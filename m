From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 26/32] target: Convert tpg_pr_ref_count to kref
Date: Fri, 13 Dec 2013 15:59:14 -0800
Message-ID: <1386979160-6928-27-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab3LMX7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:37 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Don't call fabric_drop_tpg from configfs release(), just lower the
refcount, and call fabric_drop_tpg when refcount goes to zero.

We don't need cpu_relax because core_tpg_deregister will only be called
after we know there is no PR use of this tpg (step 4 below):

1) configfs drop_item (target_fabric_drop_tpg) calls config_item_put()
2) if really removed, configfs calls release (target_fabric_tpg_release)
3) tpg_release just calls put_tpg(), so if PR has a ref, the tpg still
   isn't freed until PR code drops the ref
4) Last put_tpg(), release_tpg() calls tf_ops.fabric_drop_tpg()
   which eventually calls core_tpg_deregister
5) struct contaning tpg freed by fabric after core_tpg_deregister returns

Add a target_core_tpg.h just to stick the get/put_tpg in there.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_fabric_configfs.c |    5 ++---
 drivers/target/target_core_pr.c              |   16 ++++++----------
 drivers/target/target_core_tpg.c             |    7 ++++---
 drivers/target/target_core_tpg.h             |   13 +++++++++++++
 include/target/target_core_base.h            |    3 +--
 5 files changed, 26 insertions(+), 18 deletions(-)
 create mode 100644 drivers/target/target_core_tpg.h

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index fe940d4..45a1763 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -42,6 +42,7 @@
 #include "target_core_internal.h"
 #include "target_core_alua.h"
 #include "target_core_pr.h"
+#include "target_core_tpg.h"
 
 #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
@@ -995,10 +996,8 @@ static void target_fabric_tpg_release(struct config_item *item)
 {
 	struct se_portal_group *se_tpg = container_of(to_config_group(item),
 			struct se_portal_group, tpg_group);
-	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
-	struct target_fabric_configfs *tf = wwn->wwn_tf;
 
-	tf->tf_ops.fabric_drop_tpg(se_tpg);
+	put_tpg(se_tpg);
 }
 
 static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 0da6696..e2b656b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -40,6 +40,7 @@
 #include "target_core_internal.h"
 #include "target_core_pr.h"
 #include "target_core_ua.h"
+#include "target_core_tpg.h"
 
 /*
  * Used for Specify Initiator Ports Capable Bit (SPEC_I_PT)
@@ -1334,8 +1335,7 @@ static void core_scsi3_tpg_undepend_item(struct se_portal_group *tpg)
 	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&tpg->tpg_group.cg_item);
 
-	atomic_dec(&tpg->tpg_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	put_tpg(tpg);
 }
 
 static int core_scsi3_nodeacl_depend_item(struct se_node_acl *nacl)
@@ -1535,15 +1535,13 @@ core_scsi3_decode_spec_i_port(
 			if (!i_str)
 				continue;
 
-			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_inc();
+			get_tpg(tmp_tpg);
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
 				pr_err(" core_scsi3_tpg_depend_item()"
 					" for tmp_tpg\n");
-				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				put_tpg(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
 			}
@@ -3153,15 +3151,13 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		if (!dest_tf_ops)
 			continue;
 
-		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
-		smp_mb__after_atomic_inc();
+		get_tpg(dest_se_tpg);
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
 			pr_err("core_scsi3_tpg_depend_item() failed"
 				" for dest_se_tpg\n");
-			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_dec();
+			put_tpg(dest_se_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
 		}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d9fbdd0..0e30ced 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -38,8 +38,11 @@
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
+#include <target/target_core_configfs.h>
+
 
 #include "target_core_internal.h"
+#include "target_core_tpg.h"
 
 extern struct se_device *g_lun0_dev;
 
@@ -637,7 +640,7 @@ int core_tpg_register(
 	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
 	se_tpg->se_tpg_tfo = tfo;
 	se_tpg->se_tpg_wwn = se_wwn;
-	atomic_set(&se_tpg->tpg_pr_ref_count, 0);
+	kref_init(&se_tpg->refcount);
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->se_tpg_node);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
@@ -680,8 +683,6 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	list_del(&se_tpg->se_tpg_node);
 	spin_unlock_bh(&tpg_lock);
 
-	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
-		cpu_relax();
 	/*
 	 * Release any remaining demo-mode generated se_node_acl that have
 	 * not been released because of TFO->tpg_check_demo_mode_cache() == 1
diff --git a/drivers/target/target_core_tpg.h b/drivers/target/target_core_tpg.h
new file mode 100644
index 0000000..964d69b
--- /dev/null
+++ b/drivers/target/target_core_tpg.h
@@ -0,0 +1,13 @@
+
+static inline void release_tpg(struct kref *ref)
+{
+	struct se_portal_group *tpg = container_of(ref,
+		struct se_portal_group, refcount);
+	struct se_wwn *wwn = tpg->se_tpg_wwn;
+	struct target_fabric_configfs *tf = wwn->wwn_tf;
+
+	tf->tf_ops.fabric_drop_tpg(tpg);
+}
+
+#define get_tpg(x) kref_get(&x->refcount)
+#define put_tpg(x) kref_put(&x->refcount, release_tpg)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e4d5119..dc8bf39 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -781,8 +781,7 @@ struct se_portal_group {
 	enum transport_tpg_type_table se_tpg_type;
 	/* Number of ACLed Initiator Nodes for this TPG */
 	u32			num_node_acls;
-	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		tpg_pr_ref_count;
+	struct kref		refcount;
 	/* Spinlock for adding/removing ACLed Nodes */
 	spinlock_t		acl_node_lock;
 	/* Spinlock for adding/removing sessions */
-- 
1.7.1

