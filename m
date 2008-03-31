From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 8/9] zfcp: Cleanup line breaks in debug trace.
Date: Mon, 31 Mar 2008 11:15:30 +0200
Message-ID: <20080331091835.728331000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:20172 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbYCaJSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:38 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_linebreaks.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Remove line breaks that do not conform to coding style.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  123 +++++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 68 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 11:01:11.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 11:02:33.000000000 +0200
@@ -110,9 +110,8 @@ static void zfcp_dbf_outd(char **p, cons
 		*p += sprintf(*p, "\n");
 }
 
-static int
-zfcp_dbf_view_header(debug_info_t * id, struct debug_view *view, int area,
-		     debug_entry_t * entry, char *out_buf)
+static int zfcp_dbf_view_header(debug_info_t *id, struct debug_view *view,
+				int area, debug_entry_t *entry, char *out_buf)
 {
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)DEBUG_DATA(entry);
 	struct timespec t;
@@ -137,7 +136,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 	union fsf_prot_status_qual *prot_status_qual =
-	    &qtcb->prefix.prot_status_qual;
+					&qtcb->prefix.prot_status_qual;
 	union fsf_status_qual *fsf_status_qual = &qtcb->header.fsf_status_qual;
 	struct scsi_cmnd *scsi_cmnd;
 	struct zfcp_port *port;
