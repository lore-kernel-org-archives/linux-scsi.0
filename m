Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A77C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 08:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbjD0IEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbjD0IEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 04:04:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4E2D72
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7Kcjr003717
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NHCt/9sYcq4+bjkcxI0YOgpImmocpZEm1rbJSreK9Y0=;
 b=Zl78tG+QKZrozDX3pCSjNAXT3hp9pDCrVid6TAq05GalMIzID0XuaD9bH1c6UE4lHdsU
 0t03XGFhOWEBBsekKpg2TuitP7p/ONwXzs4I5eY2yRTfZsyOQW4bi6JW1i0Kl12Vn8ip
 cieMwjW1AK5zZTJn4Rr66Dgzq3iIVP0WNO15maGqYJSFOuA0Mb5FsHmUTFaMA5OPLzre
 rXamYIIlEe1ttfVao/IiPh9T/kOR+BeAhanYB2REzXZjeAF6MbPWThh+Xj0JDSfAxUqh
 IxTLeujwG4AGe7zVCCv3qAObigdBrIo8MnzsgcjCDCdNm/cVsTVRRz8SaS3N0t+xu+XB /g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q781htf75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 27 Apr
 2023 01:04:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 27 Apr 2023 01:04:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D8C0C3F7082;
        Thu, 27 Apr 2023 01:04:02 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 2/7] qla2xxx: Fix task management cmd failure
Date:   Thu, 27 Apr 2023 01:03:46 -0700
Message-ID: <20230427080351.9889-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230427080351.9889-1-njavali@marvell.com>
References: <20230427080351.9889-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eeWkf6yeRWUEKQsboya8CLqiq43W_ifH
X-Proofpoint-ORIG-GUID: eeWkf6yeRWUEKQsboya8CLqiq43W_ifH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Task management cmd failed with status 30h which means
FW is not able to finish processing one task management
before another task management for the same lun.
Hence add wait for completion of marker to space it out.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   6 ++
 drivers/scsi/qla2xxx/qla_init.c | 102 +++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_iocb.c |  28 +++++++--
 drivers/scsi/qla2xxx/qla_isr.c  |  26 +++++++-
 4 files changed, 139 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d59e94ae0db4..0437e0150a50 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -472,6 +472,7 @@ struct tmf_arg {
 	struct scsi_qla_host *vha;
 	u64 lun;
 	u32 flags;
+	uint8_t modifier;
 };
 
 struct els_logo_payload {
@@ -553,6 +554,10 @@ struct srb_iocb {
 			uint32_t data;
 			struct completion comp;
 			__le16 comp_status;
+
+			uint8_t modifier;
+			uint8_t vp_index;
+			uint16_t loop_id;
 		} tmf;
 		struct {
 #define SRB_FXDISC_REQ_DMA_VALID	BIT_0
@@ -656,6 +661,7 @@ struct srb_iocb {
 #define SRB_SA_UPDATE	25
 #define SRB_ELS_CMD_HST_NOLOGIN 26
 #define SRB_SA_REPLACE	27
+#define SRB_MARKER	28
 
 struct qla_els_pt_arg {
 	u8 els_opcode;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c88e04a492a5..45a941409fef 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2013,6 +2013,80 @@ qla2x00_tmf_iocb_timeout(void *data)
 	}
 }
 
+static void qla_marker_sp_done(srb_t *sp, int res)
+{
+	struct srb_iocb *tmf = &sp->u.iocb_cmd;
+
+	if (res != QLA_SUCCESS)
+		ql_dbg(ql_dbg_taskm, sp->vha, 0x8004,
+		    "Async-marker fail hdl=%x portid=%06x ctrl=%x lun=%lld qp=%d.\n",
+		    sp->handle, sp->fcport->d_id.b24, sp->u.iocb_cmd.u.tmf.flags,
+		    sp->u.iocb_cmd.u.tmf.lun, sp->qpair->id);
+
+	complete(&tmf->u.tmf.comp);
+}
+
+#define  START_SP_W_RETRIES(_sp, _rval) \
+{\
+	int cnt = 5; \
+	do { \
+		_rval = qla2x00_start_sp(_sp); \
+		if (_rval == EAGAIN) \
+			msleep(1); \
+		else \
+			break; \
+		cnt--; \
+	} while (cnt); \
+}
+
+int
+qla26xx_marker(struct tmf_arg *arg)
+{
+	struct scsi_qla_host *vha = arg->vha;
+	struct srb_iocb *tm_iocb;
+	srb_t *sp;
+	int rval = QLA_FUNCTION_FAILED;
+	fc_port_t *fcport = arg->fcport;
+
+	/* ref: INIT */
+	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_MARKER;
+	sp->name = "marker";
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha), qla_marker_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
+
+	tm_iocb = &sp->u.iocb_cmd;
+	init_completion(&tm_iocb->u.tmf.comp);
+	tm_iocb->u.tmf.modifier = arg->modifier;
+	tm_iocb->u.tmf.lun = arg->lun;
+	tm_iocb->u.tmf.loop_id = fcport->loop_id;
+	tm_iocb->u.tmf.vp_index = vha->vp_idx;
+
+	START_SP_W_RETRIES(sp, rval);
+
+	ql_dbg(ql_dbg_taskm, vha, 0x8006,
+	    "Async-marker hdl=%x loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d rval %d.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24,
+	    arg->modifier, arg->lun, sp->qpair->id, rval);
+
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x8031,
+		    "Marker IOCB failed (%x).\n", rval);
+		goto done_free_sp;
+	}
+
+	wait_for_completion(&tm_iocb->u.tmf.comp);
+
+done_free_sp:
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+done:
+	return rval;
+}
+
 static void qla2x00_tmf_sp_done(srb_t *sp, int res)
 {
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
@@ -2026,7 +2100,6 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	struct scsi_qla_host *vha = arg->vha;
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
-	unsigned long flags;
 	int rval = QLA_FUNCTION_FAILED;
 
 	fc_port_t *fcport = arg->fcport;
@@ -2048,11 +2121,12 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	tm_iocb->u.tmf.flags = arg->flags;
 	tm_iocb->u.tmf.lun = arg->lun;
 
-	rval = qla2x00_start_sp(sp);
+	START_SP_W_RETRIES(sp, rval);
+
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
-	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x ctrl=%x.\n",
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa, arg->flags);
+	    "Async-tmf hdl=%x loop-id=%x portid=%06x ctrl=%x lun=%lld qp=%d rval=%x.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24,
+	    arg->flags, arg->lun, sp->qpair->id, rval);
 
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
@@ -2065,17 +2139,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 		    "TM IOCB failed (%x).\n", rval);
 	}
 
