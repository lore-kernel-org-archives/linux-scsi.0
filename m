From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/22] libata-sff: reorder SFF/BMDMA functions
Date: Tue, 21 Oct 2008 18:17:46 +0900
Message-ID: <1224580680-13698-9-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Reorder functions such that SFF and BMDMA functions are grouped.
While at it, s/BMDMA/SFF in a few comments where it actually meant
SFF.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-sff.c |  610 +++++++++++++++++++++++-----------------------
 include/linux/libata.h   |   24 +-
 2 files changed, 322 insertions(+), 312 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index dbb8695..2c5ebd1 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -67,17 +67,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.port_start		= ata_sff_port_start,
 };
 
-const struct ata_port_operations ata_bmdma_port_ops = {
-	.inherits		= &ata_sff_port_ops,
-
-	.mode_filter		= ata_bmdma_mode_filter,
-
-	.bmdma_setup		= ata_bmdma_setup,
-	.bmdma_start		= ata_bmdma_start,
-	.bmdma_stop		= ata_bmdma_stop,
-	.bmdma_status		= ata_bmdma_status,
-};
-
 /**
  *	ata_fill_sg - Fill PCI IDE PRD table
  *	@qc: Metadata associated with taskfile to be transferred
@@ -1590,7 +1579,7 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 	if (status & ATA_BUSY)
 		goto idle_irq;
 
-	/* ack bmdma irq events */
+	/* clear irq events */
 	ap->ops->sff_irq_clear(ap);
 
 	ata_sff_hsm_move(ap, qc, status, 0);
@@ -1657,7 +1646,7 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
  *	ata_sff_freeze - Freeze SFF controller port
  *	@ap: port to freeze
  *
- *	Freeze BMDMA controller port.
+ *	Freeze SFF controller port.
  *
  *	LOCKING:
  *	Inherited from caller.
@@ -2207,291 +2196,8 @@ void ata_sff_std_ports(struct ata_ioports *ioaddr)
 	ioaddr->command_addr = ioaddr->cmd_addr + ATA_REG_CMD;
 }
 
-unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
-				    unsigned long xfer_mask)
-{
-	/* Filter out DMA modes if the device has been configured by
-	   the BIOS as PIO only */
-
-	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
-		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-	return xfer_mask;
-}
-
-/**
- *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
- *	@qc: Info associated with this ATA transaction.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_setup(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
-	u8 dmactl;
-
-	/* load PRD table addr. */
-	mb();	/* make sure PRD table writes are visible to controller */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
-
-	/* specify data direction, triple-check start bit is clear */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
-	if (!rw)
-		dmactl |= ATA_DMA_WR;
-	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* issue r/w command */
-	ap->ops->sff_exec_command(ap, &qc->tf);
-}
-
-/**
- *	ata_bmdma_start - Start a PCI IDE BMDMA transaction
- *	@qc: Info associated with this ATA transaction.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	u8 dmactl;
-
-	/* start host DMA transaction */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* Strictly, one may wish to issue an ioread8() here, to
-	 * flush the mmio write.  However, control also passes
-	 * to the hardware at this point, and it will interrupt
-	 * us when we are to resume control.  So, in effect,
-	 * we don't care when the mmio write flushes.
-	 * Further, a read of the DMA status register _immediately_
-	 * following the write may not be what certain flaky hardware
-	 * is expected, so I think it is best to not add a readb()
-	 * without first all the MMIO ATA cards/mobos.
-	 * Or maybe I'm just being paranoid.
-	 *
-	 * FIXME: The posting of this write means I/O starts are
-	 * unneccessarily delayed for MMIO
-	 */
-}
-
-/**
- *	ata_bmdma_stop - Stop PCI IDE BMDMA transfer
- *	@qc: Command we are ending DMA for
- *
- *	Clears the ATA_DMA_START flag in the dma control register
- *
- *	May be used as the bmdma_stop() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	void __iomem *mmio = ap->ioaddr.bmdma_addr;
-
-	/* clear start/stop bit */
-	iowrite8(ioread8(mmio + ATA_DMA_CMD) & ~ATA_DMA_START,
-		 mmio + ATA_DMA_CMD);
-
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_dma_pause(ap);
-}
-
-/**
- *	ata_bmdma_status - Read PCI IDE BMDMA status
- *	@ap: Port associated with this ATA transaction.
- *
- *	Read and return BMDMA status register.
- *
- *	May be used as the bmdma_status() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-u8 ata_bmdma_status(struct ata_port *ap)
-{
-	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-}
-
-/**
- *	ata_bus_reset - reset host port and associated ATA channel
- *	@ap: port to reset
- *
- *	This is typically the first time we actually start issuing
- *	commands to the ATA channel.  We wait for BSY to clear, then
- *	issue EXECUTE DEVICE DIAGNOSTIC command, polling for its
- *	result.  Determine what devices, if any, are on the channel
- *	by looking at the device 0/1 error register.  Look at the signature
- *	stored in each device's taskfile registers, to determine if
- *	the device is ATA or ATAPI.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *	Obtains host lock.
- *
- *	DEPRECATED:
- *	This function is only for drivers which still use old EH and
- *	will be removed soon.
- */
-void ata_bus_reset(struct ata_port *ap)
-{
-	struct ata_device *device = ap->link.device;
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	u8 err;
-	unsigned int dev0, dev1 = 0, devmask = 0;
-	int rc;
-
-	DPRINTK("ENTER, host %u, port %u\n", ap->print_id, ap->port_no);
-
-	/* determine if device 0/1 are present */
-	if (ap->flags & ATA_FLAG_SATA_RESET)
-		dev0 = 1;
-	else {
-		dev0 = ata_devchk(ap, 0);
-		if (slave_possible)
-			dev1 = ata_devchk(ap, 1);
-	}
-
-	if (dev0)
-		devmask |= (1 << 0);
-	if (dev1)
-		devmask |= (1 << 1);
-
-	/* select device 0 again */
-	ap->ops->sff_dev_select(ap, 0);
-
-	/* issue bus reset */
-	if (ap->flags & ATA_FLAG_SRST) {
-		rc = ata_bus_softreset(ap, devmask,
-				       ata_deadline(jiffies, 40000));
-		if (rc && rc != -ENODEV)
-			goto err_out;
-	}
-
-	/*
-	 * determine by signature whether we have ATA or ATAPI devices
-	 */
-	device[0].class = ata_sff_dev_classify(&device[0], dev0, &err);
-	if ((slave_possible) && (err != 0x81))
-		device[1].class = ata_sff_dev_classify(&device[1], dev1, &err);
-
-	/* is double-select really necessary? */
-	if (device[1].class != ATA_DEV_NONE)
-		ap->ops->sff_dev_select(ap, 1);
-	if (device[0].class != ATA_DEV_NONE)
-		ap->ops->sff_dev_select(ap, 0);
-
-	/* if no devices were detected, disable this port */
-	if ((device[0].class == ATA_DEV_NONE) &&
-	    (device[1].class == ATA_DEV_NONE))
-		goto err_out;
-
-	if (ap->flags & (ATA_FLAG_SATA_RESET | ATA_FLAG_SRST)) {
-		/* set up device control for ATA_FLAG_SATA_RESET */
-		iowrite8(ap->ctl, ioaddr->ctl_addr);
-	}
-
-	DPRINTK("EXIT\n");
-	return;
-
-err_out:
-	device[0].class = ATA_DEV_NONE;
-	device[1].class = ATA_DEV_NONE;
-	ata_port_printk(ap, KERN_ERR, "giving up port\n");
-
-	DPRINTK("EXIT\n");
-}
-
 #ifdef CONFIG_PCI
 
