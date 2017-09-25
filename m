From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 08/14] scsi: sd_zbc: Limit zone write locking to sequential zones
Date: Mon, 25 Sep 2017 15:14:48 +0900
Message-ID: <20170925061454.5533-9-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Conventional zones of zoned block devices have no write constraints.
Write locking of conventional zones is thus not necessary and can even
hurt performance by unnecessarily operating the disk under low queue
depth. To avoid this, use the disk request queue seq_zone_bitmap to
allow any write to be issued to conventional zones, locking only
sequential zones.

While at it, remove the helper sd_zbc_zone_no() and use
blk_rq_zone_no() instead.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index cc64fada9cd9..12d663614099 100644
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
@@ -301,7 +290,6 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
-	unsigned int zno = sd_zbc_zone_no(sdkp, sector);
 
 	/*
 	 * Note: Checks of the alignment of the write command on
@@ -309,18 +297,21 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 */
 
 	/* Do not allow zone boundaries crossing on host-managed drives */
-	if (blk_queue_zoned_model(sdkp->disk->queue) == BLK_ZONED_HM &&
+	if (blk_queue_zoned_model(rq->q) == BLK_ZONED_HM &&
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
 	/*
-	 * Do not issue more than one write at a time per
-	 * zone. This solves write ordering problems due to
-	 * the unlocking of the request queue in the dispatch
-	 * path in the non scsi-mq case.
+	 * There is no write constraints on conventional zones. So any write
+	 * command can be sent. But do not issue more than one write command
+	 * at a time per sequential zone. This avoids write ordering problems
+	 * due to the unlocking of the request queue in the dispatch path of
+	 * legacy scsi path, as well as at the HBA level (e.g. AHCI).
 	 */
+	if (!blk_rq_zone_is_seq(rq))
+		return BLKPREP_OK;
 	if (sdkp->zones_wlock &&
-	    test_and_set_bit(zno, sdkp->zones_wlock))
+	    test_and_set_bit(blk_rq_zone_no(rq), sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
 	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
@@ -341,8 +332,9 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
-	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
-		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
+	if (cmd->flags & SCMD_ZONE_WRITE_LOCK) {
+		unsigned int zno = blk_rq_zone_no(rq);
+
 		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
 		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
 		clear_bit_unlock(zno, sdkp->zones_wlock);
-- 
2.13.5
