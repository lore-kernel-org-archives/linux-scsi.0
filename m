From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 1/5] blk_end_request: request-based dm
	core
Date: Fri, 31 Aug 2007 18:44:27 -0400 (EDT)
Message-ID: <20070831.184427.112285010.k-ueda@ct.jp.nec.com>
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
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch is an examle of block device stacking at request level,
showing the necessity of blk_end_request() and how the new
rq->end_io() hook is used.
Request-based dm itself is still under development and not ready
for inclusion.

This patch adds request-based dm feature to dm core.
Request-based dm hooks clone's ->end_io() to check errors of clone
returned from device drivers.  (See clone_end_request())

# Currently, request-based dm can be turned on by ioctl at dm device
# creation time, so the userspace patches are needed.
# The ioctl from userspace is ignored if kernel doesn't support it,
# so please update userspace tools first when you try this.
# (If kernel was updated first, you would hit kernel panic.)

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c             |    9
 drivers/md/dm-hw-handler.h    |    1
 drivers/md/dm-ioctl.c         |    5
 drivers/md/dm-table.c         |   23 +
 drivers/md/dm.c               |  514 +++++++++++++++++++++++++++++++++++++++++- drivers/md/dm.h               |   13 +
 drivers/scsi/scsi_lib.c       |   38 +++
 include/linux/blkdev.h        |    6
 include/linux/device-mapper.h |   35 ++
 include/linux/dm-ioctl.h      |    9
 10 files changed, 638 insertions(+), 15 deletions(-)

