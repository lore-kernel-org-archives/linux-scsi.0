From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/3] scsi_dh: Add 'dh_state' sysfs attribute
Date: Wed, 07 May 2008 17:05:17 +0200
Message-ID: <20080507150517.F026310B5DF@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:36324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYEHGWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2008 02:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


The scsi_dh attribute allows for dynamic manipulation of the device
handler state. It supports manual attaching, detaching, and activating
of the device handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |   88 +++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 55e5fd2..2dbf84b 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -54,6 +54,55 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 	return found;
 }
 
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
+		/*
+		 * Detach from a device handler
+		 */
+		if (!strncmp(buf, "detach", 6)) {
+			err = scsi_dh_handler_detach(sdev);
+		} else if (!strncmp(buf, "activate", 8)) {
+			scsi_dh = sdev->scsi_dh_data->scsi_dh;
+
+			err = scsi_dh->activate(sdev);
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
+	struct scsi_device_handler *scsi_dh;
+
+	if (!sdev->scsi_dh_data)
+		return snprintf(buf, 20, "detached\n");
+
+	scsi_dh = sdev->scsi_dh_data->scsi_dh;
+
+	return snprintf(buf, 20, "%s\n", scsi_dh->name);
+}
+
+static struct device_attribute scsi_dh_state_attr =
+	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
+	       store_dh_state);
+
 /*
  * scsi_dh_handler_attach - Attach a device handler to a device
  * @sdev - SCSI device the device handler should attach to
@@ -115,9 +164,11 @@ static int scsi_dh_notifier(struct notifier_block *nb,
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		scsi_dh_handler_attach(sdev, devinfo->handler);
+		device_create_file(dev, &scsi_dh_state_attr);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		if (sdev->scsi_dh_data == NULL)
 			goto out;
+		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev);
 	}
 out:
@@ -298,17 +349,54 @@ static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
 
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
 static int __init scsi_dh_init(void)
 {
 	int r;
 
 	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
 
+	if (!r)
+		bus_for_each_dev(&scsi_bus_type, NULL, NULL,
+				 scsi_dh_sysfs_attr_add);
+
 	return r;
 }
 
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
 static void __exit scsi_dh_exit(void)
 {
+	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
+			 scsi_dh_sysfs_attr_remove);
 	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
 }
 
-- 
1.5.2.4

