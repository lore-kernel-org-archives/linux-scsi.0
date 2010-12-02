From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/7] zfcp: Redesign of the debug tracing for HBA records.
Date: Thu, 02 Dec 2010 15:16:14 +0100
Message-ID: <20101202141919.101519488@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:36814 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0LBOTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:23 -0500
Content-Disposition: inline; filename=703-zfcp-debug-tracing-hba.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

This patch is the continuation to redesign the zfcp tracing to a more
straight-forward and easy to extend scheme.

This patch deals with all trace records of the zfcp HBA area.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c  |  431 +++++++++++-------------------------------
 drivers/s390/scsi/zfcp_dbf.h  |  197 +++++++++----------
 drivers/s390/scsi/zfcp_ext.h  |   10 
 drivers/s390/scsi/zfcp_fsf.c  |   18 +
 drivers/s390/scsi/zfcp_qdio.c |    2 
 5 files changed, 228 insertions(+), 430 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -22,22 +22,34 @@ module_param(dbfsize, uint, 0400);
 MODULE_PARM_DESC(dbfsize,
 		 "number of pages for each debug feature area (default 4)");
 
-static void zfcp_dbf_hexdump(debug_info_t *dbf, void *to, int to_len,
-			     int level, char *from, int from_len)
+static inline unsigned int zfcp_dbf_plen(unsigned int offset)
 {
-	int offset;
-	struct zfcp_dbf_dump *dump = to;
-	int room = to_len - sizeof(*dump);
-
-	for (offset = 0; offset < from_len; offset += dump->size) {
-		memset(to, 0, to_len);
-		strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
-		dump->total_size = from_len;
-		dump->offset = offset;
-		dump->size = min(from_len - offset, room);
-		memcpy(dump->data, from + offset, dump->size);
-		debug_event(dbf, level, dump, dump->size + sizeof(*dump));
+	return sizeof(struct zfcp_dbf_pay) + offset - ZFCP_DBF_PAY_MAX_REC;
+}
+
+static inline
+void zfcp_dbf_pl_write(struct zfcp_dbf *dbf, void *data, u16 length, char *area,
+		       u64 req_id)
+{
+	struct zfcp_dbf_pay *pl = &dbf->pay_buf;
+	u16 offset = 0, rec_length;
+
+	spin_lock(&dbf->pay_lock);
+	memset(pl, 0, sizeof(*pl));
+	pl->fsf_req_id = req_id;
+	memcpy(pl->area, area, ZFCP_DBF_TAG_LEN);
+
+	while (offset < length) {
+		rec_length = min((u16) ZFCP_DBF_PAY_MAX_REC,
+				 (u16) (length - offset));
+		memcpy(pl->data, data + offset, rec_length);
+		debug_event(dbf->pay, 1, pl, zfcp_dbf_plen(rec_length));
+
+		offset += rec_length;
+		pl->counter++;
 	}
+
+	spin_unlock(&dbf->pay_lock);
 }
 
 static void zfcp_dbf_tag(char **p, const char *label, const char *tag)
@@ -104,336 +116,117 @@ static int zfcp_dbf_view_header(debug_in
 	return p - out_buf;
 }
 
-void _zfcp_dbf_hba_fsf_response(const char *tag2, int level,
-				struct zfcp_fsf_req *fsf_req,
-				struct zfcp_dbf *dbf)
-{
-	struct fsf_qtcb *qtcb = fsf_req->qtcb;
-	union fsf_prot_status_qual *prot_status_qual =
-					&qtcb->prefix.prot_status_qual;
-	union fsf_status_qual *fsf_status_qual = &qtcb->header.fsf_status_qual;
-	struct scsi_cmnd *scsi_cmnd;
-	struct zfcp_port *port;
-	struct zfcp_unit *unit;
-	struct zfcp_send_els *send_els;
-	struct zfcp_dbf_hba_record *rec = &dbf->hba_buf;
-	struct zfcp_dbf_hba_record_response *response = &rec->u.response;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dbf->hba_lock, flags);
-	memset(rec, 0, sizeof(*rec));
-	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
-	strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
-
-	response->fsf_command = fsf_req->fsf_command;
-	response->fsf_reqid = fsf_req->req_id;
-	response->fsf_seqno = fsf_req->seq_no;
-	response->fsf_issued = fsf_req->issued;
-	response->fsf_prot_status = qtcb->prefix.prot_status;
-	response->fsf_status = qtcb->header.fsf_status;
-	memcpy(response->fsf_prot_status_qual,
-	       prot_status_qual, FSF_PROT_STATUS_QUAL_SIZE);
-	memcpy(response->fsf_status_qual,
-	       fsf_status_qual, FSF_STATUS_QUALIFIER_SIZE);
-	response->fsf_req_status = fsf_req->status;
-	response->sbal_first = fsf_req->qdio_req.sbal_first;
-	response->sbal_last = fsf_req->qdio_req.sbal_last;
-	response->sbal_response = fsf_req->qdio_req.sbal_response;
-	response->pool = fsf_req->pool != NULL;
-	response->erp_action = (unsigned long)fsf_req->erp_action;
-
-	switch (fsf_req->fsf_command) {
-	case FSF_QTCB_FCP_CMND:
-		if (fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
-			break;
-		scsi_cmnd = (struct scsi_cmnd *)fsf_req->data;
-		if (scsi_cmnd) {
-			response->u.fcp.cmnd = (unsigned long)scsi_cmnd;
-			response->u.fcp.data_dir =
-				qtcb->bottom.io.data_direction;
-		}
-		break;
-
-	case FSF_QTCB_OPEN_PORT_WITH_DID:
-	case FSF_QTCB_CLOSE_PORT:
-	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		port = (struct zfcp_port *)fsf_req->data;
-		response->u.port.wwpn = port->wwpn;
-		response->u.port.d_id = port->d_id;
-		response->u.port.port_handle = qtcb->header.port_handle;
-		break;
-
-	case FSF_QTCB_OPEN_LUN:
-	case FSF_QTCB_CLOSE_LUN:
-		unit = (struct zfcp_unit *)fsf_req->data;
-		port = unit->port;
-		response->u.unit.wwpn = port->wwpn;
-		response->u.unit.fcp_lun = unit->fcp_lun;
-		response->u.unit.port_handle = qtcb->header.port_handle;
-		response->u.unit.lun_handle = qtcb->header.lun_handle;
-		break;
-
-	case FSF_QTCB_SEND_ELS:
-		send_els = (struct zfcp_send_els *)fsf_req->data;
-		response->u.els.d_id = ntoh24(qtcb->bottom.support.d_id);
-		break;
-
-	case FSF_QTCB_ABORT_FCP_CMND:
-	case FSF_QTCB_SEND_GENERIC:
-	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
-	case FSF_QTCB_EXCHANGE_PORT_DATA:
-	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		break;
-	}
-
-	debug_event(dbf->hba, level, rec, sizeof(*rec));
-
-	/* have fcp channel microcode fixed to use as little as possible */
-	if (fsf_req->fsf_command != FSF_QTCB_FCP_CMND) {
-		/* adjust length skipping trailing zeros */
-		char *buf = (char *)qtcb + qtcb->header.log_start;
-		int len = qtcb->header.log_length;
-		for (; len && !buf[len - 1]; len--);
-		zfcp_dbf_hexdump(dbf->hba, rec, sizeof(*rec), level, buf,
-				 len);
-	}
-
-	spin_unlock_irqrestore(&dbf->hba_lock, flags);
-}
-
-void _zfcp_dbf_hba_fsf_unsol(const char *tag, int level, struct zfcp_dbf *dbf,
-			     struct fsf_status_read_buffer *status_buffer)
+/**
+ * zfcp_dbf_hba_fsf_res - trace event for fsf responses
+ * @tag: tag indicating which kind of unsolicited status has been received
+ * @req: request for which a response was received
+ */
+void zfcp_dbf_hba_fsf_res(char *tag, struct zfcp_fsf_req *req)
 {
-	struct zfcp_dbf_hba_record *rec = &dbf->hba_buf;
+	struct zfcp_dbf *dbf = req->adapter->dbf;
+	struct fsf_qtcb_prefix *q_pref = &req->qtcb->prefix;
+	struct fsf_qtcb_header *q_head = &req->qtcb->header;
+	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
-	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
-	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
-
-	rec->u.status.failed = atomic_read(&dbf->adapter->stat_miss);
-	if (status_buffer != NULL) {
-		rec->u.status.status_type = status_buffer->status_type;
-		rec->u.status.status_subtype = status_buffer->status_subtype;
-		memcpy(&rec->u.status.queue_designator,
-		       &status_buffer->queue_designator,
-		       sizeof(struct fsf_queue_designator));
-
-		switch (status_buffer->status_type) {
-		case FSF_STATUS_READ_SENSE_DATA_AVAIL:
-			rec->u.status.payload_size =
-			    ZFCP_DBF_UNSOL_PAYLOAD_SENSE_DATA_AVAIL;
-			break;
 
-		case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-			rec->u.status.payload_size =
-			    ZFCP_DBF_UNSOL_PAYLOAD_BIT_ERROR_THRESHOLD;
-			break;
-
-		case FSF_STATUS_READ_LINK_DOWN:
-			switch (status_buffer->status_subtype) {
-			case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-			case FSF_STATUS_READ_SUB_FDISC_FAILED:
-				rec->u.status.payload_size =
-					sizeof(struct fsf_link_down_info);
-			}
-			break;
-
-		case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
-			rec->u.status.payload_size =
-			    ZFCP_DBF_UNSOL_PAYLOAD_FEATURE_UPDATE_ALERT;
-			break;
-		}
-		memcpy(&rec->u.status.payload,
-		       &status_buffer->payload, rec->u.status.payload_size);
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_HBA_RES;
+	rec->fsf_req_id = req->req_id;
+	rec->fsf_req_status = req->status;
+	rec->fsf_cmd = req->fsf_command;
+	rec->fsf_seq_no = req->seq_no;
+	rec->u.res.req_issued = req->issued;
+	rec->u.res.prot_status = q_pref->prot_status;
+	rec->u.res.fsf_status = q_head->fsf_status;
+
+	memcpy(rec->u.res.prot_status_qual, &q_pref->prot_status_qual,
+	       FSF_PROT_STATUS_QUAL_SIZE);
+	memcpy(rec->u.res.fsf_status_qual, &q_head->fsf_status_qual,
+	       FSF_STATUS_QUALIFIER_SIZE);
+
+	if (req->fsf_command != FSF_QTCB_FCP_CMND) {
+		rec->pl_len = q_head->log_length;
+		zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
+				  rec->pl_len, "fsf_res", req->req_id);
 	}
 
-	debug_event(dbf->hba, level, rec, sizeof(*rec));
+	debug_event(dbf->hba, 1, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
 /**
- * zfcp_dbf_hba_qdio - trace event for QDIO related failure
- * @qdio: qdio structure affected by this QDIO related event
- * @qdio_error: as passed by qdio module
- * @sbal_index: first buffer with error condition, as passed by qdio module
- * @sbal_count: number of buffers affected, as passed by qdio module
+ * zfcp_dbf_hba_fsf_uss - trace event for an unsolicited status buffer
+ * @tag: tag indicating which kind of unsolicited status has been received
+ * @req: request providing the unsolicited status
  */
-void zfcp_dbf_hba_qdio(struct zfcp_dbf *dbf, unsigned int qdio_error,
-		       int sbal_index, int sbal_count)
+void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 {
-	struct zfcp_dbf_hba_record *r = &dbf->hba_buf;
+	struct zfcp_dbf *dbf = req->adapter->dbf;
+	struct fsf_status_read_buffer *srb = req->data;
+	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->hba_lock, flags);
-	memset(r, 0, sizeof(*r));
-	strncpy(r->tag, "qdio", ZFCP_DBF_TAG_SIZE);
-	r->u.qdio.qdio_error = qdio_error;
-	r->u.qdio.sbal_index = sbal_index;
-	r->u.qdio.sbal_count = sbal_count;
-	debug_event(dbf->hba, 0, r, sizeof(*r));
+	memset(rec, 0, sizeof(*rec));
+
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_HBA_USS;
+	rec->fsf_req_id = req->req_id;
+	rec->fsf_req_status = req->status;
+	rec->fsf_cmd = req->fsf_command;
+
+	if (!srb)
+		goto log;
+
+	rec->u.uss.status_type = srb->status_type;
+	rec->u.uss.status_subtype = srb->status_subtype;
+	rec->u.uss.d_id = ntoh24(srb->d_id);
+	rec->u.uss.lun = srb->fcp_lun;
+	memcpy(&rec->u.uss.queue_designator, &srb->queue_designator,
+	       sizeof(rec->u.uss.queue_designator));
+
+	/* status read buffer payload length */
+	rec->pl_len = (!srb->length) ? 0 : srb->length -
+			offsetof(struct fsf_status_read_buffer, payload);
+
+	if (rec->pl_len)
+		zfcp_dbf_pl_write(dbf, srb->payload.data, rec->pl_len,
+				  "fsf_uss", req->req_id);
+log:
+	debug_event(dbf->hba, 2, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
 /**
- * zfcp_dbf_hba_berr - trace event for bit error threshold
- * @dbf: dbf structure affected by this QDIO related event
- * @req: fsf request
+ * zfcp_dbf_hba_bit_err - trace event for bit error conditions
+ * @tag: tag indicating which kind of unsolicited status has been received
+ * @req: request which caused the bit_error condition
  */
-void zfcp_dbf_hba_berr(struct zfcp_dbf *dbf, struct zfcp_fsf_req *req)
+void zfcp_dbf_hba_bit_err(char *tag, struct zfcp_fsf_req *req)
 {
-	struct zfcp_dbf_hba_record *r = &dbf->hba_buf;
+	struct zfcp_dbf *dbf = req->adapter->dbf;
+	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
 	struct fsf_status_read_buffer *sr_buf = req->data;
-	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->hba_lock, flags);
-	memset(r, 0, sizeof(*r));
-	strncpy(r->tag, "berr", ZFCP_DBF_TAG_SIZE);
-	memcpy(&r->u.berr, err, sizeof(struct fsf_bit_error_payload));
-	debug_event(dbf->hba, 0, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->hba_lock, flags);
-}
-static void zfcp_dbf_hba_view_response(char **p,
-				       struct zfcp_dbf_hba_record_response *r)
-{
-	struct timespec t;
-
-	zfcp_dbf_out(p, "fsf_command", "0x%08x", r->fsf_command);
-	zfcp_dbf_out(p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
-	zfcp_dbf_out(p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-	stck_to_timespec(r->fsf_issued, &t);
-	zfcp_dbf_out(p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
-	zfcp_dbf_out(p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
-	zfcp_dbf_out(p, "fsf_status", "0x%08x", r->fsf_status);
-	zfcp_dbf_outd(p, "fsf_prot_status_qual", r->fsf_prot_status_qual,
-		      FSF_PROT_STATUS_QUAL_SIZE, 0, FSF_PROT_STATUS_QUAL_SIZE);
-	zfcp_dbf_outd(p, "fsf_status_qual", r->fsf_status_qual,
-		      FSF_STATUS_QUALIFIER_SIZE, 0, FSF_STATUS_QUALIFIER_SIZE);
-	zfcp_dbf_out(p, "fsf_req_status", "0x%08x", r->fsf_req_status);
-	zfcp_dbf_out(p, "sbal_first", "0x%02x", r->sbal_first);
-	zfcp_dbf_out(p, "sbal_last", "0x%02x", r->sbal_last);
-	zfcp_dbf_out(p, "sbal_response", "0x%02x", r->sbal_response);
-	zfcp_dbf_out(p, "pool", "0x%02x", r->pool);
-
-	switch (r->fsf_command) {
-	case FSF_QTCB_FCP_CMND:
-		if (r->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
-			break;
-		zfcp_dbf_out(p, "data_direction", "0x%04x", r->u.fcp.data_dir);
-		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
-		*p += sprintf(*p, "\n");
-		break;
-
-	case FSF_QTCB_OPEN_PORT_WITH_DID:
-	case FSF_QTCB_CLOSE_PORT:
-	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->u.port.wwpn);
-		zfcp_dbf_out(p, "d_id", "0x%06x", r->u.port.d_id);
-		zfcp_dbf_out(p, "port_handle", "0x%08x", r->u.port.port_handle);
-		break;
-
-	case FSF_QTCB_OPEN_LUN:
-	case FSF_QTCB_CLOSE_LUN:
-		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->u.unit.wwpn);
-		zfcp_dbf_out(p, "fcp_lun", "0x%016Lx", r->u.unit.fcp_lun);
-		zfcp_dbf_out(p, "port_handle", "0x%08x", r->u.unit.port_handle);
-		zfcp_dbf_out(p, "lun_handle", "0x%08x", r->u.unit.lun_handle);
-		break;
-
-	case FSF_QTCB_SEND_ELS:
-		zfcp_dbf_out(p, "d_id", "0x%06x", r->u.els.d_id);
-		break;
-
-	case FSF_QTCB_ABORT_FCP_CMND:
-	case FSF_QTCB_SEND_GENERIC:
-	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
-	case FSF_QTCB_EXCHANGE_PORT_DATA:
-	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		break;
-	}
-}
-
-static void zfcp_dbf_hba_view_status(char **p,
-				     struct zfcp_dbf_hba_record_status *r)
-{
-	zfcp_dbf_out(p, "failed", "0x%02x", r->failed);
-	zfcp_dbf_out(p, "status_type", "0x%08x", r->status_type);
-	zfcp_dbf_out(p, "status_subtype", "0x%08x", r->status_subtype);
-	zfcp_dbf_outd(p, "queue_designator", (char *)&r->queue_designator,
-		      sizeof(struct fsf_queue_designator), 0,
-		      sizeof(struct fsf_queue_designator));
-	zfcp_dbf_outd(p, "payload", (char *)&r->payload, r->payload_size, 0,
-		      r->payload_size);
-}
-
-static void zfcp_dbf_hba_view_qdio(char **p, struct zfcp_dbf_hba_record_qdio *r)
-{
-	zfcp_dbf_out(p, "qdio_error", "0x%08x", r->qdio_error);
-	zfcp_dbf_out(p, "sbal_index", "0x%02x", r->sbal_index);
-	zfcp_dbf_out(p, "sbal_count", "0x%02x", r->sbal_count);
-}
-
-static void zfcp_dbf_hba_view_berr(char **p, struct fsf_bit_error_payload *r)
-{
-	zfcp_dbf_out(p, "link_failures", "%d", r->link_failure_error_count);
-	zfcp_dbf_out(p, "loss_of_sync_err", "%d", r->loss_of_sync_error_count);
-	zfcp_dbf_out(p, "loss_of_sig_err", "%d", r->loss_of_signal_error_count);
-	zfcp_dbf_out(p, "prim_seq_err", "%d",
-		     r->primitive_sequence_error_count);
-	zfcp_dbf_out(p, "inval_trans_word_err", "%d",
-		     r->invalid_transmission_word_error_count);
-	zfcp_dbf_out(p, "CRC_errors", "%d", r->crc_error_count);
-	zfcp_dbf_out(p, "prim_seq_event_to", "%d",
-		     r->primitive_sequence_event_timeout_count);
-	zfcp_dbf_out(p, "elast_buf_overrun_err", "%d",
-		     r->elastic_buffer_overrun_error_count);
-	zfcp_dbf_out(p, "adv_rec_buf2buf_cred", "%d",
-		     r->advertised_receive_b2b_credit);
-	zfcp_dbf_out(p, "curr_rec_buf2buf_cred", "%d",
-		     r->current_receive_b2b_credit);
-	zfcp_dbf_out(p, "adv_trans_buf2buf_cred", "%d",
-		     r->advertised_transmit_b2b_credit);
-	zfcp_dbf_out(p, "curr_trans_buf2buf_cred", "%d",
-		     r->current_transmit_b2b_credit);
-}
-
-static int zfcp_dbf_hba_view_format(debug_info_t *id, struct debug_view *view,
-				    char *out_buf, const char *in_buf)
-{
-	struct zfcp_dbf_hba_record *r = (struct zfcp_dbf_hba_record *)in_buf;
-	char *p = out_buf;
-
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
-		return 0;
-
-	zfcp_dbf_tag(&p, "tag", r->tag);
-	if (isalpha(r->tag2[0]))
-		zfcp_dbf_tag(&p, "tag2", r->tag2);
+	memset(rec, 0, sizeof(*rec));
 
-	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_hba_view_response(&p, &r->u.response);
-	else if (strncmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_hba_view_status(&p, &r->u.status);
-	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_hba_view_qdio(&p, &r->u.qdio);
-	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_hba_view_berr(&p, &r->u.berr);
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_HBA_BIT;
+	rec->fsf_req_id = req->req_id;
+	rec->fsf_req_status = req->status;
+	rec->fsf_cmd = req->fsf_command;
+	memcpy(&rec->u.be, &sr_buf->payload.bit_error,
+	       sizeof(struct fsf_bit_error_payload));
 
-	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
-		p += sprintf(p, "\n");
-	return p - out_buf;
+	debug_event(dbf->hba, 1, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
-static struct debug_view zfcp_dbf_hba_view = {
-	.name = "structured",
-	.header_proc = zfcp_dbf_view_header,
-	.format_proc = zfcp_dbf_hba_view_format,
-};
-
 static void zfcp_dbf_set_common(struct zfcp_dbf_rec *rec,
 				struct zfcp_adapter *adapter,
 				struct zfcp_port *port,
@@ -758,6 +551,7 @@ int zfcp_dbf_adapter_register(struct zfc
 
 	dbf->adapter = adapter;
 
+	spin_lock_init(&dbf->pay_lock);
 	spin_lock_init(&dbf->hba_lock);
 	spin_lock_init(&dbf->san_lock);
 	spin_lock_init(&dbf->scsi_lock);
@@ -771,11 +565,17 @@ int zfcp_dbf_adapter_register(struct zfc
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
 	sprintf(dbf_name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
-	dbf->hba = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_hba_view,
-				sizeof(struct zfcp_dbf_hba_record));
+	dbf->hba = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_hba));
 	if (!dbf->hba)
 		goto err_out;
 
+	/* debug feature area which records payload info */
+	sprintf(dbf_name, "zfcp_%s_pay", dev_name(&adapter->ccw_device->dev));
+	dbf->pay = zfcp_dbf_reg(dbf_name, 3, NULL,
+				sizeof(struct zfcp_dbf_pay));
+	if (!dbf->pay)
+		goto err_out;
+
 	/* debug feature area which records SAN command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
 	dbf->san = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_san));
@@ -808,6 +608,7 @@ void zfcp_dbf_adapter_unregister(struct
 	debug_unregister(dbf->scsi);
 	debug_unregister(dbf->san);
 	debug_unregister(dbf->hba);
+	debug_unregister(dbf->pay);
 	debug_unregister(dbf->rec);
 	dbf->adapter->dbf = NULL;
 	kfree(dbf);
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -1,22 +1,8 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
+ * debug feature declarations
  *
- * Copyright IBM Corp. 2008, 2009
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corp. 2008, 2010
  */
 
 #ifndef ZFCP_DBF_H
@@ -136,73 +122,90 @@ struct zfcp_dbf_san {
 	char payload[ZFCP_DBF_SAN_MAX_PAYLOAD];
 } __packed;
 
-struct zfcp_dbf_hba_record_response {
-	u32 fsf_command;
-	u64 fsf_reqid;
-	u32 fsf_seqno;
-	u64 fsf_issued;
-	u32 fsf_prot_status;
+/**
+ * struct zfcp_dbf_hba_res - trace record for hba responses
+ * @req_issued: timestamp when request was issued
+ * @prot_status: protocol status
+ * @prot_status_qual: protocol status qualifier
+ * @fsf_status: fsf status
+ * @fsf_status_qual: fsf status qualifier
+ */
+struct zfcp_dbf_hba_res {
+	u64 req_issued;
+	u32 prot_status;
+	u8  prot_status_qual[FSF_PROT_STATUS_QUAL_SIZE];
 	u32 fsf_status;
-	u8 fsf_prot_status_qual[FSF_PROT_STATUS_QUAL_SIZE];
-	u8 fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
-	u32 fsf_req_status;
-	u8 sbal_first;
-	u8 sbal_last;
-	u8 sbal_response;
-	u8 pool;
-	u64 erp_action;
-	union {
-		struct {
-			u64 cmnd;
-			u32 data_dir;
-		} fcp;
-		struct {
-			u64 wwpn;
-			u32 d_id;
-			u32 port_handle;
-		} port;
-		struct {
-			u64 wwpn;
-			u64 fcp_lun;
-			u32 port_handle;
-			u32 lun_handle;
-		} unit;
-		struct {
-			u32 d_id;
-		} els;
-	} u;
-} __attribute__ ((packed));
+	u8  fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
+} __packed;
 
-struct zfcp_dbf_hba_record_status {
-	u8 failed;
+/**
+ * struct zfcp_dbf_hba_uss - trace record for unsolicited status
+ * @status_type: type of unsolicited status
+ * @status_subtype: subtype of unsolicited status
+ * @d_id: destination ID
+ * @lun: logical unit number
+ * @queue_designator: queue designator
+ */
+struct zfcp_dbf_hba_uss {
 	u32 status_type;
 	u32 status_subtype;
-	struct fsf_queue_designator
-	 queue_designator;
-	u32 payload_size;
-#define ZFCP_DBF_UNSOL_PAYLOAD				80
-#define ZFCP_DBF_UNSOL_PAYLOAD_SENSE_DATA_AVAIL		32
-#define ZFCP_DBF_UNSOL_PAYLOAD_BIT_ERROR_THRESHOLD	56
-#define ZFCP_DBF_UNSOL_PAYLOAD_FEATURE_UPDATE_ALERT	2 * sizeof(u32)
-	u8 payload[ZFCP_DBF_UNSOL_PAYLOAD];
-} __attribute__ ((packed));
+	u32 d_id;
+	u64 lun;
+	u64 queue_designator;
+} __packed;
 
-struct zfcp_dbf_hba_record_qdio {
-	u32 qdio_error;
-	u8 sbal_index;
-	u8 sbal_count;
-} __attribute__ ((packed));
+/**
+ * enum zfcp_dbf_hba_id - HBA trace record identifier
+ * @ZFCP_DBF_HBA_RES: response trace record
+ * @ZFCP_DBF_HBA_USS: unsolicited status trace record
+ * @ZFCP_DBF_HBA_BIT: bit error trace record
+ */
+enum zfcp_dbf_hba_id {
+	ZFCP_DBF_HBA_RES	= 1,
+	ZFCP_DBF_HBA_USS	= 2,
+	ZFCP_DBF_HBA_BIT	= 3,
+};
 
-struct zfcp_dbf_hba_record {
-	u8 tag[ZFCP_DBF_TAG_SIZE];
-	u8 tag2[ZFCP_DBF_TAG_SIZE];
+/**
+ * struct zfcp_dbf_hba - common trace record for HBA records
+ * @id: unique number of recovery record type
+ * @tag: identifier string specifying the location of initiation
+ * @fsf_req_id: request id for fsf requests
+ * @fsf_req_status: status of fsf request
+ * @fsf_cmd: fsf command
+ * @fsf_seq_no: fsf sequence number
+ * @pl_len: length of payload stored as zfcp_dbf_pay
+ * @u: record type specific data
+ */
+struct zfcp_dbf_hba {
+	u8 id;
+	char tag[ZFCP_DBF_TAG_LEN];
+	u64 fsf_req_id;
+	u32 fsf_req_status;
+	u32 fsf_cmd;
+	u32 fsf_seq_no;
+	u16 pl_len;
 	union {
-		struct zfcp_dbf_hba_record_response response;
-		struct zfcp_dbf_hba_record_status status;
-		struct zfcp_dbf_hba_record_qdio qdio;
-		struct fsf_bit_error_payload berr;
+		struct zfcp_dbf_hba_res res;
+		struct zfcp_dbf_hba_uss uss;
+		struct fsf_bit_error_payload be;
 	} u;
-} __attribute__ ((packed));
+} __packed;
+
+/**
+ * struct zfcp_dbf_pay - trace record for unformatted payload information
+ * @area: area this record is originated from
+ * @counter: ascending record number
+ * @fsf_req_id: request id of fsf request
+ * @data: unformatted data
+ */
+struct zfcp_dbf_pay {
+	char area[ZFCP_DBF_TAG_LEN];
+	char counter;
+	u64 fsf_req_id;
+#define ZFCP_DBF_PAY_MAX_REC 0x100
+	char data[ZFCP_DBF_PAY_MAX_REC];
+} __packed;
 
 struct zfcp_dbf_scsi_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
@@ -230,71 +233,57 @@ struct zfcp_dbf_scsi_record {
 } __attribute__ ((packed));
 
 struct zfcp_dbf {
+	debug_info_t			*pay;
 	debug_info_t			*rec;
 	debug_info_t			*hba;
 	debug_info_t			*san;
 	debug_info_t			*scsi;
+	spinlock_t			pay_lock;
 	spinlock_t			rec_lock;
 	spinlock_t			hba_lock;
 	spinlock_t			san_lock;
 	spinlock_t			scsi_lock;
 	struct zfcp_dbf_rec		rec_buf;
-	struct zfcp_dbf_hba_record	hba_buf;
+	struct zfcp_dbf_hba		hba_buf;
 	struct zfcp_dbf_san		san_buf;
 	struct zfcp_dbf_scsi_record	scsi_buf;
+	struct zfcp_dbf_pay		pay_buf;
 	struct zfcp_adapter		*adapter;
 };
 
 static inline
-void zfcp_dbf_hba_fsf_resp(const char *tag2, int level,
-			   struct zfcp_fsf_req *req, struct zfcp_dbf *dbf)
+void zfcp_dbf_hba_fsf_resp(char *tag, int level, struct zfcp_fsf_req *req)
 {
-	if (level <= dbf->hba->level)
-		_zfcp_dbf_hba_fsf_response(tag2, level, req, dbf);
+	if (level <= req->adapter->dbf->hba->level)
+		zfcp_dbf_hba_fsf_res(tag, req);
 }
 
 /**
  * zfcp_dbf_hba_fsf_response - trace event for request completion
  * @fsf_req: request that has been completed
  */
-static inline void zfcp_dbf_hba_fsf_response(struct zfcp_fsf_req *req)
+static inline
+void zfcp_dbf_hba_fsf_response(struct zfcp_fsf_req *req)
 {
-	struct zfcp_dbf *dbf = req->adapter->dbf;
 	struct fsf_qtcb *qtcb = req->qtcb;
 
 	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
 	    (qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
-		zfcp_dbf_hba_fsf_resp("perr", 1, req, dbf);
+		zfcp_dbf_hba_fsf_resp("fs_perr", 1, req);
 
 	} else if (qtcb->header.fsf_status != FSF_GOOD) {
-		zfcp_dbf_hba_fsf_resp("ferr", 1, req, dbf);
+		zfcp_dbf_hba_fsf_resp("fs_ferr", 1, req);
 
 	} else if ((req->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) ||
 		   (req->fsf_command == FSF_QTCB_OPEN_LUN)) {
-		zfcp_dbf_hba_fsf_resp("open", 4, req, dbf);
+		zfcp_dbf_hba_fsf_resp("fs_open", 4, req);
 
 	} else if (qtcb->header.log_length) {
-		zfcp_dbf_hba_fsf_resp("qtcb", 5, req, dbf);
+		zfcp_dbf_hba_fsf_resp("fs_qtcb", 5, req);
 
 	} else {
-		zfcp_dbf_hba_fsf_resp("norm", 6, req, dbf);
+		zfcp_dbf_hba_fsf_resp("fs_norm", 6, req);
 	}
- }
-
-/**
- * zfcp_dbf_hba_fsf_unsol - trace event for an unsolicited status buffer
- * @tag: tag indicating which kind of unsolicited status has been received
- * @dbf: reference to dbf structure
- * @status_buffer: buffer containing payload of unsolicited status
- */
-static inline
-void zfcp_dbf_hba_fsf_unsol(const char *tag, struct zfcp_dbf *dbf,
-			    struct fsf_status_read_buffer *buf)
-{
-	int level = 2;
-
-	if (level <= dbf->hba->level)
-		_zfcp_dbf_hba_fsf_unsol(tag, level, dbf, buf);
 }
 
 static inline
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -49,11 +49,9 @@ extern void zfcp_dbf_adapter_unregister(
 extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
 			      struct zfcp_port *, struct scsi_device *, u8, u8);
 extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
-extern void _zfcp_dbf_hba_fsf_response(const char *, int, struct zfcp_fsf_req *,
-				       struct zfcp_dbf *);
-extern void _zfcp_dbf_hba_fsf_unsol(const char *, int level, struct zfcp_dbf *,
-					  struct fsf_status_read_buffer *);
-extern void zfcp_dbf_hba_qdio(struct zfcp_dbf *, unsigned int, int, int);
+extern void zfcp_dbf_hba_fsf_uss(char *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_hba_fsf_res(char *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_berr(struct zfcp_dbf *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
@@ -141,6 +139,8 @@ extern int zfcp_qdio_sbals_from_sg(struc
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
 extern void zfcp_qdio_siosl(struct zfcp_adapter *);
+extern struct zfcp_fsf_req *zfcp_fsf_get_req(struct zfcp_qdio *,
+					     struct qdio_buffer *);
 
 /* zfcp_scsi.c */
 extern struct zfcp_data zfcp_data;
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -211,13 +211,13 @@ static void zfcp_fsf_status_read_handler
 	struct fsf_status_read_buffer *sr_buf = req->data;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		zfcp_dbf_hba_fsf_unsol("dism", adapter->dbf, sr_buf);
+		zfcp_dbf_hba_fsf_uss("fssrh_1", req);
 		mempool_free(sr_buf, adapter->pool.status_read_data);
 		zfcp_fsf_req_free(req);
 		return;
 	}
 
-	zfcp_dbf_hba_fsf_unsol("read", adapter->dbf, sr_buf);
+	zfcp_dbf_hba_fsf_uss("fssrh_2", req);
 
 	switch (sr_buf->status_type) {
 	case FSF_STATUS_READ_PORT_CLOSED:
@@ -232,7 +232,7 @@ static void zfcp_fsf_status_read_handler
 		dev_warn(&adapter->ccw_device->dev,
 			 "The error threshold for checksum statistics "
 			 "has been exceeded\n");
-		zfcp_dbf_hba_berr(adapter->dbf, req);
+		zfcp_dbf_hba_bit_err("fssrh_3", req);
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
@@ -754,10 +754,11 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	goto out;
 
 failed_req_send:
+	req->data = NULL;
 	mempool_free(sr_buf, adapter->pool.status_read_data);
 failed_buf:
+	zfcp_dbf_hba_fsf_uss("fssr__1", req);
 	zfcp_fsf_req_free(req);
-	zfcp_dbf_hba_fsf_unsol("fail", adapter->dbf, NULL);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -2420,3 +2421,12 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 			break;
 	}
 }
+
+struct zfcp_fsf_req *zfcp_fsf_get_req(struct zfcp_qdio *qdio,
+				      struct qdio_buffer *sbal)
+{
+	struct qdio_buffer_element *sbale = &sbal->element[0];
+	u64 req_id = (unsigned long) sbale->addr;
+
+	return zfcp_reqlist_find(qdio->adapter->req_list, req_id);
+}
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -74,7 +74,6 @@ static void zfcp_qdio_int_req(struct ccw
 	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
 
 	if (unlikely(qdio_err)) {
-		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
 		zfcp_qdio_handler_error(qdio, "qdireq1", qdio_err);
 		return;
 	}
@@ -97,7 +96,6 @@ static void zfcp_qdio_int_resp(struct cc
 	int sbal_idx, sbal_no;
 
 	if (unlikely(qdio_err)) {
-		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
 		zfcp_qdio_handler_error(qdio, "qdires1", qdio_err);
 		return;
 	}

