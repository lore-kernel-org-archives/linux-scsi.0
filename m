From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/11] zfcp: Move FSF request tracking code to new file
Date: Wed, 17 Feb 2010 11:18:50 +0100
Message-ID: <20100217102018.152432000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:46624 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0BQKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:23 -0500
Content-Disposition: inline; filename=701-zfcp-fsf-tracking.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the code for tracking FSF requests to new file to have this code
in one place. The functions for adding and removing requests on the
I/O path are already inline. The alloc and free functions are only
called once, so it does not hurt to inline them and add them to the
same file.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c     |   36 -------
 drivers/s390/scsi/zfcp_ccw.c     |    3 
 drivers/s390/scsi/zfcp_def.h     |   34 -------
 drivers/s390/scsi/zfcp_erp.c     |    7 -
 drivers/s390/scsi/zfcp_ext.h     |    1 
 drivers/s390/scsi/zfcp_fsf.c     |   32 +-----
 drivers/s390/scsi/zfcp_reqlist.h |  183 +++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_scsi.c    |    5 -
 8 files changed, 203 insertions(+), 98 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-02-16 09:43:29.000000000 +0100
@@ -32,6 +32,7 @@
 #include <linux/seq_file.h>
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
+#include "zfcp_reqlist.h"
 
 #define ZFCP_BUS_ID_SIZE	20
 
@@ -49,36 +50,6 @@ static struct kmem_cache *zfcp_cache_hw_
 	return kmem_cache_create(name, size, roundup_pow_of_two(size), 0, NULL);
 }
 
