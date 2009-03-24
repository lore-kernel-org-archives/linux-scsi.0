From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/26] qla2xxx: Export flash-block-size for application support.
Date: Tue, 24 Mar 2009 09:08:11 -0700
Message-ID: <1237910900-30817-18-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109AbZCXQIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:38 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

In handling the RMW semantics needed to update regions not
falling on a sector boundary.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bfc1afd..ed22ee0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -928,6 +928,16 @@ qla2x00_phy_version_show(struct device *dev, struct device_attribute *attr,
 	    ha->phy_version[0], ha->phy_version[1], ha->phy_version[2]);
 }
 
+static ssize_t
+qla2x00_flash_block_size_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	return snprintf(buf, PAGE_SIZE, "0x%x\n", ha->fdt_block_size);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -954,6 +964,8 @@ static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
 		   NULL);
 static DEVICE_ATTR(mpi_version, S_IRUGO, qla2x00_mpi_version_show, NULL);
 static DEVICE_ATTR(phy_version, S_IRUGO, qla2x00_phy_version_show, NULL);
+static DEVICE_ATTR(flash_block_size, S_IRUGO, qla2x00_flash_block_size_show,
+		   NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -975,6 +987,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_total_isp_aborts,
 	&dev_attr_mpi_version,
 	&dev_attr_phy_version,
+	&dev_attr_flash_block_size,
 	NULL,
 };
 
-- 
1.6.2.rc0.55.g30aa4f

