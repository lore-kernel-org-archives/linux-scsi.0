From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi device ref count (update)
Date: Thu, 20 Nov 2003 23:38:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121073825.GA1281@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:56531 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264320AbTKUHdy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 02:33:54 -0500
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e34.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id hAL7XrK5339300
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 02:33:53 -0500
Received: from dyn9-47-17-195 (sig-9-65-33-52.mts.ibm.com [9.65.33.52])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAL7XfBj208996
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 00:33:52 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against scsi-bugfixes-2.6. I updated it based on comments
received. It breaks up the reference count initialization for scsi_device
and restores calling slave_destroy for all scsi_devices configured or
not. I ran a small regression using the scsi_debug, aic7xxx, and qla2xxx
driver. I also had a debug patch for more verbose kobject cleanup and
patch for a badness check on atomic_dec going negative (previously
provided by Linus).

The object cleanup appears to being functioning correctly. I only saw
previously reported badness output:
	- Synchronizing SCSI cache fails on cleanup.
	- scsi_debug.c missing release (I believe Doug posted a patch)
	- aic7xxx warnings on rmmod due to ahc_platform_free calling
	  scsi_remove_host with ahc_list_lock held.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This patch splits the scsi device struct device register into init and
add. It also addresses memory leak issues of not calling slave_destroy
on scsi_devices that are not configured in.

Details:
* Make scsi_device_dev_release extern for scsi_scan to use in
alloc_sdev.
* Move scsi_free_sdev code to scsi_device_dev_release. Have
previous callers of scsi_free_sdev call slave_destroy plus put_device.
* Changed name of scsi_device_register to scsi_sysfs_add_sdev to
match host call and align with split struct device init.
* Move sdev_gendev device and class init to scsi_alloc_sdev.

Thu Nov 20 22:56:11 PST 2003
EDESC


 drivers/scsi/scsi_priv.h  |    4 +-
 drivers/scsi/scsi_scan.c  |   63 +++++++++++++++++++++-------------------------
 drivers/scsi/scsi_sysfs.c |   58 ++++++++++++++++++++++--------------------
 3 files changed, 62 insertions(+), 63 deletions(-)

diff -puN drivers/scsi/scsi_priv.h~sdev_ldm_reg drivers/scsi/scsi_priv.h
--- scsi-bugfixes-2.6/drivers/scsi/scsi_priv.h~sdev_ldm_reg	Thu Nov 20 21:34:55 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_priv.h	Thu Nov 20 21:34:55 2003
@@ -130,7 +130,6 @@ extern void scsi_exit_procfs(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
-extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysctl.c */
@@ -143,7 +142,8 @@ extern void scsi_exit_sysctl(void);
 #endif /* CONFIG_SYSCTL */
 
 /* scsi_sysfs.c */
-extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_dev_release(struct device *);
+extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
diff -puN drivers/scsi/scsi_scan.c~sdev_ldm_reg drivers/scsi/scsi_scan.c
--- scsi-bugfixes-2.6/drivers/scsi/scsi_scan.c~sdev_ldm_reg	Thu Nov 20 21:34:55 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_scan.c	Thu Nov 20 21:34:55 2003
@@ -236,6 +236,25 @@ static struct scsi_device *scsi_alloc_sd
 			goto out_free_queue;
 	}
 
