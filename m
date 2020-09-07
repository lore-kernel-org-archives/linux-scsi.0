Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D325BC43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D1D2137B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MLyAR4iv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgIGMVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 08:21:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729300AbgIGMS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:18:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C4k1v017157
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:18:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=sEgIrWB3xjY+QDsgmvf2aemGpbqEVfh6pQ16xEs7344=;
 b=MLyAR4ivLi1Wecc61SAmc/8VtyBbcMyeFFrtuCVq6+PUDH4xcSukNIDkJ2jZFdFKOPNy
 H8fi54ooQ7k/RnDtFF3PJBxzFM+SlFXY/ul4cwonCemgcftoxgutrI8pMSLF4NGhPD+R
 ok8rhCYULdkcxhgDsioX+Pcdefm+9NRBpnw9Xe7ohd4zVDBpR4Jhdjq37tlo0gHIBwbN
 0+pW5dYuI9H07jUKzXwVcIiyiVDjMEAd5FsrO3HUr/WG/LeucQqEd8jDaHN/KrVv1hA+
 HxUXo+dJyT4A3VpRtTY8wKDgknn6h6afGNuf39uTZ71LIeOI80L8ZYHtbgoo4loIjZNd TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqxnh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:18:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:18:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:18:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:18:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 01A4C3F703F;
        Mon,  7 Sep 2020 05:18:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CIKPs005250;
        Mon, 7 Sep 2020 05:18:20 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CIK56005249;
        Mon, 7 Sep 2020 05:18:20 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 8/8] qedf: Changes the %p to %px to print pointers
Date:   Mon, 7 Sep 2020 05:14:43 -0700
Message-ID: <20200907121443.5150-9-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 Changed all the pointer address printing method from 
  %p to %px to print unmodified addresses.
 

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_els.c  | 22 ++++++++---------
 drivers/scsi/qedf/qedf_fip.c  |  2 +-
 drivers/scsi/qedf/qedf_io.c   | 56 +++++++++++++++++++++----------------------
 drivers/scsi/qedf/qedf_main.c | 44 +++++++++++++++++-----------------
 4 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 625e58c..04f37d0 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -63,7 +63,7 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "initiate_els els_req = "
-		   "0x%p cb_arg = %p xid = %x\n", els_req, cb_arg,
+		   "0x%px cb_arg = %px xid = %x\n", els_req, cb_arg,
 		   els_req->xid);
 	els_req->sc_cmd = NULL;
 	els_req->cmd_type = QEDF_ELS;
@@ -204,12 +204,12 @@ static void qedf_rrq_compl(struct qedf_els_cb_arg *cb_arg)
 
 	if (!orig_io_req) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Original io_req is NULL, rrq_req = %p.\n", rrq_req);
+			 "Original io_req is NULL, rrq_req = %px.\n", rrq_req);
 		goto out_free;
 	}
 
 	refcount = kref_read(&orig_io_req->refcount);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "rrq_compl: orig io = %p,"
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "rrq_compl: orig io = %px,"
 		   " orig xid = 0x%x, rrq_xid = 0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, rrq_req->xid, refcount);
 
@@ -283,7 +283,7 @@ int qedf_send_rrq(struct qedf_ioreq *aborted_io_req)
 	refcount = kref_read(&aborted_io_req->refcount);
 	if (refcount != 1) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_ELS,
-			  "refcount for xid=%x io_req=%p refcount=%d is not 1.\n",
+			  "refcount for xid=%x io_req=%px refcount=%d is not 1.\n",
 			  aborted_io_req->xid, aborted_io_req, refcount);
 		return -EINVAL;
 	}
@@ -293,7 +293,7 @@ int qedf_send_rrq(struct qedf_ioreq *aborted_io_req)
 	r_a_tov = lport->r_a_tov;
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending RRQ orig "
-		   "io = %p, orig_xid = 0x%x\n", aborted_io_req,
+		   "io = %px, orig_xid = 0x%x\n", aborted_io_req,
 		   aborted_io_req->xid);
 	memset(&rrq, 0, sizeof(rrq));
 
