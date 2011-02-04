From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/12] target: Move fabric dependent struct se_tpg_np free into ->release() callback
Date: Thu,  3 Feb 2011 22:45:10 -0800
Message-ID: <1296801912-18857-11-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.250]:34642 "HELO
	nm30-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753051Ab1BDGpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:32 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the struct target_core_fabric_ops->fabric_drop_np() callback
and subsequent fabric dependent release of struct se_tpg_np memory to the
configfs callback target_fabric_np_base_item_ops->release() called from within
fs/configfs/item.c:config_item_cleanup() context.  This patch resolves the
following SLUB 'Poison overwritten' warning when calling tfc->fabric_drop_np()
directly after config_item_put() for the fabric dependent data structure
containing struct se_tpg_np->tpg_np_group:

[ 3967.988931] =============================================================================
[ 3967.989501] BUG kmalloc-512: Poison overwritten
[ 3967.989692] -----------------------------------------------------------------------------
[ 3967.989692]
[ 3967.989692] INFO: 0xffff880012255524-0xffff880012255524. First byte 0x6a instead of 0x6b
[ 3967.989692] INFO: Allocated in kzalloc+0xf/0x11 [iscsi_target_mod] age=6769 cpu=0 pid=9702
[ 3967.989692] INFO: Freed in iscsi_tpg_del_network_portal+0x18e/0x205 [iscsi_target_mod] age=7 cpu=0 pid=9723
[ 3967.989692] INFO: Slab 0xffffea00003f8260 objects=28 used=12 fp=0xffff880012255488 flags=0x1000000000040c1
[ 3967.989692] INFO: Object 0xffff880012255488 @offset=5256 fp=0xffff880012255b60

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   22 +++++++++++++++-------
 include/target/target_core_base.h            |    1 +
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index dfa3267..9b6dd20 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -446,7 +446,18 @@ TF_CIT_SETUP(tpg_nacl, NULL, &target_fabric_nacl_group_ops, NULL);
 
 CONFIGFS_EATTR_OPS(target_fabric_np_base, se_tpg_np, tpg_np_group);
 
+static void target_fabric_np_base_release(struct config_item *item)
+{
+	struct se_tpg_np *se_tpg_np = container_of(to_config_group(item),
+				struct se_tpg_np, tpg_np_group);
+	struct se_portal_group *se_tpg = se_tpg_np->tpg_np_parent;
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+
+	tf->tf_ops.fabric_drop_np(se_tpg_np);
+}
+
 static struct configfs_item_operations target_fabric_np_base_item_ops = {
+	.release		= target_fabric_np_base_release,
 	.show_attribute		= target_fabric_np_base_attr_show,
 	.store_attribute	= target_fabric_np_base_attr_store,
 };
@@ -475,6 +486,7 @@ static struct config_group *target_fabric_make_np(
 	if (!(se_tpg_np) || IS_ERR(se_tpg_np))
 		return ERR_PTR(-EINVAL);
 
+	se_tpg_np->tpg_np_parent = se_tpg;
 	config_group_init_type_name(&se_tpg_np->tpg_np_group, name,
 			&TF_CIT_TMPL(tf)->tfc_tpg_np_base_cit);
 
@@ -485,14 +497,10 @@ static void target_fabric_drop_np(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_portal_group *se_tpg = container_of(group,
-				struct se_portal_group, tpg_np_group);
-	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
-	struct se_tpg_np *se_tpg_np = container_of(to_config_group(item),
-				struct se_tpg_np, tpg_np_group);
-
+	/*
+	 * struct se_tpg_np is released via target_fabric_np_base_release()
+	 */
 	config_item_put(item);
-	tf->tf_ops.fabric_drop_np(se_tpg_np);
 }
 
 static struct configfs_group_operations target_fabric_np_group_ops = {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 574bafd..b638eae 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -873,6 +873,7 @@ struct se_port {
 } ____cacheline_aligned;
 
 struct se_tpg_np {
+	struct se_portal_group *tpg_np_parent;
 	struct config_group	tpg_np_group;
 } ____cacheline_aligned;
 
-- 
1.7.4

