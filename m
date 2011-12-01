From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH v3 4/4] scsi_dh: code cleanup and remove the references to scsi_dev_info
Date: Thu, 1 Dec 2011 15:03:12 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910AB8F96@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:35417 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1LAUDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 15:03:19 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, hare@suse.de, Mike Snitzer <snitzer@redhat.com>, JBottomley@Parallels.com

This has the latest comment from Mike Snitzer.. Everything else is as before..

All the handlers have implemented the match function(look at patch 1, 2, 3).
We don't need to use scsi_dev_info any more for matching purposes.
Cleaning up the scsi_dh code.

FYI..
Match function was originally implemented by this 

http://www.spinics.net/lists/linux-scsi/msg54284.html
or
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=6c3633d08acf514e2e89aa95d2346ce9d64d719a

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---

diff -uprN -X linux-3.2-rc2/Documentation/dontdiff linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh.c linux-3.2-rc2-new/drivers/scsi/device_handler/scsi_dh.c
--- linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh.c	2011-11-15 11:02:59.000000000 -0600
+++ linux-3.2-rc2-new/drivers/scsi/device_handler/scsi_dh.c	2011-11-19 10:57:56.000000000 -0600
@@ -28,7 +28,6 @@
 
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
-static int scsi_dh_list_idx = 1;
 
 static struct scsi_device_handler *get_device_handler(const char *name)
 {
@@ -45,21 +44,6 @@ static struct scsi_device_handler *get_d
 	return found;
 }
 
-static struct scsi_device_handler *get_device_handler_by_idx(int idx)
-{
-	struct scsi_device_handler *tmp, *found = NULL;
-
-	spin_lock(&list_lock);
-	list_for_each_entry(tmp, &scsi_dh_list, list) {
-		if (tmp->idx == idx) {
-			found = tmp;
-			break;
-		}
-	}
-	spin_unlock(&list_lock);
-	return found;
-}
-
 /*
  * device_handler_match_function - Match a device handler to a device
  * @sdev - SCSI device to be tested
@@ -84,23 +68,6 @@ device_handler_match_function(struct scs
 }
 
 /*
- * device_handler_match_devlist - Match a device handler to a device
- * @sdev - SCSI device to be tested
- *
- * Tests @sdev against all device_handler registered in the devlist.
- * Returns the found device handler or NULL if not found.
- */
-static struct scsi_device_handler *
-device_handler_match_devlist(struct scsi_device *sdev)
-{
-	int idx;
-
-	idx = scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model,
-					  SCSI_DEVINFO_DH);
-	return get_device_handler_by_idx(idx);
-}
-
-/*
  * device_handler_match - Attach a device handler to a device
  * @scsi_dh - The device handler to match against or NULL
  * @sdev - SCSI device to be tested against @scsi_dh
@@ -116,8 +83,6 @@ device_handler_match(struct scsi_device_
 	struct scsi_device_handler *found_dh;
 
 	found_dh = device_handler_match_function(sdev);
-	if (!found_dh)
-		found_dh = device_handler_match_devlist(sdev);
 
 	if (scsi_dh && found_dh != scsi_dh)
 		found_dh = NULL;
@@ -361,25 +326,14 @@ static int scsi_dh_notifier_remove(struc
  */
 int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 {
-	int i;
 
 	if (get_device_handler(scsi_dh->name))
 		return -EBUSY;
 
 	spin_lock(&list_lock);
-	scsi_dh->idx = scsi_dh_list_idx++;
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
 
-	for (i = 0; scsi_dh->devlist && scsi_dh->devlist[i].vendor; i++) {
-		scsi_dev_info_list_add_keyed(0,
-					scsi_dh->devlist[i].vendor,
-					scsi_dh->devlist[i].model,
-					NULL,
-					scsi_dh->idx,
-					SCSI_DEVINFO_DH);
-	}
-
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
 	printk(KERN_INFO "%s: device handler registered\n", scsi_dh->name);
 
@@ -396,7 +350,6 @@ EXPORT_SYMBOL_GPL(scsi_register_device_h
  */
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
-	int i;
 
 	if (!get_device_handler(scsi_dh->name))
 		return -ENODEV;
@@ -404,12 +357,6 @@ int scsi_unregister_device_handler(struc
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
 			 scsi_dh_notifier_remove);
 
-	for (i = 0; scsi_dh->devlist && scsi_dh->devlist[i].vendor; i++) {
-		scsi_dev_info_list_del_keyed(scsi_dh->devlist[i].vendor,
-					     scsi_dh->devlist[i].model,
-					     SCSI_DEVINFO_DH);
-	}
-
 	spin_lock(&list_lock);
 	list_del(&scsi_dh->list);
 	spin_unlock(&list_lock);
@@ -588,10 +535,6 @@ static int __init scsi_dh_init(void)
 {
 	int r;
 
-	r = scsi_dev_info_add_list(SCSI_DEVINFO_DH, "SCSI Device Handler");
-	if (r)
-		return r;
-
 	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
 
 	if (!r)
@@ -606,7 +549,6 @@ static void __exit scsi_dh_exit(void)
 	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
 			 scsi_dh_sysfs_attr_remove);
 	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
-	scsi_dev_info_remove_list(SCSI_DEVINFO_DH);
 }
 
 module_init(scsi_dh_init);
diff -uprN -X linux-3.2-rc2/Documentation/dontdiff linux-3.2-rc2/drivers/scsi/scsi_priv.h linux-3.2-rc2-new/drivers/scsi/scsi_priv.h
--- linux-3.2-rc2/drivers/scsi/scsi_priv.h	2011-11-15 11:02:59.000000000 -0600
+++ linux-3.2-rc2-new/drivers/scsi/scsi_priv.h	2011-11-19 12:16:14.000000000 -0600
@@ -45,7 +45,6 @@ static inline void scsi_log_completion(s
 enum {
 	SCSI_DEVINFO_GLOBAL = 0,
 	SCSI_DEVINFO_SPI,
-	SCSI_DEVINFO_DH,
 };
 
 extern int scsi_get_device_flags(struct scsi_device *sdev,
diff -uprN -X linux-3.2-rc2/Documentation/dontdiff linux-3.2-rc2/include/scsi/scsi_device.h linux-3.2-rc2-new/include/scsi/scsi_device.h
--- linux-3.2-rc2/include/scsi/scsi_device.h	2011-11-15 11:02:59.000000000 -0600
+++ linux-3.2-rc2-new/include/scsi/scsi_device.h	2011-11-19 10:57:56.000000000 -0600
@@ -185,7 +185,6 @@ typedef void (*activate_complete)(void *
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
-	int idx;
 
 	/* Filled by the hardware handler */
 	struct module *module;


