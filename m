From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/18] dm: always defer request allocation to the owner of the request_queue
Date: Wed, 25 Jan 2017 18:25:15 +0100
Message-ID: <1485365126-23210-8-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

DM already calls blk_mq_alloc_request on the request_queue of the
underlying device if it is a blk-mq device.  But now that we allow drivers
to allocate additional data and initialize it ahead of time we need to do
the same for all drivers.   Doing so and using the new cmd_size
infrastructure in the block layer greatly simplifies the dm-rq and mpath
code, and should also make arbitrary combinations of SQ and MQ devices
with SQ or MQ device mapper tables easily possible as a further step.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h          |   1 -
 drivers/md/dm-mpath.c         | 132 ++++------------------
 drivers/md/dm-rq.c            | 251 ++++++++++--------------------------------
 drivers/md/dm-rq.h            |   2 +-
 drivers/md/dm-target.c        |   7 --
 drivers/md/dm.c               |  30 ++---
 drivers/md/dm.h               |   3 +-
 include/linux/device-mapper.h |   3 -
 8 files changed, 85 insertions(+), 344 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 40ceba1..136fda3 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -92,7 +92,6 @@ struct mapped_device {
 	 * io objects are allocated from here.
 	 */
 	mempool_t *io_pool;
-	mempool_t *rq_pool;
 
 	struct bio_set *bs;
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6400cff..784f237 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -92,12 +92,6 @@ struct multipath {
 
 	unsigned queue_mode;
 
-	/*
-	 * We must use a mempool of dm_mpath_io structs so that we
-	 * can resubmit bios on error.
-	 */
-	mempool_t *mpio_pool;
-
 	struct mutex work_mutex;
 	struct work_struct trigger_event;
 
@@ -115,8 +109,6 @@ struct dm_mpath_io {
 
 typedef int (*action_fn) (struct pgpath *pgpath);
 
-static struct kmem_cache *_mpio_cache;
-
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
@@ -209,7 +201,6 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		init_waitqueue_head(&m->pg_init_wait);
 		mutex_init(&m->work_mutex);
 
-		m->mpio_pool = NULL;
 		m->queue_mode = DM_TYPE_NONE;
 
 		m->ti = ti;
@@ -229,16 +220,7 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 			m->queue_mode = DM_TYPE_MQ_REQUEST_BASED;
 		else
 			m->queue_mode = DM_TYPE_REQUEST_BASED;
-	}
-
-	if (m->queue_mode == DM_TYPE_REQUEST_BASED) {
-		unsigned min_ios = dm_get_reserved_rq_based_ios();
-
-		m->mpio_pool = mempool_create_slab_pool(min_ios, _mpio_cache);
-		if (!m->mpio_pool)
-			return -ENOMEM;
-	}
-	else if (m->queue_mode == DM_TYPE_BIO_BASED) {
+	} else if (m->queue_mode == DM_TYPE_BIO_BASED) {
 		INIT_WORK(&m->process_queued_bios, process_queued_bios);
 		/*
 		 * bio-based doesn't support any direct scsi_dh management;
@@ -263,7 +245,6 @@ static void free_multipath(struct multipath *m)
 
 	kfree(m->hw_handler_name);
 	kfree(m->hw_handler_params);
-	mempool_destroy(m->mpio_pool);
 	kfree(m);
 }
 
@@ -272,38 +253,6 @@ static struct dm_mpath_io *get_mpio(union map_info *info)
 	return info->ptr;
 }
 
-static struct dm_mpath_io *set_mpio(struct multipath *m, union map_info *info)
-{
-	struct dm_mpath_io *mpio;
-
-	if (!m->mpio_pool) {
-		/* Use blk-mq pdu memory requested via per_io_data_size */
-		mpio = get_mpio(info);
-		memset(mpio, 0, sizeof(*mpio));
-		return mpio;
-	}
-
-	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
-	if (!mpio)
-		return NULL;
-
-	memset(mpio, 0, sizeof(*mpio));
-	info->ptr = mpio;
-
-	return mpio;
-}
-
-static void clear_request_fn_mpio(struct multipath *m, union map_info *info)
-{
-	/* Only needed for non blk-mq (.request_fn) multipath */
-	if (m->mpio_pool) {
-		struct dm_mpath_io *mpio = info->ptr;
-
-		info->ptr = NULL;
-		mempool_free(mpio, m->mpio_pool);
-	}
-}
-
 static size_t multipath_per_bio_data_size(void)
 {
 	return sizeof(struct dm_mpath_io) + sizeof(struct dm_bio_details);
@@ -530,16 +479,17 @@ static bool must_push_back_bio(struct multipath *m)
 /*
  * Map cloned requests (request-based multipath)
  */
-static int __multipath_map(struct dm_target *ti, struct request *clone,
-			   union map_info *map_context,
-			   struct request *rq, struct request **__clone)
+static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
+				   union map_info *map_context,
+				   struct request **__clone)
 {
 	struct multipath *m = ti->private;
 	int r = DM_MAPIO_REQUEUE;
-	size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
+	size_t nr_bytes = blk_rq_bytes(rq);
 	struct pgpath *pgpath;
 	struct block_device *bdev;
-	struct dm_mpath_io *mpio;
+	struct dm_mpath_io *mpio = get_mpio(map_context);
+	struct request *clone;
 
 	/* Do we need to select a new pgpath? */
 	pgpath = lockless_dereference(m->current_pgpath);
@@ -556,42 +506,23 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		return r;
 	}
 
-	mpio = set_mpio(m, map_context);
-	if (!mpio)
-		/* ENOMEM, requeue */
-		return r;
-
+	memset(mpio, 0, sizeof(*mpio));
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
 
 	bdev = pgpath->path.dev->bdev;
 
-	if (clone) {
-		/*
-		 * Old request-based interface: allocated clone is passed in.
-		 * Used by: .request_fn stacked on .request_fn path(s).
-		 */
-		clone->q = bdev_get_queue(bdev);
-		clone->rq_disk = bdev->bd_disk;
-		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	} else {
-		/*
-		 * blk-mq request-based interface; used by both:
-		 * .request_fn stacked on blk-mq path(s) and
-		 * blk-mq stacked on blk-mq path(s).
-		 */
-		clone = blk_mq_alloc_request(bdev_get_queue(bdev),
-					     rq_data_dir(rq), BLK_MQ_REQ_NOWAIT);
-		if (IS_ERR(clone)) {
-			/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
-			clear_request_fn_mpio(m, map_context);
-			return r;
-		}
-		clone->bio = clone->biotail = NULL;
-		clone->rq_disk = bdev->bd_disk;
-		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-		*__clone = clone;
+	clone = blk_get_request(bdev_get_queue(bdev),
+			rq->cmd_flags | REQ_NOMERGE,
+			GFP_ATOMIC);
+	if (IS_ERR(clone)) {
+		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
+		return r;
 	}
+	clone->bio = clone->biotail = NULL;
+	clone->rq_disk = bdev->bd_disk;
+	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	*__clone = clone;
 
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
@@ -600,22 +531,9 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	return DM_MAPIO_REMAPPED;
 }
 
-static int multipath_map(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
-{
-	return __multipath_map(ti, clone, map_context, NULL, NULL);
-}
-
-static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
-				   union map_info *map_context,
-				   struct request **clone)
-{
-	return __multipath_map(ti, NULL, map_context, rq, clone);
-}
-
 static void multipath_release_clone(struct request *clone)
 {
-	blk_mq_free_request(clone);
+	blk_put_request(clone);
 }
 
 /*
@@ -1187,7 +1105,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_write_same_bios = 1;
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
 		ti->per_io_data_size = multipath_per_bio_data_size();
-	else if (m->queue_mode == DM_TYPE_MQ_REQUEST_BASED)
+	else
 		ti->per_io_data_size = sizeof(struct dm_mpath_io);
 
 	return 0;
@@ -1610,7 +1528,6 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
-	clear_request_fn_mpio(m, map_context);
 
 	return r;
 }
@@ -2060,7 +1977,6 @@ static struct target_type multipath_target = {
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
-	.map_rq = multipath_map,
 	.clone_and_map_rq = multipath_clone_and_map,
 	.release_clone_rq = multipath_release_clone,
 	.rq_end_io = multipath_end_io,
@@ -2080,11 +1996,6 @@ static int __init dm_multipath_init(void)
 {
 	int r;
 
-	/* allocate a slab for the dm_mpath_ios */
-	_mpio_cache = KMEM_CACHE(dm_mpath_io, 0);
-	if (!_mpio_cache)
-		return -ENOMEM;
-
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
 		DMERR("request-based register failed %d", r);
@@ -2120,8 +2031,6 @@ static int __init dm_multipath_init(void)
 bad_alloc_kmultipathd:
 	dm_unregister_target(&multipath_target);
 bad_register_target:
-	kmem_cache_destroy(_mpio_cache);
-
 	return r;
 }
 
