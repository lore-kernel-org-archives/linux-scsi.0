From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 11/14] megaraid_sas: Expose fw_cmds_outstanding through sysfs
Date: Fri,  5 Jan 2018 05:27:46 -0800
Message-ID: <1515158869-26693-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42676 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeAEN3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id d23so2179735pfe.9
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:38 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Expose FW outstanding commands (fw_outstanding) through sysfs interface.
This helps in debugging certain performance issues in the field.

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6da2766694cb..40775408c222 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3122,6 +3122,16 @@ megasas_ldio_outstanding_show(struct device *cdev, struct device_attribute *attr
 	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&instance->ldio_outstanding));
 }
 
+static ssize_t
+megasas_fw_cmds_outstanding_show(struct device *cdev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&instance->fw_outstanding));
+}
+
 static DEVICE_ATTR(fw_crash_buffer, S_IRUGO | S_IWUSR,
 	megasas_fw_crash_buffer_show, megasas_fw_crash_buffer_store);
 static DEVICE_ATTR(fw_crash_buffer_size, S_IRUGO,
@@ -3132,6 +3142,8 @@ static DEVICE_ATTR(page_size, S_IRUGO,
 	megasas_page_size_show, NULL);
 static DEVICE_ATTR(ldio_outstanding, S_IRUGO,
 	megasas_ldio_outstanding_show, NULL);
+static DEVICE_ATTR(fw_cmds_outstanding, S_IRUGO,
+	megasas_fw_cmds_outstanding_show, NULL);
 
 struct device_attribute *megaraid_host_attrs[] = {
 	&dev_attr_fw_crash_buffer_size,
@@ -3139,6 +3151,7 @@ struct device_attribute *megaraid_host_attrs[] = {
 	&dev_attr_fw_crash_state,
 	&dev_attr_page_size,
 	&dev_attr_ldio_outstanding,
+	&dev_attr_fw_cmds_outstanding,
 	NULL,
 };
 
-- 
2.14.1
