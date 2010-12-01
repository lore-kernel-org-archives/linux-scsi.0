From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/27] libfc: tune fc_exch_em_alloc() to be O(2)
Date: Tue, 30 Nov 2010 16:18:17 -0800
Message-ID: <20101201001817.18369.74436.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:18 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

For allocating new exch from pool,  scanning for free slot in exch
array fluctuates when exch pool is close to exhaustion.

The fluctuation is smoothed, and the scan looks to be O(2).

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d0df1b2..46973d6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workqueue;
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
@@ -396,13 +401,23 @@ static inline void fc_exch_ptr_set(struct fc_exch_pool *pool, u16 index,
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
+		pool->next_index = index;
+
+	fc_exch_ptr_set(pool, index, NULL);
 	list_del(&ep->ex_list);
 	spin_unlock_bh(&pool->lock);
 	fc_exch_release(ep);	/* drop hold for exch in mp */
@@ -678,6 +693,19 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
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
@@ -686,7 +714,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 			goto err;
 	}
 	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;
-
+hit:
 	fc_exch_hold(ep);	/* hold for exch in mp */
 	spin_lock_init(&ep->ex_lock);
 	/*
@@ -2180,6 +2208,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lport,
 		goto free_mempool;
 	for_each_possible_cpu(cpu) {
 		pool = per_cpu_ptr(mp->pool, cpu);
+		pool->left = FC_XID_UNKNOWN;
+		pool->right = FC_XID_UNKNOWN;
 		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->ex_list);
 	}