@@ -2131,7 +2040,6 @@ static void __exit dm_multipath_exit(void)
 	destroy_workqueue(kmultipathd);
 
 	dm_unregister_target(&multipath_target);
-	kmem_cache_destroy(_mpio_cache);
 }
 
 module_init(dm_multipath_init);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 3f12916..8d06834 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -109,28 +109,6 @@ void dm_stop_queue(struct request_queue *q)
 		dm_mq_stop_queue(q);
 }
 
-static struct dm_rq_target_io *alloc_old_rq_tio(struct mapped_device *md,
-						gfp_t gfp_mask)
-{
-	return mempool_alloc(md->io_pool, gfp_mask);
-}
-
-static void free_old_rq_tio(struct dm_rq_target_io *tio)
-{
-	mempool_free(tio, tio->md->io_pool);
-}
-
-static struct request *alloc_old_clone_request(struct mapped_device *md,
-					       gfp_t gfp_mask)
-{
-	return mempool_alloc(md->rq_pool, gfp_mask);
-}
-
-static void free_old_clone_request(struct mapped_device *md, struct request *rq)
-{
-	mempool_free(rq, md->rq_pool);
-}
-
 /*
  * Partial completion handling for request-based dm
  */
@@ -185,7 +163,7 @@ static void end_clone_bio(struct bio *clone)
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
 {
-	return (rq->q->mq_ops ? blk_mq_rq_to_pdu(rq) : rq->special);
+	return blk_mq_rq_to_pdu(rq);
 }
 
 static void rq_end_stats(struct mapped_device *md, struct request *orig)
