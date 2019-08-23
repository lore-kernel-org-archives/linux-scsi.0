Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A0EC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106AF20850
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CBZTkWKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388955AbfHWJwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:52:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732878AbfHWJwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:52:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nWYX002571
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=rlpXThePpss+rcwWLPcI2RKfjKiEOwazMiZChivpY8E=;
 b=CBZTkWKlooz9MEgbOlmXYyiui32E1Sbfkc+56CGyFYYQoELjuPVNfenT4SbLPQbXmHi4
 szkhpvKYVvlc7pHOdrmmeb1BX95iJXDGTfqoUVUYtAmubWrwlCtVshxHzYZC/NGB+vSo
 0u2LdW/rIc5aU8PhRoibgvVP91F47LSSUWst8s/BKpJOWvUclR2J2ZPnBX6H7NPCFqSH
 BFz8N0bX2uR5+vVRGJu61UGrhEGtedbEBvs3Sw1MwfpRjdtuUQtuGwEkdNDsYTEEYVE1
 ZkyymUg1j6yF9ZVWACr1T/hqvsvKb3TKF5ikHSPymtrKFlFrzqoLRToRagtRS1WrzfbP Bw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4072m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:49 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:52:47 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:52:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C0D3E3F703F;
        Fri, 23 Aug 2019 02:52:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9qlSA007869;
        Fri, 23 Aug 2019 02:52:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9qlDN007868;
        Fri, 23 Aug 2019 02:52:47 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 01/14] qedf: Print message during bailout conditions.
Date:   Fri, 23 Aug 2019 02:52:31 -0700
Message-ID: <20190823095244.7830-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Print messages during exiting condition to help
  debugging.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_debugfs.c | 16 +++++------
 drivers/scsi/qedf/qedf_els.c     | 38 ++++++++++++++++++++------
 drivers/scsi/qedf/qedf_fip.c     |  5 +++-
 drivers/scsi/qedf/qedf_io.c      | 58 +++++++++++++++++++++++++++++++++-------
 drivers/scsi/qedf/qedf_main.c    | 53 ++++++++++++++++++++++++++----------
 5 files changed, 130 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index d905a30..b88bed9 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -47,13 +47,13 @@
  * @pf: the pf that is stopping
  **/
 void
-qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf)
+qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf_dbg)
 {
-	QEDF_INFO(qedf, QEDF_LOG_DEBUGFS, "Destroying debugfs host "
+	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "Destroying debugfs host "
 		   "entry\n");
 	/* remove debugfs  entries of this PF */
-	debugfs_remove_recursive(qedf->bdf_dentry);
-	qedf->bdf_dentry = NULL;
+	debugfs_remove_recursive(qedf_dbg->bdf_dentry);
+	qedf_dbg->bdf_dentry = NULL;
 }
 
 /**
@@ -140,10 +140,10 @@
 			loff_t *ppos)
 {
 	int cnt;
-	struct qedf_dbg_ctx *qedf =
+	struct qedf_dbg_ctx *qedf_dbg =
 				(struct qedf_dbg_ctx *)filp->private_data;
 
-	QEDF_INFO(qedf, QEDF_LOG_DEBUGFS, "entered\n");
+	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "debug mask=0x%x\n", qedf_debug);
 	cnt = sprintf(buffer, "debug mask = 0x%x\n", qedf_debug);
 
 	cnt = min_t(int, count, cnt - *ppos);
@@ -158,7 +158,7 @@
 	uint32_t val;
 	void *kern_buf;
 	int rval;
-	struct qedf_dbg_ctx *qedf =
+	struct qedf_dbg_ctx *qedf_dbg =
 	    (struct qedf_dbg_ctx *)filp->private_data;
 
 	if (!count || *ppos)
@@ -178,7 +178,7 @@
 	else
 		qedf_debug = val;
 
-	QEDF_INFO(qedf, QEDF_LOG_DEBUGFS, "Setting debug=0x%x.\n", val);
+	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "Setting debug=0x%x.\n", val);
 	return count;
 }
 
diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 5996f68..87e169d 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -179,8 +179,11 @@ static void qedf_rrq_compl(struct qedf_els_cb_arg *cb_arg)
 
 	orig_io_req = cb_arg->aborted_io_req;
 
-	if (!orig_io_req)
+	if (!orig_io_req) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Original io_req is NULL, rrq_req = %p.\n", rrq_req);
 		goto out_free;
+	}
 
 	if (rrq_req->event != QEDF_IOREQ_EV_ELS_TMO &&
 	    rrq_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
@@ -350,8 +353,10 @@ void qedf_restart_rport(struct qedf_rport *fcport)
 	u32 port_id;
 	unsigned long flags;
 
-	if (!fcport)
+	if (!fcport) {
+		QEDF_ERR(NULL, "fcport is NULL.\n");
 		return;
+	}
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 	if (test_bit(QEDF_RPORT_IN_RESET, &fcport->flags) ||
@@ -418,8 +423,11 @@ static void qedf_l2_els_compl(struct qedf_els_cb_arg *cb_arg)
 	 * If we are flushing the command just free the cb_arg as none of the
 	 * response data will be valid.
 	 */
