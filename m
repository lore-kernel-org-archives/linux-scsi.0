Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA22CC2D0D1
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7F2820716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g7gR+hMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfLQWHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfLQWHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBn029957;
        Tue, 17 Dec 2019 14:07:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=UTADna3545oxYLLybMOSZCurWDMU0Wn7f6JZEoEFftI=;
 b=g7gR+hMlPQdYvQg7Fe4F7yKNmWDgZr5WCSiQf89cCJzpvz9mm+ddLcC2ZRAudnIr059c
 CvzvIBuDRnD4P/7Vbxpph2qo34DJyw8lzTDF/ICkkMZovdEhIEUsqYaXavIiFBEEn6fA
 IyuLps6YlmNtiwtThU0NEdSIEMTARd26vvl95J7pMboiLZ8Zd7OkNjsDsnWw78srtBi5
 35LCs9tQRdrkzyuVXybcT3lq+vxfbIkdc7VB5rZvSOPaQ7R7aqdDGBlb1GcqKKb+vpeT
 ORPnXw6cTiNuDAp3uxPADhjcp2IorFM+Io6UxBtn0zOydpYqXmHrHeOkzz/PfVqe3onL BA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:24 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5B4A33F7040;
        Tue, 17 Dec 2019 14:06:24 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6OJL028127;
        Tue, 17 Dec 2019 14:06:24 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6OYo028126;
        Tue, 17 Dec 2019 14:06:24 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 02/14] qla2xxx: Fix fabric scan hang
Date:   Tue, 17 Dec 2019 14:06:05 -0800
Message-ID: <20191217220617.28084-3-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On timeout, SRB pointer was cleared from outstanding command
array and drop.  It was not allowed to go through the done
process and cleanup.  This patch will abort the SRB, where FW
will return it with an error status and resume the normal cleanup.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 34 +++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_iocb.c | 41 +++++++++++++++++++++++++++++++++--------
 3 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 51916183cbe9..0678d18144e3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -255,6 +255,7 @@ extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
+extern int qla24xx_async_abort_cmd(srb_t *, bool);
 
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c689e34a5235..0758b1cefffe 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -49,16 +49,9 @@ qla2x00_sp_timeout(struct timer_list *t)
 {
 	srb_t *sp = from_timer(sp, t, u.iocb_cmd.timer);
 	struct srb_iocb *iocb;
-	struct req_que *req;
-	unsigned long flags;
-	struct qla_hw_data *ha = sp->vha->hw;
 
-	WARN_ON_ONCE(irqs_disabled());
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = sp->qpair->req;
-	req->outstanding_cmds[sp->handle] = NULL;
+	WARN_ON(irqs_disabled());
 	iocb = &sp->u.iocb_cmd;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	iocb->timeout(sp);
 }
 
@@ -142,7 +135,7 @@ static void qla24xx_abort_sp_done(srb_t *sp, int res)
 		sp->free(sp);
 }
 
-static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
+int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
 	struct srb_iocb *abt_iocb;
@@ -242,6 +235,7 @@ qla2x00_async_iocb_timeout(void *data)
 	case SRB_NACK_PRLI:
 	case SRB_NACK_LOGO:
 	case SRB_CTRL_VP:
+	default:
 		rc = qla24xx_async_abort_cmd(sp, false);
 		if (rc) {
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
@@ -258,10 +252,6 @@ qla2x00_async_iocb_timeout(void *data)
 			sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
-	default:
-		WARN_ON_ONCE(true);
-		sp->done(sp, QLA_FUNCTION_TIMEOUT);
-		break;
 	}
 }
 
@@ -1758,9 +1748,23 @@ qla2x00_tmf_iocb_timeout(void *data)
 {
 	srb_t *sp = data;
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
+	int rc, h;
+	unsigned long flags;
 
-	tmf->u.tmf.comp_status = CS_TIMEOUT;
-	complete(&tmf->u.tmf.comp);
+	rc = qla24xx_async_abort_cmd(sp, false);
+	if (rc) {
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		tmf->u.tmf.comp_status = CS_TIMEOUT;
+		tmf->u.tmf.data = QLA_FUNCTION_FAILED;
+		complete(&tmf->u.tmf.comp);
+	}
 }
 
 static void qla2x00_tmf_sp_done(srb_t *sp, int res)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8b050f0b4333..15c76b9a4502 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2537,13 +2537,32 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 	fc_port_t *fcport = sp->fcport;
 	struct scsi_qla_host *vha = sp->vha;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	unsigned long flags = 0;
+	int res, h;
 
 	ql_dbg(ql_dbg_io, vha, 0x3069,
 	    "%s Timeout, hdl=%x, portid=%02x%02x%02x\n",
 	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
 	    fcport->d_id.b.al_pa);
 
-	complete(&lio->u.els_logo.comp);
+	/* Abort the exchange */
+	res = qla24xx_async_abort_cmd(sp, false);
+	if (res) {
+		ql_dbg(ql_dbg_io, vha, 0x3070,
+		    "mbx abort_command failed.\n");
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		complete(&lio->u.els_logo.comp);
+	} else {
+		ql_dbg(ql_dbg_io, vha, 0x3071,
+		    "mbx abort_command success.\n");
+	}
 }
 
 static void qla2x00_els_dcmd_sp_done(srb_t *sp, int res)
@@ -2717,23 +2736,29 @@ qla2x00_els_dcmd2_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct scsi_qla_host *vha = sp->vha;
-	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
-	int res;
+	int res, h;
 
 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3069,
 	    "%s hdl=%x ELS Timeout, %8phC portid=%06x\n",
 	    sp->name, sp->handle, fcport->port_name, fcport->d_id.b24);
 
 	/* Abort the exchange */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	res = ha->isp_ops->abort_command(sp);
+	res = qla24xx_async_abort_cmd(sp, false);
 	ql_dbg(ql_dbg_io, vha, 0x3070,
 	    "mbx abort_command %s\n",
 	    (res == QLA_SUCCESS) ? "successful" : "failed");
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	sp->done(sp, QLA_FUNCTION_TIMEOUT);
+	if (res) {
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		sp->done(sp, QLA_FUNCTION_TIMEOUT);
+	}
 }
 
 void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha, struct els_plogi *els_plogi)
-- 
2.12.0