@@ -233,31 +211,6 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	dm_put(md);
 }
 
-static void free_rq_clone(struct request *clone)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
-
-	blk_rq_unprep_clone(clone);
-
-	/*
-	 * It is possible for a clone_old_rq() allocated clone to
-	 * get passed in -- it may not yet have a request_queue.
-	 * This is known to occur if the error target replaces
-	 * a multipath target that has a request_fn queue stacked
-	 * on blk-mq queue(s).
-	 */
-	if (clone->q && clone->q->mq_ops)
-		/* stacked on blk-mq queue(s) */
-		tio->ti->type->release_clone_rq(clone);
-	else if (!md->queue->mq_ops)
-		/* request_fn queue stacked on request_fn queue(s) */
-		free_old_clone_request(md, clone);
-
-	if (!md->queue->mq_ops)
-		free_old_rq_tio(tio);
-}
-
 /*
  * Complete the clone and the original request.
  * Must be called without clone's queue lock held,
@@ -270,7 +223,9 @@ static void dm_end_request(struct request *clone, int error)
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
-	free_rq_clone(clone);
+	blk_rq_unprep_clone(clone);
+	tio->ti->type->release_clone_rq(clone);
+
 	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
@@ -279,22 +234,6 @@ static void dm_end_request(struct request *clone, int error)
 	rq_completed(md, rw, true);
 }
 
-static void dm_unprep_request(struct request *rq)
-{
-	struct dm_rq_target_io *tio = tio_from_request(rq);
-	struct request *clone = tio->clone;
-
-	if (!rq->q->mq_ops) {
-		rq->special = NULL;
-		rq->rq_flags &= ~RQF_DONTPREP;
-	}
-
-	if (clone)
-		free_rq_clone(clone);
-	else if (!tio->md->queue->mq_ops)
-		free_old_rq_tio(tio);
-}
-
 /*
  * Requeue the original request of a clone.
  */
@@ -333,7 +272,10 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	int rw = rq_data_dir(rq);
 
 	rq_end_stats(md, rq);
