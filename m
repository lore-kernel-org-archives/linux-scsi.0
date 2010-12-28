From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/8] Address recent SCST comments
Date: Tue, 28 Dec 2010 18:23:25 +0100
Message-ID: <201012281823.26449.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:58782 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0L1RXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 12:23:38 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

On Monday 27 December 2010 14:35:33 Bart Van Assche wrote:
> The paches in this patch series address the following issues:
> - Make sure that all SCST sysfs attributes have only one value per file.
> [ ... ]

Note: someone was so kind to inform me (via private e-mail) that two more
classes of sysfs files did not yet satisfy the one-value-per-file rule, namely
the SGV cache statistics and the I/O latency statistics. The two patches
below move these sysfs files to debugfs too:

[SCSI] scst: Move SGV cache statistics to debugfs

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/stable/sysfs-devices-scst |   31 -----
 drivers/scst/Makefile                       |    4 +-
 drivers/scst/scst_mem.c                     |  168 +++-----------------------
 drivers/scst/scst_mem.h                     |   22 ++++-
 drivers/scst/scst_mem_stats.c               |  168 +++++++++++++++++++++++++++
 drivers/scst/scst_mem_stats.h               |   21 ++++
 drivers/scst/scst_priv.h                    |    2 -
 drivers/scst/scst_sysfs.c                   |    9 --
 drivers/scst/scst_tracing.c                 |   17 +++-
 9 files changed, 246 insertions(+), 196 deletions(-)
 create mode 100644 drivers/scst/scst_mem_stats.c
 create mode 100644 drivers/scst/scst_mem_stats.h

diff --git a/Documentation/ABI/stable/sysfs-devices-scst b/Documentation/ABI/stable/sysfs-devices-scst
index e25d1a4..8e02cff 100644
--- a/Documentation/ABI/stable/sysfs-devices-scst
+++ b/Documentation/ABI/stable/sysfs-devices-scst
@@ -18,37 +18,6 @@ Description:
 		specific identifier ID and USN of virtual devices. Must be
 		set before any virtual devices are created. Read-write.
 
-What:		/sys/devices/scst/sgv/global_stats
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Global SGV (scatter/gather vector) cache statistics. Read-only.
-		An example:
-
-		$ cat sgv/global_stats
-		Inactive/active pages			0/0
-		Hi/lo watermarks [pages]		62208/0
-		Hi watermark releases/failures		0/0
-		Other allocs				0
-
-What:		/sys/devices/scst/sgv/sgv/stats
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Statistics for the regular SGV cache. Read-only.
-
-What:		/sys/devices/scst/sgv/sgv-clust/stats
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Statistics for the clustering SGV cache. Read-only.
-
-What:		/sys/devices/scst/sgv/sgv-dma/stats
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Statistics for the DMA SGV cache. Read-only.
-
 What:		/sys/devices/scst/threads
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
diff --git a/drivers/scst/Makefile b/drivers/scst/Makefile
index 38b3f4e..a27cf92 100644
--- a/drivers/scst/Makefile
+++ b/drivers/scst/Makefile
@@ -7,7 +7,7 @@ scst-y        += scst_lib.o
 scst-y        += scst_sysfs.o
 scst-y        += scst_mem.o
 scst-y        += scst_debug.o
-scst-$(CONFIG_SCST_DEBUG)	+= scst_tracing.o
-scst-$(CONFIG_SCST_TRACING)	+= scst_tracing.o
+scst-$(CONFIG_SCST_DEBUG)	+= scst_tracing.o scst_mem_stats.o
+scst-$(CONFIG_SCST_TRACING)	+= scst_tracing.o scst_mem_stats.o
 
 obj-$(CONFIG_SCST)   += scst.o dev_handlers/ scst_local/ srpt/
diff --git a/drivers/scst/scst_mem.c b/drivers/scst/scst_mem.c
index 048f848..b9d84f5 100644
--- a/drivers/scst/scst_mem.c
+++ b/drivers/scst/scst_mem.c
@@ -29,6 +29,7 @@
 #include <scst/scst.h>
 #include "scst_priv.h"
 #include "scst_mem.h"
+#include "scst_mem_stats.h"
 
 #define SGV_DEFAULT_PURGE_INTERVAL	(60 * HZ)
 #define SGV_MIN_SHRINK_INTERVAL		(1 * HZ)
@@ -66,12 +67,6 @@ static struct shrinker sgv_shrinker;
  */
 static LIST_HEAD(sgv_pools_list);
 
