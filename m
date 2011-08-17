From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 20/21] target: Make locking in transport_deregister_session() IRQ safe
Date: Wed, 17 Aug 2011 23:17:24 +0000
Message-ID: <1313623045-15916-21-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58357 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1HQXmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:49 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

At least the tcm_qla2xxx fabric driver calls into transport_deregister_session()
while holding an IRQ-disabled spinlock, so the inner locking needs to
use spin_lock_irqsave() instead of spin_lock_bh().

This fixes warnings seen with tcm_qla2xxx like:

    WARNING: at kernel/softirq.c:159 local_bh_enable_ip+0x98/0xb0()
    Call Trace:
     [<ffffffff8104e65f>] warn_slowpath_common+0x7f/0xc0
     [<ffffffff8104e6ba>] warn_slowpath_null+0x1a/0x20
     [<ffffffff81055368>] local_bh_enable_ip+0x98/0xb0
     [<ffffffff814d5284>] _raw_spin_unlock_bh+0x14/0x20
     [<ffffffffa027b7f6>] transport_deregister_session+0x96/0x180 [target_core_mod]
     [<ffffffffa00f7731>] tcm_qla2xxx_free_session+0xd1/0x170 [tcm_qla2xxx]
     [<ffffffffa01b9173>] qla_tgt_sess_put+0xc3/0x140 [qla2xxx]
     [<ffffffffa01bf40f>] qla_tgt_stop_phase1+0x8f/0x2c0 [qla2xxx]
     [<ffffffffa00f735e>] tcm_qla2xxx_tpg_store_enable+0x6e/0xd0 [tcm_qla2xxx]
     [<ffffffffa026ca29>] target_fabric_tpg_attr_store+0x39/0x40 [target_core_mod]
     [<ffffffffa00a575d>] configfs_write_file+0xbd/0x120 [configfs]
     [<ffffffff811464a6>] vfs_write+0xc6/0x180
     [<ffffffff811467c1>] sys_write+0x51/0x90
     [<ffffffff814dd382>] system_call_fastpath+0x16/0x1b

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9cc49d1..8d0c58e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -389,17 +389,18 @@ void transport_deregister_session(struct se_session *se_sess)
 {
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
 	struct se_node_acl *se_nacl;
+	unsigned long flags;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
 		return;
 	}
 
-	spin_lock_bh(&se_tpg->session_lock);
+	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
 	se_sess->se_tpg = NULL;
 	se_sess->fabric_sess_ptr = NULL;
-	spin_unlock_bh(&se_tpg->session_lock);
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	/*
 	 * Determine if we need to do extra work for this initiator node's
@@ -407,22 +408,22 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 	se_nacl = se_sess->se_node_acl;
 	if (se_nacl) {
-		spin_lock_bh(&se_tpg->acl_node_lock);
+		spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
 		if (se_nacl->dynamic_node_acl) {
 			if (!se_tpg->se_tpg_tfo->tpg_check_demo_mode_cache(
 					se_tpg)) {
 				list_del(&se_nacl->acl_list);
 				se_tpg->num_node_acls--;
-				spin_unlock_bh(&se_tpg->acl_node_lock);
+				spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 
 				core_tpg_wait_for_nacl_pr_ref(se_nacl);
 				core_free_device_list_for_node(se_nacl, se_tpg);
 				se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg,
 						se_nacl);
-				spin_lock_bh(&se_tpg->acl_node_lock);
+				spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
 			}
 		}
-		spin_unlock_bh(&se_tpg->acl_node_lock);
+		spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 	}
 
 	transport_free_session(se_sess);
-- 
1.7.6

