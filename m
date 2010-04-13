From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 7/12/1/5] SCST SGV cache
Date: Tue, 13 Apr 2010 17:06:18 +0400
Message-ID: <4BC46C4A.5080809@vlnb.net>
References: <4BC44A49.7070307@vlnb.net> <4BC44D08.4060907@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BC44D08.4060907@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, linux-driver@qlogic.com
List-Id: linux-scsi@vger.kernel.org

This patch contains SCST SGV cache. SGV cache is a memory management 
subsystem in SCST. More info about it you can find in the documentation
in this patch.

P.S. Solaris COMSTAR also has similar facility.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Documentation/scst/sgv_cache.txt |  224 ++++
 drivers/scst/scst_mem.c          | 1788 +++++++++++++++++++++++++++++++++++++++
 drivers/scst/scst_mem.h          |  150 +++
 include/scst/scst_sgv.h          |   97 ++
 4 files changed, 2259 insertions(+)

diff -uprN orig/linux-2.6.33/include/scst/scst_sgv.h linux-2.6.33/include/scst/scst_sgv.h
--- orig/linux-2.6.33/include/scst/scst_sgv.h
+++ linux-2.6.33/include/scst/scst_sgv.h
@@ -0,0 +1,97 @@
+/*
+ *  include/scst_sgv.h
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  Include file for SCST SGV cache.
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
+#ifndef __SCST_SGV_H
+#define __SCST_SGV_H
+
+/** SGV pool routines and flag bits **/
+
+/* Set if the allocated object must be not from the cache */
+#define SGV_POOL_ALLOC_NO_CACHED		1
+
+/* Set if there should not be any memory allocations on a cache miss */
+#define SGV_POOL_NO_ALLOC_ON_CACHE_MISS		2
+
+/* Set an object should be returned even if it doesn't have SG vector built */
+#define SGV_POOL_RETURN_OBJ_ON_ALLOC_FAIL	4
+
+/*
+ * Set if the allocated object must be a new one, i.e. from the cache,
+ * but not cached
+ */
+#define SGV_POOL_ALLOC_GET_NEW			8
+
+struct sgv_pool_obj;
+struct sgv_pool;
+
+/*
+ * Structure to keep a memory limit for an SCST object
+ */
+struct scst_mem_lim {
+	/* How much memory allocated under this object */
+	atomic_t alloced_pages;
+
+	/*
+	 * How much memory allowed to allocated under this object. Put here
+	 * mostly to save a possible cache miss accessing scst_max_dev_cmd_mem.
+	 */
+	int max_allowed_pages;
+};
+
+/* Types of clustering */
+enum sgv_clustering_types {
+	/* No clustering performed */
+	sgv_no_clustering = 0,
+
+	/*
+	 * A page will only be merged with the latest previously allocated
+	 * page, so the order of pages in the SG will be preserved.
+	 */
+	sgv_tail_clustering,
+
+	/*
+	 * Free merging of pages at any place in the SG is allowed. This mode
+	 * usually provides the best merging rate.
+	 */
+	sgv_full_clustering,
+};
+
+struct sgv_pool *sgv_pool_create(const char *name,
+	enum sgv_clustering_types clustered, int single_alloc_pages,
+	bool shared, int purge_interval);
+void sgv_pool_del(struct sgv_pool *pool);
+
+void sgv_pool_get(struct sgv_pool *pool);
+void sgv_pool_put(struct sgv_pool *pool);
+
+void sgv_pool_flush(struct sgv_pool *pool);
+
+void sgv_pool_set_allocator(struct sgv_pool *pool,
+	struct page *(*alloc_pages_fn)(struct scatterlist *, gfp_t, void *),
+	void (*free_pages_fn)(struct scatterlist *, int, void *));
+
+struct scatterlist *sgv_pool_alloc(struct sgv_pool *pool, unsigned int size,
+	gfp_t gfp_mask, int flags, int *count,
+	struct sgv_pool_obj **sgv, struct scst_mem_lim *mem_lim, void *priv);
+void sgv_pool_free(struct sgv_pool_obj *sgv, struct scst_mem_lim *mem_lim);
+
+void *sgv_get_priv(struct sgv_pool_obj *sgv);
+
+void scst_init_mem_lim(struct scst_mem_lim *mem_lim);
+
+#endif /* __SCST_SGV_H */
diff -uprN orig/linux-2.6.33/drivers/scst/scst_mem.h linux-2.6.33/drivers/scst/scst_mem.h
--- orig/linux-2.6.33/drivers/scst/scst_mem.h
+++ linux-2.6.33/drivers/scst/scst_mem.h
@@ -0,0 +1,150 @@
+/*
+ *  scst_mem.h
+ *
+ *  Copyright (C) 2006 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
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
+#include <linux/scatterlist.h>
+#include <linux/workqueue.h>
+
+#define SGV_POOL_ELEMENTS	11
+
+/*
+ * sg_num is indexed by the page number, pg_count is indexed by the sg number.
+ * Made in one entry to simplify the code (eg all sizeof(*) parts) and save
+ * some CPU cache for non-clustered case.
+ */
+struct trans_tbl_ent {
+	unsigned short sg_num;
+	unsigned short pg_count;
+};
+
+/*
+ * SGV pool object
+ */
+struct sgv_pool_obj {
+	int cache_num;
+	int pages;
+
+	/* jiffies, protected by sgv_pool_lock */
+	unsigned long time_stamp;
+
+	struct list_head recycling_list_entry;
+	struct list_head sorted_recycling_list_entry;
+
+	struct sgv_pool *owner_pool;
+	int orig_sg;
+	int orig_length;
+	int sg_count;
+	void *allocator_priv;
+	struct trans_tbl_ent *trans_tbl;
+	struct scatterlist *sg_entries;
+	struct scatterlist sg_entries_data[0];
+};
+
+/*
+ * SGV pool statistics accounting structure
+ */
+struct sgv_pool_cache_acc {
+	atomic_t total_alloc, hit_alloc;
+	atomic_t merged;
+};
+
+/*
+ * SGV pool allocation functions
+ */
+struct sgv_pool_alloc_fns {
+	struct page *(*alloc_pages_fn)(struct scatterlist *sg, gfp_t gfp_mask,
+		void *priv);
+	void (*free_pages_fn)(struct scatterlist *sg, int sg_count,
+		void *priv);
+};
+
+/*
+ * SGV pool
+ */
+struct sgv_pool {
+	enum sgv_clustering_types clustering_type;
+	int single_alloc_pages;
+	int max_cached_pages;
+
+	struct sgv_pool_alloc_fns alloc_fns;
+
+	/* <=4K, <=8, <=16, <=32, <=64, <=128, <=256, <=512, <=1024, <=2048 */
+	struct kmem_cache *caches[SGV_POOL_ELEMENTS];
+
+	spinlock_t sgv_pool_lock; /* outer lock for sgv_pools_lock! */
+
+	int purge_interval;
+
+	/* Protected by sgv_pool_lock, if necessary */
+	unsigned int purge_work_scheduled:1;
+	unsigned int sgv_kobj_initialized:1;
+
+	/* Protected by sgv_pool_lock */
+	struct list_head sorted_recycling_list;
+
+	int inactive_cached_pages; /* protected by sgv_pool_lock */
+
+	/* Protected by sgv_pool_lock */
+	struct list_head recycling_lists[SGV_POOL_ELEMENTS];
+
+	int cached_pages, cached_entries; /* protected by sgv_pool_lock */
+
+	struct sgv_pool_cache_acc cache_acc[SGV_POOL_ELEMENTS];
+
+	struct delayed_work sgv_purge_work;
+
+	struct list_head sgv_active_pools_list_entry;
+
+	atomic_t big_alloc, big_pages, big_merged;
+	atomic_t other_alloc, other_pages, other_merged;
+
+	atomic_t sgv_pool_ref;
+
+	int max_caches;
+
+	/* SCST_MAX_NAME + few more bytes to match scst_user expectations */
+	char cache_names[SGV_POOL_ELEMENTS][SCST_MAX_NAME + 10];
+	char name[SCST_MAX_NAME + 10];
+
+	struct mm_struct *owner_mm;
+
+	struct list_head sgv_pools_list_entry;
+
+	struct kobject sgv_kobj;
+};
+
+static inline struct scatterlist *sgv_pool_sg(struct sgv_pool_obj *obj)
+{
+	return obj->sg_entries;
+}
+
+int scst_sgv_pools_init(unsigned long mem_hwmark, unsigned long mem_lwmark);
+void scst_sgv_pools_deinit(void);
+
+void sgv_pool_destroy(struct sgv_pool *pool);
+
+ssize_t sgv_sysfs_stat_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf);
+ssize_t sgv_sysfs_stat_reset(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count);
+ssize_t sgv_sysfs_global_stat_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf);
+ssize_t sgv_sysfs_global_stat_reset(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count);
+
+void scst_sgv_pool_use_norm(struct scst_tgt_dev *tgt_dev);
+void scst_sgv_pool_use_norm_clust(struct scst_tgt_dev *tgt_dev);
+void scst_sgv_pool_use_dma(struct scst_tgt_dev *tgt_dev);
diff -uprN orig/linux-2.6.33/drivers/scst/scst_mem.c linux-2.6.33/drivers/scst/scst_mem.c
--- orig/linux-2.6.33/drivers/scst/scst_mem.c
+++ linux-2.6.33/drivers/scst/scst_mem.c
@@ -0,0 +1,1788 @@
+/*
+ *  scst_mem.c
+ *
+ *  Copyright (C) 2006 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
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
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/unistd.h>
+#include <linux/string.h>
+
+#include "scst.h"
+#include "scst_priv.h"
+#include "scst_mem.h"
+
+#define SGV_DEFAULT_PURGE_INTERVAL	(60 * HZ)
+#define SGV_MIN_SHRINK_INTERVAL		(1 * HZ)
+
+/* Max pages freed from a pool per shrinking iteration */
+#define MAX_PAGES_PER_POOL	50
+
+static struct sgv_pool *sgv_norm_clust_pool, *sgv_norm_pool, *sgv_dma_pool;
+
+static atomic_t sgv_pages_total = ATOMIC_INIT(0);
+
+/* Both read-only */
+static int sgv_hi_wmk;
+static int sgv_lo_wmk;
+
+static int sgv_max_local_pages, sgv_max_trans_pages;
+
+static DEFINE_SPINLOCK(sgv_pools_lock); /* inner lock for sgv_pool_lock! */
+static DEFINE_MUTEX(sgv_pools_mutex);
+
+/* Both protected by sgv_pools_lock */
+static struct sgv_pool *sgv_cur_purge_pool;
+static LIST_HEAD(sgv_active_pools_list);
+
+static atomic_t sgv_releases_on_hiwmk = ATOMIC_INIT(0);
+static atomic_t sgv_releases_on_hiwmk_failed = ATOMIC_INIT(0);
+
+static atomic_t sgv_other_total_alloc = ATOMIC_INIT(0);
+
+static struct shrinker sgv_shrinker;
+
+/*
+ * Protected by sgv_pools_mutex AND sgv_pools_lock for writes,
+ * either one for reads.
+ */
+static LIST_HEAD(sgv_pools_list);
+
+static inline bool sgv_pool_clustered(const struct sgv_pool *pool)
+{
+	return pool->clustering_type != sgv_no_clustering;
+}
+
+void scst_sgv_pool_use_norm(struct scst_tgt_dev *tgt_dev)
+{
+	tgt_dev->gfp_mask = __GFP_NOWARN;
+	tgt_dev->pool = sgv_norm_pool;
+	clear_bit(SCST_TGT_DEV_CLUST_POOL, &tgt_dev->tgt_dev_flags);
+}
+
+void scst_sgv_pool_use_norm_clust(struct scst_tgt_dev *tgt_dev)
+{
+	TRACE_MEM("%s", "Use clustering");
+	tgt_dev->gfp_mask = __GFP_NOWARN;
+	tgt_dev->pool = sgv_norm_clust_pool;
+	set_bit(SCST_TGT_DEV_CLUST_POOL, &tgt_dev->tgt_dev_flags);
+}
+
+void scst_sgv_pool_use_dma(struct scst_tgt_dev *tgt_dev)
+{
+	TRACE_MEM("%s", "Use ISA DMA memory");
+	tgt_dev->gfp_mask = __GFP_NOWARN | GFP_DMA;
+	tgt_dev->pool = sgv_dma_pool;
+	clear_bit(SCST_TGT_DEV_CLUST_POOL, &tgt_dev->tgt_dev_flags);
+}
+
+/* Must be no locks */
+static void sgv_dtor_and_free(struct sgv_pool_obj *obj)
+{
+	struct sgv_pool *pool = obj->owner_pool;
+
+	TRACE_MEM("Destroying sgv obj %p", obj);
+
+	if (obj->sg_count != 0) {
+		pool->alloc_fns.free_pages_fn(obj->sg_entries,
+			obj->sg_count, obj->allocator_priv);
+	}
+	if (obj->sg_entries != obj->sg_entries_data) {
+		if (obj->trans_tbl !=
+		    (struct trans_tbl_ent *)obj->sg_entries_data) {
+			/* kfree() handles NULL parameter */
+			kfree(obj->trans_tbl);
+			obj->trans_tbl = NULL;
+		}
+		kfree(obj->sg_entries);
+	}
+
+	kmem_cache_free(pool->caches[obj->cache_num], obj);
+	return;
+}
+
+/* Might be called under sgv_pool_lock */
+static inline void sgv_del_from_active(struct sgv_pool *pool)
+{
+	struct list_head *next;
+
+	TRACE_MEM("Deleting sgv pool %p from the active list", pool);
+
+	spin_lock_bh(&sgv_pools_lock);
+
+	next = pool->sgv_active_pools_list_entry.next;
+	list_del(&pool->sgv_active_pools_list_entry);
+
+	if (sgv_cur_purge_pool == pool) {
+		TRACE_MEM("Sgv pool %p is sgv cur purge pool", pool);
+
+		if (next == &sgv_active_pools_list)
+			next = next->next;
+
+		if (next == &sgv_active_pools_list) {
+			sgv_cur_purge_pool = NULL;
+			TRACE_MEM("%s", "Sgv active list now empty");
+		} else {
+			sgv_cur_purge_pool = list_entry(next, typeof(*pool),
+				sgv_active_pools_list_entry);
+			TRACE_MEM("New sgv cur purge pool %p",
+				sgv_cur_purge_pool);
+		}
+	}
+
+	spin_unlock_bh(&sgv_pools_lock);
+	return;
+}
+
+/* Must be called under sgv_pool_lock held */
+static void sgv_dec_cached_entries(struct sgv_pool *pool, int pages)
+{
+	pool->cached_entries--;
+	pool->cached_pages -= pages;
+
+	if (pool->cached_entries == 0)
+		sgv_del_from_active(pool);
+
+	return;
+}
+
+/* Must be called under sgv_pool_lock held */
+static void __sgv_purge_from_cache(struct sgv_pool_obj *obj)
+{
+	int pages = obj->pages;
+	struct sgv_pool *pool = obj->owner_pool;
+
+	TRACE_MEM("Purging sgv obj %p from pool %p (new cached_entries %d)",
+		obj, pool, pool->cached_entries-1);
+
+	list_del(&obj->sorted_recycling_list_entry);
+	list_del(&obj->recycling_list_entry);
+
+	pool->inactive_cached_pages -= pages;
+	sgv_dec_cached_entries(pool, pages);
+
+	atomic_sub(pages, &sgv_pages_total);
+
+	return;
+}
+
+/* Must be called under sgv_pool_lock held */
+static bool sgv_purge_from_cache(struct sgv_pool_obj *obj, int min_interval,
+	unsigned long cur_time)
+{
+	EXTRACHECKS_BUG_ON(min_interval < 0);
+
+	TRACE_MEM("Checking if sgv obj %p should be purged (cur time %ld, "
+		"obj time %ld, time to purge %ld)", obj, cur_time,
+		obj->time_stamp, obj->time_stamp + min_interval);
+
+	if (time_after_eq(cur_time, (obj->time_stamp + min_interval))) {
+		__sgv_purge_from_cache(obj);
+		return true;
+	}
+	return false;
+}
+
+/* No locks */
+static int sgv_shrink_pool(struct sgv_pool *pool, int nr, int min_interval,
+	unsigned long cur_time)
+{
+	int freed = 0;
+
+	TRACE_MEM("Trying to shrink pool %p (nr %d, min_interval %d)",
+		pool, nr, min_interval);
+
+	if (pool->purge_interval < 0) {
+		TRACE_MEM("Not shrinkable pool %p, skipping", pool);
+		goto out;
+	}
+
+	spin_lock_bh(&pool->sgv_pool_lock);
+
+	while (!list_empty(&pool->sorted_recycling_list) &&
+			(atomic_read(&sgv_pages_total) > sgv_lo_wmk)) {
+		struct sgv_pool_obj *obj = list_entry(
+			pool->sorted_recycling_list.next,
+			struct sgv_pool_obj, sorted_recycling_list_entry);
+
+		if (sgv_purge_from_cache(obj, min_interval, cur_time)) {
+			int pages = obj->pages;
+
+			freed += pages;
+			nr -= pages;
+
+			TRACE_MEM("%d pages purged from pool %p (nr left %d, "
+				"total freed %d)", pages, pool, nr, freed);
+
+			spin_unlock_bh(&pool->sgv_pool_lock);
+			sgv_dtor_and_free(obj);
+			spin_lock_bh(&pool->sgv_pool_lock);
+		} else
+			break;
+
+		if ((nr <= 0) || (freed >= MAX_PAGES_PER_POOL)) {
+			if (freed >= MAX_PAGES_PER_POOL)
+				TRACE_MEM("%d pages purged from pool %p, "
+					"leaving", freed, pool);
+			break;
+		}
+	}
+
+	spin_unlock_bh(&pool->sgv_pool_lock);
+
+out:
+	return nr;
+}
+
+/* No locks */
+static int __sgv_shrink(int nr, int min_interval)
+{
+	struct sgv_pool *pool;
+	unsigned long cur_time = jiffies;
+	int prev_nr = nr;
+	bool circle = false;
+
+	TRACE_MEM("Trying to shrink %d pages from all sgv pools "
+		"(min_interval %d)", nr, min_interval);
+
+	while (nr > 0) {
+		struct list_head *next;
+
+		spin_lock_bh(&sgv_pools_lock);
+
+		pool = sgv_cur_purge_pool;
+		if (pool == NULL) {
+			if (list_empty(&sgv_active_pools_list)) {
+				TRACE_MEM("%s", "Active pools list is empty");
+				goto out_unlock;
+			}
+
+			pool = list_entry(sgv_active_pools_list.next,
+					typeof(*pool),
+					sgv_active_pools_list_entry);
+		}
+		sgv_pool_get(pool);
+
+		next = pool->sgv_active_pools_list_entry.next;
+		if (next == &sgv_active_pools_list) {
+			if (circle && (prev_nr == nr)) {
+				TRACE_MEM("Full circle done, but no progress, "
+					"leaving (nr %d)", nr);
+				goto out_unlock_put;
+			}
+			circle = true;
+			prev_nr = nr;
+
+			next = next->next;
+		}
+
+		sgv_cur_purge_pool = list_entry(next, typeof(*pool),
+			sgv_active_pools_list_entry);
+		TRACE_MEM("New cur purge pool %p", sgv_cur_purge_pool);
+
+		spin_unlock_bh(&sgv_pools_lock);
+
+		nr = sgv_shrink_pool(pool, nr, min_interval, cur_time);
+
+		sgv_pool_put(pool);
+	}
+
+out:
+	return nr;
+
+out_unlock:
+	spin_unlock_bh(&sgv_pools_lock);
+	goto out;
+
+out_unlock_put:
+	spin_unlock_bh(&sgv_pools_lock);
+	sgv_pool_put(pool);
+	goto out;
+}
+
+static int sgv_shrink(int nr, gfp_t gfpm)
+{
+
+	if (nr > 0) {
+		nr = __sgv_shrink(nr, SGV_MIN_SHRINK_INTERVAL);
+		TRACE_MEM("Left %d", nr);
+	} else {
+		struct sgv_pool *pool;
+		int inactive_pages = 0;
+
+		spin_lock_bh(&sgv_pools_lock);
+		list_for_each_entry(pool, &sgv_active_pools_list,
+				sgv_active_pools_list_entry) {
+			if (pool->purge_interval > 0)
+				inactive_pages += pool->inactive_cached_pages;
+		}
+		spin_unlock_bh(&sgv_pools_lock);
+
+		nr = max((int)0, inactive_pages - sgv_lo_wmk);
+		TRACE_MEM("Can free %d (total %d)", nr,
+			atomic_read(&sgv_pages_total));
+	}
+	return nr;
+}
+
+static void sgv_purge_work_fn(struct delayed_work *work)
+{
+	unsigned long cur_time = jiffies;
+	struct sgv_pool *pool = container_of(work, struct sgv_pool,
+					sgv_purge_work);
+
+	TRACE_MEM("Purge work for pool %p", pool);
+
+	spin_lock_bh(&pool->sgv_pool_lock);
+
+	pool->purge_work_scheduled = false;
+
+	while (!list_empty(&pool->sorted_recycling_list)) {
+		struct sgv_pool_obj *obj = list_entry(
+			pool->sorted_recycling_list.next,
+			struct sgv_pool_obj, sorted_recycling_list_entry);
+
+		if (sgv_purge_from_cache(obj, pool->purge_interval, cur_time)) {
+			spin_unlock_bh(&pool->sgv_pool_lock);
+			sgv_dtor_and_free(obj);
+			spin_lock_bh(&pool->sgv_pool_lock);
+		} else {
+			/*
+			 * Let's reschedule it for full period to not get here
+			 * too often. In the worst case we have shrinker
+			 * to reclaim buffers quickier.
+			 */
+			TRACE_MEM("Rescheduling purge work for pool %p (delay "
+				"%d HZ/%d sec)", pool, pool->purge_interval,
+				pool->purge_interval/HZ);
+			schedule_delayed_work(&pool->sgv_purge_work,
+				pool->purge_interval);
+			pool->purge_work_scheduled = true;
+			break;
+		}
+	}
+
+	spin_unlock_bh(&pool->sgv_pool_lock);
+
+	TRACE_MEM("Leaving purge work for pool %p", pool);
+	return;
+}
+
+static int sgv_check_full_clustering(struct scatterlist *sg, int cur, int hint)
+{
+	int res = -1;
+	int i = hint;
+	unsigned long pfn_cur = page_to_pfn(sg_page(&sg[cur]));
+	int len_cur = sg[cur].length;
+	unsigned long pfn_cur_next = pfn_cur + (len_cur >> PAGE_SHIFT);
+	int full_page_cur = (len_cur & (PAGE_SIZE - 1)) == 0;
+	unsigned long pfn, pfn_next;
+	bool full_page;
+
+#if 0
+	TRACE_MEM("pfn_cur %ld, pfn_cur_next %ld, len_cur %d, full_page_cur %d",
+		pfn_cur, pfn_cur_next, len_cur, full_page_cur);
+#endif
+
+	/* check the hint first */
+	if (i >= 0) {
+		pfn = page_to_pfn(sg_page(&sg[i]));
+		pfn_next = pfn + (sg[i].length >> PAGE_SHIFT);
+		full_page = (sg[i].length & (PAGE_SIZE - 1)) == 0;
+
+		if ((pfn == pfn_cur_next) && full_page_cur)
+			goto out_head;
+
+		if ((pfn_next == pfn_cur) && full_page)
+			goto out_tail;
+	}
+
+	/* ToDo: implement more intelligent search */
+	for (i = cur - 1; i >= 0; i--) {
+		pfn = page_to_pfn(sg_page(&sg[i]));
+		pfn_next = pfn + (sg[i].length >> PAGE_SHIFT);
+		full_page = (sg[i].length & (PAGE_SIZE - 1)) == 0;
+
+		if ((pfn == pfn_cur_next) && full_page_cur)
+			goto out_head;
+
+		if ((pfn_next == pfn_cur) && full_page)
+			goto out_tail;
+	}
+
+out:
+	return res;
+
+out_tail:
+	TRACE_MEM("SG segment %d will be tail merged with segment %d", cur, i);
+	sg[i].length += len_cur;
+	sg_clear(&sg[cur]);
+	res = i;
+	goto out;
+
+out_head:
+	TRACE_MEM("SG segment %d will be head merged with segment %d", cur, i);
+	sg_assign_page(&sg[i], sg_page(&sg[cur]));
+	sg[i].length += len_cur;
+	sg_clear(&sg[cur]);
+	res = i;
+	goto out;
+}
+
+static int sgv_check_tail_clustering(struct scatterlist *sg, int cur, int hint)
+{
+	int res = -1;
+	unsigned long pfn_cur = page_to_pfn(sg_page(&sg[cur]));
+	int len_cur = sg[cur].length;
+	int prev;
+	unsigned long pfn_prev;
+	bool full_page;
+
+#ifdef SCST_HIGHMEM
+	if (page >= highmem_start_page) {
+		TRACE_MEM("%s", "HIGHMEM page allocated, no clustering")
+		goto out;
+	}
+#endif
+
+#if 0
+	TRACE_MEM("pfn_cur %ld, pfn_cur_next %ld, len_cur %d, full_page_cur %d",
+		pfn_cur, pfn_cur_next, len_cur, full_page_cur);
+#endif
+
+	if (cur == 0)
+		goto out;
+
+	prev = cur - 1;
+	pfn_prev = page_to_pfn(sg_page(&sg[prev])) +
+			(sg[prev].length >> PAGE_SHIFT);
+	full_page = (sg[prev].length & (PAGE_SIZE - 1)) == 0;
+
+	if ((pfn_prev == pfn_cur) && full_page) {
+		TRACE_MEM("SG segment %d will be tail merged with segment %d",
+			cur, prev);
+		sg[prev].length += len_cur;
+		sg_clear(&sg[cur]);
+		res = prev;
+	}
+
+out:
+	return res;
+}
+
+static void sgv_free_sys_sg_entries(struct scatterlist *sg, int sg_count,
+	void *priv)
+{
+	int i;
+
+	TRACE_MEM("sg=%p, sg_count=%d", sg, sg_count);
+
+	for (i = 0; i < sg_count; i++) {
+		struct page *p = sg_page(&sg[i]);
+		int len = sg[i].length;
+		int pages =
+			(len >> PAGE_SHIFT) + ((len & ~PAGE_MASK) != 0);
+
+		TRACE_MEM("page %lx, len %d, pages %d",
+			(unsigned long)p, len, pages);
+
+		while (pages > 0) {
+			int order = 0;
+
+/*
+ * __free_pages() doesn't like freeing pages with not that order with
+ * which they were allocated, so disable this small optimization.
+ */
+#if 0
+			if (len > 0) {
+				while (((1 << order) << PAGE_SHIFT) < len)
+					order++;
+				len = 0;
+			}
+#endif
+			TRACE_MEM("free_pages(): order %d, page %lx",
+				order, (unsigned long)p);
+
+			__free_pages(p, order);
+
+			pages -= 1 << order;
+			p += 1 << order;
+		}
+	}
+}
+
+static struct page *sgv_alloc_sys_pages(struct scatterlist *sg,
+	gfp_t gfp_mask, void *priv)
+{
+	struct page *page = alloc_pages(gfp_mask, 0);
+
+	sg_set_page(sg, page, PAGE_SIZE, 0);
+	TRACE_MEM("page=%p, sg=%p, priv=%p", page, sg, priv);
+	if (page == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Allocation of "
+			"sg page failed");
+	}
+	return page;
+}
+
+static int sgv_alloc_sg_entries(struct scatterlist *sg, int pages,
+	gfp_t gfp_mask, enum sgv_clustering_types clustering_type,
+	struct trans_tbl_ent *trans_tbl,
+	const struct sgv_pool_alloc_fns *alloc_fns, void *priv)
+{
+	int sg_count = 0;
+	int pg, i, j;
+	int merged = -1;
+
+	TRACE_MEM("pages=%d, clustering_type=%d", pages, clustering_type);
+
+#if 0
+	gfp_mask |= __GFP_COLD;
+#endif
+#ifdef CONFIG_SCST_STRICT_SECURITY
+	gfp_mask |= __GFP_ZERO;
+#endif
+
+	for (pg = 0; pg < pages; pg++) {
+		void *rc;
+#ifdef CONFIG_SCST_DEBUG_OOM
+		if (((gfp_mask & __GFP_NOFAIL) != __GFP_NOFAIL) &&
+		    ((scst_random() % 10000) == 55))
+			rc = NULL;
+		else
+#endif
+			rc = alloc_fns->alloc_pages_fn(&sg[sg_count], gfp_mask,
+				priv);
+		if (rc == NULL)
+			goto out_no_mem;
+
+		/*
+		 * This code allows compiler to see full body of the clustering
+		 * functions and gives it a chance to generate better code.
+		 * At least, the resulting code is smaller, comparing to
+		 * calling them using a function pointer.
+		 */
+		if (clustering_type == sgv_full_clustering)
+			merged = sgv_check_full_clustering(sg, sg_count, merged);
+		else if (clustering_type == sgv_tail_clustering)
+			merged = sgv_check_tail_clustering(sg, sg_count, merged);
+		else
+			merged = -1;
+
+		if (merged == -1)
+			sg_count++;
+
+		TRACE_MEM("pg=%d, merged=%d, sg_count=%d", pg, merged,
+			sg_count);
+	}
+
+	if ((clustering_type != sgv_no_clustering) && (trans_tbl != NULL)) {
+		pg = 0;
+		for (i = 0; i < pages; i++) {
+			int n = (sg[i].length >> PAGE_SHIFT) +
+				((sg[i].length & ~PAGE_MASK) != 0);
+			trans_tbl[i].pg_count = pg;
+			for (j = 0; j < n; j++)
+				trans_tbl[pg++].sg_num = i+1;
+			TRACE_MEM("i=%d, n=%d, pg_count=%d", i, n,
+				trans_tbl[i].pg_count);
+		}
+	}
+
+out:
+	TRACE_MEM("sg_count=%d", sg_count);
+	return sg_count;
+
+out_no_mem:
+	alloc_fns->free_pages_fn(sg, sg_count, priv);
+	sg_count = 0;
+	goto out;
+}
+
+static int sgv_alloc_arrays(struct sgv_pool_obj *obj,
+	int pages_to_alloc, gfp_t gfp_mask)
+{
+	int sz, tsz = 0;
+	int res = 0;
+
+	sz = pages_to_alloc * sizeof(obj->sg_entries[0]);
+
+	obj->sg_entries = kmalloc(sz, gfp_mask);
+	if (unlikely(obj->sg_entries == NULL)) {
+		TRACE(TRACE_OUT_OF_MEM, "Allocation of sgv_pool_obj "
+			"SG vector failed (size %d)", sz);
+		res = -ENOMEM;
+		goto out;
+	}
+
+	sg_init_table(obj->sg_entries, pages_to_alloc);
+
+	if (sgv_pool_clustered(obj->owner_pool)) {
+		if (pages_to_alloc <= sgv_max_trans_pages) {
+			obj->trans_tbl =
+				(struct trans_tbl_ent *)obj->sg_entries_data;
+			/*
+			 * No need to clear trans_tbl, if needed, it will be
+			 * fully rewritten in sgv_alloc_sg_entries()
+			 */
+		} else {
+			tsz = pages_to_alloc * sizeof(obj->trans_tbl[0]);
+			obj->trans_tbl = kzalloc(tsz, gfp_mask);
+			if (unlikely(obj->trans_tbl == NULL)) {
+				TRACE(TRACE_OUT_OF_MEM, "Allocation of "
+					"trans_tbl failed (size %d)", tsz);
+				res = -ENOMEM;
+				goto out_free;
+			}
+		}
+	}
+
+	TRACE_MEM("pages_to_alloc %d, sz %d, tsz %d, obj %p, sg_entries %p, "
+		"trans_tbl %p", pages_to_alloc, sz, tsz, obj, obj->sg_entries,
+		obj->trans_tbl);
+
+out:
+	return res;
+
+out_free:
+	kfree(obj->sg_entries);
+	obj->sg_entries = NULL;
+	goto out;
+}
+
+static struct sgv_pool_obj *sgv_get_obj(struct sgv_pool *pool, int cache_num,
+	int pages, gfp_t gfp_mask, bool get_new)
+{
+	struct sgv_pool_obj *obj;
+
+	spin_lock_bh(&pool->sgv_pool_lock);
+
+	if (unlikely(get_new)) {
+		/* Used only for buffers preallocation */
+		goto get_new;
+	}
+
+	if (likely(!list_empty(&pool->recycling_lists[cache_num]))) {
+		obj = list_entry(pool->recycling_lists[cache_num].next,
+			 struct sgv_pool_obj, recycling_list_entry);
+
+		list_del(&obj->sorted_recycling_list_entry);
+		list_del(&obj->recycling_list_entry);
+
+		pool->inactive_cached_pages -= pages;
+
+		spin_unlock_bh(&pool->sgv_pool_lock);
+		goto out;
+	}
+
+get_new:
+	if (pool->cached_entries == 0) {
+		TRACE_MEM("Adding pool %p to the active list", pool);
+		spin_lock_bh(&sgv_pools_lock);
+		list_add_tail(&pool->sgv_active_pools_list_entry,
+			&sgv_active_pools_list);
+		spin_unlock_bh(&sgv_pools_lock);
+	}
+
+	pool->cached_entries++;
+	pool->cached_pages += pages;
+
+	spin_unlock_bh(&pool->sgv_pool_lock);
+
+	TRACE_MEM("New cached entries %d (pool %p)", pool->cached_entries,
+		pool);
+
+	obj = kmem_cache_alloc(pool->caches[cache_num],
+		gfp_mask & ~(__GFP_HIGHMEM|GFP_DMA));
+	if (likely(obj)) {
+		memset(obj, 0, sizeof(*obj));
+		obj->cache_num = cache_num;
+		obj->pages = pages;
+		obj->owner_pool = pool;
+	} else {
+		spin_lock_bh(&pool->sgv_pool_lock);
+		sgv_dec_cached_entries(pool, pages);
+		spin_unlock_bh(&pool->sgv_pool_lock);
+	}
+
+out:
+	return obj;
+}
+
+static void sgv_put_obj(struct sgv_pool_obj *obj)
+{
+	struct sgv_pool *pool = obj->owner_pool;
+	struct list_head *entry;
+	struct list_head *list = &pool->recycling_lists[obj->cache_num];
+	int pages = obj->pages;
+
+	spin_lock_bh(&pool->sgv_pool_lock);
+
+	TRACE_MEM("sgv %p, cache num %d, pages %d, sg_count %d", obj,
+		obj->cache_num, pages, obj->sg_count);
+
+	if (sgv_pool_clustered(pool)) {
+		/* Make objects with less entries more preferred */
+		__list_for_each(entry, list) {
+			struct sgv_pool_obj *tmp = list_entry(entry,
+				struct sgv_pool_obj, recycling_list_entry);
+
+			TRACE_MEM("tmp %p, cache num %d, pages %d, sg_count %d",
+				tmp, tmp->cache_num, tmp->pages, tmp->sg_count);
+
+			if (obj->sg_count <= tmp->sg_count)
+				break;
+		}
+		entry = entry->prev;
+	} else
+		entry = list;
+
+	TRACE_MEM("Adding in %p (list %p)", entry, list);
+	list_add(&obj->recycling_list_entry, entry);
+
+	list_add_tail(&obj->sorted_recycling_list_entry,
+		&pool->sorted_recycling_list);
+
+	obj->time_stamp = jiffies;
+
+	pool->inactive_cached_pages += pages;
+
+	if (!pool->purge_work_scheduled) {
+		TRACE_MEM("Scheduling purge work for pool %p", pool);
+		pool->purge_work_scheduled = true;
+		schedule_delayed_work(&pool->sgv_purge_work,
+			pool->purge_interval);
+	}
+
+	spin_unlock_bh(&pool->sgv_pool_lock);
+	return;
+}
+
+/* No locks */
+static int sgv_hiwmk_check(int pages_to_alloc)
+{
+	int res = 0;
+	int pages = pages_to_alloc;
+
+	pages += atomic_read(&sgv_pages_total);
+
+	if (unlikely(pages > sgv_hi_wmk)) {
+		pages -= sgv_hi_wmk;
+		atomic_inc(&sgv_releases_on_hiwmk);
+
+		pages = __sgv_shrink(pages, 0);
+		if (pages > 0) {
+			TRACE(TRACE_OUT_OF_MEM, "Requested amount of "
+			    "memory (%d pages) for being executed "
+			    "commands together with the already "
+			    "allocated memory exceeds the allowed "
+			    "maximum %d. Should you increase "
+			    "scst_max_cmd_mem?", pages_to_alloc,
+			   sgv_hi_wmk);
+			atomic_inc(&sgv_releases_on_hiwmk_failed);
+			res = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+
+	atomic_add(pages_to_alloc, &sgv_pages_total);
+
+out_unlock:
+	TRACE_MEM("pages_to_alloc %d, new total %d", pages_to_alloc,
+		atomic_read(&sgv_pages_total));
+
+	return res;
+}
+
+/* No locks */
+static void sgv_hiwmk_uncheck(int pages)
+{
+	atomic_sub(pages, &sgv_pages_total);
+	TRACE_MEM("pages %d, new total %d", pages,
+		atomic_read(&sgv_pages_total));
+	return;
+}
+
+/* No locks */
+static bool sgv_check_allowed_mem(struct scst_mem_lim *mem_lim, int pages)
+{
+	int alloced;
+	bool res = true;
+
+	alloced = atomic_add_return(pages, &mem_lim->alloced_pages);
+	if (unlikely(alloced > mem_lim->max_allowed_pages)) {
+		TRACE(TRACE_OUT_OF_MEM, "Requested amount of memory "
+			"(%d pages) for being executed commands on a device "
+			"together with the already allocated memory exceeds "
+			"the allowed maximum %d. Should you increase "
+			"scst_max_dev_cmd_mem?", pages,
+			mem_lim->max_allowed_pages);
+		atomic_sub(pages, &mem_lim->alloced_pages);
+		res = false;
+	}
+
+	TRACE_MEM("mem_lim %p, pages %d, res %d, new alloced %d", mem_lim,
+		pages, res, atomic_read(&mem_lim->alloced_pages));
+
+	return res;
+}
+
+/* No locks */
+static void sgv_uncheck_allowed_mem(struct scst_mem_lim *mem_lim, int pages)
+{
+	atomic_sub(pages, &mem_lim->alloced_pages);
+
+	TRACE_MEM("mem_lim %p, pages %d, new alloced %d", mem_lim,
+		pages, atomic_read(&mem_lim->alloced_pages));
+	return;
+}
+
+/**
+ * sgv_pool_alloc - allocate an SG vector from the SGV pool
+ * @pool:	the cache to alloc from
+ * @size:	size of the resulting SG vector in bytes
+ * @gfp_mask:	the allocation mask
+ * @flags:	the allocation flags
+ * @count:	the resulting count of SG entries in the resulting SG vector
+ * @sgv:	the resulting SGV object
+ * @mem_lim:	memory limits
+ * @priv:	pointer to private for this allocation data
+ *
+ * Description:
+ *    Allocate an SG vector from the SGV pool and returns pointer to it or
+ *    NULL in case of any error. See the SGV pool documentation for more details.
+ */
+struct scatterlist *sgv_pool_alloc(struct sgv_pool *pool, unsigned int size,
+	gfp_t gfp_mask, int flags, int *count,
+	struct sgv_pool_obj **sgv, struct scst_mem_lim *mem_lim, void *priv)
+{
+	struct sgv_pool_obj *obj;
+	int cache_num, pages, cnt;
+	struct scatterlist *res = NULL;
+	int pages_to_alloc;
+	int no_cached = flags & SGV_POOL_ALLOC_NO_CACHED;
+	bool allowed_mem_checked = false, hiwmk_checked = false;
+
+	if (unlikely(size == 0))
+		goto out;
+
+	EXTRACHECKS_BUG_ON((gfp_mask & __GFP_NOFAIL) == __GFP_NOFAIL);
+
+	pages = ((size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	if (pool->single_alloc_pages == 0) {
+		int pages_order = get_order(size);
+		cache_num = pages_order;
+		pages_to_alloc = (1 << pages_order);
+	} else {
+		cache_num = 0;
+		pages_to_alloc = max(pool->single_alloc_pages, pages);
+	}
+
+	TRACE_MEM("size=%d, pages=%d, pages_to_alloc=%d, cache num=%d, "
+		"flags=%x, no_cached=%d, *sgv=%p", size, pages,
+		pages_to_alloc, cache_num, flags, no_cached, *sgv);
+
+	if (*sgv != NULL) {
+		obj = *sgv;
+
+		TRACE_MEM("Supplied obj %p, cache num %d", obj, obj->cache_num);
+
+		EXTRACHECKS_BUG_ON(obj->sg_count != 0);
+
+		if (unlikely(!sgv_check_allowed_mem(mem_lim, pages_to_alloc)))
+			goto out_fail_free_sg_entries;
+		allowed_mem_checked = true;
+
+		if (unlikely(sgv_hiwmk_check(pages_to_alloc) != 0))
+			goto out_fail_free_sg_entries;
+		hiwmk_checked = true;
+	} else if ((pages_to_alloc <= pool->max_cached_pages) && !no_cached) {
+		if (unlikely(!sgv_check_allowed_mem(mem_lim, pages_to_alloc)))
+			goto out_fail;
+		allowed_mem_checked = true;
+
+		obj = sgv_get_obj(pool, cache_num, pages_to_alloc, gfp_mask,
+			flags & SGV_POOL_ALLOC_GET_NEW);
+		if (unlikely(obj == NULL)) {
+			TRACE(TRACE_OUT_OF_MEM, "Allocation of "
+				"sgv_pool_obj failed (size %d)", size);
+			goto out_fail;
+		}
+
+		if (obj->sg_count != 0) {
+			TRACE_MEM("Cached obj %p", obj);
+			atomic_inc(&pool->cache_acc[cache_num].hit_alloc);
+			goto success;
+		}
+
+		if (flags & SGV_POOL_NO_ALLOC_ON_CACHE_MISS) {
+			if (!(flags & SGV_POOL_RETURN_OBJ_ON_ALLOC_FAIL))
+				goto out_fail_free;
+		}
+
+		TRACE_MEM("Brand new obj %p", obj);
+
+		if (pages_to_alloc <= sgv_max_local_pages) {
+			obj->sg_entries = obj->sg_entries_data;
+			sg_init_table(obj->sg_entries, pages_to_alloc);
+			TRACE_MEM("sg_entries %p", obj->sg_entries);
+			if (sgv_pool_clustered(pool)) {
+				obj->trans_tbl = (struct trans_tbl_ent *)
+					(obj->sg_entries + pages_to_alloc);
+				TRACE_MEM("trans_tbl %p", obj->trans_tbl);
+				/*
+				 * No need to clear trans_tbl, if needed, it
+				 * will be fully rewritten in
+				 * sgv_alloc_sg_entries().
+				 */
+			}
+		} else {
+			if (unlikely(sgv_alloc_arrays(obj, pages_to_alloc,
+					gfp_mask) != 0))
+				goto out_fail_free;
+		}
+
+		if ((flags & SGV_POOL_NO_ALLOC_ON_CACHE_MISS) &&
+		    (flags & SGV_POOL_RETURN_OBJ_ON_ALLOC_FAIL))
+			goto out_return;
+
+		obj->allocator_priv = priv;
+
+		if (unlikely(sgv_hiwmk_check(pages_to_alloc) != 0))
+			goto out_fail_free_sg_entries;
+		hiwmk_checked = true;
+	} else {
+		int sz;
+
+		pages_to_alloc = pages;
+
+		if (unlikely(!sgv_check_allowed_mem(mem_lim, pages_to_alloc)))
+			goto out_fail;
+		allowed_mem_checked = true;
+
+		if (flags & SGV_POOL_NO_ALLOC_ON_CACHE_MISS)
+			goto out_return2;
+
+		sz = sizeof(*obj) + pages * sizeof(obj->sg_entries[0]);
+
+		obj = kmalloc(sz, gfp_mask);
+		if (unlikely(obj == NULL)) {
+			TRACE(TRACE_OUT_OF_MEM, "Allocation of "
+				"sgv_pool_obj failed (size %d)", size);
+			goto out_fail;
+		}
+		memset(obj, 0, sizeof(*obj));
+
+		obj->owner_pool = pool;
+		cache_num = -1;
+		obj->cache_num = cache_num;
+		obj->pages = pages_to_alloc;
+		obj->allocator_priv = priv;
+
+		obj->sg_entries = obj->sg_entries_data;
+		sg_init_table(obj->sg_entries, pages);
+
+		if (unlikely(sgv_hiwmk_check(pages_to_alloc) != 0))
+			goto out_fail_free_sg_entries;
+		hiwmk_checked = true;
+
+		TRACE_MEM("Big or no_cached obj %p (size %d)", obj, sz);
+	}
+
+	obj->sg_count = sgv_alloc_sg_entries(obj->sg_entries,
+		pages_to_alloc, gfp_mask, pool->clustering_type,
+		obj->trans_tbl, &pool->alloc_fns, priv);
+	if (unlikely(obj->sg_count <= 0)) {
+		obj->sg_count = 0;
+		if ((flags & SGV_POOL_RETURN_OBJ_ON_ALLOC_FAIL) &&
+		    (cache_num >= 0))
+			goto out_return1;
+		else
+			goto out_fail_free_sg_entries;
+	}
+
+	if (cache_num >= 0) {
+		atomic_add(pages_to_alloc - obj->sg_count,
+			&pool->cache_acc[cache_num].merged);
+	} else {
+		if (no_cached) {
+			atomic_add(pages_to_alloc,
+				&pool->other_pages);
+			atomic_add(pages_to_alloc - obj->sg_count,
+				&pool->other_merged);
+		} else {
+			atomic_add(pages_to_alloc,
+				&pool->big_pages);
+			atomic_add(pages_to_alloc - obj->sg_count,
+				&pool->big_merged);
+		}
+	}
+
+success:
+	if (cache_num >= 0) {
+		int sg;
+		atomic_inc(&pool->cache_acc[cache_num].total_alloc);
+		if (sgv_pool_clustered(pool))
+			cnt = obj->trans_tbl[pages-1].sg_num;
+		else
+			cnt = pages;
+		sg = cnt-1;
+		obj->orig_sg = sg;
+		obj->orig_length = obj->sg_entries[sg].length;
+		if (sgv_pool_clustered(pool)) {
+			obj->sg_entries[sg].length =
+				(pages - obj->trans_tbl[sg].pg_count) << PAGE_SHIFT;
+		}
+	} else {
+		cnt = obj->sg_count;
+		if (no_cached)
+			atomic_inc(&pool->other_alloc);
+		else
+			atomic_inc(&pool->big_alloc);
+	}
+
+	*count = cnt;
+	res = obj->sg_entries;
+	*sgv = obj;
+
+	if (size & ~PAGE_MASK)
+		obj->sg_entries[cnt-1].length -=
+			PAGE_SIZE - (size & ~PAGE_MASK);
+
+	TRACE_MEM("obj=%p, sg_entries %p (size=%d, pages=%d, sg_count=%d, "
+		"count=%d, last_len=%d)", obj, obj->sg_entries, size, pages,
+		obj->sg_count, *count, obj->sg_entries[obj->orig_sg].length);
+
+out:
+	return res;
+
+out_return:
+	obj->allocator_priv = priv;
+	obj->owner_pool = pool;
+
+out_return1:
+	*sgv = obj;
+	TRACE_MEM("Returning failed obj %p (count %d)", obj, *count);
+
+out_return2:
+	*count = pages_to_alloc;
+	res = NULL;
+	goto out_uncheck;
+
+out_fail_free_sg_entries:
+	if (obj->sg_entries != obj->sg_entries_data) {
+		if (obj->trans_tbl !=
+			(struct trans_tbl_ent *)obj->sg_entries_data) {
+			/* kfree() handles NULL parameter */
+			kfree(obj->trans_tbl);
+			obj->trans_tbl = NULL;
+		}
+		kfree(obj->sg_entries);
+		obj->sg_entries = NULL;
+	}
+
+out_fail_free:
+	if (cache_num >= 0) {
+		spin_lock_bh(&pool->sgv_pool_lock);
+		sgv_dec_cached_entries(pool, pages_to_alloc);
+		spin_unlock_bh(&pool->sgv_pool_lock);
+
+		kmem_cache_free(pool->caches[obj->cache_num], obj);
+	} else
+		kfree(obj);
+
+out_fail:
+	res = NULL;
+	*count = 0;
+	*sgv = NULL;
+	TRACE_MEM("%s", "Allocation failed");
+
+out_uncheck:
+	if (hiwmk_checked)
+		sgv_hiwmk_uncheck(pages_to_alloc);
+	if (allowed_mem_checked)
+		sgv_uncheck_allowed_mem(mem_lim, pages_to_alloc);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_alloc);
+
+/**
+ * sgv_get_priv - return the private allocation data
+ *
+ * Allows to get the allocation private data for this SGV
+ * cache object. The private data supposed to be set by sgv_pool_alloc().
+ */
+void *sgv_get_priv(struct sgv_pool_obj *obj)
+{
+	return obj->allocator_priv;
+}
+EXPORT_SYMBOL_GPL(sgv_get_priv);
+
+/**
+ * sgv_pool_free - free previously allocated SG vector
+ * @sgv:	the SGV object to free
+ * @mem_lim:	memory limits
+ *
+ * Description:
+ *    Frees previously allocated SG vector and updates memory limits
+ */
+void sgv_pool_free(struct sgv_pool_obj *obj, struct scst_mem_lim *mem_lim)
+{
+	int pages = (obj->sg_count != 0) ? obj->pages : 0;
+
+	TRACE_MEM("Freeing obj %p, cache num %d, pages %d, sg_entries %p, "
+		"sg_count %d, allocator_priv %p", obj, obj->cache_num, pages,
+		obj->sg_entries, obj->sg_count, obj->allocator_priv);
+	if (obj->cache_num >= 0) {
+		obj->sg_entries[obj->orig_sg].length = obj->orig_length;
+		sgv_put_obj(obj);
+	} else {
+		obj->owner_pool->alloc_fns.free_pages_fn(obj->sg_entries,
+			obj->sg_count, obj->allocator_priv);
+		kfree(obj);
+		sgv_hiwmk_uncheck(pages);
+	}
+
+	sgv_uncheck_allowed_mem(mem_lim, pages);
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_free);
+
+/**
+ * scst_alloc() - allocates an SG vector
+ *
+ * Allocates and returns pointer to SG vector with data size "size".
+ * In *count returned the count of entries in the vector.
+ * Returns NULL for failure.
+ */
+struct scatterlist *scst_alloc(int size, gfp_t gfp_mask, int *count)
+{
+	struct scatterlist *res;
+	int pages = (size >> PAGE_SHIFT) + ((size & ~PAGE_MASK) != 0);
+	struct sgv_pool_alloc_fns sys_alloc_fns = {
+		sgv_alloc_sys_pages, sgv_free_sys_sg_entries };
+	int no_fail = ((gfp_mask & __GFP_NOFAIL) == __GFP_NOFAIL);
+
+	atomic_inc(&sgv_other_total_alloc);
+
+	if (unlikely(sgv_hiwmk_check(pages) != 0)) {
+		if (!no_fail) {
+			res = NULL;
+			goto out;
+		} else {
+			/*
+			 * Update active_pages_total since alloc can't fail.
+			 * If it wasn't updated then the counter would cross 0
+			 * on free again.
+			 */
+			sgv_hiwmk_uncheck(-pages);
+		 }
+	}
+
+	res = kmalloc(pages*sizeof(*res), gfp_mask);
+	if (res == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "Unable to allocate sg for %d pages",
+			pages);
+		goto out_uncheck;
+	}
+
+	sg_init_table(res, pages);
+
+	/*
+	 * If we allow use clustering here, we will have troubles in
+	 * scst_free() to figure out how many pages are in the SG vector.
+	 * So, always don't use clustering.
+	 */
+	*count = sgv_alloc_sg_entries(res, pages, gfp_mask, sgv_no_clustering,
+			NULL, &sys_alloc_fns, NULL);
+	if (*count <= 0)
+		goto out_free;
+
+out:
+	TRACE_MEM("Alloced sg %p (count %d) \"no fail\" %d", res, *count, no_fail);
+	return res;
+
+out_free:
+	kfree(res);
+	res = NULL;
+
+out_uncheck:
+	if (!no_fail)
+		sgv_hiwmk_uncheck(pages);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(scst_alloc);
+
+/**
+ * scst_free() - frees SG vector
+ *
+ * Frees SG vector returned by scst_alloc().
+ */
+void scst_free(struct scatterlist *sg, int count)
+{
+	TRACE_MEM("Freeing sg=%p", sg);
+
+	sgv_hiwmk_uncheck(count);
+
+	sgv_free_sys_sg_entries(sg, count, NULL);
+	kfree(sg);
+	return;
+}
+EXPORT_SYMBOL_GPL(scst_free);
+
+/* Must be called under sgv_pools_mutex */
+static void sgv_pool_init_cache(struct sgv_pool *pool, int cache_num)
+{
+	int size;
+	int pages;
+	struct sgv_pool_obj *obj;
+
+	atomic_set(&pool->cache_acc[cache_num].total_alloc, 0);
+	atomic_set(&pool->cache_acc[cache_num].hit_alloc, 0);
+	atomic_set(&pool->cache_acc[cache_num].merged, 0);
+
+	if (pool->single_alloc_pages == 0)
+		pages = 1 << cache_num;
+	else
+		pages = pool->single_alloc_pages;
+
+	if (pages <= sgv_max_local_pages) {
+		size = sizeof(*obj) + pages *
+			(sizeof(obj->sg_entries[0]) +
+			 ((pool->clustering_type != sgv_no_clustering) ?
+				sizeof(obj->trans_tbl[0]) : 0));
+	} else if (pages <= sgv_max_trans_pages) {
+		/*
+		 * sg_entries is allocated outside object,
+		 * but trans_tbl is still embedded.
+		 */
+		size = sizeof(*obj) + pages *
+			(((pool->clustering_type != sgv_no_clustering) ?
+				sizeof(obj->trans_tbl[0]) : 0));
+	} else {
+		size = sizeof(*obj);
+		/* both sgv and trans_tbl are kmalloc'ed() */
+	}
+
+	TRACE_MEM("pages=%d, size=%d", pages, size);
+
+	scnprintf(pool->cache_names[cache_num],
+		sizeof(pool->cache_names[cache_num]),
+		"%s-%uK", pool->name, (pages << PAGE_SHIFT) >> 10);
+	pool->caches[cache_num] = kmem_cache_create(
+		pool->cache_names[cache_num], size, 0, SCST_SLAB_FLAGS, NULL
+		);
+	return;
+}
+
+/* Must be called under sgv_pools_mutex */
+static int sgv_pool_init(struct sgv_pool *pool, const char *name,
+	enum sgv_clustering_types clustering_type, int single_alloc_pages,
+	int purge_interval)
+{
+	int res = -ENOMEM;
+	int i;
+
+	if (single_alloc_pages < 0) {
+		PRINT_ERROR("Wrong single_alloc_pages value %d",
+			single_alloc_pages);
+		res = -EINVAL;
+		goto out;
+	}
+
+	memset(pool, 0, sizeof(*pool));
+
+	atomic_set(&pool->big_alloc, 0);
+	atomic_set(&pool->big_pages, 0);
+	atomic_set(&pool->big_merged, 0);
+	atomic_set(&pool->other_alloc, 0);
+	atomic_set(&pool->other_pages, 0);
+	atomic_set(&pool->other_merged, 0);
+
+	pool->clustering_type = clustering_type;
+	pool->single_alloc_pages = single_alloc_pages;
+	if (purge_interval != 0) {
+		pool->purge_interval = purge_interval;
+		if (purge_interval < 0) {
+			/* Let's pretend that it's always scheduled */
+			pool->purge_work_scheduled = 1;
+		}
+	} else
+		pool->purge_interval = SGV_DEFAULT_PURGE_INTERVAL;
+	if (single_alloc_pages == 0) {
+		pool->max_caches = SGV_POOL_ELEMENTS;
+		pool->max_cached_pages = 1 << (SGV_POOL_ELEMENTS - 1);
+	} else {
+		pool->max_caches = 1;
+		pool->max_cached_pages = single_alloc_pages;
+	}
+	pool->alloc_fns.alloc_pages_fn = sgv_alloc_sys_pages;
+	pool->alloc_fns.free_pages_fn = sgv_free_sys_sg_entries;
+
+	TRACE_MEM("name %s, sizeof(*obj)=%zd, clustering_type=%d, "
+		"single_alloc_pages=%d, max_caches=%d, max_cached_pages=%d",
+		name, sizeof(struct sgv_pool_obj), clustering_type,
+		single_alloc_pages, pool->max_caches, pool->max_cached_pages);
+
+	strlcpy(pool->name, name, sizeof(pool->name)-1);
+
+	pool->owner_mm = current->mm;
+
+	for (i = 0; i < pool->max_caches; i++) {
+		sgv_pool_init_cache(pool, i);
+		if (pool->caches[i] == NULL) {
+			TRACE(TRACE_OUT_OF_MEM, "Allocation of sgv_pool "
+				"cache %s(%d) failed", name, i);
+			goto out_free;
+		}
+	}
+
+	atomic_set(&pool->sgv_pool_ref, 1);
+	spin_lock_init(&pool->sgv_pool_lock);
+	INIT_LIST_HEAD(&pool->sorted_recycling_list);
+	for (i = 0; i < pool->max_caches; i++)
+		INIT_LIST_HEAD(&pool->recycling_lists[i]);
+
+	INIT_DELAYED_WORK(&pool->sgv_purge_work,
+		(void (*)(struct work_struct *))sgv_purge_work_fn);
+
+	spin_lock_bh(&sgv_pools_lock);
+	list_add_tail(&pool->sgv_pools_list_entry, &sgv_pools_list);
+	spin_unlock_bh(&sgv_pools_lock);
+
+	res = 0;
+
+out:
+	return res;
+
+out_free:
+	for (i = 0; i < pool->max_caches; i++) {
+		if (pool->caches[i]) {
+			kmem_cache_destroy(pool->caches[i]);
+			pool->caches[i] = NULL;
+		} else
+			break;
+	}
+	goto out;
+}
+
+static void sgv_evaluate_local_max_pages(void)
+{
+	int space4sgv_ttbl = PAGE_SIZE - sizeof(struct sgv_pool_obj);
+
+	sgv_max_local_pages = space4sgv_ttbl /
+		  (sizeof(struct trans_tbl_ent) + sizeof(struct scatterlist));
+
+	sgv_max_trans_pages =  space4sgv_ttbl / sizeof(struct trans_tbl_ent);
+
+	TRACE_MEM("sgv_max_local_pages %d, sgv_max_trans_pages %d",
+		sgv_max_local_pages, sgv_max_trans_pages);
+	return;
+}
+
+/**
+ * sgv_pool_flush - flushe the SGV pool
+ *
+ * Flushes, i.e. frees, all the cached entries in the SGV pool.
+ */
+void sgv_pool_flush(struct sgv_pool *pool)
+{
+	int i;
+
+	for (i = 0; i < pool->max_caches; i++) {
+		struct sgv_pool_obj *obj;
+
+		spin_lock_bh(&pool->sgv_pool_lock);
+
+		while (!list_empty(&pool->recycling_lists[i])) {
+			obj = list_entry(pool->recycling_lists[i].next,
+				struct sgv_pool_obj, recycling_list_entry);
+
+			__sgv_purge_from_cache(obj);
+
+			spin_unlock_bh(&pool->sgv_pool_lock);
+
+			EXTRACHECKS_BUG_ON(obj->owner_pool != pool);
+			sgv_dtor_and_free(obj);
+
+			spin_lock_bh(&pool->sgv_pool_lock);
+		}
+		spin_unlock_bh(&pool->sgv_pool_lock);
+	}
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_flush);
+
+static void sgv_pool_deinit_put(struct sgv_pool *pool)
+{
+
+	cancel_delayed_work_sync(&pool->sgv_purge_work);
+
+	sgv_pool_flush(pool);
+
+	mutex_lock(&sgv_pools_mutex);
+	spin_lock_bh(&sgv_pools_lock);
+	list_del(&pool->sgv_pools_list_entry);
+	spin_unlock_bh(&sgv_pools_lock);
+	mutex_unlock(&sgv_pools_mutex);
+
+	scst_sgv_sysfs_put(pool);
+
+	/* pool can be dead here */
+	return;
+}
+
+/**
+ * sgv_pool_set_allocator - set custom pages allocator
+ * @pool:	the cache
+ * @alloc_pages_fn: pages allocation function
+ * @free_pages_fn: pages freeing function
+ *
+ * Description:
+ *    Allows to set custom pages allocator for the SGV pool.
+ *    See the SGV pool documentation for more details.
+ */
+void sgv_pool_set_allocator(struct sgv_pool *pool,
+	struct page *(*alloc_pages_fn)(struct scatterlist *, gfp_t, void *),
+	void (*free_pages_fn)(struct scatterlist *, int, void *))
+{
+	pool->alloc_fns.alloc_pages_fn = alloc_pages_fn;
+	pool->alloc_fns.free_pages_fn = free_pages_fn;
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_set_allocator);
+
+/**
+ * sgv_pool_create - creates and initializes an SGV pool
+ * @name:	the name of the SGV pool
+ * @clustered:	sets type of the pages clustering.
+ * @single_alloc_pages:	if 0, then the SGV pool will work in the set of
+ *		power 2 size buffers mode. If >0, then the SGV pool will
+ *		work in the fixed size buffers mode. In this case
+ *		single_alloc_pages sets the size of each buffer in pages.
+ * @shared:	sets if the SGV pool can be shared between devices or not.
+ *		The cache sharing allowed only between devices created inside
+ *		the same address space. If an SGV pool is shared, each
+ *		subsequent call of sgv_pool_create() with the same cache name
+ *		will not create a new cache, but instead return a reference
+ *		to it.
+ * @purge_interval: sets the cache purging interval. I.e., an SG buffer
+ *		will be freed if it's unused for time t
+ *		purge_interval <= t < 2*purge_interval. If purge_interval
+ *		is 0, then the default interval will be used (60 seconds).
+ *		If purge_interval <0, then the automatic purging will be
+ *		disabled.
+ *
+ * Description:
+ *    Returns the resulting SGV pool or NULL in case of any error.
+ */
+struct sgv_pool *sgv_pool_create(const char *name,
+	enum sgv_clustering_types clustering_type,
+	int single_alloc_pages, bool shared, int purge_interval)
+{
+	struct sgv_pool *pool;
+	int rc;
+
+	mutex_lock(&sgv_pools_mutex);
+	list_for_each_entry(pool, &sgv_pools_list, sgv_pools_list_entry) {
+		if (strcmp(pool->name, name) == 0) {
+			if (shared) {
+				if (pool->owner_mm != current->mm) {
+					PRINT_ERROR("Attempt of a shared use "
+						"of SGV pool %s with "
+						"different MM", name);
+					goto out_err_unlock;
+				}
+				sgv_pool_get(pool);
+				goto out_unlock;
+			} else {
+				PRINT_ERROR("SGV pool %s already exists", name);
+				goto out_err_unlock;
+			}
+		}
+	}
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (pool == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Allocation of sgv_pool failed");
+		goto out_unlock;
+	}
+
+	rc = sgv_pool_init(pool, name, clustering_type, single_alloc_pages,
+				purge_interval);
+	if (rc != 0)
+		goto out_free_unlock;
+
+	rc = scst_create_sgv_sysfs(pool);
+	if (rc != 0)
+		goto out_err_unlock_put;
+
+out_unlock:
+	mutex_unlock(&sgv_pools_mutex);
+	return pool;
+
+out_free_unlock:
+	kfree(pool);
+
+out_err_unlock:
+	pool = NULL;
+	goto out_unlock;
+
+out_err_unlock_put:
+	mutex_unlock(&sgv_pools_mutex);
+	sgv_pool_deinit_put(pool);
+	goto out_err_unlock;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_create);
+
+void sgv_pool_destroy(struct sgv_pool *pool)
+{
+	int i;
+
+	for (i = 0; i < pool->max_caches; i++) {
+		if (pool->caches[i])
+			kmem_cache_destroy(pool->caches[i]);
+		pool->caches[i] = NULL;
+	}
+
+	kfree(pool);
+	return;
+}
+
+/**
+ * sgv_pool_get - increase ref counter for the corresponding SGV pool
+ *
+ * Increases ref counter for the corresponding SGV pool
+ */
+void sgv_pool_get(struct sgv_pool *pool)
+{
+	atomic_inc(&pool->sgv_pool_ref);
+	TRACE_MEM("Incrementing sgv pool %p ref (new value %d)",
+		pool, atomic_read(&pool->sgv_pool_ref));
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_get);
+
+/**
+ * sgv_pool_put - decrease ref counter for the corresponding SGV pool
+ *
+ * Decreases ref counter for the corresponding SGV pool. If the ref
+ * counter reaches 0, the cache will be destroyed.
+ */
+void sgv_pool_put(struct sgv_pool *pool)
+{
+	TRACE_MEM("Decrementing sgv pool %p ref (new value %d)",
+		pool, atomic_read(&pool->sgv_pool_ref)-1);
+	if (atomic_dec_and_test(&pool->sgv_pool_ref))
+		sgv_pool_deinit_put(pool);
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_put);
+
+/**
+ * sgv_pool_del - deletes the corresponding SGV pool
+ * @pool:	the cache to delete.
+ *
+ * Description:
+ *    If the cache is shared, it will decrease its reference counter.
+ *    If the reference counter reaches 0, the cache will be destroyed.
+ */
+void sgv_pool_del(struct sgv_pool *pool)
+{
+
+	sgv_pool_put(pool);
+	return;
+}
+EXPORT_SYMBOL_GPL(sgv_pool_del);
+
+/* Both parameters in pages */
+int scst_sgv_pools_init(unsigned long mem_hwmark, unsigned long mem_lwmark)
+{
+	int res = 0;
+
+	sgv_hi_wmk = mem_hwmark;
+	sgv_lo_wmk = mem_lwmark;
+
+	sgv_evaluate_local_max_pages();
+
+	sgv_norm_pool = sgv_pool_create("sgv", sgv_no_clustering, 0, false, 0);
+	if (sgv_norm_pool == NULL)
+		goto out_err;
+
+	sgv_norm_clust_pool = sgv_pool_create("sgv-clust",
+		sgv_full_clustering, 0, false, 0);
+	if (sgv_norm_clust_pool == NULL)
+		goto out_free_norm;
+
+	sgv_dma_pool = sgv_pool_create("sgv-dma", sgv_no_clustering, 0,
+				false, 0);
+	if (sgv_dma_pool == NULL)
+		goto out_free_clust;
+
+	sgv_shrinker.shrink = sgv_shrink;
+	sgv_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&sgv_shrinker);
+
+out:
+	return res;
+
+out_free_clust:
+	sgv_pool_deinit_put(sgv_norm_clust_pool);
+
+out_free_norm:
+	sgv_pool_deinit_put(sgv_norm_pool);
+
+out_err:
+	res = -ENOMEM;
+	goto out;
+}
+
+void scst_sgv_pools_deinit(void)
+{
+
+	unregister_shrinker(&sgv_shrinker);
+
+	sgv_pool_deinit_put(sgv_dma_pool);
+	sgv_pool_deinit_put(sgv_norm_pool);
+	sgv_pool_deinit_put(sgv_norm_clust_pool);
+
+	flush_scheduled_work();
+	return;
+}
+
+ssize_t sgv_sysfs_stat_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct sgv_pool *pool;
+	int i, total = 0, hit = 0, merged = 0, allocated = 0;
+	int oa, om, res;
+
+	pool = container_of(kobj, struct sgv_pool, sgv_kobj);
+
+	for (i = 0; i < SGV_POOL_ELEMENTS; i++) {
+		int t;
+
+		hit += atomic_read(&pool->cache_acc[i].hit_alloc);
+		total += atomic_read(&pool->cache_acc[i].total_alloc);
+
+		t = atomic_read(&pool->cache_acc[i].total_alloc) -
+			atomic_read(&pool->cache_acc[i].hit_alloc);
+		allocated += t * (1 << i);
+		merged += atomic_read(&pool->cache_acc[i].merged);
+	}
+
+	res = sprintf(buf, "%-30s %-11s %-11s %-11s %-11s", "Name", "Hit", "Total",
+		"% merged", "Cached (P/I/O)");
+
+	res += sprintf(&buf[res], "\n%-30s %-11d %-11d %-11d %d/%d/%d\n",
+		pool->name, hit, total,
+		(allocated != 0) ? merged*100/allocated : 0,
+		pool->cached_pages, pool->inactive_cached_pages,
+		pool->cached_entries);
+
+	for (i = 0; i < SGV_POOL_ELEMENTS; i++) {
+		int t = atomic_read(&pool->cache_acc[i].total_alloc) -
+			atomic_read(&pool->cache_acc[i].hit_alloc);
+		allocated = t * (1 << i);
+		merged = atomic_read(&pool->cache_acc[i].merged);
+
+		res += sprintf(&buf[res], "  %-28s %-11d %-11d %d\n",
+			pool->cache_names[i],
+			atomic_read(&pool->cache_acc[i].hit_alloc),
+			atomic_read(&pool->cache_acc[i].total_alloc),
+			(allocated != 0) ? merged*100/allocated : 0);
+	}
+
+	allocated = atomic_read(&pool->big_pages);
+	merged = atomic_read(&pool->big_merged);
+	oa = atomic_read(&pool->other_pages);
+	om = atomic_read(&pool->other_merged);
+
+	res += sprintf(&buf[res], "  %-40s %d/%-9d %d/%d\n", "big/other",
+		atomic_read(&pool->big_alloc), atomic_read(&pool->other_alloc),
+		(allocated != 0) ? merged*100/allocated : 0,
+		(oa != 0) ? om/oa : 0);
+
+	return res;
+}
+
+ssize_t sgv_sysfs_stat_reset(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct sgv_pool *pool;
+	int i;
+
+	pool = container_of(kobj, struct sgv_pool, sgv_kobj);
+
+	for (i = 0; i < SGV_POOL_ELEMENTS; i++) {
+		atomic_set(&pool->cache_acc[i].hit_alloc, 0);
+		atomic_set(&pool->cache_acc[i].total_alloc, 0);
+		atomic_set(&pool->cache_acc[i].merged, 0);
+	}
+
+	atomic_set(&pool->big_pages, 0);
+	atomic_set(&pool->big_merged, 0);
+	atomic_set(&pool->big_alloc, 0);
+	atomic_set(&pool->other_pages, 0);
+	atomic_set(&pool->other_merged, 0);
+	atomic_set(&pool->other_alloc, 0);
+
+	PRINT_INFO("Statistics for SGV pool %s resetted", pool->name);
+	return count;
+}
+
+ssize_t sgv_sysfs_global_stat_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct sgv_pool *pool;
+	int inactive_pages = 0, res;
+
+	spin_lock_bh(&sgv_pools_lock);
+	list_for_each_entry(pool, &sgv_active_pools_list,
+			sgv_active_pools_list_entry) {
+		inactive_pages += pool->inactive_cached_pages;
+	}
+	spin_unlock_bh(&sgv_pools_lock);
+
+	res = sprintf(buf, "%-42s %d/%d\n%-42s %d/%d\n%-42s %d/%d\n"
+		"%-42s %-11d\n",
+		"Inactive/active pages", inactive_pages,
+		atomic_read(&sgv_pages_total) - inactive_pages,
+		"Hi/lo watermarks [pages]", sgv_hi_wmk, sgv_lo_wmk,
+		"Hi watermark releases/failures",
+		atomic_read(&sgv_releases_on_hiwmk),
+		atomic_read(&sgv_releases_on_hiwmk_failed),
+		"Other allocs", atomic_read(&sgv_other_total_alloc));
+	return res;
+}
+
+ssize_t sgv_sysfs_global_stat_reset(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+
+	atomic_set(&sgv_releases_on_hiwmk, 0);
+	atomic_set(&sgv_releases_on_hiwmk_failed, 0);
+	atomic_set(&sgv_other_total_alloc, 0);
+
+	PRINT_INFO("%s", "Global SGV pool statistics resetted");
+	return count;
+}
+
diff -uprN orig/linux-2.6.33/Documentation/scst/sgv_cache.txt linux-2.6.33/Documentation/scst/sgv_cache.txt
--- orig/linux-2.6.33/Documentation/scst/sgv_cache.txt
+++ linux-2.6.33/Documentation/scst/sgv_cache.txt
@@ -0,0 +1,224 @@
+			SCST SGV CACHE.
+
+		PROGRAMMING INTERFACE DESCRIPTION.
+
+		     For SCST version 1.0.2
+
+SCST SGV cache is a memory management subsystem in SCST. One can call it
+a "memory pool", but Linux kernel already have a mempool interface,
+which serves different purposes. SGV cache provides to SCST core, target
+drivers and backend dev handlers facilities to allocate, build and cache
+SG vectors for data buffers. The main advantage of it is the caching
+facility, when it doesn't free to the system each vector, which is not
+used anymore, but keeps it for a while (possibly indefinitely) to let it
+be reused by the next consecutive command. This allows to:
+
+ - Reduce commands processing latencies and, hence, improve performance;
+
+ - Make commands processing latencies predictable, which is essential
+   for RT applications.
+
+The freed SG vectors are kept by the SGV cache either for some (possibly
+indefinite) time, or, optionally, until the system needs more memory and
+asks to free some using the set_shrinker() interface. Also the SGV cache
+allows to:
+
+  - Cluster pages together. "Cluster" means merging adjacent pages in a
+single SG entry. It allows to have less SG entries in the resulting SG
+vector, hence improve performance handling it as well as allow to
+work with bigger buffers on hardware with limited SG capabilities.
+
+  - Set custom page allocator functions. For instance, scst_user device
+handler uses this facility to eliminate unneeded mapping/unmapping of
+user space pages and avoid unneeded IOCTL calls for buffers allocations.
+In fileio_tgt application, which uses a regular malloc() function to
+allocate data buffers, this facility allows ~30% less CPU load and
+considerable performance increase.
+
+ - Prevent each initiator or all initiators altogether to allocate too 
+much memory and DoS the target. Consider 10 initiators, which can have
+access to 10 devices each. Any of them can queue up to 64 commands, each
+can transfer up to 1MB of data. So, all of them in a peak can allocate
+up to 10*10*64 = ~6.5GB of memory for data buffers. This amount must be
+limited somehow and the SGV cache performs this function. 
+
+From implementation POV the SGV cache is a simple extension of the kmem
+cache. It can work in 2 modes:
+
+1. With fixed size buffers.
+
+2. With a set of power 2 size buffers. In this mode each SGV cache
+(struct sgv_pool) has SGV_POOL_ELEMENTS (11 currently) of kmem caches.
+Each of those kmem caches keeps SGV cache objects (struct sgv_pool_obj)
+corresponding to SG vectors with size of order X pages. For instance,
+request to allocate 4 pages will be served from kmem cache[2], since the
+order of the of number of requested pages is 2. If later request to
+allocate 11KB comes, the same SG vector with 4 pages will be reused (see
+below). This mode is in average allows less memory overhead comparing
+with the fixed size buffers mode.
+
+Consider how the SGV cache works in the set of buffers mode. When a
+request to allocate new SG vector comes, sgv_pool_alloc() via 
+sgv_get_obj() checks if there is already a cached vector with that
+order. If yes, then that vector will be reused and its length, if 
+necessary, will be modified to match the requested size. In the above 
+example request for 11KB buffer, 4 pages vector will be reused and
+modified using trans_tbl to contain 3 pages and the last entry will be
+modified to contain the requested length - 2*PAGE_SIZE. If there is no
+cached object, then a new sgv_pool_obj will be allocated from the
+corresponding kmem cache, chosen by the order of number of requested
+pages. Then that vector will be filled by pages and returned.
+
+In the fixed size buffers mode the SGV cache works similarly, except
+that it always allocate buffer with the predefined fixed size. I.e.
+even for 4K request the whole buffer with predefined size, say, 1MB,
+will be used.
+
+In both modes, if size of a request exceeds the maximum allowed for
+caching buffer size, the requested buffer will be allocated, but not
+cached.
+
+Freed cached sgv_pool_obj objects are actually freed to the system
+either by the purge work, which is scheduled once in 60 seconds, or in
+sgv_shrink() called by system, when it's asking for memory.
+
+			Interface.
+
+struct sgv_pool *sgv_pool_create(const char *name,
+	enum sgv_clustering_types clustered, int single_alloc_pages,
+	bool shared, int purge_interval)
+	
+This function creates and initializes an SGV cache. It has the following
+arguments:
+
+ - name - the name of the SGV cache
+
+ - clustered - sets type of the pages clustering. The type can be:
+
+     * sgv_no_clustering - no clustering performed.
+
+     * sgv_tail_clustering - a page will only be merged with the latest
+       previously allocated page, so the order of pages in the SG will be
+       preserved
+
+     * sgv_full_clustering - free merging of pages at any place in
+       the SG is allowed. This mode usually provides the best merging
+       rate.
+ 
+ - single_alloc_pages - if 0, then the SGV cache will work in the set of
+   power 2 size buffers mode. If >0, then the SGV cache will work in the
+   fixed size buffers mode. In this case single_alloc_pages sets the
+   size of each buffer in pages.
+
+ - shared - sets if the SGV cache can be shared between devices or not.
+   The cache sharing allowed only between devices created inside the same
+   address space. If an SGV cache is shared, each subsequent call of
+   sgv_pool_create() with the same cache name will not create a new cache,
+   but instead return a reference to it.
+
+ - purge_interval - sets the cache purging interval. I.e. an SG buffer
+   will be freed if it's unused for time t purge_interval <= t <
+   2*purge_interval. If purge_interval is 0, then the default interval
+   will be used (60 seconds). If purge_interval <0, then the automatic
+   purging will be disabled. Shrinking by the system's demand will also
+   be disabled.
+
+Returns the resulting SGV cache or NULL in case of any error.
+
+void sgv_pool_del(struct sgv_pool *pool)
+
+This function deletes the corresponding SGV cache. If the cache is
+shared, it will decrease its reference counter. If the reference counter
+reaches 0, the cache will be destroyed.
+
+void sgv_pool_flush(struct sgv_pool *pool)
+
+This function flushes, i.e. frees, all the cached entries in the SGV
+cache.
+
+void sgv_pool_set_allocator(struct sgv_pool *pool,
+	struct page *(*alloc_pages_fn)(struct scatterlist *sg, gfp_t gfp, void *priv),
+	void (*free_pages_fn)(struct scatterlist *sg, int sg_count, void *priv));
+
+This function allows to set for the SGV cache a custom pages allocator. For
+instance, scst_user uses such function to supply to the cache mapped from
+user space pages.
+
+alloc_pages_fn() has the following parameters:
+
+ - sg - SG entry, to which the allocated page should be added.
+ 
+ - gfp - the allocation GFP flags
+ 
+ - priv - pointer to a private data supplied to sgv_pool_alloc()
+ 
+This function should return the allocated page or NULL, if no page was
+allocated.
+
+free_pages_fn() has the following parameters:
+
+ - sg - SG vector to free
+ 
+ - sg_count - number of SG entries in the sg
+ 
+ - priv - pointer to a private data supplied to the corresponding sgv_pool_alloc()
+
+struct scatterlist *sgv_pool_alloc(struct sgv_pool *pool, unsigned int size,
+	gfp_t gfp_mask, int flags, int *count,
+	struct sgv_pool_obj **sgv, struct scst_mem_lim *mem_lim, void *priv)
+
+This function allocates an SG vector from the SGV cache. It has the
+following parameters:
+
+ - pool - the cache to alloc from
+
+ - size - size of the resulting SG vector in bytes
+
+ - gfp_mask - the allocation mask
+ 
+ - flags - the allocation flags. The following flags are possible and
+   can be set using OR operation:
+ 
+     * SGV_POOL_ALLOC_NO_CACHED - the SG vector must not be cached.
+ 
+     * SGV_POOL_NO_ALLOC_ON_CACHE_MISS - don't do an allocation on a
+       cache miss.
+ 
+     * SGV_POOL_RETURN_OBJ_ON_ALLOC_FAIL - return an empty SGV object,
+       i.e. without the SG vector, if the allocation can't be completed.
+       For instance, because SGV_POOL_NO_ALLOC_ON_CACHE_MISS flag set.
+ 
+ - count - the resulting count of SG entries in the resulting SG vector.
+
+ - sgv - the resulting SGV object. It should be used to free the
+   resulting SG vector.
+ 
+ - mem_lim - memory limits, see below.
+ 
+ - priv - pointer to private for this allocation data. This pointer will
+   be supplied to alloc_pages_fn() and free_pages_fn() and can be
+   retrieved by sgv_get_priv().
+
+This function returns pointer to the resulting SG vector or NULL in case
+of any error.
+
+void sgv_pool_free(struct sgv_pool_obj *sgv, struct scst_mem_lim *mem_lim)
+
+This function frees previously allocated SG vector, referenced by SGV
+cache object sgv.
+
+void *sgv_get_priv(struct sgv_pool_obj *sgv)
+
+This function allows to get the allocation private data for this SGV
+cache object sgv. The private data are set by sgv_pool_alloc().
+
+void scst_init_mem_lim(struct scst_mem_lim *mem_lim)
+
+This function initializes memory limits structure mem_lim according to
+the current system configuration. This structure should be latter used
+to track and limit allocated by one or more SGV caches memory.
+
+		Runtime information and statistics.
+
+Runtime information and statistics is available in /sys/kernel/scst_tgt/sgv.
+