-	if (els_req->event == QEDF_IOREQ_EV_ELS_FLUSH)
+	if (els_req->event == QEDF_IOREQ_EV_ELS_FLUSH) {
+		QEDF_ERR(NULL, "els_req xid=0x%x event is flush.\n",
+			 els_req->xid);
 		goto free_arg;
+	}
 
 	fcport = els_req->fcport;
 	mp_req = &(els_req->mp_req);
@@ -532,8 +540,10 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 
 	orig_io_req = cb_arg->aborted_io_req;
 
-	if (!orig_io_req)
+	if (!orig_io_req) {
+		QEDF_ERR(NULL, "orig_io_req is NULL.\n");
 		goto out_free;
+	}
 
 	clear_bit(QEDF_CMD_SRR_SENT, &orig_io_req->flags);
 
@@ -547,8 +557,11 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 		   orig_io_req, orig_io_req->xid, srr_req->xid, refcount);
 
 	/* If a SRR times out, simply free resources */
-	if (srr_req->event == QEDF_IOREQ_EV_ELS_TMO)
+	if (srr_req->event == QEDF_IOREQ_EV_ELS_TMO) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "ELS timeout rec_xid=0x%x.\n", srr_req->xid);
 		goto out_put;
+	}
 
 	/* Normalize response data into struct fc_frame */
 	mp_req = &(srr_req->mp_req);
@@ -721,8 +734,11 @@ void qedf_process_seq_cleanup_compl(struct qedf_ctx *qedf,
 	cb_arg = io_req->cb_arg;
 
 	/* If we timed out just free resources */
-	if (io_req->event == QEDF_IOREQ_EV_ELS_TMO || !cqe)
+	if (io_req->event == QEDF_IOREQ_EV_ELS_TMO || !cqe) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "cqe is NULL or timeout event (0x%x)", io_req->event);
 		goto free;
+	}
 
 	/* Kill the timer we put on the request */
 	cancel_delayed_work_sync(&io_req->timeout_work);
@@ -825,8 +841,10 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 
 	orig_io_req = cb_arg->aborted_io_req;
 
-	if (!orig_io_req)
+	if (!orig_io_req) {
+		QEDF_ERR(NULL, "orig_io_req is NULL.\n");
 		goto out_free;
+	}
 
 	if (rec_req->event != QEDF_IOREQ_EV_ELS_TMO &&
 	    rec_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
@@ -838,8 +856,12 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 		   orig_io_req, orig_io_req->xid, rec_req->xid, refcount);
 
 	/* If a REC times out, free resources */
-	if (rec_req->event == QEDF_IOREQ_EV_ELS_TMO)
+	if (rec_req->event == QEDF_IOREQ_EV_ELS_TMO) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Got TMO event, orig_io_req %p orig_io_xid=0x%x.\n",
+			 orig_io_req, orig_io_req->xid);
 		goto out_put;
+	}
 
 	/* Normalize response data into struct fc_frame */
 	mp_req = &(rec_req->mp_req);
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 362d2be..5143d93 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -23,8 +23,11 @@ void qedf_fcoe_send_vlan_req(struct qedf_ctx *qedf)
 	int rc = -1;
 
 	skb = dev_alloc_skb(sizeof(struct fip_vlan));
