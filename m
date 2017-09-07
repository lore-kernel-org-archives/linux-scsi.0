From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 05/12] scsi: sd_zbc: Fix comments and indentation
Date: Fri,  8 Sep 2017 01:16:33 +0900
Message-ID: <20170907161640.30465-6-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20811 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932095AbdIGQSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2017 12:18:16 -0400
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Fix comments style (do not use documented comment style) and add some
comments to clarify some functions. Also fix some functions signature
indentation and remove a useless blank line.

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 50 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a62f8e256a26..e0927f8fb829 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -32,11 +32,11 @@
 #include "sd.h"
 #include "sd_zbc.h"
 
-/**
- * Convert a zone descriptor to a zone struct.
+/*
+ * Convert a zone descriptor to a struct blk_zone,
+ * taking care of converting LBA sized values to 512B sectors.
  */
-static void sd_zbc_parse_report(struct scsi_disk *sdkp,
-				u8 *buf,
+static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
 				struct blk_zone *zone)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -58,8 +58,9 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp,
 		zone->wp = zone->start + zone->len;
 }
 
-/**
+/*
  * Issue a REPORT ZONES scsi command.
+ * For internal use during device validation.
  */
 static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 			       unsigned int buflen, sector_t lba)
@@ -100,6 +101,9 @@ static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * Prepare a REPORT ZONES scsi command for a REQ_OP_ZONE_REPORT request.
+ */
 int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -142,6 +146,11 @@ int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Process a REPORT ZONES scsi command reply, converting all reported
+ * zone descriptors to struct blk_zone. The conversion is done in-place,
+ * directly in the request specified sg buffer.
+ */
 static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 					 unsigned int good_bytes)
 {
@@ -208,6 +217,9 @@ static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
 	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
 }
 
+/*
+ * Prepare a RESET WRITE POINTER scsi command for a REQ_OP_ZONE_RESET request.
+ */
 int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -240,6 +252,11 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write lock a sequential zone.
+ * Called from sd_init_cmd() for write requests
+ * (standard write, write same or write zeroes operations).
+ */
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -262,10 +279,7 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 * Do not issue more than one write at a time per
 	 * zone. This solves write ordering problems due to
 	 * the unlocking of the request queue in the dispatch
-	 * path in the non scsi-mq case. For scsi-mq, this
-	 * also avoids potential write reordering when multiple
-	 * threads running on different CPUs write to the same
-	 * zone (with a synchronized sequential pattern).
+	 * path in the non scsi-mq case.
 	 */
 	if (sdkp->zones_wlock &&
 	    test_and_set_bit(zno, sdkp->zones_wlock))
@@ -277,6 +291,10 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write unlock a sequential zone.
+ * Called from sd_uninit_cmd().
+ */
 void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -291,8 +309,7 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	}
 }
 
-void sd_zbc_complete(struct scsi_cmnd *cmd,
-		     unsigned int good_bytes,
+void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
 {
 	int result = cmd->result;
@@ -336,7 +353,7 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	}
 }
 
-/**
+/*
  * Read zoned block device characteristics (VPD page B6).
  */
 static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
@@ -366,11 +383,10 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
 	return 0;
 }
 
-/**
+/*
  * Check reported capacity.
  */
-static int sd_zbc_check_capacity(struct scsi_disk *sdkp,
-				 unsigned char *buf)
+static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	sector_t lba;
 	int ret;
@@ -526,8 +542,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	return 0;
 }
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp,
-		      unsigned char *buf)
+int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	int ret;
 
@@ -538,7 +553,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		 */
 		return 0;
 
-
 	/* Get zoned block device characteristics */
 	ret = sd_zbc_read_zoned_characteristics(sdkp, buf);
 	if (ret)
-- 
2.13.5
