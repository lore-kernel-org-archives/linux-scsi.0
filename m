From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 5/8] dm core: add core functions for
	request-based dm
Date: Fri, 03 Oct 2008 11:18:42 -0400 (EDT)
Message-ID: <20081003.111842.112627383.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, mbroz@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds core functions for request-based dm.

When struct mapped device (md) is initialized as request-based,
md->queue has an I/O scheduler and the following functions are set:
    make_request_fn: __make_request() (existing block layer function)
    request_fn:      dm_request_fn()  (newly added function)
Actual initializations are done in another patch (PATCH 6).

Below is a brief summary of how request-based dm behaves, including:
  - making request from bio
  - cloning, mapping and dispatching request
  - completing request and bio
  - suspending md
  - resuming md


bio to request
==============
md->queue->make_request_fn() (__make_request()) is called for a bio
submitted to the md.
Then, the bio is kept in the queue as a new request or merged into
another request in the queue if possible.


Cloning and Mapping
===================
Cloning and mapping are done in md->queue->request_fn() (dm_request_fn()),
when requests are dispatched after they are sorted by the I/O scheduler.

dm_request_fn() checks busy state of underlying devices using
target's busy() function and stops dispatching requests to keep them
on the dm device's queue if busy.
It helps better I/O merging, since no merge is done for a request
once it is dispatched to underlying devices.

Actual cloning and mapping are done in dm_prep_fn() and map_request()
called from dm_request_fn().
dm_prep_fn() clones not only request but also bios of the request
so that dm can hold bio completion in error cases and prevent
the bio submitter from noticing the error.
(See the "Completion" section below for details.)

After the cloning, the clone is mapped by target's map_rq() function
and inserted to underlying device's queue using __elv_add_request().


Completion
==========
Request completion can be hooked by rq->end_io(), but then, all bios
in the request will have been completed even error cases, and the bio
submitter will have noticed the error.
To prevent the bio completion in error cases, request-based dm clones
both bio and request and hooks both bio->bi_end_io() and rq->end_io():
    bio->bi_end_io(): end_clone_bio()
    rq->end_io():     end_clone_request()

Summary of the request completion flow is below:
blk_end_request() for a clone request
  => __end_that_request_first()
     => bio->bi_end_io() == end_clone_bio() for each clone bio
        => Free the clone bio
        => Success: Complete the original bio (blk_update_request())
           Error:   Don't complete the original bio
  => end_that_request_last()
     => rq->end_io() == end_clone_request()
        => blk_complete_request()
           => dm_softirq_done()
              => Free the clone request
              => Success: Complete the original request (blk_end_request())
                 Error:   Requeue the original request

end_clone_bio() completes the original request on the size of
the original bio in successful cases.
Even if all bios in the original request are completed by that
completion, the original request must not be completed yet to keep
the ordering of request completion for the stacking.
So end_clone_bio() uses blk_update_request() instead of
blk_end_request().
In error cases, end_clone_bio() doesn't complete the original bio.
It just frees the cloned bio and gives over the error handling to
end_clone_request().

end_clone_request(), which is called with queue lock held, completes
the clone request and the original request in a softirq context
(dm_softirq_done()), which has no queue lock, to avoid a deadlock
issue on submission of another request during the completion:
    - The submitted request may be mapped to the same device
    - Request submission requires queue lock, but the queue lock
      has been held by itself and it doesn't know that

The clone request has no clone bio when dm_softirq_done() is called.
So target drivers can't resubmit it again even error cases.
Instead, they can ask dm core for requeueing and remapping
the original request in that cases.


suspend
=======
Request-based dm uses stopping md->queue as suspend of the md.
For noflush suspend, just stops md->queue.

For flush suspend, inserts a marker request to the tail of md->queue.
And dispatches all requests in md->queue until the marker comes to
the front of md->queue.  Then, stops dispatching request and waits
for the all dispatched requests to be completed.
After that, completes the marker request, stops md->queue and
wake up the waiter on the suspend queue, md->wait.