-	if (!skb)
+	if (!skb) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Failed to allocate skb.\n");
 		return;
+	}
 
 	eth_fr = (char *)skb->data;
 	vlan = (struct fip_vlan *)eth_fr;
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d881e82..5b42892 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -104,6 +104,8 @@ static void qedf_cmd_timeout(struct work_struct *work)
 		qedf_process_seq_cleanup_compl(qedf, NULL, io_req);
 		break;
 	default:
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+			  "Hit default case, xid=0x%x.\n", io_req->xid);
 		break;
 	}
 }
@@ -122,8 +124,10 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	num_ios = max_xid - min_xid + 1;
 
 	/* Free fcoe_bdt_ctx structures */
-	if (!cmgr->io_bdt_pool)
+	if (!cmgr->io_bdt_pool) {
+		QEDF_ERR(&qedf->dbg_ctx, "io_bdt_pool is NULL.\n");
 		goto free_cmd_pool;
+	}
 
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
@@ -226,8 +230,11 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 		io_req->sense_buffer = dma_alloc_coherent(&qedf->pdev->dev,
 		    QEDF_SCSI_SENSE_BUFFERSIZE, &io_req->sense_buffer_dma,
 		    GFP_KERNEL);
-		if (!io_req->sense_buffer)
+		if (!io_req->sense_buffer) {
+			QEDF_ERR(&qedf->dbg_ctx,
+				 "Failed to alloc sense buffer.\n");
 			goto mem_err;
+		}
 
 		/* Allocate task parameters to pass to f/w init funcions */
 		io_req->task_params = kzalloc(sizeof(*io_req->task_params),
@@ -437,8 +444,12 @@ void qedf_release_cmd(struct kref *ref)
 	struct qedf_rport *fcport = io_req->fcport;
 	unsigned long flags;
 
-	if (io_req->cmd_type == QEDF_SCSI_CMD)
+	if (io_req->cmd_type == QEDF_SCSI_CMD) {
+		QEDF_WARN(&fcport->qedf->dbg_ctx,
+			  "Cmd released called without scsi_done called, io_req %p xid=0x%x.\n",
+			  io_req, io_req->xid);
 		WARN_ON(io_req->sc_cmd);
+	}
 
 	if (io_req->cmd_type == QEDF_ELS ||
 	    io_req->cmd_type == QEDF_TASK_MGMT_CMD)
@@ -447,8 +458,10 @@ void qedf_release_cmd(struct kref *ref)
 	atomic_inc(&cmd_mgr->free_list_cnt);
 	atomic_dec(&fcport->num_active_ios);
 	atomic_set(&io_req->state, QEDF_CMD_ST_INACTIVE);
-	if (atomic_read(&fcport->num_active_ios) < 0)
+	if (atomic_read(&fcport->num_active_ios) < 0) {
 		QEDF_WARN(&(fcport->qedf->dbg_ctx), "active_ios < 0.\n");
+		WARN_ON(1);
+	}
 
 	/* Increment task retry identifier now that the request is released */
 	io_req->task_retry_identifier++;
@@ -951,6 +964,9 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	if (test_bit(QEDF_UNLOADING, &qedf->flags) ||
 	    test_bit(QEDF_DBG_STOP_IO, &qedf->flags)) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+			  "Returning DNC as unloading or stop io, flags 0x%lx.\n",
+			  qedf->flags);
 		sc_cmd->result = DID_NO_CONNECT << 16;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
@@ -967,6 +983,9 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+			  "fc_remote_port_chkready failed=0x%x for port_id=0x%06x.\n",
+			  rval, rport->port_id);
 		sc_cmd->result = rval;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
@@ -974,12 +993,14 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	/* Retry command if we are doing a qed drain operation */
 	if (test_bit(QEDF_DRAIN_ACTIVE, &qedf->flags)) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO, "Drain active.\n");
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto exit_qcmd;
 	}
 
 	if (lport->state != LPORT_ST_READY ||
 	    atomic_read(&qedf->link_state) != QEDF_LINK_UP) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO, "Link down.\n");
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto exit_qcmd;
 	}
@@ -1297,8 +1318,10 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	struct scsi_cmnd *sc_cmd;
 	int refcount;
 
