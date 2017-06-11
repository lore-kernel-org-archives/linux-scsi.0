From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v4 0/5] tcmu: Add Type of reconfig into netlink
Date: Sun, 11 Jun 2017 16:02:32 -0500
Message-ID: <593DAFE8.80705@redhat.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1496988706.28997.40.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040008020902050908090003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751850AbdFKVCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Jun 2017 17:02:34 -0400
In-Reply-To: <1496988706.28997.40.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>

This is a multi-part message in MIME format.
--------------040008020902050908090003
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 06/09/2017 01:11 AM, Nicholas A. Bellinger wrote:
> Hi Bryant & Co,
> 
> On Tue, 2017-06-06 at 09:28 -0500, Bryant G. Ly wrote:
>> From: "Bryant G. Ly" <bgly@us.ibm.com>
>>
>> This patch consists of adding a netlink to allow for reconfiguration
>> of a device in tcmu.
>>
>> It also changes and adds some attributes that are reconfigurable:
>> write_cache, device size, and device path.
>>
>> V2 - Fixes kfree in tcmu: Make dev_config configurable
>> V3 - Fixes spelling error
>> V4 - change strcpy to strlcpy for tcmu_dev_path_store and move
>>      tcmu_reconfig_type into target_core_user.h
>>
>>
>> Bryant G. Ly (5):
>>   tcmu: Support emulate_write_cache
>>   tcmu: Add netlink for device reconfiguration
>>   tcmu: Make dev_size configurable via userspace
>>   tcmu: Make dev_config configurable
>>   tcmu: Add Type of reconfig into netlink
>>
>>  drivers/target/target_core_user.c     | 152 ++++++++++++++++++++++++++++++++--
>>  include/uapi/linux/target_core_user.h |   9 ++
>>  2 files changed, 155 insertions(+), 6 deletions(-)
>>
> 
> AFAICT, it looks like all of the review comments have been addressed in
> -v4.
> 
> Applied to target-pending/for-next, with MNC's (pseudo) Reviewed-by's
> added for #3-#5.
> 
> Please let me know if anything else needs to be changed.
> 

The patches look ok. Thanks. Could you just merge the attached patch
into "[PATCH v4 5/5] tcmu: Add Type of reconfig into netlink" or into
the patchset after it? It just makes some of the names a little less
generic and only returns the reconfig attr for reconfig commands.

--------------040008020902050908090003
Content-Type: text/x-patch;
 name="0001-tcmu-reconfigure-netlink-attr-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tcmu-reconfigure-netlink-attr-changes.patch"

>From b51f9b228490ba61306060460164aed8f2e8fc8b Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Sun, 11 Jun 2017 15:59:25 -0500
Subject: [PATCH 1/1] tcmu: reconfigure netlink attr changes

1. TCMU_ATTR_TYPE is too generic when it describes only the
reconfiguration type, so rename to TCMU_ATTR_RECONFIG_TYPE.

2. Only return the reconfig type when it is a TCMU_CMD_RECONFIG_DEVICE
command.

3. CONFIG_* is probably too generic, so add a TCMU_* prefix.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c     | 20 ++++++++++++--------
 include/uapi/linux/target_core_user.h | 10 +++++-----
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index afc1fd6..3a50b8c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1199,9 +1199,11 @@ static int tcmu_netlink_event(enum tcmu_genl_cmd cmd, const char *name,
 	if (ret < 0)
 		goto free_skb;
 
-	ret = nla_put_u32(skb, TCMU_ATTR_TYPE, type);
-	if (ret < 0)
-		goto free_skb;
+	if (cmd == TCMU_CMD_RECONFIG_DEVICE) {
+		ret = nla_put_u32(skb, TCMU_ATTR_RECONFIG_TYPE, type);
+		if (ret < 0)
+			goto free_skb;
+	}
 
 	genlmsg_end(skb, msg_header);
 
@@ -1306,7 +1308,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	kref_get(&udev->kref);
 
 	ret = tcmu_netlink_event(TCMU_CMD_ADDED_DEVICE, udev->uio_info.name,
-				 udev->uio_info.uio_dev->minor, NO_RECONFIG);
+				 udev->uio_info.uio_dev->minor,
+				 TCMU_CONFIG_NONE);
 	if (ret)
 		goto err_netlink;
 
@@ -1388,7 +1391,8 @@ static void tcmu_free_device(struct se_device *dev)
 
 	if (tcmu_dev_configured(udev)) {
 		tcmu_netlink_event(TCMU_CMD_REMOVED_DEVICE, udev->uio_info.name,
-				   udev->uio_info.uio_dev->minor, NO_RECONFIG);
+				   udev->uio_info.uio_dev->minor,
+				   TCMU_CONFIG_NONE);
 
 		uio_unregister_device(&udev->uio_info);
 	}
@@ -1583,7 +1587,7 @@ static ssize_t tcmu_dev_path_store(struct config_item *item, const char *page,
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_PATH);
+					 TCMU_CONFIG_PATH);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
@@ -1622,7 +1626,7 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_SIZE);
+					 TCMU_CONFIG_SIZE);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
@@ -1662,7 +1666,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,
 					 udev->uio_info.name,
 					 udev->uio_info.uio_dev->minor,
-					 CONFIG_WRITECACHE);
+					 TCMU_CONFIG_WRITECACHE);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 5b00e35..b14ddf9 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -139,16 +139,16 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_UNSPEC,
 	TCMU_ATTR_DEVICE,
 	TCMU_ATTR_MINOR,
-	TCMU_ATTR_TYPE,
+	TCMU_ATTR_RECONFIG_TYPE,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
 
 enum tcmu_reconfig_types {
-	NO_RECONFIG,
-	CONFIG_PATH,
-	CONFIG_SIZE,
-	CONFIG_WRITECACHE,
+	TCMU_CONFIG_NONE,
+	TCMU_CONFIG_PATH,
+	TCMU_CONFIG_SIZE,
+	TCMU_CONFIG_WRITECACHE,
 };
 
 #endif
-- 
1.8.3.1


--------------040008020902050908090003--
