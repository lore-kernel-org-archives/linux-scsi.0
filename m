From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 4/4] tcmu: Make dev_config configurable
Date: Fri, 26 May 2017 09:27:23 -0500
Message-ID: <1495808843-40222-5-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This allows for userspace to change the device path after
it has been created. Thus giving the user the ability to change
the path. The use case for this is to allow for virtual optical
to have media change.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c8c84b7..3036a57 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1548,6 +1548,45 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
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
+
+	copy = kstrdup(page, GFP_KERNEL);
+
+	if (!copy)
+		return -EINVAL;
+
+	strcpy(udev->dev_config, copy);
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
@@ -1626,6 +1665,7 @@ CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
 struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
+	&tcmu_attr_dev_path,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	NULL,
-- 
2.5.4 (Apple Git-61)
