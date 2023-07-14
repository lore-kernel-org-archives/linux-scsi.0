Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1154AEB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbjGNHBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbjGNHBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AD9270D
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DL47eC017679
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=GJ9+X2ASBW2rbzd3GDmX10XNTC+0aIEfHmMzArjSuRU=;
 b=HTPiSIpUBkIXzCCBBMaN3tsNXD69VGWdercLkT7RYaNnsEPZmWCpizuoZ0s7CHzlggas
 a6ciNk6jhV3wHqsXN53T4uVOPFMuChmubU3VvLmKq32PVptJHy1/guiIrB2QF5eTky0O
 Wcx6/BvDKjxQ40iC6gvyWc5ib2lYRwmVocGM+FQpeY7bSdhzzEEaqQe72omXVgoML0sK
 LoTmZn3EeTRInPwcOawJbLOHu6tBhEwmY2jtID94dXj0Fnca7IpEAfurJOofR1M47tuc
 wesESO2k994bxrA5bFLfyg0bdfywHSyL3UNaZ08nnSDGxDswsJ0HnIETEUynI+Y2l0XY wA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rtrux9mgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:18 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 488B43F708D;
        Fri, 14 Jul 2023 00:01:15 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 04/10] qla2xxx: Fix command flush during TMF
Date:   Fri, 14 Jul 2023 12:30:58 +0530
Message-ID: <20230714070104.40052-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: oRnXYDlwybBXhMEZPCK1biorym0zLcn0
X-Proofpoint-ORIG-GUID: oRnXYDlwybBXhMEZPCK1biorym0zLcn0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For each TMF request, driver iterate through each qpair and flush
commands associated to the TMF. At the end of the qpair flush, a
Marker is used to complete the flush transaction. This process
was repeated for each qpair. The multiple flush and marker for this
TMF request seems to cause confusion for FW.

Instead, 1 flush is send to FW. Driver would wait for FW to go through
all the IO's on each qpair to be read then return. Driver then close out
the transaction with a Marker.

Cc: stable@vger.kernel.org
Fixes: d90171dd0da5 ("scsi: qla2xxx: Multi-que support for TMF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 74 +++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_iocb.c |  1 +
 drivers/scsi/qla2xxx/qla_os.c   |  9 ++--
 3 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5ec6f01ca635..3b32e65d6260 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2002,12 +2002,11 @@ qla2x00_tmf_iocb_timeout(void *data)
 	int rc, h;
 	unsigned long flags;
 
-	if (sp->type == SRB_MARKER) {
-		complete(&tmf->u.tmf.comp);
-		return;
-	}
+	if (sp->type == SRB_MARKER)
+		rc = QLA_FUNCTION_FAILED;
+	else
+		rc = qla24xx_async_abort_cmd(sp, false);
 
-	rc = qla24xx_async_abort_cmd(sp, false);
 	if (rc) {
 		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
@@ -2129,6 +2128,17 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
 	complete(&tmf->u.tmf.comp);
 }
 
+static int qla_tmf_wait(struct tmf_arg *arg)
+{
+	/* there are only 2 types of error handling that reaches here, lun or target reset */
+	if (arg->flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET | TCF_CLEAR_TASK_SET))
+		return qla2x00_eh_wait_for_pending_commands(arg->vha,
+		    arg->fcport->d_id.b24, arg->lun, WAIT_LUN);
+	else
+		return qla2x00_eh_wait_for_pending_commands(arg->vha,
+		    arg->fcport->d_id.b24, arg->lun, WAIT_TARGET);
+}
+
 static int
 __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 {
@@ -2136,8 +2146,9 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-
 	fc_port_t *fcport = arg->fcport;
+	u32 chip_gen, login_gen;
+	u64 jif;
 
 	if (TMF_NOT_READY(arg->fcport)) {
 		ql_dbg(ql_dbg_taskm, vha, 0x8032,
@@ -2182,8 +2193,27 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 		    "TM IOCB failed (%x).\n", rval);
 	}
 
-	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw))
-		rval = qla26xx_marker(arg);
+	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
+		chip_gen = vha->hw->chip_reset;
+		login_gen = fcport->login_gen;
+
+		jif = jiffies;
+		if (qla_tmf_wait(arg)) {
+			ql_log(ql_log_info, vha, 0x803e,
+			       "Waited %u ms Nexus=%ld:%06x:%llu.\n",
+			       jiffies_to_msecs(jiffies - jif), vha->host_no,
+			       fcport->d_id.b24, arg->lun);
+		}
+
+		if (chip_gen == vha->hw->chip_reset && login_gen == fcport->login_gen) {
+			rval = qla26xx_marker(arg);
+		} else {
+			ql_log(ql_log_info, vha, 0x803e,
+			       "Skip Marker due to disruption. Nexus=%ld:%06x:%llu.\n",
+			       vha->host_no, fcport->d_id.b24, arg->lun);
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
 
 done_free_sp:
 	/* ref: INIT */
@@ -2261,9 +2291,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 		     uint32_t tag)
 {
 	struct scsi_qla_host *vha = fcport->vha;
-	struct qla_qpair *qpair;
 	struct tmf_arg a;
-	int i, rval = QLA_SUCCESS;
+	int rval = QLA_SUCCESS;
 
 	if (TMF_NOT_READY(fcport))
 		return QLA_SUSPENDED;
@@ -2283,34 +2312,9 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 	if (qla_get_tmf(&a))
 		return QLA_FUNCTION_FAILED;
 
-	if (vha->hw->mqenable) {
-		for (i = 0; i < vha->hw->num_qpairs; i++) {
-			qpair = vha->hw->queue_pair_map[i];
-			if (!qpair)
-				continue;
-
-			if (TMF_NOT_READY(fcport)) {
-				ql_log(ql_log_warn, vha, 0x8026,
-				    "Unable to send TM due to disruption.\n");
-				rval = QLA_SUSPENDED;
-				break;
-			}
-
-			a.qpair = qpair;
-			a.flags = flags|TCF_NOTMCMD_TO_TARGET;
-			rval = __qla2x00_async_tm_cmd(&a);
-			if (rval)
-				break;
-		}
-	}
-
-	if (rval)
-		goto bailout;
-
 	a.qpair = vha->hw->base_qpair;
 	rval = __qla2x00_async_tm_cmd(&a);
 
-bailout:
 	qla_put_tmf(&a);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a1675f056a5c..1c6e300ed3ab 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3881,6 +3881,7 @@ qla_marker_iocb(srb_t *sp, struct mrk_entry_24xx *mrk)
 {
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = sp->u.iocb_cmd.u.tmf.modifier;
+	mrk->handle = make_handle(sp->qpair->req->id, sp->handle);
 	if (sp->u.iocb_cmd.u.tmf.modifier != MK_SYNC_ALL) {
 		mrk->nport_handle = cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
 		int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun, (struct scsi_lun *)&mrk->lun);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 47bbc8b321f8..03bc3a0b45b6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1488,8 +1488,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
-	    sdev->lun, WAIT_LUN) != QLA_SUCCESS) {
+	if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24,
+						 cmd->device->lun,
+						 WAIT_LUN) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
 		    "wait for pending cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
@@ -1555,8 +1556,8 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
-	    0, WAIT_TARGET) != QLA_SUCCESS) {
+	if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24, 0,
+						 WAIT_TARGET) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
 		    "wait for pending cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
-- 
2.23.1