resume
======
Starts md->queue.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c         |   14 
 drivers/md/dm.c               |  714 +++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |    2 
 include/linux/device-mapper.h |    8 
 4 files changed, 734 insertions(+), 4 deletions(-)

Index: 2.6.27-rc8/drivers/md/dm.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.c
+++ 2.6.27-rc8/drivers/md/dm.c
@@ -86,6 +86,14 @@ union map_info *dm_get_mapinfo(struct bi
 	return NULL;
 }
 
+union map_info *dm_get_rq_mapinfo(struct request *rq)
+{
+	if (rq && rq->end_io_data)
+		return &((struct dm_rq_target_io *)rq->end_io_data)->info;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
+
 #define MINOR_ALLOCED ((void *)-1)
 
 /*
@@ -169,6 +177,12 @@ struct mapped_device {
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
+
+	/* marker of flush suspend for request-based dm */
+	struct request suspend_rq;
+
+	/* For saving the address of __make_request for request based dm */
+	make_request_fn *saved_make_request_fn;
 };
 
 #define MIN_IOS 256
@@ -416,6 +430,28 @@ static void free_tio(struct mapped_devic
 	mempool_free(tio, md->tio_pool);
 }
 
+static inline struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md)
+{
+	return mempool_alloc(md->tio_pool, GFP_ATOMIC);
+}
+
+static inline void free_rq_tio(struct mapped_device *md,
+			       struct dm_rq_target_io *tio)
+{
+	mempool_free(tio, md->tio_pool);
+}
+
+static inline struct dm_clone_bio_info *alloc_bio_info(struct mapped_device *md)
+{
+	return mempool_alloc(md->io_pool, GFP_ATOMIC);
+}
+
+static inline void free_bio_info(struct mapped_device *md,
+				 struct dm_clone_bio_info *info)
+{
+	mempool_free(info, md->io_pool);
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
@@ -604,6 +640,266 @@ static void clone_endio(struct bio *bio,
 	free_tio(md, tio);
 }
 
+/*
+ * Partial completion handling for request-based dm
+ */
+static void end_clone_bio(struct bio *clone, int error)
+{
+	struct dm_clone_bio_info *info = clone->bi_private;
+	struct dm_rq_target_io *tio = info->rq->end_io_data;
+	struct bio *bio = info->orig;
+	unsigned int nr_bytes = info->orig->bi_size;
+
+	free_bio_info(tio->md, info);
+	clone->bi_private = tio->md->bs;
+	bio_put(clone);
+
+	if (tio->error) {
+		/*
+		 * An error has already been detected on the request.
+		 * Once error occurred, just let clone->end_io() handle
+		 * the remainder.
+		 */
+		return;
+	} else if (error) {
+		/*
+		 * Don't notice the error to the upper layer yet.
+		 * The error handling decision is made by the target driver,
+		 * when the request is completed.
+		 */
+		tio->error = error;
+		return;
+	}
+
+	/*
+	 * I/O for the bio successfully completed.
+	 * Notice the data completion to the upper layer.
+	 */
+
+	/*
+	 * bios are processed from the head of the list.
+	 * So the completing bio should always be rq->bio.
+	 * If it's not, something wrong is happening.
+	 */
+	if (tio->orig->bio != bio)
+		DMERR("bio completion is going in the middle of the request");
+
+	/*
+	 * Update the original request.
+	 * Do not use blk_end_request() here, because it may complete
+	 * the original request before the clone, and break the ordering.
+	 */
+	blk_update_request(tio->orig, 0, nr_bytes);
+}
+
+static void free_bio_clone(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct bio *bio;
+	struct dm_clone_bio_info *info;
+
+	while ((bio = clone->bio) != NULL) {
+		clone->bio = bio->bi_next;
+
+		info = bio->bi_private;
+		free_bio_info(md, info);
+
+		bio->bi_private = md->bs;
+		bio_put(bio);
+	}
+}
+
+static void dec_rq_pending(struct dm_rq_target_io *tio)
+{
+	if (!atomic_dec_return(&tio->md->pending))
+		/* nudge anyone waiting on suspend queue */
+		wake_up(&tio->md->wait);
+}
+
+static void dm_unprep_request(struct request *rq)
+{
+	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	rq->special = NULL;
+	rq->cmd_flags &= ~REQ_DONTPREP;
+
+	free_bio_clone(clone);
+	dec_rq_pending(tio);
+	free_rq_tio(tio->md, tio);
+}
+
+/*
+ * Requeue the original request of a clone.
+ */
+void dm_requeue_request(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+	struct request_queue *q = rq->q;
+	unsigned long flags;
+
+	dm_unprep_request(rq);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (elv_queue_empty(q))
+		blk_plug_device(q);
+	blk_requeue_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_requeue_request);
+
+static inline void __stop_queue(struct request_queue *q)
+{
+	blk_stop_queue(q);
+}
+
+static void stop_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static inline void __start_queue(struct request_queue *q)
+{
+	if (blk_queue_stopped(q))
+		blk_start_queue(q);
+}
+
+static void start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/*
+ * Complete the clone and the original request
+ */
+static void dm_end_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+	struct request_queue *q = rq->q;
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+
+	if (blk_pc_request(rq)) {
+		rq->errors = clone->errors;
+		rq->data_len = clone->data_len;
+
+		if (rq->sense)
+			/*
+			 * We are using the sense buffer of the original
+			 * request.
+			 * So setting the length of the sense data is enough.
+			 */
+			rq->sense_len = clone->sense_len;
+	}
+
+	free_bio_clone(clone);
+	dec_rq_pending(tio);
+	free_rq_tio(tio->md, tio);
+
+	if (unlikely(blk_end_request(rq, error, nr_bytes)))
+		BUG();
+
+	blk_run_queue(q);
+}
+
+/*
+ * Request completion handler for request-based dm
+ */
+static void dm_softirq_done(struct request *rq)
+{
+	struct request *clone = rq->completion_data;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+	int error = tio->error;
+	int r;
+
+	if (rq->cmd_flags & REQ_FAILED)
+		goto end_request;
+
+	if (rq_end_io) {
+		r = rq_end_io(tio->ti, clone, error, &tio->info);
+		if (r <= 0)
+			/* The target wants to complete the I/O */
+			error = r;
+		else if (r == DM_ENDIO_INCOMPLETE)
+			/* The target will handle the I/O */
+			return;
+		else if (r == DM_ENDIO_REQUEUE) {
+			/*
+			 * The target wants to requeue the I/O.
+			 * Don't invoke blk_run_queue() so that the requeued
+			 * request won't be dispatched again soon.
+			 */
+			dm_requeue_request(clone);
+			return;
+		} else {
+			DMWARN("unimplemented target endio return value: %d",
+			       r);
+			BUG();
+		}
+	}
+
+end_request:
+	dm_end_request(clone, error);
+}
+
+/*
+ * Called with the queue lock held
+ */
+static void end_clone_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+
+	/*
+	 * For just cleaning up the information of the queue in which
+	 * the clone was dispatched.
+	 * The clone is *NOT* freed actually here because it is alloced from
+	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
+	 */
+	__blk_put_request(clone->q, clone);
+
+	/*
+	 * Actual request completion is done in a softirq context which doesn't
+	 * hold the queue lock.  Otherwise, deadlock could occur because:
+	 *     - another request may be submitted by the upper level driver
+	 *       of the stacking during the completion
+	 *     - the submission which requires queue lock may be done
+	 *       against this queue
+	 */
+	tio->error = error;
+	rq->completion_data = clone;
+	blk_complete_request(rq);
+}
+
+/*
+ * Complete the original request of a clone with an error status.
+ * Target's rq_end_io() function isn't called.
+ * This may be used by target's map_rq() function when the mapping fails.
+ */
+void dm_kill_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+
+	tio->error = error;
+	/* Avoid printing "I/O error" message, since we didn't I/O actually */
+	rq->cmd_flags |= (REQ_FAILED | REQ_QUIET);
+	rq->completion_data = clone;
+	blk_complete_request(rq);
+}
+EXPORT_SYMBOL_GPL(dm_kill_request);
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -922,7 +1218,7 @@ out:
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static int dm_request(struct request_queue *q, struct bio *bio)
+static int _dm_request(struct request_queue *q, struct bio *bio)
 {
 	int r = -EIO;
 	int rw = bio_data_dir(bio);
@@ -972,12 +1268,311 @@ out_req:
 	return 0;
 }
 
