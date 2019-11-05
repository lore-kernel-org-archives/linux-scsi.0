Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F3CC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C94A7206BA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GbgQPtBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfKEPHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730939AbfKEPHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F0W8e015804;
        Tue, 5 Nov 2019 07:07:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tQjI9dmo6tE9eRBtBIA9p7rE9acxBLKJqgn6wRIl0sw=;
 b=GbgQPtByl+eHbYaHz+cTHm0XE8NrNVXOUPE74sz/8NBPHToc3cEpOGm/rWpMrhnfNTeA
 xA8ZUPLDezCNXkwGNApuxgRgy07Clykg/KTBPEpxl9Xjg1jGR2S2VzYQLd4TPlxLYTYa
 hH1Xscqd8OiW7nrm+4I03Xv3D1j8YfmlsWcnkzePR6cIbnmZW8Crr5/8WBEQYkWaO7/L
 B7DYdCaUiCfi1fY1Pwt/cQj5dyqTShOS1OlfSr6snANHmAyMcsEKNhMVqunnoZOedTKc
 GXx5XEgAO5idYSVLsiDnLs7cky75xq/fzXQgu7ArvctIHpo8gC1qYw7L+nCTs6Kgf8gc Cg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtrhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:03 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:00 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:00 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 835263F703F;
        Tue,  5 Nov 2019 07:07:00 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F70kv008131;
        Tue, 5 Nov 2019 07:07:00 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F70L5008130;
        Tue, 5 Nov 2019 07:07:00 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/8] qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
Date:   Tue, 5 Nov 2019 07:06:50 -0800
Message-ID: <20191105150657.8092-2-hmadhani@marvell.com>
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

Current code will send PRLI with FC-NVMe bit set for the
targets which supports only FCP. This may result into issue
with targets which do not understand NVMe and will go into
strange state. This patch would restart the login process
by going back to PLOGI state. The PLOGI state will force the
target to respond to correct PRLI request.

Fixes: c76ae845ea836 ("scsi: qla2xxx: Add error handling for PLOGI ELS passthrough")
Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 37 ++++++++-----------------------------
 drivers/scsi/qla2xxx/qla_iocb.c |  6 +++++-
 2 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7cb7545de962..5db8ad832893 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1864,42 +1864,21 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * FCP/NVMe port
 		 */
 		if (NVME_FCP_TARGET(ea->fcport)) {
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-			else
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post %s prli\n",
 				__func__, __LINE__, ea->fcport->port_name,
 				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
 				"NVMe" : "FCP");
-			qla24xx_post_prli_work(vha, ea->fcport);
-			break;
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+			else
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 		}
 
-		/* at this point both PRLI NVME & PRLI FCP failed */
-		if (N2N_TOPO(vha->hw)) {
-			if (ea->fcport->n2n_link_reset_cnt < 3) {
-				ea->fcport->n2n_link_reset_cnt++;
-				/*
-				 * remote port is not sending Plogi. Reset
-				 * link to kick start his state machine
-				 */
-				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
-			} else {
-				ql_log(ql_log_warn, vha, 0x2119,
-				    "%s %d %8phC Unable to reconnect\n",
-				    __func__, __LINE__, ea->fcport->port_name);
-			}
-		} else {
-			/*
-			 * switch connect. login failed. Take connection
-			 * down and allow relogin to retrigger
-			 */
-			ea->fcport->flags &= ~FCF_ASYNC_SENT;
-			ea->fcport->keep_nport_handle = 0;
-			qlt_schedule_sess_for_deletion(ea->fcport);
-		}
+		ea->fcport->flags &= ~FCF_ASYNC_SENT;
+		ea->fcport->keep_nport_handle = 0;
+		ea->fcport->logout_on_delete = 1;
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index eeb526411536..2b675da34bda 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2764,6 +2764,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
 			break;
+
 		case CS_IOCB_ERROR:
 			switch (fw_status[1]) {
 			case LSC_SCODE_PORTID_USED:
@@ -2834,6 +2835,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
+				fcport->disc_state = DSC_LOGIN_FAILED;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2846,6 +2848,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			sp->fcport->disc_state = DSC_LOGIN_FAILED;
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2881,11 +2884,12 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		return -ENOMEM;
 	}
 
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-- 
2.12.0

