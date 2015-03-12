From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/7] dm: add 'use_blk_mq' module param and expose in per-device ro sysfs attr
Date: Wed, 11 Mar 2015 23:56:42 -0400
Message-ID: <1426132602-34331-8-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Request-based DM's blk-mq support defaults to off; but a user can easily
change the default using the dm_mod.use_blk_mq module/boot option.

Also, you can check what mode a given request-based DM device is using
with: cat /sys/block/dm-X/dm/use_blk_mq

This change enabled further cleanup and reduced work (e.g. the
md->io_pool and md->rq_pool isn't created if using blk-mq).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig    | 11 +++++++++++
 drivers/md/dm-sysfs.c |  9 +++++++++
 drivers/md/dm-table.c |  6 +++---
 drivers/md/dm.c       | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm.h       |  5 ++++-
 5 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 63e05e3..109f9dc 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -196,6 +196,17 @@ config BLK_DEV_DM
 
 	  If unsure, say N.
 
+config DM_MQ_DEFAULT
+	bool "request-based DM: use blk-mq I/O path by default"
+	depends on BLK_DEV_DM
+	---help---
+	  This option enables the blk-mq based I/O path for request-based
+	  DM devices by default.  With the option the dm_mod.use_blk_mq
+	  module/boot option defaults to Y, without it to N, but it can
+	  still be overriden either way.
+
+	  If unsure say N.
+
 config DM_DEBUG
 	bool "Device mapper debugging support"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index f5bb394..7e818f5 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -89,15 +89,24 @@ static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 	return strlen(buf);
 }
 
+static ssize_t dm_attr_use_blk_mq_show(struct mapped_device *md, char *buf)
+{
+	sprintf(buf, "%d\n", dm_use_blk_mq(md));
+
+	return strlen(buf);
+}
+
 static DM_ATTR_RO(name);
 static DM_ATTR_RO(uuid);
 static DM_ATTR_RO(suspended);
+static DM_ATTR_RO(use_blk_mq);
 static DM_ATTR_RW(rq_based_seq_io_merge_deadline);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
 	&dm_attr_uuid.attr,
 	&dm_attr_suspended.attr,
+	&dm_attr_use_blk_mq.attr,
 	&dm_attr_rq_based_seq_io_merge_deadline.attr,
 	NULL,
 };
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 66600ca..8d025f3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -940,7 +940,7 @@ bool dm_table_mq_request_based(struct dm_table *t)
 	return dm_table_get_type(t) == DM_TYPE_MQ_REQUEST_BASED;
 }
 
-static int dm_table_alloc_md_mempools(struct dm_table *t)
+static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
 	unsigned type = dm_table_get_type(t);
 	unsigned per_bio_data_size = 0;
@@ -958,7 +958,7 @@ static int dm_table_alloc_md_mempools(struct dm_table *t)
 			per_bio_data_size = max(per_bio_data_size, tgt->per_bio_data_size);
 		}
 
-	t->mempools = dm_alloc_md_mempools(type, t->integrity_supported, per_bio_data_size);
+	t->mempools = dm_alloc_md_mempools(md, type, t->integrity_supported, per_bio_data_size);
 	if (!t->mempools)
 		return -ENOMEM;
 
@@ -1128,7 +1128,7 @@ int dm_table_complete(struct dm_table *t)
 		return r;
 	}
 
-	r = dm_table_alloc_md_mempools(t);
+	r = dm_table_alloc_md_mempools(t, t->md);
 	if (r)
 		DMERR("unable to allocate mempools");
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b0c965a..3165b94 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -228,8 +228,20 @@ struct mapped_device {
 
 	/* for blk-mq request-based DM support */
 	struct blk_mq_tag_set tag_set;
+	bool use_blk_mq;
 };
 
+#ifdef CONFIG_DM_MQ_DEFAULT
+static bool use_blk_mq = true;
+#else
+static bool use_blk_mq = false;
+#endif
+
+bool dm_use_blk_mq(struct mapped_device *md)
+{
+	return md->use_blk_mq;
+}
+
 /*
  * For mempools pre-allocation at the table loading time.
  */
