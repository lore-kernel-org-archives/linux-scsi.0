From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCHv2 5/8] libata: Add links between removable devices and docks
Date: Fri, 20 Jan 2012 01:19:02 +0100
Message-ID: <20120120001902.GF27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Attaching ata objects to docks makes it possible to identify which dock
should be used to trigger the removal of a device, and also allows
userspace to cleanly unmount filesystems before completing a
user-requested undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/ata/libata-acpi.c |   20 ++++++++++++++++++++
 drivers/ata/libata-scsi.c |    3 +++
 drivers/ata/libata.h      |    4 ++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3a7771d..3531ff7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -955,6 +955,26 @@ void ata_acpi_on_disable(struct ata_device *dev)
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
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 508a60b..f08c447 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3444,6 +3444,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
+				ata_acpi_bind_dock(dev);
 			} else {
 				dev->sdev = NULL;
 			}
@@ -3544,6 +3545,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	sdev = dev->sdev;
 	dev->sdev = NULL;
 
+	ata_acpi_unbind_dock(dev);
+
 	if (sdev) {
 		/* If user initiated unplug races with us, sdev can go
 		 * away underneath us after the host lock and
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ddf0c7b..e61ba10 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -117,6 +117,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
+extern void ata_acpi_bind_dock(struct ata_device *dev);
+extern void ata_acpi_unbind_dock(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -127,6 +129,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline int ata_acpi_register(void) { return 0; }
 static void ata_acpi_unregister(void) { }
+static void ata_acpi_bind_dock(struct ata_device *dev) { }
+static void ata_acpi_unbind_dock(struct ata_device *dev) { }
 #endif
 
 /* libata-scsi.c */
-- 
1.7.8

