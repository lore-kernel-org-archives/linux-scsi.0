From: vikas.chaudhary@qlogic.com
Subject: [PATCH 4/8] qla4xxx: Fix double reset in case of firmware hung for ISP83XX
Date: Thu,  7 Mar 2013 05:43:10 -0500
Message-ID: <1362652994-7593-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:43100 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754374Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

In case of firmware hung we need to call "mailbox_premature_completion" to
complete any pending mbox command as firmware is not alive.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b3ccb1a..ade1ba6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2543,6 +2543,7 @@ static void qla4_8xxx_process_fw_error(struct scsi_qla_host *ha)
 void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 {
 	uint32_t dev_state;
+	uint32_t idc_ctrl;
 
 	/* don't poll if reset is going on */
 	if (!(test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
@@ -2561,10 +2562,23 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 			qla4xxx_wake_dpc(ha);
 		} else if (dev_state == QLA8XXX_DEV_NEED_RESET &&
 			   !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+
+			ql4_printk(KERN_INFO, ha, "%s: HW State: NEED RESET!\n",
+				   __func__);
+
+			if (is_qla8032(ha)) {
+				idc_ctrl = qla4_83xx_rd_reg(ha,
+							QLA83XX_IDC_DRV_CTRL);
+				if (!(idc_ctrl & GRACEFUL_RESET_BIT1)) {
+					ql4_printk(KERN_INFO, ha, "%s: Graceful reset bit is not set\n",
+						   __func__);
+					qla4xxx_mailbox_premature_completion(
+									    ha);
+				}
+			}
+
 			if (is_qla8032(ha) ||
 			    (is_qla8022(ha) && !ql4xdontresethba)) {
-				ql4_printk(KERN_INFO, ha, "%s: HW State: "
-				    "NEED RESET!\n", __func__);
 				set_bit(DPC_RESET_HA, &ha->dpc_flags);
 				qla4xxx_wake_dpc(ha);
 			}
-- 
1.8.0

