From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: [PATCH 2.6.15] I2O: move pci_request_regions() just behind pci_enable_device()
Date: Thu, 12 Jan 2006 08:31:57 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0207C3C4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:3045 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751192AbWALNcB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 08:32:01 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryoji Kamei <kamei@miraclelinux.com>, linux-scsi <linux-scsi@vger.kernel.org>, Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: akpm@osdl.org

The problem in dpt_i2o could be the pci config space accesses it
triggers as it loads, dangerous to do if there is any I/O activity going
on in the other driver (probable if a boot driver I guess).

I approve this patch to dpt_i2o.c, and am applying it to the Adaptec
branch of the driver.

Thanks for the investigation Ryoji.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Ryoji Kamei [mailto:kamei@miraclelinux.com] 
Sent: Thursday, January 12, 2006 5:34 AM
To: akpm@osdl.org; AACRAID
Cc: Ryoji Kamei
Subject: [PATCH 2.6.15] I2O: move pci_request_regions() just behind
pci_enable_device()



Dear maintainers,

In linux 2.6.15, data transfer does hang when both dpt_i2o
and i2o_block drivers are loaded.
It seems that location of pci_request_regions() are wrong.
I moved it just behind pci_enable_device() like other drivers,
and it becomes fine.

Signed-off-by: Ryoji Kamei <kamei@miraclelinux.com>
---
--- linux-2.6.15.orig/drivers/message/i2o/pci.c	2006-01-03
12:21:10.000000000 +0900
+++ linux-2.6.15/drivers/message/i2o/pci.c	2006-01-12
16:48:45.456399784
+0900
@@ -88,11 +88,6 @@
 	struct device *dev = &pdev->dev;
 	int i;

-	if (pci_request_regions(pdev, OSM_DESCRIPTION)) {
-		printk(KERN_ERR "%s: device already claimed\n",
c->name);
-		return -ENODEV;
-	}
-
 	for (i = 0; i < 6; i++) {
 		/* Skip I/O spaces */
 		if (!(pci_resource_flags(pdev, i) & IORESOURCE_IO)) {
@@ -319,6 +314,11 @@
 		return rc;
 	}

+	if (pci_request_regions(pdev, OSM_DESCRIPTION)) {
+		printk(KERN_ERR "i2o: device already claimed\n",
c->name);
+		return -ENODEV;
+	}
+
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "i2o: no suitable DMA found for
%s\n",
 		       pci_name(pdev));
--- linux-2.6.15.orig/drivers/scsi/dpt_i2o.c	2006-01-03
12:21:10.000000000 +0900
+++ linux-2.6.15/drivers/scsi/dpt_i2o.c	2006-01-12 16:51:36.842345160
+0900
@@ -898,6 +898,12 @@
 	if(pci_enable_device(pDev)) {
 		return -EINVAL;
 	}
+
+	if (pci_request_regions(pDev, "dpt_i2o")) {
+		PERROR("dpti: adpt_config_hba: pci request region
failed\n");
+		return -EINVAL;
+	}
+
 	pci_set_master(pDev);
 	if (pci_set_dma_mask(pDev, 0xffffffffffffffffULL) &&
 	    pci_set_dma_mask(pDev, 0xffffffffULL))
@@ -923,10 +929,6 @@
 		raptorFlag = TRUE;
 	}

-	if (pci_request_regions(pDev, "dpt_i2o")) {
-		PERROR("dpti: adpt_config_hba: pci request region
failed\n");
-		return -EINVAL;
-	}
 	base_addr_virt = ioremap(base_addr0_phys,hba_map0_area_size);
 	if (!base_addr_virt) {
 		pci_release_regions(pDev);