@@ -2219,6 +2231,7 @@ static void dm_init_md_queue(struct mapped_device *md)
 
 static void dm_init_old_md_queue(struct mapped_device *md)
 {
+	md->use_blk_mq = false;
 	dm_init_md_queue(md);
 
 	/*
@@ -2260,6 +2273,7 @@ static struct mapped_device *alloc_dev(int minor)
 	if (r < 0)
 		goto bad_io_barrier;
 
+	md->use_blk_mq = use_blk_mq;
 	md->type = DM_TYPE_NONE;
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);
@@ -2346,7 +2360,6 @@ static void unlock_fs(struct mapped_device *md);
 static void free_dev(struct mapped_device *md)
 {
 	int minor = MINOR(disk_devt(md->disk));
-	bool using_blk_mq = !!md->queue->mq_ops;
 
 	unlock_fs(md);
 	bdput(md->bdev);
@@ -2372,7 +2385,7 @@ static void free_dev(struct mapped_device *md)
 
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
-	if (using_blk_mq)
+	if (md->use_blk_mq)
 		blk_mq_free_tag_set(&md->tag_set);
 	dm_stats_cleanup(&md->stats);
 	module_put(THIS_MODULE);
@@ -2383,7 +2396,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->io_pool && md->bs) {
+	if (md->bs) {
 		/* The md already has necessary mempools. */
 		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
 			/*
@@ -2793,13 +2806,21 @@ out_tag_set:
 	return err;
 }
 
+static unsigned filter_md_type(unsigned type, struct mapped_device *md)
+{
+	if (type == DM_TYPE_BIO_BASED)
+		return type;
+
+	return !md->use_blk_mq ? DM_TYPE_REQUEST_BASED : DM_TYPE_MQ_REQUEST_BASED;
+}
+
 /*
  * Setup the DM device's queue based on md's type
  */
 int dm_setup_md_queue(struct mapped_device *md)
 {
 	int r;
-	unsigned md_type = dm_get_md_type(md);
+	unsigned md_type = filter_md_type(dm_get_md_type(md), md);
 
 	switch (md_type) {
 	case DM_TYPE_REQUEST_BASED:
@@ -3503,16 +3524,19 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_bio_data_size)
+struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
+					    unsigned integrity, unsigned per_bio_data_size)
 {
 	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
-	struct kmem_cache *cachep;
+	struct kmem_cache *cachep = NULL;
 	unsigned int pool_size = 0;
 	unsigned int front_pad;
 
 	if (!pools)
 		return NULL;
 
+	type = filter_md_type(type, md);
+
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
 		cachep = _io_cache;
@@ -3520,13 +3544,13 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 		break;
 	case DM_TYPE_REQUEST_BASED:
+		cachep = _rq_tio_cache;
 		pool_size = dm_get_reserved_rq_based_ios();
 		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
 		if (!pools->rq_pool)
 			goto out;
 		/* fall through to setup remaining rq-based pools */
 	case DM_TYPE_MQ_REQUEST_BASED:
-		cachep = _rq_tio_cache;
 		if (!pool_size)
 			pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
@@ -3534,12 +3558,14 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 		WARN_ON(per_bio_data_size != 0);
 		break;
 	default:
-		goto out;
+		BUG();
 	}
 
-	pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
-	if (!pools->io_pool)
-		goto out;
+	if (cachep) {
+		pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
+		if (!pools->io_pool)
+			goto out;
+	}
 
 	pools->bs = bioset_create_nobvec(pool_size, front_pad);
 	if (!pools->bs)
@@ -3596,6 +3622,9 @@ MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
 module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
 
+module_param(use_blk_mq, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(use_blk_mq, "Use block multiqueue for request-based DM devices");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 5522422..6123c2b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -211,6 +211,8 @@ int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 void dm_internal_suspend(struct mapped_device *md);
 void dm_internal_resume(struct mapped_device *md);
 
+bool dm_use_blk_mq(struct mapped_device *md);
+
 int dm_io_init(void);
 void dm_io_exit(void);
 
@@ -220,7 +222,8 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_bio_data_size);
+struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
+					    unsigned integrity, unsigned per_bio_data_size);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 /*
-- 
1.9.5 (Apple Git-50.3)
