From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] bsg: make class backlinks
Date: Fri, 20 Jul 2007 18:22:17 -0500
Message-ID: <1184973737.3455.73.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34204 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251AbXGTXWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 19:22:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Currently, bsg doesn't make class backlinks (a process whereby you'd get
a link to bsg in the device directory in the same way you get one for
sg).  This is because the bsg device is uninitialised, so the class
device has nothing it can attach to.  The fix is to make the bsg device
point to the cdevice of the entity creating the bsg, necessitating
changing the bsg_register_queue() prototype into a form that takes the
generic device.

James

Index: BUILD-2.6/block/bsg.c
===================================================================
--- BUILD-2.6.orig/block/bsg.c	2007-07-20 16:51:40.000000000 -0500
+++ BUILD-2.6/block/bsg.c	2007-07-20 17:41:50.000000000 -0500
@@ -936,20 +936,29 @@ void bsg_unregister_queue(struct request
 
 	mutex_lock(&bsg_mutex);
 	sysfs_remove_link(&q->kobj, "bsg");
-	class_device_destroy(bsg_class, MKDEV(bsg_major, bcd->minor));
+	class_device_unregister(bcd->class_dev);
+	put_device(bcd->dev);
 	bcd->class_dev = NULL;
+	bcd->dev = NULL;
 	list_del_init(&bcd->list);
 	bsg_device_nr--;
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
-int bsg_register_queue(struct request_queue *q, const char *name)
+int bsg_register_queue(struct request_queue *q, struct device *gdev,
+		       const char *name)
 {
 	struct bsg_class_device *bcd, *__bcd;
 	dev_t dev;
 	int ret = -EMFILE;
 	struct class_device *class_dev = NULL;
+	const char *devname;
+
+	if (name)
+		devname = name;
+	else
+		devname = gdev->bus_id;
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -982,11 +991,13 @@ retry:
 		bsg_minor_idx = 0;
 
 	bcd->queue = q;
+	bcd->dev = get_device(gdev);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
+	class_dev = class_device_create(bsg_class, NULL, dev, gdev, "%s",
+					devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
-		goto err;
+		goto err_put;
 	}
 	bcd->class_dev = class_dev;
 
@@ -1004,6 +1015,8 @@ retry:
 
 err_unregister:
 	class_device_unregister(class_dev);
+err_put:
+	put_device(gdev);
 err:
 	mutex_unlock(&bsg_mutex);
 	return ret;
Index: BUILD-2.6/include/linux/bsg.h
===================================================================
--- BUILD-2.6.orig/include/linux/bsg.h	2007-07-20 16:53:27.000000000 -0500
+++ BUILD-2.6/include/linux/bsg.h	2007-07-20 17:40:35.000000000 -0500
@@ -57,10 +57,10 @@ struct bsg_class_device {
 	struct request_queue *queue;
 };
 
-extern int bsg_register_queue(struct request_queue *, const char *);
+extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-#define bsg_register_queue(disk, name)		(0)
+#define bsg_register_queue(disk, dev, name)		(0)
 #define bsg_unregister_queue(disk)	do { } while (0)
 #endif
 
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2007-07-20 17:01:27.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2007-07-20 17:44:06.000000000 -0500
@@ -736,7 +736,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
 
-	error = bsg_register_queue(rq, sdev->sdev_gendev.bus_id);
+	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
 
 	if (error)
 		sdev_printk(KERN_INFO, sdev,
Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2007-07-20 17:01:38.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2007-07-20 17:52:15.000000000 -0500
@@ -191,25 +191,34 @@ static void sas_non_host_smp_request(str
 	sas_smp_request(q, rphy_to_shost(rphy), rphy);
 }
 
-static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy,
-			      char *name)
+static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 {
 	struct request_queue *q;
 	int error;
+	struct device *dev;
+	char namebuf[BUS_ID_SIZE];
+	const char *name;
 
 	if (!to_sas_internal(shost->transportt)->f->smp_handler) {
 		printk("%s can't handle SMP requests\n", shost->hostt->name);
 		return 0;
 	}
 
-	if (rphy)
+	if (rphy) {
 		q = blk_init_queue(sas_non_host_smp_request, NULL);
-	else
+		dev = &rphy->dev;
+		name = dev->bus_id;
+	} else {
 		q = blk_init_queue(sas_host_smp_request, NULL);
+		dev = &shost->shost_gendev;
+		snprintf(namebuf, sizeof(namebuf),
+			 "sas_host%d", shost->host_no);
+		name = namebuf;
+	}
 	if (!q)
 		return -ENOMEM;
 
-	error = bsg_register_queue(q, name);
+	error = bsg_register_queue(q, dev, name);
 	if (error) {
 		blk_cleanup_queue(q);
 		return -ENOMEM;
@@ -255,7 +264,6 @@ static int sas_host_setup(struct transpo
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	char name[BUS_ID_SIZE];
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
@@ -263,8 +271,7 @@ static int sas_host_setup(struct transpo
 	sas_host->next_expander_id = 0;
 	sas_host->next_port_id = 0;
 
-	snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
-	if (sas_bsg_initialize(shost, NULL, name))
+	if (sas_bsg_initialize(shost, NULL))
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
@@ -1332,9 +1339,6 @@ struct sas_rphy *sas_end_device_alloc(st
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
-	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
-		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
-
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_end_device_alloc);
@@ -1374,9 +1378,6 @@ struct sas_rphy *sas_expander_alloc(stru
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
-	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
-		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
-
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_expander_alloc);
@@ -1404,6 +1405,9 @@ int sas_rphy_add(struct sas_rphy *rphy)
 		return error;
 	transport_add_device(&rphy->dev);
 	transport_configure_device(&rphy->dev);
+	if (sas_bsg_initialize(shost, rphy))
+		printk("fail to a bsg device %s\n", rphy->dev.bus_id);
+
 
 	mutex_lock(&sas_host->lock);
 	list_add_tail(&rphy->list, &sas_host->rphy_list);


