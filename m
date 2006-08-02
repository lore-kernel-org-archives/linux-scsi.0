From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 1/3] zfcp: improve management of request IDs
Date: Wed, 2 Aug 2006 11:05:16 +0200
Message-ID: <20060802090516.GA11385@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:60257 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751202AbWHBJJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 05:09:13 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.7/8.13.7) with ESMTP id k7299Au7018884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 09:09:12 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k729CctK053894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 11:12:38 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k72999Er011742
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 11:09:10 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Volker Sameske <sameske@de.ibm.com>

From: Volker Sameske <sameske@de.ibm.com>

Improve request handling. Use hash table to manage request IDs.

Signed-off-by: Volker Sameske <sameske@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |  120 +++++++++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_ccw.c  |    5 ++
 drivers/s390/scsi/zfcp_def.h  |   11 ++--
 drivers/s390/scsi/zfcp_erp.c  |   16 ++---
 drivers/s390/scsi/zfcp_ext.h  |    6 ++
 drivers/s390/scsi/zfcp_fsf.c  |  122 ++++++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_qdio.c |   79 +++++++++++----------------
 7 files changed, 231 insertions(+), 128 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 9cd789b..adc9d8f 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -112,6 +112,105 @@ _zfcp_hex_dump(char *addr, int count)
 		printk("\n");
 }
 
+
+/****************************************************************/
+/****** Functions to handle the request ID hash table    ********/
+/****************************************************************/
+
+#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_FSF
+
+static int zfcp_reqlist_init(struct zfcp_adapter *adapter)
+{
+	int i;
+
+	adapter->req_list = kcalloc(REQUEST_LIST_SIZE, sizeof(struct list_head),
+				    GFP_KERNEL);
+
+	if (!adapter->req_list)
+		return -ENOMEM;
+
+	for (i=0; i<REQUEST_LIST_SIZE; i++)
+		INIT_LIST_HEAD(&adapter->req_list[i]);
+
+	return 0;
+}
+
+static void zfcp_reqlist_free(struct zfcp_adapter *adapter)
+{
+	struct zfcp_fsf_req *request, *tmp;
+	unsigned int i;
+
+	for (i=0; i<REQUEST_LIST_SIZE; i++) {
+		if (list_empty(&adapter->req_list[i]))
+			continue;
+
+		list_for_each_entry_safe(request, tmp,
+					 &adapter->req_list[i], list)
+			list_del(&request->list);
+	}
+
+	kfree(adapter->req_list);
+}
+
+void zfcp_reqlist_add(struct zfcp_adapter *adapter,
+		      struct zfcp_fsf_req *fsf_req)
+{
+	unsigned int i;
+
+	i = fsf_req->req_id % REQUEST_LIST_SIZE;
+	list_add_tail(&fsf_req->list, &adapter->req_list[i]);
+}
+
+void zfcp_reqlist_remove(struct zfcp_adapter *adapter, unsigned long req_id)
+{
+	struct zfcp_fsf_req *request, *tmp;
+	unsigned int i, counter;
+	u64 dbg_tmp[2];
+
+	i = req_id % REQUEST_LIST_SIZE;
+	BUG_ON(list_empty(&adapter->req_list[i]));
+
+	counter = 0;
+	list_for_each_entry_safe(request, tmp, &adapter->req_list[i], list) {
+		if (request->req_id == req_id) {
+			dbg_tmp[0] = (u64) atomic_read(&adapter->reqs_active);
+			dbg_tmp[1] = (u64) counter;
+			debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
+			list_del(&request->list);
+			break;
+		}
+		counter++;
+	}
+}
+
+struct zfcp_fsf_req *zfcp_reqlist_ismember(struct zfcp_adapter *adapter,
+					   unsigned long req_id)
+{
+	struct zfcp_fsf_req *request, *tmp;
+	unsigned int i;
+
+	i = req_id % REQUEST_LIST_SIZE;
+
+	list_for_each_entry_safe(request, tmp, &adapter->req_list[i], list)
+		if (request->req_id == req_id)
+			return request;
+
+	return NULL;
+}
+
+int zfcp_reqlist_isempty(struct zfcp_adapter *adapter)
+{
+	unsigned int i;
+
+	for (i=0; i<REQUEST_LIST_SIZE; i++)
+		if (!list_empty(&adapter->req_list[i]))
+			return 0;
+
+	return 1;
+}
+
+#undef ZFCP_LOG_AREA
+
 /****************************************************************/
 /************** Uncategorised Functions *************************/
 /****************************************************************/
