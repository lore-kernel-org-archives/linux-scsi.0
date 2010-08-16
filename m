From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Mon, 16 Aug 2010 18:52:03 +0200
Message-ID: <1281977523-19335-6-git-send-email-tj@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernle.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernle.org>

This patch converts dm to support REQ_FLUSH/FUA instead of now
deprecated REQ_HARDBARRIER.

For common parts,

* Barrier retry logic dropped from dm-io.

* Empty WRITE_BARRIERs are replaced with WRITE_FLUSHes.

* It's now guaranteed that all FLUSH bio's which are passed onto dm
  targets are zero length.  bio_empty_barrier() tests are replaced
  with REQ_FLUSH tests.

* Dropped unlikely() around REQ_FLUSH tests.  Flushes are not unlikely
  enough to be marked with unlikely().

For bio-based dm,

* Preflush is handled as before but postflush is dropped and replaced
  with passing down REQ_FUA to member request_queues.  This replaces
  one array wide cache flush w/ member specific FUA writes.

* __split_and_process_bio() now calls __clone_and_map_flush() directly
  for flushes and guarantees all FLUSH bio's going to targets are zero
  length.

* -EOPNOTSUPP retry logic dropped.

For request-based dm,

* Nothing much changes.  It just needs to handle FLUSH requests as
  before.  It would be beneficial to advertise FUA capability so that
  it can propagate FUA flags down to member request_queues instead of
  sequencing it as WRITE + FLUSH at the top queue.

Lightly tested linear, stripe, raid1, snap and crypt targets.  Please
proceed with caution as I'm not familiar with the code base.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c           |    2 +-
 drivers/md/dm-io.c              |   20 +----
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-raid1.c           |    8 +-
 drivers/md/dm-region-hash.c     |   16 ++--
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/dm-snap.c            |    6 +-
 drivers/md/dm-stripe.c          |    2 +-
 drivers/md/dm.c                 |  180 +++++++++++++++++++-------------------
 9 files changed, 113 insertions(+), 125 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3bdbb61..da11652 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1249,7 +1249,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
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
index 7413626..af33245 100644
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
index c097d8a..b9048f0 100644
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
index 5485377..62a6586 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1581,7 +1581,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		bio->bi_bdev = s->cow->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
@@ -1685,7 +1685,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		if (!map_context->flush_request)
 			bio->bi_bdev = s->origin->bdev;
 		else
@@ -2123,7 +2123,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio->bi_rw & REQ_FLUSH)
 		return DM_MAPIO_REMAPPED;
 
 	/* Only tell snapshots if this is a write */
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index d6e28d7..0f534ca 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -214,7 +214,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
 	sector_t offset, chunk;
 	uint32_t stripe;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		BUG_ON(map_context->flush_request >= sc->stripes);
 		bio->bi_bdev = sc->stripe[map_context->flush_request].dev->bdev;
 		return DM_MAPIO_REMAPPED;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b71cc9e..13e5707 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -139,21 +139,21 @@ struct mapped_device {
 	spinlock_t deferred_lock;
 
 	/*
-	 * An error from the barrier request currently being processed.
+	 * An error from the flush request currently being processed.
 	 */
-	int barrier_error;
+	int flush_error;
 
 	/*
-	 * Protect barrier_error from concurrent endio processing
+	 * Protect flush_error from concurrent endio processing
 	 * in request-based dm.
 	 */
-	spinlock_t barrier_error_lock;
+	spinlock_t flush_error_lock;
 
 	/*
-	 * Processing queue (flush/barriers)
+	 * Processing queue (flush)
 	 */
 	struct workqueue_struct *wq;
-	struct work_struct barrier_work;
+	struct work_struct flush_work;
 
 	/* A pointer to the currently processing pre/post flush request */
 	struct request *flush_request;
@@ -195,8 +195,8 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;
 
-	/* zero-length barrier that will be cloned and submitted to targets */
-	struct bio barrier_bio;
+	/* zero-length flush that will be cloned and submitted to targets */
+	struct bio flush_bio;
 };
 
 /*
@@ -507,7 +507,7 @@ static void end_io_acct(struct dm_io *io)
 
 	/*
 	 * After this is decremented the bio must not be touched if it is
-	 * a barrier.
+	 * a flush.
 	 */
 	dm_disk(md)->part0.in_flight[rw] = pending =
 		atomic_dec_return(&md->pending[rw]);
@@ -621,7 +621,7 @@ static void dec_pending(struct dm_io *io, int error)
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
 			if (__noflush_suspending(md)) {
-				if (!(io->bio->bi_rw & REQ_HARDBARRIER))
+				if (!(io->bio->bi_rw & REQ_FLUSH))
 					bio_list_add_head(&md->deferred,
 							  io->bio);
 			} else
