Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F73C77B7E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 07:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbjD1HyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjD1HyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 03:54:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC89269F
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:50 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S4F4iq030886
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=KTGKqf9UtWtc9aLPoMU1xz6y+CT0cAep1K2asn7B8mA=;
 b=JJcJ9H+IcUfG12QfCrZ1+Q9tt+PJYbrNiHAL9BE1mMcQIRQ399IjMNQsUnC4JYbLMPKz
 Vy2AaBzxMVLOmMZM97HD0R0wioYTsW0H6unH06Qf8WaVVqFD0sLanv/MbsK/M3DAOO7+
 560CnR8NYlAooRgemrKG4+Q7w3K5a7zlOfgTxw2pXvipOI4pET7zdsTFB0fdVjErtJdp
 CZQ5p7KaffiHNizE0u5NFLDR9QskMcOYM0A4m9hsvt1kX1dASJXWFUQlWxpNMNIxLxJq
 XVhzrrG7zhZss0Nv8ZWaB89gB0EllnNmIbfG6hY30i3tfQRENu7qqBmhCTd631emyZsf +A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q85x60vaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 28 Apr
 2023 00:53:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 28 Apr 2023 00:53:45 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 370255B6933;
        Fri, 28 Apr 2023 00:53:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 1/7] qla2xxx: Multi-que support for TMF
Date:   Fri, 28 Apr 2023 00:53:33 -0700
Message-ID: <20230428075339.32551-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com>
References: <20230428075339.32551-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Lp10BBEllKaFtyrxTX6jyFZLsp_lU0Pd
X-Proofpoint-ORIG-GUID: Lp10BBEllKaFtyrxTX6jyFZLsp_lU0Pd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add queue flush for task management command, before
placing it on the wire.
Do IO flush for all Request Q's.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304271702.GpIL391S-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v2:
- Fix warning reported by kernel robot.

 drivers/scsi/qla2xxx/qla_def.h  |  8 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 69 ++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_iocb.c |  5 ++-
 4 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ec0e987b71fa..d59e94ae0db4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -466,6 +466,14 @@ static inline be_id_t port_id_to_be_id(port_id_t port_id)
 	return res;
 }
 
+struct tmf_arg {
+	struct qla_qpair *qpair;
+	struct fc_port *fcport;
+	struct scsi_qla_host *vha;
+	u64 lun;
+	u32 flags;
+};
+
 struct els_logo_payload {
 	uint8_t opcode;
 	uint8_t rsvd[3];
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9aba07c7bde4..ef11ce46381d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -69,7 +69,7 @@ extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_prlo(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
+extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint64_t, uint32_t);
 struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
     enum qla_work_type);
 extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ec0423ec6681..035d1984e2bd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2020,17 +2020,19 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
 	complete(&tmf->u.tmf.comp);
 }
 
-int
-qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
-	uint32_t tag)
+static int
+__qla2x00_async_tm_cmd(struct tmf_arg *arg)
 {
-	struct scsi_qla_host *vha = fcport->vha;
+	struct scsi_qla_host *vha = arg->vha;
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
+	unsigned long flags;
 	int rval = QLA_FUNCTION_FAILED;
 
+	fc_port_t *fcport = arg->fcport;
+
 	/* ref: INIT */
-	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
@@ -2043,15 +2045,15 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 	tm_iocb = &sp->u.iocb_cmd;
 	init_completion(&tm_iocb->u.tmf.comp);
-	tm_iocb->u.tmf.flags = flags;
-	tm_iocb->u.tmf.lun = lun;
+	tm_iocb->u.tmf.flags = arg->flags;
+	tm_iocb->u.tmf.lun = arg->lun;
 
+	rval = qla2x00_start_sp(sp);
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
-	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
+	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x ctrl=%x.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    fcport->d_id.b.area, fcport->d_id.b.al_pa, arg->flags);
 
-	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 	wait_for_completion(&tm_iocb->u.tmf.comp);
@@ -2065,12 +2067,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
 		flags = tm_iocb->u.tmf.flags;
-		lun = (uint16_t)tm_iocb->u.tmf.lun;
+		if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|
+			TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
+			flags = MK_SYNC_ID_LUN;
+		else
+			flags = MK_SYNC_ID;
 
-		/* Issue Marker IOCB */
-		qla2x00_marker(vha, vha->hw->base_qpair,
-		    fcport->loop_id, lun,
-		    flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
+		qla2x00_marker(vha, sp->qpair,
+		    sp->fcport->loop_id, arg->lun, flags);
 	}
 
 done_free_sp:
@@ -2080,6 +2084,41 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	return rval;
 }
 
+int
+qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
+		     uint32_t tag)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_qpair *qpair;
+	struct tmf_arg a;
+	struct completion comp;
+	int i, rval;
+
+	init_completion(&comp);
+	a.vha = fcport->vha;
+	a.fcport = fcport;
+	a.lun = lun;
+
+	if (vha->hw->mqenable) {
+		for (i = 0; i < vha->hw->num_qpairs; i++) {
+			qpair = vha->hw->queue_pair_map[i];
+			if (!qpair)
+				continue;
+			a.qpair = qpair;
+			a.flags = flags|TCF_NOTMCMD_TO_TARGET;
+			rval = __qla2x00_async_tm_cmd(&a);
+			if (rval)
+				break;
+		}
+	}
+
+	a.qpair = vha->hw->base_qpair;
+	a.flags = flags;
+	rval = __qla2x00_async_tm_cmd(&a);
+
+	return rval;
+}
+
 int
 qla24xx_async_abort_command(srb_t *sp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b9b3e6f80ea9..b02039601cc0 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2541,7 +2541,7 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	scsi_qla_host_t *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_iocb *iocb = &sp->u.iocb_cmd;
-	struct req_que *req = vha->req;
+	struct req_que *req = sp->qpair->req;
 
 	flags = iocb->u.tmf.flags;
 	lun = iocb->u.tmf.lun;
@@ -2557,7 +2557,8 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	tsk->port_id[2] = fcport->d_id.b.domain;
 	tsk->vp_index = fcport->vha->vp_idx;
 
-	if (flags == TCF_LUN_RESET) {
+	if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET|
+	    TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA)) {
 		int_to_scsilun(lun, &tsk->lun);
 		host_to_fcp_swap((uint8_t *)&tsk->lun,
 			sizeof(tsk->lun));
-- 
2.23.1

