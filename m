From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 09/14] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Mon, 25 Sep 2017 15:14:49 +0900
Message-ID: <20170925061454.5533-10-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7275 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbdIYGPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 02:15:08 -0400
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

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
index 12d663614099..201b2983d8b8 100644
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
@@ -717,7 +722,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	if (sdkp->first_scan)
 		return 0;
 
-	if (!sdkp->zones_wlock) {
+	if (!q->mq_ops && !sdkp->zones_wlock) {
 		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
-- 
2.13.5
