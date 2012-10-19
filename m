From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 05/19] be2iscsi: Display driver name and version in device attribute
Date: Sat, 20 Oct 2012 04:42:25 +0530
Message-ID: <9fdbe712-1e34-4864-949e-f570426e0b09@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:4712 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2JSXNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:13:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   16 ++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2d1bbb8..bd0f49f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -153,8 +153,10 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 		"\t\t\t\tIO Path Events		: 0x10\n"
 		"\t\t\t\tConfiguration Path	: 0x20\n");
 
+DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable,
+	&dev_attr_beiscsi_drvr_ver,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index aab5dd3..1ec1db3 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1136,3 +1136,19 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
 	free_mcc_tag(&phba->ctrl, tag);
 	return 0;
 }
+
+/**
+ * beiscsi_drvr_ver_disp()- Display the driver Name and Version
+ * @dev: ptr to device not used.
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text driver name and version
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index c50cef6..291c684 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -301,4 +301,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba);
 
 int mgmt_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag);
+
+ssize_t beiscsi_drvr_ver_disp(struct device *dev,
+			       struct device_attribute *attr, char *buf);
 #endif
-- 
1.7.2

