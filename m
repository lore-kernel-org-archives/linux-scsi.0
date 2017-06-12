From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v4 0/5] tcmu: Add Type of reconfig into netlink
Date: Mon, 12 Jun 2017 01:43:46 -0500
Message-ID: <593E3822.5030408@redhat.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1496988706.28997.40.camel@haakon3.risingtidesystems.com>
 <593DAFE8.80705@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090807050603090300060901"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <593DAFE8.80705@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090807050603090300060901
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 06/11/2017 04:02 PM, Mike Christie wrote:
> On 06/09/2017 01:11 AM, Nicholas A. Bellinger wrote:
>> Hi Bryant & Co,
>>
>> On Tue, 2017-06-06 at 09:28 -0500, Bryant G. Ly wrote:
>>> From: "Bryant G. Ly" <bgly@us.ibm.com>
>>>
>>> This patch consists of adding a netlink to allow for reconfiguration
>>> of a device in tcmu.
>>>
>>> It also changes and adds some attributes that are reconfigurable:
>>> write_cache, device size, and device path.
>>>
>>> V2 - Fixes kfree in tcmu: Make dev_config configurable
>>> V3 - Fixes spelling error
>>> V4 - change strcpy to strlcpy for tcmu_dev_path_store and move
>>>      tcmu_reconfig_type into target_core_user.h
>>>
>>>
>>> Bryant G. Ly (5):
>>>   tcmu: Support emulate_write_cache
>>>   tcmu: Add netlink for device reconfiguration
>>>   tcmu: Make dev_size configurable via userspace
>>>   tcmu: Make dev_config configurable
>>>   tcmu: Add Type of reconfig into netlink
>>>
>>>  drivers/target/target_core_user.c     | 152 ++++++++++++++++++++++++++++++++--
>>>  include/uapi/linux/target_core_user.h |   9 ++
>>>  2 files changed, 155 insertions(+), 6 deletions(-)
>>>
>>
>> AFAICT, it looks like all of the review comments have been addressed in
>> -v4.
>>
>> Applied to target-pending/for-next, with MNC's (pseudo) Reviewed-by's
>> added for #3-#5.
>>
>> Please let me know if anything else needs to be changed.
>>
> 
> The patches look ok. Thanks. Could you just merge the attached patch
> into "[PATCH v4 5/5] tcmu: Add Type of reconfig into netlink" or into
> the patchset after it? It just makes some of the names a little less
> generic and only returns the reconfig attr for reconfig commands.
> 

Actually Nick, do not merge the last patch. I have a lot more fixes/changes.

Bryant, could you test and adapt your userspace patches for the attached
patch build over Nicks for-next branch.

Basically, the patch just has use pass the value being reconfigured with
the netlink event. Along the way, it fixes a couple bugs.

Nick, when we have tested the patch, then I can submit as a formal
patchset, or you can fold into the existing patches or whatever you prefer.


--------------090807050603090300060901
Content-Type: text/x-patch;
 name="0001-tcmu-reconfigure-netlink-attr-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tcmu-reconfigure-netlink-attr-changes.patch"

>From dad38c89d92a83b19b285431268818a74fe48fab Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Mon, 12 Jun 2017 01:34:28 -0500
Subject: [PATCH 1/1] tcmu: reconfigure netlink attr changes v2

1. TCMU_ATTR_TYPE is too generic. Drop it and use per reconfig
type attrs.

2. Only return the reconfig type when it is a TCMU_CMD_RECONFIG_DEVICE command.

3. CONFIG_* type is not needed. We can pass the value along with an
ATTR to userspace, so it does not need to read sysfs/configfs.

4. Fix leak in tcmu_dev_path_store and rename to dev_config to
reflect it is more than just a path that can be changed.

6. Don't update kernel struct value if netlink sending fails.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c     | 73 +++++++++++++++++++++--------------
 include/uapi/linux/target_core_user.h | 12 ++----
 2 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index afc1fd6..1712c42 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1177,7 +1177,8 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 }
 
 static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name,
