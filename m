From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 11/13] dm: enable request-based dm
Date: Fri, 12 Sep 2008 10:46:34 -0400 (EDT)
Message-ID: <20080912.104634.08318008.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch enables request-based dm.

o Request-based dm and bio-based dm coexist, since there are
  some target drivers which are more fitting to bio-based dm.
  Also, there are other bio-based devices in the kernel
  (e.g. md, loop).
  Since bio-based device can't receive struct request,
  there are some limitations on device stacking between
  bio-based and request-based.

                     type of underlying device
                   bio-based      requeset-based
   ----------------------------------------------
    bio-based         OK                OK
    request-based     NG                OK

  The device type is recognized by the queue flag in the kernel,
  so dm follows that.

o The type of a dm device is decided at the first table loading time.
  Until then, mempool creations are deferred, since mempools for
  request-based dm are different from those for bio-based dm.
  Once the type of a dm device is decided, the type can't be changed.

o Currently, request-based dm supports only tables that have a single
  target.  To support multiple targets, we need to support request
  splitting or prevent bio/request from spanning multiple targets.
  The former needs lots of changes in the block layer, and the latter
  needs that all target drivers support merge() function.
  Both will take a time.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c         |   13 ++++
 drivers/md/dm-table.c         |   68 +++++++++++++++++++++++
 drivers/md/dm.c               |  122 ++++++++++++++++++++++++++++++++++--------
 drivers/md/dm.h               |   15 +++++
 include/linux/device-mapper.h |    1 
 5 files changed, 196 insertions(+), 23 deletions(-)

