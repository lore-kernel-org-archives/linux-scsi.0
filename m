From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 03/14] qla2xxx: Fix request queue corruption.
Date: Wed, 15 Mar 2017 09:48:45 -0700
Message-ID: <20170315164856.17255-4-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0063.outbound.protection.outlook.com ([104.47.34.63]:35020
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753099AbdCOQtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:11 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

When FW notify driver or driver detects low FW resource,
driver tries to send out Busy SCSI Status to tell Initiator
side to back off. During the send process, the lock was not held.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ecf97c5993e8..a463bcc57902 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5079,16 +5079,22 @@ qlt_send_busy(struct scsi_qla_host *vha,
 
 static int
 qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha,
-	struct atio_from_isp *atio)
+	struct atio_from_isp *atio, bool ha_locked)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t status;
+	unsigned long flags;
 
 	if (ha->tgt.num_pend_cmds < Q_FULL_THRESH_HOLD(ha))
 		return 0;
 
+	if (!ha_locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	status = temp_sam_status;
 	qlt_send_busy(vha, atio, status);
+	if (!ha_locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	return 1;
 }
 
@@ -5133,7 +5139,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 
 
 		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
-			rc = qlt_chk_qfull_thresh_hold(vha, atio);
+			rc = qlt_chk_qfull_thresh_hold(vha, atio, ha_locked);
 			if (rc != 0) {
 				tgt->atio_irq_cmd_count--;
 				return;
@@ -5256,7 +5262,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			break;
 		}
 
-		rc = qlt_chk_qfull_thresh_hold(vha, atio);
+		rc = qlt_chk_qfull_thresh_hold(vha, atio, true);
 		if (rc != 0) {
 			tgt->irq_cmd_count--;
 			return;
-- 
2.12.0
