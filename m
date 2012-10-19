From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 15/19] be2iscsi: Fix issue of displaying adapter family.
Date: Sat, 20 Oct 2012 04:45:06 +0530
Message-ID: <e809d66f-d55d-4b1c-940c-cc708c0cd3fe@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38787 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2JSXQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:16:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix issue of displaying adapter family through the sysfs
 entry for each Scsi_Host created for the adapter.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2d28cac..ea510ef 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -152,9 +152,11 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 		"\t\t\t\tConfiguration Path	: 0x20\n");
 
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
+DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
 struct device_attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable,
 	&dev_attr_beiscsi_drvr_ver,
+	&dev_attr_beiscsi_adapter_family,
 	NULL,
 };
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index b96a159..ee130bc 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1153,6 +1153,45 @@ beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
 }
 
+/**
+ * beiscsi_adap_family_disp()- Display adapter family.
+ * @dev: ptr to device to get priv structure
+ * @attr: device attribute, not used.
+ * @buf: contains formatted text driver name and version
+ *
+ * return
+ * size of the formatted string
+ **/
+ssize_t
+beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	uint16_t dev_id = 0;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	dev_id = phba->pcidev->device;
+	switch (dev_id) {
+	case BE_DEVICE_ID1:
+	case OC_DEVICE_ID1:
+	case OC_DEVICE_ID2:
+		return snprintf(buf, PAGE_SIZE, "BE2 Adapter Family\n");
+		break;
+	case BE_DEVICE_ID2:
+	case OC_DEVICE_ID3:
+		return snprintf(buf, PAGE_SIZE, "BE3-R Adapter Family\n");
+		break;
+	case OC_SKH_ID1:
+		return snprintf(buf, PAGE_SIZE, "Skyhawk-R Adapter Family\n");
+		break;
+	default:
+		return snprintf(buf, PAGE_SIZE,
+				"Unkown Adapter Family: 0x%x\n", dev_id);
+		break;
+	}
+}
+
+
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
 			     struct be_mem_descriptor *mem_descr)
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 4ec6127..e2c222a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -305,6 +305,9 @@ int mgmt_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag);
 ssize_t beiscsi_drvr_ver_disp(struct device *dev,
 			       struct device_attribute *attr, char *buf);
 
+ssize_t beiscsi_adap_family_disp(struct device *dev,
+				  struct device_attribute *attr, char *buf);
+
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
 			     struct be_mem_descriptor *mem_descr);
-- 
1.7.2

