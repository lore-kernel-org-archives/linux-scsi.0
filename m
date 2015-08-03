From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] SCSI: refactor device-matching code in scsi_devinfo.c
Date: Mon, 3 Aug 2015 11:57:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1508031143060.1667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43519 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753900AbbHCP5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:57:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giulio Bernardi <ugilio@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

In drivers/scsi/scsi_devinfo.c, the scsi_dev_info_list_del_keyed() and
scsi_get_device_flags_keyed() routines contain a large amount of
duplicate code for finding vendor/product matches in a
scsi_dev_info_list.  This patch factors out the duplicate code and
puts it in a separate function, scsi_dev_info_list_find().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Giulio Bernardi <ugilio@gmail.com>

---


[as1782]


 drivers/scsi/scsi_devinfo.c |  114 ++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 72 deletions(-)

Index: usb-4.1/drivers/scsi/scsi_devinfo.c
===================================================================
--- usb-4.1.orig/drivers/scsi/scsi_devinfo.c
+++ usb-4.1/drivers/scsi/scsi_devinfo.c
@@ -390,25 +390,26 @@ int scsi_dev_info_list_add_keyed(int com
 EXPORT_SYMBOL(scsi_dev_info_list_add_keyed);
 
 /**
- * scsi_dev_info_list_del_keyed - remove one dev_info list entry.
+ * scsi_dev_info_list_find - find a matching dev_info list entry.
  * @vendor:	vendor string
  * @model:	model (product) string
  * @key:	specify list to use
  *
  * Description:
- * 	Remove and destroy one dev_info entry for @vendor, @model
+ *	Finds the first dev_info entry matching @vendor, @model
  * 	in list specified by @key.
  *
- * Returns: 0 OK, -error on failure.
+ * Returns: pointer to matching entry, or ERR_PTR on failure.
  **/
-int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key)
+static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
+		const char *model, int key)
 {
-	struct scsi_dev_info_list *devinfo, *found = NULL;
+	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
 		scsi_devinfo_lookup_by_key(key);
 
 	if (IS_ERR(devinfo_table))
-		return PTR_ERR(devinfo_table);
+		return (struct scsi_dev_info_list *) devinfo_table;
 
 	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
 			    dev_info_list) {
@@ -452,25 +453,42 @@ int scsi_dev_info_list_del_keyed(char *v
 			if (memcmp(devinfo->model, model,
 				   min(max, strlen(devinfo->model))))
 				continue;
-			found = devinfo;
+			return devinfo;
 		} else {
 			if (!memcmp(devinfo->vendor, vendor,
 				     sizeof(devinfo->vendor)) &&
 			     !memcmp(devinfo->model, model,
 				      sizeof(devinfo->model)))
-				found = devinfo;
+				return devinfo;
 		}
-		if (found)
-			break;
 	}
 
-	if (found) {
-		list_del(&found->dev_info_list);
-		kfree(found);
-		return 0;
-	}
+	return ERR_PTR(-ENOENT);
+}
+
+/**
+ * scsi_dev_info_list_del_keyed - remove one dev_info list entry.
+ * @vendor:	vendor string
+ * @model:	model (product) string
+ * @key:	specify list to use
+ *
+ * Description:
+ *	Remove and destroy one dev_info entry for @vendor, @model
+ *	in list specified by @key.
+ *
+ * Returns: 0 OK, -error on failure.
+ **/
+int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key)
+{
+	struct scsi_dev_info_list *found;
 
-	return -ENOENT;
+	found = scsi_dev_info_list_find(vendor, model, key);
+	if (IS_ERR(found))
+		return PTR_ERR(found);
+
+	list_del(&found->dev_info_list);
+	kfree(found);
+	return 0;
 }
 EXPORT_SYMBOL(scsi_dev_info_list_del_keyed);
 
@@ -565,64 +583,16 @@ int scsi_get_device_flags_keyed(struct s
 				int key)
 {
 	struct scsi_dev_info_list *devinfo;
-	struct scsi_dev_info_list_table *devinfo_table;
+	int err;
 
-	devinfo_table = scsi_devinfo_lookup_by_key(key);
+	devinfo = scsi_dev_info_list_find(vendor, model, key);
+	if (!IS_ERR(devinfo))
+		return devinfo->flags;
+
+	err = PTR_ERR(devinfo);
+	if (err != -ENOENT)
+		return err;
 
-	if (IS_ERR(devinfo_table))
-		return PTR_ERR(devinfo_table);
-
-	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
-			    dev_info_list) {
-		if (devinfo->compatible) {
-			/*
-			 * Behave like the older version of get_device_flags.
-			 */
-			size_t max;
-			/*
-			 * XXX why skip leading spaces? If an odd INQUIRY
-			 * value, that should have been part of the
-			 * scsi_static_device_list[] entry, such as "  FOO"
-			 * rather than "FOO". Since this code is already
-			 * here, and we don't know what device it is
-			 * trying to work with, leave it as-is.
-			 */
-			max = 8;	/* max length of vendor */
-			while ((max > 0) && *vendor == ' ') {
-				max--;
-				vendor++;
-			}
-			/*
-			 * XXX removing the following strlen() would be
-			 * good, using it means that for a an entry not in
-			 * the list, we scan every byte of every vendor
-			 * listed in scsi_static_device_list[], and never match
-			 * a single one (and still have to compare at
-			 * least the first byte of each vendor).
-			 */
-			if (memcmp(devinfo->vendor, vendor,
-				    min(max, strlen(devinfo->vendor))))
-				continue;
-			/*
-			 * Skip spaces again.
-			 */
-			max = 16;	/* max length of model */
-			while ((max > 0) && *model == ' ') {
-				max--;
-				model++;
-			}
-			if (memcmp(devinfo->model, model,
-				   min(max, strlen(devinfo->model))))
-				continue;
-			return devinfo->flags;
-		} else {
-			if (!memcmp(devinfo->vendor, vendor,
-				     sizeof(devinfo->vendor)) &&
-			     !memcmp(devinfo->model, model,
-				      sizeof(devinfo->model)))
-				return devinfo->flags;
-		}
-	}
 	/* nothing found, return nothing */
 	if (key != SCSI_DEVINFO_GLOBAL)
 		return 0;

