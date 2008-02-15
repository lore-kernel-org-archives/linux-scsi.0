From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 09/13] dm: add core functions
Date: Fri, 15 Feb 2008 17:32:13 -0500 (EST)
Message-ID: <20080215.173213.98555581.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761986AbYBOWcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:32:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds core functions for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |  452 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h |    7 
 2 files changed, 456 insertions(+), 3 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -75,6 +75,14 @@ union map_info *dm_get_mapinfo(struct bi
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
@@ -86,6 +94,7 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_REQUEST_BASED 6
 
 /*
  * Work processed by per-device workqueue.
@@ -158,6 +167,9 @@ struct mapped_device {
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
+
+	/* For saving the address of __make_request for request based dm */
+	make_request_fn *saved_make_request_fn;
 };
 
 #define MIN_IOS 256
@@ -395,6 +407,17 @@ static void free_tio(struct mapped_devic
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
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
@@ -583,6 +606,181 @@ static void clone_endio(struct bio *bio,
 	free_tio(md, tio);
 }
 
+static void __requeue_request(struct request_queue *q, struct request *rq)
+{
+	if (elv_queue_empty(q))
+		blk_plug_device(q);
+	blk_requeue_request(q, rq);
+}
+
+static void requeue_request(struct request_queue *q, struct request *rq)
+{
+	unsigned long flags = 0UL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__requeue_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void dec_rq_pending(struct dm_rq_target_io *tio)
+{
+	if (!atomic_dec_return(&tio->md->pending))
+		/* nudge anyone waiting on suspend queue */
+		wake_up(&tio->md->wait);
+}
+
+static void blk_update_cloned_rq(struct request *rq, struct request *clone)
+{
+	clone->nr_phys_segments = rq->nr_phys_segments;
+	clone->nr_hw_segments = rq->nr_hw_segments;
+	clone->current_nr_sectors = rq->current_nr_sectors;
+	clone->hard_cur_sectors = rq->hard_cur_sectors;
+	clone->hard_nr_sectors = rq->hard_nr_sectors;
+	clone->nr_sectors = rq->nr_sectors;
+	clone->hard_sector = rq->hard_sector;
+	clone->sector = rq->sector;
+	clone->data_len = rq->data_len;
+	clone->buffer = rq->buffer;
+	clone->data = rq->data;
+	clone->bio = rq->bio;
+	clone->biotail = rq->biotail;
+}
+
+static void finish_clone(struct request *clone)
+{
+	if (!clone->q)
+		/*
+		 * The clone was not dispatched into underlying devices and
+		 * it means the caller is not underlying device driver,
+		 * the caller should be dm. (e.g. dispatch_queued_ios() of
+		 * dm-multipath)
+		 * So no need to do anything here for this clone.
+		 */
+		return;
+
+	/*
+	 * For just cleaning up the information of the queue in which
+	 * the clone was dispatched.
+	 * The clone is *NOT* freed actually here because it is alloced from
+	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
+	 *
+	 * The 'error' and 'nr_bytes' arguments of blk_end_io() don't matter
+	 * because they aren't used for dm's clones.
+	 */
+	if (blk_end_io(clone, 0, 0, 0, NULL))
+		DMWARN("dm ignores the immediate return request of callback.");
+}
+
+static void clean_clone(struct request *clone)
+{
+	finish_clone(clone);
+	clone->special = NULL;
+	clone->errors = 0;
+	clone->endio_error = 0;
+}
+
+/**
+ * Must be called without the queue lock
+ **/
+static int clone_end_request(struct request *clone, int error,
+			     unsigned int nr_bytes, unsigned int bidi_bytes,
+			     int (drv_callback)(struct request *))
+{
+	int r = 0, rw = rq_data_dir(clone), requeued = 0;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_first_fn endio_first = tio->ti->type->rq_end_io_first;
+	dm_request_endio_fn endio = tio->ti->type->rq_end_io;
+	dm_request_queue_in_tgt_fn queue_in_tgt = tio->ti->type->queue_in_tgt;
+	struct request *orig = tio->orig;
+	struct request_queue *q_orig = orig->q;
+
+	if (blk_fs_request(clone) && clone->rq_disk)
+		disk_stat_add(clone->rq_disk, sectors[rw], nr_bytes >> 9);
+
+	if (endio_first) {
+		r = endio_first(tio->ti, clone, error, &tio->info);
+		switch (r) {
+		case 0:
+			/* Succeeded */
+			break;
+		case DM_ENDIO_INCOMPLETE:
+			/*
+			 * The target wants to handle the io without unmap.
+			 *
+			 * The clone must be cleaned up before the target
+			 * takes it so that the target can dispatch it
+			 * to (same or another) underlying device again.
+			 */
+			clean_clone(clone);
+
+			if (!queue_in_tgt) {
+				DMERR("queue_in_tgt isn't implemented.");
+				BUG();
+			}
+			queue_in_tgt(tio->ti, clone, &tio->info);
+			blk_run_queue(q_orig);
+
+			return 0;
+		case DM_ENDIO_REQUEUE:
+			/*
+			 * The target wants to push back the I/O for noflush
+			 * suspension.
+			 * Don't invoke blk_run_queue() in this case so that
+			 * the requeued request won't be dispatched again soon.
+			 */
+			requeue_request(q_orig, orig);
+			requeued = 1;
+
+			goto free_clone;
+		default:
+			if (r >= 0) {
+				DMWARN("unimplemented target endio return"
+				       " value: %d", r);
+				BUG();
+			}
+
+			/*
+			 * The target detected error, but didn't retry.
+			 * Direct the error to upper layer.
+			 */
+			error = r;
+			break;
+		}
+	}
+
+	/* Complete the original request's chunk */
+	r = blk_end_request(orig, error, nr_bytes);
+
+	/*
+	 * Recopy the original request fields that were updated
+	 * in blk_end_request() to the clone.
+	 */
+	blk_update_cloned_rq(orig, clone);
+
+	if (r)
+		/* The original request has leftover */
+		return 1;
+
+free_clone:
+	/*
+	 * Now the original request is completed and freed, or requeued.
+	 * So no need the clone any more.
+	 */
+
+	if (endio)
+		endio(tio->ti, clone, error, &tio->info);
+
+	finish_clone(clone);
+
+	if (!requeued)
+		blk_run_queue(q_orig);
+
+	dec_rq_pending(tio);
+	free_rq_tio(tio->md, tio);
+
+	return 0;
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -854,7 +1052,7 @@ static int __split_bio(struct mapped_dev
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static int dm_request(struct request_queue *q, struct bio *bio)
+static int _dm_request(struct request_queue *q, struct bio *bio)
 {
 	int r = -EIO;
 	int rw = bio_data_dir(bio);
@@ -904,12 +1102,203 @@ out_req:
 	return 0;
 }
 
+static int dm_make_request(struct request_queue *q, struct bio *bio)
+{
+	int r = 0;
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
+	r = md->saved_make_request_fn(q, bio); /* call __make_request() */
+
+	return r;
+}
+
+static int dm_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = q->queuedata;
+
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		return dm_make_request(q, bio);
+	else
+		return _dm_request(q, bio);
+}
+
+static void setup_clone(struct request *clone, struct request *rq)
+{
+	INIT_LIST_HEAD(&clone->queuelist);
+	INIT_LIST_HEAD(&clone->donelist);
+	clone->q = NULL;
+	clone->cmd_flags = (rq_data_dir(rq) | REQ_NOMERGE | REQ_CLONED);
+	clone->cmd_type = rq->cmd_type;
+	clone->sector = rq->sector;
+	clone->hard_sector = rq->hard_sector;
+	clone->nr_sectors = rq->nr_sectors;
+	clone->hard_nr_sectors = rq->hard_nr_sectors;
+	clone->current_nr_sectors = rq->current_nr_sectors;
+	clone->hard_cur_sectors = rq->hard_cur_sectors;
+	clone->bio = rq->bio;
+	clone->biotail = rq->biotail;
+	INIT_HLIST_NODE(&clone->hash);
+/*	RB_CLEAR_NODE(&clone->rb_node);*/
+	clone->completion_data = NULL;
+	clone->elevator_private = NULL;
+	clone->elevator_private2 = NULL;
+	clone->rq_disk = NULL;
+	clone->start_time = jiffies;
+	clone->nr_phys_segments = rq->nr_phys_segments;
+	clone->nr_hw_segments = rq->nr_hw_segments;
+	clone->ioprio = rq->ioprio;
+	clone->special = NULL;
+	clone->buffer = rq->buffer;
+	clone->tag = -1;
+	clone->errors = 0;
+	clone->ref_count = 1;
+	clone->cmd_len = rq->cmd_len;
+	memcpy(clone->cmd, rq->cmd, sizeof(rq->cmd));
+	clone->data_len = rq->data_len;
+	clone->sense_len = rq->sense_len;
+	clone->data = rq->data;
+	clone->sense = rq->sense;
+	clone->timeout = 0;
+	clone->retries = 0;
+/*	clone->dtor = NULL;
+	clone->dtor_data = NULL;*/
+	clone->end_io = NULL;
+	clone->complete_io = clone_end_request;
+	clone->end_io_data = NULL;
+	clone->next_rq = NULL;
+	clone->endio_error = 0;
+}
+
+void dm_dispatch_request(struct request_queue *q, struct request *rq)
+{
+	rq->start_time = jiffies;
+	blk_submit_request(q, rq);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static int clone_and_map_request(struct dm_target *ti, struct request *rq,
+				 struct mapped_device *md)
+{
+	int r;
+	struct request *clone;
+	struct dm_rq_target_io *tio;
+
+	tio = alloc_rq_tio(md); /* only one for each original request */
+	if (!tio)
+		/* -ENOMEM */
+		goto requeue;
+	tio->md = md;
+	tio->error = 0;
+	tio->orig = rq;
+	tio->ti = ti;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = &tio->clone;
+	setup_clone(clone, rq);
+	clone->end_io_data = tio;
+
+	atomic_inc(&md->pending);
+	r = ti->type->map_rq(ti, clone, &tio->info);
+	switch (r) {
+	case DM_MAPIO_SUBMITTED:
+		/* the target has taken the request to submit by itself */
+		break;
+	case DM_MAPIO_REMAPPED:
+		/* the clone has been remapped so dispatch it */
+		dm_dispatch_request(clone->q, clone);
+		break;
+	case DM_MAPIO_REQUEUE:
+		/* the target has requested to requeue the original request */
+		dec_rq_pending(tio);
+		free_rq_tio(md, tio);
+		goto requeue;
+	default:
+		if (r >= 0) {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		dec_rq_pending(tio);
+		free_rq_tio(md, tio);
+
+		/* Avoid printing "I/O error" message because we didn't I/O */
+		rq->cmd_flags |= REQ_QUIET;
+		blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+		break;
+	}
+
+	return 0;
+
+requeue:
+	/*
+	 * Actual requeue is done in dm_request_fn() after queue lock is taken
+	 * so that we can avoid to get extra queue lock for the requeue
+	 */
+	return 1;
+}
+
+int dm_underlying_device_congested(struct request_queue *q)
+{
+	return blk_lld_busy(q);
+}
+EXPORT_SYMBOL_GPL(dm_underlying_device_congested);
+
+/*
+ * q->request_fn for request-based dm.
+ * called with q->queue_lock held
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
@@ -923,6 +1312,9 @@ static int dm_any_congested(void *conges
 
 	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
 		r = bdi_bits;
+	else if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		/* Request-based dm cares about only own queue */
+		r = md->queue->backing_dev_info.state & bdi_bits;
 	else
 		r = dm_table_any_congested(map, bdi_bits);
 
@@ -1417,6 +1809,25 @@ out:
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
@@ -1515,6 +1926,20 @@ int dm_suspend(struct mapped_device *md,
 	add_wait_queue(&md->wait, &wait);
 	up_write(&md->io_lock);
 
+	/*
+	 * In request-based dm, stopping request_queue prevents mapping.
+	 * Even after stopping the request_queue, submitted requests from
+	 * upper-layer can be inserted to the request_queue.
+	 * So original (unmapped) requests are kept in the request_queue
+	 * during suspension.
+	 *
+	 * NOTE: To stop mapping correctly, dm_request_fn() must care about
+	 *       the queue-stop status because underlying device drivers
+	 *       may call q->request_fn() directly through blk_run_queue().
+	 */
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		stop_queue(md->queue);
+
 	/* unplug */
 	if (map)
 		dm_table_unplug_all(map);
@@ -1527,14 +1952,23 @@ int dm_suspend(struct mapped_device *md,
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
@@ -1573,6 +2007,18 @@ int dm_resume(struct mapped_device *md)
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
Index: 2.6.25-rc1/drivers/md/dm.h
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.h
+++ 2.6.25-rc1/drivers/md/dm.h
@@ -128,6 +128,12 @@ int dm_target_iterate(void (*iter_func)(
 					void *param), void *param);
 
 /*-----------------------------------------------------------------
+ * Helper for block layer operations
+ *---------------------------------------------------------------*/
+void dm_dispatch_request(struct request_queue *q, struct request *rq);
+int dm_underlying_device_congested(struct request_queue *q);
+
+/*-----------------------------------------------------------------
  * Useful inlines.
  *---------------------------------------------------------------*/
 static inline int array_too_big(unsigned long fixed, unsigned long obj,
@@ -184,6 +190,7 @@ void dm_stripe_exit(void);
 
 void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
+union map_info *dm_get_rq_mapinfo(struct request *rq);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
