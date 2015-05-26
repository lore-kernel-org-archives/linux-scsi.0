From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 09/10] target: Only reset specific dynamic entries during lun_group creation
Date: Tue, 26 May 2015 06:25:29 +0000
Message-ID: <1432621530-24171-10-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes core_tpg_add_node_to_devs() to avoid unnecessarly
resetting every se_dev_entry in se_node_acl->tpg_lun_hlist when the
operation is driven by an explicit configfs se_lun->lun_group creation
via core_dev_add_lun() to only update a single se_lun.

Otherwise for the second core_tpg_check_initiator_node_acl() case, go
ahead and continue to scan the full set of currently active se_lun in
se_portal_group->tpg_lun_hlist.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c   | 2 +-
 drivers/target/target_core_internal.h | 3 ++-
 drivers/target/target_core_tpg.c      | 7 +++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c95d3cf..8eac502 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1193,7 +1193,7 @@ int core_dev_add_lun(
 			if (acl->dynamic_node_acl &&
 			    (!tpg->se_tpg_tfo->tpg_check_demo_mode_login_only ||
 			     !tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg))) {
-				core_tpg_add_node_to_devs(acl, tpg);
+				core_tpg_add_node_to_devs(acl, tpg, lun);
 			}
 		}
 		mutex_unlock(&tpg->acl_node_mutex);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 2c160ce..ce80ca7 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -64,7 +64,8 @@ extern struct se_device *g_lun0_dev;
 
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
-void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
+void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
+				  struct se_lun *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 73c25bd..f66c208 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -89,7 +89,8 @@ EXPORT_SYMBOL(core_tpg_get_initiator_node_acl);
  */
 void core_tpg_add_node_to_devs(
 	struct se_node_acl *acl,
-	struct se_portal_group *tpg)
+	struct se_portal_group *tpg,
+	struct se_lun *lun_orig)
 {
 	u32 lun_access = 0;
 	struct se_lun *lun;
@@ -99,6 +100,8 @@ void core_tpg_add_node_to_devs(
 	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
 		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 			continue;
+		if (lun_orig && lun != lun_orig)
+			continue;
 
 		dev = lun->lun_se_dev;
 		/*
@@ -238,7 +241,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	 */
 	if ((tpg->se_tpg_tfo->tpg_check_demo_mode_login_only == NULL) ||
 	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) != 1))
-		core_tpg_add_node_to_devs(acl, tpg);
+		core_tpg_add_node_to_devs(acl, tpg, NULL);
 
 	target_add_node_acl(acl);
 	return acl;
-- 
1.9.1
