From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Wait RCU grace-period before backend/fabric unload
Date: Thu, 30 Jul 2015 06:15:23 +0000
Message-ID: <1438236923-17889-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a v4.2-rc1 regression where backend driver
struct module unload immediately after ->free_device() has done
an internal call_rcu(), results in IRQ rcu_process_callbacks()
use-after-free paging OOPsen.

It adds a explicit synchronize_rcu() in target_backend_unregister()
to wait a full RCU grace period before releasing target_backend_ops
memory, and allowing TBO->module exit to proceed.

Also, go ahead and do the same for target_unregister_template()
to ensure se_deve_entry->rcu_head -> kfree_rcu() grace period has
passed, before allowing target_core_fabric_ops->owner module exit
to proceed.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 10 +++++++++-
 drivers/target/target_core_hba.c      | 10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c2e9fea..b4c3ae0 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -457,8 +457,16 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 		if (!strcmp(t->tf_ops->name, fo->name)) {
 			BUG_ON(atomic_read(&t->tf_access_cnt));
 			list_del(&t->tf_list);
+			mutex_unlock(&g_tf_lock);
+			/*
+			 * Allow any outstanding fabric se_deve_entry->rcu_head
+			 * grace periods to expire post kfree_rcu(), before allowing
+			 * fabric driver unload of target_core_fabric_ops->module
+			 * to proceed.
+			 */
+			synchronize_rcu();
 			kfree(t);
-			break;
+			return;
 		}
 	}
 	mutex_unlock(&g_tf_lock);
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 62ea4e8..0fb830b 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -84,8 +84,16 @@ void target_backend_unregister(const struct target_backend_ops *ops)
 	list_for_each_entry(tb, &backend_list, list) {
 		if (tb->ops == ops) {
 			list_del(&tb->list);
+			mutex_unlock(&backend_mutex);
+			/*
+			 * Allow any outstanding backend driver ->rcu_head grace
+			 * period to expire post ->free_device() -> call_rcu(),
+			 * before allowing backend driver module unload of
+			 * target_backend_ops->owner to proceed.
+			 */
+			synchronize_rcu();
 			kfree(tb);
-			break;
+			return;
 		}
 	}
 	mutex_unlock(&backend_mutex);
-- 
1.9.1