+	if (get_device(&sdev->host->shost_gendev)) {
+
+		device_initialize(&sdev->sdev_gendev);
+		sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
+		sdev->sdev_gendev.bus = &scsi_bus_type;
+		sdev->sdev_gendev.release = scsi_device_dev_release;
+		sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+			sdev->host->host_no, sdev->channel, sdev->id,
+			sdev->lun);
+
+		class_device_initialize(&sdev->sdev_classdev);
+		sdev->sdev_classdev.dev = &sdev->sdev_gendev;
+		sdev->sdev_classdev.class = &sdev_class;
+		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
+	} else
+		goto out_free_queue;
+
 	/*
 	 * If there are any same target siblings, add this to the
 	 * sibling list
@@ -273,36 +292,6 @@ out:
 }
 
 /**
- * scsi_free_sdev - cleanup and free a scsi_device
- * @sdev:	cleanup and free this scsi_device
- *
- * Description:
- *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
- *     the list, and freeing @sdev.
- **/
-void scsi_free_sdev(struct scsi_device *sdev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-
-	if (sdev->request_queue)
-		scsi_free_queue(sdev->request_queue);
-
-	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->starved_entry);
-	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
-		kfree(sdev->sdev_target);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-
-	kfree(sdev->inquiry);
-	kfree(sdev);
-}
-
-/**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sreq:	used to send the INQUIRY
  * @inq_result:	area to store the INQUIRY result
@@ -642,7 +631,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	scsi_device_register(sdev);
+	scsi_sysfs_add_sdev(sdev);
 
 	return SCSI_SCAN_LUN_PRESENT;
 }
@@ -748,8 +737,11 @@ static int scsi_probe_and_add_lun(struct
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp)
 			*sdevp = sdev;
-	} else
-		scsi_free_sdev(sdev);
+	} else {
+		if (sdev->host->hostt->slave_destroy)
+			sdev->host->hostt->slave_destroy(sdev);
+		put_device(&sdev->sdev_gendev);
+	}
  out:
 	return res;
 }
@@ -1301,5 +1293,8 @@ struct scsi_device *scsi_get_host_dev(st
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
-	scsi_free_sdev(sdev);
+
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	put_device(&sdev->sdev_gendev);
 }
diff -puN drivers/scsi/scsi_sysfs.c~sdev_ldm_reg drivers/scsi/scsi_sysfs.c
--- scsi-bugfixes-2.6/drivers/scsi/scsi_sysfs.c~sdev_ldm_reg	Thu Nov 20 21:34:55 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_sysfs.c	Thu Nov 20 21:38:09 2003
@@ -115,14 +115,29 @@ static void scsi_device_cls_release(stru
 	put_device(&sdev->sdev_gendev);
 }
 
-static void scsi_device_dev_release(struct device *dev)
+void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdev;
 	struct device *parent;
+	unsigned long flags;
 
 	parent = dev->parent;
 	sdev = to_scsi_device(dev);
-	scsi_free_sdev(sdev);
+
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del(&sdev->siblings);
+	list_del(&sdev->same_target_siblings);
+	list_del(&sdev->starved_entry);
+	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
+		kfree(sdev->sdev_target);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+
+	if (sdev->request_queue)
+		scsi_free_queue(sdev->request_queue);
+
+	kfree(sdev->inquiry);
+	kfree(sdev);
+
 	put_device(parent);
 }
 
@@ -321,29 +336,18 @@ static int attr_add(struct device *dev, 
 }
 
 /**
- * scsi_device_register - register a scsi device with the scsi bus
- * @sdev:	scsi_device to register
+ * scsi_sysfs_add_sdev - add scsi device to sysfs
+ * @sdev:	scsi_device to add
  *
  * Return value:
  * 	0 on Success / non-zero on Failure
  **/
-int scsi_device_register(struct scsi_device *sdev)
+int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	int error = 0, i;
+	int error = -EINVAL, i;
 
-	set_bit(SDEV_ADD, &sdev->sdev_state);
-	device_initialize(&sdev->sdev_gendev);
-	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
-	sdev->sdev_gendev.bus = &scsi_bus_type;
-	sdev->sdev_gendev.release = scsi_device_dev_release;
-
-	class_device_initialize(&sdev->sdev_classdev);
-	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
-	sdev->sdev_classdev.class = &sdev_class;
-	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE, "%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	if (test_and_set_bit(SDEV_ADD, &sdev->sdev_state))
+		return error;
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
@@ -351,8 +355,6 @@ int scsi_device_register(struct scsi_dev
 		return error;
 	}
 
-	get_device(sdev->sdev_gendev.parent);
-
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
@@ -396,12 +398,14 @@ clean_device:
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	class_device_unregister(&sdev->sdev_classdev);
-	set_bit(SDEV_DEL, &sdev->sdev_state);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	device_del(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	if (test_and_clear_bit(SDEV_ADD, &sdev->sdev_state)) {
+		set_bit(SDEV_DEL, &sdev->sdev_state);
+		class_device_unregister(&sdev->sdev_classdev);
+		device_del(&sdev->sdev_gendev);
+		if (sdev->host->hostt->slave_destroy)
+			sdev->host->hostt->slave_destroy(sdev);
+		put_device(&sdev->sdev_gendev);
+	}
 }
 
 int scsi_register_driver(struct device_driver *drv)

_

