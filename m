From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 21/31] target: Move core_alua_free_lu_gp() into ->release() callback
Date: Wed,  9 Feb 2011 15:34:56 -0800
Message-ID: <1297294506-23579-22-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ne1.yahoo.com ([98.138.90.66]:38557 "HELO
	nm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756049Ab1BIXfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:47 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the core_alua_free_lu_gp() and subsequent release of
struct t10_alua_lu_gp memory to inside of the configfs callback
target_core_alua_lu_gp_ops->release() called from within
fs/configfs/item.c:config_item_cleanup() context.  This patch resolves the
following SLUB 'Poison overwritten' warning when calling core_alua_free_lu_gp()
-> kfree(lu_gp) directly after config_item_put():

[  293.452366] =============================================================================
[  293.452653] BUG t10_alua_lu_gp_cache: Poison overwritten
[  293.452653] -----------------------------------------------------------------------------
[  293.452653]
[  293.452653] INFO: 0xffff88001f7c2174-0xffff88001f7c2174. First byte 0x6a instead of 0x6b
[  293.452653] INFO: Allocated in core_alua_allocate_lu_gp+0x1c/0xa0 [target_core_mod] age=1799 cpu=0 pid=5229
[  293.452653] INFO: Freed in core_alua_free_lu_gp+0x105/0x111 [target_core_mod] age=52 cpu=0 pid=5235
[  293.452653] INFO: Slab 0xffffea00006e3270 objects=25 used=0 fp=0xffff88001f7c2000 flags=0x100000000004080
[  293.452653] INFO: Object 0xffff88001f7c2140 @offset=320 fp=0xffff88001f7c2280
[  293.452653]

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 812eb8b..af1dd98 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2194,7 +2194,16 @@ static struct configfs_attribute *target_core_alua_lu_gp_attrs[] = {
 	NULL,
 };
 
+static void target_core_alua_lu_gp_release(struct config_item *item)
+{
+	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
+			struct t10_alua_lu_gp, lu_gp_group);
+
+	core_alua_free_lu_gp(lu_gp);
+}
+
 static struct configfs_item_operations target_core_alua_lu_gp_ops = {
+	.release		= target_core_alua_lu_gp_release,
 	.show_attribute		= target_core_alua_lu_gp_attr_show,
 	.store_attribute	= target_core_alua_lu_gp_attr_store,
 };
@@ -2245,9 +2254,11 @@ static void target_core_alua_drop_lu_gp(
 	printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Logical Unit"
 		" Group: core/alua/lu_gps/%s, ID: %hu\n",
 		config_item_name(item), lu_gp->lu_gp_id);
-
+	/*
+	 * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops->release()
+	 * -> target_core_alua_lu_gp_release()
+	 */
 	config_item_put(item);
-	core_alua_free_lu_gp(lu_gp);
 }
 
 static struct configfs_group_operations target_core_alua_lu_gps_group_ops = {
-- 
1.7.4

