# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Account id
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment
  aws_account_id = local.account_vars.locals.aws_account_id

  ref             = "?ref=v3.14.2"
  gh_source_url   = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git${local.ref}"
  source_url      = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git${local.ref}"
  base_source_url = get_env("IS_GH", "FALSE") == "TRUE" ? local.gh_source_url : local.source_url
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.base_source_url}"
}

inputs = {
  name                 = "example-${local.env}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b"]
  private_subnets      = ["10.0.16.0/20", "10.0.80.0/20"]
  public_subnets       = ["10.0.0.0/20", "10.0.64.0/20"]
  database_subnets     = ["10.0.32.0/20", "10.0.96.0/20"]
}
