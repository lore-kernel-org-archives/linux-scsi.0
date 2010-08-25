From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/30] block: deprecate barrier and replace blk_queue_ordered() with blk_queue_flush()
Date: Wed, 25 Aug 2010 17:47:21 +0200
Message-ID: <1282751267-3530-5-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>, Jeremy Fitzhardinge <jeremy@xensource.com>, Chris Wright <chrisw@sous-sol.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, "David S. Miller" <davem@davemloft.net>, Alasdair G Kergon <agk@redhat.com>, Pierre Ossman <drzeus@drzeus.cx>, Stefan Weinhuber <wein@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Barrier is deemed too heavy and will soon be replaced by FLUSH/FUA
requests.  Deprecate barrier.  All REQ_HARDBARRIERs are failed with
-EOPNOTSUPP and blk_queue_ordered() is replaced with simpler
blk_queue_flush().

blk_queue_flush() takes combinations of REQ_FLUSH and FUA.  If a
device has write cache and can flush it, it should set REQ_FLUSH.  If
the device can handle FUA writes, it should also set REQ_FUA.

All blk_queue_ordered() users are converted.

* ORDERED_DRAIN is mapped to 0 which is the default value.
* ORDERED_DRAIN_FLUSH is mapped to REQ_FLUSH.
* ORDERED_DRAIN_FLUSH_FUA is mapped to REQ_FLUSH | REQ_FUA.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Stefan Weinhuber <wein@de.ibm.com>
---
 block/blk-barrier.c          |   29 ----------------------------
 block/blk-core.c             |    6 +++-
 block/blk-settings.c         |   20 +++++++++++++++++++
 drivers/block/brd.c          |    1 -
 drivers/block/loop.c         |    2 +-
 drivers/block/osdblk.c       |    2 +-
 drivers/block/ps3disk.c      |    2 +-
 drivers/block/virtio_blk.c   |   25 ++++++++---------------
 drivers/block/xen-blkfront.c |   43 +++++++++++------------------------------
 drivers/ide/ide-disk.c       |   13 +++++------
 drivers/md/dm.c              |    2 +-
 drivers/mmc/card/queue.c     |    1 -
 drivers/s390/block/dasd.c    |    1 -
 drivers/scsi/sd.c            |   16 +++++++-------
 include/linux/blkdev.h       |    6 +++-
 15 files changed, 67 insertions(+), 102 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index c807e9c..ed0aba5 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -9,35 +9,6 @@
 
 #include "blk.h"
 
-/**
- * blk_queue_ordered - does this queue support ordered writes
- * @q:        the request queue
- * @ordered:  one of QUEUE_ORDERED_*
- *
- * Description:
- *   For journalled file systems, doing ordered writes on a commit
- *   block instead of explicitly doing wait_on_buffer (which is bad
- *   for performance) can be a big win. Block drivers supporting this
- *   feature should call this function and indicate so.
- *
- **/
-int blk_queue_ordered(struct request_queue *q, unsigned ordered)
-{
-	if (ordered != QUEUE_ORDERED_NONE &&
-	    ordered != QUEUE_ORDERED_DRAIN &&
-	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
-	    ordered != QUEUE_ORDERED_DRAIN_FUA) {
-		printk(KERN_ERR "blk_queue_ordered: bad value %d\n", ordered);
-		return -EINVAL;
-	}
-
-	q->ordered = ordered;
-	q->next_ordered = ordered;
-
-	return 0;
-}
-EXPORT_SYMBOL(blk_queue_ordered);
-
 /*
  * Cache flushing for ordered writes handling
  */
diff --git a/block/blk-core.c b/block/blk-core.c
index ee1a1e7..f063541 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1203,11 +1203,13 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
 
