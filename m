Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EA0C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 12:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665F861466
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 12:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhEGMcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 08:32:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:46856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236694AbhEGMcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 08:32:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72EE5B186;
        Fri,  7 May 2021 12:31:04 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>
Subject: [RFC 1/2] qla2xxx: Refactor asynchronous command initialization
Date:   Fri,  7 May 2021 14:31:02 +0200
Message-Id: <20210507123103.10265-3-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210507123103.10265-1-dwagner@suse.de>
References: <20210507123103.10265-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move common open coded asynchronous command initializing code such as
setting up the timer and the done callback into one function. This is
a preperation step and allows us later on to change the low level
error flow handling at a central place.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  3 +-
 drivers/scsi/qla2xxx/qla_gs.c     | 70 ++++++++++--------------------
 drivers/scsi/qla2xxx/qla_init.c   | 72 +++++++++++--------------------
 drivers/scsi/qla2xxx/qla_iocb.c   | 29 +++++++------
 drivers/scsi/qla2xxx/qla_mbx.c    | 11 ++---
 drivers/scsi/qla2xxx/qla_mid.c    |  5 +--
 drivers/scsi/qla2xxx/qla_mr.c     |  7 ++-
 drivers/scsi/qla2xxx/qla_target.c |  6 +--
 8 files changed, 75 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fae5cae6f0a8..15e6a61905c9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -298,7 +298,8 @@ extern int qla2x00_start_sp(srb_t *);
 extern int qla24xx_dif_start_scsi(srb_t *);
 extern int qla2x00_start_bidir(srb_t *, struct scsi_qla_host *, uint32_t);
 extern int qla2xxx_dif_start_scsi_mq(srb_t *);
-extern void qla2x00_init_timer(srb_t *sp, unsigned long tmo);
+extern void qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
+				  void (*done)(struct srb *, int));
 extern unsigned long qla2x00_get_async_timeout(struct scsi_qla_host *);
 
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5b6e04a91a18..1784ebfacfab 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -598,7 +598,8 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rft_id";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -638,8 +639,6 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 	sp->u.iocb_cmd.u.ctarg.req_size = RFT_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFT_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x.\n",
@@ -694,7 +693,8 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rff_id";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -732,8 +732,6 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.req_size = RFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x feature %x type %x.\n",
@@ -785,7 +783,8 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rnid";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -823,9 +822,6 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RNN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x\n",
 	    sp->name, sp->handle, d_id->b24);
@@ -892,7 +888,8 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rsnn_nn";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -936,9 +933,6 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RSNN_NN_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x.\n",
 	    sp->name, sp->handle);
@@ -2908,8 +2902,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->name = "gpsc";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gpsc_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla24xx_prep_ct_fm_req(fcport->ct_desc.ct_sns, GPSC_CMD,
@@ -2927,9 +2921,6 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GPSC_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = vha->mgmt_svr_loop_id;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla24xx_async_gpsc_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x205e,
 	    "Async-%s %8phC hdl=%x loopid=%x portid=%02x%02x%02x.\n",
 	    sp->name, fcport->port_name, sp->handle,
@@ -3185,7 +3176,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	sp->name = "gpnid";
 	sp->u.iocb_cmd.u.ctarg.id = *id;
 	sp->gen1 = 0;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnid_sp_done);
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	list_for_each_entry(tsp, &vha->gpnid_list, elem) {
@@ -3233,9 +3225,6 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GPN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_gpnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x2067,
 	    "Async-%s hdl=%x ID %3phC.\n", sp->name,
 	    sp->handle, &ct_req->req.port_id.port_id);
@@ -3343,9 +3332,8 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->name = "gffid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gffid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFF_ID_CMD,
@@ -3363,8 +3351,6 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla24xx_async_gffid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x2132,
 	    "Async-%s hdl=%x  %8phC.\n", sp->name,
 	    sp->handle, fcport->port_name);
@@ -3878,9 +3864,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->name = "gnnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnft_gnnft_sp_done);
 
 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
 	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
@@ -3896,8 +3881,6 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
 	    sp->handle, ct_req->req.gpn_ft.port_type);
@@ -4043,9 +4026,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 	sp->name = "gpnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnft_gnnft_sp_done);
 
 	rspsz = sp->u.iocb_cmd.u.ctarg.rsp_size;
 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
