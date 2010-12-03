From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/12] qla4xxx: do not process interrupt unconditionally
Date: Thu, 2 Dec 2010 22:12:27 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411C@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3247 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0LCGMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:30 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Lalit Chandivade <lalit.chandivade@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

in mailbox command do not process interrupt unconditionally,
process interrupt only in polling mode

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 8961d4c..b7e43b1 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -81,23 +81,7 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (is_qla8022(ha)) {
-		intr_status = readl(&ha->qla4_8xxx_reg->host_int);
-		if (intr_status & ISRX_82XX_RISC_INT) {
-			/* Service existing interrupt */
-			DEBUG2(printk("scsi%ld: %s: "
-			    "servicing existing interrupt\n",
-			    ha->host_no, __func__));
-			intr_status = readl(&ha->qla4_8xxx_reg->host_status);
-			ha->isp_ops->interrupt_service_routine(ha, intr_status);
-			clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
-			if (test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
-			    test_bit(AF_INTx_ENABLED, &ha->flags))
-				qla4_8xxx_wr_32(ha,
-				    ha->nx_legacy_intr.tgt_mask_reg,
-				    0xfbff);
-		}
-	} else {
+	if (!is_qla8022(ha)) {
 		intr_status = readl(&ha->reg->ctrl_status);
 		if (intr_status & CSR_SCSI_PROCESSOR_INTR) {
 			/* Service existing interrupt */
-- 
1.7.3.2

