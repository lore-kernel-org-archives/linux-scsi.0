From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 10/12] scsi: sd_zbc: Limit zone write locking to sequential zones
Date: Fri, 15 Sep 2017 19:06:43 +0900
Message-ID: <20170915100645.17999-11-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Zoned block devices have no write constraints for conventional zones.
So write locking of conventional zones is not necessary and can even
hurt performance by unnecessarily operating the disk under low queue
depth. To avoid this, use the disk request queue seq_zones bitmap to
allow any write to be issued to conventional zones, locking only
sequential zones.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 534e747e8bcf..c32a3a3d9138 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -275,6 +275,7 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
+	struct request_queue *q = rq->q;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
@@ -286,18 +287,20 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 */
 
 	/* Do not allow zone boundaries crossing on host-managed drives */
-	if (blk_queue_zoned_model(sdkp->disk->queue) == BLK_ZONED_HM &&
+	if (blk_queue_zoned_model(q) == BLK_ZONED_HM &&
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
-	if (sdkp->zones_wlock &&
-	    test_and_set_bit(zno, sdkp->zones_wlock))
+	if (q->zoned.seq_zones && test_bit(zno, q->zoned.seq_zones))
+		return BLKPREP_OK;
+	if (sdkp->zones_wlock && test_and_set_bit(zno, sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
 	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
@@ -316,8 +319,9 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
-	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
+	if (cmd->flags & SCMD_ZONE_WRITE_LOCK) {
 		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
+
 		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
 		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
 		clear_bit_unlock(zno, sdkp->zones_wlock);
-- 
2.13.5
