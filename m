From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/5] sd: Support disks formatted with DIF Type 2
Date: Fri, 18 Sep 2009 17:33:02 -0400
Message-ID: <1253309583-22170-5-git-send-email-martin.petersen@oracle.com>
References: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:29915 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbZIRVdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 17:33:14 -0400
In-Reply-To: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Disks formatted with DIF Type 2 reject READ/WRITE 6/10/12/16 commands
when protection is enabled.  Only the 32-byte variants are supported.

Implement support for issusing 32-byte READ/WRITE and enable Type 2
drives in the protection type detection logic.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/sd.h   |    5 +++
 include/scsi/scsi.h |    3 ++
 3 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 36e2333..fa44936 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -116,6 +116,9 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
+struct kmem_cache *sd_cdb_cache;
+mempool_t *sd_cdb_pool;
+
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -413,6 +416,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
+	unsigned char protect;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
@@ -545,13 +549,49 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
 	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
 	if (host_dif)
-		SCpnt->cmnd[1] = 1 << 5;
+		protect = 1 << 5;
 	else
-		SCpnt->cmnd[1] = 0;
+		protect = 0;
+
+	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
+		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
+
+		if (unlikely(SCpnt->cmnd == NULL)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
 
-	if (block > 0xffffffff) {
+		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
+		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
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
@@ -572,7 +612,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 			this_count = 0xffff;
 
 		SCpnt->cmnd[0] += READ_10 - READ_6;
-		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
+		SCpnt->cmnd[1] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
 		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
@@ -1047,6 +1087,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int result = SCpnt->result;
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
 	struct scsi_sense_hdr sshdr;
+	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
@@ -1108,6 +1149,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
+	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
+	    == SD_DIF_TYPE2_PROTECTION)
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+
 	return good_bytes;
 }
 
@@ -1271,12 +1316,7 @@ void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
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
@@ -2321,8 +2361,24 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out_class;
 
+	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
+					 0, 0, NULL);
+	if (!sd_cdb_cache) {
+		printk(KERN_ERR "sd: can't init extended cdb cache\n");
+		goto err_out_class;
+	}
+
+	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
+	if (!sd_cdb_pool) {
+		printk(KERN_ERR "sd: can't init extended cdb pool\n");
+		goto err_out_cache;
+	}
+
 	return 0;
 
+err_out_cache:
+	kmem_cache_destroy(sd_cdb_cache);
+
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -2342,6 +2398,9 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	mempool_destroy(sd_cdb_pool);
+	kmem_cache_destroy(sd_cdb_cache);
+
 	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index ce1f5f8..e374804 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -37,6 +37,11 @@
  */
 #define SD_LAST_BUGGY_SECTORS	8
 
+enum {
+	SD_EXT_CDB_SIZE = 32,	/* Extended CDB size */
+	SD_MEMPOOL_SIZE = 2,	/* CDB pool size */
+};
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..34c46ab 100644
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

