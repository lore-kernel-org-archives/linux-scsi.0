From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 15/23] be2iscsi: Dispaly CID available for connection offload
Date: Sat, 28 Sep 2013 15:35:52 -0700
Message-ID: <1380407761-2949-15-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46390 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3I1Wgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:41 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so4271527pad.9
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:41 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Display CID available on each iSCSI Fn which can be used to
 offload a connection. The display is split across available CID
 on each chute.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    8 ++++++--
 drivers/scsi/be2iscsi/be_mgmt.c |   34 ++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_mgmt.h |    8 ++++++--
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b323569..005ea62 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -154,13 +154,17 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
 DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
-DEVICE_ATTR(beiscsi_active_cid_count, S_IRUGO, beiscsi_active_cid_disp, NULL);
+DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
+	     beiscsi_active_session_disp, NULL);
+DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
+	     beiscsi_free_session_disp, NULL);
 struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable,
 	&dev_attr_beiscsi_drvr_ver,
 	&dev_attr_beiscsi_adapter_family,
 	&dev_attr_beiscsi_fw_ver,
-	&dev_attr_beiscsi_active_cid_count,
+	&dev_attr_beiscsi_active_session_count,
+	&dev_attr_beiscsi_free_session_count,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a542bbb..896e21f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1346,7 +1346,7 @@ beiscsi_fw_ver_disp(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * beiscsi_active_cid_disp()- Display Sessions Active
+ * beiscsi_active_session_disp()- Display Sessions Active
  * @dev: ptr to device not used.
  * @attr: device attribute, not used.
  * @buf: contains formatted text Session Count
@@ -1355,7 +1355,7 @@ beiscsi_fw_ver_disp(struct device *dev, struct device_attribute *attr,
  * size of the formatted string
  **/
 ssize_t
-beiscsi_active_cid_disp(struct device *dev, struct device_attribute *attr,
+beiscsi_active_session_disp(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -1378,6 +1378,36 @@ beiscsi_active_cid_disp(struct device *dev, struct device_attribute *attr,
 }
 
 /**
+ * beiscsi_free_session_disp()- Display Avaliable Session
+ * @dev: ptr to device not used.
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text Session Count
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_free_session_disp(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	uint16_t ulp_num, len = 0;
+
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported))
+			len += snprintf(buf+len, PAGE_SIZE - len,
+					"ULP%d : %d\n", ulp_num,
+					BEISCSI_ULP_AVLBL_CID(phba, ulp_num));
+		else
+			len += snprintf(buf+len, PAGE_SIZE - len,
+					"ULP%d : %d\n", ulp_num, 0);
+	}
+
+	return len;
+}
+
+/**
  * beiscsi_adap_family_disp()- Display adapter family.
  * @dev: ptr to device to get priv structure
  * @attr: device attribute, not used.
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 04af7e7..9107ecf 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -315,12 +315,16 @@ ssize_t beiscsi_drvr_ver_disp(struct device *dev,
 ssize_t beiscsi_fw_ver_disp(struct device *dev,
 			     struct device_attribute *attr, char *buf);
 
-ssize_t beiscsi_active_cid_disp(struct device *dev,
-				 struct device_attribute *attr, char *buf);
+ssize_t beiscsi_active_session_disp(struct device *dev,
+				     struct device_attribute *attr, char *buf);
 
 ssize_t beiscsi_adap_family_disp(struct device *dev,
 				  struct device_attribute *attr, char *buf);
 
+
+ssize_t beiscsi_free_session_disp(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
 			     struct be_mem_descriptor *mem_descr);
-- 
1.7.10.4

