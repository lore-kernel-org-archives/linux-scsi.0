From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] ipr iomem annotations
Date: Thu, 21 Oct 2004 00:52:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235200.GW23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18089 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270532AbUJTXwE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:52:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	Annotated.  Original reused the structure that contained pointers into
remapped iomem for storing offsets in such area, so we need to split that
beast.
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-isurf/drivers/scsi/ipr.c RC9-bk4-ipr/drivers/scsi/ipr.c
--- RC9-bk4-isurf/drivers/scsi/ipr.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-ipr/drivers/scsi/ipr.c	Wed Oct 20 19:24:35 2004
@@ -5433,7 +5433,7 @@
 
 	ENTER;
 	free_irq(pdev->irq, ioa_cfg);
-	iounmap((void *) ioa_cfg->hdw_dma_regs);
+	iounmap(ioa_cfg->hdw_dma_regs);
 	pci_release_regions(pdev);
 	ipr_free_mem(ioa_cfg);
 	scsi_host_put(ioa_cfg->host);
@@ -5624,6 +5624,10 @@
 static void __devinit ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 				       struct Scsi_Host *host, struct pci_dev *pdev)
 {
+	const struct ipr_interrupt_offsets *p;
+	struct ipr_interrupts *t;
+	void __iomem *base;
+
 	ioa_cfg->host = host;
 	ioa_cfg->pdev = pdev;
 	ioa_cfg->log_level = ipr_log_level;
@@ -5655,17 +5659,19 @@
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	pci_set_drvdata(pdev, ioa_cfg);
 
-	memcpy(&ioa_cfg->regs, &ioa_cfg->chip_cfg->regs, sizeof(ioa_cfg->regs));
-
-	ioa_cfg->regs.set_interrupt_mask_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.clr_interrupt_mask_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.sense_interrupt_mask_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.clr_interrupt_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.sense_interrupt_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.ioarrin_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.sense_uproc_interrupt_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.set_uproc_interrupt_reg += ioa_cfg->hdw_dma_regs;
-	ioa_cfg->regs.clr_uproc_interrupt_reg += ioa_cfg->hdw_dma_regs;
+	p = &ioa_cfg->chip_cfg->regs;
+	t = &ioa_cfg->regs;
+	base = ioa_cfg->hdw_dma_regs;
+
+	t->set_interrupt_mask_reg = base + p->set_interrupt_mask_reg;
+	t->clr_interrupt_mask_reg = base + p->clr_interrupt_mask_reg;
+	t->sense_interrupt_mask_reg = base + p->sense_interrupt_mask_reg;
+	t->clr_interrupt_reg = base + p->clr_interrupt_reg;
+	t->sense_interrupt_reg = base + p->sense_interrupt_reg;
+	t->ioarrin_reg = base + p->ioarrin_reg;
+	t->sense_uproc_interrupt_reg = base + p->sense_uproc_interrupt_reg;
+	t->set_uproc_interrupt_reg = base + p->set_uproc_interrupt_reg;
+	t->clr_uproc_interrupt_reg = base + p->clr_uproc_interrupt_reg;
 }
 
 /**
@@ -5681,7 +5687,8 @@
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct Scsi_Host *host;
-	unsigned long ipr_regs, ipr_regs_pci;
+	unsigned long ipr_regs_pci;
+	void __iomem *ipr_regs;
 	u32 rc = PCIBIOS_SUCCESSFUL;
 
 	ENTER;
@@ -5715,8 +5722,7 @@
 		goto out_scsi_host_put;
 	}
 
-	ipr_regs = (unsigned long)ioremap(ipr_regs_pci,
-					  pci_resource_len(pdev, 0));
+	ipr_regs = ioremap(ipr_regs_pci, pci_resource_len(pdev, 0));
 
 	if (!ipr_regs) {
 		dev_err(&pdev->dev,
@@ -5790,7 +5796,7 @@
 cleanup_nolog:
 	ipr_free_mem(ioa_cfg);
 cleanup_nomem:
-	iounmap((void *) ipr_regs);
+	iounmap(ipr_regs);
 out_release_regions:
 	pci_release_regions(pdev);
 out_scsi_host_put:
diff -urN RC9-bk4-isurf/drivers/scsi/ipr.h RC9-bk4-ipr/drivers/scsi/ipr.h
--- RC9-bk4-isurf/drivers/scsi/ipr.h	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-ipr/drivers/scsi/ipr.h	Wed Oct 20 19:24:35 2004
@@ -749,7 +749,7 @@
 	struct ipr_supported_device supp_dev;
 };
 
-struct ipr_interrupts {
+struct ipr_interrupt_offsets {
 	unsigned long set_interrupt_mask_reg;
 	unsigned long clr_interrupt_mask_reg;
 	unsigned long sense_interrupt_mask_reg;
@@ -762,10 +762,23 @@
 	unsigned long clr_uproc_interrupt_reg;
 };
 
+struct ipr_interrupts {
+	void __iomem *set_interrupt_mask_reg;
+	void __iomem *clr_interrupt_mask_reg;
+	void __iomem *sense_interrupt_mask_reg;
+	void __iomem *clr_interrupt_reg;
+
+	void __iomem *sense_interrupt_reg;
+	void __iomem *ioarrin_reg;
+	void __iomem *sense_uproc_interrupt_reg;
+	void __iomem *set_uproc_interrupt_reg;
+	void __iomem *clr_uproc_interrupt_reg;
+};
+
 struct ipr_chip_cfg_t {
 	u32 mailbox;
 	u8 cache_line_size;
-	struct ipr_interrupts regs;
+	struct ipr_interrupt_offsets regs;
 };
 
 enum ipr_shutdown_type {
@@ -884,9 +897,9 @@
 
 	const struct ipr_chip_cfg_t *chip_cfg;
 
-	unsigned long hdw_dma_regs;	/* iomapped PCI memory space */
+	void __iomem *hdw_dma_regs;	/* iomapped PCI memory space */
 	unsigned long hdw_dma_regs_pci;	/* raw PCI memory space */
-	unsigned long ioa_mailbox;
+	void __iomem *ioa_mailbox;
 	struct ipr_interrupts regs;
 
 	u16 saved_pcix_cmd_reg;
