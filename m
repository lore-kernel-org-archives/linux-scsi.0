From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based dm
Date: Fri,  3 Sep 2010 12:29:38 +0200
Message-ID: <1283509796-1510-24-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.co
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch converts bio-based dm to support REQ_FLUSH/FUA instead of
now deprecated REQ_HARDBARRIER.

* -EOPNOTSUPP handling logic dropped.

* Preflush is handled as before but postflush is dropped and replaced
  with passing down REQ_FUA to member request_queues.  This replaces
  one array wide cache flush w/ member specific FUA writes.

* __split_and_process_bio() now calls __clone_and_map_flush() directly
  for flushes and guarantees all FLUSH bio's going to targets are zero
`  length.

* It's now guaranteed that all FLUSH bio's which are passed onto dm
  targets are zero length.  bio_empty_barrier() tests are replaced
  with REQ_FLUSH tests.

* Empty WRITE_BARRIERs are replaced with WRITE_FLUSHes.

* Dropped unlikely() around REQ_FLUSH tests.  Flushes are not unlikely
  enough to be marked with unlikely().

* Block layer now filters out REQ_FLUSH/FUA bio's if the request_queue
  doesn't support cache flushing.  Advertise REQ_FLUSH | REQ_FUA
  capability.

* Request based dm isn't converted yet.  dm_init_request_based_queue()
  resets flush support to 0 for now.  To avoid disturbing request
  based dm code, dm->flush_error is added for bio based dm while
  requested based dm continues to use dm->barrier_error.

Lightly tested linear, stripe, raid1, snap and crypt targets.  Please
proceed with caution as I'm not familiar with the code base.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c           |    2 +-
 drivers/md/dm-io.c              |   20 +-----
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-raid1.c           |    8 +-
 drivers/md/dm-region-hash.c     |   16 +++---
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/dm-snap.c            |    6 +-
 drivers/md/dm-stripe.c          |    2 +-
 drivers/md/dm.c                 |  119 +++++++++++++++++++--------------------
 9 files changed, 80 insertions(+), 97 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 368e8e9..d5b0e4c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1278,7 +1278,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	struct dm_crypt_io *io;
 	struct crypt_config *cc;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		cc = ti->private;
 		bio->bi_bdev = cc->dev->bdev;
 		return DM_MAPIO_REMAPPED;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 0590c75..136d4f7 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -31,7 +31,6 @@ struct dm_io_client {
  */
 struct io {
 	unsigned long error_bits;
-	unsigned long eopnotsupp_bits;
 	atomic_t count;
 	struct task_struct *sleeper;
 	struct dm_io_client *client;
@@ -130,11 +129,8 @@ static void retrieve_io_and_region_from_bio(struct bio *bio, struct io **io,
  *---------------------------------------------------------------*/
 static void dec_count(struct io *io, unsigned int region, int error)
 {
-	if (error) {
+	if (error)
 		set_bit(region, &io->error_bits);
-		if (error == -EOPNOTSUPP)
-			set_bit(region, &io->eopnotsupp_bits);
-	}
 
 	if (atomic_dec_and_test(&io->count)) {
 		if (io->sleeper)
@@ -310,8 +306,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	sector_t remaining = where->count;
 
 	/*
-	 * where->count may be zero if rw holds a write barrier and we
-	 * need to send a zero-sized barrier.
+	 * where->count may be zero if rw holds a flush and we need to
+	 * send a zero-sized flush.
 	 */
 	do {
 		/*
@@ -364,7 +360,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (rw & REQ_HARDBARRIER))
+		if (where[i].count || (rw & REQ_FLUSH))
 			do_region(rw, i, where + i, dp, io);
 	}
 
@@ -393,9 +389,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 		return -EIO;
 	}
 
-retry:
 	io->error_bits = 0;
-	io->eopnotsupp_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = current;
 	io->client = client;
@@ -412,11 +406,6 @@ retry:
 	}
 	set_current_state(TASK_RUNNING);
 
-	if (io->eopnotsupp_bits && (rw & REQ_HARDBARRIER)) {
-		rw &= ~REQ_HARDBARRIER;
-		goto retry;
-	}
-
 	if (error_bits)
 		*error_bits = io->error_bits;
 
@@ -437,7 +426,6 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
-	io->eopnotsupp_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
 	io->client = client;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 5a08be0..33420e6 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -300,7 +300,7 @@ static int flush_header(struct log_c *lc)
 		.count = 0,
 	};
 
-	lc->io_req.bi_rw = WRITE_BARRIER;
+	lc->io_req.bi_rw = WRITE_FLUSH;
 
 	return dm_io(&lc->io_req, 1, &null_location, NULL);
 }
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 7c081bc..19a59b0 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -259,7 +259,7 @@ static int mirror_flush(struct dm_target *ti)
 	struct dm_io_region io[ms->nr_mirrors];
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE_BARRIER,
+		.bi_rw = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.bvec = NULL,
 		.client = ms->io_client,
@@ -629,7 +629,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE | (bio->bi_rw & WRITE_BARRIER),
+		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
 		.mem.type = DM_IO_BVEC,
 		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
 		.notify.fn = write_callback,
@@ -670,7 +670,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if (unlikely(bio_empty_barrier(bio))) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1203,7 +1203,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (likely(!bio_empty_barrier(bio)))
+		if (!(bio->bi_rw & REQ_FLUSH))
 			dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index bd5c58b..dad011a 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -81,9 +81,9 @@ struct dm_region_hash {
 	struct list_head failed_recovered_regions;
 
 	/*
-	 * If there was a barrier failure no regions can be marked clean.
+	 * If there was a flush failure no regions can be marked clean.
 	 */
-	int barrier_failure;
+	int flush_failure;
 
 	void *context;
 	sector_t target_begin;
@@ -217,7 +217,7 @@ struct dm_region_hash *dm_region_hash_create(
 	INIT_LIST_HEAD(&rh->quiesced_regions);
 	INIT_LIST_HEAD(&rh->recovered_regions);
 	INIT_LIST_HEAD(&rh->failed_recovered_regions);
-	rh->barrier_failure = 0;
+	rh->flush_failure = 0;
 
 	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
 						      sizeof(struct dm_region));
@@ -399,8 +399,8 @@ void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio)
 	region_t region = dm_rh_bio_to_region(rh, bio);
 	int recovering = 0;
 
-	if (bio_empty_barrier(bio)) {
-		rh->barrier_failure = 1;
+	if (bio->bi_rw & REQ_FLUSH) {
+		rh->flush_failure = 1;
 		return;
 	}
 
@@ -524,7 +524,7 @@ void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios)
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio_empty_barrier(bio))
+		if (bio->bi_rw & REQ_FLUSH)
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
@@ -555,9 +555,9 @@ void dm_rh_dec(struct dm_region_hash *rh, region_t region)
 		 */
 
 		/* do nothing for DM_RH_NOSYNC */
-		if (unlikely(rh->barrier_failure)) {
+		if (unlikely(rh->flush_failure)) {
 			/*
-			 * If a write barrier failed some time ago, we
+			 * If a write flush failed some time ago, we
 			 * don't know whether or not this write made it
 			 * to the disk, so we must resync the device.
 			 */
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index cc2bdb8..0b61792 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -687,7 +687,7 @@ static void persistent_commit_exception(struct dm_exception_store *store,
 	/*
 	 * Commit exceptions to disk.
 	 */
-	if (ps->valid && area_io(ps, WRITE_BARRIER))
+	if (ps->valid && area_io(ps, WRITE_FLUSH_FUA))
 		ps->valid = 0;
 
 	/*
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5974d30..eed2101 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1587,7 +1587,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		bio->bi_bdev = s->cow->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
@@ -1691,7 +1691,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		if (!map_context->target_request_nr)
 			bio->bi_bdev = s->origin->bdev;
 		else
@@ -2135,7 +2135,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio->bi_rw & REQ_FLUSH)
 		return DM_MAPIO_REMAPPED;
 
 	/* Only tell snapshots if this is a write */
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index c297f6d..f0371b4 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -271,7 +271,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
 	uint32_t stripe;
 	unsigned target_request_nr;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		target_request_nr = map_context->target_request_nr;
 		BUG_ON(target_request_nr >= sc->stripes);
 		bio->bi_bdev = sc->stripe[target_request_nr].dev->bdev;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b1d92be..32e6622 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -144,15 +144,16 @@ struct mapped_device {
 	spinlock_t deferred_lock;
 
 	/*
-	 * An error from the barrier request currently being processed.
+	 * An error from the flush request currently being processed.
 	 */
-	int barrier_error;
+	int flush_error;
 
 	/*
 	 * Protect barrier_error from concurrent endio processing
 	 * in request-based dm.
 	 */
 	spinlock_t barrier_error_lock;
+	int barrier_error;
 
 	/*
 	 * Processing queue (flush/barriers)
@@ -200,8 +201,8 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;
 
-	/* zero-length barrier that will be cloned and submitted to targets */
-	struct bio barrier_bio;
+	/* zero-length flush that will be cloned and submitted to targets */
+	struct bio flush_bio;
 };
 
 /*
@@ -512,7 +513,7 @@ static void end_io_acct(struct dm_io *io)
 
 	/*
 	 * After this is decremented the bio must not be touched if it is
-	 * a barrier.
+	 * a flush.
 	 */
 	dm_disk(md)->part0.in_flight[rw] = pending =
 		atomic_dec_return(&md->pending[rw]);
@@ -626,7 +627,7 @@ static void dec_pending(struct dm_io *io, int error)
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
 			if (__noflush_suspending(md)) {
-				if (!(io->bio->bi_rw & REQ_HARDBARRIER))
+				if (!(io->bio->bi_rw & REQ_FLUSH))
 					bio_list_add_head(&md->deferred,
 							  io->bio);
 			} else
@@ -638,20 +639,14 @@ static void dec_pending(struct dm_io *io, int error)
 		io_error = io->error;
 		bio = io->bio;
 
-		if (bio->bi_rw & REQ_HARDBARRIER) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			/*
-			 * There can be just one barrier request so we use
+			 * There can be just one flush request so we use
 			 * a per-device variable for error reporting.
 			 * Note that you can't touch the bio after end_io_acct
-			 *
-			 * We ignore -EOPNOTSUPP for empty flush reported by
-			 * underlying devices. We assume that if the device
-			 * doesn't support empty barriers, it doesn't need
-			 * cache flushing commands.
 			 */
-			if (!md->barrier_error &&
-			    !(bio_empty_barrier(bio) && io_error == -EOPNOTSUPP))
-				md->barrier_error = io_error;
+			if (!md->flush_error)
+				md->flush_error = io_error;
 			end_io_acct(io);
 			free_io(md, io);
 		} else {
@@ -1119,7 +1114,7 @@ static void dm_bio_destructor(struct bio *bio)
 }
 
 /*
- * Creates a little bio that is just does part of a bvec.
+ * Creates a little bio that just does part of a bvec.
  */
 static struct bio *split_bvec(struct bio *bio, sector_t sector,
 			      unsigned short idx, unsigned int offset,
@@ -1134,7 +1129,7 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 
 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw & ~REQ_HARDBARRIER;
+	clone->bi_rw = bio->bi_rw;
 	clone->bi_vcnt = 1;
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
@@ -1161,7 +1156,6 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 
 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_rw &= ~REQ_HARDBARRIER;
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1225,7 +1219,7 @@ static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
 		__issue_target_request(ci, ti, request_nr, len);
 }
 
-static int __clone_and_map_empty_barrier(struct clone_info *ci)
+static int __clone_and_map_flush(struct clone_info *ci)
 {
 	unsigned target_nr = 0;
 	struct dm_target *ti;
@@ -1289,9 +1283,6 @@ static int __clone_and_map(struct clone_info *ci)
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
-	if (unlikely(bio_empty_barrier(bio)))
-		return __clone_and_map_empty_barrier(ci);
-
 	if (unlikely(bio->bi_rw & REQ_DISCARD))
 		return __clone_and_map_discard(ci);
 
@@ -1383,11 +1374,11 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 
 	ci.map = dm_get_live_table(md);
 	if (unlikely(!ci.map)) {
-		if (!(bio->bi_rw & REQ_HARDBARRIER))
+		if (!(bio->bi_rw & REQ_FLUSH))
 			bio_io_error(bio);
 		else
-			if (!md->barrier_error)
-				md->barrier_error = -EIO;
+			if (!md->flush_error)
+				md->flush_error = -EIO;
 		return;
 	}
 
@@ -1400,14 +1391,22 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
-	ci.sector_count = bio_sectors(bio);
-	if (unlikely(bio_empty_barrier(bio)))
+	if (!(bio->bi_rw & REQ_FLUSH))
+		ci.sector_count = bio_sectors(bio);
+	else {
+		/* all FLUSH bio's reaching here should be empty */
+		WARN_ON_ONCE(bio_has_data(bio));
 		ci.sector_count = 1;
+	}
 	ci.idx = bio->bi_idx;
 
 	start_io_acct(ci.io);
-	while (ci.sector_count && !error)
-		error = __clone_and_map(&ci);
+	while (ci.sector_count && !error) {
+		if (!(bio->bi_rw & REQ_FLUSH))
+			error = __clone_and_map(&ci);
+		else
+			error = __clone_and_map_flush(&ci);
+	}
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
@@ -1492,11 +1491,11 @@ static int _dm_request(struct request_queue *q, struct bio *bio)
 	part_stat_unlock();
 
 	/*
-	 * If we're suspended or the thread is processing barriers
+	 * If we're suspended or the thread is processing flushes
 	 * we have to queue this io for later.
 	 */
 	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
-	    unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
+	    (bio->bi_rw & REQ_FLUSH)) {
 		up_read(&md->io_lock);
 
 		if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) &&
@@ -1940,6 +1939,7 @@ static void dm_init_md_queue(struct mapped_device *md)
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+	blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA);
 }
 
 /*
@@ -2245,7 +2245,8 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_flush(md->queue, REQ_FLUSH);
+	/* no flush support for request based dm yet */
+	blk_queue_flush(md->queue, 0);
 
 	elv_register_queue(md->queue);
 
@@ -2406,41 +2407,35 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 	return r;
 }
 
-static void dm_flush(struct mapped_device *md)
+static void process_flush(struct mapped_device *md, struct bio *bio)
 {
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-
-	bio_init(&md->barrier_bio);
-	md->barrier_bio.bi_bdev = md->bdev;
-	md->barrier_bio.bi_rw = WRITE_BARRIER;
-	__split_and_process_bio(md, &md->barrier_bio);
+	md->flush_error = 0;
 
+	/* handle REQ_FLUSH */
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-}
 
-static void process_barrier(struct mapped_device *md, struct bio *bio)
-{
-	md->barrier_error = 0;
+	bio_init(&md->flush_bio);
+	md->flush_bio.bi_bdev = md->bdev;
+	md->flush_bio.bi_rw = WRITE_FLUSH;
+	__split_and_process_bio(md, &md->flush_bio);
 
-	dm_flush(md);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 
-	if (!bio_empty_barrier(bio)) {
-		__split_and_process_bio(md, bio);
-		/*
-		 * If the request isn't supported, don't waste time with
-		 * the second flush.
-		 */
-		if (md->barrier_error != -EOPNOTSUPP)
-			dm_flush(md);
+	/* if it's an empty flush or the preflush failed, we're done */
+	if (!bio_has_data(bio) || md->flush_error) {
+		if (md->flush_error != DM_ENDIO_REQUEUE)
+			bio_endio(bio, md->flush_error);
+		else {
+			spin_lock_irq(&md->deferred_lock);
+			bio_list_add_head(&md->deferred, bio);
+			spin_unlock_irq(&md->deferred_lock);
+		}
+		return;
 	}
 
-	if (md->barrier_error != DM_ENDIO_REQUEUE)
-		bio_endio(bio, md->barrier_error);
-	else {
-		spin_lock_irq(&md->deferred_lock);
-		bio_list_add_head(&md->deferred, bio);
-		spin_unlock_irq(&md->deferred_lock);
-	}
+	/* issue data + REQ_FUA */
+	bio->bi_rw &= ~REQ_FLUSH;
+	__split_and_process_bio(md, bio);
 }
 
 /*
@@ -2469,8 +2464,8 @@ static void dm_wq_work(struct work_struct *work)
 		if (dm_request_based(md))
 			generic_make_request(c);
 		else {
-			if (c->bi_rw & REQ_HARDBARRIER)
-				process_barrier(md, c);
+			if (c->bi_rw & REQ_FLUSH)
+				process_flush(md, c);
 			else
 				__split_and_process_bio(md, c);
 		}
-- 
1.7.1