@@ -633,14 +633,14 @@ static void dec_pending(struct dm_io *io, int error)
 		io_error = io->error;
 		bio = io->bio;
 
-		if (bio->bi_rw & REQ_HARDBARRIER) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			/*
-			 * There can be just one barrier request so we use
+			 * There can be just one flush request so we use
 			 * a per-device variable for error reporting.
 			 * Note that you can't touch the bio after end_io_acct
 			 */
-			if (!md->barrier_error && io_error != -EOPNOTSUPP)
-				md->barrier_error = io_error;
+			if (!md->flush_error)
+				md->flush_error = io_error;
 			end_io_acct(io);
 			free_io(md, io);
 		} else {
@@ -744,21 +744,18 @@ static void end_clone_bio(struct bio *clone, int error)
 	blk_update_request(tio->orig, 0, nr_bytes);
 }
 
-static void store_barrier_error(struct mapped_device *md, int error)
+static void store_flush_error(struct mapped_device *md, int error)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&md->barrier_error_lock, flags);
+	spin_lock_irqsave(&md->flush_error_lock, flags);
 	/*
-	 * Basically, the first error is taken, but:
-	 *   -EOPNOTSUPP supersedes any I/O error.
-	 *   Requeue request supersedes any I/O error but -EOPNOTSUPP.
+	 * Basically, the first error is taken, but requeue request
+	 * supersedes any I/O error.
 	 */
-	if (!md->barrier_error || error == -EOPNOTSUPP ||
-	    (md->barrier_error != -EOPNOTSUPP &&
-	     error == DM_ENDIO_REQUEUE))
-		md->barrier_error = error;
-	spin_unlock_irqrestore(&md->barrier_error_lock, flags);
+	if (!md->flush_error || error == DM_ENDIO_REQUEUE)
+		md->flush_error = error;
+	spin_unlock_irqrestore(&md->flush_error_lock, flags);
 }
 
 /*
@@ -799,12 +796,12 @@ static void dm_end_request(struct request *clone, int error)
 {
 	int rw = rq_data_dir(clone);
 	int run_queue = 1;
-	bool is_barrier = clone->cmd_flags & REQ_HARDBARRIER;
+	bool is_flush = clone->cmd_flags & REQ_FLUSH;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_barrier) {
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_flush) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;
 
@@ -819,9 +816,9 @@ static void dm_end_request(struct request *clone, int error)
 
 	free_rq_clone(clone);
 
-	if (unlikely(is_barrier)) {
+	if (is_flush) {
 		if (unlikely(error))
-			store_barrier_error(md, error);
+			store_flush_error(md, error);
 		run_queue = 0;
 	} else
 		blk_end_request_all(rq, error);
@@ -851,9 +848,9 @@ void dm_requeue_unmapped_request(struct request *clone)
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.
+		 * Flush clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
 		 * case.
 		 */
@@ -950,14 +947,14 @@ static void dm_complete_request(struct request *clone, int error)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.  So can't use
+		 * Flush clones share an original request.  So can't use
 		 * softirq_done with the original.
 		 * Pass the clone to dm_done() directly in this special case.
 		 * It is safe (even if clone->q->queue_lock is held here)
 		 * because there is no I/O dispatching during the completion
-		 * of barrier clone.
+		 * of flush clone.
 		 */
 		dm_done(clone, error, true);
 		return;
