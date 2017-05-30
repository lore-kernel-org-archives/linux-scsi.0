From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2 1/5] tcmu: Support emulate_write_cache
Date: Tue, 30 May 2017 13:31:16 -0500
Message-ID: <1496169080-58746-2-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This will enable the toggling of write_cache in tcmu through targetcli-fb

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-By: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index beb5f09..0c797cc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1290,6 +1290,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* Other attributes can be configured in userspace */
 	if (!dev->dev_attrib.hw_max_sectors)
 		dev->dev_attrib.hw_max_sectors = 128;
+	if (!dev->dev_attrib.emulate_write_cache)
+		dev->dev_attrib.emulate_write_cache = 0;
 	dev->dev_attrib.hw_queue_depth = 128;
 
 	/*
@@ -1546,6 +1548,32 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 }
 CONFIGFS_ATTR(tcmu_, cmd_time_out);
 
+static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
+					     char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+
+	return snprintf(page, PAGE_SIZE, "%i\n", da->emulate_write_cache);
+}
+
+static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
+					      const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	int val;
+	int ret;
+
+	ret = kstrtouint(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	da->emulate_write_cache = val;
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, emulate_write_cache);
+
 static struct configfs_attribute **tcmu_attrs;
 
 static struct target_backend_ops tcmu_ops = {
@@ -1682,6 +1710,8 @@ static int __init tcmu_module_init(void)
 		tcmu_attrs[i] = passthrough_attrib_attrs[i];
 	}
 	tcmu_attrs[i] = &tcmu_attr_cmd_time_out;
+	i++;
+	tcmu_attrs[i] = &tcmu_attr_emulate_write_cache;
 	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
 
 	ret = transport_backend_register(&tcmu_ops);
-- 
2.5.4 (Apple Git-61)
