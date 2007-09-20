From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 18/19] qla2xxx: Rework MSI-X handlers.
Date: Thu, 20 Sep 2007 14:07:49 -0700
Message-ID: <1190322470-15543-18-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXITVHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:42 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Since MSI-X vectors do not require a clearing "handshake" from
the system perspective, and the registered handler will not be
called more than once for one occurrence of receipt of a vector,
there is no requirement to flush the risc register write clearing
the interrupt condition in the risc. Also, since the msi-x
registered handlers are optimised for a particular vector, it is
preferable to handle the one vector received per invocation of
the handler.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f61c2fe..c4768c4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1679,7 +1679,6 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	qla24xx_process_response_queue(ha);
 
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-	RD_REG_DWORD_RELAXED(&reg->hccr);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1693,7 +1692,6 @@ qla24xx_msix_default(int irq, void *dev_id)
 	struct device_reg_24xx __iomem *reg;
 	int		status;
 	unsigned long	flags;
-	unsigned long	iter;
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
@@ -1703,7 +1701,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (iter = 50; iter--; ) {
+	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
 			if (pci_channel_offline(ha->pdev))
@@ -1748,8 +1746,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		RD_REG_DWORD_RELAXED(&reg->hccr);
-	}
+	} while (0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
-- 
1.5.3.2.80.g077d6f

