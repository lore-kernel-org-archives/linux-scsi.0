From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Fri, 13 Aug 2010 16:38:20 +0200
Message-ID: <20100813143820.GA7931@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57863 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab0HMOi4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2010 10:38:56 -0400
Content-Disposition: inline
In-Reply-To: <4C654D4B.1030507@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

On Fri, Aug 13, 2010 at 03:48:59PM +0200, Tejun Heo wrote:
> There are two reason to avoid changing the meaning of REQ_HARDBARRIER
> and just deprecate it.  One is to avoid breaking filesystems'
> expectations underneath it.  Please note that there are out-of-tree
> filesystems too.  I think it would be too dangerous to relax
> REQ_HARDBARRIER.

Note that the renaming patch would include a move from REQ_HARDBARRIER
to REQ_FLUSH_FUA, so things just using REQ_HARDBARRIER will fail to
compile.  And while out of tree filesystems do exist they it's their
problem to keep up with kernel changes.  They decide not to be part
of the Linux kernel, so it'll be their job to keep up with it.

> Another is that pseudo block layer drivers (loop, virtio_blk,
> md/dm...) have assumptions about REQ_HARDBARRIER behavior and things
> would be broken in obscure ways between REQ_HARDBARRIER semantics
> change and updates to each of those drivers, so I don't really think
> changing the semantics while the mechanism is online is a good idea.

I don't think doing those changes in a separate commit is a good idea.

> > Then we can patches do disable the reiserfs barrier "optimization" as
> > the very first one, and DM/MD support which I'm currently working on
> > as the last one and we can start doing the heavy testing.
> 
> Oops, I've already converted loop, virtio_blk/lguest and am working on
> md/dm right now too.  I'm almost done with md and now doing dm. :-)
> Maybe we should post them right now so that we don't waste too much
> time trying to solve the same problems?

Here's the dm patch.  It only handles normal bio based dm yet, which
I understand and can test.  request  based dm (multipath) still needs
work.


Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2010-08-13 16:11:04.207010218 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2010-08-13 16:11:10.048003862 +0200
@@ -1249,7 +1249,7 @@ static int crypt_map(struct dm_target *t
 	struct dm_crypt_io *io;
 	struct crypt_config *cc;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio_empty_flush(bio)) {
 		cc = ti->private;
 		bio->bi_bdev = cc->dev->bdev;
 		return DM_MAPIO_REMAPPED;
Index: linux-2.6/drivers/md/dm-io.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-io.c	2010-08-13 16:11:04.213011894 +0200
+++ linux-2.6/drivers/md/dm-io.c	2010-08-13 16:11:10.049003792 +0200
@@ -364,7 +364,7 @@ static void dispatch_io(int rw, unsigned
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (rw & REQ_HARDBARRIER))
+		if (where[i].count || (rw & REQ_FLUSH))
 			do_region(rw, i, where + i, dp, io);
 	}
 
@@ -412,8 +412,8 @@ retry:
 	}
 	set_current_state(TASK_RUNNING);
 
