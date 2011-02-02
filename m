From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] target: Move fabric dependent struct se_wwn free into ->release() callback
Date: Wed,  2 Feb 2011 03:10:42 -0800
Message-ID: <1296645046-7076-2-git-send-email-nab@linux-iscsi.org>
References: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24344 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753096Ab1BBLKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 06:10:39 -0500
In-Reply-To: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the struct target_core_fabric_ops->fabric_drop_wwn() callback
and subsequent fabric dependent release of struct se_wwn memory to inside of
the configfs callback target_fabric_tpg_item_ops->release() called from within
fs/configfs/item.c:config_item_cleanup() context.  This patch resolves the
following SLUB 'Poison overwritten' warning when calling tfc->fabric_drop_wwn()
directly after config_item_put() for the fabric dependent data structure
containing struct se_wwn->wwn_group:

[ 1327.103030] =============================================================================
[ 1327.103063] BUG kmalloc-2048: Poison overwritten
[ 1327.103063] -----------------------------------------------------------------------------
[ 1327.103063]
[ 1327.103063] INFO: 0xffff8800030c89ac-0xffff8800030c89ac. First byte 0x6a instead of 0x6b
[ 1327.103063] INFO: Allocated in kzalloc+0xf/0x11 [iscsi_target_mod] age=15782 cpu=0 pid=5838
[ 1327.103063] INFO: Freed in __core_del_tiqn+0x5e/0x65 [iscsi_target_mod] age=113 cpu=0 pid=5870
[ 1327.103063] INFO: Slab 0xffffea00000aabc0 objects=15 used=3 fp=0xffff8800030c8848 flags=0x1000000000040c1
[ 1327.103063] INFO: Object 0xffff8800030c8848 @offset=2120 fp=0xffff8800030c8000

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ea49c9d..8410ee4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -1042,12 +1042,26 @@ static void target_fabric_drop_tpg(
 	tf->tf_ops.fabric_drop_tpg(se_tpg);
 }
 
+static void target_fabric_release_wwn(struct config_item *item)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item),
+				struct se_wwn, wwn_group);
+	struct target_fabric_configfs *tf = wwn->wwn_tf;
+
+	tf->tf_ops.fabric_drop_wwn(wwn);
+}
+
+static struct configfs_item_operations target_fabric_tpg_item_ops = {
+	.release	= target_fabric_release_wwn,
+};
+
 static struct configfs_group_operations target_fabric_tpg_group_ops = {
 	.make_group	= target_fabric_make_tpg,
 	.drop_item	= target_fabric_drop_tpg,
 };
 
-TF_CIT_SETUP(tpg, NULL, &target_fabric_tpg_group_ops, NULL);
+TF_CIT_SETUP(tpg, &target_fabric_tpg_item_ops, &target_fabric_tpg_group_ops,
+		NULL);
 
 /* End of tfc_tpg_cit */
 
@@ -1081,13 +1095,7 @@ static void target_fabric_drop_wwn(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct target_fabric_configfs *tf = container_of(group,
-				struct target_fabric_configfs, tf_group);
-	struct se_wwn *wwn = container_of(to_config_group(item),
-				struct se_wwn, wwn_group);
-
 	config_item_put(item);
-	tf->tf_ops.fabric_drop_wwn(wwn);
 }
 
 static struct configfs_group_operations target_fabric_wwn_group_ops = {
-- 
1.5.6.5

