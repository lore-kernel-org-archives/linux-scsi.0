Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B792C4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E50660FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbhHQFOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15180 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237701AbhHQFOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BO006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=GhuM204tRkoBJ9OWVnSdEree0Z70Q+fAW1CP2o4UJHY=;
 b=SiMIO7648iDOGUHpq6NqoGxBC+OMOBxCMZ0Wu4EzErAhJossK+xZsqKEqJ2GZ5ywDls8
 MgcQc6wT2PbgK1sIUOa2ON6ddPW9+PgGO58eAhQ8DwOrhX6ehbFaEmxc+wEBMFSc7bRh
 Ij+fPOUAsXTZGz+Jslv3bg0JOSxvjzvFVjULi0wIs3oShOiFqHsADBn4NRyhLT1Dj8n1
 G6tQb17RY7F/HGoarD9gKPdMln+mM0e1Li4M6LBQsh3oVmL6zSL/zO7kIPp0V53bUGrU
 vE7CfRPFt2MkQ1e4G5lv7hrG6+cBwTLjuQIuM1ezV2/liJVKEguErQGkxqcSJsQWtSF2 ww== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8D84A3F70AF;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DpI5002544;
        Mon, 16 Aug 2021 22:13:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DplC002543;
        Mon, 16 Aug 2021 22:13:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/12] qla2xxx: Fix hang on NVME command timeouts
Date:   Mon, 16 Aug 2021 22:13:11 -0700
Message-ID: <20210817051315.2477-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: F7b3zW99Wi9mIYupLYvwD-Dmk-3uwL81
X-Proofpoint-ORIG-GUID: F7b3zW99Wi9mIYupLYvwD-Dmk-3uwL81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

The abort callback gets called only when it gets posted to firmware. The
refcounting is done properly in the callback. On internal errors,
the callback is not invoked leading to a hung IO. Fix this by having
separate error code when command gets returned from firmware.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  3 +++
 drivers/scsi/qla2xxx/qla_init.c |  6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_nvme.c | 26 +++++++++++++++++---------
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ddc6932f05fa..cb5bf2585cb7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5166,6 +5166,9 @@ struct secure_flash_update_block_pk {
 #define QLA_BUSY			0x107
 #define QLA_ALREADY_REGISTERED		0x109
 #define QLA_OS_TIMER_EXPIRED		0x10a
+#define QLA_ERR_NO_QPAIR		0x10b
+#define QLA_ERR_NOT_FOUND		0x10c
+#define QLA_ERR_FROM_FW			0x10d
 
 #define NVRAM_DELAY()		udelay(10)
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a70c68bb1d2d..255f3a8884db 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -157,7 +157,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
 				  GFP_ATOMIC);
 	if (!sp)
-		return rval;
+		return QLA_MEMORY_ALLOC_FAILED;
 
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
@@ -190,7 +190,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (wait) {
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
-			QLA_SUCCESS : QLA_FUNCTION_FAILED;
+			QLA_SUCCESS : QLA_ERR_FROM_FW;
 		sp->free(sp);
 	}
 
@@ -1988,7 +1988,7 @@ qla24xx_async_abort_command(srb_t *sp)
 
 	if (handle == req->num_outstanding_cmds) {
 		/* Command not found. */
-		return QLA_FUNCTION_FAILED;
+		return QLA_ERR_NOT_FOUND;
 	}
 	if (sp->type == SRB_FXIOCB_DCMD)
 		return qlafx00_fx_disc(vha, &vha->hw->mr.fcport,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2964f5280bed..fcc219172aa9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3245,7 +3245,7 @@ qla24xx_abort_command(srb_t *sp)
 	if (sp->qpair)
 		req = sp->qpair->req;
 	else
-		return QLA_FUNCTION_FAILED;
+		return QLA_ERR_NO_QPAIR;
 
 	if (ql2xasynctmfenable)
 		return qla24xx_async_abort_command(sp);
@@ -3258,7 +3258,7 @@ qla24xx_abort_command(srb_t *sp)
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 	if (handle == req->num_outstanding_cmds) {
 		/* Command not found. */
-		return QLA_FUNCTION_FAILED;
+		return QLA_ERR_NOT_FOUND;
 	}
 
 	abt = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d294b590581e..1c5da2dbd6f9 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -227,11 +227,11 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	srb_t *sp = priv->sp;
 	fc_port_t *fcport = sp->fcport;
 	struct qla_hw_data *ha = fcport->vha->hw;
-	int rval;
+	int rval, abts_done_called = 1;
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0xffff,
-	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
-	       __func__, sp, sp->handle, fcport, fcport->deleted);
+	       "%s called for sp=%p, hndl=%x on fcport=%p desc=%p deleted=%d\n",
+	       __func__, sp, sp->handle, fcport, sp->u.iocb_cmd.u.nvme.desc, fcport->deleted);
 
 	if (!ha->flags.fw_started || fcport->deleted == QLA_SESS_DELETED)
 		goto out;
@@ -251,12 +251,20 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	    __func__, (rval != QLA_SUCCESS) ? "Failed to abort" : "Aborted",
 	    sp, sp->handle, fcport, rval);
 
+	/*
+	 * If async tmf is enabled, the abort callback is called only on
+	 * return codes QLA_SUCCESS and QLA_ERR_FROM_FW.
+	 */
+	if (ql2xasynctmfenable &&
+	    rval != QLA_SUCCESS && rval != QLA_ERR_FROM_FW)
+		abts_done_called = 0;
+
 	/*
 	 * Returned before decreasing kref so that I/O requests
 	 * are waited until ABTS complete. This kref is decreased
 	 * at qla24xx_abort_sp_done function.
 	 */
-	if (ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(sp))
+	if (abts_done_called && ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(sp))
 		return;
 out:
 	/* kref_get was done before work was schedule. */
@@ -804,14 +812,14 @@ void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, srb_t *ori
 	case CS_PORT_LOGGED_OUT:
 	/* BA_RJT was received for the ABTS */
 	case CS_PORT_CONFIG_CHG:
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09d,
+		ql_dbg(ql_dbg_async, vha, 0xf09d,
 		       "Abort I/O IOCB completed with error, comp_status=%x\n",
 		comp_status);
 		break;
 
 	/* BA_RJT was received for the ABTS */
 	case CS_REJECT_RECEIVED:
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
+		ql_dbg(ql_dbg_async, vha, 0xf09e,
 		       "BA_RJT was received for the ABTS rjt_vendorUnique = %u",
 			abt->fw.ba_rjt_vendorUnique);
 		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
@@ -820,18 +828,18 @@ void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, srb_t *ori
 		break;
 
 	case CS_COMPLETE:
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09f,
+		ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0xf09f,
 		       "IOCB request is completed successfully comp_status=%x\n",
 		comp_status);
 		break;
 
 	case CS_IOCB_ERROR:
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a0,
+		ql_dbg(ql_dbg_async, vha, 0xf0a0,
 		       "IOCB request is failed, comp_status=%x\n", comp_status);
 		break;
 
 	default:
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a1,
+		ql_dbg(ql_dbg_async, vha, 0xf0a1,
 		       "Invalid Abort IO IOCB Completion Status %x\n",
 		comp_status);
 		break;
-- 
2.23.1

