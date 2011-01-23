From: Fubo Chen <fubo.chen@gmail.com>
Subject: [PATCH] target: Address sparse warnings
Date: Sun, 23 Jan 2011 10:28:34 +0100
Message-ID: <AANLkTi=MupdWyYnuY1rV9AkEobw8pZVO_-12JN6DteeJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42546 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1AWJ2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 04:28:35 -0500
Received: by iyj18 with SMTP id 18so3051650iyj.19
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 01:28:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Does this patch make sense ? With this patch sparse only complains
about "warning: incorrect type in assignment (different address
spaces)".

diff --git a/drivers/target/target_core_configfs.c
b/drivers/target/target_core_configfs.c
index 2764510..a33ffeb 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3128,7 +3128,7 @@ static int target_core_init_configfs(void)
 	if (core_dev_setup_virtual_lun0() < 0)
 		goto out;

-	scsi_target_proc = proc_mkdir("scsi_target", 0);
+	scsi_target_proc = proc_mkdir("scsi_target", NULL);
 	if (!(scsi_target_proc)) {
 		printk(KERN_ERR "proc_mkdir(scsi_target, 0) failed\n");
 		goto out;
@@ -3142,7 +3142,7 @@ static int target_core_init_configfs(void)
 out:
 	configfs_unregister_subsystem(subsys);
 	if (scsi_target_proc)
-		remove_proc_entry("scsi_target", 0);
+		remove_proc_entry("scsi_target", NULL);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 out_global:
@@ -3209,7 +3209,7 @@ static void target_core_exit_configfs(void)
 			" Infrastructure\n");

 	remove_scsi_target_mib();
