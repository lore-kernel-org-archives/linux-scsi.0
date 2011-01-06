From: Peter Jones <pjones@redhat.com>
Subject: [PATCH 1/2] Add scsi_dev_info_list_del_keyed()
Date: Thu,  6 Jan 2011 15:31:29 -0500
Message-ID: <1294345890-6089-1-git-send-email-pjones@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1AFUbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 15:31:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Chandra Seetharaman <sekharan@us.ibm.com>, Peter Jones <pjones@redhat.com>

For scsi_dh.c to use devinfo lists, we have to be able to remove entries
before rmmod.
---
 drivers/scsi/scsi_devinfo.c |   85 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h    |    1 +
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 43fad4c..82e9e5c 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -382,6 +382,91 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 EXPORT_SYMBOL(scsi_dev_info_list_add_keyed);
 
 /**
+ * scsi_dev_info_list_del_keyed - remove one dev_info list entry.
+ * @vendor:	vendor string
+ * @model:	model (product) string
+ * @key:	specify list to use
+ *
+ * Description:
+ * 	Remove and destroy one dev_info entry for @vendor, @model
+ * 	in list specified by @key.
+ *
+ * Returns: 0 OK, -error on failure.
+ **/
+int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key)
+{
+	struct scsi_dev_info_list *devinfo, *found = NULL;
+	struct scsi_dev_info_list_table *devinfo_table =
+		scsi_devinfo_lookup_by_key(key);
+
+	if (IS_ERR(devinfo_table))
+		return PTR_ERR(devinfo_table);
+
+	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
+			    dev_info_list) {
+		if (devinfo->compatible) {
+			/*
+			 * Behave like the older version of get_device_flags.
+			 */
+			size_t max;
+			/*
+			 * XXX why skip leading spaces? If an odd INQUIRY
+			 * value, that should have been part of the
+			 * scsi_static_device_list[] entry, such as "  FOO"
+			 * rather than "FOO". Since this code is already
+			 * here, and we don't know what device it is
+			 * trying to work with, leave it as-is.
+			 */
+			max = 8;	/* max length of vendor */
+			while ((max > 0) && *vendor == ' ') {
+				max--;
+				vendor++;
+			}
+			/*
+			 * XXX removing the following strlen() would be
+			 * good, using it means that for a an entry not in
+			 * the list, we scan every byte of every vendor
+			 * listed in scsi_static_device_list[], and never match
+			 * a single one (and still have to compare at
+			 * least the first byte of each vendor).
+			 */
+			if (memcmp(devinfo->vendor, vendor,
+				    min(max, strlen(devinfo->vendor))))
+				continue;
+			/*
+			 * Skip spaces again.
+			 */
+			max = 16;	/* max length of model */
+			while ((max > 0) && *model == ' ') {
+				max--;
+				model++;
+			}
+			if (memcmp(devinfo->model, model,
+				   min(max, strlen(devinfo->model))))
+				continue;
+			found = devinfo;
+		} else {
+			if (!memcmp(devinfo->vendor, vendor,
+				     sizeof(devinfo->vendor)) &&
+			     !memcmp(devinfo->model, model,
+				      sizeof(devinfo->model)))
+				found = devinfo;
+		}
+		if (found)
+			break;
+	}
+
+	if (found) {
+		list_del(&found->dev_info_list);
+		kfree(found);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(scsi_dev_info_list_del_keyed);
+
+/**
  * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
  * @dev_list:	string of device flags to add
  *
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..ce9e0ad 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -56,6 +56,7 @@ extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
 					int flags, int key);
+extern int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key);
 extern int scsi_dev_info_add_list(int key, const char *name);
 extern int scsi_dev_info_remove_list(int key);
 
-- 
1.7.3.1

