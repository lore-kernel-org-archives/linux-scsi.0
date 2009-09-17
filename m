From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/20] cciss: Add a "raid_level" attribute to each logical
	drive in /sys
Date: Thu, 17 Sep 2009 13:48:21 -0500
Message-ID: <20090917184821.15105.70403.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760299AbZIQSr5@vger.kernel.org>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

and change get rid of some magic numbers in raid lavel decoding.

Add raid_level attribute to each logical drive at
/sys/devices/<dev>/ccissX/cXdY/raid_level for controller X,
logical drive Y


Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 ++++++
 drivers/block/cciss.c                              |   24 ++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 5a6c8d3..8d02602 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -45,3 +45,10 @@ Kernel Version: 2.6.31
 Contact:	iss_storagedev@hp.com
 Description:	Displays the 8-byte LUN ID used to address logical
 		drive Y of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/raid_level
+Date:		August 2009
+Kernel Version: 2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Displays the RAID level of logical drive Y of
+		controller X.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 84f15ec..dc3461e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -602,6 +602,29 @@ static ssize_t cciss_show_lunid(struct device *dev,
 }
 DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
 
+static ssize_t cciss_show_raid_level(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
+	int raid;
+	unsigned long flags;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		return -EBUSY;
+	}
+	raid = drv->raid_level;
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	if (raid < 0 || raid > RAID_UNKNOWN)
+		raid = RAID_UNKNOWN;
+
+	return snprintf(buf, strlen(raid_label[raid]) + 7, "RAID %s\n",
+			raid_label[raid]);
+}
+DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
+
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
 	NULL
@@ -628,6 +651,7 @@ static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_vendor.attr,
 	&dev_attr_rev.attr,
 	&dev_attr_lunid.attr,
+	&dev_attr_raid_level.attr,
 	NULL
 };
 