-	dm_unprep_request(rq);
+	if (tio->clone) {
+		blk_rq_unprep_clone(tio->clone);
+		tio->ti->type->release_clone_rq(tio->clone);
+	}
 
 	if (!rq->q->mq_ops)
 		dm_old_requeue_request(rq);
@@ -388,14 +330,11 @@ static void dm_softirq_done(struct request *rq)
 	if (!clone) {
 		rq_end_stats(tio->md, rq);
 		rw = rq_data_dir(rq);
-		if (!rq->q->mq_ops) {
+		if (!rq->q->mq_ops)
 			blk_end_request_all(rq, tio->error);
-			rq_completed(tio->md, rw, false);
-			free_old_rq_tio(tio);
-		} else {
+		else
 			blk_mq_end_request(rq, tio->error);
-			rq_completed(tio->md, rw, false);
-		}
+		rq_completed(tio->md, rw, false);
 		return;
 	}
 
@@ -439,16 +378,6 @@ static void end_clone_request(struct request *clone, int error)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	if (!clone->q->mq_ops) {
-		/*
-		 * For just cleaning up the information of the queue in which
-		 * the clone was dispatched.
-		 * The clone is *NOT* freed actually here because it is alloced
-		 * from dm own mempool (RQF_ALLOCED isn't set).
-		 */
-		__blk_put_request(clone->q, clone);
-	}
-
 	/*
 	 * Actual request completion is done in a softirq context which doesn't
 	 * hold the clone's queue lock.  Otherwise, deadlock could occur because:
@@ -506,28 +435,6 @@ static int setup_clone(struct request *clone, struct request *rq,
 	return 0;
 }
 
-static struct request *clone_old_rq(struct request *rq, struct mapped_device *md,
-				    struct dm_rq_target_io *tio, gfp_t gfp_mask)
-{
-	/*
-	 * Create clone for use with .request_fn request_queue
-	 */
-	struct request *clone;
-
-	clone = alloc_old_clone_request(md, gfp_mask);
-	if (!clone)
-		return NULL;
-
-	blk_rq_init(NULL, clone);
-	if (setup_clone(clone, rq, tio, gfp_mask)) {
-		/* -ENOMEM */
-		free_old_clone_request(md, clone);
-		return NULL;
-	}
-
-	return clone;
-}
-
 static void map_tio_request(struct kthread_work *work);
 
 static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
@@ -549,60 +456,6 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 		kthread_init_work(&tio->work, map_tio_request);
 }
 
-static struct dm_rq_target_io *dm_old_prep_tio(struct request *rq,
-					       struct mapped_device *md,
-					       gfp_t gfp_mask)
-{
-	struct dm_rq_target_io *tio;
-	int srcu_idx;
-	struct dm_table *table;
-
-	tio = alloc_old_rq_tio(md, gfp_mask);
-	if (!tio)
-		return NULL;
-
-	init_tio(tio, rq, md);
-
-	table = dm_get_live_table(md, &srcu_idx);
-	/*
-	 * Must clone a request if this .request_fn DM device
-	 * is stacked on .request_fn device(s).
-	 */
-	if (!dm_table_all_blk_mq_devices(table)) {
-		if (!clone_old_rq(rq, md, tio, gfp_mask)) {
-			dm_put_live_table(md, srcu_idx);
-			free_old_rq_tio(tio);
-			return NULL;
-		}
-	}
-	dm_put_live_table(md, srcu_idx);
-
-	return tio;
-}
-
-/*
- * Called with the queue lock held.
- */
-static int dm_old_prep_fn(struct request_queue *q, struct request *rq)
-{
-	struct mapped_device *md = q->queuedata;
-	struct dm_rq_target_io *tio;
-
-	if (unlikely(rq->special)) {
-		DMWARN("Already has something in rq->special.");
-		return BLKPREP_KILL;
-	}
-
-	tio = dm_old_prep_tio(rq, md, GFP_ATOMIC);
-	if (!tio)
-		return BLKPREP_DEFER;
-
-	rq->special = tio;
-	rq->rq_flags |= RQF_DONTPREP;
-
-	return BLKPREP_OK;
-}
-
 /*
  * Returns:
  * DM_MAPIO_*       : the request has been processed as indicated
@@ -617,31 +470,18 @@ static int map_request(struct dm_rq_target_io *tio)
 	struct request *rq = tio->orig;
 	struct request *clone = NULL;
 
-	if (tio->clone) {
-		clone = tio->clone;
-		r = ti->type->map_rq(ti, clone, &tio->info);
-		if (r == DM_MAPIO_DELAY_REQUEUE)
-			return DM_MAPIO_REQUEUE; /* .request_fn requeue is always immediate */
-	} else {
-		r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
-		if (r < 0) {
-			/* The target wants to complete the I/O */
-			dm_kill_unmapped_request(rq, r);
-			return r;
-		}
-		if (r == DM_MAPIO_REMAPPED &&
-		    setup_clone(clone, rq, tio, GFP_ATOMIC)) {
-			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
-			return DM_MAPIO_REQUEUE;
-		}
-	}
-
+	r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
 		break;
 	case DM_MAPIO_REMAPPED:
