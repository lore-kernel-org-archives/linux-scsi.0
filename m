From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 31/32] target: Don't release and re-acquire some spinlocks in loops
Date: Fri, 13 Dec 2013 15:59:19 -0800
Message-ID: <1386979160-6928-32-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab3LMX7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:38 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Here are some instances where we're looping, but then dropping the
spinlock around the loop in the loop, because we need to be able to
sleep in the calls. Since everything is refcounted now, this should no
longer be needed and we can just hold the locks the whole time.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c |    4 ----
 drivers/target/target_core_tpg.c    |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a432d7b..3896c99 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -463,7 +463,6 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 
 	spin_lock_irq(&tpg->acl_node_lock);
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_node) {
-		spin_unlock_irq(&tpg->acl_node_lock);
 
 		spin_lock_irq(&nacl->device_list_lock);
 		rbtree_postorder_for_each_entry_safe(deve, _tmp, &nacl->rb_device_list, rb_node) {
@@ -473,7 +472,6 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 		}
 		spin_unlock_irq(&nacl->device_list_lock);
 
-		spin_lock_irq(&tpg->acl_node_lock);
 	}
 	spin_unlock_irq(&tpg->acl_node_lock);
 }
@@ -1141,9 +1139,7 @@ int core_dev_add_lun(
 			if (acl->dynamic_node_acl &&
 			    (!tpg->se_tpg_tfo->tpg_check_demo_mode_login_only ||
 			     !tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg))) {
-				spin_unlock_irq(&tpg->acl_node_lock);
 				core_tpg_add_node_to_devs(acl, tpg);
-				spin_lock_irq(&tpg->acl_node_lock);
 			}
 		}
 		spin_unlock_irq(&tpg->acl_node_lock);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 30af019..1bcb665 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -172,8 +172,6 @@ void core_tpg_add_node_to_devs(
 	for (node = rb_first(&tpg->rb_tpg_lun_list); node; node = rb_next(node)) {
 		struct se_lun *lun = rb_entry(node, struct se_lun, rb_node);
 
-		spin_unlock(&tpg->tpg_lun_lock);
-
 		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
@@ -201,7 +199,6 @@ void core_tpg_add_node_to_devs(
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 				lun_access, acl, tpg);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);
 }
@@ -299,9 +296,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 		if (!lun->lun_se_dev)
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
 		core_dev_del_lun(tpg, lun);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);
 }
-- 
1.7.1

