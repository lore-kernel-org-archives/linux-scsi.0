From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 17/17] Add usage_count attribute to each logical drive
	in /sys
Date: Thu, 20 Aug 2009 10:19:09 -0500
Message-ID: <20090820151909.22833.79641.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:43315 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZHTPTH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:19:07 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

Add usage_count attribute to each logical drive at
/sys/devices/<dev>/ccissX/cXdY/usage_count for controller X,
logical drive Y.  The usage count is the number of times
the device has currently been opened.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +++++++
 drivers/block/cciss.c                              |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 8d02602..4f29e5f 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -52,3 +52,10 @@ Kernel Version: 2.6.31
 Contact:	iss_storagedev@hp.com
 Description:	Displays the RAID level of logical drive Y of
 		controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/usage_count
+Date:		August 2009
+Kernel Version: 2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Displays the usage count (number of opens) of logical drive Y
+		of controller X.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 2ad089e..a8b7aef 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -626,6 +626,25 @@ static ssize_t cciss_show_raid_level(struct device *dev,
 }
 DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
 
+static ssize_t cciss_show_usage_count(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
+	unsigned long flags;
+	int count;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		return -EBUSY;
+	}
+	count = drv->usage_count;
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	return snprintf(buf, 20, "%d\n", count);
+}
+DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
+
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
 	NULL
@@ -653,6 +672,7 @@ static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_rev.attr,
 	&dev_attr_lunid.attr,
 	&dev_attr_raid_level.attr,
+	&dev_attr_usage_count.attr,
 	NULL
 };
 

