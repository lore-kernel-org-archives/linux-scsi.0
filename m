From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 15/16] target: Drop left-over internal dev attribute code
Date: Fri, 28 Nov 2014 09:06:41 +0000
Message-ID: <1417165602-32359-16-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33635 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaK1Jh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:56 -0500
Received: by mail-ob0-f178.google.com with SMTP id gq1so4826564obb.9
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:55 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that backend drivers are populating their own device attributes,
go ahead and remove left-over definitions + internal attribute list
of device attributes from target_core_configfs.c code

Also update TB_CIT_SETUP(dev_attrib,...) to signal ct_attr = NULL.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 176 +---------------------------------
 1 file changed, 1 insertion(+), 175 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2903d89..75d89ad 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -586,189 +586,15 @@ EXPORT_SYMBOL(target_fabric_configfs_deregister);
 
 /* Start functions for struct config_item_type tb_dev_attrib_cit */
 
-#define DEF_DEV_ATTRIB_SHOW(_name)					\
-static ssize_t target_core_dev_show_attr_##_name(			\
-	struct se_dev_attrib *da,					\
-	char *page)							\
-{									\
-	return snprintf(page, PAGE_SIZE, "%u\n",			\
-		(u32)da->da_dev->dev_attrib._name);			\
-}
-
-#define DEF_DEV_ATTRIB_STORE(_name)					\
-static ssize_t target_core_dev_store_attr_##_name(			\
-	struct se_dev_attrib *da,					\
-	const char *page,						\
-	size_t count)							\
-{									\
-	unsigned long val;						\
-	int ret;							\
-									\
-	ret = kstrtoul(page, 0, &val);				\
-	if (ret < 0) {							\
-		pr_err("kstrtoul() failed with"		\
-			" ret: %d\n", ret);				\
-		return -EINVAL;						\
-	}								\
-	ret = se_dev_set_##_name(da->da_dev, (u32)val);			\
-									\
-	return (!ret) ? count : -EINVAL;				\
-}
-
-#define DEF_DEV_ATTRIB(_name)						\
-DEF_DEV_ATTRIB_SHOW(_name);						\
-DEF_DEV_ATTRIB_STORE(_name);
-
-#define DEF_DEV_ATTRIB_RO(_name)					\
-DEF_DEV_ATTRIB_SHOW(_name);
-
 CONFIGFS_EATTR_STRUCT(target_core_dev_attrib, se_dev_attrib);