@@ -381,7 +381,7 @@ void qedf_restart_rport(struct qedf_rport *fcport)
 	if (test_bit(QEDF_RPORT_IN_RESET, &fcport->flags) ||
 	    !test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags) ||
 	    test_bit(QEDF_RPORT_UPLOADING_CONNECTION, &fcport->flags)) {
-		QEDF_ERR(&(fcport->qedf->dbg_ctx), "fcport %p already in reset or not offloaded.\n",
+		QEDF_ERR(&(fcport->qedf->dbg_ctx), "fcport %px already in reset or not offloaded.\n",
 		    fcport);
 		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 		return;
@@ -567,7 +567,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 		cancel_delayed_work_sync(&orig_io_req->timeout_work);
 
 	refcount = kref_read(&orig_io_req->refcount);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%p,"
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%px,"
 		   " orig_io_xid=0x%x, rec_xid=0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, srr_req->xid, refcount);
 
@@ -655,7 +655,7 @@ static int qedf_send_srr(struct qedf_ioreq *orig_io_req, u32 offset, u8 r_ctl)
 	lport = qedf->lport;
 	r_a_tov = lport->r_a_tov;
 
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending SRR orig_io=%p, "
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending SRR orig_io=%px, "
 		   "orig_xid=0x%x\n", orig_io_req, orig_io_req->xid);
 	memset(&srr, 0, sizeof(srr));
 
@@ -866,14 +866,14 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 		cancel_delayed_work_sync(&orig_io_req->timeout_work);
 
 	refcount = kref_read(&orig_io_req->refcount);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%p,"
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%px,"
 		   " orig_io_xid=0x%x, rec_xid=0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, rec_req->xid, refcount);
 
 	/* If a REC times out, free resources */
 	if (rec_req->event == QEDF_IOREQ_EV_ELS_TMO) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Got TMO event, orig_io_req %p orig_io_xid=0x%x.\n",
+			 "Got TMO event, orig_io_req %px orig_io_xid=0x%x.\n",
 			 orig_io_req, orig_io_req->xid);
 		goto out_put;
 	}
@@ -1049,7 +1049,7 @@ int qedf_send_rec(struct qedf_ioreq *orig_io_req)
 	rec.rec_rx_id =
 	    htons(orig_io_req->task->tstorm_st_context.read_write.rx_id);
 
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending REC orig_io=%p, "
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending REC orig_io=%px, "
 	   "orig_xid=0x%x rx_id=0x%x\n", orig_io_req,
 	   orig_io_req->xid, rec.rec_rx_id);
 	rc = qedf_initiate_els(fcport, ELS_REC, &rec, sizeof(rec),
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index ad6a56c..b2e44bf 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -189,7 +189,7 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 	sub = fiph->fip_subcode;
 
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_LL2,
-		  "FIP frame received: skb=%p fiph=%p source=%pM destn=%pM op=%x sub=%x vlan=%04x",
+		  "FIP frame received: skb=%px fiph=%px source=%pM destn=%pM op=%x sub=%x vlan=%04x",
 		  skb, fiph, eth_hdr->h_source, eth_hdr->h_dest, op,
 		  sub, vlan);
 	if (qedf_dump_frames)
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 86c8afb..4fba5cc 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -444,7 +444,7 @@ void qedf_release_cmd(struct kref *ref)
 
 	if (io_req->cmd_type == QEDF_SCSI_CMD) {
 		QEDF_WARN(&fcport->qedf->dbg_ctx,
-			  "Cmd released called without scsi_done called, io_req %p xid=0x%x.\n",
+			  "Cmd released called without scsi_done called, io_req %px xid=0x%x.\n",
 			  io_req, io_req->xid);
 		WARN_ON(io_req->sc_cmd);
 	}
