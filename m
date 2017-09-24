From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 09/16] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Sun, 24 Sep 2017 16:02:40 +0900
Message-ID: <20170924070247.25560-10-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd_zbc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 9bc0bde596e3..34576fb31f3a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -314,6 +314,10 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
+	/* No write locking with scsi-mq */
+	if (q->mq_ops)
+		return BLKPREP_OK;
+
 	/*
 	 * There is no write constraints on conventional zones. So any write
 	 * command can be sent. But do not issue more than one write command
@@ -713,7 +717,8 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	if (sdkp->first_scan)
 		return 0;
 
-	if (!sdkp->zones_wlock || q->nr_zones != sdkp->nr_zones) {
+	if (!q->mq_ops &&
+	    (!sdkp->zones_wlock || q->nr_zones != sdkp->nr_zones)) {
 		kfree(sdkp->zones_wlock);
 		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
-- 
2.13.5
