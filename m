From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/14] qla2xxx: Add MSI-X support.
Date: Mon, 29 Jan 2007 10:22:19 -0800
Message-ID: <11700949511578-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXA2SWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:40 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   24 +++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 +
 drivers/scsi/qla2xxx/qla_init.c |    2 +
 drivers/scsi/qla2xxx/qla_isr.c  |  215 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   14 +--
 5 files changed, 247 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2c10130..9b7bcc0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2047,6 +2047,27 @@ struct isp_operations {
 		uint32_t);
 };
 
+/* MSI-X Support *************************************************************/
+
+#define QLA_MSIX_CHIP_REV_24XX	3
+#define QLA_MSIX_FW_MODE(m)	(((m) & (BIT_7|BIT_8|BIT_9)) >> 7)
+#define QLA_MSIX_FW_MODE_1(m)	(QLA_MSIX_FW_MODE(m) == 1)
+
+#define QLA_MSIX_DEFAULT	0x00
+#define QLA_MSIX_RSP_Q		0x01
+
+#define QLA_MSIX_ENTRIES	2
+#define QLA_MIDX_DEFAULT	0
+#define QLA_MIDX_RSP_Q		1
+
+struct scsi_qla_host;
+
+struct qla_msix_entry {
+	int have_irq;
+	uint16_t msix_vector;
+	uint16_t msix_entry;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -2358,6 +2379,7 @@ typedef struct scsi_qla_host {
 
 	uint8_t		host_str[16];
 	uint32_t	pci_attr;
+	uint16_t	chip_revision;
 
 	uint16_t	product_id[4];
 
@@ -2391,6 +2413,8 @@ typedef struct scsi_qla_host {
 	uint16_t	zio_mode;
 	uint16_t	zio_timer;
 	struct fc_host_statistics fc_host_stat;
+
+	struct qla_msix_entry msix_entries[QLA_MSIX_ENTRIES];
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e4dd12f..7a7b7e9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -224,6 +224,9 @@ extern irqreturn_t qla24xx_intr_handler(int, void *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
 extern void qla24xx_process_response_queue(struct scsi_qla_host *);
 
+extern int qla2x00_request_irqs(scsi_qla_host_t *);
+extern void qla2x00_free_irqs(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b3dac26..e594915 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -293,6 +293,8 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	d &= ~PCI_ROM_ADDRESS_ENABLE;
 	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
 
+	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->chip_revision);
+
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->pci_attr = RD_REG_DWORD(&reg->ctrl_status);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ba67077..d6f396d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1532,3 +1532,218 @@ qla24xx_ms_entry(scsi_qla_host_t *ha, struct ct_entry_24xx *pkt)
 	qla2x00_sp_compl(ha, sp);
 }
 
+static irqreturn_t
+qla24xx_msix_rsp_q(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*ha;
+	struct device_reg_24xx __iomem *reg;
+	unsigned long flags;
+
+	ha = dev_id;
+	reg = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	qla24xx_process_response_queue(ha);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+	RD_REG_DWORD_RELAXED(&reg->hccr);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
+qla24xx_msix_default(int irq, void *dev_id)
+{
+	scsi_qla_host_t	*ha;
+	struct device_reg_24xx __iomem *reg;
+	int		status;
+	unsigned long	flags;
+	unsigned long	iter;
+	uint32_t	stat;
+	uint32_t	hccr;
+	uint16_t	mb[4];
+
+	ha = dev_id;
+	reg = &ha->iobase->isp24;
+	status = 0;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (iter = 50; iter--; ) {
+		stat = RD_REG_DWORD(&reg->host_status);
+		if (stat & HSRX_RISC_PAUSED) {
+			hccr = RD_REG_DWORD(&reg->hccr);
+
+			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
+			    "Dumping firmware!\n", hccr);
+			ha->isp_ops.fw_dump(ha, 1);
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			break;
+		} else if ((stat & HSRX_RISC_INT) == 0)
+			break;
+
+		switch (stat & 0xff) {
+		case 0x1:
+		case 0x2:
+		case 0x10:
+		case 0x11:
+			qla24xx_mbx_completion(ha, MSW(stat));
+			status |= MBX_INTERRUPT;
+
+			break;
+		case 0x12:
+			mb[0] = MSW(stat);
+			mb[1] = RD_REG_WORD(&reg->mailbox1);
+			mb[2] = RD_REG_WORD(&reg->mailbox2);
+			mb[3] = RD_REG_WORD(&reg->mailbox3);
+			qla2x00_async_event(ha, mb);
+			break;
+		case 0x13:
+			qla24xx_process_response_queue(ha);
+			break;
+		default:
+			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
+			    "(%d).\n",
+			    ha->host_no, stat & 0xff));
+			break;
+		}
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		RD_REG_DWORD_RELAXED(&reg->hccr);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
+
+		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		up(&ha->mbx_intr_sem);
+
+		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* Interrupt handling helpers. */
+
+struct qla_init_msix_entry {
+	uint16_t entry;
+	uint16_t index;
+	const char *name;
+	irqreturn_t (*handler)(int, void *);
+};
+
+static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
+	{ QLA_MSIX_DEFAULT, QLA_MIDX_DEFAULT,
+		"qla2xxx (default)", qla24xx_msix_default },
+
+	{ QLA_MSIX_RSP_Q, QLA_MIDX_RSP_Q,
+		"qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
+};
+
+static void
+qla24xx_disable_msix(scsi_qla_host_t *ha)
+{
+	int i;
+	struct qla_msix_entry *qentry;
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
+		qentry = &ha->msix_entries[imsix_entries[i].index];
+		if (qentry->have_irq)
+			free_irq(qentry->msix_vector, ha);
+	}
+	pci_disable_msix(ha->pdev);
+}
+
+static int
+qla24xx_enable_msix(scsi_qla_host_t *ha)
+{
+	int i, ret;
+	struct msix_entry entries[QLA_MSIX_ENTRIES];
+	struct qla_msix_entry *qentry;
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
+		entries[i].entry = imsix_entries[i].entry;
+
+	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Failed to enable support -- %d/%d\n",
+		    QLA_MSIX_ENTRIES, ret);
+		goto msix_out;
+	}
+	ha->flags.msix_enabled = 1;
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
+		qentry = &ha->msix_entries[imsix_entries[i].index];
+		qentry->msix_vector = entries[i].vector;
+		qentry->msix_entry = entries[i].entry;
+		qentry->have_irq = 0;
+		ret = request_irq(qentry->msix_vector,
+		    imsix_entries[i].handler, 0, imsix_entries[i].name, ha);
+		if (ret) {
+			qla_printk(KERN_WARNING, ha,
+			    "MSI-X: Unable to register handler -- %x/%d.\n",
+			    imsix_entries[i].index, ret);
+			qla24xx_disable_msix(ha);
+			goto msix_out;
+		}
+		qentry->have_irq = 1;
+	}
+
+msix_out:
+	return ret;
+}
+
+int
+qla2x00_request_irqs(scsi_qla_host_t *ha)
+{
+	int ret;
+
+	/* If possible, enable MSI-X. */
+	if (!IS_QLA2432(ha))
+		goto skip_msix;
+
+        if (ha->chip_revision < QLA_MSIX_CHIP_REV_24XX ||
+	    !QLA_MSIX_FW_MODE_1(ha->fw_attributes)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
+		    ha->chip_revision, ha->fw_attributes));
+
+		goto skip_msix;
+	}
+
+	ret = qla24xx_enable_msix(ha);
+	if (!ret) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "MSI-X: Enabled (0x%X, 0x%X).\n", ha->chip_revision,
+		    ha->fw_attributes));
+		return ret;
+	}
+	qla_printk(KERN_WARNING, ha,
+	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
+skip_msix:
+	ret = request_irq(ha->pdev->irq, ha->isp_ops.intr_handler,
+	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
+	if (ret) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to reserve interrupt %d already in use.\n",
+		    ha->pdev->irq);
+	}
+	ha->host->irq = ha->pdev->irq;
+
+	return ret;
+}
+
+void
+qla2x00_free_irqs(scsi_qla_host_t *ha)
+{
+
+	if (ha->flags.msix_enabled)
+		qla24xx_disable_msix(ha);
+	else if (ha->host->irq)
+		free_irq(ha->host->irq, ha);
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d6445ae..1f8d04c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1615,15 +1615,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
-	ret = request_irq(pdev->irq, ha->isp_ops.intr_handler,
-	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
-	if (ret) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to reserve interrupt %d already in use.\n",
-		    pdev->irq);
+	ret = qla2x00_request_irqs(ha);
+	if (ret)
 		goto probe_failed;
-	}
-	host->irq = pdev->irq;
 
 	/* Initialized the timer */
 	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
@@ -1753,9 +1747,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 
 	qla2x00_mem_free(ha);
 
-	/* Detach interrupts */
-	if (ha->host->irq)
-		free_irq(ha->host->irq, ha);
+	qla2x00_free_irqs(ha);
 
 	/* release io space registers  */
 	if (ha->iobase)
-- 
1.5.0.rc2.gdbaa0