-static struct kobj_type pool_ktype;
-
-static struct kobject *scst_sgv_kobj;
-static int scst_sgv_sysfs_create(struct sgv_pool *pool, struct kobject *parent);
-static void scst_sgv_sysfs_del(struct sgv_pool *pool);
-
 static inline bool sgv_pool_clustered(const struct sgv_pool *pool)
 {
 	return pool->clustering_type != sgv_no_clustering;
@@ -1412,7 +1407,7 @@ static int sgv_pool_init(struct sgv_pool *pool, const char *name,
 	list_add_tail(&pool->sgv_pools_list_entry, &sgv_pools_list);
 	spin_unlock_bh(&sgv_pools_lock);
 
-	res = scst_sgv_sysfs_create(pool, scst_sgv_kobj);
+	res = scst_sgv_pool_debugfs_create(pool);
 	if (res != 0)
 		goto out_del;
 
@@ -1486,6 +1481,8 @@ EXPORT_SYMBOL_GPL(sgv_pool_flush);
 
 static void sgv_pool_destroy(struct sgv_pool *pool)
 {
+	int i;
+
 	cancel_delayed_work_sync(&pool->sgv_purge_work);
 
 	sgv_pool_flush(pool);
@@ -1496,10 +1493,15 @@ static void sgv_pool_destroy(struct sgv_pool *pool)
 	spin_unlock_bh(&sgv_pools_lock);
 	mutex_unlock(&sgv_pools_mutex);
 
-	scst_sgv_sysfs_del(pool);
+	scst_sgv_pool_debugfs_del(pool);
 
-	kobject_put(&pool->sgv_kobj);
-	return;
+	for (i = 0; i < pool->max_caches; i++) {
+		if (pool->caches[i])
+			kmem_cache_destroy(pool->caches[i]);
+		pool->caches[i] = NULL;
+	}
+
+	kfree(pool);
 }
 
 /**
@@ -1523,17 +1525,6 @@ void sgv_pool_set_allocator(struct sgv_pool *pool,
 EXPORT_SYMBOL_GPL(sgv_pool_set_allocator);
 
 /**
- * sgv_kobj_to_pool() - Convert a kobject pointer to a pool pointer.
- *
- * Must be called from inside an sgv pool sysfs .show() or .store() callback
- * function only.
- */
-static inline struct sgv_pool *sgv_kobj_to_pool(struct kobject *kobj)
-{
-	return container_of(kobj, struct sgv_pool, sgv_kobj);
-}
-
-/**
  * sgv_pool_create - creates and initializes an SGV pool
  * @name:	the name of the SGV pool
  * @clustered:	sets type of the pages clustering.
@@ -1591,8 +1582,6 @@ struct sgv_pool *sgv_pool_create(const char *name,
 		goto out_unlock;
 	}
 
-	kobject_init(&pool->sgv_kobj, &pool_ktype);
-
 	rc = sgv_pool_init(pool, name, clustering_type, single_alloc_pages,
 				purge_interval);
 	if (rc != 0)
@@ -1603,7 +1592,7 @@ out_unlock:
 	return pool;
 
 out_free:
-	kobject_put(&pool->sgv_kobj);
+	kfree(pool);
 	goto out_unlock;
 }
 EXPORT_SYMBOL_GPL(sgv_pool_create);
@@ -1707,15 +1696,13 @@ void scst_sgv_pools_deinit(void)
 	return;
 }
 
-static ssize_t sgv_sysfs_stat_show(struct kobject *kobj,
-	struct kobj_attribute *attr, char *buf)
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+ssize_t sgv_pool_stat_show(struct sgv_pool *pool, char *buf)
 {
-	struct sgv_pool *pool;
 	int i, total = 0, hit = 0, merged = 0, allocated = 0;
 	int oa, om, res;
 
-	pool = sgv_kobj_to_pool(kobj);
-
 	for (i = 0; i < SGV_POOL_ELEMENTS; i++) {
 		int t;
 
@@ -1763,14 +1750,10 @@ static ssize_t sgv_sysfs_stat_show(struct kobject *kobj,
 	return res;
 }
 
-static ssize_t sgv_sysfs_stat_reset(struct kobject *kobj,
-	struct kobj_attribute *attr, const char *buf, size_t count)
+void sgv_pool_stat_reset(struct sgv_pool *pool)
 {
-	struct sgv_pool *pool;
 	int i;
 
-	pool = sgv_kobj_to_pool(kobj);
-
 	for (i = 0; i < SGV_POOL_ELEMENTS; i++) {
 		atomic_set(&pool->cache_acc[i].hit_alloc, 0);
 		atomic_set(&pool->cache_acc[i].total_alloc, 0);
@@ -1785,11 +1768,9 @@ static ssize_t sgv_sysfs_stat_reset(struct kobject *kobj,
 	atomic_set(&pool->other_alloc, 0);
 
 	PRINT_INFO("Statistics for SGV pool %s reset", pool->name);
-	return count;
 }
 
-static ssize_t sgv_sysfs_global_stat_show(struct kobject *kobj,
-	struct kobj_attribute *attr, char *buf)
+ssize_t sgv_global_stat_show(char *buf)
 {
 	struct sgv_pool *pool;
 	int inactive_pages = 0, res;
@@ -1813,122 +1794,13 @@ static ssize_t sgv_sysfs_global_stat_show(struct kobject *kobj,
 	return res;
 }
 
-static ssize_t sgv_sysfs_global_stat_reset(struct kobject *kobj,
-	struct kobj_attribute *attr, const char *buf, size_t count)
+void sgv_global_stat_reset(void)
 {
 	atomic_set(&sgv_releases_on_hiwmk, 0);
 	atomic_set(&sgv_releases_on_hiwmk_failed, 0);
 	atomic_set(&sgv_other_total_alloc, 0);
 
 	PRINT_INFO("%s", "Global SGV pool statistics reset");
-	return count;
-}
-
-static struct kobj_attribute sgv_stat_attr =
-	__ATTR(stats, S_IRUGO | S_IWUSR, sgv_sysfs_stat_show,
-		sgv_sysfs_stat_reset);
-
-static struct attribute *sgv_attrs[] = {
-	&sgv_stat_attr.attr,
-	NULL,
-};
-
-static void scst_release_pool(struct kobject *kobj)
-{
-	struct sgv_pool *pool;
-	int i;
-
-	pool = sgv_kobj_to_pool(kobj);
-
-	for (i = 0; i < pool->max_caches; i++) {
-		if (pool->caches[i])
-			kmem_cache_destroy(pool->caches[i]);
-		pool->caches[i] = NULL;
-	}
-
-	kfree(pool);
-}
-
-static struct kobj_type pool_ktype = {
-	.release = scst_release_pool,
-	.sysfs_ops = &scst_sysfs_ops,
-	.default_attrs = sgv_attrs,
-};
-
-static int scst_sgv_sysfs_create(struct sgv_pool *pool, struct kobject *parent)
-{
-	int res;
-
-	res = kobject_add(&pool->sgv_kobj, parent, pool->name);
-	if (res != 0) {
-		PRINT_ERROR("Can't add sgv pool %s to sysfs", pool->name);
-		goto out;
-	}
-
-out:
-	return res;
-}
-
-static void scst_sgv_sysfs_del(struct sgv_pool *pool)
-{
-	kobject_del(&pool->sgv_kobj);
-}
-
-/**
- ** SGV directory implementation
- **/
-
-static struct kobj_attribute sgv_global_stat_attr =
-	__ATTR(global_stats, S_IRUGO | S_IWUSR, sgv_sysfs_global_stat_show,
-		sgv_sysfs_global_stat_reset);
-
-static struct attribute *sgv_default_attrs[] = {
-	&sgv_global_stat_attr.attr,
-	NULL,
-};
-
-static void scst_sysfs_release(struct kobject *kobj)
-{
-	kfree(kobj);
-}
-
-static struct kobj_type sgv_ktype = {
-	.sysfs_ops = &scst_sysfs_ops,
-	.release = scst_sysfs_release,
-	.default_attrs = sgv_default_attrs,
-};
-
-/**
- * scst_add_sgv_kobj() - Initialize and add the root SGV kernel object.
- */
-int scst_add_sgv_kobj(struct kobject *parent, const char *name)
-{
-	int res;
-
-	WARN_ON(scst_sgv_kobj);
-	res = -ENOMEM;
-	scst_sgv_kobj = kzalloc(sizeof(*scst_sgv_kobj), GFP_KERNEL);
-	if (!scst_sgv_kobj)
-		goto out;
-	res = kobject_init_and_add(scst_sgv_kobj, &sgv_ktype, parent, name);
-	if (res != 0)
-		goto out_free;
-out:
-	return res;
-out_free:
-	kobject_put(scst_sgv_kobj);
-	scst_sgv_kobj = NULL;
-	goto out;
-}
-
-/**
- * scst_del_put_sgv_kobj() - Remove the root SGV kernel object.
- */
-void scst_del_put_sgv_kobj(void)
-{
-	WARN_ON(!scst_sgv_kobj);
-	kobject_del(scst_sgv_kobj);
-	kobject_put(scst_sgv_kobj);
-	scst_sgv_kobj = NULL;
 }
 
+#endif /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
diff --git a/drivers/scst/scst_mem.h b/drivers/scst/scst_mem.h
index ea3f549..18b7e8c 100644
--- a/drivers/scst/scst_mem.h
+++ b/drivers/scst/scst_mem.h
@@ -122,7 +122,9 @@ struct sgv_pool {
 
 	struct list_head sgv_pools_list_entry;
 
-	struct kobject sgv_kobj;
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+#endif
 };
 
 static inline struct scatterlist *sgv_pool_sg(struct sgv_pool_obj *obj)
@@ -136,3 +138,21 @@ void scst_sgv_pools_deinit(void);
 void scst_sgv_pool_use_norm(struct scst_tgt_dev *tgt_dev);
 void scst_sgv_pool_use_norm_clust(struct scst_tgt_dev *tgt_dev);
 void scst_sgv_pool_use_dma(struct scst_tgt_dev *tgt_dev);
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+int scst_sgv_debugfs_create(struct dentry *parent);
+void scst_sgv_debugfs_del(void);
+
+#else /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
+
+static inline int scst_sgv_debugfs_create(struct dentry *parent)
+{
+	return 0;
+}
+
+static inline void scst_sgv_debugfs_del(void)
+{
+}
+
+#endif /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
diff --git a/drivers/scst/scst_mem_stats.c b/drivers/scst/scst_mem_stats.c
new file mode 100644
index 0000000..8095e61
--- /dev/null
+++ b/drivers/scst/scst_mem_stats.c
@@ -0,0 +1,168 @@
+/*
+ *  scst_mem.c
+ *
+ *  Copyright (C) 2006 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *  Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <scst/scst.h>
+#include "scst_priv.h"
+#include "scst_mem.h"
+#include "scst_mem_stats.h"
+
+static struct dentry *scst_debug_sgv;
+
+static int sgv_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t sgv_pool_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct sgv_pool *pool = file->private_data;
+	unsigned long pg;
+	void *contents;
+	int len;
+	ssize_t res;
+
+	if (*ppos > PAGE_SIZE)
+		return -EINVAL;
+	pg = __get_free_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+	contents = (void *)pg;
+	len = sgv_pool_stat_show(pool, contents);
+	free_page(pg);
+	res = min_t(ssize_t, count, len - *ppos);
+	if (copy_to_user(buf, contents + *ppos, res))
+		return -EFAULT;
+	*ppos += res;
+	return res;
+}
+
+static ssize_t sgv_pool_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct sgv_pool *pool = file->private_data;
+
+	sgv_pool_stat_reset(pool);
+	return count;
+}
+
+static const struct file_operations sgv_pool_fops = {
+	.read	=	sgv_pool_read_file,
+	.write	=	sgv_pool_write_file,
+	.open	=	sgv_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
+int scst_sgv_pool_debugfs_create(struct sgv_pool *pool)
+{
+	struct dentry *file;
+	int res;
+
+	res = -ENOMEM;
+	pool->debugfs_dir = debugfs_create_dir(pool->name, scst_debug_sgv);
+	if (!pool->debugfs_dir)
+		goto out;
+	file = debugfs_create_file("stats", S_IRUGO | S_IWUSR,
+				   pool->debugfs_dir, pool, &sgv_pool_fops);
+	if (!file)
+		goto err;
+	res = 0;
+out:
+	return res;
+err:
+	debugfs_remove_recursive(pool->debugfs_dir);
+	pool->debugfs_dir = NULL;
+	goto out;
+}
+
+void scst_sgv_pool_debugfs_del(struct sgv_pool *pool)
+{
+	debugfs_remove_recursive(pool->debugfs_dir);
+	pool->debugfs_dir = NULL;
+}
+
+static ssize_t sgv_global_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	unsigned long pg;
+	void *contents;
+	int len;
+	ssize_t res;
+
+	if (*ppos > PAGE_SIZE)
+		return -EINVAL;
+	pg = __get_free_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+	contents = (void *)pg;
+	len = sgv_global_stat_show(contents);
+	free_page(pg);
+	res = min_t(ssize_t, count, len - *ppos);
+	if (copy_to_user(buf, contents + *ppos, res))
+		return -EFAULT;
+	*ppos += res;
+	return res;
+}
+
+static ssize_t sgv_global_write_file(struct file *file,
+				     const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	sgv_global_stat_reset();
+	return count;
+}
+
+static const struct file_operations sgv_global_fops = {
+	.read	=	sgv_global_read_file,
+	.write	=	sgv_global_write_file,
+	.open	=	sgv_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
+int scst_sgv_debugfs_create(struct dentry *parent)
+{
+	struct dentry *file;
+	int res;
+
+	res = -ENOMEM;
+	scst_debug_sgv = debugfs_create_dir("sgv", parent);
+	if (!scst_debug_sgv)
+		goto out;
+	file = debugfs_create_file("global_stats", S_IRUGO | S_IWUSR,
+				   scst_debug_sgv, NULL, &sgv_global_fops);
+	if (!file)
+		goto err;
+	res = 0;
+out:
+	return res;
+err:
+	debugfs_remove_recursive(scst_debug_sgv);
+	scst_debug_sgv = NULL;
+	goto out;
+}
+
+void scst_sgv_debugfs_del(void)
+{
+	debugfs_remove_recursive(scst_debug_sgv);
+	scst_debug_sgv = NULL;
+}
diff --git a/drivers/scst/scst_mem_stats.h b/drivers/scst/scst_mem_stats.h
new file mode 100644
index 0000000..b51d294
--- /dev/null
+++ b/drivers/scst/scst_mem_stats.h
@@ -0,0 +1,21 @@
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+int scst_sgv_pool_debugfs_create(struct sgv_pool *pool);
+void scst_sgv_pool_debugfs_del(struct sgv_pool *pool);
+ssize_t sgv_pool_stat_show(struct sgv_pool *pool, char *buf);
+void sgv_pool_stat_reset(struct sgv_pool *pool);
+ssize_t sgv_global_stat_show(char *buf);
+void sgv_global_stat_reset(void);
+
+#else /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
+
+static inline int scst_sgv_pool_debugfs_create(struct sgv_pool *pool)
+{
+	return 0;
+}
+
+static void scst_sgv_pool_debugfs_del(struct sgv_pool *pool)
+{
+}
+
+#endif /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
diff --git a/drivers/scst/scst_priv.h b/drivers/scst/scst_priv.h
index 7a5a815..74e68a4 100644
--- a/drivers/scst/scst_priv.h
+++ b/drivers/scst/scst_priv.h
@@ -376,8 +376,6 @@ void scst_tgt_sysfs_put(struct scst_tgt *tgt);
 int scst_sess_sysfs_create(struct scst_session *sess);
 void scst_sess_sysfs_del(struct scst_session *sess);
 int scst_recreate_sess_luns_link(struct scst_session *sess);
-int scst_add_sgv_kobj(struct kobject *parent, const char *name);
-void scst_del_put_sgv_kobj(void);
 int scst_devt_sysfs_init(struct scst_dev_type *devt);
 int scst_devt_sysfs_create(struct scst_dev_type *devt);
 void scst_devt_sysfs_del(struct scst_dev_type *devt);
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index aadb066..84dc9ee 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -3860,16 +3860,9 @@ int __init scst_sysfs_init(void)
 		goto out_remove_files;
 	}
 
-	res = scst_add_sgv_kobj(&scst_device->kobj, "sgv");
-	if (res) {
-		PRINT_ERROR("%s", "Creation of SCST sgv kernel object failed.");
-		goto out_remove_trace_files;
-	}
-
 out:
 	return res;
 
-out_remove_trace_files:
 	scst_main_remove_trace_files();
 out_remove_files:
 	device_remove_files(scst_device, scst_root_default_attrs);
@@ -3891,8 +3884,6 @@ void scst_sysfs_cleanup(void)
 {
 	PRINT_INFO("%s", "Exiting SCST sysfs hierarchy...");
 
-	scst_del_put_sgv_kobj();
-
 	scst_main_remove_trace_files();
 
 	device_remove_files(scst_device, scst_root_default_attrs);
diff --git a/drivers/scst/scst_tracing.c b/drivers/scst/scst_tracing.c
index 7b97224..9b9aef4 100644
--- a/drivers/scst/scst_tracing.c
+++ b/drivers/scst/scst_tracing.c
@@ -18,6 +18,7 @@
 #include <linux/debugfs.h>
 #include <scst/scst.h>
 #include <scst/scst_debug.h>
+#include "scst_mem.h"
 #include "scst_priv.h"
 #include "scst_pres.h"
 #include "scst_tracing.h"
@@ -230,31 +231,41 @@ int scst_debugfs_init(void)
 		goto out;
 	}
 
+	res = scst_sgv_debugfs_create(scst_debug_root);
+	if (res) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/sgv"
+			    " failed");
+		goto err;
+	}
+
 	scst_debug_target = debugfs_create_dir("target", scst_debug_root);
 	if (!scst_debug_target) {
 		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/target"
 			    " failed");
-		goto out;
+		goto err;
 	}
 
 	scst_debug_devt = debugfs_create_dir("device_type", scst_debug_root);
 	if (!scst_debug_devt) {
 		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/"
 			    "device_type failed");
-		goto out;
+		goto err;
 	}
 
 	scst_debug_dev = debugfs_create_dir("device", scst_debug_root);
 	if (!scst_debug_dev) {
 		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/device"
 			    " failed");
-		goto out;
+		goto err;
 	}
 
 	res = 0;
 
 out:
 	return res;
+err:
+	scst_debugfs_cleanup();
+	goto out;
 }
 
 void scst_debugfs_cleanup(void)
-- 
1.7.1




[SCSI] scst: Move latency statistics to debugfs

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/stable/sysfs-devices-scst_target |   16 -
 drivers/scst/Kconfig                               |    2 +-
 drivers/scst/Makefile                              |    1 +
 drivers/scst/scst_lat_stats.c                      |  435 ++++++++++++++++++++
 drivers/scst/scst_lat_stats.h                      |   28 ++
 drivers/scst/scst_sysfs.c                          |  371 ++---------------
 drivers/scst/scst_tracing.c                        |  204 +++++++---
 drivers/scst/scst_tracing.h                        |   57 ++-
 include/scst/scst.h                                |   21 +
 9 files changed, 719 insertions(+), 416 deletions(-)
 create mode 100644 drivers/scst/scst_lat_stats.c
 create mode 100644 drivers/scst/scst_lat_stats.h

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target b/Documentation/ABI/stable/sysfs-devices-scst_target
index 2d3a388..1792aa3 100644
--- a/Documentation/ABI/stable/sysfs-devices-scst_target
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target
@@ -182,28 +182,12 @@ Description:
 		Session name. For most target drivers this is a name that
 		identifies the initiator. Read-only.
 
-What:		/sys/bus/scst_target/devices/*/sessions/<session>/latency
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Latency statistics for this session. Only available if
-		CONFIG_SCST_MEASURE_LATENCY has been enabled in the
-		kernel configuration. Read-only.
-
 What:		/sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/active_commands
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
 Description:
 		Number of active commands. Read-only.
 
-What:		/sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/latency
-Date:		December 2010
-Contact:	Bart Van Assche <bvanassche@acm.org>
-Description:
-		Latency statistics for this LUN. Only available if
-		CONFIG_SCST_MEASURE_LATENCY has been enabled in the kernel
-		configuration. Read-only.
-
 What:		/sys/bus/scst_target/devices/*/sessions/<session>/luns
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
diff --git a/drivers/scst/Kconfig b/drivers/scst/Kconfig
index 75b0f97..62cb227 100644
--- a/drivers/scst/Kconfig
+++ b/drivers/scst/Kconfig
@@ -228,7 +228,7 @@ config SCST_TM_DBG_GO_OFFLINE
 
 config SCST_MEASURE_LATENCY
 	bool "Commands processing latency measurement facility"
-	depends on SCST
+	depends on SCST && (SCST_DEBUG || SCST_TRACING)
 	help
 	  This option enables commands processing latency measurement
 	  facility in SCST. It will provide in the sysfs interface
diff --git a/drivers/scst/Makefile b/drivers/scst/Makefile
index a27cf92..f2f9253 100644
--- a/drivers/scst/Makefile
+++ b/drivers/scst/Makefile
@@ -9,5 +9,6 @@ scst-y        += scst_mem.o
 scst-y        += scst_debug.o
 scst-$(CONFIG_SCST_DEBUG)	+= scst_tracing.o scst_mem_stats.o
 scst-$(CONFIG_SCST_TRACING)	+= scst_tracing.o scst_mem_stats.o
+scst-$(CONFIG_SCST_MEASURE_LATENCY)	+= scst_lat_stats.o
 
 obj-$(CONFIG_SCST)   += scst.o dev_handlers/ scst_local/ srpt/
diff --git a/drivers/scst/scst_lat_stats.c b/drivers/scst/scst_lat_stats.c
new file mode 100644
index 0000000..0bee2b9
--- /dev/null
+++ b/drivers/scst/scst_lat_stats.c
@@ -0,0 +1,435 @@
+/*
+ *  scst_lat_stats.c
+ *
+ *  Copyright (C) 2009 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scst/scst.h>
+#include <scst/scst_debug.h>
+#include "scst_priv.h"
+#include "scst_lat_stats.h"
+
+/* Per LUN latency statistics. */
+
+static char *scst_io_size_names[] = {
+	"<=8K  ",
+	"<=32K ",
+	"<=128K",
+	"<=512K",
+	">512K "
+};
+
+static ssize_t scst_tgt_dev_latency_show(struct scst_tgt_dev *tgt_dev,
+					 char *buffer)
+{
+	int res, i;
+	char buf[50];
+
+	res = 0;
+	for (i = 0; i < SCST_LATENCY_STATS_NUM; i++) {
+		uint64_t scst_time_wr, tgt_time_wr, dev_time_wr;
+		unsigned int processed_cmds_wr;
+		uint64_t scst_time_rd, tgt_time_rd, dev_time_rd;
+		unsigned int processed_cmds_rd;
+		struct scst_ext_latency_stat *latency_stat;
+
+		latency_stat = &tgt_dev->dev_latency_stat[i];
+		scst_time_wr = latency_stat->scst_time_wr;
+		scst_time_rd = latency_stat->scst_time_rd;
+		tgt_time_wr = latency_stat->tgt_time_wr;
+		tgt_time_rd = latency_stat->tgt_time_rd;
+		dev_time_wr = latency_stat->dev_time_wr;
+		dev_time_rd = latency_stat->dev_time_rd;
+		processed_cmds_wr = latency_stat->processed_cmds_wr;
+		processed_cmds_rd = latency_stat->processed_cmds_rd;
+
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			 "%-5s %-9s %-15lu ", "Write", scst_io_size_names[i],
+			(unsigned long)processed_cmds_wr);
+		if (processed_cmds_wr == 0)
+			processed_cmds_wr = 1;
+
+		do_div(scst_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_scst_time_wr,
+			(unsigned long)scst_time_wr,
+			(unsigned long)latency_stat->max_scst_time_wr,
+			(unsigned long)latency_stat->scst_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
+
+		do_div(tgt_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_tgt_time_wr,
+			(unsigned long)tgt_time_wr,
+			(unsigned long)latency_stat->max_tgt_time_wr,
+			(unsigned long)latency_stat->tgt_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
+
+		do_div(dev_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_dev_time_wr,
+			(unsigned long)dev_time_wr,
+			(unsigned long)latency_stat->max_dev_time_wr,
+			(unsigned long)latency_stat->dev_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
+
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-5s %-9s %-15lu ", "Read", scst_io_size_names[i],
+			(unsigned long)processed_cmds_rd);
+		if (processed_cmds_rd == 0)
+			processed_cmds_rd = 1;
+
+		do_div(scst_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_scst_time_rd,
+			(unsigned long)scst_time_rd,
+			(unsigned long)latency_stat->max_scst_time_rd,
+			(unsigned long)latency_stat->scst_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
+
+		do_div(tgt_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_tgt_time_rd,
+			(unsigned long)tgt_time_rd,
+			(unsigned long)latency_stat->max_tgt_time_rd,
+			(unsigned long)latency_stat->tgt_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
+
+		do_div(dev_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_dev_time_rd,
+			(unsigned long)dev_time_rd,
+			(unsigned long)latency_stat->max_dev_time_rd,
+			(unsigned long)latency_stat->dev_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
+	}
+	return res;
+}
+
+static int scst_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t tgt_dev_lat_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct scst_tgt_dev *tgt_dev = file->private_data;
+	unsigned long pg;
+	void *contents;
+	int len;
+	ssize_t res;
+
+	if (*ppos > PAGE_SIZE)
+		return -EINVAL;
+	pg = __get_free_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+	contents = (void *)pg;
+	len = scst_tgt_dev_latency_show(tgt_dev, contents);
+	free_page(pg);
+	res = min_t(ssize_t, count, len - *ppos);
+	if (copy_to_user(buf, contents + *ppos, res))
+		return -EFAULT;
+	*ppos += res;
+	return res;
+}
+
+static ssize_t tgt_dev_lat_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static const struct file_operations tgt_dev_lat_fops = {
+	.read	=	tgt_dev_lat_read_file,
+	.write	=	tgt_dev_lat_write_file,
+	.open	=	scst_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
+int scst_tgt_dev_lat_create(struct scst_tgt_dev *tgt_dev)
+{
+	tgt_dev->latency_file = debugfs_create_file("latency",
+				    S_IRUGO | S_IWUSR, tgt_dev->debugfs_dir,
+				    tgt_dev, &tgt_dev_lat_fops);
+	return tgt_dev->latency_file ? 0 : -ENOMEM;
+}
+
+void scst_tgt_dev_lat_remove(struct scst_tgt_dev *tgt_dev)
+{
+	debugfs_remove(tgt_dev->latency_file);
+	tgt_dev->latency_file = NULL;
+}
+
+/* Per session latency statistics. */
+
+static ssize_t scst_sess_latency_show(struct scst_session *sess, char *buffer)
+{
+	ssize_t res;
+	int i;
+	char buf[50];
+	uint64_t scst_time, tgt_time, dev_time;
+	unsigned int processed_cmds;
+
+	res = 0;
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
+		"%-15s %-15s %-46s %-46s %-46s\n",
+		"T-L names", "Total commands", "SCST latency",
+		"Target latency", "Dev latency (min/avg/max/all ns)");
+
+	spin_lock_bh(&sess->lat_lock);
+
+	for (i = 0; i < SCST_LATENCY_STATS_NUM ; i++) {
+		uint64_t scst_time_wr, tgt_time_wr, dev_time_wr;
+		unsigned int processed_cmds_wr;
+		uint64_t scst_time_rd, tgt_time_rd, dev_time_rd;
+		unsigned int processed_cmds_rd;
+		struct scst_ext_latency_stat *latency_stat;
+
+		latency_stat = &sess->sess_latency_stat[i];
+		scst_time_wr = latency_stat->scst_time_wr;
+		scst_time_rd = latency_stat->scst_time_rd;
+		tgt_time_wr = latency_stat->tgt_time_wr;
+		tgt_time_rd = latency_stat->tgt_time_rd;
+		dev_time_wr = latency_stat->dev_time_wr;
+		dev_time_rd = latency_stat->dev_time_rd;
+		processed_cmds_wr = latency_stat->processed_cmds_wr;
+		processed_cmds_rd = latency_stat->processed_cmds_rd;
+
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-5s %-9s %-15lu ",
+			"Write", scst_io_size_names[i],
+			(unsigned long)processed_cmds_wr);
+		if (processed_cmds_wr == 0)
+			processed_cmds_wr = 1;
+
+		do_div(scst_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_scst_time_wr,
+			(unsigned long)scst_time_wr,
+			(unsigned long)latency_stat->max_scst_time_wr,
+			(unsigned long)latency_stat->scst_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s", buf);
+
+		do_div(tgt_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_tgt_time_wr,
+			(unsigned long)tgt_time_wr,
+			(unsigned long)latency_stat->max_tgt_time_wr,
+			(unsigned long)latency_stat->tgt_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s", buf);
+
+		do_div(dev_time_wr, processed_cmds_wr);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_dev_time_wr,
+			(unsigned long)dev_time_wr,
+			(unsigned long)latency_stat->max_dev_time_wr,
+			(unsigned long)latency_stat->dev_time_wr);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s\n", buf);
+
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-5s %-9s %-15lu ",
+			"Read", scst_io_size_names[i],
+			(unsigned long)processed_cmds_rd);
+		if (processed_cmds_rd == 0)
+			processed_cmds_rd = 1;
+
+		do_div(scst_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_scst_time_rd,
+			(unsigned long)scst_time_rd,
+			(unsigned long)latency_stat->max_scst_time_rd,
+			(unsigned long)latency_stat->scst_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s", buf);
+
+		do_div(tgt_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_tgt_time_rd,
+			(unsigned long)tgt_time_rd,
+			(unsigned long)latency_stat->max_tgt_time_rd,
+			(unsigned long)latency_stat->tgt_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s", buf);
+
+		do_div(dev_time_rd, processed_cmds_rd);
+		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+			(unsigned long)latency_stat->min_dev_time_rd,
+			(unsigned long)dev_time_rd,
+			(unsigned long)latency_stat->max_dev_time_rd,
+			(unsigned long)latency_stat->dev_time_rd);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
+			"%-47s\n", buf);
+	}
+
+	scst_time = sess->scst_time;
+	tgt_time = sess->tgt_time;
+	dev_time = sess->dev_time;
+	processed_cmds = sess->processed_cmds;
+
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
+		"\n%-15s %-16d", "Overall ", processed_cmds);
+
+	if (processed_cmds == 0)
+		processed_cmds = 1;
+
+	do_div(scst_time, processed_cmds);
+	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+		(unsigned long)sess->min_scst_time,
+		(unsigned long)scst_time,
+		(unsigned long)sess->max_scst_time,
+		(unsigned long)sess->scst_time);
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
+		"%-47s", buf);
+
+	do_div(tgt_time, processed_cmds);
+	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+		(unsigned long)sess->min_tgt_time,
+		(unsigned long)tgt_time,
+		(unsigned long)sess->max_tgt_time,
+		(unsigned long)sess->tgt_time);
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
+		"%-47s", buf);
+
+	do_div(dev_time, processed_cmds);
+	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
+		(unsigned long)sess->min_dev_time,
+		(unsigned long)dev_time,
+		(unsigned long)sess->max_dev_time,
+		(unsigned long)sess->dev_time);
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
+		"%-47s\n\n", buf);
+
+	spin_unlock_bh(&sess->lat_lock);
+	return res;
+}
+
+static int scst_sess_zero_latency(struct scst_session *sess)
+{
+	int res, t;
+
+	res = mutex_lock_interruptible(&scst_mutex);
+	if (res)
+		goto out;
+
+	PRINT_INFO("Zeroing latency statistics for initiator "
+		"%s", sess->initiator_name);
+
+	spin_lock_bh(&sess->lat_lock);
+
+	sess->scst_time = 0;
+	sess->tgt_time = 0;
+	sess->dev_time = 0;
+	sess->min_scst_time = 0;
+	sess->min_tgt_time = 0;
+	sess->min_dev_time = 0;
+	sess->max_scst_time = 0;
+	sess->max_tgt_time = 0;
+	sess->max_dev_time = 0;
+	sess->processed_cmds = 0;
+	memset(sess->sess_latency_stat, 0,
+		sizeof(sess->sess_latency_stat));
+
+	for (t = SESS_TGT_DEV_LIST_HASH_SIZE-1; t >= 0; t--) {
+		struct list_head *head = &sess->sess_tgt_dev_list[t];
+		struct scst_tgt_dev *tgt_dev;
+		list_for_each_entry(tgt_dev, head, sess_tgt_dev_list_entry) {
+			tgt_dev->scst_time = 0;
+			tgt_dev->tgt_time = 0;
+			tgt_dev->dev_time = 0;
+			tgt_dev->processed_cmds = 0;
+			memset(tgt_dev->dev_latency_stat, 0,
+				sizeof(tgt_dev->dev_latency_stat));
+		}
+	}
+
+	spin_unlock_bh(&sess->lat_lock);
+
+	mutex_unlock(&scst_mutex);
+
+out:
+	return res;
+}
+
+static ssize_t sess_lat_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct scst_session *sess = file->private_data;
+	unsigned long pg;
+	void *contents;
+	int len;
+	ssize_t res;
+
+	if (*ppos > PAGE_SIZE)
+		return -EINVAL;
+	pg = __get_free_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+	contents = (void *)pg;
+	len = scst_sess_latency_show(sess, contents);
+	free_page(pg);
+	res = min_t(ssize_t, count, len - *ppos);
+	if (copy_to_user(buf, contents + *ppos, res))
+		return -EFAULT;
+	*ppos += res;
+	return res;
+}
+
+static ssize_t sess_lat_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct scst_session *sess = file->private_data;
+	int res;
+
+	res = scst_sess_zero_latency(sess);
+	if (res)
+		goto out;
+	*ppos += count;
+	res = count;
+out:
+	return res;
+}
+
+static const struct file_operations sess_lat_fops = {
+	.read	=	sess_lat_read_file,
+	.write	=	sess_lat_write_file,
+	.open	=	scst_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
+int scst_sess_lat_create(struct scst_session *sess)
+{
+	sess->latency_file = debugfs_create_file("latency",
+				    S_IRUGO | S_IWUSR, sess->debugfs_dir,
+				    sess, &sess_lat_fops);
+	return sess->latency_file ? 0 : -ENOMEM;
+}
+
+void scst_sess_lat_remove(struct scst_session *sess)
+{
+	debugfs_remove(sess->latency_file);
+	sess->latency_file = NULL;
+}
diff --git a/drivers/scst/scst_lat_stats.h b/drivers/scst/scst_lat_stats.h
new file mode 100644
index 0000000..50c89ee
--- /dev/null
+++ b/drivers/scst/scst_lat_stats.h
@@ -0,0 +1,28 @@
+#if defined(CONFIG_SCST_MEASURE_LATENCY)
+
+int scst_tgt_dev_lat_create(struct scst_tgt_dev *tgt_dev);
+void scst_tgt_dev_lat_remove(struct scst_tgt_dev *tgt_dev);
+int scst_sess_lat_create(struct scst_session *sess);
+void scst_sess_lat_remove(struct scst_session *sess);
+
+#else /*defined(CONFIG_SCST_MEASURE_LATENCY)*/
+
+static inline int scst_tgt_dev_lat_create(struct scst_tgt_dev *tgt_dev)
+{
+	return 0;
+}
+
+static inline void scst_tgt_dev_lat_remove(struct scst_tgt_dev *tgt_dev)
+{
+}
+
+static inline int scst_sess_lat_create(struct scst_session *sess)
+{
+	return 0;
+}
+
+static inline void scst_sess_lat_remove(struct scst_session *sess)
+{
+}
+
+#endif /*defined(CONFIG_SCST_MEASURE_LATENCY)*/
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 84dc9ee..c9c4c28 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -46,6 +46,7 @@
 #include "scst_priv.h"
 #include "scst_mem.h"
 #include "scst_tracing.h"
+#include "scst_lat_stats.h"
 
 enum mgmt_path_type {
 	PATH_NOT_RECOGNIZED,
@@ -442,7 +443,7 @@ int scst_tgtt_sysfs_create(struct scst_tgt_template *tgtt)
 		}
 	}
 
