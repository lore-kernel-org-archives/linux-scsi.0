From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/20] cciss: Add lunid attribute to each logical drive in /sys
Date: Thu, 17 Sep 2009 13:48:10 -0500
Message-ID: <20090917184810.15105.56428.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760283AbZIQSry@vger.kernel.org>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Add lunid attribute to each logical drive at
/sys/devices/<dev>/ccissX/cXdY/lunid for controller X,
logical drive Y

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +++++
 drivers/block/cciss.c                              |   26 ++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index ac3429d..5a6c8d3 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -38,3 +38,10 @@ Kernel Version:	2.6.31
 Contact:	iss_storagedev@hp.com
 Description:	Kicks of a rescan of the controller to discover logical
 		drive topology changes.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/lunid
+Date:		August 2009
+Kernel Version: 2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Displays the 8-byte LUN ID used to address logical
+		drive Y of controller X.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0ff665e..a8684d0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -578,6 +578,31 @@ static ssize_t dev_show_rev(struct device *dev,
 }
 DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 
+static ssize_t cciss_show_lunid(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
+	unsigned long flags;
+	unsigned char lunid[8];
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		return -EBUSY;
+	}
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		return -ENOTTY;
+	}
+	memcpy(lunid, drv->LunID, sizeof(lunid));
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	return snprintf(buf, 20, "0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+		lunid[0], lunid[1], lunid[2], lunid[3],
+		lunid[4], lunid[5], lunid[6], lunid[7]);
+}
+DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
+
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
 	NULL
@@ -603,6 +628,7 @@ static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_model.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_rev.attr,
+	&dev_attr_lunid.attr,
 	NULL
 };
 
