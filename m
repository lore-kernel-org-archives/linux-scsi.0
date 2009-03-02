From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/18] [PATCH] zfcp: Improve reliability of SCSI eh handlers in zfcp
Date: Mon, 02 Mar 2009 13:09:00 +0100
Message-ID: <20090302121002.939534000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49653 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=706-zfcp-reliability.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the SCSI midlayer is running error recovery, the low-level error
recovery in zfcp could be running and preventing the SCSI midlayer to
issue error recovery requests. To avoid unnecessary error recovery
escalation, wait for the zfcp erp to finish and retry if necessary.

While reworking the SCSI eh handlers, alsa cleanup the code and
simplify the interface from zfcp_scsi to the fsf layer.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    3 -
 drivers/s390/scsi/zfcp_ext.h  |   11 +--
 drivers/s390/scsi/zfcp_fsf.c  |   39 ++++---------
 drivers/s390/scsi/zfcp_scsi.c |  122 ++++++++++++++++++++----------------------
 4 files changed, 77 insertions(+), 98 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2009-03-02 12:42:24.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-03-02 12:42:30.000000000 +0100
@@ -586,9 +586,6 @@ struct zfcp_fsf_req_qtcb {
 
 /********************** ZFCP SPECIFIC DEFINES ********************************/
 
-#define ZFCP_REQ_AUTO_CLEANUP	0x00000002
-#define ZFCP_REQ_NO_QTCB	0x00000008
-
 #define ZFCP_SET                0x00000100
 #define ZFCP_CLEAR              0x00000200
 
--- a/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:20.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:30.000000000 +0100
@@ -125,16 +125,13 @@ extern int zfcp_status_read_refill(struc
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
-extern int zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *,
-					  struct zfcp_unit *,
-					  struct scsi_cmnd *, int, int);
+extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
+					  struct scsi_cmnd *);
 extern void zfcp_fsf_req_complete(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
-extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *,
-						  struct zfcp_unit *, u8, int);
+extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *, u8);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long,
-						       struct zfcp_adapter *,
-						       struct zfcp_unit *, int);
+						       struct zfcp_unit *);
 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_allocate(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:26.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:30.000000000 +0100
@@ -12,6 +12,9 @@
 #include <linux/blktrace_api.h>
 #include "zfcp_ext.h"
 
+#define ZFCP_REQ_AUTO_CLEANUP	0x00000002
+#define ZFCP_REQ_NO_QTCB	0x00000008
+
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
@@ -913,27 +916,22 @@ static void zfcp_fsf_abort_fcp_command_h
 /**
  * zfcp_fsf_abort_fcp_command - abort running SCSI command
  * @old_req_id: unsigned long
- * @adapter: pointer to struct zfcp_adapter
  * @unit: pointer to struct zfcp_unit
- * @req_flags: integer specifying the request flags
  * Returns: pointer to struct zfcp_fsf_req
- *
- * FIXME(design): should be watched by a timeout !!!
  */
 
 struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
-						struct zfcp_adapter *adapter,
-						struct zfcp_unit *unit,
-						int req_flags)
+						struct zfcp_unit *unit)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
-				  req_flags, adapter->pool.fsf_req_abort);
+				  0, adapter->pool.fsf_req_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;
@@ -2310,21 +2308,17 @@ static void zfcp_set_fcp_dl(struct fcp_c
 
 /**
  * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
- * @adapter: adapter where scsi command is issued
  * @unit: unit where command is sent to
  * @scsi_cmnd: scsi command to be sent
- * @timer: timer to be started when request is initiated
- * @req_flags: flags for fsf_request
  */
-int zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *adapter,
-				   struct zfcp_unit *unit,
-				   struct scsi_cmnd *scsi_cmnd,
-				   int use_timer, int req_flags)
+int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *unit,
+				   struct scsi_cmnd *scsi_cmnd)
 {
 	struct zfcp_fsf_req *req;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
 	unsigned int sbtype;
 	int real_bytes, retval = -EIO;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
@@ -2333,7 +2327,8 @@ int zfcp_fsf_send_fcp_command_task(struc
 	spin_lock(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
+				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_scsi);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -2415,9 +2410,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 
 	zfcp_set_fcp_dl(fcp_cmnd_iu, real_bytes);
 
-	if (use_timer)
-		zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
-
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
 		goto failed_scsi_cmnd;
@@ -2435,19 +2427,16 @@ out:
 
 /**
  * zfcp_fsf_send_fcp_ctm - send SCSI task management command
- * @adapter: pointer to struct zfcp-adapter
  * @unit: pointer to struct zfcp_unit
  * @tm_flags: unsigned byte for task management flags
- * @req_flags: int request flags
  * Returns: on success pointer to struct fsf_req, NULL otherwise
  */
-struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *adapter,
-					   struct zfcp_unit *unit,
-					   u8 tm_flags, int req_flags)
+struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *unit, u8 tm_flags)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
@@ -2456,7 +2445,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, 0,
 				  adapter->pool.fsf_req_scsi);
 	if (IS_ERR(req)) {
 		req = NULL;
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 12:42:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 12:42:30.000000000 +0100
@@ -87,8 +87,7 @@ static int zfcp_scsi_queuecommand(struct
 		return 0;;
 	}
 
-	ret = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, 0,
-					     ZFCP_REQ_AUTO_CLEANUP);
+	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
 	if (unlikely(ret == -EBUSY))
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (unlikely(ret < 0))
@@ -145,79 +144,91 @@ out:
 
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
- 	struct Scsi_Host *scsi_host;
- 	struct zfcp_adapter *adapter;
-	struct zfcp_unit *unit;
-	struct zfcp_fsf_req *fsf_req;
+	struct Scsi_Host *scsi_host = scpnt->device->host;
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *) scsi_host->hostdata[0];
+	struct zfcp_unit *unit = scpnt->device->hostdata;
+	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
 	unsigned long old_req_id = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS;
