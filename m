From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 8/8] scsi_dh: create lookup cache
Date: Thu, 17 Jul 2008 16:53:33 -0700
Message-ID: <20080717235333.23056.40253.sendpatchset@chandra-ubuntu>
References: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com, hare@suse.de, linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Create a cache of devices that are seen in a system. This will avoid
the unnecessary traversal of the device list in the scsi_dh when there
are multiple luns of a same type.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |  129 +++++++++++++++++++++++++++------
 1 files changed, 105 insertions(+), 24 deletions(-)

Index: linux-2.6.26-git5/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.26-git5.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.26-git5/drivers/scsi/device_handler/scsi_dh.c
@@ -24,8 +24,16 @@
 #include <scsi/scsi_dh.h>
 #include "../scsi_priv.h"
 
+struct scsi_dh_devinfo_list {
+	struct list_head node;
+	char vendor[9];
+	char model[17];
+	struct scsi_device_handler *handler;
+};
+
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
+static LIST_HEAD(scsi_dh_dev_list);
 
 static struct scsi_device_handler *get_device_handler(const char *name)
 {
@@ -42,21 +50,94 @@ static struct scsi_device_handler *get_d
 	return found;
 }
 
-static int device_handler_match(struct scsi_device_handler *tmp,
-				struct scsi_device *sdev)
+
+static struct scsi_device_handler *
+scsi_dh_cache_lookup(struct scsi_device *sdev)
 {
-	int i;
+	struct scsi_dh_devinfo_list *tmp;
+	struct scsi_device_handler *found_dh = NULL;
 
-	for(i = 0; tmp->devlist[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, tmp->devlist[i].vendor,
-			     strlen(tmp->devlist[i].vendor)) &&
-		    !strncmp(sdev->model, tmp->devlist[i].model,
-			     strlen(tmp->devlist[i].model))) {
-			return 1;
+	spin_lock(&list_lock);
+	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
+		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
+		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
+			found_dh = tmp->handler;
+			break;
 		}
 	}
+	spin_unlock(&list_lock);
 
-	return 0;
+	return found_dh;
+}
+
+static int scsi_dh_handler_lookup(struct scsi_device_handler *scsi_dh,
+				  struct scsi_device *sdev)
+{
+	int i, found = 0;
+
+	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
+			     strlen(scsi_dh->devlist[i].vendor)) &&
+		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
+			     strlen(scsi_dh->devlist[i].model))) {
+			found = 1;
+			break;
+		}
+	}
+	return found;
+}
+
+/*
+ * device_handler_match - Attach a device handler to a device
+ * @scsi_dh - The device handler to match against or NULL
+ * @sdev - SCSI device to be tested against @scsi_dh
+ *
+ * Tests @sdev against the device handler @scsi_dh or against
+ * all registered device_handler if @scsi_dh == NULL.
+ * Returns the found device handler or NULL if not found.
+ */
+static struct scsi_device_handler *
+device_handler_match(struct scsi_device_handler *scsi_dh,
+		     struct scsi_device *sdev)
+{
+	struct scsi_device_handler *found_dh = NULL;
+	struct scsi_dh_devinfo_list *tmp;
+
+	found_dh = scsi_dh_cache_lookup(sdev);
+	if (found_dh)
+		return found_dh;
+
+	if (scsi_dh) {
+		if (scsi_dh_handler_lookup(scsi_dh, sdev))
+			found_dh = scsi_dh;
+	} else {
+		struct scsi_device_handler *tmp_dh;
+
+		spin_lock(&list_lock);
+		list_for_each_entry(tmp_dh, &scsi_dh_list, list) {
+			if (scsi_dh_handler_lookup(tmp_dh, sdev))
+				found_dh = tmp_dh;
+		}
+		spin_unlock(&list_lock);
+	}
+
+	if (found_dh) { /* If device is found, add it to the cache */
+		tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+		if (tmp) {
+			strncpy(tmp->vendor, sdev->vendor, 8);
+			strncpy(tmp->model, sdev->model, 16);
+			tmp->vendor[8] = '\0';
+			tmp->model[16] = '\0';
+			tmp->handler = found_dh;
+			spin_lock(&list_lock);
+			list_add(&tmp->node, &scsi_dh_dev_list);
+			spin_unlock(&list_lock);
+		} else {
+			found_dh = NULL;
+		}
+	}
+
+	return found_dh;
 }
 
 /*
@@ -203,26 +284,18 @@ static int scsi_dh_notifier(struct notif
 	struct device *dev = data;
 	struct scsi_device *sdev;
 	int err = 0;
-	struct scsi_device_handler *tmp, *devinfo = NULL;
+	struct scsi_device_handler *devinfo = NULL;
 
 	if (!scsi_is_sdev_device(dev))
 		return 0;
 
 	sdev = to_scsi_device(dev);
 
-	spin_lock(&list_lock);
-	list_for_each_entry(tmp, &scsi_dh_list, list) {
-		if (device_handler_match(tmp, sdev)) {
-			devinfo = tmp;
-			break;
-		}
-	}
-	spin_unlock(&list_lock);
-
-	if (!devinfo)
-		goto out;
-
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		devinfo = device_handler_match(NULL, sdev);
+		if (!devinfo)
+			goto out;
+
 		err = scsi_dh_handler_attach(sdev, devinfo);
 		if (!err)
 			err = device_create_file(dev, &scsi_dh_state_attr);
@@ -312,6 +385,8 @@ EXPORT_SYMBOL_GPL(scsi_register_device_h
  */
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
+	struct scsi_dh_devinfo_list *tmp, *pos;
+
 	if (!get_device_handler(scsi_dh->name))
 		return -ENODEV;
 
@@ -320,6 +395,12 @@ int scsi_unregister_device_handler(struc
 
 	spin_lock(&list_lock);
 	list_del(&scsi_dh->list);
+	list_for_each_entry_safe(pos, tmp, &scsi_dh_dev_list, node) {
+		if (pos->handler == scsi_dh) {
+			list_del(&pos->node);
+			kfree(pos);
+		}
+	}
 	spin_unlock(&list_lock);
 	printk(KERN_INFO "%s: device handler unregistered\n", scsi_dh->name);
 