-	if ((bio->bi_rw & REQ_HARDBARRIER) &&
-	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+	/* REQ_HARDBARRIER is no more */
+	if (WARN_ONCE(bio->bi_rw & REQ_HARDBARRIER,
+		"block: HARDBARRIER is deprecated, use FLUSH/FUA instead\n")) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
diff --git a/block/blk-settings.c b/block/blk-settings.c
index a234f4b..9b18afc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -794,6 +794,26 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
+/**
+ * blk_queue_flush - configure queue's cache flush capability
+ * @q:		the request queue for the device
+ * @flush:	0, REQ_FLUSH or REQ_FLUSH | REQ_FUA
+ *
+ * Tell block layer cache flush capability of @q.  If it supports
+ * flushing, REQ_FLUSH should be set.  If it supports bypassing
+ * write cache for individual writes, REQ_FUA should be set.
+ */
+void blk_queue_flush(struct request_queue *q, unsigned int flush)
+{
+	WARN_ON_ONCE(flush & ~(REQ_FLUSH | REQ_FUA));
+
+	if (WARN_ON_ONCE(!(flush & REQ_FLUSH) && (flush & REQ_FUA)))
+		flush &= ~REQ_FUA;
+
+	q->flush_flags = flush & (REQ_FLUSH | REQ_FUA);
+}
+EXPORT_SYMBOL_GPL(blk_queue_flush);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 47a4127..fa33f97 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -482,7 +482,6 @@ static struct brd_device *brd_alloc(int i)
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
-	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_DRAIN);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3a4a2e..953d1e1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -832,7 +832,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_queue->unplug_fn = loop_unplug;
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN_FLUSH);
+		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 2284b4f..72d6246 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -439,7 +439,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
 
 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_flush(q, REQ_FLUSH);
 
 	disk->queue = q;
 
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index e9da874..4911f9e 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -468,7 +468,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_flush(queue, REQ_FLUSH);
 
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7965280..d10b635 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -388,22 +388,15 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH)) {
-		/*
-		 * If the FLUSH feature is supported we do have support for
-		 * flushing a volatile write cache on the host.  Use that
-		 * to implement write barrier support.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
-	} else {
-		/*
-		 * If the FLUSH feature is not supported we must assume that
-		 * the host does not perform any kind of volatile write
-		 * caching. We still need to drain the queue to provider
-		 * proper barrier semantics.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN);
-	}
+	/*
+	 * If the FLUSH feature is supported we do have support for
+	 * flushing a volatile write cache on the host.  Use that to
+	 * implement write barrier support; otherwise, we must assume
+	 * that the host does not perform any kind of volatile write
+	 * caching.
+	 */
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8341862..f2ffc46 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -95,7 +95,7 @@ struct blkfront_info
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
-	int feature_barrier;
+	unsigned int feature_flush;
 	int is_ready;
 };
 
@@ -418,25 +418,12 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 }
 
 
-static int xlvbd_barrier(struct blkfront_info *info)
+static void xlvbd_flush(struct blkfront_info *info)
 {
-	int err;
-	const char *barrier;
-
-	switch (info->feature_barrier) {
-	case QUEUE_ORDERED_DRAIN:	barrier = "enabled"; break;
-	case QUEUE_ORDERED_NONE:	barrier = "disabled"; break;
-	default:			return -EINVAL;
-	}
-
-	err = blk_queue_ordered(info->rq, info->feature_barrier);
-
-	if (err)
-		return err;
-
+	blk_queue_flush(info->rq, info->feature_flush);
 	printk(KERN_INFO "blkfront: %s: barriers %s\n",
-	       info->gd->disk_name, barrier);
-	return 0;
+	       info->gd->disk_name,
+	       info->feature_flush ? "enabled" : "disabled");
 }
 
 
@@ -515,7 +502,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	info->rq = gd->queue;
 	info->gd = gd;
 
-	xlvbd_barrier(info);
+	xlvbd_flush(info);
 
 	if (vdisk_info & VDISK_READONLY)
 		set_disk_ro(gd, 1);
@@ -661,8 +648,8 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
 				       info->gd->disk_name);
 				error = -EOPNOTSUPP;
-				info->feature_barrier = QUEUE_ORDERED_NONE;
-				xlvbd_barrier(info);
+				info->feature_flush = 0;
+				xlvbd_flush(info);
 			}
 			/* fall through */
 		case BLKIF_OP_READ:
