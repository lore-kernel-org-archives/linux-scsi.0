From: Holger Macht <holger@homac.de>
Subject: [PATCH 4/7] acpi: Add support for linking docks to the objects they
 contain
Date: Tue, 6 Dec 2011 17:37:51 +0100
Message-ID: <20111206163751.GE3629@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1LFQhy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 11:37:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>

From: Matthew Garrett <mjg@redhat.com>

When undocking, it's helpful to know which devices are going to
disappear. This patch adds support for adding symlinks to the device
into the docking bay.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Holger Macht <holger@homac.de>
---
 drivers/acpi/dock.c         |   78 ++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |   10 +++++
 2 files changed, 88 insertions(+)

Index: linux/drivers/acpi/dock.c
===================================================================
--- linux.orig/drivers/acpi/dock.c
+++ linux/drivers/acpi/dock.c
@@ -276,6 +276,84 @@ int is_dock_device(acpi_handle handle)
 EXPORT_SYMBOL_GPL(is_dock_device);
 
 /**
+ * dock_link_device - link a device from the dock
+ * @handle: acpi handle of the potentially dependent device
+ */
+struct device **dock_link_device(acpi_handle handle)
+{
+	struct device *dev = acpi_get_physical_device(handle);
+	struct dock_station *dock_station;
+	int ret, dock = 0;
+	struct device **devices;
+
+	devices = kmalloc(dock_station_count * sizeof(struct device *),
+			  GFP_KERNEL);
+
+	if (!dev)
+		return NULL;
+
+	if (is_dock(handle)) {
+		put_device(dev);
+		return NULL;
+	}
+
+	list_for_each_entry(dock_station, &dock_stations, sibling) {
+		if (find_dock_dependent_device(dock_station, handle)) {
+			ret = sysfs_create_link(&dock_station->dock_device->dev.kobj,
+						&dev->kobj, dev_name(dev));
+			WARN_ON(ret);
+			devices[dock] = &dock_station->dock_device->dev;
+			dock++;
+		}
+	}
+	if (!dock)
+		put_device(dev);
+
+	devices[dock] = NULL;
+	return devices;
+}
+EXPORT_SYMBOL_GPL(dock_link_device);
+
+/**
+ * dock_unlink_device - unlink a device from the dock
+ * @handle: acpi handle of the potentially dependent device
+ */
+struct device **dock_unlink_device(acpi_handle handle)
+{
+	struct device *dev = acpi_get_physical_device(handle);
+	struct dock_station *dock_station;
+	int dock = 0;
+	struct device **devices =
+		kmalloc(dock_station_count * sizeof(struct device *),
+			GFP_KERNEL);
+
+	if (!dev)
+		return NULL;
+
+	if (is_dock(handle)) {
+		put_device(dev);
+		return NULL;
+	}
+
+	list_for_each_entry(dock_station, &dock_stations, sibling) {
+		if (find_dock_dependent_device(dock_station, handle)) {
+			sysfs_remove_link(&dock_station->dock_device->dev.kobj,
+					  dev_name(dev));
+			devices[dock] = &dock_station->dock_device->dev;
+			dock++;
+		}
+	}
+	/* An extra reference has been held while the link existed */
+	if (dock)
+		put_device(dev);
+
+	put_device(dev);
+	devices[dock] = NULL;
+	return devices;
+}
+EXPORT_SYMBOL_GPL(dock_unlink_device);
+
+/**
  * dock_present - see if the dock station is present.
  * @ds: the dock station
  *
Index: linux/include/acpi/acpi_drivers.h
===================================================================
--- linux.orig/include/acpi/acpi_drivers.h
+++ linux/include/acpi/acpi_drivers.h
@@ -131,6 +131,8 @@ extern int register_hotplug_dock_device(
 					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
+extern struct device **dock_link_device(acpi_handle handle);
+extern struct device **dock_unlink_device(acpi_handle handle);
 #else
 static inline int is_dock_device(acpi_handle handle)
 {
@@ -152,6 +154,14 @@ static inline int register_hotplug_dock_
 static inline void unregister_hotplug_dock_device(acpi_handle handle)
 {
 }
+static inline struct device **dock_link_device(acpi_handle handle)
+{
+	return NULL;
+}
+static inline struct device **dock_unlink_device(acpi_handle handle)
+{
+	return NULL;
+}
 #endif
 
 #endif /*__ACPI_DRIVERS_H__*/
