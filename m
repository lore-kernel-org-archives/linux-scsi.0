Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC0AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 09:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiK2J1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Nov 2022 04:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiK2J1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2022 04:27:03 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B67B5B861
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2022 01:27:03 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT3No4N005645;
        Tue, 29 Nov 2022 01:27:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TTg0j0anYf4H7id0qGrJCclv0dg5QszxlwBWWjmxLsE=;
 b=C4+mqiCzzKbP7xu/8vfGliV97gmtAwvL9MWkMedwxFhfoI27FgSs3pbFe8Zae0FVTAhF
 m9cH7pOVyA2GfyKfZo6LXUUYXpl1M5moeqOfPCB28tIWnDabTJ/EkbIaod8C3FeAh6Yn
 Yu7FdKkcNy26Wfd3eM9rwFvsC59ubiANhiJX6lhLJTMmLTZ0DwcvRKREGQ8TrkWIaPWV
 xvQBfrmb7cSoE8yYZmbcMq4qRQww9tAeFyzJ4JjRA8LC5QNw0vssPnh0OZ8ObSTaGtIF
 pdQLX0wgkKixldllJrAbR7G06u/8avfP04bLiPQt5NEk2BtLe7No2bZp3s6mqqLfnFd0 /w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509889-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 01:26:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Nov
 2022 01:26:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 01:26:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 094E03F7044;
        Tue, 29 Nov 2022 01:26:58 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>,
        <mpatalan@redhat.com>
Subject: [PATCH] qla2xxx: Fix crash when IO abort times out
Date:   Tue, 29 Nov 2022 01:26:34 -0800
Message-ID: <20221129092634.15347-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gyBzcpuXx8IVfk4kQ-sGEPCj9COpj3ZH
X-Proofpoint-GUID: gyBzcpuXx8IVfk4kQ-sGEPCj9COpj3ZH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_06,2022-11-28_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

While performing CPU hotplug, a crash with the following stack was
seen:

Call Trace:
     qla24xx_process_response_queue+0x42a/0x970 [qla2xxx]
     qla2x00_start_nvme_mq+0x3a2/0x4b0 [qla2xxx]
     qla_nvme_post_cmd+0x166/0x240 [qla2xxx]
     nvme_fc_start_fcp_op.part.0+0x119/0x2e0 [nvme_fc]
     blk_mq_dispatch_rq_list+0x17b/0x610
     __blk_mq_sched_dispatch_requests+0xb0/0x140
     blk_mq_sched_dispatch_requests+0x30/0x60
     __blk_mq_run_hw_queue+0x35/0x90
     __blk_mq_delay_run_hw_queue+0x161/0x180
     blk_execute_rq+0xbe/0x160
     __nvme_submit_sync_cmd+0x16f/0x220 [nvme_core]
     nvmf_connect_admin_queue+0x11a/0x170 [nvme_fabrics]
     nvme_fc_create_association.cold+0x50/0x3dc [nvme_fc]
     nvme_fc_connect_ctrl_work+0x19/0x30 [nvme_fc]
     process_one_work+0x1e8/0x3c0

On abort timeout, an IO completion was called without
checking if that was already completed or not leading
up to a crash.

Verify IO and abort request are indeed outstanding before
attempting completion.

Fixes: ca66aa0949a0 ("scsi: qla2xxx: Do command completion on abort timeout")
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 29ce6a55ce5e..ee5927cb51ca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -110,6 +110,7 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	struct qla_qpair *qpair = sp->qpair;
 	u32 handle;
 	unsigned long flags;
+	int sp_found = 0, cmdsp_found = 0;
 
 	if (sp->cmd_sp)
 		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
@@ -124,18 +125,21 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
 		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
-		    sp->cmd_sp))
+		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			cmdsp_found = 1;
+		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			sp_found = 1;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp) {
+	if (cmdsp_found && sp->cmd_sp) {
 		/*
 		 * This done function should take care of
 		 * original command ref: INIT
@@ -143,8 +147,10 @@ static void qla24xx_abort_iocb_timeout(void *data)
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
 	}
 
-	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
-	sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	if (sp_found) {
+		abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
+		sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	}
 }
 
 static void qla24xx_abort_sp_done(srb_t *sp, int res)
-- 
2.19.0.rc0

