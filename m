From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] exposing sdev_target in sysfs
Date: 06 Sep 2004 10:36:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094481378.1761.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2237 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268079AbUIFOgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 10:36:22 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i86EaIJ15557
	for <linux-scsi@vger.kernel.org>; Mon, 6 Sep 2004 10:36:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

OK, following the feedback this is the latest incarnation of the patch
(I fixed a few other sleeping in irq context problems as well).

I've tested this adding and removing luns from a 16 lun array; it seems
to be robust.

James

diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Sep  6 09:27:44 2004
+++ b/drivers/scsi/scsi_lib.c	Mon Sep  6 09:27:44 2004
@@ -365,7 +365,7 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	current_sdev->sdev_target->starget_sdev_user = NULL;
+	scsi_target(current_sdev)->starget_sdev_user = NULL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
@@ -377,7 +377,7 @@
 	blk_run_queue(current_sdev->request_queue);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (current_sdev->sdev_target->starget_sdev_user)
+	if (scsi_target(current_sdev)->starget_sdev_user)
 		goto out;
 	list_for_each_entry_safe(sdev, tmp, &current_sdev->same_target_siblings,
 			same_target_siblings) {
@@ -1247,10 +1247,10 @@
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
 		if (sdev->single_lun) {
-			if (sdev->sdev_target->starget_sdev_user &&
-			    sdev->sdev_target->starget_sdev_user != sdev)
+			if (scsi_target(sdev)->starget_sdev_user &&
+			    scsi_target(sdev)->starget_sdev_user != sdev)
 				goto not_ready;
-			sdev->sdev_target->starget_sdev_user = sdev;
+			scsi_target(sdev)->starget_sdev_user = sdev;
 		}
 		shost->host_busy++;
 
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Sep  6 09:27:44 2004
+++ b/drivers/scsi/scsi_priv.h	Mon Sep  6 09:27:44 2004
@@ -65,9 +65,15 @@
  */
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
-	unsigned int		starget_refcnt;
+	struct device		dev;
 };
 
+#define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
+static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
+{
+	return to_scsi_target(sdev->sdev_gendev.parent);
+}
+
 /* hosts.c */
 extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
@@ -156,6 +162,8 @@
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
+extern int scsi_sysfs_device_initialize(struct scsi_device *);
+extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 
 extern struct class sdev_class;
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Sep  6 09:27:44 2004
+++ b/drivers/scsi/scsi_scan.c	Mon Sep  6 09:27:44 2004
@@ -261,30 +261,8 @@
 			goto out_cleanup_slave;
 	}
 
