From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 02/19] tcmu: Add netlink command reply supported option for each device
Date: Sun, 29 Oct 2017 22:44:22 -0500
Message-ID: <1509335079-5276-3-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Kenjiro Nakayama <nakayamakenjiro@gmail.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

Currently netlink command reply support option
(TCMU_ATTR_SUPP_KERN_CMD_REPLY) can be enabled only on module
scope. Because of that, once an application enables the netlink
command reply support, all applications using target_core_user.ko
would be expected to support the netlink reply. To make matters worse,
users will not be able to add a device via configfs manually.

To fix these issues, this patch adds an option to make netlink command
reply disabled on each device through configfs. Original
TCMU_ATTR_SUPP_KERN_CMD_REPLY is still enabled on module scope to keep
backward-compatibility and used by default, however once users set
nl_reply_supported=<NAGATIVE_VALUE> via configfs for a particular
device, the device disables the netlink command reply support.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
[use kstrtoint]
Signed-off-by: Mike Christie <mchristi@redhat.com>

---
 drivers/target/target_core_user.c | 58 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8b9ec0f..fa251d3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -150,6 +150,8 @@ struct tcmu_dev {
 	wait_queue_head_t nl_cmd_wq;
 
 	char dev_config[TCMU_CONFIG_LEN];
+
+	int nl_reply_supported;
 };
 
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
@@ -1352,6 +1354,10 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 
 	if (!tcmu_kern_cmd_reply_supported)
 		return;
+
+	if (udev->nl_reply_supported <= 0)
+		return;
+
 relock:
 	spin_lock(&udev->nl_cmd_lock);
 
@@ -1378,6 +1384,9 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	if (!tcmu_kern_cmd_reply_supported)
 		return 0;
 
+	if (udev->nl_reply_supported <= 0)
+		return 0;
+
 	pr_debug("sleeping for nl reply\n");
 	wait_for_completion(&nl_cmd->complete);
 
@@ -1550,6 +1559,12 @@ static int tcmu_configure_device(struct se_device *dev)
 		dev->dev_attrib.emulate_write_cache = 0;
 	dev->dev_attrib.hw_queue_depth = 128;
 
+	/* If user didn't explicitly disable netlink reply support, use
+	 * module scope setting.
+	 */
+	if (udev->nl_reply_supported >= 0)
+		udev->nl_reply_supported = tcmu_kern_cmd_reply_supported;
+
 	/*
 	 * Get a ref incase userspace does a close on the uio device before
 	 * LIO has initiated tcmu_free_device.
@@ -1612,7 +1627,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_err,
+	Opt_nl_reply_supported, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1620,6 +1635,7 @@ enum {
 	{Opt_dev_size, "dev_size=%u"},
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
+	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
 	{Opt_err, NULL}
 };
 
@@ -1694,6 +1710,17 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			ret = tcmu_set_dev_attrib(&args[0],
 					&(dev->dev_attrib.hw_max_sectors));
 			break;
+		case Opt_nl_reply_supported:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtoint(arg_p, 0, &udev->nl_reply_supported);
+			kfree(arg_p);
+			if (ret < 0)
+				pr_err("kstrtoint() failed for nl_reply_supported=\n");
+			break;
 		default:
 			break;
 		}
@@ -1844,6 +1871,34 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 }
 CONFIGFS_ATTR(tcmu_, dev_size);
 
+static ssize_t tcmu_nl_reply_supported_show(struct config_item *item,
+		char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", udev->nl_reply_supported);
+}
+
+static ssize_t tcmu_nl_reply_supported_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	s8 val;
+	int ret;
+
+	ret = kstrtos8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	udev->nl_reply_supported = val;
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, nl_reply_supported);
+
 static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
 					     char *page)
 {
@@ -1886,6 +1941,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_nl_reply_supported,
 	NULL,
 };
 
-- 
1.8.3.1
