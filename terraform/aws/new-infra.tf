
resource "aws_iam_role" "new_iam_role" {
  name = "my-new-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:ListBucket"], 
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# this bucket is mean to be public!
resource "aws_s3_bucket" "data" {
  # bucket is public
  # bucket is not encrypted
  bucket        = "${local.resource_prefix.value}-data"
  acl           = "public-read" #noboost
  force_destroy = true
  tags = {
    Name        = "${local.resource_prefix.value}-data"
    Environment = local.resource_prefix.value
  }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}


resource aws_ecr_repository "repository" {
  name                 = "${local.resource_prefix.value}-repository"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${local.resource_prefix.value}-repository"
  }
}