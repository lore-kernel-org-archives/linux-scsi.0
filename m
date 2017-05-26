From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 2/4] tcmu: Add netlink for device reconfiguration
Date: Fri, 26 May 2017 09:27:21 -0500
Message-ID: <1495808843-40222-3-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

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
