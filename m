From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tiny zalon cleanups
Date: Sat, 20 Sep 2003 11:30:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920093012.GA20959@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:12526 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261768AbTITJaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 05:30:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Rename zalon_scsi_callback to the more sensible zalon_probe and fix
a few tiny indentation issues.


--- 1.8/drivers/scsi/zalon.c	Thu Sep 11 19:46:12 2003
+++ edited/drivers/scsi/zalon.c	Sat Sep 20 10:05:53 2003
@@ -99,7 +99,7 @@
 };
 
 static int __init
-zalon_scsi_callback(struct parisc_device *dev)
+zalon_probe(struct parisc_device *dev)
 {
 	struct gsc_irq gsc_irq;
 	u32 zalon_vers;
@@ -130,7 +130,7 @@
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, dev->hpa + IO_MODULE_EIM);
 
-	if ( zalon_vers == 0)
+	if (zalon_vers == 0)
 		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __FUNCTION__);
 
 	memset(&device, 0, sizeof(ncr_device));
@@ -150,10 +150,10 @@
 	device.differential	= 2;
 
 	host = ncr_attach(&zalon7xx_template, unit, &device);
-	if(!host)
+	if (!host)
 		goto fail;
 
-	if(request_irq(irq, ncr53c8xx_intr, SA_SHIRQ, dev->dev.bus_id, host)) {
+	if (request_irq(irq, ncr53c8xx_intr, SA_SHIRQ, dev->dev.bus_id, host)) {
 		printk(KERN_ERR "%s: irq problem with %d, detaching\n ",
 		       dev->dev.bus_id, irq);
 		goto fail;
@@ -200,7 +200,7 @@
 static struct parisc_driver zalon_driver = {
 	.name =		"GSC SCSI (Zalon)",
 	.id_table =	zalon_tbl,
-	.probe =	zalon_scsi_callback,
+	.probe =	zalon_probe,
 	.remove =	__devexit_p(zalon_remove),
 };
 
