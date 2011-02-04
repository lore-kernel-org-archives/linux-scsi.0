From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 09/12] target: Move fabric dependent se_node_acl free into ->release callback()
Date: Thu,  3 Feb 2011 22:45:09 -0800
Message-ID: <1296801912-18857-10-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9.bullet.mail.ac4.yahoo.com ([98.139.52.206]:37551 "HELO
	nm9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752779Ab1BDGpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:30 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the struct target_core_fabric_ops->fabric_drop_nodeacl()
callback and subsequent fabric dependent release of struct se_node_acl memory
to the configfs callback target_fabric_nacl_base_item_ops->release() called
from within fs/configfs/item.c:config_item_cleanup() context.  This patch
resolves the following SLUB 'Poison overwritten' warning when calling
tfc->fabric_drop_node_acl() directly after config_item_put() for the fabric
dependent data structure containing struct se_node_acl->acl_group:

[ 2500.148656] =============================================================================
[ 2500.148656] BUG kmalloc-2048: Poison overwritten
[ 2500.148656] -----------------------------------------------------------------------------
[ 2500.148656]
[ 2500.148656] INFO: 0xffff880001e6a6f4-0xffff880001e6a6f4. First byte 0x6a instead of 0x6b
[ 2500.148656] INFO: Allocated in 0xffffffffa02b9e55 age=265456 cpu=0 pid=8233
[ 2500.148656] INFO: Freed in 0xffffffffa02c8f9b age=251652 cpu=0 pid=8244
[ 2500.148656] INFO: Slab 0xffffea000006a6c0 objects=15 used=5 fp=0xffff880001e6a120 flags=0x1000000000040c1
[ 2500.148656] INFO: Object 0xffff880001e6a120 @offset=8480 fp=0xffff880001e698d8

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 225284d..dfa3267 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -345,7 +345,18 @@ static void target_fabric_drop_mappedlun(
 	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
 }
 
+static void target_fabric_nacl_base_release(struct config_item *item)
+{
+	struct se_node_acl *se_nacl = container_of(to_config_group(item),
+			struct se_node_acl, acl_group);
+	struct se_portal_group *se_tpg = se_nacl->se_tpg;
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+
+	tf->tf_ops.fabric_drop_nodeacl(se_nacl);
+}
+
 static struct configfs_item_operations target_fabric_nacl_base_item_ops = {
+	.release		= target_fabric_nacl_base_release,
 	.show_attribute		= target_fabric_nacl_base_attr_show,
 	.store_attribute	= target_fabric_nacl_base_attr_store,
 };
@@ -404,9 +415,6 @@ static void target_fabric_drop_nodeacl(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_portal_group *se_tpg = container_of(group,
-			struct se_portal_group, tpg_acl_group);
-	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 	struct se_node_acl *se_nacl = container_of(to_config_group(item),
 			struct se_node_acl, acl_group);
 	struct config_item *df_item;
@@ -419,9 +427,10 @@ static void target_fabric_drop_nodeacl(
 		nacl_cg->default_groups[i] = NULL;
 		config_item_put(df_item);
 	}
-
+	/*
+	 * struct se_node_acl free is done in target_fabric_nacl_base_release()
+	 */
 	config_item_put(item);
-	tf->tf_ops.fabric_drop_nodeacl(se_nacl);
 }
 
 static struct configfs_group_operations target_fabric_nacl_group_ops = {
-- 
1.7.4

