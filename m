From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/8] scsi_dh: Add 'dh_state' sysfs attribute
Date: Thu, 17 Jul 2008 09:38:12 +0200
Message-ID: <20080717073812.CF59C18C6FD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYGQHiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 03:38:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


Implement a 'dh_state' sdev attribute for dynamic device handler
manipulation. A read on the attribute will return the name of
the currently attached device handler or 'detached' if no handler
is attached.
The attribute allows the following strings to be written:
- The name of the device handler to be attached if the state is
  'detached'.
- 'activate' to trigger path activation if a device handler
  is attached.
- 'detach' to detach the currently attached device handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |  103 ++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 3f79817..e90df9d 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -84,7 +84,7 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
  * @scsi_dh - Device handler to be detached
  *
  * Detach from a device handler. If a device handler is specified,
- * only detach if the currently attached handler is equal to it.
+ * only detach if the currently attached handler matches @scsi_dh.
  */
 static void scsi_dh_handler_detach(struct scsi_device *sdev,
 				   struct scsi_device_handler *scsi_dh)
@@ -103,6 +103,98 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
 }
 
 /*
+ * Functions for sysfs attribute 'dh_state'
+ */
+static ssize_t
+store_dh_state(struct device *dev, struct device_attribute *attr,
+	       const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device_handler *scsi_dh;
+	int err = -EINVAL;
+
+	if (!sdev->scsi_dh_data) {
+		/*
+		 * Attach to a device handler
+		 */
+		if (!(scsi_dh = get_device_handler(buf)))
+			return err;
+		err = scsi_dh_handler_attach(sdev, scsi_dh);
+	} else {
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+		if (!strncmp(buf, "detach", 6)) {
+			/*
+			 * Detach from a device handler
+			 */
+			scsi_dh_handler_detach(sdev, scsi_dh);
+			err = 0;
+		} else if (!strncmp(buf, "activate", 8)) {
+			/*
+			 * Activate a device handler
+			 */
+			if (scsi_dh->activate)
+				err = scsi_dh->activate(sdev);
+			else
+				err = 0;
+		}
+	}
+
+	return err<0?err:count;
+}
+
+static ssize_t
+show_dh_state(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (!sdev->scsi_dh_data)
+		return snprintf(buf, 20, "detached\n");
+
+	return snprintf(buf, 20, "%s\n", sdev->scsi_dh_data->scsi_dh->name);
+}
+
+static struct device_attribute scsi_dh_state_attr =
+	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
+	       store_dh_state);
+
+/*
+ * scsi_dh_sysfs_attr_add - Callback for scsi_init_dh
+ */
+static int scsi_dh_sysfs_attr_add(struct device *dev, void *data)
+{
+	struct scsi_device *sdev;
+	int err;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	err = device_create_file(&sdev->sdev_gendev,
+				 &scsi_dh_state_attr);
+
+	return 0;
+}
+
+/*
+ * scsi_dh_sysfs_attr_remove - Callback for scsi_exit_dh
+ */
+static int scsi_dh_sysfs_attr_remove(struct device *dev, void *data)
+{
+	struct scsi_device *sdev;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
+	device_remove_file(&sdev->sdev_gendev,
+			   &scsi_dh_state_attr);
+
+	return 0;
+}
+
+/*
  * scsi_dh_notifier - notifier chain callback
  */
 static int scsi_dh_notifier(struct notifier_block *nb,
@@ -132,7 +224,10 @@ static int scsi_dh_notifier(struct notifier_block *nb,
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		err = scsi_dh_handler_attach(sdev, devinfo);
+		if (!err)
+			err = device_create_file(dev, &scsi_dh_state_attr);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
 out:
@@ -284,11 +379,17 @@ static int __init scsi_dh_init(void)
 
 	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
 
+	if (!r)
+		bus_for_each_dev(&scsi_bus_type, NULL, NULL,
+				 scsi_dh_sysfs_attr_add);
+
 	return r;
 }
 
 static void __exit scsi_dh_exit(void)
 {
+	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
+			 scsi_dh_sysfs_attr_remove);
 	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
 }
 
-- 
1.5.2.4

