From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during get_initiator_node_acl
Date: Fri,  8 Jan 2016 07:15:45 +0000
Message-ID: <1452237348-2277-2-git-send-email-nab@daterainc.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35497 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbcAHHRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 02:17:53 -0500
Received: by mail-oi0-f47.google.com with SMTP id l9so301842884oia.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2016 23:17:53 -0800 (PST)
In-Reply-To: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a long standing race where obtaining
se_node_acl->acl_kref in __transport_register_session()
happens a bit too late, and leaves open the potential
for core_tpg_del_initiator_node_acl() to hit a NULL
pointer dereference.

Instead, get ->acl_kref in core_tpg_get_initiator_node_acl()
while se_portal_group->acl_node_mutex is held, and move the
final target_put_nacl() from transport_deregister_session()
into transport_free_session() so that fabric driver login
failure handling using the modern method to still work
as expected.

Note the existing wait_for_completion(&acl->acl_free_comp)
in core_tpg_del_initiator_node_acl() does not change.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c       |  6 ++++++
 drivers/target/target_core_transport.c | 18 ++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 62103a8..fb77fe1 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -78,6 +78,12 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 
 	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	/*
+	 * Obtain the acl_kref now, which will be dropped upon the
+	 * release of se_sess memory within transport_free_session().
+	 */
+	if (acl)
+		kref_get(&acl->acl_kref);
 	mutex_unlock(&tpg->acl_node_mutex);
 
 	return acl;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index eb7aaf0..81cc699 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -341,7 +341,6 @@ void __transport_register_session(
 					&buf[0], PR_REG_ISID_LEN);
 			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
 		}
-		kref_get(&se_nacl->acl_kref);
 
 		spin_lock_irq(&se_nacl->nacl_sess_lock);
 		/*
@@ -464,6 +463,15 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 
 void transport_free_session(struct se_session *se_sess)
 {
+	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+	/*
+	 * Drop the se_node_acl->nacl_kref obtained from within
+	 * core_tpg_get_initiator_node_acl().
+	 */
+	if (se_nacl) {
+		se_sess->se_node_acl = NULL;
+		target_put_nacl(se_nacl);
+	}
 	if (se_sess->sess_cmd_map) {
 		percpu_ida_destroy(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
@@ -478,7 +486,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	const struct target_core_fabric_ops *se_tfo;
 	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool comp_nacl = true, drop_nacl = false;
+	bool drop_nacl = false;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
@@ -510,18 +518,16 @@ void transport_deregister_session(struct se_session *se_sess)
 	if (drop_nacl) {
 		core_tpg_wait_for_nacl_pr_ref(se_nacl);
 		core_free_device_list_for_node(se_nacl, se_tpg);
+		se_sess->se_node_acl = NULL;
 		kfree(se_nacl);
-		comp_nacl = false;
 	}
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
-	 * removal context.
+	 * removal context from within transport_free_session() code.
 	 */
-	if (se_nacl && comp_nacl)
-		target_put_nacl(se_nacl);
 
 	transport_free_session(se_sess);
 }
-- 
1.9.1

