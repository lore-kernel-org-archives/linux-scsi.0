From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCHv2 4/8] acpi: Add support for linking docks to the objects
 they contain
Date: Fri, 20 Jan 2012 01:18:55 +0100
Message-ID: <20120120001854.GE27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

When undocking, it's helpful to know which devices are going to
disappear. This patch adds support for adding symlinks to the device
into the docking bay.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/acpi/dock.c         |   78 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |   10 +++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 88eb143..98cecaf 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
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
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index bb145e4..43f7817 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -131,6 +131,8 @@ extern int register_hotplug_dock_device(acpi_handle handle,
 					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
+extern struct device **dock_link_device(acpi_handle handle);
+extern struct device **dock_unlink_device(acpi_handle handle);
 #else
 static inline int is_dock_device(acpi_handle handle)
 {
@@ -152,6 +154,14 @@ static inline int register_hotplug_dock_device(acpi_handle handle,
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
-- 
1.7.8

