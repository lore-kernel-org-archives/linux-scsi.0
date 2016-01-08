From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/4] target: Remove useless set_initiator_node_queue_depth acl lookup
Date: Fri,  8 Jan 2016 07:15:46 +0000
Message-ID: <1452237348-2277-3-git-send-email-nab@daterainc.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With the changes in place to obtain se_node_acl->acl_kref
from within core_tpg_del_initiator_node_acl() and auditing
existing users, it's clear there is no need to perform the
lookup during core_tpg_set_initiator_node_queue_depth().

This is because se_node_acl->acl_group is already protecting
the se_node_acl reference via configfs, and ->acl_group
shutdown in core_tpg_del_initiator_node_acl() can't occur
until core_tpg_set_initiator_node_queue_depth() completes.

Also, remove a related pointless wrapper in iscsi-target.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |  6 +++---
 drivers/target/iscsi/iscsi_target_tpg.c      | 10 ----------
 drivers/target/iscsi/iscsi_target_tpg.h      |  2 --
 drivers/target/target_core_tpg.c             | 23 ++++-------------------
 include/target/target_core_fabric.h          |  2 +-
 5 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 255204c..6469321 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -726,10 +726,10 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 	if (iscsit_get_tpg(tpg) < 0)
 		return -EINVAL;
 	/*
-	 * iscsit_tpg_set_initiator_node_queue_depth() assumes force=1
+	 * core_tpg_set_initiator_node_queue_depth() assumes force=1
 	 */
-	ret = iscsit_tpg_set_initiator_node_queue_depth(tpg,
-				config_item_name(acl_ci), cmdsn_depth, 1);
+	ret = core_tpg_set_initiator_node_queue_depth(se_tpg, se_nacl,
+						      cmdsn_depth, 1);
 
 	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
 		"InitiatorName: %s\n", config_item_name(wwn_ci),
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 23c95cd..0814e58 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -590,16 +590,6 @@ int iscsit_tpg_del_network_portal(
 	return iscsit_tpg_release_np(tpg_np, tpg, np);
 }
 
-int iscsit_tpg_set_initiator_node_queue_depth(
-	struct iscsi_portal_group *tpg,
-	unsigned char *initiatorname,
-	u32 queue_depth,
-	int force)
-{
-	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
-		initiatorname, queue_depth, force);
-}
-
 int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 {
 	unsigned char buf1[256], buf2[256], *none = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 9db32bd..2da2119 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -26,8 +26,6 @@ extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi_portal_gr
 			int);
 extern int iscsit_tpg_del_network_portal(struct iscsi_portal_group *,
 			struct iscsi_tpg_np *);
-extern int iscsit_tpg_set_initiator_node_queue_depth(struct iscsi_portal_group *,
-			unsigned char *, u32, int);
 extern int iscsit_ta_authentication(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_login_timeout(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_netif_timeout(struct iscsi_portal_group *, u32);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index fb77fe1..550d6f8 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -371,30 +371,18 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
  */
 int core_tpg_set_initiator_node_queue_depth(
 	struct se_portal_group *tpg,
-	unsigned char *initiatorname,
+	struct se_node_acl *acl,
 	u32 queue_depth,
 	int force)
 {
 	struct se_session *sess, *init_sess = NULL;
-	struct se_node_acl *acl;
 	unsigned long flags;
 	int dynamic_acl = 0;
 
-	mutex_lock(&tpg->acl_node_mutex);
-	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if (!acl) {
-		pr_err("Access Control List entry for %s Initiator"
-			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
-			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		mutex_unlock(&tpg->acl_node_mutex);
-		return -ENODEV;
-	}
 	if (acl->dynamic_node_acl) {
 		acl->dynamic_node_acl = 0;
 		dynamic_acl = 1;
 	}
-	mutex_unlock(&tpg->acl_node_mutex);
 
 	spin_lock_irqsave(&tpg->session_lock, flags);
 	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
@@ -407,13 +395,12 @@ int core_tpg_set_initiator_node_queue_depth(
 				" operational.  To forcefully change the queue"
 				" depth and force session reinstatement"
 				" use the \"force=1\" parameter.\n",
-				tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
+				tpg->se_tpg_tfo->get_fabric_name(),
+				acl->initiatorname);
 			spin_unlock_irqrestore(&tpg->session_lock, flags);
 
-			mutex_lock(&tpg->acl_node_mutex);
 			if (dynamic_acl)
 				acl->dynamic_node_acl = 1;
-			mutex_unlock(&tpg->acl_node_mutex);
 			return -EEXIST;
 		}
 		/*
@@ -464,13 +451,11 @@ int core_tpg_set_initiator_node_queue_depth(
 
 	pr_debug("Successfully changed queue depth to: %d for Initiator"
 		" Node: %s on %s Target Portal Group: %u\n", queue_depth,
-		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
+		acl->initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
-	mutex_lock(&tpg->acl_node_mutex);
 	if (dynamic_acl)
 		acl->dynamic_node_acl = 1;
-	mutex_unlock(&tpg->acl_node_mutex);
 
 	return 0;
 }
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index de21130..7f83295 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -172,7 +172,7 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
 int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
-		unsigned char *, u32, int);
+		struct se_node_acl *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
 int	core_tpg_register(struct se_wwn *, struct se_portal_group *, int);
-- 
1.9.1
