From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/64] fcoe,
	libfc: adds per cpu exch pool within exchange manager(EM)
Date: Tue, 25 Aug 2009 13:58:47 -0700
Message-ID: <20090825205847.1553.96759.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbZHYU7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:08 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Adds per cpu exch pool for these reasons:-

 1. Currently an EM instance is shared across all cpus to manage
    all exches for all cpus. This required em_lock across all
    cpus for an exch alloc, free, lookup and reset each frame
    and that made em_lock expensive, so instead having per cpu
    exch pool with their own per cpu pool lock will likely reduce
    locking contention in fast path for an exch alloc, free and
    lookup.

 2. Per cpu exch pool will likely improve cache hit ratio since
    all frames of an exch will be processed on the same cpu on
    which exch originated.

This patch is only prep work to help in keeping complexity of next
patch low, so this patch only sets up per cpu exch pool and related
helper funcs to be used by next patch. The next patch fully makes
use of per cpu exch pool in all code paths ie. tx, rx and reset.

Divides per EM exch id range equally across all cpus to setup per
cpu exch pool. This division is such that lower bits of exch id
carries cpu number info on which exch originated, later a simple
bitwise AND operation on exch id of incoming frame with fc_cpu_mask
retrieves cpu number info to direct all frames to same cpu on which
exch originated. This required a global fc_cpu_mask and fc_cpu_order
initialized to max possible cpus number nr_cpu_ids rounded up to 2's
power, this will be used in mapping exch id and exch ptr array
index in pool during exch allocation, find or reset code paths.

Adds a check in fc_exch_mgr_alloc() to ensure specified min_xid
lower bits are zero since these bits are used to carry cpu info.

Adds and initializes struct fc_exch_pool with all required fields
to manage exches in pool.

Allocates per cpu struct fc_exch_pool with memory for exches array
for range of exches per pool. The exches array memory is followed
by struct fc_exch_pool.

Adds fc_exch_ptr_get/set() helper functions to get/set exch ptr in
pool exches array at specified array index.

Increases default FCOE_MAX_XID to 0x0FFF from 0x07EF, so that more
exches are available per cpu after above described exch id range
division across all cpus to each pool.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.h     |    2 -
 drivers/scsi/libfc/fc_exch.c |   89 +++++++++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h         |    1 
 3 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 65120e2..550d1e4 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -38,7 +38,7 @@
 #define FCOE_MAX_OUTSTANDING_COMMANDS	1024
 
 #define FCOE_MIN_XID		0x0000	/* the min xid supported by fcoe_sw */
-#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
+#define FCOE_MAX_XID		0x0FFF	/* the max xid supported by fcoe_sw */
 
 unsigned int fcoe_debug_logging;
 module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 40c3427..9cbe8d6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -32,6 +32,9 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
+u16	fc_cpu_mask;		/* cpu mask for possible cpus */
+EXPORT_SYMBOL(fc_cpu_mask);
+static u16	fc_cpu_order;	/* 2's power to represent total possible cpus */
 static struct kmem_cache *fc_em_cachep;        /* cache for exchanges */
 
 /*
@@ -48,6 +51,20 @@ static struct kmem_cache *fc_em_cachep;        /* cache for exchanges */
  */
 
 /*
+ * Per cpu exchange pool
+ *
+ * This structure manages per cpu exchanges in array of exchange pointers.
+ * This array is allocated followed by struct fc_exch_pool memory for
+ * assigned range of exchanges to per cpu pool.
+ */
+struct fc_exch_pool {
+	u16		next_index;	/* next possible free exchange index */
+	u16		total_exches;	/* total allocated exchanges */
+	spinlock_t	lock;		/* exch pool lock */
+	struct list_head	ex_list;	/* allocated exchanges list */
+};
+
+/*
  * Exchange manager.
  *
  * This structure is the center for creating exchanges and sequences.
@@ -66,6 +83,8 @@ struct fc_exch_mgr {
 	u32	total_exches;		/* total allocated exchanges */
 	struct list_head	ex_list;	/* allocated exchanges list */
 	mempool_t	*ep_pool;	/* reserve ep's */
