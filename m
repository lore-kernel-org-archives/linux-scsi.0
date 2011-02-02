From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] target: Move fabric dependent se_portal_group free into ->release() callback
Date: Wed,  2 Feb 2011 03:10:43 -0800
Message-ID: <1296645046-7076-3-git-send-email-nab@linux-iscsi.org>
References: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24358 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753096Ab1BBLKn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 06:10:43 -0500
In-Reply-To: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the struct target_core_fabric_ops->fabric_drop_tpg() callback
and subsequent fabric dependent release of struct se_portal_group memory to
inside of the configfs callback target_fabric_tpg_base_item_ops->release()
called from within fs/configfs/item.c:config_item_cleanup() context.
This patch resolves the following SLUB 'Poison overwritten' warning when calling
tfc->fabric_drop_tpg() directly after config_item_put() for the fabric dependent
data structure containing struct se_portal_group->tpg_group:

[ 2283.331123] =============================================================================
[ 2283.331282] BUG lio_tpg_cache: Poison overwritten
[ 2283.331282] -----------------------------------------------------------------------------
[ 2283.331282]
[ 2283.331282] INFO: 0xffff880001e48b7c-0xffff880001e48b7c. First byte 0x6a instead of 0x6b
[ 2283.331282] INFO: Allocated in core_alloc_portal_group+0x24/0x102 [iscsi_target_mod] age=48820 cpu=0 pid=8220
[ 2283.331282] INFO: Freed in iscsi_tpg_del_portal_group+0x290/0x2a1 [iscsi_target_mod] age=34618 cpu=0 pid=8266
[ 2283.331282] INFO: Slab 0xffffea0000069fc0 objects=16 used=0 fp=0xffff880001e48000 flags=0x100000000004080
[ 2283.331282] INFO: Object 0xffff880001e487c0 @offset=1984 fp=0xffff880001e48f80

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 8410ee4..0de0ee2 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -963,7 +963,18 @@ TF_CIT_SETUP(tpg_param, &target_fabric_tpg_param_item_ops, NULL, NULL);
  */
 CONFIGFS_EATTR_OPS(target_fabric_tpg, se_portal_group, tpg_group);
 
+static void target_fabric_tpg_release(struct config_item *item)
+{
+	struct se_portal_group *se_tpg = container_of(to_config_group(item),
+			struct se_portal_group, tpg_group);
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct target_fabric_configfs *tf = wwn->wwn_tf;
+
+	tf->tf_ops.fabric_drop_tpg(se_tpg);
+}
+
 static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
+	.release		= target_fabric_tpg_release,
 	.show_attribute		= target_fabric_tpg_attr_show,
 	.store_attribute	= target_fabric_tpg_attr_store,
 };
@@ -1021,8 +1032,6 @@ static void target_fabric_drop_tpg(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_wwn *wwn = container_of(group, struct se_wwn, wwn_group);
-	struct target_fabric_configfs *tf = wwn->wwn_tf;
 	struct se_portal_group *se_tpg = container_of(to_config_group(item),
 				struct se_portal_group, tpg_group);
 	struct config_group *tpg_cg = &se_tpg->tpg_group;
@@ -1039,7 +1048,6 @@ static void target_fabric_drop_tpg(
 	}
 
 	config_item_put(item);
-	tf->tf_ops.fabric_drop_tpg(se_tpg);
 }
 
 static void target_fabric_release_wwn(struct config_item *item)
-- 
1.5.6.5