-	res = scst_tgtt_create_trace_files(tgtt);
+	res = scst_tgtt_debugfs_create(tgtt);
 	if (res) {
 		PRINT_ERROR("Can't create tracing files for target driver %s",
 			    tgtt->name);
@@ -459,7 +460,7 @@ out_del:
 
 void scst_tgtt_sysfs_del(struct scst_tgt_template *tgtt)
 {
-	scst_tgtt_remove_trace_files(tgtt);
+	scst_tgtt_debugfs_remove(tgtt);
 	driver_unregister(&tgtt->tgtt_drv);
 }
 
@@ -1049,6 +1050,10 @@ int scst_tgt_sysfs_create(struct scst_tgt *tgt)
 		}
 	}
 
+	res = scst_tgt_debugfs_create(tgt);
+	if (res)
+		goto out_err;
+
 out:
 	return res;
 
@@ -1062,6 +1067,7 @@ out_err:
 
 void scst_tgt_sysfs_del(struct scst_tgt *tgt)
 {
+	scst_tgt_debugfs_remove(tgt);
 	kobject_del(tgt->tgt_sess_kobj);
 	kobject_del(tgt->tgt_luns_kobj);
 	kobject_del(tgt->tgt_ini_grp_kobj);
@@ -1502,112 +1508,6 @@ void scst_dev_sysfs_put(struct scst_device *dev)
  ** Tgt_dev implementation
  **/
 
-#ifdef CONFIG_SCST_MEASURE_LATENCY
-
-static char *scst_io_size_names[] = {
-	"<=8K  ",
-	"<=32K ",
-	"<=128K",
-	"<=512K",
-	">512K "
-};
-
-static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
-	struct kobj_attribute *attr, char *buffer)
-{
-	int res, i;
-	char buf[50];
-	struct scst_tgt_dev *tgt_dev;
-
-	tgt_dev = scst_kobj_to_tgt_dev(kobj);
-
-	res = 0;
-	for (i = 0; i < SCST_LATENCY_STATS_NUM; i++) {
-		uint64_t scst_time_wr, tgt_time_wr, dev_time_wr;
-		unsigned int processed_cmds_wr;
-		uint64_t scst_time_rd, tgt_time_rd, dev_time_rd;
-		unsigned int processed_cmds_rd;
-		struct scst_ext_latency_stat *latency_stat;
-
-		latency_stat = &tgt_dev->dev_latency_stat[i];
-		scst_time_wr = latency_stat->scst_time_wr;
-		scst_time_rd = latency_stat->scst_time_rd;
-		tgt_time_wr = latency_stat->tgt_time_wr;
-		tgt_time_rd = latency_stat->tgt_time_rd;
-		dev_time_wr = latency_stat->dev_time_wr;
-		dev_time_rd = latency_stat->dev_time_rd;
-		processed_cmds_wr = latency_stat->processed_cmds_wr;
-		processed_cmds_rd = latency_stat->processed_cmds_rd;
-
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			 "%-5s %-9s %-15lu ", "Write", scst_io_size_names[i],
-			(unsigned long)processed_cmds_wr);
-		if (processed_cmds_wr == 0)
-			processed_cmds_wr = 1;
-
-		do_div(scst_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_scst_time_wr,
-			(unsigned long)scst_time_wr,
-			(unsigned long)latency_stat->max_scst_time_wr,
-			(unsigned long)latency_stat->scst_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
-
-		do_div(tgt_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_tgt_time_wr,
-			(unsigned long)tgt_time_wr,
-			(unsigned long)latency_stat->max_tgt_time_wr,
-			(unsigned long)latency_stat->tgt_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
-
-		do_div(dev_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_dev_time_wr,
-			(unsigned long)dev_time_wr,
-			(unsigned long)latency_stat->max_dev_time_wr,
-			(unsigned long)latency_stat->dev_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
-
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-5s %-9s %-15lu ", "Read", scst_io_size_names[i],
-			(unsigned long)processed_cmds_rd);
-		if (processed_cmds_rd == 0)
-			processed_cmds_rd = 1;
-
-		do_div(scst_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_scst_time_rd,
-			(unsigned long)scst_time_rd,
-			(unsigned long)latency_stat->max_scst_time_rd,
-			(unsigned long)latency_stat->scst_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
-
-		do_div(tgt_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_tgt_time_rd,
-			(unsigned long)tgt_time_rd,
-			(unsigned long)latency_stat->max_tgt_time_rd,
-			(unsigned long)latency_stat->tgt_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
-
-		do_div(dev_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_dev_time_rd,
-			(unsigned long)dev_time_rd,
-			(unsigned long)latency_stat->max_dev_time_rd,
-			(unsigned long)latency_stat->dev_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
-	}
-	return res;
-}
-
-static struct kobj_attribute tgt_dev_latency_attr =
-	__ATTR(latency, S_IRUGO,
-		scst_tgt_dev_latency_show, NULL);
-
-#endif /* CONFIG_SCST_MEASURE_LATENCY */
-
 static ssize_t scst_tgt_dev_active_commands_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
 {
@@ -1627,9 +1527,6 @@ static struct kobj_attribute tgt_dev_active_commands_attr =
 
 struct attribute *scst_tgt_dev_attrs[] = {
 	&tgt_dev_active_commands_attr.attr,
-#ifdef CONFIG_SCST_MEASURE_LATENCY
-	&tgt_dev_latency_attr.attr,
-#endif
 	NULL,
 };
 
@@ -1645,12 +1542,24 @@ int scst_tgt_dev_sysfs_create(struct scst_tgt_dev *tgt_dev)
 		goto out;
 	}
 
+	res = scst_tgt_dev_debugfs_create(tgt_dev);
+	if (res)
+		goto err;
+
+	res = scst_tgt_dev_lat_create(tgt_dev);
+	if (res)
+		goto err;
 out:
 	return res;
+err:
+	scst_tgt_dev_sysfs_del(tgt_dev);
+	goto out;
 }
 
 void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev)
 {
+	scst_tgt_dev_lat_remove(tgt_dev);
+	scst_tgt_dev_debugfs_remove(tgt_dev);
 	kobject_del(&tgt_dev->tgt_dev_kobj);
 }
 
@@ -1658,223 +1567,6 @@ void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev)
  ** Sessions subdirectory implementation
  **/
 
-#ifdef CONFIG_SCST_MEASURE_LATENCY
-
-static ssize_t scst_sess_latency_show(struct kobject *kobj,
-	struct kobj_attribute *attr, char *buffer)
-{
-	ssize_t res;
-	struct scst_session *sess;
-	int i;
-	char buf[50];
-	uint64_t scst_time, tgt_time, dev_time;
-	unsigned int processed_cmds;
-
-	sess = scst_kobj_to_sess(kobj);
-
-	res = 0;
-	res += scnprintf(&buffer[res], PAGE_SIZE - res,
-		"%-15s %-15s %-46s %-46s %-46s\n",
-		"T-L names", "Total commands", "SCST latency",
-		"Target latency", "Dev latency (min/avg/max/all ns)");
-
-	spin_lock_bh(&sess->lat_lock);
-
-	for (i = 0; i < SCST_LATENCY_STATS_NUM ; i++) {
-		uint64_t scst_time_wr, tgt_time_wr, dev_time_wr;
-		unsigned int processed_cmds_wr;
-		uint64_t scst_time_rd, tgt_time_rd, dev_time_rd;
-		unsigned int processed_cmds_rd;
-		struct scst_ext_latency_stat *latency_stat;
-
-		latency_stat = &sess->sess_latency_stat[i];
-		scst_time_wr = latency_stat->scst_time_wr;
-		scst_time_rd = latency_stat->scst_time_rd;
-		tgt_time_wr = latency_stat->tgt_time_wr;
-		tgt_time_rd = latency_stat->tgt_time_rd;
-		dev_time_wr = latency_stat->dev_time_wr;
-		dev_time_rd = latency_stat->dev_time_rd;
-		processed_cmds_wr = latency_stat->processed_cmds_wr;
-		processed_cmds_rd = latency_stat->processed_cmds_rd;
-
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-5s %-9s %-15lu ",
-			"Write", scst_io_size_names[i],
-			(unsigned long)processed_cmds_wr);
-		if (processed_cmds_wr == 0)
-			processed_cmds_wr = 1;
-
-		do_div(scst_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_scst_time_wr,
-			(unsigned long)scst_time_wr,
-			(unsigned long)latency_stat->max_scst_time_wr,
-			(unsigned long)latency_stat->scst_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s", buf);
-
-		do_div(tgt_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_tgt_time_wr,
-			(unsigned long)tgt_time_wr,
-			(unsigned long)latency_stat->max_tgt_time_wr,
-			(unsigned long)latency_stat->tgt_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s", buf);
-
-		do_div(dev_time_wr, processed_cmds_wr);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_dev_time_wr,
-			(unsigned long)dev_time_wr,
-			(unsigned long)latency_stat->max_dev_time_wr,
-			(unsigned long)latency_stat->dev_time_wr);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s\n", buf);
-
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-5s %-9s %-15lu ",
-			"Read", scst_io_size_names[i],
-			(unsigned long)processed_cmds_rd);
-		if (processed_cmds_rd == 0)
-			processed_cmds_rd = 1;
-
-		do_div(scst_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_scst_time_rd,
-			(unsigned long)scst_time_rd,
-			(unsigned long)latency_stat->max_scst_time_rd,
-			(unsigned long)latency_stat->scst_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s", buf);
-
-		do_div(tgt_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_tgt_time_rd,
-			(unsigned long)tgt_time_rd,
-			(unsigned long)latency_stat->max_tgt_time_rd,
-			(unsigned long)latency_stat->tgt_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s", buf);
-
-		do_div(dev_time_rd, processed_cmds_rd);
-		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-			(unsigned long)latency_stat->min_dev_time_rd,
-			(unsigned long)dev_time_rd,
-			(unsigned long)latency_stat->max_dev_time_rd,
-			(unsigned long)latency_stat->dev_time_rd);
-		res += scnprintf(&buffer[res], PAGE_SIZE - res,
-			"%-47s\n", buf);
-	}
-
-	scst_time = sess->scst_time;
-	tgt_time = sess->tgt_time;
-	dev_time = sess->dev_time;
-	processed_cmds = sess->processed_cmds;
-
-	res += scnprintf(&buffer[res], PAGE_SIZE - res,
-		"\n%-15s %-16d", "Overall ", processed_cmds);
-
-	if (processed_cmds == 0)
-		processed_cmds = 1;
-
-	do_div(scst_time, processed_cmds);
-	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-		(unsigned long)sess->min_scst_time,
-		(unsigned long)scst_time,
-		(unsigned long)sess->max_scst_time,
-		(unsigned long)sess->scst_time);
-	res += scnprintf(&buffer[res], PAGE_SIZE - res,
-		"%-47s", buf);
-
-	do_div(tgt_time, processed_cmds);
-	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-		(unsigned long)sess->min_tgt_time,
-		(unsigned long)tgt_time,
-		(unsigned long)sess->max_tgt_time,
-		(unsigned long)sess->tgt_time);
-	res += scnprintf(&buffer[res], PAGE_SIZE - res,
-		"%-47s", buf);
-
-	do_div(dev_time, processed_cmds);
-	snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
-		(unsigned long)sess->min_dev_time,
-		(unsigned long)dev_time,
-		(unsigned long)sess->max_dev_time,
-		(unsigned long)sess->dev_time);
-	res += scnprintf(&buffer[res], PAGE_SIZE - res,
-		"%-47s\n\n", buf);
-
-	spin_unlock_bh(&sess->lat_lock);
-	return res;
-}
-
-static int scst_sess_zero_latency(struct scst_session *sess)
-{
-	int res, t;
-
-	res = mutex_lock_interruptible(&scst_mutex);
-	if (res != 0)
-		goto out;
-
-	PRINT_INFO("Zeroing latency statistics for initiator "
-		"%s", sess->initiator_name);
-
-	spin_lock_bh(&sess->lat_lock);
-
-	sess->scst_time = 0;
-	sess->tgt_time = 0;
-	sess->dev_time = 0;
-	sess->min_scst_time = 0;
-	sess->min_tgt_time = 0;
-	sess->min_dev_time = 0;
-	sess->max_scst_time = 0;
-	sess->max_tgt_time = 0;
-	sess->max_dev_time = 0;
-	sess->processed_cmds = 0;
-	memset(sess->sess_latency_stat, 0,
-		sizeof(sess->sess_latency_stat));
-
-	for (t = SESS_TGT_DEV_LIST_HASH_SIZE-1; t >= 0; t--) {
-		struct list_head *head = &sess->sess_tgt_dev_list[t];
-		struct scst_tgt_dev *tgt_dev;
-		list_for_each_entry(tgt_dev, head, sess_tgt_dev_list_entry) {
-			tgt_dev->scst_time = 0;
-			tgt_dev->tgt_time = 0;
-			tgt_dev->dev_time = 0;
-			tgt_dev->processed_cmds = 0;
-			memset(tgt_dev->dev_latency_stat, 0,
-				sizeof(tgt_dev->dev_latency_stat));
-		}
-	}
-
-	spin_unlock_bh(&sess->lat_lock);
-
-	mutex_unlock(&scst_mutex);
-
-out:
-	return res;
-}
-
-static ssize_t scst_sess_latency_store(struct kobject *kobj,
-	struct kobj_attribute *attr, const char *buf, size_t count)
-{
-	int res;
-	struct scst_session *sess;
-
-	sess = scst_kobj_to_sess(kobj);
-
-	res = scst_sess_zero_latency(sess);
-	if (res == 0)
-		res = count;
-	return res;
-}
-
-static struct kobj_attribute session_latency_attr =
-	__ATTR(latency, S_IRUGO | S_IWUSR, scst_sess_latency_show,
-	       scst_sess_latency_store);
-
-#endif /* CONFIG_SCST_MEASURE_LATENCY */
-
 static ssize_t scst_sess_sysfs_commands_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
 {
@@ -1949,9 +1641,6 @@ struct attribute *scst_session_attrs[] = {
 	&session_commands_attr.attr,
 	&session_active_commands_attr.attr,
 	&session_initiator_name_attr.attr,
-#ifdef CONFIG_SCST_MEASURE_LATENCY
-	&session_latency_attr.attr,
-#endif /* CONFIG_SCST_MEASURE_LATENCY */
 	NULL,
 };
 
@@ -2010,6 +1699,14 @@ int scst_sess_sysfs_create(struct scst_session *sess)
 	if (res)
 		goto out_free;
 
+	res = scst_sess_debugfs_create(sess);
+	if (res)
+		goto out_free;
+
+	res = scst_sess_lat_create(sess);
+	if (res)
+		goto out_free;
+
 out:
 	return res;
 out_free:
@@ -2019,6 +1716,8 @@ out_free:
 
 void scst_sess_sysfs_del(struct scst_session *sess)
 {
+	scst_sess_lat_remove(sess);
+	scst_sess_debugfs_remove(sess);
 	kobject_del(&sess->sess_kobj);
 }
 
@@ -3183,7 +2882,7 @@ int scst_devt_sysfs_create(struct scst_dev_type *devt)
 		}
 	}
 
