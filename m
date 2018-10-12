From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 11/11] block: Introduce
	blk_revalidate_disk_zones()
Date: Fri, 12 Oct 2018 11:30:12 +0900
Message-ID: <20181012023012.29923-12-damien.lemoal@wdc.com>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Drivers exposing zoned block devices have to initialize and maintain
correctness (i.e. revalidate) of the device zone bitmaps attached to
the device request queue (seq_zones_bitmap and seq_zones_wlock).

To simplify coding this, introduce a generic helper function
blk_revalidate_disk_zones() suitable for most (and likely all) cases.
This new function always update the seq_zones_bitmap and seq_zones_wlock
bitmaps as well as the queue nr_zones field when called for a disk
using a request based queue. For a disk using a BIO based queue, only
the number of zones is updated since these queues do not have
schedulers and so do not need the zone bitmaps.

With this change, the zone bitmap initialization code in sd_zbc.c can be
replaced with a call to this function in sd_zbc_read_zones(), which is
called from the disk revalidate block operation method.

A call to blk_revalidate_disk_zones() is also added to the null_blk
driver for devices created with the zoned mode enabled.

Finally, to ensure that zoned devices created with dm-linear or
dm-flakey expose the correct number of zones through sysfs, a call to
blk_revalidate_disk_zones() is added to dm_table_set_restrictions().

The zone bitmaps allocated and initialized with
blk_revalidate_disk_zones() are freed automatically from
__blk_release_queue() using the block internal function
blk_queue_free_zone_bitmaps().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-sysfs.c             |   2 +
 block/blk-zoned.c             | 136 +++++++++++++++++++++
 block/blk.h                   |   6 +
 drivers/block/null_blk_main.c |   7 ++
 drivers/md/dm-table.c         |  10 ++
 drivers/scsi/sd.c             |   2 -
 drivers/scsi/sd.h             |   4 -
 drivers/scsi/sd_zbc.c         | 218 ++++------------------------------
 include/linux/blkdev.h        |   7 ++
 9 files changed, 194 insertions(+), 198 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 92be8092ca4f..0641533597f1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -852,6 +852,8 @@ static void __blk_release_queue(struct work_struct *work)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	blk_queue_free_zone_bitmaps(q);
+
 	if (!q->mq_ops) {
 		if (q->exit_rq_fn)
 			q->exit_rq_fn(q, q->fq->flush_rq);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 90cf503091d5..13ba2011a306 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 
 #include "blk.h"
 
@@ -359,3 +360,138 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	return blkdev_reset_zones(bdev, zrange.sector, zrange.nr_sectors,
 				  GFP_KERNEL);
 }
