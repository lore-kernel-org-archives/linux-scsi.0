From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] small lasi700 update
Date: Mon, 22 Sep 2003 11:50:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922095010.GA20291@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:21915 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262738AbTIVJuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 05:50:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 - move the struct parisc_driver down like in most drivers, avoids
   two forward-declarations
 - give lasi700_scsi_tbl and lasi700_driver_callback sensible names
 - properly return -ENOMEM instead of 1 on kmalloc failure
 - check scsi_add_host return value



--- 1.15/drivers/scsi/lasi700.c	Sun Aug 17 04:43:48 2003
+++ edited/drivers/scsi/lasi700.c	Sun Sep 21 22:17:38 2003
@@ -59,7 +59,7 @@
 MODULE_DESCRIPTION("lasi700 SCSI Driver");
 MODULE_LICENSE("GPL");
 
-static struct parisc_device_id lasi700_scsi_tbl[] = {
+static struct parisc_device_id lasi700_ids[] = {
 	LASI700_ID_TABLE,
 	LASI710_ID_TABLE,
 	{ 0 }
@@ -72,15 +72,8 @@
 };
 MODULE_DEVICE_TABLE(parisc, lasi700_scsi_tbl);
 
-static struct parisc_driver lasi700_driver = {
-	.name =		"Lasi SCSI",
-	.id_table =	lasi700_scsi_tbl,
-	.probe =	lasi700_driver_callback,
-	.remove =	__devexit_p(lasi700_driver_remove),
-};
-
 static int __init
-lasi700_driver_callback(struct parisc_device *dev)
+lasi700_probe(struct parisc_device *dev)
 {
 	unsigned long base = dev->hpa + LASI_SCSI_CORE_OFFSET;
 	struct NCR_700_Host_Parameters *hostdata;
@@ -90,7 +83,7 @@
 	if (!hostdata) {
 		printk(KERN_ERR "%s: Failed to allocate host data\n",
 		       dev->dev.bus_id);
-		return 1;
+		return -ENOMEM;
 	}
 	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
 
@@ -123,15 +116,17 @@
 		goto out_put_host;
 	}
 
+	if (scsi_add_host(host, &dev->dev))
+		goto out_free_irq;
 	dev_set_drvdata(&dev->dev, host);
-	scsi_add_host(host, &dev->dev); /* XXX handle failure */
 	scsi_scan_host(host);
 
 	return 0;
 
+ out_free_irq:
+	free_irq(host->irq, host);
  out_put_host:
 	scsi_host_put(host);
-
  out_kfree:
 	kfree(hostdata);
 	return -ENODEV;
@@ -151,6 +146,13 @@
 
 	return 0;
 }
+
+static struct parisc_driver lasi700_driver = {
+	.name =		"Lasi SCSI",
+	.id_table =	lasi700_ids,
+	.probe =	lasi700_probe,
+	.remove =	__devexit_p(lasi700_driver_remove),
+};
 
 static int __init
 lasi700_init(void)
--- 1.6/drivers/scsi/lasi700.h	Thu Jun 26 04:41:10 2003
+++ edited/drivers/scsi/lasi700.h	Sun Sep 21 22:14:43 2003
@@ -25,9 +25,6 @@
 #ifndef _LASI700_H
 #define _LASI700_H
 
-static int lasi700_driver_callback(struct parisc_device *dev);
-static int lasi700_driver_remove(struct parisc_device *dev);
-
 #define LASI_710_SVERSION	0x082
 #define LASI_700_SVERSION	0x071
 
