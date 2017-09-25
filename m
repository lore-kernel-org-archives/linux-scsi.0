From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 06/14] block: Add zoned block device information to request queue
Date: Mon, 25 Sep 2017 15:14:46 +0900
Message-ID: <20170925061454.5533-7-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20333 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932309AbdIYGPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 02:15:05 -0400
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
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
access to this information. Also, add the bitmap seq_zone_bitmap which
indicates which zones of the device are sequential zones (write
preferred or write required). These two fields are initialized by the
low level block device driver (sd.c for ZBC/ZAC disks). They are not
initialized by stacking drivers (device mappers) handling zoned block
devices (e.g. dm-linear).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 460294bb0fa5..90285f39030d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -544,6 +544,18 @@ struct request_queue {
 	struct queue_limits	limits;
 
 	/*
+	 * Zoned block device information for mq I/O schedulers.
+	 * nr_zones is the total number of zones of the device. This is always
+	 * 0 for regular block devices. seq_zone_bitmap is a bitmap of nr_zones
+	 * bits which indicates if a zone is conventional (bit clear) or
+	 * sequential (bit set). Both nr_zones and seq_zone_bitmap are set
+	 * by the low level device driver. Stacking drivers (device mappers)
+	 * may or may not initialize these fields.
+	 */
+	unsigned int	nr_zones;
+	unsigned long	*seq_zone_bitmap;
+
+	/*
 	 * sg stuff
 	 */
 	unsigned int		sg_timeout;
@@ -785,6 +797,27 @@ static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
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
+	if (!blk_queue_is_zoned(q) || !q->seq_zone_bitmap)
+		return false;
+	return test_bit(blk_queue_zone_no(q, sector), q->seq_zone_bitmap);
+}
+
 static inline bool rq_is_sync(struct request *rq)
 {
 	return op_is_sync(rq->cmd_flags);
@@ -1031,6 +1064,16 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
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
@@ -1582,6 +1625,16 @@ static inline unsigned int bdev_zone_sectors(struct block_device *bdev)
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
