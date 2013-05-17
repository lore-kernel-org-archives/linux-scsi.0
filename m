From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v2 1/2] ATA/SCSI subsystem resume path made fully
 asynchronous
Date: Fri, 17 May 2013 19:03:30 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A16B97BD7C@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

This patch goes through and sets the power.async_suspend flag for every device
in the ATA/SCSI resume path. This includes the ata port, link, and dev
devices, the scsi host and target devices, all their associated transport
devices, the block devices, and block partitions. This allows the entire
ATA resume path to be added to the async device queue in
drivers/base/power/main.c. Without this, the ATA resume path ends up in
both queues (sync and async), which causes interdependencies and backs up
the two queues.

Changelog:
v2:
        - Updated patch submission. Incorporates comments from Tejun Heo.   
          Fixed pr_debug format, No functional changes.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
---
 block/genhd.c                      |    2 ++
 block/partition-generic.c          |    1 +
 drivers/ata/libata-transport.c     |    4 +++-
 drivers/base/attribute_container.c |    1 +
 drivers/base/core.c                |    8 +++++++-
 drivers/scsi/scsi_sysfs.c          |    2 +-
 drivers/scsi/sd.c                  |    3 +++
 7 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7dcfdd8..3825d45 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -525,6 +525,8 @@ static void register_disk(struct gendisk *disk)
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
+	device_enable_async_suspend(ddev);
+
 	if (device_add(ddev))
 		return;
 	if (!sysfs_deprecated) {
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 1cb4dec..7f136d1 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -325,6 +325,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	pdev->class = &block_class;
 	pdev->type = &part_type;
 	pdev->parent = ddev;
+	pdev->power.async_suspend = true;
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c04d393..493f5ce 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -285,13 +285,13 @@ int ata_tport_add(struct device *parent,
 	dev->parent = get_device(parent);
 	dev->release = ata_tport_release;
 	dev_set_name(dev, "ata%d", ap->print_id);
+	device_enable_async_suspend(dev);
 	transport_setup_device(dev);
 	error = device_add(dev);
 	if (error) {
 		goto tport_err;
 	}
 
-	device_enable_async_suspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	pm_runtime_forbid(dev);
@@ -414,6 +414,7 @@ int ata_tlink_add(struct ata_link *link)
         else
 		dev_set_name(dev, "link%d.%d", ap->print_id, link->pmp);
 
+	device_enable_async_suspend(dev);
 	transport_setup_device(dev);
 
 	error = device_add(dev);
@@ -642,6 +643,7 @@ static int ata_tdev_add(struct ata_device *ata_dev)
         else
 		dev_set_name(dev, "dev%d.%d.0", ap->print_id, link->pmp);
 
+	device_enable_async_suspend(dev);
 	transport_setup_device(dev);
 	error = device_add(dev);
 	if (error) {
diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index d78b204..7209b6e 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -349,6 +349,7 @@ attribute_container_add_attrs(struct device *classdev)
 int
 attribute_container_add_class_device(struct device *classdev)
 {
+	classdev->power.async_suspend = true;
 	int error = device_add(classdev);
 	if (error)
 		return error;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..07fb818 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1020,7 +1020,8 @@ int device_add(struct device *dev)
 		goto name_error;
 	}
 
-	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
+	pr_debug("device: '%s': %s, %s suspend\n", dev_name(dev), __func__,
+		(dev->power.async_suspend) ? "async" : "sync");
 
 	parent = get_device(dev->parent);
 	kobj = get_device_parent(dev, parent);
@@ -1558,6 +1559,11 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 		goto error;
 	}
 
+	if (parent)
+		dev->power.async_suspend = parent->power.async_suspend;
+	else
+		dev->power.async_suspend = true;
+
 	dev->devt = devt;
 	dev->class = class;
 	dev->parent = parent;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..22b5a5a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -838,6 +838,7 @@ static int scsi_target_add(struct scsi_target *starget)
 	if (starget->state != STARGET_CREATED)
 		return 0;
 
+	device_enable_async_suspend(&starget->dev);
 	error = device_add(&starget->dev);
 	if (error) {
 		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
@@ -848,7 +849,6 @@ static int scsi_target_add(struct scsi_target *starget)
 
 	pm_runtime_set_active(&starget->dev);
 	pm_runtime_enable(&starget->dev);
-	device_enable_async_suspend(&starget->dev);
 
 	return 0;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..3a412ea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2924,6 +2924,9 @@ static int sd_probe(struct device *dev)
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, dev_name(dev));
 
+	if (dev)
+		sdkp->dev.power.async_suspend = dev->power.async_suspend;
+
 	if (device_add(&sdkp->dev))
 		goto out_free_index;
 