-			      int minor, int type)
+			      int minor, int reconfig_attr,
+			      const void *reconfig_data)
 {
 	struct sk_buff *skb;
 	void *msg_header;
@@ -1199,9 +1200,27 @@ static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name,
 	if (ret < 0)
 		goto free_skb;
 
-	ret = nla_put_u32(skb, TCMU_ATTR_TYPE, type);
-	if (ret < 0)
-		goto free_skb;
+	if (cmd == TCMU_CMD_RECONFIG_DEVICE) {
+		switch (reconfig_attr) {
+		case TCMU_ATTR_DEV_CFG:
+			ret = nla_put_string(skb, reconfig_attr, reconfig_data);
+			break;
+		case TCMU_ATTR_DEV_SIZE:
+			ret = nla_put_u64_64bit(skb, reconfig_attr,
+						*((u64 *)reconfig_data),
+						TCMU_ATTR_PAD);
+			break;
+		case TCMU_ATTR_WRITECACHE:
+			ret = nla_put_u8(skb, reconfig_attr,
+					  *((u8 *)reconfig_data));
+			break;
+		default:
+			BUG();
+		}
+
+		if (ret < 0)
+			goto free_skb;
+	}
 
 	genlmsg_end(skb, msg_header);
 
@@ -1306,7 +1325,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	kref_get(&udev->kref);
 
 	ret = tcmu_netlink_event(TCMU_CMD_ADDED_DEVICE, udev->uio_info.name,
-				 udev->uio_info.uio_dev->minor, NO_RECONFIG);
+				 udev->uio_info.uio_dev->minor, 0, NULL);
 	if (ret)
 		goto err_netlink;
 
@@ -1388,7 +1407,7 @@ static void tcmu_free_device(struct se_device *dev)
 
 	if (tcmu_dev_configured(udev)) {
 		tcmu_netlink_event(TCMU_CMD_REMOVED_DEVICE, udev->uio_info.name,
-				   udev->uio_info.uio_dev->minor, NO_RECONFIG);
+				   udev->uio_info.uio_dev->minor, 0, NULL);
 
 		uio_unregister_device(&udev->uio_info);
 	}
@@ -1553,7 +1572,7 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 }
 CONFIGFS_ATTR(tcmu_, cmd_time_out);
 
-static ssize_t tcmu_dev_path_show(struct config_item *item, char *page)
+static ssize_t tcmu_dev_config_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 						struct se_dev_attrib, da_group);
@@ -1562,37 +1581,34 @@ static ssize_t tcmu_dev_path_show(struct config_item *item, char *page)
 	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_config);
 }
 
-static ssize_t tcmu_dev_path_store(struct config_item *item, const char *page,
-				   size_t count)
+static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
+				     size_t count)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 						struct se_dev_attrib, da_group);
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
-	char *copy = NULL;
-	int ret;
+	int ret, len;
 
-	copy = kstrdup(page, GFP_KERNEL);
-	if (!copy) {
-		kfree(copy);
+	len = strlen(page);
+	if (!len || len > TCMU_CONFIG_LEN - 1)
 		return -EINVAL;
-	}
-	strlcpy(udev->dev_config, copy, TCMU_CONFIG_LEN);
 
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_PATH);
+					 TCMU_ATTR_DEV_CFG, page);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
 		}
 	}
+	strlcpy(udev->dev_config, page, TCMU_CONFIG_LEN);
 
 	return count;
 }
-CONFIGFS_ATTR(tcmu_, dev_path);
+CONFIGFS_ATTR(tcmu_, dev_config);
 
 static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
 {
@@ -1609,26 +1625,25 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 						struct se_dev_attrib, da_group);
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
-	unsigned long val;
+	u64 val;
 	int ret;
 
-	ret = kstrtoul(page, 0, &val);
+	ret = kstrtou64(page, 0, &val);
 	if (ret < 0)
 		return ret;
-	udev->dev_size = val;
 
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_SIZE);
+					 TCMU_ATTR_DEV_SIZE, &val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
 		}
 	}
-
+	udev->dev_size = val;
 	return count;
 }
 CONFIGFS_ATTR(tcmu_, dev_size);
@@ -1648,33 +1663,33 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
-	int val;
+	u8 val;
 	int ret;
 
-	ret = kstrtouint(page, 0, &val);
+	ret = kstrtou8(page, 0, &val);
 	if (ret < 0)
 		return ret;
 
-	da->emulate_write_cache = val;
-
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_WRITECACHE);
+					 TCMU_ATTR_WRITECACHE, &val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
 		}
 	}
+
+	da->emulate_write_cache = val;
 	return count;
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
 struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
-	&tcmu_attr_dev_path,
+	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	NULL,
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 5b00e35..4bfc9a1 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -139,16 +139,12 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_UNSPEC,
 	TCMU_ATTR_DEVICE,
 	TCMU_ATTR_MINOR,
-	TCMU_ATTR_TYPE,
+	TCMU_ATTR_PAD,
+	TCMU_ATTR_DEV_CFG,
+	TCMU_ATTR_DEV_SIZE,
+	TCMU_ATTR_WRITECACHE,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
 
-enum tcmu_reconfig_types {
-	NO_RECONFIG,
-	CONFIG_PATH,
-	CONFIG_SIZE,
-	CONFIG_WRITECACHE,
-};
-
 #endif
-- 
1.8.3.1


--------------090807050603090300060901--
