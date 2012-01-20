From: Holger Macht <holger@homac.de>
Subject: [PATCHv2 7/8] acpi: Prevent duplicate hotplug device registration on
 dock stations
Date: Fri, 20 Jan 2012 01:19:17 +0100
Message-ID: <20120120001917.GH27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

register_hotplug_dock_device() must only be called once per ACPI
handle. However, ACPI glue infrastructure does not allow to prevent
multiple find_device() invocations when a scsi bus or device appears or
disappears. So export a function from the dock driver to check if a
specific hotplug dock device is already registered and call this before
registering.

Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/acpi/dock.c         |   20 ++++++++++++++++++++
 drivers/ata/libata-acpi.c   |    6 ++++--
 include/acpi/acpi_drivers.h |    1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 98cecaf..b5e4142 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -720,6 +720,26 @@ void unregister_hotplug_dock_device(acpi_handle handle)
 }
 EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
 
+int is_registered_hotplug_dock_device(const struct acpi_dock_ops *ops)
+{
+	struct dock_dependent_device *dd;
+	struct dock_station *ds;
+
+	list_for_each_entry(ds, &dock_stations, sibling) {
+		mutex_lock(&ds->hp_lock);
+		list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list) {
+			if (ops == dd->ops) {
+				mutex_unlock(&ds->hp_lock);
+				return 1;
+			}
+		}
+		mutex_unlock(&ds->hp_lock);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(is_registered_hotplug_dock_device);
+
 /**
  * handle_eject_request - handle an undock request checking for error conditions
  *
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3595ef4..a39f9b3 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1001,7 +1001,8 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
-	register_hotplug_dock_device(*handle, &ata_acpi_ap_dock_ops, ap);
+	if (!is_registered_hotplug_dock_device(&ata_acpi_ap_dock_ops))
+		register_hotplug_dock_device(*handle, &ata_acpi_ap_dock_ops, ap);
 
 	return 0;
 }
@@ -1024,7 +1025,8 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	if (!*handle)
 		return -ENODEV;
 
-	register_hotplug_dock_device(*handle, &ata_acpi_dev_dock_ops, ata_dev);
+	if (!is_registered_hotplug_dock_device(&ata_acpi_dev_dock_ops))
+		register_hotplug_dock_device(*handle, &ata_acpi_dev_dock_ops, ata_dev);
 
 	return 0;
 }
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 43f7817..3c4e381 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -131,6 +131,7 @@ extern int register_hotplug_dock_device(acpi_handle handle,
 					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
+extern int is_registered_hotplug_dock_device(const struct acpi_dock_ops *ops);
 extern struct device **dock_link_device(acpi_handle handle);
 extern struct device **dock_unlink_device(acpi_handle handle);
 #else
-- 
1.7.8