-	res = scst_devt_create_trace_files(devt);
+	res = scst_devt_debugfs_create(devt);
 	if (res) {
 		PRINT_ERROR("Can't create tracing files for device type %s",
 			    devt->name);
@@ -3200,7 +2899,7 @@ out_err:
 
 void scst_devt_sysfs_del(struct scst_dev_type *devt)
 {
-	scst_devt_remove_trace_files(devt);
+	scst_devt_debugfs_remove(devt);
 }
 
 void scst_devt_sysfs_put(struct scst_dev_type *devt)
@@ -3854,7 +3553,7 @@ int __init scst_sysfs_init(void)
 		goto out_unregister_device;
 	}
 
-	res = scst_main_create_trace_files();
+	res = scst_main_debugfs_create();
 	if (res) {
 		PRINT_ERROR("%s", "Creating SCST trace files failed.");
 		goto out_remove_files;
@@ -3863,7 +3562,7 @@ int __init scst_sysfs_init(void)
 out:
 	return res;
 
-	scst_main_remove_trace_files();
+	scst_main_debugfs_remove();
 out_remove_files:
 	device_remove_files(scst_device, scst_root_default_attrs);
 out_unregister_device:
@@ -3884,7 +3583,7 @@ void scst_sysfs_cleanup(void)
 {
 	PRINT_INFO("%s", "Exiting SCST sysfs hierarchy...");
 
-	scst_main_remove_trace_files();
+	scst_main_debugfs_remove();
 
 	device_remove_files(scst_device, scst_root_default_attrs);
 
diff --git a/drivers/scst/scst_tracing.c b/drivers/scst/scst_tracing.c
index 9b9aef4..c87597b 100644
--- a/drivers/scst/scst_tracing.c
+++ b/drivers/scst/scst_tracing.c
@@ -24,7 +24,8 @@
 #include "scst_tracing.h"
 
 static struct dentry *scst_debug_root;
-static struct dentry *scst_debug_target;
+static struct dentry *scst_debug_tgtt;
+static struct dentry *scst_debug_tgt;
 static struct dentry *scst_debug_devt;
 static struct dentry *scst_debug_dev;
 static struct dentry *scst_main_tracing_dir;
@@ -167,29 +168,21 @@ static const struct file_operations scst_tracing_fops = {
 	.llseek	=	noop_llseek,
 };
 
-static struct dentry *scst_create_trace_files(struct dentry *root,
-					      const char *dir_name,
+static struct dentry *scst_create_trace_files(struct dentry *dir,
 					      struct scst_trace_data *td)
 {
 	int i;
-	struct dentry *subdir, *tracing_dir, *file;
+	struct dentry *tracing_dir, *file;
 	const struct scst_trace_log *p;
 	const struct scst_trace_log *tracing_table[] = {
 		scst_trace_tbl,
 		td->trace_tbl,
 	};
 
-	BUG_ON(!root);
-	BUG_ON(!dir_name);
+	BUG_ON(!dir);
 	BUG_ON(!td);
 
-	subdir = debugfs_create_dir(dir_name, root);
-	if (!subdir) {
-		PRINT_ERROR("Creation of directory %s failed", dir_name);
-		goto out;
-	}
-
-	tracing_dir = debugfs_create_dir("tracing", subdir);
+	tracing_dir = debugfs_create_dir("tracing", dir);
 	if (!tracing_dir) {
 		PRINT_ERROR("%s", "Creation of tracing dir failed");
 		goto err;
@@ -208,18 +201,13 @@ static struct dentry *scst_create_trace_files(struct dentry *root,
 		}
 	}
 out:
-	return subdir;
+	return tracing_dir;
 err:
-	debugfs_remove_recursive(subdir);
-	subdir = NULL;
+	debugfs_remove_recursive(tracing_dir);
+	tracing_dir = NULL;
 	goto out;
 }
 
-static void scst_remove_trace_files(struct dentry *dir)
-{
-	debugfs_remove_recursive(dir);
-}
-
 int scst_debugfs_init(void)
 {
 	int res;
@@ -238,8 +226,15 @@ int scst_debugfs_init(void)
 		goto err;
 	}
 
-	scst_debug_target = debugfs_create_dir("target", scst_debug_root);
-	if (!scst_debug_target) {
+	scst_debug_tgtt = debugfs_create_dir("target_driver", scst_debug_root);
+	if (!scst_debug_tgtt) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/"
+			    "target_driver failed");
+		goto err;
+	}
+
+	scst_debug_tgt = debugfs_create_dir("target", scst_debug_root);
+	if (!scst_debug_tgt) {
 		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/target"
 			    " failed");
 		goto err;
@@ -273,57 +268,164 @@ void scst_debugfs_cleanup(void)
 	debugfs_remove_recursive(scst_debug_root);
 	scst_debug_dev = NULL;
 	scst_debug_devt = NULL;
-	scst_debug_target = NULL;
+	scst_debug_tgt = NULL;
+	scst_debug_tgtt = NULL;
 	scst_debug_root = NULL;
 }
 
-int scst_main_create_trace_files(void)
+int scst_main_debugfs_create(void)
 {
-	scst_main_tracing_dir = scst_create_trace_files(scst_debug_root,
-							"main",
-							&scst_main_trace_data);
-	return scst_main_tracing_dir ? 0 : -EINVAL;
+	int res;
+
+	res = -ENOMEM;
+	scst_main_tracing_dir = debugfs_create_dir("main", scst_debug_root);
+	if (!scst_main_tracing_dir)
+		goto out;
+
+	if (!scst_create_trace_files(scst_main_tracing_dir,
+				     &scst_main_trace_data)) {
+		goto out;
+	}
+	res = 0;
+out:
+	return res;
 }
 
-void scst_main_remove_trace_files(void)
+void scst_main_debugfs_remove(void)
 {
-	scst_remove_trace_files(scst_main_tracing_dir);
+	debugfs_remove_recursive(scst_main_tracing_dir);
 	scst_main_tracing_dir = NULL;
 }
 
-int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt)
+int scst_tgtt_debugfs_create(struct scst_tgt_template *tgtt)
 {
-	if (tgtt->trace_data.trace_flags) {
-		tgtt->tracing_dir = scst_create_trace_files(scst_debug_target,
-							    tgtt->name,
-							    &tgtt->trace_data);
-		if (!tgtt->tracing_dir)
-			return -EINVAL;
+	int res;
+
+	res = -ENOMEM;
+	tgtt->tracing_dir = debugfs_create_dir(tgtt->name, scst_debug_tgtt);
+	if (!tgtt->tracing_dir) {
+		PRINT_ERROR("Creation of directory %s failed", tgtt->name);
+		goto out;
 	}
-	return 0;
+
+	if (tgtt->trace_data.trace_flags &&
+	    !scst_create_trace_files(tgtt->tracing_dir, &tgtt->trace_data)) {
+			res = -ENOMEM;
+			goto out;
+	}
+	res = 0;
+out:
+	return res;
 }
 
-void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt)
+void scst_tgtt_debugfs_remove(struct scst_tgt_template *tgtt)
 {
-	scst_remove_trace_files(tgtt->tracing_dir);
+	debugfs_remove_recursive(tgtt->tracing_dir);
 	tgtt->tracing_dir = NULL;
 }
 
