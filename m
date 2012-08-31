From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v5 5/7] scsi: pm: add may_power_off flag
Date: Fri, 31 Aug 2012 17:42:33 +0800
Message-ID: <1346406155-4768-6-git-send-email-aaron.lu@intel.com>
References: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2HaJnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2012 05:43:21 -0400
In-Reply-To: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Add a new flag may_power_off for scsi device, it gives the user a chance
to control when the device is runtime suspended, can we remove its power
if possible.

And if the device can be powered off(reflected by can_power_off flag,
determined by individual driver), create a sysfs entry named
may_power_off to let user control the flag.

I'm planning using this flag for sr and sd.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_sysfs.c  | 10 ++++++----
 include/scsi/scsi_device.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..92ea17c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -484,9 +484,6 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
 
-/* Currently we don't export bit fields, but we might in future,
- * so leave this code in */
-#if 0
 /*
  * sdev_rd_attr: create a function and attribute variable for a
  * read/write bit field.
@@ -526,7 +523,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 	} else
 		return -EINVAL;
 }
-#endif
+
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -860,6 +857,8 @@ static struct device_attribute sdev_attr_queue_type_rw =
 	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 	       sdev_store_queue_type_rw);
 
+sdev_rw_attr_bit (may_power_off);
+
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -950,6 +949,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	if (sdev->can_power_off)
+		device_create_file(&sdev->sdev_gendev, &dev_attr_may_power_off);
+
 	return error;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 72d946f..41cec7f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,6 +157,7 @@ struct scsi_device {
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned wakeup_by_user:1;	/* User wakes up the device */
+	unsigned may_power_off:1;	/* Power off is allowed by user */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.5

