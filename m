From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Resolved a performance issue in interrupt handler
Date: Tue, 9 Jun 2009 11:42:48 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39419 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZFIS6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 14:58:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: douglas.w.styner@intel.com, James.Bottomley@HansenPartnership.com

Reverted back a change from spin_lock to spin_lock_irq* that was causing
the cycle times to go up.
The patch is based on scsi-misc-2.6.

Reported-and-checked-by: Douglas W. Styner <douglas.w.styner@intel.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c8d0a17..bc92feb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -37,6 +37,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	uint16_t	hccr;
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -49,7 +50,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
@@ -101,7 +102,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			RD_REG_WORD(&reg->hccr);
 		}
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -133,6 +134,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
 	struct qla_hw_data *ha;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -145,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
@@ -216,7 +218,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 		RD_REG_WORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1626,6 +1628,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	uint32_t	hccr;
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1638,7 +1641,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
@@ -1688,7 +1691,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1706,6 +1709,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
 	struct scsi_qla_host *vha;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1716,13 +1720,13 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1757,6 +1761,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1768,7 +1773,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
@@ -1817,7 +1822,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1940,6 +1945,7 @@ int
 qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 	int ret;
+	unsigned long	flags;
 	device_reg_t __iomem *reg = ha->iobase;
 
 	/* If possible, enable MSI-X. */
@@ -2007,7 +2013,7 @@ clear_risc_ints:
 	 */
 	if (IS_QLA81XX(ha))
 		goto fail;
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
@@ -2016,7 +2022,7 @@ clear_risc_ints:
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 fail:
 	return ret;
-- 
1.5.5

