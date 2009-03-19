From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/2] Add 'tpgs' sysfs attribute for SCSI devices
Date: Thu, 19 Mar 2009 09:06:34 +0100
Message-ID: <20090319080634.918B718C79D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZCSIGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 04:06:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


We need the 'TGPS' setting of the inquiry data
to properly support ALUA. So just add an accessor
for the stored inquiry data and display it
in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c  |   10 ++++++++++
 include/scsi/scsi_device.h |    5 +++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fa4711d..cccdd89 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -586,6 +586,15 @@ sdev_store_timeout (struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_tpgs (struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", scsi_device_tpgs(sdev));
+}
+static DEVICE_ATTR(tpgs, S_IRUGO, sdev_show_tpgs, NULL);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
@@ -745,6 +754,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_vendor.attr,
 	&dev_attr_model.attr,
 	&dev_attr_rev.attr,
+	&dev_attr_tpgs.attr,
 	&dev_attr_rescan.attr,
 	&dev_attr_delete.attr,
 	&dev_attr_state.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3f566af..6ac6321 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -450,6 +450,11 @@ static inline int scsi_device_protection(struct scsi_device *sdev)
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
+static inline int scsi_device_tpgs(struct scsi_device *sdev)
+{
+	return (sdev->inquiry[5] >> 4) &3;
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
1.5.3.2

