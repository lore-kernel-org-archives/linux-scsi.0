From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 09/13] dm: add core functions
Date: Wed, 19 Mar 2008 18:10:54 -0500 (EST)
Message-ID: <20080319.181054.123924401.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds core functions for request-based dm.

When struct mapped device (md) is initialized as request-based,
md->queue has an I/O scheduler and the following functions are set:
    make_request_fn: __make_request() (existing block layer function)
    request_fn:      dm_request_fn()  (newly added function)
Actual initializations are done in another patch (PATCH#10).


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
target's congested() function and stops dispatching requests
to keep them on the dm device's queue if busy.
It helps better I/O merging, since no merge is done for a request
once it is dispatched to underlying devices.

Actual cloning and mapping are done in clone_and_map_request()
called from dm_request_fn().
clone_and_map_request() clones not only request but also bios
of the request so that dm can hold bio completion in error cases
and prevent the bio submitter from noticing the error.
(See the "Completion" section below for details.)

After the cloning, the clone is mapped by target's map_rq function
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


suspend/resume
==============
Stop md->queue at suspend time.
Start md->queue at resume time.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |  543 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h |    8 
 2 files changed, 548 insertions(+), 3 deletions(-)

Index: 2.6.25-rc5/drivers/md/dm.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.c
+++ 2.6.25-rc5/drivers/md/dm.c
@@ -80,6 +80,14 @@ union map_info *dm_get_mapinfo(struct bi
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
@@ -91,6 +99,7 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_REQUEST_BASED 6
 
 /*
  * Work processed by per-device workqueue.
@@ -164,6 +173,9 @@ struct mapped_device {
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
+
+	/* For saving the address of __make_request for request based dm */
+	make_request_fn *saved_make_request_fn;
 };
 
 #define MIN_IOS 256
@@ -409,6 +421,28 @@ static void free_tio(struct mapped_devic
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
@@ -597,6 +631,204 @@ static void clone_endio(struct bio *bio,
 	free_tio(md, tio);
 }
 
+/*
+ * Partial completion handling for request-based dm
+ */
+static void end_clone_bio(struct bio *bio, int error)
+{
+	struct dm_clone_bio_info *info = bio->bi_private;
+	struct dm_rq_target_io *tio = info->rq->end_io_data;
+	struct bio *orig_bio = info->orig;
+	unsigned int nr_bytes = info->orig->bi_size;
+
+	free_bio_info(tio->md, info);
+	bio->bi_private = tio->md->bs;
+	bio_put(bio);
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
+	if (tio->orig->bio != orig_bio)
+		DMWARN("bio completion is going in the middle of the request");
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
+static void __requeue_request(struct request_queue *q, struct request *rq)
+{
+	if (elv_queue_empty(q))
+		blk_plug_device(q);
+	blk_requeue_request(q, rq);
+}
+
+static void requeue_request(struct request_queue *q, struct request *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__requeue_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/*
+ * Complete the clone and the original request
+ */
+void dm_end_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *orig = tio->orig;
+	struct request_queue *q_orig = orig->q;
+	unsigned int nr_bytes = blk_rq_bytes(orig);
+
+	if (error == DM_ENDIO_REQUEUE) {
+		/*
+		 * Requeue the original request of the clone.
+		 * Don't invoke blk_run_queue() so that the requeued request
+		 * won't be dispatched again soon.
+		 */
+		free_bio_clone(clone);
+		dec_rq_pending(tio);
+		free_rq_tio(tio->md, tio);
+
+		requeue_request(q_orig, orig);
+		return;
+	}
+
+	if (blk_pc_request(orig)) {
+		orig->errors = clone->errors;
+		orig->data_len = clone->data_len;
+
+		if (orig->sense)
+			/*
+			 * We are using the sense buffer of the original
+			 * request.
+			 * So setting the length of the sense data is enough.
+			 */
+			orig->sense_len = clone->sense_len;
+	}
+
+	free_bio_clone(clone);
+	dec_rq_pending(tio);
+	free_rq_tio(tio->md, tio);
+
+	if (unlikely(blk_end_request(orig, error, nr_bytes)))
+		BUG();
+
+	blk_run_queue(q_orig);
+}
+EXPORT_SYMBOL_GPL(dm_end_request);
+
+/*
+ * Request completion handler for request-based dm
+ */
+static void dm_softirq_done(struct request *orig)
+{
+	struct request *clone = orig->completion_data;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+	int error = tio->error, r;
+
+	if (rq_end_io) {
+		r = rq_end_io(tio->ti, clone, error, &tio->info);
+		if (r <= 0 || r == DM_ENDIO_REQUEUE)
+			/* The target wants to complete or requeue the I/O */
+			error = r;
+		else if (r == DM_ENDIO_INCOMPLETE)
+			/* The target will handle the I/O */
+			return;
+		else {
+			DMWARN("unimplemented target endio return value: %d",
+			       r);
+			BUG();
+		}
+	}
+
+	dm_end_request(clone, error);
+}
+
+/*
+ * Called with the queue lock held
+ */
+static void end_clone_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *orig = tio->orig;
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
+	orig->completion_data = clone;
+	blk_complete_request(orig);
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -868,7 +1100,7 @@ static int __split_bio(struct mapped_dev
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static int dm_request(struct request_queue *q, struct bio *bio)
+static int _dm_request(struct request_queue *q, struct bio *bio)
 {
 	int r = -EIO;
 	int rw = bio_data_dir(bio);
@@ -918,12 +1150,264 @@ out_req:
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
+static int dm_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = q->queuedata;
+
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		return dm_make_request(q, bio);
+
+	return _dm_request(q, bio);
+}
+
+void dm_dispatch_request(struct request *rq)
+{
+	rq->start_time = jiffies;
+	blk_submit_request(rq->q, rq);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static void copy_request_info(struct request *clone, struct request *orig)
+{
+	INIT_LIST_HEAD(&clone->queuelist);
+	INIT_LIST_HEAD(&clone->donelist);
+	clone->q = NULL;
+	clone->cmd_flags = (rq_data_dir(orig) | REQ_NOMERGE);
+	clone->cmd_type = orig->cmd_type;
+	clone->sector = orig->sector;
+	clone->hard_sector = orig->hard_sector;
+	clone->nr_sectors = orig->nr_sectors;
+	clone->hard_nr_sectors = orig->hard_nr_sectors;
+	clone->current_nr_sectors = orig->current_nr_sectors;
+	clone->hard_cur_sectors = orig->hard_cur_sectors;
+	INIT_HLIST_NODE(&clone->hash);
+	clone->completion_data = NULL;
+	clone->elevator_private = NULL;
+	clone->elevator_private2 = NULL;
+	clone->rq_disk = NULL;
+	clone->start_time = jiffies;
+	clone->nr_phys_segments = orig->nr_phys_segments;
+	clone->nr_hw_segments = orig->nr_hw_segments;
+	clone->ioprio = orig->ioprio;
+	clone->special = NULL;
+	clone->buffer = orig->buffer;
+	clone->tag = -1;
+	clone->errors = 0;
+	clone->ref_count = 1;
+	clone->cmd_len = orig->cmd_len;
+	if (orig->cmd_len)
+		memcpy(clone->cmd, orig->cmd, sizeof(orig->cmd));
+	clone->data_len = orig->data_len;
+	clone->sense_len = orig->sense_len;
+	clone->data = orig->data;
+	clone->sense = orig->sense;
+	clone->timeout = 0;
+	clone->retries = 0;
+	clone->end_io = end_clone_request;
+	clone->next_rq = NULL;
+}
+
+static int clone_request_bios(struct request *clone, struct request *orig)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct bio *bio, *orig_bio;
+	struct dm_clone_bio_info *info;
+
+	for (orig_bio = orig->bio; orig_bio; orig_bio = orig_bio->bi_next) {
+		info = alloc_bio_info(md);
+		if (!info)
+			goto free_and_out;
+
+		bio = bio_alloc_bioset(GFP_ATOMIC, orig_bio->bi_max_vecs,
+				       md->bs);
+		if (!bio) {
+			free_bio_info(md, info);
+			goto free_and_out;
+		}
+
+		__bio_clone(bio, orig_bio);
+		bio->bi_destructor = dm_bio_destructor;
+		bio->bi_end_io = end_clone_bio;
+		info->rq = clone;
+		info->orig = orig_bio;
+		bio->bi_private = info;
+
+		if (clone->bio) {
+			clone->biotail->bi_next = bio;
+			clone->biotail = bio;
+		} else
+			clone->bio = clone->biotail = bio;
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
+static int setup_clone(struct request *clone, struct request *orig)
+{
+	int r;
+
+	r = clone_request_bios(clone, orig);
+	if (r)
+		return r;
+
+	copy_request_info(clone, orig);
+
+	return 0;
+}
+
+static int clone_and_map_request(struct dm_target *ti, struct request *rq,
+				 struct mapped_device *md)
+{
+	int r;
+	struct request *clone;
+	struct dm_rq_target_io *tio;
+
+	tio = alloc_rq_tio(md); /* Only one for each original request */
+	if (!tio)
+		/* -ENOMEM */
+		goto requeue;
+	tio->md = md;
+	tio->orig = rq;
+	tio->error = 0;
+	tio->ti = ti;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = &tio->clone;
+	clone->end_io_data = tio;
+	clone->bio = clone->biotail = NULL;
+	if (setup_clone(clone, rq))
+		/* -ENOMEM */
+		goto free_rq_tio_and_requeue;
+
+	atomic_inc(&md->pending);
+	r = ti->type->map_rq(ti, clone, &tio->info);
+	switch (r) {
+	case DM_MAPIO_SUBMITTED:
+		/* The target has taken the request to submit by itself */
+		break;
+	case DM_MAPIO_REMAPPED:
+		/* The clone has been remapped so dispatch it */
+		dm_dispatch_request(clone);
+		break;
+	case DM_MAPIO_REQUEUE:
+		/* The target wants to requeue the original request */
+		goto free_bio_clone_and_requeue;
+	default:
+		if (r > 0) {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		/*
+		 * The target wants to complete the original request.
+		 * Avoid printing "I/O error" message, since we didn't I/O.
+		 */
+		rq->cmd_flags |= REQ_QUIET;
+		dm_end_request(clone, r);
+		break;
+	}
+
+	return 0;
+
+free_bio_clone_and_requeue:
+	free_bio_clone(clone);
+	dec_rq_pending(tio);
+
+free_rq_tio_and_requeue:
+	free_rq_tio(md, tio);
+
+requeue:
+	/*
+	 * Actual requeue is done in dm_request_fn() after queue lock is held
+	 * so that we can avoid to get extra queue lock for the requeue
+	 */
+	return 1;
+}
+
+/*
+ * q->request_fn for request-based dm.
+ * Called with the queue lock held
+ */
+static void dm_request_fn(struct request_queue *q)
+{
+	int r;
+	struct mapped_device *md = (struct mapped_device *)q->queuedata;
+	struct dm_table *map = dm_get_table(md);
+	struct dm_target *ti;
+	dm_congested_fn congested;
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
+			break;
+
+		ti = dm_table_find_target(map, rq->sector);
+		congested = ti->type->congested;
+		if (congested && congested(ti))
+			break;
+
+		blkdev_dequeue_request(rq);
+		spin_unlock(q->queue_lock);
+		r = clone_and_map_request(ti, rq, md);
+		spin_lock_irq(q->queue_lock);
+
+		if (r)
+			__requeue_request(q, rq);
+	}
+
+	dm_table_put(map);
+
+	return;
+}
+
+int dm_underlying_device_congested(struct request_queue *q)
+{
+	return blk_lld_busy(q);
+}
+EXPORT_SYMBOL_GPL(dm_underlying_device_congested);
+
 static void dm_unplug_all(struct request_queue *q)
 {
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_table(md);
 
 	if (map) {
+		if (test_bit(DMF_REQUEST_BASED, &md->flags))
+			generic_unplug_device(q);
+
 		dm_table_unplug_all(map);
 		dm_table_put(map);
 	}
@@ -937,6 +1421,9 @@ static int dm_any_congested(void *conges
 
 	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
 		r = bdi_bits;
+	else if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		/* Request-based dm cares about only own queue */
+		r = md->queue->backing_dev_info.state & bdi_bits;
 	else
 		r = dm_table_any_congested(map, bdi_bits);
 
@@ -1434,6 +1921,25 @@ out:
 	return r;
 }
 
+static void stop_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_queue_stopped(q))
+		blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -1532,6 +2038,16 @@ int dm_suspend(struct mapped_device *md,
 	add_wait_queue(&md->wait, &wait);
 	up_write(&md->io_lock);
 
+	/*
+	 * In request-based dm, stopping request_queue prevents mapping.
+	 * Even after stopping the request_queue, submitted requests from
+	 * upper-layer can be inserted to the request_queue.
+	 * So original (unmapped) requests are kept in the request_queue
+	 * during suspension.
+	 */
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		stop_queue(md->queue);
+
 	/* unplug */
 	if (map)
 		dm_table_unplug_all(map);
@@ -1544,14 +2060,23 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 	remove_wait_queue(&md->wait, &wait);
 
-	if (noflush)
-		__merge_pushback_list(md);
+	if (noflush) {
+		if (test_bit(DMF_REQUEST_BASED, &md->flags))
+			/* Request-based dm uses md->queue for noflush */
+			clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+		else
+			__merge_pushback_list(md);
+	}
 	up_write(&md->io_lock);
 
 	/* were we interrupted ? */
 	if (r < 0) {
 		dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
 
+		if (test_bit(DMF_REQUEST_BASED, &md->flags))
+			/* Request-based dm uses md->queue for deferred I/Os */
+			start_queue(md->queue);
+
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
 	}
@@ -1590,6 +2115,18 @@ int dm_resume(struct mapped_device *md)
 	if (r)
 		goto out;
 
+	/*
+	 * Flushing deferred I/Os must be done after targets are resumed
+	 * so that mapping of targets can work correctly.
+	 *
+	 * Resuming request_queue earlier than clear_bit(DMF_BLOCK_IO) means
+	 * starting to flush requests before upper-layer starts to submit bios.
+	 * It may be better because llds should be empty and no need to wait
+	 * for bio merging so strictly at this time.
+	 */
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		start_queue(md->queue);
+
 	dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
 
 	unlock_fs(md);
Index: 2.6.25-rc5/drivers/md/dm.h
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.h
+++ 2.6.25-rc5/drivers/md/dm.h
@@ -128,6 +128,13 @@ int dm_target_iterate(void (*iter_func)(
 					void *param), void *param);
 
 /*-----------------------------------------------------------------
+ * Helper for block layer and dm core operations
+ *---------------------------------------------------------------*/
+void dm_dispatch_request(struct request *rq);
+void dm_end_request(struct request *rq, int error);
+int dm_underlying_device_congested(struct request_queue *q);
+
+/*-----------------------------------------------------------------
  * Useful inlines.
  *---------------------------------------------------------------*/
 static inline int array_too_big(unsigned long fixed, unsigned long obj,
@@ -184,6 +191,7 @@ void dm_stripe_exit(void);
 
 void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
+union map_info *dm_get_rq_mapinfo(struct request *rq);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