-	if (!io_req)
+	if (!io_req) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO, "io_req is NULL\n");
 		return;
+	}
 
 	if (test_and_set_bit(QEDF_CMD_ERR_SCSI_DONE, &io_req->flags)) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
@@ -1414,8 +1437,12 @@ void qedf_process_warning_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	u64 err_warn_bit_map;
 	u8 err_warn = 0xff;
 
-	if (!cqe)
+	if (!cqe) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+			  "cqe is NULL for io_req %p xid=0x%x\n",
+			  io_req, io_req->xid);
 		return;
+	}
 
 	QEDF_ERR(&(io_req->fcport->qedf->dbg_ctx), "Warning CQE, "
 		  "xid=0x%x\n", io_req->xid);
@@ -1477,8 +1504,11 @@ void qedf_process_error_detect(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 {
 	int rval;
 
-	if (!cqe)
+	if (!cqe) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+			  "cqe is NULL for io_req %p\n", io_req);
 		return;
+	}
 
 	QEDF_ERR(&(io_req->fcport->qedf->dbg_ctx), "Error detection CQE, "
 		  "xid=0x%x\n", io_req->xid);
@@ -1543,8 +1573,10 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 	int wait_cnt = 100;
 	int refcount = 0;
 
-	if (!fcport)
+	if (!fcport) {
+		QEDF_ERR(NULL, "fcport is NULL\n");
 		return;
+	}
 
 	/* Check that fcport is still offloaded */
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
@@ -1976,6 +2008,10 @@ void qedf_process_abts_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	clear_bit(QEDF_CMD_IN_ABORT, &io_req->flags);
 
 	if (io_req->sc_cmd) {
+		if (!io_req->return_scsi_cmd_on_abts)
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_SCSI_TM,
+				  "Not call scsi_done for xid=0x%x.\n",
+				  io_req->xid);
 		if (io_req->return_scsi_cmd_on_abts)
 			qedf_scsi_done(qedf, io_req, DID_ERROR);
 	}
@@ -2201,6 +2237,10 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	}
 
 	if (io_req->sc_cmd) {
+		if (!io_req->return_scsi_cmd_on_abts)
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_SCSI_TM,
+				  "Not call scsi_done for xid=0x%x.\n",
+				  io_req->xid);
 		if (io_req->return_scsi_cmd_on_abts)
 			qedf_scsi_done(qedf, io_req, DID_ERROR);
 	}
@@ -2241,7 +2281,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	u16 sqe_idx;
 
 	if (!sc_cmd) {
-		QEDF_ERR(&(qedf->dbg_ctx), "invalid arg\n");
+		QEDF_ERR(&qedf->dbg_ctx, "sc_cmd is NULL\n");
 		return FAILED;
 	}
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a42babd..3e245b0 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -128,8 +128,11 @@ static bool qedf_initiate_fipvlan_req(struct qedf_ctx *qedf)
 			return false;
 		}
 
-		if (qedf->vlan_id > 0)
+		if (qedf->vlan_id > 0) {
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+				  "vlan = 0x%x already set.\n", qedf->vlan_id);
 			return true;
+		}
 
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
 			   "Retry %d.\n", qedf->fipvlan_retries);
@@ -162,6 +165,8 @@ static void qedf_handle_link_update(struct work_struct *work)
 			return;
 
 		if (atomic_read(&qedf->link_state) != QEDF_LINK_UP) {
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+				  "Link is down, resetting vlan_id.\n");
 			qedf->vlan_id = 0;
 			return;
 		}
@@ -311,8 +316,10 @@ int qedf_send_flogi(struct qedf_ctx *qedf)
 
 	lport = qedf->lport;
 
