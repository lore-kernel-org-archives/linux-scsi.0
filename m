From: vikas.chaudhary@qlogic.com
Subject: [PATCH 02/13] qla4xxx: Do not send mbox command if FW is in failed state
Date: Mon, 21 Mar 2011 03:34:25 -0700
Message-ID: <1300703676-27398-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46169 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753090Ab1CUKtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:49:15 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

FW is not able to process mbox command if FW state is failed. This will cause
mbox command to timeout and adapter reset. We have separate function to detect
FW failed state and do adapter reset. So to avoid mbox command timeout, do not
process mbox command in case of FW state failed.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f65626a..47b2591 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -32,6 +32,7 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 	u_long wait_count;
 	uint32_t intr_status;
 	unsigned long flags = 0;
+	uint32_t dev_state;
 
 	/* Make sure that pointers are valid */
 	if (!mbx_cmd || !mbx_sts) {
@@ -40,12 +41,23 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		return status;
 	}
 
-	if (is_qla8022(ha) &&
-	    test_bit(AF_FW_RECOVERY, &ha->flags)) {
-		DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: prematurely "
-		    "completing mbx cmd as firmware recovery detected\n",
-		    ha->host_no, __func__));
-		return status;
+	if (is_qla8022(ha)) {
+		if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
+			DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: "
+			    "prematurely completing mbx cmd as firmware "
+			    "recovery detected\n", ha->host_no, __func__));
+			return status;
+		}
+		/* Do not send any mbx cmd if h/w is in failed state*/
+		qla4_8xxx_idc_lock(ha);
+		dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		qla4_8xxx_idc_unlock(ha);
+		if (dev_state == QLA82XX_DEV_FAILED) {
+			ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: H/W is in "
+			    "failed state, do not send any mailbox commands\n",
+			    ha->host_no, __func__);
+			return status;
+		}
 	}
 
 	if ((is_aer_supported(ha)) &&
-- 
1.7.3.2

