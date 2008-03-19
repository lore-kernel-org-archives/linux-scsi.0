From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 10/13] dm: enable request-based dm
Date: Wed, 19 Mar 2008 18:11:14 -0500 (EST)
Message-ID: <20080319.181114.99453309.k-ueda@ct.jp.nec.com>
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

This patch enables request-based dm.

Request-based dm and bio-based dm coexist, since there are
some target drivers which are more fitting to bio-based dm.
There are some limitations between them.
  - OK: bio-based dm device on bio-based dm device
  - OK: bio-based dm device on request-based dm device
  - OK: request-based dm device on request-based dm device
  - NG: request-based dm device on bio-based dm device

The type of a dm device is decided at the first table loading time.
Until then, mempool creations and queue initializations are deferred.
Once the type of a dm device is decided, the type can't be changed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-table.c |   54 +++++++++++++++
 drivers/md/dm.c       |  174 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm.h       |    6 +
 3 files changed, 199 insertions(+), 35 deletions(-)

Index: 2.6.25-rc5/drivers/md/dm-table.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm-table.c
+++ 2.6.25-rc5/drivers/md/dm-table.c
@@ -813,6 +813,55 @@ static int setup_indexes(struct dm_table
 	return 0;
 }
 
+#define DM_HOOK_AT_REQUEST	0
+#define DM_HOOK_AT_BIO		1
+
+/*
+ * Check the consistency of targets' hook type
+ *
+ * Returns
+ *    DM_HOOK_AT_REQUEST: the table is for request-based dm
+ *    DM_HOOK_AT_BIO    : the table is for bio-based dm
+ *    negative          : the table is not consistent
+ */
+static int check_table_hook_type(struct dm_table *t)
+{
+	unsigned int i;
+	unsigned int bio_based = 0, rq_based = 0;
+	struct dm_target *ti;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = t->targets + i;
+
+		if (ti->type->map_rq)
+			rq_based = 1;
+		else
+			bio_based = 1;
+
+		if (rq_based && bio_based) {
+			DMERR("Inconsistent table: different target types"
+			      " mixed up");
+			return -EINVAL;
+		}
+	}
+
+	return rq_based ? DM_HOOK_AT_REQUEST : DM_HOOK_AT_BIO;
+}
+
+static int set_md_hook_type(struct dm_table *t)
+{
+	int r = check_table_hook_type(t);
+
+	switch (r) {
+	case DM_HOOK_AT_REQUEST:
+		return dm_set_md_request_based(t->md);
+	case DM_HOOK_AT_BIO:
+		return dm_set_md_bio_based(t->md);
+	default:
+		return r;
+	}
+}
+
 /*
  * Builds the btree to index the map.
  */
