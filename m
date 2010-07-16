From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/10] zfcp: Cleanup QDIO attachment and improve processing.
Date: Fri, 16 Jul 2010 15:37:38 +0200
Message-ID: <20100716134300.427228000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43153 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497Ab0GPNnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:04 -0400
Content-Disposition: inline; filename=709-zfcp-qdio-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Some definitions and structures in the zfcp QDIO processing are
improved by the removal of not required variables and processing steps.
I addition the naming of some variables is changed to make their purpose
more clear.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |   10 +-
 drivers/s390/scsi/zfcp_qdio.c |  141 ++++++++++++++----------------------------
 drivers/s390/scsi/zfcp_qdio.h |   57 +++++-----------
 3 files changed, 69 insertions(+), 139 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -732,7 +732,7 @@ static int zfcp_fsf_req_send(struct zfcp
 
 	zfcp_reqlist_add(adapter->req_list, req);
 
-	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q.count);
+	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q_free);
 	req->issued = get_clock();
 	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
 		del_timer(&req->timer);
@@ -2025,7 +2025,7 @@ static void zfcp_fsf_req_trace(struct zf
 	blktrc.magic = ZFCP_BLK_DRV_DATA_MAGIC;
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		blktrc.flags |= ZFCP_BLK_REQ_ERROR;
-	blktrc.inb_usage = req->qdio_req.qdio_inb_usage;
+	blktrc.inb_usage = 0;
 	blktrc.outb_usage = req->qdio_req.qdio_outb_usage;
 
 	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA &&
@@ -2207,7 +2207,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 		return -EBUSY;
 
 	spin_lock(&qdio->req_q_lock);
-	if (atomic_read(&qdio->req_q.count) <= 0) {
+	if (atomic_read(&qdio->req_q_free) <= 0) {
 		atomic_inc(&qdio->req_q_full);
 		goto out;
 	}
@@ -2407,7 +2407,7 @@ out:
 void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 {
 	struct zfcp_adapter *adapter = qdio->adapter;
-	struct qdio_buffer *sbal = qdio->resp_q.sbal[sbal_idx];
+	struct qdio_buffer *sbal = qdio->res_q[sbal_idx];
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long req_id;
@@ -2428,8 +2428,6 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 			      req_id, dev_name(&adapter->ccw_device->dev));
 
 		fsf_req->qdio_req.sbal_response = sbal_idx;
-		fsf_req->qdio_req.qdio_inb_usage =
-			atomic_read(&qdio->resp_q.count);
 		zfcp_fsf_req_complete(fsf_req);
 
 		if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -55,71 +55,46 @@ static void zfcp_qdio_zero_sbals(struct 
 static inline void zfcp_qdio_account(struct zfcp_qdio *qdio)
 {
 	unsigned long long now, span;
-	int free, used;
+	int used;
 
 	spin_lock(&qdio->stat_lock);
 	now = get_clock_monotonic();
 	span = (now - qdio->req_q_time) >> 12;
-	free = atomic_read(&qdio->req_q.count);
-	used = QDIO_MAX_BUFFERS_PER_Q - free;
+	used = QDIO_MAX_BUFFERS_PER_Q - atomic_read(&qdio->req_q_free);
 	qdio->req_q_util += used * span;
 	qdio->req_q_time = now;
 	spin_unlock(&qdio->stat_lock);
 }
 
 static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int qdio_err,
-			      int queue_no, int first, int count,
+			      int queue_no, int idx, int count,
 			      unsigned long parm)
 {
 	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
-	struct zfcp_qdio_queue *queue = &qdio->req_q;
 
 	if (unlikely(qdio_err)) {
-		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, first,
-					count);
+		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
 		zfcp_qdio_handler_error(qdio, "qdireq1");
 		return;
 	}
 
 	/* cleanup all SBALs being program-owned now */
-	zfcp_qdio_zero_sbals(queue->sbal, first, count);
+	zfcp_qdio_zero_sbals(qdio->req_q, idx, count);
 
 	zfcp_qdio_account(qdio);
-	atomic_add(count, &queue->count);
+	atomic_add(count, &qdio->req_q_free);
 	wake_up(&qdio->req_q_wq);
 }
 
-static void zfcp_qdio_resp_put_back(struct zfcp_qdio *qdio, int processed)
-{
-	struct zfcp_qdio_queue *queue = &qdio->resp_q;
-	struct ccw_device *cdev = qdio->adapter->ccw_device;
-	u8 count, start = queue->first;
-	unsigned int retval;
-
-	count = atomic_read(&queue->count) + processed;
-
-	retval = do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, start, count);
-
-	if (unlikely(retval)) {
-		atomic_set(&queue->count, count);
-		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdrpb_1", NULL);
-	} else {
-		queue->first += count;
-		queue->first %= QDIO_MAX_BUFFERS_PER_Q;
-		atomic_set(&queue->count, 0);
-	}
-}
-
 static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int qdio_err,
