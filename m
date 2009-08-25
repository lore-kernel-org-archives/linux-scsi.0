From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/64] fcoe,
	libfc: fully makes use of per cpu exch pool and then removes em_lock
Date: Tue, 25 Aug 2009 13:58:53 -0700
Message-ID: <20090825205853.1553.57151.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZHYU6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:51 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

1. Updates fcoe_rcv() to queue incoming frames to the fcoe per
   cpu thread on which this frame's exch was originated and simply
   use current cpu for request exch not originated by initiator.
   It is redundant to add this code under CONFIG_SMP, so removes
   CONFIG_SMP uses around this code.

2. Updates fc_exch_em_alloc, fc_exch_delete, fc_exch_find to use
   per cpu exch pools, here fc_exch_delete is rename of older
   fc_exch_mgr_delete_ep since ep/exch are now deleted in pools
   of EM and so brief new name is sufficient and better name.

   Updates these functions to map exch id to their index into exch
   pool using fc_cpu_mask, fc_cpu_order and EM min_xid.
   This mapping is as per detailed explanation about this in
   last patch and basically this is just as lower fc_cpu_mask
   bits of exch id as cpu number and upper bit sum of EM min_xid
   and exch index in pool.

   Uses pool next_index to keep track of exch allocation from
   pool along with pool_max_index as upper bound of exches array
   in pool.

3. Adds exch pool ptr to fc_exch to free exch to its pool in
   fc_exch_delete.

4. Updates fc_exch_mgr_reset to reset all exch pools of an EM,
   this required adding fc_exch_pool_reset func to reset exches
   in pool and then have fc_exch_mgr_reset call fc_exch_pool_reset
   for each pool within each EM for a lport.

5. Removes no longer needed exches array, em_lock, next_xid, and
   total_exches from struct fc_exch_mgr, these are not needed after
   use of per cpu exch pool, also removes not used max_read,
   last_read from struct fc_exch_mgr.

6. Updates locking notes for exch pool lock with fc_exch lock and
   uses pool lock in exch allocation, lookup and reset.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c     |   19 ++--
 drivers/scsi/libfc/fc_exch.c |  189 ++++++++++++++++++++++--------------------
 include/scsi/libfc.h         |    9 +-
 3 files changed, 115 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 757aa28..e32a0ed 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -912,8 +912,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_softc *fc;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
-	unsigned short oxid;
-	unsigned int cpu = 0;
+	unsigned int cpu;
 
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->ctlr.lp;
@@ -947,20 +946,20 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
 	fh = (struct fc_frame_header *) skb_transport_header(skb);
 
-	oxid = ntohs(fh->fh_ox_id);
-
 	fr = fcoe_dev_from_skb(skb);
 	fr->fr_dev = lp;
 	fr->ptype = ptype;
 
-#ifdef CONFIG_SMP
 	/*
-	 * The incoming frame exchange id(oxid) is ANDed with num of online
-	 * cpu bits to get cpu and then this cpu is used for selecting
-	 * a per cpu kernel thread from fcoe_percpu.
+	 * In case the incoming frame's exchange is originated from
+	 * the initiator, then received frame's exchange id is ANDed
+	 * with fc_cpu_mask bits to get the same cpu on which exchange
+	 * was originated, otherwise just use the current cpu.
 	 */
-	cpu = oxid & (num_online_cpus() - 1);
-#endif
+	if (ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)
+		cpu = ntohs(fh->fh_ox_id) & fc_cpu_mask;
+	else
+		cpu = smp_processor_id();
 
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock_bh(&fps->fcoe_rx_list.lock);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9cbe8d6..b51db15 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -73,14 +73,8 @@ struct fc_exch_pool {
 struct fc_exch_mgr {
 	enum fc_class	class;		/* default class for sequences */
 	struct kref	kref;		/* exchange mgr reference count */
-	spinlock_t	em_lock;	/* exchange manager lock,
-					   must be taken before ex_lock */
-	u16		next_xid;	/* next possible free exchange ID */
 	u16		min_xid;	/* min exchange ID */
 	u16		max_xid;	/* max exchange ID */
-	u16		max_read;	/* max exchange ID for read */
-	u16		last_read;	/* last xid allocated for read */
-	u32	total_exches;		/* total allocated exchanges */
 	struct list_head	ex_list;	/* allocated exchanges list */
 	mempool_t	*ep_pool;	/* reserve ep's */
 	u16		pool_max_index;	/* max exch array index in exch pool */
@@ -99,7 +93,6 @@ struct fc_exch_mgr {
 		atomic_t seq_not_found;
 		atomic_t non_bls_resp;
 	} stats;
-	struct fc_exch **exches;	/* for exch pointers indexed by xid */
 };
 #define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
 
@@ -192,8 +185,8 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp);
  * sequence allocation and deallocation must be locked.
  *  - exchange refcnt can be done atomicly without locks.
  *  - sequence allocation must be locked by exch lock.
