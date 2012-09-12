From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 4/6] scsi: pm: add may_power_off flag
Date: Wed, 12 Sep 2012 16:29:55 +0800
Message-ID: <1347438597-5903-5-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab2ILIaP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Sep 2012 04:30:15 -0400
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Add a new flag may_power_off for scsi device, it gives the user a chance
to control when the device is runtime suspended, can we remove its power
if possible.

And if the device can be powered off(reflected by can_power_off flag,
determined by individual driver), create a sysfs entry named
may_power_off to let user control the flag.

When user changes this flag through sysfs entry and if the device is
already runtime suspended, runtime resume it so that it can respect this
flag next time it is runtime suspended.

I'm planning using this flag for sr and sd.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_sysfs.c  | 37 ++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |  1 +
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..8c8efd3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -509,6 +509,7 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 	return ret;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
+#endif
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
@@ -526,7 +527,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 	} else
 		return -EINVAL;
 }
-#endif
+
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -860,6 +861,37 @@ static struct device_attribute sdev_attr_queue_type_rw =
 	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 	       sdev_store_queue_type_rw);
 
+static ssize_t
+sdev_show_may_power_off(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf (buf, 20, "%d\n", sdev->may_power_off);
+}
+
+static ssize_t
+sdev_store_may_power_off(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	int ret;
+	struct scsi_device *sdev;
+
+	ret = scsi_sdev_check_buf_bit(buf);
+	if (ret >= 0) {
+		sdev = to_scsi_device(dev);
+		if (sdev->may_power_off != ret) {
+			sdev->may_power_off = ret;
+			if (pm_runtime_suspended(dev))
+				pm_runtime_resume(dev);
+		}
+		ret = count;
+	}
+	return ret;
+}
+static DEVICE_ATTR(may_power_off, S_IRUGO | S_IWUSR,
+			sdev_show_may_power_off, sdev_store_may_power_off);
+
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -950,6 +982,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	if (sdev->can_power_off)
+		device_create_file(&sdev->sdev_gendev, &dev_attr_may_power_off);
+
 	return error;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index da5c86f..4712aa1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -159,6 +159,7 @@ struct scsi_device {
 	unsigned need_eject:1;	/* Need eject the tray when wakes up */
 	unsigned ready_to_power_off:1;	/* Device is ready to be powered off */
 	unsigned powered_off:1;	/* Device is powered off */
+	unsigned may_power_off:1; /* Power off is allowed by user */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.12.21.g871e293

