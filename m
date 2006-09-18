From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 4/6] zfcp: introduce struct timer_list in struct zfcp_fsf_req
Date: Mon, 18 Sep 2006 22:29:56 +0200
Message-ID: <20060918202956.GA10503@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36025 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S964934AbWIRUep
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:34:45 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKYhLf088624
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:34:43 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKdSqe2638002
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:39:28 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKYh5I014569
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:34:43 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: introduce struct timer_list in struct zfcp_fsf_req

This instance will be used whenever a timer is needed for
a request by zfcp.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    4 -
 drivers/s390/scsi/zfcp_def.h  |    8 -
 drivers/s390/scsi/zfcp_erp.c  |  228 +++++++++++-------------------------
 drivers/s390/scsi/zfcp_ext.h  |   13 +-
 drivers/s390/scsi/zfcp_fsf.c  |  257 +++++++++++++++++------------------------
 drivers/s390/scsi/zfcp_scsi.c |   25 +---
 6 files changed, 191 insertions(+), 344 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 504c921..5d39b2d 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -1135,9 +1135,6 @@ zfcp_adapter_enqueue(struct ccw_device *
 	/* initialize lock of associated request queue */
 	rwlock_init(&adapter->request_queue.queue_lock);
 
-	/* intitialise SCSI ER timer */
-	init_timer(&adapter->scsi_er_timer);
-
 	/* mark adapter unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
@@ -1653,7 +1650,6 @@ zfcp_ns_gid_pn_request(struct zfcp_erp_a
 	gid_pn->ct.handler = zfcp_ns_gid_pn_handler;
 	gid_pn->ct.handler_data = (unsigned long) gid_pn;
         gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
-        gid_pn->ct.timer = &erp_action->timer;
 	gid_pn->port = erp_action->port;
 
 	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index ef1cd49..8f88269 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -137,7 +137,7 @@ #define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_
 #define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
 
 /* timeout value for "default timer" for fsf requests */
-#define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ);
+#define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ)
 
 /*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
 
@@ -779,7 +779,6 @@ typedef void (*zfcp_send_ct_handler_t)(u
  * @handler_data: data passed to handler function
  * @pool: pointer to memory pool for ct request structure
  * @timeout: FSF timeout for this request
- * @timer: timer (e.g. for request initiated by erp)
  * @completion: completion for synchronization purposes
  * @status: used to pass error status to calling function
  */
@@ -793,7 +792,6 @@ struct zfcp_send_ct {
 	unsigned long handler_data;
 	mempool_t *pool;
 	int timeout;
-	struct timer_list *timer;
 	struct completion *completion;
 	int status;
 };
@@ -821,7 +819,6 @@ typedef void (*zfcp_send_els_handler_t)(
  * @resp_count: number of elements in response scatter-gather list
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
- * @timer: timer (e.g. for request initiated by erp)
  * @completion: completion for synchronization purposes
  * @ls_code: hex code of ELS command
  * @status: used to pass error status to calling function
@@ -836,7 +833,6 @@ struct zfcp_send_els {
 	unsigned int resp_count;
 	zfcp_send_els_handler_t handler;
 	unsigned long handler_data;
-	struct timer_list *timer;
 	struct completion *completion;
 	int ls_code;
 	int status;
@@ -886,7 +882,6 @@ struct zfcp_adapter {
 	struct list_head        port_remove_lh;    /* head of ports to be
 						      removed */
 	u32			ports;	           /* number of remote ports */
-	struct timer_list	scsi_er_timer;     /* SCSI err recovery watch */
 	atomic_t		reqs_active;	   /* # active FSF reqs */
 	unsigned long		req_no;		   /* unique FSF req number */
 	struct list_head	*req_list;	   /* list of pending reqs */
@@ -1003,6 +998,7 @@ struct zfcp_fsf_req {
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
         unsigned long          data;           /* private data of request */ 
+	struct timer_list      timer;	       /* used for erp or scsi er */
 	struct zfcp_erp_action *erp_action;    /* used if this request is
 						  issued on behalf of erp */
 	mempool_t	       *pool;	       /* used if request was alloacted
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 7f60b6f..af42a0e 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -64,8 +64,6 @@ static int zfcp_erp_strategy_check_actio
 static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *, int);
 static int zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *);
-static void zfcp_erp_adapter_strategy_close_qdio(struct zfcp_erp_action *);
-static void zfcp_erp_adapter_strategy_close_fsf(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *);
@@ -111,64 +109,86 @@ static inline void zfcp_erp_action_to_re
 static inline void zfcp_erp_action_to_running(struct zfcp_erp_action *);
 
 static void zfcp_erp_memwait_handler(unsigned long);
-static void zfcp_erp_timeout_handler(unsigned long);
-static inline void zfcp_erp_timeout_init(struct zfcp_erp_action *);
 
 /**
- * zfcp_fsf_request_timeout_handler - called if a request timed out
- * @data: pointer to adapter for handler function
- *
- * This function needs to be called if requests (ELS, Generic Service,
- * or SCSI commands) exceed a certain time limit. The assumption is
- * that after the time limit the adapter get stuck. So we trigger a reopen of
- * the adapter. This should not be used for error recovery, SCSI abort
- * commands and SCSI requests from SCSI mid-layer.
+ * zfcp_close_qdio - close qdio queues for an adapter
  */
-void
-zfcp_fsf_request_timeout_handler(unsigned long data)
+static void zfcp_close_qdio(struct zfcp_adapter *adapter)
 {
-	struct zfcp_adapter *adapter;
+	struct zfcp_qdio_queue *req_queue;
+	int first, count;
 
-	adapter = (struct zfcp_adapter *) data;
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
+		return;
 
-	zfcp_erp_adapter_reopen(adapter, 0);
+	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
+	req_queue = &adapter->request_queue;
+	write_lock_irq(&req_queue->queue_lock);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
+	write_unlock_irq(&req_queue->queue_lock);
+
+	debug_text_event(adapter->erp_dbf, 3, "qdio_down2a");
+	while (qdio_shutdown(adapter->ccw_device,
+			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
+		msleep(1000);
+	debug_text_event(adapter->erp_dbf, 3, "qdio_down2b");
+
+	/* cleanup used outbound sbals */
+	count = atomic_read(&req_queue->free_count);
+	if (count < QDIO_MAX_BUFFERS_PER_Q) {
+		first = (req_queue->free_index+count) % QDIO_MAX_BUFFERS_PER_Q;
+		count = QDIO_MAX_BUFFERS_PER_Q - count;
+		zfcp_qdio_zero_sbals(req_queue->buffer, first, count);
+	}
+	req_queue->free_index = 0;
+	atomic_set(&req_queue->free_count, 0);
+	req_queue->distance_from_int = 0;
+	adapter->response_queue.free_index = 0;
+	atomic_set(&adapter->response_queue.free_count, 0);
 }
 
 /**
- * zfcp_fsf_scsi_er_timeout_handler - timeout handler for scsi eh tasks
+ * zfcp_close_fsf - stop FSF operations for an adapter
  *
- * This function needs to be called whenever a SCSI error recovery
- * action (abort/reset) does not return.  Re-opening the adapter means
- * that the abort/reset command can be returned by zfcp. It won't complete
- * via the adapter anymore (because qdio queues are closed). If ERP is
- * already running on this adapter it will be stopped.
+ * Dismiss and cleanup all pending fsf_reqs (this wakes up all initiators of
+ * requests waiting for completion; especially this returns SCSI commands
+ * with error state).
  */
-void zfcp_fsf_scsi_er_timeout_handler(unsigned long data)
+static void zfcp_close_fsf(struct zfcp_adapter *adapter)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	unsigned long flags;
-
-	ZFCP_LOG_NORMAL("warning: SCSI error recovery timed out. "
-			"Restarting all operations on the adapter %s\n",
-			zfcp_get_busid_by_adapter(adapter));
-	debug_text_event(adapter->erp_dbf, 1, "eh_lmem_tout");
+	/* close queues to ensure that buffers are not accessed by adapter */
+	zfcp_close_qdio(adapter);
+	zfcp_fsf_req_dismiss_all(adapter);
+	/* reset FSF request sequence number */
+	adapter->fsf_req_seq_no = 0;
+	/* all ports and units are closed */
+	zfcp_erp_modify_adapter_status(adapter,
+				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
+}
 
-	write_lock_irqsave(&adapter->erp_lock, flags);
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
-			     &adapter->status)) {
-		zfcp_erp_modify_adapter_status(adapter,
-		       ZFCP_STATUS_COMMON_UNBLOCKED|ZFCP_STATUS_COMMON_OPEN,
-		       ZFCP_CLEAR);
-		zfcp_erp_action_dismiss_adapter(adapter);
-		write_unlock_irqrestore(&adapter->erp_lock, flags);
-		/* dismiss all pending requests including requests for ERP */
-		zfcp_fsf_req_dismiss_all(adapter);
-		adapter->fsf_req_seq_no = 0;
-	} else
-		write_unlock_irqrestore(&adapter->erp_lock, flags);
+/**
+ * zfcp_fsf_request_timeout_handler - called if a request timed out
+ * @data: pointer to adapter for handler function
+ *
+ * This function needs to be called if requests (ELS, Generic Service,
+ * or SCSI commands) exceed a certain time limit. The assumption is
+ * that after the time limit the adapter get stuck. So we trigger a reopen of
+ * the adapter.
+ */
+static void zfcp_fsf_request_timeout_handler(unsigned long data)
+{
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
 	zfcp_erp_adapter_reopen(adapter, 0);
 }
 
+void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req, unsigned long timeout)
+{
+	fsf_req->timer.function = zfcp_fsf_request_timeout_handler;
+	fsf_req->timer.data = (unsigned long) fsf_req->adapter;
+	fsf_req->timer.expires = timeout;
+	add_timer(&fsf_req->timer);
+}
+
 /*
  * function:	
  *
@@ -282,7 +302,6 @@ zfcp_erp_adisc(struct zfcp_port *port)
 	struct zfcp_ls_adisc *adisc;
 	void *address = NULL;
 	int retval = 0;
-	struct timer_list *timer;
 
 	send_els = kzalloc(sizeof(struct zfcp_send_els), GFP_ATOMIC);
 	if (send_els == NULL)
@@ -329,22 +348,11 @@ zfcp_erp_adisc(struct zfcp_port *port)
 		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
 		      adisc->nport_id);
 
-	timer = kmalloc(sizeof(struct timer_list), GFP_ATOMIC);
-	if (!timer)
-		goto nomem;
-
-	init_timer(timer);
-	timer->function = zfcp_fsf_request_timeout_handler;
-	timer->data = (unsigned long) adapter;
-	timer->expires = ZFCP_FSF_REQUEST_TIMEOUT;
-	send_els->timer = timer;
-
 	retval = zfcp_fsf_send_els(send_els);
 	if (retval != 0) {
 		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
 				"0x%08x on adapter %s\n", send_els->d_id,
 				zfcp_get_busid_by_adapter(adapter));
-		del_timer(send_els->timer);
 		goto freemem;
 	}
 
@@ -356,7 +364,6 @@ zfcp_erp_adisc(struct zfcp_port *port)
 	if (address != NULL)
 		__free_pages(send_els->req->page, 0);
 	if (send_els != NULL) {
-		kfree(send_els->timer);
 		kfree(send_els->req);
 		kfree(send_els->resp);
 		kfree(send_els);
@@ -382,9 +389,6 @@ zfcp_erp_adisc_handler(unsigned long dat
 	struct zfcp_ls_adisc_acc *adisc;
 
 	send_els = (struct zfcp_send_els *) data;
-
-	del_timer(send_els->timer);
-
 	adapter = send_els->adapter;
 	port = send_els->port;
 	d_id = send_els->d_id;
@@ -433,7 +437,6 @@ zfcp_erp_adisc_handler(unsigned long dat
  out:
 	zfcp_port_put(port);
 	__free_pages(send_els->req->page, 0);
-	kfree(send_els->timer);
 	kfree(send_els->req);
 	kfree(send_els->resp);
 	kfree(send_els);
@@ -909,8 +912,6 @@ static void zfcp_erp_async_handler_noloc
 		debug_text_event(adapter->erp_dbf, 2, "a_asyh_ex");
 		debug_event(adapter->erp_dbf, 2, &erp_action->action,
 			    sizeof (int));
-		if (!(set_mask & ZFCP_STATUS_ERP_TIMEDOUT))
-			del_timer(&erp_action->timer);
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
 	} else {
@@ -957,8 +958,7 @@ zfcp_erp_memwait_handler(unsigned long d
  *		action gets an appropriate flag and will be processed
  *		accordingly
  */
-static void
-zfcp_erp_timeout_handler(unsigned long data)
+void zfcp_erp_timeout_handler(unsigned long data)
 {
 	struct zfcp_erp_action *erp_action = (struct zfcp_erp_action *) data;
 	struct zfcp_adapter *adapter = erp_action->adapter;
@@ -1934,8 +1934,7 @@ zfcp_erp_adapter_strategy_generic(struct
 			  &erp_action->adapter->status);
 
  failed_openfcp:
-	zfcp_erp_adapter_strategy_close_qdio(erp_action);
-	zfcp_erp_adapter_strategy_close_fsf(erp_action);
+	zfcp_close_fsf(erp_action->adapter);
  failed_qdio:
  out:
 	return retval;
@@ -2040,59 +2039,6 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 	return retval;
 }
 
-/**
- * zfcp_erp_adapter_strategy_close_qdio - close qdio queues for an adapter
- */
-static void
-zfcp_erp_adapter_strategy_close_qdio(struct zfcp_erp_action *erp_action)
-{
-	int first_used;
-	int used_count;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status)) {
-		ZFCP_LOG_DEBUG("error: attempt to shut down inactive QDIO "
-			       "queues on adapter %s\n",
-			       zfcp_get_busid_by_adapter(adapter));
-		return;
-	}
-
-	/*
-	 * Get queue_lock and clear QDIOUP flag. Thus it's guaranteed that
-	 * do_QDIO won't be called while qdio_shutdown is in progress.
-	 */
-	write_lock_irq(&adapter->request_queue.queue_lock);
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	write_unlock_irq(&adapter->request_queue.queue_lock);
-
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down2a");
-	while (qdio_shutdown(adapter->ccw_device,
-			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
-		msleep(1000);
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down2b");
-
-	/*
-	 * First we had to stop QDIO operation.
-	 * Now it is safe to take the following actions.
-	 */
-
-	/* Cleanup only necessary when there are unacknowledged buffers */
-	if (atomic_read(&adapter->request_queue.free_count)
-	    < QDIO_MAX_BUFFERS_PER_Q) {
-		first_used = (adapter->request_queue.free_index +
-			      atomic_read(&adapter->request_queue.free_count))
-			% QDIO_MAX_BUFFERS_PER_Q;
-		used_count = QDIO_MAX_BUFFERS_PER_Q -
-			atomic_read(&adapter->request_queue.free_count);
-		zfcp_qdio_zero_sbals(adapter->request_queue.buffer,
-				     first_used, used_count);
-	}
-	adapter->response_queue.free_index = 0;
-	atomic_set(&adapter->response_queue.free_count, 0);
-	adapter->request_queue.free_index = 0;
-	atomic_set(&adapter->request_queue.free_count, 0);
-	adapter->request_queue.distance_from_int = 0;
-}
 
 static int
 zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *erp_action)
@@ -2127,7 +2073,6 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		write_lock_irq(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
 		write_unlock_irq(&adapter->erp_lock);
-		zfcp_erp_timeout_init(erp_action);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
 			retval = ZFCP_ERP_FAILED;
 			debug_text_event(adapter->erp_dbf, 5, "a_fstx_xf");
@@ -2196,7 +2141,6 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	zfcp_erp_action_to_running(erp_action);
 	write_unlock_irq(&adapter->erp_lock);
 
-	zfcp_erp_timeout_init(erp_action);
 	ret = zfcp_fsf_exchange_port_data(erp_action, adapter, NULL);
 	if (ret == -EOPNOTSUPP) {
 		debug_text_event(adapter->erp_dbf, 3, "a_xport_notsupp");
@@ -2248,27 +2192,6 @@ zfcp_erp_adapter_strategy_open_fsf_statu
 	return retval;
 }
 
-/**
- * zfcp_erp_adapter_strategy_close_fsf - stop FSF operations for an adapter
- */
-static void
-zfcp_erp_adapter_strategy_close_fsf(struct zfcp_erp_action *erp_action)
-{
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	/*
-	 * wake waiting initiators of requests,
-	 * return SCSI commands (with error status),
-	 * clean up all requests (synchronously)
-	 */
-	zfcp_fsf_req_dismiss_all(adapter);
-	/* reset FSF request sequence number */
-	adapter->fsf_req_seq_no = 0;
-	/* all ports and units are closed */
-	zfcp_erp_modify_adapter_status(adapter,
-				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
-}
-
 /*
  * function:	
  *
@@ -2605,7 +2528,6 @@ zfcp_erp_port_forced_strategy_close(stru
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_port *port = erp_action->port;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_fsf_close_physical_port(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "o_pfstc_nomem");
@@ -2662,7 +2584,6 @@ zfcp_erp_port_strategy_close(struct zfcp
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_port *port = erp_action->port;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_fsf_close_port(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "p_pstc_nomem");
@@ -2700,7 +2621,6 @@ zfcp_erp_port_strategy_open_port(struct 
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_port *port = erp_action->port;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_fsf_open_port(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "p_psto_nomem");
@@ -2738,7 +2658,6 @@ zfcp_erp_port_strategy_open_common_looku
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_port *port = erp_action->port;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_ns_gid_pn_request(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "p_pstn_nomem");
@@ -2864,7 +2783,6 @@ zfcp_erp_unit_strategy_close(struct zfcp
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_unit *unit = erp_action->unit;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_fsf_close_unit(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "u_ustc_nomem");
@@ -2905,7 +2823,6 @@ zfcp_erp_unit_strategy_open(struct zfcp_
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_unit *unit = erp_action->unit;
 
-	zfcp_erp_timeout_init(erp_action);
 	retval = zfcp_fsf_open_unit(erp_action);
 	if (retval == -ENOMEM) {
 		debug_text_event(adapter->erp_dbf, 5, "u_usto_nomem");
@@ -2930,14 +2847,13 @@ zfcp_erp_unit_strategy_open(struct zfcp_
 	return retval;
 }
 
-static inline void
-zfcp_erp_timeout_init(struct zfcp_erp_action *erp_action)
+void zfcp_erp_start_timer(struct zfcp_fsf_req *fsf_req)
 {
-	init_timer(&erp_action->timer);
-	erp_action->timer.function = zfcp_erp_timeout_handler;
-	erp_action->timer.data = (unsigned long) erp_action;
-	/* jiffies will be added in zfcp_fsf_req_send */
-	erp_action->timer.expires = ZFCP_ERP_FSFREQ_TIMEOUT;
+	BUG_ON(!fsf_req->erp_action);
+	fsf_req->timer.function = zfcp_erp_timeout_handler;
+	fsf_req->timer.data = (unsigned long) fsf_req->erp_action;
+	fsf_req->timer.expires = jiffies + ZFCP_ERP_FSFREQ_TIMEOUT;
+	add_timer(&fsf_req->timer);
 }
 
 /*
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 710ebbf..3125a42 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -87,8 +87,8 @@ extern int  zfcp_fsf_exchange_port_data(
 					struct fsf_qtcb_bottom_port *);
 extern int  zfcp_fsf_control_file(struct zfcp_adapter *, struct zfcp_fsf_req **,
 				  u32, u32, struct zfcp_sg_list *);
-extern void zfcp_fsf_request_timeout_handler(unsigned long);
-extern void zfcp_fsf_scsi_er_timeout_handler(unsigned long);
+extern void zfcp_fsf_start_timer(struct zfcp_fsf_req *, unsigned long);
+extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
 extern int  zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int  zfcp_fsf_status_read(struct zfcp_adapter *, int);
 extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
@@ -98,8 +98,7 @@ extern int zfcp_fsf_send_ct(struct zfcp_
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
 extern int  zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *,
 					   struct zfcp_unit *,
-					   struct scsi_cmnd *,
-					   struct timer_list*, int);
+					   struct scsi_cmnd *, int, int);
 extern int  zfcp_fsf_req_complete(struct zfcp_fsf_req *);
 extern void zfcp_fsf_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
@@ -123,13 +122,11 @@ extern char *zfcp_get_fcp_rsp_info_ptr(s
 extern void set_host_byte(u32 *, char);
 extern void set_driver_byte(u32 *, char);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
-extern void zfcp_fsf_start_scsi_er_timer(struct zfcp_adapter *);
 extern fcp_dl_t zfcp_get_fcp_dl(struct fcp_cmnd_iu *);
 
 extern int zfcp_scsi_command_async(struct zfcp_adapter *,struct zfcp_unit *,
-				   struct scsi_cmnd *, struct timer_list *);
-extern int zfcp_scsi_command_sync(struct zfcp_unit *, struct scsi_cmnd *,
-				  struct timer_list *);
+				   struct scsi_cmnd *, int);
+extern int zfcp_scsi_command_sync(struct zfcp_unit *, struct scsi_cmnd *, int);
 extern struct fc_function_template zfcp_transport_functions;
 
 /******************************** ERP ****************************************/
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index a66b519..277826c 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -42,7 +42,7 @@ static inline int zfcp_fsf_req_sbal_chec
 static inline int zfcp_use_one_sbal(
 	struct scatterlist *, int, struct scatterlist *, int);
 static struct zfcp_fsf_req *zfcp_fsf_req_alloc(mempool_t *, int);
-static int zfcp_fsf_req_send(struct zfcp_fsf_req *, struct timer_list *);
+static int zfcp_fsf_req_send(struct zfcp_fsf_req *);
 static int zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *);
@@ -225,8 +225,10 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
 		 */
 		zfcp_fsf_status_read_handler(fsf_req);
 		goto out;
-	} else
+	} else {
+		del_timer(&fsf_req->timer);
 		zfcp_fsf_protstatus_eval(fsf_req);
+	}
 
 	/*
 	 * fsf_req may be deleted due to waking up functions, so 
@@ -785,8 +787,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
 	sbale->addr = (void *) status_buffer;
 	sbale->length = sizeof(struct fsf_status_read_buffer);
 
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(fsf_req, NULL);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_DEBUG("error: Could not set-up unsolicited status "
 			       "environment.\n");
@@ -1112,8 +1113,8 @@ zfcp_fsf_abort_fcp_command(unsigned long
 			   struct zfcp_unit *unit, int req_flags)
 {
 	volatile struct qdio_buffer_element *sbale;
-	unsigned long lock_flags;
 	struct zfcp_fsf_req *fsf_req = NULL;
+	unsigned long lock_flags;
 	int retval = 0;
 
 	/* setup new FSF request */
@@ -1143,12 +1144,9 @@ zfcp_fsf_abort_fcp_command(unsigned long
 	/* set handle of request which should be aborted */
 	fsf_req->qtcb->bottom.support.req_handle = (u64) old_req_id;
 
-	/* start QDIO request for this FSF request */
-
-	zfcp_fsf_start_scsi_er_timer(adapter);
-	retval = zfcp_fsf_req_send(fsf_req, NULL);
+	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
-		del_timer(&adapter->scsi_er_timer);
 		ZFCP_LOG_INFO("error: Failed to send abort command request "
 			      "on adapter %s, port 0x%016Lx, unit 0x%016Lx\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1184,8 +1182,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 	unsigned char status_qual =
 	    new_fsf_req->qtcb->header.fsf_status_qual.word[0];
 
-	del_timer(&new_fsf_req->adapter->scsi_er_timer);
-
 	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		/* do not set ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED */
 		goto skip_fsfstatus;
@@ -1391,11 +1387,6 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 		goto failed_req;
 	}
 
-        if (erp_action != NULL) {
-                erp_action->fsf_req = fsf_req;
-                fsf_req->erp_action = erp_action;
-        }
-
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         if (zfcp_use_one_sbal(ct->req, ct->req_count,
                               ct->resp, ct->resp_count)){
@@ -1462,8 +1453,14 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 
 	zfcp_san_dbf_event_ct_request(fsf_req);
 
-	/* start QDIO request for this FSF request */
-	ret = zfcp_fsf_req_send(fsf_req, ct->timer);
+	if (erp_action) {
+		erp_action->fsf_req = fsf_req;
+		fsf_req->erp_action = erp_action;
+		zfcp_erp_start_timer(fsf_req);
+	} else
+		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
+
+	ret = zfcp_fsf_req_send(fsf_req);
 	if (ret) {
 		ZFCP_LOG_DEBUG("error: initiation of CT request failed "
 			       "(adapter %s, port 0x%016Lx)\n",
@@ -1760,8 +1757,8 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 
 	zfcp_san_dbf_event_els_request(fsf_req);
 
-	/* start QDIO request for this FSF request */
-	ret = zfcp_fsf_req_send(fsf_req, els->timer);
+	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
+	ret = zfcp_fsf_req_send(fsf_req);
 	if (ret) {
 		ZFCP_LOG_DEBUG("error: initiation of ELS request failed "
 			       "(adapter %s, port d_id: 0x%08x)\n",
@@ -1958,6 +1955,7 @@ int
 zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long lock_flags;
 	int retval = 0;
 
@@ -1966,7 +1964,7 @@ zfcp_fsf_exchange_config_data(struct zfc
 				     FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				     ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &(erp_action->fsf_req));
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create exchange configuration "
 			      "data request for adapter %s.\n",
@@ -1974,26 +1972,26 @@ zfcp_fsf_exchange_config_data(struct zfc
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-                                    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	erp_action->fsf_req->erp_action = erp_action;
-	erp_action->fsf_req->qtcb->bottom.config.feature_selection =
+	fsf_req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_CFDC |
 			FSF_FEATURE_LUN_SHARING |
 			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
 
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO
 		    ("error: Could not send exchange configuration data "
 		     "command on the adapter %s\n",
 		     zfcp_get_busid_by_adapter(erp_action->adapter));
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -2223,10 +2221,9 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 			    struct fsf_qtcb_bottom_port *data)
 {
 	volatile struct qdio_buffer_element *sbale;
-	int retval = 0;
-	unsigned long lock_flags;
         struct zfcp_fsf_req *fsf_req;
-	struct timer_list *timer;
+	unsigned long lock_flags;
+	int retval = 0;
 
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT)) {
 		ZFCP_LOG_INFO("error: exchange port data "
@@ -2259,22 +2256,11 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	if (erp_action) {
 		erp_action->fsf_req = fsf_req;
 		fsf_req->erp_action = erp_action;
-		timer = &erp_action->timer;
-	} else {
-		timer = kmalloc(sizeof(struct timer_list), GFP_ATOMIC);
-		if (!timer) {
-			write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-						lock_flags);
-			zfcp_fsf_req_free(fsf_req);
-			return -ENOMEM;
-		}
-		init_timer(timer);
-		timer->function = zfcp_fsf_request_timeout_handler;
-		timer->data = (unsigned long) adapter;
-		timer->expires = ZFCP_FSF_REQUEST_TIMEOUT;
-	}
+		zfcp_erp_start_timer(fsf_req);
+	} else
+		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 
-	retval = zfcp_fsf_req_send(fsf_req, timer);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send an exchange port data "
                               "command on the adapter %s\n",
@@ -2282,8 +2268,6 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 		zfcp_fsf_req_free(fsf_req);
 		if (erp_action)
 			erp_action->fsf_req = NULL;
-		else
-			kfree(timer);
 		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
 					lock_flags);
 		return retval;
@@ -2294,9 +2278,7 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	if (!erp_action) {
 		wait_event(fsf_req->completion_wq,
 			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-		del_timer_sync(timer);
 		zfcp_fsf_req_free(fsf_req);
-		kfree(timer);
 	}
 	return retval;
 }
@@ -2378,6 +2360,7 @@ int
 zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long lock_flags;
 	int retval = 0;
 
@@ -2386,7 +2369,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 				     FSF_QTCB_OPEN_PORT_WITH_DID,
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &(erp_action->fsf_req));
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create open port request "
 			      "for port 0x%016Lx on adapter %s.\n",
@@ -2395,24 +2378,24 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-                                    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	erp_action->fsf_req->qtcb->bottom.support.d_id = erp_action->port->d_id;
+	fsf_req->qtcb->bottom.support.d_id = erp_action->port->d_id;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
-	erp_action->fsf_req->data = (unsigned long) erp_action->port;
-	erp_action->fsf_req->erp_action = erp_action;
+	fsf_req->data = (unsigned long) erp_action->port;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
 
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send open port request for "
 			      "port 0x%016Lx on adapter %s.\n",
 			      erp_action->port->wwpn,
 			      zfcp_get_busid_by_adapter(erp_action->adapter));
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -2634,6 +2617,7 @@ int
 zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long lock_flags;
 	int retval = 0;
 
@@ -2642,7 +2626,7 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 				     FSF_QTCB_CLOSE_PORT,
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &(erp_action->fsf_req));
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create a close port request "
 			      "for port 0x%016Lx on adapter %s.\n",
@@ -2651,25 +2635,25 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-                                    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
-	erp_action->fsf_req->data = (unsigned long) erp_action->port;
-	erp_action->fsf_req->erp_action = erp_action;
-	erp_action->fsf_req->qtcb->header.port_handle =
-	    erp_action->port->handle;
-
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	fsf_req->data = (unsigned long) erp_action->port;
+	fsf_req->erp_action = erp_action;
+	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
+
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send a close port request for "
 			      "port 0x%016Lx on adapter %s.\n",
 			      erp_action->port->wwpn,
 			      zfcp_get_busid_by_adapter(erp_action->adapter));
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -2766,16 +2750,17 @@ zfcp_fsf_close_port_handler(struct zfcp_
 int
 zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 {
-	int retval = 0;
-	unsigned long lock_flags;
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
+	unsigned long lock_flags;
+	int retval = 0;
 
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(erp_action->adapter,
 				     FSF_QTCB_CLOSE_PHYSICAL_PORT,
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &erp_action->fsf_req);
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create close physical port "
 			      "request (adapter %s, port 0x%016Lx)\n",
@@ -2785,8 +2770,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-				    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2794,20 +2778,19 @@ zfcp_fsf_close_physical_port(struct zfcp
 	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
 			&erp_action->port->status);
 	/* save a pointer to this port */
-	erp_action->fsf_req->data = (unsigned long) erp_action->port;
-	/* port to be closed */
-	erp_action->fsf_req->qtcb->header.port_handle =
-	    erp_action->port->handle;
-	erp_action->fsf_req->erp_action = erp_action;
-
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	fsf_req->data = (unsigned long) erp_action->port;
+	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
+
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send close physical port "
 			      "request (adapter %s, port 0x%016Lx)\n",
 			      zfcp_get_busid_by_adapter(erp_action->adapter),
 			      erp_action->port->wwpn);
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -2972,6 +2955,7 @@ int
 zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long lock_flags;
 	int retval = 0;
 
@@ -2980,7 +2964,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 				     FSF_QTCB_OPEN_LUN,
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &(erp_action->fsf_req));
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create open unit request for "
 			      "unit 0x%016Lx on port 0x%016Lx on adapter %s.\n",
@@ -2990,24 +2974,22 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-                                    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	erp_action->fsf_req->qtcb->header.port_handle =
-		erp_action->port->handle;
-	erp_action->fsf_req->qtcb->bottom.support.fcp_lun =
-		erp_action->unit->fcp_lun;
+	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
+	fsf_req->qtcb->bottom.support.fcp_lun =	erp_action->unit->fcp_lun;
 	if (!(erp_action->adapter->connection_features & FSF_FEATURE_NPIV_MODE))
-		erp_action->fsf_req->qtcb->bottom.support.option =
+		fsf_req->qtcb->bottom.support.option =
 			FSF_OPEN_LUN_SUPPRESS_BOXING;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
-	erp_action->fsf_req->data = (unsigned long) erp_action->unit;
-	erp_action->fsf_req->erp_action = erp_action;
+	fsf_req->data = (unsigned long) erp_action->unit;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
 
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(erp_action->fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send an open unit request "
 			      "on the adapter %s, port 0x%016Lx for "
@@ -3015,7 +2997,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 			      zfcp_get_busid_by_adapter(erp_action->adapter),
 			      erp_action->port->wwpn,
 			      erp_action->unit->fcp_lun);
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -3308,6 +3290,7 @@ int
 zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long lock_flags;
 	int retval = 0;
 
@@ -3316,7 +3299,7 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 				     FSF_QTCB_CLOSE_LUN,
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &(erp_action->fsf_req));
+				     &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Could not create close unit request for "
 			      "unit 0x%016Lx on port 0x%016Lx on adapter %s.\n",
