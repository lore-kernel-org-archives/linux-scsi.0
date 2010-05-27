From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/24] hpsa: save pdev pointer in per hba structure early to
	avoid passing it around so much.
Date: Thu, 27 May 2010 15:12:46 -0500
Message-ID: <20100527201246.3116.59564.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26534 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0E0UII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:08 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: save pdev pointer in per hba structure early to avoid passing it around so much.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   75 ++++++++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 183d3a4..d3c7c4b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3217,8 +3217,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
  * controllers that are capable. If not, we use IO-APIC mode.
  */
 
-static void __devinit hpsa_interrupt_mode(struct ctlr_info *h,
-					   struct pci_dev *pdev, u32 board_id)
+static void __devinit hpsa_interrupt_mode(struct ctlr_info *h, u32 board_id)
 {
 #ifdef CONFIG_PCI_MSI
 	int err;
@@ -3231,9 +3230,9 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h,
 	    (board_id == 0x40800E11) ||
 	    (board_id == 0x40820E11) || (board_id == 0x40830E11))
 		goto default_int_mode;
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
-		dev_info(&pdev->dev, "MSIX\n");
-		err = pci_enable_msix(pdev, hpsa_msix_entries, 4);
+	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
+		dev_info(&h->pdev->dev, "MSIX\n");
+		err = pci_enable_msix(h->pdev, hpsa_msix_entries, 4);
 		if (!err) {
 			h->intr[0] = hpsa_msix_entries[0].vector;
 			h->intr[1] = hpsa_msix_entries[1].vector;
@@ -3243,29 +3242,29 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h,
 			return;
 		}
 		if (err > 0) {
-			dev_warn(&pdev->dev, "only %d MSI-X vectors "
+			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
 			goto default_int_mode;
 		} else {
-			dev_warn(&pdev->dev, "MSI-X init failed %d\n",
+			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
 			goto default_int_mode;
 		}
 	}
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
-		dev_info(&pdev->dev, "MSI\n");
-		if (!pci_enable_msi(pdev))
+	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
+		dev_info(&h->pdev->dev, "MSI\n");
+		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
 		else
-			dev_warn(&pdev->dev, "MSI init failed\n");
+			dev_warn(&h->pdev->dev, "MSI init failed\n");
 	}
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	h->intr[PERF_MODE_INT] = pdev->irq;
+	h->intr[PERF_MODE_INT] = h->pdev->irq;
 }
 
-static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
+static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	u32 board_id, scratchpad = 0;
@@ -3275,8 +3274,8 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 	u32 trans_offset;
 	int i, prod_index, err;
 
-	subsystem_vendor_id = pdev->subsystem_vendor;
-	subsystem_device_id = pdev->subsystem_device;
+	subsystem_vendor_id = h->pdev->subsystem_vendor;
+	subsystem_device_id = h->pdev->subsystem_device;
 	board_id = (((u32) (subsystem_device_id << 16) & 0xffff0000) |
 		    subsystem_vendor_id);
 
@@ -3290,7 +3289,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 		prod_index--;
 		if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
 				!hpsa_allow_any) {
-			dev_warn(&pdev->dev, "unrecognized board ID:"
+			dev_warn(&h->pdev->dev, "unrecognized board ID:"
 				" 0x%08lx, ignoring.\n",
 				(unsigned long) board_id);
 			return -ENODEV;
@@ -3299,41 +3298,42 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 	/* check to see if controller has been disabled
 	 * BEFORE trying to enable it
 	 */
-	(void)pci_read_config_word(pdev, PCI_COMMAND, &command);
+	(void)pci_read_config_word(h->pdev, PCI_COMMAND, &command);
 	if (!(command & 0x02)) {
-		dev_warn(&pdev->dev, "controller appears to be disabled\n");
+		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
 
-	err = pci_enable_device(pdev);
+	err = pci_enable_device(h->pdev);
 	if (err) {
-		dev_warn(&pdev->dev, "unable to enable PCI device\n");
+		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");
 		return err;
 	}
 
-	err = pci_request_regions(pdev, "hpsa");
+	err = pci_request_regions(h->pdev, "hpsa");
 	if (err) {
-		dev_err(&pdev->dev, "cannot obtain PCI resources, aborting\n");
+		dev_err(&h->pdev->dev,
+			"cannot obtain PCI resources, aborting\n");
 		return err;
 	}
 
 	/* If the kernel supports MSI/MSI-X we will try to enable that,
 	 * else we use the IO-APIC interrupt assigned to us by system ROM.
 	 */
-	hpsa_interrupt_mode(h, pdev, board_id);
+	hpsa_interrupt_mode(h, board_id);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM)
+		if (pci_resource_flags(h->pdev, i) & IORESOURCE_MEM)
 			break;
 	}
 	if (i == DEVICE_COUNT_RESOURCE) {
-		dev_warn(&pdev->dev, "no memory BAR found\n");
+		dev_warn(&h->pdev->dev, "no memory BAR found\n");
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
 
-	h->paddr = pci_resource_start(pdev, i); /* addressing mode bits
+	h->paddr = pci_resource_start(h->pdev, i); /* addressing mode bits
 						 * already removed
 						 */
 
@@ -3347,7 +3347,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
 	if (scratchpad != HPSA_FIRMWARE_READY) {
-		dev_warn(&pdev->dev, "board not ready, timed out.\n");
+		dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
@@ -3355,20 +3355,20 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 	/* get the address index number */
 	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
 	cfg_base_addr &= (u32) 0x0000ffff;
-	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
+	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
 	if (cfg_base_addr_index == -1) {
-		dev_warn(&pdev->dev, "cannot find cfg_base_addr_index\n");
+		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
 
 	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
-	h->cfgtable = remap_pci_mem(pci_resource_start(pdev,
+	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
 			       cfg_base_addr_index) + cfg_offset,
 				sizeof(h->cfgtable));
 	/* Find performant mode table. */
 	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
-	h->transtable = remap_pci_mem(pci_resource_start(pdev,
+	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
 				cfg_base_addr_index)+cfg_offset+trans_offset,
 				sizeof(*h->transtable));
 
@@ -3400,7 +3400,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
 	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
 	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
-		dev_warn(&pdev->dev, "not a valid CISS config table\n");
+		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
@@ -3442,11 +3442,12 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 	}
 
 #ifdef HPSA_DEBUG
-	print_cfg_table(&pdev->dev, h->cfgtable);
+	print_cfg_table(&h->pdev->dev, h->cfgtable);
 #endif				/* HPSA_DEBUG */
 
 	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
-		dev_warn(&pdev->dev, "unable to get board into simple mode\n");
+		dev_warn(&h->pdev->dev,
+			"unable to get board into simple mode\n");
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
@@ -3457,7 +3458,7 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	pci_release_regions(pdev);
+	pci_release_regions(h->pdev);
 	return err;
 }
 
@@ -3515,17 +3516,17 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	if (!h)
 		return -ENOMEM;
 
+	h->pdev = pdev;
 	h->busy_initializing = 1;
 	INIT_HLIST_HEAD(&h->cmpQ);
 	INIT_HLIST_HEAD(&h->reqQ);
-	rc = hpsa_pci_init(h, pdev);
+	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
 
 	sprintf(h->devname, "hpsa%d", number_of_controllers);
 	h->ctlr = number_of_controllers;
 	number_of_controllers++;
-	h->pdev = pdev;
 
 	/* configure PCI DMA stuff */
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));