+static int dm_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = (struct mapped_device *)q->queuedata;
+
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
+	if (unlikely(!md->map)) {
+		bio_endio(bio, -EIO);
+		return 0;
+	}
+
+	return md->saved_make_request_fn(q, bio); /* call __make_request() */
+}
+
+static inline int dm_request_based(struct mapped_device *md)
+{
+	return blk_queue_stackable(md->queue);
+}
+
+static int dm_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = q->queuedata;
+
+	if (dm_request_based(md))
+		return dm_make_request(q, bio);
+
+	return _dm_request(q, bio);
+}
+
+void dm_dispatch_request(struct request *rq)
+{
+	int r;
+
+	rq->start_time = jiffies;
+	r = blk_insert_cloned_request(rq->q, rq);
+	if (r)
+		dm_kill_request(rq, r);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static void copy_request_info(struct request *clone, struct request *rq)
+{
+	clone->cmd_flags = (rq_data_dir(rq) | REQ_NOMERGE);
+	clone->cmd_type = rq->cmd_type;
+	clone->sector = rq->sector;
+	clone->hard_sector = rq->hard_sector;
+	clone->nr_sectors = rq->nr_sectors;
+	clone->hard_nr_sectors = rq->hard_nr_sectors;
+	clone->current_nr_sectors = rq->current_nr_sectors;
+	clone->hard_cur_sectors = rq->hard_cur_sectors;
+	clone->nr_phys_segments = rq->nr_phys_segments;
+	clone->ioprio = rq->ioprio;
+	clone->buffer = rq->buffer;
+	clone->cmd_len = rq->cmd_len;
+	if (rq->cmd_len)
+		clone->cmd = rq->cmd;
+	clone->data_len = rq->data_len;
+	clone->extra_len = rq->extra_len;
+	clone->sense_len = rq->sense_len;
+	clone->data = rq->data;
+	clone->sense = rq->sense;
+}
+
+static int clone_request_bios(struct request *clone, struct request *rq,
+			      struct mapped_device *md)
+{
+	struct bio *bio, *clone_bio;
+	struct dm_clone_bio_info *info;
+
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		info = alloc_bio_info(md);
+		if (!info)
+			goto free_and_out;
+
+		clone_bio = bio_alloc_bioset(GFP_ATOMIC, bio->bi_max_vecs,
+					     md->bs);
+		if (!clone_bio) {
+			free_bio_info(md, info);
+			goto free_and_out;
+		}
+
+		__bio_clone(clone_bio, bio);
+		clone_bio->bi_destructor = dm_bio_destructor;
+		clone_bio->bi_end_io = end_clone_bio;
+		info->rq = clone;
+		info->orig = bio;
+		clone_bio->bi_private = info;
+
+		if (clone->bio) {
+			clone->biotail->bi_next = clone_bio;
+			clone->biotail = clone_bio;
+		} else
+			clone->bio = clone->biotail = clone_bio;
+	}
+
+	return 0;
+
+free_and_out:
+	free_bio_clone(clone);
+
+	return -ENOMEM;
+}
+
+static int setup_clone(struct request *clone, struct request *rq,
+		       struct dm_rq_target_io *tio)
+{
+	int r;
+
+	blk_rq_init(NULL, clone);
+
+	r = clone_request_bios(clone, rq, tio->md);
+	if (r)
+		return r;
+
+	copy_request_info(clone, rq);
+	clone->start_time = jiffies;
+	clone->end_io = end_clone_request;
+	clone->end_io_data = tio;
+
+	return 0;
+}
+
+static inline int dm_flush_suspending(struct mapped_device *md)
+{
+	return !md->suspend_rq.data;
+}
+
+/*
+ * Called with the queue lock held.
+ */
+static int dm_prep_fn(struct request_queue *q, struct request *rq)
+{
+	struct mapped_device *md = (struct mapped_device *)q->queuedata;
+	struct dm_rq_target_io *tio;
+	struct request *clone;
+
+	if (unlikely(rq == &md->suspend_rq)) { /* Flush suspend marker */
+		if (dm_flush_suspending(md)) {
+			if (q->in_flight)
+				return BLKPREP_DEFER;
+			else {
+				/* This device should be quiet now */
+				__stop_queue(q);
+				smp_mb();
+				BUG_ON(atomic_read(&md->pending));
+				wake_up(&md->wait);
+				return BLKPREP_KILL;
+			}
+		} else
+			/*
+			 * The suspend process was interrupted.
+			 * So no need to suspend now.
+			 */
+			return BLKPREP_KILL;
+	}
+
+	if (unlikely(rq->special)) {
+		DMWARN("Already has something in rq->special.");
+		return BLKPREP_KILL;
+	}
+
+	if (unlikely(!dm_request_based(md))) {
+		DMWARN("Request was queued into bio-based device");
+		return BLKPREP_KILL;
+	}
+
+	tio = alloc_rq_tio(md); /* Only one for each original request */
+	if (!tio)
+		/* -ENOMEM */
+		return BLKPREP_DEFER;
+
+	tio->md = md;
+	tio->ti = NULL;
+	tio->orig = rq;
+	tio->error = 0;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = &tio->clone;
+	if (setup_clone(clone, rq, tio)) {
+		/* -ENOMEM */
+		free_rq_tio(md, tio);
+		return BLKPREP_DEFER;
+	}
+
+	rq->special = clone;
+	rq->cmd_flags |= REQ_DONTPREP;
+
+	return BLKPREP_OK;
+}
+
+static void map_request(struct dm_target *ti, struct request *rq,
+			struct mapped_device *md)
+{
+	int r;
+	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	tio->ti = ti;
+	atomic_inc(&md->pending);
+	r = ti->type->map_rq(ti, clone, &tio->info);
+	switch (r) {
+	case DM_MAPIO_SUBMITTED:
+		/* The target has taken the I/O to submit by itself later */
+		break;
+	case DM_MAPIO_REMAPPED:
+		/* The target has remapped the I/O so dispatch it */
+		dm_dispatch_request(clone);
+		break;
+	case DM_MAPIO_REQUEUE:
+		/* The target wants to requeue the I/O */
+		dm_requeue_request(clone);
+		break;
+	default:
+		if (r > 0) {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		/* The target wants to complete the I/O */
+		dm_kill_request(clone, r);
+		break;
+	}
+}
+
+/*
+ * q->request_fn for request-based dm.
+ * Called with the queue lock held.
+ */
+static void dm_request_fn(struct request_queue *q)
+{
+	struct mapped_device *md = (struct mapped_device *)q->queuedata;
+	struct dm_table *map = dm_get_table(md);
+	struct dm_target *ti;
+	struct request *rq;
+
+	/*
+	 * The check for blk_queue_stopped() needs here, because:
+	 *     - device suspend uses blk_stop_queue() and expects that
+	 *       no I/O will be dispatched any more after the queue stop
+	 *     - generic_unplug_device() doesn't call q->request_fn()
+	 *       when the queue is stopped, so no problem
+	 *     - but underlying device drivers may call q->request_fn()
+	 *       without the check through blk_run_queue()
+	 */
+	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
+		rq = elv_next_request(q);
+		if (!rq)
+			goto plug_and_out;
+
+		ti = dm_table_find_target(map, rq->sector);
+		if (ti->type->busy && ti->type->busy(ti))
+			goto plug_and_out;
+
+		blkdev_dequeue_request(rq);
+		spin_unlock(q->queue_lock);
+		map_request(ti, rq, md);
+		spin_lock_irq(q->queue_lock);
+	}
+
+	goto out;
+
+plug_and_out:
+	if (!elv_queue_empty(q))
+		/* Some requests still remain, retry later */
+		blk_plug_device(q);
+
+out:
+	dm_table_put(map);
+
+	return;
+}
+
+int dm_underlying_device_busy(struct request_queue *q)
+{
+	return blk_lld_busy(q);
+}
+EXPORT_SYMBOL_GPL(dm_underlying_device_busy);
+
+static int dm_lld_busy(struct request_queue *q)
+{
+	int r;
+	struct mapped_device *md = q->queuedata;
+	struct dm_table *map = dm_get_table(md);
+
+	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
+		r = 1;
+	else
+		r = dm_table_any_busy_target(map);
+
+	dm_table_put(map);
+	return r;
+}
+
 static void dm_unplug_all(struct request_queue *q)
 {
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_table(md);
 
 	if (map) {
+		if (dm_request_based(md))
+			generic_unplug_device(q);
+
 		dm_table_unplug_all(map);
 		dm_table_put(map);
 	}
@@ -991,6 +1586,12 @@ static int dm_any_congested(void *conges
 
 	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
 		r = bdi_bits;
+	else if (dm_request_based(md))
+		/*
+		 * Request-based dm cares about only own queue for
+		 * the query about congestion status of request_queue
+		 */
+		r = md->queue->backing_dev_info.state & bdi_bits;
 	else
 		r = dm_table_any_congested(map, bdi_bits);
 
@@ -1382,7 +1983,11 @@ static int dm_wait_for_completion(struct
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		smp_mb();
-		if (!atomic_read(&md->pending))
+		if (dm_request_based(md)) {
+			if (!atomic_read(&md->pending) &&
+			    blk_queue_stopped(md->queue))
+				break;
+		} else if (!atomic_read(&md->pending))
 			break;
 
 		if (signal_pending(current)) {
@@ -1484,6 +2089,88 @@ out:
 	return r;
 }
 
+static inline void dm_invalidate_flush_suspend(struct mapped_device *md)
+{
+	md->suspend_rq.data = (void *)0x1;
+}
+
+static void dm_abort_suspend(struct mapped_device *md, int noflush)
+{
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	/*
+	 * For flush suspend, invalidation and queue restart must be protected
+	 * by a single queue lock to prevent a race with dm_prep_fn().
+	 */
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (!noflush)
+		dm_invalidate_flush_suspend(md);
+	__start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/*
+ * Additional suspend work for request-based dm.
+ *
+ * In request-based dm, stopping request_queue prevents mapping.
+ * Even after stopping the request_queue, submitted requests from upper-layer
+ * can be inserted to the request_queue.  So original (unmapped) requests are
+ * kept in the request_queue during suspension.
+ */
+static void dm_start_suspend(struct mapped_device *md, int noflush)
+{
+	struct request *rq = &md->suspend_rq;
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	if (noflush) {
+		stop_queue(q);
+		return;
+	}
+
+	/*
+	 * For flush suspend, we need a marker to indicate the border line
+	 * between flush needed I/Os and deferred I/Os, since all I/Os are
+	 * queued in the request_queue during suspension.
+	 *
+	 * This marker must be inserted after setting DMF_BLOCK_IO,
+	 * because dm_prep_fn() considers no DMF_BLOCK_IO to be
+	 * a suspend interruption.
+	 */
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (unlikely(rq->ref_count)) {
+		/*
+		 * This can happen when the previous suspend was interrupted,
+		 * the inserted suspend_rq for the previous suspend has still
+		 * been in the queue and this suspend has been invoked.
+		 *
+		 * We could re-insert the suspend_rq by deleting it from
+		 * the queue forcibly using list_del_init(&rq->queuelist).
+		 * But it would break the block-layer easily.
+		 * So we don't re-insert the suspend_rq again in such a case.
+		 * The suspend_rq should be already invalidated during
+		 * the previous suspend interruption, so just wait for it
+		 * to be completed.
+		 *
+		 * This suspend will never complete, so warn the user to
+		 * interrupt this suspend and retry later.
+		 */
+		BUG_ON(!rq->data);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+
+		DMWARN("Invalidating the previous suspend is still in"
+		       " progress.  This suspend will be never done."
+		       " Please interrupt this suspend and retry later.");
+		return;
+	}
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/* Now no user of the suspend_rq */
+	blk_rq_init(q, rq);
+	blk_insert_request(q, rq, 0, NULL);
+}
+
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -1582,6 +2269,9 @@ int dm_suspend(struct mapped_device *md,
 	add_wait_queue(&md->wait, &wait);
 	up_write(&md->io_lock);
 
+	if (dm_request_based(md))
+		dm_start_suspend(md, noflush);
+
 	/* unplug */
 	if (map)
 		dm_table_unplug_all(map);
@@ -1594,14 +2284,22 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 	remove_wait_queue(&md->wait, &wait);
 
-	if (noflush)
-		__merge_pushback_list(md);
+	if (noflush) {
+		if (dm_request_based(md))
+			/* All requeued requests are already in md->queue */
+			clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+		else
+			__merge_pushback_list(md);
+	}
 	up_write(&md->io_lock);
 
 	/* were we interrupted ? */
 	if (r < 0) {
 		dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
 
+		if (dm_request_based(md))
+			dm_abort_suspend(md, noflush);
+
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
 	}
@@ -1642,6 +2340,14 @@ int dm_resume(struct mapped_device *md)
 
 	dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
 
+	/*
+	 * Flushing deferred I/Os must be done after targets are resumed
+	 * so that mapping of targets can work correctly.
+	 * Request-based dm is queueing the deferred I/Os in its request_queue.
+	 */
+	if (dm_request_based(md))
+		start_queue(md->queue);
+
 	unlock_fs(md);
 
 	if (md->suspended_bdev) {
Index: 2.6.27-rc8/drivers/md/dm.h
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.h
+++ 2.6.27-rc8/drivers/md/dm.h
@@ -46,6 +46,7 @@ void dm_table_presuspend_targets(struct 
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
+int dm_table_any_busy_target(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
@@ -91,6 +92,7 @@ void dm_stripe_exit(void);
 
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 void dm_kobject_uevent(struct mapped_device *md);
 
Index: 2.6.27-rc8/drivers/md/dm-table.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm-table.c
+++ 2.6.27-rc8/drivers/md/dm-table.c
@@ -956,6 +956,20 @@ int dm_table_any_congested(struct dm_tab
 	return r;
 }
 
+int dm_table_any_busy_target(struct dm_table *t)
+{
+	int i;
+	struct dm_target *ti;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = t->targets + i;
+		if (ti->type->busy && ti->type->busy(ti))
+			return 1;
+	}
+
+	return 0;
+}
+
 void dm_table_unplug_all(struct dm_table *t)
 {
 	struct dm_dev_internal *dd;
Index: 2.6.27-rc8/include/linux/device-mapper.h
===================================================================
--- 2.6.27-rc8.orig/include/linux/device-mapper.h
+++ 2.6.27-rc8/include/linux/device-mapper.h
@@ -379,4 +379,12 @@ static inline unsigned long to_bytes(sec
 	return (n << SECTOR_SHIFT);
 }
 
+/*-----------------------------------------------------------------
+ * Helper for block layer and dm core operations
+ *---------------------------------------------------------------*/
+void dm_dispatch_request(struct request *rq);
+void dm_requeue_request(struct request *rq);
+void dm_kill_request(struct request *rq, int error);
+int dm_underlying_device_busy(struct request_queue *q);
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
