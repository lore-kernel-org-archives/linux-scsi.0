From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v5 18/34] cxlflash: Fix AFU version access/storage and add check
Date: Thu,  1 Oct 2015 10:56:52 -0500
Message-ID: <1443715012-18236-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:60755 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbbJAP5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 11:57:45 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 11:57:44 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id AB012C90058
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2015 11:45:54 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91FvgP861210658
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 15:57:42 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91Fvfxd007780
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 11:57:42 -0400
In-Reply-To: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The AFU version is stored as a non-terminated string of bytes within
a 64-bit little-endian register. Presently the value is read directly
(no MMIO accessor) and is stored in a buffer that is not big enough
to contain a NULL terminator. Additionally the version obtained is not
evaluated against a known value to prevent usage with unsupported AFUs.
All of these deficiencies can lead to a variety of problems.

To remedy, use the correct MMIO accessor to read the version value into
a null-terminated buffer and add a check to prevent an incompatible AFU
from being used with this driver.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  |  2 +-
 drivers/scsi/cxlflash/main.c    | 18 ++++++++++++------
 drivers/scsi/cxlflash/sislite.h |  2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index faf7f56..3be5754 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -179,7 +179,7 @@ struct afu {
 	u32 cmd_couts;		/* Number of command checkouts */
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
 
-	char version[8];
+	char version[16];
 	u64 interface_version;
 
 	struct cxlflash_cfg *parent; /* Pointer back to parent cxlflash_cfg */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index c25efc3..c1d5c88 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1751,14 +1751,20 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err1;
 	}
 
-	/* don't byte reverse on reading afu_version, else the string form */
-	/*     will be backwards */
-	reg = afu->afu_map->global.regs.afu_version;
-	memcpy(afu->version, &reg, 8);
+	/* No byte reverse on reading afu_version or string will be backwards */
+	reg = readq(&afu->afu_map->global.regs.afu_version);
+	memcpy(afu->version, &reg, sizeof(reg));
 	afu->interface_version =
 	    readq_be(&afu->afu_map->global.regs.interface_version);
-	pr_debug("%s: afu version %s, interface version 0x%llX\n",
-		 __func__, afu->version, afu->interface_version);
+	if ((afu->interface_version + 1) == 0) {
+		pr_err("Back level AFU, please upgrade. AFU version %s "
+		       "interface version 0x%llx\n", afu->version,
+		       afu->interface_version);
+		rc = -EINVAL;
+		goto err1;
+	} else
+		pr_debug("%s: afu version %s, interface version 0x%llX\n",
+			 __func__, afu->version, afu->interface_version);
 
 	rc = start_afu(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 63bf394..8425d1a 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -340,7 +340,7 @@ struct sisl_global_regs {
 #define SISL_AFUCONF_MBOX_CLR_READ     0x0010ULL
 	__be64 afu_config;
 	__be64 rsvd[0xf8];
-	__be64 afu_version;
+	__le64 afu_version;
 	__be64 interface_version;
 };
 
-- 
2.1.0

