From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/9] zfcp: Simplify zfcp_dbf_tag and related functions in debug trace.
Date: Mon, 31 Mar 2008 11:15:27 +0200
Message-ID: <20080331091833.255373000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:48201 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYCaJSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:36 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_returns.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Simplify usage of zfcp_dbf_tag() and calling functions.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  141 +++++++++++++++++++------------------------
 1 file changed, 64 insertions(+), 77 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:25:13.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:26:00.000000000 +0200
@@ -62,16 +62,14 @@ static void zfcp_dbf_timestamp(unsigned 
 	time->tv_nsec = ((stck * 1000) >> 12);
 }
 
-static int zfcp_dbf_tag(char *out_buf, const char *label, const char *tag)
+static void zfcp_dbf_tag(char **p, const char *label, const char *tag)
 {
-	int len = 0, i;
+	int i;
 
-	len += sprintf(out_buf + len, "%-24s", label);
+	*p += sprintf(*p, "%-24s", label);
 	for (i = 0; i < ZFCP_DBF_TAG_SIZE; i++)
-		len += sprintf(out_buf + len, "%c", tag[i]);
-	len += sprintf(out_buf + len, "\n");
-
-	return len;
+		*p += sprintf(*p, "%c", tag[i]);
+	*p += sprintf(*p, "\n");
 }
 
 static void zfcp_dbf_outs(char **buf, const char *s1, const char *s2)
