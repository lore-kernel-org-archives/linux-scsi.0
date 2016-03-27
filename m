From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/2] drivers/scsi: make sun3x_esp.c driver explicitly non-modular
Date: Sun, 27 Mar 2016 13:00:25 -0400
Message-ID: <1459098025-26269-3-git-send-email-paul.gortmaker@windriver.com>
References: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The Kconfig for this driver is currently:

config SUN3X_ESP
    bool "Sun3x ESP SCSI"

...meaning that it currently is not being built as a module by anyone,
and it has been this way since the beginning of git history (~2005).

Lets remove the modular code that is essentially orphaned, so that
when reading the driver there is no doubt it is builtin-only.

We explicitly disallow a driver unbind, since that doesn't have a
sensible use case anyway, and it allows us to drop the ".remove"
code for non-modular drivers.

Since module_init translates to device_initcall in the non-modular
case, the init ordering remains unchanged with this commit.

We also delete the MODULE_LICENSE tag etc. since all that information
was (or is now) contained at the top of the file in the comments.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/sun3x_esp.c | 44 +++++---------------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index d50c5ed8f428..55a02f4331e5 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -1,13 +1,14 @@
 /* sun3x_esp.c: ESP front-end for Sun3x systems.
  *
  * Copyright (C) 2007,2008 Thomas Bogendoerfer (tsbogend@alpha.franken.de)
+ *
+ * License: GPL
  */
 
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
@@ -268,33 +269,11 @@ fail:
 	return err;
 }
 
-static int esp_sun3x_remove(struct platform_device *dev)
-{
-	struct esp *esp = dev_get_drvdata(&dev->dev);
-	unsigned int irq = esp->host->irq;
-	u32 val;
-
-	scsi_esp_unregister(esp);
-
-	/* Disable interrupts.  */
-	val = dma_read32(DMA_CSR);
-	dma_write32(val & ~DMA_INT_ENAB, DMA_CSR);
-
-	free_irq(irq, esp);
-	dma_free_coherent(esp->dev, 16,
-			  esp->command_block,
-			  esp->command_block_dma);
-
-	scsi_host_put(esp->host);
-
-	return 0;
-}
-
 static struct platform_driver esp_sun3x_driver = {
 	.probe          = esp_sun3x_probe,
-	.remove         = esp_sun3x_remove,
 	.driver = {
-		.name   = "sun3x_esp",
+		.name			= "sun3x_esp",
+		.suppress_bind_attrs	= true,
 	},
 };
 
@@ -302,17 +281,4 @@ static int __init sun3x_esp_init(void)
 {
 	return platform_driver_register(&esp_sun3x_driver);
 }
-
-static void __exit sun3x_esp_exit(void)
-{
-	platform_driver_unregister(&esp_sun3x_driver);
-}
-
-MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
-MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
-module_init(sun3x_esp_init);
-module_exit(sun3x_esp_exit);
-MODULE_ALIAS("platform:sun3x_esp");
+device_initcall(sun3x_esp_init);
-- 
2.6.1
