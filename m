From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/24] target: Release left-over demo-mode NodeACLs w/ tfo->tpg_check_demo_mode_cache()=1
Date: Sat, 29 Jan 2011 10:36:10 -0800
Message-ID: <1296326184-16664-11-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10.bullet.mail.ac4.yahoo.com ([98.139.52.207]:43963 "HELO
	nm10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754736Ab1A2Sgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:36 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing struct se_portal_groups->acl_node_list walk & release
following target_core_transport.c:transport_deregister_session() logic with
tfo->tpg_check_demo_mode_cache()=1 mode for left-over demo-mode struct se_node_acl
dynamic allocations during the final core_tpg_deregister() shutdown sequence.

As with transport_deregister_session() w/ tfo->tpg_check_demo_mode_cache()=0, it
waits for any outstanding PR and MIBs references to be relinquished, and calls
core_free_device_list_for_node() to release individual demo-mode MappedLUNs from
struct se_node_acl->device_list[] via core_update_device_list_for_node().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 135c3f59ed66eb1a54dbbf9eca5eeade272b5259)
---
 drivers/target/target_core_tpg.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index abfa81a..d15deaf 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -701,6 +701,8 @@ EXPORT_SYMBOL(core_tpg_register);
 
 int core_tpg_deregister(struct se_portal_group *se_tpg)
 {
+	struct se_node_acl *nacl, *nacl_tmp;
+
 	printk(KERN_INFO "TARGET_CORE[%s]: Deallocating %s struct se_portal_group"
 		" for endpoint: %s Portal Tag %u\n",
 		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
@@ -714,6 +716,26 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
 		cpu_relax();
+	/*
+	 * Release any remaining demo-mode generated se_node_acl that have
+	 * not been released because of TFO->tpg_check_demo_mode_cache() == 1
+	 * in transport_deregister_session().
+	 */
+	spin_lock_bh(&se_tpg->acl_node_lock);
+	list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
+			acl_list) {
+		list_del(&nacl->acl_list);
+		se_tpg->num_node_acls--;
+		spin_unlock_bh(&se_tpg->acl_node_lock);
+
+		core_tpg_wait_for_nacl_pr_ref(nacl);
+		core_tpg_wait_for_mib_ref(nacl);
+		core_free_device_list_for_node(nacl, se_tpg);
+		TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg, nacl);
+
+		spin_lock_bh(&se_tpg->acl_node_lock);
+	}
+	spin_unlock_bh(&se_tpg->acl_node_lock);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
 		core_tpg_release_virtual_lun0(se_tpg);
-- 
1.7.3.5

