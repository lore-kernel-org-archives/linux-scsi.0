From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 09/32] target: convert tg_pt_gp_mem_ref_cnt to kref
Date: Fri, 13 Dec 2013 15:58:57 -0800
Message-ID: <1386979160-6928-10-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3LMX7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:30 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Use kref to handle reference counting.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_alua.c |   23 ++++++++++++++---------
 include/target/target_core_base.h |    2 +-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index ba7b3d6..4ee08a2 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -84,6 +84,16 @@ static void release_alua_tg_pt_gp(struct kref *ref)
 #define get_alua_tg_pt_gp(x) kref_get(&x->refcount)
 #define put_alua_tg_pt_gp(x) kref_put(&x->refcount, release_alua_tg_pt_gp)
 
+static void release_alua_tg_pt_gp_mem(struct kref *ref)
+{
+	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem = container_of(ref, struct t10_alua_tg_pt_gp_member, refcount);
+
+	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
+}
+
+#define get_alua_tg_pt_gp_mem(x) kref_get(&x->refcount)
+#define put_alua_tg_pt_gp_mem(x) kref_put(&x->refcount, release_alua_tg_pt_gp_mem)
+
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
@@ -834,8 +844,7 @@ static int core_alua_do_transition_tg_pt(
 		 * every I_T nexus other than the I_T nexus on which the SET
 		 * TARGET PORT GROUPS command
 		 */
-		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_inc();
+		get_alua_tg_pt_gp_mem(mem);
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -861,8 +870,7 @@ static int core_alua_do_transition_tg_pt(
 		spin_unlock_bh(&port->sep_alua_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_dec();
+		put_alua_tg_pt_gp_mem(mem);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
@@ -1463,7 +1471,7 @@ struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
 	}
 	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_node);
 	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	atomic_set(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt, 0);
+	kref_init(&tg_pt_gp_mem->refcount);
 
 	tg_pt_gp_mem->tg_pt = port;
 	port->sep_alua_tg_pt_gp_mem = tg_pt_gp_mem;
@@ -1536,9 +1544,6 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 	if (!tg_pt_gp_mem)
 		return;
 
-	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
-		cpu_relax();
-
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 	if (tg_pt_gp) {
@@ -1553,7 +1558,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 	}
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
+	put_alua_tg_pt_gp_mem(tg_pt_gp_mem);
 }
 
 static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 58b04f9..6c517cd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -307,7 +307,7 @@ struct t10_alua_tg_pt_gp {
 
 struct t10_alua_tg_pt_gp_member {
 	bool tg_pt_gp_assoc;
-	atomic_t tg_pt_gp_mem_ref_cnt;
+	struct kref refcount;
 	spinlock_t tg_pt_gp_mem_lock;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_port *tg_pt;
-- 
1.7.1

