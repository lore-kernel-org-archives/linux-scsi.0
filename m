From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 08/18] be2iscsi: Fix displaying the FW Version from driver.
Date: Fri,  5 Apr 2013 20:38:28 -0700
Message-ID: <1365219519-3457-8-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57740 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163203Ab3DFDjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:00 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc17so2322291pbc.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:38:59 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The mgmt_hba_attributes structure declared was not proper and
 because of that the FW response returned for the MBX_CMD was not
 matching. This issue went unnoticed as mgmt_hba_attribs structure
 members were never used in the code path.

 This fix of displaying the FW version had to change the mgmt_hba_attrib
 structure also. The latest driver will also work with the older FW as
 the issue was in the driver declaration.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_main.h |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   21 +++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |   30 +++++++++++++++++-------------
 4 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6be5e29..adc662d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -153,10 +153,12 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
+DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
 struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable,
 	&dev_attr_beiscsi_drvr_ver,
 	&dev_attr_beiscsi_adapter_family,
+	&dev_attr_beiscsi_fw_ver,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 77b13c3..3c5df92 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -68,6 +68,7 @@
 #define BEISCSI_MAX_NUM_CPUS	7
 #define OC_SKH_MAX_NUM_CPUS	31
 
+#define BEISCSI_VER_STRLEN 32
 
 #define BEISCSI_SGLIST_ELEMENTS	30
 
@@ -341,6 +342,7 @@ struct beiscsi_hba {
 	struct delayed_work beiscsi_hw_check_task;
 
 	u8 mac_address[ETH_ALEN];
+	char fw_ver_str[BEISCSI_VER_STRLEN];
 	char wq_name[20];
 	struct workqueue_struct *wq;	/* The actuak work queue */
 	struct be_ctrl_info ctrl;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a6c2fe4..7fe8595 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -368,6 +368,8 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
 			    "BM_%d : phba->fw_config.iscsi_features = %d\n",
 			    phba->fw_config.iscsi_features);
+		memcpy(phba->fw_ver_str, resp->params.hba_attribs.
+		       firmware_version_string, BEISCSI_VER_STRLEN);
 	} else
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BG_%d :  Failed in mgmt_check_supported_fw\n");
@@ -1260,6 +1262,25 @@ beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
 }
 
 /**
+ * beiscsi_fw_ver_disp()- Display Firmware Version
+ * @dev: ptr to device not used.
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text Firmware version
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_fw_ver_disp(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
+}
+
+/**
  * beiscsi_adap_family_disp()- Display adapter family.
  * @dev: ptr to device to get priv structure
  * @attr: device attribute, not used.
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 2e4968a..00f3a4f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -156,25 +156,25 @@ union invalidate_commands_params {
 } __packed;
 
 struct mgmt_hba_attributes {
-	u8 flashrom_version_string[32];
-	u8 manufacturer_name[32];
+	u8 flashrom_version_string[BEISCSI_VER_STRLEN];
+	u8 manufacturer_name[BEISCSI_VER_STRLEN];
 	u32 supported_modes;
 	u8 seeprom_version_lo;
 	u8 seeprom_version_hi;
 	u8 rsvd0[2];
 	u32 fw_cmd_data_struct_version;
 	u32 ep_fw_data_struct_version;
-	u32 future_reserved[12];
+	u8 ncsi_version_string[12];
 	u32 default_extended_timeout;
-	u8 controller_model_number[32];
+	u8 controller_model_number[BEISCSI_VER_STRLEN];
 	u8 controller_description[64];
-	u8 controller_serial_number[32];
-	u8 ip_version_string[32];
-	u8 firmware_version_string[32];
-	u8 bios_version_string[32];
-	u8 redboot_version_string[32];
-	u8 driver_version_string[32];
-	u8 fw_on_flash_version_string[32];
+	u8 controller_serial_number[BEISCSI_VER_STRLEN];
+	u8 ip_version_string[BEISCSI_VER_STRLEN];
+	u8 firmware_version_string[BEISCSI_VER_STRLEN];
+	u8 bios_version_string[BEISCSI_VER_STRLEN];
+	u8 redboot_version_string[BEISCSI_VER_STRLEN];
+	u8 driver_version_string[BEISCSI_VER_STRLEN];
+	u8 fw_on_flash_version_string[BEISCSI_VER_STRLEN];
 	u32 functionalities_supported;
 	u16 max_cdblength;
 	u8 asic_revision;
@@ -190,7 +190,8 @@ struct mgmt_hba_attributes {
 	u32 firmware_post_status;
 	u32 hba_mtu[8];
 	u8 iscsi_features;
-	u8 future_u8[3];
+	u8 asic_generation;
+	u8 future_u8[2];
 	u32 future_u32[3];
 } __packed;
 
@@ -207,7 +208,7 @@ struct mgmt_controller_attributes {
 	u64 unique_identifier;
 	u8 netfilters;
 	u8 rsvd0[3];
-	u8 future_u32[4];
+	u32 future_u32[4];
 } __packed;
 
 struct be_mgmt_controller_attributes {
@@ -311,6 +312,9 @@ int mgmt_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag);
 ssize_t beiscsi_drvr_ver_disp(struct device *dev,
 			       struct device_attribute *attr, char *buf);
 
+ssize_t beiscsi_fw_ver_disp(struct device *dev,
+			     struct device_attribute *attr, char *buf);
+
 ssize_t beiscsi_adap_family_disp(struct device *dev,
 				  struct device_attribute *attr, char *buf);
 
-- 
1.7.10.4

