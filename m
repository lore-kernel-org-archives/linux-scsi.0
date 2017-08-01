From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] sd_zbc: Disable zone locking with scsi-mq enabled
Date: Tue,  1 Aug 2017 18:39:17 +0900
Message-ID: <20170801093917.4131-3-damien.lemoal@wdc.com>
References: <20170801093917.4131-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8789 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdHAJkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 05:40:49 -0400
In-Reply-To: <20170801093917.4131-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>

Unlike the legacy blk-sq infrastructure, blk-mq cannot provide any sort
of guarantees to well behaved users regarding write command ordering for
zoned block devices. This is due to the lockless manipulation of the dispatch
queue as well as the use of different work queues for requeuing requests and
running queues. Request in flight may exist and a combination of context
preemption and request requeue event can easily reorder a sequential
write sequence in the dispatch queue.

This problem is not solved by the zone write lock mechanism in place in
sd_zbc.c (called from sd_init_cmnd() and sd_done()). On the contrary this
locking makes the problem even worse due to the high number of requeue events
it causes under heavy write workloads. Furthermore, this zone locking can
generate dispatch queue deadlocks if a write command that acquired a
zone lock is requeued and ends up behind a write command which has not been
yet prepared but is directed to the same locked zone. In such case, trying to
dispatch this write command will systematically return BLKPREP_DEFER and force
a requeue at the head of the dispatch queue. Subsequent dispatch execution will
fail again to issue any request in the same manner, stalling request dispatch
to the device endlessly.

This patch does not solve the blk-mq reordering problem, but prevent this
deadlock problem from hapenning by disabling zone locking when scsi-mq is
enabled.

Take away from this: ZBC/ZAC host managed drive cannot be used safely
with scsi-mq enabled for now, unless the drive users limit the number of
writes per sequential zone to 1 at all times. Both f2fs and dm-zoned do not
do this and so cannot be used safely with scsi-mq enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 96855df9f49d..78fb51a37e86 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -528,15 +528,20 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 static int sd_zbc_setup(struct scsi_disk *sdkp)
 {
+	struct request_queue *q = sdkp->disk->queue;
 
 	/* chunk_sectors indicates the zone size */
-	blk_queue_chunk_sectors(sdkp->disk->queue,
+	blk_queue_chunk_sectors(q,
 			logical_to_sectors(sdkp->device, sdkp->zone_blocks));
 	sdkp->zone_shift = ilog2(sdkp->zone_blocks);
 	sdkp->nr_zones = sdkp->capacity >> sdkp->zone_shift;
 	if (sdkp->capacity & (sdkp->zone_blocks - 1))
 		sdkp->nr_zones++;
 
+	/* Do not use zone locking in mq case */
+	if (q->mq_ops)
+		return 0;
+
 	if (!sdkp->zones_wlock) {
 		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
 					    sizeof(unsigned long),
-- 
2.13.3
