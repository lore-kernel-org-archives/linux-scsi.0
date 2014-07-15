From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/15] block copy: use two bios
Date: Tue, 15 Jul 2014 15:35:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151534510.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch changes the architecture of xcopy so that two bios are used.

There used to be just one bio that held pointers to both source and
destination block device. However a bio with two block devices cannot
really be passed though block midlayer drivers (dm and md).

When we need to send the XCOPY command, we call the function
blkdev_issue_copy. This function creates two bios, the first with bi_rw
READ | REQ_COPY and the second WRITE | REQ_COPY. The bios have a pointer
to a common bi_copy structure.

These bios travel independently through the block device stack. When both
the bios reach the physical disk driver (the function blk_queue_bio), they
are paired, a request is made and the request is sent to the SCSI disk
driver.

It is possible that one of the bios reaches a device that doesn't support
XCOPY, in that case both bios are aborted with an error.

Note that there is no guarantee that the XCOPY command will succeed. If it
doesn't succeed, the caller is supposed to perform the copy manually.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/bio.c               |   26 ++++++++++++++-
 block/blk-core.c          |   34 ++++++++++++++++++++
 block/blk-lib.c           |   76 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.c         |    7 +---
 include/linux/blk_types.h |   12 ++++++-
 5 files changed, 131 insertions(+), 24 deletions(-)

