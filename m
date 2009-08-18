From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/27] zfcp: fix layering oddities between zfcp_fsf and zfcp_qdio
Date: Tue, 18 Aug 2009 15:43:13 +0200
Message-ID: <20090818135029.794391000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57157 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZHRNu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:29 -0400
Content-Disposition: inline; filename=709-zfcp-odd-layers.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

There is no need for the QDIO layer to have knowledge or do things
wich are done better by the FSF layer and vice versa.  Straighten a
few things to improve vividness.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ext.h  |    2 
 drivers/s390/scsi/zfcp_fsf.c  |  100 +++++++++++++++++++++++++++++-------------
 drivers/s390/scsi/zfcp_qdio.c |   45 ------------------
 3 files changed, 73 insertions(+), 74 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:13.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:17.000000000 +0200
@@ -133,11 +133,11 @@ extern int zfcp_fsf_send_ct(struct zfcp_
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
 extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
 					  struct scsi_cmnd *);
-extern void zfcp_fsf_req_complete(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
 extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *, u8);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long,
 						       struct zfcp_unit *);
+extern void zfcp_fsf_reqid_check(struct zfcp_adapter *, int);
 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_allocate(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:11.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:17.000000000 +0200
@@ -122,35 +122,6 @@ void zfcp_fsf_req_free(struct zfcp_fsf_r
 	}
 }
 
