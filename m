From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] nsp32 iomem annotations
Date: Thu, 21 Oct 2004 00:54:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235447.GZ23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28585 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270506AbUJTXyt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:54:49 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-megaraid/drivers/scsi/nsp32.c RC9-bk4-nsp32/drivers/scsi/nsp32.c
--- RC9-bk4-megaraid/drivers/scsi/nsp32.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-nsp32/drivers/scsi/nsp32.c	Wed Oct 20 19:24:36 2004
@@ -2721,7 +2721,7 @@
 	host->io_port   = data->BaseAddress;
 	host->unique_id = data->BaseAddress;
 	host->n_io_port	= data->NumAddress;
-	host->base      = data->MmioAddress;
+	host->base      = (unsigned long)data->MmioAddress;
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,63))
 	scsi_set_device(host, &PCIDEV->dev);
 #else
@@ -2939,8 +2939,8 @@
 		release_region(host->io_port, host->n_io_port);
 	}
 
-	if (data->MmioAddress != 0) {
-		iounmap((void *)(data->MmioAddress));
+	if (data->MmioAddress) {
+		iounmap(data->MmioAddress);
 	}
 
 	return 0;
@@ -3512,8 +3512,7 @@
 	data->IrqNumber   = pdev->irq;
 	data->BaseAddress = pci_resource_start(pdev, 0);
 	data->NumAddress  = pci_resource_len  (pdev, 0);
-	data->MmioAddress = 
-		(unsigned long)ioremap_nocache(pci_resource_start(pdev, 1),
+	data->MmioAddress = ioremap_nocache(pci_resource_start(pdev, 1),
 					       pci_resource_len  (pdev, 1));
 	data->MmioLength  = pci_resource_len  (pdev, 1);
 
@@ -3525,7 +3524,7 @@
 	ret = scsi_register_host(&nsp32_template);
 #endif
 
-	nsp32_msg(KERN_INFO, "irq: %i mmio: 0x%lx+0x%lx slot: %s model: %s",
+	nsp32_msg(KERN_INFO, "irq: %i mmio: %p+0x%lx slot: %s model: %s",
 		  pdev->irq,
 		  data->MmioAddress, data->MmioLength,
 		  pci_name(pdev),
diff -urN RC9-bk4-megaraid/drivers/scsi/nsp32.h RC9-bk4-nsp32/drivers/scsi/nsp32.h
--- RC9-bk4-megaraid/drivers/scsi/nsp32.h	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-nsp32/drivers/scsi/nsp32.h	Wed Oct 20 19:24:36 2004
@@ -563,7 +563,7 @@
 	int           IrqNumber;
 	int           BaseAddress;
 	int           NumAddress;
-	unsigned long MmioAddress;
+	void __iomem *MmioAddress;
 #define NSP32_MMIO_OFFSET 0x0800
 	unsigned long MmioLength;
 
