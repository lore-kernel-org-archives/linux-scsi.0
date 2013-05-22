From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 02/12] megaraid_sas : Fix the interrupt mask for Gen2
 controller
Date: Wed, 22 May 2013 12:29:54 +0530
Message-ID: <201305221230.r4MCUAoU011934@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:43127
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474Ab3EVMaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:30:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Fix the interrupt mask for Gen2 controller.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 758ea2e..c79daf5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -711,7 +711,7 @@ megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
 	 */
 	status = readl(&regs->outbound_intr_status);
 
-	if (status & MFI_GEN2_ENABLE_INTERRUPT_MASK) {
+	if (status & MFI_INTR_FLAG_REPLY_MESSAGE) {
 		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
 	}
 	if (status & MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT) {

