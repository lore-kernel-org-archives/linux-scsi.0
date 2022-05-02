Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDEDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387776AbiEBVmz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387735AbiEBVmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3E2E0E9
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 161D71F8A8;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1j94lGWvoxcX1wRrhzNbX5t25vbLp3BhH49QfnK1vY=;
        b=kAvy22mdjYq/0TMNS2FSN+i8x6fZe9fKZ/VOKkUfZKAtPbZQFZVsm8DmtbBmZT97bFOubV
        cX1MJTkiAxynneQH+85nnnNPPwYBQsK+BambSimyhgA9QeC6TcfV5Kx1Idl2HouriaQmtX
        lezLnitiWHvl3EhHTapKBj6pGNrfylk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1j94lGWvoxcX1wRrhzNbX5t25vbLp3BhH49QfnK1vY=;
        b=QDUHzxlHbkAQtkk4OSRm+e7GrCwuUENCp+8FCkFmECJied+1CVX9c+UFqk5yFNOE2Cs40Y
        /puWblmPcf7vuJBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DE9722C14E;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DBF605194102; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH 07/24] qedf: use fc rport as argument for qedf_initiate_tmf()
Date:   Mon,  2 May 2022 23:38:03 +0200
Message-Id: <20220502213820.3187-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sending a TMF we're only concerned with the rport and the LUN ID,
so use struct fc_rport as argument for qedf_initiate_tmf().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  5 ++-
 drivers/scsi/qedf/qedf_io.c   | 75 ++++++++++-------------------------
 drivers/scsi/qedf/qedf_main.c | 19 ++++-----
 3 files changed, 33 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index c5c0bbdafc4e..80814bcf4db1 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -112,6 +112,7 @@ struct qedf_ioreq {
 #define QEDF_CMD_ERR_SCSI_DONE		0x5
 	u8 io_req_flags;
 	uint8_t tm_flags;
+	u64 tm_lun;
 	struct qedf_rport *fcport;
 #define	QEDF_CMD_ST_INACTIVE		0
 #define	QEDFC_CMD_ST_IO_ACTIVE		1
@@ -497,7 +498,7 @@ extern void qedf_process_warning_compl(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
 extern void qedf_process_error_detect(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
-extern void qedf_flush_active_ios(struct qedf_rport *fcport, int lun);
+extern void qedf_flush_active_ios(struct qedf_rport *fcport, u64 lun);
 extern void qedf_release_cmd(struct kref *ref);
 extern int qedf_initiate_abts(struct qedf_ioreq *io_req,
 	bool return_scsi_cmd_on_abts);
@@ -522,7 +523,7 @@ extern int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	bool return_scsi_cmd_on_abts);
 extern void qedf_process_cleanup_compl(struct qedf_ctx *qedf,
 	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
-extern int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags);
+extern int qedf_initiate_tmf(struct fc_rport *rport, u64 lun, u8 tm_flags);
 extern void qedf_process_tmf_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	struct qedf_ioreq *io_req);
 extern void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe);
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 2ec1f710fd1d..5d82fd95e74c 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -546,7 +546,7 @@ static int qedf_build_bd_list_from_sg(struct qedf_ioreq *io_req)
 }
 
 static void qedf_build_fcp_cmnd(struct qedf_ioreq *io_req,
-				  struct fcp_cmnd *fcp_cmnd)
+				struct fcp_cmnd *fcp_cmnd)
 {
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 
@@ -554,8 +554,12 @@ static void qedf_build_fcp_cmnd(struct qedf_ioreq *io_req,
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
@@ -1096,7 +1100,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
 	}
 
 	/* The sense buffer can be NULL for TMF commands */
-	if (sc_cmd->sense_buffer) {
+	if (sc_cmd && sc_cmd->sense_buffer) {
 		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, sense_data,
@@ -1581,7 +1585,7 @@ static void qedf_flush_els_req(struct qedf_ctx *qedf,
 /* A value of -1 for lun is a wild card that means flush all
  * active SCSI I/Os for the target.
  */
-void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
+void qedf_flush_active_ios(struct qedf_rport *fcport, u64 lun)
 {
 	struct qedf_ioreq *io_req;
 	struct qedf_ctx *qedf;
@@ -1769,10 +1773,6 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 			kref_put(&io_req->refcount, qedf_release_cmd);
 			continue;
 		}
-		if (lun > -1) {
-			if (io_req->lun != lun)
-				continue;
-		}
 
 		/*
 		 * Use kref_get_unless_zero in the unlikely case the command
@@ -2282,7 +2282,7 @@ void qedf_process_cleanup_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	complete(&io_req->cleanup_done);
 }
 
-static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
+static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 	uint8_t tm_flags)
 {
 	struct qedf_ioreq *io_req;
@@ -2292,17 +2292,10 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	int rc = 0;
 	uint16_t xid;
 	int tmo = 0;
-	int lun = 0;
 	unsigned long flags;
 	struct fcoe_wqe *sqe;
 	u16 sqe_idx;
 
-	if (!sc_cmd) {
-		QEDF_ERR(&qedf->dbg_ctx, "sc_cmd is NULL\n");
-		return FAILED;
-	}
-
-	lun = (int)sc_cmd->device->lun;
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "fcport not offloaded\n");
 		rc = FAILED;
@@ -2322,7 +2315,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 		qedf->target_resets++;
 
 	/* Initialize rest of io_req fields */
-	io_req->sc_cmd = sc_cmd;
+	io_req->sc_cmd = NULL;
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
@@ -2336,6 +2329,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 
 	/* Default is to return a SCSI command when an error occurs */
 	io_req->return_scsi_cmd_on_abts = false;
+	io_req->tm_lun = tm_lun;
 
 	/* Obtain exchange id */
 	xid = io_req->xid;
@@ -2390,7 +2384,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 
 
 	if (tm_flags == FCP_TMF_LUN_RESET)
-		qedf_flush_active_ios(fcport, lun);
+		qedf_flush_active_ios(fcport, tm_lun);
 	else
 		qedf_flush_active_ios(fcport, -1);
 
@@ -2405,23 +2399,18 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	return rc;
 }
 
-int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
+int qedf_initiate_tmf(struct fc_rport *rport, u64 lun, u8 tm_flags)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct qedf_rport *fcport = (struct qedf_rport *)&rp[1];
-	struct qedf_ctx *qedf;
-	struct fc_lport *lport = shost_priv(sc_cmd->device->host);
+	struct qedf_ctx *qedf = fcport->qedf;
+	struct fc_lport *lport = rp->local_port;
 	int rc = SUCCESS;
-	int rval;
-	struct qedf_ioreq *io_req = NULL;
-	int ref_cnt = 0;
 	struct fc_rport_priv *rdata = fcport->rdata;
 
 	QEDF_ERR(NULL,
-		 "tm_flags 0x%x sc_cmd %p op = 0x%02x target_id = 0x%x lun=%d\n",
-		 tm_flags, sc_cmd, sc_cmd->cmd_len ? sc_cmd->cmnd[0] : 0xff,
-		 rport->scsi_target_id, (int)sc_cmd->device->lun);
+		 "tm_flags 0x%x target_id = 0x%x lun=%llu\n",
+		 tm_flags, rport->scsi_target_id, lun);
 
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(NULL, "stale rport\n");
@@ -2432,33 +2421,10 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		 (tm_flags == FCP_TMF_TGT_RESET) ? "TARGET RESET" :
 		 "LUN RESET");
 
-	if (qedf_priv(sc_cmd)->io_req) {
-		io_req = qedf_priv(sc_cmd)->io_req;
-		ref_cnt = kref_read(&io_req->refcount);
-		QEDF_ERR(NULL,
-			 "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
-			 io_req, io_req->xid, ref_cnt);
-	}
-
-	rval = fc_remote_port_chkready(rport);
-	if (rval) {
-		QEDF_ERR(NULL, "device_reset rport not ready\n");
-		rc = FAILED;
-		goto tmf_err;
-	}
-
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_rport(rport);
 	if (rc)
 		goto tmf_err;
 
-	if (!fcport) {
-		QEDF_ERR(NULL, "device_reset: rport is NULL\n");
-		rc = FAILED;
-		goto tmf_err;
-	}
-
-	qedf = fcport->qedf;
-
 	if (!qedf) {
 		QEDF_ERR(NULL, "qedf is NULL.\n");
 		rc = FAILED;
@@ -2495,7 +2461,7 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		goto tmf_err;
 	}
 
-	rc = qedf_execute_tmf(fcport, sc_cmd, tm_flags);
+	rc = qedf_execute_tmf(fcport, lun, tm_flags);
 
 tmf_err:
 	kref_put(&rdata->kref, fc_rport_destroy);
@@ -2512,7 +2478,6 @@ void qedf_process_tmf_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	fcp_rsp = &cqe->cqe_info.rsp_info;
 	qedf_parse_fcp_rsp(io_req, fcp_rsp);
 
-	io_req->sc_cmd = NULL;
 	complete(&io_req->tm_done);
 }
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 18dc68d577b6..85ccfbc5cd26 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -773,7 +773,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 		goto drop_rdata_kref;
 	}
 
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_rport(rport);
 	if (rc)
 		goto drop_rdata_kref;
 
@@ -857,18 +857,19 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 
 static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
 {
-	QEDF_ERR(NULL, "%d:0:%d:%lld: TARGET RESET Issued...",
-		 sc_cmd->device->host->host_no, sc_cmd->device->id,
-		 sc_cmd->device->lun);
-	return qedf_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+
+	QEDF_ERR(NULL, "TARGET RESET Issued...");
+	return qedf_initiate_tmf(rport, 0, FCP_TMF_TGT_RESET);
 }
 
 static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
-	QEDF_ERR(NULL, "%d:0:%d:%lld: LUN RESET Issued... ",
-		 sc_cmd->device->host->host_no, sc_cmd->device->id,
-		 sc_cmd->device->lun);
-	return qedf_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+
+	QEDF_ERR(NULL, "LUN RESET Issued...\n");
+	return qedf_initiate_tmf(rport, sc_cmd->device->lun, FCP_TMF_LUN_RESET);
 }
 
 bool qedf_wait_for_upload(struct qedf_ctx *qedf)
-- 
2.29.2

