From: michaelc@cs.wisc.edu
Subject: [PATCH 06/24] libiscsi, iscsi_tcp: iscsi pool cleanup
Date: Thu, 13 Dec 2007 12:43:25 -0600
Message-ID: <11975714342353-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbXLMSot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:49 -0500
In-Reply-To: <11975714333916-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Olaf Kirch <olaf.kirch@oracle.com>

From: Mike Christie <michaelc@cs.wisc.edu>

from olaf.kirch@oracle.com

iscsi_pool_init simplified

iscsi_pool_init currently has a lot of duplicate kfree() calls it does
when some allocation fails. This patch simplifies the code a little by
using iscsi_pool_free to tear down the pool in case of an error.

iscsi_pool_init also returns a copy of the item array to the caller.
Not all callers use this array, so we make it optional.

Instead of allocating a second array and return that, allocate just one
array, of twice the size.

Update users of iscsi_pool_{init,free}

This patch drops the (now useless) second argument to
iscsi_pool_free, and updates all callers.

It also removes the ctask->r2ts array, which was never
used anyway. Since the items argument to iscsi_pool_init
is now optional, we can pass NULL instead.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   12 ++-----
 drivers/scsi/iscsi_tcp.h |    3 +-
 drivers/scsi/libiscsi.c  |   75 ++++++++++++++++++++++++---------------------
 include/scsi/libiscsi.h  |   10 +++---
 4 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 491845f..f79a457 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1998,8 +1998,7 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 		 */
 
 		/* R2T pool */
-		if (iscsi_pool_init(&tcp_ctask->r2tpool, session->max_r2t * 4,
-				    (void***)&tcp_ctask->r2ts,
+		if (iscsi_pool_init(&tcp_ctask->r2tpool, session->max_r2t * 4, NULL,
 				    sizeof(struct iscsi_r2t_info))) {
 			goto r2t_alloc_fail;
 		}
@@ -2008,8 +2007,7 @@ iscsi_r2tpool_alloc(struct iscsi_session *session)
 		tcp_ctask->r2tqueue = kfifo_alloc(
 		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL);
 		if (tcp_ctask->r2tqueue == ERR_PTR(-ENOMEM)) {
-			iscsi_pool_free(&tcp_ctask->r2tpool,
-					(void**)tcp_ctask->r2ts);
+			iscsi_pool_free(&tcp_ctask->r2tpool);
 			goto r2t_alloc_fail;
 		}
 	}
@@ -2022,8 +2020,7 @@ r2t_alloc_fail:
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 		kfifo_free(tcp_ctask->r2tqueue);
-		iscsi_pool_free(&tcp_ctask->r2tpool,
-				(void**)tcp_ctask->r2ts);
+		iscsi_pool_free(&tcp_ctask->r2tpool);
 	}
 	return -ENOMEM;
 }
@@ -2038,8 +2035,7 @@ iscsi_r2tpool_free(struct iscsi_session *session)
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
 		kfifo_free(tcp_ctask->r2tqueue);
-		iscsi_pool_free(&tcp_ctask->r2tpool,
-				(void**)tcp_ctask->r2ts);
+		iscsi_pool_free(&tcp_ctask->r2tpool);
 	}
 }
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index eb3784f..d49d876 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -175,9 +175,8 @@ struct iscsi_tcp_cmd_task {
 	uint32_t		exp_datasn;		/* expected target's R2TSN/DataSN */
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;			/* in progress R2T    */
-	struct iscsi_queue	r2tpool;
+	struct iscsi_pool	r2tpool;
 	struct kfifo		*r2tqueue;
-	struct iscsi_r2t_info	**r2ts;
 	int			digest_count;
 	uint32_t		immdigest;		/* for imm data */
 	struct iscsi_buf	immbuf;			/* for imm data digest */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5936586..d43f909 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1413,59 +1413,64 @@ done:
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_device_reset);
 
+/*
+ * Pre-allocate a pool of @max items of @item_size. By default, the pool
+ * should be accessed via kfifo_{get,put} on q->queue.
+ * Optionally, the caller can obtain the array of object pointers
+ * by passing in a non-NULL @items pointer
+ */
 int
