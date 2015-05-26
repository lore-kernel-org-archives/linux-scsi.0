From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 3/4] target: Drop se_lun->lun_active for existing percpu lun_ref
Date: Tue, 26 May 2015 06:57:24 +0000
Message-ID: <1432623445-25776-4-git-send-email-nab@daterainc.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With se_port_t and t10_alua_tg_pt_gp_member being absored into se_lun,
there is no need for an extra atomic_t based reference count for PR
ALL_TG_PT=1 and ALUA access state transition.

Go ahead and use the existing percpu se_lun->lun_ref instead, and
convert the two special cases to percpu_ref_tryget_live() to avoid
se_lun if transport_clear_lun_ref() has already been invoked to
shutdown the se_lun.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c |  5 +++--
 drivers/target/target_core_pr.c   |  9 +++++----
 drivers/target/target_core_tpg.c  | 10 ++++++----
 include/target/target_core_base.h |  1 -
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 314d230..5745dda 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -969,7 +969,8 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		 * every I_T nexus other than the I_T nexus on which the SET
 		 * TARGET PORT GROUPS command
 		 */
-		atomic_inc_mb(&lun->lun_active);
+		if (!percpu_ref_tryget_live(&lun->lun_ref))
+			continue;
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 		spin_lock_bh(&lun->lun_deve_lock);
@@ -997,7 +998,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		spin_unlock_bh(&lun->lun_deve_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-		atomic_dec_mb(&lun->lun_active);
+		percpu_ref_put(&lun->lun_ref);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f036337..b3088b2 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -704,7 +704,8 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 */
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry_safe(lun_tmp, next, &dev->dev_sep_list, lun_dev_link) {
-		atomic_inc_mb(&lun_tmp->lun_active);
+		if (!percpu_ref_tryget_live(&lun_tmp->lun_ref))
+			continue;
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&lun_tmp->lun_deve_lock);
@@ -750,7 +751,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (ret < 0) {
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
-				atomic_dec_mb(&lun->lun_active);
+				percpu_ref_put(&lun_tmp->lun_ref);
 				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
 			}
@@ -767,7 +768,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						deve_tmp, deve_tmp->mapped_lun,
 						NULL, sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
-				atomic_dec_mb(&lun_tmp->lun_active);
+				percpu_ref_put(&lun_tmp->lun_ref);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -779,7 +780,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 		spin_unlock_bh(&lun_tmp->lun_deve_lock);
 
 		spin_lock(&dev->se_port_lock);
-		atomic_dec_mb(&lun_tmp->lun_active);
+		percpu_ref_put(&lun_tmp->lun_ref);
 	}
 	spin_unlock(&dev->se_port_lock);
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5b9a229..2ec1ed1 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -606,7 +606,6 @@ struct se_lun *core_tpg_alloc_lun(
 	mutex_init(&lun->lun_tg_pt_md_mutex);
 	INIT_LIST_HEAD(&lun->lun_tg_pt_gp_link);
 	spin_lock_init(&lun->lun_tg_pt_gp_lock);
-	atomic_set(&lun->lun_active, 0);
 	lun->lun_tpg = tpg;
 
 	return lun;
@@ -662,13 +661,16 @@ void core_tpg_remove_lun(
 	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 
 	core_clear_lun_from_tpg(lun, tpg);
+	/*
+	 * Wait for any active I/O references to percpu se_lun->lun_ref to
+	 * be released.  Also, se_lun->lun_ref is now used by PR and ALUA
+	 * logic when referencing a remote target port during ALL_TGT_PT=1
+	 * and generating UNIT_ATTENTIONs for ALUA access state transition.
+	 */
 	transport_clear_lun_ref(lun);
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 	if (lun->lun_se_dev) {
-		while (atomic_read(&lun->lun_active))
-			cpu_relax();
-
 		target_detach_tg_pt_gp(lun);
 
 		spin_lock(&dev->se_port_lock);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b82a989..eefc2b0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -721,7 +721,6 @@ struct se_lun {
 	struct t10_alua_tg_pt_gp *lun_tg_pt_gp;
 	spinlock_t		lun_tg_pt_gp_lock;
 
-	atomic_t		lun_active;
 	struct se_portal_group	*lun_tpg;
 	struct scsi_port_stats	lun_stats;
 	struct config_group	lun_group;
-- 
1.9.1