- *  - If the em_lock and ex_lock must be taken at the same time, then the
- *    em_lock must be taken before the ex_lock.
+ *  - If the EM pool lock and ex_lock must be taken at the same time, then the
+ *    EM pool lock must be taken before the ex_lock.
  */
 
 /*
@@ -335,17 +328,18 @@ static inline void fc_exch_ptr_set(struct fc_exch_pool *pool, u16 index,
 	((struct fc_exch **)(pool + 1))[index] = ep;
 }
 
-static void fc_exch_mgr_delete_ep(struct fc_exch *ep)
+static void fc_exch_delete(struct fc_exch *ep)
 {
-	struct fc_exch_mgr *mp;
+	struct fc_exch_pool *pool;
 
-	mp = ep->em;
-	spin_lock_bh(&mp->em_lock);
-	WARN_ON(mp->total_exches <= 0);
-	mp->total_exches--;
-	mp->exches[ep->xid - mp->min_xid] = NULL;
+	pool = ep->pool;
+	spin_lock_bh(&pool->lock);
+	WARN_ON(pool->total_exches <= 0);
+	pool->total_exches--;
+	fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid) >> fc_cpu_order,
+			NULL);
 	list_del(&ep->ex_list);
-	spin_unlock_bh(&mp->em_lock);
+	spin_unlock_bh(&pool->lock);
 	fc_exch_release(ep);	/* drop hold for exch in mp */
 }
 
@@ -465,7 +459,7 @@ static void fc_exch_timeout(struct work_struct *work)
 			rc = fc_exch_done_locked(ep);
 		spin_unlock_bh(&ep->ex_lock);
 		if (!rc)
-			fc_exch_mgr_delete_ep(ep);
+			fc_exch_delete(ep);
 		if (resp)
 			resp(sp, ERR_PTR(-FC_EX_TIMEOUT), arg);
 		fc_seq_exch_abort(sp, 2 * ep->r_a_tov);
@@ -509,10 +503,9 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 					struct fc_exch_mgr *mp)
 {
 	struct fc_exch *ep;
-	u16 min, max, xid;
-
-	min = mp->min_xid;
-	max = mp->max_xid;
+	unsigned int cpu;
+	u16 index;
+	struct fc_exch_pool *pool;
 
 	/* allocate memory for exchange */
 	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
@@ -522,15 +515,17 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	}
 	memset(ep, 0, sizeof(*ep));
 
