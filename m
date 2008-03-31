From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 9/9] zfcp: Add docbook comments to debug trace.
Date: Mon, 31 Mar 2008 11:15:31 +0200
Message-ID: <20080331091836.490978000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:29133 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYCaJTR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:19:17 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_docbook.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Add missing docbook-comments for functions forming zfcp's internal
trace API.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   62 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 15:00:08.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 15:00:21.000000000 +0100
@@ -131,6 +131,10 @@ static int zfcp_dbf_view_header(debug_in
 	return p - out_buf;
 }
 
+/**
+ * zfcp_hba_dbf_event_fsf_response - trace event for request completion
+ * @fsf_req: request that has been completed
+ */
 void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
@@ -247,6 +251,12 @@ void zfcp_hba_dbf_event_fsf_response(str
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
+/**
+ * zfcp_hba_dbf_event_fsf_unsol - trace event for an unsolicited status buffer
+ * @tag: tag indicating which kind of unsolicited status has been received
+ * @adapter: adapter that has issued the unsolicited status buffer
+ * @status_buffer: buffer containing payload of unsolicited status
+ */
 void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
 				  struct fsf_status_read_buffer *status_buffer)
 {
@@ -299,6 +309,15 @@ void zfcp_hba_dbf_event_fsf_unsol(const 
 	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
 }
 
+/**
+ * zfcp_hba_dbf_event_qdio - trace event for QDIO related failure
+ * @adapter: adapter affected by this QDIO related event
+ * @status: as passed by qdio module
+ * @qdio_error: as passed by qdio module
+ * @siga_error: as passed by qdio module
+ * @sbal_index: first buffer with error condition, as passed by qdio module
+ * @sbal_count: number of buffers affected, as passed by qdio module
+ */
 void zfcp_hba_dbf_event_qdio(struct zfcp_adapter *adapter, unsigned int status,
 			     unsigned int qdio_error, unsigned int siga_error,
 			     int sbal_index, int sbal_count)
@@ -810,6 +829,10 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
+/**
+ * zfcp_san_dbf_event_ct_request - trace event for issued CT request
+ * @fsf_req: request containing issued CT data
+ */
 void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
@@ -840,6 +863,10 @@ void zfcp_san_dbf_event_ct_request(struc
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
+/**
+ * zfcp_san_dbf_event_ct_response - trace event for completion of CT request
+ * @fsf_req: request containing CT response
+ */
 void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
@@ -892,6 +919,10 @@ static void zfcp_san_dbf_event_els(const
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
+/**
+ * zfcp_san_dbf_event_els_request - trace event for issued ELS
+ * @fsf_req: request containing issued ELS
+ */
 void zfcp_san_dbf_event_els_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
@@ -902,6 +933,10 @@ void zfcp_san_dbf_event_els_request(stru
 			       zfcp_sg_to_address(els->req), els->req->length);
 }
 
+/**
+ * zfcp_san_dbf_event_els_response - trace event for completed ELS
+ * @fsf_req: request containing ELS response
+ */
 void zfcp_san_dbf_event_els_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
@@ -913,6 +948,10 @@ void zfcp_san_dbf_event_els_response(str
 			       els->resp->length);
 }
 
+/**
+ * zfcp_san_dbf_event_incoming_els - trace event for incomig ELS
+ * @fsf_req: request containing unsolicited status buffer with incoming ELS
+ */
 void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
@@ -1069,6 +1108,14 @@ static void zfcp_scsi_dbf_event(const ch
 	spin_unlock_irqrestore(&adapter->scsi_dbf_lock, flags);
 }
 
+/**
+ * zfcp_scsi_dbf_event_result - trace event for SCSI command completion
+ * @tag: tag indicating success or failure of SCSI command
+ * @level: trace level applicable for this event
+ * @adapter: adapter that has been used to issue the SCSI command
+ * @scsi_cmnd: SCSI command pointer
+ * @fsf_req: request used to issue SCSI command (might be NULL)
+ */
 void zfcp_scsi_dbf_event_result(const char *tag, int level,
 				struct zfcp_adapter *adapter,
 				struct scsi_cmnd *scsi_cmnd,
@@ -1077,6 +1124,14 @@ void zfcp_scsi_dbf_event_result(const ch
 	zfcp_scsi_dbf_event("rslt", tag, level, adapter, scsi_cmnd, fsf_req, 0);
 }
 
+/**
+ * zfcp_scsi_dbf_event_abort - trace event for SCSI command abort
+ * @tag: tag indicating success or failure of abort operation
+ * @adapter: adapter thas has been used to issue SCSI command to be aborted
+ * @scsi_cmnd: SCSI command to be aborted
+ * @new_fsf_req: request containing abort (might be NULL)
+ * @old_req_id: identifier of request containg SCSI command to be aborted
+ */
 void zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
 			       struct scsi_cmnd *scsi_cmnd,
 			       struct zfcp_fsf_req *new_fsf_req,
@@ -1086,6 +1141,13 @@ void zfcp_scsi_dbf_event_abort(const cha
 			    old_req_id);
 }
 
+/**
+ * zfcp_scsi_dbf_event_devreset - trace event for Logical Unit or Target Reset
+ * @tag: tag indicating success or failure of reset operation
+ * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
+ * @unit: unit that needs reset
+ * @scsi_cmnd: SCSI command which caused this error recovery
+ */
 void zfcp_scsi_dbf_event_devreset(const char *tag, u8 flag,
 				  struct zfcp_unit *unit,
 				  struct scsi_cmnd *scsi_cmnd)

-- 
