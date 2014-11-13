From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/3] target: Remove TRANSPORT_LUNFLAGS_NO_ACCESS
Date: Thu, 13 Nov 2014 12:50:57 -0800
Message-ID: <1415911858-3123-2-git-send-email-agrover@redhat.com>
References: <1415911858-3123-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041AbaKMUvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2014 15:51:04 -0500
In-Reply-To: <1415911858-3123-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

Only used as a param to core_disable_device_list_for_node(), but that
function doesn't use it.

Change function signature to remove that param, and change all callsites
to not pass LUNFLAGS_NO_ACCESS.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c   | 8 +++-----
 drivers/target/target_core_internal.h | 2 +-
 drivers/target/target_core_tpg.c      | 2 +-
 include/target/target_core_base.h     | 1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f32a02d..5a511c6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -262,7 +262,7 @@ int core_free_device_list_for_node(
 
 		spin_unlock_irq(&nacl->device_list_lock);
 		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
+			nacl, tpg);
 		spin_lock_irq(&nacl->device_list_lock);
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
@@ -368,7 +368,6 @@ int core_disable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
 	u32 mapped_lun,
-	u32 lun_access,
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
@@ -436,8 +435,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 			spin_unlock_irq(&nacl->device_list_lock);
 
 			core_disable_device_list_for_node(lun, NULL,
-				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
-				nacl, tpg);
+				deve->mapped_lun, nacl, tpg);
 
 			spin_lock_irq(&nacl->device_list_lock);
 		}
@@ -1430,7 +1428,7 @@ int core_dev_del_initiator_node_lun_acl(
 	spin_unlock(&lun->lun_acl_lock);
 
 	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
-		TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
+		nacl, tpg);
 
 	lacl->se_lun = NULL;
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 2aab22b..1b54f3c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -12,7 +12,7 @@ void	core_update_device_list_access(u32, bool, struct se_node_acl *);
 int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, bool, struct se_node_acl *, struct se_portal_group *);
 int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
-		u32, u32, struct se_node_acl *, struct se_portal_group *);
+		u32, struct se_node_acl *, struct se_portal_group *);
 void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
 int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index da21294..bc9ff92 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -76,7 +76,7 @@ static void core_clear_initiator_node_from_tpg(
 		lun = deve->se_lun;
 		spin_unlock_irq(&nacl->device_list_lock);
 		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
+			nacl, tpg);
 
 		spin_lock_irq(&nacl->device_list_lock);
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1a3aa44..0558782 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -175,7 +175,6 @@ enum se_cmd_flags_table {
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
 enum transport_lunflags_table {
-	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
 	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
 	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
 };
-- 
1.9.3

