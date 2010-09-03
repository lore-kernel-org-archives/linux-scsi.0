From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/41] dm: implement REQ_FLUSH/FUA support for
	request-based dm
Date: Fri,  3 Sep 2010 12:29:39 +0200
Message-ID: <1283509796-1510-25-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch converts request-based dm to support the new REQ_FLUSH/FUA.

The original request-based flush implementation depended on
request_queue blocking other requests while a barrier sequence is in
progress, which is no longer true for the new REQ_FLUSH/FUA.

In general, request-based dm doesn't have infrastructure for cloning
one source request to multiple targets, but the original flush
implementation had a special mostly independent path which can issue
flushes to multiple targets and sequence them.  However, the
capability isn't currently in use and adds a lot of complexity.
Moreoever, it's unlikely to be useful in its current form as it
doesn't make sense to be able to send out flushes to multiple targets
when write requests can't be.

This patch rips out special flush code path and deals handles
REQ_FLUSH/FUA requests the same way as other requests.  The only
special treatment is that REQ_FLUSH requests use the block address 0
when finding target, which is enough for now.

* added BUG_ON(!dm_target_is_valid(ti)) in dm_request_fn() as
  suggested by Mike Snitzer

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |  206 ++++++-------------------------------------------------
 1 files changed, 22 insertions(+), 184 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32e6622..65114e4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -149,20 +149,9 @@ struct mapped_device {
 	int flush_error;
 
 	/*
-	 * Protect barrier_error from concurrent endio processing
-	 * in request-based dm.
-	 */
-	spinlock_t barrier_error_lock;
-	int barrier_error;
-
-	/*
-	 * Processing queue (flush/barriers)
+	 * Processing queue (flush)
 	 */
 	struct workqueue_struct *wq;
-	struct work_struct barrier_work;
-
-	/* A pointer to the currently processing pre/post flush request */
-	struct request *flush_request;
 
 	/*
 	 * The current mapping.
@@ -750,23 +739,6 @@ static void end_clone_bio(struct bio *clone, int error)
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
@@ -804,13 +776,11 @@ static void free_rq_clone(struct request *clone)
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
 
@@ -824,15 +794,8 @@ static void dm_end_request(struct request *clone, int error)
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
+	rq_completed(md, rw, true);
 }
 
 static void dm_unprep_request(struct request *rq)
@@ -857,16 +820,6 @@ void dm_requeue_unmapped_request(struct request *clone)
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
-		/*
-		 * Barrier clones share an original request.
-		 * Leave it to dm_end_request(), which handles this special
-		 * case.
-		 */
-		dm_end_request(clone, DM_ENDIO_REQUEUE);
-		return;
-	}
-
 	dm_unprep_request(rq);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -956,19 +909,6 @@ static void dm_complete_request(struct request *clone, int error)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
-		/*
-		 * Barrier clones share an original request.  So can't use
-		 * softirq_done with the original.
-		 * Pass the clone to dm_done() directly in this special case.
-		 * It is safe (even if clone->q->queue_lock is held here)
-		 * because there is no I/O dispatching during the completion
-		 * of barrier clone.
-		 */
-		dm_done(clone, error, true);
-		return;
-	}
-
 	tio->error = error;
 	rq->completion_data = clone;
 	blk_complete_request(rq);
@@ -985,17 +925,6 @@ void dm_kill_unmapped_request(struct request *clone, int error)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
-	if (unlikely(clone->cmd_flags & REQ_HARDBARRIER)) {
-		/*
-		 * Barrier clones share an original request.
-		 * Leave it to dm_end_request(), which handles this special
-		 * case.
-		 */
-		BUG_ON(error > 0);
-		dm_end_request(clone, error);
-		return;
-	}
-
 	rq->cmd_flags |= REQ_FAILED;
 	dm_complete_request(clone, error);
 }
@@ -1536,14 +1465,6 @@ static int dm_request(struct request_queue *q, struct bio *bio)
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
@@ -1591,22 +1512,15 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
-	if (dm_rq_is_flush_request(rq)) {
-		blk_rq_init(NULL, clone);
-		clone->cmd_type = REQ_TYPE_FS;
-		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
-	} else {
-		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
-				      dm_rq_bio_constructor, tio);
-		if (r)
-			return r;
-
-		clone->cmd = rq->cmd;
-		clone->cmd_len = rq->cmd_len;
-		clone->sense = rq->sense;
-		clone->buffer = rq->buffer;
-	}
+	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
+			      dm_rq_bio_constructor, tio);
+	if (r)
+		return r;
 
+	clone->cmd = rq->cmd;
+	clone->cmd_len = rq->cmd_len;
+	clone->sense = rq->sense;
+	clone->buffer = rq->buffer;
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
 
@@ -1647,9 +1561,6 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
 	struct mapped_device *md = q->queuedata;
 	struct request *clone;
 
