From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 16/22] be2iscsi: Display Port Identifier for each iSCSI function.
Date: Thu, 12 Sep 2013 22:10:06 -0700
Message-ID: <1379049014-32716-16-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56907 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3IMFgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:46 -0400
Received: by mail-pa0-f44.google.com with SMTP id fz6so2060240pac.17
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:44 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   19 +++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
 3 files changed, 24 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index beebf7f..4bec9e2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -154,6 +154,7 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
 DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
+DEVICE_ATTR(beiscsi_phys_port, S_IRUGO, beiscsi_phys_port_disp, NULL);
 DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
 	     beiscsi_active_session_disp, NULL);
 DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
@@ -165,6 +166,7 @@ struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_fw_ver,
 	&dev_attr_beiscsi_active_session_count,
 	&dev_attr_beiscsi_free_session_count,
+	&dev_attr_beiscsi_phys_port,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index c97140f..d3deb3f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1446,6 +1446,25 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 	}
 }
 
+/**
+ * beiscsi_phys_port()- Display Physical Port Identifier
+ * @dev: ptr to device not used.
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text port identifier
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_phys_port_disp(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "Port Identifier : %d\n",
+			phba->fw_config.phys_port);
+}
 
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 9107ecf..645e144 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -325,6 +325,9 @@ ssize_t beiscsi_adap_family_disp(struct device *dev,
 ssize_t beiscsi_free_session_disp(struct device *dev,
 				   struct device_attribute *attr, char *buf);
 
+ssize_t beiscsi_phys_port_disp(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
 			     struct be_mem_descriptor *mem_descr);
-- 
1.7.10.4

