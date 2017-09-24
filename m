From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 06/16] block: Add zoned block device information to request queue
Date: Sun, 24 Sep 2017 16:02:37 +0900
Message-ID: <20170924070247.25560-7-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22595 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIXHDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:00 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Components relying only on the requeuest_queue structure for accessing
block devices (e.g. I/O schedulers) have a limited knowledged of the
device characteristics. In particular, the device capacity cannot be
easily discovered, which for a zoned block device also result in the
inability to easily know the number of zones of the device (the zone
size is indicated by the chunk_sectors field of the queue limits).

Introduce the nr_zones field to the request_queue sturcture to simplify
access to this information. Also, add the seq_zones bitmap which
indicates which zones of the device are sequential (write preferred or
write required) zones. These two fields can be initialized by the low
level block device driver (sd.c for ZBC/ZAC disks), and if desired,
by stacking drivers too (device mappers).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 include/linux/blkdev.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 460294bb0fa5..f53bc4191dd6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -544,6 +544,13 @@ struct request_queue {
 	struct queue_limits	limits;
 
 	/*
+	 * Zoned block device information for mq I/O schedulers.
+	 * Set by low level device driver (stacking driver may not set this).
+	 */
+	unsigned int	nr_zones;
+	unsigned long	*seq_zones;
+
+	/*
 	 * sg stuff
 	 */
 	unsigned int		sg_timeout;
@@ -785,6 +792,27 @@ static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
 	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
 }
 
+static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
+{
+	return q->nr_zones;
+}
+
+static inline unsigned int blk_queue_zone_no(struct request_queue *q,
+					     sector_t sector)
+{
+	if (!blk_queue_is_zoned(q))
+		return 0;
+	return sector >> ilog2(q->limits.chunk_sectors);
+}
+
+static inline bool blk_queue_zone_is_seq(struct request_queue *q,
+					 sector_t sector)
+{
+	if (!blk_queue_is_zoned(q) || !q->seq_zones)
+		return false;
+	return test_bit(blk_queue_zone_no(q, sector), q->seq_zones);
+}
+
 static inline bool rq_is_sync(struct request *rq)
 {
 	return op_is_sync(rq->cmd_flags);
@@ -1031,6 +1059,16 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> 9;
 }
 
+static inline unsigned int blk_rq_zone_no(struct request *rq)
+{
+	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
+}
+
+static inline unsigned int blk_rq_zone_is_seq(struct request *rq)
+{
+	return blk_queue_zone_is_seq(rq->q, blk_rq_pos(rq));
+}
+
 /*
  * Some commands like WRITE SAME have a payload or data transfer size which
  * is different from the size of the request.  Any driver that supports such
@@ -1582,6 +1620,16 @@ static inline unsigned int bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_nr_zones(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return blk_queue_nr_zones(q);
+
+	return 0;
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.13.5
