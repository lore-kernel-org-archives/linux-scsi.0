From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/9] zfcp: Cleanup debug trace view functions.
Date: Mon, 31 Mar 2008 11:15:24 +0200
Message-ID: <20080331091830.423413000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60961 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYCaJSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:33 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_view.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Improve readability of code by using more convenient output function.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  380 ++++++++++++++++++-------------------------
 1 file changed, 161 insertions(+), 219 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:24:47.000000000 +0200
@@ -139,25 +139,21 @@ zfcp_dbf_view_header(debug_info_t * id, 
 		     debug_entry_t * entry, char *out_buf)
 {
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)DEBUG_DATA(entry);
-	int len = 0;
 	struct timespec t;
+	char *p = out_buf;
 
 	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
 		zfcp_dbf_timestamp(entry->id.stck, &t);
-		len += zfcp_dbf_view(out_buf + len, "timestamp", "%011lu:%06lu",
-				     t.tv_sec, t.tv_nsec);
-		len += zfcp_dbf_view(out_buf + len, "cpu", "%02i",
-				     entry->id.fields.cpuid);
-	} else {
-		len += zfcp_dbf_view_dump(out_buf + len, NULL,
-					  dump->data,
-					  dump->size,
-					  dump->offset, dump->total_size);
+		zfcp_dbf_out(&p, "timestamp", "%011lu:%06lu",
+			     t.tv_sec, t.tv_nsec);
+		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
+	} else	{
+		p += zfcp_dbf_view_dump(p, NULL, dump->data, dump->size,
+					dump->offset, dump->total_size);
 		if ((dump->offset + dump->size) == dump->total_size)
-			len += sprintf(out_buf + len, "\n");
+			p += sprintf(p, "\n");
 	}
-
-	return len;
+	return p - out_buf;
 }
 
 void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *fsf_req)
