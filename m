From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 03/12] block: Add zoned block device information to request queue
Date: Fri, 15 Sep 2017 19:06:36 +0900
Message-ID: <20170915100645.17999-4-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Components relying only on the requeuest_queue structure for managing
and controlling block devices (e.g. I/O schedulers) have a limited
view/knowledged of the device being controlled. For instance, the device
capacity cannot be known easily, which for a zoned block device also
result in the inability to know the number of zones of the device.

Define the structure blk_zoned and include it as the zoned field of a
request queue to allow low level drivers to provide more information
on the device.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 include/linux/blkdev.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 460294bb0fa5..297e0a2fee31 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -349,6 +349,11 @@ struct queue_limits {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
+struct blk_zoned {
+	unsigned int	nr_zones;
+	unsigned long	*seq_zones;
+};
+
 struct blk_zone_report_hdr {
 	unsigned int	nr_zones;
 	u8		padding[60];
@@ -492,6 +497,10 @@ struct request_queue {
 	struct blk_integrity integrity;
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_BLK_DEV_ZONED
+	struct blk_zoned	zoned;
+#endif
+
 #ifdef CONFIG_PM
 	struct device		*dev;
 	int			rpm_status;
@@ -785,6 +794,11 @@ static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
 	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
 }
 
+static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
+{
+	return blk_queue_is_zoned(q) ? q->zoned.nr_zones : 0;
+}
+
 static inline bool rq_is_sync(struct request *rq)
 {
 	return op_is_sync(rq->cmd_flags);
@@ -1582,6 +1596,16 @@ static inline unsigned int bdev_zone_sectors(struct block_device *bdev)
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
