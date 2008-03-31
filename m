From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/9] zfcp: Shorten excessive names in debug trace.
Date: Mon, 31 Mar 2008 11:15:29 +0200
Message-ID: <20080331091834.879147000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:48203 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbYCaJSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:37 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_shorter_names.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Saving on line breaks, improving readability, by shortening excessive
function names and identifiers, by simplifying some functions call
chains, and by simplifying nesting of some data structure.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  305 +++++++++++++++++++------------------------
 drivers/s390/scsi/zfcp_dbf.h |   74 ++++------
 2 files changed, 170 insertions(+), 209 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:26:00.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:31:43.000000000 +0200
@@ -144,12 +144,12 @@ void zfcp_hba_dbf_event_fsf_response(str
 	struct zfcp_unit *unit;
 	struct zfcp_send_els *send_els;
 	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
-	struct zfcp_hba_dbf_record_response *response = &rec->type.response;
+	struct zfcp_hba_dbf_record_response *response = &rec->u.response;
 	int level;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
-	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
+	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
 
 	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
@@ -193,11 +193,9 @@ void zfcp_hba_dbf_event_fsf_response(str
 		if (fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
 			break;
 		scsi_cmnd = (struct scsi_cmnd *)fsf_req->data;
-		if (scsi_cmnd != NULL) {
-			response->data.send_fcp.scsi_cmnd
-			    = (unsigned long)scsi_cmnd;
-			response->data.send_fcp.scsi_serial
-			    = scsi_cmnd->serial_number;
+		if (scsi_cmnd) {
+			response->u.fcp.cmnd = (unsigned long)scsi_cmnd;
+			response->u.fcp.serial = scsi_cmnd->serial_number;
 		}
 		break;
 
@@ -205,25 +203,25 @@ void zfcp_hba_dbf_event_fsf_response(str
 	case FSF_QTCB_CLOSE_PORT:
 	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
 		port = (struct zfcp_port *)fsf_req->data;
-		response->data.port.wwpn = port->wwpn;
-		response->data.port.d_id = port->d_id;
-		response->data.port.port_handle = qtcb->header.port_handle;
+		response->u.port.wwpn = port->wwpn;
+		response->u.port.d_id = port->d_id;
+		response->u.port.port_handle = qtcb->header.port_handle;
 		break;
 
 	case FSF_QTCB_OPEN_LUN:
 	case FSF_QTCB_CLOSE_LUN:
 		unit = (struct zfcp_unit *)fsf_req->data;
 		port = unit->port;
-		response->data.unit.wwpn = port->wwpn;
-		response->data.unit.fcp_lun = unit->fcp_lun;
-		response->data.unit.port_handle = qtcb->header.port_handle;
-		response->data.unit.lun_handle = qtcb->header.lun_handle;
+		response->u.unit.wwpn = port->wwpn;
+		response->u.unit.fcp_lun = unit->fcp_lun;
+		response->u.unit.port_handle = qtcb->header.port_handle;
+		response->u.unit.lun_handle = qtcb->header.lun_handle;
 		break;
 
 	case FSF_QTCB_SEND_ELS:
 		send_els = (struct zfcp_send_els *)fsf_req->data;
-		response->data.send_els.d_id = qtcb->bottom.support.d_id;
-		response->data.send_els.ls_code = send_els->ls_code >> 24;
+		response->u.els.d_id = qtcb->bottom.support.d_id;
+		response->u.els.ls_code = send_els->ls_code >> 24;
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -235,8 +233,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 		break;
 	}
 
-	debug_event(adapter->hba_dbf, level,
-		    rec, sizeof(struct zfcp_hba_dbf_record));
+	debug_event(adapter->hba_dbf, level, rec, sizeof(*rec));
 
 	/* have fcp channel microcode fixed to use as little as possible */
 	if (fsf_req->fsf_command != FSF_QTCB_FCP_CMND) {
@@ -259,26 +256,26 @@ zfcp_hba_dbf_event_fsf_unsol(const char 
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
-	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
+	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
 	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
 
-	rec->type.status.failed = adapter->status_read_failed;
+	rec->u.status.failed = adapter->status_read_failed;
 	if (status_buffer != NULL) {
-		rec->type.status.status_type = status_buffer->status_type;
-		rec->type.status.status_subtype = status_buffer->status_subtype;
-		memcpy(&rec->type.status.queue_designator,
+		rec->u.status.status_type = status_buffer->status_type;
+		rec->u.status.status_subtype = status_buffer->status_subtype;
+		memcpy(&rec->u.status.queue_designator,
 		       &status_buffer->queue_designator,
 		       sizeof(struct fsf_queue_designator));
 
 		switch (status_buffer->status_type) {
 		case FSF_STATUS_READ_SENSE_DATA_AVAIL:
-			rec->type.status.payload_size =
+			rec->u.status.payload_size =
 			    ZFCP_DBF_UNSOL_PAYLOAD_SENSE_DATA_AVAIL;
 			break;
 
 		case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-			rec->type.status.payload_size =
+			rec->u.status.payload_size =
 			    ZFCP_DBF_UNSOL_PAYLOAD_BIT_ERROR_THRESHOLD;
 			break;
 
@@ -286,22 +283,21 @@ zfcp_hba_dbf_event_fsf_unsol(const char 
 			switch (status_buffer->status_subtype) {
 			case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
 			case FSF_STATUS_READ_SUB_FDISC_FAILED:
-				rec->type.status.payload_size =
+				rec->u.status.payload_size =
 					sizeof(struct fsf_link_down_info);
 			}
 			break;
 
 		case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
-			rec->type.status.payload_size =
+			rec->u.status.payload_size =
 			    ZFCP_DBF_UNSOL_PAYLOAD_FEATURE_UPDATE_ALERT;
 			break;
 		}
-		memcpy(&rec->type.status.payload,
-		       &status_buffer->payload, rec->type.status.payload_size);
+		memcpy(&rec->u.status.payload,
+		       &status_buffer->payload, rec->u.status.payload_size);
 	}
 
-	debug_event(adapter->hba_dbf, 2,
-		    rec, sizeof(struct zfcp_hba_dbf_record));
+	debug_event(adapter->hba_dbf, 2, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
@@ -310,19 +306,18 @@ zfcp_hba_dbf_event_qdio(struct zfcp_adap
 			unsigned int qdio_error, unsigned int siga_error,
 			int sbal_index, int sbal_count)
 {
-	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	struct zfcp_hba_dbf_record *r = &adapter->hba_dbf_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
-	memset(rec, 0, sizeof(struct zfcp_hba_dbf_record));
-	strncpy(rec->tag, "qdio", ZFCP_DBF_TAG_SIZE);
-	rec->type.qdio.status = status;
-	rec->type.qdio.qdio_error = qdio_error;
-	rec->type.qdio.siga_error = siga_error;
-	rec->type.qdio.sbal_index = sbal_index;
-	rec->type.qdio.sbal_count = sbal_count;
-	debug_event(adapter->hba_dbf, 0,
-		    rec, sizeof(struct zfcp_hba_dbf_record));
+	memset(r, 0, sizeof(*r));
+	strncpy(r->tag, "qdio", ZFCP_DBF_TAG_SIZE);
+	r->u.qdio.status = status;
+	r->u.qdio.qdio_error = qdio_error;
+	r->u.qdio.siga_error = siga_error;
+	r->u.qdio.sbal_index = sbal_index;
+	r->u.qdio.sbal_count = sbal_count;
+	debug_event(adapter->hba_dbf, 0, r, sizeof(*r));
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
@@ -352,34 +347,29 @@ static void zfcp_hba_dbf_view_response(c
 	case FSF_QTCB_FCP_CMND:
 		if (r->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
 			break;
-		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx",
-			     r->data.send_fcp.scsi_cmnd);
-		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx",
-			     r->data.send_fcp.scsi_serial);
+		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
+		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
 	case FSF_QTCB_CLOSE_PORT:
 	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->data.port.wwpn);
-		zfcp_dbf_out(p, "d_id", "0x%06x", r->data.port.d_id);
-		zfcp_dbf_out(p, "port_handle", "0x%08x",
-			     r->data.port.port_handle);
+		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->u.port.wwpn);
+		zfcp_dbf_out(p, "d_id", "0x%06x", r->u.port.d_id);
+		zfcp_dbf_out(p, "port_handle", "0x%08x", r->u.port.port_handle);
 		break;
 
 	case FSF_QTCB_OPEN_LUN:
 	case FSF_QTCB_CLOSE_LUN:
-		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->data.unit.wwpn);
-		zfcp_dbf_out(p, "fcp_lun", "0x%016Lx", r->data.unit.fcp_lun);
-		zfcp_dbf_out(p, "port_handle", "0x%08x",
-			     r->data.unit.port_handle);
-		zfcp_dbf_out(p, "lun_handle", "0x%08x",
-			     r->data.unit.lun_handle);
+		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->u.unit.wwpn);
+		zfcp_dbf_out(p, "fcp_lun", "0x%016Lx", r->u.unit.fcp_lun);
+		zfcp_dbf_out(p, "port_handle", "0x%08x", r->u.unit.port_handle);
+		zfcp_dbf_out(p, "lun_handle", "0x%08x", r->u.unit.lun_handle);
 		break;
 
 	case FSF_QTCB_SEND_ELS:
-		zfcp_dbf_out(p, "d_id", "0x%06x", r->data.send_els.d_id);
-		zfcp_dbf_out(p, "ls_code", "0x%02x", r->data.send_els.ls_code);
+		zfcp_dbf_out(p, "d_id", "0x%06x", r->u.els.d_id);
+		zfcp_dbf_out(p, "ls_code", "0x%02x", r->u.els.ls_code);
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -428,11 +418,11 @@ static int zfcp_hba_dbf_view_format(debu
 		zfcp_dbf_tag(&p, "tag2", r->tag2);
 
 	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_response(&p, &r->type.response);
+		zfcp_hba_dbf_view_response(&p, &r->u.response);
 	else if (strncmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_status(&p, &r->type.status);
+		zfcp_hba_dbf_view_status(&p, &r->u.status);
 	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_hba_dbf_view_qdio(&p, &r->type.qdio);
+		zfcp_hba_dbf_view_qdio(&p, &r->u.qdio);
 
 	p += sprintf(p, "\n");
 	return p - out_buf;
@@ -823,57 +813,34 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
-static void
-_zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
-			      u32 s_id, u32 d_id, void *buffer, int buflen)
-{
-	struct zfcp_send_ct *send_ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_port *port = send_ct->port;
-	struct zfcp_adapter *adapter = port->adapter;
-	struct ct_hdr *header = (struct ct_hdr *)buffer;
-	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
-	struct zfcp_san_dbf_record_ct *ct = &rec->type.ct;
-	unsigned long flags;
-
-	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
-	memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
-	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
-	rec->fsf_reqid = (unsigned long)fsf_req;
-	rec->fsf_seqno = fsf_req->seq_no;
-	rec->s_id = s_id;
-	rec->d_id = d_id;
-	if (strncmp(tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
-		ct->type.request.cmd_req_code = header->cmd_rsp_code;
-		ct->type.request.revision = header->revision;
-		ct->type.request.gs_type = header->gs_type;
-		ct->type.request.gs_subtype = header->gs_subtype;
-		ct->type.request.options = header->options;
-		ct->type.request.max_res_size = header->max_res_size;
-	} else if (strncmp(tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
-		ct->type.response.cmd_rsp_code = header->cmd_rsp_code;
-		ct->type.response.revision = header->revision;
-		ct->type.response.reason_code = header->reason_code;
-		ct->type.response.reason_code_expl = header->reason_code_expl;
-		ct->type.response.vendor_unique = header->vendor_unique;
-	}
-	ct->payload_size =
-	    min(buflen - (int)sizeof(struct ct_hdr), ZFCP_DBF_CT_PAYLOAD);
-	memcpy(ct->payload, buffer + sizeof(struct ct_hdr), ct->payload_size);
-	debug_event(adapter->san_dbf, 3,
-		    rec, sizeof(struct zfcp_san_dbf_record));
-	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
-}
-
 void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
+	struct ct_hdr *hdr = zfcp_sg_to_address(ct->req);
+	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
+	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
+	unsigned long flags;
 
-	_zfcp_san_dbf_event_common_ct("octc", fsf_req,
-				      fc_host_port_id(adapter->scsi_host),
-				      port->d_id, zfcp_sg_to_address(ct->req),
-				      ct->req->length);
+	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
+	r->fsf_reqid = (unsigned long)fsf_req;
+	r->fsf_seqno = fsf_req->seq_no;
+	r->s_id = fc_host_port_id(adapter->scsi_host);
+	r->d_id = port->d_id;
+	oct->cmd_req_code = hdr->cmd_rsp_code;
+	oct->revision = hdr->revision;
+	oct->gs_type = hdr->gs_type;
+	oct->gs_subtype = hdr->gs_subtype;
+	oct->options = hdr->options;
+	oct->max_res_size = hdr->max_res_size;
+	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
+		       ZFCP_DBF_CT_PAYLOAD);
+	memcpy(oct->payload, (void *)hdr + sizeof(struct ct_hdr), oct->len);
+	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
 void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
@@ -881,11 +848,28 @@ void zfcp_san_dbf_event_ct_response(stru
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
+	struct ct_hdr *hdr = zfcp_sg_to_address(ct->resp);
+	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
+	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
+	unsigned long flags;
 
-	_zfcp_san_dbf_event_common_ct("rctc", fsf_req, port->d_id,
-				      fc_host_port_id(adapter->scsi_host),
-				      zfcp_sg_to_address(ct->resp),
-				      ct->resp->length);
+	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
+	r->fsf_reqid = (unsigned long)fsf_req;
+	r->fsf_seqno = fsf_req->seq_no;
+	r->s_id = port->d_id;
+	r->d_id = fc_host_port_id(adapter->scsi_host);
+	rct->cmd_rsp_code = hdr->cmd_rsp_code;
+	rct->revision = hdr->revision;
+	rct->reason_code = hdr->reason_code;
+	rct->expl = hdr->reason_code_expl;
+	rct->vendor_unique = hdr->vendor_unique;
+	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
+		       ZFCP_DBF_CT_PAYLOAD);
+	memcpy(rct->payload, (void *)hdr + sizeof(struct ct_hdr), rct->len);
+	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
 static void
@@ -898,13 +882,13 @@ _zfcp_san_dbf_event_common_els(const cha
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
-	memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
+	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 	rec->fsf_reqid = (unsigned long)fsf_req;
 	rec->fsf_seqno = fsf_req->seq_no;
 	rec->s_id = s_id;
 	rec->d_id = d_id;
-	rec->type.els.ls_code = ls_code;
+	rec->u.els.ls_code = ls_code;
 	debug_event(adapter->san_dbf, level, rec, sizeof(*rec));
 	zfcp_dbf_hexdump(adapter->san_dbf, rec, sizeof(*rec), level,
 			 buffer, min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD));
@@ -967,42 +951,33 @@ zfcp_san_dbf_view_format(debug_info_t * 
 	zfcp_dbf_out(&p, "d_id", "0x%06x", r->d_id);
 
 	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
-		/* FIXME: struct zfcp_dbf_ct_req *ct = ...; */
-		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x",
-			     r->type.ct.type.request.cmd_req_code);
-		zfcp_dbf_out(&p, "revision", "0x%02x",
-			     r->type.ct.type.request.revision);
-		zfcp_dbf_out(&p, "gs_type", "0x%02x",
-			     r->type.ct.type.request.gs_type);
-		zfcp_dbf_out(&p, "gs_subtype", "0x%02x",
-			     r->type.ct.type.request.gs_subtype);
-		zfcp_dbf_out(&p, "options", "0x%02x",
-			     r->type.ct.type.request.options);
-		zfcp_dbf_out(&p, "max_res_size", "0x%04x",
-			     r->type.ct.type.request.max_res_size);
-		total = r->type.ct.payload_size;
-		buffer = r->type.ct.payload;
+		struct zfcp_san_dbf_record_ct_request *ct = &r->u.ct_req;
+		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x", ct->cmd_req_code);
+		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
+		zfcp_dbf_out(&p, "gs_type", "0x%02x", ct->gs_type);
+		zfcp_dbf_out(&p, "gs_subtype", "0x%02x", ct->gs_subtype);
+		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
+		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
+		total = ct->len;
+		buffer = ct->payload;
 		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
-		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x",
-			     r->type.ct.type.response.cmd_rsp_code);
-		zfcp_dbf_out(&p, "revision", "0x%02x",
-			     r->type.ct.type.response.revision);
-		zfcp_dbf_out(&p, "reason_code", "0x%02x",
-			     r->type.ct.type.response.reason_code);
-		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x",
-			     r->type.ct.type.response.reason_code_expl);
-		zfcp_dbf_out(&p, "vendor_unique", "0x%02x",
-			     r->type.ct.type.response.vendor_unique);
-		total = r->type.ct.payload_size;
-		buffer = r->type.ct.payload;
+		struct zfcp_san_dbf_record_ct_response *ct = &r->u.ct_resp;
+		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
+		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
+		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
+		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
+		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
+		total = ct->len;
+		buffer = ct->payload;
 		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
-		zfcp_dbf_out(&p, "ls_code", "0x%02x", r->type.els.ls_code);
-		total = r->type.els.payload_size;
-		buffer = r->type.els.payload;
+		struct zfcp_san_dbf_record_els *els = &r->u.els;
+		zfcp_dbf_out(&p, "ls_code", "0x%02x", els->ls_code);
+		total = els->len;
+		buffer = els->payload;
 		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
 	}
 
@@ -1038,7 +1013,7 @@ _zfcp_scsi_dbf_event_common(const char *
 
 	spin_lock_irqsave(&adapter->scsi_dbf_lock, flags);
 	do {
-		memset(rec, 0, sizeof(struct zfcp_scsi_dbf_record));
+		memset(rec, 0, sizeof(*rec));
 		if (offset == 0) {
 			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 			strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
@@ -1064,20 +1039,16 @@ _zfcp_scsi_dbf_event_common(const char *
 				fcp_sns_info =
 				    zfcp_get_fcp_sns_info_ptr(fcp_rsp);
 
-				rec->type.fcp.rsp_validity =
-				    fcp_rsp->validity.value;
-				rec->type.fcp.rsp_scsi_status =
-				    fcp_rsp->scsi_status;
-				rec->type.fcp.rsp_resid = fcp_rsp->fcp_resid;
+				rec->rsp_validity = fcp_rsp->validity.value;
+				rec->rsp_scsi_status = fcp_rsp->scsi_status;
+				rec->rsp_resid = fcp_rsp->fcp_resid;
 				if (fcp_rsp->validity.bits.fcp_rsp_len_valid)
-					rec->type.fcp.rsp_code =
-					    *(fcp_rsp_info + 3);
+					rec->rsp_code = *(fcp_rsp_info + 3);
 				if (fcp_rsp->validity.bits.fcp_sns_len_valid) {
 					buflen = min((int)fcp_rsp->fcp_sns_len,
 						     ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO);
-					rec->type.fcp.sns_info_len = buflen;
-					memcpy(rec->type.fcp.sns_info,
-					       fcp_sns_info,
+					rec->sns_info_len = buflen;
+					memcpy(rec->sns_info, fcp_sns_info,
 					       min(buflen,
 						   ZFCP_DBF_SCSI_FCP_SNS_INFO));
 					offset += min(buflen,
@@ -1088,7 +1059,7 @@ _zfcp_scsi_dbf_event_common(const char *
 				rec->fsf_seqno = fsf_req->seq_no;
 				rec->fsf_issued = fsf_req->issued;
 			}
-			rec->type.old_fsf_reqid = old_req_id;
+			rec->old_fsf_reqid = old_req_id;
 		} else {
 			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
 			dump->total_size = buflen;
@@ -1100,8 +1071,7 @@ _zfcp_scsi_dbf_event_common(const char *
 			memcpy(dump->data, fcp_sns_info + offset, dump->size);
 			offset += dump->size;
 		}
-		debug_event(adapter->scsi_dbf, level,
-			    rec, sizeof(struct zfcp_scsi_dbf_record));
+		debug_event(adapter->scsi_dbf, level, rec, sizeof(*rec));
 	} while (offset < buflen);
 	spin_unlock_irqrestore(&adapter->scsi_dbf_lock, flags);
 }
@@ -1159,28 +1129,23 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
 	zfcp_dbf_out(&p, "scsi_allowed", "0x%02x", r->scsi_allowed);
 	if (strncmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx",
-			     r->type.old_fsf_reqid);
+		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx", r->old_fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
 	zfcp_dbf_timestamp(r->fsf_issued, &t);
 	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
 
 	if (strncmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
-		zfcp_dbf_out(&p, "fcp_rsp_validity", "0x%02x",
-			     r->type.fcp.rsp_validity);
-		zfcp_dbf_out(&p, "fcp_rsp_scsi_status",
-			     "0x%02x", r->type.fcp.rsp_scsi_status);
-		zfcp_dbf_out(&p, "fcp_rsp_resid", "0x%08x",
-			     r->type.fcp.rsp_resid);
-		zfcp_dbf_out(&p, "fcp_rsp_code", "0x%08x",
-			     r->type.fcp.rsp_code);
-		zfcp_dbf_out(&p, "fcp_sns_info_len", "0x%08x",
-			     r->type.fcp.sns_info_len);
-		zfcp_dbf_outd(&p, "fcp_sns_info", r->type.fcp.sns_info,
-			      min((int)r->type.fcp.sns_info_len,
+		zfcp_dbf_out(&p, "fcp_rsp_validity", "0x%02x", r->rsp_validity);
+		zfcp_dbf_out(&p, "fcp_rsp_scsi_status", "0x%02x",
+			     r->rsp_scsi_status);
+		zfcp_dbf_out(&p, "fcp_rsp_resid", "0x%08x", r->rsp_resid);
+		zfcp_dbf_out(&p, "fcp_rsp_code", "0x%08x", r->rsp_code);
+		zfcp_dbf_out(&p, "fcp_sns_info_len", "0x%08x", r->sns_info_len);
+		zfcp_dbf_outd(&p, "fcp_sns_info", r->sns_info,
+			      min((int)r->sns_info_len,
 			      ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
-			      r->type.fcp.sns_info_len);
+			      r->sns_info_len);
 	}
 	p += sprintf(p, "\n");
 	return p - out_buf;
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-03-31 10:26:10.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-03-31 10:26:37.000000000 +0200
@@ -104,9 +104,9 @@ struct zfcp_hba_dbf_record_response {
 	u64 erp_action;
 	union {
 		struct {
-			u64 scsi_cmnd;
-			u64 scsi_serial;
-		} send_fcp;
+			u64 cmnd;
+			u64 serial;
+		} fcp;
 		struct {
 			u64 wwpn;
 			u32 d_id;
@@ -121,8 +121,8 @@ struct zfcp_hba_dbf_record_response {
 		struct {
 			u32 d_id;
 			u8 ls_code;
-		} send_els;
-	} data;
+		} els;
+	} u;
 } __attribute__ ((packed));
 
 struct zfcp_hba_dbf_record_status {
@@ -154,35 +154,34 @@ struct zfcp_hba_dbf_record {
 		struct zfcp_hba_dbf_record_response response;
 		struct zfcp_hba_dbf_record_status status;
 		struct zfcp_hba_dbf_record_qdio qdio;
-	} type;
+	} u;
 } __attribute__ ((packed));
 
-struct zfcp_san_dbf_record_ct {
-	union {
-		struct {
-			u16 cmd_req_code;
-			u8 revision;
-			u8 gs_type;
-			u8 gs_subtype;
-			u8 options;
-			u16 max_res_size;
-		} request;
-		struct {
-			u16 cmd_rsp_code;
-			u8 revision;
-			u8 reason_code;
-			u8 reason_code_expl;
-			u8 vendor_unique;
-		} response;
-	} type;
-	u32 payload_size;
+struct zfcp_san_dbf_record_ct_request {
+	u16 cmd_req_code;
+	u8 revision;
+	u8 gs_type;
+	u8 gs_subtype;
+	u8 options;
+	u16 max_res_size;
+	u32 len;
 #define ZFCP_DBF_CT_PAYLOAD	24
 	u8 payload[ZFCP_DBF_CT_PAYLOAD];
 } __attribute__ ((packed));
 
+struct zfcp_san_dbf_record_ct_response {
+	u16 cmd_rsp_code;
+	u8 revision;
+	u8 reason_code;
+	u8 expl;
+	u8 vendor_unique;
+	u32 len;
+	u8 payload[ZFCP_DBF_CT_PAYLOAD];
+} __attribute__ ((packed));
+
 struct zfcp_san_dbf_record_els {
 	u8 ls_code;
-	u32 payload_size;
+	u32 len;
 #define ZFCP_DBF_ELS_PAYLOAD	32
 #define ZFCP_DBF_ELS_MAX_PAYLOAD 1024
 	u8 payload[ZFCP_DBF_ELS_PAYLOAD];
@@ -195,9 +194,10 @@ struct zfcp_san_dbf_record {
 	u32 s_id;
 	u32 d_id;
 	union {
-		struct zfcp_san_dbf_record_ct ct;
+		struct zfcp_san_dbf_record_ct_request ct_req;
+		struct zfcp_san_dbf_record_ct_response ct_resp;
 		struct zfcp_san_dbf_record_els els;
-	} type;
+	} u;
 } __attribute__ ((packed));
 
 struct zfcp_scsi_dbf_record {
@@ -215,19 +215,15 @@ struct zfcp_scsi_dbf_record {
 	u64 fsf_reqid;
 	u32 fsf_seqno;
 	u64 fsf_issued;
-	union {
-		u64 old_fsf_reqid;
-		struct {
-			u8 rsp_validity;
-			u8 rsp_scsi_status;
-			u32 rsp_resid;
-			u8 rsp_code;
+	u64 old_fsf_reqid;
+	u8 rsp_validity;
+	u8 rsp_scsi_status;
+	u32 rsp_resid;
+	u8 rsp_code;
 #define ZFCP_DBF_SCSI_FCP_SNS_INFO	16
 #define ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO	256
-			u32 sns_info_len;
-			u8 sns_info[ZFCP_DBF_SCSI_FCP_SNS_INFO];
-		} fcp;
-	} type;
+	u32 sns_info_len;
+	u8 sns_info[ZFCP_DBF_SCSI_FCP_SNS_INFO];
 } __attribute__ ((packed));
 
 #endif /* ZFCP_DBF_H */

-- 
