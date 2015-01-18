From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 11/11] ata: pata_of_platform: adjust module reference for scsi host
Date: Mon, 19 Jan 2015 00:06:09 +0900
Message-ID: <1421593569-5089-12-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The pata_of_platform driver depends on pata_platform module.  The
module reference of this scsi host is initialized to pata_platform's
one.  Because this drivers use __pata_platform_probe() which is
defined in pata_platform module and calls scsi_host_alloc() internally.
So these drivers can be unloaded even if the scsi device is being
accessed.

This fixes it by converting into __pata_platform_probe() macro so that
these drivers can pass their correct module reference through
__ata_host_alloc().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/ata/pata_platform.c  | 18 ++++++++++--------
 include/linux/ata_platform.h | 16 ++++++++++------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 1eedfe4..c84e834 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -71,13 +71,14 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
 }
 
 /**
- *	__pata_platform_probe		-	attach a platform interface
+ *	___pata_platform_probe		-	attach a platform interface
  *	@dev: device
  *	@io_res: Resource representing I/O base
  *	@ctl_res: Resource representing CTL base
  *	@irq_res: Resource representing IRQ and its flags
  *	@ioport_shift: I/O port shift
  *	@__pio_mask: PIO mask
+ *	@owner: module which will be the owner of the ATA host
  *
  *	Register a platform bus IDE interface. Such interfaces are PIO and we
  *	assume do not support IRQ sharing.
@@ -97,9 +98,10 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
  *
  *	If no IRQ resource is present, PIO polling mode is used instead.
  */
-int __pata_platform_probe(struct device *dev, struct resource *io_res,
-			  struct resource *ctl_res, struct resource *irq_res,
-			  unsigned int ioport_shift, int __pio_mask)
+int ___pata_platform_probe(struct device *dev, struct resource *io_res,
+			   struct resource *ctl_res, struct resource *irq_res,
+			   unsigned int ioport_shift, int __pio_mask,
+			   struct module *owner)
 {
 	struct ata_host *host;
 	struct ata_port *ap;
@@ -124,7 +126,7 @@ int __pata_platform_probe(struct device *dev, struct resource *io_res,
 	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
-	host = ata_host_alloc(dev, 1);
+	host = __ata_host_alloc(dev, 1, owner);
 	if (!host)
 		return -ENOMEM;
 	ap = host->ports[0];
@@ -172,7 +174,7 @@ int __pata_platform_probe(struct device *dev, struct resource *io_res,
 	return ata_host_activate(host, irq, irq ? ata_sff_interrupt : NULL,
 				 irq_flags, &pata_platform_sht);
 }
-EXPORT_SYMBOL_GPL(__pata_platform_probe);
+EXPORT_SYMBOL_GPL(___pata_platform_probe);
 
 static int pata_platform_probe(struct platform_device *pdev)
 {
@@ -215,8 +217,8 @@ static int pata_platform_probe(struct platform_device *pdev)
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 
 	return __pata_platform_probe(&pdev->dev, io_res, ctl_res, irq_res,
-				     pp_info ? pp_info->ioport_shift : 0,
-				     pio_mask);
+				   pp_info ? pp_info->ioport_shift : 0,
+				   pio_mask);
 }
 
 static struct platform_driver pata_platform_driver = {
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
index 5c618a0..20bca38 100644
--- a/include/linux/ata_platform.h
+++ b/include/linux/ata_platform.h
@@ -10,12 +10,16 @@ struct pata_platform_info {
 	unsigned int ioport_shift;
 };
 
-extern int __pata_platform_probe(struct device *dev,
-				 struct resource *io_res,
-				 struct resource *ctl_res,
-				 struct resource *irq_res,
-				 unsigned int ioport_shift,
-				 int __pio_mask);
+extern int ___pata_platform_probe(struct device *dev,
+				  struct resource *io_res,
+				  struct resource *ctl_res,
+				  struct resource *irq_res,
+				  unsigned int ioport_shift,
+				  int __pio_mask, struct module *owner);
+#define __pata_platform_probe(dev, io_res, ctl_res, irq_res,		\
+			      ioport_shift, __pio_mask)			\
+	___pata_platform_probe(dev, io_res, ctl_res, irq_res,		\
+			       ioport_shift, __pio_mask, THIS_MODULE)
 
 /*
  * Marvell SATA private data
-- 
1.9.1