@@ -328,61 +326,60 @@ zfcp_hba_dbf_event_qdio(struct zfcp_adap
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
-static int zfcp_hba_dbf_view_response(char *buf,
-				      struct zfcp_hba_dbf_record_response *r)
+static void zfcp_hba_dbf_view_response(char **p,
+				       struct zfcp_hba_dbf_record_response *r)
 {
 	struct timespec t;
-	char *p = buf;
 
-	zfcp_dbf_out(&p, "fsf_command", "0x%08x", r->fsf_command);
-	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
-	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
+	zfcp_dbf_out(p, "fsf_command", "0x%08x", r->fsf_command);
+	zfcp_dbf_out(p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
+	zfcp_dbf_out(p, "fsf_seqno", "0x%08x", r->fsf_seqno);
 	zfcp_dbf_timestamp(r->fsf_issued, &t);
-	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
-	zfcp_dbf_out(&p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
-	zfcp_dbf_out(&p, "fsf_status", "0x%08x", r->fsf_status);
-	zfcp_dbf_outd(&p, "fsf_prot_status_qual", r->fsf_prot_status_qual,
+	zfcp_dbf_out(p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
+	zfcp_dbf_out(p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
+	zfcp_dbf_out(p, "fsf_status", "0x%08x", r->fsf_status);
+	zfcp_dbf_outd(p, "fsf_prot_status_qual", r->fsf_prot_status_qual,
 		      FSF_PROT_STATUS_QUAL_SIZE, 0, FSF_PROT_STATUS_QUAL_SIZE);
-	zfcp_dbf_outd(&p, "fsf_status_qual", r->fsf_status_qual,
+	zfcp_dbf_outd(p, "fsf_status_qual", r->fsf_status_qual,
 		      FSF_STATUS_QUALIFIER_SIZE, 0, FSF_STATUS_QUALIFIER_SIZE);
-	zfcp_dbf_out(&p, "fsf_req_status", "0x%08x", r->fsf_req_status);
-	zfcp_dbf_out(&p, "sbal_first", "0x%02x", r->sbal_first);
-	zfcp_dbf_out(&p, "sbal_curr", "0x%02x", r->sbal_curr);
-	zfcp_dbf_out(&p, "sbal_last", "0x%02x", r->sbal_last);
-	zfcp_dbf_out(&p, "pool", "0x%02x", r->pool);
+	zfcp_dbf_out(p, "fsf_req_status", "0x%08x", r->fsf_req_status);
+	zfcp_dbf_out(p, "sbal_first", "0x%02x", r->sbal_first);
+	zfcp_dbf_out(p, "sbal_curr", "0x%02x", r->sbal_curr);
+	zfcp_dbf_out(p, "sbal_last", "0x%02x", r->sbal_last);
+	zfcp_dbf_out(p, "pool", "0x%02x", r->pool);
 
 	switch (r->fsf_command) {
 	case FSF_QTCB_FCP_CMND:
 		if (r->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
 			break;
-		zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx",
+		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx",
 			     r->data.send_fcp.scsi_cmnd);
-		zfcp_dbf_out(&p, "scsi_serial", "0x%016Lx",
+		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx",
 			     r->data.send_fcp.scsi_serial);
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
 	case FSF_QTCB_CLOSE_PORT:
 	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->data.port.wwpn);
-		zfcp_dbf_out(&p, "d_id", "0x%06x", r->data.port.d_id);
-		zfcp_dbf_out(&p, "port_handle", "0x%08x",
+		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->data.port.wwpn);
+		zfcp_dbf_out(p, "d_id", "0x%06x", r->data.port.d_id);
+		zfcp_dbf_out(p, "port_handle", "0x%08x",
 			     r->data.port.port_handle);
 		break;
 
 	case FSF_QTCB_OPEN_LUN:
 	case FSF_QTCB_CLOSE_LUN:
-		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->data.unit.wwpn);
-		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->data.unit.fcp_lun);
-		zfcp_dbf_out(&p, "port_handle", "0x%08x",
+		zfcp_dbf_out(p, "wwpn", "0x%016Lx", r->data.unit.wwpn);
+		zfcp_dbf_out(p, "fcp_lun", "0x%016Lx", r->data.unit.fcp_lun);
+		zfcp_dbf_out(p, "port_handle", "0x%08x",
 			     r->data.unit.port_handle);
-		zfcp_dbf_out(&p, "lun_handle", "0x%08x",
+		zfcp_dbf_out(p, "lun_handle", "0x%08x",
 			     r->data.unit.lun_handle);
 		break;
 
 	case FSF_QTCB_SEND_ELS:
-		zfcp_dbf_out(&p, "d_id", "0x%06x", r->data.send_els.d_id);
-		zfcp_dbf_out(&p, "ls_code", "0x%02x", r->data.send_els.ls_code);
+		zfcp_dbf_out(p, "d_id", "0x%06x", r->data.send_els.d_id);
+		zfcp_dbf_out(p, "ls_code", "0x%02x", r->data.send_els.ls_code);
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -393,62 +390,52 @@ static int zfcp_hba_dbf_view_response(ch
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
 		break;
 	}
-	return p - buf;
 }
 
-static int zfcp_hba_dbf_view_status(char *buf,
-				    struct zfcp_hba_dbf_record_status *r)
+static void zfcp_hba_dbf_view_status(char **p,
+				     struct zfcp_hba_dbf_record_status *r)
 {
-	char *p = buf;
-
-	zfcp_dbf_out(&p, "failed", "0x%02x", r->failed);
-	zfcp_dbf_out(&p, "status_type", "0x%08x", r->status_type);
-	zfcp_dbf_out(&p, "status_subtype", "0x%08x", r->status_subtype);
-	zfcp_dbf_outd(&p, "queue_designator", (char *)&r->queue_designator,
+	zfcp_dbf_out(p, "failed", "0x%02x", r->failed);
+	zfcp_dbf_out(p, "status_type", "0x%08x", r->status_type);
+	zfcp_dbf_out(p, "status_subtype", "0x%08x", r->status_subtype);
+	zfcp_dbf_outd(p, "queue_designator", (char *)&r->queue_designator,
 		      sizeof(struct fsf_queue_designator), 0,
 		      sizeof(struct fsf_queue_designator));
-	zfcp_dbf_outd(&p, "payload", (char *)&r->payload, r->payload_size, 0,
+	zfcp_dbf_outd(p, "payload", (char *)&r->payload, r->payload_size, 0,
 		      r->payload_size);
-	return p - buf;
 }
 
-static int zfcp_hba_dbf_view_qdio(char *buf, struct zfcp_hba_dbf_record_qdio *r)
+static void zfcp_hba_dbf_view_qdio(char **p, struct zfcp_hba_dbf_record_qdio *r)
 {
-	char *p = buf;
-
-	zfcp_dbf_out(&p, "status", "0x%08x", r->status);
-	zfcp_dbf_out(&p, "qdio_error", "0x%08x", r->qdio_error);
-	zfcp_dbf_out(&p, "siga_error", "0x%08x", r->siga_error);
-	zfcp_dbf_out(&p, "sbal_index", "0x%02x", r->sbal_index);
-	zfcp_dbf_out(&p, "sbal_count", "0x%02x", r->sbal_count);
-	return p - buf;
+	zfcp_dbf_out(p, "status", "0x%08x", r->status);
+	zfcp_dbf_out(p, "qdio_error", "0x%08x", r->qdio_error);
+	zfcp_dbf_out(p, "siga_error", "0x%08x", r->siga_error);
+	zfcp_dbf_out(p, "sbal_index", "0x%02x", r->sbal_index);
+	zfcp_dbf_out(p, "sbal_count", "0x%02x", r->sbal_count);
 }
 
-static int
-zfcp_hba_dbf_view_format(debug_info_t * id, struct debug_view *view,
-			 char *out_buf, const char *in_buf)
+static int zfcp_hba_dbf_view_format(debug_info_t *id, struct debug_view *view,
+				    char *out_buf, const char *in_buf)
 {
-	struct zfcp_hba_dbf_record *rec = (struct zfcp_hba_dbf_record *)in_buf;
-	int len = 0;
+	struct zfcp_hba_dbf_record *r = (struct zfcp_hba_dbf_record *)in_buf;
+	char *p = out_buf;
 
-	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
-	len += zfcp_dbf_tag(out_buf + len, "tag", rec->tag);
-	if (isalpha(rec->tag2[0]))
-		len += zfcp_dbf_tag(out_buf + len, "tag2", rec->tag2);
-	if (strncmp(rec->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
-		len += zfcp_hba_dbf_view_response(out_buf + len,
-						  &rec->type.response);
-	else if (strncmp(rec->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
-		len += zfcp_hba_dbf_view_status(out_buf + len,
-						&rec->type.status);
-	else if (strncmp(rec->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
-		len += zfcp_hba_dbf_view_qdio(out_buf + len, &rec->type.qdio);
-
-	len += sprintf(out_buf + len, "\n");
+	zfcp_dbf_tag(&p, "tag", r->tag);
+	if (isalpha(r->tag2[0]))
+		zfcp_dbf_tag(&p, "tag2", r->tag2);
+
+	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
+		zfcp_hba_dbf_view_response(&p, &r->type.response);
+	else if (strncmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
+		zfcp_hba_dbf_view_status(&p, &r->type.status);
+	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
+		zfcp_hba_dbf_view_qdio(&p, &r->type.qdio);
 
-	return len;
+	p += sprintf(p, "\n");
+	return p - out_buf;
 }
 
 static struct debug_view zfcp_hba_dbf_view = {
@@ -973,7 +960,7 @@ zfcp_san_dbf_view_format(debug_info_t * 
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
-	p += zfcp_dbf_tag(p, "tag", r->tag);
+	zfcp_dbf_tag(&p, "tag", r->tag);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
 	zfcp_dbf_out(&p, "s_id", "0x%06x", r->s_id);
@@ -1160,8 +1147,8 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
-	p += zfcp_dbf_tag(p, "tag", r->tag);
-	p += zfcp_dbf_tag(p, "tag2", r->tag2);
+	zfcp_dbf_tag(&p, "tag", r->tag);
+	zfcp_dbf_tag(&p, "tag2", r->tag2);
 	zfcp_dbf_out(&p, "scsi_id", "0x%08x", r->scsi_id);
 	zfcp_dbf_out(&p, "scsi_lun", "0x%08x", r->scsi_lun);
 	zfcp_dbf_out(&p, "scsi_result", "0x%08x", r->scsi_result);

-- 
