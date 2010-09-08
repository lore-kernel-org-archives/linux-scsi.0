From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/12] zfcp: Reorder FCP I/O and task management handler functions
Date: Wed, 08 Sep 2010 14:39:58 +0200
Message-ID: <20100908124353.916771041@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56817 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab0IHMn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:56 -0400
Content-Disposition: inline; filename=708-zfcp-task-mngt-reorder.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Instead of calling the same handler for both, I/O and task management
commands, use different handlers that call a function for the common
part.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |  147 +++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 75 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:30.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:30.000000000 +0200
@@ -2080,73 +2080,7 @@ static void zfcp_fsf_req_trace(struct zf
 			    sizeof(blktrc));
 }
 
-static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
-{
-	struct scsi_cmnd *scpnt;
-	struct fcp_resp_with_ext *fcp_rsp;
-	unsigned long flags;
-
-	read_lock_irqsave(&req->adapter->abort_lock, flags);
-
-	scpnt = req->data;
-	if (unlikely(!scpnt)) {
-		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
-		return;
-	}
-
-	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
-		goto skip_fsfstatus;
-	}
-
-	switch (req->qtcb->header.fsf_status) {
-	case FSF_INCONSISTENT_PROT_DATA:
-	case FSF_INVALID_PROT_PARM:
-		set_host_byte(scpnt, DID_ERROR);
-		goto skip_fsfstatus;
-	case FSF_BLOCK_GUARD_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x1);
-		goto skip_fsfstatus;
-	case FSF_APP_TAG_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x2);
-		goto skip_fsfstatus;
-	case FSF_REF_TAG_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x3);
-		goto skip_fsfstatus;
-	}
-	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
-	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
-
-skip_fsfstatus:
-	zfcp_fsf_req_trace(req, scpnt);
-	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
-
-	scpnt->host_scribble = NULL;
-	(scpnt->scsi_done) (scpnt);
-	/*
-	 * We must hold this lock until scsi_done has been called.
-	 * Otherwise we may call scsi_done after abort regarding this
-	 * command has completed.
-	 * Note: scsi_done must not block!
-	 */
-	read_unlock_irqrestore(&req->adapter->abort_lock, flags);
-}
-
-static void zfcp_fsf_send_fcp_ctm_handler(struct zfcp_fsf_req *req)
-{
-	struct fcp_resp_with_ext *fcp_rsp;
-	struct fcp_resp_rsp_info *rsp_info;
-
-	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
-	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
-
-	if ((rsp_info->rsp_code != FCP_TMF_CMPL) ||
-	     (req->status & ZFCP_STATUS_FSFREQ_ERROR))
-		req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
-}
-
-
-static void zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *req)
+static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
 {
 	struct scsi_cmnd *scmnd = req->data;
 	struct scsi_device *sdev = scmnd->device;
@@ -2154,7 +2088,7 @@ static void zfcp_fsf_send_fcp_command_ha
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
-		goto skip_fsfstatus;
+		return;
 
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
@@ -2211,12 +2145,60 @@ static void zfcp_fsf_send_fcp_command_ha
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
-skip_fsfstatus:
-	if (req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
-		zfcp_fsf_send_fcp_ctm_handler(req);
-	else {
-		zfcp_fsf_send_fcp_command_task_handler(req);
+}
+
+static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
+{
+	struct scsi_cmnd *scpnt;
+	struct fcp_resp_with_ext *fcp_rsp;
+	unsigned long flags;
+
+	zfcp_fsf_fcp_handler_common(req);
+
+	read_lock_irqsave(&req->adapter->abort_lock, flags);
+
+	scpnt = req->data;
+	if (unlikely(!scpnt)) {
+		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
+		return;
 	}
+
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
+		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
+		goto skip_fsfstatus;
+	}
+
+	switch (req->qtcb->header.fsf_status) {
+	case FSF_INCONSISTENT_PROT_DATA:
+	case FSF_INVALID_PROT_PARM:
+		set_host_byte(scpnt, DID_ERROR);
+		goto skip_fsfstatus;
+	case FSF_BLOCK_GUARD_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x1);
+		goto skip_fsfstatus;
+	case FSF_APP_TAG_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x2);
+		goto skip_fsfstatus;
+	case FSF_REF_TAG_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x3);
+		goto skip_fsfstatus;
+	}
+	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
+
+skip_fsfstatus:
+	zfcp_fsf_req_trace(req, scpnt);
+	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
+
+	scpnt->host_scribble = NULL;
+	(scpnt->scsi_done) (scpnt);
+	/*
+	 * We must hold this lock until scsi_done has been called.
+	 * Otherwise we may call scsi_done after abort regarding this
+	 * command has completed.
+	 * Note: scsi_done must not block!
+	 */
+	read_unlock_irqrestore(&req->adapter->abort_lock, flags);
 }
 
 static int zfcp_fsf_set_data_dir(struct scsi_cmnd *scsi_cmnd, u32 *data_dir)
@@ -2299,7 +2281,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *
 	io = &req->qtcb->bottom.io;
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	req->data = scsi_cmnd;
-	req->handler = zfcp_fsf_send_fcp_command_handler;
+	req->handler = zfcp_fsf_fcp_cmnd_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
 	io->service_class = FSF_CLASS_3;
@@ -2345,6 +2327,21 @@ out:
 	return retval;
 }
 
+static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
+{
+	struct fcp_resp_with_ext *fcp_rsp;
+	struct fcp_resp_rsp_info *rsp_info;
+
+	zfcp_fsf_fcp_handler_common(req);
+
+	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
+
+	if ((rsp_info->rsp_code != FCP_TMF_CMPL) ||
+	     (req->status & ZFCP_STATUS_FSFREQ_ERROR))
+		req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
+}
+
 /**
  * zfcp_fsf_fcp_task_mgmt - send SCSI task management command
  * @scmnd: SCSI command to send the task management command for
@@ -2378,7 +2375,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
 	req->data = scmnd;
-	req->handler = zfcp_fsf_send_fcp_command_handler;
+	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
 	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;

