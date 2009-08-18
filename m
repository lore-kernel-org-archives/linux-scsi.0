From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 14/27] zfcp: Move qdio related data out of zfcp_adapter
Date: Tue, 18 Aug 2009 15:43:19 +0200
Message-ID: <20090818135030.604584000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49801 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013AbZHRNul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:41 -0400
Content-Disposition: inline; filename=715-zfcp-structure-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The zfcp_adapter structure was growing over time to a size of almost
one memory page. To reduce the size of the data structure and to
seperate different layers, put all qdio related data in the new
zfcp_qdio data structure.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   20 +-
 drivers/s390/scsi/zfcp_dbf.c   |    6 
 drivers/s390/scsi/zfcp_def.h   |   34 +++-
 drivers/s390/scsi/zfcp_erp.c   |    8 -
 drivers/s390/scsi/zfcp_ext.h   |   26 +--
 drivers/s390/scsi/zfcp_fsf.c   |  299 +++++++++++++++++++++--------------------
 drivers/s390/scsi/zfcp_qdio.c  |  222 ++++++++++++++++--------------
 drivers/s390/scsi/zfcp_scsi.c  |    6 
 drivers/s390/scsi/zfcp_sysfs.c |   16 +-
 9 files changed, 342 insertions(+), 295 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-12 12:37:22.000000000 +0200
@@ -428,7 +428,7 @@ static void zfcp_free_low_mem_buffers(st
 int zfcp_status_read_refill(struct zfcp_adapter *adapter)
 {
 	while (atomic_read(&adapter->stat_miss) > 0)
-		if (zfcp_fsf_status_read(adapter)) {
+		if (zfcp_fsf_status_read(adapter->qdio)) {
 			if (atomic_read(&adapter->stat_miss) >= 16) {
 				zfcp_erp_adapter_reopen(adapter, 0, "axsref1",
 							NULL);
@@ -507,11 +507,16 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		return -ENOMEM;
 	}
 
+	adapter->qdio = kzalloc(sizeof(struct zfcp_qdio), GFP_KERNEL);
+	if (!adapter->qdio)
+		goto qdio_mem_failed;
+
+	adapter->qdio->adapter = adapter;
 	ccw_device->handler = NULL;
 	adapter->ccw_device = ccw_device;
 	atomic_set(&adapter->refcount, 0);
 
-	if (zfcp_qdio_allocate(adapter))
+	if (zfcp_qdio_allocate(adapter->qdio, ccw_device))
 		goto qdio_allocate_failed;
 
 	if (zfcp_allocate_low_mem_buffers(adapter))
@@ -536,8 +541,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	spin_lock_init(&adapter->req_list_lock);
 
-	spin_lock_init(&adapter->req_q_lock);
-	spin_lock_init(&adapter->qdio_stat_lock);
+	spin_lock_init(&adapter->qdio->req_q_lock);
+	spin_lock_init(&adapter->qdio->stat_lock);
 
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
@@ -574,7 +579,9 @@ debug_register_failed:
 failed_low_mem_buffers:
 	zfcp_free_low_mem_buffers(adapter);
 qdio_allocate_failed:
-	zfcp_qdio_free(adapter);
+	zfcp_qdio_free(adapter->qdio);
+	kfree(adapter->qdio);
+qdio_mem_failed:
 	kfree(adapter);
 	return -ENOMEM;
 }
@@ -605,12 +612,13 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	zfcp_destroy_adapter_work_queue(adapter);
 	zfcp_adapter_debug_unregister(adapter);
-	zfcp_qdio_free(adapter);
+	zfcp_qdio_free(adapter->qdio);
 	zfcp_free_low_mem_buffers(adapter);
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
 	kfree(adapter->gs);
+	kfree(adapter->qdio);
 	kfree(adapter);
 }
 
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-08-12 12:37:22.000000000 +0200
@@ -274,16 +274,16 @@ void _zfcp_hba_dbf_event_fsf_unsol(const
 
 /**
  * zfcp_hba_dbf_event_qdio - trace event for QDIO related failure
- * @adapter: adapter affected by this QDIO related event
+ * @qdio: qdio structure affected by this QDIO related event
  * @qdio_error: as passed by qdio module
  * @sbal_index: first buffer with error condition, as passed by qdio module
  * @sbal_count: number of buffers affected, as passed by qdio module
  */
-void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *adapter,
+void zfcp_hba_dbf_event_qdio(struct zfcp_qdio *qdio,
 			     unsigned int qdio_error, int sbal_index,
 			     int sbal_count)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_dbf *dbf = qdio->adapter->dbf;
 	struct zfcp_hba_dbf_record *r = &dbf->hba_dbf_buf;
 	unsigned long flags;
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-12 12:37:37.000000000 +0200
@@ -428,6 +428,29 @@ struct zfcp_latencies {
 	spinlock_t lock;
 };
 
+/** struct zfcp_qdio - basic QDIO data structure
+ * @resp_q: response queue
+ * @req_q: request queue
+ * @stat_lock: lock to protect req_q_util and req_q_time
+ * @req_q_lock; lock to serialize access to request queue
+ * @req_q_time: time of last fill level change
+ * @req_q_util: used for accounting
+ * @req_q_full: queue full incidents
+ * @req_q_wq: used to wait for SBAL availability
+ * @adapter: adapter used in conjunction with this QDIO structure
+ */
+struct zfcp_qdio {
+	struct zfcp_qdio_queue	resp_q;
+	struct zfcp_qdio_queue	req_q;
+	spinlock_t		stat_lock;
+	spinlock_t		req_q_lock;
+	ktime_t			req_q_time;
+	u64			req_q_util;
+	atomic_t		req_q_full;
+	wait_queue_head_t	req_q_wq;
+	struct zfcp_adapter	*adapter;
+};
+
 struct zfcp_adapter {
 	atomic_t                refcount;          /* reference count */
 	wait_queue_head_t	remove_wq;         /* can be used to wait for
@@ -436,6 +459,7 @@ struct zfcp_adapter {
 	u64			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
+	struct zfcp_qdio	*qdio;
 	u32			hydra_version;	   /* Hydra version */
 	u32			fsf_lic_version;
 	u32			adapter_features;  /* FCP channel features */
@@ -447,15 +471,7 @@ struct zfcp_adapter {
 	unsigned long		req_no;		   /* unique FSF req number */
 	struct list_head	*req_list;	   /* list of pending reqs */
 	spinlock_t		req_list_lock;	   /* request list lock */
-	struct zfcp_qdio_queue	req_q;		   /* request queue */
-	spinlock_t		req_q_lock;	   /* for operations on queue */
-	ktime_t			req_q_time; /* time of last fill level change */
-	u64			req_q_util; /* for accounting */
-	spinlock_t		qdio_stat_lock;
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
-	wait_queue_head_t	request_wq;	   /* can be used to wait for
-						      more avaliable SBALs */
-	struct zfcp_qdio_queue	resp_q;	   /* response queue */
 	rwlock_t		abort_lock;        /* Protects against SCSI
 						      stack abort/command
 						      completion races */
@@ -478,13 +494,11 @@ struct zfcp_adapter {
 	struct zfcp_wka_ports	*gs;		   /* generic services */
 	struct zfcp_dbf		*dbf;		   /* debug traces */
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
-	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
 	struct work_struct	scan_work;
 	struct service_level	service_level;
-	atomic_t		qdio_outb_full;	   /* queue full incidents */
 	struct workqueue_struct	*work_queue;
 };
 
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-12 12:37:22.000000000 +0200
@@ -603,9 +603,11 @@ static void zfcp_erp_wakeup(struct zfcp_
 
 static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *act)
 {
-	if (zfcp_qdio_open(act->adapter))
+	struct zfcp_qdio *qdio = act->adapter->qdio;
+
+	if (zfcp_qdio_open(qdio))
 		return ZFCP_ERP_FAILED;
-	init_waitqueue_head(&act->adapter->request_wq);
+	init_waitqueue_head(&qdio->req_q_wq);
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &act->adapter->status);
 	return ZFCP_ERP_SUCCEEDED;
 }
@@ -710,7 +712,7 @@ static void zfcp_erp_adapter_strategy_cl
 	struct zfcp_adapter *adapter = act->adapter;
 
 	/* close queues to ensure that buffers are not accessed by adapter */
-	zfcp_qdio_close(adapter);
+	zfcp_qdio_close(adapter->qdio);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-12 12:37:22.000000000 +0200
@@ -51,7 +51,7 @@ extern void _zfcp_hba_dbf_event_fsf_resp
 extern void _zfcp_hba_dbf_event_fsf_unsol(const char *, int level,
 					  struct zfcp_adapter *,
 					  struct fsf_status_read_buffer *);
-extern void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *, unsigned int, int,
+extern void zfcp_hba_dbf_event_qdio(struct zfcp_qdio *, unsigned int, int,
 				    int);
 extern void zfcp_hba_dbf_event_berr(struct zfcp_adapter *,
 				    struct zfcp_fsf_req *);
@@ -118,15 +118,15 @@ extern int zfcp_fsf_close_physical_port(
 extern int zfcp_fsf_open_unit(struct zfcp_erp_action *);
 extern int zfcp_fsf_close_unit(struct zfcp_erp_action *);
 extern int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *);
-extern int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *,
+extern int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *,
 					      struct fsf_qtcb_bottom_config *);
 extern int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *);
-extern int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *,
+extern int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *,
 					    struct fsf_qtcb_bottom_port *);
 extern struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *,
 						  struct zfcp_fsf_cfdc *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
-extern int zfcp_fsf_status_read(struct zfcp_adapter *);
+extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
@@ -137,21 +137,21 @@ extern void zfcp_fsf_req_free(struct zfc
 extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *, u8);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long,
 						       struct zfcp_unit *);
