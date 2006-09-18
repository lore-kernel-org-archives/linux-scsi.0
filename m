From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 3/6] zfcp: fix: use correct req_id in eh_abort_handler
Date: Mon, 18 Sep 2006 22:29:20 +0200
Message-ID: <20060918202920.GA10496@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:38456 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S964933AbWIRUeH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:34:07 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKY6nn021150
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:34:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKcolK2949248
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:38:50 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKY5H9014085
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:34:06 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: fix: use correct req_id in eh_abort_handler

zfcp's eh_abort_handler used the wrong request ID to
identify the request to be aborted. The bug was introduced
with commit fea9d6c7bcd8ff1d60ff74f27ba483b3820b18a3
for improved management of request IDs. The bug is
fixed with this patch.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    4 +++
 drivers/s390/scsi/zfcp_dbf.c  |   13 ++++----
 drivers/s390/scsi/zfcp_ext.h  |    2 +
 drivers/s390/scsi/zfcp_fsf.c  |    9 +++---
 drivers/s390/scsi/zfcp_scsi.c |   63 ++++++++++++++++++-----------------------
 5 files changed, 42 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index d2b094d..504c921 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -189,6 +189,10 @@ struct zfcp_fsf_req *zfcp_reqlist_ismemb
 	struct zfcp_fsf_req *request, *tmp;
 	unsigned int i;
 
+	/* 0 is reserved as an invalid req_id */
+	if (req_id == 0)
+		return NULL;
+
 	i = req_id % REQUEST_LIST_SIZE;
 
 	list_for_each_entry_safe(request, tmp, &adapter->req_list[i], list)
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index c033145..0aa3b1a 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -707,7 +707,7 @@ _zfcp_scsi_dbf_event_common(const char *
 			    struct zfcp_adapter *adapter,
 			    struct scsi_cmnd *scsi_cmnd,
 			    struct zfcp_fsf_req *fsf_req,
-			    struct zfcp_fsf_req *old_fsf_req)
+			    unsigned long old_req_id)
 {
 	struct zfcp_scsi_dbf_record *rec = &adapter->scsi_dbf_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
@@ -768,8 +768,7 @@ _zfcp_scsi_dbf_event_common(const char *
 				rec->fsf_seqno = fsf_req->seq_no;
 				rec->fsf_issued = fsf_req->issued;
 			}
-			rec->type.old_fsf_reqid =
-				    (unsigned long) old_fsf_req;
+			rec->type.old_fsf_reqid = old_req_id;
 		} else {
 			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
 			dump->total_size = buflen;
@@ -794,17 +793,17 @@ zfcp_scsi_dbf_event_result(const char *t
 			   struct zfcp_fsf_req *fsf_req)
 {
 	_zfcp_scsi_dbf_event_common("rslt", tag, level,
-			adapter, scsi_cmnd, fsf_req, NULL);
+			adapter, scsi_cmnd, fsf_req, 0);
 }
 
 inline void
 zfcp_scsi_dbf_event_abort(const char *tag, struct zfcp_adapter *adapter,
 			  struct scsi_cmnd *scsi_cmnd,
 			  struct zfcp_fsf_req *new_fsf_req,
-			  struct zfcp_fsf_req *old_fsf_req)
+			  unsigned long old_req_id)
 {
 	_zfcp_scsi_dbf_event_common("abrt", tag, 1,
-			adapter, scsi_cmnd, new_fsf_req, old_fsf_req);
+			adapter, scsi_cmnd, new_fsf_req, old_req_id);
 }
 
 inline void