@@ -961,8 +1060,12 @@ zfcp_adapter_enqueue(struct ccw_device *
 	INIT_LIST_HEAD(&adapter->port_remove_lh);
 
 	/* initialize list of fsf requests */
-	spin_lock_init(&adapter->fsf_req_list_lock);
-	INIT_LIST_HEAD(&adapter->fsf_req_list_head);
+	spin_lock_init(&adapter->req_list_lock);
+	retval = zfcp_reqlist_init(adapter);
+	if (retval) {
+		ZFCP_LOG_INFO("request list initialization failed\n");
+		goto failed_low_mem_buffers;
+	}
 
 	/* initialize debug locks */
 
@@ -1041,8 +1144,6 @@ zfcp_adapter_enqueue(struct ccw_device *
  *		!0 - struct zfcp_adapter  data structure could not be removed
  *			(e.g. still used)
  * locks:	adapter list write lock is assumed to be held by caller
- *              adapter->fsf_req_list_lock is taken and released within this 
- *              function and must not be held on entry
  */
 void
 zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
@@ -1054,14 +1155,14 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
-	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-	retval = !list_empty(&adapter->fsf_req_list_head);
-	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-	if (retval) {
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	retval = zfcp_reqlist_isempty(adapter);
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+	if (!retval) {
 		ZFCP_LOG_NORMAL("bug: adapter %s (%p) still in use, "
 				"%i requests outstanding\n",
 				zfcp_get_busid_by_adapter(adapter), adapter,
-				atomic_read(&adapter->fsf_reqs_active));
+				atomic_read(&adapter->reqs_active));
 		retval = -EBUSY;
 		goto out;
 	}
@@ -1087,6 +1188,7 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	zfcp_free_low_mem_buffers(adapter);
 	/* free memory of adapter data structure and queues */
 	zfcp_qdio_free_queues(adapter);
+	zfcp_reqlist_free(adapter);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
 	ZFCP_LOG_TRACE("freeing adapter structure\n");
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index 57d8e4b..fdabade 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -164,6 +164,11 @@ zfcp_ccw_set_online(struct ccw_device *c
 	retval = zfcp_adapter_scsi_register(adapter);
 	if (retval)
 		goto out_scsi_register;
+
+	/* initialize request counter */
+	BUG_ON(!zfcp_reqlist_isempty(adapter));
+	adapter->req_no = 0;
+
 	zfcp_erp_modify_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING,
 				       ZFCP_SET);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 2df512a..72293f3 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -886,11 +886,11 @@ struct zfcp_adapter {
 	struct list_head        port_remove_lh;    /* head of ports to be
 						      removed */
 	u32			ports;	           /* number of remote ports */
-        struct timer_list       scsi_er_timer;     /* SCSI err recovery watch */
-	struct list_head	fsf_req_list_head; /* head of FSF req list */
-	spinlock_t		fsf_req_list_lock; /* lock for ops on list of
-						      FSF requests */
-        atomic_t       		fsf_reqs_active;   /* # active FSF reqs */
+	struct timer_list	scsi_er_timer;     /* SCSI err recovery watch */
+	atomic_t		reqs_active;	   /* # active FSF reqs */
+	unsigned long		req_no;		   /* unique FSF req number */
+	struct list_head	*req_list;	   /* list of pending reqs */
+	spinlock_t		req_list_lock;	   /* request list lock */
 	struct zfcp_qdio_queue	request_queue;	   /* request queue */
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	wait_queue_head_t	request_wq;	   /* can be used to wait for
@@ -986,6 +986,7 @@ struct zfcp_unit {
 /* FSF request */
 struct zfcp_fsf_req {
 	struct list_head       list;	       /* list of FSF requests */
+	unsigned long	       req_id;	       /* unique request ID */
 	struct zfcp_adapter    *adapter;       /* adapter request belongs to */
 	u8		       sbal_number;    /* nr of SBALs free for use */
 	u8		       sbal_first;     /* first SBAL for this request */
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 8ec8da0..f74412b 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -848,18 +848,16 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	if (erp_action->fsf_req) {
-		/* take lock to ensure that request is not being deleted meanwhile */
-		spin_lock(&adapter->fsf_req_list_lock);
-		/* check whether fsf req does still exist */
-		list_for_each_entry(fsf_req, &adapter->fsf_req_list_head, list)
-		    if (fsf_req == erp_action->fsf_req)
-			break;
-		if (fsf_req && (fsf_req->erp_action == erp_action)) {
+		/* take lock to ensure that request is not deleted meanwhile */
+		spin_lock(&adapter->req_list_lock);
+		if ((!zfcp_reqlist_ismember(adapter,
+					    erp_action->fsf_req->req_id)) &&
+		    (fsf_req->erp_action == erp_action)) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
 			debug_event(adapter->erp_dbf, 3, &fsf_req,
 				    sizeof (unsigned long));
-			/* dismiss fsf_req of timed out or dismissed erp_action */
+			/* dismiss fsf_req of timed out/dismissed erp_action */
 			if (erp_action->status & (ZFCP_STATUS_ERP_DISMISSED |
 						  ZFCP_STATUS_ERP_TIMEDOUT)) {
 				debug_text_event(adapter->erp_dbf, 3,
@@ -892,7 +890,7 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 			 */
 			erp_action->fsf_req = NULL;
 		}
-		spin_unlock(&adapter->fsf_req_list_lock);
+		spin_unlock(&adapter->req_list_lock);
 	} else
 		debug_text_event(adapter->erp_dbf, 3, "a_ca_noreq");
 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index d023660..04bb3a9 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -63,7 +63,6 @@ extern int  zfcp_qdio_allocate_queues(st
 extern void zfcp_qdio_free_queues(struct zfcp_adapter *);
 extern int  zfcp_qdio_determine_pci(struct zfcp_qdio_queue *,
 				    struct zfcp_fsf_req *);
-extern int  zfcp_qdio_reqid_check(struct zfcp_adapter *, void *);
 
 extern volatile struct qdio_buffer_element *zfcp_qdio_sbale_req
 	(struct zfcp_fsf_req *, int, int);
@@ -190,5 +189,10 @@ extern void zfcp_scsi_dbf_event_abort(co
 				      struct zfcp_fsf_req *);
 extern void zfcp_scsi_dbf_event_devreset(const char *, u8, struct zfcp_unit *,
 					 struct scsi_cmnd *);
+extern void zfcp_reqlist_add(struct zfcp_adapter *, struct zfcp_fsf_req *);
+extern void zfcp_reqlist_remove(struct zfcp_adapter *, unsigned long);
+extern struct zfcp_fsf_req *zfcp_reqlist_ismember(struct zfcp_adapter *,
+						  unsigned long);
+extern int zfcp_reqlist_isempty(struct zfcp_adapter *);
 
 #endif	/* ZFCP_EXT_H */
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 31db2b0..ff2eacf 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -49,7 +49,6 @@ static int zfcp_fsf_fsfstatus_qual_eval(
 static void zfcp_fsf_link_down_info_eval(struct zfcp_adapter *,
 	struct fsf_link_down_info *);
 static int zfcp_fsf_req_dispatch(struct zfcp_fsf_req *);
-static void zfcp_fsf_req_dismiss(struct zfcp_fsf_req *);
 
 /* association between FSF command and FSF QTCB type */
 static u32 fsf_qtcb_type[] = {
@@ -146,47 +145,48 @@ zfcp_fsf_req_free(struct zfcp_fsf_req *f
 		kfree(fsf_req);
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- *
- * note: qdio queues shall be down (no ongoing inbound processing)
+/**
+ * zfcp_fsf_req_dismiss - dismiss a single fsf request
  */
-int
-zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
+static void zfcp_fsf_req_dismiss(struct zfcp_adapter *adapter,
+				 struct zfcp_fsf_req *fsf_req,
+				 unsigned int counter)
 {
-	struct zfcp_fsf_req *fsf_req, *tmp;
-	unsigned long flags;
-	LIST_HEAD(remove_queue);
+	u64 dbg_tmp[2];
 
-	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-	list_splice_init(&adapter->fsf_req_list_head, &remove_queue);
-	atomic_set(&adapter->fsf_reqs_active, 0);
-	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-
-	list_for_each_entry_safe(fsf_req, tmp, &remove_queue, list) {
-		list_del(&fsf_req->list);
-		zfcp_fsf_req_dismiss(fsf_req);
-	}
-
-	return 0;
+	dbg_tmp[0] = (u64) atomic_read(&adapter->reqs_active);
+	dbg_tmp[1] = (u64) counter;
+	debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
+	list_del(&fsf_req->list);
+	fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+	zfcp_fsf_req_complete(fsf_req);
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
+/**
+ * zfcp_fsf_req_dismiss_all - dismiss all remaining fsf requests
  */
-static void
-zfcp_fsf_req_dismiss(struct zfcp_fsf_req *fsf_req)
+int zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
-	fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-	zfcp_fsf_req_complete(fsf_req);
+	struct zfcp_fsf_req *request, *tmp;
+	unsigned long flags;
+	unsigned int i, counter;
+
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	atomic_set(&adapter->reqs_active, 0);
+	for (i=0; i<REQUEST_LIST_SIZE; i++) {
+		if (list_empty(&adapter->req_list[i]))
+			continue;
+
+		counter = 0;
+		list_for_each_entry_safe(request, tmp,
+					 &adapter->req_list[i], list) {
+			zfcp_fsf_req_dismiss(adapter, request, counter);
+			counter++;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+
+	return 0;
 }
 
 /*
@@ -4592,12 +4592,14 @@ static inline void
 zfcp_fsf_req_qtcb_init(struct zfcp_fsf_req *fsf_req)
 {
 	if (likely(fsf_req->qtcb != NULL)) {
-		fsf_req->qtcb->prefix.req_seq_no = fsf_req->adapter->fsf_req_seq_no;
-		fsf_req->qtcb->prefix.req_id = (unsigned long)fsf_req;
+		fsf_req->qtcb->prefix.req_seq_no =
+			fsf_req->adapter->fsf_req_seq_no;
+		fsf_req->qtcb->prefix.req_id = fsf_req->req_id;
 		fsf_req->qtcb->prefix.ulp_info = ZFCP_ULP_INFO_VERSION;
-		fsf_req->qtcb->prefix.qtcb_type = fsf_qtcb_type[fsf_req->fsf_command];
+		fsf_req->qtcb->prefix.qtcb_type =
+			fsf_qtcb_type[fsf_req->fsf_command];
 		fsf_req->qtcb->prefix.qtcb_version = ZFCP_QTCB_VERSION;
-		fsf_req->qtcb->header.req_handle = (unsigned long)fsf_req;
+		fsf_req->qtcb->header.req_handle = fsf_req->req_id;
 		fsf_req->qtcb->header.fsf_command = fsf_req->fsf_command;
 	}
 }
@@ -4654,6 +4656,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 {
 	volatile struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req = NULL;
+	unsigned long flags;
 	int ret = 0;
 	struct zfcp_qdio_queue *req_queue = &adapter->request_queue;
 
@@ -4668,6 +4671,12 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 
 	fsf_req->adapter = adapter;
 	fsf_req->fsf_command = fsf_cmd;
+	INIT_LIST_HEAD(&fsf_req->list);
+	
+	/* unique request id */
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	fsf_req->req_id = adapter->req_no++;
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
         zfcp_fsf_req_qtcb_init(fsf_req);
 
@@ -4707,7 +4716,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
 
 	/* setup common SBALE fields */
-	sbale[0].addr = fsf_req;
+	sbale[0].addr = (void *) fsf_req->req_id;
 	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 	if (likely(fsf_req->qtcb != NULL)) {
 		sbale[1].addr = (void *) fsf_req->qtcb;
@@ -4747,7 +4756,7 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	volatile struct qdio_buffer_element *sbale;
 	int inc_seq_no;
 	int new_distance_from_int;
-	unsigned long flags;
+	u64 dbg_tmp[2];
 	int retval = 0;
 
 	adapter = fsf_req->adapter;
@@ -4761,10 +4770,10 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, (char *) sbale[1].addr,
 		      sbale[1].length);
 
-	/* put allocated FSF request at list tail */
-	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-	list_add_tail(&fsf_req->list, &adapter->fsf_req_list_head);
-	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
+	/* put allocated FSF request into hash table */
+	spin_lock(&adapter->req_list_lock);
+	zfcp_reqlist_add(adapter, fsf_req);
+	spin_unlock(&adapter->req_list_lock);
 
 	inc_seq_no = (fsf_req->qtcb != NULL);
 
@@ -4803,6 +4812,10 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 			 QDIO_FLAG_SYNC_OUTPUT,
 			 0, fsf_req->sbal_first, fsf_req->sbal_number, NULL);
 
+	dbg_tmp[0] = (unsigned long) sbale[0].addr;
+	dbg_tmp[1] = (u64) retval;
+	debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
+
 	if (unlikely(retval)) {
 		/* Queues are down..... */
 		retval = -EIO;
@@ -4812,22 +4825,17 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 		 */
 		if (timer)
 			del_timer(timer);
-		spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-		list_del(&fsf_req->list);
-		spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-		/*
-		 * adjust the number of free SBALs in request queue as well as
-		 * position of first one
-		 */
+		spin_lock(&adapter->req_list_lock);
+		zfcp_reqlist_remove(adapter, fsf_req->req_id);
+		spin_unlock(&adapter->req_list_lock);
+		/* undo changes in request queue made for this request */
 		zfcp_qdio_zero_sbals(req_queue->buffer,
 				     fsf_req->sbal_first, fsf_req->sbal_number);
 		atomic_add(fsf_req->sbal_number, &req_queue->free_count);
-		req_queue->free_index -= fsf_req->sbal_number;	 /* increase */
+		req_queue->free_index -= fsf_req->sbal_number;
 		req_queue->free_index += QDIO_MAX_BUFFERS_PER_Q;
 		req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
-		ZFCP_LOG_DEBUG
-			("error: do_QDIO failed. Buffers could not be enqueued "
-			 "to request queue.\n");
+		zfcp_erp_adapter_reopen(adapter, 0);
 	} else {
 		req_queue->distance_from_int = new_distance_from_int;
 		/*
@@ -4843,7 +4851,7 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 			adapter->fsf_req_seq_no++;
 
 		/* count FSF requests pending */
-		atomic_inc(&adapter->fsf_reqs_active);
+		atomic_inc(&adapter->reqs_active);
 	}
 	return retval;
 }
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 49ea5ad..dbd9f48 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -282,6 +282,37 @@ zfcp_qdio_request_handler(struct ccw_dev
 	return;
 }
 
+/**
+ * zfcp_qdio_reqid_check - checks for valid reqids or unsolicited status
+ */
+static int zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, 
+				 unsigned long req_id)
+{
+	struct zfcp_fsf_req *fsf_req;
+	unsigned long flags;
+
+	debug_long_event(adapter->erp_dbf, 4, req_id);
+
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	fsf_req = zfcp_reqlist_ismember(adapter, req_id);
+
+	if (!fsf_req) {
+		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+		ZFCP_LOG_NORMAL("error: unknown request id (%ld).\n", req_id);
+		zfcp_erp_adapter_reopen(adapter, 0);
+		return -EINVAL;
+	}
+
+	zfcp_reqlist_remove(adapter, req_id);
+	atomic_dec(&adapter->reqs_active);
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+
+	/* finish the FSF request */
+	zfcp_fsf_req_complete(fsf_req);
+
+	return 0;
+}
+
 /*
  * function:   	zfcp_qdio_response_handler
  *
@@ -344,7 +375,7 @@ zfcp_qdio_response_handler(struct ccw_de
 			/* look for QDIO request identifiers in SB */
 			buffere = &buffer->element[buffere_index];
 			retval = zfcp_qdio_reqid_check(adapter,
-						       (void *) buffere->addr);
+					(unsigned long) buffere->addr);
 
 			if (retval) {
 				ZFCP_LOG_NORMAL("bug: unexpected inbound "
@@ -415,52 +446,6 @@ zfcp_qdio_response_handler(struct ccw_de
 	return;
 }
 
-/*
- * function:	zfcp_qdio_reqid_check
- *
- * purpose:	checks for valid reqids or unsolicited status
- *
- * returns:	0 - valid request id or unsolicited status
- *		!0 - otherwise
- */
-int
-zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, void *sbale_addr)
-{
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long flags;
-
-	/* invalid (per convention used in this driver) */
-	if (unlikely(!sbale_addr)) {
-		ZFCP_LOG_NORMAL("bug: invalid reqid\n");
-		return -EINVAL;
-	}
-
-	/* valid request id and thus (hopefully :) valid fsf_req address */
-	fsf_req = (struct zfcp_fsf_req *) sbale_addr;
-
-	/* serialize with zfcp_fsf_req_dismiss_all */
-	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-	if (list_empty(&adapter->fsf_req_list_head)) {
-		spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-		return 0;
-	}
-	list_del(&fsf_req->list);
-	atomic_dec(&adapter->fsf_reqs_active);
-	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-
-	if (unlikely(adapter != fsf_req->adapter)) {
-		ZFCP_LOG_NORMAL("bug: invalid reqid (fsf_req=%p, "
-				"fsf_req->adapter=%p, adapter=%p)\n",
-				fsf_req, fsf_req->adapter, adapter);
-		return -EINVAL;
-	}
-
-	/* finish the FSF request */
-	zfcp_fsf_req_complete(fsf_req);
-
-	return 0;
-}
-
 /**
  * zfcp_qdio_sbale_get - return pointer to SBALE of qdio_queue
  * @queue: queue from which SBALE should be returned
-- 
1.4.2.rc2.gef1d9

