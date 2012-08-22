From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/42] qla2xxx: Add FW DUMP SIZE sysfs attribute.
Date: Wed, 22 Aug 2012 14:21:02 -0400
Message-ID: <1345659696-3670-9-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:58992 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964967Ab2HVSiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:11 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ff2439b..da804f4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1276,6 +1276,24 @@ qla2x00_diag_megabytes_show(struct device *dev,
 	    vha->bidi_stats.transfer_bytes >> 20);
 }
 
+static ssize_t
+qla2x00_fw_dump_size_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t size;
+
+	if (!ha->fw_dumped)
+		size = 0;
+	else if (IS_QLA82XX(ha))
+		size = ha->md_template_size + ha->md_dump_size;
+	else
+		size = ha->fw_dump_len;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", size);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -1316,6 +1334,7 @@ static DEVICE_ATTR(fw_state, S_IRUGO, qla2x00_fw_state_show, NULL);
 static DEVICE_ATTR(thermal_temp, S_IRUGO, qla2x00_thermal_temp_show, NULL);
 static DEVICE_ATTR(diag_requests, S_IRUGO, qla2x00_diag_requests_show, NULL);
 static DEVICE_ATTR(diag_megabytes, S_IRUGO, qla2x00_diag_megabytes_show, NULL);
+static DEVICE_ATTR(fw_dump_size, S_IRUGO, qla2x00_fw_dump_size_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1347,6 +1366,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_thermal_temp,
 	&dev_attr_diag_requests,
 	&dev_attr_diag_megabytes,
+	&dev_attr_fw_dump_size,
 	NULL,
 };
 
-- 
1.7.7

