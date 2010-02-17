From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/11] zfcp: Introduce header file for qdio structs and inline functions
Date: Wed, 17 Feb 2010 11:18:59 +0100
Message-ID: <20100217102019.322091000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37866 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0BQKUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:24 -0500
Content-Disposition: inline; filename=711-zfcp-header.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the qdio related structs and some helper functions to a new
zfcp_qdio.h header file. While doing this, rename the struct
zfcp_queue_req to zfcp_qdio_req to adhere to the naming scheme used in
zfcp. This allows a better seperation of the qdio code and inlining
the helper functions will save some function calls.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c  |    6 +-
 drivers/s390/scsi/zfcp_def.h  |   57 +--------------------
 drivers/s390/scsi/zfcp_ext.h  |    8 ---
 drivers/s390/scsi/zfcp_fsf.c  |   71 +++++++++++++--------------
 drivers/s390/scsi/zfcp_qdio.c |   48 +++---------------
 drivers/s390/scsi/zfcp_qdio.h |  109 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+), 137 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:31.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:33.000000000 +0100
@@ -140,9 +140,9 @@ void _zfcp_dbf_hba_fsf_response(const ch
 	memcpy(response->fsf_status_qual,
 	       fsf_status_qual, FSF_STATUS_QUALIFIER_SIZE);
 	response->fsf_req_status = fsf_req->status;
-	response->sbal_first = fsf_req->queue_req.sbal_first;
-	response->sbal_last = fsf_req->queue_req.sbal_last;
-	response->sbal_response = fsf_req->queue_req.sbal_response;
+	response->sbal_first = fsf_req->qdio_req.sbal_first;
+	response->sbal_last = fsf_req->qdio_req.sbal_last;
+	response->sbal_response = fsf_req->qdio_req.sbal_response;
 	response->pool = fsf_req->pool != NULL;
 	response->erp_action = (unsigned long)fsf_req->erp_action;
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:33.000000000 +0100
@@ -33,11 +33,11 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
 #include <asm/ccwdev.h>
-#include <asm/qdio.h>
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
 #include "zfcp_fsf.h"
+#include "zfcp_qdio.h"
 
 struct zfcp_reqlist;
 
@@ -127,12 +127,6 @@ struct zfcp_adapter_mempool {
 	mempool_t *qtcb_pool;
 };
 
-struct zfcp_qdio_queue {
-	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
-	u8		   first;	/* index of next free bfr in queue */
-	atomic_t           count;	/* number of free buffers in queue */
-};
-
 struct zfcp_erp_action {
 	struct list_head list;
 	int action;	              /* requested action code */
@@ -164,29 +158,6 @@ struct zfcp_latencies {
 	spinlock_t lock;
 };
 
-/** struct zfcp_qdio - basic QDIO data structure
- * @resp_q: response queue
- * @req_q: request queue
- * @stat_lock: lock to protect req_q_util and req_q_time
- * @req_q_lock; lock to serialize access to request queue
- * @req_q_time: time of last fill level change
- * @req_q_util: used for accounting
- * @req_q_full: queue full incidents
- * @req_q_wq: used to wait for SBAL availability
- * @adapter: adapter used in conjunction with this QDIO structure
- */
-struct zfcp_qdio {
-	struct zfcp_qdio_queue	resp_q;
-	struct zfcp_qdio_queue	req_q;
-	spinlock_t		stat_lock;
-	spinlock_t		req_q_lock;
-	unsigned long long	req_q_time;
-	u64			req_q_util;
-	atomic_t		req_q_full;
-	wait_queue_head_t	req_q_wq;
-	struct zfcp_adapter	*adapter;
-};
-
 struct zfcp_adapter {
 	struct kref		ref;
 	u64			peer_wwnn;	   /* P2P peer WWNN */
@@ -273,33 +244,11 @@ struct zfcp_unit {
 };
 
 /**
- * struct zfcp_queue_req - queue related values for a request
- * @sbal_number: number of free SBALs
- * @sbal_first: first SBAL for this request
- * @sbal_last: last SBAL for this request
- * @sbal_limit: last possible SBAL for this request
- * @sbale_curr: current SBALE at creation of this request
- * @sbal_response: SBAL used in interrupt
- * @qdio_outb_usage: usage of outbound queue
- * @qdio_inb_usage: usage of inbound queue
- */
-struct zfcp_queue_req {
-	u8		       sbal_number;
-	u8		       sbal_first;
-	u8		       sbal_last;
-	u8		       sbal_limit;
-	u8		       sbale_curr;
-	u8		       sbal_response;
-	u16		       qdio_outb_usage;
-	u16		       qdio_inb_usage;
-};
-
-/**
  * struct zfcp_fsf_req - basic FSF request structure
  * @list: list of FSF requests
  * @req_id: unique request ID
  * @adapter: adapter this request belongs to
- * @queue_req: queue related values
+ * @qdio_req: qdio queue related values
  * @completion: used to signal the completion of the request
  * @status: status of the request
  * @fsf_command: FSF command issued
@@ -317,7 +266,7 @@ struct zfcp_fsf_req {
 	struct list_head	list;
 	unsigned long		req_id;
 	struct zfcp_adapter	*adapter;
-	struct zfcp_queue_req	queue_req;
+	struct zfcp_qdio_req	qdio_req;
 	struct completion	completion;
 	u32			status;
 	u32			fsf_command;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-02-16 09:43:33.000000000 +0100
@@ -143,13 +143,9 @@ extern void zfcp_fsf_reqid_check(struct 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
 extern void zfcp_qdio_destroy(struct zfcp_qdio *);
-extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_queue_req *);
-extern struct qdio_buffer_element
-	*zfcp_qdio_sbale_req(struct zfcp_qdio *, struct zfcp_queue_req *);
-extern struct qdio_buffer_element
-	*zfcp_qdio_sbale_curr(struct zfcp_qdio *, struct zfcp_queue_req *);
+extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *,
-				   struct zfcp_queue_req *, unsigned long,
+				   struct zfcp_qdio_req *, unsigned long,
 				   struct scatterlist *, int);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:33.000000000 +0100
@@ -14,6 +14,7 @@
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 #include "zfcp_dbf.h"
+#include "zfcp_qdio.h"
 #include "zfcp_reqlist.h"
 
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
@@ -723,12 +724,12 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	req->adapter = adapter;
 	req->fsf_command = fsf_cmd;
 	req->req_id = adapter->req_no;
-	req->queue_req.sbal_number = 1;
-	req->queue_req.sbal_first = req_q->first;
-	req->queue_req.sbal_last = req_q->first;
-	req->queue_req.sbale_curr = 1;
+	req->qdio_req.sbal_number = 1;
+	req->qdio_req.sbal_first = req_q->first;
+	req->qdio_req.sbal_last = req_q->first;
+	req->qdio_req.sbale_curr = 1;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].addr = (void *) req->req_id;
 	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
@@ -772,9 +773,9 @@ static int zfcp_fsf_req_send(struct zfcp
 
 	zfcp_reqlist_add(adapter->req_list, req);
 
-	req->queue_req.qdio_outb_usage = atomic_read(&qdio->req_q.count);
+	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q.count);
 	req->issued = get_clock();
-	if (zfcp_qdio_send(qdio, &req->queue_req)) {
+	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
 		del_timer(&req->timer);
 		/* lookup request again, list might have changed */
 		zfcp_reqlist_find_rm(adapter->req_list, req_id);
@@ -815,9 +816,9 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
-	req->queue_req.sbale_curr = 2;
+	req->qdio_req.sbale_curr = 2;
 
 	sr_buf = mempool_alloc(adapter->pool.status_read_data, GFP_ATOMIC);
 	if (!sr_buf) {
@@ -826,7 +827,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	}
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
-	sbale = zfcp_qdio_sbale_curr(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_curr(qdio, &req->qdio_req);
 	sbale->addr = (void *) sr_buf;
 	sbale->length = sizeof(*sr_buf);
 
@@ -923,7 +924,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		goto out_error_free;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1018,7 +1019,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(adapter->qdio,
-							       &req->queue_req);
+							       &req->qdio_req);
 	u32 feat = adapter->adapter_features;
 	int bytes;
 
@@ -1036,15 +1037,15 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 		return 0;
 	}
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
+	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
 		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
-	req->queue_req.sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
+	req->qdio_req.sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
+	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	req->qtcb->bottom.support.resp_buf_length = bytes;
@@ -1240,7 +1241,7 @@ int zfcp_fsf_exchange_config_data(struct
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1282,7 +1283,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 		goto out_unlock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->handler = zfcp_fsf_exchange_config_data_handler;
@@ -1338,7 +1339,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1387,7 +1388,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (data)
 		req->data = data;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1502,7 +1503,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1572,7 +1573,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1649,7 +1650,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1704,7 +1705,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1798,7 +1799,7 @@ int zfcp_fsf_close_physical_port(struct 
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1971,7 +1972,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2057,7 +2058,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2100,8 +2101,8 @@ static void zfcp_fsf_req_trace(struct zf
 	blktrc.magic = ZFCP_BLK_DRV_DATA_MAGIC;
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		blktrc.flags |= ZFCP_BLK_REQ_ERROR;
-	blktrc.inb_usage = req->queue_req.qdio_inb_usage;
-	blktrc.outb_usage = req->queue_req.qdio_outb_usage;
+	blktrc.inb_usage = req->qdio_req.qdio_inb_usage;
+	blktrc.outb_usage = req->qdio_req.qdio_outb_usage;
 
 	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA) {
 		blktrc.flags |= ZFCP_BLK_LAT_VALID;
@@ -2330,11 +2331,11 @@ int zfcp_fsf_send_fcp_command_task(struc
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
-	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->queue_req, sbtype,
+	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sbtype,
 					     scsi_sglist(scsi_cmnd),
 					     FSF_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
-		if (req->queue_req.sbal_number >= FSF_MAX_SBALS_PER_REQ) {
+		if (req->qdio_req.sbal_number >= FSF_MAX_SBALS_PER_REQ) {
 			dev_err(&adapter->ccw_device->dev,
 				"Oversize data package, unit 0x%016Lx "
 				"on port 0x%016Lx closed\n",
@@ -2399,7 +2400,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2462,14 +2463,14 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 
 	req->handler = zfcp_fsf_control_file_handler;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
 	sbale[0].flags |= direction;
 
 	bottom = &req->qtcb->bottom.support;
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
 	bottom->option = fsf_cfdc->option;
 
-	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->queue_req,
+	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
 					direction, fsf_cfdc->sg,
 					FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
@@ -2517,8 +2518,8 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 			panic("error: unknown req_id (%lx) on adapter %s.\n",
 			      req_id, dev_name(&adapter->ccw_device->dev));
 
-		fsf_req->queue_req.sbal_response = sbal_idx;
-		fsf_req->queue_req.qdio_inb_usage =
+		fsf_req->qdio_req.sbal_response = sbal_idx;
+		fsf_req->qdio_req.qdio_inb_usage =
 			atomic_read(&qdio->resp_q.count);
 		zfcp_fsf_req_complete(fsf_req);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.c linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c	2010-02-16 09:43:33.000000000 +0100
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include "zfcp_ext.h"
+#include "zfcp_qdio.h"
 
 #define QBUFF_PER_PAGE		(PAGE_SIZE / sizeof(struct qdio_buffer))
 
@@ -28,12 +29,6 @@ static int zfcp_qdio_buffers_enqueue(str
 	return 0;
 }
 
-static struct qdio_buffer_element *
-zfcp_qdio_sbale(struct zfcp_qdio_queue *q, int sbal_idx, int sbale_idx)
-{
-	return &q->sbal[sbal_idx]->element[sbale_idx];
-}
-
 static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *id)
 {
 	struct zfcp_adapter *adapter = qdio->adapter;
@@ -145,32 +140,8 @@ static void zfcp_qdio_int_resp(struct cc
 	zfcp_qdio_resp_put_back(qdio, count);
 }
 
-/**
- * zfcp_qdio_sbale_req - return ptr to SBALE of req_q for a struct zfcp_fsf_req
- * @qdio: pointer to struct zfcp_qdio
- * @q_rec: pointer to struct zfcp_queue_rec
- * Returns: pointer to qdio_buffer_element (SBALE) structure
- */
-struct qdio_buffer_element *zfcp_qdio_sbale_req(struct zfcp_qdio *qdio,
-						struct zfcp_queue_req *q_req)
-{
-	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last, 0);
-}
-
-/**
- * zfcp_qdio_sbale_curr - return curr SBALE on req_q for a struct zfcp_fsf_req
- * @fsf_req: pointer to struct fsf_req
- * Returns: pointer to qdio_buffer_element (SBALE) structure
- */
-struct qdio_buffer_element *zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio,
-						 struct zfcp_queue_req *q_req)
-{
-	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last,
-			       q_req->sbale_curr);
-}
-
 static void zfcp_qdio_sbal_limit(struct zfcp_qdio *qdio,
-				 struct zfcp_queue_req *q_req, int max_sbals)
+				 struct zfcp_qdio_req *q_req, int max_sbals)
 {
 	int count = atomic_read(&qdio->req_q.count);
 	count = min(count, max_sbals);
@@ -179,7 +150,7 @@ static void zfcp_qdio_sbal_limit(struct 
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req,
+zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 		     unsigned long sbtype)
 {
 	struct qdio_buffer_element *sbale;
@@ -214,7 +185,7 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *q
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req,
+zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 		     unsigned int sbtype)
 {
 	if (q_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
@@ -224,7 +195,7 @@ zfcp_qdio_sbale_next(struct zfcp_qdio *q
 }
 
 static void zfcp_qdio_undo_sbals(struct zfcp_qdio *qdio,
-				 struct zfcp_queue_req *q_req)
+				 struct zfcp_qdio_req *q_req)
 {
 	struct qdio_buffer **sbal = qdio->req_q.sbal;
 	int first = q_req->sbal_first;
@@ -235,7 +206,7 @@ static void zfcp_qdio_undo_sbals(struct 
 }
 
 static int zfcp_qdio_fill_sbals(struct zfcp_qdio *qdio,
-				struct zfcp_queue_req *q_req,
+				struct zfcp_qdio_req *q_req,
 				unsigned int sbtype, void *start_addr,
 				unsigned int total_length)
 {
@@ -271,8 +242,7 @@ static int zfcp_qdio_fill_sbals(struct z
  * @max_sbals: upper bound for number of SBALs to be used
  * Returns: number of bytes, or error (negativ)
  */
-int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio,
-			    struct zfcp_queue_req *q_req,
+int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 			    unsigned long sbtype, struct scatterlist *sg,
 			    int max_sbals)
 {
@@ -304,10 +274,10 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 /**
  * zfcp_qdio_send - set PCI flag in first SBALE and send req to QDIO
  * @qdio: pointer to struct zfcp_qdio
- * @q_req: pointer to struct zfcp_queue_req
+ * @q_req: pointer to struct zfcp_qdio_req
  * Returns: 0 on success, error otherwise
  */
-int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_queue_req *q_req)
+int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
 	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 	int first = q_req->sbal_first;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.h linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.h
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.h	2010-02-16 09:43:33.000000000 +0100
@@ -0,0 +1,109 @@
+/*
+ * zfcp device driver
+ *
+ * Header file for zfcp qdio interface
+ *
+ * Copyright IBM Corporation 2010
+ */
+
+#ifndef ZFCP_QDIO_H
+#define ZFCP_QDIO_H
+
+#include <asm/qdio.h>
+
+/**
+ * struct zfcp_qdio_queue - qdio queue buffer, zfcp index and free count
+ * @sbal: qdio buffers
+ * @first: index of next free buffer in queue
+ * @count: number of free buffers in queue
+ */
+struct zfcp_qdio_queue {
+	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
+	u8		   first;
+	atomic_t           count;
+};
+
+/**
+ * struct zfcp_qdio - basic qdio data structure
+ * @resp_q: response queue
+ * @req_q: request queue
+ * @stat_lock: lock to protect req_q_util and req_q_time
+ * @req_q_lock: lock to serialize access to request queue
+ * @req_q_time: time of last fill level change
+ * @req_q_util: used for accounting
+ * @req_q_full: queue full incidents
+ * @req_q_wq: used to wait for SBAL availability
+ * @adapter: adapter used in conjunction with this qdio structure
+ */
+struct zfcp_qdio {
+	struct zfcp_qdio_queue	resp_q;
+	struct zfcp_qdio_queue	req_q;
+	spinlock_t		stat_lock;
+	spinlock_t		req_q_lock;
+	unsigned long long	req_q_time;
+	u64			req_q_util;
+	atomic_t		req_q_full;
+	wait_queue_head_t	req_q_wq;
+	struct zfcp_adapter	*adapter;
+};
+
+/**
+ * struct zfcp_qdio_req - qdio queue related values for a request
+ * @sbal_number: number of free sbals
+ * @sbal_first: first sbal for this request
+ * @sbal_last: last sbal for this request
+ * @sbal_limit: last possible sbal for this request
+ * @sbale_curr: current sbale at creation of this request
+ * @sbal_response: sbal used in interrupt
+ * @qdio_outb_usage: usage of outbound queue
+ * @qdio_inb_usage: usage of inbound queue
+ */
+struct zfcp_qdio_req {
+	u8	sbal_number;
+	u8	sbal_first;
+	u8	sbal_last;
+	u8	sbal_limit;
+	u8	sbale_curr;
+	u8	sbal_response;
+	u16	qdio_outb_usage;
+	u16	qdio_inb_usage;
+};
+
+/**
+ * zfcp_qdio_sbale - return pointer to sbale in qdio queue
+ * @q: queue where to find sbal
+ * @sbal_idx: sbal index in queue
+ * @sbale_idx: sbale index in sbal
+ */
+static inline struct qdio_buffer_element *
+zfcp_qdio_sbale(struct zfcp_qdio_queue *q, int sbal_idx, int sbale_idx)
+{
+	return &q->sbal[sbal_idx]->element[sbale_idx];
+}
+
+/**
+ * zfcp_qdio_sbale_req - return pointer to sbale on req_q for a request
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_rec: pointer to struct zfcp_qdio_req
+ * Returns: pointer to qdio_buffer_element (sbale) structure
+ */
+static inline struct qdio_buffer_element *
+zfcp_qdio_sbale_req(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
+{
+	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last, 0);
+}
+
+/**
+ * zfcp_qdio_sbale_curr - return current sbale on req_q for a request
+ * @qdio: pointer to struct zfcp_qdio
+ * @fsf_req: pointer to struct zfcp_fsf_req
+ * Returns: pointer to qdio_buffer_element (sbale) structure
+ */
+static inline struct qdio_buffer_element *
+zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
+{
+	return zfcp_qdio_sbale(&qdio->req_q, q_req->sbal_last,
+			       q_req->sbale_curr);
+}
+
+#endif /* ZFCP_QDIO_H */

