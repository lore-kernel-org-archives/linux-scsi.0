Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A1EC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 07:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345444AbjD1Hyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345645AbjD1HyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 03:54:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA153595
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S4F4is030886
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=91nfxUMvbEYK2aK5R/HJci4hWLZPiahowYXjA1Sc54U=;
 b=O76RGZsDedAqM4FUN/jgckcV0tIR1uWjzMI1kGB45ZzfNB86rpWeZaEaQSC6nV0R0qF3
 nEydeCYqJ4u0fpq/XIYtmrBHEw/EtPSZ2bgxo5s81eYzqZoeRplHZFPVU9lOA7NPpp8y
 32RQOvTvYvgJy4tzj4p80gxa9L/1ujxxeRApGkOG3v86hI+TJjIcxUt2O2l6G3bftcF5
 fM891kcx5Aag8Y1Z3qz1m3ukEBEZyp/8nJ8rYXZovg++9WcMxKHifJaQhagT2T2giGo1
 BkT8ThG3oEotpcFQPumpKuvRXNCTusvcBJPUiXhjn7/goUSUDRti0gh63+mR1e0upzsw jw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q85x60vaa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 28 Apr
 2023 00:53:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 28 Apr 2023 00:53:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7542F5B6938;
        Fri, 28 Apr 2023 00:53:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 4/7] qla2xxx: Fix hang in task management
Date:   Fri, 28 Apr 2023 00:53:36 -0700
Message-ID: <20230428075339.32551-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com>
References: <20230428075339.32551-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: y9xSBltBXCqNroEj3bB0VXyyq0N5T4LH
X-Proofpoint-ORIG-GUID: y9xSBltBXCqNroEj3bB0VXyyq0N5T4LH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Task management command hangs where a side
band chip reset failed to nudge the TMF
from it's current send path.

Add additional error check to block TMF
from entering during chip reset and along
the TMF path to cause it to bail out, skip
over abort of marker.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 +++
 drivers/scsi/qla2xxx/qla_init.c | 60 +++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0971150953a9..3e0be0136cad 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5516,4 +5516,8 @@ struct ql_vnd_tgt_stats_resp {
 	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
 	_fp->flags
 
+#define TMF_NOT_READY(_fcport) \
+	(!_fcport || IS_SESSION_DELETED(_fcport) || atomic_read(&_fcport->state) != FCS_ONLINE || \
+	!_fcport->vha->hw->flags.fw_started)
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 17649cf9c39d..b61597d6882c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1996,6 +1996,11 @@ qla2x00_tmf_iocb_timeout(void *data)
 	int rc, h;
 	unsigned long flags;
 
+	if (sp->type == SRB_MARKER) {
+		complete(&tmf->u.tmf.comp);
+		return;
+	}
+
 	rc = qla24xx_async_abort_cmd(sp, false);
 	if (rc) {
 		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
@@ -2023,6 +2028,7 @@ static void qla_marker_sp_done(srb_t *sp, int res)
 		    sp->handle, sp->fcport->d_id.b24, sp->u.iocb_cmd.u.tmf.flags,
 		    sp->u.iocb_cmd.u.tmf.lun, sp->qpair->id);
 
+	sp->u.iocb_cmd.u.tmf.data = res;
 	complete(&tmf->u.tmf.comp);
 }
 
@@ -2039,6 +2045,11 @@ static void qla_marker_sp_done(srb_t *sp, int res)
 	} while (cnt); \
 }
 
+/**
+ * qla26xx_marker: send marker IOCB and wait for the completion of it.
+ * @arg: pointer to argument list.
+ *    It is assume caller will provide an fcport pointer and modifier
+ */
 static int
 qla26xx_marker(struct tmf_arg *arg)
 {
@@ -2048,6 +2059,14 @@ qla26xx_marker(struct tmf_arg *arg)
 	int rval = QLA_FUNCTION_FAILED;
 	fc_port_t *fcport = arg->fcport;
 
+	if (TMF_NOT_READY(arg->fcport)) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8039,
+		    "FC port not ready for marker loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d.\n",
+		    fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, arg->qpair->id);
+		return QLA_SUSPENDED;
+	}
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2074,11 +2093,19 @@ qla26xx_marker(struct tmf_arg *arg)
 
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x8031,
-		    "Marker IOCB failed (%x).\n", rval);
+		    "Marker IOCB send failure (%x).\n", rval);
 		goto done_free_sp;
 	}
 
 	wait_for_completion(&tm_iocb->u.tmf.comp);
+	rval = tm_iocb->u.tmf.data;
+
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x8019,
+		    "Marker failed hdl=%x loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d rval %d.\n",
+		    sp->handle, fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, sp->qpair->id, rval);
+	}
 
 done_free_sp:
 	/* ref: INIT */
@@ -2091,6 +2118,8 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
 {
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
 
+	if (res)
+		tmf->u.tmf.data = res;
 	complete(&tmf->u.tmf.comp);
 }
 
@@ -2104,6 +2133,14 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 
 	fc_port_t *fcport = arg->fcport;
 
+	if (TMF_NOT_READY(arg->fcport)) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8032,
+		    "FC port not ready for TM command loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d.\n",
+		    fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, arg->qpair->id);
+		return QLA_SUSPENDED;
+	}
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2178,7 +2215,9 @@ int qla_get_tmf(fc_port_t *fcport)
 		msleep(1);
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-		if (fcport->deleted) {
+		if (TMF_NOT_READY(fcport)) {
+			ql_log(ql_log_warn, vha, 0x802c,
+			    "Unable to acquire TM resource due to disruption.\n");
 			rc = EIO;
 			break;
 		}
@@ -2204,7 +2243,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_qpair *qpair;
 	struct tmf_arg a;
-	int i, rval;
+	int i, rval = QLA_SUCCESS;
+
+	if (TMF_NOT_READY(fcport))
+		return QLA_SUSPENDED;
 
 	a.vha = fcport->vha;
 	a.fcport = fcport;
@@ -2223,6 +2265,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 			qpair = vha->hw->queue_pair_map[i];
 			if (!qpair)
 				continue;
+
+			if (TMF_NOT_READY(fcport)) {
+				ql_log(ql_log_warn, vha, 0x8026,
+				    "Unable to send TM due to disruption.\n");
+				rval = QLA_SUSPENDED;
+				break;
+			}
+
 			a.qpair = qpair;
 			a.flags = flags|TCF_NOTMCMD_TO_TARGET;
 			rval = __qla2x00_async_tm_cmd(&a);
@@ -2231,10 +2281,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 		}
 	}
 
+	if (rval)
+		goto bailout;
+
 	a.qpair = vha->hw->base_qpair;
 	a.flags = flags;
 	rval = __qla2x00_async_tm_cmd(&a);
 
+bailout:
 	if (a.modifier == MK_SYNC_ID_LUN)
 		qla_put_tmf(fcport);
 
-- 
2.23.1