@@ -354,82 +350,65 @@ zfcp_hba_dbf_event_qdio(struct zfcp_adap
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
-static int
-zfcp_hba_dbf_view_response(char *out_buf,
-			   struct zfcp_hba_dbf_record_response *rec)
+static int zfcp_hba_dbf_view_response(char *buf,
+				      struct zfcp_hba_dbf_record_response *r)
 {
-	int len = 0;
 	struct timespec t;
+	char *p = buf;
 
-	len += zfcp_dbf_view(out_buf + len, "fsf_command", "0x%08x",
-			     rec->fsf_command);
-	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
-			     rec->fsf_reqid);
-	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
-			     rec->fsf_seqno);
-	zfcp_dbf_timestamp(rec->fsf_issued, &t);
-	len += zfcp_dbf_view(out_buf + len, "fsf_issued", "%011lu:%06lu",
-			     t.tv_sec, t.tv_nsec);
-	len += zfcp_dbf_view(out_buf + len, "fsf_prot_status", "0x%08x",
-			     rec->fsf_prot_status);
-	len += zfcp_dbf_view(out_buf + len, "fsf_status", "0x%08x",
-			     rec->fsf_status);
-	len += zfcp_dbf_view_dump(out_buf + len, "fsf_prot_status_qual",
-				  rec->fsf_prot_status_qual,
-				  FSF_PROT_STATUS_QUAL_SIZE,
-				  0, FSF_PROT_STATUS_QUAL_SIZE);
-	len += zfcp_dbf_view_dump(out_buf + len, "fsf_status_qual",
-				  rec->fsf_status_qual,
-				  FSF_STATUS_QUALIFIER_SIZE,
-				  0, FSF_STATUS_QUALIFIER_SIZE);
-	len += zfcp_dbf_view(out_buf + len, "fsf_req_status", "0x%08x",
-			     rec->fsf_req_status);
-	len += zfcp_dbf_view(out_buf + len, "sbal_first", "0x%02x",
-			     rec->sbal_first);
-	len += zfcp_dbf_view(out_buf + len, "sbal_curr", "0x%02x",
-			     rec->sbal_curr);
-	len += zfcp_dbf_view(out_buf + len, "sbal_last", "0x%02x",
-			     rec->sbal_last);
-	len += zfcp_dbf_view(out_buf + len, "pool", "0x%02x", rec->pool);
+	zfcp_dbf_out(&p, "fsf_command", "0x%08x", r->fsf_command);
+	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
+	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
+	zfcp_dbf_timestamp(r->fsf_issued, &t);
+	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
+	zfcp_dbf_out(&p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
+	zfcp_dbf_out(&p, "fsf_status", "0x%08x", r->fsf_status);
+	p += zfcp_dbf_view_dump(p, "fsf_prot_status_qual",
+				r->fsf_prot_status_qual,
+				FSF_PROT_STATUS_QUAL_SIZE,
+				0, FSF_PROT_STATUS_QUAL_SIZE);
+	p += zfcp_dbf_view_dump(p, "fsf_status_qual",
+				r->fsf_status_qual,
+				FSF_STATUS_QUALIFIER_SIZE,
+				0, FSF_STATUS_QUALIFIER_SIZE);
+	zfcp_dbf_out(&p, "fsf_req_status", "0x%08x", r->fsf_req_status);
+	zfcp_dbf_out(&p, "sbal_first", "0x%02x", r->sbal_first);
+	zfcp_dbf_out(&p, "sbal_curr", "0x%02x", r->sbal_curr);
+	zfcp_dbf_out(&p, "sbal_last", "0x%02x", r->sbal_last);
+	zfcp_dbf_out(&p, "pool", "0x%02x", r->pool);
 
-	switch (rec->fsf_command) {
+	switch (r->fsf_command) {
 	case FSF_QTCB_FCP_CMND:
-		if (rec->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
+		if (r->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
 			break;
-		len += zfcp_dbf_view(out_buf + len, "scsi_cmnd", "0x%0Lx",
-				     rec->data.send_fcp.scsi_cmnd);
-		len += zfcp_dbf_view(out_buf + len, "scsi_serial", "0x%016Lx",
-				     rec->data.send_fcp.scsi_serial);
+		zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx",
+			     r->data.send_fcp.scsi_cmnd);
+		zfcp_dbf_out(&p, "scsi_serial", "0x%016Lx",
+			     r->data.send_fcp.scsi_serial);
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
 	case FSF_QTCB_CLOSE_PORT:
 	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		len += zfcp_dbf_view(out_buf + len, "wwpn", "0x%016Lx",
-				     rec->data.port.wwpn);
-		len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x",
-				     rec->data.port.d_id);
-		len += zfcp_dbf_view(out_buf + len, "port_handle", "0x%08x",
-				     rec->data.port.port_handle);
+		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->data.port.wwpn);
+		zfcp_dbf_out(&p, "d_id", "0x%06x", r->data.port.d_id);
+		zfcp_dbf_out(&p, "port_handle", "0x%08x",
+			     r->data.port.port_handle);
 		break;
 
 	case FSF_QTCB_OPEN_LUN:
 	case FSF_QTCB_CLOSE_LUN:
-		len += zfcp_dbf_view(out_buf + len, "wwpn", "0x%016Lx",
-				     rec->data.unit.wwpn);
-		len += zfcp_dbf_view(out_buf + len, "fcp_lun", "0x%016Lx",
-				     rec->data.unit.fcp_lun);
-		len += zfcp_dbf_view(out_buf + len, "port_handle", "0x%08x",
-				     rec->data.unit.port_handle);
-		len += zfcp_dbf_view(out_buf + len, "lun_handle", "0x%08x",
-				     rec->data.unit.lun_handle);
+		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->data.unit.wwpn);
+		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->data.unit.fcp_lun);
+		zfcp_dbf_out(&p, "port_handle", "0x%08x",
+			     r->data.unit.port_handle);
+		zfcp_dbf_out(&p, "lun_handle", "0x%08x",
+			     r->data.unit.lun_handle);
 		break;
 
 	case FSF_QTCB_SEND_ELS:
-		len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x",
-				     rec->data.send_els.d_id);
-		len += zfcp_dbf_view(out_buf + len, "ls_code", "0x%02x",
-				     rec->data.send_els.ls_code);
+		zfcp_dbf_out(&p, "d_id", "0x%06x", r->data.send_els.d_id);
+		zfcp_dbf_out(&p, "ls_code", "0x%02x", r->data.send_els.ls_code);
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -440,47 +419,36 @@ zfcp_hba_dbf_view_response(char *out_buf
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
 		break;
 	}
-
-	return len;
+	return p - buf;
 }
 
