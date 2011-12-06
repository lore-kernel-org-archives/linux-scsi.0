From: Holger Macht <holger@homac.de>
Subject: [PATCH 6/7] libata: Generate and pass correct acpi handles
Date: Tue, 6 Dec 2011 17:38:04 +0100
Message-ID: <20111206163804.GG3629@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1LFQiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 11:38:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>

Fix ACPI handle generation for device handles and pass the correct
handles to the dock driver.

Signed-off-by: Holger Macht <holger@homac.de>
---
 libata-acpi.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux/drivers/ata/libata-acpi.c
===================================================================
--- linux.orig/drivers/ata/libata-acpi.c
+++ linux/drivers/ata/libata-acpi.c
@@ -74,9 +74,6 @@ acpi_handle ata_dev_acpi_handle(struct a
 	acpi_integer adr;
 	struct ata_port *ap = dev->link->ap;
 
-	if (dev->sdev)
-		return DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
-
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
 			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
@@ -1004,8 +1001,7 @@ static int ata_acpi_bind_host(struct dev
 	if (!*handle)
 		return -ENODEV;
 
-	register_hotplug_dock_device(ata_ap_acpi_handle(ap),
-				     &ata_acpi_ap_dock_ops, ap);
+	register_hotplug_dock_device(*handle, &ata_acpi_ap_dock_ops, ap);
 
 	return 0;
 }
@@ -1027,8 +1023,8 @@ static int ata_acpi_bind_device(struct d
 
 	if (!*handle)
 		return -ENODEV;
-	register_hotplug_dock_device(ata_dev_acpi_handle(ata_dev),
-				     &ata_acpi_dev_dock_ops, ata_dev);
+
+	register_hotplug_dock_device(*handle, &ata_acpi_dev_dock_ops, ata_dev);
 
 	return 0;
 }
