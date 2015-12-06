From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: eata module for DPT SCSI cards
Date: Mon, 7 Dec 2015 02:11:28 +1030
Message-ID: <56645728.3040202@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17659 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbbLFPlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2015 10:41:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: linux-scsi@vger.kernel.org


Hi, I'm still having to have the following applied to be able to use the 
eata driver for my DPT2044W SCSI card.

Is there any chance that this could be mainlined or another fix 
implemented that can be mainlined?

As it is with the following patches applied, I still have to unload and 
reload the eata driver before mounting filesystems on the disk attached 
to the DPT2044W SCSI card that uses the eata driver, otherwise kexec 
reboots fail.

Without the patches applied, the machine locks up when it tries to load 
the eata module.

Arthur.


diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d7ffd66..8321c46 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -391,6 +391,7 @@ int __weak pcibios_alloc_irq(struct pci_dev *dev)
  {
  	return 0;
  }
+EXPORT_SYMBOL_GPL(pcibios_alloc_irq);

  void __weak pcibios_free_irq(struct pci_dev *dev)
  {
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c..7e6eaf8 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1061,6 +1061,7 @@ static void enable_pci_ports(void)
  		       driver_name, dev->bus->number, dev->devfn);
  #endif

+		pcibios_alloc_irq(dev);
  		if (pci_enable_device(dev))
  			printk
  			    ("%s: warning, pci_enable_device failed, bus %d devfn 0x%x.\n",
@@ -1520,6 +1521,7 @@ static void add_pci_ports(void)
  		if (!(dev = pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev)))
  			break;

+		pcibios_alloc_irq(dev);
  		if (pci_enable_device(dev)) {
  #if defined(DEBUG_PCI_DETECT)
  			printk

## end
