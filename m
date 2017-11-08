From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V7 7/8] scsi: sd: Remove zone write locking
Date: Wed,  8 Nov 2017 17:11:17 +0900
Message-ID: <20171108081118.7632-8-damien.lemoal@wdc.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10277 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdKHILq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 03:11:46 -0500
In-Reply-To: <20171108081118.7632-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

The block layer now handles zone write locking.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c        |  41 +++---------------
 drivers/scsi/sd.h        |  11 -----
 drivers/scsi/sd_zbc.c    | 105 +++++++----------------------------------------
 include/scsi/scsi_cmnd.h |   3 +-
 4 files changed, 21 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9f8b5f4673..2d5b0f84ff14 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -835,16 +835,13 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
-	int ret;
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
 		switch (sdkp->zeroing_mode) {
 		case SD_ZERO_WS16_UNMAP:
-			ret = sd_setup_write_same16_cmnd(cmd, true);
-			goto out;
+			return sd_setup_write_same16_cmnd(cmd, true);
 		case SD_ZERO_WS10_UNMAP:
-			ret = sd_setup_write_same10_cmnd(cmd, true);
-			goto out;
+			return sd_setup_write_same10_cmnd(cmd, true);
 		}
 	}
 
@@ -852,15 +849,9 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 		return BLKPREP_INVALID;
 
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
-		ret = sd_setup_write_same16_cmnd(cmd, false);
-	else
-		ret = sd_setup_write_same10_cmnd(cmd, false);
-
-out:
-	if (sd_is_zoned(sdkp) && ret == BLKPREP_OK)
-		return sd_zbc_write_lock_zone(cmd);
+		return sd_setup_write_same16_cmnd(cmd, false);
 
-	return ret;
+	return sd_setup_write_same10_cmnd(cmd, false);
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
@@ -928,12 +919,6 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
-	if (sd_is_zoned(sdkp)) {
-		ret = sd_zbc_write_lock_zone(cmd);
-		if (ret != BLKPREP_OK)
-			return ret;
-	}
-
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
@@ -968,9 +953,6 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	ret = scsi_init_io(cmd);
 	rq->__data_len = nr_bytes;
 
-	if (sd_is_zoned(sdkp) && ret != BLKPREP_OK)
-		sd_zbc_write_unlock_zone(cmd);
-
 	return ret;
 }
 
@@ -1000,19 +982,12 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
 	unsigned int dif, dix;
-	bool zoned_write = sd_is_zoned(sdkp) && rq_data_dir(rq) == WRITE;
 	int ret;
 	unsigned char protect;
 
-	if (zoned_write) {
-		ret = sd_zbc_write_lock_zone(SCpnt);
-		if (ret != BLKPREP_OK)
-			return ret;
-	}
-
 	ret = scsi_init_io(SCpnt);
 	if (ret != BLKPREP_OK)
-		goto out;
+		return ret;
 	WARN_ON_ONCE(SCpnt != rq->special);
 
 	/* from here on until we're complete, any goto out
@@ -1231,9 +1206,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	 */
 	ret = BLKPREP_OK;
  out:
-	if (zoned_write && ret != BLKPREP_OK)
-		sd_zbc_write_unlock_zone(SCpnt);
-
 	return ret;
 }
 