-int scst_devt_create_trace_files(struct scst_dev_type *devt)
+int scst_tgt_debugfs_create(struct scst_tgt *tgt)
 {
-	if (devt->trace_data.trace_flags) {
-		devt->tracing_dir = scst_create_trace_files(scst_debug_devt,
-							    devt->name,
-							    &devt->trace_data);
-		if (!devt->tracing_dir)
-			return -EINVAL;
+	int res;
+
+	res = -ENOMEM;
+	tgt->debugfs_dir = debugfs_create_dir(tgt->tgt_name, scst_debug_tgt);
+	if (!tgt->debugfs_dir) {
+		PRINT_ERROR("Creation of directory %s failed", tgt->tgt_name);
+		goto out;
 	}
-	return 0;
+	tgt->sessions_dir = debugfs_create_dir("sessions", tgt->debugfs_dir);
+	if (!tgt->sessions_dir) {
+		PRINT_ERROR("Creation of directory %s/sessions failed",
+			    tgt->tgt_name);
+		goto out;
+	}
+	res = 0;
+out:
+	return res;
+}
+
+void scst_tgt_debugfs_remove(struct scst_tgt *tgt)
+{
+	debugfs_remove_recursive(tgt->debugfs_dir);
+	tgt->debugfs_dir = NULL;
+}
+
+int scst_sess_debugfs_create(struct scst_session *sess)
+{
+	int res;
+
+	res = -ENOMEM;
+	sess->debugfs_dir = debugfs_create_dir(sess->initiator_name,
+					       sess->tgt->sessions_dir);
+	if (!sess->debugfs_dir) {
+		PRINT_ERROR("Creation of directory %s failed",
+			    sess->initiator_name);
+		goto out;
+	}
+	sess->luns_dir = debugfs_create_dir("luns", sess->debugfs_dir);
+	if (!sess->luns_dir) {
+		PRINT_ERROR("Creation of directory %s/sessions failed",
+			    sess->initiator_name);
+		goto out;
+	}
+	res = 0;
+out:
+	return res;
+}
+
+void scst_sess_debugfs_remove(struct scst_session *sess)
+{
+	debugfs_remove_recursive(sess->debugfs_dir);
+	sess->debugfs_dir = NULL;
+}
+
+int scst_tgt_dev_debugfs_create(struct scst_tgt_dev *tgt_dev)
+{
+	int res;
+	char lun[16];
+
+	res = -ENOMEM;
+	snprintf(lun, sizeof(lun), "%llx", tgt_dev->lun);
+	tgt_dev->debugfs_dir = debugfs_create_dir(lun, tgt_dev->sess->luns_dir);
+	if (!tgt_dev->debugfs_dir) {
+		PRINT_ERROR("Creation of directory %s/luns/%s failed",
+			    tgt_dev->sess->initiator_name, lun);
+		goto out;
+	}
+	res = 0;
+out:
+	return res;
+}
+
+void scst_tgt_dev_debugfs_remove(struct scst_tgt_dev *tgt_dev)
+{
+	debugfs_remove_recursive(tgt_dev->debugfs_dir);
+	tgt_dev->debugfs_dir = NULL;
+}
+
+int scst_devt_debugfs_create(struct scst_dev_type *devt)
+{
+	int res;
+
+	res = -ENOMEM;
+	devt->tracing_dir = debugfs_create_dir(devt->name, scst_debug_devt);
+	if (!devt->tracing_dir)
+		goto out;
+	if (devt->trace_data.trace_flags &&
+	    !scst_create_trace_files(devt->tracing_dir, &devt->trace_data))
+		goto err;
+	res = 0;
+out:
+	return res;
+err:
+	scst_devt_debugfs_remove(devt);
+	goto out;
 }
 
-void scst_devt_remove_trace_files(struct scst_dev_type *devt)
+void scst_devt_debugfs_remove(struct scst_dev_type *devt)
 {
-	scst_remove_trace_files(devt->tracing_dir);
+	debugfs_remove_recursive(devt->tracing_dir);
 	devt->tracing_dir = NULL;
 }
 
diff --git a/drivers/scst/scst_tracing.h b/drivers/scst/scst_tracing.h
index 8fd40bd..23b820b 100644
--- a/drivers/scst/scst_tracing.h
+++ b/drivers/scst/scst_tracing.h
@@ -4,12 +4,18 @@
 
 int scst_debugfs_init(void);
 void scst_debugfs_cleanup(void);
-int scst_main_create_trace_files(void);
-void scst_main_remove_trace_files(void);
-int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt);
-void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt);
-int scst_devt_create_trace_files(struct scst_dev_type *devt);
-void scst_devt_remove_trace_files(struct scst_dev_type *devt);
+int scst_main_debugfs_create(void);
+void scst_main_debugfs_remove(void);
+int scst_tgtt_debugfs_create(struct scst_tgt_template *tgtt);
+void scst_tgtt_debugfs_remove(struct scst_tgt_template *tgtt);
+int scst_tgt_debugfs_create(struct scst_tgt *tgtt);
+void scst_tgt_debugfs_remove(struct scst_tgt *tgtt);
+int scst_sess_debugfs_create(struct scst_session *tgtt);
+void scst_sess_debugfs_remove(struct scst_session *tgtt);
+int scst_tgt_dev_debugfs_create(struct scst_tgt_dev *tgtt);
+void scst_tgt_dev_debugfs_remove(struct scst_tgt_dev *tgtt);
+int scst_devt_debugfs_create(struct scst_dev_type *devt);
+void scst_devt_debugfs_remove(struct scst_dev_type *devt);
 int scst_dev_create_debug_files(struct scst_device *dev);
 void scst_dev_remove_debug_files(struct scst_device *dev);
 
