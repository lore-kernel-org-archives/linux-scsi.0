From: Holger Macht <holger@homac.de>
Subject: [PATCHv2 8/8] libata: Use correct PCI devices
Date: Fri, 20 Jan 2012 01:19:24 +0100
Message-ID: <20120120001924.GI27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a made ata ports parent
devices of scsi hosts, so we need to go yet another level up to be able
to use the correct PCI devices.

Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/ata/libata-acpi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index a39f9b3..b03e468 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -996,7 +996,7 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return -ENODEV;
 
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), ap->port_no);
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent->parent), ap->port_no);
 
 	if (!*handle)
 		return -ENODEV;
@@ -1036,13 +1036,13 @@ static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
 	unsigned int host, channel, id, lun;
 
 	if (sscanf(dev_name(dev), "host%u", &host) == 1) {
-		if (!is_pci_ata(dev->parent))
+		if (!is_pci_ata(dev->parent->parent))
 			return -ENODEV;
 
 		return ata_acpi_bind_host(dev, host, handle);
 	} else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
 			&host, &channel, &id, &lun) == 4) {
-		if (!is_pci_ata(dev->parent->parent->parent))
+		if (!is_pci_ata(dev->parent->parent->parent->parent))
 			return -ENODEV;
 
 		return ata_acpi_bind_device(dev, channel, id, handle);
-- 
1.7.8

