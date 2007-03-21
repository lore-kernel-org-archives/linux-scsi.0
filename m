From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] improve bsg device allocation
Date: Thu, 22 Mar 2007 03:11:06 +0900
Message-ID: <20070322031106Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:56379 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222AbXCUSK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 14:10:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This patch addresses on two issues on bsg device allocation.

- the current maxium number of bsg devices is 256. It's too small if
we allocate bsg devices to all SCSI devices, transport entities, etc.
This increses the maxium number to 32768 (taken from the sg driver).

- SCSI devices are dynamically added and removed. Currently, bsg can't
handle it well since bsd_device->minor is simply increased.

This is dependent on the patchset that I posted yesterday:

http://marc.info/?l=linux-scsi&m=117440208726755&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index cd0221c..4ef3cc5 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -58,6 +58,7 @@ enum {
 };
 
 #define BSG_DEFAULT_CMDS	64
+#define BSG_MAX_DEVS		32768
 
 #undef BSG_DEBUG
 
@@ -75,7 +76,7 @@ #define list_entry_bc(entry)	list_entry(
 #define BSG_MAJOR	(240)
 
 static DEFINE_MUTEX(bsg_mutex);
-static int bsg_device_nr;
+static int bsg_device_nr, bsg_minor_idx;
 
 #define BSG_LIST_SIZE	(8)
 #define bsg_list_idx(minor)	((minor) & (BSG_LIST_SIZE - 1))
@@ -957,14 +958,15 @@ void bsg_unregister_queue(struct request
 	class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
 	bcd->class_dev = NULL;
 	list_del_init(&bcd->list);
+	bsg_device_nr--;
 	mutex_unlock(&bsg_mutex);
 }
 
 int bsg_register_queue(struct request_queue *q, char *name)
 {
-	struct bsg_class_device *bcd;
+	struct bsg_class_device *bcd, *__bcd;
 	dev_t dev;
-	int ret;
+	int ret = -EMFILE;
 	struct class_device *class_dev = NULL;
 
 	/*
@@ -978,10 +980,27 @@ int bsg_register_queue(struct request_qu
 	INIT_LIST_HEAD(&bcd->list);
 
 	mutex_lock(&bsg_mutex);
-	dev = MKDEV(BSG_MAJOR, bsg_device_nr);
-	bcd->minor = bsg_device_nr;
-	bsg_device_nr++;
+	if (bsg_device_nr == BSG_MAX_DEVS) {
+		printk(KERN_ERR "bsg: too many bsg devices\n");
+		goto err;
+	}
+
+retry:
+	list_for_each_entry(__bcd, &bsg_class_list, list) {
+		if (__bcd->minor == bsg_minor_idx) {
+			bsg_minor_idx++;
+			if (bsg_minor_idx == BSG_MAX_DEVS)
+				bsg_minor_idx = 0;
+			goto retry;
+		}
+	}
+
+	bcd->minor = bsg_minor_idx++;
+	if (bsg_minor_idx == BSG_MAX_DEVS)
+		bsg_minor_idx = 0;
+
 	bcd->queue = q;
+	dev = MKDEV(BSG_MAJOR, bcd->minor);
 	class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
@@ -996,11 +1015,11 @@ int bsg_register_queue(struct request_qu
 	}
 
 	list_add_tail(&bcd->list, &bsg_class_list);
+	bsg_device_nr++;
 
 	mutex_unlock(&bsg_mutex);
 	return 0;
 err:
-	bsg_device_nr--;
 	if (class_dev)
 		class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
 	mutex_unlock(&bsg_mutex);
@@ -1030,6 +1049,11 @@ static struct class_interface bsg_intf =
 	.remove	= bsg_remove,
 };
 
+static struct cdev bsg_cdev = {
+	.kobj   = {.name = "bsg", },
+	.owner  = THIS_MODULE,
+};
+
 static int __init bsg_init(void)
 {
 	int ret, i;
@@ -1050,10 +1074,19 @@ static int __init bsg_init(void)
 		return PTR_ERR(bsg_class);
 	}
 
-	ret = register_chrdev(BSG_MAJOR, "bsg", &bsg_fops);
+	ret = register_chrdev_region(MKDEV(BSG_MAJOR, 0), BSG_MAX_DEVS, "bsg");
+	if (ret) {
+		kmem_cache_destroy(bsg_cmd_cachep);
+		class_destroy(bsg_class);
+		return ret;
+	}
+
+	cdev_init(&bsg_cdev, &bsg_fops);
+	ret = cdev_add(&bsg_cdev, MKDEV(BSG_MAJOR, 0), BSG_MAX_DEVS);
 	if (ret) {
 		kmem_cache_destroy(bsg_cmd_cachep);
 		class_destroy(bsg_class);
+		unregister_chrdev_region(MKDEV(BSG_MAJOR, 0), BSG_MAX_DEVS);
 		return ret;
 	}
 
-- 
1.4.3.2