@@ -4060,8 +4042,6 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
 	    sp->handle, ct_req->req.gpn_ft.port_type);
@@ -4175,9 +4155,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->name = "gnnid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gnnid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
@@ -4196,8 +4175,6 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GNN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gnnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
 	    sp->name, fcport->port_name,
@@ -4303,9 +4280,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->name = "gfpnid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gfpnid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFPN_ID_CMD,
@@ -4324,8 +4300,6 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFPN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gfpnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
 	    sp->name, fcport->port_name,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9c5782e946e0..6497bf405d82 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -168,16 +168,14 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
 	init_completion(&abt_iocb->u.abt.comp);
 	/* FW can send 2 x ABTS's timeout/20s */
-	qla2x00_init_timer(sp, 42);
+	qla2x00_init_async_sp(sp, 42, qla24xx_abort_sp_done);
+	sp->u.iocb_cmd.timeout = qla24xx_abort_iocb_timeout;
 
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 	abt_iocb->u.abt.req_que_no = cpu_to_le16(cmd_sp->qpair->req->id);
 
-	sp->done = qla24xx_abort_sp_done;
-
 	ql_dbg(ql_dbg_async, vha, 0x507c,
 	       "Abort command issued - hdl=%x, type=%x\n", cmd_sp->handle,
 	       cmd_sp->type);
@@ -337,12 +335,10 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	sp->name = "login";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_login_sp_done);
 
 	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_login_sp_done;
 	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport))
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
 	else
@@ -386,7 +382,6 @@ int
 qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
-	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -396,12 +391,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_LOGOUT_CMD;
 	sp->name = "logout";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_logout_sp_done;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_logout_sp_done),
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
@@ -448,7 +439,6 @@ int
 qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
-	struct srb_iocb *lio;
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
@@ -458,12 +448,8 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_PRLO_CMD;
 	sp->name = "prlo";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_prlo_sp_done;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_prlo_sp_done);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-prlo - hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
@@ -584,16 +570,15 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	sp->type = SRB_ADISC_CMD;
 	sp->name = "adisc";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_adisc_sp_done);
 
-	sp->done = qla2x00_async_adisc_sp_done;
-	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+	if (data[1] & QLA_LOGIO_LOGIN_RETRIED) {
+		lio = &sp->u.iocb_cmd;
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x206f,
 	    "Async-adisc - hdl=%x loopid=%x portid=%06x %8phC.\n",
@@ -1114,11 +1099,10 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->name = "gnlist";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gnl_sp_done);
 
 	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
-
 	mb = sp->u.iocb_cmd.u.mbx.out_mb;
 	mb[0] = MBC_PORT_NODE_NAME_LIST;
 	mb[1] = BIT_2 | BIT_3;
@@ -1129,8 +1113,6 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	mb[8] = vha->gnl.size;
 	mb[9] = vha->vp_idx;
 
-	sp->done = qla24xx_async_gnl_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x20da,
 	    "Async-%s - OUT WWPN %8phC hndl %x\n",
 	    sp->name, fcport->port_name, sp->handle);
@@ -1261,12 +1243,10 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_PRLI_CMD;
 	sp->name = "prli";
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_prli_sp_done);
 
 	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_prli_sp_done;
 	lio->u.logio.flags = 0;
 
 	if (NVME_TARGET(vha->hw, fcport))
@@ -1336,10 +1316,8 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	sp->name = "gpdb";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gpdb_sp_done);
 
 	pd = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd == NULL) {
@@ -1358,11 +1336,10 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	mb[9] = vha->vp_idx;
 	mb[10] = opt;
 
+	mbx = &sp->u.iocb_cmd;
 	mbx->u.mbx.in = pd;
 	mbx->u.mbx.in_dma = pd_dma;
 
-	sp->done = qla24xx_async_gpdb_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x20dc,
 	    "Async-%s %8phC hndl %x opt %x\n",
 	    sp->name, fcport->port_name, sp->handle, opt);
@@ -1832,18 +1809,17 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	if (!sp)
 		goto done;
 
-	tm_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
+			      qla2x00_tmf_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
 
