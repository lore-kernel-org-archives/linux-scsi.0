From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 11/32] target: Convert se_dev_entry to kref
Date: Fri, 13 Dec 2013 15:58:59 -0800
Message-ID: <1386979160-6928-12-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3LMX7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:32 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c   |   12 +++-------
 drivers/target/target_core_internal.h |   12 ++++++++++
 drivers/target/target_core_pr.c       |   38 ++++++++++++--------------------
 drivers/target/target_core_tpg.c      |    2 +-
 include/target/target_core_base.h     |    3 +-
 5 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1954b0f..295b5e4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -224,8 +224,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 		if (port->sep_rtpi != rtpi)
 			continue;
 
-		atomic_inc(&deve->pr_ref_count);
-		smp_mb__after_atomic_inc();
+		get_deve(deve);
 		spin_unlock_irq(&nacl->device_list_lock);
 
 		return deve;
@@ -401,12 +400,6 @@ int core_disable_device_list_for_node(
 	spin_lock_bh(&port->sep_alua_lock);
 	list_del(&deve->alua_port_node);
 	spin_unlock_bh(&port->sep_alua_lock);
-	/*
-	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
-	 * PR operation to complete.
-	 */
-	while (atomic_read(&deve->pr_ref_count) != 0)
-		cpu_relax();
 
 	spin_lock_irq(&nacl->device_list_lock);
 	/*
@@ -421,6 +414,9 @@ int core_disable_device_list_for_node(
 	spin_unlock_irq(&nacl->device_list_lock);
 
 	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
+
+	put_deve(deve);
+
 	return 0;
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index b11512c..fddf44c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -93,6 +93,18 @@ int	core_tpg_post_addlun(struct se_portal_group *, struct se_lun *,
 struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
 int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
 
+static inline void release_deve(struct kref *kref)
+{
+	struct se_dev_entry *deve = container_of(kref,
+				struct se_dev_entry, refcount);
+
+	/* doesn't really get freed because device_list is a static array */
+	deve->lun_flags &= ~TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
+}
+
+#define get_deve(x) kref_get(&x->refcount)
+#define put_deve(x) kref_put(&x->refcount, release_deve)
+
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index fc6029b..9155df0 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -708,8 +708,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (strcmp(nacl->initiatorname, nacl_tmp->initiatorname))
 				continue;
 
-			atomic_inc(&deve_tmp->pr_ref_count);
-			smp_mb__after_atomic_inc();
+			get_deve(deve_tmp);
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -722,8 +721,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				put_port(port);
-				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				put_deve(deve_tmp);
 				goto out;
 			}
 			/*
@@ -738,8 +736,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				put_port(port);
-				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				put_deve(deve_tmp);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -1399,22 +1396,17 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	struct se_lun_acl *lun_acl = se_deve->se_lun_acl;
 	struct se_node_acl *nacl;
 	struct se_portal_group *tpg;
-	/*
-	 * For nacl->dynamic_node_acl=1
-	 */
-	if (!lun_acl) {
-		atomic_dec(&se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
-		return;
-	}
-	nacl = lun_acl->se_lun_nacl;
-	tpg = nacl->se_tpg;
 
-	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
-			&lun_acl->se_lun_group.cg_item);
+	/* for non-demo-mode */
+	if (lun_acl) {
+		nacl = lun_acl->se_lun_nacl;
+		tpg = nacl->se_tpg;
 
-	atomic_dec(&se_deve->pr_ref_count);
-	smp_mb__after_atomic_dec();
+		configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
+				       &lun_acl->se_lun_group.cg_item);
+	}
+
+	put_deve(se_deve);
 }
 
 static sense_reason_t
@@ -1642,8 +1634,7 @@ core_scsi3_decode_spec_i_port(
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
-			atomic_dec(&dest_se_deve->pr_ref_count);
-			smp_mb__after_atomic_dec();
+			put_deve(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -3306,8 +3297,7 @@ after_iport_check:
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
-		atomic_dec(&dest_se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
+		put_deve(dest_se_deve);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 1fd90fc..8771b23 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -237,7 +237,7 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 		deve = nacl->device_list[i];
 
 		atomic_set(&deve->ua_count, 0);
-		atomic_set(&deve->pr_ref_count, 0);
+		kref_init(&deve->refcount);
 		spin_lock_init(&deve->ua_lock);
 		INIT_LIST_HEAD(&deve->alua_port_node);
 		INIT_LIST_HEAD(&deve->ua_list);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f0bc5c1..6bf1da9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -587,8 +587,7 @@ struct se_dev_entry {
 	u64			read_bytes;
 	u64			write_bytes;
 	atomic_t		ua_count;
-	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		pr_ref_count;
+	struct kref		refcount;
 	struct se_lun_acl	*se_lun_acl;
 	spinlock_t		ua_lock;
 	struct se_lun		*se_lun;
-- 
1.7.1

