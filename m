From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 10/32] target: Change sep_tg_pt_ref_cnt to use kref
Date: Fri, 13 Dec 2013 15:58:58 -0800
Message-ID: <1386979160-6928-11-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LMX7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:30 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Use the kernel's std kref for refcounting.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c   |   12 ++----------
 drivers/target/target_core_internal.h |   10 ++++++++++
 drivers/target/target_core_pr.c       |   12 ++++--------
 include/target/target_core_base.h     |    2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3350467..1954b0f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -472,6 +472,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 	spin_lock_init(&port->sep_alua_lock);
 	mutex_init(&port->sep_tg_pt_md_mutex);
+	kref_init(&port->refcount);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
@@ -555,20 +556,11 @@ static void core_export_port(
 static void core_release_port(struct se_device *dev, struct se_port *port)
 	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
 {
-	/*
-	 * Wait for any port reference for PR ALL_TG_PT=1 operation
-	 * to complete in __core_scsi3_alloc_registration()
-	 */
-	spin_unlock(&dev->se_port_lock);
-	if (atomic_read(&port->sep_tg_pt_ref_cnt))
-		cpu_relax();
-	spin_lock(&dev->se_port_lock);
-
 	core_alua_free_tg_pt_gp_mem(port);
 
 	list_del(&port->sep_node);
 	dev->dev_port_count--;
-	kfree(port);
+	put_port(port);
 }
 
 int core_dev_export(
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 47b63b0..b11512c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -60,6 +60,16 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name);
 int	target_configure_device(struct se_device *dev);
 void	target_free_device(struct se_device *);
 
+static inline void release_port(struct kref *ref)
+{
+	struct se_port *port = container_of(ref, struct se_port, refcount);
+
+	kfree(port);
+}
+
+#define get_port(x) kref_get(&x->refcount)
+#define put_port(x) kref_put(&x->refcount, release_port)
+
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
 int	core_delete_hba(struct se_hba *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d141c7f..fc6029b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -674,8 +674,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 */
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_node) {
-		atomic_inc(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_inc();
+		get_port(port);
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -722,8 +721,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (ret < 0) {
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
-				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				put_port(port);
 				atomic_dec(&deve_tmp->pr_ref_count);
 				smp_mb__after_atomic_dec();
 				goto out;
@@ -739,8 +737,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						nacl_tmp, deve_tmp, NULL,
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
-				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				put_port(port);
 				atomic_dec(&deve_tmp->pr_ref_count);
 				smp_mb__after_atomic_dec();
 				core_scsi3_lunacl_undepend_item(deve_tmp);
@@ -754,8 +751,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 		spin_unlock_bh(&port->sep_alua_lock);
 
 		spin_lock(&dev->se_port_lock);
-		atomic_dec(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_dec();
+		put_port(port);
 	}
 	spin_unlock(&dev->se_port_lock);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6c517cd..f0bc5c1 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -773,7 +773,7 @@ struct se_port {
 	/* Used for ALUA Target Port Groups membership */
 	atomic_t	sep_tg_pt_secondary_offline;
 	/* Used for PR ALL_TG_PT=1 */
-	atomic_t	sep_tg_pt_ref_cnt;
+	struct kref refcount;
 	spinlock_t	sep_alua_lock;
 	struct mutex	sep_tg_pt_md_mutex;
 	struct t10_alua_tg_pt_gp_member *sep_alua_tg_pt_gp_mem;
-- 
1.7.1

