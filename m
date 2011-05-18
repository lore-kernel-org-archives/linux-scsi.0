From: vikas.chaudhary@qlogic.com
Subject: [PATCH 05/10] qla4xxx: Don't process mbx interrupt unconditionally
Date: Tue, 17 May 2011 23:17:07 -0700
Message-ID: <1305699432-13225-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50928 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754512Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Do not process interrupt unconditionally during mailbox processing  which can
lead to spurious interrupt. Mailbox completion are now polled if interrupt are
disabled or wait for interrupt to come in if its enabled

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f9d81c8..a1df53c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -86,22 +86,8 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		msleep(10);
 	}
 
-	/* To prevent overwriting mailbox registers for a command that has
-	 * not yet been serviced, check to see if an active command
-	 * (AEN, IOCB, etc.) is interrupting, then service it.
-	 * -----------------------------------------------------------------
-	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (!is_qla8022(ha)) {
-		intr_status = readl(&ha->reg->ctrl_status);
-		if (intr_status & CSR_SCSI_PROCESSOR_INTR) {
-			/* Service existing interrupt */
-			ha->isp_ops->interrupt_service_routine(ha, intr_status);
-			clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
-		}
-	}
-
 	ha->mbox_status_count = outCount;
 	for (i = 0; i < outCount; i++)
 		ha->mbox_status[i] = 0;
-- 
1.7.3.2