-	spin_lock_bh(&mp->em_lock);
-	xid = mp->next_xid;
-	/* alloc a new xid */
-	while (mp->exches[xid - min]) {
-		xid = (xid == max) ? min : xid + 1;
-		if (xid == mp->next_xid)
+	cpu = smp_processor_id();
+	pool = per_cpu_ptr(mp->pool, cpu);
+	spin_lock_bh(&pool->lock);
+	index = pool->next_index;
+	/* allocate new exch from pool */
+	while (fc_exch_ptr_get(pool, index)) {
+		index = index == mp->pool_max_index ? 0 : index + 1;
+		if (index == pool->next_index)
 			goto err;
 	}
-	mp->next_xid = (xid == max) ? min : xid + 1;
+	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;
 
 	fc_exch_hold(ep);	/* hold for exch in mp */
 	spin_lock_init(&ep->ex_lock);
@@ -541,17 +536,18 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	 */
 	spin_lock_bh(&ep->ex_lock);
 
-	mp->exches[xid - mp->min_xid] = ep;
-	list_add_tail(&ep->ex_list, &mp->ex_list);
+	fc_exch_ptr_set(pool, index, ep);
+	list_add_tail(&ep->ex_list, &pool->ex_list);
 	fc_seq_alloc(ep, ep->seq_id++);
-	mp->total_exches++;
-	spin_unlock_bh(&mp->em_lock);
+	pool->total_exches++;
+	spin_unlock_bh(&pool->lock);
 
 	/*
 	 *  update exchange
 	 */
-	ep->oxid = ep->xid = xid;
+	ep->oxid = ep->xid = (index << fc_cpu_order | cpu) + mp->min_xid;
 	ep->em = mp;
+	ep->pool = pool;
 	ep->lp = lport;
 	ep->f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
 	ep->rxid = FC_XID_UNKNOWN;
@@ -560,7 +556,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 out:
 	return ep;
 err:
-	spin_unlock_bh(&mp->em_lock);
+	spin_unlock_bh(&pool->lock);
 	atomic_inc(&mp->stats.no_free_exch_xid);
 	mempool_free(ep, mp->ep_pool);
 	return NULL;
@@ -597,16 +593,18 @@ EXPORT_SYMBOL(fc_exch_alloc);
  */
 static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 {
+	struct fc_exch_pool *pool;
 	struct fc_exch *ep = NULL;
 
 	if ((xid >= mp->min_xid) && (xid <= mp->max_xid)) {
-		spin_lock_bh(&mp->em_lock);
-		ep = mp->exches[xid - mp->min_xid];
+		pool = per_cpu_ptr(mp->pool, xid & fc_cpu_mask);
+		spin_lock_bh(&pool->lock);
+		ep = fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
 		if (ep) {
 			fc_exch_hold(ep);
 			WARN_ON(ep->xid != xid);
 		}
-		spin_unlock_bh(&mp->em_lock);
+		spin_unlock_bh(&pool->lock);
 	}
 	return ep;
 }
@@ -620,7 +618,7 @@ void fc_exch_done(struct fc_seq *sp)
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
-		fc_exch_mgr_delete_ep(ep);
+		fc_exch_delete(ep);
 }
 EXPORT_SYMBOL(fc_exch_done);
 
@@ -1213,7 +1211,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);
 		if (!rc)
-			fc_exch_mgr_delete_ep(ep);
+			fc_exch_delete(ep);
 	}
 
 	/*
@@ -1323,7 +1321,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 		rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
-		fc_exch_mgr_delete_ep(ep);
+		fc_exch_delete(ep);
 
 	if (resp)
 		resp(sp, fp, ex_resp_arg);
@@ -1466,48 +1464,76 @@ static void fc_exch_reset(struct fc_exch *ep)
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
-		fc_exch_mgr_delete_ep(ep);
+		fc_exch_delete(ep);
 
 	if (resp)
 		resp(sp, ERR_PTR(-FC_EX_CLOSED), arg);
 }
 
-/*
- * Reset an exchange manager, releasing all sequences and exchanges.
- * If sid is non-zero, reset only exchanges we source from that FID.
- * If did is non-zero, reset only exchanges destined to that FID.
+/**
+ * fc_exch_pool_reset() - Resets an per cpu exches pool.
+ * @lport:	ptr to the local port
+ * @pool:	ptr to the per cpu exches pool
+ * @sid:	source FC ID
+ * @did:	destination FC ID
+ *
+ * Resets an per cpu exches pool, releasing its all sequences
+ * and exchanges. If sid is non-zero, then reset only exchanges
+ * we sourced from that FID. If did is non-zero, reset only
+ * exchanges destined to that FID.
  */
