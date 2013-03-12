From: jayamohank@gmail.com
Subject: [PATCH 09/15] be2iscsi: Fix displaying the Active Session Count from driver
Date: Mon, 11 Mar 2013 21:39:39 -0700
Message-ID: <1363063186-4902-9-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55734 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3CLEkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:11 -0400
Received: by mail-pb0-f51.google.com with SMTP id un15so4572816pbc.10
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:10 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

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
index 5631a19..218f7ee 100644
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
index 0a406a4..ed5aa0f 100644
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

