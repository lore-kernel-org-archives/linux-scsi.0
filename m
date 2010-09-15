From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/5] libata: Add links between removable devices and docks
Date: Wed, 15 Sep 2010 15:58:03 -0400
Message-ID: <1284580683-2386-5-git-send-email-mjg@redhat.com>
References: <1284580683-2386-1-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab0IOUE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 16:04:29 -0400
In-Reply-To: <1284580683-2386-1-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, lenb@kernel.org, James.Bottomley@suse.de, jgarzik@pobox.com, Matthew Garrett <mjg@redhat.com>

Attaching ata objects to docks makes it possible to identify which dock
should be used to trigger the removal of a device, and also allows
userspace to cleanly unmount filesystems before completing a
user-requested undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/libata-acpi.c |   20 ++++++++++++++++++++
 drivers/ata/libata-scsi.c |    3 +++
 drivers/ata/libata.h      |    4 ++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ec5ebef..99d108d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -966,6 +966,26 @@ void ata_acpi_on_disable(struct ata_device *dev)
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
index a89172c..120e8a6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3393,6 +3393,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
+				ata_acpi_bind_dock(dev);
 			}
 		}
 	}
@@ -3513,6 +3514,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	spin_unlock_irqrestore(ap->lock, flags);
 	mutex_unlock(&ap->scsi_host->scan_mutex);
 
+	ata_acpi_unbind_dock(dev);
+
 	if (sdev) {
 		ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
 			       dev_name(&sdev->sdev_gendev));
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 8d7bd00..73b65ee 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -114,6 +114,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
+extern void ata_acpi_bind_dock(struct ata_device *dev);
+extern void ata_acpi_unbind_dock(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -124,6 +126,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline int ata_acpi_register(void) { return 0; }
 static void ata_acpi_unregister(void) { }
+static void ata_acpi_bind_dock(struct ata_device *dev) { }
+static void ata_acpi_unbind_dock(struct ata_device *dev) { }
 #endif
 
 /* libata-scsi.c */
-- 
1.7.1

