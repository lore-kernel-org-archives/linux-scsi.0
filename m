From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 01/22] target: Convert transport_lookup_*_lun to RCU reader
Date: Fri, 27 Mar 2015 08:04:51 +0000
Message-ID: <1427443512-8925-2-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34951 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbbC0IGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:01 -0400
Received: by oiag65 with SMTP id g65so69887381oia.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:00 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts transport_lookup_*_lun() fast-path code to
use RCU read path primitives when looking up se_dev_entry.  It
adds a new array of pointers in se_node_acl->lun_entry_hlist
for this purpose.

For transport_lookup_cmd_lun() code, it works with existing per-cpu
se_lun->lun_ref when associating se_cmd with se_lun + se_device.

Also, go ahead and update core_create_device_list_for_node() +
core_free_device_list_for_node() to use ->lun_entry_hlist.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 45 +++++++++++++++++++++++++------------
 drivers/target/target_core_tpg.c    | 10 +++++----
 include/target/target_core_base.h   |  2 ++
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 37449bd..be893c8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -59,17 +59,24 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev;
-	unsigned long flags;
+	struct se_dev_entry *deve;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return TCM_NON_EXISTENT_LUN;
 
-	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
-	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		struct se_dev_entry *deve = se_cmd->se_deve;
-
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[unpacked_lun]);
+	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+		/*
+		 * Make sure that target_enable_device_list_for_node()
+		 * has not already cleared the RCU protected pointers.
+		 */
+		if (!deve->se_lun) {
+			rcu_read_unlock();
+			goto check_lun;
+		}
 		deve->total_cmds++;
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
@@ -78,7 +85,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 				" Access for 0x%08x\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
-			spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
 		}
 
@@ -96,8 +103,9 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
+check_lun:
 	if (!se_lun) {
 		/*
 		 * Use the se_portal_group->tpg_virt_lun0 to allow for
@@ -146,25 +154,34 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	unsigned long flags;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return -ENODEV;
 
-	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
-	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	deve = se_cmd->se_deve;
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[unpacked_lun]);
 
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+		/*
+		 * Make sure that target_enable_device_list_for_node()
+		 * has not already cleared the RCU protected pointers.
+		 */
+		if (!deve->se_lun) {
+			rcu_read_unlock();
+			goto check_lun;
+		}
 		se_tmr->tmr_lun = deve->se_lun;
 		se_cmd->se_lun = deve->se_lun;
 		se_lun = deve->se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
+check_lun:
 	if (!se_lun) {
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			" Access for 0x%08x\n",
@@ -267,8 +284,8 @@ int core_free_device_list_for_node(
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
-	nacl->device_list = NULL;
+	array_free(nacl->lun_entry_hlist, TRANSPORT_MAX_LUNS_PER_TPG);
+	nacl->lun_entry_hlist = NULL;
 
 	return 0;
 }
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0696de9..b2fdba5 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -234,15 +234,15 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 	struct se_dev_entry *deve;
 	int i;
 
-	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
+	nacl->lun_entry_hlist = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
 			sizeof(struct se_dev_entry), GFP_KERNEL);
-	if (!nacl->device_list) {
+	if (!nacl->lun_entry_hlist) {
 		pr_err("Unable to allocate memory for"
-			" struct se_node_acl->device_list\n");
+			" struct se_node_acl->lun_entry_hlist\n");
 		return -ENOMEM;
 	}
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
+		deve = nacl->lun_entry_hlist[i];
 
 		atomic_set(&deve->ua_count, 0);
 		atomic_set(&deve->pr_ref_count, 0);
@@ -281,6 +281,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
+	spin_lock_init(&acl->lun_entry_lock);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
@@ -408,6 +409,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
+	spin_lock_init(&acl->lun_entry_lock);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	acl->queue_depth = queue_depth;
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fe25a78..06ecd7b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -595,10 +595,12 @@ struct se_node_acl {
 	char			acl_tag[MAX_ACL_TAG_SIZE];
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
+	struct se_dev_entry __rcu **lun_entry_hlist;
 	struct se_dev_entry	**device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
 	spinlock_t		device_list_lock;
+	spinlock_t		lun_entry_lock;
 	spinlock_t		nacl_sess_lock;
 	struct config_group	acl_group;
 	struct config_group	acl_attrib_group;
-- 
1.9.1

