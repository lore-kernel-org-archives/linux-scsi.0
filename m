From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 19/31] qla2xxx: Fix task mgmt handling for NPIV
Date: Wed, 23 Aug 2017 15:05:13 -0700
Message-ID: <20170823220525.3115-20-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0071.outbound.protection.outlook.com ([104.47.36.71]:21680
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751093AbdHWWFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:55 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Fix task management response for NPIV Target mode.
Current code uses the wrong vp index.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 7 ++++++-
 drivers/scsi/qla2xxx/qla_target.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6a6d9db6479f..4f1621fd5ef2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1901,6 +1901,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->reset_count = ha->base_qpair->chip_reset;
 	mcmd->tmr_func = QLA_TGT_ABTS;
 	mcmd->qpair = ha->base_qpair;
+	mcmd->vha = vha;
 
 	/*
 	 * LUN is looked up by target-core internally based on the passed
@@ -2003,7 +2004,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 static void qlt_24xx_send_task_mgmt_ctio(struct qla_qpair *qpair,
 	struct qla_tgt_mgmt_cmd *mcmd, uint32_t resp_code)
 {
-	struct scsi_qla_host *ha = qpair->vha;
+	struct scsi_qla_host *ha = mcmd->vha;
 	struct atio_from_isp *atio = &mcmd->orig_iocb.atio;
 	struct ctio7_to_24xx *ctio;
 	uint16_t temp;
@@ -3464,6 +3465,9 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe009, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
 
+	if (cmd)
+		vha = cmd->vha;
+
 	pkt = (request_t *)qla2x00_alloc_iocbs_ready(qpair, NULL);
 	if (pkt == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe050,
@@ -4379,6 +4383,7 @@ static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	mcmd->flags = flags;
 	mcmd->reset_count = ha->base_qpair->chip_reset;
 	mcmd->qpair = ha->base_qpair;
+	mcmd->vha = vha;
 
 	switch (fn) {
 	case QLA_TGT_LUN_RESET:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 7fe02d036bdf..96fce43e1e46 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -959,6 +959,7 @@ struct qla_tgt_mgmt_cmd {
 	uint8_t fc_tm_rsp;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
+	struct scsi_qla_host *vha;
 	struct se_cmd se_cmd;
 	struct work_struct free_work;
 	unsigned int flags;
-- 
2.12.0