-extern void zfcp_fsf_reqid_check(struct zfcp_adapter *, int);
+extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 
 /* zfcp_qdio.c */
-extern int zfcp_qdio_allocate(struct zfcp_adapter *);
-extern void zfcp_qdio_free(struct zfcp_adapter *);
-extern int zfcp_qdio_send(struct zfcp_adapter *, struct zfcp_queue_req *);
+extern int zfcp_qdio_allocate(struct zfcp_qdio *, struct ccw_device *);
+extern void zfcp_qdio_free(struct zfcp_qdio *);
+extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_queue_req *);
 extern struct qdio_buffer_element
-	*zfcp_qdio_sbale_req(struct zfcp_adapter *, struct zfcp_queue_req *);
+	*zfcp_qdio_sbale_req(struct zfcp_qdio *, struct zfcp_queue_req *);
 extern struct qdio_buffer_element
-	*zfcp_qdio_sbale_curr(struct zfcp_adapter *, struct zfcp_queue_req *);
-extern int zfcp_qdio_sbals_from_sg(struct zfcp_adapter *,
+	*zfcp_qdio_sbale_curr(struct zfcp_qdio *, struct zfcp_queue_req *);
+extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *,
 				   struct zfcp_queue_req *, unsigned long,
 				   struct scatterlist *, int);
-extern int zfcp_qdio_open(struct zfcp_adapter *);
-extern void zfcp_qdio_close(struct zfcp_adapter *);
+extern int zfcp_qdio_open(struct zfcp_qdio *);
+extern void zfcp_qdio_close(struct zfcp_qdio *);
 
 /* zfcp_scsi.c */
 extern struct zfcp_data zfcp_data;
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 12:37:22.000000000 +0200
@@ -637,33 +637,34 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_sbal_check(struct zfcp_adapter *adapter)
+static int zfcp_fsf_sbal_check(struct zfcp_qdio *qdio)
 {
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 
-	spin_lock_bh(&adapter->req_q_lock);
+	spin_lock_bh(&qdio->req_q_lock);
 	if (atomic_read(&req_q->count))
 		return 1;
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return 0;
 }
 