-/**
- * zfcp_fsf_req_dismiss_all - dismiss all fsf requests
- * @adapter: pointer to struct zfcp_adapter
- *
- * Never ever call this without shutting down the adapter first.
- * Otherwise the adapter would continue using and corrupting s390 storage.
- * Included BUG_ON() call to ensure this is done.
- * ERP is supposed to be the only user of this function.
- */
-void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
-{
-	struct zfcp_fsf_req *req, *tmp;
-	unsigned long flags;
-	LIST_HEAD(remove_queue);
-	unsigned int i;
-
-	BUG_ON(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP);
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	for (i = 0; i < REQUEST_LIST_SIZE; i++)
-		list_splice_init(&adapter->req_list[i], &remove_queue);
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-
-	list_for_each_entry_safe(req, tmp, &remove_queue, list) {
-		list_del(&req->list);
-		req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-		zfcp_fsf_req_complete(req);
-	}
-}
-
 static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
 {
 	struct fsf_status_read_buffer *sr_buf = req->data;
@@ -459,7 +430,7 @@ static void zfcp_fsf_protstatus_eval(str
  * is called to process the completion status and trigger further
  * events related to the FSF request.
  */
-void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
+static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 {
 	if (unlikely(req->fsf_command == FSF_QTCB_UNSOLICITED_STATUS)) {
 		zfcp_fsf_status_read_handler(req);
@@ -492,6 +463,35 @@ void zfcp_fsf_req_complete(struct zfcp_f
 		wake_up(&req->completion_wq);
 }
 
+/**
+ * zfcp_fsf_req_dismiss_all - dismiss all fsf requests
+ * @adapter: pointer to struct zfcp_adapter
+ *
+ * Never ever call this without shutting down the adapter first.
+ * Otherwise the adapter would continue using and corrupting s390 storage.
+ * Included BUG_ON() call to ensure this is done.
+ * ERP is supposed to be the only user of this function.
+ */
+void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
+{
+	struct zfcp_fsf_req *req, *tmp;
+	unsigned long flags;
+	LIST_HEAD(remove_queue);
+	unsigned int i;
+
+	BUG_ON(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP);
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	for (i = 0; i < REQUEST_LIST_SIZE; i++)
+		list_splice_init(&adapter->req_list[i], &remove_queue);
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+
+	list_for_each_entry_safe(req, tmp, &remove_queue, list) {
+		list_del(&req->list);
+		req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+		zfcp_fsf_req_complete(req);
+	}
+}
+
 static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 {
 	struct fsf_qtcb_bottom_config *bottom;
@@ -2578,3 +2578,43 @@ out:
 	}
 	return ERR_PTR(retval);
 }
+
+/**
+ * zfcp_fsf_reqid_check - validate req_id contained in SBAL returned by QDIO
+ * @adapter: pointer to struct zfcp_adapter
+ * @sbal_idx: response queue index of SBAL to be processed
+ */
+void zfcp_fsf_reqid_check(struct zfcp_adapter *adapter, int sbal_idx)
+{
+	struct qdio_buffer *sbal = adapter->resp_q.sbal[sbal_idx];
+	struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
+	unsigned long flags, req_id;
+	int idx;
+
+	for (idx = 0; idx < QDIO_MAX_ELEMENTS_PER_BUFFER; idx++) {
+
+		sbale = &sbal->element[idx];
+		req_id = (unsigned long) sbale->addr;
+		spin_lock_irqsave(&adapter->req_list_lock, flags);
+		fsf_req = zfcp_reqlist_find(adapter, req_id);
+
+		if (!fsf_req)
+			/*
+			 * Unknown request means that we have potentially memory
+			 * corruption and must stop the machine immediately.
+			 */
+			panic("error: unknown req_id (%lx) on adapter %s.\n",
+			      req_id, dev_name(&adapter->ccw_device->dev));
+
+		list_del(&fsf_req->list);
+		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
+
+		fsf_req->sbal_response = sbal_idx;
+		fsf_req->qdio_inb_usage = atomic_read(&adapter->resp_q.count);
+		zfcp_fsf_req_complete(fsf_req);
+
+		if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
+			break;
+	}
+}
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:29:17.000000000 +0200
@@ -112,31 +112,6 @@ static void zfcp_qdio_int_req(struct ccw
 	wake_up(&adapter->request_wq);
 }
 
-static void zfcp_qdio_reqid_check(struct zfcp_adapter *adapter,
-				  unsigned long req_id, int sbal_idx)
-{
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long flags;
-
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	fsf_req = zfcp_reqlist_find(adapter, req_id);
-
-	if (!fsf_req)
-		/*
-		 * Unknown request means that we have potentially memory
-		 * corruption and must stop the machine immediatly.
-		 */
-		panic("error: unknown request id (%lx) on adapter %s.\n",
-		      req_id, dev_name(&adapter->ccw_device->dev));
-
-	zfcp_reqlist_remove(adapter, fsf_req);
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-
-	fsf_req->sbal_response = sbal_idx;
-	fsf_req->qdio_inb_usage = atomic_read(&adapter->resp_q.count);
-	zfcp_fsf_req_complete(fsf_req);
-}
-
 static void zfcp_qdio_resp_put_back(struct zfcp_adapter *adapter, int processed)
 {
 	struct zfcp_qdio_queue *queue = &adapter->resp_q;
@@ -163,9 +138,7 @@ static void zfcp_qdio_int_resp(struct cc
 			       unsigned long parm)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
-	struct zfcp_qdio_queue *queue = &adapter->resp_q;
-	struct qdio_buffer_element *sbale;
-	int sbal_idx, sbale_idx, sbal_no;
+	int sbal_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
 		zfcp_hba_dbf_event_qdio(adapter, qdio_err, first, count);
@@ -179,22 +152,8 @@ static void zfcp_qdio_int_resp(struct cc
 	 */
 	for (sbal_no = 0; sbal_no < count; sbal_no++) {
 		sbal_idx = (first + sbal_no) % QDIO_MAX_BUFFERS_PER_Q;
-
 		/* go through all SBALEs of SBAL */
-		for (sbale_idx = 0; sbale_idx < QDIO_MAX_ELEMENTS_PER_BUFFER;
-		     sbale_idx++) {
-			sbale = zfcp_qdio_sbale(queue, sbal_idx, sbale_idx);
-			zfcp_qdio_reqid_check(adapter,
-					      (unsigned long) sbale->addr,
-					      sbal_idx);
-			if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
-				break;
-		};
-
-		if (unlikely(!(sbale->flags & SBAL_FLAGS_LAST_ENTRY)))
-			dev_warn(&adapter->ccw_device->dev,
-				 "A QDIO protocol error occurred, "
-				 "operations continue\n");
+		zfcp_fsf_reqid_check(adapter, sbal_idx);
 	}
 
 	/*