+		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
+			/* -ENOMEM */
+			ti->type->release_clone_rq(clone);
+			return DM_MAPIO_REQUEUE;
+		}
+
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
@@ -700,6 +540,29 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 	dm_get(md);
 }
 
+static int __dm_rq_init_rq(struct mapped_device *md, struct request *rq)
+{
+	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
+
+	/*
+	 * Must initialize md member of tio, otherwise it won't
+	 * be available in dm_mq_queue_rq.
+	 */
+	tio->md = md;
+
+	if (md->init_tio_pdu) {
+		/* target-specific per-io data is immediately after the tio */
+		tio->info.ptr = tio + 1;
+	}
+
+	return 0;
+}
+
+static int dm_rq_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
+{
+	return __dm_rq_init_rq(q->rq_alloc_data, rq);
+}
+
 static void map_tio_request(struct kthread_work *work)
 {
 	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io, work);
@@ -794,6 +657,7 @@ static void dm_old_request_fn(struct request_queue *q)
 		dm_start_request(md, rq);
 
 		tio = tio_from_request(rq);
+		init_tio(tio, rq, md);
 		/* Establish tio->ti before queuing work (map_tio_request) */
 		tio->ti = ti;
 		kthread_queue_work(&md->kworker, &tio->work);
@@ -804,10 +668,22 @@ static void dm_old_request_fn(struct request_queue *q)
 /*
  * Fully initialize a .request_fn request-based queue.
  */
-int dm_old_init_request_queue(struct mapped_device *md)
+int dm_old_init_request_queue(struct mapped_device *md, struct dm_table *t)
 {
+	struct dm_target *immutable_tgt;
+
 	/* Fully initialize the queue */
+	md->queue->cmd_size = sizeof(struct dm_rq_target_io);
+	md->queue->rq_alloc_data = md;
 	md->queue->request_fn = dm_old_request_fn;
+	md->queue->init_rq_fn = dm_rq_init_rq;
+
+	immutable_tgt = dm_table_get_immutable_target(t);
+	if (immutable_tgt && immutable_tgt->per_io_data_size) {
+		/* any target-specific per-io data is immediately after the tio */
+		md->queue->cmd_size += immutable_tgt->per_io_data_size;
+		md->init_tio_pdu = true;
+	}
 	if (blk_init_allocated_queue(md->queue) < 0)
 		return -EINVAL;
 
@@ -816,7 +692,6 @@ int dm_old_init_request_queue(struct mapped_device *md)
 
 	dm_init_normal_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
-	blk_queue_prep_rq(md->queue, dm_old_prep_fn);
 
 	/* Initialize the request-based DM worker thread */
 	kthread_init_worker(&md->kworker);
@@ -837,21 +712,7 @@ static int dm_mq_init_request(void *data, struct request *rq,
 		       unsigned int hctx_idx, unsigned int request_idx,
 		       unsigned int numa_node)
 {
-	struct mapped_device *md = data;
-	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
-
-	/*
-	 * Must initialize md member of tio, otherwise it won't
-	 * be available in dm_mq_queue_rq.
-	 */
-	tio->md = md;
-
-	if (md->init_tio_pdu) {
-		/* target-specific per-io data is immediately after the tio */
-		tio->info.ptr = tio + 1;
-	}
-
-	return 0;
+	return __dm_rq_init_rq(data, rq);
 }
 
 static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 4da06ca..f0020d2 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -48,7 +48,7 @@ struct dm_rq_clone_bio_info {
 bool dm_use_blk_mq_default(void);
 bool dm_use_blk_mq(struct mapped_device *md);
 
-int dm_old_init_request_queue(struct mapped_device *md);
+int dm_old_init_request_queue(struct mapped_device *md, struct dm_table *t);
 int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t);
 void dm_mq_cleanup_mapped_device(struct mapped_device *md);
 
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 710ae28..43d3445 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -131,12 +131,6 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
 	return -EIO;
 }
 
