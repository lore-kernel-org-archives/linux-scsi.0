From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] target: Move core_alua_free_tg_pt_gp() into ->release() callback
Date: Wed,  2 Feb 2011 00:26:51 -0800
Message-ID: <1296635211-6269-5-git-send-email-nab@linux-iscsi.org>
References: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26.bullet.mail.ac4.yahoo.com ([98.139.52.223]:42096 "HELO
	nm26.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753690Ab1BBI1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 03:27:01 -0500
In-Reply-To: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the core_alua_free_tg_pt_gp() and subsequent release of
struct t10_alua_tg_pt_gp memory to inside of the configfs callback
target_core_alua_tg_pt_gp_ops->release() called from within
fs/configfs/item.c:config_item_cleanup() context.  This patch resolves
the following SLUB 'Poison overwritten' warning when calling
core_alua_free_tg_pt_gp() -> kfree(tg_pt_gp) directly after config_item_put():

[10703.173250] =============================================================================
[10703.173250] BUG t10_alua_tg_pt_gp_cache: Poison overwritten
[10703.173250] -----------------------------------------------------------------------------
[10703.173250]
[10703.173250] INFO: 0xffff88001eb1637c-0xffff88001eb1637c. First byte 0x6a instead of 0x6b
[10703.173250] INFO: Allocated in core_alua_allocate_tg_pt_gp+0x21/0x126 [target_core_mod] age=2297 cpu=0 pid=21770
[10703.173250] INFO: Freed in core_alua_free_tg_pt_gp+0xf2/0xfe [target_core_mod] age=67 cpu=0 pid=21775
[10703.173250] INFO: Slab 0xffffea00006b6cd0 objects=21 used=0 fp=0xffff88001eb16000 flags=0x100000000004080
[10703.173250] INFO: Object 0xffff88001eb16300 @offset=768 fp=0xffff88001eb16480

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3933409..5be35b8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2615,7 +2615,16 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	NULL,
 };
 
+static void target_core_alua_tg_pt_gp_release(struct config_item *item)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
+			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
+
+	core_alua_free_tg_pt_gp(tg_pt_gp);
+}
+
 static struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
+	.release		= target_core_alua_tg_pt_gp_release,
 	.show_attribute		= target_core_alua_tg_pt_gp_attr_show,
 	.store_attribute	= target_core_alua_tg_pt_gp_attr_store,
 };
@@ -2668,9 +2677,11 @@ static void target_core_alua_drop_tg_pt_gp(
 	printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Target Port"
 		" Group: alua/tg_pt_gps/%s, ID: %hu\n",
 		config_item_name(item), tg_pt_gp->tg_pt_gp_id);
-
+	/*
+	 * core_alua_free_tg_pt_gp() is called from target_core_alua_tg_pt_gp_ops->release()
+	 * -> target_core_alua_tg_pt_gp_release().
+	 */
 	config_item_put(item);
-	core_alua_free_tg_pt_gp(tg_pt_gp);
 }
 
 static struct configfs_group_operations target_core_alua_tg_pt_gps_group_ops = {
@@ -2910,7 +2921,10 @@ static void target_core_drop_subdev(
 		config_item_put(df_item);
 	}
 	kfree(tg_pt_gp_cg->default_groups);
-	core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
+	/*
+	 * core_alua_free_tg_pt_gp() is called from ->default_tg_pt_gp
+	 * directly from target_core_alua_tg_pt_gp_release().
+	 */
 	T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
 
 	dev_cg = &se_dev->se_dev_group;
-- 
1.5.6.5

