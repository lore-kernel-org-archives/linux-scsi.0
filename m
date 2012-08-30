From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 3/3] scsi: sd: add may_power_off sysfs entry
Date: Thu, 30 Aug 2012 14:44:00 +0800
Message-ID: <1346309040-27112-4-git-send-email-aaron.lu@intel.com>
References: <1346309040-27112-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2H3Goj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2012 02:44:39 -0400
In-Reply-To: <1346309040-27112-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

If the platform is able to power off the scsi device, add a sysfs entry
may_power_off to let user control the may_power_off flag of the device.

This flag will control when the scsi device is runtime suspended, can we
remove power from it(e.g. let it enter D3 cold ACPI device state).

This flag is used in libata-acpi.c to decide which ACPI D-State it will
enter when runtime suspended.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..db25569 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2584,6 +2584,38 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t
+may_power_off_show(struct device *dev, struct device_attribute *attr,
+		   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 10, "%d\n", sdev->may_power_off);
+}
+
+static ssize_t
+may_power_off_store(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	int value = -EINVAL;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (buf[1] == '\0' || (buf[1] == '\n' && buf[2] == '\0')) {
+		if (buf[0] == '1')
+			value = 1;
+		else if (buf[0] == '0')
+			value = 0;
+	}
+
+	if (value >= 0) {
+		sdev->may_power_off = value;
+		value = count;
+	}
+
+	return value;
+}
+DEVICE_ATTR(may_power_off, S_IRUGO | S_IWUSR,
+		may_power_off_show, may_power_off_store);
+
 /*
  * The asynchronous part of sd_probe
  */
@@ -2638,6 +2670,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	if (sdp->can_power_off)
+		device_create_file(&sdp->sdev_gendev, &dev_attr_may_power_off);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
-- 
1.7.11.5

