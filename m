From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI device tree
Date: Mon, 28 May 2012 13:08:29 +0800
Message-ID: <1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Associate the ACPI device tree and libata devices.
This patch uses the generic ACPI glue framework to do so.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Holger Macht <holger@homac.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/glue.c       |    2 +
 drivers/ata/libata-acpi.c |  114 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |    3 +
 drivers/ata/libata.h      |    4 ++
 4 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 29a4a5c..18d6812 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -39,6 +39,7 @@ int register_acpi_bus_type(struct acpi_bus_type *type)
 	}
 	return -ENODEV;
 }
+EXPORT_SYMBOL(register_acpi_bus_type);
 
 int unregister_acpi_bus_type(struct acpi_bus_type *type)
 {
@@ -54,6 +55,7 @@ int unregister_acpi_bus_type(struct acpi_bus_type *type)
 	}
 	return -ENODEV;
 }
+EXPORT_SYMBOL(unregister_acpi_bus_type);
 
 static struct acpi_bus_type *acpi_get_bus_type(struct bus_type *type)
 {
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index bb7c5f1..96a5775 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -47,6 +47,28 @@ static void ata_acpi_clear_gtf(struct ata_device *dev)
 	dev->gtf_cache = NULL;
 }
 
+static acpi_handle ap_acpi_handle(struct ata_port *ap)
+{
+	if (ap->flags & ATA_FLAG_ACPI_SATA)
+		return NULL;
+	return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
+}
+
+static acpi_handle dev_acpi_handle(struct ata_device *dev)
+{
+	acpi_integer adr;
+	struct ata_port *ap = dev->link->ap;
+
+	if (ap->flags & ATA_FLAG_ACPI_SATA) {
+		if (!sata_pmp_attached(ap))
+			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
+		else
+			adr = SATA_ADR(ap->port_no, dev->link->pmp);
+		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), adr);
+	} else
+		return acpi_get_child(ap_acpi_handle(ap), dev->devno);
+}
+
 /**
  * ata_acpi_associate_sata_port - associate SATA port with ACPI objects
  * @ap: target SATA port
@@ -1018,3 +1040,95 @@ void ata_acpi_on_disable(struct ata_device *dev)
 {
 	ata_acpi_clear_gtf(dev);
 }
+
+static int is_pci_ata(struct device *dev)
+{
+	struct pci_dev *pdev;
+
+	if (!is_pci_dev(dev))
+		return 0;
+
+	pdev = to_pci_dev(dev);
+
+	if ((pdev->class >> 8) != PCI_CLASS_STORAGE_SATA &&
+	    (pdev->class >> 8) != PCI_CLASS_STORAGE_IDE)
+		return 0;
+
+	return 1;
+}
+
+static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+
+	if (ap->flags & ATA_FLAG_ACPI_SATA)
+		return -ENODEV;
+
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), ap->port_no);
+
+	if (!*handle)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int ata_acpi_bind_device(struct device *dev, int channel, int id,
+				acpi_handle *handle)
+{
+	struct device *host = dev->parent->parent;
+	struct Scsi_Host *shost = dev_to_shost(host);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ata_device *ata_dev;
+
+	if (ap->flags & ATA_FLAG_ACPI_SATA)
+		ata_dev = &ap->link.device[channel];
+	else
+		ata_dev = &ap->link.device[id];
+
+	*handle = dev_acpi_handle(ata_dev);
+
+	if (!*handle)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
+{
+	unsigned int host, channel, id, lun;
+
+	if (sscanf(dev_name(dev), "host%u", &host) == 1) {
+		if (!is_pci_ata(dev->parent))
+			return -ENODEV;
+
+		return ata_acpi_bind_host(dev, host, handle);
+	} else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
+			&host, &channel, &id, &lun) == 4) {
+		if (!is_pci_ata(dev->parent->parent->parent))
+			return -ENODEV;
+
+		return ata_acpi_bind_device(dev, channel, id, handle);
+	} else
+		return -ENODEV;
+}
+
+static int ata_acpi_find_dummy(struct device *dev, acpi_handle *handle)
+{
+	return -ENODEV;
+}
+
+static struct acpi_bus_type ata_acpi_bus = {
+	.find_bridge = ata_acpi_find_dummy,
+	.find_device = ata_acpi_find_device,
+};
+
+int ata_acpi_register(void)
+{
+	return scsi_register_acpi_bus_type(&ata_acpi_bus);
+}
+
+void ata_acpi_unregister(void)
+{
+	scsi_unregister_acpi_bus_type(&ata_acpi_bus);
+}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 23763a1..8908f9f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6506,6 +6506,8 @@ static int __init ata_init(void)
 
 	ata_parse_force_param();
 
+	ata_acpi_register();
+
 	rc = ata_sff_init();
 	if (rc) {
 		kfree(ata_force_tbl);
@@ -6532,6 +6534,7 @@ static void __exit ata_exit(void)
 	ata_release_transport(ata_scsi_transport_template);
 	libata_transport_exit();
 	ata_sff_exit();
+	ata_acpi_unregister();
 	kfree(ata_force_tbl);
 }
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 9d0fd0b..3df3362 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -119,6 +119,8 @@ extern void ata_acpi_on_resume(struct ata_port *ap);
 extern int ata_acpi_on_devcfg(struct ata_device *dev);
 extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
+extern int ata_acpi_register(void);
+extern void ata_acpi_unregister(void);
 #else
 static inline void ata_acpi_associate_sata_port(struct ata_port *ap) { }
 static inline void ata_acpi_associate(struct ata_host *host) { }
@@ -129,6 +131,8 @@ static inline int ata_acpi_on_devcfg(struct ata_device *dev) { return 0; }
 static inline void ata_acpi_on_disable(struct ata_device *dev) { }
 static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
+static inline int ata_acpi_register(void) { return 0; }
+static void ata_acpi_unregister(void) { }
 #endif
 
 /* libata-scsi.c */
-- 
1.7.2.5

