Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AE3C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbiCJJ13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240796AbiCJJ10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C56139CE6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxG024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=d2dO3WFvqi5qAeDslraGmyGTq8RQN1JLa2HvwUzHmBk=;
 b=k2dJBvaCCc9QRYfPr3UjpxX2ylrmKuS8atIfr4Sxn5Ovv1W18sISe+JN1ww6EQc5T2/X
 ZO/A6xeQRAVGW+17+qwhhiOnQ3F/Fsdlbh03ZEUil2i+mEVZ1dk1UxSB4zxodwcY99cM
 GG8/r5qIBd7KxTuN+UIDlu3frT1ovRBAo8JOQYtcnq218Q7sJqV4rNkrisuWQq2N6ndo
 yr/6RleYQ6sYGv/CwpjQGs/yK2ak00J4wY2d7sTeDJFsDHnPHSxfiyRFL11SC7S+HASV
 JXh778OMZpCa87ml2BekZZtqLN52pv2x40ZPROzH0uyk8gM0F7lU87Lv5yX5jiaWHx1P cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:22 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DA5133F705A;
        Thu, 10 Mar 2022 01:26:22 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QMA8022993;
        Thu, 10 Mar 2022 01:26:22 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QM0e022992;
        Thu, 10 Mar 2022 01:26:22 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 02/13] qla2xxx: Fix disk failure to rediscover
Date:   Thu, 10 Mar 2022 01:25:53 -0800
Message-ID: <20220310092604.22950-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: KtKnm0jGdvrvccPFuyYlisEFTomspPc6
X-Proofpoint-ORIG-GUID: KtKnm0jGdvrvccPFuyYlisEFTomspPc6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experience some of the LUN failed to rediscovered after
long cable pull test. The issue is triggered by a race
condition between driver setting session online state vs
starting the LUN scan process at the same time. Current code
set the online state after notifying the session is
available. In this case, trigger to start the LUN scan process happened
before driver could set the session in online state.
LUN scan ends up with failure due to the session
online check was failing.

Set the online state before reporting of the availability of the session.

Cc: stable@vger.kernel.org
Fixes: aecf043443d3 ("scsi: qla2xxx: Fix Remote port registration")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 drivers/scsi/qla2xxx/qla_nvme.c | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 835ed4179887..6ffe44b805b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5758,6 +5758,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5858,6 +5860,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5875,8 +5878,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (NVME_TARGET(vha->hw, fcport))
 		qla_nvme_register_remote(vha, fcport);
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 718c761ff5f8..5723082d94d6 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -37,6 +37,11 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		return 0;
+
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));
-- 
2.19.0.rc0

