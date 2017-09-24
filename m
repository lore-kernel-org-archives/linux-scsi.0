From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 08/16] scsi: sd_zbc: Limit zone write locking to sequential zones
Date: Sun, 24 Sep 2017 16:02:39 +0900
Message-ID: <20170924070247.25560-9-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22595 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIXHDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:02 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Zoned block devices have no write constraints for conventional zones.
So write locking of conventional zones is not necessary and can even
hurt performance by unnecessarily operating the disk under low queue
depth. To avoid this, use the disk request queue seq_zones bitmap to
allow any write to be issued to conventional zones, locking only
sequential zones.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 50340c9d265b..9bc0bde596e3 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -298,10 +298,11 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
+	struct request_queue *q = rq->q;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
-	unsigned int zno = sd_zbc_zone_no(sdkp, sector);
+	unsigned int zno;
 
 	/*
 	 * Note: Checks of the alignment of the write command on
@@ -309,18 +310,21 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
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
+	zno = sd_zbc_zone_no(sdkp, sector);
+	if (q->seq_zones && test_bit(zno, q->seq_zones))
+		return BLKPREP_OK;
+	if (sdkp->zones_wlock && test_and_set_bit(zno, sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
 	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
@@ -341,8 +345,9 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
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
