From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/19] qla2xxx: Add PCI error recovery support.
Date: Thu, 20 Sep 2007 14:07:36 -0700
Message-ID: <1190322470-15543-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXITVHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:48 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |   28 +++++++++-
 drivers/scsi/qla2xxx/qla_os.c  |  114 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1e3428..75ab898 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
+#include <linux/aer.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eecae99..dcfb24b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -34,6 +34,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
+	uint16_t	hccr;
 	uint16_t	mb[4];
 
 	ha = (scsi_qla_host_t *) dev_id;
@@ -48,7 +49,23 @@ qla2100_intr_handler(int irq, void *dev_id)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (iter = 50; iter--; ) {
-		if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
+		hccr = RD_REG_WORD(&reg->hccr);
+		if (hccr & HCCR_RISC_PAUSE) {
+			if (pci_channel_offline(ha->pdev))
+				break;
+
+			/*
+			 * Issue a "HARD" reset in order for the RISC interrupt
+			 * bit to be cleared.  Schedule a big hammmer to get
+			 * out of the RISC PAUSED state.
+			 */
+			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+			RD_REG_WORD(&reg->hccr);
+
+			ha->isp_ops->fw_dump(ha, 1);
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			break;
+		} else if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
 			break;
 
 		if (RD_REG_WORD(&reg->semaphore) & BIT_0) {
@@ -127,6 +144,9 @@ qla2300_intr_handler(int irq, void *dev_id)
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
+			if (pci_channel_offline(ha->pdev))
+				break;
+
 			hccr = RD_REG_WORD(&reg->hccr);
 			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
 				qla_printk(KERN_INFO, ha, "Parity error -- "
@@ -1499,6 +1519,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
+			if (pci_channel_offline(ha->pdev))
+				break;
+
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
@@ -1633,6 +1656,9 @@ qla24xx_msix_default(int irq, void *dev_id)
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
+			if (pci_channel_offline(ha->pdev))
+				break;
+
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2a03400..a8ab2d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -385,6 +385,11 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	srb_t *sp;
 	int rval;
 
+	if (unlikely(pci_channel_offline(ha->pdev))) {
+		cmd->result = DID_REQUEUE << 16;
+		goto qc_fail_command;
+	}
+
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		cmd->result = rval;
@@ -447,6 +452,11 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	int rval;
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
+	if (unlikely(pci_channel_offline(ha->pdev))) {
+		cmd->result = DID_REQUEUE << 16;
+		goto qc24_fail_command;
+	}
+
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		cmd->result = rval;
@@ -1571,6 +1581,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
+	if (pci_find_aer_capability(pdev))
+		if (pci_enable_pcie_error_reporting(pdev))
+			goto probe_out;
+
 	sht = &qla2x00_driver_template;
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432 ||
@@ -2814,6 +2828,105 @@ qla2x00_release_firmware(void)
 	up(&qla_fw_lock);
 }
 
+static pci_ers_result_t
+qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		pci_disable_device(pdev);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		qla2x00_remove_one(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t
+qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
+{
+	int risc_paused = 0;
+	uint32_t stat;
+	unsigned long flags;
+	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
+		stat = RD_REG_DWORD(&reg->hccr);
+		if (stat & HCCR_RISC_PAUSE)
+			risc_paused = 1;
+	} else if (IS_QLA23XX(ha)) {
+		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+		if (stat & HSR_RISC_PAUSED)
+			risc_paused = 1;
+	} else if (IS_FWI2_CAPABLE(ha)) {
+		stat = RD_REG_DWORD(&reg24->host_status);
+		if (stat & HSRX_RISC_PAUSED)
+			risc_paused = 1;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (risc_paused) {
+		qla_printk(KERN_INFO, ha, "RISC paused -- mmio_enabled, "
+		    "Dumping firmware!\n");
+		ha->isp_ops->fw_dump(ha, 0);
+
+		return PCI_ERS_RESULT_NEED_RESET;
+	} else
+		return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t
+qla2xxx_pci_slot_reset(struct pci_dev *pdev)
+{
+	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
+	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+
+	if (pci_enable_device(pdev)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Can't re-enable PCI device after reset.\n");
+
+		return ret;
+	}
+	pci_set_master(pdev);
+
+	if (ha->isp_ops->pci_config(ha))
+		return ret;
+
+	set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	if (qla2x00_abort_isp(ha)== QLA_SUCCESS)
+		ret =  PCI_ERS_RESULT_RECOVERED;
+	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+
+	return ret;
+}
+
+static void
+qla2xxx_pci_resume(struct pci_dev *pdev)
+{
+	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = qla2x00_wait_for_hba_online(ha);
+	if (ret != QLA_SUCCESS) {
+		qla_printk(KERN_ERR, ha,
+		    "the device failed to resume I/O "
+		    "from slot/link_reset");
+	}
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+}
+
+static struct pci_error_handlers qla2xxx_err_handler = {
+	.error_detected = qla2xxx_pci_error_detected,
+	.mmio_enabled = qla2xxx_pci_mmio_enabled,
+	.slot_reset = qla2xxx_pci_slot_reset,
+	.resume = qla2xxx_pci_resume,
+};
+
 static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200) },
@@ -2839,6 +2952,7 @@ static struct pci_driver qla2xxx_pci_driver = {
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
 	.remove		= __devexit_p(qla2x00_remove_one),
+	.err_handler	= &qla2xxx_err_handler,
 };
 
 /**
-- 
1.5.3.2.80.g077d6f