-static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
+static int zfcp_fsf_req_sbal_get(struct zfcp_qdio *qdio)
 {
+	struct zfcp_adapter *adapter = qdio->adapter;
 	long ret;
 
-	spin_unlock_bh(&adapter->req_q_lock);
-	ret = wait_event_interruptible_timeout(adapter->request_wq,
-			       zfcp_fsf_sbal_check(adapter), 5 * HZ);
+	spin_unlock_bh(&qdio->req_q_lock);
+	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
+			       zfcp_fsf_sbal_check(qdio), 5 * HZ);
 	if (ret > 0)
 		return 0;
 	if (!ret) {
-		atomic_inc(&adapter->qdio_outb_full);
+		atomic_inc(&qdio->req_q_full);
 		/* assume hanging outbound queue, try queue recovery */
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrsg_1", NULL);
 	}
 
-	spin_lock_bh(&adapter->req_q_lock);
+	spin_lock_bh(&qdio->req_q_lock);
 	return -EIO;
 }
 
@@ -700,11 +701,12 @@ static struct fsf_qtcb *zfcp_qtcb_alloc(
 	return qtcb;
 }
 
-static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
+static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 						u32 fsf_cmd, mempool_t *pool)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	struct zfcp_qdio_queue *req_q = &qdio->req_q;
+	struct zfcp_adapter *adapter = qdio->adapter;
 	struct zfcp_fsf_req *req = zfcp_fsf_alloc(pool);
 
 	if (unlikely(!req))
@@ -725,7 +727,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	req->queue_req.sbal_last = req_q->first;
 	req->queue_req.sbale_curr = 1;
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].addr = (void *) req->req_id;
 	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
@@ -740,7 +742,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 			return ERR_PTR(-ENOMEM);
 		}
 
-		req->qtcb->prefix.req_seq_no = req->adapter->fsf_req_seq_no;
+		req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
 		req->qtcb->prefix.req_id = req->req_id;
 		req->qtcb->prefix.ulp_info = 26;
 		req->qtcb->prefix.qtcb_type = fsf_qtcb_type[req->fsf_command];
@@ -764,6 +766,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_qdio *qdio = adapter->qdio;
 	unsigned long	     flags;
 	int		     idx;
 	int		     with_qtcb = (req->qtcb != NULL);
@@ -774,9 +777,9 @@ static int zfcp_fsf_req_send(struct zfcp
 	list_add_tail(&req->list, &adapter->req_list[idx]);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	req->queue_req.qdio_outb_usage = atomic_read(&adapter->req_q.count);
+	req->queue_req.qdio_outb_usage = atomic_read(&qdio->req_q.count);
 	req->issued = get_clock();
-	if (zfcp_qdio_send(adapter, &req->queue_req)) {
+	if (zfcp_qdio_send(qdio, &req->queue_req)) {
 		del_timer(&req->timer);
 		spin_lock_irqsave(&adapter->req_list_lock, flags);
 		/* lookup request again, list might have changed */
@@ -801,25 +804,26 @@ static int zfcp_fsf_req_send(struct zfcp
  * @req_flags: request flags
  * Returns: 0 on success, ERROR otherwise
  */
-int zfcp_fsf_status_read(struct zfcp_adapter *adapter)
+int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
 {
+	struct zfcp_adapter *adapter = qdio->adapter;
 	struct zfcp_fsf_req *req;
 	struct fsf_status_read_buffer *sr_buf;
 	struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS,
 				  adapter->pool.status_read_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->queue_req.sbale_curr = 2;
 
@@ -830,7 +834,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	}
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
-	sbale = zfcp_qdio_sbale_curr(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_curr(qdio, &req->queue_req);
 	sbale->addr = (void *) sr_buf;
 	sbale->length = sizeof(*sr_buf);
 
@@ -846,7 +850,7 @@ failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -913,13 +917,13 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
-				  adapter->pool.scsi_abort);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_ABORT_FCP_CMND,
+				  qdio->adapter->pool.scsi_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;
@@ -929,7 +933,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		goto out_error_free;
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -947,7 +951,7 @@ out_error_free:
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return req;
 }
 
@@ -1024,7 +1028,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 				       int max_sbals)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(adapter,
+	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(adapter->qdio,
 							       &req->queue_req);
 	u32 feat = adapter->adapter_features;
 	int bytes;
@@ -1043,7 +1047,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 		return 0;
 	}
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req,
+	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
@@ -1051,7 +1055,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	req->qtcb->bottom.support.req_buf_length = bytes;
 	req->queue_req.sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req,
+	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	if (bytes <= 0)
@@ -1071,15 +1075,15 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 		     struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_wka_port *wka_port = ct->wka_port;
-	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC, pool);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_GENERIC, pool);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1118,7 +1122,7 @@ failed_send:
 	if (erp_action)
 		erp_action->fsf_req = NULL;
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return ret;
 }
 
@@ -1181,15 +1185,15 @@ skip_fsfstatus:
 int zfcp_fsf_send_els(struct zfcp_send_els *els)
 {
 	struct zfcp_fsf_req *req;
-	struct zfcp_adapter *adapter = els->adapter;
+	struct zfcp_qdio *qdio = els->adapter->qdio;
 	struct fsf_qtcb_bottom_support *bottom;
 	int ret = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_ELS, NULL);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1221,7 +1225,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 failed_send:
 	zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return ret;
 }
 
