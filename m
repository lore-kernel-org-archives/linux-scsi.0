From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 15/17] be2iscsi: Fix issue of displaying adapter family.
Date: Sat, 29 Sep 2012 07:04:47 +0530
Message-ID: <aa964fe5-cd1d-4242-9f29-ceccc5ad5233@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:52581 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030494Ab2I2Bfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:35:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix the issue of displaying adapter family by creating new
 sys attribute.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f39cd6b..6da7e18 100644
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
index b96a159..02c6344 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1153,6 +1153,44 @@ beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
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
+		return snprintf(buf, PAGE_SIZE, "BE3 Adapter Family\n");
+		break;
+	case OC_SKH_ID1:
+		return snprintf(buf, PAGE_SIZE, "Skyhawk Adapter Family\n");
+		break;
+	default:
+		return snprintf(buf, PAGE_SIZE, "Unkown Adapter Type\n");
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

