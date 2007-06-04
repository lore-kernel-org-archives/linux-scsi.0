From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/2] m68k 53c700 SCSI
Date: Mon, 4 Jun 2007 11:17:02 +0100
Message-ID: <20070604101702.GA19864@infradead.org>
References: <20070603112136.885629062@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXFDKRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2007 06:17:12 -0400
Content-Disposition: inline
In-Reply-To: <20070603112136.885629062@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

On Sun, Jun 03, 2007 at 01:21:36PM +0200, Geert Uytterhoeven wrote:
> 	Hi James,
> 
> Here are the updates for m68k 53c700 SCSI drivers:
> [1] m68k: BVME6000 and MVME16x SCSI driver rename
> [2] m68k: switch to 53c700 driver

As I mentioned in the description for the 53c7xx removal patch I
think it's cleaner to just remove the old and re-add the new drivers
when there is nothing left of the content at all and they are renamed
aswell.

Also the amiga7xx driver should probably be split into two, as the
a4000t internal code shares nothing with the zorro bus cards.

So I'd suggest you repost a patch series onto of the current scsi-misc
tree consisting of:

 1/n  changes to the 53c700 driver for m68k support
 2/n  new BVME6000 driver
 3/n  new MVME16x driver
 4/n  new a4000t driver
 5/n  new zorror 53x700 driver

That beeing said the actual code looks very nice.  I've attached a small
patch cleaning up some minor codingstyle deficiencies and switching to
the new shost_priv accessor that's in the scsi-misc tree.


