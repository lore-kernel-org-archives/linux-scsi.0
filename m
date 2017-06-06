From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v4 4/5] tcmu: Make dev_config configurable
Date: Tue,  6 Jun 2017 09:28:51 -0500
Message-ID: <1496759332-35216-5-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751477AbdFFO3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2017 10:29:06 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v56EOaSl179411
        for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2017 10:29:05 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2awtnmwmrc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 10:29:05 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 6 Jun 2017 10:29:04 -0400
In-Reply-To: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This allows for userspace to change the device path after
it has been created. Thus giving the user the ability to change
the path. The use case for this is to allow for virtual optical
to have media change.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c8c84b7..7c64757 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1548,6 +1548,46 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 }
 CONFIGFS_ATTR(tcmu_, cmd_time_out);
 
+static ssize_t tcmu_dev_path_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_config);
+}
+
+static ssize_t tcmu_dev_path_store(struct config_item *item, const char *page,
+				   size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	char *copy = NULL;
+	int ret;
+
+	copy = kstrdup(page, GFP_KERNEL);
+	if (!copy) {
+		kfree(copy);
+		return -EINVAL;
+	}
+	strlcpy(udev->dev_config, copy, TCMU_CONFIG_LEN);
+
+	/* Check if device has been configured before */
+	if (tcmu_dev_configured(udev)) {
+		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
+					 udev->uio_info.name,
+					 udev->uio_info.uio_dev->minor);
+		if (ret) {
+			pr_err("Unable to reconfigure device\n");
+			return ret;
+		}
+	}
+
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, dev_path);
+
 static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
@@ -1626,6 +1666,7 @@ CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
 struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
+	&tcmu_attr_dev_path,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	NULL,
-- 
2.5.4 (Apple Git-61)