@@ -3326,27 +3309,26 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(erp_action->fsf_req,
-                                    erp_action->fsf_req->sbal_curr, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	erp_action->fsf_req->qtcb->header.port_handle =
-	    erp_action->port->handle;
-	erp_action->fsf_req->qtcb->header.lun_handle = erp_action->unit->handle;
+	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
+	fsf_req->qtcb->header.lun_handle = erp_action->unit->handle;
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
-	erp_action->fsf_req->data = (unsigned long) erp_action->unit;
-	erp_action->fsf_req->erp_action = erp_action;
+	fsf_req->data = (unsigned long) erp_action->unit;
+	fsf_req->erp_action = erp_action;
+	erp_action->fsf_req = fsf_req;
 
-	/* start QDIO request for this FSF request */
-	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
+	zfcp_erp_start_timer(fsf_req);
+	retval = zfcp_fsf_req_send(erp_action->fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send a close unit request for "
 			      "unit 0x%016Lx on port 0x%016Lx onadapter %s.\n",
 			      erp_action->unit->fcp_lun,
 			      erp_action->port->wwpn,
 			      zfcp_get_busid_by_adapter(erp_action->adapter));
-		zfcp_fsf_req_free(erp_action->fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
@@ -3499,7 +3481,7 @@ int
 zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *adapter,
 			       struct zfcp_unit *unit,
 			       struct scsi_cmnd * scsi_cmnd,
-			       struct timer_list *timer, int req_flags)
+			       int use_timer, int req_flags)
 {
 	struct zfcp_fsf_req *fsf_req = NULL;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
@@ -3640,11 +3622,10 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 		      (char *) scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
 
-	/*
-	 * start QDIO request for this FSF request
-	 *  covered by an SBALE)
-	 */
-	retval = zfcp_fsf_req_send(fsf_req, timer);
+	if (use_timer)
+		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
+
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (unlikely(retval < 0)) {
 		ZFCP_LOG_INFO("error: Could not send FCP command request "
 			      "on adapter %s, port 0x%016Lx, unit 0x%016Lx\n",
@@ -3729,11 +3710,9 @@ zfcp_fsf_send_fcp_command_task_managemen
 	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
 	fcp_cmnd_iu->task_management_flags = tm_flags;
 
-	/* start QDIO request for this FSF request */
-	zfcp_fsf_start_scsi_er_timer(adapter);
-	retval = zfcp_fsf_req_send(fsf_req, NULL);
+	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
-		del_timer(&adapter->scsi_er_timer);
 		ZFCP_LOG_INFO("error: Could not send an FCP-command (task "
 			      "management) on adapter %s, port 0x%016Lx for "
 			      "unit LUN 0x%016Lx\n",
@@ -4237,7 +4216,6 @@ zfcp_fsf_send_fcp_command_task_managemen
 	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
 	struct zfcp_unit *unit = (struct zfcp_unit *) fsf_req->data;
 
-	del_timer(&fsf_req->adapter->scsi_er_timer);
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 		goto skip_fsfstatus;
@@ -4306,7 +4284,6 @@ zfcp_fsf_control_file(struct zfcp_adapte
 	struct zfcp_fsf_req *fsf_req;
 	struct fsf_qtcb_bottom_support *bottom;
 	volatile struct qdio_buffer_element *sbale;
-	struct timer_list *timer;
 	unsigned long lock_flags;
 	int req_flags = 0;
 	int direction;
@@ -4338,12 +4315,6 @@ zfcp_fsf_control_file(struct zfcp_adapte
 		goto out;
 	}
 
-	timer = kmalloc(sizeof(struct timer_list), GFP_KERNEL);
-	if (!timer) {
-		retval = -ENOMEM;
-		goto out;
- 	}
-
 	retval = zfcp_fsf_req_create(adapter, fsf_command, req_flags,
 				     NULL, &lock_flags, &fsf_req);
 	if (retval < 0) {
@@ -4378,12 +4349,8 @@ zfcp_fsf_control_file(struct zfcp_adapte
 	} else
 		sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	init_timer(timer);
-	timer->function = zfcp_fsf_request_timeout_handler;
-	timer->data = (unsigned long) adapter;
-	timer->expires = ZFCP_FSF_REQUEST_TIMEOUT;
-
-	retval = zfcp_fsf_req_send(fsf_req, timer);
+	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("initiation of cfdc up/download failed"
 			      "(adapter %s)\n",
@@ -4403,15 +4370,12 @@ zfcp_fsf_control_file(struct zfcp_adapte
 	           fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
 	*fsf_req_ptr = fsf_req;
-	del_timer_sync(timer);
-	goto free_timer;
+	goto out;
 
  free_fsf_req:
 	zfcp_fsf_req_free(fsf_req);
  unlock_queue_lock:
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
- free_timer:
-	kfree(timer);
  out:
 	return retval;
 }
@@ -4688,7 +4652,8 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 		adapter->req_no++;
 	fsf_req->req_id = adapter->req_no++;
 
-        zfcp_fsf_req_qtcb_init(fsf_req);
+	init_timer(&fsf_req->timer);
+	zfcp_fsf_req_qtcb_init(fsf_req);
 
 	/* initialize waitqueue which may be used to wait on 
 	   this request completion */
@@ -4758,8 +4723,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
  * returns:	0 - request transfer succesfully started
  *		!0 - start of request transfer failed
  */
-static int
-zfcp_fsf_req_send(struct zfcp_fsf_req *fsf_req, struct timer_list *timer)
+static int zfcp_fsf_req_send(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_qdio_queue *req_queue;
@@ -4787,12 +4751,6 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 
 	inc_seq_no = (fsf_req->qtcb != NULL);
 
-	/* figure out expiration time of timeout and start timeout */
-	if (unlikely(timer)) {
-		timer->expires += jiffies;
-		add_timer(timer);
-	}
-
 	ZFCP_LOG_TRACE("request queue of adapter %s: "
 		       "next free SBAL is %i, %i free SBALs\n",
 		       zfcp_get_busid_by_adapter(adapter),
@@ -4829,12 +4787,7 @@ zfcp_fsf_req_send(struct zfcp_fsf_req *f
 	if (unlikely(retval)) {
 		/* Queues are down..... */
 		retval = -EIO;
-		/*
-		 * FIXME(potential race):
-		 * timer might be expired (absolutely unlikely)
-		 */
-		if (timer)
-			del_timer(timer);
+		del_timer(&fsf_req->timer);
 		spin_lock(&adapter->req_list_lock);
 		zfcp_reqlist_remove(adapter, fsf_req->req_id);
 		spin_unlock(&adapter->req_list_lock);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 043ed7c..753bb9b 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -231,7 +231,7 @@ zfcp_scsi_command_fail(struct scsi_cmnd 
  */
 int
 zfcp_scsi_command_async(struct zfcp_adapter *adapter, struct zfcp_unit *unit,
-			struct scsi_cmnd *scpnt, struct timer_list *timer)
+			struct scsi_cmnd *scpnt, int use_timer)
 {
 	int tmp;
 	int retval;
@@ -267,7 +267,7 @@ zfcp_scsi_command_async(struct zfcp_adap
 		goto out;
 	}
 
-	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, timer,
+	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, use_timer,
 					     ZFCP_REQ_AUTO_CLEANUP);
 
 	if (unlikely(tmp < 0)) {
@@ -291,21 +291,22 @@ zfcp_scsi_command_sync_handler(struct sc
  * zfcp_scsi_command_sync - send a SCSI command and wait for completion
  * @unit: unit where command is sent to
  * @scpnt: scsi command to be sent
- * @timer: timer to be started if request is successfully initiated
+ * @use_timer: indicates whether timer should be setup or not
  * Return: 0
  *
  * Errors are indicated in scpnt->result
  */
 int
 zfcp_scsi_command_sync(struct zfcp_unit *unit, struct scsi_cmnd *scpnt,
-		       struct timer_list *timer)
+		       int use_timer)
 {
 	int ret;
 	DECLARE_COMPLETION(wait);
 
 	scpnt->SCp.ptr = (void *) &wait;  /* silent re-use */
 	scpnt->scsi_done = zfcp_scsi_command_sync_handler;
-	ret = zfcp_scsi_command_async(unit->port->adapter, unit, scpnt, timer);
+	ret = zfcp_scsi_command_async(unit->port->adapter, unit, scpnt,
+				      use_timer);
 	if (ret == 0)
 		wait_for_completion(&wait);
 
@@ -341,7 +342,7 @@ zfcp_scsi_queuecommand(struct scsi_cmnd 
 	adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
 	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 
-	return zfcp_scsi_command_async(adapter, unit, scpnt, NULL);
+	return zfcp_scsi_command_async(adapter, unit, scpnt, 0);
 }
 
 static struct zfcp_unit *
@@ -538,8 +539,6 @@ zfcp_task_management_function(struct zfc
 
 /**
  * zfcp_scsi_eh_host_reset_handler - handler for host and bus reset
- *
- * If ERP is already running it will be stopped.
  */
 int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
@@ -638,16 +637,6 @@ zfcp_adapter_scsi_unregister(struct zfcp
 	return;
 }
 
-
-void
-zfcp_fsf_start_scsi_er_timer(struct zfcp_adapter *adapter)
-{
-	adapter->scsi_er_timer.function = zfcp_fsf_scsi_er_timeout_handler;
-	adapter->scsi_er_timer.data = (unsigned long) adapter;
-	adapter->scsi_er_timer.expires = jiffies + ZFCP_SCSI_ER_TIMEOUT;
-	add_timer(&adapter->scsi_er_timer);
-}
-
 /*
  * Support functions for FC transport class
  */
-- 
1.4.2.1.g80823