-			       int queue_no, int first, int count,
+			       int queue_no, int idx, int count,
 			       unsigned long parm)
 {
 	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
 	int sbal_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
-		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, first,
-					count);
+		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
 		zfcp_qdio_handler_error(qdio, "qdires1");
 		return;
 	}
@@ -129,16 +104,16 @@ static void zfcp_qdio_int_resp(struct cc
 	 * returned by QDIO layer
 	 */
 	for (sbal_no = 0; sbal_no < count; sbal_no++) {
-		sbal_idx = (first + sbal_no) % QDIO_MAX_BUFFERS_PER_Q;
+		sbal_idx = (idx + sbal_no) % QDIO_MAX_BUFFERS_PER_Q;
 		/* go through all SBALEs of SBAL */
 		zfcp_fsf_reqid_check(qdio, sbal_idx);
 	}
 
 	/*
-	 * put range of SBALs back to response queue
-	 * (including SBALs which have already been free before)
+	 * put SBALs back to response queue
 	 */
-	zfcp_qdio_resp_put_back(qdio, count);
+	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, idx, count))
+		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdires2", NULL);
 }
 
 static struct qdio_buffer_element *
@@ -185,17 +160,6 @@ zfcp_qdio_sbale_next(struct zfcp_qdio *q
 	return zfcp_qdio_sbale_curr(qdio, q_req);
 }
 
-static void zfcp_qdio_undo_sbals(struct zfcp_qdio *qdio,
-				 struct zfcp_qdio_req *q_req)
-{
-	struct qdio_buffer **sbal = qdio->req_q.sbal;
-	int first = q_req->sbal_first;
-	int last = q_req->sbal_last;
-	int count = (last - first + QDIO_MAX_BUFFERS_PER_Q) %
-		QDIO_MAX_BUFFERS_PER_Q + 1;
-	zfcp_qdio_zero_sbals(sbal, first, count);
-}
-
 /**
  * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
  * @qdio: pointer to struct zfcp_qdio
@@ -218,7 +182,8 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 		sbale = zfcp_qdio_sbale_next(qdio, q_req);
 		if (!sbale) {
 			atomic_inc(&qdio->req_q_full);
-			zfcp_qdio_undo_sbals(qdio, q_req);
+			zfcp_qdio_zero_sbals(qdio->req_q, q_req->sbal_first,
+					     q_req->sbal_number);
 			return -EINVAL;
 		}
 
@@ -237,10 +202,8 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	struct zfcp_qdio_queue *req_q = &qdio->req_q;
-
 	spin_lock_bh(&qdio->req_q_lock);
-	if (atomic_read(&req_q->count) ||
+	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -289,25 +252,25 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio 
  */
 int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
-	struct zfcp_qdio_queue *req_q = &qdio->req_q;
-	int first = q_req->sbal_first;
-	int count = q_req->sbal_number;
 	int retval;
