From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] bind bsg to all SCSI devices
Date: Tue, 20 Mar 2007 23:48:55 +0900 (JST)
Message-ID: <20070320213116O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43681 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544AbXCTOtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 10:49:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This patch binds bsg to all SCSI devices (their request queues) like
the current sg driver does. We can send SCSI commands to non disk and
cdrom scsi devices like OSD via bsg.

This patch removes bsg_register_queue from blk_register_queue so bsg
devices aren't bound to non SCSI block devices. If they want bsg, I'll
send a patch to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c       |   59 ++++++++++++++++++++++++++++++++++++++++++++++------
 block/ll_rw_blk.c |    8 -------
 2 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 4ea4bed..cd0221c 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -29,6 +29,8 @@ #include <linux/bsg.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
 #include <scsi/sg.h>
 
 static char bsg_version[] = "block layer sg (bsg) 0.4";
@@ -962,6 +964,8 @@ int bsg_register_queue(struct request_qu
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
+	int ret;
+	struct class_device *class_dev = NULL;
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -978,22 +982,54 @@ int bsg_register_queue(struct request_qu
 	bcd->minor = bsg_device_nr;
 	bsg_device_nr++;
 	bcd->queue = q;
-	bcd->class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
-	if (!bcd->class_dev)
+	class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
+	if (IS_ERR(class_dev)) {
+		ret = PTR_ERR(class_dev);
 		goto err;
+	}
+	bcd->class_dev = class_dev;
+
+	if (q->kobj.dentry) {
+		ret = sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg");
+		if (ret)
+			goto err;
+	}
+
 	list_add_tail(&bcd->list, &bsg_class_list);
-	if (sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg"))
-		goto err;
+
 	mutex_unlock(&bsg_mutex);
 	return 0;
 err:
 	bsg_device_nr--;
-	if (bcd->class_dev)
+	if (class_dev)
 		class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
 	mutex_unlock(&bsg_mutex);
-	return -ENOMEM;
+	return ret;
+}
+
+static int bsg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
+{
+	int ret;
+	struct scsi_device *sdp = to_scsi_device(cl_dev->dev);
+	struct request_queue *rq = sdp->request_queue;
+
+	if (rq->kobj.parent)
+		ret = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
+	else
+		ret = bsg_register_queue(rq, kobject_name(&sdp->sdev_gendev.kobj));
+	return ret;
 }
 
+static void bsg_remove(struct class_device *cl_dev, struct class_interface *cl_intf)
+{
+	bsg_unregister_queue(to_scsi_device(cl_dev->dev)->request_queue);
+}
+
+static struct class_interface bsg_intf = {
+	.add	= bsg_add,
+	.remove	= bsg_remove,
+};
+
 static int __init bsg_init(void)
 {
 	int ret, i;
@@ -1021,6 +1057,15 @@ static int __init bsg_init(void)
 		return ret;
 	}
 
+	ret = scsi_register_interface(&bsg_intf);
+	if (ret) {
+		printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
+		kmem_cache_destroy(bsg_cmd_cachep);
+		class_destroy(bsg_class);
+		unregister_chrdev(BSG_MAJOR, "bsg");
+		return ret;
+	}
+
 	printk(KERN_INFO "%s loaded\n", bsg_version);
 	return 0;
 }
@@ -1029,4 +1074,4 @@ MODULE_AUTHOR("Jens Axboe");
 MODULE_DESCRIPTION("Block layer SGSI generic (sg) driver");
 MODULE_LICENSE("GPL");
 
-subsys_initcall(bsg_init);
+device_initcall(bsg_init);
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index fccc3a1..38c293b 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -4038,13 +4038,6 @@ int blk_register_queue(struct gendisk *d
 		return ret;
 	}
 
-	ret = bsg_register_queue(q, disk->disk_name);
-	if (ret) {
-		elv_unregister_queue(q);
-		kobject_unregister(&q->kobj);
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -4053,7 +4046,6 @@ void blk_unregister_queue(struct gendisk
 	request_queue_t *q = disk->queue;
 
 	if (q && q->request_fn) {
-		bsg_unregister_queue(q);
 		elv_unregister_queue(q);
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
-- 
1.4.3.2

