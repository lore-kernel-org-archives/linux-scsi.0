From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 15/22] target: Convert core_tpg_deregister to use list splice
Date: Fri, 27 Mar 2015 08:05:05 +0000
Message-ID: <1427443512-8925-16-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_tpg_deregister() to perform a list splice
for any remaining dynamically generated se_node_acls attached to
se_tpg, before calling tfo->tpg_release_fabric_acl() to free memory.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 3d81a72..b5b4053 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -735,6 +735,7 @@ EXPORT_SYMBOL(core_tpg_register);
 int core_tpg_deregister(struct se_portal_group *se_tpg)
 {
 	struct se_node_acl *nacl, *nacl_tmp;
+	LIST_HEAD(node_list);
 
 	pr_debug("TARGET_CORE[%s]: Deallocating %s struct se_portal_group"
 		" for endpoint: %s Portal Tag %u\n",
@@ -750,25 +751,22 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
 		cpu_relax();
 
+	mutex_lock(&se_tpg->acl_node_mutex);
+	list_splice_init(&se_tpg->acl_node_list, &node_list);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 	/*
 	 * Release any remaining demo-mode generated se_node_acl that have
 	 * not been released because of TFO->tpg_check_demo_mode_cache() == 1
 	 * in transport_deregister_session().
 	 */
-	mutex_lock(&se_tpg->acl_node_mutex);
-	list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
-			acl_list) {
+	list_for_each_entry_safe(nacl, nacl_tmp, &node_list, acl_list) {
 		list_del(&nacl->acl_list);
 		se_tpg->num_node_acls--;
-		mutex_unlock(&se_tpg->acl_node_mutex);
 
 		core_tpg_wait_for_nacl_pr_ref(nacl);
 		core_free_device_list_for_node(nacl, se_tpg);
 		se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg, nacl);
-
-		mutex_lock(&se_tpg->acl_node_mutex);
 	}
-	mutex_unlock(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
-- 
1.9.1
