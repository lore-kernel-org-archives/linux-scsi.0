From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 10/14] qla2xxx: Fix request queue corruption.
Date: Fri, 24 Feb 2017 13:37:39 -0800
Message-ID: <1487972263-3795-11-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0087.outbound.protection.outlook.com ([104.47.37.87]:47259
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751301AbdBXViR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:38:17 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
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
index a09e4a5..b5864e5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5183,16 +5183,22 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 
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
 
@@ -5237,7 +5243,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 
 
 		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
-			rc = qlt_chk_qfull_thresh_hold(vha, atio);
+			rc = qlt_chk_qfull_thresh_hold(vha, atio, ha_locked);
 			if (rc != 0) {
 				tgt->atio_irq_cmd_count--;
 				return;
@@ -5360,7 +5366,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			break;
 		}
 
-		rc = qlt_chk_qfull_thresh_hold(vha, atio);
+		rc = qlt_chk_qfull_thresh_hold(vha, atio, true);
 		if (rc != 0) {
 			tgt->irq_cmd_count--;
 			return;
-- 
1.8.3.1
