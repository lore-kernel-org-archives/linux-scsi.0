From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 8/17] sym53c8xx: Use pdev->revision
Date: Fri,  5 Oct 2007 15:55:05 -0400
Message-ID: <1191614114907-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:47875 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761143AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Auke missed the sym2 driver in his initial sweep.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c   |    6 +++---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   25 +++++++++----------------
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    8 ++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    1 -
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 9916a2a..2be0ae1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -206,13 +206,13 @@ sym_fw2_patch(struct sym_hcb *np)
 	 *  they are not desirable. See `sym_fw2.h' for more details.
 	 */
 	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_66 &&
-	      np->revision_id < 0x1 &&
+	      np->s.device->revision < 0x1 &&
 	      np->pciclk_khz < 60000)) {
 		scripta0->datao_phase[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->datao_phase[1] = cpu_to_scr(0);
 	}
-	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
-	      /* np->revision_id < 0xff */ 1)) {
+	if (!(np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 /* &&
+	      np->s.device->revision < 0xff */)) {
 		scripta0->sel_done[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->sel_done[1] = cpu_to_scr(0);
 	}
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index fec9c9c..ef707a4 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1254,8 +1254,8 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 	info.pos	= 0;
 
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
-			 "revision id 0x%x\n",
-			 np->s.chip_name, np->device_id, np->revision_id);
+			 "revision id 0x%x\n", np->s.chip_name,
+			 np->device_id, np->s.device->revision);
 	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
 		pci_name(np->s.device), IRQ_PRM(np->s.device->irq));
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
@@ -1368,10 +1368,9 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	unsigned long flags;
 	struct sym_fw *fw;
 
-	printk(KERN_INFO
-		"sym%d: <%s> rev 0x%x at pci %s irq " IRQ_FMT "\n",
-		unit, dev->chip.name, dev->chip.revision_id,
-		pci_name(pdev), IRQ_PRM(pdev->irq));
+	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq " IRQ_FMT "\n",
+		unit, dev->chip.name, pdev->revision, pci_name(pdev),
+		IRQ_PRM(pdev->irq));
 
 	/*
 	 *  Get the firmware for this chip.
@@ -1412,7 +1411,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	np->s.device	= pdev;
 	np->s.unit	= unit;
 	np->device_id	= dev->chip.device_id;
-	np->revision_id	= dev->chip.revision_id;
 	np->features	= dev->chip.features;
 	np->clock_divn	= dev->chip.nr_divisor;
 	np->maxoffs	= dev->chip.offset_max;
@@ -1500,7 +1498,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	instance->transportt	= sym2_transport_template;
 
 	/* 53c896 rev 1 errata: DMA may not cross 16MB boundary */
-	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && np->revision_id < 2)
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && pdev->revision < 2)
 		instance->dma_boundary = 0xFFFFFF;
 
 	spin_unlock_irqrestore(instance->host_lock, flags);
@@ -1545,7 +1543,6 @@ static int __devinit sym_check_supported(struct sym_device *device)
 {
 	struct sym_chip *chip;
 	struct pci_dev *pdev = device->pdev;
-	u_char revision;
 	unsigned long io_port = pci_resource_start(pdev, 0);
 	int i;
 
@@ -1565,14 +1562,12 @@ static int __devinit sym_check_supported(struct sym_device *device)
 	 * to our device structure so we can make it match the actual device
 	 * and options.
 	 */
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	chip = sym_lookup_chip_table(pdev->device, revision);
+	chip = sym_lookup_chip_table(pdev->device, pdev->revision);
 	if (!chip) {
 		dev_info(&pdev->dev, "device not supported\n");
 		return -ENODEV;
 	}
 	memcpy(&device->chip, chip, sizeof(device->chip));
-	device->chip.revision_id = revision;
 
 	return 0;
 }
@@ -1613,7 +1608,7 @@ static int __devinit sym_set_workarounds(struct sym_device *device)
 	 *  We must ensure the chip will use WRITE AND INVALIDATE.
 	 *  The revision number limit is for now arbitrary.
 	 */
-	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && chip->revision_id < 0x4) {
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && pdev->revision < 0x4) {
 		chip->features	|= (FE_WRIE | FE_CLSE);
 	}
 
@@ -1904,12 +1899,10 @@ static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
  */
 static void sym2_reset_workarounds(struct pci_dev *pdev)
 {
-	u_char revision;
 	u_short status_reg;
 	struct sym_chip *chip;
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	chip = sym_lookup_chip_table(pdev->device, revision);
+	chip = sym_lookup_chip_table(pdev->device, pdev->revision);
 
 	/* Work around for errant bit in 895A, in a fashion
 	 * similar to what is done in sym_set_workarounds().
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index af24c44..9f4198c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -805,7 +805,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  are used. Disable internal cycles.
 	 */
 	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
-	    np->revision_id < 0x1)
+	    np->s.device->revision < 0x1)
 		np->rv_ccntl0	|=  DILS;
 
 	/*
@@ -829,9 +829,9 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  LOAD/STORE instructions does not need this work-around.
 	 */
 	if ((np->device_id == PCI_DEVICE_ID_NCR_53C810 &&
-	     np->revision_id >= 0x10 && np->revision_id <= 0x11) ||
+	     np->s.device->revision >= 0x10 && np->s.device->revision <= 0x11) ||
 	    (np->device_id == PCI_DEVICE_ID_NCR_53C860 &&
-	     np->revision_id <= 0x1))
+	     np->s.device->revision <= 0x1))
 		np->features &= ~(FE_WRIE|FE_ERL|FE_ERMP);
 
 	/*
@@ -1809,7 +1809,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  I just don't want. :)
 	 */
 	if (np->device_id == PCI_DEVICE_ID_LSI_53C1010_33 &&
-	    np->revision_id < 1)
+	    np->s.device->revision < 1)
 		OUTB(np, nc_stest1, INB(np, nc_stest1) | 0x30);
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 79ab6a1..3aa8060 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -919,7 +919,6 @@ struct sym_hcb {
 	 *  General controller parameters and configuration.
 	 */
 	u_short	device_id;	/* PCI device id		*/
-	u_char	revision_id;	/* PCI device revision id	*/
 	u_int	features;	/* Chip features map		*/
 	u_char	myaddr;		/* SCSI id of the adapter	*/
 	u_char	maxburst;	/* log base 2 of dwords burst	*/
-- 
1.4.4.2

