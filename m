From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] target: Move fabric independent se_lun_acl free into ->release() callback
Date: Wed,  2 Feb 2011 03:10:46 -0800
Message-ID: <1296645046-7076-6-git-send-email-nab@linux-iscsi.org>
References: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24405 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753096Ab1BBLKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 06:10:50 -0500
In-Reply-To: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the call for core_dev_free_initiator_node_lun_acl() and
subsequent release of fabric independent struct se_lun_acl memory to inside
of the configfs callback target_fabric_mappedlun_item_ops->release() called
from within fs/configfs/item.c:config_item_cleanup() context.  This patch
resolves the following SLUB 'Poison overwritten' warning when calling
core_dev_free_initiator_node_lun_acl() directly after config_item_put()
for the fabric independent struct se_lun_acl->se_lun_group:

[ 3968.067934] =============================================================================
[ 3968.068257] BUG kmalloc-1024: Poison overwritten
[ 3968.068423] -----------------------------------------------------------------------------
[ 3968.068424]
[ 3968.068844] INFO: 0xffff88001ac5b8cc-0xffff88001ac5b8cc. First byte 0x6a instead of 0x6b
[ 3968.068844] INFO: Allocated in kzalloc+0xf/0x11 [target_core_mod] age=6749 cpu=0 pid=9707
[ 3968.068844] INFO: Freed in core_dev_free_initiator_node_lun_acl+0x6b/0x77 [target_core_mod] age=2 cpu=0 pid=9725
[ 3968.068844] INFO: Slab 0xffffea00005db340 objects=29 used=10 fp=0xffff88001ac5b7a8 flags=0x1000000000040c1
[ 3968.068844] INFO: Object 0xffff88001ac5b7a8 @offset=14248 fp=0xffff88001ac5c8c8

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 41fea37..0f2762a 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -215,12 +215,22 @@ TCM_MAPPEDLUN_ATTR(write_protect, S_IRUGO | S_IWUSR);
 
 CONFIGFS_EATTR_OPS(target_fabric_mappedlun, se_lun_acl, se_lun_group);
 
+static void target_fabric_mappedlun_release(struct config_item *item)
+{
+	struct se_lun_acl *lacl = container_of(to_config_group(item),
+				struct se_lun_acl, se_lun_group);
+	struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
+
+	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
+}
+
 static struct configfs_attribute *target_fabric_mappedlun_attrs[] = {
 	&target_fabric_mappedlun_write_protect.attr,
 	NULL,
 };
 
 static struct configfs_item_operations target_fabric_mappedlun_item_ops = {
+	.release		= target_fabric_mappedlun_release,
 	.show_attribute		= target_fabric_mappedlun_attr_show,
 	.store_attribute	= target_fabric_mappedlun_attr_store,
 	.allow_link		= target_fabric_mappedlun_link,
@@ -394,7 +404,6 @@ static void target_fabric_drop_mappedlun(
 {
 	struct se_lun_acl *lacl = container_of(to_config_group(item),
 			struct se_lun_acl, se_lun_group);
-	struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
 	struct config_item *df_item;
 	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
 	int i;
@@ -414,9 +423,10 @@ static void target_fabric_drop_mappedlun(
 		config_item_put(df_item);
 	}
 	kfree(lacl_cg->default_groups);
-
+	/*
+	 * struct se_lun_acl memory is released by target_fabric_mappedlun_release()
+	 */
 	config_item_put(item);
-	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
 }
 
 static void target_fabric_nacl_base_release(struct config_item *item)
-- 
1.5.6.5