@@ -821,6 +870,11 @@ int dm_table_complete(struct dm_table *t
 	int r = 0;
 	unsigned int leaf_nodes;
 
+	/* Setup the mapped_device to bio-based dm or request-based dm */
+	r = set_md_hook_type(t);
+	if (r)
+		return r;
+
 	check_for_valid_limits(&t->limits);
 
 	/* how many indexes will the btree have ? */
Index: 2.6.25-rc5/drivers/md/dm.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.c
+++ 2.6.25-rc5/drivers/md/dm.c
@@ -100,6 +100,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_REQUEST_BASED 6
+#define DMF_BIO_BASED 7
 
 /*
  * Work processed by per-device workqueue.
@@ -1507,6 +1508,135 @@ out:
 	return r;
 }
 
+static void init_queue(struct request_queue *q, struct mapped_device *md)
+{
+	q->queuedata = md;
+	q->backing_dev_info.congested_fn = dm_any_congested;
+	q->backing_dev_info.congested_data = md;
+	blk_queue_make_request(q, dm_request);
+	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
+	q->unplug_fn = dm_unplug_all;
+}
+
+int dm_set_md_request_based(struct mapped_device *md)
+{
+	int r = 0;
+
+	if (test_bit(DMF_REQUEST_BASED, &md->flags))
+		/* Initialization is already done */
+		return 0;
+
+	if (test_bit(DMF_BIO_BASED, &md->flags)) {
+		DMERR("Can't change hook type to request-based from bio-based");
+		return -EINVAL;
+	}
+
+	md->io_pool = mempool_create_slab_pool(MIN_IOS, _bio_info_cache);
+	if (!md->io_pool)
+		return -ENOMEM;
+
+	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
+	if (!md->tio_pool) {
+		r = -ENOMEM;
+		goto out_free_io_pool;
+	}
+
+	md->bs = bioset_create(MIN_IOS, MIN_IOS);
+	if (!md->bs) {
+		r = -ENOMEM;
+		goto out_free_tio_pool;
+	}
+
+	md->queue = blk_init_queue(dm_request_fn, NULL);
+	if (!md->queue) {
+		DMERR("request queue initialization for request-based failed");
+		r = -ENOMEM;
+		goto out_free_bs;
+	}
+
+	md->saved_make_request_fn = md->queue->make_request_fn;
+	init_queue(md->queue, md);
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	md->disk->queue = md->queue;
+	r = blk_register_queue(md->disk);
+	if (r) {
+		DMERR("registration of request queue failed");
+		goto out_cleanup_queue;
+	}
+
+	set_bit(DMF_REQUEST_BASED, &md->flags);
+
+	return 0;
+
+out_cleanup_queue:
+	blk_cleanup_queue(md->queue);
+	md->disk->queue = md->queue = NULL;
+	md->saved_make_request_fn = NULL;
+
+out_free_bs:
+	bioset_free(md->bs);
+	md->bs = NULL;
+
+out_free_tio_pool:
+	mempool_destroy(md->tio_pool);
+	md->tio_pool = NULL;
+
+out_free_io_pool:
+	mempool_destroy(md->io_pool);
+	md->io_pool = NULL;
+
+	return r;
+}
+
+int dm_set_md_bio_based(struct mapped_device *md)
+{
+	if (test_bit(DMF_BIO_BASED, &md->flags))
+		/* Initialization is already done */
+		return 0;
+
+	if (test_bit(DMF_REQUEST_BASED, &md->flags)) {
+		DMERR("Can't change hook type to bio-based from request-based");
+		return -EINVAL;
+	}
+
+	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
+	if (!md->io_pool)
+		goto out;
+
+	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _tio_cache);
+	if (!md->tio_pool)
+		goto out_free_io_pool;
+
+	md->bs = bioset_create(16, 16);
+	if (!md->bs)
+		goto out_free_tio_pool;
+
+	md->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!md->queue) {
+		DMERR("request queue initialization for request-based failed");
+		goto out_free_bs;
+	}
+
+	init_queue(md->queue, md);
+	md->disk->queue = md->queue;
+
+	set_bit(DMF_BIO_BASED, &md->flags);
+
+	return 0;
+
+out_free_bs:
+	bioset_free(md->bs);
+	md->bs = NULL;
+out_free_tio_pool:
+	mempool_destroy(md->tio_pool);
+	md->tio_pool = NULL;
+out_free_io_pool:
+	mempool_destroy(md->io_pool);
+	md->io_pool = NULL;
+out:
+	return -ENOMEM;
+}
+
 static struct block_device_operations dm_blk_dops;
 
 /*
@@ -1546,28 +1676,7 @@ static struct mapped_device *alloc_dev(i
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!md->queue)
-		goto bad_queue;
-
-	md->queue->queuedata = md;
-	md->queue->backing_dev_info.congested_fn = dm_any_congested;
-	md->queue->backing_dev_info.congested_data = md;
-	blk_queue_make_request(md->queue, dm_request);
-	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	md->queue->unplug_fn = dm_unplug_all;
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
+	/* md's queue and mempools will be allocated after the 1st table load */
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1580,7 +1689,6 @@ static struct mapped_device *alloc_dev(i
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 	add_disk(md->disk);
@@ -1602,14 +1710,6 @@ static struct mapped_device *alloc_dev(i
 bad_thread:
 	put_disk(md->disk);
 bad_disk:
-	bioset_free(md->bs);
-bad_no_bioset:
-	mempool_destroy(md->tio_pool);
-bad_tio_pool:
-	mempool_destroy(md->io_pool);
-bad_io_pool:
-	blk_cleanup_queue(md->queue);
-bad_queue:
 	free_minor(minor);
 bad_minor:
 	module_put(THIS_MODULE);
@@ -1629,9 +1729,12 @@ static void free_dev(struct mapped_devic
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
 
@@ -1640,7 +1743,8 @@ static void free_dev(struct mapped_devic
 	spin_unlock(&_minor_lock);
 
 	put_disk(md->disk);
-	blk_cleanup_queue(md->queue);
+	if (md->queue)
+		blk_cleanup_queue(md->queue);
 	module_put(THIS_MODULE);
 	kfree(md);
 }
Index: 2.6.25-rc5/drivers/md/dm.h
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.h
+++ 2.6.25-rc5/drivers/md/dm.h
@@ -197,4 +197,10 @@ int dm_lock_for_deletion(struct mapped_d
 
 void dm_kobject_uevent(struct mapped_device *md);
 
+/*
+ * Initializer for request-based/bio-based device
+ */
+int dm_set_md_request_based(struct mapped_device *md);
+int dm_set_md_bio_based(struct mapped_device *md);
+
 #endif
