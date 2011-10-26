From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH] qla2xxx: Correct inadvertent clearing of RISC_INTR status.
Date: Wed, 26 Oct 2011 14:20:13 -0700
Message-ID: <1319664013-15758-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:27876
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab1JZVck (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Oct 2011 17:32:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

During heavy I/O (CPU-affinity mode enabled) and CLI/Agent
interactions, the driver would report periodic mailbox command
timeout statuses.  Within the CPU-affinity ISR handler, the
driver should check the 'disable-msix-handshake' flag in deciding
whether or not to clear HCCRX_CLR_RISC_INT.  The mode is not
specific to a dedicated queue, instead, applies to the current
'ha' context.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3474e86..2516adf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2279,7 +2279,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	ha = rsp->hw;
 
 	/* Clear the interrupt, if enabled, for this response queue */
-	if (rsp->options & ~BIT_6) {
+	if (!ha->flags.disable_msix_handshake) {
 		reg = &ha->iobase->isp24;
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-- 
1.6.0.2


