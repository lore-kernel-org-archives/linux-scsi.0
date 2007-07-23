From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] bsg: use lib/idr.c to find a unique minor number
Date: Mon, 23 Jul 2007 09:33:26 +0900
Message-ID: <20070723093326S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:44106 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763691AbXGWAdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:33:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

This replaces the current linear search for a unique minor number with
lib/idr.c.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |   69 ++++++++++++++++++++++----------------------------
 include/linux/bsg.h |    1 -
 2 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 1ba9bc6..f0259c2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -24,6 +24,7 @@
 #include <linux/cdev.h>
 #include <linux/percpu.h>
 #include <linux/uio.h>
+#include <linux/idr.h>
 #include <linux/bsg.h>
 
 #include <scsi/scsi.h>
@@ -70,13 +71,12 @@ enum {
 #endif
 
 static DEFINE_MUTEX(bsg_mutex);
-static int bsg_device_nr, bsg_minor_idx;
+static DEFINE_IDR(bsg_minor_idr);
 
 #define BSG_LIST_ARRAY_SIZE	8
 static struct hlist_head bsg_device_list[BSG_LIST_ARRAY_SIZE];
 
 static struct class *bsg_class;
-static LIST_HEAD(bsg_class_list);
 static int bsg_major;
 
 static struct kmem_cache *bsg_cmd_cachep;
@@ -781,23 +781,18 @@ static struct bsg_device *__bsg_get_device(int minor)
 
 static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 {
-	struct bsg_device *bd = __bsg_get_device(iminor(inode));
-	struct bsg_class_device *bcd, *__bcd;
+	struct bsg_device *bd;
+	struct bsg_class_device *bcd;
 
+	bd = __bsg_get_device(iminor(inode));
 	if (bd)
 		return bd;
 
 	/*
 	 * find the class device
 	 */
-	bcd = NULL;
 	mutex_lock(&bsg_mutex);
-	list_for_each_entry(__bcd, &bsg_class_list, list) {
-		if (__bcd->minor == iminor(inode)) {
-			bcd = __bcd;
-			break;
-		}
-	}
+	bcd = idr_find(&bsg_minor_idr, iminor(inode));
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
@@ -936,13 +931,12 @@ void bsg_unregister_queue(struct request_queue *q)
 		return;
 
 	mutex_lock(&bsg_mutex);
+	idr_remove(&bsg_minor_idr, bcd->minor);
 	sysfs_remove_link(&q->kobj, "bsg");
 	class_device_unregister(bcd->class_dev);
 	put_device(bcd->dev);
 	bcd->class_dev = NULL;
 	bcd->dev = NULL;
-	list_del_init(&bcd->list);
-	bsg_device_nr--;
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
@@ -950,9 +944,9 @@ EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 int bsg_register_queue(struct request_queue *q, struct device *gdev,
 		       const char *name)
 {
-	struct bsg_class_device *bcd, *__bcd;
+	struct bsg_class_device *bcd;
 	dev_t dev;
-	int ret = -EMFILE;
+	int ret, minor;
 	struct class_device *class_dev = NULL;
 	const char *devname;
 
@@ -969,28 +963,26 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 
 	bcd = &q->bsg_dev;
 	memset(bcd, 0, sizeof(*bcd));
-	INIT_LIST_HEAD(&bcd->list);
 
 	mutex_lock(&bsg_mutex);
-	if (bsg_device_nr == BSG_MAX_DEVS) {
-		printk(KERN_ERR "bsg: too many bsg devices\n");
-		goto err;
-	}
 
-retry:
-	list_for_each_entry(__bcd, &bsg_class_list, list) {
-		if (__bcd->minor == bsg_minor_idx) {
-			bsg_minor_idx++;
-			if (bsg_minor_idx == BSG_MAX_DEVS)
-				bsg_minor_idx = 0;
-			goto retry;
-		}
+	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
+	if (!ret) {
+		ret = -ENOMEM;
+		goto unlock;
 	}
 
-	bcd->minor = bsg_minor_idx++;
-	if (bsg_minor_idx == BSG_MAX_DEVS)
-		bsg_minor_idx = 0;
+	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
+	if (ret < 0)
+		goto unlock;
 
+	if (minor >= BSG_MAX_DEVS) {
+		printk(KERN_ERR "bsg: too many bsg devices\n");
+		ret = -EINVAL;
+		goto remove_idr;
+	}
+
+	bcd->minor = minor;
 	bcd->queue = q;
 	bcd->dev = get_device(gdev);
 	dev = MKDEV(bsg_major, bcd->minor);
@@ -998,27 +990,26 @@ retry:
 					devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
-		goto err_put;
+		goto put_dev;
 	}
 	bcd->class_dev = class_dev;
 
 	if (q->kobj.sd) {
 		ret = sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg");
 		if (ret)
-			goto err_unregister;
+			goto unregister_class_dev;
 	}
 
-	list_add_tail(&bcd->list, &bsg_class_list);
-	bsg_device_nr++;
-
 	mutex_unlock(&bsg_mutex);
 	return 0;
 
-err_unregister:
+unregister_class_dev:
 	class_device_unregister(class_dev);
-err_put:
+put_dev:
 	put_device(gdev);
-err:
+remove_idr:
+	idr_remove(&bsg_minor_idr, minor);
+unlock:
 	mutex_unlock(&bsg_mutex);
 	return ret;
 }
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index f415f89..241eed0 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -53,7 +53,6 @@ struct bsg_class_device {
 	struct class_device *class_dev;
 	struct device *dev;
 	int minor;
-	struct list_head list;
 	struct request_queue *queue;
 };
 
-- 
1.5.2.4

