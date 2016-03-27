From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] drivers/scsi: make jazz_esp.c driver explicitly non-modular
Date: Sun, 27 Mar 2016 13:00:24 -0400
Message-ID: <1459098025-26269-2-git-send-email-paul.gortmaker@windriver.com>
References: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
List-Id: linux-scsi@vger.kernel.org

The Kconfig for this driver is currently:

config JAZZ_ESP
        bool "MIPS JAZZ FAS216 SCSI support

=2E..meaning that it currently is not being built as a module by anyone=
,
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
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org
Cc: linux-mips@linux-mips.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/jazz_esp.c | 43 ++++++-----------------------------------=
--
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 9aaa74e349cc..4260a0f7e154 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -1,12 +1,13 @@
 /* jazz_esp.c: ESP front-end for MIPS JAZZ systems.
  *
- * Copyright (C) 2007 Thomas Bogend=C3=B6rfer (tsbogend@alpha.frankend=
e)
+ * Copyright (C) 2007 Thomas Bogend=C3=B6rfer (tsbogend@alpha.franken.=
de)
+ *
+ * License: GPL
  */
=20
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -201,31 +202,11 @@ fail:
 	return err;
 }
=20
-static int esp_jazz_remove(struct platform_device *dev)
-{
-	struct esp *esp =3D dev_get_drvdata(&dev->dev);
-	unsigned int irq =3D esp->host->irq;
-
-	scsi_esp_unregister(esp);
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
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:jazz_esp");
-
 static struct platform_driver esp_jazz_driver =3D {
 	.probe		=3D esp_jazz_probe,
-	.remove		=3D esp_jazz_remove,
 	.driver	=3D {
-		.name	=3D "jazz_esp",
+		.name			=3D "jazz_esp",
+		.suppress_bind_attrs	=3D true,
 	},
 };
=20
@@ -233,16 +214,4 @@ static int __init jazz_esp_init(void)
 {
 	return platform_driver_register(&esp_jazz_driver);
 }
-
-static void __exit jazz_esp_exit(void)
-{
-	platform_driver_unregister(&esp_jazz_driver);
-}
-
-MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
-MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
-module_init(jazz_esp_init);
-module_exit(jazz_esp_exit);
+device_initcall(jazz_esp_init);
--=20
2.6.1