-static int
-zfcp_hba_dbf_view_status(char *out_buf, struct zfcp_hba_dbf_record_status *rec)
+static int zfcp_hba_dbf_view_status(char *buf,
+				    struct zfcp_hba_dbf_record_status *r)
 {
-	int len = 0;
-
-	len += zfcp_dbf_view(out_buf + len, "failed", "0x%02x", rec->failed);
-	len += zfcp_dbf_view(out_buf + len, "status_type", "0x%08x",
-			     rec->status_type);
-	len += zfcp_dbf_view(out_buf + len, "status_subtype", "0x%08x",
-			     rec->status_subtype);
-	len += zfcp_dbf_view_dump(out_buf + len, "queue_designator",
-				  (char *)&rec->queue_designator,
-				  sizeof(struct fsf_queue_designator),
-				  0, sizeof(struct fsf_queue_designator));
-	len += zfcp_dbf_view_dump(out_buf + len, "payload",
-				  (char *)&rec->payload,
-				  rec->payload_size, 0, rec->payload_size);
+	char *p = buf;
 
-	return len;
+	zfcp_dbf_out(&p, "failed", "0x%02x", r->failed);
+	zfcp_dbf_out(&p, "status_type", "0x%08x", r->status_type);
+	zfcp_dbf_out(&p, "status_subtype", "0x%08x", r->status_subtype);
+	p += zfcp_dbf_view_dump(p, "queue_designator",
+				(char *)&r->queue_designator,
+				sizeof(struct fsf_queue_designator),
+				0, sizeof(struct fsf_queue_designator));
+	p += zfcp_dbf_view_dump(p, "payload", (char *)&r->payload,
+				r->payload_size, 0, r->payload_size);
+	return p - buf;
 }
 
-static int
-zfcp_hba_dbf_view_qdio(char *out_buf, struct zfcp_hba_dbf_record_qdio *rec)
+static int zfcp_hba_dbf_view_qdio(char *buf, struct zfcp_hba_dbf_record_qdio *r)
 {
-	int len = 0;
-
-	len += zfcp_dbf_view(out_buf + len, "status", "0x%08x", rec->status);
-	len += zfcp_dbf_view(out_buf + len, "qdio_error", "0x%08x",
-			     rec->qdio_error);
-	len += zfcp_dbf_view(out_buf + len, "siga_error", "0x%08x",
-			     rec->siga_error);
-	len += zfcp_dbf_view(out_buf + len, "sbal_index", "0x%02x",
-			     rec->sbal_index);
-	len += zfcp_dbf_view(out_buf + len, "sbal_count", "0x%02x",
-			     rec->sbal_count);
+	char *p = buf;
 
-	return len;
+	zfcp_dbf_out(&p, "status", "0x%08x", r->status);
+	zfcp_dbf_out(&p, "qdio_error", "0x%08x", r->qdio_error);
+	zfcp_dbf_out(&p, "siga_error", "0x%08x", r->siga_error);
+	zfcp_dbf_out(&p, "sbal_index", "0x%02x", r->sbal_index);
+	zfcp_dbf_out(&p, "sbal_count", "0x%02x", r->sbal_count);
+	return p - buf;
 }
 
 static int
@@ -720,8 +688,8 @@ static int zfcp_rec_dbf_view_format(debu
 		zfcp_dbf_out(&p, "step", "0x%08Lx", r->u.action.step);
 		break;
 	}
