From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 09/18] be2iscsi: Fix displaying the Active Session Count from driver
Date: Fri,  5 Apr 2013 20:38:29 -0700
Message-ID: <1365219519-3457-9-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38183 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163204Ab3DFDjC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:02 -0400
Received: by mail-pb0-f48.google.com with SMTP id xb4so2306566pbc.35
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:01 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

This patch fixes the displaying of number of active
sessions in use.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   20 ++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
 3 files changed, 25 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index adc662d..ff89b4c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -154,11 +154,13 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
 DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
+DEVICE_ATTR(beiscsi_active_cid_count, S_IRUGO, beiscsi_active_cid_disp, NULL);
 struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable,
 	&dev_attr_beiscsi_drvr_ver,
 	&dev_attr_beiscsi_adapter_family,
 	&dev_attr_beiscsi_fw_ver,
+	&dev_attr_beiscsi_active_cid_count,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 7fe8595..8662f73 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1281,6 +1281,26 @@ beiscsi_fw_ver_disp(struct device *dev, struct device_attribute *attr,
 }
 
 /**
+ * beiscsi_active_cid_disp()- Display Sessions Active
+ * @dev: ptr to device not used.
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text Session Count
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_active_cid_disp(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		       (phba->params.cxns_per_ctrl - phba->avlbl_cids));
+}
+
+/**
  * beiscsi_adap_family_disp()- Display adapter family.
  * @dev: ptr to device to get priv structure
  * @attr: device attribute, not used.
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 00f3a4f..4c7e0a2 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -315,6 +315,9 @@ ssize_t beiscsi_drvr_ver_disp(struct device *dev,
 ssize_t beiscsi_fw_ver_disp(struct device *dev,
 			     struct device_attribute *attr, char *buf);
 
+ssize_t beiscsi_active_cid_disp(struct device *dev,
+				 struct device_attribute *attr, char *buf);
+
 ssize_t beiscsi_adap_family_disp(struct device *dev,
 				  struct device_attribute *attr, char *buf);
 
-- 
1.7.10.4

