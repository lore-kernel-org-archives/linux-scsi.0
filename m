From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 03/17] Allow triggering of rescan of logical drive
	topology via sysfs entry
Date: Thu, 20 Aug 2009 10:17:57 -0500
Message-ID: <20090820151757.22833.74373.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37138 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZHTPR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:17:56 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

From: Andrew Patterson <andrew.patterson@hp.com>

Added /sys/bus/pci/devices/<dev>/ccissX/rescan sysfs entry used
to kick off a rescan that discovers logical drive topology changes.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
---

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 ++++
 drivers/block/cciss.c                              |   36 ++++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 0a92a7c..ac3429d 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -31,3 +31,10 @@ Date:		March 2009
 Kernel Version: 2.6.30
 Contact:	iss_storagedev@hp.com
 Description:	A symbolic link to /sys/block/cciss!cXdY
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/rescan
+Date:		August 2009
+Kernel Version:	2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Kicks of a rescan of the controller to discover logical
+		drive topology changes.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e7273a4..763535e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -194,6 +194,7 @@ static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
 static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int add_to_scan_list(struct ctlr_info *h);
 static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 
@@ -459,9 +460,19 @@ static void __devinit cciss_procinit(int i)
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
@@ -565,6 +576,25 @@ static ssize_t dev_show_rev(struct device *dev,
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

