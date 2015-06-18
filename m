From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] tcm_loop: Send I_T_NEXUS_LOSS_OCCURRED UA
Date: Thu, 18 Jun 2015 11:43:38 +0200
Message-ID: <1434620622-65391-5-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbbFRJnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 05:43:45 -0400
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

If the virtual SAS link is set to 'offline' we should be
queueing an I_T_NEXUS_LOSS_OCCURRED UA.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c  |  5 +++++
 drivers/target/target_core_tpg.c    | 17 +++++++++++++++++
 include/target/target_core_fabric.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index d77caf5..6c724dd 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1087,6 +1087,11 @@ static ssize_t tcm_loop_tpg_store_transport_status(
 	}
 	if (!strncmp(page, "offline", 7)) {
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_OFFLINE;
+		if (tl_tpg->tl_nexus) {
+			struct se_session *tl_sess = tl_tpg->tl_nexus->se_sess;
+
+			core_allocate_nexus_loss_ua(tl_sess->se_node_acl);
+		}
 		return count;
 	}
 	return -EINVAL;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index aa39bc8..94c531e 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -43,6 +43,7 @@
 #include "target_core_internal.h"
 #include "target_core_alua.h"
 #include "target_core_pr.h"
+#include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
 
@@ -85,6 +86,22 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 }
 EXPORT_SYMBOL(core_tpg_get_initiator_node_acl);
 
+void core_allocate_nexus_loss_ua(
+	struct se_node_acl *nacl)
+{
+	struct se_dev_entry *deve;
+
+	if (!nacl)
+		return;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+		core_scsi3_ua_allocate(deve, 0x29,
+			ASCQ_29H_NEXUS_LOSS_OCCURRED);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(core_allocate_nexus_loss_ua);
+
 /*	core_tpg_add_node_to_devs():
  *
  *
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 18afef9..69355fe 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -152,6 +152,7 @@ int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
 void	__target_execute_cmd(struct se_cmd *);
 int	transport_lookup_tmr_lun(struct se_cmd *, u64);
+void	core_allocate_nexus_loss_ua(struct se_node_acl *acl);
 
 struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
-- 
1.8.5.2