@@ -24,30 +30,57 @@ static inline void scst_debugfs_cleanup(void)
 {
 }
 
-static inline int scst_main_create_trace_files(void)
+static inline int scst_main_debugfs_create(void)
 {
 	return 0;
 }
 
-static inline void scst_main_remove_trace_files(void)
+static inline void scst_main_debugfs_remove(void)
 {
 }
 
-static inline int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt)
+static inline int scst_tgtt_debugfs_create(struct scst_tgt_template *tgtt)
 {
 	return 0;
 }
 
-static inline void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt)
+static inline void scst_tgtt_debugfs_remove(struct scst_tgt_template *tgtt)
 {
 }
 
-static inline int scst_devt_create_trace_files(struct scst_dev_type *devt)
+static inline int scst_tgt_debugfs_create(struct scst_tgt *tgtt)
 {
 	return 0;
 }
 
-static inline void scst_devt_remove_trace_files(struct scst_dev_type *devt)
+static inline void scst_tgt_debugfs_remove(struct scst_tgt *tgtt)
+{
+}
+
+static inline int scst_sess_debugfs_create(struct scst_session *tgtt)
+{
+	return 0;
+}
+
+static inline void scst_sess_debugfs_remove(struct scst_session *tgtt)
+{
+}
+
+static inline int scst_tgt_dev_debugfs_create(struct scst_tgt_dev *tgtt)
+{
+	return 0;
+}
+
+static inline void scst_tgt_dev_debugfs_remove(struct scst_tgt_dev *tgtt)
+{
+}
+
+static inline int scst_devt_debugfs_create(struct scst_dev_type *devt)
+{
+	return 0;
+}
+
+static inline void scst_devt_debugfs_remove(struct scst_dev_type *devt)
 {
 }
 
