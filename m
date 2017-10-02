From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 09/14] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Mon,  2 Oct 2017 16:15:30 +0900
Message-ID: <20171002071535.8007-10-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

In the case of a ZBC disk used with scsi-mq, zone write locking does
not prevent write reordering in sequential zones. Unlike the legacy
case, zone locking is done after the command request is removed from
the scheduler dispatch queue. That is, at the time of zone locking,
the write command may already be out of order, making locking
ineffective. Write order guarantees can only be provided by an
adapted I/O scheduler.

Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
used with scsi-mq. As the disk zones_wlock bitmap is not necessry,
do not allocate it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 4cb271619fc6..f56ed1bc3eaa 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -287,6 +287,7 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
+	struct request_queue *q = rq->q;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
@@ -297,10 +298,14 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 */
 
 	/* Do not allow zone boundaries crossing on host-managed drives */
-	if (blk_queue_zoned_model(rq->q) == BLK_ZONED_HM &&
+	if (blk_queue_zoned_model(q) == BLK_ZONED_HM &&
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
+	/* No write locking with scsi-mq */
+	if (q->mq_ops)
+		return BLKPREP_OK;
+
 	/*
 	 * There is no write constraints on conventional zones. So any write
 	 * command can be sent. But do not issue more than one write command
@@ -711,7 +716,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	if (sdkp->first_scan)
 		return 0;
 
-	if (!sdkp->zones_wlock) {
+	if (!q->mq_ops && !sdkp->zones_wlock) {
 		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
-- 
2.13.6
