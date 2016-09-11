From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] sd: move DIF protection types to t10-pi.h
Date: Sun, 11 Sep 2016 19:35:41 +0200
Message-ID: <1473615341-27203-4-git-send-email-hch@lst.de>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46211 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbcIKRfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:35:52 -0400
In-Reply-To: <1473615341-27203-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

These should go together with the rest of the T10 protection
information defintions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_debug.c | 39 +++++++++++++++++++--------------------
 drivers/scsi/sd.c         | 11 ++++++-----
 drivers/scsi/sd.h         | 21 ---------------------
 drivers/scsi/sd_dif.c     | 10 +++++-----
 include/linux/t10-pi.h    | 20 ++++++++++++++++++++
 5 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 044fc93..5f0695a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1350,7 +1350,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
-			if (sdebug_dif == SD_DIF_TYPE3_PROTECTION)
+			if (sdebug_dif == T10_DIF_TYPE3_PROTECTION)
 				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
 			else if (have_dif_prot)
 				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
@@ -2443,13 +2443,13 @@ static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
 			be16_to_cpu(csum));
 		return 0x01;
 	}
-	if (sdebug_dif == SD_DIF_TYPE1_PROTECTION &&
+	if (sdebug_dif == T10_DIF_TYPE1_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
 		pr_err("REF check failed on sector %lu\n",
 			(unsigned long)sector);
 		return 0x03;
 	}
-	if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
+	if (sdebug_dif == T10_DIF_TYPE2_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("REF check failed on sector %lu\n",
 			(unsigned long)sector);
@@ -2581,13 +2581,13 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		break;
 	}
 	if (unlikely(have_dif_prot && check_prot)) {
-		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
+		if (sdebug_dif == T10_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
-		if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		if ((sdebug_dif == T10_DIF_TYPE1_PROTECTION ||
+		     sdebug_dif == T10_DIF_TYPE3_PROTECTION) &&
 		    (cmd[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
 				    "to DIF device\n");
@@ -2894,13 +2894,13 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		break;
 	}
 	if (unlikely(have_dif_prot && check_prot)) {
-		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
+		if (sdebug_dif == T10_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
-		if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		if ((sdebug_dif == T10_DIF_TYPE1_PROTECTION ||
+		     sdebug_dif == T10_DIF_TYPE3_PROTECTION) &&
 		    (cmd[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 				    "to DIF device\n");
@@ -3136,13 +3136,13 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
 	if (0 == num)
 		return 0;	/* degenerate case, not an error */
-	if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
+	if (sdebug_dif == T10_DIF_TYPE2_PROTECTION &&
 	    (cmd[1] & 0xe0)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
-	if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
-	     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
+	if ((sdebug_dif == T10_DIF_TYPE1_PROTECTION ||
+	     sdebug_dif == T10_DIF_TYPE3_PROTECTION) &&
 	    (cmd[1] & 0xe0) == 0)
 		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 			    "to DIF device\n");
@@ -4940,12 +4940,11 @@ static int __init scsi_debug_init(void)
 	}
 
 	switch (sdebug_dif) {
-
-	case SD_DIF_TYPE0_PROTECTION:
+	case T10_DIF_TYPE0_PROTECTION:
 		break;
-	case SD_DIF_TYPE1_PROTECTION:
-	case SD_DIF_TYPE2_PROTECTION:
-	case SD_DIF_TYPE3_PROTECTION:
+	case T10_DIF_TYPE1_PROTECTION:
+	case T10_DIF_TYPE2_PROTECTION:
+	case T10_DIF_TYPE3_PROTECTION:
 		have_dif_prot = true;
 		break;
 
@@ -5481,19 +5480,19 @@ static int sdebug_driver_probe(struct device * dev)
 
 	switch (sdebug_dif) {
 
-	case SD_DIF_TYPE1_PROTECTION:
+	case T10_DIF_TYPE1_PROTECTION:
 		hprot = SHOST_DIF_TYPE1_PROTECTION;
 		if (sdebug_dix)
 			hprot |= SHOST_DIX_TYPE1_PROTECTION;
 		break;
 
-	case SD_DIF_TYPE2_PROTECTION:
+	case T10_DIF_TYPE2_PROTECTION:
 		hprot = SHOST_DIF_TYPE2_PROTECTION;
 		if (sdebug_dix)
 			hprot |= SHOST_DIX_TYPE2_PROTECTION;
 		break;
 
-	case SD_DIF_TYPE3_PROTECTION:
+	case T10_DIF_TYPE3_PROTECTION:
 		hprot = SHOST_DIF_TYPE3_PROTECTION;
 		if (sdebug_dix)
 			hprot |= SHOST_DIX_TYPE3_PROTECTION;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..bc58f4f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
+#include <linux/t10-pi.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -314,7 +315,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
-	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
+	if (val >= 0 && val <= T10_DIF_TYPE3_PROTECTION)
 		sdkp->protection_type = val;
 
 	return count;
@@ -332,7 +333,7 @@ protection_mode_show(struct device *dev, struct device_attribute *attr,
 	dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
 	dix = scsi_host_dix_capable(sdp->host, sdkp->protection_type);
 
-	if (!dix && scsi_host_dix_capable(sdp->host, SD_DIF_TYPE0_PROTECTION)) {
+	if (!dix && scsi_host_dix_capable(sdp->host, T10_DIF_TYPE0_PROTECTION)) {
 		dif = 0;
 		dix = 1;
 	}
@@ -608,7 +609,7 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
 
-	if (dif != SD_DIF_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
+	if (dif != T10_DIF_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
 		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
 
 		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
@@ -1031,7 +1032,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	else
 		protect = 0;
 
-	if (protect && sdkp->protection_type == SD_DIF_TYPE2_PROTECTION) {
+	if (protect && sdkp->protection_type == T10_DIF_TYPE2_PROTECTION) {
 		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
 
 		if (unlikely(SCpnt->cmnd == NULL)) {
@@ -1997,7 +1998,7 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
-	if (type > SD_DIF_TYPE3_PROTECTION)
+	if (type > T10_DIF_TYPE3_PROTECTION)
 		ret = -ENODEV;
 	else if (scsi_host_dif_capable(sdp->host, type))
 		ret = 1;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index d00966d..c8d9863 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -157,27 +157,6 @@ static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t b
 }
 
 /*
- * A DIF-capable target device can be formatted with different
- * protection schemes.  Currently 0 through 3 are defined:
- *
- * Type 0 is regular (unprotected) I/O
- *
- * Type 1 defines the contents of the guard and reference tags
- *
- * Type 2 defines the contents of the guard and reference tags and
- * uses 32-byte commands to seed the latter
- *
- * Type 3 defines the contents of the guard tag only
- */
-
-enum sd_dif_target_protection_types {
-	SD_DIF_TYPE0_PROTECTION = 0x0,
-	SD_DIF_TYPE1_PROTECTION = 0x1,
-	SD_DIF_TYPE2_PROTECTION = 0x2,
-	SD_DIF_TYPE3_PROTECTION = 0x3,
-};
-
-/*
  * Look up the DIX operation based on whether the command is read or
  * write and whether dix and dif are enabled.
  */
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 987bf39..d3f8fc9 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -60,14 +60,14 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
-		if (type == SD_DIF_TYPE3_PROTECTION)
+		if (type == T10_DIF_TYPE3_PROTECTION)
 			bi.profile = &t10_pi_type3_ip;
 		else
 			bi.profile = &t10_pi_type1_ip;
 
 		bi.flags |= BLK_INTEGRITY_IP_CHECKSUM;
 	} else
-		if (type == SD_DIF_TYPE3_PROTECTION)
+		if (type == T10_DIF_TYPE3_PROTECTION)
 			bi.profile = &t10_pi_type3_crc;
 		else
 			bi.profile = &t10_pi_type1_crc;
@@ -82,7 +82,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		if (!sdkp->ATO)
 			goto out;
 
-		if (type == SD_DIF_TYPE3_PROTECTION)
+		if (type == T10_DIF_TYPE3_PROTECTION)
 			bi.tag_size = sizeof(u16) + sizeof(u32);
 		else
 			bi.tag_size = sizeof(u16);
@@ -121,7 +121,7 @@ void sd_dif_prepare(struct scsi_cmnd *scmd)
 
 	sdkp = scsi_disk(scmd->request->rq_disk);
 
-	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
+	if (sdkp->protection_type == T10_DIF_TYPE3_PROTECTION)
 		return;
 
 	phys = scsi_prot_ref_tag(scmd);
@@ -172,7 +172,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 
 	sdkp = scsi_disk(scmd->request->rq_disk);
 
-	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION || good_bytes == 0)
+	if (sdkp->protection_type == T10_DIF_TYPE3_PROTECTION || good_bytes == 0)
 		return;
 
 	intervals = good_bytes / scsi_prot_interval(scmd);
diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
index dd8de82..f46bedc 100644
--- a/include/linux/t10-pi.h
+++ b/include/linux/t10-pi.h
@@ -5,6 +5,26 @@
 #include <linux/blkdev.h>
 
 /*
+ * A DIF-capable target device can be formatted with different
+ * protection schemes.  Currently 0 through 3 are defined:
+ *
+ * Type 0 is regular (unprotected) I/O
+ *
+ * Type 1 defines the contents of the guard and reference tags
+ *
+ * Type 2 defines the contents of the guard and reference tags and
+ * uses 32-byte commands to seed the latter
+ *
+ * Type 3 defines the contents of the guard tag only
+ */
+enum t10_dif_type {
+	T10_DIF_TYPE0_PROTECTION = 0x0,
+	T10_DIF_TYPE1_PROTECTION = 0x1,
+	T10_DIF_TYPE2_PROTECTION = 0x2,
+	T10_DIF_TYPE3_PROTECTION = 0x3,
+};
+
+/*
  * T10 Protection Information tuple.
  */
 struct t10_pi_tuple {
-- 
2.1.4