-	if (get_device(&sdev->host->shost_gendev)) {
-
-		device_initialize(&sdev->sdev_gendev);
-		sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
-		sdev->sdev_gendev.bus = &scsi_bus_type;
-		sdev->sdev_gendev.release = scsi_device_dev_release;
-		sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-			sdev->host->host_no, sdev->channel, sdev->id,
-			sdev->lun);
-
-		class_device_initialize(&sdev->sdev_classdev);
-		sdev->sdev_classdev.dev = &sdev->sdev_gendev;
-		sdev->sdev_classdev.class = &sdev_class;
-		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
-			 "%d:%d:%d:%d", sdev->host->host_no,
-			 sdev->channel, sdev->id, sdev->lun);
-
-		class_device_initialize(&sdev->transport_classdev);
-		sdev->transport_classdev.dev = &sdev->sdev_gendev;
-		sdev->transport_classdev.class = sdev->host->transportt->class;
-		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
-			 "%d:%d:%d:%d", sdev->host->host_no,
-			 sdev->channel, sdev->id, sdev->lun);
-	} else
+	if (get_device(&sdev->host->shost_gendev) == NULL ||
+	    scsi_sysfs_device_initialize(sdev) != 0)
 		goto out_cleanup_transport;
 
 	/*
@@ -500,10 +478,6 @@
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
-	struct scsi_device *sdev_sibling;
-	struct scsi_target *starget;
-	unsigned long flags;
-
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -612,40 +586,14 @@
 	if (*bflags & BLIST_NOSTARTONADD)
 		sdev->no_start_on_add = 1;
 
-	/*
-	 * If we need to allow I/O to only one of the luns attached to
-	 * this target id at a time set single_lun, and allocate or modify
-	 * sdev_target.
-	 */
-	if (*bflags & BLIST_SINGLELUN) {
+	/* NOTE: this target initialisation code depends critically on
+	 * lun scanning being sequential. */
+	if(scsi_sysfs_target_initialize(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
+	if (*bflags & BLIST_SINGLELUN)
 		sdev->single_lun = 1;
-		spin_lock_irqsave(sdev->host->host_lock, flags);
-		starget = NULL;
-		/*
-		 * Search for an existing target for this sdev.
-		 */
-		list_for_each_entry(sdev_sibling, &sdev->same_target_siblings,
-				    same_target_siblings) {
-			if (sdev_sibling->sdev_target != NULL) {
-				starget = sdev_sibling->sdev_target;
-				break;
-			}
-		}
-		if (!starget) {
-			starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
-			if (!starget) {
-				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-				spin_unlock_irqrestore(sdev->host->host_lock,
-						       flags);
-				return SCSI_SCAN_NO_RESPONSE;
-			}
-			starget->starget_refcnt = 0;
-			starget->starget_sdev_user = NULL;
-		}
-		starget->starget_refcnt++;
-		sdev->sdev_target = starget;
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
-	}
+
 
 	sdev->use_10_for_rw = 1;
 
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Mon Sep  6 09:27:44 2004
+++ b/drivers/scsi/scsi_sysfs.c	Mon Sep  6 09:27:44 2004
@@ -153,25 +153,31 @@
 	struct scsi_device *sdev;
 	struct device *parent;
 	unsigned long flags;
+	int delete;
 
 	parent = dev->parent;
 	sdev = to_scsi_device(dev);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
+	/* If we're the last LUN on the target, destroy the target */
+	delete = (list_empty(&sdev->same_target_siblings) && parent);
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
-	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
-		kfree(sdev->sdev_target);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
+	if (delete) {
+		device_del(parent);
+		put_device(parent);
+	}
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
 
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-	put_device(parent);
+	if (parent)
+		put_device(parent);
 }
 
 struct class sdev_class = {
@@ -430,6 +436,14 @@
 	return device_create_file(dev, attr);
 }
 
+static void scsi_target_dev_release(struct device *dev)
+{
+	struct scsi_target *starget = to_scsi_target(dev);
+	struct device *parent = dev->parent;
+	kfree(starget);
+	put_device(parent);
+}
+
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -447,6 +461,7 @@
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
+		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
@@ -626,6 +641,76 @@
 		}
 	}
 
+	return 0;
+}
+
+int scsi_sysfs_device_initialize(struct scsi_device *sdev)
+{
+	device_initialize(&sdev->sdev_gendev);
+	sdev->sdev_gendev.bus = &scsi_bus_type;
+	sdev->sdev_gendev.release = scsi_device_dev_release;
+	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+		sdev->host->host_no, sdev->channel, sdev->id,
+		sdev->lun);
+	
+	class_device_initialize(&sdev->sdev_classdev);
+	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
+	sdev->sdev_classdev.class = &sdev_class;
+	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
+		 "%d:%d:%d:%d", sdev->host->host_no,
+		 sdev->channel, sdev->id, sdev->lun);
+
+	class_device_initialize(&sdev->transport_classdev);
+	sdev->transport_classdev.dev = &sdev->sdev_gendev;
+	sdev->transport_classdev.class = sdev->host->transportt->class;
+	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+		 "%d:%d:%d:%d", sdev->host->host_no,
+		 sdev->channel, sdev->id, sdev->lun);
+	return 0;
+}
+
+int scsi_sysfs_target_initialize(struct scsi_device *sdev)
+{
+	struct scsi_target *starget = NULL;
+	struct scsi_device *sdev_sibling;
+	struct device *dev = NULL;
+	int error;
+	unsigned long flags;
+
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	/*
+	 * Search for an existing target for this sdev.
+	 */
+	list_for_each_entry(sdev_sibling, &sdev->same_target_siblings,
+			    same_target_siblings) {
+		if (sdev_sibling->sdev_gendev.parent != NULL) {
+			starget = scsi_target(sdev_sibling);
+			break;
+		}
+	}
+	if (!starget) {
+		starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
+		if (!starget) {
+			printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+			spin_unlock_irqrestore(sdev->host->host_lock,
+					       flags);
+			return -ENOMEM;
+		}
+		memset(starget, 0, sizeof(*starget));
+		dev = &starget->dev;
+		device_initialize(dev);
+		dev->parent = &sdev->host->shost_gendev;
+		dev->release = scsi_target_dev_release;
+		sprintf(dev->bus_id, "target%d:%d:%d",
+			sdev->host->host_no, sdev->channel, sdev->id);
+	}
+	get_device(&starget->dev);
+	sdev->sdev_gendev.parent = &starget->dev;
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	if (dev && (error = device_add(dev))) {
+		printk(KERN_ERR "Target device_add failed\n");
+		return error;
+	}
 	return 0;
 }
 

