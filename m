From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 10/15] qla2xxx: Fix request queue corruption.
Date: Thu, 2 Feb 2017 11:42:33 -0800
Message-ID: <1486064558-365-11-git-send-email-himanshu.madhani@cavium.com>
References: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0084.outbound.protection.outlook.com ([104.47.37.84]:8160
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751500AbdBBT7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 14:59:04 -0500
In-Reply-To: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

When FW notify driver or driver detects low FW resource,
driver tries to send out Busy SCSI Status to tell Initiator
side to back off. During the send process, the lock was not held.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ab9f4e7..1bd4eff 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5187,16 +5187,22 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 
 static int
 qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha,
-	struct atio_from_isp *atio)
+	struct atio_from_isp *atio, uint8_t ha_locked)
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
 
@@ -5241,7 +5247,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 
 
 		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
-			rc = qlt_chk_qfull_thresh_hold(vha, atio);
+			rc = qlt_chk_qfull_thresh_hold(vha, atio, ha_locked);
 			if (rc != 0) {
 				tgt->atio_irq_cmd_count--;
 				return;
@@ -5364,7 +5370,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			break;
 		}
 
-		rc = qlt_chk_qfull_thresh_hold(vha, atio);
+		rc = qlt_chk_qfull_thresh_hold(vha, atio, 1);
 		if (rc != 0) {
 			tgt->irq_cmd_count--;
 			return;
-- 
1.8.3.1