@@ -968,7 +968,7 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	if (!qedf->pdev->msix_enabled) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
-		    "Completing sc_cmd=%p DID_NO_CONNECT as MSI-X is not enabled.\n",
+		    "Completing sc_cmd=%px DID_NO_CONNECT as MSI-X is not enabled.\n",
 		    sc_cmd);
 		sc_cmd->result = DID_NO_CONNECT << 16;
 		sc_cmd->scsi_done(sc_cmd);
@@ -1163,19 +1163,19 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 
 	if (!sc_cmd->device) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Device for sc_cmd %p is NULL.\n", sc_cmd);
+			 "Device for sc_cmd %px is NULL.\n", sc_cmd);
 		return;
 	}
 
 	if (!sc_cmd->request) {
 		QEDF_WARN(&(qedf->dbg_ctx), "sc_cmd->request is NULL, "
-		    "sc_cmd=%p.\n", sc_cmd);
+		    "sc_cmd=%px.\n", sc_cmd);
 		return;
 	}
 
 	if (!sc_cmd->request->q) {
 		QEDF_WARN(&(qedf->dbg_ctx), "request->q is NULL so request "
-		   "is not valid, sc_cmd=%p.\n", sc_cmd);
+		   "is not valid, sc_cmd=%px.\n", sc_cmd);
 		return;
 	}
 
@@ -1342,7 +1342,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	if (test_and_set_bit(QEDF_CMD_ERR_SCSI_DONE, &io_req->flags)) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-			  "io_req:%p scsi_done handling already done\n",
+			  "io_req:%px scsi_done handling already done\n",
 			  io_req);
 		return;
 	}
@@ -1361,7 +1361,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	}
 
 	if (!virt_addr_valid(sc_cmd)) {
-		QEDF_ERR(&qedf->dbg_ctx, "sc_cmd=%p is not valid.", sc_cmd);
+		QEDF_ERR(&qedf->dbg_ctx, "sc_cmd=%px is not valid.", sc_cmd);
 		goto bad_scsi_ptr;
 	}
 
@@ -1372,34 +1372,34 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	}
 
 	if (!sc_cmd->device) {
-		QEDF_ERR(&qedf->dbg_ctx, "Device for sc_cmd %p is NULL.\n",
+		QEDF_ERR(&qedf->dbg_ctx, "Device for sc_cmd %px is NULL.\n",
 			 sc_cmd);
 		goto bad_scsi_ptr;
 	}
 
 	if (!virt_addr_valid(sc_cmd->device)) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Device pointer for sc_cmd %p is bad.\n", sc_cmd);
+			 "Device pointer for sc_cmd %px is bad.\n", sc_cmd);
 		goto bad_scsi_ptr;
 	}
 
 	if (!sc_cmd->sense_buffer) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "sc_cmd->sense_buffer for sc_cmd %p is NULL.\n",
+			 "sc_cmd->sense_buffer for sc_cmd %px is NULL.\n",
 			 sc_cmd);
 		goto bad_scsi_ptr;
 	}
 
 	if (!virt_addr_valid(sc_cmd->sense_buffer)) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "sc_cmd->sense_buffer for sc_cmd %p is bad.\n",
+			 "sc_cmd->sense_buffer for sc_cmd %px is bad.\n",
 			 sc_cmd);
 		goto bad_scsi_ptr;
 	}
 
 	if (!sc_cmd->scsi_done) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "sc_cmd->scsi_done for sc_cmd %p is NULL.\n",
+			 "sc_cmd->scsi_done for sc_cmd %px is NULL.\n",
 			 sc_cmd);
 		goto bad_scsi_ptr;
 	}
