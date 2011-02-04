From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 07/12] target: Move fabric dependent struct se_wwn free into ->release() callback
Date: Thu,  3 Feb 2011 22:45:07 -0800
Message-ID: <1296801912-18857-8-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ac4.yahoo.com ([98.139.52.200]:46876 "HELO
	nm3.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752779Ab1BDGp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:26 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

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
index 32b148d..1ef3783 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -893,12 +893,26 @@ static void target_fabric_drop_tpg(
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
 
@@ -932,13 +946,7 @@ static void target_fabric_drop_wwn(
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
1.7.4

