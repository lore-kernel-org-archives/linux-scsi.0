From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/27] zfcp: Separate qdio attributes from zfcp_fsf_req
Date: Tue, 18 Aug 2009 15:43:18 +0200
Message-ID: <20090818135030.464057000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56324 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012AbZHRNuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:40 -0400
Content-Disposition: inline; filename=714-zfcp-qdio-attributes.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Split all qdio related attributes out of zfcp_fsf_req and put it in
new structure.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c  |    6 +-
 drivers/s390/scsi/zfcp_def.h  |   84 ++++++++++++++++++++++++-------------
 drivers/s390/scsi/zfcp_ext.h  |   11 +++-
 drivers/s390/scsi/zfcp_fsf.c  |   79 ++++++++++++++++++----------------
 drivers/s390/scsi/zfcp_qdio.c |   95 ++++++++++++++++++++++--------------------
 5 files changed, 160 insertions(+), 115 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:29:09.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:29:29.000000000 +0200
@@ -152,9 +152,9 @@ void _zfcp_hba_dbf_event_fsf_response(co
 	memcpy(response->fsf_status_qual,
 	       fsf_status_qual, FSF_STATUS_QUALIFIER_SIZE);
 	response->fsf_req_status = fsf_req->status;
-	response->sbal_first = fsf_req->sbal_first;
-	response->sbal_last = fsf_req->sbal_last;
-	response->sbal_response = fsf_req->sbal_response;
+	response->sbal_first = fsf_req->queue_req.sbal_first;
+	response->sbal_last = fsf_req->queue_req.sbal_last;
+	response->sbal_response = fsf_req->queue_req.sbal_response;
 	response->pool = fsf_req->pool != NULL;
 	response->erp_action = (unsigned long)fsf_req->erp_action;
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:29.000000000 +0200
@@ -529,36 +529,64 @@ struct zfcp_unit {
 	struct work_struct	scsi_work;
 };
 
-/* FSF request */
+/**
+ * struct zfcp_queue_req - queue related values for a request
+ * @sbal_number: number of free SBALs
+ * @sbal_first: first SBAL for this request
+ * @sbal_last: last SBAL for this request
+ * @sbal_limit: last possible SBAL for this request
+ * @sbale_curr: current SBALE at creation of this request
+ * @sbal_response: SBAL used in interrupt
+ * @qdio_outb_usage: usage of outbound queue
+ * @qdio_inb_usage: usage of inbound queue
+ */
+struct zfcp_queue_req {
+	u8		       sbal_number;
+	u8		       sbal_first;
+	u8		       sbal_last;
+	u8		       sbal_limit;
+	u8		       sbale_curr;
+	u8		       sbal_response;
+	u16		       qdio_outb_usage;
+	u16		       qdio_inb_usage;
+};
+
+/**
+ * struct zfcp_fsf_req - basic FSF request structure
+ * @list: list of FSF requests
+ * @req_id: unique request ID
+ * @adapter: adapter this request belongs to
+ * @queue_req: queue related values
+ * @completion: used to signal the completion of the request
+ * @status: status of the request
+ * @fsf_command: FSF command issued
+ * @qtcb: associated QTCB
+ * @seq_no: sequence number of this request
+ * @data: private data
+ * @timer: timer data of this request
+ * @erp_action: reference to erp action if request issued on behalf of ERP
+ * @pool: reference to memory pool if used for this request
+ * @issued: time when request was send (STCK)
+ * @unit: reference to unit if this request is a SCSI request
+ * @handler: handler which should be called to process response
+ */
 struct zfcp_fsf_req {
-	struct list_head       list;	       /* list of FSF requests */
-	unsigned long	       req_id;	       /* unique request ID */
-	struct zfcp_adapter    *adapter;       /* adapter request belongs to */
-	u8		       sbal_number;    /* nr of SBALs free for use */
-	u8		       sbal_first;     /* first SBAL for this request */
-	u8		       sbal_last;      /* last SBAL for this request */
-	u8		       sbal_limit;      /* last possible SBAL for
-						  this reuest */
-	u8		       sbale_curr;     /* current SBALE during creation
-						  of request */
-	u8			sbal_response;	/* SBAL used in interrupt */
-	struct completion	completion;	/* can be used by a routine
-						  to wait for completion */
-	u32			status;	       /* status of this request */
-	u32		       fsf_command;    /* FSF Command copy */
-	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
-	u32		       seq_no;         /* Sequence number of request */
-	void			*data;           /* private data of request */
-	struct timer_list     timer;	       /* used for erp or scsi er */
-	struct zfcp_erp_action *erp_action;    /* used if this request is
-						  issued on behalf of erp */
-	mempool_t	       *pool;	       /* used if request was alloacted
-						  from emergency pool */
-	unsigned long long     issued;         /* request sent time (STCK) */
-	struct zfcp_unit       *unit;
+	struct list_head	list;
+	unsigned long		req_id;
+	struct zfcp_adapter	*adapter;
+	struct zfcp_queue_req	queue_req;
+	struct completion	completion;
+	u32			status;
+	u32			fsf_command;
+	struct fsf_qtcb		*qtcb;
+	u32			seq_no;
+	void			*data;
+	struct timer_list	timer;
+	struct zfcp_erp_action	*erp_action;
+	mempool_t		*pool;
+	unsigned long long	issued;
+	struct zfcp_unit	*unit;
 	void			(*handler)(struct zfcp_fsf_req *);
-	u16			qdio_outb_usage;/* usage of outbound queue */
-	u16			qdio_inb_usage;	/* usage of inbound queue */
 };
 
 /* driver data */
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:29.000000000 +0200
@@ -142,10 +142,13 @@ extern void zfcp_fsf_reqid_check(struct 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_allocate(struct zfcp_adapter *);
 extern void zfcp_qdio_free(struct zfcp_adapter *);
-extern int zfcp_qdio_send(struct zfcp_fsf_req *);
-extern struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_fsf_req *);
-extern struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_fsf_req *);
-extern int zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *, unsigned long,
+extern int zfcp_qdio_send(struct zfcp_adapter *, struct zfcp_queue_req *);
+extern struct qdio_buffer_element
+	*zfcp_qdio_sbale_req(struct zfcp_adapter *, struct zfcp_queue_req *);
+extern struct qdio_buffer_element
+	*zfcp_qdio_sbale_curr(struct zfcp_adapter *, struct zfcp_queue_req *);
+extern int zfcp_qdio_sbals_from_sg(struct zfcp_adapter *,
+				   struct zfcp_queue_req *, unsigned long,
 				   struct scatterlist *, int);
 extern int zfcp_qdio_open(struct zfcp_adapter *);
 extern void zfcp_qdio_close(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:29.000000000 +0200
@@ -720,12 +720,12 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	req->adapter = adapter;
 	req->fsf_command = fsf_cmd;
 	req->req_id = adapter->req_no;
-	req->sbal_number = 1;
-	req->sbal_first = req_q->first;
-	req->sbal_last = req_q->first;
-	req->sbale_curr = 1;
+	req->queue_req.sbal_number = 1;
+	req->queue_req.sbal_first = req_q->first;
+	req->queue_req.sbal_last = req_q->first;
+	req->queue_req.sbale_curr = 1;
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].addr = (void *) req->req_id;
 	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
