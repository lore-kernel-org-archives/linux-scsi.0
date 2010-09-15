From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] acpi: Add support for linking docks to the objects they contain
Date: Wed, 15 Sep 2010 15:58:02 -0400
Message-ID: <1284580683-2386-4-git-send-email-mjg@redhat.com>
References: <1284580683-2386-1-git-send-email-mjg@redhat.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1284580683-2386-1-git-send-email-mjg@redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, lenb@kernel.org, James.Bottomley@suse.de, jgarzik@pobox.com, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

When undocking, it's helpful to know which devices are going to disappear.
This patch adds support for adding symlinks to the device into the docking
bay.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/dock.c         |   82 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |   10 +++++
 2 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 3fe29e9..685aac9 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -276,6 +276,88 @@ int is_dock_device(acpi_handle handle)
 EXPORT_SYMBOL_GPL(is_dock_device);
 
 /**
+ *
+ * dock_link_device - link a device from the dock
+ * @handle: acpi handle of the potentially dependent device
+ *
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
+ *
+ * dock_unlink_device - unlink a device from the dock
+ * @handle: acpi handle of the potentially dependent device
+ *
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
index 23d78b4..59774b5 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -133,6 +133,8 @@ extern int register_hotplug_dock_device(acpi_handle handle,
 					struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
+extern struct device **dock_link_device(acpi_handle handle);
+extern struct device **dock_unlink_device(acpi_handle handle);
 #else
 static inline int is_dock_device(acpi_handle handle)
 {
@@ -154,6 +156,14 @@ static inline int register_hotplug_dock_device(acpi_handle handle,
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
1.7.1