-	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
+	u8 sbal_number = q_req->sbal_number;
 
 	zfcp_qdio_account(qdio);
 
-	retval = do_QDIO(qdio->adapter->ccw_device, qdio_flags, 0, first,
-			 count);
+	retval = do_QDIO(qdio->adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0,
+			 q_req->sbal_first, sbal_number);
+
 	if (unlikely(retval)) {
-		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
+		zfcp_qdio_zero_sbals(qdio->req_q, q_req->sbal_first,
+				     sbal_number);
 		return retval;
 	}
 
 	/* account for transferred buffers */
-	atomic_sub(count, &req_q->count);
-	req_q->first += count;
-	req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
+	atomic_sub(sbal_number, &qdio->req_q_free);
+	qdio->req_q_idx += sbal_number;
+	qdio->req_q_idx %= QDIO_MAX_BUFFERS_PER_Q;
+
 	return 0;
 }
 
@@ -329,8 +292,8 @@ static void zfcp_qdio_setup_init_data(st
 	id->input_handler = zfcp_qdio_int_resp;
 	id->output_handler = zfcp_qdio_int_req;
 	id->int_parm = (unsigned long) qdio;
-	id->input_sbal_addr_array = (void **) (qdio->resp_q.sbal);
-	id->output_sbal_addr_array = (void **) (qdio->req_q.sbal);
+	id->input_sbal_addr_array = (void **) (qdio->res_q);
+	id->output_sbal_addr_array = (void **) (qdio->req_q);
 
 }
 /**
@@ -343,8 +306,8 @@ static int zfcp_qdio_allocate(struct zfc
 {
 	struct qdio_initialize init_data;
 
-	if (zfcp_qdio_buffers_enqueue(qdio->req_q.sbal) ||
-	    zfcp_qdio_buffers_enqueue(qdio->resp_q.sbal))
+	if (zfcp_qdio_buffers_enqueue(qdio->req_q) ||
+	    zfcp_qdio_buffers_enqueue(qdio->res_q))
 		return -ENOMEM;
 
 	zfcp_qdio_setup_init_data(&init_data, qdio);
@@ -358,34 +321,30 @@ static int zfcp_qdio_allocate(struct zfc
  */
 void zfcp_qdio_close(struct zfcp_qdio *qdio)
 {
-	struct zfcp_qdio_queue *req_q;
-	int first, count;
+	struct zfcp_adapter *adapter = qdio->adapter;
+	int idx, count;
 
-	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return;
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
-	req_q = &qdio->req_q;
 	spin_lock_bh(&qdio->req_q_lock);
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
 	spin_unlock_bh(&qdio->req_q_lock);
 
 	wake_up(&qdio->req_q_wq);
 
-	qdio_shutdown(qdio->adapter->ccw_device,
-		      QDIO_FLAG_CLEANUP_USING_CLEAR);
+	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 
 	/* cleanup used outbound sbals */
-	count = atomic_read(&req_q->count);
+	count = atomic_read(&qdio->req_q_free);
 	if (count < QDIO_MAX_BUFFERS_PER_Q) {
-		first = (req_q->first + count) % QDIO_MAX_BUFFERS_PER_Q;
+		idx = (qdio->req_q_idx + count) % QDIO_MAX_BUFFERS_PER_Q;
 		count = QDIO_MAX_BUFFERS_PER_Q - count;
-		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
+		zfcp_qdio_zero_sbals(qdio->req_q, idx, count);
 	}
-	req_q->first = 0;
-	atomic_set(&req_q->count, 0);
-	qdio->resp_q.first = 0;
-	atomic_set(&qdio->resp_q.count, 0);
+	qdio->req_q_idx = 0;
+	atomic_set(&qdio->req_q_free, 0);
 }
 
 /**
@@ -397,10 +356,11 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 {
 	struct qdio_buffer_element *sbale;
 	struct qdio_initialize init_data;
-	struct ccw_device *cdev = qdio->adapter->ccw_device;
+	struct zfcp_adapter *adapter = qdio->adapter;
+	struct ccw_device *cdev = adapter->ccw_device;
 	int cc;
 
-	if (atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
 		return -EIO;
 
 	zfcp_qdio_setup_init_data(&init_data, qdio);
@@ -412,19 +372,18 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 		goto failed_qdio;
 
 	for (cc = 0; cc < QDIO_MAX_BUFFERS_PER_Q; cc++) {
-		sbale = &(qdio->resp_q.sbal[cc]->element[0]);
+		sbale = &(qdio->res_q[cc]->element[0]);
 		sbale->length = 0;
 		sbale->flags = SBAL_FLAGS_LAST_ENTRY;
 		sbale->addr = NULL;
 	}
 
-	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, 0,
-		     QDIO_MAX_BUFFERS_PER_Q))
+	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, 0, QDIO_MAX_BUFFERS_PER_Q))
 		goto failed_qdio;
 
 	/* set index of first avalable SBALS / number of available SBALS */