-	remove_proc_entry("scsi_target", 0);
+	remove_proc_entry("scsi_target", NULL);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 	release_se_global();
diff --git a/drivers/target/target_core_device.c
b/drivers/target/target_core_device.c
index 317ce58..fb01f4a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -392,12 +392,14 @@ int core_update_device_list_for_node(
 		 */
 		if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 			if (deve->se_lun_acl != NULL) {
+				spin_unlock_irq(&nacl->device_list_lock);
 				printk(KERN_ERR "struct se_dev_entry->se_lun_acl"
 					" already set for demo mode -> explict"
 					" LUN ACL transition\n");
 				return -1;
 			}
 			if (deve->se_lun != lun) {
+				spin_unlock_irq(&nacl->device_list_lock);
 				printk(KERN_ERR "struct se_dev_entry->se_lun does"
 					" match passed struct se_lun for demo mode"
 					" -> explict LUN ACL transition\n");
@@ -588,6 +590,8 @@ static void core_export_port(
  *	Called with struct se_device->se_port_lock spinlock held.
  */
 static void core_release_port(struct se_device *dev, struct se_port *port)
+	__releases(&dev->se_port_lock)
+	__acquires(&dev->se_port_lock)
 {
 	/*
 	 * Wait for any port reference for PR ALL_TG_PT=1 operation
@@ -798,6 +802,8 @@ void se_clear_dev_ports(struct se_device *dev)
 		spin_lock(&lun->lun_sep_lock);
 		if (lun->lun_se_dev == NULL) {
 			spin_unlock(&lun->lun_sep_lock);
+			spin_lock(&hba->device_lock);
+			spin_lock(&dev->se_port_lock);
 			continue;
 		}
 		spin_unlock(&lun->lun_sep_lock);
diff --git a/drivers/target/target_core_fabric_lib.c
b/drivers/target/target_core_fabric_lib.c
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

diff --git a/drivers/target/target_core_iblock.c
b/drivers/target/target_core_iblock.c
index c6e0d75..b933e24 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -133,7 +133,7 @@ static struct se_device *iblock_create_virtdevice(

 	if (!(ib_dev)) {
 		printk(KERN_ERR "Unable to locate struct iblock_dev parameter\n");
-		return 0;
+		return NULL;
 	}
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 	/*
@@ -142,7 +142,7 @@ static struct se_device *iblock_create_virtdevice(
 	ib_dev->ibd_bio_set = bioset_create(32, 64);
 	if (!(ib_dev->ibd_bio_set)) {
 		printk(KERN_ERR "IBLOCK: Unable to create bioset()\n");
-		return 0;
+		return NULL;
 	}
 	printk(KERN_INFO "IBLOCK: Created bio_set()\n");
 	/*
diff --git a/drivers/target/target_core_mib.c b/drivers/target/target_core_mib.c
index d5a48aa..0347b1c 100644
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
+	__acquires(&se_global->g_device_lock)
 {
 	spin_lock(&se_global->hba_lock);
 	return seq_list_start(&se_global->g_hba_list, *pos);
@@ -112,6 +115,7 @@ static void *scsi_inst_seq_next(
 }

 static void scsi_inst_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	spin_unlock(&se_global->hba_lock);
 }
@@ -154,6 +158,7 @@ static const struct file_operations scsi_inst_seq_fops = {
  * SCSI Device Table
  */
 static void *scsi_dev_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -164,6 +169,7 @@ static void *scsi_dev_seq_next(struct seq_file
*seq, void *v, loff_t *pos)
 }

 static void scsi_dev_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -235,6 +241,7 @@ static const struct file_operations scsi_dev_seq_fops = {
  * SCSI Port Table
  */
 static void *scsi_port_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -245,6 +252,7 @@ static void *scsi_port_seq_next(struct seq_file
*seq, void *v, loff_t *pos)
 }

 static void scsi_port_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -305,6 +313,7 @@ static const struct file_operations scsi_port_seq_fops = {
  * SCSI Transport Table
  */
 static void *scsi_transport_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -315,6 +324,7 @@ static void *scsi_transport_seq_next(struct
seq_file *seq, void *v, loff_t *pos)
 }

 static void scsi_transport_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -390,6 +400,7 @@ static const struct file_operations
scsi_transport_seq_fops = {
  * SCSI Target Device Table
  */
 static void *scsi_tgt_dev_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -400,6 +411,7 @@ static void *scsi_tgt_dev_seq_next(struct seq_file
*seq, void *v, loff_t *pos)
 }

 static void scsi_tgt_dev_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -481,6 +493,7 @@ static const struct file_operations
scsi_tgt_dev_seq_fops = {
  * SCSI Target Port Table
  */
 static void *scsi_tgt_port_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -491,6 +504,7 @@ static void *scsi_tgt_port_seq_next(struct
seq_file *seq, void *v, loff_t *pos)
 }

 static void scsi_tgt_port_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
@@ -575,6 +589,7 @@ static const struct file_operations
scsi_tgt_port_seq_fops = {
  * Iterates through all active TPGs and extracts the info from the ACLs
  */
 static void *scsi_auth_intr_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_tpg_lock)
 {
 	spin_lock_bh(&se_global->se_tpg_lock);
 	return seq_list_start(&se_global->g_se_tpg_list, *pos);
@@ -587,6 +602,7 @@ static void *scsi_auth_intr_seq_next(struct
seq_file *seq, void *v,
 }

 static void scsi_auth_intr_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_tpg_lock)
 {
 	spin_unlock_bh(&se_global->se_tpg_lock);
 }
@@ -700,6 +716,7 @@ static const struct file_operations
scsi_auth_intr_seq_fops = {
  * to list the info fo this table.
  */
 static void *scsi_att_intr_port_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->se_tpg_lock)
 {
 	spin_lock_bh(&se_global->se_tpg_lock);
 	return seq_list_start(&se_global->g_se_tpg_list, *pos);
@@ -712,6 +729,7 @@ static void *scsi_att_intr_port_seq_next(struct
seq_file *seq, void *v,
 }

 static void scsi_att_intr_port_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->se_tpg_lock)
 {
 	spin_unlock_bh(&se_global->se_tpg_lock);
 }
@@ -824,6 +842,7 @@ static const struct file_operations
scsi_att_intr_port_seq_fops = {
  * SCSI Logical Unit Table
  */
 static void *scsi_lu_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&se_global->g_device_lock)
 {
 	return locate_hba_start(seq, pos);
 }
@@ -834,6 +853,7 @@ static void *scsi_lu_seq_next(struct seq_file
*seq, void *v, loff_t *pos)
 }

 static void scsi_lu_seq_stop(struct seq_file *seq, void *v)
+	__releases(&se_global->g_device_lock)
 {
 	locate_hba_stop(seq, v);
 }
diff --git a/drivers/target/target_core_pscsi.c
b/drivers/target/target_core_pscsi.c
index 742d246..3546e9a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -442,6 +442,7 @@ static struct se_device *pscsi_create_type_disk(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt
*)pdv->pdv_se_hba->hba_ptr;
@@ -489,6 +490,7 @@ static struct se_device *pscsi_create_type_rom(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt
*)pdv->pdv_se_hba->hba_ptr;
@@ -523,6 +525,7 @@ static struct se_device *pscsi_create_type_other(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt
*)pdv->pdv_se_hba->hba_ptr;
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
diff --git a/drivers/target/target_core_transport.c
b/drivers/target/target_core_transport.c
index 28b6292..a318927 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,8 +228,6 @@ static void transport_remove_cmd_from_queue(struct
se_cmd *cmd,
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
 static void transport_stop_all_task_timers(struct se_cmd *cmd);

-int transport_emulate_control_cdb(struct se_task *task);
-
 int init_se_global(void)
 {
 	struct se_global *global;
@@ -4370,7 +4368,7 @@ out:
 	return -1;
 }

-extern u32 transport_calc_sg_num(
+u32 transport_calc_sg_num(
 	struct se_task *task,
 	struct se_mem *in_se_mem,
 	u32 task_offset)
diff --git a/include/target/target_core_transport.h
b/include/target/target_core_transport.h
index 66f44e5..f87f20d 100644
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
@@ -163,6 +165,7 @@ extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
 extern int transport_generic_handle_cdb_map(struct se_cmd *);
+extern int transport_emulate_control_cdb(struct se_task *);
 extern int transport_generic_handle_data(struct se_cmd *);
 extern void transport_new_cmd_failure(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
