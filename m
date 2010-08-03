From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Tue, 3 Aug 2010 20:51:48 +0200
Message-ID: <20100803185148.GA12258@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz>
	<20100803184939.GA12198@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100803184939.GA12198@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.maso
List-Id: linux-scsi@vger.kernel.org

Adapt device-mapper to the new world order where even bio based devices
get simple REQ_FLUSH requests for cache flushes, and need to submit
them downwards for implementing barriers.

Note that I've removed the unlikely statements around the REQ_FLUSH
checks.  While these generally aren't as common as normal read/writes
they are common enough that statically mispredictim them is a really
bad idea.

Tested with simple linear LVM volumes only so far.


Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2010-08-03 20:26:49.629254174 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2010-08-03 20:36:59.279003929 +0200
@@ -1249,7 +1249,7 @@ static int crypt_map(struct dm_target *t
 	struct dm_crypt_io *io;
 	struct crypt_config *cc;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		cc = ti->private;
 		bio->bi_bdev = cc->dev->bdev;
 		return DM_MAPIO_REMAPPED;
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c	2010-08-03 20:26:49.641003999 +0200
+++ linux-2.6/drivers/md/dm-raid1.c	2010-08-03 20:36:59.280003649 +0200
@@ -629,7 +629,7 @@ static void do_write(struct mirror_set *
 	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE | (bio->bi_rw & WRITE_BARRIER),
+		.bi_rw = WRITE | (bio->bi_rw & (WRITE_BARRIER|REQ_FLUSH)),
 		.mem.type = DM_IO_BVEC,
 		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
 		.notify.fn = write_callback,
@@ -670,7 +670,7 @@ static void do_writes(struct mirror_set
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if (unlikely(bio_empty_barrier(bio))) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1199,12 +1199,14 @@ static int mirror_end_io(struct dm_targe
 	struct dm_bio_details *bd = NULL;
 	struct dm_raid1_read_record *read_record = map_context->ptr;
 
+	if (bio->bi_rw & REQ_FLUSH)
+		return error;
+
 	/*
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (likely(!bio_empty_barrier(bio)))
-			dm_rh_dec(ms->rh, map_context->ll);
+		dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
 
Index: linux-2.6/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-region-hash.c	2010-08-03 20:26:49.650023346 +0200
+++ linux-2.6/drivers/md/dm-region-hash.c	2010-08-03 20:36:59.285025649 +0200
@@ -399,7 +399,7 @@ void dm_rh_mark_nosync(struct dm_region_
 	region_t region = dm_rh_bio_to_region(rh, bio);
 	int recovering = 0;
 
-	if (bio_empty_barrier(bio)) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		rh->barrier_failure = 1;
 		return;
 	}
@@ -524,7 +524,7 @@ void dm_rh_inc_pending(struct dm_region_
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio_empty_barrier(bio))
+		if (bio->bi_rw & REQ_FLUSH)
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2010-08-03 20:26:49.656003091 +0200
+++ linux-2.6/drivers/md/dm-snap.c	2010-08-03 20:36:59.290023135 +0200
@@ -1581,7 +1581,7 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		bio->bi_bdev = s->cow->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
@@ -1685,7 +1685,7 @@ static int snapshot_merge_map(struct dm_
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		if (!map_context->flush_request)
 			bio->bi_bdev = s->origin->bdev;
 		else
@@ -2123,7 +2123,7 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio->bi_rw & REQ_FLUSH)
 		return DM_MAPIO_REMAPPED;
 
 	/* Only tell snapshots if this is a write */
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2010-08-03 20:26:49.663003301 +0200
+++ linux-2.6/drivers/md/dm-stripe.c	2010-08-03 20:36:59.295005744 +0200
@@ -214,7 +214,7 @@ static int stripe_map(struct dm_target *
 	sector_t offset, chunk;
 	uint32_t stripe;
 
-	if (unlikely(bio_empty_barrier(bio))) {
+	if (bio->bi_rw & REQ_FLUSH) {
 		BUG_ON(map_context->flush_request >= sc->stripes);
 		bio->bi_bdev = sc->stripe[map_context->flush_request].dev->bdev;
 		return DM_MAPIO_REMAPPED;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2010-08-03 20:26:49.676004139 +0200
+++ linux-2.6/drivers/md/dm.c	2010-08-03 20:36:59.301005325 +0200
@@ -633,7 +633,7 @@ static void dec_pending(struct dm_io *io
 		io_error = io->error;
 		bio = io->bio;
 
-		if (bio->bi_rw & REQ_HARDBARRIER) {
+		if (bio == &md->barrier_bio) {
 			/*
 			 * There can be just one barrier request so we use
 			 * a per-device variable for error reporting.
@@ -851,7 +851,7 @@ void dm_requeue_unmapped_request(struct
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_HARDBARRIER) {
 		/*
 		 * Barrier clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
@@ -950,7 +950,7 @@ static void dm_complete_request(struct r
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_HARDBARRIER) {
 		/*
 		 * Barrier clones share an original request.  So can't use
 		 * softirq_done with the original.
@@ -979,7 +979,7 @@ void dm_kill_unmapped_request(struct req
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
+	if (clone->cmd_flags & REQ_HARDBARRIER) {
 		/*
 		 * Barrier clones share an original request.
 		 * Leave it to dm_end_request(), which handles this special
@@ -1208,7 +1208,7 @@ static int __clone_and_map(struct clone_
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio->bi_rw & REQ_FLUSH)
 		return __clone_and_map_empty_barrier(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
@@ -1308,7 +1308,7 @@ static void __split_and_process_bio(stru
 
 	ci.map = dm_get_live_table(md);
 	if (unlikely(!ci.map)) {
-		if (!(bio->bi_rw & REQ_HARDBARRIER))
+		if (bio != &md->barrier_bio)
 			bio_io_error(bio);
 		else
 			if (!md->barrier_error)
@@ -1326,7 +1326,7 @@ static void __split_and_process_bio(stru
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
-	if (unlikely(bio_empty_barrier(bio)))
+	if (bio->bi_rw & REQ_FLUSH)
 		ci.sector_count = 1;
 	ci.idx = bio->bi_idx;
 
@@ -1421,7 +1421,7 @@ static int _dm_request(struct request_qu
 	 * we have to queue this io for later.
 	 */
 	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
-	    unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
+	    unlikely(bio->bi_rw & (REQ_HARDBARRIER|REQ_FLUSH))) {
 		up_read(&md->io_lock);
 
 		if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) &&
@@ -1462,14 +1462,6 @@ static int dm_request(struct request_que
 	return _dm_request(q, bio);
 }
 
-static bool dm_rq_is_flush_request(struct request *rq)
-{
-	if (rq->cmd_flags & REQ_FLUSH)
-		return true;
-	else
-		return false;
-}
-
 void dm_dispatch_request(struct request *rq)
 {
 	int r;
@@ -1517,10 +1509,10 @@ static int setup_clone(struct request *c
 {
 	int r;
 
-	if (dm_rq_is_flush_request(rq)) {
+	if (rq->cmd_flags & REQ_FLUSH) {
 		blk_rq_init(NULL, clone);
 		clone->cmd_type = REQ_TYPE_FS;
-		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
+		clone->cmd_flags |= (WRITE_SYNC | REQ_FLUSH);
 	} else {
 		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 				      dm_rq_bio_constructor, tio);
@@ -1573,7 +1565,7 @@ static int dm_prep_fn(struct request_que
 	struct mapped_device *md = q->queuedata;
 	struct request *clone;
 
-	if (unlikely(dm_rq_is_flush_request(rq)))
+	if (rq->cmd_flags & REQ_FLUSH)
 		return BLKPREP_OK;
 
 	if (unlikely(rq->special)) {
@@ -1664,7 +1656,7 @@ static void dm_request_fn(struct request
 		if (!rq)
 			goto plug_and_out;
 
-		if (unlikely(dm_rq_is_flush_request(rq))) {
+		if (rq->cmd_flags & REQ_FLUSH) {
 			BUG_ON(md->flush_request);
 			md->flush_request = rq;
 			blk_start_request(rq);
@@ -2239,7 +2231,7 @@ static void dm_flush(struct mapped_devic
 
 	bio_init(&md->barrier_bio);
 	md->barrier_bio.bi_bdev = md->bdev;
-	md->barrier_bio.bi_rw = WRITE_BARRIER;
+	md->barrier_bio.bi_rw = WRITE_SYNC | REQ_FLUSH;
 	__split_and_process_bio(md, &md->barrier_bio);
 
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
@@ -2250,19 +2242,8 @@ static void process_barrier(struct mappe
 	md->barrier_error = 0;
 
 	dm_flush(md);
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
+	__split_and_process_bio(md, bio);
+	dm_flush(md);
 }
 
 /*
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2010-08-03 20:32:11.951274008 +0200
+++ linux-2.6/include/linux/bio.h	2010-08-03 20:36:59.303005325 +0200
@@ -241,10 +241,6 @@ enum rq_flag_bits {
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_empty_barrier(bio) \
-	((bio->bi_rw & REQ_HARDBARRIER) && \
-	 !bio_has_data(bio) && \
-	 !(bio->bi_rw & REQ_DISCARD))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
Index: linux-2.6/drivers/md/dm-io.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-io.c	2010-08-03 20:26:49.685023485 +0200
+++ linux-2.6/drivers/md/dm-io.c	2010-08-03 20:36:59.308004417 +0200
@@ -364,7 +364,7 @@ static void dispatch_io(int rw, unsigned
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (rw & REQ_HARDBARRIER))
+		if (where[i].count || (rw & REQ_FLUSH))
 			do_region(rw, i, where + i, dp, io);
 	}
 
