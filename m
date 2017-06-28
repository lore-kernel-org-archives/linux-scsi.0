From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/47] qedf: use fc rport as argument for qedf_initiate_tmf()
Date: Wed, 28 Jun 2017 10:32:55 +0200
Message-ID: <1498638793-44672-30-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53835 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF1IdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:22 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When sending a TMF we're only concerned with the rport and the LUN ID,
so use struct fc_rport as argument for qedf_initiate_tmf().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qedf/qedf.h      |  5 +++--
 drivers/scsi/qedf/qedf_io.c   | 48 +++++++++++++++++++------------------------
 drivers/scsi/qedf/qedf_main.c |  9 ++++++--
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 4d03892..dcd51d6 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -119,6 +119,7 @@ struct qedf_ioreq {
 #define QEDF_CMD_SRR_SENT		0x3
 	u8 io_req_flags;
 	uint8_t tm_flags;
+	u64 tm_lun;
 	struct qedf_rport *fcport;
 	unsigned long flags;
 	enum qedf_ioreq_event event;
@@ -453,7 +454,7 @@ extern void qedf_process_warning_compl(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
 extern void qedf_process_error_detect(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
-extern void qedf_flush_active_ios(struct qedf_rport *fcport, int lun);
+extern void qedf_flush_active_ios(struct qedf_rport *fcport, u64 lun);
 extern void qedf_release_cmd(struct kref *ref);
 extern int qedf_initiate_abts(struct qedf_ioreq *io_req,
 	bool return_scsi_cmd_on_abts);
@@ -478,7 +479,7 @@ extern int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	bool return_scsi_cmd_on_abts);
 extern void qedf_process_cleanup_compl(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
-extern int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags);
+extern int qedf_initiate_tmf(struct fc_rport *rport, u64 lun, u8 tm_flags);
 extern void qedf_process_tmf_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	struct qedf_ioreq *io_req);
 extern void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe);
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index ded3860..df7cbe9 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -541,7 +541,7 @@ static int qedf_build_bd_list_from_sg(struct qedf_ioreq *io_req)
 }
 
 static void qedf_build_fcp_cmnd(struct qedf_ioreq *io_req,
-				  struct fcp_cmnd *fcp_cmnd)
+				struct fcp_cmnd *fcp_cmnd)
 {
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 
@@ -549,8 +549,12 @@ static void qedf_build_fcp_cmnd(struct qedf_ioreq *io_req,
 	memset(fcp_cmnd, 0, FCP_CMND_LEN);
 
 	/* 8 bytes: SCSI LUN info */
-	int_to_scsilun(sc_cmd->device->lun,
-			(struct scsi_lun *)&fcp_cmnd->fc_lun);
+	if (io_req->cmd_type == QEDF_TASK_MGMT_CMD)
+		int_to_scsilun(io_req->tm_lun,
+			       (struct scsi_lun *)&fcp_cmnd->fc_lun);
+	else
+		int_to_scsilun(sc_cmd->device->lun,
+			       (struct scsi_lun *)&fcp_cmnd->fc_lun);
 
 	/* 4 bytes: flag info */
 	fcp_cmnd->fc_pri_ta = 0;
@@ -1010,8 +1014,9 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
 		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-	    fcp_rsp->scsi_status_code;
+	if (sc_cmd)
+		CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
+			fcp_rsp->scsi_status_code;
 
 	if (rsp_flags &
 	    FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID)
@@ -1042,7 +1047,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
 	}
 
 	/* The sense buffer can be NULL for TMF commands */
-	if (sc_cmd->sense_buffer) {
+	if (sc_cmd && sc_cmd->sense_buffer) {
 		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, sense_data,
@@ -1404,7 +1409,7 @@ static void qedf_flush_els_req(struct qedf_ctx *qedf,
 /* A value of -1 for lun is a wild card that means flush all
  * active SCSI I/Os for the target.
  */
-void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
+void qedf_flush_active_ios(struct qedf_rport *fcport, u64 lun)
 {
 	struct qedf_ioreq *io_req;
 	struct qedf_ctx *qedf;
@@ -1444,11 +1449,9 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 
 		if (!io_req->sc_cmd)
 			continue;
-		if (lun > 0) {
-			if (io_req->sc_cmd->device->lun !=
-			    (u64)lun)
-				continue;
-		}
+		if ((lun != (u64)-1) && io_req->sc_cmd &&
+		    io_req->sc_cmd->device->lun != lun)
+			continue;
 
 		/*
 		 * Use kref_get_unless_zero in the unlikely case the command
@@ -1831,7 +1834,7 @@ void qedf_process_cleanup_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	complete(&io_req->tm_done);
 }
 
-static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
+static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 	uint8_t tm_flags)
 {
 	struct qedf_ioreq *io_req;
@@ -1845,11 +1848,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	struct fcoe_wqe *sqe;
 	u16 sqe_idx;
 
-	if (!sc_cmd) {
-		QEDF_ERR(&(qedf->dbg_ctx), "invalid arg\n");
-		return FAILED;
-	}
-
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "fcport not offloaded\n");
 		rc = FAILED;
@@ -1867,7 +1865,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	}
 
 	/* Initialize rest of io_req fields */
-	io_req->sc_cmd = sc_cmd;
+	io_req->sc_cmd = NULL;
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
@@ -1878,9 +1876,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
 	io_req->tm_flags = tm_flags;
-
-	/* Default is to return a SCSI command when an error occurs */
-	io_req->return_scsi_cmd_on_abts = true;
+	io_req->tm_lun = tm_lun;
 
 	/* Obtain exchange id */
 	xid = io_req->xid;
@@ -1919,7 +1915,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	}
 
 	if (tm_flags == FCP_TMF_LUN_RESET)
-		qedf_flush_active_ios(fcport, (int)sc_cmd->device->lun);
+		qedf_flush_active_ios(fcport, tm_lun);
 	else
 		qedf_flush_active_ios(fcport, -1);
 
@@ -1936,9 +1932,8 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	return rc;
 }
 
-int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
+int qedf_initiate_tmf(struct fc_rport *rport, u64 lun, u8 tm_flags)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct qedf_rport *fcport = (struct qedf_rport *)&rp[1];
 	struct qedf_ctx *qedf;
@@ -1975,7 +1970,7 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		goto tmf_err;
 	}
 
-	rc = qedf_execute_tmf(fcport, sc_cmd, tm_flags);
+	rc = qedf_execute_tmf(fcport, lun, tm_flags);
 
 tmf_err:
 	return rc;
@@ -1989,7 +1984,6 @@ void qedf_process_tmf_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	fcp_rsp = &cqe->cqe_info.rsp_info;
 	qedf_parse_fcp_rsp(io_req, fcp_rsp);
 
-	io_req->sc_cmd = NULL;
 	complete(&io_req->tm_done);
 }
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index b06ef7c..a0853ac 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -619,14 +619,19 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 
 static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
 {
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+
 	QEDF_ERR(NULL, "TARGET RESET Issued...");
-	return qedf_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
+	return qedf_initiate_tmf(rport, 0, FCP_TMF_TGT_RESET);
 }
 
 static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+
 	QEDF_ERR(NULL, "LUN RESET Issued...\n");
-	return qedf_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
+	return qedf_initiate_tmf(rport, sc_cmd->device->lun, FCP_TMF_LUN_RESET);
 }
 
 void qedf_wait_for_upload(struct qedf_ctx *qedf)
-- 
1.8.5.6
