From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] tcmu: Allow reconfig to handle multiple attributes
Date: Thu,  4 Jan 2018 10:11:00 -0600
Message-ID: <20180104161100.15330-1-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932071AbeADQLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 11:11:11 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w04G8Ukk065742
        for <linux-scsi@vger.kernel.org>; Thu, 4 Jan 2018 11:11:10 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f9q5xs3k5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jan 2018 11:11:10 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Thu, 4 Jan 2018 11:11:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This patch allows for multiple attributes to be reconfigured
and handled all in one call as compared to multiple netlinks.

Example:
set attribute dev_reconfig=dev_config=fbo//home/path:dev_size=2147483648

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c     | 92 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_user.h |  1 +
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4824abf92ed79..619fae5e865f1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -152,6 +152,8 @@ struct tcmu_dev {
 	char dev_config[TCMU_CONFIG_LEN];
 
 	int nl_reply_supported;
+
+	char dev_reconfig[TCMU_CONFIG_LEN * 2];
 };
 
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
@@ -1452,6 +1454,10 @@ static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
 			ret = nla_put_u8(skb, reconfig_attr,
 					  *((u8 *)reconfig_data));
 			break;
+		case TCMU_ATTR_DEV_RECFG:
+			pr_err("Put string into netlink and send it\n");
+			ret = nla_put_string(skb, reconfig_attr, reconfig_data);
+			break;
 		default:
 			BUG();
 		}
@@ -1637,7 +1643,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_nl_reply_supported, Opt_err,
+	Opt_nl_reply_supported, Opt_dev_reconfig, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1646,6 +1652,7 @@ static match_table_t tokens = {
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
+	{Opt_dev_reconfig, "dev_reconfig=%s"},
 	{Opt_err, NULL}
 };
 
@@ -1731,6 +1738,14 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			if (ret < 0)
 				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
+		case Opt_dev_reconfig:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			kfree(arg_p);
+			break;
 		default:
 			break;
 		}
@@ -1945,12 +1960,87 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_dev_reconfig_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_reconfig);
+}
+
+static ssize_t tcmu_dev_reconfig_store(struct config_item *item,
+				       const char *page,
+				       size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	int token, ret;
+	char *orig, *ptr, *opts, *arg_p;
+	substring_t args[MAX_OPT_ARGS];
+
+	/* Check if device has been configured before */
+	if (tcmu_dev_configured(udev)) {
+		ret = tcmu_netlink_event(udev, TCMU_CMD_RECONFIG_DEVICE,
+					 TCMU_ATTR_DEV_RECFG, page);
+		if (ret) {
+			pr_err("Unable to reconfigure device\n");
+			return ret;
+		}
+
+		opts = kstrdup(page, GFP_KERNEL);
+		if (!opts)
+			return -ENOMEM;
+
+		orig = opts;
+		strcpy(udev->dev_reconfig, opts);
+
+		while ((ptr = strsep(&opts, ":")) != NULL) {
+			if (!*ptr)
+				continue;
+
+			token = match_token(ptr, tokens, args);
+			switch (token) {
+			case Opt_dev_config:
+				if (match_strlcpy(udev->dev_config, &args[0],
+						  TCMU_CONFIG_LEN) == 0) {
+					pr_err("Could not reconfigure dev_config");
+				}
+				ret = tcmu_update_uio_info(udev);
+				if (ret)
+					pr_err("Could not reconfigure dev_config");
+				break;
+			case Opt_dev_size:
+				arg_p = match_strdup(&args[0]);
+				if (!arg_p)
+					pr_err("Could not reconfigure dev_size");
+				ret = kstrtoul(arg_p, 0,
+					       (unsigned long *)&udev->dev_size);
+				kfree(arg_p);
+				if (ret < 0)
+					pr_err("kstrtoul() failed for dev_size=\n");
+
+				pr_err("found dev_size");
+				break;
+			default:
+				break;
+			}
+		}
+		return count;
+	}
+
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, dev_reconfig);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	&tcmu_attr_nl_reply_supported,
+	&tcmu_attr_dev_reconfig,
 	NULL,
 };
 
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index aff57a0b29a6c..068b088f51f77 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -150,6 +150,7 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_CMD_STATUS,
 	TCMU_ATTR_DEVICE_ID,
 	TCMU_ATTR_SUPP_KERN_CMD_REPLY,
+	TCMU_ATTR_DEV_RECFG,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
-- 
2.14.3 (Apple Git-98)
