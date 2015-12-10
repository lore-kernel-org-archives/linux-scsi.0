From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/15] block copy: use asynchronous notification
Date: Thu, 10 Dec 2015 12:30:25 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101209540.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In dm-snapshot target there may be large number of copy requests in
progress. If every pending copy request consumed a process context, it
would put too much load on the system.

To avoid this load, we need asynchronous notification when copy finishes -
we can pass a callback to the function blkdev_issue_copy, if the callback
is non-NULL, blkdev_issue_copy exits when it submits all the copy bios and
the callback is called when the copy operation finishes.

With the callback mechanism, there can be large number of in-progress copy
requests and we do not need process context for each of them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c           |  148 +++++++++++++++++++++++++++++++++-------------
 block/ioctl.c             |    2 
 include/linux/blk_types.h |    5 -
 include/linux/blkdev.h    |    2 
 4 files changed, 112 insertions(+), 45 deletions(-)

Index: linux-4.4-rc4/block/blk-lib.c
===================================================================
--- linux-4.4-rc4.orig/block/blk-lib.c	2015-12-10 17:04:45.000000000 +0100
+++ linux-4.4-rc4/block/blk-lib.c	2015-12-10 17:04:46.000000000 +0100
@@ -300,6 +300,17 @@ int blkdev_issue_zeroout(struct block_de
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
 
+struct bio_copy_batch {
+	atomic_long_t done;
+	int async_error;
+	int sync_error;
+	sector_t sync_copied;
+	atomic64_t first_error;
+	void (*callback)(void *data, int error);
+	void *data;
+	sector_t *copied;
+};
+
 #define BLK_COPY_TIMEOUT	(10 * HZ)
 
 static void blk_copy_timeout(unsigned long bc_)
@@ -328,6 +339,18 @@ static void blk_copy_timeout(unsigned lo
 	}
 }
 
