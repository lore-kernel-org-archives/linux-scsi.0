From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] target: Move core_delete_hba() into ->release() callback
Date: Wed,  2 Feb 2011 00:26:48 -0800
Message-ID: <1296635211-6269-2-git-send-email-nab@linux-iscsi.org>
References: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ac4.yahoo.com ([98.139.52.221]:22962 "HELO
	nm24.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753395Ab1BBI0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 03:26:52 -0500
In-Reply-To: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the core_delete_hba() call in target_core_call_delhbafromtarget()
and subsequent release struct se_hba memory to inside of the configfs callback
target_core_hba_item_ops->release() called from within fs/configfs/item.c:
config_item_cleanup() context.  This patch resolves the following SLUB
'Poison overwritten' warning while calling core_delete_hba() -> kfree(hba)
directly after config_item_put():

[ 1734.081444] =============================================================================
[ 1734.081635] BUG kmalloc-256: Poison overwritten
[ 1734.081635] -----------------------------------------------------------------------------
[ 1734.081635]
[ 1734.081635] INFO: 0xffff88000d290824-0xffff88000d290824. First byte 0x6a instead of 0x6b
[ 1734.081635] INFO: Allocated in core_alloc_hba+0x3a/0x231 [target_core_mod] age=3714 cpu=0 pid=11015
[ 1734.081635] INFO: Freed in core_delete_hba+0x8a/0x90 [target_core_mod] age=4 cpu=0 pid=11040
[ 1734.081635] INFO: Slab 0xffffea00002e0f80 objects=24 used=6 fp=0xffff88000d2907b0 flags=0x1000000000040c1
[ 1734.081635] INFO: Object 0xffff88000d2907b0 @offset=1968 fp=0xffff88000d290b88

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 7d7dfbc..ccb5554 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2998,6 +2998,13 @@ SE_HBA_ATTR(hba_mode, S_IRUGO | S_IWUSR);
 
 CONFIGFS_EATTR_OPS(target_core_hba, se_hba, hba_group);
 
+static void target_core_hba_release(struct config_item *item)
+{
+	struct se_hba *hba = container_of(to_config_group(item),
+				struct se_hba, hba_group);
+	core_delete_hba(hba);
+}
+
 static struct configfs_attribute *target_core_hba_attrs[] = {
 	&target_core_hba_hba_info.attr,
 	&target_core_hba_hba_mode.attr,
@@ -3005,6 +3012,7 @@ static struct configfs_attribute *target_core_hba_attrs[] = {
 };
 
 static struct configfs_item_operations target_core_hba_item_ops = {
+	.release		= target_core_hba_release,
 	.show_attribute		= target_core_hba_attr_show,
 	.store_attribute	= target_core_hba_attr_store,
 };
@@ -3081,10 +3089,11 @@ static void target_core_call_delhbafromtarget(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_hba *hba = item_to_hba(item);
-
+	/*
+	 * core_delete_hba() is called from target_core_hba_item_ops->release()
+	 * -> target_core_hba_release()
+	 */
 	config_item_put(item);
-	core_delete_hba(hba);
 }
 
 static struct configfs_group_operations target_core_group_ops = {
-- 
1.5.6.5