Index: linux-3.16-rc5/block/blk-lib.c
===================================================================
--- linux-3.16-rc5.orig/block/blk-lib.c	2014-07-14 16:32:21.000000000 +0200
+++ linux-3.16-rc5/block/blk-lib.c	2014-07-15 15:26:33.000000000 +0200
@@ -305,6 +305,36 @@ int blkdev_issue_zeroout(struct block_de
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
 
+static void bio_copy_end_io(struct bio *bio, int error)
+{
+	struct bio_copy *bc = bio->bi_copy;
+	if (unlikely(error)) {
+		unsigned long flags;
+		int dir;
+		struct bio *other;
+
+		/* if the other bio is waiting for the pair, release it */
+		spin_lock_irqsave(&bc->spinlock, flags);
+		if (bc->error >= 0)
+			bc->error = error;
+		dir = bio_data_dir(bio);
+		other = bc->pair[dir ^ 1];
+		bc->pair[dir ^ 1] = NULL;
+		spin_unlock_irqrestore(&bc->spinlock, flags);
+		if (other)
+			bio_endio(other, error);
+	}
+	bio_put(bio);
+	if (atomic_dec_and_test(&bc->in_flight)) {
+		struct bio_batch *bb = bc->private;
+		if (unlikely(bc->error < 0) && !ACCESS_ONCE(bb->error))
+			ACCESS_ONCE(bb->error) = bc->error;
+		kfree(bc);
+		if (atomic_dec_and_test(&bb->done))
+			complete(bb->wait);
+	}
+}
+
 /**
  * blkdev_issue_copy - queue a copy same operation
  * @src_bdev:	source blockdev
@@ -351,9 +381,9 @@ int blkdev_issue_copy(struct block_devic
 	bb.wait = &wait;
 
 	while (nr_sects) {
-		struct bio *bio;
+		struct bio *read_bio, *write_bio;
 		struct bio_copy *bc;
-		unsigned int chunk;
+		unsigned int chunk = min(nr_sects, max_copy_sectors);
 
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
@@ -361,27 +391,43 @@ int blkdev_issue_copy(struct block_devic
 			break;
 		}
 
-		bio = bio_alloc(gfp_mask, 1);
-		if (!bio) {
+		read_bio = bio_alloc(gfp_mask, 1);
+		if (!read_bio) {
 			kfree(bc);
 			ret = -ENOMEM;
 			break;
 		}
 
-		chunk = min(nr_sects, max_copy_sectors);
-
-		bio->bi_iter.bi_sector = dst_sector;
-		bio->bi_iter.bi_size = chunk << 9;
-		bio->bi_end_io = bio_batch_end_io;
-		bio->bi_bdev = dst_bdev;
-		bio->bi_private = &bb;
-		bio->bi_copy = bc;
+		write_bio = bio_alloc(gfp_mask, 1);
+		if (!write_bio) {
+			bio_put(read_bio);
+			kfree(bc);
+			ret = -ENOMEM;
+			break;
+		}
 
-		bc->bic_bdev = src_bdev;
-		bc->bic_sector = src_sector;
+		atomic_set(&bc->in_flight, 2);
+		bc->error = 1;
+		bc->pair[0] = NULL;
+		bc->pair[1] = NULL;
+		bc->private = &bb;
+		spin_lock_init(&bc->spinlock);
+
+		read_bio->bi_iter.bi_sector = src_sector;
+		read_bio->bi_iter.bi_size = chunk << 9;
+		read_bio->bi_end_io = bio_copy_end_io;
+		read_bio->bi_bdev = src_bdev;
+		read_bio->bi_copy = bc;
+
+		write_bio->bi_iter.bi_sector = dst_sector;
+		write_bio->bi_iter.bi_size = chunk << 9;
+		write_bio->bi_end_io = bio_copy_end_io;
+		write_bio->bi_bdev = dst_bdev;
+		write_bio->bi_copy = bc;
 
 		atomic_inc(&bb.done);
-		submit_bio(REQ_WRITE | REQ_COPY, bio);
+		submit_bio(READ | REQ_COPY, read_bio);
+		submit_bio(WRITE | REQ_COPY, write_bio);
 
 		src_sector += chunk;
 		dst_sector += chunk;
Index: linux-3.16-rc5/include/linux/blk_types.h
===================================================================
--- linux-3.16-rc5.orig/include/linux/blk_types.h	2014-07-14 16:26:44.000000000 +0200
+++ linux-3.16-rc5/include/linux/blk_types.h	2014-07-15 15:26:05.000000000 +0200
@@ -40,8 +40,16 @@ struct bvec_iter {
 };
 
 struct bio_copy {
-	struct block_device	*bic_bdev;
-	sector_t		bic_sector;
+	/*
+	 * error == 1 - bios are waiting to be paired
+	 * error == 0 - pair was issued
+	 * error < 0  - error
+	 */
+	int error;
+	atomic_t in_flight;
+	struct bio *pair[2];
+	void *private;
+	spinlock_t spinlock;
 };
 
 /*
Index: linux-3.16-rc5/block/bio.c
===================================================================
--- linux-3.16-rc5.orig/block/bio.c	2014-07-14 16:26:44.000000000 +0200
+++ linux-3.16-rc5/block/bio.c	2014-07-14 16:39:04.000000000 +0200
@@ -239,8 +239,6 @@ static void __bio_free(struct bio *bio)
 {
 	bio_disassociate_task(bio);
 
-	kfree(bio->bi_copy);
-
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
 }
@@ -566,6 +564,7 @@ void __bio_clone_fast(struct bio *bio, s
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_copy = bio_src->bi_copy;
 	bio->bi_io_vec = bio_src->bi_io_vec;
 }
 EXPORT_SYMBOL(__bio_clone_fast);
@@ -1750,6 +1749,26 @@ void bio_flush_dcache_pages(struct bio *
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
 
+static noinline_for_stack void bio_endio_copy(struct bio *bio, int error)
+{
+	struct bio_copy *bc = bio->bi_copy;
+	struct bio *other = NULL;
+	unsigned long flags;
+	int dir;
+
+	spin_lock_irqsave(&bc->spinlock, flags);
+	dir = bio_data_dir(bio);
+	if (bc->pair[dir]) {
+		BUG_ON(bc->pair[dir] != bio);
+		other = bc->pair[dir ^ 1];
+		bc->pair[0] = bc->pair[1] = NULL;
+	}
+	spin_unlock_irqrestore(&bc->spinlock, flags);
+
+	if (other)
+		bio_endio(other, error);
+}
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
@@ -1777,6 +1796,9 @@ void bio_endio(struct bio *bio, int erro
 		if (!atomic_dec_and_test(&bio->bi_remaining))
 			return;
 
+		if (unlikely((bio->bi_rw & REQ_COPY) != 0))
+			bio_endio_copy(bio, error);
+
 		/*
 		 * Need to have a real endio function for chained bios,
 		 * otherwise various corner cases will break (like stacking
Index: linux-3.16-rc5/block/blk-core.c
===================================================================
--- linux-3.16-rc5.orig/block/blk-core.c	2014-07-14 16:26:44.000000000 +0200
+++ linux-3.16-rc5/block/blk-core.c	2014-07-14 16:39:04.000000000 +0200
@@ -1544,6 +1544,32 @@ void init_request_from_bio(struct reques
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
+static noinline_for_stack struct bio *blk_queue_copy(struct bio *bio)
+{
+	struct bio_copy *bc = bio->bi_copy;
+	int dir, error;
+	struct bio *ret;
+
+	spin_lock_irq(&bc->spinlock);
+	error = bc->error;
+	if (unlikely(error < 0)) {
+		spin_unlock_irq(&bc->spinlock);
+		bio_endio(bio, error);
+		return NULL;
+	}
+	dir = bio_data_dir(bio);
+	bc->pair[dir] = bio;
+	if (bc->pair[dir ^ 1]) {
+		ret = bc->pair[1];
+		bc->error = 0;
+	} else {
+		ret = NULL;
+	}
+	spin_unlock_irq(&bc->spinlock);
+
+	return ret;
+}
+
 void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
@@ -1598,6 +1624,14 @@ void blk_queue_bio(struct request_queue 
 	}
 
 get_rq:
+	if (unlikely((bio->bi_rw & REQ_COPY) != 0)) {
+		spin_unlock_irq(q->queue_lock);
+		bio = blk_queue_copy(bio);
+		if (!bio)
+			return;
+		spin_lock_irq(q->queue_lock);
+	}
+
 	/*
 	 * This sync check and mask will be re-done in init_request_from_bio(),
 	 * but we need to set it earlier to expose the sync flag to the
Index: linux-3.16-rc5/drivers/scsi/sd.c
===================================================================
--- linux-3.16-rc5.orig/drivers/scsi/sd.c	2014-07-14 16:26:44.000000000 +0200
+++ linux-3.16-rc5/drivers/scsi/sd.c	2014-07-14 16:41:31.000000000 +0200
@@ -902,12 +902,9 @@ static int sd_setup_copy_cmnd(struct scs
 	struct page *page;
 	unsigned char *buf;
 
-	if (!bio->bi_copy)
-		return BLKPREP_KILL;
-
 	dst_sdp = scsi_disk(rq->rq_disk)->device;
 	dst_queue = rq->rq_disk->queue;
-	src_disk = bio->bi_copy->bic_bdev->bd_disk;
+	src_disk = bio->bi_copy->pair[0]->bi_bdev->bd_disk;
 	src_queue = src_disk->queue;
 	if (!src_queue ||
 	    src_queue->make_request_fn != blk_queue_bio ||
@@ -924,7 +921,7 @@ static int sd_setup_copy_cmnd(struct scs
 		return BLKPREP_KILL;
 
 	dst_lba = blk_rq_pos(rq) >> (ilog2(dst_sdp->sector_size) - 9);
-	src_lba = bio->bi_copy->bic_sector >> (ilog2(src_sdp->sector_size) - 9);
+	src_lba = bio->bi_copy->pair[0]->bi_iter.bi_sector >> (ilog2(src_sdp->sector_size) - 9);
 	nr_blocks = blk_rq_sectors(rq) >> (ilog2(dst_sdp->sector_size) - 9);
 
 	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
