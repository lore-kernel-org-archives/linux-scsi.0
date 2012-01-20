From: Holger Macht <holger@homac.de>
Subject: [PATCHv2 6/8] libata: Generate and pass correct acpi handles
Date: Fri, 20 Jan 2012 01:19:08 +0100
Message-ID: <20120120001907.GG27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Fix ACPI handle generation for device handles and pass the correct
handles to the dock driver.

Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/ata/libata-acpi.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3531ff7..3595ef4 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -74,9 +74,6 @@ acpi_handle ata_dev_acpi_handle(struct ata_device *dev)
 	acpi_integer adr;
 	struct ata_port *ap = dev->link->ap;
 
-	if (dev->sdev)
-		return DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
-
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
 			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
@@ -1004,8 +1001,7 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
-	register_hotplug_dock_device(ata_ap_acpi_handle(ap),
-				     &ata_acpi_ap_dock_ops, ap);
+	register_hotplug_dock_device(*handle, &ata_acpi_ap_dock_ops, ap);
 
 	return 0;
 }
@@ -1027,8 +1023,8 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 
 	if (!*handle)
 		return -ENODEV;
-	register_hotplug_dock_device(ata_dev_acpi_handle(ata_dev),
-				     &ata_acpi_dev_dock_ops, ata_dev);
+
+	register_hotplug_dock_device(*handle, &ata_acpi_dev_dock_ops, ata_dev);
 
 	return 0;
 }
-- 
1.7.8

