From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 2/6] fastboot: make scsi probes asynchronous
Date: Mon, 5 Jan 2009 20:11:18 -0800
Message-ID: <20090105201118.5bfa1e36@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105200959.04a626ac@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 19617cfb1840abc69cc2fe74433007fc1daa1cb7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 05:32:28 -0800
Subject: [PATCH] fastboot: make scsi probes asynchronous

This patch makes part of the scsi probe (which is mostly device spin up and the
partition scan) asynchronous. Only the part that runs after getting the device
number allocated is asynchronous, ensuring that device numbering remains stable.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/scsi/scsi_scan.c |    3 +
 drivers/scsi/sd.c        |  109 ++++++++++++++++++++++++++++------------------
 2 files changed, 70 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 18486b5..17914a3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/spinlock.h>
+#include <linux/async.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -179,6 +180,8 @@ int scsi_complete_async_scans(void)
 	spin_unlock(&async_scan_lock);
 
 	kfree(data);
+	/* Synchronize async operations globally */
+	async_synchronize_full();
 	return 0;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 62b28d5..e035c11 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
+#include <linux/async.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -1802,6 +1803,71 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+/*
+ * The asynchronous part of sd_probe
+ */
+static void sd_probe_async(void *data, async_cookie_t cookie)
+{
+	struct scsi_disk *sdkp = data;
+	struct scsi_device *sdp;
+	struct gendisk *gd;
+	u32 index;
+	struct device *dev;
+
+	sdp = sdkp->device;
+	gd = sdkp->disk;
+	index = sdkp->index;
+	dev = &sdp->sdev_gendev;
+
+	if (!sdp->request_queue->rq_timeout) {
+		if (sdp->type != TYPE_MOD)
+			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
+		else
+			blk_queue_rq_timeout(sdp->request_queue,
+					     SD_MOD_TIMEOUT);
+	}
+
+	device_initialize(&sdkp->dev);
+	sdkp->dev.parent = &sdp->sdev_gendev;
+	sdkp->dev.class = &sd_disk_class;
+	strncpy(sdkp->dev.bus_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+
+	if (device_add(&sdkp->dev))
+		goto out_free_index;
+
+	get_device(&sdp->sdev_gendev);
+
+	if (index < SD_MAX_DISKS) {
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
+	}
+	gd->fops = &sd_fops;
+	gd->private_data = &sdkp->driver;
+	gd->queue = sdkp->device->request_queue;
+
+	sd_revalidate_disk(gd);
+
+	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
+
+	gd->driverfs_dev = &sdp->sdev_gendev;
+	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
+	if (sdp->removable)
+		gd->flags |= GENHD_FL_REMOVABLE;
+
+	dev_set_drvdata(dev, sdkp);
+	add_disk(gd);
+	sd_dif_config_host(sdkp);
+
+	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
+		  sdp->removable ? "removable " : "");
+
+	return;
+
+ out_free_index:
+	ida_remove(&sd_index_ida, index);
+}
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -1865,48 +1931,7 @@ static int sd_probe(struct device *dev)
 	sdkp->openers = 0;
 	sdkp->previous_state = 1;
 
-	if (!sdp->request_queue->rq_timeout) {
-		if (sdp->type != TYPE_MOD)
-			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
-		else
-			blk_queue_rq_timeout(sdp->request_queue,
-					     SD_MOD_TIMEOUT);
-	}
-
-	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = &sdp->sdev_gendev;
-	sdkp->dev.class = &sd_disk_class;
-	strncpy(sdkp->dev.bus_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
-
-	if (device_add(&sdkp->dev))
-		goto out_free_index;
-
-	get_device(&sdp->sdev_gendev);
-
-	if (index < SD_MAX_DISKS) {
-		gd->major = sd_major((index & 0xf0) >> 4);
-		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-		gd->minors = SD_MINORS;
-	}
-	gd->fops = &sd_fops;
-	gd->private_data = &sdkp->driver;
-	gd->queue = sdkp->device->request_queue;
-
-	sd_revalidate_disk(gd);
-
-	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
-
-	gd->driverfs_dev = &sdp->sdev_gendev;
-	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
-	if (sdp->removable)
-		gd->flags |= GENHD_FL_REMOVABLE;
-
-	dev_set_drvdata(dev, sdkp);
-	add_disk(gd);
-	sd_dif_config_host(sdkp);
-
-	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
-		  sdp->removable ? "removable " : "");
+	async_schedule(sd_probe_async, sdkp);
 
 	return 0;
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