-static int io_err_map_rq(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
-{
-	return -EIO;
-}
-
 static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
 				   union map_info *map_context,
 				   struct request **clone)
@@ -161,7 +155,6 @@ static struct target_type error_target = {
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
-	.map_rq = io_err_map_rq,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
 	.direct_access = io_err_direct_access,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..ff4a29a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -91,7 +91,6 @@ static int dm_numa_node = DM_NUMA_NODE;
  */
 struct dm_md_mempools {
 	mempool_t *io_pool;
-	mempool_t *rq_pool;
 	struct bio_set *bs;
 };
 
@@ -1419,7 +1418,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	if (md->kworker_task)
 		kthread_stop(md->kworker_task);
 	mempool_destroy(md->io_pool);
-	mempool_destroy(md->rq_pool);
 	if (md->bs)
 		bioset_free(md->bs);
 
@@ -1595,12 +1593,10 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		goto out;
 	}
 
-	BUG_ON(!p || md->io_pool || md->rq_pool || md->bs);
+	BUG_ON(!p || md->io_pool || md->bs);
 
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
-	md->rq_pool = p->rq_pool;
-	p->rq_pool = NULL;
 	md->bs = p->bs;
 	p->bs = NULL;
 
@@ -1777,7 +1773,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
-		r = dm_old_init_request_queue(md);
+		r = dm_old_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based mapped device");
 			return r;
@@ -2493,7 +2489,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 					    unsigned integrity, unsigned per_io_data_size)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
-	struct kmem_cache *cachep = NULL;
 	unsigned int pool_size = 0;
 	unsigned int front_pad;
 
@@ -2503,20 +2498,16 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-		cachep = _io_cache;
 		pool_size = dm_get_reserved_bio_based_ios();
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
+	
+		pools->io_pool = mempool_create_slab_pool(pool_size, _io_cache);
+		if (!pools->io_pool)
+			goto out;
 		break;
 	case DM_TYPE_REQUEST_BASED:
-		cachep = _rq_tio_cache;
-		pool_size = dm_get_reserved_rq_based_ios();
-		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
-		if (!pools->rq_pool)
-			goto out;
-		/* fall through to setup remaining rq-based pools */
 	case DM_TYPE_MQ_REQUEST_BASED:
-		if (!pool_size)
-			pool_size = dm_get_reserved_rq_based_ios();
+		pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_io_data_size is used for blk-mq pdu at queue allocation */
 		break;
@@ -2524,12 +2515,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 		BUG();
 	}
 
-	if (cachep) {
-		pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
-		if (!pools->io_pool)
-			goto out;
-	}
-
 	pools->bs = bioset_create_nobvec(pool_size, front_pad);
 	if (!pools->bs)
 		goto out;
@@ -2551,7 +2536,6 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 		return;
 
 	mempool_destroy(pools->io_pool);
-	mempool_destroy(pools->rq_pool);
 
 	if (pools->bs)
 		bioset_free(pools->bs);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f0aad08..f298b01 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -95,8 +95,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 /*
  * To check whether the target type is request-based or not (bio-based).
  */
-#define dm_target_request_based(t) (((t)->type->map_rq != NULL) || \
-				    ((t)->type->clone_and_map_rq != NULL))
+#define dm_target_request_based(t) ((t)->type->clone_and_map_rq != NULL)
 
 /*
  * To check whether the target type is a hybrid (capable of being
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ef7962e..a7e6903 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -55,8 +55,6 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
  * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
-typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
-				  union map_info *map_context);
 typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
@@ -163,7 +161,6 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
-	dm_map_request_fn map_rq;
 	dm_clone_and_map_request_fn clone_and_map_rq;
 	dm_release_clone_request_fn release_clone_rq;
 	dm_endio_fn end_io;
-- 
2.1.4

