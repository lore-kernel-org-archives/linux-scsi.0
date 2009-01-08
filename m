From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 4/7] sym53c8xx: unmap pci memory after probe errors
Date: Thu, 08 Jan 2009 12:55:52 -0500
Message-ID: <49663E28.5020706@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4455 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761130AbZAHRzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:55:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

During sym2_probe(), sym_init_device() does pci_iomap(), but there is
no corresponding pci_iounmap() if an error occurs before sym_attach()
copies sym_device::s.{ioaddr,ramaddr} to np.
1) Add the sym_iounmap_device() function.
2) Call sym_iounmap_device() if an error occurs between
   sym_init_device() and the time sym_attach() allocates np.
3) Make sym_attach() copy sym_device::s.{ioaddr,ramaddr} to np before
   calling any function that can fail so that sym_free_resources()
   will do the unmap instead of sym_iounmap_device().

Also fixed by this patch:
During sym2_probe(), if sym_check_raid() returns nonzero, then
pci_release_regions() is never called.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-07 17:35:27.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-07 18:15:29.000000000 -0500
@@ -1236,6 +1236,20 @@ static int sym53c8xx_proc_info(struct Sc
 #endif /* SYM_LINUX_PROC_INFO_SUPPORT */
 
 /*
+ * Free resources claimed by sym_init_device().  Note that
+ * sym_free_resources() should be used instead of this function after calling
+ * sym_attach().
+ */
+static void __devinit
+sym_iounmap_device(struct sym_device *device)
+{
+	if (device->s.ioaddr)
+		pci_iounmap(device->pdev, device->s.ioaddr);
+	if (device->s.ramaddr)
+		pci_iounmap(device->pdev, device->s.ramaddr);
+}
+
+/*
  *	Free controller resources.
  */
 static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev,
@@ -1272,7 +1286,7 @@ static struct Scsi_Host * __devinit sym_
 {
 	struct sym_data *sym_data;
 	struct sym_hcb *np = NULL;
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = NULL;
 	struct pci_dev *pdev = dev->pdev;
 	unsigned long flags;
 	struct sym_fw *fw;
@@ -1287,11 +1301,11 @@ static struct Scsi_Host * __devinit sym_
 	 */
 	fw = sym_find_firmware(&dev->chip);
 	if (!fw)
-		return NULL;
+		goto attach_failed;
 
 	shost = scsi_host_alloc(tpnt, sizeof(*sym_data));
 	if (!shost)
-		return NULL;
+		goto attach_failed;
 	sym_data = shost_priv(shost);
 
 	/*
@@ -1321,6 +1335,13 @@ static struct Scsi_Host * __devinit sym_
 	np->maxoffs	= dev->chip.offset_max;
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
+	np->mmio_ba	= (u32)dev->mmio_base;
+	np->s.ioaddr	= dev->s.ioaddr;
+	np->s.ramaddr	= dev->s.ramaddr;
+	if (!(np->features & FE_RAM))
+		dev->ram_base = 0;
+	if (dev->ram_base)
+		np->ram_ba = (u32)dev->ram_base;
 
 	/*
 	 *  Edit its name.
@@ -1336,22 +1357,6 @@ static struct Scsi_Host * __devinit sym_
 		goto attach_failed;
 	}
 
-	/*
-	 *  Try to map the controller chip to
-	 *  virtual and physical memory.
-	 */
-	np->mmio_ba = (u32)dev->mmio_base;
-	np->s.ioaddr	= dev->s.ioaddr;
-	np->s.ramaddr	= dev->s.ramaddr;
-
-	/*
-	 *  Map on-chip RAM if present and supported.
-	 */
-	if (!(np->features & FE_RAM))
-		dev->ram_base = 0;
-	if (dev->ram_base)
-		np->ram_ba = (u32)dev->ram_base;
-
 	if (sym_hcb_attach(shost, fw, dev->nvram))
 		goto attach_failed;
 
@@ -1419,12 +1424,13 @@ static struct Scsi_Host * __devinit sym_
 		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
 	spin_unlock_irqrestore(shost->host_lock, flags);
  attach_failed:
-	if (!shost)
-		return NULL;
 	printf_info("sym%d: giving up ...\n", unit);
 	if (np)
 		sym_free_resources(np, pdev, do_free_irq);
-	scsi_host_put(shost);
+	else
+		sym_iounmap_device(dev);
+	if (shost)
+		scsi_host_put(shost);
 
 	return NULL;
  }
@@ -1700,6 +1706,8 @@ static int __devinit sym2_probe(struct p
 	struct sym_device sym_dev;
 	struct sym_nvram nvram;
 	struct Scsi_Host *shost;
+	int do_iounmap = 0;
+	int do_disable_device = 1;
 
 	memset(&sym_dev, 0, sizeof(sym_dev));
 	memset(&nvram, 0, sizeof(nvram));
@@ -1713,11 +1721,15 @@ static int __devinit sym2_probe(struct p
 		goto disable;
 
 	sym_init_device(pdev, &sym_dev);
+	do_iounmap = 1;
+
 	if (sym_check_supported(&sym_dev))
 		goto free;
 
-	if (sym_check_raid(&sym_dev))
-		goto leave;	/* Don't disable the device */
+	if (sym_check_raid(&sym_dev)) {
+		do_disable_device = 0;	/* Don't disable the device */
+		goto free;
+	}
 
 	if (sym_set_workarounds(&sym_dev))
 		goto free;
@@ -1726,6 +1738,7 @@ static int __devinit sym2_probe(struct p
 
 	sym_get_nvram(&sym_dev, &nvram);
 
+	do_iounmap = 0; /* Don't sym_iounmap_device() after sym_attach(). */
 	shost = sym_attach(&sym2_template, attach_count, &sym_dev);
 	if (!shost)
 		goto free;
@@ -1741,9 +1754,12 @@ static int __devinit sym2_probe(struct p
  detach:
 	sym_detach(pci_get_drvdata(pdev), pdev);
  free:
+	if (do_iounmap)
+		sym_iounmap_device(&sym_dev);
 	pci_release_regions(pdev);
  disable:
-	pci_disable_device(pdev);
+	if (do_disable_device)
+		pci_disable_device(pdev);
  leave:
 	return -ENODEV;
 }