@@ -979,9 +976,9 @@ void dm_kill_unmapped_request(struct request *clone, int error)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_FLUSH) {
 		/*
-		 * Barrier clones share an original request.
+		 * Flush clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
 		 * case.
 		 */
@@ -1098,7 +1095,7 @@ static void dm_bio_destructor(struct bio *bio)
 }
 
 /*
- * Creates a little bio that is just does part of a bvec.
+ * Creates a little bio that just does part of a bvec.
  */
 static struct bio *split_bvec(struct bio *bio, sector_t sector,
 			      unsigned short idx, unsigned int offset,
@@ -1113,7 +1110,7 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 
 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw & ~REQ_HARDBARRIER;
+	clone->bi_rw = bio->bi_rw;
 	clone->bi_vcnt = 1;
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
@@ -1140,7 +1137,6 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 
 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_rw &= ~REQ_HARDBARRIER;
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1186,7 +1182,7 @@ static void __flush_target(struct clone_info *ci, struct dm_target *ti,
 	__map_bio(ti, clone, tio);
 }
 
-static int __clone_and_map_empty_barrier(struct clone_info *ci)
+static int __clone_and_map_flush(struct clone_info *ci)
 {
 	unsigned target_nr = 0, flush_nr;
 	struct dm_target *ti;
@@ -1208,9 +1204,6 @@ static int __clone_and_map(struct clone_info *ci)
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
-	if (unlikely(bio_empty_barrier(bio)))
-		return __clone_and_map_empty_barrier(ci);
-
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
 		return -EIO;
@@ -1308,11 +1301,11 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 
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
 
@@ -1325,14 +1318,22 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
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
@@ -1417,11 +1418,11 @@ static int _dm_request(struct request_queue *q, struct bio *bio)
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
@@ -1520,7 +1521,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 	if (dm_rq_is_flush_request(rq)) {
 		blk_rq_init(NULL, clone);
 		clone->cmd_type = REQ_TYPE_FS;
-		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
+		clone->cmd_flags |= (REQ_FLUSH | WRITE);
 	} else {
 		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 				      dm_rq_bio_constructor, tio);
@@ -1664,11 +1665,11 @@ static void dm_request_fn(struct request_queue *q)
 		if (!rq)
 			goto plug_and_out;
 
-		if (unlikely(dm_rq_is_flush_request(rq))) {
+		if (dm_rq_is_flush_request(rq)) {
 			BUG_ON(md->flush_request);
 			md->flush_request = rq;
 			blk_start_request(rq);
-			queue_work(md->wq, &md->barrier_work);
+			queue_work(md->wq, &md->flush_work);
 			goto out;
 		}
 
@@ -1843,7 +1844,7 @@ out:
 static const struct block_device_operations dm_blk_dops;
 
 static void dm_wq_work(struct work_struct *work);
-static void dm_rq_barrier_work(struct work_struct *work);
+static void dm_rq_flush_work(struct work_struct *work);
 
 /*
  * Allocate and initialise a blank device with a given minor.
@@ -1873,7 +1874,7 @@ static struct mapped_device *alloc_dev(int minor)
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->deferred_lock);
-	spin_lock_init(&md->barrier_error_lock);
+	spin_lock_init(&md->flush_error_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1918,7 +1919,7 @@ static struct mapped_device *alloc_dev(int minor)
 	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
-	INIT_WORK(&md->barrier_work, dm_rq_barrier_work);
+	INIT_WORK(&md->flush_work, dm_rq_flush_work);
 	init_waitqueue_head(&md->eventq);
 
 	md->disk->major = _major;
@@ -2233,36 +2234,35 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
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
-		dm_flush(md);
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
@@ -2291,8 +2291,8 @@ static void dm_wq_work(struct work_struct *work)
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
@@ -2317,8 +2317,8 @@ static void dm_rq_set_flush_nr(struct request *clone, unsigned flush_nr)
 	tio->info.flush_request = flush_nr;
 }
 
-/* Issue barrier requests to targets and wait for their completion. */
-static int dm_rq_barrier(struct mapped_device *md)
+/* Issue flush requests to targets and wait for their completion. */
+static int dm_rq_flush(struct mapped_device *md)
 {
 	int i, j;
 	struct dm_table *map = dm_get_live_table(md);
@@ -2326,7 +2326,7 @@ static int dm_rq_barrier(struct mapped_device *md)
 	struct dm_target *ti;
 	struct request *clone;
 
-	md->barrier_error = 0;
+	md->flush_error = 0;
 
 	for (i = 0; i < num_targets; i++) {
 		ti = dm_table_get_target(map, i);
@@ -2341,26 +2341,26 @@ static int dm_rq_barrier(struct mapped_device *md)
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 	dm_table_put(map);
 
-	return md->barrier_error;
+	return md->flush_error;
 }
 
-static void dm_rq_barrier_work(struct work_struct *work)
+static void dm_rq_flush_work(struct work_struct *work)
 {
 	int error;
 	struct mapped_device *md = container_of(work, struct mapped_device,
-						barrier_work);
+						flush_work);
 	struct request_queue *q = md->queue;
 	struct request *rq;
 	unsigned long flags;
 
 	/*
 	 * Hold the md reference here and leave it at the last part so that
-	 * the md can't be deleted by device opener when the barrier request
+	 * the md can't be deleted by device opener when the flush request
 	 * completes.
 	 */
 	dm_get(md);
 
-	error = dm_rq_barrier(md);
+	error = dm_rq_flush(md);
 
 	rq = md->flush_request;
 	md->flush_request = NULL;
@@ -2520,7 +2520,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	up_write(&md->io_lock);
 
 	/*
-	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
+	 * Request-based dm uses md->wq for flush (dm_rq_flush_work) which
 	 * can be kicked until md->queue is stopped.  So stop md->queue before
 	 * flushing md->wq.
 	 */
-- 
1.7.1