-/**
- *	ata_pci_bmdma_clear_simplex -	attempt to kick device out of simplex
- *	@pdev: PCI device
- *
- *	Some PCI ATA devices report simplex mode but in fact can be told to
- *	enter non simplex mode. This implements the necessary logic to
- *	perform the task on such devices. Calling it on other devices will
- *	have -undefined- behaviour.
- */
-int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
-{
-	unsigned long bmdma = pci_resource_start(pdev, 4);
-	u8 simplex;
-
-	if (bmdma == 0)
-		return -ENOENT;
-
-	simplex = inb(bmdma + 0x02);
-	outb(simplex & 0x60, bmdma + 0x02);
-	simplex = inb(bmdma + 0x02);
-	if (simplex & 0x80)
-		return -EOPNOTSUPP;
-	return 0;
-}
-
-/**
- *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
- *	@host: target ATA host
- *
- *	Acquire PCI BMDMA resources and initialize @host accordingly.
- *
- *	LOCKING:
- *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-int ata_pci_bmdma_init(struct ata_host *host)
-{
-	struct device *gdev = host->dev;
-	struct pci_dev *pdev = to_pci_dev(gdev);
-	int i, rc;
-
-	/* No BAR4 allocation: No DMA */
-	if (pci_resource_start(pdev, 4) == 0)
-		return 0;
-
-	/* TODO: If we get no DMA mask we should fall back to PIO */
-	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
-	if (rc)
-		return rc;
-	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
-	if (rc)
-		return rc;
-
-	/* request and iomap DMA region */
-	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
-	if (rc) {
-		dev_printk(KERN_ERR, gdev, "failed to request/iomap BAR4\n");
-		return -ENOMEM;
-	}
-	host->iomap = pcim_iomap_table(pdev);
-
-	for (i = 0; i < 2; i++) {
-		struct ata_port *ap = host->ports[i];
-		void __iomem *bmdma = host->iomap[4] + 8 * i;
-
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		ap->ioaddr.bmdma_addr = bmdma;
-		if ((!(ap->flags & ATA_FLAG_IGN_SIMPLEX)) &&
-		    (ioread8(bmdma + 2) & 0x80))
-			host->flags |= ATA_HOST_SIMPLEX;
-
-		ata_port_desc(ap, "bmdma 0x%llx",
-			(unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
-	}
-
-	return 0;
-}
-
 static int ata_resources_present(struct pci_dev *pdev, int port)
 {
 	int i;
@@ -2811,8 +2517,305 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 #endif /* CONFIG_PCI */
 
+/**
+ *	ata_bus_reset - reset host port and associated ATA channel
+ *	@ap: port to reset
+ *
+ *	This is typically the first time we actually start issuing
+ *	commands to the ATA channel.  We wait for BSY to clear, then
+ *	issue EXECUTE DEVICE DIAGNOSTIC command, polling for its
+ *	result.  Determine what devices, if any, are on the channel
+ *	by looking at the device 0/1 error register.  Look at the signature
+ *	stored in each device's taskfile registers, to determine if
+ *	the device is ATA or ATAPI.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *	Obtains host lock.
+ *
+ *	DEPRECATED:
+ *	This function is only for drivers which still use old EH and
+ *	will be removed soon.
+ */
+void ata_bus_reset(struct ata_port *ap)
+{
+	struct ata_device *device = ap->link.device;
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
+	u8 err;
+	unsigned int dev0, dev1 = 0, devmask = 0;
+	int rc;
+
+	DPRINTK("ENTER, host %u, port %u\n", ap->print_id, ap->port_no);
+
+	/* determine if device 0/1 are present */
+	if (ap->flags & ATA_FLAG_SATA_RESET)
+		dev0 = 1;
+	else {
+		dev0 = ata_devchk(ap, 0);
+		if (slave_possible)
+			dev1 = ata_devchk(ap, 1);
+	}
+
+	if (dev0)
+		devmask |= (1 << 0);
+	if (dev1)
+		devmask |= (1 << 1);
+
+	/* select device 0 again */
+	ap->ops->sff_dev_select(ap, 0);
+
+	/* issue bus reset */
+	if (ap->flags & ATA_FLAG_SRST) {
+		rc = ata_bus_softreset(ap, devmask,
+				       ata_deadline(jiffies, 40000));
+		if (rc && rc != -ENODEV)
+			goto err_out;
+	}
+
+	/*
+	 * determine by signature whether we have ATA or ATAPI devices
+	 */
+	device[0].class = ata_sff_dev_classify(&device[0], dev0, &err);
+	if ((slave_possible) && (err != 0x81))
+		device[1].class = ata_sff_dev_classify(&device[1], dev1, &err);
+
+	/* is double-select really necessary? */
+	if (device[1].class != ATA_DEV_NONE)
+		ap->ops->sff_dev_select(ap, 1);
+	if (device[0].class != ATA_DEV_NONE)
+		ap->ops->sff_dev_select(ap, 0);
+
+	/* if no devices were detected, disable this port */
+	if ((device[0].class == ATA_DEV_NONE) &&
+	    (device[1].class == ATA_DEV_NONE))
+		goto err_out;
+
+	if (ap->flags & (ATA_FLAG_SATA_RESET | ATA_FLAG_SRST)) {
+		/* set up device control for ATA_FLAG_SATA_RESET */
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
+	}
+
+	DPRINTK("EXIT\n");
+	return;
+
+err_out:
+	device[0].class = ATA_DEV_NONE;
+	device[1].class = ATA_DEV_NONE;
+	ata_port_printk(ap, KERN_ERR, "giving up port\n");
+
+	DPRINTK("EXIT\n");
+}
+
+const struct ata_port_operations ata_bmdma_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+
+	.mode_filter		= ata_bmdma_mode_filter,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+};
+
+unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
+				    unsigned long xfer_mask)
+{
+	/* Filter out DMA modes if the device has been configured by
+	   the BIOS as PIO only */
+
+	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
+		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
+	return xfer_mask;
+}
+
+/**
+ *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
+ *	@qc: Info associated with this ATA transaction.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	u8 dmactl;
+
+	/* load PRD table addr. */
+	mb();	/* make sure PRD table writes are visible to controller */
+	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+
+/**
+ *	ata_bmdma_start - Start a PCI IDE BMDMA transaction
+ *	@qc: Info associated with this ATA transaction.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	u8 dmactl;
+
+	/* start host DMA transaction */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	/* Strictly, one may wish to issue an ioread8() here, to
+	 * flush the mmio write.  However, control also passes
+	 * to the hardware at this point, and it will interrupt
+	 * us when we are to resume control.  So, in effect,
+	 * we don't care when the mmio write flushes.
+	 * Further, a read of the DMA status register _immediately_
+	 * following the write may not be what certain flaky hardware
+	 * is expected, so I think it is best to not add a readb()
+	 * without first all the MMIO ATA cards/mobos.
+	 * Or maybe I'm just being paranoid.
+	 *
+	 * FIXME: The posting of this write means I/O starts are
+	 * unneccessarily delayed for MMIO
+	 */
+}
+
+/**
+ *	ata_bmdma_stop - Stop PCI IDE BMDMA transfer
+ *	@qc: Command we are ending DMA for
+ *
+ *	Clears the ATA_DMA_START flag in the dma control register
+ *
+ *	May be used as the bmdma_stop() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+	/* clear start/stop bit */
+	iowrite8(ioread8(mmio + ATA_DMA_CMD) & ~ATA_DMA_START,
+		 mmio + ATA_DMA_CMD);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+
+/**
+ *	ata_bmdma_status - Read PCI IDE BMDMA status
+ *	@ap: Port associated with this ATA transaction.
+ *
+ *	Read and return BMDMA status register.
+ *
+ *	May be used as the bmdma_status() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+u8 ata_bmdma_status(struct ata_port *ap)
+{
+	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+}
+
+#ifdef CONFIG_PCI
+
+/**
+ *	ata_pci_bmdma_clear_simplex -	attempt to kick device out of simplex
+ *	@pdev: PCI device
+ *
+ *	Some PCI ATA devices report simplex mode but in fact can be told to
+ *	enter non simplex mode. This implements the necessary logic to
+ *	perform the task on such devices. Calling it on other devices will
+ *	have -undefined- behaviour.
+ */
+int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
+{
+	unsigned long bmdma = pci_resource_start(pdev, 4);
+	u8 simplex;
+
+	if (bmdma == 0)
+		return -ENOENT;
+
+	simplex = inb(bmdma + 0x02);
+	outb(simplex & 0x60, bmdma + 0x02);
+	simplex = inb(bmdma + 0x02);
+	if (simplex & 0x80)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+/**
+ *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
+ *	@host: target ATA host
+ *
+ *	Acquire PCI BMDMA resources and initialize @host accordingly.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_pci_bmdma_init(struct ata_host *host)
+{
+	struct device *gdev = host->dev;
+	struct pci_dev *pdev = to_pci_dev(gdev);
+	int i, rc;
+
+	/* No BAR4 allocation: No DMA */
+	if (pci_resource_start(pdev, 4) == 0)
+		return 0;
+
+	/* TODO: If we get no DMA mask we should fall back to PIO */
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+
+	/* request and iomap DMA region */
+	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
+	if (rc) {
+		dev_printk(KERN_ERR, gdev, "failed to request/iomap BAR4\n");
+		return -ENOMEM;
+	}
+	host->iomap = pcim_iomap_table(pdev);
+
+	for (i = 0; i < 2; i++) {
+		struct ata_port *ap = host->ports[i];
+		void __iomem *bmdma = host->iomap[4] + 8 * i;
+
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ap->ioaddr.bmdma_addr = bmdma;
+		if ((!(ap->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+		    (ioread8(bmdma + 2) & 0x80))
+			host->flags |= ATA_HOST_SIMPLEX;
+
+		ata_port_desc(ap, "bmdma 0x%llx",
+			(unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
+	}
+
+	return 0;
+}
+
+#endif /* CONFIG_PCI */
+
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
-EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
 EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
@@ -2845,17 +2848,20 @@ EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_sff_port_start);
 EXPORT_SYMBOL_GPL(ata_sff_std_ports);
+#ifdef CONFIG_PCI
+EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
+EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
+EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
+EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
+#endif /* CONFIG_PCI */
+EXPORT_SYMBOL_GPL(ata_bus_reset);
+EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
 EXPORT_SYMBOL_GPL(ata_bmdma_mode_filter);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
 EXPORT_SYMBOL_GPL(ata_bmdma_stop);
 EXPORT_SYMBOL_GPL(ata_bmdma_status);
-EXPORT_SYMBOL_GPL(ata_bus_reset);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
-EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 #endif /* CONFIG_PCI */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e0b8c24..c7fb1a2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1523,17 +1523,7 @@ extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_sff_port_start(struct ata_port *ap);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
-extern unsigned long ata_bmdma_mode_filter(struct ata_device *dev,
-					   unsigned long xfer_mask);
-extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
-extern void ata_bmdma_start(struct ata_queued_cmd *qc);
-extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
-extern u8 ata_bmdma_status(struct ata_port *ap);
-extern void ata_bus_reset(struct ata_port *ap);
-
 #ifdef CONFIG_PCI
-extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
-extern int ata_pci_bmdma_init(struct ata_host *host);
 extern int ata_pci_sff_init_host(struct ata_host *host);
 extern int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 				    const struct ata_port_info * const * ppi,
@@ -1546,6 +1536,20 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 				struct scsi_host_template *sht, void *host_priv);
 #endif /* CONFIG_PCI */
 
+extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
+
+extern unsigned long ata_bmdma_mode_filter(struct ata_device *dev,
+					   unsigned long xfer_mask);
+extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
+extern void ata_bmdma_start(struct ata_queued_cmd *qc);
+extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
+extern u8 ata_bmdma_status(struct ata_port *ap);
+
+#ifdef CONFIG_PCI
+extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
+extern int ata_pci_bmdma_init(struct ata_host *host);
+#endif /* CONFIG_PCI */
+
 /**
  *	ata_sff_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
-- 
1.5.4.5