diff -rupN 07-change-end-io/block/ll_rw_blk.c a1-rqdm-core/block/ll_rw_blk.c
--- 07-change-end-io/block/ll_rw_blk.c	2007-08-24 12:31:41.000000000 -0400
+++ a1-rqdm-core/block/ll_rw_blk.c	2007-08-29 13:53:12.000000000 -0400
@@ -177,6 +177,13 @@ void blk_queue_softirq_done(struct reque
 
 EXPORT_SYMBOL(blk_queue_softirq_done);
 
+void blk_queue_device_congested(struct request_queue *q, device_congested_fn *fn)
+{
+	q->device_congested_fn = fn;
+}
+
+EXPORT_SYMBOL_GPL(blk_queue_device_congested);
+
 /**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
@@ -3692,7 +3699,7 @@ int blk_end_io(struct request *rq, int u
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
 
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+	if ((blk_fs_request(rq) || blk_pc_request(rq)) && !blk_cloned_rq(rq)) {
 		if (__end_that_request_first(rq, uptodate, nr_bytes))
 			return 1;
 	}
diff -rupN 07-change-end-io/drivers/md/dm.c a1-rqdm-core/drivers/md/dm.c
--- 07-change-end-io/drivers/md/dm.c	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/drivers/md/dm.c	2007-08-30 11:19:30.000000000 -0400
@@ -51,6 +51,22 @@ struct dm_target_io {
 	union map_info info;
 };
 
+/*
+ * For request based dm.
+ * One of these is allocated per request.
+ *
+ * Since assuming "original request : cloned request = 1 : 1" and
+ * a counter for number of clones like struct dm_io.io_count isn't needed,
+ * struct dm_io and struct target_io can merge.
+ */
+struct dm_rq_target_io {
+	struct mapped_device *md;
+	int error;
+	struct request *rq;
+	struct dm_target *ti;
+	union map_info info;
+};
+
 union map_info *dm_get_mapinfo(struct bio *bio)
 {
 	if (bio && bio->bi_private)
@@ -58,6 +74,14 @@ union map_info *dm_get_mapinfo(struct bi
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
@@ -70,6 +94,13 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
 
+/*
+ * Bits for the md->features field.
+ */
+#define DM_FEAT_REQUEST_BASE (1 << 0)
+
+#define dm_feat_rq_base(md) ((md)->features & DM_FEAT_REQUEST_BASE)
+
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct semaphore suspend_lock;
@@ -79,6 +110,7 @@ struct mapped_device {
 	atomic_t open_count;
 
 	unsigned long flags;
+	unsigned long features;
 
 	struct request_queue *queue;
 	struct gendisk *disk;
@@ -121,11 +153,16 @@ struct mapped_device {
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
+
+	/* For saving the address of __make_request for request based dm */
+	make_request_fn *saved_make_request_fn;
 };
 
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
+static struct kmem_cache *_rq_cache;     /* clone pool for request-based dm */
+static struct kmem_cache *_rq_tio_cache; /* target_io pool for request-based dm */
 
 static int __init local_init(void)
 {
@@ -143,9 +180,27 @@ static int __init local_init(void)
 		return -ENOMEM;
 	}
 
+	_rq_cache = kmem_cache_create("dm_rq", sizeof(struct request),
+				      0, 0, NULL);
+	if (!_rq_cache) {
+		kmem_cache_destroy(_tio_cache);
+		kmem_cache_destroy(_io_cache);
+		return -ENOMEM;
+	}
+
+	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
+	if (!_rq_tio_cache) {
+		kmem_cache_destroy(_rq_cache);
+		kmem_cache_destroy(_tio_cache);
+		kmem_cache_destroy(_io_cache);
+		return -ENOMEM;
+	}
+
 	_major = major;
 	r = register_blkdev(_major, _name);
 	if (r < 0) {
+		kmem_cache_destroy(_rq_tio_cache);
+		kmem_cache_destroy(_rq_cache);
 		kmem_cache_destroy(_tio_cache);
 		kmem_cache_destroy(_io_cache);
 		return r;
@@ -159,6 +214,8 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
+	kmem_cache_destroy(_rq_tio_cache);
+	kmem_cache_destroy(_rq_cache);
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
@@ -341,6 +398,27 @@ static void free_tio(struct mapped_devic
 	mempool_free(tio, md->tio_pool);
 }
 
+static inline struct request *alloc_rq(struct mapped_device *md)
+{
+	return mempool_alloc(md->io_pool, GFP_ATOMIC);
+}
+
+static inline void free_rq(struct mapped_device *md, struct request *rq)
+{
+	mempool_free(rq, md->io_pool);
+}
+
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
@@ -434,6 +512,93 @@ int dm_set_geometry(struct mapped_device
 	return 0;
 }
 
+/*
+ * The queue is only valid as long as you have a reference
+ * count on 'md'.
+ */
+struct request_queue *dm_get_queue(struct mapped_device *md)
+{
+	if (blk_get_queue(md->queue))
+		return NULL;
+
+	return md->queue;
+}
+EXPORT_SYMBOL_GPL(dm_get_queue);
+
+void dm_put_queue(struct request_queue *q)
+{
+	blk_put_queue(q);
+}
+EXPORT_SYMBOL_GPL(dm_put_queue);
+
+void dm_stop_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_stop_queue);
+
+void dm_start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_queue_stopped(q))
+		blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_start_queue);
+
+void __dm_requeue_request(struct request_queue *q, struct request *rq)
+{
+	if (elv_queue_empty(q))
+		blk_plug_device(q);
+	blk_requeue_request(q, rq);
+}
+EXPORT_SYMBOL_GPL(__dm_requeue_request);
+
+void dm_requeue_request(struct request_queue *q, struct request *rq)
+{
+	unsigned long flags = 0UL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__dm_requeue_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_requeue_request);
+
+void dm_dispatch_request(struct request_queue *q, struct request *rq)
+{
+	int where = ELEVATOR_INSERT_BACK;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	/* Initialize statistic stuff */
+	disk_round_stats(rq->rq_disk);
+	rq->start_time = jiffies;
+	rq->rq_disk->in_flight++;
+
+	__elv_add_request(q, rq, where, 0);
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static void kill_request(struct request *rq)
+{
+	int nr_bytes = rq->hard_nr_sectors << 9;
+
+	if (!nr_bytes)
+		nr_bytes = rq->data_len;
+
+	rq->cmd_flags |= REQ_QUIET;
+	blk_end_request(rq, 0, nr_bytes);
+}
+
 /*-----------------------------------------------------------------
  * CRUD START:
  *   A more elegant soln is in the works that uses the queue
@@ -533,6 +698,152 @@ static int clone_endio(struct bio *bio, 
 	return r;
 }
 
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
+static void dec_rq_pending(struct dm_rq_target_io *tio)
+{
+	if (!atomic_dec_return(&tio->md->pending))
+		/* nudge anyone waiting on suspend queue */
+		wake_up(&tio->md->wait);
+}
+
+static void finish_clone(struct request *clone, int needlock,
+			 int (drv_callback)(struct request *))
+{
+	if (!clone->q)
+		/*
+		 * The clone was not dispatched into underlying devices and
+		 * it means the caller is not underlying device driver,
+		 * the caller should be dm. (e.g. dispatch_queued_ios() of
+		 * dm-multipath)
+		 * So no need to do here for this clone.
+		 */
+		return;
+
+	/*
+	 * The clone is *NOT* freed actually here because it is alloced from
+	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
+	 *
+	 * The uptodate and nr_bytes arguments of blk_end_io() don't matter
+	 * because they aren't used for dm's clones.
+	 */
+	if (blk_end_io(clone, 1, 0, needlock, NULL, drv_callback))
+		DMWARN("dm ignores the immediate return request of callback.");
+}
+
+static void clean_clone(struct request *clone)
+{
+	clone->special = NULL;
+	clone->errors = 0;
+}
+
+static int clone_end_request(struct request *clone, int uptodate, int nr_bytes,
+			     int needlock, int (drv_callback)(struct request *))
+{
+	int r = 0, error = 0, rw = rq_data_dir(clone);
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_first_fn endio_first = tio->ti->type->rq_end_io_first;
+	dm_request_endio_fn endio = tio->ti->type->rq_end_io;
+	dm_request_queue_in_tgt_fn queue_in_tgt = tio->ti->type->queue_in_tgt;
+	struct request *orig = tio->rq;
+	struct request_queue *q = clone->q, *q_orig = orig->q;
+
+	if (blk_fs_request(clone) && clone->rq_disk)
+		disk_stat_add(clone->rq_disk, sectors[rw], nr_bytes >> 9);
+
+	if (end_io_error(uptodate))
+		error = !uptodate ? -EIO : uptodate;
+
+	if (endio_first) {
+		r = endio_first(tio->ti, clone, error, &tio->info);
+		switch (r) {
+		case 0:
+			/* succeeded */
+			break;
+		case 1:
+			/* the target wants to handle the io without unmap */
+			finish_clone(clone, needlock, drv_callback);
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
+		case 2:
+			/* The target wants to requeue the original request */
+			if (needlock)
+				dm_requeue_request(q_orig, orig);
+			else
+				__dm_requeue_request(q_orig, orig);
+
+			goto free_clone;
+		default:
+			if (r >= 0) {
+				DMWARN("unimplemented target endio return value: %d", r);
+				BUG();
+			}
+
+			/* 
+			 * the target detected error, but couldn't retry.
+			 * direct the error to upper layer.
+			 */
+			uptodate = r;
+			break;
+		}
+	}
+
+	/* Complete the original request's chunk */
+	r = blk_end_request(orig, uptodate, nr_bytes);
+
+	/*
+	 * Recopy the original request fields that were updated
+         * in blk_end_request() to the clone.
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
+	 * So 
+	 */
+
+	if (endio)
+		endio(tio->ti, clone, error, &tio->info);
+
+	finish_clone(clone, needlock, drv_callback);
+
+	blk_run_queue(q_orig);
+
+	dec_rq_pending(tio);
+	free_rq(tio->md, clone);
+	free_rq_tio(tio->md, tio);
+
+	return 0;
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -844,6 +1155,166 @@ static int dm_request(struct request_que
 	return 0;
 }
 
+/* FIXME */
+static int dm_make_request(struct request_queue *q, struct bio *bio)
+{
+	int r = 0;
+	struct mapped_device *md = (struct mapped_device *)q->queuedata;
+
+	r = md->saved_make_request_fn(q, bio); /* call __make_request() */
+
+	return r;
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
+//	RB_CLEAR_NODE(&clone->rb_node);
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
+	clone->end_io = clone_end_request;
+	clone->end_io_data = NULL;
+}
+
+int dm_underlying_device_congested(struct request_queue *q)
+{
+	if (q->device_congested_fn)
+		return q->device_congested_fn(q);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_underlying_device_congested);
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
+	tio->rq = rq;
+	tio->ti = ti;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = alloc_rq(md);
+	if (!clone) {
+		/* -ENOMEM */
+		free_rq_tio(md, tio);
+		goto requeue;
+	}
+	setup_clone(clone, rq);
+	clone->end_io_data = tio;
+
+	atomic_inc(&md->pending);
+	r = ti->type->map_rq(ti, clone, &tio->info);
+	switch (r) {
+	case 0:
+		/* the target has taken the request to submit by itself */
+		break;
+	case 1:
+		/* the clone has been remapped so dispatch it */
+		dm_dispatch_request(clone->q, clone);
+		break;
+	case 2:
+		/* the target has requested to requeue the original request */
+		dec_rq_pending(tio);
+		free_rq_tio(md, tio);
+		free_rq(md, clone);
+		goto requeue;
+	default:
+		if (r >= 0) {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		dec_rq_pending(tio);
+		free_rq_tio(md, tio);
+		free_rq(md, clone);
+		kill_request(rq);
+		break;
+	}
+
+	return 0;
+
+requeue:
+	return 1;
+}
+
+/*
+ * q->request_fn for request based dm.
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
+	while (!blk_queue_plugged(q)) {
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
+			__dm_requeue_request(q, rq);
+	}
+
+	dm_table_put(map);
+
+	return;
+}
+
 static int dm_flush_all(struct request_queue *q, struct gendisk *disk,
 			sector_t *error_sector)
 {
@@ -865,6 +1336,9 @@ static void dm_unplug_all(struct request
 	struct dm_table *map = dm_get_table(md);
 
 	if (map) {
+		if (dm_feat_rq_base(md))
+			generic_unplug_device(q);
+
 		dm_table_unplug_all(map);
 		dm_table_put(map);
 	}
@@ -966,7 +1440,7 @@ static struct block_device_operations dm
 /*
  * Allocate and initialise a blank device with a given minor.
  */
-static struct mapped_device *alloc_dev(int minor)
+static struct mapped_device *alloc_dev(int minor, int request_base)
 {
 	int r;
 	struct mapped_device *md = kmalloc(sizeof(*md), GFP_KERNEL);
@@ -997,23 +1471,35 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
 
-	md->queue = blk_alloc_queue(GFP_KERNEL);
+	if (request_base) {
+		md->features |= DM_FEAT_REQUEST_BASE;
+		md->queue = blk_init_queue(dm_request_fn, NULL);
+	} else {
+		md->queue = blk_alloc_queue(GFP_KERNEL);
+	}
 	if (!md->queue)
 		goto bad1_free_minor;
 
 	md->queue->queuedata = md;
-	md->queue->backing_dev_info.congested_fn = dm_any_congested;
-	md->queue->backing_dev_info.congested_data = md;
-	blk_queue_make_request(md->queue, dm_request);
+	if (request_base) {
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		blk_queue_make_request(md->queue, dm_make_request);
+	} else {
+		md->queue->backing_dev_info.congested_fn = dm_any_congested;
+		md->queue->backing_dev_info.congested_data = md;
+		blk_queue_make_request(md->queue, dm_request);
+	}
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	md->queue->issue_flush_fn = dm_flush_all;
 
-	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
+	md->io_pool = mempool_create_slab_pool(MIN_IOS,
+				request_base ? _rq_cache : _io_cache);
 	if (!md->io_pool)
 		goto bad2;
 
-	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _tio_cache);
+	md->tio_pool = mempool_create_slab_pool(MIN_IOS,
+				request_base ? _rq_tio_cache : _tio_cache);
 	if (!md->tio_pool)
 		goto bad3;
 
@@ -1154,11 +1640,12 @@ static void __unbind(struct mapped_devic
 /*
  * Constructor for a new device.
  */
-int dm_create(int minor, struct mapped_device **result)
+int dm_create(int minor, struct mapped_device **result, unsigned create_flags)
 {
 	struct mapped_device *md;
+	int request_base = create_flags & DM_CREATE_REQUEST_BASE_FLAG ? 1 : 0;
 
-	md = alloc_dev(minor);
+	md = alloc_dev(minor, request_base);
 	if (!md)
 		return -ENXIO;
 
@@ -1383,9 +1870,13 @@ int dm_suspend(struct mapped_device *md,
 	up_write(&md->io_lock);
 
 	/* unplug */
-	if (map)
+	if (map) {
 		dm_table_unplug_all(map);
 
+		if (dm_feat_rq_base(md))
+			dm_stop_queue(md->queue);
+	}
+
 	/*
 	 * Then we wait for the already mapped ios to
 	 * complete.
@@ -1475,6 +1966,9 @@ int dm_resume(struct mapped_device *md)
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
+	if (dm_feat_rq_base(md))
+		dm_start_queue(md->queue);
+
 	r = dm_table_resume_targets(map);
 	if (r)
 		goto out;
diff -rupN 07-change-end-io/drivers/md/dm.h a1-rqdm-core/drivers/md/dm.h
--- 07-change-end-io/drivers/md/dm.h	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/drivers/md/dm.h	2007-08-28 15:21:48.000000000 -0400
@@ -84,6 +84,11 @@
 #define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
 
 /*
+ * Create feature flags
+ */
+#define DM_CREATE_REQUEST_BASE_FLAG	(1 << 0)
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
@@ -112,6 +117,7 @@ int dm_table_resume_targets(struct dm_ta
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 int dm_table_flush_all(struct dm_table *t);
+int dm_table_underlying_device_congested(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
@@ -124,6 +130,12 @@ int dm_target_iterate(void (*iter_func)(
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
@@ -180,6 +192,7 @@ void dm_stripe_exit(void);
 
 void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
+union map_info *dm_get_rq_mapinfo(struct request *rq);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
diff -rupN 07-change-end-io/drivers/md/dm-hw-handler.h a1-rqdm-core/drivers/md/dm-hw-handler.h
--- 07-change-end-io/drivers/md/dm-hw-handler.h	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/drivers/md/dm-hw-handler.h	2007-08-28 15:21:48.000000000 -0400
@@ -35,6 +35,7 @@ struct hw_handler_type {
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
 			 struct dm_path *path);
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
+	unsigned (*error_rq) (struct hw_handler *hwh, struct request *rq);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
 };
diff -rupN 07-change-end-io/drivers/md/dm-ioctl.c a1-rqdm-core/drivers/md/dm-ioctl.c
--- 07-change-end-io/drivers/md/dm-ioctl.c	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/drivers/md/dm-ioctl.c	2007-08-28 15:21:48.000000000 -0400
@@ -565,6 +565,7 @@ static int dev_create(struct dm_ioctl *p
 {
 	int r, m = DM_ANY_MINOR;
 	struct mapped_device *md;
+	unsigned create_flags = 0;
 
 	r = check_name(param->name);
 	if (r)
@@ -572,8 +573,10 @@ static int dev_create(struct dm_ioctl *p
 
 	if (param->flags & DM_PERSISTENT_DEV_FLAG)
 		m = MINOR(huge_decode_dev(param->dev));
+	if (param->flags & DM_REQUEST_BASE_FLAG)
+		create_flags |= DM_CREATE_REQUEST_BASE_FLAG;
 
-	r = dm_create(m, &md);
+	r = dm_create(m, &md, create_flags);
 	if (r)
 		return r;
 
diff -rupN 07-change-end-io/drivers/md/dm-table.c a1-rqdm-core/drivers/md/dm-table.c
--- 07-change-end-io/drivers/md/dm-table.c	2007-08-22 18:54:04.000000000 -0400
+++ a1-rqdm-core/drivers/md/dm-table.c	2007-08-28 15:21:48.000000000 -0400
@@ -1025,6 +1025,29 @@ int dm_table_flush_all(struct dm_table *
 	return ret;
 }
 
+int dm_table_underlying_device_congested(struct dm_table *t)
+{
+	int r = 0;
+	struct list_head *d, *devices = dm_table_get_devices(t);
+	struct dm_dev *dd;
+	struct request_queue *q;
+
+	for (d = devices->next; d != devices; d = d->next) {
+		dd = list_entry(d, struct dm_dev, list);
+		q = bdev_get_queue(dd->bdev);
+
+		/*
+		 * We should use "&=" and target driver should chose
+		 * not congested device by using a table function like
+		 * dm_table_uncongested_device().
+		 */
+		r &= dm_underlying_device_congested(q);
+//		r |= dm_underlying_device_congested(q);
+	}
+
+	return r;
+}
+
 struct mapped_device *dm_table_get_md(struct dm_table *t)
 {
 	dm_get(t->md);
diff -rupN 07-change-end-io/drivers/scsi/scsi_lib.c a1-rqdm-core/drivers/scsi/scsi_lib.c
--- 07-change-end-io/drivers/scsi/scsi_lib.c	2007-08-24 12:26:06.000000000 -0400
+++ a1-rqdm-core/drivers/scsi/scsi_lib.c	2007-08-28 15:21:48.000000000 -0400
@@ -1401,6 +1401,43 @@ static void scsi_softirq_done(struct req
 	}
 }
 
+static int scsi_device_congested(struct request_queue *q)
+{
+	int r = 0;
+	struct scsi_device *sdev = q->queuedata;
+//	struct Scsi_Host *shost;
+//	unsigned long flags = 0UL;
+
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		/*
+		 * Something may happened.  We handle it in scsi_request_fn.
+		 * Please dispatch the requests in the queue.
+		 */
+		return 0;
+
+	if ((sdev->device_busy >= sdev->queue_depth) || sdev->device_blocked ||
+	    (sdev->single_lun && scsi_target(sdev)->starget_sdev_user &&
+	    scsi_target(sdev)->starget_sdev_user != sdev)) {
+		r = 1;
+		goto out;
+	}
+
+/*
+	shost = sdev->host;
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_in_recovery(shost) ||
+	    (shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
+	    shost->host_blocked || shost->host_self_blocked)
+		r = 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+*/
+
+out:
+	put_device(&sdev->sdev_gendev);
+
+	return r;
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1590,6 +1627,7 @@ struct request_queue *scsi_alloc_queue(s
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
+	blk_queue_device_congested(q, scsi_device_congested);
 	return q;
 }
 
diff -rupN 07-change-end-io/include/linux/blkdev.h a1-rqdm-core/include/linux/blkdev.h
--- 07-change-end-io/include/linux/blkdev.h	2007-08-24 12:32:44.000000000 -0400
+++ a1-rqdm-core/include/linux/blkdev.h	2007-08-29 13:53:12.000000000 -0400
@@ -203,6 +203,7 @@ enum rq_flag_bits {
 	__REQ_RW_SYNC,		/* request is sync (O_DIRECT) */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
+	__REQ_CLONED,		/* request is a clone of another request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -224,6 +225,7 @@ enum rq_flag_bits {
 #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
+#define REQ_CLONED	(1 << __REQ_CLONED)
 
 #define BLK_MAX_CDB	16
 
@@ -348,6 +350,7 @@ typedef int (merge_bvec_fn) (struct requ
 typedef int (issue_flush_fn) (struct request_queue *, struct gendisk *, sector_t *);
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
+typedef int (device_congested_fn) (struct request_queue *q);
 
 enum blk_queue_state {
 	Queue_down,
@@ -386,6 +389,7 @@ struct request_queue
 	issue_flush_fn		*issue_flush_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
+	device_congested_fn	*device_congested_fn;
 
 	/*
 	 * Dispatch queue sorting
@@ -555,6 +559,7 @@ enum {
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_cloned_rq(rq)	((rq)->cmd_flags & REQ_CLONED)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
@@ -786,6 +791,7 @@ extern void blk_queue_prep_rq(struct req
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
+extern void blk_queue_device_congested(struct request_queue *, device_congested_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
 extern void blk_queue_issue_flush_fn(struct request_queue *, issue_flush_fn *);
diff -rupN 07-change-end-io/include/linux/device-mapper.h a1-rqdm-core/include/linux/device-mapper.h
--- 07-change-end-io/include/linux/device-mapper.h	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/include/linux/device-mapper.h	2007-08-28 15:21:48.000000000 -0400
@@ -10,6 +10,8 @@
 
 #ifdef __KERNEL__
 
+struct request;
+struct request_queue;
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -45,6 +47,9 @@ typedef void (*dm_dtr_fn) (struct dm_tar
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
 
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
+				  union map_info *map_context);
+
 /*
  * Returns:
  * < 0 : error (currently ignored)
@@ -57,6 +62,18 @@ typedef int (*dm_endio_fn) (struct dm_ta
 			    struct bio *bio, int error,
 			    union map_info *map_context);
 
+typedef int (*dm_request_endio_first_fn) (struct dm_target *ti,
+					  struct request *clone, int error,
+					  union map_info *map_context);
+
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+				    struct request *clone, int error,
+				    union map_info *map_context);
+
+typedef void (*dm_request_queue_in_tgt_fn) (struct dm_target *ti,
+					    struct request *clone,
+					    union map_info *map_context);
+
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
@@ -71,6 +88,7 @@ typedef int (*dm_message_fn) (struct dm_
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 			    struct file *filp, unsigned int cmd,
 			    unsigned long arg);
+typedef int (*dm_congested_fn) (struct dm_target *ti);
 
 void dm_error(const char *message);
 
@@ -98,7 +116,11 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
+	dm_request_endio_first_fn rq_end_io_first;
+	dm_request_endio_fn rq_end_io;
+	dm_request_queue_in_tgt_fn queue_in_tgt;
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
@@ -107,6 +129,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
+	dm_congested_fn congested;
 };
 
 struct io_restrictions {
@@ -142,6 +165,8 @@ struct dm_target {
 
 	/* Used to provide an error string from the ctr */
 	char *error;
+
+	struct request_queue *queue;
 };
 
 int dm_register_target(struct target_type *t);
@@ -157,7 +182,7 @@ int dm_unregister_target(struct target_t
  * DM_ANY_MINOR chooses the next available minor number.
  */
 #define DM_ANY_MINOR (-1)
-int dm_create(int minor, struct mapped_device **md);
+int dm_create(int minor, struct mapped_device **md, unsigned create_flags);
 
 /*
  * Reference counting for md.
@@ -167,6 +192,14 @@ void dm_get(struct mapped_device *md);
 void dm_put(struct mapped_device *md);
 
 /*
+ * Queue operations
+ */
+struct request_queue *dm_get_queue(struct mapped_device *md);
+void dm_put_queue(struct request_queue *q);
+void dm_stop_queue(struct request_queue *q);
+void dm_start_queue(struct request_queue *q);
+
+/*
  * An arbitrary pointer may be stored alongside a mapped device.
  */
 void dm_set_mdptr(struct mapped_device *md, void *ptr);
diff -rupN 07-change-end-io/include/linux/dm-ioctl.h a1-rqdm-core/include/linux/dm-ioctl.h
--- 07-change-end-io/include/linux/dm-ioctl.h	2007-08-13 00:25:24.000000000 -0400
+++ a1-rqdm-core/include/linux/dm-ioctl.h	2007-08-28 15:21:48.000000000 -0400
@@ -285,9 +285,9 @@ typedef char ioctl_struct[308];
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	11
+#define DM_VERSION_MINOR	12
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2006-10-12)"
+#define DM_VERSION_EXTRA	"-ioctl (2006-12-14)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -328,4 +328,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_NOFLUSH_FLAG		(1 << 11) /* In */
 
+/*
+ * Set this to create request based device-mapper device.
+ */
+#define DM_REQUEST_BASE_FLAG	(1 << 12) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
