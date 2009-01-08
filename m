From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 5/7] sym53c8xx: handle pci_iomap() failures
Date: Thu, 08 Jan 2009 12:56:58 -0500
Message-ID: <49663E6A.4010508@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3716 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbZAHR47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:56:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

sym_init_device() doesn't check if pci_iomap() fails.  It also tries
to map device RAM without first checking FE_RAM.

1) Move some initialization from sym_init_device() to the top of
   sym2_probe().
2) Rename sym_init_device() to sym_iomap_device().
3) Call sym_iomap_device() after sym_check_supported() instead of
   before so that device->chip.features will be set.
4) Check FE_RAM in sym_iomap_device() before mapping RAM.
5) If sym_iomap_device() cannot map registers, then abort.
6) If sym_iomap_device() cannot map RAM, then fall back to not using
   RAM and continue.
7) Remove the check for FE_RAM in sym_attach() since dev->ram_base
   is now always set correctly.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-07 18:15:29.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-08 10:53:39.000000000 -0500
@@ -1236,7 +1236,7 @@ static int sym53c8xx_proc_info(struct Sc
 #endif /* SYM_LINUX_PROC_INFO_SUPPORT */
 
 /*
- * Free resources claimed by sym_init_device().  Note that
+ * Free resources claimed by sym_iomap_device().  Note that
  * sym_free_resources() should be used instead of this function after calling
  * sym_attach().
  */
@@ -1336,12 +1336,9 @@ static struct Scsi_Host * __devinit sym_
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
 	np->mmio_ba	= (u32)dev->mmio_base;
+	np->ram_ba	= (u32)dev->ram_base;
 	np->s.ioaddr	= dev->s.ioaddr;
 	np->s.ramaddr	= dev->s.ramaddr;
-	if (!(np->features & FE_RAM))
-		dev->ram_base = 0;
-	if (dev->ram_base)
-		np->ram_ba = (u32)dev->ram_base;
 
 	/*
 	 *  Edit its name.
@@ -1559,30 +1556,28 @@ static int __devinit sym_set_workarounds
 }
 
 /*
- *  Read and check the PCI configuration for any detected NCR 
- *  boards and save data for attaching after all boards have 
- *  been detected.
+ * Map HBA registers and on-chip SRAM (if present).
  */
-static void __devinit
-sym_init_device(struct pci_dev *pdev, struct sym_device *device)
+static int __devinit
+sym_iomap_device(struct sym_device *device)
 {
-	int i = 2;
+	struct pci_dev *pdev = device->pdev;
 	struct pci_bus_region bus_addr;
-
-	device->host_id = SYM_SETUP_HOST_ID;
-	device->pdev = pdev;
+	int i = 2;
 
 	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
 	device->mmio_base = bus_addr.start;
 
-	/*
-	 * If the BAR is 64-bit, resource 2 will be occupied by the
-	 * upper 32 bits
-	 */
-	if (!pdev->resource[i].flags)
-		i++;
-	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
-	device->ram_base = bus_addr.start;
+	if (device->chip.features & FE_RAM) {
+		/*
+		 * If the BAR is 64-bit, resource 2 will be occupied by the
+		 * upper 32 bits
+		 */
+		if (!pdev->resource[i].flags)
+			i++;
+		pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
+		device->ram_base = bus_addr.start;
+	}
 
 #ifdef CONFIG_SCSI_SYM53C8XX_MMIO
 	if (device->mmio_base)
@@ -1592,9 +1587,21 @@ sym_init_device(struct pci_dev *pdev, st
 	if (!device->s.ioaddr)
 		device->s.ioaddr = pci_iomap(pdev, 0,
 						pci_resource_len(pdev, 0));
-	if (device->ram_base)
+	if (!device->s.ioaddr) {
+		dev_err(&pdev->dev, "could not map registers; giving up.\n");
+		return -EIO;
+	}
+	if (device->ram_base) {
 		device->s.ramaddr = pci_iomap(pdev, i,
 						pci_resource_len(pdev, i));
+		if (!device->s.ramaddr) {
+			dev_warn(&pdev->dev,
+				"could not map SRAM; continuing anyway.\n");
+			device->ram_base = 0;
+		}
+	}
+
+	return 0;
 }
 
 /*
@@ -1711,6 +1718,8 @@ static int __devinit sym2_probe(struct p
 
 	memset(&sym_dev, 0, sizeof(sym_dev));
 	memset(&nvram, 0, sizeof(nvram));
+	sym_dev.pdev = pdev;
+	sym_dev.host_id = SYM_SETUP_HOST_ID;
 
 	if (pci_enable_device(pdev))
 		goto leave;
@@ -1720,12 +1729,13 @@ static int __devinit sym2_probe(struct p
 	if (pci_request_regions(pdev, NAME53C8XX))
 		goto disable;
 
-	sym_init_device(pdev, &sym_dev);
-	do_iounmap = 1;
-
 	if (sym_check_supported(&sym_dev))
 		goto free;
 
+	if (sym_iomap_device(&sym_dev))
+		goto free;
+	do_iounmap = 1;
+
 	if (sym_check_raid(&sym_dev)) {
 		do_disable_device = 0;	/* Don't disable the device */
 		goto free;


