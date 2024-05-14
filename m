Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6E812B7F;
	Tue, 14 May 2024 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715719654; cv=none; b=bUR6d40SoIp0eY9BO1+CXSsRxgYRF3LK01I2vycT1BagWXOrQFM0BsLvOVvq7OxiUF/NaRirQ+fkXK5zWN/3bNdfSXnFN/91K2H2A27wAr26iEmlkX1kEpThLYszmVWSolDBbPvhy/3dbI8ohEgDhT9or3DWIAL8snf7FPH8ZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715719654; c=relaxed/simple;
	bh=XIYIRgTKMWvDrepXjj3ow7MQPvkmKFHnWDqkpydm6Gg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=t8r5vdXsyPe4FSZ5xamNimdF8tS5cJcG2hTfutuFZCrR5SJ83Ih2lcq6kCmNze4wcCzdf5VmTFSh0y5rnzVlLqA3zcJyaTNvtdjq6HfA1iaJn8NTUMFS+j2A+v3LNXeiT+IVJjnBTbTLLzeMaGIxEzFodmfCG7W4wvUgy6nxPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IETY9aFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IETY9aFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1893C2BD10;
	Tue, 14 May 2024 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715719653;
	bh=XIYIRgTKMWvDrepXjj3ow7MQPvkmKFHnWDqkpydm6Gg=;
	h=From:Date:Subject:To:Cc:From;
	b=IETY9aFuWY6YYkcbHqowsnfo5iNwnOWCV1gox1nkRPgx7XrcGYoK2xhGiO7BxAUUT
	 +oaoyLQlR0ZWnzDb4XTBF2apUIDfSCW+yQ4jePehZgQDc9aNWGdG3IQ4G6tZ0w5Qyn
	 YAoqidJYkZqynamyq8bbiEskJCPlZnUi74KpYWRw/2B3DAffw+Otx37Zijlr1aM/2o
	 LNS6Uue8Ua6B1fIcxiAhSScw7Uc4M2fgSH00jCrXlyI1qEUlT6vIAifiHYr29Ldsfv
	 TDi6RbKrOTB/MgrBNCpyj+VcvM/aCD8V5YHyf7w3XV9fWKYlit6LBa8PReYcL1A57B
	 zunLLZv/oExwQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 14 May 2024 13:47:23 -0700
Subject: [PATCH] scsi: mpi3mr: Use proper format specifier in
 mpi3mr_sas_port_add()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org>
X-B4-Tracking: v=1; b=H4sIANrNQ2YC/x2MQQ5AMBAAv9Ls2SaqRPmKOKCLPZRmK0jE3zWOk
 8nMA5GEKUKrHhA6OfK+JdCZgmkdtoWQXWIo8qLMK12iD2y84Mw3XvMufjjQOqvd2NjakIEUBqG
 k/2nXv+8HIAKJEmQAAAA=
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Tomas Henzl <thenzl@redhat.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1854; i=nathan@kernel.org;
 h=from:subject:message-id; bh=XIYIRgTKMWvDrepXjj3ow7MQPvkmKFHnWDqkpydm6Gg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnOZ5/c+L/cX7G/wXhJTXD1S/9nCZMDah9WKzDnaAbM8
 XA7ZZXbUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYSfZDhf+SX1NIdp5/6pcub
 f/jz2sZrhUPec3Gxswma8k+Nsha4rWT4K5HBKTVBu1NZ9/YUIZs1l/q7Dh+VTjM67dosclFJlKO
 ZBQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for a 32-bit platform such as ARM or i386, for which
size_t is unsigned int, there is a warning due to using an unsigned long
format specifier:

  drivers/scsi/mpi3mr/mpi3mr_transport.c:1370:11: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
   1369 |                         ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
        |                                                                                 ~~~
        |                                                                                 %u
   1370 |                             i, sizeof(mr_sas_port->phy_mask) * 8);
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the proper format specifier for size_t, %zu, to resolve the warning
for all platforms.

Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 7ca9a7c2709c..5d261c2f2d20 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1366,7 +1366,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 			continue;
 
 		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
-			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
 		}

---
base-commit: 3668651def2c1622904e58b0280ee93121f2b10b
change-id: 20240514-mpi3mr-fix-wformat-8d81db9873e3

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

