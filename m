From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/3] libata: add support for blk-iopoll
Date: Thu,  6 Aug 2009 21:58:04 +0200
Message-ID: <1249588685-4662-3-git-send-email-jens.axboe@oracle.com>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:59759 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbZHFT6G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Aug 2009 15:58:06 -0400
In-Reply-To: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, jeff@garzik.org, Jens Axboe <jens.axboe@oracle.com>

This adds basic support to libata, and specific support for ahci.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/ahci.c     |   53 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/libata.h |    2 +
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 958c1fa..9dda8ca 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -45,6 +45,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include <linux/blk-iopoll.h>
 
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
@@ -2053,7 +2054,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_port_intr(struct ata_port *ap)
+static int ahci_port_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -2083,7 +2084,7 @@ static void ahci_port_intr(struct ata_port *ap)
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
-		return;
+		return 0;
 	}
 
 	if (status & PORT_IRQ_SDB_FIS) {
@@ -2124,7 +2125,43 @@ static void ahci_port_intr(struct ata_port *ap)
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_RESET;
 		ata_port_freeze(ap);
+		rc = 0;
 	}
+
+	return rc;
+}
+
+static void ap_irq_disable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	writel(0, port_mmio + PORT_IRQ_MASK);
+}
+
+static void ap_irq_enable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+
+static int ahci_iopoll(struct blk_iopoll *iop, int budget)
+{
+	struct ata_port *ap = container_of(iop, struct ata_port, iopoll);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	ret = ahci_port_intr(ap);
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+
+	if (ret < budget) {
+		blk_iopoll_complete(iop);
+		ap_irq_enable(ap);
+	}
+
+	return ret;
 }
 
 static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
@@ -2157,7 +2194,12 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			if (!blk_iopoll_enabled)
+				ahci_port_intr(ap);
+			else if (blk_iopoll_sched_prep(&ap->iopoll)) {
+				ap_irq_disable(ap);
+				blk_iopoll_sched(&ap->iopoll);
+			}
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -2299,6 +2341,7 @@ static int ahci_port_resume(struct ata_port *ap)
 	else
 		ahci_pmp_detach(ap);
 
+	blk_iopoll_enable(&ap->iopoll);
 	return 0;
 }
 
@@ -2421,6 +2464,8 @@ static int ahci_port_start(struct ata_port *ap)
 
 	ap->private_data = pp;
 
+	blk_iopoll_init(&ap->iopoll, 32, ahci_iopoll);
+
 	/* engage engines, captain */
 	return ahci_port_resume(ap);
 }
@@ -2434,6 +2479,8 @@ static void ahci_port_stop(struct ata_port *ap)
 	rc = ahci_deinit_port(ap, &emsg);
 	if (rc)
 		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
+
+	blk_iopoll_disable(&ap->iopoll);
 }
 
 static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7cfed24..14bba58 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -37,6 +37,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
+#include <linux/blk-iopoll.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -761,6 +762,7 @@ struct ata_port {
 #endif
 	/* owned by EH */
 	u8			sector_buf[ATA_SECT_SIZE] ____cacheline_aligned;
+	struct blk_iopoll	iopoll;
 };
 
 /* The following initializer overrides a method to NULL whether one of
-- 
1.6.3.2.306.g4f4fa