@@ -1409,7 +1409,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	sc_cmd->result = result << 16;
 	refcount = kref_read(&io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%lld: Completing "
-	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
+	    "sc_cmd=%px result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
 	    "allowed=%d retries=%d refcount=%d.\n",
 	    qedf->lport->host->host_no, sc_cmd->device->id,
 	    sc_cmd->device->lun, sc_cmd, sc_cmd->result, sc_cmd->cmnd[0],
@@ -1455,7 +1455,7 @@ void qedf_process_warning_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 
 	if (!cqe) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-			  "cqe is NULL for io_req %p xid=0x%x\n",
+			  "cqe is NULL for io_req %px xid=0x%x\n",
 			  io_req, io_req->xid);
 		return;
 	}
@@ -1522,7 +1522,7 @@ void qedf_process_error_detect(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 
 	if (!cqe) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-			  "cqe is NULL for io_req %p\n", io_req);
+			  "cqe is NULL for io_req %px\n", io_req);
 		return;
 	}
 
@@ -1629,7 +1629,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 	cmd_mgr = qedf->cmd_mgr;
 
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-		  "Flush active i/o's num=0x%x fcport=0x%p port_id=0x%06x scsi_id=%d.\n",
+		  "Flush active i/o's num=0x%x fcport=0x%px port_id=0x%06x scsi_id=%d.\n",
 		  atomic_read(&fcport->num_active_ios), fcport,
 		  fcport->rdata->ids.port_id, fcport->rport->scsi_target_id);
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO, "Locking flush mutex.\n");
@@ -1702,7 +1702,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 			rc = kref_get_unless_zero(&io_req->refcount);
 			if (!rc) {
 				QEDF_ERR(&(qedf->dbg_ctx),
-				    "Could not get kref for ELS io_req=0x%p xid=0x%x.\n",
+				    "Could not get kref for ELS io_req=0x%px xid=0x%x.\n",
 				    io_req, io_req->xid);
 				continue;
 			}
@@ -1722,7 +1722,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 			rc = kref_get_unless_zero(&io_req->refcount);
 			if (!rc) {
 				QEDF_ERR(&(qedf->dbg_ctx),
-				    "Could not get kref for abort io_req=0x%p xid=0x%x.\n",
+				    "Could not get kref for abort io_req=0x%px xid=0x%x.\n",
 				    io_req, io_req->xid);
 				continue;
 			}
@@ -1760,7 +1760,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 			continue;
 		if (!io_req->sc_cmd->device) {
 			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-				  "Device backpointer NULL for sc_cmd=%p.\n",
+				  "Device backpointer NULL for sc_cmd=%px.\n",
 				  io_req->sc_cmd);
 			/* Put reference for non-existent scsi_cmnd */
 			io_req->sc_cmd = NULL;
@@ -1780,7 +1780,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 		rc = kref_get_unless_zero(&io_req->refcount);
 		if (!rc) {
 			QEDF_ERR(&(qedf->dbg_ctx), "Could not get kref for "
-			    "io_req=0x%p xid=0x%x\n", io_req, io_req->xid);
+			    "io_req=0x%px xid=0x%x\n", io_req, io_req->xid);
 			continue;
 		}
 
@@ -1822,7 +1822,7 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 						set_bit(QEDF_CMD_DIRTY,
 							&io_req->flags);
 						QEDF_ERR(&qedf->dbg_ctx,
-							 "Outstanding io_req =%p xid=0x%x flags=0x%lx, sc_cmd=%p refcount=%d cmd_type=%d.\n",
+							 "Outstanding io_req =%px xid=0x%x flags=0x%lx, sc_cmd=%px refcount=%d cmd_type=%d.\n",
 							 io_req, io_req->xid,
 							 io_req->flags,
 							 io_req->sc_cmd,
@@ -1908,7 +1908,7 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 	    test_bit(QEDF_CMD_IN_CLEANUP, &io_req->flags) ||
 	    test_bit(QEDF_CMD_IN_ABORT, &io_req->flags)) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "io_req xid=0x%x sc_cmd=%p already in cleanup or abort processing or already completed.\n",
