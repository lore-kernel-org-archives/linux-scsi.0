From: Brian King <brking@us.ibm.com>
Subject: [PATCH 3/4] libata: Move ata_probe_ent_alloc to libata_core
Date: Mon, 07 Aug 2006 14:27:24 -0500
Message-ID: <200608071927.k77JROkb008546@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54999 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750835AbWHGT10 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 15:27:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Move ata_probe_ent_alloc to libata-core. It will also be used by
future SAS/SATA integration patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-bmdma.c |   26 -------------------------
 libata-dev-bjking1/drivers/scsi/libata-core.c  |   25 ++++++++++++++++++++++++
 libata-dev-bjking1/drivers/scsi/libata.h       |    2 +
 3 files changed, 27 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/libata-bmdma.c~libata_move_probe_ent_alloc drivers/scsi/libata-bmdma.c
--- libata-dev/drivers/scsi/libata-bmdma.c~libata_move_probe_ent_alloc	2006-08-07 12:40:50.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-bmdma.c	2006-08-07 12:40:50.000000000 -0500
@@ -797,32 +797,6 @@ void ata_bmdma_post_internal_cmd(struct 
 }
 
 #ifdef CONFIG_PCI
-static struct ata_probe_ent *
-ata_probe_ent_alloc(struct device *dev, const struct ata_port_info *port)
-{
-	struct ata_probe_ent *probe_ent;
-
-	probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
-	if (!probe_ent) {
-		printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
-		       kobject_name(&(dev->kobj)));
-		return NULL;
-	}
-
-	INIT_LIST_HEAD(&probe_ent->node);
-	probe_ent->dev = dev;
-
-	probe_ent->sht = port->sht;
-	probe_ent->host_flags = port->host_flags;
-	probe_ent->pio_mask = port->pio_mask;
-	probe_ent->mwdma_mask = port->mwdma_mask;
-	probe_ent->udma_mask = port->udma_mask;
-	probe_ent->port_ops = port->port_ops;
-
-	return probe_ent;
-}
-
-
 /**
  *	ata_pci_init_native_mode - Initialize native-mode driver
  *	@pdev:  pci device to be initialized
diff -puN drivers/scsi/libata-core.c~libata_move_probe_ent_alloc drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_move_probe_ent_alloc	2006-08-07 12:40:50.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-08-07 12:40:50.000000000 -0500
@@ -5706,6 +5706,31 @@ int ata_scsi_release(struct Scsi_Host *h
 	return 1;
 }
 
+struct ata_probe_ent *
+ata_probe_ent_alloc(struct device *dev, const struct ata_port_info *port)
+{
+	struct ata_probe_ent *probe_ent;
+
+	probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
+	if (!probe_ent) {
+		printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
+		       kobject_name(&(dev->kobj)));
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&probe_ent->node);
+	probe_ent->dev = dev;
+
+	probe_ent->sht = port->sht;
+	probe_ent->host_flags = port->host_flags;
+	probe_ent->pio_mask = port->pio_mask;
+	probe_ent->mwdma_mask = port->mwdma_mask;
+	probe_ent->udma_mask = port->udma_mask;
+	probe_ent->port_ops = port->port_ops;
+
+	return probe_ent;
+}
+
 /**
  *	ata_std_ports - initialize ioaddr with standard port offsets.
  *	@ioaddr: IO address structure to be initialized
diff -puN drivers/scsi/libata.h~libata_move_probe_ent_alloc drivers/scsi/libata.h
--- libata-dev/drivers/scsi/libata.h~libata_move_probe_ent_alloc	2006-08-07 12:40:50.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata.h	2006-08-07 12:40:50.000000000 -0500
@@ -71,6 +71,8 @@ extern int ata_task_ioctl(struct scsi_de
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern void ata_port_init(struct ata_port *ap, struct ata_host_set *host_set,
 			  const struct ata_probe_ent *ent, unsigned int port_no);
+extern struct ata_probe_ent *ata_probe_ent_alloc(struct device *dev,
+						 const struct ata_port_info *port);
 
 
 /* libata-scsi.c */
_
