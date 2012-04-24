From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/6] qla4xxx: Correct early completion of pending mbox.
Date: Mon, 23 Apr 2012 22:32:32 -0700
Message-ID: <1335245557-17169-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:38525
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab2DXFsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 01:48:09 -0400
In-Reply-To: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Check for Firmware Hang (AF_FW_RECOVERY) after mailbox command
has gained access to ensure that the mailbox command does not
wait un-necessarily during a firmware recovery and prevent
premature mailbox timeout which will lead to back to back reset's.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 7ac21da..c7d101e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -51,25 +51,6 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		}
 	}
 
-	if (is_qla8022(ha)) {
-		if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
-			DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: "
-			    "prematurely completing mbx cmd as firmware "
-			    "recovery detected\n", ha->host_no, __func__));
-			return status;
-		}
-		/* Do not send any mbx cmd if h/w is in failed state*/
-		qla4_8xxx_idc_lock(ha);
-		dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-		qla4_8xxx_idc_unlock(ha);
-		if (dev_state == QLA82XX_DEV_FAILED) {
-			ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: H/W is in "
-			    "failed state, do not send any mailbox commands\n",
-			    ha->host_no, __func__);
-			return status;
-		}
-	}
-
 	if ((is_aer_supported(ha)) &&
 	    (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))) {
 		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Perm failure on EEH, "
@@ -96,6 +77,25 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		msleep(10);
 	}
 
+	if (is_qla8022(ha)) {
+		if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
+			DEBUG2(ql4_printk(KERN_WARNING, ha,
+					  "scsi%ld: %s: prematurely completing mbx cmd as firmware recovery detected\n",
+					  ha->host_no, __func__));
+			goto mbox_exit;
+		}
+		/* Do not send any mbx cmd if h/w is in failed state*/
+		qla4_8xxx_idc_lock(ha);
+		dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		qla4_8xxx_idc_unlock(ha);
+		if (dev_state == QLA82XX_DEV_FAILED) {
+			ql4_printk(KERN_WARNING, ha,
+				   "scsi%ld: %s: H/W is in failed state, do not send any mailbox commands\n",
+				   ha->host_no, __func__);
+			goto mbox_exit;
+		}
+	}
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	ha->mbox_status_count = outCount;
-- 
1.7.9.1.265.gb3a76