+			 "io_req xid=0x%x sc_cmd=%px already in cleanup or abort processing or already completed.\n",
 			 io_req->xid, io_req->sc_cmd);
 		rc = 1;
 		goto drop_rdata_kref;
@@ -2206,7 +2206,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	refcount = kref_read(&io_req->refcount);
 
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-		  "Entered xid=0x%x sc_cmd=%p cmd_type=%d flags=0x%lx refcount=%d fcport=%p port_id=0x%06x\n",
+		  "Entered xid=0x%x sc_cmd=%px cmd_type=%d flags=0x%lx refcount=%d fcport=%px port_id=0x%06x\n",
 		  io_req->xid, io_req->sc_cmd, io_req->cmd_type, io_req->flags,
 		  refcount, fcport, fcport->rdata->ids.port_id);
 
@@ -2418,7 +2418,7 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	struct fc_rport_priv *rdata = fcport->rdata;
 
 	QEDF_ERR(NULL,
-		 "tm_flags 0x%x sc_cmd %p op = 0x%02x target_id = 0x%x lun=%d\n",
+		 "tm_flags 0x%x sc_cmd %px op = 0x%02x target_id = 0x%x lun=%d\n",
 		 tm_flags, sc_cmd, sc_cmd->cmd_len ? sc_cmd->cmnd[0] : 0xff,
 		 rport->scsi_target_id, (int)sc_cmd->device->lun);
 
@@ -2435,7 +2435,7 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
 		ref_cnt = kref_read(&io_req->refcount);
 		QEDF_ERR(NULL,
-			 "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
+			 "orig io_req = %px xid = 0x%x ref_cnt = %d.\n",
 			 io_req, io_req->xid, ref_cnt);
 	}
 
@@ -2484,11 +2484,11 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 
 	if (test_bit(QEDF_RPORT_UPLOADING_CONNECTION, &fcport->flags)) {
 		if (!fcport->rdata)
-			QEDF_ERR(&qedf->dbg_ctx, "fcport %p is uploading.\n",
+			QEDF_ERR(&qedf->dbg_ctx, "fcport %px is uploading.\n",
 				 fcport);
 		else
 			QEDF_ERR(&qedf->dbg_ctx,
-				 "fcport %p port_id=%06x is uploading.\n",
+				 "fcport %px port_id=%06x is uploading.\n",
 				 fcport, fcport->rdata->ids.port_id);
 		rc = FAILED;
 		goto tmf_err;
@@ -2553,7 +2553,7 @@ void qedf_process_unsol_compl(struct qedf_ctx *qedf, uint16_t que_idx,
 
 	if (qedf_dump_frames) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_UNSOL,
-		    "BDQ frame is at addr=%p.\n", bdq_addr);
+		    "BDQ frame is at addr=%px.\n", bdq_addr);
 		print_hex_dump(KERN_WARNING, "bdq ", DUMP_PREFIX_OFFSET, 16, 1,
 		    (void *)bdq_addr, pktlen, false);
 	}
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 091cf86..b3f691b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -710,7 +710,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	fcport = (struct qedf_rport *)&rp[1];
 	rdata = fcport->rdata;
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
-		QEDF_ERR(&qedf->dbg_ctx, "stale rport, sc_cmd=%p\n", sc_cmd);
+		QEDF_ERR(&qedf->dbg_ctx, "stale rport, sc_cmd=%px\n", sc_cmd);
 		rc = SUCCESS;
 		goto out;
 	}
@@ -719,7 +719,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
 	if (!io_req) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "sc_cmd not queued with lld, sc_cmd=%p op=0x%02x, port_id=%06x\n",
+			 "sc_cmd not queued with lld, sc_cmd=%px op=0x%02x, port_id=%06x\n",
 			 sc_cmd, sc_cmd->cmnd[0],
 			 rdata->ids.port_id);
 		rc = SUCCESS;
