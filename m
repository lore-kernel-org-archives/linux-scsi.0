From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v3 10/10] target: Drop left-over se_lun->lun_status
Date: Tue, 26 May 2015 06:40:30 +0000
Message-ID: <1432622430-25253-11-git-send-email-nab@linux-iscsi.org>
References: <1432622430-25253-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432622430-25253-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that se_portal_group->tpg_lun_hlist is a RCU protected hlist,
go ahead and drop the left-over lun->lun_status usage.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c  | 6 ------
 include/target/target_core_base.h | 8 --------
 2 files changed, 14 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index f66c208..91f8ddb 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -98,8 +98,6 @@ void core_tpg_add_node_to_devs(
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
-		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
-			continue;
 		if (lun_orig && lun != lun_orig)
 			continue;
 
@@ -495,7 +493,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	int ret;
 
 	lun->unpacked_lun = 0;
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
 	spin_lock_init(&lun->lun_sep_lock);
@@ -608,7 +605,6 @@ struct se_lun *core_tpg_alloc_lun(
 	}
 	lun->unpacked_lun = unpacked_lun;
 	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
 	spin_lock_init(&lun->lun_sep_lock);
@@ -638,7 +634,6 @@ int core_tpg_add_lun(
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_access = lun_access;
-	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
 	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
 	mutex_unlock(&tpg->tpg_lun_mutex);
@@ -658,7 +653,6 @@ void core_tpg_remove_lun(
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		hlist_del_rcu(&lun->link);
 	mutex_unlock(&tpg->tpg_lun_mutex);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7908d6d..78ed2a8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -119,12 +119,6 @@ enum hba_flags_table {
 	HBA_FLAGS_PSCSI_MODE	= 0x02,
 };
 
-/* struct se_lun->lun_status */
-enum transport_lun_status_table {
-	TRANSPORT_LUN_STATUS_FREE = 0,
-	TRANSPORT_LUN_STATUS_ACTIVE = 1,
-};
-
 /* Special transport agnostic struct se_cmd->t_states */
 enum transport_state_table {
 	TRANSPORT_NO_STATE	= 0,
@@ -707,8 +701,6 @@ struct se_lun {
 	u16			lun_rtpi;
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
-	/* See transport_lun_status_table */
-	enum transport_lun_status_table lun_status;
 	u32			lun_access;
 	u32			lun_flags;
 	u32			unpacked_lun;
-- 
1.9.1