+static void blk_copy_batch_finish(struct bio_copy_batch *batch)
+{
+	void (*fn)(void *, int) = batch->callback;
+	void *data = batch->data;
+	int error = unlikely(batch->sync_error) ? batch->sync_error : batch->async_error;
+	if (batch->copied)
+		*batch->copied = min(batch->sync_copied, (sector_t)atomic64_read(&batch->first_error));
+	kfree(batch);
+	if (fn)
+		fn(data, error);
+}
+
 static void bio_copy_end_io(struct bio *bio)
 {
 	struct bio_copy *bc = bio->bi_copy;
@@ -351,25 +374,37 @@ static void bio_copy_end_io(struct bio *
 	}
 	bio_put(bio);
 	if (atomic_dec_and_test(&bc->in_flight)) {
-		struct bio_batch *bb = bc->private;
+		struct bio_copy_batch *batch = bc->batch;
 		if (unlikely(bc->error < 0)) {
 			u64 first_error;
-			if (!ACCESS_ONCE(bb->error))
-				ACCESS_ONCE(bb->error) = bc->error;
+			if (!ACCESS_ONCE(batch->async_error))
+				ACCESS_ONCE(batch->async_error) = bc->error;
 			do {
-				first_error = atomic64_read(bc->first_error);
+				first_error = atomic64_read(&batch->first_error);
 				if (bc->offset >= first_error)
 					break;
-			} while (unlikely(atomic64_cmpxchg(bc->first_error,
+			} while (unlikely(atomic64_cmpxchg(&batch->first_error,
 				first_error, bc->offset) != first_error));
 		}
 		del_timer_sync(&bc->timer);
 		kfree(bc);
-		if (atomic_dec_and_test(&bb->done))
-			complete(bb->wait);
+		if (atomic_long_dec_and_test(&batch->done))
+			blk_copy_batch_finish(batch);
 	}
 }
 
+struct bio_copy_completion {
+	struct completion wait;
+	int error;
+};
+
+static void bio_copy_sync_callback(void *ptr, int error)
+{
+	struct bio_copy_completion *comp = ptr;
+	comp->error = error;
+	complete(&comp->wait);
+}
+
 /**
  * blkdev_issue_copy - queue a copy same operation
  * @src_bdev:	source blockdev
@@ -384,57 +419,83 @@ static void bio_copy_end_io(struct bio *
  */
 int blkdev_issue_copy(struct block_device *src_bdev, sector_t src_sector,
 		      struct block_device *dst_bdev, sector_t dst_sector,
-		      sector_t nr_sects, gfp_t gfp_mask, sector_t *copied)
+		      sector_t nr_sects, gfp_t gfp_mask,
+		      void (*callback)(void *, int), void *data,
+		      sector_t *copied)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *sq = bdev_get_queue(src_bdev);
 	struct request_queue *dq = bdev_get_queue(dst_bdev);
 	unsigned int max_copy_sectors;
-	struct bio_batch bb;
-	int ret = 0;
-	atomic64_t first_error = ATOMIC64_INIT(nr_sects);
-	sector_t offset = 0;
+	int ret;
+	struct bio_copy_batch *batch;
+	struct bio_copy_completion comp;
 
 	if (copied)
 		*copied = 0;
 
-	if (!sq || !dq)
-		return -ENXIO;
+	if (!sq || !dq) {
+		ret = -ENXIO;
+		goto end_callback;
+	}
 
 	max_copy_sectors = min(sq->limits.max_copy_sectors,
 			       dq->limits.max_copy_sectors);
 
-	if (max_copy_sectors == 0)
-		return -EOPNOTSUPP;
+	if (max_copy_sectors == 0) {
+		ret = -EOPNOTSUPP;
+		goto end_callback;
+	}
 
 	if (src_sector + nr_sects < src_sector ||
-	    dst_sector + nr_sects < dst_sector)
-		return -EINVAL;
+	    dst_sector + nr_sects < dst_sector) {
+		ret = -EINVAL;
+		goto end_callback;
+	}
 
 	/* Do not support overlapping copies */
 	if (src_bdev == dst_bdev &&
-	    abs((u64)dst_sector - (u64)src_sector) < nr_sects)
-		return -EOPNOTSUPP;
+	    abs((u64)dst_sector - (u64)src_sector) < nr_sects) {
+		ret = -EOPNOTSUPP;
+		goto end_callback;
+	}
 
-	atomic_set(&bb.done, 1);
-	bb.error = 0;
-	bb.wait = &wait;
+	batch = kmalloc(sizeof(struct bio_copy_batch), gfp_mask);
+	if (!batch) {
+		ret = -ENOMEM;
+		goto end_callback;
+	}
+
+	batch->done = (atomic_long_t)ATOMIC_LONG_INIT(1);
+	batch->async_error = 0;
+	batch->sync_error = 0;
+	batch->sync_copied = 0;
+	batch->first_error = (atomic64_t)ATOMIC64_INIT(nr_sects);
+	batch->copied = copied;
+	if (callback) {
+		batch->callback = callback;
+		batch->data = data;
+	} else {
+		comp.wait = COMPLETION_INITIALIZER_ONSTACK(comp.wait);
+		batch->callback = bio_copy_sync_callback;
+		batch->data = &comp;
+	}
 
