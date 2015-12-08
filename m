From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 1/2] drivers/base: add bus_device_iter_init, bus_device_iter_next, bus_device_iter_exit
Date: Tue,  8 Dec 2015 09:08:23 -0500
Message-ID: <1449583704-32400-2-git-send-email-emilne@redhat.com>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbbLHOI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 09:08:26 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 1DFF914CAD8
	for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2015 14:08:26 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id tB8E8OxR005638
	for <linux-scsi@vger.kernel.org>; Tue, 8 Dec 2015 09:08:25 -0500
In-Reply-To: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

These functions are needed to expose an iterator for SCSI usage.

>From a patch originally developed by David Jeffery <djeffery@redhat.com>

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/base/bus.c     | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  5 +++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 5005924..a472e46 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -318,6 +318,65 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 EXPORT_SYMBOL_GPL(bus_for_each_dev);
 
 /**
+ * bus_device_iter_init - Initialize an iterator for walking a bus's devices.
+ * @iter: iterator structure to initialize
+ * @bus: bus type
+ *
+ * Initializes an iterator for safely walking a bus's list of devices.  The
+ * iterator can be used by bus_device_iter_next() to safely walk the list, even
+ * if a device is removed from the list while being examined.  Needs to be
+ * matched with a call to bus_device_iter_exit() to clean up the iterator when
+ * finished.
+ *
+ * Return 0 on success, non-zero on failure.  Iterator cannot be used
+ * for a non-zero result
+ */
+int bus_device_iter_init(struct klist_iter *iter,
+			 struct bus_type *bus)
+{
+	if (!bus || !bus->p)
+		return -EINVAL;
+
+	klist_iter_init_node(&bus->p->klist_devices, iter, NULL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bus_device_iter_init);
+
+/**
+ * bus_device_iter_next - Get a bus's next device from the iterator.
+ * @iter: iterator structure from bus_device_iter_init()
+ *
+ * Finds the next valid device entry on a bus's device list.  Allows the list
+ * to be safely traversed by the caller even when other tasks remove devices
+ * from the list.
+ *
+ * Returns a reference to the next device, or NULL if no more devices.
+ */
+struct device *bus_device_iter_next(struct klist_iter *iter)
+{
+	struct device *dev;
+
+	while ((dev = next_device(iter)))
+		if (get_device(dev))
+			break;
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(bus_device_iter_next);
+
+/**
+ * bus_device_iter_exit - Clean up an iterator from walking a bus's device list.
+ * @iter: iterator structure from bus_device_iter_init() to clean up
+ *
+ * Clean up any remaining state after finishing walking a bus's device list.
+ */
+void bus_device_iter_exit(struct klist_iter *iter)
+{
+	klist_iter_exit(iter);
+}
+EXPORT_SYMBOL_GPL(bus_device_iter_exit);
+
+/**
  * bus_find_device - device iterator for locating a particular device.
  * @bus: bus type
  * @start: Device to begin with
diff --git a/include/linux/device.h b/include/linux/device.h
index b8f411b..a44d912 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -151,6 +151,11 @@ void subsys_dev_iter_exit(struct subsys_dev_iter *iter);
 
 int bus_for_each_dev(struct bus_type *bus, struct device *start, void *data,
 		     int (*fn)(struct device *dev, void *data));
+
+int bus_device_iter_init(struct klist_iter *iter, struct bus_type *bus);
+struct device *bus_device_iter_next(struct klist_iter *iter);
+void bus_device_iter_exit(struct klist_iter *iter);
+
 struct device *bus_find_device(struct bus_type *bus, struct device *start,
 			       void *data,
 			       int (*match)(struct device *dev, void *data));
-- 
2.1.0