-static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
-{
-	int idx;
-
-	adapter->req_list = kcalloc(REQUEST_LIST_SIZE, sizeof(struct list_head),
-				    GFP_KERNEL);
-	if (!adapter->req_list)
-		return -ENOMEM;
-
-	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++)
-		INIT_LIST_HEAD(&adapter->req_list[idx]);
-	return 0;
-}
-
-/**
- * zfcp_reqlist_isempty - is the request list empty
- * @adapter: pointer to struct zfcp_adapter
- *
- * Returns: true if list is empty, false otherwise
- */
-int zfcp_reqlist_isempty(struct zfcp_adapter *adapter)
-{
-	unsigned int idx;
-
-	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++)
-		if (!list_empty(&adapter->req_list[idx]))
-			return 0;
-	return 1;
-}
-
 static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 {
 	struct ccw_device *cdev;
@@ -539,7 +510,8 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 	if (zfcp_allocate_low_mem_buffers(adapter))
 		goto failed;
 
-	if (zfcp_reqlist_alloc(adapter))
+	adapter->req_list = zfcp_reqlist_alloc();
+	if (!adapter->req_list)
 		goto failed;
 
 	if (zfcp_dbf_adapter_register(adapter))
@@ -560,8 +532,6 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 	INIT_LIST_HEAD(&adapter->erp_ready_head);
 	INIT_LIST_HEAD(&adapter->erp_running_head);
 
-	spin_lock_init(&adapter->req_list_lock);
-
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2010-02-16 09:43:29.000000000 +0100
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include "zfcp_ext.h"
+#include "zfcp_reqlist.h"
 
 #define ZFCP_MODEL_PRIV 0x4
 
@@ -162,7 +163,7 @@ static int zfcp_ccw_set_online(struct cc
 	}
 
 	/* initialize request counter */
-	BUG_ON(!zfcp_reqlist_isempty(adapter));
+	BUG_ON(!zfcp_reqlist_isempty(adapter->req_list));
 	adapter->req_no = 0;
 
 	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:29.000000000 +0100
@@ -39,9 +39,7 @@
 #include <asm/sysinfo.h>
 #include "zfcp_fsf.h"
 
-/********************* GENERAL DEFINES *********************************/
-
-#define REQUEST_LIST_SIZE 128
+struct zfcp_reqlist;
 
 /********************* SCSI SPECIFIC DEFINES *********************************/
 #define ZFCP_SCSI_ER_TIMEOUT                    (10*HZ)
@@ -206,8 +204,7 @@ struct zfcp_adapter {
 	struct list_head	port_list;	   /* remote port list */
 	rwlock_t		port_list_lock;    /* port list lock */
 	unsigned long		req_no;		   /* unique FSF req number */
-	struct list_head	*req_list;	   /* list of pending reqs */
-	spinlock_t		req_list_lock;	   /* request list lock */
+	struct zfcp_reqlist	*req_list;
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	rwlock_t		abort_lock;        /* Protects against SCSI
 						      stack abort/command
@@ -351,31 +348,4 @@ struct zfcp_data {
 #define ZFCP_SET                0x00000100
 #define ZFCP_CLEAR              0x00000200
 
-/*
- * Helper functions for request ID management.
- */
-static inline int zfcp_reqlist_hash(unsigned long req_id)
-{
-	return req_id % REQUEST_LIST_SIZE;
-}
-
-static inline void zfcp_reqlist_remove(struct zfcp_adapter *adapter,
-				       struct zfcp_fsf_req *fsf_req)
-{
-	list_del(&fsf_req->list);
-}
-
-static inline struct zfcp_fsf_req *
-zfcp_reqlist_find(struct zfcp_adapter *adapter, unsigned long req_id)
-{
-	struct zfcp_fsf_req *request;
-	unsigned int idx;
-
-	idx = zfcp_reqlist_hash(req_id);
-	list_for_each_entry(request, &adapter->req_list[idx], list)
-		if (request->req_id == req_id)
-			return request;
-	return NULL;
-}
-
 #endif /* ZFCP_DEF_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:29.000000000 +0100
@@ -11,6 +11,7 @@
 
 #include <linux/kthread.h>
 #include "zfcp_ext.h"
+#include "zfcp_reqlist.h"
 
 #define ZFCP_MAX_ERPS                   3
 
@@ -483,8 +484,8 @@ static void zfcp_erp_strategy_check_fsfr
 	if (!act->fsf_req_id)
 		return;
 
-	spin_lock(&adapter->req_list_lock);
-	req = zfcp_reqlist_find(adapter, act->fsf_req_id);
+	spin_lock(&adapter->req_list->lock);
+	req = _zfcp_reqlist_find(adapter->req_list, act->fsf_req_id);
 	if (req && req->erp_action == act) {
 		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
@@ -498,7 +499,7 @@ static void zfcp_erp_strategy_check_fsfr
 			act->fsf_req_id = 0;
 	} else
 		act->fsf_req_id = 0;
-	spin_unlock(&adapter->req_list_lock);
+	spin_unlock(&adapter->req_list->lock);
 }
 
 /**
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-02-16 09:43:29.000000000 +0100
@@ -21,7 +21,6 @@ extern struct zfcp_adapter *zfcp_adapter
 extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
 extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, u64);
-extern int zfcp_reqlist_isempty(struct zfcp_adapter *);
 extern void zfcp_sg_free_table(struct scatterlist *, int);
 extern int zfcp_sg_setup_table(struct scatterlist *, int);
 extern void zfcp_device_unregister(struct device *,
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:29.000000000 +0100
@@ -14,6 +14,7 @@
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 #include "zfcp_dbf.h"
+#include "zfcp_reqlist.h"
 
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
@@ -457,15 +458,10 @@ static void zfcp_fsf_req_complete(struct
 void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_req *req, *tmp;
-	unsigned long flags;
 	LIST_HEAD(remove_queue);
-	unsigned int i;
 
 	BUG_ON(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP);
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	for (i = 0; i < REQUEST_LIST_SIZE; i++)
-		list_splice_init(&adapter->req_list[i], &remove_queue);
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+	zfcp_reqlist_move(adapter->req_list, &remove_queue);
 
 	list_for_each_entry_safe(req, tmp, &remove_queue, list) {
 		list_del(&req->list);
@@ -770,27 +766,17 @@ static int zfcp_fsf_req_send(struct zfcp
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
-	unsigned long	     flags;
-	int		     idx;
-	int		     with_qtcb = (req->qtcb != NULL);
+	int with_qtcb = (req->qtcb != NULL);
 	int req_id = req->req_id;
 
-	/* put allocated FSF request into hash table */
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	idx = zfcp_reqlist_hash(req_id);
-	list_add_tail(&req->list, &adapter->req_list[idx]);
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+	zfcp_reqlist_add(adapter->req_list, req);
 
 	req->queue_req.qdio_outb_usage = atomic_read(&qdio->req_q.count);
 	req->issued = get_clock();
 	if (zfcp_qdio_send(qdio, &req->queue_req)) {
 		del_timer(&req->timer);
-		spin_lock_irqsave(&adapter->req_list_lock, flags);
 		/* lookup request again, list might have changed */
-		req = zfcp_reqlist_find(adapter, req_id);
-		if (req)
-			zfcp_reqlist_remove(adapter, req);
-		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+		zfcp_reqlist_find_rm(adapter->req_list, req_id);
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1", req);
 		return -EIO;
 	}
@@ -2518,15 +2504,14 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 	struct qdio_buffer *sbal = qdio->resp_q.sbal[sbal_idx];
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req;
-	unsigned long flags, req_id;
+	unsigned long req_id;
 	int idx;
 
 	for (idx = 0; idx < QDIO_MAX_ELEMENTS_PER_BUFFER; idx++) {
 
 		sbale = &sbal->element[idx];
 		req_id = (unsigned long) sbale->addr;
-		spin_lock_irqsave(&adapter->req_list_lock, flags);
-		fsf_req = zfcp_reqlist_find(adapter, req_id);
+		fsf_req = zfcp_reqlist_find_rm(adapter->req_list, req_id);
 
 		if (!fsf_req)
 			/*
@@ -2536,9 +2521,6 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 			panic("error: unknown req_id (%lx) on adapter %s.\n",
 			      req_id, dev_name(&adapter->ccw_device->dev));
 
-		list_del(&fsf_req->list);
-		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-
 		fsf_req->queue_req.sbal_response = sbal_idx;
 		fsf_req->queue_req.qdio_inb_usage =
 			atomic_read(&qdio->resp_q.count);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_reqlist.h linux-2.6-patched/drivers/s390/scsi/zfcp_reqlist.h
--- linux-2.6/drivers/s390/scsi/zfcp_reqlist.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_reqlist.h	2010-02-16 09:43:29.000000000 +0100
@@ -0,0 +1,183 @@
+/*
+ * zfcp device driver
+ *
+ * Data structure and helper functions for tracking pending FSF
+ * requests.
+ *
+ * Copyright IBM Corporation 2009
+ */
+
+#ifndef ZFCP_REQLIST_H
+#define ZFCP_REQLIST_H
+
+/* number of hash buckets */
+#define ZFCP_REQ_LIST_BUCKETS 128
+
+/**
+ * struct zfcp_reqlist - Container for request list (reqlist)
+ * @lock: Spinlock for protecting the hash list
+ * @list: Array of hashbuckets, each is a list of requests in this bucket
+ */
+struct zfcp_reqlist {
+	spinlock_t lock;
+	struct list_head buckets[ZFCP_REQ_LIST_BUCKETS];
+};
+
+static inline int zfcp_reqlist_hash(unsigned long req_id)
+{
+	return req_id % ZFCP_REQ_LIST_BUCKETS;
+}
+
+/**
+ * zfcp_reqlist_alloc - Allocate and initialize reqlist
+ *
+ * Returns pointer to allocated reqlist on success, or NULL on
+ * allocation failure.
+ */
+static inline struct zfcp_reqlist *zfcp_reqlist_alloc(void)
+{
+	unsigned int i;
+	struct zfcp_reqlist *rl;
+
+	rl = kzalloc(sizeof(struct zfcp_reqlist), GFP_KERNEL);
+	if (!rl)
+		return NULL;
+
+	spin_lock_init(&rl->lock);
+
+	for (i = 0; i < ZFCP_REQ_LIST_BUCKETS; i++)
+		INIT_LIST_HEAD(&rl->buckets[i]);
+
+	return rl;
+}
+
+/**
+ * zfcp_reqlist_isempty - Check whether the request list empty
+ * @rl: pointer to reqlist
+ *
+ * Returns: 1 if list is empty, 0 if not
+ */
+static inline int zfcp_reqlist_isempty(struct zfcp_reqlist *rl)
+{
+	unsigned int i;
+
+	for (i = 0; i < ZFCP_REQ_LIST_BUCKETS; i++)
+		if (!list_empty(&rl->buckets[i]))
+			return 0;
+	return 1;
+}
+
+/**
+ * zfcp_reqlist_free - Free allocated memory for reqlist
+ * @rl: The reqlist where to free memory
+ */
+static inline void zfcp_reqlist_free(struct zfcp_reqlist *rl)
+{
+	/* sanity check */
+	BUG_ON(!zfcp_reqlist_isempty(rl));
+
+	kfree(rl);
+}
+
+static inline struct zfcp_fsf_req *
+_zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
+{
+	struct zfcp_fsf_req *req;
+	unsigned int i;
+
+	i = zfcp_reqlist_hash(req_id);
+	list_for_each_entry(req, &rl->buckets[i], list)
+		if (req->req_id == req_id)
+			return req;
+	return NULL;
+}
+
+/**
+ * zfcp_reqlist_find - Lookup FSF request by its request id
+ * @rl: The reqlist where to lookup the FSF request
+ * @req_id: The request id to look for
+ *
+ * Returns a pointer to the FSF request with the specified request id
+ * or NULL if there is no known FSF request with this id.
+ */
+static inline struct zfcp_fsf_req *
+zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
+{
+	unsigned long flags;
+	struct zfcp_fsf_req *req;
+
+	spin_lock_irqsave(&rl->lock, flags);
+	req = _zfcp_reqlist_find(rl, req_id);
+	spin_unlock_irqrestore(&rl->lock, flags);
+
+	return req;
+}
+
+/**
+ * zfcp_reqlist_find_rm - Lookup request by id and remove it from reqlist
+ * @rl: reqlist where to search and remove entry
+ * @req_id: The request id of the request to look for
+ *
+ * This functions tries to find the FSF request with the specified
+ * id and then removes it from the reqlist. The reqlist lock is held
+ * during both steps of the operation.
+ *
+ * Returns: Pointer to the FSF request if the request has been found,
+ * NULL if it has not been found.
+ */
+static inline struct zfcp_fsf_req *
+zfcp_reqlist_find_rm(struct zfcp_reqlist *rl, unsigned long req_id)
+{
+	unsigned long flags;
+	struct zfcp_fsf_req *req;
+
+	spin_lock_irqsave(&rl->lock, flags);
+	req = _zfcp_reqlist_find(rl, req_id);
+	if (req)
+		list_del(&req->list);
+	spin_unlock_irqrestore(&rl->lock, flags);
+
+	return req;
+}
+
+/**
+ * zfcp_reqlist_add - Add entry to reqlist
+ * @rl: reqlist where to add the entry
+ * @req: The entry to add
+ *
+ * The request id always increases. As an optimization new requests
+ * are added here with list_add_tail at the end of the bucket lists
+ * while old requests are looked up starting at the beginning of the
+ * lists.
+ */
+static inline void zfcp_reqlist_add(struct zfcp_reqlist *rl,
+				    struct zfcp_fsf_req *req)
+{
+	unsigned int i;
+	unsigned long flags;
+
+	i = zfcp_reqlist_hash(req->req_id);
+
+	spin_lock_irqsave(&rl->lock, flags);
+	list_add_tail(&req->list, &rl->buckets[i]);
+	spin_unlock_irqrestore(&rl->lock, flags);
+}
+
+/**
+ * zfcp_reqlist_move - Move all entries from reqlist to simple list
+ * @rl: The zfcp_reqlist where to remove all entries
+ * @list: The list where to move all entries
+ */
+static inline void zfcp_reqlist_move(struct zfcp_reqlist *rl,
+				     struct list_head *list)
+{
+	unsigned int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rl->lock, flags);
+	for (i = 0; i < ZFCP_REQ_LIST_BUCKETS; i++)
+		list_splice_init(&rl->buckets[i], list);
+	spin_unlock_irqrestore(&rl->lock, flags);
+}
+
+#endif /* ZFCP_REQLIST_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:29.000000000 +0100
@@ -15,6 +15,7 @@
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
 #include "zfcp_fc.h"
+#include "zfcp_reqlist.h"
 
 static unsigned int default_depth = 32;
 module_param_named(queue_depth, default_depth, uint, 0600);
@@ -189,9 +190,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
-	spin_lock(&adapter->req_list_lock);
-	old_req = zfcp_reqlist_find(adapter, old_reqid);
-	spin_unlock(&adapter->req_list_lock);
+	old_req = zfcp_reqlist_find(adapter->req_list, old_reqid);
 	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_dbf_scsi_abort("lte1", adapter->dbf, scpnt, NULL,

