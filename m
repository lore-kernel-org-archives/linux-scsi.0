From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 3/3] cciss: kick off logical drive topology rescan through
	sysfs
Date: Tue, 14 Jul 2009 16:02:55 -0600
Message-ID: <20090714220255.22282.96793.stgit@bob.kio>
References: <20090714220239.22282.44414.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756638AbZGNWDA@vger.kernel.org>
In-Reply-To: <20090714220239.22282.44414.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

cciss: kick off logical drive topology rescan through sysfs

Added /sys/bus/pci/devices/<dev>/ccissX/rescan sysfs entry used
to kick off a rescan that discovers logical drive topology changes.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 0a92a7c..4050606 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -31,3 +31,10 @@ Date:		March 2009
 Kernel Version: 2.6.30
 Contact:	iss_storagedev@hp.com
 Description:	A symbolic link to /sys/block/cciss!cXdY
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/rescan
+Date:		July 2009
+Kernel Version:	2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Kicks of a rescan of the controller to discovery logical
+		drive topology changes.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c6bba77..a409e26 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -461,9 +461,19 @@ static void __devinit cciss_procinit(int i)
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
 #define to_drv(n) container_of(n, drive_info_struct, dev)
 
-static struct device_type cciss_host_type = {
-	.name		= "cciss_host",
-};
+static ssize_t host_store_rescan(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ctlr_info *h = to_hba(dev);
+
+	add_to_scan_list(h);
+	wake_up_process(cciss_scan_thread);
+	wait_for_completion_interruptible(&h->scan_wait);
+
+	return count;
+}
+DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
@@ -567,6 +577,25 @@ static ssize_t dev_show_rev(struct device *dev,
 }
 DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 
+static struct attribute *cciss_host_attrs[] = {
+	&dev_attr_rescan.attr,
+	NULL
+};
+
+static struct attribute_group cciss_host_attr_group = {
+	.attrs = cciss_host_attrs,
+};
+
+static struct attribute_group *cciss_host_attr_groups[] = {
+	&cciss_host_attr_group,
+	NULL
+};
+
+static struct device_type cciss_host_type = {
+	.name		= "cciss_host",
+	.groups		= cciss_host_attr_groups,
+};
+
 static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_unique_id.attr,
 	&dev_attr_model.attr,
