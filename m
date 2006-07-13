From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/2] libata: Add ata_host_set_init
Date: Thu, 13 Jul 2006 08:35:41 -0500
Message-ID: <200607131335.k6DDZgVi005014@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45711 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751485AbWGMNfo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 09:35:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Add ata_host_set_init in preparation for SAS attached SATA.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   28 ++++++++++++++++++++++++----
 include/linux/libata.h     |    2 ++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff -puN include/linux/libata.h~libata_host_set_init include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_host_set_init	2006-07-09 13:07:19.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-07-09 13:07:19.000000000 -0500
@@ -682,6 +682,8 @@ extern int ata_pci_clear_simplex(struct 
 #endif /* CONFIG_PCI */
 extern int ata_device_add(const struct ata_probe_ent *ent);
 extern void ata_port_detach(struct ata_port *ap);
+extern void ata_host_set_init(struct ata_host_set *, struct device *,
+			      unsigned long, const struct ata_port_operations *);
 extern void ata_host_set_remove(struct ata_host_set *host_set);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
diff -puN drivers/scsi/libata-core.c~libata_host_set_init drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_host_set_init	2006-07-09 13:07:19.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-07-09 13:07:19.000000000 -0500
@@ -5373,6 +5373,28 @@ err_out:
 }
 
 /**
+ *	ata_sas_host_init - Initialize a host_set struct
+ *	@host_set:	host_set to initialize
+ *	@dev:		device host_set is attached to
+ *	@flags:	host_set flags
+ *	@ops:		port_ops
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ */
+
+void ata_host_set_init(struct ata_host_set *host_set,
+		       struct device *dev, unsigned long flags,
+		       const struct ata_port_operations *ops)
+{
+	spin_lock_init(&host_set->lock);
+	host_set->dev = dev;
+	host_set->flags = flags;
+	host_set->ops = ops;
+}
+
+/**
  *	ata_device_add - Register hardware device with ATA and SCSI layers
  *	@ent: Probe information describing hardware device to be registered
  *
@@ -5403,15 +5425,12 @@ int ata_device_add(const struct ata_prob
 			   (ent->n_ports * sizeof(void *)), GFP_KERNEL);
 	if (!host_set)
 		return 0;
-	spin_lock_init(&host_set->lock);
 
-	host_set->dev = dev;
+	ata_host_set_init(host_set, dev, ent->host_set_flags, ent->port_ops);
 	host_set->n_ports = ent->n_ports;
 	host_set->irq = ent->irq;
 	host_set->mmio_base = ent->mmio_base;
 	host_set->private_data = ent->private_data;
-	host_set->ops = ent->port_ops;
-	host_set->flags = ent->host_set_flags;
 
 	/* register each port bound to this device */
 	for (i = 0; i < ent->n_ports; i++) {
@@ -5926,6 +5945,7 @@ EXPORT_SYMBOL_GPL(sata_deb_timing_hotplu
 EXPORT_SYMBOL_GPL(sata_deb_timing_long);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_std_ports);
+EXPORT_SYMBOL_GPL(ata_host_set_init);
 EXPORT_SYMBOL_GPL(ata_device_add);
 EXPORT_SYMBOL_GPL(ata_port_detach);
 EXPORT_SYMBOL_GPL(ata_host_set_remove);
_
