From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Wed, 14 Feb 2007 15:56:05 -0500
Message-ID: <20070214205605.GA20967@osc.edu>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:39452 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbXBNV3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 16:29:18 -0500
Content-Disposition: inline
In-Reply-To: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Smart@Emulex.Com, hch@infradead.org

fujita.tomonori@lab.ntt.co.jp wrote on Wed, 14 Feb 2007 02:53 +0900:
> It seems that it would be better to bind bsg devices to request_queue
> instead of gendisk. This enables any objects to define own
> request_handler and create own bsg device (under sysfs).
> 
> Possible enhancements:
> 
> - I removed gendisk but it would be better for objects having gendisk
> to keep it for nice features like disk stats.
> 
> - Objects that wants to use bsg need to setup a request_queue. Maybe
> wrapper functions to setup a request_queue for them would be useful.
> 
> This patch was tested only with disk drivers.

The only place that bsg_register_rq is called is via
blk_register_queue, which is only called by add_disk.  But not all
devices have a block interface or need the gendisk that these
functions assume.

This change registers all SCSI devices with bsg, even ones that are
not accessed through a block interface.  They already have a
request_queue; this just presents it to bsg at LUN scan time.
It uses the bus_id as the name for sysfs.

Devices that happen to be block SCSI devices are thus registered
twice, which is probably not good, but preserves the exsiting "sda"
entry, e.g., in /sys/class/bsg.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c               |   16 +++++++++++++---
 drivers/scsi/scsi_scan.c  |    6 ++++++
 drivers/scsi/scsi_sysfs.c |    1 +
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index e261997..e100efe 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -962,6 +962,7 @@ int bsg_register_rq(struct request_queue *q, char *name)
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
+	int ret = -ENOMEM;
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -981,9 +982,18 @@ int bsg_register_rq(struct request_queue *q, char *name)
 	bcd->class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
 	if (!bcd->class_dev)
 		goto err;
+
+	/*
+	 * Put a link, e.g., /sys/block/sda/queue/bsg -> /sys/class/bsg/sda,
+	 * if a sysfs entry for the queue exists.
+	 */
+	if (q->kobj.dentry) {
+		ret = sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg");
+		if (ret)
+			goto err;
+	}
+
 	list_add_tail(&bcd->list, &bsg_class_list);
-	if (sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg"))
-		goto err;
 	mutex_unlock(&bsg_mutex);
 	return 0;
 err:
@@ -991,7 +1001,7 @@ err:
 	if (bcd->class_dev)
 		class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
 	mutex_unlock(&bsg_mutex);
-	return -ENOMEM;
+	return ret;
 }
 
 static int __init bsg_init(void)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23ab62e..8aa4c3c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -895,6 +895,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	/*
+	 * Register bsg interface for every SCSI device.
+	 */
+	if (bsg_register_rq(sdev->request_queue, sdev->sdev_gendev.bus_id))
+		return SCSI_SCAN_NO_RESPONSE;
+
+	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
 	 * about it.
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 259c90c..bc694a5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -238,6 +238,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	if (sdev->request_queue) {
+		bsg_unregister_rq(sdev->request_queue);
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
-- 
1.4.4.2