-iscsi_pool_init(struct iscsi_queue *q, int max, void ***items, int item_size)
+iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 {
-	int i;
+	int i, num_arrays = 1;
 
-	*items = kmalloc(max * sizeof(void*), GFP_KERNEL);
-	if (*items == NULL)
-		return -ENOMEM;
+	memset(q, 0, sizeof(*q));
 
 	q->max = max;
-	q->pool = kmalloc(max * sizeof(void*), GFP_KERNEL);
-	if (q->pool == NULL) {
-		kfree(*items);
-		return -ENOMEM;
-	}
+
+	/* If the user passed an items pointer, he wants a copy of
+	 * the array. */
+	if (items)
+		num_arrays++;
+	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
+	if (q->pool == NULL)
+		goto enomem;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
-	if (q->queue == ERR_PTR(-ENOMEM)) {
-		kfree(q->pool);
-		kfree(*items);
-		return -ENOMEM;
-	}
+	if (q->queue == ERR_PTR(-ENOMEM))
+		goto enomem;
 
 	for (i = 0; i < max; i++) {
-		q->pool[i] = kmalloc(item_size, GFP_KERNEL);
+		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
 		if (q->pool[i] == NULL) {
-			int j;
-
-			for (j = 0; j < i; j++)
-				kfree(q->pool[j]);
-
-			kfifo_free(q->queue);
-			kfree(q->pool);
-			kfree(*items);
-			return -ENOMEM;
+			q->max = i;
+			goto enomem;
 		}
-		memset(q->pool[i], 0, item_size);
-		(*items)[i] = q->pool[i];
 		__kfifo_put(q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
+
+	if (items) {
+		*items = q->pool + max;
+		memcpy(*items, q->pool, max * sizeof(void *));
+	}
+
 	return 0;
+
+enomem:
+	iscsi_pool_free(q);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_init);
 
-void iscsi_pool_free(struct iscsi_queue *q, void **items)
+void iscsi_pool_free(struct iscsi_pool *q)
 {
 	int i;
 
 	for (i = 0; i < q->max; i++)
-		kfree(items[i]);
-	kfree(q->pool);
-	kfree(items);
+		kfree(q->pool[i]);
+	if (q->pool)
+		kfree(q->pool);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
@@ -1610,9 +1615,9 @@ module_put:
 cls_session_fail:
 	scsi_remove_host(shost);
 add_host_fail:
-	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
+	iscsi_pool_free(&session->mgmtpool);
 mgmtpool_alloc_fail:
-	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
+	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
 	scsi_host_put(shost);
 	return NULL;
@@ -1635,8 +1640,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	iscsi_unblock_session(cls_session);
 	scsi_remove_host(shost);
 
-	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
-	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
+	iscsi_pool_free(&session->mgmtpool);
+	iscsi_pool_free(&session->cmdpool);
 
 	kfree(session->password);
 	kfree(session->password_in);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index a9a9e86..4b3e3c1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -215,7 +215,7 @@ struct iscsi_conn {
 	uint32_t		eh_abort_cnt;
 };
 
-struct iscsi_queue {
+struct iscsi_pool {
 	struct kfifo		*queue;		/* FIFO Queue */
 	void			**pool;		/* Pool of elements */
 	int			max;		/* Max number of elements */
@@ -274,10 +274,10 @@ struct iscsi_session {
 
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_cmd_task	**cmds;		/* Original Cmds arr */
-	struct iscsi_queue	cmdpool;	/* PDU's pool */
+	struct iscsi_pool	cmdpool;	/* PDU's pool */
 	int			mgmtpool_max;	/* size of mgmt array */
 	struct iscsi_mgmt_task	**mgmt_cmds;	/* Original mgmt arr */
-	struct iscsi_queue	mgmtpool;	/* Mgmt PDU's pool */
+	struct iscsi_pool	mgmtpool;	/* Mgmt PDU's pool */
 };
 
 /*
@@ -350,8 +350,8 @@ extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
 /*
  * generic helpers
  */
-extern void iscsi_pool_free(struct iscsi_queue *, void **);
-extern int iscsi_pool_init(struct iscsi_queue *, int, void ***, int);
+extern void iscsi_pool_free(struct iscsi_pool *);
+extern int iscsi_pool_init(struct iscsi_pool *, int, void ***, int);
 
 /*
  * inline functions to deal with padding.
-- 
1.5.1.2

