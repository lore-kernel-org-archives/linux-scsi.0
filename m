From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/27] zfcp: Only collect FSF/HBA debug data for matching trace levels
Date: Tue, 18 Aug 2009 15:43:09 +0200
Message-ID: <20090818135029.272343000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38047 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=703-zfcp-debug-data-2.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The default trace level is to only trace failed FSF commands. Thus it
is not necessary to collect trace data for most FSF commands, since
it will be thrown away later. Restructure the FSF/HBA trace
infrastructure to first check the trace level in a inline function and
only do the expensive data collection for matching trace levels.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |   44 ++++++-----------------------------
 drivers/s390/scsi/zfcp_dbf.h |   53 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_ext.h |    9 ++++---
 3 files changed, 67 insertions(+), 39 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2009-08-12 10:05:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2009-08-12 10:05:28.000000000 +0200
@@ -120,14 +120,10 @@ static int zfcp_dbf_view_header(debug_in
 	return p - out_buf;
 }
 
-/**
- * zfcp_hba_dbf_event_fsf_response - trace event for request completion
- * @fsf_req: request that has been completed
- */
-void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *fsf_req)
+void _zfcp_hba_dbf_event_fsf_response(const char *tag2, int level,
+				      struct zfcp_fsf_req *fsf_req,
+				      struct zfcp_dbf *dbf)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct zfcp_dbf *dbf = adapter->dbf;
 	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 	union fsf_prot_status_qual *prot_status_qual =
 					&qtcb->prefix.prot_status_qual;
@@ -138,31 +134,12 @@ void zfcp_hba_dbf_event_fsf_response(str
 	struct zfcp_send_els *send_els;
 	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
 	struct zfcp_hba_dbf_record_response *response = &rec->u.response;
-	int level;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
-
-	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
-	    (qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
-		strncpy(rec->tag2, "perr", ZFCP_DBF_TAG_SIZE);
-		level = 1;
-	} else if (qtcb->header.fsf_status != FSF_GOOD) {
-		strncpy(rec->tag2, "ferr", ZFCP_DBF_TAG_SIZE);
-		level = 1;
-	} else if ((fsf_req->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) ||
-		   (fsf_req->fsf_command == FSF_QTCB_OPEN_LUN)) {
-		strncpy(rec->tag2, "open", ZFCP_DBF_TAG_SIZE);
-		level = 4;
-	} else if (qtcb->header.log_length) {
-		strncpy(rec->tag2, "qtcb", ZFCP_DBF_TAG_SIZE);
-		level = 5;
-	} else {
-		strncpy(rec->tag2, "norm", ZFCP_DBF_TAG_SIZE);
-		level = 6;
-	}
+	strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
 
 	response->fsf_command = fsf_req->fsf_command;
 	response->fsf_reqid = fsf_req->req_id;
@@ -241,14 +218,9 @@ void zfcp_hba_dbf_event_fsf_response(str
 	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 
-/**
- * zfcp_hba_dbf_event_fsf_unsol - trace event for an unsolicited status buffer
- * @tag: tag indicating which kind of unsolicited status has been received
- * @adapter: adapter that has issued the unsolicited status buffer
- * @status_buffer: buffer containing payload of unsolicited status
- */
-void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
-				  struct fsf_status_read_buffer *status_buffer)
+void _zfcp_hba_dbf_event_fsf_unsol(const char *tag, int level,
+				   struct zfcp_adapter *adapter,
+				   struct fsf_status_read_buffer *status_buffer)
 {
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
@@ -296,7 +268,7 @@ void zfcp_hba_dbf_event_fsf_unsol(const 
 		       &status_buffer->payload, rec->u.status.payload_size);
 	}
 
-	debug_event(dbf->hba_dbf, 2, rec, sizeof(*rec));
+	debug_event(dbf->hba_dbf, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2009-08-12 10:05:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2009-08-12 10:05:28.000000000 +0200
@@ -240,6 +240,59 @@ struct zfcp_dbf {
 };
 
 static inline
+void zfcp_hba_dbf_event_fsf_resp(const char *tag2, int level,
+				 struct zfcp_fsf_req *req, struct zfcp_dbf *dbf)
+{
+	if (level <= dbf->hba_dbf->level)
+		_zfcp_hba_dbf_event_fsf_response(tag2, level, req, dbf);
+}
+
+/**
+ * zfcp_hba_dbf_event_fsf_response - trace event for request completion
+ * @fsf_req: request that has been completed
+ */
+static inline void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *req)
+{
+	struct zfcp_dbf *dbf = req->adapter->dbf;
+	struct fsf_qtcb *qtcb = req->qtcb;
+
+	if ((qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
+	    (qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
+		zfcp_hba_dbf_event_fsf_resp("perr", 1, req, dbf);
+
+	} else if (qtcb->header.fsf_status != FSF_GOOD) {
+		zfcp_hba_dbf_event_fsf_resp("ferr", 1, req, dbf);
+
+	} else if ((req->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) ||
+		   (req->fsf_command == FSF_QTCB_OPEN_LUN)) {
+		zfcp_hba_dbf_event_fsf_resp("open", 4, req, dbf);
+
+	} else if (qtcb->header.log_length) {
+		zfcp_hba_dbf_event_fsf_resp("qtcb", 5, req, dbf);
+
+	} else {
+		zfcp_hba_dbf_event_fsf_resp("norm", 6, req, dbf);
+	}
+ }
+
+/**
+ * zfcp_hba_dbf_event_fsf_unsol - trace event for an unsolicited status buffer
+ * @tag: tag indicating which kind of unsolicited status has been received
+ * @adapter: adapter that has issued the unsolicited status buffer
+ * @status_buffer: buffer containing payload of unsolicited status
+ */
+static inline
+void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
+				  struct fsf_status_read_buffer *buf)
+{
+	struct zfcp_dbf *dbf = adapter->dbf;
+	int level = 2;
+
+	if (level <= dbf->hba_dbf->level)
+		_zfcp_hba_dbf_event_fsf_unsol(tag, level, adapter, buf);
+}
+
+static inline
 void zfcp_scsi_dbf_event(const char *tag, const char *tag2, int level,
 			 struct zfcp_adapter *adapter, struct scsi_cmnd *scmd,
 			 struct zfcp_fsf_req *req, unsigned long old_id)
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-08-12 10:05:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-08-12 10:05:28.000000000 +0200
@@ -45,9 +45,12 @@ extern void zfcp_rec_dbf_event_trigger(c
 				       struct zfcp_adapter *,
 				       struct zfcp_port *, struct zfcp_unit *);
 extern void zfcp_rec_dbf_event_action(char *, struct zfcp_erp_action *);
-extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
-extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
-					 struct fsf_status_read_buffer *);
+extern void _zfcp_hba_dbf_event_fsf_response(const char *, int level,
+					     struct zfcp_fsf_req *,
+					     struct zfcp_dbf *dbf);
+extern void _zfcp_hba_dbf_event_fsf_unsol(const char *, int level,
+					  struct zfcp_adapter *,
+					  struct fsf_status_read_buffer *);
 extern void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *, unsigned int, int,
 				    int);
 extern void zfcp_hba_dbf_event_berr(struct zfcp_adapter *,

