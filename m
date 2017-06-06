From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v4 5/5] tcmu: Add Type of reconfig into netlink
Date: Tue,  6 Jun 2017 09:28:52 -0500
Message-ID: <1496759332-35216-6-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48197 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751433AbdFFO3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2017 10:29:31 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v56ETUvG040495
        for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2017 10:29:31 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2aww80kspt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 10:29:30 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 6 Jun 2017 10:29:21 -0400
In-Reply-To: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This patch adds more info about the attribute being changed,
so that usersapce can easily figure out what is happening.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c     | 20 ++++++++++++++------
 include/uapi/linux/target_core_user.h |  8 ++++++++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7c64757..afc1fd6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1176,7 +1176,8 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 	return 0;
 }
 
-static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name, int minor)
+static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name,
+			      int minor, int type)
 {
 	struct sk_buff *skb;
 	void *msg_header;
@@ -1198,6 +1199,10 @@ static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name, int mino
 	if (ret < 0)
 		goto free_skb;
 
+	ret = nla_put_u32(skb, TCMU_ATTR_TYPE, type);
+	if (ret < 0)
+		goto free_skb;
+
 	genlmsg_end(skb, msg_header);
 
 	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
@@ -1301,7 +1306,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	kref_get(&udev->kref);
 
 	ret = tcmu_netlink_event(TCMU_CMD_ADDED_DEVICE, udev->uio_info.name,
-				 udev->uio_info.uio_dev->minor);
+				 udev->uio_info.uio_dev->minor, NO_RECONFIG);
 	if (ret)
 		goto err_netlink;
 
@@ -1383,7 +1388,7 @@ static void tcmu_free_device(struct se_device *dev)
 
 	if (tcmu_dev_configured(udev)) {
 		tcmu_netlink_event(TCMU_CMD_REMOVED_DEVICE, udev->uio_info.name,
-				   udev->uio_info.uio_dev->minor);
+				   udev->uio_info.uio_dev->minor, NO_RECONFIG);
 
 		uio_unregister_device(&udev->uio_info);
 	}
@@ -1577,7 +1582,8 @@ static ssize_t tcmu_dev_path_store(struct config_item *item, const char *page,
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
-					 udev->uio_info.uio_dev->minor);
+					 udev->uio_info.uio_dev->minor,
+					 CONFIG_PATH);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
@@ -1615,7 +1621,8 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
-					 udev->uio_info.uio_dev->minor);
+					 udev->uio_info.uio_dev->minor,
+					 CONFIG_SIZE);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
@@ -1654,7 +1661,8 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
-					 udev->uio_info.uio_dev->minor);
+					 udev->uio_info.uio_dev->minor,
+					 CONFIG_WRITECACHE);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 403a61f..5b00e35 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -139,8 +139,16 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_UNSPEC,
 	TCMU_ATTR_DEVICE,
 	TCMU_ATTR_MINOR,
+	TCMU_ATTR_TYPE,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
 
+enum tcmu_reconfig_types {
+	NO_RECONFIG,
+	CONFIG_PATH,
+	CONFIG_SIZE,
+	CONFIG_WRITECACHE,
+};
+
 #endif
-- 
2.5.4 (Apple Git-61)