@@ -733,7 +733,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	/* If we got a valid io_req, confirm it belongs to this sc_cmd. */
 	if (!rval || io_req->sc_cmd != sc_cmd) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Freed/Incorrect io_req, io_req->sc_cmd=%p, sc_cmd=%p, port_id=%06x, bailing out.\n",
+			 "Freed/Incorrect io_req, io_req->sc_cmd=%px, sc_cmd=%px, port_id=%06x, bailing out.\n",
 			 io_req->sc_cmd, sc_cmd, rdata->ids.port_id);
 
 		goto drop_rdata_kref;
@@ -742,7 +742,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	if (fc_remote_port_chkready(rport)) {
 		refcount = kref_read(&io_req->refcount);
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "rport not ready, io_req=%p, xid=0x%x sc_cmd=%p op=0x%02x, refcount=%d, port_id=%06x\n",
+			 "rport not ready, io_req=%px, xid=0x%x sc_cmd=%px op=0x%02x, refcount=%d, port_id=%06x\n",
 			 io_req, io_req->xid, sc_cmd, sc_cmd->cmnd[0],
 			 refcount, rdata->ids.port_id);
 
@@ -777,7 +777,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	}
 
 	QEDF_ERR(&qedf->dbg_ctx,
-		 "Aborting io_req=%p sc_cmd=%p xid=0x%x fp_idx=%d, port_id=%06x.\n",
+		 "Aborting io_req=%px sc_cmd=%px xid=0x%x fp_idx=%d, port_id=%06x.\n",
 		 io_req, sc_cmd, io_req->xid, io_req->fp_idx,
 		 rdata->ids.port_id);
 
@@ -868,11 +868,11 @@ bool qedf_wait_for_upload(struct qedf_ctx *qedf)
 				       &fcport->flags)) {
 			if (fcport->rdata)
 				QEDF_ERR(&qedf->dbg_ctx,
-					 "Waiting for fcport %p portid=%06x.\n",
+					 "Waiting for fcport %px portid=%06x.\n",
 					 fcport, fcport->rdata->ids.port_id);
 			} else {
 				QEDF_ERR(&qedf->dbg_ctx,
-					 "Waiting for fcport %p.\n", fcport);
+					 "Waiting for fcport %px.\n", fcport);
 			}
 	}
 	rcu_read_unlock();
@@ -1894,7 +1894,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fc_vport_setlink(vn_port);
 	}
 
-	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%p.\n",
+	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%px.\n",
 		   vn_port);
 
 	/* Set up debug context for vport */
@@ -2314,7 +2314,7 @@ static void qedf_simd_int_handler(void *cookie)
 	/* Cookie is qedf_ctx struct */
 	struct qedf_ctx *qedf = (struct qedf_ctx *)cookie;
 
-	QEDF_WARN(&(qedf->dbg_ctx), "qedf=%p.\n", qedf);
+	QEDF_WARN(&(qedf->dbg_ctx), "qedf=%px.\n", qedf);
 }
 
 #define QEDF_SIMD_HANDLER_NUM		0
@@ -2543,13 +2543,13 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	if (fcport && test_bit(QEDF_RPORT_UPLOADING_CONNECTION,
 	    &fcport->flags)) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
-		    "Connection uploading, dropping fp=%p.\n", fp);
+		    "Connection uploading, dropping fp=%px.\n", fp);
 		kfree_skb(skb);
 		return;
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2, "FCoE frame receive: "
-	    "skb=%p fp=%p src=%06x dest=%06x r_ctl=%x fh_type=%x.\n", skb, fp,
+	    "skb=%px fp=%px src=%06x dest=%06x r_ctl=%x fh_type=%x.\n", skb, fp,
 	    ntoh24(fh->fh_s_id), ntoh24(fh->fh_d_id), fh->fh_r_ctl,
 	    fh->fh_type);
 	if (qedf_dump_frames)
