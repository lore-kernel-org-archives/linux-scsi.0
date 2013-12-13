From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 06/32] target: Convert lu_gp_ref_cnt to kref
Date: Fri, 13 Dec 2013 15:58:54 -0800
Message-ID: <1386979160-6928-7-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab3LMX73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:29 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Use kref to handle reference counting

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_alua.c |   37 ++++++++++++++++++++-----------------
 include/target/target_core_base.h |    2 +-
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2ac2f11..8c01ade 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -54,6 +54,16 @@ static LIST_HEAD(lu_gps_list);
 
 struct t10_alua_lu_gp *default_lu_gp;
 
+static void release_alua_lu_gp(struct kref *ref)
+{
+	struct t10_alua_lu_gp *lu_gp = container_of(ref, struct t10_alua_lu_gp, refcount);
+
+	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+}
+
+#define get_alua_lu_gp(x) kref_get(&x->refcount)
+#define put_alua_lu_gp(x) kref_put(&x->refcount, release_alua_lu_gp)
+
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
@@ -898,8 +908,7 @@ int core_alua_do_port_transition(
 	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = local_lu_gp_mem->lu_gp;
-	atomic_inc(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_inc();
+	get_alua_lu_gp(lu_gp);
 	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
 	/*
 	 * For storage objects that are members of the 'default_lu_gp',
@@ -913,8 +922,8 @@ int core_alua_do_port_transition(
 		 */
 		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
 					md_buf, new_state, explicit);
-		atomic_dec(&lu_gp->lu_gp_ref_cnt);
-		smp_mb__after_atomic_dec();
+
+		put_alua_lu_gp(lu_gp);
 		kfree(md_buf);
 		return 0;
 	}
@@ -985,8 +994,7 @@ int core_alua_do_port_transition(
 		l_tg_pt_gp->tg_pt_gp_id, (explicit) ? "explicit" : "implicit",
 		core_alua_dump_state(new_state));
 
-	atomic_dec(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_dec();
+	put_alua_lu_gp(lu_gp);
 	kfree(md_buf);
 	return 0;
 }
@@ -1107,7 +1115,8 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
 	spin_lock_init(&lu_gp->lu_gp_lock);
-	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
+
+	kref_init(&lu_gp->refcount);
 
 	if (def_group) {
 		lu_gp->lu_gp_id = alua_lu_gps_counter++;
@@ -1200,13 +1209,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 	list_del(&lu_gp->lu_gp_node);
 	alua_lu_gps_count--;
 	spin_unlock(&lu_gps_lock);
-	/*
-	 * Allow struct t10_alua_lu_gp * referenced by core_alua_get_lu_gp_by_name()
-	 * in target_core_configfs.c:target_core_store_alua_lu_gp() to be
-	 * released with core_alua_put_lu_gp_from_name()
-	 */
-	while (atomic_read(&lu_gp->lu_gp_ref_cnt))
-		cpu_relax();
+
 	/*
 	 * Release reference to struct t10_alua_lu_gp * from all associated
 	 * struct se_device.
@@ -1241,7 +1244,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
 
-	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+	put_alua_lu_gp(lu_gp);
 }
 
 void core_alua_free_lu_gp_mem(struct se_device *dev)
@@ -1284,7 +1287,7 @@ struct t10_alua_lu_gp *core_alua_get_lu_gp_by_name(const char *name)
 			continue;
 		ci = &lu_gp->lu_gp_group.cg_item;
 		if (!strcmp(config_item_name(ci), name)) {
-			atomic_inc(&lu_gp->lu_gp_ref_cnt);
+			get_alua_lu_gp(lu_gp);
 			spin_unlock(&lu_gps_lock);
 			return lu_gp;
 		}
@@ -1297,7 +1300,7 @@ struct t10_alua_lu_gp *core_alua_get_lu_gp_by_name(const char *name)
 void core_alua_put_lu_gp_from_name(struct t10_alua_lu_gp *lu_gp)
 {
 	spin_lock(&lu_gps_lock);
-	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	put_alua_lu_gp(lu_gp);
 	spin_unlock(&lu_gps_lock);
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d5e0da1..5bdf0d5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -264,7 +264,7 @@ struct t10_alua_lu_gp {
 	u16	lu_gp_id;
 	int	lu_gp_valid_id;
 	u32	lu_gp_members;
-	atomic_t lu_gp_ref_cnt;
+	struct kref refcount;
 	spinlock_t lu_gp_lock;
 	struct config_group lu_gp_group;
 	struct list_head lu_gp_node;
-- 
1.7.1

