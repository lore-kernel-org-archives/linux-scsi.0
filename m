From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] bsg: add release callback support
Date: Sat, 19 Apr 2008 00:43:14 +0900
Message-ID: <1208533395-31610-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1208533395-31610-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52914 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbYDRPoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:44:09 -0400
In-Reply-To: <1208533395-31610-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This patch adds release callback support, which is called when a bsg
device goes away. bsg_register_queue() takes a pointer to a callback
function. This feature is useful for stuff like sas_host that can't
use the release callback in struct device.

If a caller doesn't need bsg's release callback, it can call
bsg_register_queue() with NULL pointer (e.g. scsi devices can use
release callback in struct device so they don't need bsg's callback).

With this patch, bsg uses kref for refcounts on bsg devices instead of
get/put_device in fops->open/release. bsg calls put_device and the
caller's release callback (if it was registered) in kref_put's
release.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c                       |   43 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c         |    2 +-
 drivers/scsi/scsi_transport_sas.c |    2 +-
 include/linux/bsg.h               |   14 ++++++++---
 4 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f51172e..23ea4fd 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -699,14 +699,26 @@ static struct bsg_device *bsg_alloc_device(void)
 	return bd;
 }
 
+static void bsg_kref_release_function(struct kref *kref)
+{
+	struct bsg_class_device *bcd =
+		container_of(kref, struct bsg_class_device, ref);
+
+	if (bcd->release)
+		bcd->release(bcd->parent);
+
+	put_device(bcd->parent);
+}
+
 static int bsg_put_device(struct bsg_device *bd)
 {
-	int ret = 0;
-	struct device *dev = bd->queue->bsg_dev.dev;
+	int ret = 0, do_free;
+	struct request_queue *q = bd->queue;
 
 	mutex_lock(&bsg_mutex);
 
-	if (!atomic_dec_and_test(&bd->ref_count))
+	do_free = atomic_dec_and_test(&bd->ref_count);
+	if (!do_free)
 		goto out;
 
 	dprintk("%s: tearing down\n", bd->name);
@@ -723,12 +735,13 @@ static int bsg_put_device(struct bsg_device *bd)
 	 */
 	ret = bsg_complete_all_commands(bd);
 
-	blk_put_queue(bd->queue);
 	hlist_del(&bd->dev_list);
 	kfree(bd);
 out:
 	mutex_unlock(&bsg_mutex);
-	put_device(dev);
+	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
+	if (do_free)
+		blk_put_queue(q);
 	return ret;
 }
 
@@ -796,7 +809,7 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
 	if (bcd)
-		get_device(bcd->dev);
+		kref_get(&bcd->ref);
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
@@ -808,7 +821,7 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 
 	bd = bsg_add_device(inode, bcd->queue, file);
 	if (IS_ERR(bd))
-		put_device(bcd->dev);
+		kref_put(&bcd->ref, bsg_kref_release_function);
 
 	return bd;
 }
@@ -947,14 +960,14 @@ void bsg_unregister_queue(struct request_queue *q)
 	idr_remove(&bsg_minor_idr, bcd->minor);
 	sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
-	put_device(bcd->dev);
 	bcd->class_dev = NULL;
+	kref_put(&bcd->ref, bsg_kref_release_function);
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
-int bsg_register_queue(struct request_queue *q, struct device *gdev,
-		       const char *name)
+int bsg_register_queue(struct request_queue *q, struct device *parent,
+		       const char *name, void (*release)(struct device *))
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
@@ -965,7 +978,7 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 	if (name)
 		devname = name;
 	else
-		devname = gdev->bus_id;
+		devname = parent->bus_id;
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -996,9 +1009,11 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 
 	bcd->minor = minor;
 	bcd->queue = q;
-	bcd->dev = get_device(gdev);
+	bcd->parent = get_device(parent);
+	bcd->release = release;
+	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create(bsg_class, gdev, dev, "%s", devname);
+	class_dev = device_create(bsg_class, parent, dev, "%s", devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
 		goto put_dev;
@@ -1017,7 +1032,7 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 unregister_class_dev:
 	device_unregister(class_dev);
 put_dev:
-	put_device(gdev);
+	put_device(parent);
 remove_idr:
 	idr_remove(&bsg_minor_idr, minor);
 unlock:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 198aa45..049103f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -889,7 +889,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		goto out;
 	}
 
-	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
+	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
 	if (error)
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 27ec625..94ff29f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -219,7 +219,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	if (!q)
 		return -ENOMEM;
 
-	error = bsg_register_queue(q, dev, name);
+	error = bsg_register_queue(q, dev, name, NULL);
 	if (error) {
 		blk_cleanup_queue(q);
 		return -ENOMEM;
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index e8406c5..cf0303a 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -56,19 +56,25 @@ struct sg_io_v4 {
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
 	struct device *class_dev;
-	struct device *dev;
+	struct device *parent;
 	int minor;
 	struct request_queue *queue;
+	struct kref ref;
+	void (*release)(struct device *);
 };
 
-extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
+extern int bsg_register_queue(struct request_queue *q,
+			      struct device *parent, const char *name,
+			      void (*release)(struct device *));
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-static inline int bsg_register_queue(struct request_queue * rq, struct device *dev, const char *name)
+static inline int bsg_register_queue(struct request_queue *q,
+				     struct device *parent, const char *name,
+				     void (*release)(struct device *))
 {
 	return 0;
 }
-static inline void bsg_unregister_queue(struct request_queue *rq)
+static inline void bsg_unregister_queue(struct request_queue *q)
 {
 }
 #endif
-- 
1.5.3.4

