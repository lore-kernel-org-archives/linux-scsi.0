From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] exposing the sdev_target in sysfs
Date: 03 Sep 2004 19:40:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094254851.1712.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50602 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269982AbUICXkw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2004 19:40:52 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i83NepJ01000
	for <linux-scsi@vger.kernel.org>; Fri, 3 Sep 2004 19:40:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The aim of this patch is to give us somewhere to hang the per target
timer that emulex needs.

However, it will break the current sysfs layout.  devices will now
appear something like this:

lrwxrwxrwx  1 root root 0 Sep  3 18:31
/sys/class/scsi_device/0:0:5:0/device ->
../../../devices/parisc8/parisc8:0/pci0000:00/0000:00:13.0/host0/target0:0:5/0:0:5:0

(note the extra target0:0:5 in there).

which may break some of the user land tools (although you're all using
the scsi class interface to access your devices, aren't you? in which
case you won't notice any problems).

Comments welcome.

James

===== drivers/scsi/scsi_lib.c 1.131 vs edited =====
--- 1.131/drivers/scsi/scsi_lib.c	2004-08-25 11:21:41 -05:00
+++ edited/drivers/scsi/scsi_lib.c	2004-09-03 16:54:22 -05:00
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
 
===== drivers/scsi/scsi_priv.h 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi_priv.h	2004-06-16 10:45:44 -05:00
+++ edited/drivers/scsi/scsi_priv.h	2004-09-03 16:50:41 -05:00
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
===== drivers/scsi/scsi_scan.c 1.128 vs edited =====
--- 1.128/drivers/scsi/scsi_scan.c	2004-08-22 20:06:22 -05:00
+++ edited/drivers/scsi/scsi_scan.c	2004-09-03 18:18:58 -05:00
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
@@ -612,40 +586,12 @@
 	if (*bflags & BLIST_NOSTARTONADD)
 		sdev->no_start_on_add = 1;
 
-	/*
-	 * If we need to allow I/O to only one of the luns attached to
-	 * this target id at a time set single_lun, and allocate or modify
-	 * sdev_target.
-	 */
-	if (*bflags & BLIST_SINGLELUN) {
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
 
===== drivers/scsi/scsi_sysfs.c 1.52 vs edited =====
--- 1.52/drivers/scsi/scsi_sysfs.c	2004-07-28 22:59:10 -05:00
+++ edited/drivers/scsi/scsi_sysfs.c	2004-09-03 18:32:46 -05:00
@@ -158,11 +158,14 @@
 	sdev = to_scsi_device(dev);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
+	/* If we're the last LUN on the target, destroy the target */
+	if (list_empty(&sdev->same_target_siblings) && parent) {
+		device_del(parent);
+		put_device(parent);
+	}
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
-	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
-		kfree(sdev->sdev_target);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	if (sdev->request_queue)
@@ -171,7 +174,8 @@
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-	put_device(parent);
+	if (parent)
+		put_device(parent);
 }
 
 struct class sdev_class = {
@@ -430,6 +434,14 @@
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
@@ -447,6 +459,7 @@
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
+		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
@@ -626,6 +639,79 @@
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
+		struct device *dev;
+		int error;
+
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
+		dev->bus = &scsi_bus_type;
+		dev->release = scsi_target_dev_release;
+		sprintf(dev->bus_id, "target%d:%d:%d",
+			sdev->host->host_no, sdev->channel, sdev->id);
+		if ((error = device_add(dev))) {
+			spin_unlock_irqrestore(sdev->host->host_lock, flags);
+			printk(KERN_ERR "Target device_add failed\n");
+			return error;
+		}
+	}
+	get_device(&starget->dev);
+	sdev->sdev_gendev.parent = &starget->dev;
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	return 0;
 }
 



