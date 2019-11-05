Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ADDC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E01A6214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AzEsG8qR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731127AbfKEPHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45102 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730939AbfKEPHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ExrDL009715;
        Tue, 5 Nov 2019 07:07:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=T3exIOUAVw99DVYXYe9OsHwr5tWK39Ff6zm+uTZFoDY=;
 b=AzEsG8qRHts+vg4w3qrq4M7AA5hf+4w/mIxqpkkqHZfaKLQ2xoVxN7wh6ZpazVIKtAFf
 /OmTcuYCo2TTl5WOfwCUskF2fLkIx1vxtI3t6ViCMputMuqF0rX4YjxXnM8TRYfk7tWt
 TAsvQ0gAb8an1+epoJj0wL94yPLeVEseHTavPAhwPl51glgebZk1F3+4Bg1cDlCS//Bm
 bQwQj5Zd8cfSfTM1Wauaek08FxUPfbh+jlpTtDBBPBrEBB62G/kz71GlExL67xkfMYxq
 cBirZwhoILctbIdrXlBmIQLncDq1xHpIHQ/2VJ12ZEN2Bsfk957DheaI8v6HsyNa9w+e Ew== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n93cm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:07 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:07 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E0C353F703F;
        Tue,  5 Nov 2019 07:07:06 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F76u4008147;
        Tue, 5 Nov 2019 07:07:06 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F76bd008146;
        Tue, 5 Nov 2019 07:07:06 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/8] qla2xxx: Fix SRB leak on switch command timeout
Date:   Tue, 5 Nov 2019 07:06:52 -0800
Message-ID: <20191105150657.8092-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

when GPSC/GPDB switch command fails, driver just returns
without doing a proper cleanup. This patch fixes this memory
leak by calling sp->free() in the error path.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
 drivers/scsi/qla2xxx/qla_mbx.c  |  4 ----
 drivers/scsi/qla2xxx/qla_mid.c  | 11 ++++-------
 drivers/scsi/qla2xxx/qla_os.c   |  7 ++++++-
 5 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7a00272ca380..67230688b05e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3010,7 +3010,7 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, int res)
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
 	if (res == QLA_FUNCTION_TIMEOUT)
-		return;
+		goto done;
 
 	if (res == (DID_ERROR << 16)) {
 		/* entry status error */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7fdbe041cc19..bddb26baedd2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1151,19 +1151,18 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
 	    "Async done-%s res %x, WWPN %8phC mb[1]=%x mb[2]=%x \n",
 	    sp->name, res, fcport->port_name, mb[1], mb[2]);
 
-	if (res == QLA_FUNCTION_TIMEOUT) {
-		dma_pool_free(sp->vha->hw->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
-			sp->u.iocb_cmd.u.mbx.in_dma);
-		return;
-	}
-
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
+	if (res == QLA_FUNCTION_TIMEOUT)
+		goto done;
+
 	memset(&ea, 0, sizeof(ea));
 	ea.fcport = fcport;
 	ea.sp = sp;
 
 	qla24xx_handle_gpdb_event(vha, &ea);
 
+done:
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 04175c91af0e..0cf94f05f008 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6288,17 +6288,13 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	case  QLA_SUCCESS:
 		ql_dbg(ql_dbg_mbx, vha, 0x119d, "%s: %s done.\n",
 		    __func__, sp->name);
-		sp->free(sp);
 		break;
 	default:
 		ql_dbg(ql_dbg_mbx, vha, 0x119e, "%s: %s Failed. %x.\n",
 		    __func__, sp->name, rval);
-		sp->free(sp);
 		break;
 	}
 
-	return rval;
-
 done_free_sp:
 	sp->free(sp);
 done:
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 6afad68e5ba2..bd62c4595b73 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -944,7 +944,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
-		goto done;
+		return rval;
 
 	sp->type = SRB_CTRL_VP;
 	sp->name = "ctrl_vp";
@@ -960,7 +960,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 		ql_dbg(ql_dbg_async, vha, 0xffff,
 		    "%s: %s Failed submission. %x.\n",
 		    __func__, sp->name, rval);
-		goto done_free_sp;
+		goto done;
 	}
 
 	ql_dbg(ql_dbg_vport, vha, 0x113f, "%s hndl %x submitted\n",
@@ -978,16 +978,13 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	case QLA_SUCCESS:
 		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s done.\n",
 		    __func__, sp->name);
-		goto done_free_sp;
+		break;
 	default:
 		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s Failed. %x.\n",
 		    __func__, sp->name, rval);
-		goto done_free_sp;
+		break;
 	}
 done:
-	return rval;
-
-done_free_sp:
 	sp->free(sp);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 588e0d27f151..2e7a4a2d6c5a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -996,7 +996,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
 		if (rval == QLA_INTERFACE_ERROR)
-			goto qc24_fail_command;
+			goto qc24_free_sp_fail_command;
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1008,6 +1008,11 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
+qc24_free_sp_fail_command:
+	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
+
 qc24_fail_command:
 	cmd->scsi_done(cmd);
 
-- 
2.12.0

