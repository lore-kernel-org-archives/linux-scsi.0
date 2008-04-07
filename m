From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_sas: fix the lifetime of bsg queues
Date: Mon, 07 Apr 2008 11:06:47 +0900
Message-ID: <20080407110647F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59430 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYDGCHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2008 22:07:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

We call blk_cleanup_queue too early for bsg queues for SAS. If we hold
a sas_host device (end_device or expander) open, remove the device,
then send a request to it, we get a kernel crash. This bug is similar
to the lifetime of bsg for scsi devices that Pete reported.

We need to call blk_cleanup_queue in the release function as we do
with scsi devices.

It's easy to fix end_device and expander since they have the release
function (we can just move blk_cleanup_queue to sas_expander_release
and sas_end_device_release from sas_bsg_remove).

A sas_host device doesn't have the release function; struct
sas_host_attrs is freed with scsi_host in scsi_host_dev_release. The
probleme is that scsi_host_dev_release can't do transport specific
stuff.

This patch creates sas_host_release by adding struct device to struct
sas_host_attrs. This necessitates changing the bsg_register_queue()
prototype to take two pointers to struct device. bsg holds a ref to
one and passes another to class_device_create since sas_host_attrs's
device isn't registered in sysfs so it can't be passed to
class_device_create.

Another possible solution is adding to a release hook to
scsi_transport_template and scsi_host_dev_release calls it. Probably,
it's more simple though the hook will not be useful for non SAS
transports.

This patch against scsi-post-merge with bsg fixes for scsi devices:

http://marc.info/?l=linux-scsi&m=120692552424155&w=2


===
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_sas: fix the lifetime of bsg queues

We call blk_cleanup_queue too early for bsg queues. If we hold a
sas_host device (end_device, or expander) open, remove the device,
then send a request to it, we get a kernel crash.

We need to call blk_cleanup_queue in the release function as we do
with scsi devices.

This patch moves blk_cleanup_queue to sas_expander_release and
sas_end_device_release from sas_bsg_remove.

This patch also creates sas_host_release by adding struct device to
struct sas_host_attrs. This necessitates changing the
bsg_register_queue() prototype to take two pointers to struct
device. bsg holds a ref to one and passes another to
class_device_create since sas_host_attrs's device isn't registered in
sysfs so it can't be passed to class_device_create.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c                       |   11 +++++---
 drivers/scsi/scsi_sysfs.c         |    2 +-
 drivers/scsi/scsi_transport_sas.c |   54 ++++++++++++++++++++++++++++++------
 include/linux/bsg.h               |    7 +++-
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f61d9d4..eedfb0d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -947,8 +947,8 @@ void bsg_unregister_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
-int bsg_register_queue(struct request_queue *q, struct device *gdev,
-		       const char *name)
+int bsg_register_queue(struct request_queue *q, struct device *parent,
+		       struct device *gdev, const char *name)
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
@@ -956,10 +956,13 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 	struct device *class_dev = NULL;
 	const char *devname;
 
+	if (!gdev)
+		gdev = parent;
+
 	if (name)
 		devname = name;
 	else
-		devname = gdev->bus_id;
+		devname = parent->bus_id;
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -992,7 +995,7 @@ int bsg_register_queue(struct request_queue *q, struct device *gdev,
 	bcd->queue = q;
 	bcd->dev = get_device(gdev);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create(bsg_class, gdev, dev, "%s", devname);
+	class_dev = device_create(bsg_class, parent, dev, "%s", devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
 		goto put_dev;
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
index 27ec625..5ee1a85 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -43,6 +43,7 @@ struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
 	struct request_queue *q;
+	struct device sas_host_dev;
 	u32 next_target_id;
 	u32 next_expander_id;
 	int next_port_id;
@@ -192,11 +193,24 @@ static void sas_non_host_smp_request(struct request_queue *q)
 	sas_smp_request(q, rphy_to_shost(rphy), rphy);
 }
 
+static void sas_host_release(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	struct request_queue *q = sas_host->q;
+
+	if (q) {
+		blk_cleanup_queue(q);
+		put_device(dev->parent);
+	}
+}
+
 static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 {
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct request_queue *q;
 	int error;
-	struct device *dev;
+	struct device *parent, *dev = NULL;
 	char namebuf[BUS_ID_SIZE];
 	const char *name;
 
@@ -207,22 +221,32 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 	if (rphy) {
 		q = blk_init_queue(sas_non_host_smp_request, NULL);
-		dev = &rphy->dev;
-		name = dev->bus_id;
+
+		parent = &rphy->dev;
+		name = parent->bus_id;
 	} else {
 		q = blk_init_queue(sas_host_smp_request, NULL);
-		dev = &shost->shost_gendev;
+
+		parent = &shost->shost_gendev;
+		dev = &sas_host->sas_host_dev;
+		device_initialize(dev);
+		dev->parent = get_device(&shost->shost_gendev);
+		dev->release = sas_host_release;
+
 		snprintf(namebuf, sizeof(namebuf),
 			 "sas_host%d", shost->host_no);
 		name = namebuf;
 	}
-	if (!q)
-		return -ENOMEM;
 
-	error = bsg_register_queue(q, dev, name);
+	if (!q) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = bsg_register_queue(q, parent, dev, name);
 	if (error) {
 		blk_cleanup_queue(q);
-		return -ENOMEM;
+		goto out;
 	}
 
 	if (rphy)
@@ -238,6 +262,11 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	set_bit(QUEUE_FLAG_BIDI, &q->queue_flags);
 
 	return 0;
+out:
+	if (dev)
+		put_device(dev->parent);
+
+	return error;
 }
 
 static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
@@ -253,7 +282,6 @@ static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		return;
 
 	bsg_unregister_queue(q);
-	blk_cleanup_queue(q);
 }
 
 /*
@@ -283,8 +311,10 @@ static int sas_host_remove(struct transport_container *tc, struct device *dev,
 			   struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
 	sas_bsg_remove(shost, NULL);
+	put_device(&sas_host->sas_host_dev);
 
 	return 0;
 }
@@ -1301,6 +1331,9 @@ static void sas_expander_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
+	if (rphy->q)
+		blk_cleanup_queue(rphy->q);
+
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1310,6 +1343,9 @@ static void sas_end_device_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_end_device *edev = rphy_to_end_device(rphy);
 
+	if (rphy->q)
+		blk_cleanup_queue(rphy->q);
+
 	put_device(dev->parent);
 	kfree(edev);
 }
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index e8406c5..67e37b9 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -61,10 +61,13 @@ struct bsg_class_device {
 	struct request_queue *queue;
 };
 
-extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
+extern int bsg_register_queue(struct request_queue *, struct device *,
+			      struct device *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-static inline int bsg_register_queue(struct request_queue * rq, struct device *dev, const char *name)
+static inline int bsg_register_queue(struct request_queue *rq,
+				     struct device *parent, struct device *dev,
+				     const char *name)
 {
 	return 0;
 }
-- 
1.5.3.6

