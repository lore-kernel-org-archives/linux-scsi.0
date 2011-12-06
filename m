From: Holger Macht <holger@homac.de>
Subject: [PATCH 5/7] libata: Add links between removable devices and docks
Date: Tue, 6 Dec 2011 17:37:57 +0100
Message-ID: <20111206163757.GF3629@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Attaching ata objects to docks makes it possible to identify which dock
should be used to trigger the removal of a device, and also allows
userspace to cleanly unmount filesystems before completing a
user-requested undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Holger Macht <holger@homac.de>
---
 libata-acpi.c |   20 ++++++++++++++++++++
 libata-scsi.c |    3 +++
 libata.h      |    4 ++++
 3 files changed, 27 insertions(+)

Index: linux/drivers/ata/libata-acpi.c
===================================================================
--- linux.orig/drivers/ata/libata-acpi.c
+++ linux/drivers/ata/libata-acpi.c
@@ -955,6 +955,26 @@ void ata_acpi_on_disable(struct ata_devi
 	ata_acpi_clear_gtf(dev);
 }
 
+void ata_acpi_bind_dock(struct ata_device *dev)
+{
+	struct device **docks;
+
+	if (!ata_dev_acpi_handle(dev))
+		return;
+	docks = dock_link_device(ata_dev_acpi_handle(dev));
+	kfree(docks);
+}
+
+void ata_acpi_unbind_dock(struct ata_device *dev)
+{
+	struct device **docks;
+
+	if (!ata_dev_acpi_handle(dev))
+		return;
+	docks = dock_unlink_device(ata_dev_acpi_handle(dev));
+	kfree(docks);
+}
+
 static int is_pci_ata(struct device *dev)
 {
 	struct pci_dev *pdev;
Index: linux/drivers/ata/libata-scsi.c
===================================================================
--- linux.orig/drivers/ata/libata-scsi.c
+++ linux/drivers/ata/libata-scsi.c
@@ -3443,6 +3443,7 @@ void ata_scsi_scan_host(struct ata_port
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
+				ata_acpi_bind_dock(dev);
 			} else {
 				dev->sdev = NULL;
 			}
@@ -3543,6 +3544,8 @@ static void ata_scsi_remove_dev(struct a
 	sdev = dev->sdev;
 	dev->sdev = NULL;
 
+	ata_acpi_unbind_dock(dev);
+
 	if (sdev) {
 		/* If user initiated unplug races with us, sdev can go
 		 * away underneath us after the host lock and
Index: linux/drivers/ata/libata.h
===================================================================
--- linux.orig/drivers/ata/libata.h
+++ linux/drivers/ata/libata.h
@@ -116,6 +116,8 @@ extern void ata_acpi_on_disable(struct a
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
+extern void ata_acpi_bind_dock(struct ata_device *dev);
+extern void ata_acpi_unbind_dock(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -126,6 +128,8 @@ static inline void ata_acpi_set_state(st
 				      pm_message_t state) { }
 static inline int ata_acpi_register(void) { return 0; }
 static void ata_acpi_unregister(void) { }
+static void ata_acpi_bind_dock(struct ata_device *dev) { }
+static void ata_acpi_unbind_dock(struct ata_device *dev) { }
 #endif
 
 /* libata-scsi.c */
