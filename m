From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/2] ata: pata_platform: fix owner module reference mismatch for scsi host
Date: Tue, 27 Jan 2015 08:34:59 +0900
Message-ID: <1422315299-4614-2-git-send-email-akinobu.mita@gmail.com>
References: <1422315299-4614-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1422315299-4614-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The owner module reference of the pata_of_platform's scsi_host is
initialized to pata_platform's one, because pata_of_platform driver
use a scsi_host_template defined in pata_platform.  So this drivers
can be unloaded even if the scsi device is being accessed.

This fixes it by propagating the scsi_host_template to pata_of_platform
driver.  The scsi_host_template is passed through a new
argument of __pata_platform_probe().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/ata/pata_of_platform.c | 6 +++++-
 drivers/ata/pata_platform.c    | 8 +++++---
 include/linux/ata_platform.h   | 5 ++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index dcc408a..ec904ae 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -16,6 +16,10 @@
 #include <linux/ata_platform.h>
 #include <linux/libata.h>
 
+static struct scsi_host_template pata_platform_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
 static int pata_of_platform_probe(struct platform_device *ofdev)
 {
 	int ret;
@@ -63,7 +67,7 @@ static int pata_of_platform_probe(struct platform_device *ofdev)
 	pio_mask |= (1 << pio_mode) - 1;
 
 	return __pata_platform_probe(&ofdev->dev, &io_res, &ctl_res, irq_res,
-				     reg_shift, pio_mask);
+				     reg_shift, pio_mask, &pata_platform_sht);
 }
 
 static struct of_device_id pata_of_platform_match[] = {
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 1eedfe4..c503ded 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -78,6 +78,7 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
  *	@irq_res: Resource representing IRQ and its flags
  *	@ioport_shift: I/O port shift
  *	@__pio_mask: PIO mask
+ *	@sht: scsi_host_template to use when registering
  *
  *	Register a platform bus IDE interface. Such interfaces are PIO and we
  *	assume do not support IRQ sharing.
@@ -99,7 +100,8 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
  */
 int __pata_platform_probe(struct device *dev, struct resource *io_res,
 			  struct resource *ctl_res, struct resource *irq_res,
-			  unsigned int ioport_shift, int __pio_mask)
+			  unsigned int ioport_shift, int __pio_mask,
+			  struct scsi_host_template *sht)
 {
 	struct ata_host *host;
 	struct ata_port *ap;
@@ -170,7 +172,7 @@ int __pata_platform_probe(struct device *dev, struct resource *io_res,
 
 	/* activate */
 	return ata_host_activate(host, irq, irq ? ata_sff_interrupt : NULL,
-				 irq_flags, &pata_platform_sht);
+				 irq_flags, sht);
 }
 EXPORT_SYMBOL_GPL(__pata_platform_probe);
 
@@ -216,7 +218,7 @@ static int pata_platform_probe(struct platform_device *pdev)
 
 	return __pata_platform_probe(&pdev->dev, io_res, ctl_res, irq_res,
 				     pp_info ? pp_info->ioport_shift : 0,
-				     pio_mask);
+				     pio_mask, &pata_platform_sht);
 }
 
 static struct platform_driver pata_platform_driver = {
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
index 5c618a0..619d9e7 100644
--- a/include/linux/ata_platform.h
+++ b/include/linux/ata_platform.h
@@ -10,12 +10,15 @@ struct pata_platform_info {
 	unsigned int ioport_shift;
 };
 
+struct scsi_host_template;
+
 extern int __pata_platform_probe(struct device *dev,
 				 struct resource *io_res,
 				 struct resource *ctl_res,
 				 struct resource *irq_res,
 				 unsigned int ioport_shift,
-				 int __pio_mask);
+				 int __pio_mask,
+				 struct scsi_host_template *sht);
 
 /*
  * Marvell SATA private data
-- 
1.9.1

