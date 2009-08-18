From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 16/27] zfcp: Update dbf calls
Date: Tue, 18 Aug 2009 15:43:21 +0200
Message-ID: <20090818135030.880689000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57700 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZHRNug (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:36 -0400
Content-Disposition: inline; filename=717-zfcp-structure-cleanup-2.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Change the dbf data and functions to use the zfcp_dbf prefix
throughout the code. Also change the calls to dbf to use zfcp_dbf
instead of zfcp_adapter.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    7 
 drivers/s390/scsi/zfcp_dbf.c  |  408 +++++++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_dbf.h  |  152 +++++++--------
 drivers/s390/scsi/zfcp_erp.c  |   49 ++---
 drivers/s390/scsi/zfcp_ext.h  |   52 ++---
 drivers/s390/scsi/zfcp_fc.c   |    2 
 drivers/s390/scsi/zfcp_fsf.c  |   24 +-
 drivers/s390/scsi/zfcp_qdio.c |    6 
 drivers/s390/scsi/zfcp_scsi.c |   27 +-
 9 files changed, 347 insertions(+), 380 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 13:26:55.000000000 +0200
@@ -517,6 +517,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		goto qdio_mem_failed;
 
 	adapter->qdio->adapter = adapter;
+
 	ccw_device->handler = NULL;
 	adapter->ccw_device = ccw_device;
 	atomic_set(&adapter->refcount, 0);
@@ -530,7 +531,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (zfcp_reqlist_alloc(adapter))
 		goto failed_low_mem_buffers;
 
-	if (zfcp_adapter_debug_register(adapter))
+	if (zfcp_dbf_adapter_register(adapter))
 		goto debug_register_failed;
 
 	if (zfcp_setup_adapter_work_queue(adapter))
@@ -577,7 +578,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 sysfs_failed:
 	zfcp_destroy_adapter_work_queue(adapter);
 work_queue_failed:
-	zfcp_adapter_debug_unregister(adapter);
+	zfcp_dbf_adapter_unregister(adapter->dbf);
 debug_register_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
 	kfree(adapter->req_list);
@@ -616,7 +617,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 		return;
 
 	zfcp_destroy_adapter_work_queue(adapter);
-	zfcp_adapter_debug_unregister(adapter);
+	zfcp_dbf_adapter_unregister(adapter->dbf);
 	zfcp_qdio_free(adapter->qdio);
 	zfcp_free_low_mem_buffers(adapter);
 	kfree(adapter->req_list);
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 13:27:45.000000000 +0200
@@ -120,9 +120,9 @@ static int zfcp_dbf_view_header(debug_in
 	return p - out_buf;
 }
 
-void _zfcp_hba_dbf_event_fsf_response(const char *tag2, int level,
-				      struct zfcp_fsf_req *fsf_req,
-				      struct zfcp_dbf *dbf)
+void _zfcp_dbf_hba_fsf_response(const char *tag2, int level,
+				struct zfcp_fsf_req *fsf_req,
+				struct zfcp_dbf *dbf)
 {
 	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 	union fsf_prot_status_qual *prot_status_qual =
@@ -132,11 +132,11 @@ void _zfcp_hba_dbf_event_fsf_response(co
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 	struct zfcp_send_els *send_els;
-	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
-	struct zfcp_hba_dbf_record_response *response = &rec->u.response;
+	struct zfcp_dbf_hba_record *rec = &dbf->hba_buf;
+	struct zfcp_dbf_hba_record_response *response = &rec->u.response;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
 	strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
@@ -203,7 +203,7 @@ void _zfcp_hba_dbf_event_fsf_response(co
 		break;
 	}
 
-	debug_event(dbf->hba_dbf, level, rec, sizeof(*rec));
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
 
 	/* have fcp channel microcode fixed to use as little as possible */
 	if (fsf_req->fsf_command != FSF_QTCB_FCP_CMND) {
@@ -211,27 +211,25 @@ void _zfcp_hba_dbf_event_fsf_response(co
 		char *buf = (char *)qtcb + qtcb->header.log_start;
 		int len = qtcb->header.log_length;
 		for (; len && !buf[len - 1]; len--);
-		zfcp_dbf_hexdump(dbf->hba_dbf, rec, sizeof(*rec), level, buf,
+		zfcp_dbf_hexdump(dbf->hba, rec, sizeof(*rec), level, buf,
 				 len);
 	}
 
-	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
-void _zfcp_hba_dbf_event_fsf_unsol(const char *tag, int level,
-				   struct zfcp_adapter *adapter,
-				   struct fsf_status_read_buffer *status_buffer)
+void _zfcp_dbf_hba_fsf_unsol(const char *tag, int level, struct zfcp_dbf *dbf,
+			     struct fsf_status_read_buffer *status_buffer)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
+	struct zfcp_dbf_hba_record *rec = &dbf->hba_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
 	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
 
-	rec->u.status.failed = atomic_read(&adapter->stat_miss);
+	rec->u.status.failed = atomic_read(&dbf->adapter->stat_miss);
 	if (status_buffer != NULL) {
 		rec->u.status.status_type = status_buffer->status_type;
 		rec->u.status.status_subtype = status_buffer->status_subtype;
@@ -268,58 +266,54 @@ void _zfcp_hba_dbf_event_fsf_unsol(const
 		       &status_buffer->payload, rec->u.status.payload_size);
 	}
 
-	debug_event(dbf->hba_dbf, level, rec, sizeof(*rec));
-	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
 /**
- * zfcp_hba_dbf_event_qdio - trace event for QDIO related failure
+ * zfcp_dbf_hba_qdio - trace event for QDIO related failure
  * @qdio: qdio structure affected by this QDIO related event
  * @qdio_error: as passed by qdio module
  * @sbal_index: first buffer with error condition, as passed by qdio module
  * @sbal_count: number of buffers affected, as passed by qdio module
  */
-void zfcp_hba_dbf_event_qdio(struct zfcp_qdio *qdio,
-			     unsigned int qdio_error, int sbal_index,
-			     int sbal_count)
+void zfcp_dbf_hba_qdio(struct zfcp_dbf *dbf, unsigned int qdio_error,
+		       int sbal_index, int sbal_count)
 {
-	struct zfcp_dbf *dbf = qdio->adapter->dbf;
-	struct zfcp_hba_dbf_record *r = &dbf->hba_dbf_buf;
+	struct zfcp_dbf_hba_record *r = &dbf->hba_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "qdio", ZFCP_DBF_TAG_SIZE);
 	r->u.qdio.qdio_error = qdio_error;
 	r->u.qdio.sbal_index = sbal_index;
 	r->u.qdio.sbal_count = sbal_count;
-	debug_event(dbf->hba_dbf, 0, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
+	debug_event(dbf->hba, 0, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
 /**
- * zfcp_hba_dbf_event_berr - trace event for bit error threshold
- * @adapter: adapter affected by this QDIO related event
+ * zfcp_dbf_hba_berr - trace event for bit error threshold
+ * @dbf: dbf structure affected by this QDIO related event
  * @req: fsf request
  */
-void zfcp_hba_dbf_event_berr(struct zfcp_adapter *adapter,
-			     struct zfcp_fsf_req *req)
+void zfcp_dbf_hba_berr(struct zfcp_dbf *dbf, struct zfcp_fsf_req *req)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_hba_dbf_record *r = &dbf->hba_dbf_buf;
+	struct zfcp_dbf_hba_record *r = &dbf->hba_buf;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "berr", ZFCP_DBF_TAG_SIZE);
 	memcpy(&r->u.berr, err, sizeof(struct fsf_bit_error_payload));
-	debug_event(dbf->hba_dbf, 0, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
+	debug_event(dbf->hba, 0, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
-static void zfcp_hba_dbf_view_response(char **p,
-				       struct zfcp_hba_dbf_record_response *r)
+static void zfcp_dbf_hba_view_response(char **p,
+				       struct zfcp_dbf_hba_record_response *r)
 {
 	struct timespec t;
 
@@ -380,8 +374,8 @@ static void zfcp_hba_dbf_view_response(c
 	}
 }
 
-static void zfcp_hba_dbf_view_status(char **p,
-				     struct zfcp_hba_dbf_record_status *r)
+static void zfcp_dbf_hba_view_status(char **p,
+				     struct zfcp_dbf_hba_record_status *r)
 {
 	zfcp_dbf_out(p, "failed", "0x%02x", r->failed);
 	zfcp_dbf_out(p, "status_type", "0x%08x", r->status_type);
@@ -393,14 +387,14 @@ static void zfcp_hba_dbf_view_status(cha
 		      r->payload_size);
 }
 
-static void zfcp_hba_dbf_view_qdio(char **p, struct zfcp_hba_dbf_record_qdio *r)
+static void zfcp_dbf_hba_view_qdio(char **p, struct zfcp_dbf_hba_record_qdio *r)
 {
 	zfcp_dbf_out(p, "qdio_error", "0x%08x", r->qdio_error);
 	zfcp_dbf_out(p, "sbal_index", "0x%02x", r->sbal_index);
 	zfcp_dbf_out(p, "sbal_count", "0x%02x", r->sbal_count);
 }
 
-static void zfcp_hba_dbf_view_berr(char **p, struct fsf_bit_error_payload *r)
+static void zfcp_dbf_hba_view_berr(char **p, struct fsf_bit_error_payload *r)
 {
 	zfcp_dbf_out(p, "link_failures", "%d", r->link_failure_error_count);
 	zfcp_dbf_out(p, "loss_of_sync_err", "%d", r->loss_of_sync_error_count);
@@ -424,10 +418,10 @@ static void zfcp_hba_dbf_view_berr(char 
 		     r->current_transmit_b2b_credit);
 }
 
-static int zfcp_hba_dbf_view_format(debug_info_t *id, struct debug_view *view,
+static int zfcp_dbf_hba_view_format(debug_info_t *id, struct debug_view *view,
 				    char *out_buf, const char *in_buf)
 {
-	struct zfcp_hba_dbf_record *r = (struct zfcp_hba_dbf_record *)in_buf;
+	struct zfcp_dbf_hba_record *r = (struct zfcp_dbf_hba_record *)in_buf;
 	char *p = out_buf;
 
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
@@ -438,45 +432,42 @@ static int zfcp_hba_dbf_view_format(debu
 		zfcp_dbf_tag(&p, "tag2", r->tag2);
 
 	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_response(&p, &r->u.response);
+		zfcp_dbf_hba_view_response(&p, &r->u.response);
 	else if (strncmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_status(&p, &r->u.status);
+		zfcp_dbf_hba_view_status(&p, &r->u.status);
 	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_qdio(&p, &r->u.qdio);
+		zfcp_dbf_hba_view_qdio(&p, &r->u.qdio);
 	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_berr(&p, &r->u.berr);
+		zfcp_dbf_hba_view_berr(&p, &r->u.berr);
 
 	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
 		p += sprintf(p, "\n");
 	return p - out_buf;
 }
 
-static struct debug_view zfcp_hba_dbf_view = {
-	"structured",
-	NULL,
-	&zfcp_dbf_view_header,
-	&zfcp_hba_dbf_view_format,
-	NULL,
-	NULL
+static struct debug_view zfcp_dbf_hba_view = {
+	.name = "structured",
+	.header_proc = zfcp_dbf_view_header,
+	.format_proc = zfcp_dbf_hba_view_format,
 };
 
-static const char *zfcp_rec_dbf_tags[] = {
+static const char *zfcp_dbf_rec_tags[] = {
 	[ZFCP_REC_DBF_ID_THREAD] = "thread",
 	[ZFCP_REC_DBF_ID_TARGET] = "target",
 	[ZFCP_REC_DBF_ID_TRIGGER] = "trigger",
 	[ZFCP_REC_DBF_ID_ACTION] = "action",
 };
 
-static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
+static int zfcp_dbf_rec_view_format(debug_info_t *id, struct debug_view *view,
 				    char *buf, const char *_rec)
 {
-	struct zfcp_rec_dbf_record *r = (struct zfcp_rec_dbf_record *)_rec;
+	struct zfcp_dbf_rec_record *r = (struct zfcp_dbf_rec_record *)_rec;
 	char *p = buf;
 	char hint[ZFCP_DBF_ID_SIZE + 1];
 
 	memcpy(hint, r->id2, ZFCP_DBF_ID_SIZE);
 	hint[ZFCP_DBF_ID_SIZE] = 0;
-	zfcp_dbf_outs(&p, "tag", zfcp_rec_dbf_tags[r->id]);
+	zfcp_dbf_outs(&p, "tag", zfcp_dbf_rec_tags[r->id]);
 	zfcp_dbf_outs(&p, "hint", hint);
 	switch (r->id) {
 	case ZFCP_REC_DBF_ID_THREAD:
@@ -514,25 +505,22 @@ static int zfcp_rec_dbf_view_format(debu
 	return p - buf;
 }
 
-static struct debug_view zfcp_rec_dbf_view = {
-	"structured",
-	NULL,
-	&zfcp_dbf_view_header,
-	&zfcp_rec_dbf_view_format,
-	NULL,
-	NULL
+static struct debug_view zfcp_dbf_rec_view = {
+	.name = "structured",
+	.header_proc = zfcp_dbf_view_header,
+	.format_proc = zfcp_dbf_rec_view_format,
 };
 
 /**
- * zfcp_rec_dbf_event_thread - trace event related to recovery thread operation
+ * zfcp_dbf_rec_thread - trace event related to recovery thread operation
  * @id2: identifier for event
- * @adapter: adapter
+ * @dbf: reference to dbf structure
  * This function assumes that the caller is holding erp_lock.
  */
-void zfcp_rec_dbf_event_thread(char *id2, struct zfcp_adapter *adapter)
+void zfcp_dbf_rec_thread(char *id2, struct zfcp_dbf *dbf)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
+	struct zfcp_adapter *adapter = dbf->adapter;
+	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
 	unsigned long flags = 0;
 	struct list_head *entry;
 	unsigned ready = 0, running = 0, total;
@@ -543,42 +531,41 @@ void zfcp_rec_dbf_event_thread(char *id2
 		running++;
 	total = adapter->erp_total_count;
 
-	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_THREAD;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.thread.total = total;
 	r->u.thread.ready = ready;
 	r->u.thread.running = running;
-	debug_event(dbf->rec_dbf, 6, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
+	debug_event(dbf->rec, 6, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
 /**
- * zfcp_rec_dbf_event_thread - trace event related to recovery thread operation
+ * zfcp_dbf_rec_thread - trace event related to recovery thread operation
  * @id2: identifier for event
  * @adapter: adapter
  * This function assumes that the caller does not hold erp_lock.
  */
-void zfcp_rec_dbf_event_thread_lock(char *id2, struct zfcp_adapter *adapter)
+void zfcp_dbf_rec_thread_lock(char *id2, struct zfcp_dbf *dbf)
 {
+	struct zfcp_adapter *adapter = dbf->adapter;
 	unsigned long flags;
 
 	read_lock_irqsave(&adapter->erp_lock, flags);
-	zfcp_rec_dbf_event_thread(id2, adapter);
+	zfcp_dbf_rec_thread(id2, dbf);
 	read_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
-static void zfcp_rec_dbf_event_target(char *id2, void *ref,
-				      struct zfcp_adapter *adapter,
-				      atomic_t *status, atomic_t *erp_count,
-				      u64 wwpn, u32 d_id, u64 fcp_lun)
+static void zfcp_dbf_rec_target(char *id2, void *ref, struct zfcp_dbf *dbf,
+				atomic_t *status, atomic_t *erp_count, u64 wwpn,
+				u32 d_id, u64 fcp_lun)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
+	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TARGET;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -588,56 +575,57 @@ static void zfcp_rec_dbf_event_target(ch
 	r->u.target.d_id = d_id;
 	r->u.target.fcp_lun = fcp_lun;
 	r->u.target.erp_count = atomic_read(erp_count);
-	debug_event(dbf->rec_dbf, 3, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
+	debug_event(dbf->rec, 3, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
 /**
- * zfcp_rec_dbf_event_adapter - trace event for adapter state change
+ * zfcp_dbf_rec_adapter - trace event for adapter state change
  * @id: identifier for trigger of state change
  * @ref: additional reference (e.g. request)
- * @adapter: adapter
+ * @dbf: reference to dbf structure
  */
-void zfcp_rec_dbf_event_adapter(char *id, void *ref,
-				struct zfcp_adapter *adapter)
+void zfcp_dbf_rec_adapter(char *id, void *ref, struct zfcp_dbf *dbf)
 {
-	zfcp_rec_dbf_event_target(id, ref, adapter, &adapter->status,
+	struct zfcp_adapter *adapter = dbf->adapter;
+
+	zfcp_dbf_rec_target(id, ref, dbf, &adapter->status,
 				  &adapter->erp_counter, 0, 0, 0);
 }
 
 /**
- * zfcp_rec_dbf_event_port - trace event for port state change
+ * zfcp_dbf_rec_port - trace event for port state change
  * @id: identifier for trigger of state change
  * @ref: additional reference (e.g. request)
  * @port: port
  */
-void zfcp_rec_dbf_event_port(char *id, void *ref, struct zfcp_port *port)
+void zfcp_dbf_rec_port(char *id, void *ref, struct zfcp_port *port)
 {
-	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_dbf *dbf = port->adapter->dbf;
 
-	zfcp_rec_dbf_event_target(id, ref, adapter, &port->status,
+	zfcp_dbf_rec_target(id, ref, dbf, &port->status,
 				  &port->erp_counter, port->wwpn, port->d_id,
 				  0);
 }
 
 /**
- * zfcp_rec_dbf_event_unit - trace event for unit state change
+ * zfcp_dbf_rec_unit - trace event for unit state change
  * @id: identifier for trigger of state change
  * @ref: additional reference (e.g. request)
  * @unit: unit
  */
-void zfcp_rec_dbf_event_unit(char *id, void *ref, struct zfcp_unit *unit)
+void zfcp_dbf_rec_unit(char *id, void *ref, struct zfcp_unit *unit)
 {
 	struct zfcp_port *port = unit->port;
-	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_dbf *dbf = port->adapter->dbf;
 
-	zfcp_rec_dbf_event_target(id, ref, adapter, &unit->status,
+	zfcp_dbf_rec_target(id, ref, dbf, &unit->status,
 				  &unit->erp_counter, port->wwpn, port->d_id,
 				  unit->fcp_lun);
 }
 
 /**
- * zfcp_rec_dbf_event_trigger - trace event for triggered error recovery
+ * zfcp_dbf_rec_trigger - trace event for triggered error recovery
  * @id2: identifier for error recovery trigger
  * @ref: additional reference (e.g. request)
  * @want: originally requested error recovery action
@@ -647,15 +635,15 @@ void zfcp_rec_dbf_event_unit(char *id, v
  * @port: port
  * @unit: unit
  */
-void zfcp_rec_dbf_event_trigger(char *id2, void *ref, u8 want, u8 need,
-				void *action, struct zfcp_adapter *adapter,
-				struct zfcp_port *port, struct zfcp_unit *unit)
+void zfcp_dbf_rec_trigger(char *id2, void *ref, u8 want, u8 need, void *action,
+			  struct zfcp_adapter *adapter, struct zfcp_port *port,
+			  struct zfcp_unit *unit)
 {
 	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
+	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TRIGGER;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -672,23 +660,22 @@ void zfcp_rec_dbf_event_trigger(char *id
 		r->u.trigger.us = atomic_read(&unit->status);
 		r->u.trigger.fcp_lun = unit->fcp_lun;
 	}
-	debug_event(dbf->rec_dbf, action ? 1 : 4, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
+	debug_event(dbf->rec, action ? 1 : 4, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
 /**
- * zfcp_rec_dbf_event_action - trace event showing progress of recovery action
+ * zfcp_dbf_rec_action - trace event showing progress of recovery action
  * @id2: identifier
  * @erp_action: error recovery action struct pointer
  */
-void zfcp_rec_dbf_event_action(char *id2, struct zfcp_erp_action *erp_action)
+void zfcp_dbf_rec_action(char *id2, struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
+	struct zfcp_dbf *dbf = erp_action->adapter->dbf;
+	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_ACTION;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -696,27 +683,27 @@ void zfcp_rec_dbf_event_action(char *id2
 	r->u.action.status = erp_action->status;
 	r->u.action.step = erp_action->step;
 	r->u.action.fsf_req = (unsigned long)erp_action->fsf_req;
-	debug_event(dbf->rec_dbf, 5, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
+	debug_event(dbf->rec, 5, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
 /**
- * zfcp_san_dbf_event_ct_request - trace event for issued CT request
+ * zfcp_dbf_san_ct_request - trace event for issued CT request
  * @fsf_req: request containing issued CT data
  */
-void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct ct_hdr *hdr = sg_virt(ct->req);
-	struct zfcp_san_dbf_record *r = &dbf->san_dbf_buf;
-	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
+	struct zfcp_dbf_san_record *r = &dbf->san_buf;
+	struct zfcp_dbf_san_record_ct_request *oct = &r->u.ct_req;
 	int level = 3;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
@@ -731,29 +718,29 @@ void zfcp_san_dbf_event_ct_request(struc
 	oct->max_res_size = hdr->max_res_size;
 	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(dbf->san_dbf, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(dbf->san_dbf, r, sizeof(*r), level,
+	debug_event(dbf->san, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
 			 (void *)hdr + sizeof(struct ct_hdr), oct->len);
-	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
 /**
- * zfcp_san_dbf_event_ct_response - trace event for completion of CT request
+ * zfcp_dbf_san_ct_response - trace event for completion of CT request
  * @fsf_req: request containing CT response
  */
-void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_san_dbf_record *r = &dbf->san_dbf_buf;
-	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
+	struct zfcp_dbf_san_record *r = &dbf->san_buf;
+	struct zfcp_dbf_san_record_ct_response *rct = &r->u.ct_resp;
 	int level = 3;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
@@ -768,23 +755,22 @@ void zfcp_san_dbf_event_ct_response(stru
 	rct->max_res_size = hdr->max_res_size;
 	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(dbf->san_dbf, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(dbf->san_dbf, r, sizeof(*r), level,
+	debug_event(dbf->san, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
 			 (void *)hdr + sizeof(struct ct_hdr), rct->len);
-	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
-static void zfcp_san_dbf_event_els(const char *tag, int level,
-				   struct zfcp_fsf_req *fsf_req, u32 s_id,
-				   u32 d_id, u8 ls_code, void *buffer,
-				   int buflen)
+static void zfcp_dbf_san_els(const char *tag, int level,
+			     struct zfcp_fsf_req *fsf_req, u32 s_id, u32 d_id,
+			     u8 ls_code, void *buffer, int buflen)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_san_dbf_record *rec = &dbf->san_dbf_buf;
+	struct zfcp_dbf_san_record *rec = &dbf->san_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 	rec->fsf_reqid = fsf_req->req_id;
@@ -792,45 +778,45 @@ static void zfcp_san_dbf_event_els(const
 	rec->s_id = s_id;
 	rec->d_id = d_id;
 	rec->u.els.ls_code = ls_code;
-	debug_event(dbf->san_dbf, level, rec, sizeof(*rec));
-	zfcp_dbf_hexdump(dbf->san_dbf, rec, sizeof(*rec), level,
+	debug_event(dbf->san, level, rec, sizeof(*rec));
+	zfcp_dbf_hexdump(dbf->san, rec, sizeof(*rec), level,
 			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
-	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
 /**
- * zfcp_san_dbf_event_els_request - trace event for issued ELS
+ * zfcp_dbf_san_els_request - trace event for issued ELS
  * @fsf_req: request containing issued ELS
  */
-void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_els_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	zfcp_san_dbf_event_els("oels", 2, fsf_req,
+	zfcp_dbf_san_els("oels", 2, fsf_req,
 			       fc_host_port_id(els->adapter->scsi_host),
 			       els->d_id, *(u8 *) sg_virt(els->req),
 			       sg_virt(els->req), els->req->length);
 }
 
 /**
- * zfcp_san_dbf_event_els_response - trace event for completed ELS
+ * zfcp_dbf_san_els_response - trace event for completed ELS
  * @fsf_req: request containing ELS response
  */
-void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_els_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	zfcp_san_dbf_event_els("rels", 2, fsf_req, els->d_id,
+	zfcp_dbf_san_els("rels", 2, fsf_req, els->d_id,
 			       fc_host_port_id(els->adapter->scsi_host),
 			       *(u8 *)sg_virt(els->req), sg_virt(els->resp),
 			       els->resp->length);
 }
 
 /**
- * zfcp_san_dbf_event_incoming_els - trace event for incomig ELS
+ * zfcp_dbf_san_incoming_els - trace event for incomig ELS
  * @fsf_req: request containing unsolicited status buffer with incoming ELS
  */
-void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_incoming_els(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *buf =
@@ -838,16 +824,16 @@ void zfcp_san_dbf_event_incoming_els(str
 	int length = (int)buf->length -
 		     (int)((void *)&buf->payload - (void *)buf);
 
-	zfcp_san_dbf_event_els("iels", 1, fsf_req, buf->d_id,
+	zfcp_dbf_san_els("iels", 1, fsf_req, buf->d_id,
 			       fc_host_port_id(adapter->scsi_host),
 			       buf->payload.data[0], (void *)buf->payload.data,
 			       length);
 }
 
-static int zfcp_san_dbf_view_format(debug_info_t *id, struct debug_view *view,
+static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
 				    char *out_buf, const char *in_buf)
 {
-	struct zfcp_san_dbf_record *r = (struct zfcp_san_dbf_record *)in_buf;
+	struct zfcp_dbf_san_record *r = (struct zfcp_dbf_san_record *)in_buf;
 	char *p = out_buf;
 
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
@@ -860,7 +846,7 @@ static int zfcp_san_dbf_view_format(debu
 	zfcp_dbf_out(&p, "d_id", "0x%06x", r->d_id);
 
 	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_san_dbf_record_ct_request *ct = &r->u.ct_req;
+		struct zfcp_dbf_san_record_ct_request *ct = &r->u.ct_req;
 		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x", ct->cmd_req_code);
 		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
 		zfcp_dbf_out(&p, "gs_type", "0x%02x", ct->gs_type);
@@ -868,7 +854,7 @@ static int zfcp_san_dbf_view_format(debu
 		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
 		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
 	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_san_dbf_record_ct_response *ct = &r->u.ct_resp;
+		struct zfcp_dbf_san_record_ct_response *ct = &r->u.ct_resp;
 		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
 		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
 		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
@@ -878,34 +864,30 @@ static int zfcp_san_dbf_view_format(debu
 	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_san_dbf_record_els *els = &r->u.els;
+		struct zfcp_dbf_san_record_els *els = &r->u.els;
 		zfcp_dbf_out(&p, "ls_code", "0x%02x", els->ls_code);
 	}
 	return p - out_buf;
 }
 
-static struct debug_view zfcp_san_dbf_view = {
-	"structured",
-	NULL,
-	&zfcp_dbf_view_header,
-	&zfcp_san_dbf_view_format,
-	NULL,
-	NULL
+static struct debug_view zfcp_dbf_san_view = {
+	.name = "structured",
+	.header_proc = zfcp_dbf_view_header,
+	.format_proc = zfcp_dbf_san_view_format,
 };
 
-void _zfcp_scsi_dbf_event(const char *tag, const char *tag2, int level,
-			  struct zfcp_dbf *dbf, struct scsi_cmnd *scsi_cmnd,
-			  struct zfcp_fsf_req *fsf_req,
-			  unsigned long old_req_id)
+void _zfcp_dbf_scsi(const char *tag, const char *tag2, int level,
+		    struct zfcp_dbf *dbf, struct scsi_cmnd *scsi_cmnd,
+		    struct zfcp_fsf_req *fsf_req, unsigned long old_req_id)
 {
-	struct zfcp_scsi_dbf_record *rec = &dbf->scsi_dbf_buf;
+	struct zfcp_dbf_scsi_record *rec = &dbf->scsi_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
 	unsigned long flags;
 	struct fcp_rsp_iu *fcp_rsp;
 	char *fcp_rsp_info = NULL, *fcp_sns_info = NULL;
 	int offset = 0, buflen = 0;
 
-	spin_lock_irqsave(&dbf->scsi_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->scsi_lock, flags);
 	do {
 		memset(rec, 0, sizeof(*rec));
 		if (offset == 0) {
@@ -959,20 +941,20 @@ void _zfcp_scsi_dbf_event(const char *ta
 			dump->offset = offset;
 			dump->size = min(buflen - offset,
 					 (int)sizeof(struct
-						     zfcp_scsi_dbf_record) -
+						     zfcp_dbf_scsi_record) -
 					 (int)sizeof(struct zfcp_dbf_dump));
 			memcpy(dump->data, fcp_sns_info + offset, dump->size);
 			offset += dump->size;
 		}
-		debug_event(dbf->scsi_dbf, level, rec, sizeof(*rec));
+		debug_event(dbf->scsi, level, rec, sizeof(*rec));
 	} while (offset < buflen);
-	spin_unlock_irqrestore(&dbf->scsi_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->scsi_lock, flags);
 }
 
-static int zfcp_scsi_dbf_view_format(debug_info_t *id, struct debug_view *view,
+static int zfcp_dbf_scsi_view_format(debug_info_t *id, struct debug_view *view,
 				     char *out_buf, const char *in_buf)
 {
-	struct zfcp_scsi_dbf_record *r = (struct zfcp_scsi_dbf_record *)in_buf;
+	struct zfcp_dbf_scsi_record *r = (struct zfcp_dbf_scsi_record *)in_buf;
 	struct timespec t;
 	char *p = out_buf;
 
@@ -1013,13 +995,10 @@ static int zfcp_scsi_dbf_view_format(deb
 	return p - out_buf;
 }
 
-static struct debug_view zfcp_scsi_dbf_view = {
-	"structured",
-	NULL,
-	&zfcp_dbf_view_header,
-	&zfcp_scsi_dbf_view_format,
-	NULL,
-	NULL
+static struct debug_view zfcp_dbf_scsi_view = {
+	.name = "structured",
+	.header_proc = zfcp_dbf_view_header,
+	.format_proc = zfcp_dbf_scsi_view_format,
 };
 
 static debug_info_t *zfcp_dbf_reg(const char *name, int level,
@@ -1043,7 +1022,7 @@ static debug_info_t *zfcp_dbf_reg(const 
  * @adapter: pointer to adapter for which debug features should be registered
  * return: -ENOMEM on error, 0 otherwise
  */
-int zfcp_adapter_debug_register(struct zfcp_adapter *adapter)
+int zfcp_dbf_adapter_register(struct zfcp_adapter *adapter)
 {
 	char dbf_name[DEBUG_MAX_NAME_LEN];
 	struct zfcp_dbf *dbf;
@@ -1052,63 +1031,60 @@ int zfcp_adapter_debug_register(struct z
 	if (!dbf)
 		return -ENOMEM;
 
-	spin_lock_init(&dbf->hba_dbf_lock);
-	spin_lock_init(&dbf->san_dbf_lock);
-	spin_lock_init(&dbf->scsi_dbf_lock);
-	spin_lock_init(&dbf->rec_dbf_lock);
+	dbf->adapter = adapter;
+
+	spin_lock_init(&dbf->hba_lock);
+	spin_lock_init(&dbf->san_lock);
+	spin_lock_init(&dbf->scsi_lock);
+	spin_lock_init(&dbf->rec_lock);
 
 	/* debug feature area which records recovery activity */
 	sprintf(dbf_name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
-	dbf->rec_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_rec_dbf_view,
-				    sizeof(struct zfcp_rec_dbf_record));
-	if (!dbf->rec_dbf)
-		goto fail_rec;
+	dbf->rec = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_rec_view,
+				sizeof(struct zfcp_dbf_rec_record));
+	if (!dbf->rec)
+		goto err_out;
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
 	sprintf(dbf_name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
-	dbf->hba_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_hba_dbf_view,
-				    sizeof(struct zfcp_hba_dbf_record));
-	if (!dbf->hba_dbf)
-		goto fail_hba;
+	dbf->hba = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_hba_view,
+				sizeof(struct zfcp_dbf_hba_record));
+	if (!dbf->hba)
+		goto err_out;
 
 	/* debug feature area which records SAN command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
-	dbf->san_dbf = zfcp_dbf_reg(dbf_name, 6, &zfcp_san_dbf_view,
-				    sizeof(struct zfcp_san_dbf_record));
-	if (!dbf->san_dbf)
-		goto fail_san;
+	dbf->san = zfcp_dbf_reg(dbf_name, 6, &zfcp_dbf_san_view,
+				sizeof(struct zfcp_dbf_san_record));
+	if (!dbf->san)
+		goto err_out;
 
 	/* debug feature area which records SCSI command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
-	dbf->scsi_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_scsi_dbf_view,
-				     sizeof(struct zfcp_scsi_dbf_record));
-	if (!dbf->scsi_dbf)
-		goto fail_scsi;
+	dbf->scsi = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_scsi_view,
+				 sizeof(struct zfcp_dbf_scsi_record));
+	if (!dbf->scsi)
+		goto err_out;
 
 	adapter->dbf = dbf;
 	return 0;
 
-fail_scsi:
-	debug_unregister(dbf->san_dbf);
-fail_san:
-	debug_unregister(dbf->hba_dbf);
-fail_hba:
-	debug_unregister(dbf->rec_dbf);
-fail_rec:
-	kfree(dbf);
+err_out:
+	zfcp_dbf_adapter_unregister(dbf);
 	return -ENOMEM;
 }
 
 /**
  * zfcp_adapter_debug_unregister - unregisters debug feature for an adapter
- * @adapter: pointer to adapter for which debug features should be unregistered
+ * @dbf: pointer to dbf for which debug features should be unregistered
  */
-void zfcp_adapter_debug_unregister(struct zfcp_adapter *adapter)
+void zfcp_dbf_adapter_unregister(struct zfcp_dbf *dbf)
 {
-	debug_unregister(adapter->dbf->scsi_dbf);
-	debug_unregister(adapter->dbf->san_dbf);
-	debug_unregister(adapter->dbf->hba_dbf);
-	debug_unregister(adapter->dbf->rec_dbf);
-	kfree(adapter->dbf);
-	adapter->dbf = NULL;
+	debug_unregister(dbf->scsi);
+	debug_unregister(dbf->san);
+	debug_unregister(dbf->hba);
+	debug_unregister(dbf->rec);
+	dbf->adapter->dbf = NULL;
+	kfree(dbf);
 }
+
--- a/drivers/s390/scsi/zfcp_dbf.h	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2009-08-17 13:26:55.000000000 +0200
@@ -37,13 +37,13 @@ struct zfcp_dbf_dump {
 	u8 data[];		/* dump data */
 } __attribute__ ((packed));
 
-struct zfcp_rec_dbf_record_thread {
+struct zfcp_dbf_rec_record_thread {
 	u32 total;
 	u32 ready;
 	u32 running;
 };
 
-struct zfcp_rec_dbf_record_target {
+struct zfcp_dbf_rec_record_target {
 	u64 ref;
 	u32 status;
 	u32 d_id;
@@ -52,7 +52,7 @@ struct zfcp_rec_dbf_record_target {
 	u32 erp_count;
 };
 
-struct zfcp_rec_dbf_record_trigger {
+struct zfcp_dbf_rec_record_trigger {
 	u8 want;
 	u8 need;
 	u32 as;
@@ -64,21 +64,21 @@ struct zfcp_rec_dbf_record_trigger {
 	u64 fcp_lun;
 };
 
-struct zfcp_rec_dbf_record_action {
+struct zfcp_dbf_rec_record_action {
 	u32 status;
 	u32 step;
 	u64 action;
 	u64 fsf_req;
 };
 
-struct zfcp_rec_dbf_record {
+struct zfcp_dbf_rec_record {
 	u8 id;
 	char id2[7];
 	union {
-		struct zfcp_rec_dbf_record_action action;
-		struct zfcp_rec_dbf_record_thread thread;
-		struct zfcp_rec_dbf_record_target target;
-		struct zfcp_rec_dbf_record_trigger trigger;
+		struct zfcp_dbf_rec_record_action action;
+		struct zfcp_dbf_rec_record_thread thread;
+		struct zfcp_dbf_rec_record_target target;
+		struct zfcp_dbf_rec_record_trigger trigger;
 	} u;
 };
 
@@ -89,7 +89,7 @@ enum {
 	ZFCP_REC_DBF_ID_TRIGGER,
 };
 
-struct zfcp_hba_dbf_record_response {
+struct zfcp_dbf_hba_record_response {
 	u32 fsf_command;
 	u64 fsf_reqid;
 	u32 fsf_seqno;
@@ -127,7 +127,7 @@ struct zfcp_hba_dbf_record_response {
 	} u;
 } __attribute__ ((packed));
 
-struct zfcp_hba_dbf_record_status {
+struct zfcp_dbf_hba_record_status {
 	u8 failed;
 	u32 status_type;
 	u32 status_subtype;
@@ -141,24 +141,24 @@ struct zfcp_hba_dbf_record_status {
 	u8 payload[ZFCP_DBF_UNSOL_PAYLOAD];
 } __attribute__ ((packed));
 
-struct zfcp_hba_dbf_record_qdio {
+struct zfcp_dbf_hba_record_qdio {
 	u32 qdio_error;
 	u8 sbal_index;
 	u8 sbal_count;
 } __attribute__ ((packed));
 
-struct zfcp_hba_dbf_record {
+struct zfcp_dbf_hba_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u8 tag2[ZFCP_DBF_TAG_SIZE];
 	union {
-		struct zfcp_hba_dbf_record_response response;
-		struct zfcp_hba_dbf_record_status status;
-		struct zfcp_hba_dbf_record_qdio qdio;
+		struct zfcp_dbf_hba_record_response response;
+		struct zfcp_dbf_hba_record_status status;
+		struct zfcp_dbf_hba_record_qdio qdio;
 		struct fsf_bit_error_payload berr;
 	} u;
 } __attribute__ ((packed));
 
-struct zfcp_san_dbf_record_ct_request {
+struct zfcp_dbf_san_record_ct_request {
 	u16 cmd_req_code;
 	u8 revision;
 	u8 gs_type;
@@ -168,7 +168,7 @@ struct zfcp_san_dbf_record_ct_request {
 	u32 len;
 } __attribute__ ((packed));
 
-struct zfcp_san_dbf_record_ct_response {
+struct zfcp_dbf_san_record_ct_response {
 	u16 cmd_rsp_code;
 	u8 revision;
 	u8 reason_code;
@@ -178,27 +178,27 @@ struct zfcp_san_dbf_record_ct_response {
 	u32 len;
 } __attribute__ ((packed));
 
-struct zfcp_san_dbf_record_els {
+struct zfcp_dbf_san_record_els {
 	u8 ls_code;
 	u32 len;
 } __attribute__ ((packed));
 
-struct zfcp_san_dbf_record {
+struct zfcp_dbf_san_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u64 fsf_reqid;
 	u32 fsf_seqno;
 	u32 s_id;
 	u32 d_id;
 	union {
-		struct zfcp_san_dbf_record_ct_request ct_req;
-		struct zfcp_san_dbf_record_ct_response ct_resp;
-		struct zfcp_san_dbf_record_els els;
+		struct zfcp_dbf_san_record_ct_request ct_req;
+		struct zfcp_dbf_san_record_ct_response ct_resp;
+		struct zfcp_dbf_san_record_els els;
 	} u;
 #define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
 	u8 payload[32];
 } __attribute__ ((packed));
 
-struct zfcp_scsi_dbf_record {
+struct zfcp_dbf_scsi_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u8 tag2[ZFCP_DBF_TAG_SIZE];
 	u32 scsi_id;
@@ -225,86 +225,84 @@ struct zfcp_scsi_dbf_record {
 } __attribute__ ((packed));
 
 struct zfcp_dbf {
-	debug_info_t			*rec_dbf;
-	debug_info_t			*hba_dbf;
-	debug_info_t			*san_dbf;
-	debug_info_t			*scsi_dbf;
-	spinlock_t			rec_dbf_lock;
-	spinlock_t			hba_dbf_lock;
-	spinlock_t			san_dbf_lock;
-	spinlock_t			scsi_dbf_lock;
-	struct zfcp_rec_dbf_record	rec_dbf_buf;
-	struct zfcp_hba_dbf_record	hba_dbf_buf;
-	struct zfcp_san_dbf_record	san_dbf_buf;
-	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
+	debug_info_t			*rec;
+	debug_info_t			*hba;
+	debug_info_t			*san;
+	debug_info_t			*scsi;
+	spinlock_t			rec_lock;
+	spinlock_t			hba_lock;
+	spinlock_t			san_lock;
+	spinlock_t			scsi_lock;
+	struct zfcp_dbf_rec_record	rec_buf;
+	struct zfcp_dbf_hba_record	hba_buf;
+	struct zfcp_dbf_san_record	san_buf;
+	struct zfcp_dbf_scsi_record	scsi_buf;
+	struct zfcp_adapter		*adapter;
 };
 
 static inline
-void zfcp_hba_dbf_event_fsf_resp(const char *tag2, int level,
-				 struct zfcp_fsf_req *req, struct zfcp_dbf *dbf)
+void zfcp_dbf_hba_fsf_resp(const char *tag2, int level,
+			   struct zfcp_fsf_req *req, struct zfcp_dbf *dbf)
 {
-	if (level <= dbf->hba_dbf->level)
-		_zfcp_hba_dbf_event_fsf_response(tag2, level, req, dbf);
+	if (level <= dbf->hba->level)
+		_zfcp_dbf_hba_fsf_response(tag2, level, req, dbf);
 }
 
 /**
- * zfcp_hba_dbf_event_fsf_response - trace event for request completion
+ * zfcp_dbf_hba_fsf_response - trace event for request completion
  * @fsf_req: request that has been completed
  */
-static inline void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *req)
+static inline void zfcp_dbf_hba_fsf_response(struct zfcp_fsf_req *req)
 {
 	struct zfcp_dbf *dbf = req->adapter->dbf;
 	struct fsf_qtcb *qtcb = req->qtcb;
 
 	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
 	    (qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
-		zfcp_hba_dbf_event_fsf_resp("perr", 1, req, dbf);
+		zfcp_dbf_hba_fsf_resp("perr", 1, req, dbf);
 
 	} else if (qtcb->header.fsf_status != FSF_GOOD) {
-		zfcp_hba_dbf_event_fsf_resp("ferr", 1, req, dbf);
+		zfcp_dbf_hba_fsf_resp("ferr", 1, req, dbf);
 
 	} else if ((req->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) ||
 		   (req->fsf_command == FSF_QTCB_OPEN_LUN)) {
-		zfcp_hba_dbf_event_fsf_resp("open", 4, req, dbf);
+		zfcp_dbf_hba_fsf_resp("open", 4, req, dbf);
 
 	} else if (qtcb->header.log_length) {
-		zfcp_hba_dbf_event_fsf_resp("qtcb", 5, req, dbf);
+		zfcp_dbf_hba_fsf_resp("qtcb", 5, req, dbf);
 
 	} else {
-		zfcp_hba_dbf_event_fsf_resp("norm", 6, req, dbf);
+		zfcp_dbf_hba_fsf_resp("norm", 6, req, dbf);
 	}
  }
 
 /**
- * zfcp_hba_dbf_event_fsf_unsol - trace event for an unsolicited status buffer
+ * zfcp_dbf_hba_fsf_unsol - trace event for an unsolicited status buffer
  * @tag: tag indicating which kind of unsolicited status has been received
- * @adapter: adapter that has issued the unsolicited status buffer
+ * @dbf: reference to dbf structure
  * @status_buffer: buffer containing payload of unsolicited status
  */
 static inline
-void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
-				  struct fsf_status_read_buffer *buf)
+void zfcp_dbf_hba_fsf_unsol(const char *tag, struct zfcp_dbf *dbf,
+			    struct fsf_status_read_buffer *buf)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
 	int level = 2;
 
-	if (level <= dbf->hba_dbf->level)
-		_zfcp_hba_dbf_event_fsf_unsol(tag, level, adapter, buf);
+	if (level <= dbf->hba->level)
+		_zfcp_dbf_hba_fsf_unsol(tag, level, dbf, buf);
 }
 
 static inline
-void zfcp_scsi_dbf_event(const char *tag, const char *tag2, int level,
-			 struct zfcp_adapter *adapter, struct scsi_cmnd *scmd,
-			 struct zfcp_fsf_req *req, unsigned long old_id)
+void zfcp_dbf_scsi(const char *tag, const char *tag2, int level,
+		   struct zfcp_dbf *dbf, struct scsi_cmnd *scmd,
+		   struct zfcp_fsf_req *req, unsigned long old_id)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-
-	if (level <= dbf->scsi_dbf->level)
-		_zfcp_scsi_dbf_event(tag, tag2, level, dbf, scmd, req, old_id);
+	if (level <= dbf->scsi->level)
+		_zfcp_dbf_scsi(tag, tag2, level, dbf, scmd, req, old_id);
 }
 
 /**
- * zfcp_scsi_dbf_event_result - trace event for SCSI command completion
+ * zfcp_dbf_scsi_result - trace event for SCSI command completion
  * @tag: tag indicating success or failure of SCSI command
  * @level: trace level applicable for this event
  * @adapter: adapter that has been used to issue the SCSI command
@@ -312,16 +310,14 @@ void zfcp_scsi_dbf_event(const char *tag
  * @fsf_req: request used to issue SCSI command (might be NULL)
  */
 static inline
-void zfcp_scsi_dbf_event_result(const char *tag, int level,
-				struct zfcp_adapter *adapter,
-				struct scsi_cmnd *scmd,
-				struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_scsi_result(const char *tag, int level, struct zfcp_dbf *dbf,
+			  struct scsi_cmnd *scmd, struct zfcp_fsf_req *fsf_req)
 {
-	zfcp_scsi_dbf_event("rslt", tag, level, adapter, scmd, fsf_req, 0);
+	zfcp_dbf_scsi("rslt", tag, level, dbf, scmd, fsf_req, 0);
 }
 
 /**
- * zfcp_scsi_dbf_event_abort - trace event for SCSI command abort
+ * zfcp_dbf_scsi_abort - trace event for SCSI command abort
  * @tag: tag indicating success or failure of abort operation
  * @adapter: adapter thas has been used to issue SCSI command to be aborted
  * @scmd: SCSI command to be aborted
@@ -329,28 +325,26 @@ void zfcp_scsi_dbf_event_result(const ch
  * @old_id: identifier of request containg SCSI command to be aborted
  */
 static inline
-void zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
-			       struct scsi_cmnd *scmd,
-			       struct zfcp_fsf_req *new_req,
-			       unsigned long old_id)
+void zfcp_dbf_scsi_abort(const char *tag, struct zfcp_dbf *dbf,
+			 struct scsi_cmnd *scmd, struct zfcp_fsf_req *new_req,
+			 unsigned long old_id)
 {
-	zfcp_scsi_dbf_event("abrt", tag, 1, adapter, scmd, new_req, old_id);
+	zfcp_dbf_scsi("abrt", tag, 1, dbf, scmd, new_req, old_id);
 }
 
 /**
- * zfcp_scsi_dbf_event_devreset - trace event for Logical Unit or Target Reset
+ * zfcp_dbf_scsi_devreset - trace event for Logical Unit or Target Reset
  * @tag: tag indicating success or failure of reset operation
  * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
  * @unit: unit that needs reset
  * @scsi_cmnd: SCSI command which caused this error recovery
  */
 static inline
-void zfcp_scsi_dbf_event_devreset(const char *tag, u8 flag,
-				  struct zfcp_unit *unit,
-				  struct scsi_cmnd *scsi_cmnd)
+void zfcp_dbf_scsi_devreset(const char *tag, u8 flag, struct zfcp_unit *unit,
+			    struct scsi_cmnd *scsi_cmnd)
 {
-	zfcp_scsi_dbf_event(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
-			    unit->port->adapter, scsi_cmnd, NULL, 0);
+	zfcp_dbf_scsi(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
+			    unit->port->adapter->dbf, scsi_cmnd, NULL, 0);
 }
 
 #endif /* ZFCP_DBF_H */
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-17 13:26:55.000000000 +0200
@@ -74,9 +74,9 @@ static void zfcp_erp_action_ready(struct
 	struct zfcp_adapter *adapter = act->adapter;
 
 	list_move(&act->list, &act->adapter->erp_ready_head);
-	zfcp_rec_dbf_event_action("erardy1", act);
+	zfcp_dbf_rec_action("erardy1", act);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread("erardy2", adapter);
+	zfcp_dbf_rec_thread("erardy2", adapter->dbf);
 }
 
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *act)
@@ -227,11 +227,10 @@ static int zfcp_erp_action_enqueue(int w
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread("eracte1", adapter);
+	zfcp_dbf_rec_thread("eracte1", adapter->dbf);
 	retval = 0;
  out:
-	zfcp_rec_dbf_event_trigger(id, ref, want, need, act,
-				   adapter, port, unit);
+	zfcp_dbf_rec_trigger(id, ref, want, need, act, adapter, port, unit);
 	return retval;
 }
 
@@ -442,28 +441,28 @@ static int status_change_clear(unsigned 
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
-		zfcp_rec_dbf_event_adapter("eraubl1", NULL, adapter);
+		zfcp_dbf_rec_adapter("eraubl1", NULL, adapter->dbf);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
 }
 
 static void zfcp_erp_port_unblock(struct zfcp_port *port)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
-		zfcp_rec_dbf_event_port("erpubl1", NULL, port);
+		zfcp_dbf_rec_port("erpubl1", NULL, port);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
 static void zfcp_erp_unit_unblock(struct zfcp_unit *unit)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status))
-		zfcp_rec_dbf_event_unit("eruubl1", NULL, unit);
+		zfcp_dbf_rec_unit("eruubl1", NULL, unit);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
-	zfcp_rec_dbf_event_action("erator1", erp_action);
+	zfcp_dbf_rec_action("erator1", erp_action);
 }
 
 static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
@@ -479,11 +478,11 @@ static void zfcp_erp_strategy_check_fsfr
 		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-			zfcp_rec_dbf_event_action("erscf_1", act);
+			zfcp_dbf_rec_action("erscf_1", act);
 			act->fsf_req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
-			zfcp_rec_dbf_event_action("erscf_2", act);
+			zfcp_dbf_rec_action("erscf_2", act);
 		if (act->fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
 			act->fsf_req = NULL;
 	} else
@@ -641,9 +640,9 @@ static int zfcp_erp_adapter_strat_fsf_xc
 			return ZFCP_ERP_FAILED;
 		}
 
-		zfcp_rec_dbf_event_thread_lock("erasfx1", adapter);
+		zfcp_dbf_rec_thread_lock("erasfx1", adapter->dbf);
 		down(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock("erasfx2", adapter);
+		zfcp_dbf_rec_thread_lock("erasfx2", adapter->dbf);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			break;
 
@@ -682,9 +681,9 @@ static int zfcp_erp_adapter_strategy_ope
 	if (ret)
 		return ZFCP_ERP_FAILED;
 
-	zfcp_rec_dbf_event_thread_lock("erasox1", adapter);
+	zfcp_dbf_rec_thread_lock("erasox1", adapter->dbf);
 	down(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock("erasox2", adapter);
+	zfcp_dbf_rec_thread_lock("erasox2", adapter->dbf);
 	if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 		return ZFCP_ERP_FAILED;
 
@@ -1138,7 +1137,7 @@ static void zfcp_erp_action_dequeue(stru
 	}
 
 	list_del(&erp_action->list);
-	zfcp_rec_dbf_event_action("eractd1", erp_action);
+	zfcp_dbf_rec_action("eractd1", erp_action);
 
 	switch (erp_action->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
@@ -1297,9 +1296,9 @@ static int zfcp_erp_thread(void *data)
 	while (!(atomic_read(&adapter->status) &
 		 ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL)) {
 
-		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
+		zfcp_dbf_rec_thread_lock("erthrd1", adapter->dbf);
 		ignore = down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
+		zfcp_dbf_rec_thread_lock("erthrd2", adapter->dbf);
 
 		write_lock_irqsave(&adapter->erp_lock, flags);
 		next = adapter->erp_ready_head.next;
@@ -1356,7 +1355,7 @@ void zfcp_erp_thread_kill(struct zfcp_ad
 {
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock("erthrk1", adapter);
+	zfcp_dbf_rec_thread_lock("erthrk1", adapter->dbf);
 
 	wait_event(adapter->erp_thread_wqh,
 		   !(atomic_read(&adapter->status) &
@@ -1431,11 +1430,11 @@ void zfcp_erp_modify_adapter_status(stru
 
 	if (set_or_clear == ZFCP_SET) {
 		if (status_change_set(mask, &adapter->status))
-			zfcp_rec_dbf_event_adapter(id, ref, adapter);
+			zfcp_dbf_rec_adapter(id, ref, adapter->dbf);
 		atomic_set_mask(mask, &adapter->status);
 	} else {
 		if (status_change_clear(mask, &adapter->status))
-			zfcp_rec_dbf_event_adapter(id, ref, adapter);
+			zfcp_dbf_rec_adapter(id, ref, adapter->dbf);
 		atomic_clear_mask(mask, &adapter->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&adapter->erp_counter, 0);
@@ -1465,11 +1464,11 @@ void zfcp_erp_modify_port_status(struct 
 
 	if (set_or_clear == ZFCP_SET) {
 		if (status_change_set(mask, &port->status))
-			zfcp_rec_dbf_event_port(id, ref, port);
+			zfcp_dbf_rec_port(id, ref, port);
 		atomic_set_mask(mask, &port->status);
 	} else {
 		if (status_change_clear(mask, &port->status))
-			zfcp_rec_dbf_event_port(id, ref, port);
+			zfcp_dbf_rec_port(id, ref, port);
 		atomic_clear_mask(mask, &port->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&port->erp_counter, 0);
@@ -1494,11 +1493,11 @@ void zfcp_erp_modify_unit_status(struct 
 {
 	if (set_or_clear == ZFCP_SET) {
 		if (status_change_set(mask, &unit->status))
-			zfcp_rec_dbf_event_unit(id, ref, unit);
+			zfcp_dbf_rec_unit(id, ref, unit);
 		atomic_set_mask(mask, &unit->status);
 	} else {
 		if (status_change_clear(mask, &unit->status))
-			zfcp_rec_dbf_event_unit(id, ref, unit);
+			zfcp_dbf_rec_unit(id, ref, unit);
 		atomic_clear_mask(mask, &unit->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
 			atomic_set(&unit->erp_counter, 0);
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-17 13:26:55.000000000 +0200
@@ -34,35 +34,31 @@ extern struct zfcp_adapter *zfcp_get_ada
 extern struct miscdevice zfcp_cfdc_misc;
 
 /* zfcp_dbf.c */
-extern int zfcp_adapter_debug_register(struct zfcp_adapter *);
-extern void zfcp_adapter_debug_unregister(struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_thread(char *, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_thread_lock(char *, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_adapter(char *, void *, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_port(char *, void *, struct zfcp_port *);
-extern void zfcp_rec_dbf_event_unit(char *, void *, struct zfcp_unit *);
-extern void zfcp_rec_dbf_event_trigger(char *, void *, u8, u8, void *,
-				       struct zfcp_adapter *,
-				       struct zfcp_port *, struct zfcp_unit *);
-extern void zfcp_rec_dbf_event_action(char *, struct zfcp_erp_action *);
-extern void _zfcp_hba_dbf_event_fsf_response(const char *, int level,
-					     struct zfcp_fsf_req *,
-					     struct zfcp_dbf *dbf);
-extern void _zfcp_hba_dbf_event_fsf_unsol(const char *, int level,
-					  struct zfcp_adapter *,
+extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
+extern void zfcp_dbf_adapter_unregister(struct zfcp_dbf *);
+extern void zfcp_dbf_rec_thread(char *, struct zfcp_dbf *);
+extern void zfcp_dbf_rec_thread_lock(char *, struct zfcp_dbf *);
+extern void zfcp_dbf_rec_adapter(char *, void *, struct zfcp_dbf *);
+extern void zfcp_dbf_rec_port(char *, void *, struct zfcp_port *);
+extern void zfcp_dbf_rec_unit(char *, void *, struct zfcp_unit *);
+extern void zfcp_dbf_rec_trigger(char *, void *, u8, u8, void *,
+				 struct zfcp_adapter *, struct zfcp_port *,
+				 struct zfcp_unit *);
+extern void zfcp_dbf_rec_action(char *, struct zfcp_erp_action *);
+extern void _zfcp_dbf_hba_fsf_response(const char *, int, struct zfcp_fsf_req *,
+				       struct zfcp_dbf *);
+extern void _zfcp_dbf_hba_fsf_unsol(const char *, int level, struct zfcp_dbf *,
 					  struct fsf_status_read_buffer *);
-extern void zfcp_hba_dbf_event_qdio(struct zfcp_qdio *, unsigned int, int,
-				    int);
-extern void zfcp_hba_dbf_event_berr(struct zfcp_adapter *,
-				    struct zfcp_fsf_req *);
-extern void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *);
-extern void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *);
-extern void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *);
-extern void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *);
-extern void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *);
-extern void _zfcp_scsi_dbf_event(const char *, const char *, int,
-				 struct zfcp_dbf *, struct scsi_cmnd *,
-				 struct zfcp_fsf_req *, unsigned long);
+extern void zfcp_dbf_hba_qdio(struct zfcp_dbf *, unsigned int, int, int);
+extern void zfcp_dbf_hba_berr(struct zfcp_dbf *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_els_request(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_els_response(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_incoming_els(struct zfcp_fsf_req *);
+extern void _zfcp_dbf_scsi(const char *, const char *, int, struct zfcp_dbf *,
+			   struct scsi_cmnd *, struct zfcp_fsf_req *,
+			   unsigned long);
 
 /* zfcp_erp.c */
 extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, char *,
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 13:26:55.000000000 +0200
@@ -242,7 +242,7 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 		(struct fsf_status_read_buffer *) fsf_req->data;
 	unsigned int els_type = status_buffer->payload.data[0];
 
-	zfcp_san_dbf_event_incoming_els(fsf_req);
+	zfcp_dbf_san_incoming_els(fsf_req);
 	if (els_type == LS_PLOGI)
 		zfcp_fc_incoming_plogi(fsf_req);
 	else if (els_type == LS_LOGO)
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 13:26:55.000000000 +0200
@@ -248,13 +248,13 @@ static void zfcp_fsf_status_read_handler
 	struct fsf_status_read_buffer *sr_buf = req->data;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, sr_buf);
+		zfcp_dbf_hba_fsf_unsol("dism", adapter->dbf, sr_buf);
 		mempool_free(sr_buf, adapter->pool.status_read_data);
 		zfcp_fsf_req_free(req);
 		return;
 	}
 
-	zfcp_hba_dbf_event_fsf_unsol("read", adapter, sr_buf);
+	zfcp_dbf_hba_fsf_unsol("read", adapter->dbf, sr_buf);
 
 	switch (sr_buf->status_type) {
 	case FSF_STATUS_READ_PORT_CLOSED:
@@ -269,7 +269,7 @@ static void zfcp_fsf_status_read_handler
 		dev_warn(&adapter->ccw_device->dev,
 			 "The error threshold for checksum statistics "
 			 "has been exceeded\n");
-		zfcp_hba_dbf_event_berr(adapter, req);
+		zfcp_dbf_hba_berr(adapter->dbf, req);
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
@@ -355,7 +355,7 @@ static void zfcp_fsf_protstatus_eval(str
 	struct fsf_qtcb *qtcb = req->qtcb;
 	union fsf_prot_status_qual *psq = &qtcb->prefix.prot_status_qual;
 
-	zfcp_hba_dbf_event_fsf_response(req);
+	zfcp_dbf_hba_fsf_response(req);
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
@@ -848,7 +848,7 @@ failed_req_send:
 	mempool_free(sr_buf, adapter->pool.status_read_data);
 failed_buf:
 	zfcp_fsf_req_free(req);
-	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
+	zfcp_dbf_hba_fsf_unsol("fail", adapter->dbf, NULL);
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
 	return retval;
@@ -968,7 +968,7 @@ static void zfcp_fsf_send_ct_handler(str
 
 	switch (header->fsf_status) {
         case FSF_GOOD:
-		zfcp_san_dbf_event_ct_response(req);
+		zfcp_dbf_san_ct_response(req);
 		send_ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -1100,7 +1100,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	req->qtcb->bottom.support.timeout = ct->timeout;
 	req->data = ct;
 
-	zfcp_san_dbf_event_ct_request(req);
+	zfcp_dbf_san_ct_request(req);
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
 	ret = zfcp_fsf_req_send(req);
@@ -1129,7 +1129,7 @@ static void zfcp_fsf_send_els_handler(st
 
 	switch (header->fsf_status) {
 	case FSF_GOOD:
-		zfcp_san_dbf_event_els_response(req);
+		zfcp_dbf_san_els_response(req);
 		send_els->status = 0;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -1203,7 +1203,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	bottom->timeout = 2 * R_A_TOV;
 	req->data = els;
 
-	zfcp_san_dbf_event_els_request(req);
+	zfcp_dbf_san_els_request(req);
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	ret = zfcp_fsf_req_send(req);
@@ -2213,11 +2213,11 @@ static void zfcp_fsf_send_fcp_command_ta
 	}
 skip_fsfstatus:
 	if (scpnt->result != 0)
-		zfcp_scsi_dbf_event_result("erro", 3, req->adapter, scpnt, req);
+		zfcp_dbf_scsi_result("erro", 3, req->adapter->dbf, scpnt, req);
 	else if (scpnt->retries > 0)
-		zfcp_scsi_dbf_event_result("retr", 4, req->adapter, scpnt, req);
+		zfcp_dbf_scsi_result("retr", 4, req->adapter->dbf, scpnt, req);
 	else
-		zfcp_scsi_dbf_event_result("norm", 6, req->adapter, scpnt, req);
+		zfcp_dbf_scsi_result("norm", 6, req->adapter->dbf, scpnt, req);
 
 	scpnt->host_scribble = NULL;
 	(scpnt->scsi_done) (scpnt);
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 13:26:55.000000000 +0200
@@ -101,7 +101,8 @@ static void zfcp_qdio_int_req(struct ccw
 	struct zfcp_qdio_queue *queue = &qdio->req_q;
 
 	if (unlikely(qdio_err)) {
-		zfcp_hba_dbf_event_qdio(qdio, qdio_err, first, count);
+		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, first,
+					count);
 		zfcp_qdio_handler_error(qdio, "qdireq1");
 		return;
 	}
@@ -143,7 +144,8 @@ static void zfcp_qdio_int_resp(struct cc
 	int sbal_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
-		zfcp_hba_dbf_event_qdio(qdio, qdio_err, first, count);
+		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, first,
+					count);
 		zfcp_qdio_handler_error(qdio, "qdires1");
 		return;
 	}
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 13:26:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 13:26:55.000000000 +0200
@@ -53,11 +53,11 @@ static int zfcp_scsi_slave_configure(str
 
 static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *) scpnt->device->host->hostdata[0];
 	set_host_byte(scpnt, result);
 	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
-		zfcp_scsi_dbf_event_result("fail", 4,
-			(struct zfcp_adapter*) scpnt->device->host->hostdata[0],
-			scpnt, NULL);
+		zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
 	/* return directly */
 	scpnt->scsi_done(scpnt);
 }
@@ -93,7 +93,7 @@ static int zfcp_scsi_queuecommand(struct
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
-		zfcp_scsi_dbf_event_result("fail", 4, adapter, scpnt, NULL);
+		zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
 		scpnt->scsi_done(scpnt);
 		return 0;
 	}
@@ -181,8 +181,8 @@ static int zfcp_scsi_eh_abort_handler(st
 	spin_unlock(&adapter->req_list_lock);
 	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
-					  old_reqid);
+		zfcp_dbf_scsi_abort("lte1", adapter->dbf, scpnt, NULL,
+				    old_reqid);
 		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
@@ -198,8 +198,8 @@ static int zfcp_scsi_eh_abort_handler(st
 		zfcp_erp_wait(adapter);
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
-						  old_reqid);
+			zfcp_dbf_scsi_abort("nres", adapter->dbf, scpnt, NULL,
+					    old_reqid);
 			return SUCCESS;
 		}
 	}
@@ -216,7 +216,7 @@ static int zfcp_scsi_eh_abort_handler(st
 		dbf_tag = "fail";
 		retval = FAILED;
 	}
-	zfcp_scsi_dbf_event_abort(dbf_tag, adapter, scpnt, abrt_req, old_reqid);
+	zfcp_dbf_scsi_abort(dbf_tag, adapter->dbf, scpnt, abrt_req, old_reqid);
 	zfcp_fsf_req_free(abrt_req);
 	return retval;
 }
@@ -237,8 +237,7 @@ static int zfcp_task_mgmt_function(struc
 		zfcp_erp_wait(adapter);
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit,
-						     scpnt);
+			zfcp_dbf_scsi_devreset("nres", tm_flags, unit, scpnt);
 			return SUCCESS;
 		}
 	}
@@ -248,13 +247,13 @@ static int zfcp_task_mgmt_function(struc
 	wait_for_completion(&fsf_req->completion);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
-		zfcp_scsi_dbf_event_devreset("fail", tm_flags, unit, scpnt);
+		zfcp_dbf_scsi_devreset("fail", tm_flags, unit, scpnt);
 		retval = FAILED;
 	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP) {
-		zfcp_scsi_dbf_event_devreset("nsup", tm_flags, unit, scpnt);
+		zfcp_dbf_scsi_devreset("nsup", tm_flags, unit, scpnt);
 		retval = FAILED;
 	} else
-		zfcp_scsi_dbf_event_devreset("okay", tm_flags, unit, scpnt);
+		zfcp_dbf_scsi_devreset("okay", tm_flags, unit, scpnt);
 
 	zfcp_fsf_req_free(fsf_req);
 	return retval;

