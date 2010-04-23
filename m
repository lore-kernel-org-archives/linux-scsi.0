From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 08/14] m68k: amiga - A4000T SCSI platform device conversion
Date: Fri, 23 Apr 2010 10:00:29 +0200
Message-ID: <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:59947 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0DWIAk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 04:00:40 -0400
In-Reply-To: <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
---
 arch/m68k/amiga/platform.c |   11 +++++
 drivers/scsi/a4000t.c      |  101 ++++++++++++++++++++------------------------
 2 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index df1fae3..027e4ca 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -65,6 +65,13 @@ static const struct resource a3000_scsi_resource __initconst = {
 };
 
 
+static const struct resource a4000t_scsi_resource __initconst = {
+	.start	= 0xdd0000,
+	.end	= 0xdd0fff,
+	.flags	= IORESOURCE_MEM,
+};
+
+
 static int __init amiga_init_devices(void)
 {
 	if (!MACH_IS_AMIGA)
@@ -88,6 +95,10 @@ static int __init amiga_init_devices(void)
 		platform_device_register_simple("amiga-a3000-scsi", -1,
 						&a3000_scsi_resource, 1);
 
+	if (AMIGAHW_PRESENT(A4000_SCSI))
+		platform_device_register_simple("amiga-a4000t-scsi", -1,
+						&a4000t_scsi_resource, 1);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 11ae6be..23c76f4 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -20,10 +20,6 @@
 
 #include "53c700.h"
 
-MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / Kars de Jong <jongk@linux-m68k.org>");
-MODULE_DESCRIPTION("Amiga A4000T NCR53C710 driver");
-MODULE_LICENSE("GPL");
-
 
 static struct scsi_host_template a4000t_scsi_driver_template = {
 	.name		= "A4000T builtin SCSI",
@@ -32,30 +28,35 @@ static struct scsi_host_template a4000t_scsi_driver_template = {
 	.module		= THIS_MODULE,
 };
 
-static struct platform_device *a4000t_scsi_device;
 
-#define A4000T_SCSI_ADDR 0xdd0040
+#define A4000T_SCSI_OFFSET	0x40
 
-static int __devinit a4000t_probe(struct platform_device *dev)
+static int __init amiga_a4000t_scsi_probe(struct platform_device *pdev)
 {
-	struct Scsi_Host *host;
+	struct resource *res;
+	phys_addr_t scsi_addr;
 	struct NCR_700_Host_Parameters *hostdata;
+	struct Scsi_Host *host;
 
-	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
-		goto out;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 
-	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000,
+	if (!request_mem_region(res->start, resource_size(res),
 				"A4000T builtin SCSI"))
-		goto out;
+		return -EBUSY;
 
-	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters),
+			   GFP_KERNEL);
 	if (!hostdata) {
-		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
+		dev_err(&pdev->dev, "Failed to allocate host data\n");
 		goto out_release;
 	}
 
+	scsi_addr = res->start + A4000T_SCSI_OFFSET;
+
 	/* Fill in the required pieces of hostdata */
-	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
+	hostdata->base = (void __iomem *)ZTWO_VADDR(scsi_addr);
 	hostdata->clock = 50;
 	hostdata->chip710 = 1;
 	hostdata->dmode_extra = DMODE_FC2;
@@ -63,26 +64,25 @@ static int __devinit a4000t_probe(struct platform_device *dev)
 
 	/* and register the chip */
 	host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata,
-			      &dev->dev);
+			      &pdev->dev);
 	if (!host) {
-		printk(KERN_ERR "a4000t-scsi: No host detected; "
-				"board configuration problem?\n");
+		dev_err(&pdev->dev,
+			"No host detected; board configuration problem?\n");
 		goto out_free;
 	}
 
 	host->this_id = 7;
-	host->base = A4000T_SCSI_ADDR;
+	host->base = scsi_addr;
 	host->irq = IRQ_AMIGA_PORTS;
 
 	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "a4000t-scsi",
 			host)) {
-		printk(KERN_ERR "a4000t-scsi: request_irq failed\n");
+		dev_err(&pdev->dev, "request_irq failed\n");
 		goto out_put_host;
 	}
 
-	platform_set_drvdata(dev, host);
+	platform_set_drvdata(pdev, host);
 	scsi_scan_host(host);
-
 	return 0;
 
  out_put_host:
@@ -90,58 +90,49 @@ static int __devinit a4000t_probe(struct platform_device *dev)
  out_free:
 	kfree(hostdata);
  out_release:
-	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
- out:
+	release_mem_region(res->start, resource_size(res));
 	return -ENODEV;
 }
 
-static __devexit int a4000t_device_remove(struct platform_device *dev)
+static int __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
 {
-	struct Scsi_Host *host = platform_get_drvdata(dev);
+	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	scsi_remove_host(host);
-
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
-	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
-
+	release_mem_region(res->start, resource_size(res));
 	return 0;
 }
 
-static struct platform_driver a4000t_scsi_driver = {
-	.driver = {
-		.name           = "a4000t-scsi",
-		.owner          = THIS_MODULE,
+static struct platform_driver amiga_a4000t_scsi_driver = {
+	.remove = __exit_p(amiga_a4000t_scsi_remove),
+	.driver   = {
+		.name	= "amiga-a4000t-scsi",
+		.owner	= THIS_MODULE,
 	},
-	.probe          = a4000t_probe,
-	.remove         = __devexit_p(a4000t_device_remove),
 };
 
-static int __init a4000t_scsi_init(void)
+static int __init amiga_a4000t_scsi_init(void)
 {
-	int err;
-
-	err = platform_driver_register(&a4000t_scsi_driver);
-	if (err)
-		return err;
-
-	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi",
-			-1, NULL, 0);
-	if (IS_ERR(a4000t_scsi_device)) {
-		platform_driver_unregister(&a4000t_scsi_driver);
-		return PTR_ERR(a4000t_scsi_device);
-	}
-
-	return err;
+	return platform_driver_probe(&amiga_a4000t_scsi_driver,
+				     amiga_a4000t_scsi_probe);
 }
 
-static void __exit a4000t_scsi_exit(void)
+module_init(amiga_a4000t_scsi_init);
+
+static void __exit amiga_a4000t_scsi_exit(void)
 {
-	platform_device_unregister(a4000t_scsi_device);
-	platform_driver_unregister(&a4000t_scsi_driver);
+	platform_driver_unregister(&amiga_a4000t_scsi_driver);
 }
 
-module_init(a4000t_scsi_init);
-module_exit(a4000t_scsi_exit);
+module_exit(amiga_a4000t_scsi_exit);
+
+MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / "
+	      "Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("Amiga A4000T NCR53C710 driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-a4000t-scsi");
-- 
1.6.0.4

