From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/4] libata: Add ata_host_set_init
Date: Wed, 28 Jun 2006 08:30:38 -0500
Message-ID: <200606281330.k5SDUdAE031840@d03av02.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Add ata_host_set_init in preparation for SAS attached SATA.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   28 ++++++++++++++++++++++----
 libata-dev-bjking1/include/linux/libata.h     |    2 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff -puN include/linux/libata.h~libata_host_set_init include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_host_set_init	2006-06-27 16:02:05.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-06-27 16:02:05.000000000 -0500
@@ -650,6 +650,8 @@ extern int ata_pci_clear_simplex(struct 
 #endif /* CONFIG_PCI */
 extern int ata_device_add(const struct ata_probe_ent *ent);
 extern void ata_port_detach(struct ata_port *ap);
+extern void ata_host_set_init(struct ata_host_set *, struct device *,
+			      unsigned long, const struct ata_port_operations *);
 extern void ata_host_set_remove(struct ata_host_set *host_set);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
diff -puN drivers/scsi/libata-core.c~libata_host_set_init drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_host_set_init	2006-06-27 16:02:05.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-27 16:02:05.000000000 -0500
@@ -5341,6 +5341,28 @@ err_out:
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
@@ -5371,15 +5393,12 @@ int ata_device_add(const struct ata_prob
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
@@ -5857,6 +5876,7 @@ EXPORT_SYMBOL_GPL(sata_deb_timing_eh);
 EXPORT_SYMBOL_GPL(sata_deb_timing_before_fsrst);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_std_ports);
+EXPORT_SYMBOL_GPL(ata_host_set_init);
 EXPORT_SYMBOL_GPL(ata_device_add);
 EXPORT_SYMBOL_GPL(ata_port_detach);
 EXPORT_SYMBOL_GPL(ata_host_set_remove);
_
