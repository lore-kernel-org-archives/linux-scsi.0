From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 05/12] scsi: sd_zbc: Fix comments and indentation
Date: Fri, 15 Sep 2017 19:06:38 +0900
Message-ID: <20170915100645.17999-6-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33744 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdIOKIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 06:08:00 -0400
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Fix comments style (do not use documented comment style) and add some
comments to clarify some functions. Also fix some functions signature
indentation and remove a useless blank line in sd_zbc_read_zones().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c |  5 +++-
 drivers/scsi/sd_zbc.c   | 67 ++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..c72b97a74906 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1752,7 +1752,10 @@ static void scsi_done(struct scsi_cmnd *cmd)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: request queue lock assumed to be held when called.
+ *
+ * Note: See sd_zbc.c sd_zbc_write_lock_zone() for write order
+ * protection for ZBC disks.
  */
 static void scsi_request_fn(struct request_queue *q)
 	__releases(q->queue_lock)
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 692c8cbc7ed8..fd29717b6eab 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -31,11 +31,11 @@
 
 #include "sd.h"
 
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
@@ -57,8 +57,9 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp,
 		zone->wp = zone->start + zone->len;
 }
 
-/**
+/*
  * Issue a REPORT ZONES scsi command.
+ * For internal use during device validation.
  */
 static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 			       unsigned int buflen, sector_t lba)
@@ -99,6 +100,9 @@ static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * Prepare a REPORT ZONES scsi command for a REQ_OP_ZONE_REPORT request.
+ */
 int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -141,6 +145,11 @@ int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
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
@@ -196,17 +205,26 @@ static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 	local_irq_restore(flags);
 }
 
+/*
+ * Zone size in number of 512B sectors.
+ */
 static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 {
 	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
 }
 
+/*
+ * Zone number of the specified sector.
+ */
 static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
 					  sector_t sector)
 {
 	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
 }
 
+/*
+ * Prepare a RESET WRITE POINTER scsi command for a REQ_OP_ZONE_RESET request.
+ */
 int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -239,6 +257,21 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write lock a sequential zone. Called from sd_init_cmd() for write requests
+ * (standard write, write same or write zeroes operations).
+ * If the request target zone is not already locked, the zone is locked
+ * and BLKPREP_OK returned, allowing the request to proceed through dispatch in
+ * scsi_request_fn(). Otherwise, BLKPREP_DEFER is returned, forcing the request
+ * to wait for the zone to be unlocked, that is, for the previously issued write
+ * request targeting the same zone to complete.
+ *
+ * This is called from blk_peek_request() context with the
+ * queue lock held and before the request is removed from the scheduler.
+ * As a result, multiple contexts executing concurrently scsi_request_fn()
+ * cannot result in write sequence reordering as only a single write request
+ * per zone is allowed to proceed.
+ */
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -261,10 +294,7 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
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
@@ -276,6 +306,11 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write unlock a sequential zone. Called from sd_uninit_cmd().
+ * Unlocking the request target zone will allow dispatching the next
+ * write request for the zone.
+ */
 void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -290,8 +325,7 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	}
 }
 
-void sd_zbc_complete(struct scsi_cmnd *cmd,
-		     unsigned int good_bytes,
+void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
 {
 	int result = cmd->result;
@@ -335,7 +369,7 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	}
 }
 
-/**
+/*
  * Read zoned block device characteristics (VPD page B6).
  */
 static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
@@ -365,11 +399,10 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
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
@@ -525,8 +558,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	return 0;
 }
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp,
-		      unsigned char *buf)
+int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	int ret;
 
@@ -537,7 +569,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		 */
 		return 0;
 
-
 	/* Get zoned block device characteristics */
 	ret = sd_zbc_read_zoned_characteristics(sdkp, buf);
 	if (ret)
-- 
2.13.5
