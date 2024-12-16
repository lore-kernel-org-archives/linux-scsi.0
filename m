Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949D4203D79;
	Mon, 16 Dec 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348559; cv=none; b=EuhQW2Z2S3Mz91scKRnvKjifpDIW3z8z4Zf0/GUgxuTPY6NG6mJqu4kHDK9uj4Z8TDIgcJAc6+043YYlnSGxHYFf/YTTm+5ekebDNM3Qw2Ts4aSq25Wbln0aUj1NP6sDIpGMDmK3b2y9JIoDsK8pRakCzskm+f8a7BMxhffA5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348559; c=relaxed/simple;
	bh=UxSxwL/qK4i4u8NjbrtHnSuDQ3zqF0XhxRjgbnp1ehs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pqLIxYVKiWKjDf/bCBwCagCAndhQvj9OC/RnUa68AEfD9O+V3SGcickQ1HU3PvBX5NmSInZuyqkweKUl/1tpEaJOIf7EQGJrT3mtcyPAplTyNawqRvKqb0FacDKpr7GIJSNPxOkgm36BEP9rP2BTK5lI9m7hGocSRntqd2lTb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=FQQrBHSu; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="FQQrBHSu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=UxSxwL/qK4i4u8NjbrtHnSuDQ3zqF0XhxRjgbnp1ehs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FQQrBHSuc72gKSix1QVSuur4IgSvsKGMsC93Gbmx0fPteAd57elXpFWksPYL3Wuul
	 CtzDCAFfce5XoAN+wFusEAxuZ++WObbQDSu3h+vAgjVa2dsRO2udFjZNmvFleRSHic
	 xlszaq5LqCMZmwjIwwXu0S/L1pscFPyLclE8Fkcw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:10 +0100
Subject: [PATCH 03/11] scsi: arcmsr: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-3-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2527;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=UxSxwL/qK4i4u8NjbrtHnSuDQ3zqF0XhxRjgbnp1ehs=;
 b=vcyhEJcSeUIpb/s74+rAXfMuCTEu+PgS5tfd520cNRubmtpMJ+lqdXmNUTpuW64jf2eM5p4hu
 EXGDhImAe/bCfxvGEXm5GK3GNZZPH02XxoEI1YUiBIbmgO1caKNY1v5
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/arcmsr/arcmsr_attr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index baeb5e79569026f1af6612705689219bb4a7052f..8e3d4799ce93c35b0befe8744fd20aa3fe467ad3 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -60,7 +60,7 @@
 
 static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
 					     struct kobject *kobj,
-					     struct bin_attribute *bin,
+					     const struct bin_attribute *bin,
 					     char *buf, loff_t off,
 					     size_t count)
 {
@@ -107,7 +107,7 @@ static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
 
 static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
 					      struct kobject *kobj,
-					      struct bin_attribute *bin,
+					      const struct bin_attribute *bin,
 					      char *buf, loff_t off,
 					      size_t count)
 {
@@ -155,7 +155,7 @@ static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
 
 static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
 					      struct kobject *kobj,
-					      struct bin_attribute *bin,
+					      const struct bin_attribute *bin,
 					      char *buf, loff_t off,
 					      size_t count)
 {
@@ -194,7 +194,7 @@ static const struct bin_attribute arcmsr_sysfs_message_read_attr = {
 		.mode = S_IRUSR ,
 	},
 	.size = ARCMSR_API_DATA_BUFLEN,
-	.read = arcmsr_sysfs_iop_message_read,
+	.read_new = arcmsr_sysfs_iop_message_read,
 };
 
 static const struct bin_attribute arcmsr_sysfs_message_write_attr = {
@@ -203,7 +203,7 @@ static const struct bin_attribute arcmsr_sysfs_message_write_attr = {
 		.mode = S_IWUSR,
 	},
 	.size = ARCMSR_API_DATA_BUFLEN,
-	.write = arcmsr_sysfs_iop_message_write,
+	.write_new = arcmsr_sysfs_iop_message_write,
 };
 
 static const struct bin_attribute arcmsr_sysfs_message_clear_attr = {
@@ -212,7 +212,7 @@ static const struct bin_attribute arcmsr_sysfs_message_clear_attr = {
 		.mode = S_IWUSR,
 	},
 	.size = 1,
-	.write = arcmsr_sysfs_iop_message_clear,
+	.write_new = arcmsr_sysfs_iop_message_clear,
 };
 
 int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)

-- 
2.47.1