-
-	scsi_host = scpnt->device->host;
-	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
-	unit = scpnt->device->hostdata;
+	int retry = 3;
 
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
-	/* Check whether corresponding fsf_req is still pending */
 	spin_lock(&adapter->req_list_lock);
-	fsf_req = zfcp_reqlist_find(adapter, old_req_id);
+	old_req = zfcp_reqlist_find(adapter, old_req_id);
 	spin_unlock(&adapter->req_list_lock);
-	if (!fsf_req) {
+	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, 0);
-		return retval;
+		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
+					  old_req_id);
+		return SUCCESS;
 	}
-	fsf_req->data = NULL;
+	old_req->data = NULL;
 
 	/* don't access old fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 
-	fsf_req = zfcp_fsf_abort_fcp_command(old_req_id, adapter, unit, 0);
-	if (!fsf_req) {
-		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
-					  old_req_id);
-		retval = FAILED;
-		return retval;
+	while (retry--) {
+		abrt_req = zfcp_fsf_abort_fcp_command(old_req_id, unit);
+		if (abrt_req)
+			break;
+
+		zfcp_erp_wait(adapter);
+		if (!(atomic_read(&adapter->status) &
+		      ZFCP_STATUS_COMMON_RUNNING)) {
+			zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
+						  old_req_id);
+			return SUCCESS;
+		}
 	}
+	if (!abrt_req)
+		return FAILED;
 
-	__wait_event(fsf_req->completion_wq,
-		     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	wait_event(abrt_req->completion_wq,
+		   abrt_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
-		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, fsf_req, 0);
-	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
-		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, fsf_req, 0);
-	} else {
-		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, fsf_req, 0);
+	if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED)
+		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, abrt_req, 0);
+	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
+		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, abrt_req, 0);
+	else {
+		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, abrt_req, 0);
 		retval = FAILED;
 	}
-	zfcp_fsf_req_free(fsf_req);
-
+	zfcp_fsf_req_free(abrt_req);
 	return retval;
 }
 
-static int zfcp_task_mgmt_function(struct zfcp_unit *unit, u8 tm_flags,
-					 struct scsi_cmnd *scpnt)
+static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
+	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 	struct zfcp_fsf_req *fsf_req;
 	int retval = SUCCESS;
+	int retry = 3;
 
-	/* issue task management function */
-	fsf_req = zfcp_fsf_send_fcp_ctm(adapter, unit, tm_flags, 0);
-	if (!fsf_req) {
-		zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit, scpnt);
-		return FAILED;
+	while (retry--) {
+		fsf_req = zfcp_fsf_send_fcp_ctm(unit, tm_flags);
+		if (fsf_req)
+			break;
+
+		zfcp_erp_wait(adapter);
+		if (!(atomic_read(&adapter->status) &
+		      ZFCP_STATUS_COMMON_RUNNING)) {
+			zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit,
+						     scpnt);
+			return SUCCESS;
+		}
 	}
+	if (!fsf_req)
+		return FAILED;
 
-	__wait_event(fsf_req->completion_wq,
-		     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	wait_event(fsf_req->completion_wq,
+		   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	/*
-	 * check completion status of task management function
-	 */
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
 		zfcp_scsi_dbf_event_devreset("fail", tm_flags, unit, scpnt);
 		retval = FAILED;
@@ -228,39 +239,24 @@ static int zfcp_task_mgmt_function(struc
 		zfcp_scsi_dbf_event_devreset("okay", tm_flags, unit, scpnt);
 
 	zfcp_fsf_req_free(fsf_req);
-
 	return retval;
 }
 
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_unit *unit = scpnt->device->hostdata;
-
-	if (!unit) {
-		WARN_ON(1);
-		return SUCCESS;
-	}
-	return zfcp_task_mgmt_function(unit, FCP_LOGICAL_UNIT_RESET, scpnt);
+	return zfcp_task_mgmt_function(scpnt, FCP_LOGICAL_UNIT_RESET);
 }
 
 static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_unit *unit = scpnt->device->hostdata;
-
-	if (!unit) {
-		WARN_ON(1);
-		return SUCCESS;
-	}
-	return zfcp_task_mgmt_function(unit, FCP_TARGET_RESET, scpnt);
+	return zfcp_task_mgmt_function(scpnt, FCP_TARGET_RESET);
 }
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_unit *unit;
-	struct zfcp_adapter *adapter;
+	struct zfcp_unit *unit = scpnt->device->hostdata;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	unit = scpnt->device->hostdata;
-	adapter = unit->port->adapter;
 	zfcp_erp_adapter_reopen(adapter, 0, 141, scpnt);
 	zfcp_erp_wait(adapter);
 