-	if (unlikely(dm_rq_is_flush_request(rq)))
-		return BLKPREP_OK;
-
 	if (unlikely(rq->special)) {
 		DMWARN("Already has something in rq->special.");
 		return BLKPREP_KILL;
@@ -1726,6 +1637,7 @@ static void dm_request_fn(struct request_queue *q)
 	struct dm_table *map = dm_get_live_table(md);
 	struct dm_target *ti;
 	struct request *rq, *clone;
+	sector_t pos;
 
 	/*
 	 * For suspend, check blk_queue_stopped() and increment
@@ -1738,15 +1650,14 @@ static void dm_request_fn(struct request_queue *q)
 		if (!rq)
 			goto plug_and_out;
 
-		if (unlikely(dm_rq_is_flush_request(rq))) {
-			BUG_ON(md->flush_request);
-			md->flush_request = rq;
-			blk_start_request(rq);
-			queue_work(md->wq, &md->barrier_work);
-			goto out;
-		}
+		/* always use block 0 to find the target for flushes for now */
+		pos = 0;
+		if (!(rq->cmd_flags & REQ_FLUSH))
+			pos = blk_rq_pos(rq);
+
+		ti = dm_table_find_target(map, pos);
+		BUG_ON(!dm_target_is_valid(ti));
 
-		ti = dm_table_find_target(map, blk_rq_pos(rq));
 		if (ti->type->busy && ti->type->busy(ti))
 			goto plug_and_out;
 
@@ -1917,7 +1828,6 @@ out:
 static const struct block_device_operations dm_blk_dops;
 
 static void dm_wq_work(struct work_struct *work);
-static void dm_rq_barrier_work(struct work_struct *work);
 
 static void dm_init_md_queue(struct mapped_device *md)
 {
@@ -1972,7 +1882,6 @@ static struct mapped_device *alloc_dev(int minor)
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);
 	spin_lock_init(&md->deferred_lock);
-	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1995,7 +1904,6 @@ static struct mapped_device *alloc_dev(int minor)
 	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
-	INIT_WORK(&md->barrier_work, dm_rq_barrier_work);
 	init_waitqueue_head(&md->eventq);
 
 	md->disk->major = _major;
@@ -2245,8 +2153,6 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	/* no flush support for request based dm yet */
-	blk_queue_flush(md->queue, 0);
 
 	elv_register_queue(md->queue);
 
@@ -2483,73 +2389,6 @@ static void dm_queue_flush(struct mapped_device *md)
 	queue_work(md->wq, &md->work);
 }
 
-static void dm_rq_set_target_request_nr(struct request *clone, unsigned request_nr)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-
-	tio->info.target_request_nr = request_nr;
-}
-
-/* Issue barrier requests to targets and wait for their completion. */
-static int dm_rq_barrier(struct mapped_device *md)
-{
-	int i, j;
-	struct dm_table *map = dm_get_live_table(md);
-	unsigned num_targets = dm_table_get_num_targets(map);
-	struct dm_target *ti;
-	struct request *clone;
-
-	md->barrier_error = 0;
-
-	for (i = 0; i < num_targets; i++) {
-		ti = dm_table_get_target(map, i);
-		for (j = 0; j < ti->num_flush_requests; j++) {
-			clone = clone_rq(md->flush_request, md, GFP_NOIO);
-			dm_rq_set_target_request_nr(clone, j);
-			atomic_inc(&md->pending[rq_data_dir(clone)]);
-			map_request(ti, clone, md);
-		}
-	}
-
-	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-	dm_table_put(map);
-
-	return md->barrier_error;
-}
-
-static void dm_rq_barrier_work(struct work_struct *work)
-{
-	int error;
-	struct mapped_device *md = container_of(work, struct mapped_device,
-						barrier_work);
-	struct request_queue *q = md->queue;
-	struct request *rq;
-	unsigned long flags;
-
-	/*
-	 * Hold the md reference here and leave it at the last part so that
-	 * the md can't be deleted by device opener when the barrier request
-	 * completes.
-	 */
-	dm_get(md);
-
-	error = dm_rq_barrier(md);
-
-	rq = md->flush_request;
-	md->flush_request = NULL;
-
-	if (error == DM_ENDIO_REQUEUE) {
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_requeue_request(q, rq);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	} else
-		blk_end_request_all(rq, error);
-
-	blk_run_queue(q);
-
-	dm_put(md);
-}
-
 /*
  * Swap in a new table, returning the old one for the caller to destroy.
  */
@@ -2686,9 +2525,8 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	up_write(&md->io_lock);
 
 	/*
-	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
-	 * can be kicked until md->queue is stopped.  So stop md->queue before
-	 * flushing md->wq.
+	 * Stop md->queue before flushing md->wq in case request-based
+	 * dm defers requests to md->wq from md->queue.
 	 */
 	if (dm_request_based(md))
 		stop_queue(md->queue);
-- 
1.7.1