-	if (io->eopnotsupp_bits && (rw & REQ_HARDBARRIER)) {
-		rw &= ~REQ_HARDBARRIER;
+	if (io->eopnotsupp_bits && (rw & REQ_FLUSH)) {
+		rw &= ~REQ_FLUSH;
 		goto retry;
 	}
 
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c	2010-08-13 16:11:04.220013431 +0200
+++ linux-2.6/drivers/md/dm-raid1.c	2010-08-13 16:11:10.054018319 +0200
@@ -670,7 +670,7 @@ static void do_writes(struct mirror_set
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if (unlikely(bio_empty_barrier(bio))) {
+		if (bio_empty_flush(bio)) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1203,7 +1203,7 @@ static int mirror_end_io(struct dm_targe
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (likely(!bio_empty_barrier(bio)))
+		if (!bio_empty_flush(bio))
 			dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
Index: linux-2.6/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-region-hash.c	2010-08-13 16:11:04.228004631 +0200
+++ linux-2.6/drivers/md/dm-region-hash.c	2010-08-13 16:11:10.060003932 +0200
@@ -399,7 +399,7 @@ void dm_rh_mark_nosync(struct dm_region_
 	region_t region = dm_rh_bio_to_region(rh, bio);
 	int recovering = 0;
 
-	if (bio_empty_barrier(bio)) {
+	if (bio_empty_flush(bio)) {
 		rh->barrier_failure = 1;
 		return;
 	}
@@ -524,7 +524,7 @@ void dm_rh_inc_pending(struct dm_region_
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio_empty_barrier(bio))
+		if (bio_empty_flush(bio))
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2010-08-13 16:11:04.238004701 +0200
+++ linux-2.6/drivers/md/dm-snap.c	2010-08-13 16:11:10.067005677 +0200
@@ -1581,7 +1581,7 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio_empty_flush(bio)) {
 		bio->bi_bdev = s->cow->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
@@ -1685,7 +1685,7 @@ static int snapshot_merge_map(struct dm_
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio_empty_flush(bio)) {
 		if (!map_context->flush_request)
 			bio->bi_bdev = s->origin->bdev;
 		else
@@ -2123,7 +2123,7 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio_empty_flush(bio))
 		return DM_MAPIO_REMAPPED;
 
 	/* Only tell snapshots if this is a write */
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2010-08-13 16:11:04.247011266 +0200
+++ linux-2.6/drivers/md/dm-stripe.c	2010-08-13 16:11:10.072026629 +0200
@@ -214,7 +214,7 @@ static int stripe_map(struct dm_target *
 	sector_t offset, chunk;
 	uint32_t stripe;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio_empty_flush(bio)) {
 		BUG_ON(map_context->flush_request >= sc->stripes);
 		bio->bi_bdev = sc->stripe[map_context->flush_request].dev->bdev;
 		return DM_MAPIO_REMAPPED;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2010-08-13 16:11:04.256004631 +0200
+++ linux-2.6/drivers/md/dm.c	2010-08-13 16:11:37.152005462 +0200
@@ -139,17 +139,6 @@ struct mapped_device {
 	spinlock_t deferred_lock;
 
 	/*
-	 * An error from the barrier request currently being processed.
-	 */
-	int barrier_error;
-
-	/*
-	 * Protect barrier_error from concurrent endio processing
-	 * in request-based dm.
-	 */
-	spinlock_t barrier_error_lock;
-
-	/*
 	 * Processing queue (flush/barriers)
 	 */
 	struct workqueue_struct *wq;
@@ -194,9 +183,6 @@ struct mapped_device {
 
 	/* sysfs handle */
 	struct kobject kobj;
-
-	/* zero-length barrier that will be cloned and submitted to targets */
-	struct bio barrier_bio;
 };
 
 /*
@@ -505,10 +491,6 @@ static void end_io_acct(struct dm_io *io
 	part_stat_add(cpu, &dm_disk(md)->part0, ticks[rw], duration);
 	part_stat_unlock();
 
-	/*
-	 * After this is decremented the bio must not be touched if it is
-	 * a barrier.
-	 */
 	dm_disk(md)->part0.in_flight[rw] = pending =
 		atomic_dec_return(&md->pending[rw]);
 	pending += atomic_read(&md->pending[rw^0x1]);
@@ -621,7 +603,7 @@ static void dec_pending(struct dm_io *io
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
 			if (__noflush_suspending(md)) {
-				if (!(io->bio->bi_rw & REQ_HARDBARRIER))
+				if (!(io->bio->bi_rw & (REQ_FLUSH|REQ_FUA)))
 					bio_list_add_head(&md->deferred,
 							  io->bio);
 			} else
@@ -633,25 +615,13 @@ static void dec_pending(struct dm_io *io
 		io_error = io->error;
 		bio = io->bio;
 
-		if (bio->bi_rw & REQ_HARDBARRIER) {
-			/*
-			 * There can be just one barrier request so we use
-			 * a per-device variable for error reporting.
-			 * Note that you can't touch the bio after end_io_acct
-			 */
-			if (!md->barrier_error && io_error != -EOPNOTSUPP)
-				md->barrier_error = io_error;
-			end_io_acct(io);
-			free_io(md, io);
-		} else {
-			end_io_acct(io);
-			free_io(md, io);
+		end_io_acct(io);
+		free_io(md, io);
 
-			if (io_error != DM_ENDIO_REQUEUE) {
-				trace_block_bio_complete(md->queue, bio);
+		if (io_error != DM_ENDIO_REQUEUE) {
+			trace_block_bio_complete(md->queue, bio);
 
-				bio_endio(bio, io_error);
-			}
+			bio_endio(bio, io_error);
 		}
 	}
 }
@@ -744,23 +714,6 @@ static void end_clone_bio(struct bio *cl
 	blk_update_request(tio->orig, 0, nr_bytes);
 }
 
-static void store_barrier_error(struct mapped_device *md, int error)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&md->barrier_error_lock, flags);
-	/*
-	 * Basically, the first error is taken, but:
-	 *   -EOPNOTSUPP supersedes any I/O error.
-	 *   Requeue request supersedes any I/O error but -EOPNOTSUPP.
-	 */
-	if (!md->barrier_error || error == -EOPNOTSUPP ||
-	    (md->barrier_error != -EOPNOTSUPP &&
-	     error == DM_ENDIO_REQUEUE))
-		md->barrier_error = error;
-	spin_unlock_irqrestore(&md->barrier_error_lock, flags);
-}
-
 /*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
@@ -798,13 +751,11 @@ static void free_rq_clone(struct request
 static void dm_end_request(struct request *clone, int error)
 {
 	int rw = rq_data_dir(clone);
-	int run_queue = 1;
-	bool is_barrier = clone->cmd_flags & REQ_HARDBARRIER;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_barrier) {
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;
 
@@ -818,15 +769,8 @@ static void dm_end_request(struct reques
 	}
 
 	free_rq_clone(clone);
-
-	if (unlikely(is_barrier)) {
-		if (unlikely(error))
-			store_barrier_error(md, error);
-		run_queue = 0;
-	} else
-		blk_end_request_all(rq, error);
-
-	rq_completed(md, rw, run_queue);
+	blk_end_request_all(rq, error);
+	rq_completed(md, rw, 1);
 }
 
 static void dm_unprep_request(struct request *rq)
@@ -1113,7 +1057,7 @@ static struct bio *split_bvec(struct bio
 
 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw & ~REQ_HARDBARRIER;
+	clone->bi_rw = bio->bi_rw;
 	clone->bi_vcnt = 1;
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
@@ -1140,7 +1084,6 @@ static struct bio *clone_bio(struct bio
 
 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_rw &= ~REQ_HARDBARRIER;
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1186,7 +1129,7 @@ static void __flush_target(struct clone_
 	__map_bio(ti, clone, tio);
 }
 
-static int __clone_and_map_empty_barrier(struct clone_info *ci)
+static int __clone_and_map_empty_flush(struct clone_info *ci)
 {
 	unsigned target_nr = 0, flush_nr;
 	struct dm_target *ti;
@@ -1208,8 +1151,8 @@ static int __clone_and_map(struct clone_
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
-	if (unlikely(bio_empty_barrier(bio)))
-		return __clone_and_map_empty_barrier(ci);
+	if (bio_empty_flush(bio))
+		return __clone_and_map_empty_flush(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
@@ -1308,11 +1251,7 @@ static void __split_and_process_bio(stru
 
 	ci.map = dm_get_live_table(md);
 	if (unlikely(!ci.map)) {
-		if (!(bio->bi_rw & REQ_HARDBARRIER))
-			bio_io_error(bio);
-		else
-			if (!md->barrier_error)
-				md->barrier_error = -EIO;
+		bio_io_error(bio);
 		return;
 	}
 
@@ -1326,7 +1265,7 @@ static void __split_and_process_bio(stru
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio_empty_flush(bio))
 		ci.sector_count = 1;
 	ci.idx = bio->bi_idx;
 
@@ -1420,8 +1359,7 @@ static int _dm_request(struct request_qu
 	 * If we're suspended or the thread is processing barriers
 	 * we have to queue this io for later.
 	 */
-	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
-	    unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
+	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags))) {
 		up_read(&md->io_lock);
 
 		if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) &&
@@ -1873,7 +1811,6 @@ static struct mapped_device *alloc_dev(i
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->deferred_lock);
-	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -2233,38 +2170,6 @@ static int dm_wait_for_completion(struct
 	return r;
 }
 
-static void dm_flush(struct mapped_device *md)
-{
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-
-	bio_init(&md->barrier_bio);
-	md->barrier_bio.bi_bdev = md->bdev;
-	md->barrier_bio.bi_rw = WRITE_BARRIER;
-	__split_and_process_bio(md, &md->barrier_bio);
-
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-}
-
-static void process_barrier(struct mapped_device *md, struct bio *bio)
-{
-	md->barrier_error = 0;
-
-	dm_flush(md);
-
-	if (!bio_empty_barrier(bio)) {
-		__split_and_process_bio(md, bio);
-		dm_flush(md);
-	}
-
-	if (md->barrier_error != DM_ENDIO_REQUEUE)
-		bio_endio(bio, md->barrier_error);
-	else {
-		spin_lock_irq(&md->deferred_lock);
-		bio_list_add_head(&md->deferred, bio);
-		spin_unlock_irq(&md->deferred_lock);
-	}
-}
-
 /*
  * Process the deferred bios
  */
@@ -2290,12 +2195,8 @@ static void dm_wq_work(struct work_struc
 
 		if (dm_request_based(md))
 			generic_make_request(c);
-		else {
-			if (c->bi_rw & REQ_HARDBARRIER)
-				process_barrier(md, c);
-			else
-				__split_and_process_bio(md, c);
-		}
+		else
+			__split_and_process_bio(md, c);
 
 		down_write(&md->io_lock);
 	}
@@ -2326,8 +2227,6 @@ static int dm_rq_barrier(struct mapped_d
 	struct dm_target *ti;
 	struct request *clone;
 
-	md->barrier_error = 0;
-
 	for (i = 0; i < num_targets; i++) {
 		ti = dm_table_get_target(map, i);
 		for (j = 0; j < ti->num_flush_requests; j++) {
@@ -2341,7 +2240,7 @@ static int dm_rq_barrier(struct mapped_d
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 	dm_table_put(map);
 
-	return md->barrier_error;
+	return 0;
 }
 
 static void dm_rq_barrier_work(struct work_struct *work)
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2010-08-13 16:11:04.268004351 +0200
+++ linux-2.6/include/linux/bio.h	2010-08-13 16:11:10.082005677 +0200
@@ -66,8 +66,8 @@
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_empty_barrier(bio) \
-	((bio->bi_rw & REQ_HARDBARRIER) && \
+#define bio_empty_flush(bio) \
+	((bio->bi_rw & REQ_FLUSH) && \
 	 !bio_has_data(bio) && \
 	 !(bio->bi_rw & REQ_DISCARD))
 
