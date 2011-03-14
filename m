From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/13] qla4xxx: Do not send mbox command if FW is in failed
 state
Date: Sun, 13 Mar 2011 22:24:01 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1508@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46049
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab1CNFYI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:24:08 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

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
+       uint32_t dev_state;

        /* Make sure that pointers are valid */
        if (!mbx_cmd || !mbx_sts) {
@@ -40,12 +41,23 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
                return status;
        }

-       if (is_qla8022(ha) &&
-           test_bit(AF_FW_RECOVERY, &ha->flags)) {
-               DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: prematurely "
-                   "completing mbx cmd as firmware recovery detected\n",
-                   ha->host_no, __func__));
-               return status;
+       if (is_qla8022(ha)) {
+               if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
+                       DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: "
+                           "prematurely completing mbx cmd as firmware "
+                           "recovery detected\n", ha->host_no, __func__));
+                       return status;
+               }
+               /* Do not send any mbx cmd if h/w is in failed state*/
+               qla4_8xxx_idc_lock(ha);
+               dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+               qla4_8xxx_idc_unlock(ha);
+               if (dev_state == QLA82XX_DEV_FAILED) {
+                       ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: H/W is in "
+                           "failed state, do not send any mailbox commands\n",
+                           ha->host_no, __func__);
+                       return status;
+               }
        }

        if ((is_aer_supported(ha)) &&
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

