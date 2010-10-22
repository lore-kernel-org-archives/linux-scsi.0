From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: tune fc_exch_em_alloc() to be O(2)
Date: Fri, 22 Oct 2010 20:20:28 +0800
Message-ID: <AANLkTinpHyH31BsBKTHEg8CpbBYL1x7G3tMVu-1KGpy5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48297 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0JVMU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 08:20:29 -0400
Received: by wwe15 with SMTP id 15so786966wwe.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2010 05:20:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

For allocating new exch from pool,  scanning for free slot in exch
array fluctuates when exch pool is close to exhaustion.

The fluctuation is smoothed, and the scan looks to be O(2).

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-22 20:02:54.000000000 +0800
@@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
 struct fc_exch_pool {
 	u16		 next_index;
 	u16		 total_exches;
+
+	/* two cache of free slot in exch array */
+	u16		 left;
+	u16		 right;
+
 	spinlock_t	 lock;
 	struct list_head ex_list;
 };
@@ -397,13 +402,26 @@ static inline void fc_exch_ptr_set(struc
 static void fc_exch_delete(struct fc_exch *ep)
 {
 	struct fc_exch_pool *pool;
+	u16 index;

 	pool = ep->pool;
 	spin_lock_bh(&pool->lock);
 	WARN_ON(pool->total_exches <= 0);
 	pool->total_exches--;
-	fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid) >> fc_cpu_order,
-			NULL);
+
+	/* update cache of free slot */
+	index = (ep->xid - ep->em->min_xid) >> fc_cpu_order;
+	if (pool->left == FC_XID_UNKNOWN)
+		pool->left = index;
+	else if (pool->right == FC_XID_UNKNOWN)
+		pool->right = index;
+	else
+		/* XXX
+		 * next = entropy(index, left, right);
+		 **/
+		pool->next_index = index;
+
+	fc_exch_ptr_set(pool, index, NULL);
 	list_del(&ep->ex_list);
 	spin_unlock_bh(&pool->lock);
 	fc_exch_release(ep);	/* drop hold for exch in mp */
@@ -679,6 +697,19 @@ static struct fc_exch *fc_exch_em_alloc(
 	pool = per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
 	put_cpu();
+
+	/* peek cache of free slot */
+	if (pool->left != FC_XID_UNKNOWN) {
+		index = pool->left;
+		pool->left = FC_XID_UNKNOWN;
+		goto hit;
+	}
+	if (pool->right != FC_XID_UNKNOWN) {
+		index = pool->right;
+		pool->right = FC_XID_UNKNOWN;
+		goto hit;
+	}
+
 	index = pool->next_index;
 	/* allocate new exch from pool */
 	while (fc_exch_ptr_get(pool, index)) {
@@ -687,7 +718,7 @@ static struct fc_exch *fc_exch_em_alloc(
 			goto err;
 	}
 	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;
-
+hit:
 	fc_exch_hold(ep);	/* hold for exch in mp */
 	spin_lock_init(&ep->ex_lock);
 	/*
@@ -2181,6 +2212,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(st
 		goto free_mempool;
 	for_each_possible_cpu(cpu) {
 		pool = per_cpu_ptr(mp->pool, cpu);
+		pool->left  =
+		pool->right = FC_XID_UNKNOWN;
 		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->ex_list);
 	}