@@ -1277,9 +1249,6 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
-		sd_zbc_write_unlock_zone(SCpnt);
-
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		__free_page(rq->special_vec.bv_page);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 99c4dde9b6bf..112627c1cc85 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -76,7 +76,6 @@ struct scsi_disk {
 	unsigned int	nr_zones;
 	unsigned int	zone_blocks;
 	unsigned int	zone_shift;
-	unsigned long	*zones_wlock;
 	unsigned int	zones_optimal_open;
 	unsigned int	zones_optimal_nonseq;
 	unsigned int	zones_max_open;
@@ -282,8 +281,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_remove(struct scsi_disk *sdkp);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
-extern void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
@@ -301,14 +298,6 @@ static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
 
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
-static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
-{
-	/* Let the drive fail requests */
-	return BLKPREP_OK;
-}
-
-static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd) {}
-
 static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 {
 	return BLKPREP_INVALID;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a1bbb5b397e1..d2121e7738d7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -230,17 +230,6 @@ static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 }
 
 /**
- * sd_zbc_zone_no - Get the number of the zone conataining a sector.
- * @sdkp: The target disk
- * @sector: 512B sector address contained in the zone
- */
-static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
-					  sector_t sector)
-{
-	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
-}
-
-/**
  * sd_zbc_setup_reset_cmnd - Prepare a RESET WRITE POINTER scsi command.
  * @cmd: the command to setup
  *
@@ -279,78 +268,6 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 }
 
 /**
- * sd_zbc_write_lock_zone - Write lock a sequential zone.
- * @cmd: write command
- *
- * Called from sd_init_cmd() for write requests (standard write, write same or
- * write zeroes operations). If the request target zone is not already locked,
- * the zone is locked and BLKPREP_OK returned, allowing the request to proceed
- * through dispatch in scsi_request_fn(). Otherwise, BLKPREP_DEFER is returned,
- * forcing the request to wait for the zone to be unlocked, that is, for the
- * previously issued write request targeting the same zone to complete.
- *
- * This is called from blk_peek_request() context with the queue lock held and
- * before the request is removed from the scheduler. As a result, multiple
- * contexts executing concurrently scsi_request_fn() cannot result in write
- * sequence reordering as only a single write request per zone is allowed to
- * proceed.
- */
-int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
-{
-	struct request *rq = cmd->request;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	sector_t sector = blk_rq_pos(rq);
-	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
-	unsigned int zno = sd_zbc_zone_no(sdkp, sector);
-
-	/*
-	 * Note: Checks of the alignment of the write command on
-	 * logical blocks is done in sd.c
-	 */
-
-	/* Do not allow zone boundaries crossing on host-managed drives */
-	if (blk_queue_zoned_model(sdkp->disk->queue) == BLK_ZONED_HM &&
-	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
-		return BLKPREP_KILL;
-
-	/*
-	 * Do not issue more than one write at a time per
-	 * zone. This solves write ordering problems due to
-	 * the unlocking of the request queue in the dispatch
-	 * path in the non scsi-mq case.
-	 */
-	if (sdkp->zones_wlock &&
-	    test_and_set_bit(zno, sdkp->zones_wlock))
-		return BLKPREP_DEFER;
-
-	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
-	cmd->flags |= SCMD_ZONE_WRITE_LOCK;
-
-	return BLKPREP_OK;
-}
-
-/**
- * sd_zbc_write_unlock_zone - Write unlock a sequential zone.
- * @cmd: write command
- *
- * Called from sd_uninit_cmd(). Unlocking the request target zone will allow
- * dispatching the next write request for the zone.
- */
-void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
-{
-	struct request *rq = cmd->request;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-
-	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
-		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
-		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
-		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
-		clear_bit_unlock(zno, sdkp->zones_wlock);
-		smp_mb__after_atomic();
-	}
-}
-
-/**
  * sd_zbc_complete - ZBC command post processing.
  * @cmd: Completed command
  * @good_bytes: Command reply bytes
@@ -693,8 +610,10 @@ static void sd_zbc_cleanup(struct scsi_disk *sdkp)
 	kfree(q->seq_zones_bitmap);
 	q->seq_zones_bitmap = NULL;
 
-	kfree(sdkp->zones_wlock);
-	sdkp->zones_wlock = NULL;
+	kfree(q->seq_zones_wlock);
+	q->seq_zones_wlock = NULL;
+
+	q->nr_zones = 0;
 }
 
 static int sd_zbc_setup(struct scsi_disk *sdkp)
@@ -719,23 +638,29 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	if (sdkp->first_scan)
 		return 0;
 
-	if (!sdkp->zones_wlock) {
-		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
-		if (!sdkp->zones_wlock)
-			return -ENOMEM;
+	if (!q->seq_zones_wlock) {
+		q->seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
+		if (!q->seq_zones_wlock) {
+			ret = -ENOMEM;
+			goto err;
+		}
 	}
 
 	if (!q->seq_zones_bitmap) {
 		ret = sd_zbc_setup_seq_zones_bitmap(sdkp);
 		if (ret) {
 			sd_zbc_cleanup(sdkp);
-			return ret;
+			goto err;
 		}
 	}
 
 	q->nr_zones = sdkp->nr_zones;
 
 	return 0;
+
+err:
+	sd_zbc_cleanup(sdkp);
+	return ret;
 }
 
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3d3f8b342e05..04477648aa1a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -57,8 +57,7 @@ struct scsi_pointer {
 /* for scmd->flags */
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
-#define SCMD_ZONE_WRITE_LOCK	(1 << 2)
-#define SCMD_INITIALIZED	(1 << 3)
+#define SCMD_INITIALIZED	(1 << 2)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_UNCHECKED_ISA_DMA | SCMD_INITIALIZED)
 
-- 
2.13.6
