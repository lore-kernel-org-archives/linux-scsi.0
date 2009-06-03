From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/20] qla2xxx: Export negotiated fabric-parameters for application support.
Date: Wed,  3 Jun 2009 09:55:12 -0700
Message-ID: <1244048131-56590-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZFCQza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:30 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fc30f8e..524ceb9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1115,6 +1115,15 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
 	    vha->fcoe_vn_port_mac[1], vha->fcoe_vn_port_mac[0]);
 }
 
+static ssize_t
+qla2x00_fabric_param_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", vha->hw->switch_cap);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -1146,6 +1155,7 @@ static DEVICE_ATTR(flash_block_size, S_IRUGO, qla2x00_flash_block_size_show,
 static DEVICE_ATTR(vlan_id, S_IRUGO, qla2x00_vlan_id_show, NULL);
 static DEVICE_ATTR(vn_port_mac_address, S_IRUGO,
 		   qla2x00_vn_port_mac_address_show, NULL);
+static DEVICE_ATTR(fabric_param, S_IRUGO, qla2x00_fabric_param_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1170,6 +1180,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_flash_block_size,
 	&dev_attr_vlan_id,
 	&dev_attr_vn_port_mac_address,
+	&dev_attr_fabric_param,
 	NULL,
 };
 
-- 
1.6.3.1.244.gf9275

