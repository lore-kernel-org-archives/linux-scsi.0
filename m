From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2 2/5] tcmu: Add netlink for device reconfiguration
Date: Tue, 30 May 2017 13:31:17 -0500
Message-ID: <1496169080-58746-3-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59217 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750970AbdE3Sb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 14:31:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4UISw8j053869
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 14:31:28 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2asbx6xas7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 14:31:28 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 30 May 2017 14:31:27 -0400
In-Reply-To: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This gives tcmu the ability to handle events that can cause
reconfiguration, such as resize, path changes, write_cache, etc...

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-By: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c     | 12 ++++++++++++
 include/uapi/linux/target_core_user.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0c797cc..ae91822 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1562,6 +1562,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 	int val;
 	int ret;
 
@@ -1570,6 +1571,17 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 		return ret;
 
 	da->emulate_write_cache = val;
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
 	return count;
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index af17b41..403a61f 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -130,6 +130,7 @@ enum tcmu_genl_cmd {
 	TCMU_CMD_UNSPEC,
 	TCMU_CMD_ADDED_DEVICE,
 	TCMU_CMD_REMOVED_DEVICE,
+	TCMU_CMD_RECONFIG_DEVICE,
 	__TCMU_CMD_MAX,
 };
 #define TCMU_CMD_MAX (__TCMU_CMD_MAX - 1)
-- 
2.5.4 (Apple Git-61)
