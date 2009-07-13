From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] libata: Bind the Linux device tree to the ACPI device tree
Date: Mon, 13 Jul 2009 22:03:06 +0100
Message-ID: <1247518987-10818-2-git-send-email-mjg@redhat.com>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1247518987-10818-1-git-send-email-mjg@redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, shaohua.li@intel.com, linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We want to be able to express the dependencies between ACPI dock
devices and their children. This requires us to be able to associate
the ACPI device tree and libata devices. This patch uses the generic
ACPI glue framework to do so.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/Kconfig       |    1 +
 drivers/ata/libata-acpi.c |  118 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b17c57f..2e192bf 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -30,6 +30,7 @@ config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
 	select ACPI_DOCK
+	select SCSI_PLATFORM
 	default y
 	help
 	  This option adds support for ATA-related ACPI objects.
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ac176da..2d12a2c 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -56,6 +56,31 @@ static void ata_acpi_clear_gtf(struct ata_device *dev)
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
+	if (dev->sdev)
+		return DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
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
@@ -1026,3 +1051,96 @@ void ata_acpi_on_disable(struct ata_device *dev)
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
+	.bus = &scsi_bus_type,
+	.find_bridge = ata_acpi_find_dummy,
+	.find_device = ata_acpi_find_device,
+};
+
+int scsi_platform_register(void)
+{
+	return register_acpi_bus_type(&ata_acpi_bus);
+}
+
+void scsi_platform_unregister(void)
+{
+	unregister_acpi_bus_type(&ata_acpi_bus);
+}
-- 
1.6.2.5