Index: 2.6.27-rc6/drivers/md/dm-table.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm-table.c
+++ 2.6.27-rc6/drivers/md/dm-table.c
@@ -108,6 +108,8 @@ static void combine_restrictions_low(str
 	lhs->bounce_pfn = min_not_zero(lhs->bounce_pfn, rhs->bounce_pfn);
 
 	lhs->no_cluster |= rhs->no_cluster;
+
+	lhs->no_request_stacking |= rhs->no_request_stacking;
 }
 
 /*
@@ -522,6 +524,8 @@ void dm_set_device_limits(struct dm_targ
 	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, q->bounce_pfn);
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	rs->no_request_stacking |= !blk_queue_stackable(q);
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
@@ -731,6 +735,66 @@ int dm_table_add_target(struct dm_table 
 	return r;
 }
 
+int dm_table_set_type(struct dm_table *t)
+{
+	int i;
+	int bio_based = 0, request_based = 0;
+	struct dm_target *tgt;
+
+	for (i = 0; i < t->num_targets; i++) {
+		tgt = t->targets + i;
+		if (tgt->type->map_rq)
+			request_based = 1;
+		else
+			bio_based = 1;
+
+		if (bio_based && request_based) {
+			DMWARN("Inconsistent table: different target types"
+			       " can't be mixed up");
+			return -EINVAL;
+		}
+	}
+
+	if (bio_based) {
+		/* We must use this table as bio-based */
+		t->limits.no_request_stacking = 1;
+		return 0;
+	}
+
+	BUG_ON(!request_based); /* No targets in this table */
+
+	/* Non-request-stackable devices can't be used for request-based dm */
+	if (t->limits.no_request_stacking) {
+		DMWARN("table load rejected: including non-request-stackable"
+		       " devices");
+		return -EINVAL;
+	}
+
+	/*
+	 * Request-based dm supports only tables that have a single target now.
+	 * To support multiple targets, request splitting support is needed,
+	 * and that needs lots of changes in the block-layer.
+	 * (e.g. request completion process for partial completion.)
+	 */
+	if (t->num_targets > 1) {
+		DMWARN("Request-based dm doesn't support multiple targets yet");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int dm_table_get_type(struct dm_table *t)
+{
+	return t->limits.no_request_stacking ?
+		DM_TYPE_BIO_BASED : DM_TYPE_REQUEST_BASED;
+}
+
+int dm_table_request_based(struct dm_table *t)
+{
+	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
+}
+
 static int setup_indexes(struct dm_table *t)
 {
 	int i;
@@ -861,6 +925,10 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	if (t->limits.no_request_stacking)
+		queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_STACKABLE, q);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
Index: 2.6.27-rc6/drivers/md/dm.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm.c
+++ 2.6.27-rc6/drivers/md/dm.c
@@ -160,6 +160,8 @@ struct mapped_device {
 
 	struct bio_set *bs;
 
+	unsigned int mempool_type; /* Type of mempools above. */
+
 	/*
 	 * Event handling.
 	 */
@@ -1697,10 +1699,22 @@ static struct mapped_device *alloc_dev(i
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_alloc_queue(GFP_KERNEL);
+	md->queue = blk_init_queue(dm_request_fn, NULL);
 	if (!md->queue)
 		goto bad_queue;
 
+	/*
+	 * Request-based dm devices cannot be stacked on top of bio-based dm
+	 * devices.  The type of this dm device has not been decided yet,
+	 * although we initialized the queue using blk_init_queue().
+	 * The type is decided at the first table loading time.
+	 * To prevent problematic device stacking, clear the queue flag
+	 * for request stacking support until then.
+	 *
+	 * This queue is new, so no concurrency on the queue_flags.
+	 */
+	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+	md->saved_make_request_fn = md->queue->make_request_fn;
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_congested;
 	md->queue->backing_dev_info.congested_data = md;
@@ -1708,18 +1722,8 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-
-	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
-	if (!md->io_pool)
-		goto bad_io_pool;
-
-	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _tio_cache);
-	if (!md->tio_pool)
-		goto bad_tio_pool;
-
-	md->bs = bioset_create(16, 16);
-	if (!md->bs)
-		goto bad_no_bioset;
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	blk_queue_prep_rq(md->queue, dm_prep_fn);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1754,12 +1758,6 @@ static struct mapped_device *alloc_dev(i
 bad_thread:
 	put_disk(md->disk);
 bad_disk:
-	bioset_free(md->bs);
-bad_no_bioset:
-	mempool_destroy(md->tio_pool);
-bad_tio_pool:
-	mempool_destroy(md->io_pool);
-bad_io_pool:
 	blk_cleanup_queue(md->queue);
 bad_queue:
 	free_minor(minor);
@@ -1781,9 +1779,12 @@ static void free_dev(struct mapped_devic
 		bdput(md->suspended_bdev);
 	}
 	destroy_workqueue(md->wq);
-	mempool_destroy(md->tio_pool);
-	mempool_destroy(md->io_pool);
-	bioset_free(md->bs);
+	if (md->tio_pool)
+		mempool_destroy(md->tio_pool);
+	if (md->io_pool)
+		mempool_destroy(md->io_pool);
+	if (md->bs)
+		bioset_free(md->bs);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1846,6 +1847,16 @@ static int __bind(struct mapped_device *
 	dm_table_get(t);
 	dm_table_event_callback(t, event_callback, md);
 
+	/*
+	 * The queue hasn't been stopped yet, if the old table type wasn't
+	 * for request-based during suspension.  So stop it to prevent
+	 * I/O mapping before resume.
+	 * This must be done before setting the queue restrictions,
+	 * because request-based dm may be run just after the setting.
+	 */
+	if (dm_table_request_based(t) && !blk_queue_stopped(q))
+		stop_queue(q);
+
 	write_lock(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
@@ -1995,7 +2006,13 @@ static void __flush_deferred_io(struct m
 	struct bio *c;
 
 	while ((c = bio_list_pop(&md->deferred))) {
-		if (__split_bio(md, c))
+		/*
+		 * Some bios might have been queued here during suspension
+		 * before setting of request-based dm in resume
+		 */
+		if (dm_request_based(md))
+			generic_make_request(c);
+		else if (__split_bio(md, c))
 			bio_io_error(c);
 	}
 
@@ -2413,6 +2430,65 @@ int dm_noflush_suspending(struct dm_targ
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
+int dm_init_md_mempool(struct mapped_device *md, int type)
+{
+	if (unlikely(type == DM_TYPE_NONE)) {
+		DMWARN("no type is specified, can't initialize mempool");
+		return -EINVAL;
+	}
+
+	if (md->mempool_type == type)
+		return 0;
+
+	if (md->map) {
+		/* The md has been using, can't change the mempool type */
+		DMWARN("can't change mempool type after a table is bound");
+		return -EINVAL;
+	}
+
+	/* Not using the md yet, we can still change the mempool type */
+	if (md->mempool_type != DM_TYPE_NONE) {
+		mempool_destroy(md->io_pool);
+		md->io_pool = NULL;
+		mempool_destroy(md->tio_pool);
+		md->tio_pool = NULL;
+		bioset_free(md->bs);
+		md->bs = NULL;
+		md->mempool_type = DM_TYPE_NONE;
+	}
+
+	md->io_pool = (type == DM_TYPE_BIO_BASED) ?
+		      mempool_create_slab_pool(MIN_IOS, _io_cache) :
+		      mempool_create_slab_pool(MIN_IOS, _bio_info_cache);
+	if (!md->io_pool)
+		return -ENOMEM;
+
+	md->tio_pool = (type == DM_TYPE_BIO_BASED) ?
+		       mempool_create_slab_pool(MIN_IOS, _tio_cache) :
+		       mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
+	if (!md->tio_pool)
+		goto free_io_pool_and_out;
+
+	md->bs = (type == DM_TYPE_BIO_BASED) ?
+		 bioset_create(16, 16) : bioset_create(MIN_IOS, MIN_IOS);
+	if (!md->bs)
+		goto free_tio_pool_and_out;
+
+	md->mempool_type = type;
+
+	return 0;
+
+free_tio_pool_and_out:
+	mempool_destroy(md->tio_pool);
+	md->tio_pool = NULL;
+
+free_io_pool_and_out:
+	mempool_destroy(md->io_pool);
+	md->io_pool = NULL;
+
+	return -ENOMEM;
+}
+
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
Index: 2.6.27-rc6/drivers/md/dm.h
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm.h
+++ 2.6.27-rc6/drivers/md/dm.h
@@ -23,6 +23,13 @@
 #define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
 
 /*
+ * Type of table and mapped_device's mempool
+ */
+#define DM_TYPE_NONE		0
+#define DM_TYPE_BIO_BASED	1
+#define DM_TYPE_REQUEST_BASED	2
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
@@ -51,6 +58,9 @@ int dm_table_resume_targets(struct dm_ta
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 int dm_table_any_busy_target(struct dm_table *t);
 void dm_table_unplug_all(struct dm_table *t);
+int dm_table_set_type(struct dm_table *t);
+int dm_table_get_type(struct dm_table *t);
+int dm_table_request_based(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
@@ -113,4 +123,9 @@ void dm_kobject_uevent(struct mapped_dev
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 
+/*
+ * Mempool initializer for a mapped_device
+ */
+int dm_init_md_mempool(struct mapped_device *md, int type);
+
 #endif
Index: 2.6.27-rc6/drivers/md/dm-ioctl.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm-ioctl.c
+++ 2.6.27-rc6/drivers/md/dm-ioctl.c
@@ -1045,6 +1045,12 @@ static int populate_table(struct dm_tabl
 		next = spec->next;
 	}
 
+	r = dm_table_set_type(table);
+	if (r) {
+		DMWARN("unable to set table type");
+		return r;
+	}
+
 	return dm_table_complete(table);
 }
 
@@ -1069,6 +1075,13 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	r = dm_init_md_mempool(md, dm_table_get_type(t));
+	if (r) {
+		DMWARN("unable to initialize the md mempools for this table");
+		dm_table_put(t);
+		goto out;
+	}
+
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
Index: 2.6.27-rc6/include/linux/device-mapper.h
===================================================================
--- 2.6.27-rc6.orig/include/linux/device-mapper.h
+++ 2.6.27-rc6/include/linux/device-mapper.h
@@ -140,6 +140,7 @@ struct io_restrictions {
 	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
+	unsigned char no_request_stacking;
 };
 
 struct dm_target {