@@ -2776,7 +2776,7 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 
 	if (fcport == NULL) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "fcport is NULL for xid=0x%x io_req=%p.\n",
+			 "fcport is NULL for xid=0x%x io_req=%px.\n",
 			 xid, io_req);
 		return;
 	}
@@ -2787,7 +2787,7 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 	 */
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(&qedf->dbg_ctx,
-			 "Session not offloaded yet, fcport = %p.\n", fcport);
+			 "Session not offloaded yet, fcport = %px.\n", fcport);
 		return;
 	}
 
@@ -2930,7 +2930,7 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-		  "BDQ PBL addr=0x%p dma=%pad\n",
+		  "BDQ PBL addr=0x%px dma=%pad\n",
 		  qedf->bdq_pbl, &qedf->bdq_pbl_dma);
 
 	/*
@@ -3011,7 +3011,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		return -ENOMEM;
 	}
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-		   "qedf->global_queues=%p.\n", qedf->global_queues);
+		   "qedf->global_queues=%px.\n", qedf->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
 	rc = qedf_alloc_bdq(qedf);
@@ -3184,7 +3184,7 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 	qedf->pf_params.fcoe_pf_params.rq_buffer_size = QEDF_BDQ_BUF_SIZE;
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-	    "bdq_list=%p bdq_pbl_list_dma=%llx bdq_pbl_list_entries=%d.\n",
+	    "bdq_list=%px bdq_pbl_list_dma=%llx bdq_pbl_list_entries=%d.\n",
 	    qedf->bdq_pbl_list,
 	    qedf->pf_params.fcoe_pf_params.bdq_pbl_base_addr[0],
 	    qedf->pf_params.fcoe_pf_params.bdq_pbl_num_entries[0]);
@@ -3309,7 +3309,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		QEDF_ERR(&(qedf->dbg_ctx), "qedf->io_mempool is NULL.\n");
 		goto err1;
 	}
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO, "qedf->io_mempool=%p.\n",
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO, "qedf->io_mempool=%px.\n",
 	    qedf->io_mempool);
 
 	sprintf(host_buf, "qedf_%u_link",
@@ -3390,7 +3390,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-	    "BDQ primary_prod=%p secondary_prod=%p.\n", qedf->bdq_primary_prod,
+	    "BDQ primary_prod=%px secondary_prod=%px.\n", qedf->bdq_primary_prod,
 	    qedf->bdq_secondary_prod);
 
 	qed_ops->register_ops(qedf->cdev, &qedf_cb_ops, qedf);
@@ -3435,8 +3435,8 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	task_start = qedf_get_task_mem(&qedf->tasks, 0);
 	task_end = qedf_get_task_mem(&qedf->tasks, MAX_TID_BLOCKS_FCOE - 1);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Task context start=%p, "
-		   "end=%p block_size=%u.\n", task_start, task_end,
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Task context start=%px, "
+		   "end=%px block_size=%u.\n", task_start, task_end,
 		   qedf->tasks.size);
 
 	/*
@@ -3590,7 +3590,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 			}
 
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-			    "grcdump: addr=%p, size=%u.\n",
+			    "grcdump: addr=%px, size=%u.\n",
 			    qedf->grcdump, qedf->grcdump_size);
 		}
 		qedf_create_sysfs_ctx_attr(qedf);
@@ -4037,7 +4037,7 @@ static int __init qedf_init(void)
 		QEDF_ERR(NULL, "qedf_io_work_cache is NULL.\n");
 		goto err1;
 	}
-	QEDF_INFO(NULL, QEDF_LOG_DISC, "qedf_io_work_cache=%p.\n",
+	QEDF_INFO(NULL, QEDF_LOG_DISC, "qedf_io_work_cache=%px.\n",
 	    qedf_io_work_cache);
 
 	qed_ops = qed_get_fcoe_ops();
-- 
1.8.3.1