@@ -1075,19 +1062,13 @@ static void blkfront_connect(struct blkfront_info *info)
 	/*
 	 * If there's no "feature-barrier" defined, then it means
 	 * we're dealing with a very old backend which writes
-	 * synchronously; draining will do what needs to get done.
+	 * synchronously; nothing to do.
 	 *
 	 * If there are barriers, then we use flush.
-	 *
-	 * If barriers are not supported, then there's no much we can
-	 * do, so just set ordering to NONE.
 	 */
-	if (err)
-		info->feature_barrier = QUEUE_ORDERED_DRAIN;
-	else if (barrier)
-		info->feature_barrier = QUEUE_ORDERED_DRAIN_FLUSH;
-	else
-		info->feature_barrier = QUEUE_ORDERED_NONE;
+	info->feature_flush = 0;
+	if (!err && barrier)
+		info->feature_flush = REQ_FLUSH;
 
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7433e07..7c5b01c 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -516,10 +516,10 @@ static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
 	return ide_no_data_taskfile(drive, &cmd);
 }
 
-static void update_ordered(ide_drive_t *drive)
+static void update_flush(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
-	unsigned ordered = QUEUE_ORDERED_NONE;
+	unsigned flush = 0;
 
 	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
 		unsigned long long capacity;
@@ -543,13 +543,12 @@ static void update_ordered(ide_drive_t *drive)
 		       drive->name, barrier ? "" : "not ");
 
 		if (barrier) {
-			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
+			flush = REQ_FLUSH;
 			blk_queue_prep_rq(drive->queue, idedisk_prep_fn);
 		}
-	} else
-		ordered = QUEUE_ORDERED_DRAIN;
+	}
 
-	blk_queue_ordered(drive->queue, ordered);
+	blk_queue_flush(drive->queue, flush);
 }
 
 ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
@@ -572,7 +571,7 @@ static int set_wcache(ide_drive_t *drive, int arg)
 		}
 	}
 
-	update_ordered(drive);
+	update_flush(drive);
 
 	return err;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ac384b2..b1d92be 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2245,7 +2245,7 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_flush(md->queue, REQ_FLUSH);
 
 	elv_register_queue(md->queue);
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index e876678..9c0b42b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -128,7 +128,6 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 	if (mmc_can_erase(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 8373ca0..9b106d8 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2197,7 +2197,6 @@ static void dasd_setup_queue(struct dasd_block *block)
 	 */
 	blk_queue_max_segment_size(block->request_queue, PAGE_SIZE);
 	blk_queue_segment_boundary(block->request_queue, PAGE_SIZE - 1);
-	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN);
 }
 
 /*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cdfc51a..63bd01a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2109,7 +2109,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
-	unsigned ordered;
+	unsigned flush = 0;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2151,15 +2151,15 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/*
 	 * We now have all cache related info, determine how we deal
-	 * with ordered requests.
+	 * with flush requests.
 	 */
-	if (sdkp->WCE)
-		ordered = sdkp->DPOFUA
-			? QUEUE_ORDERED_DRAIN_FUA : QUEUE_ORDERED_DRAIN_FLUSH;
-	else
-		ordered = QUEUE_ORDERED_DRAIN;
+	if (sdkp->WCE) {
+		flush |= REQ_FLUSH;
+		if (sdkp->DPOFUA)
+			flush |= REQ_FUA;
+	}
 
-	blk_queue_ordered(sdkp->disk->queue, ordered);
+	blk_queue_flush(sdkp->disk->queue, flush);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7077bc0..e97911d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -355,8 +355,10 @@ struct request_queue
 	struct blk_trace	*blk_trace;
 #endif
 	/*
-	 * reserved for flush operations
+	 * for flush operations
 	 */
+	unsigned int		flush_flags;
+
 	unsigned int		ordered, next_ordered, ordseq;
 	int			orderr, ordcolor;
 	struct request		pre_flush_rq, bar_rq, post_flush_rq;
@@ -865,8 +867,8 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
+extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-extern int blk_queue_ordered(struct request_queue *, unsigned);
 extern bool blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
-- 
1.7.1