-	sprintf(p, "\n");
-	return (p - buf) + 1;
+	p += sprintf(p, "\n");
+	return p - buf;
 }
 
 static struct debug_view zfcp_rec_dbf_view = {
@@ -1024,71 +992,65 @@ static int
 zfcp_san_dbf_view_format(debug_info_t * id, struct debug_view *view,
 			 char *out_buf, const char *in_buf)
 {
-	struct zfcp_san_dbf_record *rec = (struct zfcp_san_dbf_record *)in_buf;
+	struct zfcp_san_dbf_record *r = (struct zfcp_san_dbf_record *)in_buf;
 	char *buffer = NULL;
 	int buflen = 0, total = 0;
-	int len = 0;
+	char *p = out_buf;
 
-	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
-	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
-	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
-			     rec->fsf_reqid);
-	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
-			     rec->fsf_seqno);
-	len += zfcp_dbf_view(out_buf + len, "s_id", "0x%06x", rec->s_id);
-	len += zfcp_dbf_view(out_buf + len, "d_id", "0x%06x", rec->d_id);
-
-	if (strncmp(rec->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
-		len += zfcp_dbf_view(out_buf + len, "cmd_req_code", "0x%04x",
-				     rec->type.ct.type.request.cmd_req_code);
-		len += zfcp_dbf_view(out_buf + len, "revision", "0x%02x",
-				     rec->type.ct.type.request.revision);
-		len += zfcp_dbf_view(out_buf + len, "gs_type", "0x%02x",
-				     rec->type.ct.type.request.gs_type);
-		len += zfcp_dbf_view(out_buf + len, "gs_subtype", "0x%02x",
-				     rec->type.ct.type.request.gs_subtype);
-		len += zfcp_dbf_view(out_buf + len, "options", "0x%02x",
-				     rec->type.ct.type.request.options);
-		len += zfcp_dbf_view(out_buf + len, "max_res_size", "0x%04x",
-				     rec->type.ct.type.request.max_res_size);
-		total = rec->type.ct.payload_size;
-		buffer = rec->type.ct.payload;
+	p += zfcp_dbf_tag(p, "tag", r->tag);
+	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
+	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
+	zfcp_dbf_out(&p, "s_id", "0x%06x", r->s_id);
+	zfcp_dbf_out(&p, "d_id", "0x%06x", r->d_id);
+
+	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
+		/* FIXME: struct zfcp_dbf_ct_req *ct = ...; */
+		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x",
+			     r->type.ct.type.request.cmd_req_code);
+		zfcp_dbf_out(&p, "revision", "0x%02x",
+			     r->type.ct.type.request.revision);
+		zfcp_dbf_out(&p, "gs_type", "0x%02x",
+			     r->type.ct.type.request.gs_type);
+		zfcp_dbf_out(&p, "gs_subtype", "0x%02x",
+			     r->type.ct.type.request.gs_subtype);
+		zfcp_dbf_out(&p, "options", "0x%02x",
+			     r->type.ct.type.request.options);
+		zfcp_dbf_out(&p, "max_res_size", "0x%04x",
+			     r->type.ct.type.request.max_res_size);
+		total = r->type.ct.payload_size;
+		buffer = r->type.ct.payload;
 		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
-	} else if (strncmp(rec->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
-		len += zfcp_dbf_view(out_buf + len, "cmd_rsp_code", "0x%04x",
-				     rec->type.ct.type.response.cmd_rsp_code);
-		len += zfcp_dbf_view(out_buf + len, "revision", "0x%02x",
-				     rec->type.ct.type.response.revision);
-		len += zfcp_dbf_view(out_buf + len, "reason_code", "0x%02x",
-				     rec->type.ct.type.response.reason_code);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "reason_code_expl", "0x%02x",
-				  rec->type.ct.type.response.reason_code_expl);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "vendor_unique", "0x%02x",
-				  rec->type.ct.type.response.vendor_unique);
-		total = rec->type.ct.payload_size;
-		buffer = rec->type.ct.payload;
+	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
+		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x",
+			     r->type.ct.type.response.cmd_rsp_code);
+		zfcp_dbf_out(&p, "revision", "0x%02x",
+			     r->type.ct.type.response.revision);
+		zfcp_dbf_out(&p, "reason_code", "0x%02x",
+			     r->type.ct.type.response.reason_code);
+		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x",
+			     r->type.ct.type.response.reason_code_expl);
+		zfcp_dbf_out(&p, "vendor_unique", "0x%02x",
+			     r->type.ct.type.response.vendor_unique);
+		total = r->type.ct.payload_size;
+		buffer = r->type.ct.payload;
 		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