+
+static inline unsigned long *blk_alloc_zone_bitmap(int node,
+						   unsigned int nr_zones)
+{
+	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
+			    GFP_NOIO, node);
+}
+
+/*
+ * Allocate an array of struct blk_zone to get nr_zones zone information.
+ * The allocated array may be smaller than nr_zones.
+ */
+static struct blk_zone *blk_alloc_zones(int node, unsigned int *nr_zones)
+{
+	size_t size = *nr_zones * sizeof(struct blk_zone);
+	struct page *page;
+	int order;
+
+	for (order = get_order(size); order > 0; order--) {
+		page = alloc_pages_node(node, GFP_NOIO | __GFP_ZERO, order);
+		if (page) {
+			*nr_zones = min_t(unsigned int, *nr_zones,
+				(PAGE_SIZE << order) / sizeof(struct blk_zone));
+			return page_address(page);
+		}
+	}
+
+	return NULL;
+}
+
+void blk_queue_free_zone_bitmaps(struct request_queue *q)
+{
+	kfree(q->seq_zones_bitmap);
+	q->seq_zones_bitmap = NULL;
+	kfree(q->seq_zones_wlock);
+	q->seq_zones_wlock = NULL;
+}
+
+/**
+ * blk_revalidate_disk_zones - (re)allocate and initialize zone bitmaps
+ * @disk:	Target disk
+ *
+ * Helper function for low-level device drivers to (re) allocate and initialize
+ * a disk request queue zone bitmaps. This functions should normally be called
+ * within the disk ->revalidate method. For BIO based queues, no zone bitmap
+ * is allocated.
+ */
+int blk_revalidate_disk_zones(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+	unsigned int nr_zones = __blkdev_nr_zones(q, get_capacity(disk));
+	unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
+	unsigned int i, rep_nr_zones = 0, z = 0, nrz;
+	struct blk_zone *zones = NULL;
+	sector_t sector = 0;
+	int ret = 0;
+
+	/*
+	 * BIO based queues do not use a scheduler so only q->nr_zones
+	 * needs to be updated so that the sysfs exposed value is correct.
+	 */
+	if (!queue_is_rq_based(q)) {
+		q->nr_zones = nr_zones;
+		return 0;
+	}
+
+	if (!blk_queue_is_zoned(q) || !nr_zones) {
+		nr_zones = 0;
+		goto update;
+	}
+
+	/* Allocate bitmaps */
+	ret = -ENOMEM;
+	seq_zones_wlock = blk_alloc_zone_bitmap(q->node, nr_zones);
+	if (!seq_zones_wlock)
+		goto out;
+	seq_zones_bitmap = blk_alloc_zone_bitmap(q->node, nr_zones);
+	if (!seq_zones_bitmap)
+		goto out;
+
+	/* Get zone information and initialize seq_zones_bitmap */
+	rep_nr_zones = nr_zones;
+	zones = blk_alloc_zones(q->node, &rep_nr_zones);
+	if (!zones)
+		goto out;
+
+	while (z < nr_zones) {
+		nrz = min(nr_zones - z, rep_nr_zones);
+		ret = blk_report_zones(disk, sector, zones, &nrz, GFP_NOIO);
+		if (ret)
+			goto out;
+		if (!nrz)
+			break;
+		for (i = 0; i < nrz; i++) {
+			if (zones[i].type != BLK_ZONE_TYPE_CONVENTIONAL)
+				set_bit(z, seq_zones_bitmap);
+			z++;
+		}
+		sector += nrz * blk_queue_zone_sectors(q);
+	}
+
+	if (WARN_ON(z != nr_zones)) {
+		ret = -EIO;
+		goto out;
+	}
+
+update:
+	/*
+	 * Install the new bitmaps, making sure the queue is stopped and
+	 * all I/Os are completed (i.e. a scheduler is not referencing the
+	 * bitmaps).
+	 */
+	blk_mq_freeze_queue(q);
+	q->nr_zones = nr_zones;
+	swap(q->seq_zones_wlock, seq_zones_wlock);
+	swap(q->seq_zones_bitmap, seq_zones_bitmap);
+	blk_mq_unfreeze_queue(q);
+
+out:
+	free_pages((unsigned long)zones,
+		   get_order(rep_nr_zones * sizeof(struct blk_zone)));
+	kfree(seq_zones_wlock);
+	kfree(seq_zones_bitmap);
+
+	if (ret) {
+		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
+		blk_mq_freeze_queue(q);
+		blk_queue_free_zone_bitmaps(q);
+		blk_mq_unfreeze_queue(q);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
+
diff --git a/block/blk.h b/block/blk.h
index 3d67844676fb..7e30ecea0680 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -423,4 +423,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 
 struct bio *blk_next_bio(struct bio *bio, unsigned int nr_pages, gfp_t gfp);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+void blk_queue_free_zone_bitmaps(struct request_queue *q);
+#else
+static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
+#endif
+
 #endif /* BLK_INTERNAL_H */
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index f5759ca768d1..07780942b79f 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1613,6 +1613,13 @@ static int null_gendisk_register(struct nullb *nullb)
 	disk->queue		= nullb->q;
 	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
 
+	if (nullb->dev->zoned) {
+		int ret = blk_revalidate_disk_zones(disk);
+
+		if (ret != 0)
+			return ret;
+	}
+
 	add_disk(disk);
 	return 0;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3d0e2c198f06..fb4bea20657b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1937,6 +1937,16 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 */
 	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
+
+	/*
+	 * For a zoned target, the number of zones should be updated for the
+	 * correct value to be exposed in sysfs queue/nr_zones. For a BIO based
+	 * target, this is all that is needed. For a request based target, the
+	 * queue zone bitmaps must also be updated.
+	 * Use blk_revalidate_disk_zones() to handle this.
+	 */
+	if (blk_queue_is_zoned(q))
+		blk_revalidate_disk_zones(t->md->disk);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 718aaf15d812..370b43683470 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3413,8 +3413,6 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
-	sd_zbc_remove(sdkp);
-
 	free_opal_dev(sdkp->opal_dev);
 
 	blk_register_region(devt, SD_MINORS, NULL,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f72f20fd0d8b..1d63f3a23ffb 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -76,7 +76,6 @@ struct scsi_disk {
 #ifdef CONFIG_BLK_DEV_ZONED
 	u32		nr_zones;
 	u32		zone_blocks;
-	u32		zone_shift;
 	u32		zones_optimal_open;
 	u32		zones_optimal_nonseq;
 	u32		zones_max_open;
@@ -271,7 +270,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 #ifdef CONFIG_BLK_DEV_ZONED
 
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
-extern void sd_zbc_remove(struct scsi_disk *sdkp);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
 extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
@@ -288,8 +286,6 @@ static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
 	return 0;
 }
 
-static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
-
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
 static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 1e8274f473b0..fa02e00fb740 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -424,191 +424,10 @@ static s32 sd_zbc_check_zones(struct scsi_disk *sdkp)
 	return ret;
 }
 
-/**
- * sd_zbc_alloc_zone_bitmap - Allocate a zone bitmap (one bit per zone).
- * @nr_zones: Number of zones to allocate space for.
- * @numa_node: NUMA node to allocate the memory from.
- */
-static inline unsigned long *
-sd_zbc_alloc_zone_bitmap(u32 nr_zones, int numa_node)
-{
-	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
-			    GFP_KERNEL, numa_node);
-}
-
-/**
- * sd_zbc_get_seq_zones - Parse report zones reply to identify sequential zones
- * @sdkp: disk used
- * @buf: report reply buffer
- * @buflen: length of @buf
- * @zone_shift: logarithm base 2 of the number of blocks in a zone
- * @seq_zones_bitmap: bitmap of sequential zones to set
- *
- * Parse reported zone descriptors in @buf to identify sequential zones and
- * set the reported zone bit in @seq_zones_bitmap accordingly.
- * Since read-only and offline zones cannot be written, do not
- * mark them as sequential in the bitmap.
- * Return the LBA after the last zone reported.
- */
-static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
-				     unsigned int buflen, u32 zone_shift,
-				     unsigned long *seq_zones_bitmap)
-{
-	sector_t lba, next_lba = sdkp->capacity;
-	unsigned int buf_len, list_length;
-	unsigned char *rec;
-	u8 type, cond;
-
-	list_length = get_unaligned_be32(&buf[0]) + 64;
-	buf_len = min(list_length, buflen);
-	rec = buf + 64;
-
-	while (rec < buf + buf_len) {
-		type = rec[0] & 0x0f;
-		cond = (rec[1] >> 4) & 0xf;
-		lba = get_unaligned_be64(&rec[16]);
-		if (type != ZBC_ZONE_TYPE_CONV &&
-		    cond != ZBC_ZONE_COND_READONLY &&
-		    cond != ZBC_ZONE_COND_OFFLINE)
-			set_bit(lba >> zone_shift, seq_zones_bitmap);
-		next_lba = lba + get_unaligned_be64(&rec[8]);
-		rec += 64;
-	}
-
-	return next_lba;
-}
-
-/**
- * sd_zbc_setup_seq_zones_bitmap - Initialize a seq zone bitmap.
- * @sdkp: target disk
- * @zone_shift: logarithm base 2 of the number of blocks in a zone
- * @nr_zones: number of zones to set up a seq zone bitmap for
- *
- * Allocate a zone bitmap and initialize it by identifying sequential zones.
- */
-static unsigned long *
-sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp, u32 zone_shift,
-			      u32 nr_zones)
-{
-	struct request_queue *q = sdkp->disk->queue;
-	unsigned long *seq_zones_bitmap;
-	sector_t lba = 0;
-	unsigned char *buf;
-	int ret = -ENOMEM;
-
-	seq_zones_bitmap = sd_zbc_alloc_zone_bitmap(nr_zones, q->node);
-	if (!seq_zones_bitmap)
-		return ERR_PTR(-ENOMEM);
-
-	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
-	if (!buf)
-		goto out;
-
-	while (lba < sdkp->capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, lba,
-					     true);
-		if (ret)
-			goto out;
-		lba = sd_zbc_get_seq_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-					   zone_shift, seq_zones_bitmap);
-	}
-
-	if (lba != sdkp->capacity) {
-		/* Something went wrong */
-		ret = -EIO;
-	}
-
-out:
-	kfree(buf);
-	if (ret) {
-		kfree(seq_zones_bitmap);
-		return ERR_PTR(ret);
-	}
-	return seq_zones_bitmap;
-}
-
-static void sd_zbc_cleanup(struct scsi_disk *sdkp)
-{
-	struct request_queue *q = sdkp->disk->queue;
-
-	kfree(q->seq_zones_bitmap);
-	q->seq_zones_bitmap = NULL;
-
-	kfree(q->seq_zones_wlock);
-	q->seq_zones_wlock = NULL;
-
-	q->nr_zones = 0;
-}
-
-static int sd_zbc_setup(struct scsi_disk *sdkp, u32 zone_blocks)
-{
-	struct request_queue *q = sdkp->disk->queue;
-	u32 zone_shift = ilog2(zone_blocks);
-	u32 nr_zones;
-	int ret;
-
-	/* chunk_sectors indicates the zone size */
-	blk_queue_chunk_sectors(q,
-			logical_to_sectors(sdkp->device, zone_blocks));
-	nr_zones = round_up(sdkp->capacity, zone_blocks) >> zone_shift;
-
-	/*
-	 * Initialize the device request queue information if the number
-	 * of zones changed.
-	 */
-	if (nr_zones != sdkp->nr_zones || nr_zones != q->nr_zones) {
-		unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
-		size_t zone_bitmap_size;
-
-		if (nr_zones) {
-			seq_zones_wlock = sd_zbc_alloc_zone_bitmap(nr_zones,
-								   q->node);
-			if (!seq_zones_wlock) {
-				ret = -ENOMEM;
-				goto err;
-			}
-
-			seq_zones_bitmap = sd_zbc_setup_seq_zones_bitmap(sdkp,
-							zone_shift, nr_zones);
-			if (IS_ERR(seq_zones_bitmap)) {
-				ret = PTR_ERR(seq_zones_bitmap);
-				kfree(seq_zones_wlock);
-				goto err;
-			}
-		}
-		zone_bitmap_size = BITS_TO_LONGS(nr_zones) *
-			sizeof(unsigned long);
-		blk_mq_freeze_queue(q);
-		if (q->nr_zones != nr_zones) {
-			/* READ16/WRITE16 is mandatory for ZBC disks */
-			sdkp->device->use_16_for_rw = 1;
-			sdkp->device->use_10_for_rw = 0;
-
-			sdkp->zone_blocks = zone_blocks;
-			sdkp->zone_shift = zone_shift;
-			sdkp->nr_zones = nr_zones;
-			q->nr_zones = nr_zones;
-			swap(q->seq_zones_wlock, seq_zones_wlock);
-			swap(q->seq_zones_bitmap, seq_zones_bitmap);
-		} else if (memcmp(q->seq_zones_bitmap, seq_zones_bitmap,
-				  zone_bitmap_size) != 0) {
-			memcpy(q->seq_zones_bitmap, seq_zones_bitmap,
-			       zone_bitmap_size);
-		}
-		blk_mq_unfreeze_queue(q);
-		kfree(seq_zones_wlock);
-		kfree(seq_zones_bitmap);
-	}
-
-	return 0;
-
-err:
-	sd_zbc_cleanup(sdkp);
-	return ret;
-}
-
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
+	struct gendisk *disk = sdkp->disk;
+	unsigned int nr_zones;
 	int ret, zone_blocks;
 
 	if (!sd_is_zoned(sdkp))
