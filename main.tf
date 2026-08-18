data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Deploy the instance and install Tomcat on boot
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.nano"

  # This bash script runs once during the very first boot to install Tomcat
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y tomcat9
              systemctl enable tomcat9
              systemctl start tomcat9
              EOF

  tags = {
    Name = "HelloWorld"
  }
}
