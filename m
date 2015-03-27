From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 03/22] target/device: Convert se_node_acl->device_list access to RCU reader
Date: Fri, 27 Mar 2015 08:04:53 +0000
Message-ID: <1427443512-8925-4-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts various target_core_device.c to RCU reader path
to extract deve->mapped_lun before rcu_read_unlock() ahead of invoking
core_disable_device_list_for_node() to trigger subsequent RCU updater
code.

It includes core_free_device_list_for_node(), core_clear_lun_from_tpg(),
core_clear_initiator_node_from_tpg(), and core_update_device_list_access()
updates.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 52 +++++++++++++++++++------------------
 drivers/target/target_core_tpg.c    | 22 ++++++++--------
 2 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9385e16..1053a2d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -257,32 +257,33 @@ int core_free_device_list_for_node(
 {
 	struct se_dev_entry *deve;
 	struct se_lun *lun;
-	u32 i;
+	u32 i, mapped_lun;
 
-	if (!nacl->device_list)
+	if (!nacl->lun_entry_hlist)
 		return 0;
 
-	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
+		rcu_read_lock();
+		deve = rcu_dereference(nacl->lun_entry_hlist[i]);
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)) {
+			rcu_read_unlock();
 			continue;
-
+		}
 		if (!deve->se_lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
+			rcu_read_unlock();
 			continue;
 		}
 		lun = deve->se_lun;
+		mapped_lun = deve->mapped_lun;
+		rcu_read_unlock();
 
-		spin_unlock_irq(&nacl->device_list_lock);
-		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
-		spin_lock_irq(&nacl->device_list_lock);
+		core_disable_device_list_for_node(lun, NULL, mapped_lun,
+					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
 
 	array_free(nacl->lun_entry_hlist, TRANSPORT_MAX_LUNS_PER_TPG);
 	nacl->lun_entry_hlist = NULL;
@@ -297,8 +298,8 @@ void core_update_device_list_access(
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[mapped_lun];
+	spin_lock_irq(&nacl->lun_entry_lock);
+	deve = rcu_dereference(nacl->lun_entry_hlist[mapped_lun]);
 	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
@@ -306,7 +307,9 @@ void core_update_device_list_access(
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->lun_entry_lock);
+
+	synchronize_rcu();
 }
 
 /*      core_enable_device_list_for_node():
@@ -442,26 +445,25 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 {
 	struct se_node_acl *nacl;
 	struct se_dev_entry *deve;
-	u32 i;
+	u32 i, mapped_lun;
 
 	spin_lock_irq(&tpg->acl_node_lock);
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 		spin_unlock_irq(&tpg->acl_node_lock);
 
-		spin_lock_irq(&nacl->device_list_lock);
 		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-			deve = nacl->device_list[i];
-			if (lun != deve->se_lun)
+			rcu_read_lock();
+			deve = rcu_dereference(nacl->lun_entry_hlist[i]);
+			if (!deve || lun != deve->se_lun) {
+				rcu_read_unlock();
 				continue;
-			spin_unlock_irq(&nacl->device_list_lock);
-
-			core_disable_device_list_for_node(lun, NULL,
-				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
-				nacl, tpg);
+			}
+			mapped_lun = deve->mapped_lun;
+			rcu_read_unlock();
 
-			spin_lock_irq(&nacl->device_list_lock);
+			core_disable_device_list_for_node(lun, NULL, mapped_lun,
+					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 		}
-		spin_unlock_irq(&nacl->device_list_lock);
 
 		spin_lock_irq(&tpg->acl_node_lock);
 	}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b2fdba5..15a683b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -55,32 +55,32 @@ static void core_clear_initiator_node_from_tpg(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
-	int i;
 	struct se_dev_entry *deve;
 	struct se_lun *lun;
+	u32 i, mapped_lun;
 
-	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
+		rcu_read_lock();
+		deve = rcu_dereference(nacl->lun_entry_hlist[i]);
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)) {
+			rcu_read_unlock();
 			continue;
-
+		}
 		if (!deve->se_lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
+			rcu_read_unlock();
 			continue;
 		}
-
 		lun = deve->se_lun;
-		spin_unlock_irq(&nacl->device_list_lock);
-		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
+		mapped_lun = deve->mapped_lun;
+		rcu_read_unlock();
 
-		spin_lock_irq(&nacl->device_list_lock);
+		core_disable_device_list_for_node(lun, NULL, mapped_lun,
+					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
 }
 
 /*	__core_tpg_get_initiator_node_acl():
-- 
1.9.1
