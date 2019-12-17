Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8110C2D0BF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B71920716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AfAT90j6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfLQWHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfLQWHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5eEi030252;
        Tue, 17 Dec 2019 14:06:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=SDbvJtU3roYOI7CiVauVB9hPw7X40NhAxoM3ijObLq0=;
 b=AfAT90j6N25lOb7JqniCLc8rxvKHFT4lgNy6+gQy+/xuQclYLz5MsLX5movhIB0LNLsN
 vO9SpIczRykf9NG6TMzGLoz0JSh3vyvCB516SopWb4UiuuXu8hJ0tYl2HYnZAmrnk7AO
 j/ONNt/Dz8XJvR0r64y6ooD8p56ZG+F94C9NB84csSLEnPLvEj6ksTi4/QfPv2QOrXrU
 anmSaK9PnFQ5yp3Q+QsJdm1XcDFyfJvYx4dVWGf5C6751ZDNuWNtH7heD1R/KO1lkpgb
 /topWFLft259+6ZzbxzQ5oidCot6RB7OAywcce4UncyS96Cn5SlOw8locutfS1Zi9AUj ww== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm224-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:06:58 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:41 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4E8D03F703F;
        Tue, 17 Dec 2019 14:06:41 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6faA028159;
        Tue, 17 Dec 2019 14:06:41 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6fG1028158;
        Tue, 17 Dec 2019 14:06:41 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 08/14] qla2xxx: Fix stuck login session using prli_pend_timer
Date:   Tue, 17 Dec 2019 14:06:11 -0800
Message-ID: <20191217220617.28084-9-hmadhani@marvell.com>
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

Session is stuck if driver sees FW has received a PRLI. Driver
allows FW to finish with processing of PRLI by checking back with
FW at a later time to see if the PRLI has finished. Instead, driver
failed to push forward after re-checking PRLI completion.

Fixes: 974950710e2a ("qla2xxx: Fix stuck login session")
Cc: stable@vger.kernel.org # 5.3
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  5 +++++
 drivers/scsi/qla2xxx/qla_init.c   | 34 ++++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3b9ecdeecc8e..90dae8f2d080 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2402,6 +2402,7 @@ typedef struct fc_port {
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
+	unsigned int prli_pend_timer:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2428,6 +2429,7 @@ typedef struct fc_port {
 	struct work_struct free_work;
 	struct work_struct reg_work;
 	uint64_t jiffies_at_registration;
+	unsigned long prli_expired;
 	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
 
 	uint16_t tgt_id;
@@ -4858,6 +4860,9 @@ struct sff_8247_a0 {
 	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
 	NVME_ONLY_TARGET(fcport)) \
 
+#define PRLI_PHASE(_cls) \
+	((_cls == DSC_LS_PRLI_PEND) || (_cls == DSC_LS_PRLI_COMP))
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 67f7c21edb4c..37aad8da7934 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -675,7 +675,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	port_id_t id;
 	u64 wwn;
 	u16 data[2];
-	u8 current_login_state;
+	u8 current_login_state, nvme_cls;
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -734,10 +734,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		if (NVME_TARGET(vha->hw, fcport))
-			current_login_state = e->current_login_state >> 4;
-		else
-			current_login_state = e->current_login_state & 0xf;
+		nvme_cls = e->current_login_state >> 4;
+		current_login_state = e->current_login_state & 0xf;
+
+		if (PRLI_PHASE(nvme_cls)) {
+			current_login_state = nvme_cls;
+			fcport->fc4_type &= ~FS_FC4TYPE_FCP;
+			fcport->fc4_type |= FS_FC4TYPE_NVME;
+		} else if (PRLI_PHASE(current_login_state)) {
+			fcport->fc4_type |= FS_FC4TYPE_FCP;
+			fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+		}
 
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
 		    "%s found %8phC CLS [%x|%x] fc4_type %d ID[%06x|%06x] lid[%d|%d]\n",
@@ -1207,12 +1214,19 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
+		    __func__, __LINE__, fcport->port_name);
 		return rval;
+	}
 
-	if (fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
-	    fcport->fw_login_state == DSC_LS_PRLI_PEND)
+	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
+	    fcport->fw_login_state == DSC_LS_PRLI_PEND) &&
+	    qla_dual_mode_enabled(vha)) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
+		    __func__, __LINE__, fcport->port_name);
 		return rval;
+	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1591,6 +1605,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			break;
 		default:
 			if (fcport->login_pause) {
+				ql_dbg(ql_dbg_disc, vha, 0x20d8,
+				    "%s %d %8phC exit\n",
+				    __func__, __LINE__,
+				    fcport->port_name);
 				fcport->last_rscn_gen = fcport->rscn_gen;
 				fcport->last_login_gen = fcport->login_gen;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fecc2b2aabf9..0ef76743a26d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1258,6 +1258,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
+	sess->prli_pend_timer = 0;
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 
 	qla24xx_chk_fcp_state(sess);
-- 
2.12.0