@@ -1229,15 +1233,15 @@ int zfcp_fsf_exchange_config_data(struct
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1245,7 +1249,7 @@ int zfcp_fsf_exchange_config_data(struct
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1265,29 +1269,29 @@ int zfcp_fsf_exchange_config_data(struct
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
-int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
+int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 				       struct fsf_qtcb_bottom_config *data)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out_unlock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->handler = zfcp_fsf_exchange_config_data_handler;
@@ -1303,7 +1307,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	if (!retval)
 		wait_for_completion(&req->completion);
 
@@ -1311,7 +1315,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	return retval;
 
 out_unlock:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1322,20 +1326,20 @@ out_unlock:
  */
 int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 {
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
 
-	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
+	if (!(qdio->adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1343,7 +1347,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1358,31 +1362,31 @@ int zfcp_fsf_exchange_port_data(struct z
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
 /**
  * zfcp_fsf_exchange_port_data_sync - request information about local port
- * @adapter: pointer to struct zfcp_adapter
+ * @qdio: pointer to struct zfcp_qdio
  * @data: pointer to struct fsf_qtcb_bottom_port
  * Returns: 0 on success, error otherwise
  */
-int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
+int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 				     struct fsf_qtcb_bottom_port *data)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
+	if (!(qdio->adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1392,14 +1396,14 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (data)
 		req->data = data;
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 
 	if (!retval)
 		wait_for_completion(&req->completion);
@@ -1409,7 +1413,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	return retval;
 
 out_unlock:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1495,17 +1499,17 @@ out:
 int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_fsf_req *req;
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_port *port = erp_action->port;
+	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_PORT_WITH_DID,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1513,7 +1517,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1532,7 +1536,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		zfcp_port_put(port);
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1566,16 +1570,16 @@ static void zfcp_fsf_close_port_handler(
 int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1583,7 +1587,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1600,7 +1604,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1643,16 +1647,16 @@ out:
 int zfcp_fsf_open_wka_port(struct zfcp_wka_port *wka_port)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_PORT_WITH_DID,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
+				  qdio->adapter->pool.erp_req);
 
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
@@ -1660,7 +1664,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1673,7 +1677,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1698,16 +1702,16 @@ static void zfcp_fsf_close_wka_port_hand
 int zfcp_fsf_close_wka_port(struct zfcp_wka_port *wka_port)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
+				  qdio->adapter->pool.erp_req);
 
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
@@ -1715,7 +1719,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1728,7 +1732,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1790,16 +1794,16 @@ static void zfcp_fsf_close_physical_port
 int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PHYSICAL_PORT,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1807,7 +1811,7 @@ int zfcp_fsf_close_physical_port(struct 
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1824,7 +1828,7 @@ int zfcp_fsf_close_physical_port(struct 
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1964,14 +1968,15 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_qdio *qdio = adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_LUN,
 				  adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1980,7 +1985,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2001,7 +2006,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -2050,16 +2055,16 @@ static void zfcp_fsf_close_unit_handler(
 int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 {
 	struct qdio_buffer_element *sbale;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
-				  adapter->pool.erp_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_LUN,
+				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -2067,7 +2072,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2085,7 +2090,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -2353,18 +2358,19 @@ int zfcp_fsf_send_fcp_command_task(struc
 	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
 	int real_bytes, retval = -EIO;
 	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_qdio *qdio = adapter->qdio;
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&adapter->req_q_lock);
-	if (atomic_read(&adapter->req_q.count) <= 0) {
-		atomic_inc(&adapter->qdio_outb_full);
+	spin_lock(&qdio->req_q_lock);
+	if (atomic_read(&qdio->req_q.count) <= 0) {
+		atomic_inc(&qdio->req_q_full);
 		goto out;
 	}
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
 				  adapter->pool.scsi_req);
 
 	if (IS_ERR(req)) {
@@ -2424,7 +2430,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	req->qtcb->bottom.io.fcp_cmnd_length = sizeof(struct fcp_cmnd_iu) +
 		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(u32);
 
-	real_bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req, sbtype,
+	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->queue_req, sbtype,
 					     scsi_sglist(scsi_cmnd),
 					     FSF_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
@@ -2453,7 +2459,7 @@ failed_scsi_cmnd:
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
-	spin_unlock(&adapter->req_q_lock);
+	spin_unlock(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -2468,18 +2474,18 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
-				  adapter->pool.scsi_req);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
+				  qdio->adapter->pool.scsi_req);
 
 	if (IS_ERR(req)) {
 		req = NULL;
@@ -2496,7 +2502,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->bottom.io.fcp_cmnd_length = 	sizeof(struct fcp_cmnd_iu) +
 						sizeof(u32);
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2511,7 +2517,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 	return req;
 }
 
@@ -2529,6 +2535,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 					   struct zfcp_fsf_cfdc *fsf_cfdc)
 {
 	struct qdio_buffer_element *sbale;
+	struct zfcp_qdio *qdio = adapter->qdio;
 	struct zfcp_fsf_req *req = NULL;
 	struct fsf_qtcb_bottom_support *bottom;
 	int direction, retval = -EIO, bytes;
@@ -2547,11 +2554,11 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_bh(&adapter->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(adapter))
+	spin_lock_bh(&qdio->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, NULL);
+	req = zfcp_fsf_req_create(qdio, fsf_cfdc->command, NULL);
 	if (IS_ERR(req)) {
 		retval = -EPERM;
 		goto out;
@@ -2559,15 +2566,16 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 
 	req->handler = zfcp_fsf_control_file_handler;
 
-	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= direction;
 
 	bottom = &req->qtcb->bottom.support;
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
 	bottom->option = fsf_cfdc->option;
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req, direction,
-					fsf_cfdc->sg, FSF_MAX_SBALS_PER_REQ);
+	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->queue_req,
+					direction, fsf_cfdc->sg,
+					FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
 		zfcp_fsf_req_free(req);
 		goto out;
@@ -2576,7 +2584,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock_bh(&adapter->req_q_lock);
+	spin_unlock_bh(&qdio->req_q_lock);
 
 	if (!retval) {
 		wait_for_completion(&req->completion);
@@ -2590,9 +2598,10 @@ out:
  * @adapter: pointer to struct zfcp_adapter
  * @sbal_idx: response queue index of SBAL to be processed
  */
-void zfcp_fsf_reqid_check(struct zfcp_adapter *adapter, int sbal_idx)
+void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 {
-	struct qdio_buffer *sbal = adapter->resp_q.sbal[sbal_idx];
+	struct zfcp_adapter *adapter = qdio->adapter;
+	struct qdio_buffer *sbal = qdio->resp_q.sbal[sbal_idx];
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags, req_id;
@@ -2618,7 +2627,7 @@ void zfcp_fsf_reqid_check(struct zfcp_ad
 
 		fsf_req->queue_req.sbal_response = sbal_idx;
 		fsf_req->queue_req.qdio_inb_usage =
-			atomic_read(&adapter->resp_q.count);
+			atomic_read(&qdio->resp_q.count);
 		zfcp_fsf_req_complete(fsf_req);
 
 		if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-12 12:39:17.000000000 +0200
@@ -36,18 +36,18 @@ zfcp_qdio_sbale(struct zfcp_qdio_queue *
 
 /**
  * zfcp_qdio_free - free memory used by request- and resposne queue
- * @adapter: pointer to the zfcp_adapter structure
+ * @qdio: pointer to the zfcp_qdio structure
  */
-void zfcp_qdio_free(struct zfcp_adapter *adapter)
+void zfcp_qdio_free(struct zfcp_qdio *qdio)
 {
 	struct qdio_buffer **sbal_req, **sbal_resp;
 	int p;
 
-	if (adapter->ccw_device)
-		qdio_free(adapter->ccw_device);
+	if (qdio->adapter->ccw_device)
+		qdio_free(qdio->adapter->ccw_device);
 
-	sbal_req = adapter->req_q.sbal;
-	sbal_resp = adapter->resp_q.sbal;
+	sbal_req = qdio->req_q.sbal;
+	sbal_resp = qdio->resp_q.sbal;
 
 	for (p = 0; p < QDIO_MAX_BUFFERS_PER_Q; p += QBUFF_PER_PAGE) {
 		free_page((unsigned long) sbal_req[p]);
@@ -55,8 +55,10 @@ void zfcp_qdio_free(struct zfcp_adapter 
 	}
 }
 
-static void zfcp_qdio_handler_error(struct zfcp_adapter *adapter, char *id)
+static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *id)
 {
+	struct zfcp_adapter *adapter = qdio->adapter;
+
 	dev_warn(&adapter->ccw_device->dev, "A QDIO problem occurred\n");
 
 	zfcp_erp_adapter_reopen(adapter,
@@ -75,47 +77,47 @@ static void zfcp_qdio_zero_sbals(struct 
 }
 
 /* this needs to be called prior to updating the queue fill level */
-static void zfcp_qdio_account(struct zfcp_adapter *adapter)
+static void zfcp_qdio_account(struct zfcp_qdio *qdio)
 {
 	ktime_t now;
 	s64 span;
 	int free, used;
 
-	spin_lock(&adapter->qdio_stat_lock);
+	spin_lock(&qdio->stat_lock);
 	now = ktime_get();
-	span = ktime_us_delta(now, adapter->req_q_time);
-	free = max(0, atomic_read(&adapter->req_q.count));
+	span = ktime_us_delta(now, qdio->req_q_time);
+	free = max(0, atomic_read(&qdio->req_q.count));
 	used = QDIO_MAX_BUFFERS_PER_Q - free;
-	adapter->req_q_util += used * span;
-	adapter->req_q_time = now;
-	spin_unlock(&adapter->qdio_stat_lock);
+	qdio->req_q_util += used * span;
+	qdio->req_q_time = now;
+	spin_unlock(&qdio->stat_lock);
 }
 
 static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int qdio_err,
 			      int queue_no, int first, int count,
 			      unsigned long parm)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
-	struct zfcp_qdio_queue *queue = &adapter->req_q;
+	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
+	struct zfcp_qdio_queue *queue = &qdio->req_q;
 
 	if (unlikely(qdio_err)) {
-		zfcp_hba_dbf_event_qdio(adapter, qdio_err, first, count);
-		zfcp_qdio_handler_error(adapter, "qdireq1");
+		zfcp_hba_dbf_event_qdio(qdio, qdio_err, first, count);
+		zfcp_qdio_handler_error(qdio, "qdireq1");
 		return;
 	}
 
 	/* cleanup all SBALs being program-owned now */
 	zfcp_qdio_zero_sbals(queue->sbal, first, count);
 
-	zfcp_qdio_account(adapter);
+	zfcp_qdio_account(qdio);
 	atomic_add(count, &queue->count);
-	wake_up(&adapter->request_wq);
+	wake_up(&qdio->req_q_wq);
 }
 
-static void zfcp_qdio_resp_put_back(struct zfcp_adapter *adapter, int processed)
+static void zfcp_qdio_resp_put_back(struct zfcp_qdio *qdio, int processed)
 {
-	struct zfcp_qdio_queue *queue = &adapter->resp_q;
-	struct ccw_device *cdev = adapter->ccw_device;
+	struct zfcp_qdio_queue *queue = &qdio->resp_q;
+	struct ccw_device *cdev = qdio->adapter->ccw_device;
 	u8 count, start = queue->first;
 	unsigned int retval;
 
@@ -137,12 +139,12 @@ static void zfcp_qdio_int_resp(struct cc
 			       int queue_no, int first, int count,
 			       unsigned long parm)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
+	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
 	int sbal_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
-		zfcp_hba_dbf_event_qdio(adapter, qdio_err, first, count);
-		zfcp_qdio_handler_error(adapter, "qdires1");
+		zfcp_hba_dbf_event_qdio(qdio, qdio_err, first, count);
+		zfcp_qdio_handler_error(qdio, "qdires1");
 		return;
 	}
 
@@ -153,26 +155,26 @@ static void zfcp_qdio_int_resp(struct cc
 	for (sbal_no = 0; sbal_no < count; sbal_no++) {
 		sbal_idx = (first + sbal_no) % QDIO_MAX_BUFFERS_PER_Q;
 		/* go through all SBALEs of SBAL */
-		zfcp_fsf_reqid_check(adapter, sbal_idx);
+		zfcp_fsf_reqid_check(qdio, sbal_idx);
 	}
 
 	/*
 	 * put range of SBALs back to response queue
 	 * (including SBALs which have already been free before)
 	 */
-	zfcp_qdio_resp_put_back(adapter, count);
+	zfcp_qdio_resp_put_back(qdio, count);
 }
 
 /**
  * zfcp_qdio_sbale_req - return ptr to SBALE of req_q for a struct zfcp_fsf_req
- * @adapter: pointer to struct zfcp_adapter
+ * @qdio: pointer to struct zfcp_qdio
  * @q_rec: pointer to struct zfcp_queue_rec
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_adapter *adapter,
+struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_qdio *qdio,
 						struct zfcp_queue_req *q_req)
 {
-	return zfcp_qdio_sbale(&adapter->req_q, q_req->sbal_last, 0);
+	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last, 0);
 }
 
 /**
@@ -180,30 +182,30 @@ struct qdio_buffer_element *zfcp_qdio_sb
  * @fsf_req: pointer to struct fsf_req
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_adapter *adapter,
+struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio,
 						 struct zfcp_queue_req *q_req)
 {
-	return zfcp_qdio_sbale(&adapter->req_q, q_req->sbal_last,
+	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last,
 			       q_req->sbale_curr);
 }
 
-static void zfcp_qdio_sbal_limit(struct zfcp_adapter *adapter,
+static void zfcp_qdio_sbal_limit(struct zfcp_qdio *qdio,
 				 struct zfcp_queue_req *q_req, int max_sbals)
 {
-	int count = atomic_read(&adapter->req_q.count);
+	int count = atomic_read(&qdio->req_q.count);
 	count = min(count, max_sbals);
 	q_req->sbal_limit = (q_req->sbal_first + count - 1)
 					% QDIO_MAX_BUFFERS_PER_Q;
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbal_chain(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req,
+zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req,
 		     unsigned long sbtype)
 {
 	struct qdio_buffer_element *sbale;
 
 	/* set last entry flag in current SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
+	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	/* don't exceed last allowed SBAL */
@@ -211,7 +213,7 @@ zfcp_qdio_sbal_chain(struct zfcp_adapter
 		return NULL;
 
 	/* set chaining flag in first SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_req(adapter, q_req);
+	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->flags |= SBAL_FLAGS0_MORE_SBALS;
 
 	/* calculate index of next SBAL */
@@ -225,26 +227,26 @@ zfcp_qdio_sbal_chain(struct zfcp_adapter
 	q_req->sbale_curr = 0;
 
 	/* set storage-block type for new SBAL */
-	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
+	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
 	sbale->flags |= sbtype;
 
 	return sbale;
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbale_next(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req,
+zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req,
 		     unsigned int sbtype)
 {
 	if (q_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
-		return zfcp_qdio_sbal_chain(adapter, q_req, sbtype);
+		return zfcp_qdio_sbal_chain(qdio, q_req, sbtype);
 	q_req->sbale_curr++;
-	return zfcp_qdio_sbale_curr(adapter, q_req);
+	return zfcp_qdio_sbale_curr(qdio, q_req);
 }
 
-static void zfcp_qdio_undo_sbals(struct zfcp_adapter *adapter,
+static void zfcp_qdio_undo_sbals(struct zfcp_qdio *qdio,
 				 struct zfcp_queue_req *q_req)
 {
-	struct qdio_buffer **sbal = adapter->req_q.sbal;
+	struct qdio_buffer **sbal = qdio->req_q.sbal;
 	int first = q_req->sbal_first;
 	int last = q_req->sbal_last;
 	int count = (last - first + QDIO_MAX_BUFFERS_PER_Q) %
@@ -252,7 +254,7 @@ static void zfcp_qdio_undo_sbals(struct 
 	zfcp_qdio_zero_sbals(sbal, first, count);
 }
 
-static int zfcp_qdio_fill_sbals(struct zfcp_adapter *adapter,
+static int zfcp_qdio_fill_sbals(struct zfcp_qdio *qdio,
 				struct zfcp_queue_req *q_req,
 				unsigned int sbtype, void *start_addr,
 				unsigned int total_length)
@@ -264,10 +266,10 @@ static int zfcp_qdio_fill_sbals(struct z
 	/* split segment up */
 	for (addr = start_addr, remaining = total_length; remaining > 0;
 	     addr += length, remaining -= length) {
-		sbale = zfcp_qdio_sbale_next(adapter, q_req, sbtype);
+		sbale = zfcp_qdio_sbale_next(qdio, q_req, sbtype);
 		if (!sbale) {
-			atomic_inc(&adapter->qdio_outb_full);
-			zfcp_qdio_undo_sbals(adapter, q_req);
+			atomic_inc(&qdio->req_q_full);
+			zfcp_qdio_undo_sbals(qdio, q_req);
 			return -EINVAL;
 		}
 
@@ -289,7 +291,7 @@ static int zfcp_qdio_fill_sbals(struct z
  * @max_sbals: upper bound for number of SBALs to be used
  * Returns: number of bytes, or error (negativ)
  */
-int zfcp_qdio_sbals_from_sg(struct zfcp_adapter *adapter,
+int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio,
 			    struct zfcp_queue_req *q_req,
 			    unsigned long sbtype, struct scatterlist *sg,
 			    int max_sbals)
@@ -298,14 +300,14 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 	int retval, bytes = 0;
 
 	/* figure out last allowed SBAL */
-	zfcp_qdio_sbal_limit(adapter, q_req, max_sbals);
+	zfcp_qdio_sbal_limit(qdio, q_req, max_sbals);
 
 	/* set storage-block type for this request */
-	sbale = zfcp_qdio_sbale_req(adapter, q_req);
+	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->flags |= sbtype;
 
 	for (; sg; sg = sg_next(sg)) {
-		retval = zfcp_qdio_fill_sbals(adapter, q_req, sbtype,
+		retval = zfcp_qdio_fill_sbals(qdio, q_req, sbtype,
 					      sg_virt(sg), sg->length);
 		if (retval < 0)
 			return retval;
@@ -313,7 +315,7 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 	}
 
 	/* assume that no other SBALEs are to follow in the same SBAL */
-	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
+	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	return bytes;
@@ -321,20 +323,22 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 
 /**
  * zfcp_qdio_send - set PCI flag in first SBALE and send req to QDIO
- * @fsf_req: pointer to struct zfcp_fsf_req
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: pointer to struct zfcp_queue_req
  * Returns: 0 on success, error otherwise
  */
-int zfcp_qdio_send(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req)
+int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req)
 {
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 	int first = q_req->sbal_first;
 	int count = q_req->sbal_number;
 	int retval;
 	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 
-	zfcp_qdio_account(adapter);
+	zfcp_qdio_account(qdio);
 
-	retval = do_QDIO(adapter->ccw_device, qdio_flags, 0, first, count);
+	retval = do_QDIO(qdio->adapter->ccw_device, qdio_flags, 0, first,
+			 count);
 	if (unlikely(retval)) {
 		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
 		return retval;
@@ -347,63 +351,69 @@ int zfcp_qdio_send(struct zfcp_adapter *
 	return 0;
 }
 
+
+static void zfcp_qdio_setup_init_data(struct qdio_initialize *id,
+				      struct zfcp_qdio *qdio)
+{
+
+	id->cdev = qdio->adapter->ccw_device;
+	id->q_format = QDIO_ZFCP_QFMT;
+	memcpy(id->adapter_name, dev_name(&id->cdev->dev), 8);
+	ASCEBC(id->adapter_name, 8);
+	id->qib_param_field_format = 0;
+	id->qib_param_field = NULL;
+	id->input_slib_elements = NULL;
+	id->output_slib_elements = NULL;
+	id->no_input_qs = 1;
+	id->no_output_qs = 1;
+	id->input_handler = zfcp_qdio_int_resp;
+	id->output_handler = zfcp_qdio_int_req;
+	id->int_parm = (unsigned long) qdio;
+	id->flags = QDIO_INBOUND_0COPY_SBALS |
+		    QDIO_OUTBOUND_0COPY_SBALS | QDIO_USE_OUTBOUND_PCIS;
+	id->input_sbal_addr_array = (void **) (qdio->resp_q.sbal);
+	id->output_sbal_addr_array = (void **) (qdio->req_q.sbal);
+
+}
 /**
  * zfcp_qdio_allocate - allocate queue memory and initialize QDIO data
  * @adapter: pointer to struct zfcp_adapter
  * Returns: -ENOMEM on memory allocation error or return value from
  *          qdio_allocate
  */
-int zfcp_qdio_allocate(struct zfcp_adapter *adapter)
+int zfcp_qdio_allocate(struct zfcp_qdio *qdio, struct ccw_device *ccw_dev)
 {
-	struct qdio_initialize *init_data;
+	struct qdio_initialize init_data;
 
-	if (zfcp_qdio_buffers_enqueue(adapter->req_q.sbal) ||
-		   zfcp_qdio_buffers_enqueue(adapter->resp_q.sbal))
+	if (zfcp_qdio_buffers_enqueue(qdio->req_q.sbal) ||
+	    zfcp_qdio_buffers_enqueue(qdio->resp_q.sbal))
 		return -ENOMEM;
 
-	init_data = &adapter->qdio_init_data;
-
-	init_data->cdev = adapter->ccw_device;
-	init_data->q_format = QDIO_ZFCP_QFMT;
-	memcpy(init_data->adapter_name, dev_name(&adapter->ccw_device->dev), 8);
-	ASCEBC(init_data->adapter_name, 8);
-	init_data->qib_param_field_format = 0;
-	init_data->qib_param_field = NULL;
-	init_data->input_slib_elements = NULL;
-	init_data->output_slib_elements = NULL;
-	init_data->no_input_qs = 1;
-	init_data->no_output_qs = 1;
-	init_data->input_handler = zfcp_qdio_int_resp;
-	init_data->output_handler = zfcp_qdio_int_req;
-	init_data->int_parm = (unsigned long) adapter;
-	init_data->flags = QDIO_INBOUND_0COPY_SBALS |
-			QDIO_OUTBOUND_0COPY_SBALS | QDIO_USE_OUTBOUND_PCIS;
-	init_data->input_sbal_addr_array =
-			(void **) (adapter->resp_q.sbal);
-	init_data->output_sbal_addr_array =
-			(void **) (adapter->req_q.sbal);
+	zfcp_qdio_setup_init_data(&init_data, qdio);
 
-	return qdio_allocate(init_data);
+	return qdio_allocate(&init_data);
 }
 
 /**
  * zfcp_close_qdio - close qdio queues for an adapter
+ * @qdio: pointer to structure zfcp_qdio
  */
-void zfcp_qdio_close(struct zfcp_adapter *adapter)
+void zfcp_qdio_close(struct zfcp_qdio *qdio)
 {
 	struct zfcp_qdio_queue *req_q;
 	int first, count;
 
-	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
+	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return;
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
-	req_q = &adapter->req_q;
-	spin_lock_bh(&adapter->req_q_lock);
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	spin_unlock_bh(&adapter->req_q_lock);
+	req_q = &qdio->req_q;
+	spin_lock_bh(&qdio->req_q_lock);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
+	spin_unlock_bh(&qdio->req_q_lock);
 
-	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
+	qdio_shutdown(qdio->adapter->ccw_device,
+		      QDIO_FLAG_CLEANUP_USING_CLEAR);
 
 	/* cleanup used outbound sbals */
 	count = atomic_read(&req_q->count);
@@ -414,50 +424,54 @@ void zfcp_qdio_close(struct zfcp_adapter
 	}
 	req_q->first = 0;
 	atomic_set(&req_q->count, 0);
-	adapter->resp_q.first = 0;
-	atomic_set(&adapter->resp_q.count, 0);
+	qdio->resp_q.first = 0;
+	atomic_set(&qdio->resp_q.count, 0);
 }
 
 /**
  * zfcp_qdio_open - prepare and initialize response queue
- * @adapter: pointer to struct zfcp_adapter
+ * @qdio: pointer to struct zfcp_qdio
  * Returns: 0 on success, otherwise -EIO
  */
-int zfcp_qdio_open(struct zfcp_adapter *adapter)
+int zfcp_qdio_open(struct zfcp_qdio *qdio)
 {
 	struct qdio_buffer_element *sbale;
+	struct qdio_initialize init_data;
+	struct ccw_device *cdev = qdio->adapter->ccw_device;
 	int cc;
 
-	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
+	if (atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
 		return -EIO;
 
-	if (qdio_establish(&adapter->qdio_init_data))
+	zfcp_qdio_setup_init_data(&init_data, qdio);
+
+	if (qdio_establish(&init_data))
 		goto failed_establish;
 
-	if (qdio_activate(adapter->ccw_device))
+	if (qdio_activate(cdev))
 		goto failed_qdio;
 
 	for (cc = 0; cc < QDIO_MAX_BUFFERS_PER_Q; cc++) {
-		sbale = &(adapter->resp_q.sbal[cc]->element[0]);
+		sbale = &(qdio->resp_q.sbal[cc]->element[0]);
 		sbale->length = 0;
 		sbale->flags = SBAL_FLAGS_LAST_ENTRY;
 		sbale->addr = NULL;
 	}
 
-	if (do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_INPUT, 0, 0,
+	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, 0,
 		     QDIO_MAX_BUFFERS_PER_Q))
 		goto failed_qdio;
 
 	/* set index of first avalable SBALS / number of available SBALS */
-	adapter->req_q.first = 0;
-	atomic_set(&adapter->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
+	qdio->req_q.first = 0;
+	atomic_set(&qdio->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
 
 	return 0;
 
 failed_qdio:
-	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
+	qdio_shutdown(cdev, QDIO_FLAG_CLEANUP_USING_CLEAR);
 failed_establish:
-	dev_err(&adapter->ccw_device->dev,
+	dev_err(&cdev->dev,
 		"Setting up the QDIO connection to the FCP adapter failed\n");
 	return -EIO;
 }
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-12 12:37:22.000000000 +0200
@@ -225,7 +225,7 @@ static int zfcp_task_mgmt_function(struc
 {
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_adapter *adapter = unit->port->adapter;
-	struct zfcp_fsf_req *fsf_req;
+	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS;
 	int retry = 3;
 
@@ -429,7 +429,7 @@ static struct fc_host_statistics *zfcp_g
 	if (!data)
 		return NULL;
 
-	ret = zfcp_fsf_exchange_port_data_sync(adapter, data);
+	ret = zfcp_fsf_exchange_port_data_sync(adapter->qdio, data);
 	if (ret) {
 		kfree(data);
 		return NULL;
@@ -458,7 +458,7 @@ static void zfcp_reset_fc_host_stats(str
 	if (!data)
 		return;
 
-	ret = zfcp_fsf_exchange_port_data_sync(adapter, data);
+	ret = zfcp_fsf_exchange_port_data_sync(adapter->qdio, data);
 	if (ret)
 		kfree(data);
 	else {
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-08-12 12:36:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-08-12 12:37:22.000000000 +0200
@@ -425,7 +425,7 @@ static ssize_t zfcp_sysfs_adapter_util_s
 	if (!qtcb_port)
 		return -ENOMEM;
 
-	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	retval = zfcp_fsf_exchange_port_data_sync(adapter->qdio, qtcb_port);
 	if (!retval)
 		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
 				 qtcb_port->cb_util, qtcb_port->a_util);
@@ -451,7 +451,7 @@ static int zfcp_sysfs_adapter_ex_config(
 	if (!qtcb_config)
 		return -ENOMEM;
 
-	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	retval = zfcp_fsf_exchange_config_data_sync(adapter->qdio, qtcb_config);
 	if (!retval)
 		*stat_inf = qtcb_config->stat_info;
 
@@ -492,15 +492,15 @@ static ssize_t zfcp_sysfs_adapter_q_full
 					      char *buf)
 {
 	struct Scsi_Host *scsi_host = class_to_shost(dev);
-	struct zfcp_adapter *adapter =
-		(struct zfcp_adapter *) scsi_host->hostdata[0];
+	struct zfcp_qdio *qdio =
+		((struct zfcp_adapter *) scsi_host->hostdata[0])->qdio;
 	u64 util;
 
-	spin_lock_bh(&adapter->qdio_stat_lock);
-	util = adapter->req_q_util;
-	spin_unlock_bh(&adapter->qdio_stat_lock);
+	spin_lock_bh(&qdio->stat_lock);
+	util = qdio->req_q_util;
+	spin_unlock_bh(&qdio->stat_lock);
 
-	return sprintf(buf, "%d %llu\n", atomic_read(&adapter->qdio_outb_full),
+	return sprintf(buf, "%d %llu\n", atomic_read(&qdio->req_q_full),
 		       (unsigned long long)util);
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);