@@ -814,7 +813,7 @@ zfcp_scsi_dbf_event_devreset(const char 
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	_zfcp_scsi_dbf_event_common(flag == FCP_TARGET_RESET ? "trst" : "lrst",
-			tag, 1, adapter, scsi_cmnd, NULL, NULL);
+			tag, 1, adapter, scsi_cmnd, NULL, 0);
 }
 
 static int
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 4f4ef0c..710ebbf 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -185,7 +185,7 @@ extern void zfcp_scsi_dbf_event_result(c
 				       struct zfcp_fsf_req *);
 extern void zfcp_scsi_dbf_event_abort(const char *, struct zfcp_adapter *,
 				      struct scsi_cmnd *, struct zfcp_fsf_req *,
-				      struct zfcp_fsf_req *);
+				      unsigned long);
 extern void zfcp_scsi_dbf_event_devreset(const char *, u8, struct zfcp_unit *,
 					 struct scsi_cmnd *);
 extern void zfcp_reqlist_add(struct zfcp_adapter *, struct zfcp_fsf_req *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 4913ffb..a66b519 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3527,7 +3527,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	fsf_req->unit = unit;
 
 	/* associate FSF request with SCSI request (for look up on abort) */
-	scsi_cmnd->host_scribble = (char *) fsf_req;
+	scsi_cmnd->host_scribble = (unsigned char *) fsf_req->req_id;
 
 	/* associate SCSI command with FSF request */
 	fsf_req->data = (unsigned long) scsi_cmnd;
@@ -4667,7 +4667,6 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 {
 	volatile struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req = NULL;
-	unsigned long flags;
 	int ret = 0;
 	struct zfcp_qdio_queue *req_queue = &adapter->request_queue;
 
@@ -4684,10 +4683,10 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	fsf_req->fsf_command = fsf_cmd;
 	INIT_LIST_HEAD(&fsf_req->list);
 	
-	/* unique request id */
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
+	/* this is serialized (we are holding req_queue-lock of adapter */
+	if (adapter->req_no == 0)
+		adapter->req_no++;
 	fsf_req->req_id = adapter->req_no++;
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
         zfcp_fsf_req_qtcb_init(fsf_req);
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 4857ccc..043ed7c 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -378,16 +378,15 @@ zfcp_unit_lookup(struct zfcp_adapter *ad
  * will handle late commands.  (Usually, the normal completion of late
  * commands is ignored with respect to the running abort operation.)
  */
-int
-zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
  	struct Scsi_Host *scsi_host;
  	struct zfcp_adapter *adapter;
 	struct zfcp_unit *unit;
-	int retval = SUCCESS;
-	struct zfcp_fsf_req *new_fsf_req = NULL;
-	struct zfcp_fsf_req *old_fsf_req;
+	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
+	unsigned long old_req_id;
+	int retval = SUCCESS;
 
 	scsi_host = scpnt->device->host;
 	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
@@ -399,55 +398,47 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
-	/*
-	 * Check whether command has just completed and can not be aborted.
-	 * Even if the command has just been completed late, we can access
-	 * scpnt since the SCSI stack does not release it at least until
-	 * this routine returns. (scpnt is parameter passed to this routine
-	 * and must not disappear during abort even on late completion.)
-	 */
-	old_fsf_req = (struct zfcp_fsf_req *) scpnt->host_scribble;
-	if (!old_fsf_req) {
+	/* Check whether corresponding fsf_req is still pending */
+	spin_lock(&adapter->req_list_lock);
+	fsf_req = zfcp_reqlist_ismember(adapter, (unsigned long)
+					scpnt->host_scribble);
+	spin_unlock(&adapter->req_list_lock);
+	if (!fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, NULL);
+		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, 0);
 		retval = SUCCESS;
 		goto out;
 	}
-	old_fsf_req->data = 0;
-	old_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
+	fsf_req->data = 0;
+	fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
+	old_req_id = fsf_req->req_id;
 
-	/* don't access old_fsf_req after releasing the abort_lock */
+	/* don't access old fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
-	/* call FSF routine which does the abort */
-	new_fsf_req = zfcp_fsf_abort_fcp_command((unsigned long) old_fsf_req,
-						 adapter, unit, 0);
-	if (!new_fsf_req) {
+
+	fsf_req = zfcp_fsf_abort_fcp_command(old_req_id, adapter, unit, 0);
+	if (!fsf_req) {
 		ZFCP_LOG_INFO("error: initiation of Abort FCP Cmnd failed\n");
 		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
-					  old_fsf_req);
+					  old_req_id);
 		retval = FAILED;
 		goto out;
 	}
 
-	/* wait for completion of abort */
-	__wait_event(new_fsf_req->completion_wq,
-		     new_fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	__wait_event(fsf_req->completion_wq,
+		     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	/* status should be valid since signals were not permitted */
-	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
-		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, new_fsf_req,
-					  NULL);
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
+		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, fsf_req, 0);
 		retval = SUCCESS;
-	} else if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
-		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, new_fsf_req,
-					  NULL);
+	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
+		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, fsf_req, 0);
 		retval = SUCCESS;
 	} else {
-		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, new_fsf_req,
-					  NULL);
+		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, fsf_req, 0);
 		retval = FAILED;
 	}
-	zfcp_fsf_req_free(new_fsf_req);
+	zfcp_fsf_req_free(fsf_req);
  out:
 	return retval;
 }
-- 
1.4.2.1.g80823

