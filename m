From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/7] scsi_dh: Implement match callback function
Date: Wed, 24 Aug 2011 10:51:15 +0200
Message-ID: <1314175879-16565-4-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1HXIvq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:46 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some device handler types are not tied to the vendor/model
but rather to a specific capability. Eg ALUA is supported
if the 'TPGS' setting in the standard inquiry is set.
This patch implements a 'match' callback for device handler
which supersedes the original vendor/model lookup and
implements the callback for the ALUA handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c      |   53 ++++++++++++++++++++++++----
 drivers/scsi/device_handler/scsi_dh_alua.c |   23 +++---------
 include/scsi/scsi_device.h                 |    1 +
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index a801c59..458521d 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -60,6 +60,46 @@ static struct scsi_device_handler *get_device_handler_by_idx(int idx)
 }
 
 /*
+ * device_handler_match_function - Match a device handler to a device
+ * @sdev - SCSI device to be tested
+ *
+ * Tests @sdev against the match function of all registered device_handler.
+ * Returns the found device handler or NULL if not found.
+ */
+static struct scsi_device_handler *
+device_handler_match_function(struct scsi_device *sdev)
+{
+	struct scsi_device_handler *tmp_dh, *found_dh = NULL;
+
+	spin_lock(&list_lock);
+	list_for_each_entry(tmp_dh, &scsi_dh_list, list) {
+		if (tmp_dh->match && tmp_dh->match(sdev)) {
+			found_dh = tmp_dh;
+			break;
+		}
+	}
+	spin_unlock(&list_lock);
+	return found_dh;
+}
+
+/*
+ * device_handler_match_devlist - Match a device handler to a device
+ * @sdev - SCSI device to be tested
+ *
+ * Tests @sdev against all device_handler registered in the devlist.
+ * Returns the found device handler or NULL if not found.
+ */
+static struct scsi_device_handler *
+device_handler_match_devlist(struct scsi_device *sdev)
+{
+	int idx;
+
+	idx = scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model,
+					  SCSI_DEVINFO_DH);
+	return get_device_handler_by_idx(idx);
+}
+
+/*
  * device_handler_match - Attach a device handler to a device
  * @scsi_dh - The device handler to match against or NULL
  * @sdev - SCSI device to be tested against @scsi_dh
@@ -72,12 +112,11 @@ static struct scsi_device_handler *
 device_handler_match(struct scsi_device_handler *scsi_dh,
 		     struct scsi_device *sdev)
 {
-	struct scsi_device_handler *found_dh = NULL;
-	int idx;
+	struct scsi_device_handler *found_dh;
 
-	idx = scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model,
-					  SCSI_DEVINFO_DH);
-	found_dh = get_device_handler_by_idx(idx);
+	found_dh = device_handler_match_function(sdev);
+	if (!found_dh)
+		found_dh = device_handler_match_devlist(sdev);
 
 	if (scsi_dh && found_dh != scsi_dh)
 		found_dh = NULL;
@@ -327,7 +366,7 @@ int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
 
-	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
+	for (i = 0; scsi_dh->devlist && scsi_dh->devlist[i].vendor; i++) {
 		scsi_dev_info_list_add_keyed(0,
 					scsi_dh->devlist[i].vendor,
 					scsi_dh->devlist[i].model,
@@ -360,7 +399,7 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
 			 scsi_dh_notifier_remove);
 
-	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
+	for (i = 0; scsi_dh->devlist && scsi_dh->devlist[i].vendor; i++) {
 		scsi_dev_info_list_del_keyed(scsi_dh->devlist[i].vendor,
 					     scsi_dh->devlist[i].model,
 					     SCSI_DEVINFO_DH);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4326778..80c5cf3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -677,23 +677,10 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 
 }
 
-static const struct scsi_dh_devlist alua_dev_list[] = {
-	{"HP", "MSA VOLUME" },
-	{"HP", "HSV101" },
-	{"HP", "HSV111" },
-	{"HP", "HSV200" },
-	{"HP", "HSV210" },
-	{"HP", "HSV300" },
-	{"IBM", "2107900" },
-	{"IBM", "2145" },
-	{"Pillar", "Axiom" },
-	{"Intel", "Multi-Flex"},
-	{"NETAPP", "LUN"},
-	{"NETAPP", "LUN C-Mode"},
-	{"AIX", "NVDISK"},
-	{"Promise", "VTrak"},
-	{NULL, NULL}
-};
+static bool alua_match(struct scsi_device *sdev)
+{
+	return (scsi_device_tpgs(sdev) != 0);
+}
 
 static int alua_bus_attach(struct scsi_device *sdev);
 static void alua_bus_detach(struct scsi_device *sdev);
@@ -701,12 +688,12 @@ static void alua_bus_detach(struct scsi_device *sdev);
 static struct scsi_device_handler alua_dh = {
 	.name = ALUA_DH_NAME,
 	.module = THIS_MODULE,
-	.devlist = alua_dev_list,
 	.attach = alua_bus_attach,
 	.detach = alua_bus_detach,
 	.prep_fn = alua_prep_fn,
 	.check_sense = alua_check_sense,
 	.activate = alua_activate,
+	.match = alua_match,
 };
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4733635..afcb403 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -197,6 +197,7 @@ struct scsi_device_handler {
 	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
+	bool (*match)(struct scsi_device *);
 };
 
 struct scsi_dh_data {
-- 
1.6.0.2