-#define SE_DEV_ATTR(_name, _mode)					\
-static struct target_core_dev_attrib_attribute				\
-			target_core_dev_attrib_##_name =		\
-		__CONFIGFS_EATTR(_name, _mode,				\
-		target_core_dev_show_attr_##_name,			\
-		target_core_dev_store_attr_##_name);
-
-#define SE_DEV_ATTR_RO(_name);						\
-static struct target_core_dev_attrib_attribute				\
-			target_core_dev_attrib_##_name =		\
-	__CONFIGFS_EATTR_RO(_name,					\
-	target_core_dev_show_attr_##_name);
-
-DEF_DEV_ATTRIB(emulate_model_alias);
-SE_DEV_ATTR(emulate_model_alias, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_dpo);
-SE_DEV_ATTR(emulate_dpo, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_fua_write);
-SE_DEV_ATTR(emulate_fua_write, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_fua_read);
-SE_DEV_ATTR(emulate_fua_read, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_write_cache);
-SE_DEV_ATTR(emulate_write_cache, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_ua_intlck_ctrl);
-SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_tas);
-SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_tpu);
-SE_DEV_ATTR(emulate_tpu, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_tpws);
-SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_caw);
-SE_DEV_ATTR(emulate_caw, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_3pc);
-SE_DEV_ATTR(emulate_3pc, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(pi_prot_type);
-SE_DEV_ATTR(pi_prot_type, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB_RO(hw_pi_prot_type);
-SE_DEV_ATTR_RO(hw_pi_prot_type);
-
-DEF_DEV_ATTRIB(pi_prot_format);
-SE_DEV_ATTR(pi_prot_format, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(enforce_pr_isids);
-SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(is_nonrot);
-SE_DEV_ATTR(is_nonrot, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(emulate_rest_reord);
-SE_DEV_ATTR(emulate_rest_reord, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(force_pr_aptpl);
-SE_DEV_ATTR(force_pr_aptpl, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB_RO(hw_block_size);
-SE_DEV_ATTR_RO(hw_block_size);
-
-DEF_DEV_ATTRIB(block_size);
-SE_DEV_ATTR(block_size, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB_RO(hw_max_sectors);
-SE_DEV_ATTR_RO(hw_max_sectors);
-
-DEF_DEV_ATTRIB(fabric_max_sectors);
-SE_DEV_ATTR(fabric_max_sectors, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(optimal_sectors);
-SE_DEV_ATTR(optimal_sectors, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB_RO(hw_queue_depth);
-SE_DEV_ATTR_RO(hw_queue_depth);
-
-DEF_DEV_ATTRIB(queue_depth);
-SE_DEV_ATTR(queue_depth, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(max_unmap_lba_count);
-SE_DEV_ATTR(max_unmap_lba_count, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(max_unmap_block_desc_count);
-SE_DEV_ATTR(max_unmap_block_desc_count, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(unmap_granularity);
-SE_DEV_ATTR(unmap_granularity, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(unmap_granularity_alignment);
-SE_DEV_ATTR(unmap_granularity_alignment, S_IRUGO | S_IWUSR);
-
-DEF_DEV_ATTRIB(max_write_same_len);
-SE_DEV_ATTR(max_write_same_len, S_IRUGO | S_IWUSR);
-
 CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib, da_group);
 
-static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
-	&target_core_dev_attrib_emulate_model_alias.attr,
-	&target_core_dev_attrib_emulate_dpo.attr,
-	&target_core_dev_attrib_emulate_fua_write.attr,
-	&target_core_dev_attrib_emulate_fua_read.attr,
-	&target_core_dev_attrib_emulate_write_cache.attr,
-	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
-	&target_core_dev_attrib_emulate_tas.attr,
-	&target_core_dev_attrib_emulate_tpu.attr,
-	&target_core_dev_attrib_emulate_tpws.attr,
-	&target_core_dev_attrib_emulate_caw.attr,
-	&target_core_dev_attrib_emulate_3pc.attr,
-	&target_core_dev_attrib_pi_prot_type.attr,
-	&target_core_dev_attrib_hw_pi_prot_type.attr,
-	&target_core_dev_attrib_pi_prot_format.attr,
-	&target_core_dev_attrib_enforce_pr_isids.attr,
-	&target_core_dev_attrib_force_pr_aptpl.attr,
-	&target_core_dev_attrib_is_nonrot.attr,
-	&target_core_dev_attrib_emulate_rest_reord.attr,
-	&target_core_dev_attrib_hw_block_size.attr,
-	&target_core_dev_attrib_block_size.attr,
-	&target_core_dev_attrib_hw_max_sectors.attr,
-	&target_core_dev_attrib_fabric_max_sectors.attr,
-	&target_core_dev_attrib_optimal_sectors.attr,
-	&target_core_dev_attrib_hw_queue_depth.attr,
-	&target_core_dev_attrib_queue_depth.attr,
-	&target_core_dev_attrib_max_unmap_lba_count.attr,
-	&target_core_dev_attrib_max_unmap_block_desc_count.attr,
-	&target_core_dev_attrib_unmap_granularity.attr,
-	&target_core_dev_attrib_unmap_granularity_alignment.attr,
-	&target_core_dev_attrib_max_write_same_len.attr,
-	NULL,
-};
-
 static struct configfs_item_operations target_core_dev_attrib_ops = {
 	.show_attribute		= target_core_dev_attrib_attr_show,
 	.store_attribute	= target_core_dev_attrib_attr_store,
 };
 
-TB_CIT_SETUP(dev_attrib, &target_core_dev_attrib_ops, NULL,
-	     target_core_dev_attrib_attrs);
+TB_CIT_SETUP(dev_attrib, &target_core_dev_attrib_ops, NULL, NULL);
 
 /* End functions for struct config_item_type tb_dev_attrib_cit */
 
-- 
1.9.1

