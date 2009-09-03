From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 06/10] scsi: adds sdev->queue_ramp_up_period to sysfs
Date: Thu, 03 Sep 2009 15:22:59 -0700
Message-ID: <20090903222258.24946.2994.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbZICWW4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:56 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

Adds sysfs functions to show or store sdev->queue_ramp_up_period.

Adds queue_ramp_up_period to sysfs if change_queue_depth is
supported since ramp up is needed only in case the dynamic
queue_depth change is supported first.

Initializes queue_ramp_up_period to 120HZ jiffies as initial
default value, it is same as used in lpfc and qla2xxx.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/scsi_scan.c   |    1 +
 drivers/scsi/scsi_sysfs.c  |   38 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h |    2 ++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..0e6db8b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -251,6 +251,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
 	sdev->host = shost;
+	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4530626..9759349 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -779,6 +779,36 @@ static struct device_attribute sdev_attr_queue_depth_rw =
 	       sdev_store_queue_depth_rw);
 
 static ssize_t
+sdev_show_queue_ramp_up_period(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%lu\n", sdev->queue_ramp_up_period);
+}
+
+static ssize_t
+sdev_store_queue_ramp_up_period(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned long period;
+
+	if (strict_strtoul(buf, 10, &period))
+		return -EINVAL;
+
+	sdev->queue_ramp_up_period = period;
+	return period;
+}
+
+static struct device_attribute sdev_attr_queue_ramp_up_period =
+	__ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
+	       sdev_show_queue_ramp_up_period,
+	       sdev_store_queue_ramp_up_period);
+
+static ssize_t
 sdev_store_queue_type_rw(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
@@ -870,8 +900,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	get_device(&sdev->sdev_gendev);
 
 	/* create queue files, which may be writable, depending on the host */
-	if (sdev->host->hostt->change_queue_depth)
-		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
+	if (sdev->host->hostt->change_queue_depth) {
+		error = device_create_file(&sdev->sdev_gendev,
+					   &sdev_attr_queue_depth_rw);
+		error = device_create_file(&sdev->sdev_gendev,
+					   &sdev_attr_queue_ramp_up_period);
+	}
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
 	if (error) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 041d4f9..899f501 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -85,6 +85,8 @@ struct scsi_device {
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
 	unsigned long last_queue_full_time;	/* last queue full time */
 	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
+#define SCSI_DEFAULT_RAMP_UP_PERIOD	(120 * HZ)
+
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
 	unsigned int id, lun, channel;

