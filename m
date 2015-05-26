From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v3 07/10] target: Convert core_tpg_deregister to use list splice
Date: Tue, 26 May 2015 06:40:27 +0000
Message-ID: <1432622430-25253-8-git-send-email-nab@linux-iscsi.org>
References: <1432622430-25253-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.23.28.174] ([67.23.28.174]:60007 "EHLO linux-iscsi.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751970AbbEZGpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2015 02:45:15 -0400
In-Reply-To: <1432622430-25253-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_tpg_deregister() to perform a list splice
for any remaining dynamically generated se_node_acls attached to
se_tpg, before calling kfree(nacl) to free memory.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 229e827..e7745d2 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -547,6 +547,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
 	struct se_node_acl *nacl, *nacl_tmp;
+	LIST_HEAD(node_list);
 
 	pr_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, "
 		 "Proto: %d, Portal Tag: %u\n", tfo->get_fabric_name(),
@@ -560,25 +561,22 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
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
 		kfree(nacl);
-
-		mutex_lock(&se_tpg->acl_node_mutex);
 	}
-	mutex_unlock(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
-- 
1.9.1

