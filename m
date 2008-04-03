From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/21] qla2xxx: Simplify interrupt handler locking.
Date: Thu,  3 Apr 2008 13:13:17 -0700
Message-ID: <1207253612-15538-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761668AbYDCUNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:36 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's no need to use the heavier (albiet safer)
*_irq[save|restore]() locking primitives within the driver's
interrupt handlers, interrupts are guaranteed to be
non-reentrant.  Use lightweight spin_lock() and spin_unlock()
primitives while acquiring the hardware_lock.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 370fba5..4e9f410 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -33,7 +33,6 @@ qla2100_intr_handler(int irq, void *dev_id)
 	scsi_qla_host_t	*ha;
 	struct device_reg_2xxx __iomem *reg;
 	int		status;
-	unsigned long	flags;
 	unsigned long	iter;
 	uint16_t	hccr;
 	uint16_t	mb[4];
@@ -48,7 +47,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -99,7 +98,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			RD_REG_WORD(&reg->hccr);
 		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -125,7 +124,6 @@ qla2300_intr_handler(int irq, void *dev_id)
 	scsi_qla_host_t	*ha;
 	struct device_reg_2xxx __iomem *reg;
 	int		status;
-	unsigned long	flags;
 	unsigned long	iter;
 	uint32_t	stat;
 	uint16_t	hccr;
@@ -141,7 +139,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
@@ -211,7 +209,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 		RD_REG_WORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1533,7 +1531,6 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	scsi_qla_host_t	*ha;
 	struct device_reg_24xx __iomem *reg;
 	int		status;
-	unsigned long	flags;
 	unsigned long	iter;
 	uint32_t	stat;
 	uint32_t	hccr;
@@ -1549,7 +1546,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1597,7 +1594,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1656,18 +1653,16 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 {
 	scsi_qla_host_t	*ha;
 	struct device_reg_24xx __iomem *reg;
-	unsigned long flags;
 
 	ha = dev_id;
 	reg = &ha->iobase->isp24;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 
 	qla24xx_process_response_queue(ha);
-
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
 }
@@ -1678,7 +1673,6 @@ qla24xx_msix_default(int irq, void *dev_id)
 	scsi_qla_host_t	*ha;
 	struct device_reg_24xx __iomem *reg;
 	int		status;
-	unsigned long	flags;
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
@@ -1687,7 +1681,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1734,7 +1728,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1821,7 +1815,6 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 {
 	int ret;
 	device_reg_t __iomem *reg = ha->iobase;
-	unsigned long flags;
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha))
@@ -1882,7 +1875,7 @@ skip_msi:
 clear_risc_ints:
 
 	ha->isp_ops->disable_intrs(ha);
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irq(&ha->hardware_lock);
 	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
@@ -1891,7 +1884,7 @@ clear_risc_ints:
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irq(&ha->hardware_lock);
 	ha->isp_ops->enable_intrs(ha);
 
 fail:
-- 
1.5.5.rc2