-	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
-		flags = tm_iocb->u.tmf.flags;
-		if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|
-			TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
-			flags = MK_SYNC_ID_LUN;
-		else
-			flags = MK_SYNC_ID;
-
-		qla2x00_marker(vha, sp->qpair,
-		    sp->fcport->loop_id, arg->lun, flags);
-	}
+	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw))
+		rval = qla26xx_marker(arg);
 
 done_free_sp:
 	/* ref: INIT */
@@ -2099,6 +2164,11 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 	a.fcport = fcport;
 	a.lun = lun;
 
+	if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
+		a.modifier = MK_SYNC_ID_LUN;
+	else
+		a.modifier = MK_SYNC_ID;
+
 	if (vha->hw->mqenable) {
 		for (i = 0; i < vha->hw->num_qpairs; i++) {
 			qpair = vha->hw->queue_pair_map[i];
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b02039601cc0..6acfdcc48b16 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -522,21 +522,25 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
 		return (QLA_FUNCTION_FAILED);
 	}
 
+	mrk24 = (struct mrk_entry_24xx *)mrk;
+
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = type;
 	if (type != MK_SYNC_ALL) {
 		if (IS_FWI2_CAPABLE(ha)) {
-			mrk24 = (struct mrk_entry_24xx *) mrk;
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
 			mrk24->vp_index = vha->vp_idx;
-			mrk24->handle = make_handle(req->id, mrk24->handle);
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16((uint16_t)lun);
 		}
 	}
+
+	if (IS_FWI2_CAPABLE(ha))
+		mrk24->handle = QLA_SKIP_HANDLE;
+
 	wmb();
 
 	qla2x00_start_iocbs(vha, req);
@@ -3853,9 +3857,9 @@ static int qla_get_iocbs_resource(struct srb *sp)
 	case SRB_NACK_LOGO:
 	case SRB_LOGOUT_CMD:
 	case SRB_CTRL_VP:
-		push_it_through = true;
-		fallthrough;
+	case SRB_MARKER:
 	default:
+		push_it_through = true;
 		get_exch = false;
 	}
 
@@ -3871,6 +3875,19 @@ static int qla_get_iocbs_resource(struct srb *sp)
 	return qla_get_fw_resources(sp->qpair, &sp->iores);
 }
 
+static void
+qla_marker_iocb(srb_t *sp, struct mrk_entry_24xx *mrk)
+{
+	mrk->entry_type = MARKER_TYPE;
+	mrk->modifier = sp->u.iocb_cmd.u.tmf.modifier;
+	if (sp->u.iocb_cmd.u.tmf.modifier != MK_SYNC_ALL) {
+		mrk->nport_handle = cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
+		int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun, (struct scsi_lun *)&mrk->lun);
+		host_to_fcp_swap(mrk->lun, sizeof(mrk->lun));
+		mrk->vp_index = sp->u.iocb_cmd.u.tmf.vp_index;
+	}
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3974,6 +3991,9 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_SA_REPLACE:
 		qla24xx_sa_replace_iocb(sp, pkt);
 		break;
+	case SRB_MARKER:
+		qla_marker_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 71feda2cdb63..f3107508cf12 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3750,6 +3750,28 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 	return rc;
 }
 
+static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+	struct mrk_entry_24xx *pkt)
+{
+	const char func[] = "MRK-IOCB";
+	srb_t *sp;
+	int res = QLA_SUCCESS;
+
+	if (!IS_FWI2_CAPABLE(vha->hw))
+		return;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	if (pkt->entry_status) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8025, "marker failure.\n");
+		res = QLA_COMMAND_ERROR;
+	}
+	sp->u.iocb_cmd.u.tmf.data = res;
+	sp->done(sp, res);
+}
+
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @vha: SCSI driver HA context
@@ -3863,9 +3885,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					(struct nack_to_isp *)pkt);
 			break;
 		case MARKER_TYPE:
-			/* Do nothing in this case, this check is to prevent it
-			 * from falling into default case
-			 */
+			qla_marker_iocb_entry(vha, rsp->req, (struct mrk_entry_24xx *)pkt);
 			break;
 		case ABORT_IOCB_TYPE:
 			qla24xx_abort_iocb_entry(vha, rsp->req,
-- 
2.23.1

