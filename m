From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Misc zalon fixes
Date: Wed, 29 Dec 2004 20:32:56 +0000
Message-ID: <20041229203256.GC18338@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53911 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261411AbUL2Uc4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 15:32:56 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CjkV6-00079s-8o
	for linux-scsi@vger.kernel.org; Wed, 29 Dec 2004 20:32:56 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Some miscellaneous cleanups for the Zalon driver:

 - Remove unused definitions of sync_scsi_data_for_cpu and
   sync_scsi_data_for_device
 - Fill in dev->irq in the zalon driver
 - Request the interrupt in the name of the driver, not the bus address
 - Change the driver name to look better in sysfs
 - Call ncr53c8xx_exit() in zalon7xx_exit()

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_comm.h parisc-2.6/drivers/scsi/sym53c8xx_comm.h
--- linus-2.6/drivers/scsi/sym53c8xx_comm.h	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_comm.h	2004-12-24 16:40:00.000000000 -0700
@@ -505,8 +505,6 @@ static int __map_scsi_sg_data(struct dev
 #define unmap_scsi_data(np, cmd)	__unmap_scsi_data(np->dev, cmd)
 #define map_scsi_single_data(np, cmd)	__map_scsi_single_data(np->dev, cmd)
 #define map_scsi_sg_data(np, cmd)	__map_scsi_sg_data(np->dev, cmd)
-#define sync_scsi_data_for_cpu(np, cmd)	__sync_scsi_data_for_cpu(np->dev, cmd)
-#define sync_scsi_data_for_device(np, cmd) __sync_scsi_data_for_device(np->dev, cmd)
 
 /*==========================================================
 **
diff -urpNX dontdiff linus-2.6/drivers/scsi/zalon.c parisc-2.6/drivers/scsi/zalon.c
--- linus-2.6/drivers/scsi/zalon.c	2004-12-26 14:03:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/zalon.c	2004-12-24 16:40:00.000000000 -0700
@@ -87,7 +87,7 @@ zalon_probe(struct parisc_device *dev)
 {
 	struct gsc_irq gsc_irq;
 	u32 zalon_vers;
-	int irq, error = -ENODEV;
+	int error = -ENODEV;
 	unsigned long zalon = dev->hpa;
 	unsigned long io_port = zalon + GSC_SCSI_ZALON_OFFSET;
 	static int unit = 0;
@@ -107,10 +107,10 @@ zalon_probe(struct parisc_device *dev)
 	/* Setup the interrupts first.
 	** Later on request_irq() will register the handler.
 	*/
-	irq = gsc_alloc_irq(&gsc_irq);
+	dev->irq = gsc_alloc_irq(&gsc_irq);
 
 	printk("%s: Zalon vers field is 0x%x, IRQ %d\n", __FUNCTION__,
-		zalon_vers, irq);
+		zalon_vers, dev->irq);
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, dev->hpa + IO_MODULE_EIM);
 
@@ -130,16 +130,16 @@ zalon_probe(struct parisc_device *dev)
 	device.dev		= &dev->dev;
 	device.slot.base	= (u_long)io_port;
 	device.slot.base_c	= (u_long)io_port;
-	device.slot.irq		= irq;
+	device.slot.irq		= dev->irq;
 	device.differential	= 2;
 
 	host = ncr_attach(&zalon7xx_template, unit, &device);
 	if (!host)
 		goto fail;
 
-	if (request_irq(irq, ncr53c8xx_intr, SA_SHIRQ, dev->dev.bus_id, host)) {
+	if (request_irq(dev->irq, ncr53c8xx_intr, SA_SHIRQ, "zalon", host)) {
 		printk(KERN_ERR "%s: irq problem with %d, detaching\n ",
-			dev->dev.bus_id, irq);
+			dev->dev.bus_id, dev->irq);
 		goto fail;
 	}
 
@@ -155,7 +155,7 @@ zalon_probe(struct parisc_device *dev)
 	return 0;
 
  fail_free_irq:
-	free_irq(irq, host);
+	free_irq(dev->irq, host);
  fail:
 	ncr53c8xx_release(host);
 	return error;
@@ -171,18 +171,16 @@ MODULE_DEVICE_TABLE(parisc, zalon_tbl);
 static int __exit zalon_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
-	int irq = host->irq;
 
 	scsi_remove_host(host);
 	ncr53c8xx_release(host);
-	free_irq(irq, host);
+	free_irq(dev->irq, host);
 
 	return 0;
 }
-	
 
 static struct parisc_driver zalon_driver = {
-	.name =		"GSC SCSI (Zalon)",
+	.name =		"zalon",
 	.id_table =	zalon_tbl,
 	.probe =	zalon_probe,
 	.remove =	__devexit_p(zalon_remove),
@@ -201,6 +199,7 @@ static int __init zalon7xx_init(void)
 static void __exit zalon7xx_exit(void)
 {
 	unregister_parisc_driver(&zalon_driver);
+	ncr53c8xx_exit();
 }
 
 module_init(zalon7xx_init);

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
