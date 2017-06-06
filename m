From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v4 3/5] tcmu: Make dev_size configurable via userspace
Date: Tue,  6 Jun 2017 09:28:50 -0500
Message-ID: <1496759332-35216-4-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Allow tcmu backstores to be able to set the device size
after it has been configured via set attribute.

Part of support in userspace to support certain backstores
changing device size.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c | 59 +++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ae91822..c8c84b7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1548,6 +1548,44 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 }
 CONFIGFS_ATTR(tcmu_, cmd_time_out);
 
+static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%zu\n", udev->dev_size);
+}
+
+static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
+				   size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	udev->dev_size = val;
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
+CONFIGFS_ATTR(tcmu_, dev_size);
+
 static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
 					     char *page)
 {
@@ -1586,6 +1624,13 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+struct configfs_attribute *tcmu_attrib_attrs[] = {
+	&tcmu_attr_cmd_time_out,
+	&tcmu_attr_dev_size,
+	&tcmu_attr_emulate_write_cache,
+	NULL,
+};
+
 static struct configfs_attribute **tcmu_attrs;
 
 static struct target_backend_ops tcmu_ops = {
@@ -1685,7 +1730,7 @@ static int unmap_thread_fn(void *data)
 
 static int __init tcmu_module_init(void)
 {
-	int ret, i, len = 0;
+	int ret, i, k, len = 0;
 
 	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
 
@@ -1710,7 +1755,10 @@ static int __init tcmu_module_init(void)
 	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
 		len += sizeof(struct configfs_attribute *);
 	}
-	len += sizeof(struct configfs_attribute *) * 2;
+	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++) {
+		len += sizeof(struct configfs_attribute *);
+	}
+	len += sizeof(struct configfs_attribute *);
 
 	tcmu_attrs = kzalloc(len, GFP_KERNEL);
 	if (!tcmu_attrs) {
@@ -1721,9 +1769,10 @@ static int __init tcmu_module_init(void)
 	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
 		tcmu_attrs[i] = passthrough_attrib_attrs[i];
 	}
-	tcmu_attrs[i] = &tcmu_attr_cmd_time_out;
-	i++;
-	tcmu_attrs[i] = &tcmu_attr_emulate_write_cache;
+	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++) {
+		tcmu_attrs[i] = tcmu_attrib_attrs[k];
+		i++;
+	}
 	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
 
 	ret = transport_backend_register(&tcmu_ops);
-- 
2.5.4 (Apple Git-61)