@@ -774,9 +774,9 @@ static int zfcp_fsf_req_send(struct zfcp
 	list_add_tail(&req->list, &adapter->req_list[idx]);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	req->qdio_outb_usage = atomic_read(&adapter->req_q.count);
+	req->queue_req.qdio_outb_usage = atomic_read(&adapter->req_q.count);
 	req->issued = get_clock();
-	if (zfcp_qdio_send(req)) {
+	if (zfcp_qdio_send(adapter, &req->queue_req)) {
 		del_timer(&req->timer);
 		spin_lock_irqsave(&adapter->req_list_lock, flags);
 		/* lookup request again, list might have changed */
@@ -819,9 +819,9 @@ int zfcp_fsf_status_read(struct zfcp_ada
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
-	req->sbale_curr = 2;
+	req->queue_req.sbale_curr = 2;
 
 	sr_buf = mempool_alloc(adapter->pool.status_read_data, GFP_ATOMIC);
 	if (!sr_buf) {
@@ -830,7 +830,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	}
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
-	sbale = zfcp_qdio_sbale_curr(req);
+	sbale = zfcp_qdio_sbale_curr(adapter, &req->queue_req);
 	sbale->addr = (void *) sr_buf;
 	sbale->length = sizeof(*sr_buf);
 
@@ -929,7 +929,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		goto out_error_free;
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1023,8 +1023,10 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 				       struct scatterlist *sg_resp,
 				       int max_sbals)
 {
-	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(req);
-	u32 feat = req->adapter->adapter_features;
+	struct zfcp_adapter *adapter = req->adapter;
+	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(adapter,
+							       &req->queue_req);
+	u32 feat = adapter->adapter_features;
 	int bytes;
 
 	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS)) {
@@ -1041,14 +1043,16 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 		return 0;
 	}
 
-	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
+	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req,
+					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
 		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
-	req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
+	req->queue_req.sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
 
-	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
+	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req,
+					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	if (bytes <= 0)
 		return -EIO;
@@ -1241,7 +1245,7 @@ int zfcp_fsf_exchange_config_data(struct
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1283,7 +1287,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 		goto out_unlock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->handler = zfcp_fsf_exchange_config_data_handler;
@@ -1339,7 +1343,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1388,7 +1392,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (data)
 		req->data = data;
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1509,7 +1513,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1579,7 +1583,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1656,7 +1660,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1711,7 +1715,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1803,7 +1807,7 @@ int zfcp_fsf_close_physical_port(struct 
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1976,7 +1980,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2063,7 +2067,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2140,8 +2144,8 @@ static void zfcp_fsf_trace_latency(struc
 	}
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		trace.flags |= ZFCP_BLK_REQ_ERROR;
-	trace.inb_usage = fsf_req->qdio_inb_usage;
-	trace.outb_usage = fsf_req->qdio_outb_usage;
+	trace.inb_usage = fsf_req->queue_req.qdio_inb_usage;
+	trace.outb_usage = fsf_req->queue_req.qdio_outb_usage;
 
 	blk_add_driver_data(req->q, req, &trace, sizeof(trace));
 }
@@ -2420,11 +2424,11 @@ int zfcp_fsf_send_fcp_command_task(struc
 	req->qtcb->bottom.io.fcp_cmnd_length = sizeof(struct fcp_cmnd_iu) +
 		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(u32);
 
-	real_bytes = zfcp_qdio_sbals_from_sg(req, sbtype,
+	real_bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req, sbtype,
 					     scsi_sglist(scsi_cmnd),
 					     FSF_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
-		if (req->sbal_number >= FSF_MAX_SBALS_PER_REQ) {
+		if (req->queue_req.sbal_number >= FSF_MAX_SBALS_PER_REQ) {
 			dev_err(&adapter->ccw_device->dev,
 				"Oversize data package, unit 0x%016Lx "
 				"on port 0x%016Lx closed\n",
@@ -2492,7 +2496,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->bottom.io.fcp_cmnd_length = 	sizeof(struct fcp_cmnd_iu) +
 						sizeof(u32);
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2555,15 +2559,15 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 
 	req->handler = zfcp_fsf_control_file_handler;
 
-	sbale = zfcp_qdio_sbale_req(req);
+	sbale = zfcp_qdio_sbale_req(adapter, &req->queue_req);
 	sbale[0].flags |= direction;
 
 	bottom = &req->qtcb->bottom.support;
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
 	bottom->option = fsf_cfdc->option;
 
-	bytes = zfcp_qdio_sbals_from_sg(req, direction, fsf_cfdc->sg,
-					FSF_MAX_SBALS_PER_REQ);
+	bytes = zfcp_qdio_sbals_from_sg(adapter, &req->queue_req, direction,
+					fsf_cfdc->sg, FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
 		zfcp_fsf_req_free(req);
 		goto out;
@@ -2612,8 +2616,9 @@ void zfcp_fsf_reqid_check(struct zfcp_ad
 		list_del(&fsf_req->list);
 		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-		fsf_req->sbal_response = sbal_idx;
-		fsf_req->qdio_inb_usage = atomic_read(&adapter->resp_q.count);
+		fsf_req->queue_req.sbal_response = sbal_idx;
+		fsf_req->queue_req.qdio_inb_usage =
+			atomic_read(&adapter->resp_q.count);
 		zfcp_fsf_req_complete(fsf_req);
 
 		if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:29:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:29:29.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Setup and helper functions to access QDIO.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -165,12 +165,14 @@ static void zfcp_qdio_int_resp(struct cc
 
 /**
  * zfcp_qdio_sbale_req - return ptr to SBALE of req_q for a struct zfcp_fsf_req
- * @fsf_req: pointer to struct fsf_req
+ * @adapter: pointer to struct zfcp_adapter
+ * @q_rec: pointer to struct zfcp_queue_rec
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_fsf_req *req)
+struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_adapter *adapter,
+						struct zfcp_queue_req *q_req)
 {
-	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last, 0);
+	return zfcp_qdio_sbale(&adapter->req_q, q_req->sbal_last, 0);
 }
 
 /**
@@ -178,74 +180,80 @@ struct qdio_buffer_element *zfcp_qdio_sb
  * @fsf_req: pointer to struct fsf_req
  * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
-struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_fsf_req *req)
+struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_adapter *adapter,
+						 struct zfcp_queue_req *q_req)
 {
-	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last,
-			       req->sbale_curr);
+	return zfcp_qdio_sbale(&adapter->req_q, q_req->sbal_last,
+			       q_req->sbale_curr);
 }
 
-static void zfcp_qdio_sbal_limit(struct zfcp_fsf_req *fsf_req, int max_sbals)
+static void zfcp_qdio_sbal_limit(struct zfcp_adapter *adapter,
+				 struct zfcp_queue_req *q_req, int max_sbals)
 {
-	int count = atomic_read(&fsf_req->adapter->req_q.count);
+	int count = atomic_read(&adapter->req_q.count);
 	count = min(count, max_sbals);
-	fsf_req->sbal_limit = (fsf_req->sbal_first + count - 1)
+	q_req->sbal_limit = (q_req->sbal_first + count - 1)
 					% QDIO_MAX_BUFFERS_PER_Q;
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbal_chain(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
+zfcp_qdio_sbal_chain(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req,
+		     unsigned long sbtype)
 {
 	struct qdio_buffer_element *sbale;
 
 	/* set last entry flag in current SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_curr(fsf_req);
+	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	/* don't exceed last allowed SBAL */
-	if (fsf_req->sbal_last == fsf_req->sbal_limit)
+	if (q_req->sbal_last == q_req->sbal_limit)
 		return NULL;
 
 	/* set chaining flag in first SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(adapter, q_req);
 	sbale->flags |= SBAL_FLAGS0_MORE_SBALS;
 
 	/* calculate index of next SBAL */
-	fsf_req->sbal_last++;
-	fsf_req->sbal_last %= QDIO_MAX_BUFFERS_PER_Q;
+	q_req->sbal_last++;
+	q_req->sbal_last %= QDIO_MAX_BUFFERS_PER_Q;
 
 	/* keep this requests number of SBALs up-to-date */
-	fsf_req->sbal_number++;
+	q_req->sbal_number++;
 
 	/* start at first SBALE of new SBAL */
-	fsf_req->sbale_curr = 0;
+	q_req->sbale_curr = 0;
 
 	/* set storage-block type for new SBAL */
-	sbale = zfcp_qdio_sbale_curr(fsf_req);
+	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
 	sbale->flags |= sbtype;
 
 	return sbale;
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbale_next(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
+zfcp_qdio_sbale_next(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req,
+		     unsigned int sbtype)
 {
-	if (fsf_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
-		return zfcp_qdio_sbal_chain(fsf_req, sbtype);
-	fsf_req->sbale_curr++;
-	return zfcp_qdio_sbale_curr(fsf_req);
+	if (q_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
+		return zfcp_qdio_sbal_chain(adapter, q_req, sbtype);
+	q_req->sbale_curr++;
+	return zfcp_qdio_sbale_curr(adapter, q_req);
 }
 
-static void zfcp_qdio_undo_sbals(struct zfcp_fsf_req *fsf_req)
+static void zfcp_qdio_undo_sbals(struct zfcp_adapter *adapter,
+				 struct zfcp_queue_req *q_req)
 {
-	struct qdio_buffer **sbal = fsf_req->adapter->req_q.sbal;
-	int first = fsf_req->sbal_first;
-	int last = fsf_req->sbal_last;
+	struct qdio_buffer **sbal = adapter->req_q.sbal;
+	int first = q_req->sbal_first;
+	int last = q_req->sbal_last;
 	int count = (last - first + QDIO_MAX_BUFFERS_PER_Q) %
 		QDIO_MAX_BUFFERS_PER_Q + 1;
 	zfcp_qdio_zero_sbals(sbal, first, count);
 }
 
-static int zfcp_qdio_fill_sbals(struct zfcp_fsf_req *fsf_req,
+static int zfcp_qdio_fill_sbals(struct zfcp_adapter *adapter,
+				struct zfcp_queue_req *q_req,
 				unsigned int sbtype, void *start_addr,
 				unsigned int total_length)
 {
@@ -256,10 +264,10 @@ static int zfcp_qdio_fill_sbals(struct z
 	/* split segment up */
 	for (addr = start_addr, remaining = total_length; remaining > 0;
 	     addr += length, remaining -= length) {
-		sbale = zfcp_qdio_sbale_next(fsf_req, sbtype);
+		sbale = zfcp_qdio_sbale_next(adapter, q_req, sbtype);
 		if (!sbale) {
-			atomic_inc(&fsf_req->adapter->qdio_outb_full);
-			zfcp_qdio_undo_sbals(fsf_req);
+			atomic_inc(&adapter->qdio_outb_full);
+			zfcp_qdio_undo_sbals(adapter, q_req);
 			return -EINVAL;
 		}
 
@@ -281,29 +289,31 @@ static int zfcp_qdio_fill_sbals(struct z
  * @max_sbals: upper bound for number of SBALs to be used
  * Returns: number of bytes, or error (negativ)
  */
-int zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
-			    struct scatterlist *sg, int max_sbals)
+int zfcp_qdio_sbals_from_sg(struct zfcp_adapter *adapter,
+			    struct zfcp_queue_req *q_req,
+			    unsigned long sbtype, struct scatterlist *sg,
+			    int max_sbals)
 {
 	struct qdio_buffer_element *sbale;
 	int retval, bytes = 0;
 
 	/* figure out last allowed SBAL */
-	zfcp_qdio_sbal_limit(fsf_req, max_sbals);
+	zfcp_qdio_sbal_limit(adapter, q_req, max_sbals);
 
 	/* set storage-block type for this request */
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(adapter, q_req);
 	sbale->flags |= sbtype;
 
 	for (; sg; sg = sg_next(sg)) {
-		retval = zfcp_qdio_fill_sbals(fsf_req, sbtype, sg_virt(sg),
-					      sg->length);
+		retval = zfcp_qdio_fill_sbals(adapter, q_req, sbtype,
+					      sg_virt(sg), sg->length);
 		if (retval < 0)
 			return retval;
 		bytes += sg->length;
 	}
 
 	/* assume that no other SBALEs are to follow in the same SBAL */
-	sbale = zfcp_qdio_sbale_curr(fsf_req);
+	sbale = zfcp_qdio_sbale_curr(adapter, q_req);
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	return bytes;
@@ -314,12 +324,11 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
  * @fsf_req: pointer to struct zfcp_fsf_req
  * Returns: 0 on success, error otherwise
  */
-int zfcp_qdio_send(struct zfcp_fsf_req *fsf_req)
+int zfcp_qdio_send(struct zfcp_adapter *adapter, struct zfcp_queue_req *q_req)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-	int first = fsf_req->sbal_first;
-	int count = fsf_req->sbal_number;
+	int first = q_req->sbal_first;
+	int count = q_req->sbal_number;
 	int retval;
 	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 