Index: linux-2.6/drivers/scsi/amiga7xx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/amiga7xx.c	2007-06-04 10:48:03.000000000 +0200
+++ linux-2.6/drivers/scsi/amiga7xx.c	2007-06-04 10:52:44.000000000 +0200
@@ -101,7 +101,6 @@ static int __devinit amiga7xx_init_one(s
 	}
 
 	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-
 	if (hostdata == NULL) {
 		printk(KERN_ERR "amiga7xx: Failed to allocate host data\n");
 		goto out_release;
@@ -124,9 +123,11 @@ static int __devinit amiga7xx_init_one(s
 	amiga7xx_scsi_driver_template.name = zdd->name;
 
 	/* and register the chip */
-	if ((host = NCR_700_detect(&amiga7xx_scsi_driver_template, hostdata, &z->dev))
-	   == NULL) {
-		printk(KERN_ERR "amiga7xx-scsi: No host detected; board configuration problem?\n");
+	host = NCR_700_detect(&amiga7xx_scsi_driver_template,
+			hostdata, &z->dev);
+	if (!host) {
+		printk(KERN_ERR "amiga7xx-scsi: No host detected; "
+				"board configuration problem?\n");
 		goto out_free;
 	}
 
@@ -134,7 +135,8 @@ static int __devinit amiga7xx_init_one(s
 	host->base = ioaddr;
 	host->irq = IRQ_AMIGA_PORTS;
 
-	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "amiga7xx-scsi", host)) {
+	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED,
+			"amiga7xx-scsi", host)) {
 		printk(KERN_ERR "amiga7xx-scsi: request_irq failed\n");
 		goto out_put_host;
 	}
@@ -158,8 +160,7 @@ static int __devinit amiga7xx_init_one(s
 static __devexit void amiga7xx_remove_one(struct zorro_dev *z)
 {
 	struct Scsi_Host *host = dev_to_shost(&z->dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 
@@ -188,7 +189,8 @@ static int __devinit a4000t_probe(struct
 	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
 		goto out;
 
-	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000, "A4000T builtin SCSI"))
+	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000,
+			"A4000T builtin SCSI"))
 		goto out;
 
 	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
@@ -206,9 +208,10 @@ static int __devinit a4000t_probe(struct
 	hostdata->dcntl_extra = EA_710;
 
 	/* and register the chip */
-	if ((host = NCR_700_detect(&amiga7xx_scsi_driver_template, hostdata, dev))
-	   == NULL) {
-		printk(KERN_ERR "a4000t-scsi: No host detected; board configuration problem?\n");
+	host = NCR_700_detect(&amiga7xx_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "a4000t-scsi: No host detected; "
+				"board configuration problem?\n");
 		goto out_free;
 	}
 
@@ -238,8 +241,7 @@ static int __devinit a4000t_probe(struct
 static __devexit int a4000t_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_to_shost(dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 
@@ -262,11 +264,12 @@ static int __init amiga7xx_scsi_init(voi
 {
 	int err;
 
-	if ((err = driver_register(&a4000t_scsi_driver)))
+	err = driver_register(&a4000t_scsi_driver);
+	if (err)
 		return err;
 
-	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi", -1, NULL, 0);
-
+	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi",
+			-1, NULL, 0);
 	if (IS_ERR(a4000t_scsi_device)) {
 		driver_unregister(&a4000t_scsi_driver);
 		return PTR_ERR(a4000t_scsi_device);
Index: linux-2.6/drivers/scsi/bvme6000_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/bvme6000_scsi.c	2007-06-04 10:48:03.000000000 +0200
+++ linux-2.6/drivers/scsi/bvme6000_scsi.c	2007-06-04 11:15:57.000000000 +0200
@@ -44,7 +44,8 @@ bvme6000_probe(struct device *dev)
 
 	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
 	if (hostdata == NULL) {
-		printk(KERN_ERR "bvme6000-scsi: Failed to allocate host data\n");
+		printk(KERN_ERR "bvme6000-scsi: "
+				"Failed to allocate host data\n");
 		goto out;
 	}
 	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
@@ -58,15 +59,17 @@ bvme6000_probe(struct device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	if ((host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev))
-	   == NULL) {
-		printk(KERN_ERR "bvme6000-scsi: No host detected; board configuration problem?\n");
+	host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "bvme6000-scsi: No host detected; "
+				"board configuration problem?\n");
 		goto out_free;
 	}
 	host->base = BVME_NCR53C710_BASE;
 	host->this_id = 7;
 	host->irq = BVME_IRQ_SCSI;
-	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0, "bvme6000-scsi", host)) {
+	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0,
+			"bvme6000-scsi", host)) {
 		printk(KERN_ERR "bvme6000-scsi: request_irq failed\n");
 		goto out_put_host;
 	}
@@ -87,8 +90,7 @@ static __devexit int
 bvme6000_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_to_shost(dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
@@ -109,11 +111,12 @@ static int __init bvme6000_scsi_init(voi
 {
 	int err;
 
-	if ((err = driver_register(&bvme6000_scsi_driver)))
+	err = driver_register(&bvme6000_scsi_driver);
+	if (err) {
 		return err;
 
-	bvme6000_scsi_device = platform_device_register_simple("bvme6000-scsi", -1, NULL, 0);
-
+	bvme6000_scsi_device = platform_device_register_simple("bvme6000-scsi",
+			-1, NULL, 0);
 	if (IS_ERR(bvme6000_scsi_device)) {
 		driver_unregister(&bvme6000_scsi_driver);
 		return PTR_ERR(bvme6000_scsi_device);
Index: linux-2.6/drivers/scsi/mvme16x_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mvme16x_scsi.c	2007-06-04 10:48:03.000000000 +0200
+++ linux-2.6/drivers/scsi/mvme16x_scsi.c	2007-06-04 10:52:42.000000000 +0200
@@ -43,13 +43,15 @@ mvme16x_probe(struct device *dev)
 		goto out;
 
 	if (mvme16x_config & MVME16x_CONFIG_NO_SCSICHIP) {
-		printk(KERN_INFO "mvme16x-scsi: detection disabled, SCSI chip not present\n");
+		printk(KERN_INFO "mvme16x-scsi: detection disabled, "
+				 "SCSI chip not present\n");
 		goto out;
 	}
 
 	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
 	if (hostdata == NULL) {
-		printk(KERN_ERR "mvme16x-scsi: Failed to allocate host data\n");
+		printk(KERN_ERR "mvme16x-scsi: "
+				"Failed to allocate host data\n");
 		goto out;
 	}
 	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
@@ -63,9 +65,10 @@ mvme16x_probe(struct device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	if ((host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev))
-	   == NULL) {
-		printk(KERN_ERR "mvme16x-scsi: No host detected; board configuration problem?\n");
+	host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "mvme16x-scsi: No host detected; "
+				"board configuration problem?\n");
 		goto out_free;
 	}
 	host->this_id = 7;
@@ -102,8 +105,7 @@ static __devexit int
 mvme16x_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_to_shost(dev);
-	struct NCR_700_Host_Parameters *hostdata =
-		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
 
 	/* Disable scsi chip ints */
 	{
@@ -132,11 +134,12 @@ static int __init mvme16x_scsi_init(void
 {
 	int err;
 
-	if ((err = driver_register(&mvme16x_scsi_driver)))
+	err = driver_register(&mvme16x_scsi_driver);
+	if (err)
 		return err;
 
-	mvme16x_scsi_device = platform_device_register_simple("mvme16x-scsi", -1, NULL, 0);
-
+	mvme16x_scsi_device = platform_device_register_simple("mvme16x-scsi",
+			-1, NULL, 0);
 	if (IS_ERR(mvme16x_scsi_device)) {
 		driver_unregister(&mvme16x_scsi_driver);
 		return PTR_ERR(mvme16x_scsi_device);
