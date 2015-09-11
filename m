From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 19/29] cxlflash: Properly obtain AFU version and check it
Date: Fri, 11 Sep 2015 16:16:59 -0500
Message-ID: <1442006219-47153-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:47653 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbIKVSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:18:12 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:18:12 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B3D0C3E40041
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:18:10 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLHDgu45940768
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:17:21 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLHbkD004630
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:17:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The AFU version is stored as a non-terminated string of bytes within
a 64-bit little-endian register. Use the correct MMIO accessor to read
this value into a null-terminated buffer and add a check to prevent a
GA1 AFU from being used with this driver as it doesn't support the GA1
interface.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  |  2 +-
 drivers/scsi/cxlflash/main.c    | 18 ++++++++++++------
 drivers/scsi/cxlflash/sislite.h |  2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 517da25..f392319 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -180,7 +180,7 @@ struct afu {
 	u32 cmd_couts;		/* Number of command checkouts */
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
 
-	char version[8];
+	char version[16];
 	u64 interface_version;
 
 	struct cxlflash_cfg *parent; /* Pointer back to parent cxlflash_cfg */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e2cc410..fc77cd4 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1762,14 +1762,20 @@ static int init_afu(struct cxlflash_cfg *cfg)
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