-	} else if (strncmp(rec->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(rec->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(rec->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
-		len += zfcp_dbf_view(out_buf + len, "ls_code", "0x%02x",
-				     rec->type.els.ls_code);
-		total = rec->type.els.payload_size;
-		buffer = rec->type.els.payload;
+	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
+		zfcp_dbf_out(&p, "ls_code", "0x%02x", r->type.els.ls_code);
+		total = r->type.els.payload_size;
+		buffer = r->type.els.payload;
 		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
 	}
 
-	len += zfcp_dbf_view_dump(out_buf + len, "payload",
-				  buffer, buflen, 0, total);
-
+	p += zfcp_dbf_view_dump(p, "payload", buffer, buflen, 0, total);
 	if (buflen == total)
-		len += sprintf(out_buf + len, "\n");
+		p += sprintf(p, "\n");
 
-	return len;
+	return p - out_buf;
 }
 
 static struct debug_view zfcp_san_dbf_view = {
@@ -1218,71 +1180,51 @@ static int
 zfcp_scsi_dbf_view_format(debug_info_t * id, struct debug_view *view,
 			  char *out_buf, const char *in_buf)
 {
-	struct zfcp_scsi_dbf_record *rec =
-	    (struct zfcp_scsi_dbf_record *)in_buf;
-	int len = 0;
+	struct zfcp_scsi_dbf_record *r = (struct zfcp_scsi_dbf_record *)in_buf;
 	struct timespec t;
+	char *p = out_buf;
 
-	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
-	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
-	len += zfcp_dbf_tag(out_buf + len, "tag2", rec->tag2);
-	len += zfcp_dbf_view(out_buf + len, "scsi_id", "0x%08x", rec->scsi_id);
-	len += zfcp_dbf_view(out_buf + len, "scsi_lun", "0x%08x",
-			     rec->scsi_lun);
-	len += zfcp_dbf_view(out_buf + len, "scsi_result", "0x%08x",
-			     rec->scsi_result);
-	len += zfcp_dbf_view(out_buf + len, "scsi_cmnd", "0x%0Lx",
-			     rec->scsi_cmnd);
-	len += zfcp_dbf_view(out_buf + len, "scsi_serial", "0x%016Lx",
-			     rec->scsi_serial);
-	len += zfcp_dbf_view_dump(out_buf + len, "scsi_opcode",
-				  rec->scsi_opcode,
-				  ZFCP_DBF_SCSI_OPCODE,
-				  0, ZFCP_DBF_SCSI_OPCODE);
-	len += zfcp_dbf_view(out_buf + len, "scsi_retries", "0x%02x",
-			     rec->scsi_retries);
-	len += zfcp_dbf_view(out_buf + len, "scsi_allowed", "0x%02x",
-			     rec->scsi_allowed);
-	if (strncmp(rec->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0) {
-		len += zfcp_dbf_view(out_buf + len, "old_fsf_reqid", "0x%0Lx",
-				     rec->type.old_fsf_reqid);
-	}
-	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
-			     rec->fsf_reqid);
-	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
-			     rec->fsf_seqno);
-	zfcp_dbf_timestamp(rec->fsf_issued, &t);
-	len += zfcp_dbf_view(out_buf + len, "fsf_issued", "%011lu:%06lu",
-			     t.tv_sec, t.tv_nsec);
-	if (strncmp(rec->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
-		len +=
-		    zfcp_dbf_view(out_buf + len, "fcp_rsp_validity", "0x%02x",
-				  rec->type.fcp.rsp_validity);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "fcp_rsp_scsi_status",
-				  "0x%02x", rec->type.fcp.rsp_scsi_status);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "fcp_rsp_resid", "0x%08x",
-				  rec->type.fcp.rsp_resid);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "fcp_rsp_code", "0x%08x",
-				  rec->type.fcp.rsp_code);
-		len +=
-		    zfcp_dbf_view(out_buf + len, "fcp_sns_info_len", "0x%08x",
-				  rec->type.fcp.sns_info_len);
-		len +=
-		    zfcp_dbf_view_dump(out_buf + len, "fcp_sns_info",
-				       rec->type.fcp.sns_info,
-				       min((int)rec->type.fcp.sns_info_len,
-					   ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
-				       rec->type.fcp.sns_info_len);
+	p += zfcp_dbf_tag(p, "tag", r->tag);
+	p += zfcp_dbf_tag(p, "tag2", r->tag2);
+	zfcp_dbf_out(&p, "scsi_id", "0x%08x", r->scsi_id);
+	zfcp_dbf_out(&p, "scsi_lun", "0x%08x", r->scsi_lun);
+	zfcp_dbf_out(&p, "scsi_result", "0x%08x", r->scsi_result);
+	zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx", r->scsi_cmnd);
+	zfcp_dbf_out(&p, "scsi_serial", "0x%016Lx", r->scsi_serial);
+	p += zfcp_dbf_view_dump(p, "scsi_opcode", r->scsi_opcode,
+				ZFCP_DBF_SCSI_OPCODE, 0, ZFCP_DBF_SCSI_OPCODE);
+	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
+	zfcp_dbf_out(&p, "scsi_allowed", "0x%02x", r->scsi_allowed);
+	if (strncmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
+		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx",
+			     r->type.old_fsf_reqid);
+	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
+	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
+	zfcp_dbf_timestamp(r->fsf_issued, &t);
+	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
+
+	if (strncmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
+		zfcp_dbf_out(&p, "fcp_rsp_validity", "0x%02x",
+			     r->type.fcp.rsp_validity);
+		zfcp_dbf_out(&p, "fcp_rsp_scsi_status",
+			     "0x%02x", r->type.fcp.rsp_scsi_status);
+		zfcp_dbf_out(&p, "fcp_rsp_resid", "0x%08x",
+			     r->type.fcp.rsp_resid);
+		zfcp_dbf_out(&p, "fcp_rsp_code", "0x%08x",
+			     r->type.fcp.rsp_code);
+		zfcp_dbf_out(&p, "fcp_sns_info_len", "0x%08x",
+			     r->type.fcp.sns_info_len);
+		p += zfcp_dbf_view_dump(p, "fcp_sns_info",
+					r->type.fcp.sns_info,
+					min((int)r->type.fcp.sns_info_len,
+					ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
+					r->type.fcp.sns_info_len);
 	}
-
-	len += sprintf(out_buf + len, "\n");
-
-	return len;
+	p += sprintf(p, "\n");
+	return p - out_buf;
 }
 
 static struct debug_view zfcp_scsi_dbf_view = {

-- 
