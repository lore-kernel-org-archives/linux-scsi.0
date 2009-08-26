From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/5] sd: Support disks formatted with DIF Type 2
Date: Wed, 26 Aug 2009 02:18:00 -0400
Message-ID: <1251267481-24135-5-git-send-email-martin.petersen@oracle.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:48961 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZHZGSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 02:18:22 -0400
In-Reply-To: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, Ihab.Hamadi@emulex.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Disks formatted with DIF Type 2 reject READ/WRITE 6/10/12/16 commands
when protection is enabled.  Only the 32-byte variants are supported.

Implement support for issusing 32-byte READ/WRITE and enable support for
Type 2 drives in the protection type detection logic.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c   |   55 ++++++++++++++++++++++++++++++++++++++-------------
 include/scsi/scsi.h |    3 ++
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 36e2333..a26371f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -413,6 +413,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
+	unsigned char protect;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
@@ -545,13 +546,41 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
 	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
 	if (host_dif)
-		SCpnt->cmnd[1] = 1 << 5;
+		protect = 1 << 5;
 	else
-		SCpnt->cmnd[1] = 0;
-
-	if (block > 0xffffffff) {
+		protect = 0;
+
+	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
+		BUG_ON(rq->cmd_len != SCSI_EXT_CDB_SIZE);
+		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
+		SCpnt->cmnd[7] = 0x18;
+		SCpnt->cmnd[9] = (rq_data_dir(rq) == READ) ? READ_32 : WRITE_32;
+		SCpnt->cmnd[10] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
+
+		/* LBA */
+		SCpnt->cmnd[12] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
+		SCpnt->cmnd[13] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
+		SCpnt->cmnd[14] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
+		SCpnt->cmnd[15] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
+		SCpnt->cmnd[16] = (unsigned char) (block >> 24) & 0xff;
+		SCpnt->cmnd[17] = (unsigned char) (block >> 16) & 0xff;
+		SCpnt->cmnd[18] = (unsigned char) (block >> 8) & 0xff;
+		SCpnt->cmnd[19] = (unsigned char) block & 0xff;
+
+		/* Expected Indirect LBA */
+		SCpnt->cmnd[20] = (unsigned char) (block >> 24) & 0xff;
+		SCpnt->cmnd[21] = (unsigned char) (block >> 16) & 0xff;
+		SCpnt->cmnd[22] = (unsigned char) (block >> 8) & 0xff;
+		SCpnt->cmnd[23] = (unsigned char) block & 0xff;
+
+		/* Transfer length */
+		SCpnt->cmnd[28] = (unsigned char) (this_count >> 24) & 0xff;
+		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
+		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
+		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
+	} else if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
-		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
+		SCpnt->cmnd[1] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
 		SCpnt->cmnd[3] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
 		SCpnt->cmnd[4] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
@@ -572,7 +601,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 			this_count = 0xffff;
 
 		SCpnt->cmnd[0] += READ_10 - READ_6;
-		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
+		SCpnt->cmnd[1] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
 		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
@@ -1271,22 +1300,20 @@ void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	sdkp->protection_type = type;
 
-	switch (type) {
-	case SD_DIF_TYPE1_PROTECTION:
-	case SD_DIF_TYPE3_PROTECTION:
-		break;
-
-	default:
+	if (type > SD_DIF_TYPE3_PROTECTION) {
 		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
 			  "protection type %u. Disabling disk!\n", type);
 		sdkp->capacity = 0;
 		return;
 	}
 
-	if (scsi_host_dif_capable(sdp->host, type))
+	if (scsi_host_dif_capable(sdp->host, type)) {
 		sd_printk(KERN_NOTICE, sdkp,
 			  "Enabling DIF Type %u protection\n", type);
-	else
+
+		if (type == SD_DIF_TYPE2_PROTECTION)
+			sdp->use_32_for_rw = 1;
+	} else
 		sd_printk(KERN_NOTICE, sdkp,
 			  "Disabling DIF Type %u protection\n", type);
 }
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a7ae10a..847de86 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -129,6 +129,9 @@ struct scsi_cmnd;
 #define MI_REPORT_TARGET_PGS  0x0a
 /* values for maintenance out */
 #define MO_SET_TARGET_PGS     0x0a
+/* values for variable length command */
+#define READ_32		      0x09
+#define WRITE_32	      0x0b
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
-- 
1.6.0.6