diff --git a/include/scst/scst.h b/include/scst/scst.h
index 9034624..1f59ec1 100644
--- a/include/scst/scst.h
+++ b/include/scst/scst.h
@@ -1316,6 +1316,11 @@ struct scst_tgt {
 	struct kobject *tgt_sess_kobj; /* target/sessions/ */
 	struct kobject *tgt_luns_kobj; /* target/luns/ */
 	struct kobject *tgt_ini_grp_kobj; /* target/ini_groups/ */
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+	struct dentry *sessions_dir;
+#endif
 };
 
 #ifdef CONFIG_SCST_MEASURE_LATENCY
@@ -1449,6 +1454,10 @@ struct scst_session {
 				int result);
 	void (*unreg_done_fn) (struct scst_session *sess);
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+	struct dentry *luns_dir;
+#endif
 #ifdef CONFIG_SCST_MEASURE_LATENCY
 	/*
 	 * Must be the last to allow to work with drivers who don't know
@@ -1460,6 +1469,8 @@ struct scst_session {
 	uint64_t min_scst_time, min_tgt_time, min_dev_time;
 	uint64_t max_scst_time, max_tgt_time, max_dev_time;
 	struct scst_ext_latency_stat sess_latency_stat[SCST_LATENCY_STATS_NUM];
+
+	struct dentry *latency_file;
 #endif
 };
 
@@ -1813,6 +1824,9 @@ struct scst_cmd {
 
 	struct scst_cmd *orig_cmd; /* Used to issue REQUEST SENSE */
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+#endif
 #ifdef CONFIG_SCST_MEASURE_LATENCY
 	/*
 	 * Must be the last to allow to work with drivers who don't know
@@ -1822,6 +1836,8 @@ struct scst_cmd {
 	uint64_t restart_waiting_time, rdy_to_xfer_time;
 	uint64_t pre_exec_time, exec_time, dev_done_time;
 	uint64_t xmit_time, tgt_on_free_time, dev_on_free_time;
+
+	struct dentry *latency_file;
 #endif
 };
 
@@ -2228,6 +2244,9 @@ struct scst_tgt_dev {
 
 	struct kobject tgt_dev_kobj; /* kobject for this struct */
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+#endif
 #ifdef CONFIG_SCST_MEASURE_LATENCY
 	/*
 	 * Must be the last to allow to work with drivers who don't know
@@ -2238,6 +2257,8 @@ struct scst_tgt_dev {
 	uint64_t scst_time, tgt_time, dev_time;
 	unsigned int processed_cmds;
 	struct scst_ext_latency_stat dev_latency_stat[SCST_LATENCY_STATS_NUM];
+
+	struct dentry *latency_file;
 #endif
 };
 
-- 
1.7.1

