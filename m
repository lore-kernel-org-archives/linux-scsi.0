From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/11] qla2xxx: Move RISC-interrupt-register modifications to qla2x00_request_irqs().
Date: Thu, 31 Jan 2008 12:33:50 -0800
Message-ID: <1201811634-19865-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461AbYAaUeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:10 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's no functional change involved with this update, instead
it simply migrates the "set cleared interrupt state" codes to a
more approprate method, qla2x00_request_irqs(), and cleans-up the
driver's probe() logic.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   27 ++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c  |   18 ------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 642a0c3..14e6f22 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1815,6 +1815,8 @@ int
 qla2x00_request_irqs(scsi_qla_host_t *ha)
 {
 	int ret;
+	device_reg_t __iomem *reg = ha->iobase;
+	unsigned long flags;
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha))
@@ -1846,7 +1848,7 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "MSI-X: Enabled (0x%X, 0x%X).\n", ha->chip_revision,
 		    ha->fw_attributes));
-		return ret;
+		goto clear_risc_ints;
 	}
 	qla_printk(KERN_WARNING, ha,
 	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
@@ -1864,15 +1866,30 @@ skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
-	if (!ret) {
-		ha->flags.inta_enabled = 1;
-		ha->host->irq = ha->pdev->irq;
-	} else {
+	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
+		goto fail;
+	}
+	ha->flags.inta_enabled = 1;
+	ha->host->irq = ha->pdev->irq;
+clear_risc_ints:
+
+	ha->isp_ops->disable_intrs(ha);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (IS_FWI2_CAPABLE(ha)) {
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
+	} else {
+		WRT_REG_WORD(&reg->isp.semaphore, 0);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	ha->isp_ops->enable_intrs(ha);
 
+fail:
 	return ret;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f129c69..4b4c32f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1576,10 +1576,8 @@ static int __devinit
 qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
-	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
-	unsigned long	flags = 0;
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
@@ -1762,22 +1760,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    ha->host_no, ha));
 
-	ha->isp_ops->disable_intrs(ha);
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	reg = ha->iobase;
-	if (IS_FWI2_CAPABLE(ha)) {
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
-	} else {
-		WRT_REG_WORD(&reg->isp.semaphore, 0);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	ha->isp_ops->enable_intrs(ha);
-
 	pci_set_drvdata(pdev, ha);
 
 	ha->flags.init_done = 1;
-- 
1.5.4.rc5.5.gab98

