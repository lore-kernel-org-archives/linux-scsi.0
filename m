Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9A6C0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbjHALl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbjHALlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:25 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82CB1716
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:23 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371AacDP014807
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=n4BAmTAA/H8cVXtQH66tNuB5ydtzsVQpvOUwQwWRH+4=;
 b=CFYr/WHTd31fLO8jVp3bqK3gpDFD7EUbs4RX0lSWaTPw02dEjptaq7voINpD6Rdv9CH0
 gbS3UmT63u7leuOfNXomCJoHlvYSUP/Fsj++kBIUGeFPgpQgI/z00SkNv9qHPtjRibG1
 Tt2Aj2EVgz+1T+8gNBew1wfSFa5mvs3fyPnAMp83Oi4xWqhn2idfHRNtRcAzsrGsULou
 RF94Bf4eXJMX9G0Xe+3+Y9NF44clNWHJxG0O0MPAHnp7MnJIa3V7CryOtFUTzSGptocl
 tS7cwcTFdqdu2H6uCLNM4VWvSr+iP8g5sw/ioT3K7dhzjWZ/fvuYMbCLbin++5Chwvvi PA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s529k8e4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:20 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 7DBA93F70D7;
        Tue,  1 Aug 2023 04:41:16 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 07/10] qla2xxx: Observed call trace in smp_processor_id()
Date:   Tue, 1 Aug 2023 17:10:54 +0530
Message-ID: <20230801114057.27039-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: q9zUPcFVvb86lucvMqfjb6LVXQJceSCX
X-Proofpoint-ORIG-GUID: q9zUPcFVvb86lucvMqfjb6LVXQJceSCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Following Call Trace was observed,

localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
localhost kernel: Call Trace:
localhost kernel: dump_stack_lvl+0x57/0x7d
localhost kernel: check_preemption_disabled+0xc8/0xd0
localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]

Use raw_smp_processor_id api instead of smp_processor_id

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_inline.h  | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c     | 6 +++---
 drivers/scsi/qla2xxx/qla_target.c  | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 0556969f6dc1..a4a56ab0ba74 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -577,7 +577,7 @@ fcport_is_bigger(fc_port_t *fcport)
 static inline struct qla_qpair *
 qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
 {
-	int cpuid = smp_processor_id();
+	int cpuid = raw_smp_processor_id();
 
 	if (qpair->cpuid != cpuid &&
 	    ha->qp_cpu_map[cpuid]) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e98788191897..01fc300d640f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3965,7 +3965,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (!ha->flags.fw_started)
 		return;
 
-	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
+	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
 		rsp->qpair->rcv_intr = 1;
 
 		if (!rsp->qpair->cpu_mapped)
@@ -4468,7 +4468,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = qpair->hw;
 
-	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
+	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
@@ -4494,7 +4494,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
+	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2b815a9928ea..9278713c3021 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4425,7 +4425,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
 	} else if (ha->msix_count) {
 		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
-			queue_work_on(smp_processor_id(), qla_tgt_wq,
+			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,
 			    &cmd->work);
 		else
 			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3b5ba4b47b3b..9566f0384353 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -310,7 +310,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->trc_flags |= TRC_CMD_DONE;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 /*
@@ -547,7 +547,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	cmd->trc_flags |= TRC_DATA_IN;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)
-- 
2.23.1