-void fc_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
+static void fc_exch_pool_reset(struct fc_lport *lport,
+			       struct fc_exch_pool *pool,
+			       u32 sid, u32 did)
 {
 	struct fc_exch *ep;
 	struct fc_exch *next;
-	struct fc_exch_mgr *mp;
-	struct fc_exch_mgr_anchor *ema;
 
-	list_for_each_entry(ema, &lp->ema_list, ema_list) {
-		mp = ema->mp;
-		spin_lock_bh(&mp->em_lock);
+	spin_lock_bh(&pool->lock);
 restart:
-		list_for_each_entry_safe(ep, next, &mp->ex_list, ex_list) {
-			if ((lp == ep->lp) &&
-			    (sid == 0 || sid == ep->sid) &&
-			    (did == 0 || did == ep->did)) {
-				fc_exch_hold(ep);
-				spin_unlock_bh(&mp->em_lock);
-
-				fc_exch_reset(ep);
-
-				fc_exch_release(ep);
-				spin_lock_bh(&mp->em_lock);
-
-				/*
-				 * must restart loop incase while lock
-				 * was down multiple eps were released.
-				 */
-				goto restart;
-			}
+	list_for_each_entry_safe(ep, next, &pool->ex_list, ex_list) {
+		if ((lport == ep->lp) &&
+		    (sid == 0 || sid == ep->sid) &&
+		    (did == 0 || did == ep->did)) {
+			fc_exch_hold(ep);
+			spin_unlock_bh(&pool->lock);
+
+			fc_exch_reset(ep);
+
+			fc_exch_release(ep);
+			spin_lock_bh(&pool->lock);
+
+			/*
+			 * must restart loop incase while lock
+			 * was down multiple eps were released.
+			 */
+			goto restart;
 		}
-		spin_unlock_bh(&mp->em_lock);
+	}
+	spin_unlock_bh(&pool->lock);
+}
+
+/**
+ * fc_exch_mgr_reset() - Resets all EMs of a lport
+ * @lport:	ptr to the local port
+ * @sid:	source FC ID
+ * @did:	destination FC ID
+ *
+ * Reset all EMs of a lport, releasing its all sequences and
+ * exchanges. If sid is non-zero, then reset only exchanges
+ * we sourced from that FID. If did is non-zero, reset only
+ * exchanges destined to that FID.
+ */
+void fc_exch_mgr_reset(struct fc_lport *lport, u32 sid, u32 did)
+{
+	struct fc_exch_mgr_anchor *ema;
+	unsigned int cpu;
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list) {
+		for_each_possible_cpu(cpu)
+			fc_exch_pool_reset(lport,
+					   per_cpu_ptr(ema->mp->pool, cpu),
+					   sid, did);
 	}
 }
 EXPORT_SYMBOL(fc_exch_mgr_reset);
@@ -1777,11 +1803,6 @@ static void fc_exch_mgr_destroy(struct kref *kref)
 {
 	struct fc_exch_mgr *mp = container_of(kref, struct fc_exch_mgr, kref);
 
-	/*
-	 * The total exch count must be zero
-	 * before freeing exchange manager.
-	 */
-	WARN_ON(mp->total_exches != 0);
 	mempool_destroy(mp->ep_pool);
 	free_percpu(mp->pool);
 	kfree(mp);
@@ -1802,7 +1823,6 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 				      bool (*match)(struct fc_frame *))
 {
 	struct fc_exch_mgr *mp;
-	size_t len;
 	u16 pool_exch_range;
 	size_t pool_size;
 	unsigned int cpu;
@@ -1816,25 +1836,16 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	}
 
 	/*
-	 * Memory need for EM
+	 * allocate memory for EM
 	 */
-	len = (max_xid - min_xid + 1) * (sizeof(struct fc_exch *));
-	len += sizeof(struct fc_exch_mgr);
-
-	mp = kzalloc(len, GFP_ATOMIC);
+	mp = kzalloc(sizeof(struct fc_exch_mgr), GFP_ATOMIC);
 	if (!mp)
 		return NULL;
 
 	mp->class = class;
-	mp->total_exches = 0;
-	mp->exches = (struct fc_exch **)(mp + 1);
 	/* adjust em exch xid range for offload */
 	mp->min_xid = min_xid;
 	mp->max_xid = max_xid;
-	mp->next_xid = min_xid;
-
-	INIT_LIST_HEAD(&mp->ex_list);
-	spin_lock_init(&mp->em_lock);
 
 	mp->ep_pool = mempool_create_slab_pool(2, fc_em_cachep);
 	if (!mp->ep_pool)
@@ -1944,7 +1955,7 @@ err:
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
-		fc_exch_mgr_delete_ep(ep);
+		fc_exch_delete(ep);
 	return NULL;
 }
 EXPORT_SYMBOL(fc_exch_seq_send);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 3206338..53b3881 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -368,6 +368,7 @@ struct fc_seq {
  */
 struct fc_exch {
 	struct fc_exch_mgr *em;		/* exchange manager */
+	struct fc_exch_pool *pool;	/* per cpu exches pool */
 	u32		state;		/* internal driver state */
 	u16		xid;		/* our exchange ID */
 	struct list_head	ex_list;	/* free or busy list linkage */
@@ -1045,10 +1046,12 @@ struct fc_exch *fc_exch_alloc(struct fc_lport *lport, struct fc_frame *fp);
  */
 struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
 
+
 /*
- * Reset an exchange manager, completing all sequences and exchanges.
- * If s_id is non-zero, reset only exchanges originating from that FID.
- * If d_id is non-zero, reset only exchanges sending to that FID.
+ * Reset all EMs of a lport, releasing its all sequences and
+ * exchanges. If sid is non-zero, then reset only exchanges
+ * we sourced from that FID. If did is non-zero, reset only
+ * exchanges destined to that FID.
  */
 void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 

