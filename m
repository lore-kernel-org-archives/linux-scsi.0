From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Fri, 19 May 2017 14:53:39 -0700
Message-ID: <20170519215344.2168-21-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:21572
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756823AbdESVyZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:25 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

During ABTS or Abort task, qla2xxx does a pre-search for
the se_cmd, based on command's tag. The same search is
performed by TCM. Remove the extra search from qla2xxx.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 21e8993baf4b..b8e609ae6cff 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1836,34 +1836,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct fc_port *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	struct se_cmd *se_cmd;
 	int rc;
-	bool found_lun = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			found_lun = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
-	/* cmd not in LIO lists, look in qla list */
-	if (!found_lun) {
-		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
-			/* send TASK_ABORT response immediately */
-			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
-			return 0;
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
-			    "unable to find cmd in driver or LIO for tag 0x%x\n",
-			    abts->exchange_addr_to_abort);
-			return -ENOENT;
-		}
+	if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
+		/* send TASK_ABORT response immediately */
+		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
+		return 0;
 	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
-- 
2.12.0