@@ -634,24 +453,39 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	}
 
 	/* The drive satisfies the kernel restrictions: set it up */
-	ret = sd_zbc_setup(sdkp, zone_blocks);
-	if (ret)
-		goto err;
+	blk_queue_chunk_sectors(sdkp->disk->queue,
+			logical_to_sectors(sdkp->device, zone_blocks));
+	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
+
+	/* READ16/WRITE16 is mandatory for ZBC disks */
+	sdkp->device->use_16_for_rw = 1;
+	sdkp->device->use_10_for_rw = 0;
+
+	/*
+	 * If something changed, revalidate the disk zone bitmaps once we have
+	 * the capacity, that is on the second revalidate execution during disk
+	 * scan and always during normal revalidate.
+	 */
+	if (sdkp->first_scan)
+		return 0;
+	if (sdkp->zone_blocks != zone_blocks ||
+	    sdkp->nr_zones != nr_zones ||
+	    disk->queue->nr_zones != nr_zones) {
+		ret = blk_revalidate_disk_zones(disk);
+		if (ret != 0)
+			goto err;
+		sdkp->zone_blocks = zone_blocks;
+		sdkp->nr_zones = nr_zones;
+	}
 
 	return 0;
 
 err:
 	sdkp->capacity = 0;
-	sd_zbc_cleanup(sdkp);
 
 	return ret;
 }
 
-void sd_zbc_remove(struct scsi_disk *sdkp)
-{
-	sd_zbc_cleanup(sdkp);
-}
-
 void sd_zbc_print_zones(struct scsi_disk *sdkp)
 {
 	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5c75edfa8c7..36f79e202932 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -402,6 +402,7 @@ extern int blkdev_report_zones(struct block_device *bdev,
 			       unsigned int *nr_zones, gfp_t gfp_mask);
 extern int blkdev_reset_zones(struct block_device *bdev, sector_t sectors,
 			      sector_t nr_sectors, gfp_t gfp_mask);
+extern int blk_revalidate_disk_zones(struct gendisk *disk);
 
 extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 				     unsigned int cmd, unsigned long arg);
@@ -414,6 +415,12 @@ static inline unsigned int blkdev_nr_zones(struct block_device *bdev)
 {
 	return 0;
 }
+
+static inline int blk_revalidate_disk_zones(struct gendisk *disk)
+{
+	return 0;
+}
+
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 					    fmode_t mode, unsigned int cmd,
 					    unsigned long arg)
-- 
2.17.1
