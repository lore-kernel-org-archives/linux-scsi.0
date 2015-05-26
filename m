From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 08/10] target: Drop unused se_lun->lun_acl_list
Date: Tue, 26 May 2015 06:25:28 +0000
Message-ID: <1432621530-24171-9-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 15 ---------------
 drivers/target/target_core_tpg.c    |  4 ----
 include/target/target_core_base.h   |  3 ---
 3 files changed, 22 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2da22ce..c95d3cf 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1239,7 +1239,6 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 		return NULL;
 	}
 
-	INIT_LIST_HEAD(&lacl->lacl_list);
 	lacl->mapped_lun = mapped_lun;
 	lacl->se_lun_nacl = nacl;
 	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s",
@@ -1269,11 +1268,6 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access, nacl, tpg) < 0)
 		return -EINVAL;
 
-	spin_lock(&lun->lun_acl_lock);
-	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
-	atomic_inc_mb(&lun->lun_acl_count);
-	spin_unlock(&lun->lun_acl_lock);
-
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
@@ -1300,19 +1294,12 @@ int core_dev_del_initiator_node_lun_acl(
 	if (!nacl)
 		return -EINVAL;
 
-	spin_lock(&lun->lun_acl_lock);
-	list_del(&lacl->lacl_list);
-	atomic_dec_mb(&lun->lun_acl_count);
-	spin_unlock(&lun->lun_acl_lock);
-
 	mutex_lock(&nacl->lun_entry_mutex);
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
 	if (deve)
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	lacl->se_lun = NULL;
-
 	pr_debug("%s_TPG[%hu]_LUN[%u] - Removed ACL for"
 		" InitiatorNode: %s Mapped LUN: %u\n",
 		tpg->se_tpg_tfo->get_fabric_name(),
@@ -1442,8 +1429,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	xcopy_lun = &dev->xcopy_lun;
 	xcopy_lun->lun_se_dev = dev;
 	init_completion(&xcopy_lun->lun_shutdown_comp);
-	INIT_LIST_HEAD(&xcopy_lun->lun_acl_list);
-	spin_lock_init(&xcopy_lun->lun_acl_lock);
 	spin_lock_init(&xcopy_lun->lun_sep_lock);
 	init_completion(&xcopy_lun->lun_ref_comp);
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index e7745d2..73c25bd 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -495,8 +495,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
-	INIT_LIST_HEAD(&lun->lun_acl_list);
-	spin_lock_init(&lun->lun_acl_lock);
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
@@ -610,8 +608,6 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
-	INIT_LIST_HEAD(&lun->lun_acl_list);
-	spin_lock_init(&lun->lun_acl_lock);
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2b6adac..7908d6d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -632,7 +632,6 @@ struct se_lun_acl {
 	u32			mapped_lun;
 	struct se_node_acl	*se_lun_nacl;
 	struct se_lun		*se_lun;
-	struct list_head	lacl_list;
 	struct config_group	se_lun_group;
 	struct se_ml_stat_grps	ml_stat_grps;
 };
@@ -715,10 +714,8 @@ struct se_lun {
 	u32			unpacked_lun;
 	u32			lun_index;
 	atomic_t		lun_acl_count;
-	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_sep_lock;
 	struct completion	lun_shutdown_comp;
-	struct list_head	lun_acl_list;
 	struct se_device	*lun_se_dev;
 	struct se_port		*lun_sep;
 	struct config_group	lun_group;
-- 
1.9.1
