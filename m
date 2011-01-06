From: Peter Jones <pjones@redhat.com>
Subject: [PATCH 2/2] Use scsi_devinfo functions to do matching of scsi IDs device_handler tables.
Date: Thu,  6 Jan 2011 15:31:30 -0500
Message-ID: <1294345890-6089-2-git-send-email-pjones@redhat.com>
References: <1294345890-6089-1-git-send-email-pjones@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1AFUbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 15:31:43 -0500
In-Reply-To: <1294345890-6089-1-git-send-email-pjones@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Chandra Seetharaman <sekharan@us.ibm.com>, Peter Jones <pjones@redhat.com>

Previously we were using strncmp in order to avoid having to include
whitespace in the devlist, but this means "HSV1000" matches a device
list entry that says "HSV100", which is wrong.  This patch changes
scsi_dh.c to use scsi_devinfo's matching functions instead, since they
handle these cases correctly.
---
 drivers/scsi/device_handler/scsi_dh.c |  112 +++++++++++----------------------
 drivers/scsi/scsi_priv.h              |    1 +
 include/scsi/scsi_device.h            |    1 +
 3 files changed, 39 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 6fae3d2..9561e50 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -25,16 +25,9 @@
 #include <scsi/scsi_dh.h>
 #include "../scsi_priv.h"
 
-struct scsi_dh_devinfo_list {
-	struct list_head node;
-	char vendor[9];
-	char model[17];
-	struct scsi_device_handler *handler;
-};
-
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
-static LIST_HEAD(scsi_dh_dev_list);
+static int scsi_dh_list_idx = 1;
 
 static struct scsi_device_handler *get_device_handler(const char *name)
 {
@@ -51,40 +44,18 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 	return found;
 }
 
-
-static struct scsi_device_handler *
-scsi_dh_cache_lookup(struct scsi_device *sdev)
+static struct scsi_device_handler *get_device_handler_by_idx(int idx)
 {
-	struct scsi_dh_devinfo_list *tmp;
-	struct scsi_device_handler *found_dh = NULL;
+	struct scsi_device_handler *tmp, *found = NULL;
 
 	spin_lock(&list_lock);
-	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
-		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
-		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
-			found_dh = tmp->handler;
+	list_for_each_entry(tmp, &scsi_dh_list, list) {
+		if (tmp->idx == idx) {
+			found = tmp;
 			break;
 		}
 	}
 	spin_unlock(&list_lock);
-
-	return found_dh;
-}
-
-static int scsi_dh_handler_lookup(struct scsi_device_handler *scsi_dh,
-				  struct scsi_device *sdev)
-{
-	int i, found = 0;
-
-	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
-			     strlen(scsi_dh->devlist[i].vendor)) &&
-		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
-			     strlen(scsi_dh->devlist[i].model))) {
-			found = 1;
-			break;
-		}
-	}
 	return found;
 }
 
@@ -102,41 +73,14 @@ device_handler_match(struct scsi_device_handler *scsi_dh,
 		     struct scsi_device *sdev)
 {
 	struct scsi_device_handler *found_dh = NULL;
-	struct scsi_dh_devinfo_list *tmp;
+	int idx;
 
-	found_dh = scsi_dh_cache_lookup(sdev);
-	if (found_dh)
-		return found_dh;
+	idx = scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model,
+					  SCSI_DEVINFO_DH);
+	found_dh = get_device_handler_by_idx(idx);
 
-	if (scsi_dh) {
-		if (scsi_dh_handler_lookup(scsi_dh, sdev))
-			found_dh = scsi_dh;
-	} else {
-		struct scsi_device_handler *tmp_dh;
-
-		spin_lock(&list_lock);
-		list_for_each_entry(tmp_dh, &scsi_dh_list, list) {
-			if (scsi_dh_handler_lookup(tmp_dh, sdev))
-				found_dh = tmp_dh;
-		}
-		spin_unlock(&list_lock);
-	}
-
-	if (found_dh) { /* If device is found, add it to the cache */
-		tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
-		if (tmp) {
-			strncpy(tmp->vendor, sdev->vendor, 8);
-			strncpy(tmp->model, sdev->model, 16);
-			tmp->vendor[8] = '\0';
-			tmp->model[16] = '\0';
-			tmp->handler = found_dh;
-			spin_lock(&list_lock);
-			list_add(&tmp->node, &scsi_dh_dev_list);
-			spin_unlock(&list_lock);
-		} else {
-			found_dh = NULL;
-		}
-	}
+	if (scsi_dh && found_dh != scsi_dh)
+		found_dh = NULL;
 
 	return found_dh;
 }
@@ -373,12 +317,25 @@ static int scsi_dh_notifier_remove(struct device *dev, void *data)
  */
 int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 {
+	int i;
+
 	if (get_device_handler(scsi_dh->name))
 		return -EBUSY;
 
 	spin_lock(&list_lock);
+	scsi_dh->idx = scsi_dh_list_idx++;
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
+
+	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
+		scsi_dev_info_list_add_keyed(1, /* compatible */
+					scsi_dh->devlist[i].vendor,
+					scsi_dh->devlist[i].model,
+					NULL,
+					scsi_dh->idx,
+					SCSI_DEVINFO_DH);
+	}
+
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
 	printk(KERN_INFO "%s: device handler registered\n", scsi_dh->name);
 
@@ -395,7 +352,7 @@ EXPORT_SYMBOL_GPL(scsi_register_device_handler);
  */
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
-	struct scsi_dh_devinfo_list *tmp, *pos;
+	int i;
 
 	if (!get_device_handler(scsi_dh->name))
 		return -ENODEV;
@@ -403,14 +360,14 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
 			 scsi_dh_notifier_remove);
 
+	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
+		scsi_dev_info_list_del_keyed(scsi_dh->devlist[i].vendor,
+					     scsi_dh->devlist[i].model,
+					     SCSI_DEVINFO_DH);
+	}
+
 	spin_lock(&list_lock);
 	list_del(&scsi_dh->list);
-	list_for_each_entry_safe(pos, tmp, &scsi_dh_dev_list, node) {
-		if (pos->handler == scsi_dh) {
-			list_del(&pos->node);
-			kfree(pos);
-		}
-	}
 	spin_unlock(&list_lock);
 	printk(KERN_INFO "%s: device handler unregistered\n", scsi_dh->name);
 
@@ -569,6 +526,10 @@ static int __init scsi_dh_init(void)
 {
 	int r;
 
+	r = scsi_dev_info_add_list(SCSI_DEVINFO_DH, "SCSI Device Handler");
+	if (r)
+		return r;
+
 	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
 
 	if (!r)
@@ -583,6 +544,7 @@ static void __exit scsi_dh_exit(void)
 	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
 			 scsi_dh_sysfs_attr_remove);
 	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
+	scsi_dev_info_remove_list(SCSI_DEVINFO_DH);
 }
 
 module_init(scsi_dh_init);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index ce9e0ad..9868afd 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -45,6 +45,7 @@ static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 enum {
 	SCSI_DEVINFO_GLOBAL = 0,
 	SCSI_DEVINFO_SPI,
+	SCSI_DEVINFO_DH,
 };
 
 extern int scsi_get_device_flags(struct scsi_device *sdev,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 85867dc..f171c65 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -184,6 +184,7 @@ typedef void (*activate_complete)(void *, int);
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
+	int idx;
 
 	/* Filled by the hardware handler */
 	struct module *module;
-- 
1.7.3.1