-	qdio->req_q.first = 0;
-	atomic_set(&qdio->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
+	qdio->req_q_idx = 0;
+	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
 
 	return 0;
 
@@ -438,7 +397,6 @@ failed_establish:
 
 void zfcp_qdio_destroy(struct zfcp_qdio *qdio)
 {
-	struct qdio_buffer **sbal_req, **sbal_resp;
 	int p;
 
 	if (!qdio)
@@ -447,12 +405,9 @@ void zfcp_qdio_destroy(struct zfcp_qdio 
 	if (qdio->adapter->ccw_device)
 		qdio_free(qdio->adapter->ccw_device);
 
-	sbal_req = qdio->req_q.sbal;
-	sbal_resp = qdio->resp_q.sbal;
-
 	for (p = 0; p < QDIO_MAX_BUFFERS_PER_Q; p += QBUFF_PER_PAGE) {
-		free_page((unsigned long) sbal_req[p]);
-		free_page((unsigned long) sbal_resp[p]);
+		free_page((unsigned long) qdio->req_q[p]);
+		free_page((unsigned long) qdio->res_q[p]);
 	}
 
 	kfree(qdio);
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -28,21 +28,11 @@
 	(ZFCP_QDIO_MAX_SBALS_PER_REQ * ZFCP_QDIO_MAX_SBALES_PER_SBAL - 2)
 
 /**
- * struct zfcp_qdio_queue - qdio queue buffer, zfcp index and free count
- * @sbal: qdio buffers
- * @first: index of next free buffer in queue
- * @count: number of free buffers in queue
- */
-struct zfcp_qdio_queue {
-	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
-	u8		   first;
-	atomic_t           count;
-};
-
-/**
  * struct zfcp_qdio - basic qdio data structure
- * @resp_q: response queue
+ * @res_q: response queue
  * @req_q: request queue
+ * @req_q_idx: index of next free buffer
+ * @req_q_free: number of free buffers in queue
  * @stat_lock: lock to protect req_q_util and req_q_time
  * @req_q_lock: lock to serialize access to request queue
  * @req_q_time: time of last fill level change
@@ -52,8 +42,10 @@ struct zfcp_qdio_queue {
  * @adapter: adapter used in conjunction with this qdio structure
  */
 struct zfcp_qdio {
-	struct zfcp_qdio_queue	resp_q;
-	struct zfcp_qdio_queue	req_q;
+	struct qdio_buffer	*res_q[QDIO_MAX_BUFFERS_PER_Q];
+	struct qdio_buffer	*req_q[QDIO_MAX_BUFFERS_PER_Q];
+	u8			req_q_idx;
+	atomic_t		req_q_free;
 	spinlock_t		stat_lock;
 	spinlock_t		req_q_lock;
 	unsigned long long	req_q_time;
@@ -73,7 +65,6 @@ struct zfcp_qdio {
  * @sbale_curr: current sbale at creation of this request
  * @sbal_response: sbal used in interrupt
  * @qdio_outb_usage: usage of outbound queue
- * @qdio_inb_usage: usage of inbound queue
  */
 struct zfcp_qdio_req {
 	u32	sbtype;
@@ -84,22 +75,9 @@ struct zfcp_qdio_req {
 	u8	sbale_curr;
 	u8	sbal_response;
 	u16	qdio_outb_usage;
-	u16	qdio_inb_usage;
 };
 
 /**
- * zfcp_qdio_sbale - return pointer to sbale in qdio queue
- * @q: queue where to find sbal
- * @sbal_idx: sbal index in queue
- * @sbale_idx: sbale index in sbal
- */
-static inline struct qdio_buffer_element *
-zfcp_qdio_sbale(struct zfcp_qdio_queue *q, int sbal_idx, int sbale_idx)
-{
-	return &q->sbal[sbal_idx]->element[sbale_idx];
-}
-
-/**
  * zfcp_qdio_sbale_req - return pointer to sbale on req_q for a request
  * @qdio: pointer to struct zfcp_qdio
  * @q_rec: pointer to struct zfcp_qdio_req
@@ -108,7 +86,7 @@ zfcp_qdio_sbale(struct zfcp_qdio_queue *
 static inline struct qdio_buffer_element *
 zfcp_qdio_sbale_req(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
-	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last, 0);
+	return &qdio->req_q[q_req->sbal_last]->element[0];
 }
 
 /**
@@ -120,8 +98,7 @@ zfcp_qdio_sbale_req(struct zfcp_qdio *qd
 static inline struct qdio_buffer_element *
 zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
-	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last,
-			       q_req->sbale_curr);
+	return &qdio->req_q[q_req->sbal_last]->element[q_req->sbale_curr];
 }
 
 /**
@@ -142,25 +119,25 @@ void zfcp_qdio_req_init(struct zfcp_qdio
 			unsigned long req_id, u32 sbtype, void *data, u32 len)
 {
 	struct qdio_buffer_element *sbale;
-	int count = min(atomic_read(&qdio->req_q.count),
+	int count = min(atomic_read(&qdio->req_q_free),
 			ZFCP_QDIO_MAX_SBALS_PER_REQ);
 
-	q_req->sbal_first = q_req->sbal_last = qdio->req_q.first;
+	q_req->sbal_first = q_req->sbal_last = qdio->req_q_idx;
 	q_req->sbal_number = 1;
 	q_req->sbtype = sbtype;
+	q_req->sbale_curr = 1;
 	q_req->sbal_limit = (q_req->sbal_first + count - 1)
 					% QDIO_MAX_BUFFERS_PER_Q;
 
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->addr = (void *) req_id;
-	sbale->flags |= SBAL_FLAGS0_COMMAND;
-	sbale->flags |= sbtype;
+	sbale->flags = SBAL_FLAGS0_COMMAND | sbtype;
 
-	q_req->sbale_curr = 1;
+	if (unlikely(!data))
+		return;
 	sbale++;
 	sbale->addr = data;
-	if (likely(data))
-		sbale->length = len;
+	sbale->length = len;
 }
 
 /**
@@ -232,7 +209,7 @@ static inline
 void zfcp_qdio_sbal_limit(struct zfcp_qdio *qdio,
 			  struct zfcp_qdio_req *q_req, int max_sbals)
 {
-	int count = min(atomic_read(&qdio->req_q.count), max_sbals);
+	int count = min(atomic_read(&qdio->req_q_free), max_sbals);
 
 	q_req->sbal_limit = (q_req->sbal_first + count - 1) %
 				QDIO_MAX_BUFFERS_PER_Q;