-	if (!lport->tt.elsct_send)
+	if (!lport->tt.elsct_send) {
+		QEDF_ERR(&qedf->dbg_ctx, "tt.elsct_send not set.\n");
 		return -EINVAL;
+	}
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
@@ -2340,12 +2347,14 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	fr_dev(fp) = lport;
 	fr_sof(fp) = hp->fcoe_sof;
 	if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof))) {
+		QEDF_INFO(NULL, QEDF_LOG_LL2, "skb_copy_bits failed.\n");
 		kfree_skb(skb);
 		return;
 	}
 	fr_eof(fp) = crc_eof.fcoe_eof;
 	fr_crc(fp) = crc_eof.fcoe_crc32;
 	if (pskb_trim(skb, fr_len)) {
+		QEDF_INFO(NULL, QEDF_LOG_LL2, "pskb_trim failed.\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -2406,9 +2415,9 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	 * empty then this is not addressed to our port so simply drop it.
 	 */
 	if (lport->port_id != ntoh24(fh->fh_d_id) && !vn_port) {
-		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
-		    "Dropping frame due to destination mismatch: lport->port_id=%x fh->d_id=%x.\n",
-		    lport->port_id, ntoh24(fh->fh_d_id));
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_LL2,
+			  "Dropping frame due to destination mismatch: lport->port_id=0x%x fh->d_id=0x%x.\n",
+			  lport->port_id, ntoh24(fh->fh_d_id));
 		kfree_skb(skb);
 		return;
 	}
@@ -2417,6 +2426,8 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	if ((fh->fh_type == FC_TYPE_BLS) && (f_ctl & FC_FC_SEQ_CTX) &&
 	    (f_ctl & FC_FC_EX_CTX)) {
 		/* Drop incoming ABTS response that has both SEQ/EX CTX set */
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_LL2,
+			  "Dropping ABTS response as both SEQ/EX CTX set.\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -2560,8 +2571,9 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sizeof(struct status_block_e4), &sb_phys, GFP_KERNEL);
 
 	if (!sb_virt) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Status block allocation failed "
-			  "for id = %d.\n", sb_id);
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Status block allocation failed for id = %d.\n",
+			 sb_id);
 		return -ENOMEM;
 	}
 
@@ -2569,8 +2581,9 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Status block initialization "
-			  "failed for id = %d.\n", sb_id);
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Status block initialization failed (0x%x) for id = %d.\n",
+			 ret, sb_id);
 		return ret;
 	}
 
@@ -2654,13 +2667,18 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 	io_req = &qedf->cmd_mgr->cmds[xid];
 
 	/* Completion not for a valid I/O anymore so just return */
-	if (!io_req)
+	if (!io_req) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "io_req is NULL for xid=0x%x.\n", xid);
 		return;
+	}
 
 	fcport = io_req->fcport;
 
 	if (fcport == NULL) {
-		QEDF_ERR(&(qedf->dbg_ctx), "fcport is NULL.\n");
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "fcport is NULL for xid=0x%x io_req=%p.\n",
+			 xid, io_req);
 		return;
 	}
 
@@ -2669,7 +2687,8 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 	 * isn't valid and shouldn't be taken. We should just return.
 	 */
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Session not offloaded yet.\n");
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Session not offloaded yet, fcport = %p.\n", fcport);
 		return;
 	}
 
@@ -2881,6 +2900,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 */
 	if (!qedf->p_cpuq) {
 		status = 1;
+		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
 		goto mem_alloc_failure;
 	}
 
@@ -2896,8 +2916,10 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 
 	/* Allocate DMA coherent buffers for BDQ */
 	rc = qedf_alloc_bdq(qedf);
-	if (rc)
+	if (rc) {
+		QEDF_ERR(&qedf->dbg_ctx, "Unable to allocate bdq.\n");
 		goto mem_alloc_failure;
+	}
 
 	/* Allocate a CQ and an associated PBL for each MSI-X vector */
 	for (i = 0; i < qedf->num_queues; i++) {
@@ -3209,6 +3231,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	qed_params.is_vf = is_vf;
 	qedf->cdev = qed_ops->common->probe(pdev, &qed_params);
 	if (!qedf->cdev) {
+		QEDF_ERR(&qedf->dbg_ctx, "common probe failed.\n");
 		rc = -ENODEV;
 		goto err1;
 	}
@@ -3277,8 +3300,10 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 	/* Setup interrupts */
 	rc = qedf_setup_int(qedf);
-	if (rc)
+	if (rc) {
+		QEDF_ERR(&qedf->dbg_ctx, "Setup interrupts failed.\n");
 		goto err3;
+	}
 
 	rc = qed_ops->start(qedf->cdev, &qedf->tasks);
 	if (rc) {
-- 
1.8.3.1