@@ -248,9 +247,8 @@ void zfcp_hba_dbf_event_fsf_response(str
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
-void
-zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
-			     struct fsf_status_read_buffer *status_buffer)
+void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
+				  struct fsf_status_read_buffer *status_buffer)
 {
 	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
 	unsigned long flags;
@@ -301,10 +299,9 @@ zfcp_hba_dbf_event_fsf_unsol(const char 
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
-void
-zfcp_hba_dbf_event_qdio(struct zfcp_adapter *adapter, unsigned int status,
-			unsigned int qdio_error, unsigned int siga_error,
-			int sbal_index, int sbal_count)
+void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *adapter, unsigned int status,
+			     unsigned int qdio_error, unsigned int siga_error,
+			     int sbal_index, int sbal_count)
 {
 	struct zfcp_hba_dbf_record *r = &adapter->hba_dbf_buf;
 	unsigned long flags;
@@ -872,10 +869,10 @@ void zfcp_san_dbf_event_ct_response(stru
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
-static void
-_zfcp_san_dbf_event_common_els(const char *tag, int level,
-			       struct zfcp_fsf_req *fsf_req, u32 s_id,
-			       u32 d_id, u8 ls_code, void *buffer, int buflen)
+static void zfcp_san_dbf_event_els(const char *tag, int level,
+				   struct zfcp_fsf_req *fsf_req, u32 s_id,
+				   u32 d_id, u8 ls_code, void *buffer,
+				   int buflen)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
@@ -899,42 +896,39 @@ void zfcp_san_dbf_event_els_request(stru
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	_zfcp_san_dbf_event_common_els("oels", 2, fsf_req,
-				       fc_host_port_id(els->adapter->scsi_host),
-				       els->d_id,
-				       *(u8 *) zfcp_sg_to_address(els->req),
-				       zfcp_sg_to_address(els->req),
-				       els->req->length);
+	zfcp_san_dbf_event_els("oels", 2, fsf_req,
+			       fc_host_port_id(els->adapter->scsi_host),
+			       els->d_id, *(u8 *) zfcp_sg_to_address(els->req),
+			       zfcp_sg_to_address(els->req), els->req->length);
 }
 
 void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	_zfcp_san_dbf_event_common_els("rels", 2, fsf_req, els->d_id,
-				       fc_host_port_id(els->adapter->scsi_host),
-				       *(u8 *) zfcp_sg_to_address(els->req),
-				       zfcp_sg_to_address(els->resp),
-				       els->resp->length);
+	zfcp_san_dbf_event_els("rels", 2, fsf_req, els->d_id,
+			       fc_host_port_id(els->adapter->scsi_host),
+			       *(u8 *)zfcp_sg_to_address(els->req),
+			       zfcp_sg_to_address(els->resp),
+			       els->resp->length);
 }
 
 void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_status_read_buffer *status_buffer =
-	    (struct fsf_status_read_buffer *)fsf_req->data;
-	int length = (int)status_buffer->length -
-	    (int)((void *)&status_buffer->payload - (void *)status_buffer);
-
-	_zfcp_san_dbf_event_common_els("iels", 1, fsf_req, status_buffer->d_id,
-				       fc_host_port_id(adapter->scsi_host),
-				       *(u8 *) status_buffer->payload,
-				       (void *)status_buffer->payload, length);
+	struct fsf_status_read_buffer *buf =
+			(struct fsf_status_read_buffer *)fsf_req->data;
+	int length = (int)buf->length -
+		     (int)((void *)&buf->payload - (void *)buf);
+
+	zfcp_san_dbf_event_els("iels", 1, fsf_req, buf->d_id,
+			       fc_host_port_id(adapter->scsi_host),
+			       *(u8 *)buf->payload, (void *)buf->payload,
+			       length);
 }
 
-static int
-zfcp_san_dbf_view_format(debug_info_t * id, struct debug_view *view,
-			 char *out_buf, const char *in_buf)
+static int zfcp_san_dbf_view_format(debug_info_t *id, struct debug_view *view,
+				    char *out_buf, const char *in_buf)
 {
 	struct zfcp_san_dbf_record *r = (struct zfcp_san_dbf_record *)in_buf;
 	char *buffer = NULL;
@@ -997,12 +991,11 @@ static struct debug_view zfcp_san_dbf_vi
 	NULL
 };
 
-static void
-_zfcp_scsi_dbf_event_common(const char *tag, const char *tag2, int level,
-			    struct zfcp_adapter *adapter,
-			    struct scsi_cmnd *scsi_cmnd,
-			    struct zfcp_fsf_req *fsf_req,
-			    unsigned long old_req_id)
+static void zfcp_scsi_dbf_event(const char *tag, const char *tag2, int level,
+				struct zfcp_adapter *adapter,
+				struct scsi_cmnd *scsi_cmnd,
+				struct zfcp_fsf_req *fsf_req,
+				unsigned long old_req_id)
 {
 	struct zfcp_scsi_dbf_record *rec = &adapter->scsi_dbf_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
@@ -1076,39 +1069,33 @@ _zfcp_scsi_dbf_event_common(const char *
 	spin_unlock_irqrestore(&adapter->scsi_dbf_lock, flags);
 }
 
-void
-zfcp_scsi_dbf_event_result(const char *tag, int level,
-			   struct zfcp_adapter *adapter,
-			   struct scsi_cmnd *scsi_cmnd,
-			   struct zfcp_fsf_req *fsf_req)
+void zfcp_scsi_dbf_event_result(const char *tag, int level,
+				struct zfcp_adapter *adapter,
+				struct scsi_cmnd *scsi_cmnd,
+				struct zfcp_fsf_req *fsf_req)
 {
-	_zfcp_scsi_dbf_event_common("rslt", tag, level,
-			adapter, scsi_cmnd, fsf_req, 0);
+	zfcp_scsi_dbf_event("rslt", tag, level, adapter, scsi_cmnd, fsf_req, 0);
 }
 
-void
-zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
-			  struct scsi_cmnd *scsi_cmnd,
-			  struct zfcp_fsf_req *new_fsf_req,
-			  unsigned long old_req_id)
+void zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
+			       struct scsi_cmnd *scsi_cmnd,
+			       struct zfcp_fsf_req *new_fsf_req,
+			       unsigned long old_req_id)
 {
-	_zfcp_scsi_dbf_event_common("abrt", tag, 1,
-			adapter, scsi_cmnd, new_fsf_req, old_req_id);
+	zfcp_scsi_dbf_event("abrt", tag, 1, adapter, scsi_cmnd, new_fsf_req,
+			    old_req_id);
 }
 
-void
-zfcp_scsi_dbf_event_devreset(const char *tag, u8 flag, struct zfcp_unit *unit,
-			     struct scsi_cmnd *scsi_cmnd)
+void zfcp_scsi_dbf_event_devreset(const char *tag, u8 flag,
+				  struct zfcp_unit *unit,
+				  struct scsi_cmnd *scsi_cmnd)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	_zfcp_scsi_dbf_event_common(flag == FCP_TARGET_RESET ? "trst" : "lrst",
-			tag, 1, adapter, scsi_cmnd, NULL, 0);
+	zfcp_scsi_dbf_event(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
+			    unit->port->adapter, scsi_cmnd, NULL, 0);
 }
 
-static int
-zfcp_scsi_dbf_view_format(debug_info_t * id, struct debug_view *view,
-			  char *out_buf, const char *in_buf)
+static int zfcp_scsi_dbf_view_format(debug_info_t *id, struct debug_view *view,
+				     char *out_buf, const char *in_buf)
 {
 	struct zfcp_scsi_dbf_record *r = (struct zfcp_scsi_dbf_record *)in_buf;
 	struct timespec t;

-- 