-	tm_iocb->timeout = qla2x00_tmf_iocb_timeout;
+	tm_iocb = &sp->u.iocb_cmd;
 	init_completion(&tm_iocb->u.tmf.comp);
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
-
 	tm_iocb->u.tmf.flags = flags;
 	tm_iocb->u.tmf.lun = lun;
 	tm_iocb->u.tmf.data = tag;
-	sp->done = qla2x00_tmf_sp_done;
 
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
 	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..1e848ded06a4 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2597,11 +2597,15 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	}
 }
 
-void qla2x00_init_timer(srb_t *sp, unsigned long tmo)
+void
+qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
+		      void (*done)(struct srb *sp, int res))
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
-	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
+	sp->done = done;
 	sp->free = qla2x00_sp_free;
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
 	if (IS_QLAFX00(sp->vha->hw) && sp->type == SRB_FXIOCB_DCMD)
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	sp->start_timer = 1;
@@ -2709,11 +2713,11 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
-	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
-	sp->done = qla2x00_els_dcmd_sp_done;
+	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT,
+			      qla2x00_els_dcmd_sp_done);
 	sp->free = qla2x00_els_dcmd_sp_free;
+	sp->u.iocb_cmd.timeout = qla2x00_els_dcmd_iocb_timeout;
+	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
 
 	elsio->u.els_logo.els_logo_pyld = dma_alloc_coherent(&ha->pdev->dev,
 			    DMA_POOL_SIZE, &elsio->u.els_logo.els_logo_pyld_dma,
@@ -3028,17 +3032,16 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
-	sp->type = SRB_ELS_DCMD;
-	sp->name = "ELS_DCMD";
-	sp->fcport = fcport;
-
-	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT + 2);
+	sp->type = SRB_ELS_DCMD;
+	sp->name = "ELS_DCMD";
+	sp->fcport = fcport;
+	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT + 2,
+			     qla2x00_els_dcmd2_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_els_dcmd2_iocb_timeout;
 
-	sp->done = qla2x00_els_dcmd2_sp_done;
 	elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
 
 	ptr = elsio->u.els_plogi.els_plogi_pyld =
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0bcd8afdc0ff..08d247b81a60 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6446,19 +6446,16 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	if (!sp)
 		goto done;
 
-	sp->type = SRB_MB_IOCB;
-	sp->name = mb_to_str(mcp->mb[0]);
-
 	c = &sp->u.iocb_cmd;
-	c->timeout = qla2x00_async_iocb_timeout;
 	init_completion(&c->u.mbx.comp);
 
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	sp->type = SRB_MB_IOCB;
+	sp->name = mb_to_str(mcp->mb[0]);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_mb_sp_done);
 
 	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
 
-	sp->done = qla2x00_async_mb_sp_done;
-
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1018,
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c7caf322f445..d161bfa6c7d5 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -959,9 +959,8 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	sp->type = SRB_CTRL_VP;
 	sp->name = "ctrl_vp";
 	sp->comp = &comp;
-	sp->done = qla_ctrlvp_sp_done;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla_ctrlvp_sp_done);
 	sp->u.iocb_cmd.u.ctrlvp.cmd = cmd;
 	sp->u.iocb_cmd.u.ctrlvp.vp_index = vp_index;
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6e920da64863..961ff33a0a26 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1816,11 +1816,11 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 
 	sp->type = SRB_FXIOCB_DCMD;
 	sp->name = "fxdisc";
+	qla2x00_init_async_sp(sp, FXDISC_TIMEOUT,
+			      qla2x00_fxdisc_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_fxdisc_iocb_timeout;
 
 	fdisc = &sp->u.iocb_cmd;
-	fdisc->timeout = qla2x00_fxdisc_iocb_timeout;
-	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
-
 	switch (fx_type) {
 	case FXDISC_GET_CONFIG_INFO:
 	fdisc->u.fxiocb.flags =
@@ -1921,7 +1921,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	}
 
 	fdisc->u.fxiocb.req_func_type = cpu_to_le16(fx_type);
-	sp->done = qla2x00_fxdisc_sp_done;
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b2008fb1dd38..06c32adc694c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -642,12 +642,10 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	sp->type = type;
 	sp->name = "nack";
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_nack_sp_done);
 
 	sp->u.iocb_cmd.u.nack.ntfy = ntfy;
-	sp->done = qla2x00_async_nack_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20f4,
 	    "Async-%s %8phC hndl %x %s\n",
-- 
2.29.2

