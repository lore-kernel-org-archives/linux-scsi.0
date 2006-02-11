From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 3/4] zfcp: fix logging during device reset
Date: Sat, 11 Feb 2006 01:42:58 +0100
Message-ID: <20060211004258.GA17348@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:63285 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S932283AbWBKAnn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 19:43:43 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k1B0hgQk200310
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 00:43:42 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1B0hhC3239020
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:43:43 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k1B0hg1S019285
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:43:42 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Maxim Shchetynin <maxim@de.ibm.com>, Linux SCSI <linux-scsi@vger.kernel.org>

From: Maxim Shchetynin <maxim@de.ibm.com>

Avoid access to old fsf_requests if device reset is logged.

Signed-off-by: Maxim Shchetynin <maxim@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_dbf.c  |   76 ++++++++++++++++-------------------------
 drivers/s390/scsi/zfcp_def.h  |    6 +--
 drivers/s390/scsi/zfcp_ext.h  |    5 ++-
 drivers/s390/scsi/zfcp_fsf.c  |    6 ++-
 drivers/s390/scsi/zfcp_scsi.c |   15 +++++---
 5 files changed, 47 insertions(+), 61 deletions(-)

00e2067be332ce201736a95512883396db5bed6c
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 4d7d47c..a5f2ba9 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -710,10 +710,9 @@ static inline void
 _zfcp_scsi_dbf_event_common(const char *tag, const char *tag2, int level,
 			    struct zfcp_adapter *adapter,
 			    struct scsi_cmnd *scsi_cmnd,
-			    struct zfcp_fsf_req *new_fsf_req)
+			    struct zfcp_fsf_req *fsf_req,
+			    struct zfcp_fsf_req *old_fsf_req)
 {
-	struct zfcp_fsf_req *fsf_req =
-	    (struct zfcp_fsf_req *)scsi_cmnd->host_scribble;
 	struct zfcp_scsi_dbf_record *rec = &adapter->scsi_dbf_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
 	unsigned long flags;
@@ -727,19 +726,20 @@ _zfcp_scsi_dbf_event_common(const char *
 		if (offset == 0) {
 			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 			strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
-			if (scsi_cmnd->device) {
-				rec->scsi_id = scsi_cmnd->device->id;
-				rec->scsi_lun = scsi_cmnd->device->lun;
+			if (scsi_cmnd != NULL) {
+				if (scsi_cmnd->device) {
+					rec->scsi_id = scsi_cmnd->device->id;
+					rec->scsi_lun = scsi_cmnd->device->lun;
+				}
+				rec->scsi_result = scsi_cmnd->result;
+				rec->scsi_cmnd = (unsigned long)scsi_cmnd;
+				rec->scsi_serial = scsi_cmnd->serial_number;
+				memcpy(rec->scsi_opcode, &scsi_cmnd->cmnd,
+					min((int)scsi_cmnd->cmd_len,
+						ZFCP_DBF_SCSI_OPCODE));
+				rec->scsi_retries = scsi_cmnd->retries;
+				rec->scsi_allowed = scsi_cmnd->allowed;
 			}
-			rec->scsi_result = scsi_cmnd->result;
-			rec->scsi_cmnd = (unsigned long)scsi_cmnd;
-			rec->scsi_serial = scsi_cmnd->serial_number;
-			memcpy(rec->scsi_opcode,
-			       &scsi_cmnd->cmnd,
-			       min((int)scsi_cmnd->cmd_len,
-				   ZFCP_DBF_SCSI_OPCODE));
-			rec->scsi_retries = scsi_cmnd->retries;
-			rec->scsi_allowed = scsi_cmnd->allowed;
 			if (fsf_req != NULL) {
 				fcp_rsp = (struct fcp_rsp_iu *)
 				    &(fsf_req->qtcb->bottom.io.fcp_rsp);
@@ -772,15 +772,8 @@ _zfcp_scsi_dbf_event_common(const char *
 				rec->fsf_seqno = fsf_req->seq_no;
 				rec->fsf_issued = fsf_req->issued;
 			}
-			if (new_fsf_req != NULL) {
-				rec->type.new_fsf_req.fsf_reqid =
-				    (unsigned long)
-				    new_fsf_req;
-				rec->type.new_fsf_req.fsf_seqno =
-				    new_fsf_req->seq_no;
-				rec->type.new_fsf_req.fsf_issued =
-				    new_fsf_req->issued;
-			}
+			rec->type.old_fsf_reqid =
+				    (unsigned long) old_fsf_req;
 		} else {
 			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
 			dump->total_size = buflen;
@@ -801,19 +794,21 @@ _zfcp_scsi_dbf_event_common(const char *
 inline void
 zfcp_scsi_dbf_event_result(const char *tag, int level,
 			   struct zfcp_adapter *adapter,
-			   struct scsi_cmnd *scsi_cmnd)
+			   struct scsi_cmnd *scsi_cmnd,
+			   struct zfcp_fsf_req *fsf_req)
 {
-	_zfcp_scsi_dbf_event_common("rslt",
-				    tag, level, adapter, scsi_cmnd, NULL);
+	_zfcp_scsi_dbf_event_common("rslt", tag, level,
+			adapter, scsi_cmnd, fsf_req, NULL);
 }
 
 inline void
 zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
 			  struct scsi_cmnd *scsi_cmnd,
-			  struct zfcp_fsf_req *new_fsf_req)
+			  struct zfcp_fsf_req *new_fsf_req,
+			  struct zfcp_fsf_req *old_fsf_req)
 {
-	_zfcp_scsi_dbf_event_common("abrt",
-				    tag, 1, adapter, scsi_cmnd, new_fsf_req);
+	_zfcp_scsi_dbf_event_common("abrt", tag, 1,
+			adapter, scsi_cmnd, new_fsf_req, old_fsf_req);
 }
 
 inline void
@@ -823,7 +818,7 @@ zfcp_scsi_dbf_event_devreset(const char 
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	_zfcp_scsi_dbf_event_common(flag == FCP_TARGET_RESET ? "trst" : "lrst",
-				    tag, 1, adapter, scsi_cmnd, NULL);
+			tag, 1, adapter, scsi_cmnd, NULL, NULL);
 }
 
 static int
@@ -856,6 +851,10 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 			     rec->scsi_retries);
 	len += zfcp_dbf_view(out_buf + len, "scsi_allowed", "0x%02x",
 			     rec->scsi_allowed);
+	if (strncmp(rec->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0) {
+		len += zfcp_dbf_view(out_buf + len, "old_fsf_reqid", "0x%0Lx",
+				     rec->type.old_fsf_reqid);
+	}
 	len += zfcp_dbf_view(out_buf + len, "fsf_reqid", "0x%0Lx",
 			     rec->fsf_reqid);
 	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
@@ -883,21 +882,6 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 				       min((int)rec->type.fcp.sns_info_len,
 					   ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
 				       rec->type.fcp.sns_info_len);
-	} else if (strncmp(rec->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0) {
-		len += zfcp_dbf_view(out_buf + len, "fsf_reqid_abort", "0x%0Lx",
-				     rec->type.new_fsf_req.fsf_reqid);
-		len += zfcp_dbf_view(out_buf + len, "fsf_seqno_abort", "0x%08x",
-				     rec->type.new_fsf_req.fsf_seqno);
-		len += zfcp_dbf_stck(out_buf + len, "fsf_issued",
-				     rec->type.new_fsf_req.fsf_issued);
-	} else if ((strncmp(rec->tag, "trst", ZFCP_DBF_TAG_SIZE) == 0) ||
-		   (strncmp(rec->tag, "lrst", ZFCP_DBF_TAG_SIZE) == 0)) {
-		len += zfcp_dbf_view(out_buf + len, "fsf_reqid_reset", "0x%0Lx",
-				     rec->type.new_fsf_req.fsf_reqid);
-		len += zfcp_dbf_view(out_buf + len, "fsf_seqno_reset", "0x%08x",
-				     rec->type.new_fsf_req.fsf_seqno);
-		len += zfcp_dbf_stck(out_buf + len, "fsf_issued",
-				     rec->type.new_fsf_req.fsf_issued);
 	}
 
 	len += sprintf(out_buf + len, "\n");
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index f031199..7f551d6 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -424,11 +424,7 @@ struct zfcp_scsi_dbf_record {
 	u32 fsf_seqno;
 	u64 fsf_issued;
 	union {
-		struct {
-			u64 fsf_reqid;
-			u32 fsf_seqno;
-			u64 fsf_issued;
-		} new_fsf_req;
+		u64 old_fsf_reqid;
 		struct {
 			u8 rsp_validity;
 			u8 rsp_scsi_status;
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index c1ba7cf..700f540 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -194,9 +194,10 @@ extern void zfcp_san_dbf_event_els_respo
 extern void zfcp_san_dbf_event_incoming_els(struct zfcp_fsf_req *);
 
 extern void zfcp_scsi_dbf_event_result(const char *, int, struct zfcp_adapter *,
-				       struct scsi_cmnd *);
+				       struct scsi_cmnd *,
+				       struct zfcp_fsf_req *);
 extern void zfcp_scsi_dbf_event_abort(const char *, struct zfcp_adapter *,
-				      struct scsi_cmnd *,
+				      struct scsi_cmnd *, struct zfcp_fsf_req *,
 				      struct zfcp_fsf_req *);
 extern void zfcp_scsi_dbf_event_devreset(const char *, u8, struct zfcp_unit *,
 					 struct scsi_cmnd *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index bd8cd4d..662ec57 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4211,11 +4211,11 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	ZFCP_LOG_DEBUG("scpnt->result =0x%x\n", scpnt->result);
 
 	if (scpnt->result != 0)
-		zfcp_scsi_dbf_event_result("erro", 3, fsf_req->adapter, scpnt);
+		zfcp_scsi_dbf_event_result("erro", 3, fsf_req->adapter, scpnt, fsf_req);
 	else if (scpnt->retries > 0)
-		zfcp_scsi_dbf_event_result("retr", 4, fsf_req->adapter, scpnt);
+		zfcp_scsi_dbf_event_result("retr", 4, fsf_req->adapter, scpnt, fsf_req);
 	else
-		zfcp_scsi_dbf_event_result("norm", 6, fsf_req->adapter, scpnt);
+		zfcp_scsi_dbf_event_result("norm", 6, fsf_req->adapter, scpnt, fsf_req);
 
 	/* cleanup pointer (need this especially for abort) */
 	scpnt->host_scribble = NULL;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index e080375..9f6b4d7 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -242,7 +242,7 @@ zfcp_scsi_command_fail(struct scsi_cmnd 
 	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
 		zfcp_scsi_dbf_event_result("fail", 4,
 			(struct zfcp_adapter*) scpnt->device->host->hostdata[0],
-			scpnt);
+			scpnt, NULL);
 	/* return directly */
 	scpnt->scsi_done(scpnt);
 }
@@ -446,7 +446,7 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 	old_fsf_req = (struct zfcp_fsf_req *) scpnt->host_scribble;
 	if (!old_fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, new_fsf_req);
+		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, NULL);
 		retval = SUCCESS;
 		goto out;
 	}
@@ -460,6 +460,8 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 						 adapter, unit, 0);
 	if (!new_fsf_req) {
 		ZFCP_LOG_INFO("error: initiation of Abort FCP Cmnd failed\n");
+		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
+					  old_fsf_req);
 		retval = FAILED;
 		goto out;
 	}
@@ -470,13 +472,16 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 
 	/* status should be valid since signals were not permitted */
 	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
-		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, new_fsf_req);
+		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, new_fsf_req,
+					  NULL);
 		retval = SUCCESS;
 	} else if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
-		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, new_fsf_req);
+		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, new_fsf_req,
+					  NULL);
 		retval = SUCCESS;
 	} else {
-		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, new_fsf_req);
+		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, new_fsf_req,
+					  NULL);
 		retval = FAILED;
 	}
 	zfcp_fsf_req_free(new_fsf_req);
-- 
0.99.9n-g5a22
