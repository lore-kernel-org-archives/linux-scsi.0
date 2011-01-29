From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 19/24] target: Minor sparse warning fixes and annotations
Date: Sat, 29 Jan 2011 10:36:19 -0800
Message-ID: <1296326184-16664-20-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ac4.yahoo.com ([98.139.52.221]:33752 "HELO
	nm24.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780Ab1A2ShI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:08 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

This patch addresses the majority of sparse warnings and adds
proper locking annotations.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit f63a5d6f3e055f10954c053a1402c7f62ce3d46f)
---
 drivers/target/target_core_device.c     |    1 +
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_mib.c        |   20 ++++++++++++++++++++
 drivers/target/target_core_pscsi.c      |    3 +++
 drivers/target/target_core_rd.h         |    2 --
 drivers/target/target_core_transport.c  |    4 +---
 include/target/target_core_transport.h  |    4 ++++
 7 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ec7f582..9cd87fd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -586,6 +586,7 @@ static void core_export_port(
  *	Called with struct se_device->se_port_lock spinlock held.
  */
 static void core_release_port(struct se_device *dev, struct se_port *port)
+	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
 {
 	/*
 	 * Wait for any port reference for PR ALL_TG_PT=1 operation
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 2628564..bddab5d 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -35,6 +35,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
 #include <target/target_core_transport.h>
+#include <target/target_core_fabric_lib.h>
 #include <target/target_core_fabric_ops.h>
 #include <target/target_core_configfs.h>
 
diff --git a/drivers/target/target_core_mib.c b/drivers/target/target_core_mib.c
index d5a48aa..6098d9e 100644
--- a/drivers/target/target_core_mib.c
+++ b/drivers/target/target_core_mib.c
@@ -70,6 +70,7 @@ static inline int list_is_first(const struct list_head *list,
 static void *locate_hba_start(
 	struct seq_file *seq,
 	loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	spin_lock(&se_global->g_device_lock);
 	return seq_list_start(&se_global->g_se_dev_list, *pos);
@@ -84,6 +85,7 @@ static void *locate_hba_next(
 }
 
 static void locate_hba_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	spin_unlock(&se_global->g_device_lock);
 }
@@ -98,6 +100,7 @@ static void locate_hba_stop(struct seq_file *seq, void *v)
 static void *scsi_inst_seq_start(
 	struct seq_file *seq,
 	loff_t *pos)
+	__acquires(&se_global->hba_lock)
 {
 	spin_lock(&se_global->hba_lock);
 	return seq_list_start(&se_global->g_hba_list, *pos);
@@ -112,6 +115,7 @@ static void *scsi_inst_seq_next(
 }
 
 static void scsi_inst_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->hba_lock)
 {
 	spin_unlock(&se_global->hba_lock);
 }
@@ -154,6 +158,7 @@ static const struct file_operations scsi_inst_seq_fops = {
  * SCSI Device Table
  */
 static void *scsi_dev_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -164,6 +169,7 @@ static void *scsi_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_dev_seq_stop(struct seq_file *seq, void *v)
+	 __releases(&se_global->hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -235,6 +241,7 @@ static const struct file_operations scsi_dev_seq_fops = {
  * SCSI Port Table
  */
 static void *scsi_port_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -245,6 +252,7 @@ static void *scsi_port_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_port_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -305,6 +313,7 @@ static const struct file_operations scsi_port_seq_fops = {
  * SCSI Transport Table
  */
 static void *scsi_transport_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -315,6 +324,7 @@ static void *scsi_transport_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_transport_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -390,6 +400,7 @@ static const struct file_operations scsi_transport_seq_fops = {
  * SCSI Target Device Table
  */
 static void *scsi_tgt_dev_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -400,6 +411,7 @@ static void *scsi_tgt_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_tgt_dev_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -481,6 +493,7 @@ static const struct file_operations scsi_tgt_dev_seq_fops = {
  * SCSI Target Port Table
  */
 static void *scsi_tgt_port_seq_start(struct seq_file *seq, loff_t *pos)
+	 __acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -491,6 +504,7 @@ static void *scsi_tgt_port_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_tgt_port_seq_stop(struct seq_file *seq, void *v)
+	 __releases(&se_global->se_hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -575,6 +589,7 @@ static const struct file_operations scsi_tgt_port_seq_fops = {
  * Iterates through all active TPGs and extracts the info from the ACLs
  */
 static void *scsi_auth_intr_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_tpg_lock)
 {
 	spin_lock_bh(&se_global->se_tpg_lock);
 	return seq_list_start(&se_global->g_se_tpg_list, *pos);
@@ -587,6 +602,7 @@ static void *scsi_auth_intr_seq_next(struct seq_file *seq, void *v,
 }
 
 static void scsi_auth_intr_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_tpg_lock)
 {
 	spin_unlock_bh(&se_global->se_tpg_lock);
 }
@@ -700,6 +716,7 @@ static const struct file_operations scsi_auth_intr_seq_fops = {
  * to list the info fo this table.
  */
 static void *scsi_att_intr_port_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_tpg_lock)
 {
 	spin_lock_bh(&se_global->se_tpg_lock);
 	return seq_list_start(&se_global->g_se_tpg_list, *pos);
@@ -712,6 +729,7 @@ static void *scsi_att_intr_port_seq_next(struct seq_file *seq, void *v,
 }
 
 static void scsi_att_intr_port_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_tpg_lock)
 {
 	spin_unlock_bh(&se_global->se_tpg_lock);
 }
@@ -824,6 +842,7 @@ static const struct file_operations scsi_att_intr_port_seq_fops = {
  * SCSI Logical Unit Table
  */
 static void *scsi_lu_seq_start(struct seq_file *seq, loff_t *pos)
+	 __acquires(&se_global->se_hba_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -834,6 +853,7 @@ static void *scsi_lu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void scsi_lu_seq_stop(struct seq_file *seq, void *v)
+	 __releases(&se_global->se_hba_lock)
 {
 	locate_hba_stop(seq, v);
 }
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e795f7d..40c2419 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -442,6 +442,7 @@ static struct se_device *pscsi_create_type_disk(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
@@ -489,6 +490,7 @@ static struct se_device *pscsi_create_type_rom(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
@@ -523,6 +525,7 @@ static struct se_device *pscsi_create_type_other(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 13badfb..3ea19e2 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -14,8 +14,6 @@
 #define RD_BLOCKSIZE		512
 #define RD_MAX_SECTORS		1024
 
-extern struct kmem_cache *se_mem_cache;
-
 /* Used in target_core_init_configfs() for virtual LUN 0 access */
 int __init rd_module_init(void);
 void rd_module_exit(void);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8cb628b..5fa5f89 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -229,8 +229,6 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
 static void transport_stop_all_task_timers(struct se_cmd *cmd);
 
-int transport_emulate_control_cdb(struct se_task *task);
-
 int init_se_global(void)
 {
 	struct se_global *global;
@@ -4371,7 +4369,7 @@ out:
 	return -1;
 }
 
-extern u32 transport_calc_sg_num(
+u32 transport_calc_sg_num(
 	struct se_task *task,
 	struct se_mem *in_se_mem,
 	u32 task_offset)
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 66f44e5..feaf5d4 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -109,6 +109,8 @@
 struct se_mem;
 struct se_subsystem_api;
 
+extern struct kmem_cache *se_mem_cache;
+
 extern int init_se_global(void);
 extern void release_se_global(void);
 extern void transport_init_queue_obj(struct se_queue_obj *);
@@ -186,6 +188,8 @@ extern void transport_generic_process_write(struct se_cmd *);
 extern int transport_generic_do_tmr(struct se_cmd *);
 /* From target_core_alua.c */
 extern int core_alua_check_nonop_delay(struct se_cmd *);
+/* From target_core_cdb.c */
+extern int transport_emulate_control_cdb(struct se_task *);
 
 /*
  * Each se_transport_task_t can have N number of possible struct se_task's
-- 
1.7.3.5