+	u16		pool_max_index;	/* max exch array index in exch pool */
+	struct fc_exch_pool *pool;	/* per cpu exch pool */
 
 	/*
 	 * currently exchange mgr stats are updated but not used.
@@ -303,6 +322,19 @@ static int fc_exch_done_locked(struct fc_exch *ep)
 	return rc;
 }
 
+static inline struct fc_exch *fc_exch_ptr_get(struct fc_exch_pool *pool,
+					      u16 index)
+{
+	struct fc_exch **exches = (struct fc_exch **)(pool + 1);
+	return exches[index];
+}
+
+static inline void fc_exch_ptr_set(struct fc_exch_pool *pool, u16 index,
+				   struct fc_exch *ep)
+{
+	((struct fc_exch **)(pool + 1))[index] = ep;
+}
+
 static void fc_exch_mgr_delete_ep(struct fc_exch *ep)
 {
 	struct fc_exch_mgr *mp;
@@ -1751,6 +1783,7 @@ static void fc_exch_mgr_destroy(struct kref *kref)
 	 */
 	WARN_ON(mp->total_exches != 0);
 	mempool_destroy(mp->ep_pool);
+	free_percpu(mp->pool);
 	kfree(mp);
 }
 
@@ -1770,8 +1803,13 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 {
 	struct fc_exch_mgr *mp;
 	size_t len;
+	u16 pool_exch_range;
+	size_t pool_size;
+	unsigned int cpu;
+	struct fc_exch_pool *pool;
 
-	if (max_xid <= min_xid || max_xid == FC_XID_UNKNOWN) {
+	if (max_xid <= min_xid || max_xid == FC_XID_UNKNOWN ||
+	    (min_xid & fc_cpu_mask) != 0) {
 		FC_LPORT_DBG(lp, "Invalid min_xid 0x:%x and max_xid 0x:%x\n",
 			     min_xid, max_xid);
 		return NULL;
@@ -1802,10 +1840,31 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	if (!mp->ep_pool)
 		goto free_mp;
 
+	/*
+	 * Setup per cpu exch pool with entire exchange id range equally
+	 * divided across all cpus. The exch pointers array memory is
+	 * allocated for exch range per pool.
+	 */
+	pool_exch_range = (mp->max_xid - mp->min_xid + 1) / (fc_cpu_mask + 1);
+	mp->pool_max_index = pool_exch_range - 1;
+
+	/*
+	 * Allocate and initialize per cpu exch pool
+	 */
+	pool_size = sizeof(*pool) + pool_exch_range * sizeof(struct fc_exch *);
+	mp->pool = __alloc_percpu(pool_size, __alignof__(struct fc_exch_pool));
+	if (!mp->pool)
+		goto free_mempool;
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(mp->pool, cpu);
+		spin_lock_init(&pool->lock);
+		INIT_LIST_HEAD(&pool->ex_list);
+	}
+
 	kref_init(&mp->kref);
 	if (!fc_exch_mgr_add(lp, mp, match)) {
-		mempool_destroy(mp->ep_pool);
-		goto free_mp;
+		free_percpu(mp->pool);
+		goto free_mempool;
 	}
 
 	/*
@@ -1816,6 +1875,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	kref_put(&mp->kref, fc_exch_mgr_destroy);
 	return mp;
 
+free_mempool:
+	mempool_destroy(mp->ep_pool);
 free_mp:
 	kfree(mp);
 	return NULL;
@@ -1975,6 +2036,28 @@ int fc_exch_init(struct fc_lport *lp)
 	if (!lp->tt.seq_exch_abort)
 		lp->tt.seq_exch_abort = fc_seq_exch_abort;
 
+	/*
+	 * Initialize fc_cpu_mask and fc_cpu_order. The
+	 * fc_cpu_mask is set for nr_cpu_ids rounded up
+	 * to order of 2's * power and order is stored
+	 * in fc_cpu_order as this is later required in
+	 * mapping between an exch id and exch array index
+	 * in per cpu exch pool.
+	 *
+	 * This round up is required to align fc_cpu_mask
+	 * to exchange id's lower bits such that all incoming
+	 * frames of an exchange gets delivered to the same
+	 * cpu on which exchange originated by simple bitwise
+	 * AND operation between fc_cpu_mask and exchange id.
+	 */
+	fc_cpu_mask = 1;
+	fc_cpu_order = 0;
+	while (fc_cpu_mask < nr_cpu_ids) {
+		fc_cpu_mask <<= 1;
+		fc_cpu_order++;
+	}
+	fc_cpu_mask--;
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_exch_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index c2b928c..3206338 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -343,6 +343,7 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
 
 struct fc_exch_mgr;
 struct fc_exch_mgr_anchor;
+extern u16	fc_cpu_mask;	/* cpu mask for possible cpus */
 
 /*
  * Sequence.