-	while (nr_sects && !ACCESS_ONCE(bb.error)) {
+	while (nr_sects && !ACCESS_ONCE(batch->async_error)) {
 		struct bio *read_bio, *write_bio;
 		struct bio_copy *bc;
 		unsigned chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
 
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
-			ret = -ENOMEM;
+			batch->sync_error = -ENOMEM;
 			break;
 		}
 
 		read_bio = bio_alloc(gfp_mask, 1);
 		if (!read_bio) {
 			kfree(bc);
-			ret = -ENOMEM;
+			batch->sync_error = -ENOMEM;
 			break;
 		}
 
@@ -442,7 +503,7 @@ int blkdev_issue_copy(struct block_devic
 		if (!write_bio) {
 			bio_put(read_bio);
 			kfree(bc);
-			ret = -ENOMEM;
+			batch->sync_error = -ENOMEM;
 			break;
 		}
 
@@ -450,9 +511,8 @@ int blkdev_issue_copy(struct block_devic
 		bc->error = 1;
 		bc->pair[0] = NULL;
 		bc->pair[1] = NULL;
-		bc->private = &bb;
-		bc->first_error = &first_error;
-		bc->offset = offset;
+		bc->batch = batch;
+		bc->offset = batch->sync_copied;
 		spin_lock_init(&bc->spinlock);
 		__setup_timer(&bc->timer, blk_copy_timeout, (unsigned long)bc, TIMER_IRQSAFE);
 		mod_timer(&bc->timer, jiffies + BLK_COPY_TIMEOUT);
@@ -469,27 +529,33 @@ int blkdev_issue_copy(struct block_devic
 		write_bio->bi_bdev = dst_bdev;
 		write_bio->bi_copy = bc;
 
-		atomic_inc(&bb.done);
+		atomic_long_inc(&batch->done);
 		submit_bio(READ | REQ_COPY, read_bio);
 		submit_bio(WRITE | REQ_COPY, write_bio);
 
 		src_sector += chunk;
 		dst_sector += chunk;
 		nr_sects -= chunk;
-		offset += chunk;
+		batch->sync_copied += chunk;
 	}
 
-	/* Wait for bios in-flight */
-	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion_io(&wait);
+	if (atomic_long_dec_and_test(&batch->done))
+		blk_copy_batch_finish(batch);
 
-	if (copied)
-		*copied = min((sector_t)atomic64_read(&first_error), offset);
-
-	if (likely(!ret))
-		ret = bb.error;
+	if (callback) {
+		return 0;
+	} else {
+		wait_for_completion_io(&comp.wait);
+		return comp.error;
+	}
 
-	return ret;
+end_callback:
+	if (callback) {
+		callback(data, ret);
+		return 0;
+	} else {
+		return ret;
+	}
 }
 EXPORT_SYMBOL(blkdev_issue_copy);
 
Index: linux-4.4-rc4/include/linux/blk_types.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/blk_types.h	2015-12-10 17:04:45.000000000 +0100
+++ linux-4.4-rc4/include/linux/blk_types.h	2015-12-10 17:04:46.000000000 +0100
@@ -40,6 +40,8 @@ struct bvec_iter {
 						   current bvec */
 };
 
+struct bio_copy_batch;
+
 struct bio_copy {
 	/*
 	 * error == 1 - bios are waiting to be paired
@@ -49,8 +51,7 @@ struct bio_copy {
 	int error;
 	atomic_t in_flight;
 	struct bio *pair[2];
-	void *private;
-	atomic64_t *first_error;
+	struct bio_copy_batch *batch;
 	sector_t offset;
 	spinlock_t spinlock;
 	struct timer_list timer;
Index: linux-4.4-rc4/include/linux/blkdev.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/blkdev.h	2015-12-10 17:04:40.000000000 +0100
+++ linux-4.4-rc4/include/linux/blkdev.h	2015-12-10 17:04:46.000000000 +0100
@@ -1142,7 +1142,7 @@ extern int blkdev_issue_write_same(struc
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_copy(struct block_device *, sector_t,
 		struct block_device *, sector_t, sector_t, gfp_t,
-		sector_t *);
+		void (*)(void *, int), void *, sector_t *);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, bool discard);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
Index: linux-4.4-rc4/block/ioctl.c
===================================================================
--- linux-4.4-rc4.orig/block/ioctl.c	2015-12-10 17:04:40.000000000 +0100
+++ linux-4.4-rc4/block/ioctl.c	2015-12-10 17:04:46.000000000 +0100
@@ -276,7 +276,7 @@ static int blk_ioctl_copy(struct block_d
 		return -EINVAL;
 
 	ret = blkdev_issue_copy(bdev, src_offset, bdev, dst_offset, len,
-				GFP_KERNEL, &copied_sec);
+				GFP_KERNEL, NULL, NULL, &copied_sec);
 
 	*copied = (uint64_t)copied_sec << 9;
 
