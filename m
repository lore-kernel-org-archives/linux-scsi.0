From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/12] target: Move fabric independent se_lun_acl free into ->release() callback
Date: Thu,  3 Feb 2011 22:45:11 -0800
Message-ID: <1296801912-18857-12-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4.bullet.mail.ac4.yahoo.com ([98.139.52.201]:40590 "HELO
	nm4.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753066Ab1BDGpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:35 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

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
 drivers/target/target_core_fabric_configfs.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 9b6dd20..b65d1c8 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -214,12 +214,22 @@ TCM_MAPPEDLUN_ATTR(write_protect, S_IRUGO | S_IWUSR);
 
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
@@ -337,12 +347,7 @@ static void target_fabric_drop_mappedlun(
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_lun_acl *lacl = container_of(to_config_group(item),
-			struct se_lun_acl, se_lun_group);
-	struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
-
 	config_item_put(item);
-	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
 }
 
 static void target_fabric_nacl_base_release(struct config_item *item)
-- 
1.7.4

