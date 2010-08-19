From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm: Remove legacy struct se_lun->lun_type_ptr
Date: Thu, 19 Aug 2010 15:13:16 -0700
Message-ID: <1282255996-12919-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the usage of the type 'void *' struct se_lun->lun_type_ptr,
which is leftover from legacy LIO v2.x code which supported other non 'struct se_device'
LUNs.  While a proper struct se_lun->se_dev pointer has existed for some time
in TCM v3.x code, this had only been used by SPC-3 PR and ALUA state machine code.

This pointer is still used in a number of areas, namely when an incoming CDB to
obtain a struct se_device pointer from a particular TPG LUN.  This patch converts
all usage of struct se_lun->lun_type_ptr to a slightly more grokable
struct se_lun->lun_se_dev in the handful of TCM, and one LIO-Target location that
where not using the SE_DEV() macro.

This patch also includes a handful of cleanups to target_core_transport.c I/O
path code to remove 'void *obj_type_ptr' usage from parameter and internal usage,
and instead just use 'struct se_device *dev = SE_DEV(cmd)' wherever possible.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_mib.c |    8 +-
 drivers/target/target_core_alua.c            |    6 +-
 drivers/target/target_core_device.c          |   26 ++++----
 drivers/target/target_core_fabric_configfs.c |    2 +-
 drivers/target/target_core_mib.c             |    8 +-
 drivers/target/target_core_tpg.c             |   14 +---
 drivers/target/target_core_transport.c       |   94 ++++++++++----------------
 include/target/target_core_base.h            |    5 +-
 include/target/target_core_transport.h       |    8 +-
 9 files changed, 71 insertions(+), 100 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_mib.c b/drivers/target/lio-target/iscsi_target_mib.c
index f2fdb39..b3330bb 100644
--- a/drivers/target/lio-target/iscsi_target_mib.c
+++ b/drivers/target/lio-target/iscsi_target_mib.c
@@ -1151,13 +1151,13 @@ int lio_scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 
 			lun = deve->se_lun;
 			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
-			    (!lun->se_dev))
+			    (!lun->lun_se_dev))
 				continue;
 
 			seq_printf(seq, "%u %u %u %u %u %s %u %u %u %u"
 				" %u %u %u %s\n",
 				tiqn->tiqn_index, /* scsiInstIndex */
-				lun->se_dev->dev_index, /* scsiDeviceIndex */
+				lun->lun_se_dev->dev_index, /* scsiDeviceIndex */
 				tpg->tpgt, /* scsiAuthIntrTgtPortIndex */
 				se_nacl->acl_index, /* scsiAuthIntrIndex */
 				1, /* scsiAuthIntrDevOrPort */
@@ -1245,13 +1245,13 @@ int lio_scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 
 			lun = deve->se_lun;
 			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
-			    (!lun->se_dev))
+			    (!lun->lun_se_dev))
 				continue;
 
 			seq_printf(seq, "%u %u %u %u %u "
 				   "%s+i+%02x%02x%02x%02x%02x%02x\n",
 			   tiqn->tiqn_index, /* scsiInstIndex */
-			   lun->se_dev->dev_index, /* scsiDeviceIndex */
+			   lun->lun_se_dev->dev_index, /* scsiDeviceIndex */
 			   tpg->tpgt, /* scsiPortIndex */
 			   sess->session_index,  /* scsiAttIntrPortIndex */
 			   se_nacl->acl_index, /* scsiAttIntrPortAuthIntrIdx */
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 85b8954..814c06d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1441,7 +1441,7 @@ void core_alua_free_tg_pt_gp(
 
 void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 {
-	struct se_subsystem_dev *su_dev = port->sep_lun->se_dev->se_sub_dev;
+	struct se_subsystem_dev *su_dev = port->sep_lun->lun_se_dev->se_sub_dev;
 	struct t10_alua *alua = T10_ALUA(su_dev);
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
@@ -1540,7 +1540,7 @@ void __core_alua_drop_tg_pt_gp_mem(
 
 ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
 {
-	struct se_subsystem_dev *su_dev = port->sep_lun->se_dev->se_sub_dev;
+	struct se_subsystem_dev *su_dev = port->sep_lun->lun_se_dev->se_sub_dev;
 	struct config_item *tg_pt_ci;
 	struct t10_alua *alua = T10_ALUA(su_dev);
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -1584,7 +1584,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 {
 	struct se_portal_group *tpg;
 	struct se_lun *lun;
-	struct se_subsystem_dev *su_dev = port->sep_lun->se_dev->se_sub_dev;
+	struct se_subsystem_dev *su_dev = port->sep_lun->lun_se_dev->se_sub_dev;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *tg_pt_gp_new = NULL;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ec30ddf..efc85be 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -222,7 +222,7 @@ extern int __transport_get_lun_for_cmd(
 		se_lun = se_cmd->se_lun = deve->se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
-		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_type_ptr;
+		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 	}
 out:
@@ -267,7 +267,7 @@ out:
 #endif
 			se_lun = se_cmd->se_lun = &se_sess->se_tpg->tpg_virt_lun0;	
 			se_cmd->orig_fe_lun = 0;
-			se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_type_ptr;
+			se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
 			se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		}
 	}
@@ -275,14 +275,14 @@ out:
 	 * Determine if the struct se_lun is online.
 	 */
 /* #warning FIXME: Check for LUN_RESET + UNIT Attention */
-	if (se_dev_check_online(se_lun->lun_type_ptr) != 0) {
+	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->scsi_sense_reason = NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -1;
 	}
 
 	{
-	struct se_device *dev = se_lun->se_dev;
+	struct se_device *dev = se_lun->lun_se_dev;
 	spin_lock(&dev->stats_lock);
 	dev->num_cmds++;
 	if (se_cmd->data_direction == SE_DIRECTION_WRITE)
@@ -323,10 +323,10 @@ extern int transport_get_lun_for_tmr(
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		se_lun = se_cmd->se_lun = se_tmr->tmr_lun = deve->se_lun;
-		dev = se_tmr->tmr_dev = se_lun->se_dev;
+		dev = se_tmr->tmr_dev = se_lun->lun_se_dev;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
-		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_type_ptr;
+		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
 /*		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD; */
 	}
 	spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
@@ -343,7 +343,7 @@ extern int transport_get_lun_for_tmr(
 	 * Determine if the struct se_lun is online.
 	 */
 /* #warning FIXME: Check for LUN_RESET + UNIT Attention */
-	if (se_dev_check_online(se_lun->lun_type_ptr) != 0) {
+	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -1;
 	}
@@ -577,7 +577,7 @@ int core_update_device_list_for_node(
 	deve->attach_count--;
 	spin_unlock_bh(&nacl->device_list_lock);
 
-	core_scsi3_free_pr_reg_from_nacl(lun->se_dev, nacl);
+	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
 }
 
@@ -742,7 +742,7 @@ int core_dev_export(
 	if (!(port))
 		return -1;
 
-	lun->se_dev = dev;
+	lun->lun_se_dev = dev;
 	se_dev_start(dev);
 
 	atomic_inc(&dev->dev_export_obj.obj_access_count);
@@ -758,7 +758,7 @@ void core_dev_unexport(
 	struct se_port *port = lun->lun_sep;
 
 	spin_lock(&lun->lun_sep_lock);
-	if (lun->lun_type_ptr == NULL) {
+	if (lun->lun_se_dev == NULL) {
 		spin_unlock(&lun->lun_sep_lock);
 		return;
 	}
@@ -770,7 +770,7 @@ void core_dev_unexport(
 	spin_unlock(&dev->se_port_lock);
 
 	se_dev_stop(dev);
-	lun->se_dev = NULL;
+	lun->lun_se_dev = NULL;
 }
 
 int transport_core_report_lun_response(struct se_cmd *se_cmd)
@@ -925,7 +925,7 @@ void se_clear_dev_ports(struct se_device *dev)
 		lun = sep->sep_lun;
 		tpg = sep->sep_tpg;
 		spin_lock(&lun->lun_sep_lock);
-		if (lun->lun_type_ptr == NULL) {
+		if (lun->lun_se_dev == NULL) {
 			spin_unlock(&lun->lun_sep_lock);
 			continue;
 		}
@@ -1500,7 +1500,7 @@ int core_dev_add_initiator_node_lun_acl(
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
-	core_scsi3_check_aptpl_registration(lun->se_dev, tpg, lun, lacl);
+	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, lacl);
 	return 0;
 }
 EXPORT_SYMBOL(core_dev_add_initiator_node_lun_acl);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index d5eb1ad..e1a64eb 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -637,7 +637,7 @@ static int target_fabric_port_link(
 				struct se_portal_group, tpg_group);
 	tf = se_tpg->se_tpg_wwn->wwn_tf;
 
-	if (lun->lun_type_ptr != NULL) {
+	if (lun->lun_se_dev!= NULL) {
 		printk(KERN_ERR "Port Symlink already exists\n");
 		return -EEXIST;
 	}
diff --git a/drivers/target/target_core_mib.c b/drivers/target/target_core_mib.c
index b365582..9fae6a2 100644
--- a/drivers/target/target_core_mib.c
+++ b/drivers/target/target_core_mib.c
@@ -623,7 +623,7 @@ static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 				continue;
 			lun = deve->se_lun;
 			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
-			    (!lun->se_dev))
+			    (!lun->lun_se_dev))
 				continue;
 
 			seq_printf(seq, "%u %u %u %u %u %s %u %u %u %u %u %u"
@@ -633,7 +633,7 @@ static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 				TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
 				0,
 				/* scsiDeviceIndex */
-				lun->se_dev->dev_index,
+				lun->lun_se_dev->dev_index,
 				/* scsiAuthIntrTgtPortIndex */
 				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
 				/* scsiAuthIntrIndex */
@@ -749,7 +749,7 @@ static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 
 			lun = deve->se_lun;
 			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
-			    (!lun->se_dev))
+			    (!lun->lun_se_dev))
 				continue;
 
 			memset(buf, 0, 64);
@@ -763,7 +763,7 @@ static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 				TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
 				0,
 				/* scsiDeviceIndex */
-				lun->se_dev->dev_index,
+				lun->lun_se_dev->dev_index,
 				/* scsiPortIndex */
 				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
 				/* scsiAttIntrPortIndex */
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d273698..03173f2 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -167,7 +167,7 @@ void core_tpg_add_node_to_devs(
 
 		spin_unlock(&tpg->tpg_lun_lock);
 
-		dev = lun->se_dev;
+		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
@@ -327,7 +327,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 		lun = &tpg->tpg_lun_list[i];
 
 		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_type_ptr == NULL))
+		    (lun->lun_se_dev == NULL))
 			continue;
 
 		spin_unlock(&tpg->tpg_lun_lock);
@@ -604,7 +604,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	int ret;
 
 	lun->unpacked_lun = 0;	
-	lun->lun_type_ptr = NULL;
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
@@ -650,7 +649,6 @@ int core_tpg_register(
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		lun = &se_tpg->tpg_lun_list[i];
 		lun->unpacked_lun = i;
-		lun->lun_type_ptr = NULL;
 		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 		atomic_set(&lun->lun_acl_count, 0);
 		init_completion(&lun->lun_shutdown_comp);
@@ -757,11 +755,8 @@ int core_tpg_post_addlun(
 	u32 lun_access,
 	void *lun_ptr)
 {
-	lun->lun_type_ptr = lun_ptr;
-	if (core_dev_export(lun_ptr, tpg, lun) < 0) {
-		lun->lun_type_ptr = NULL;
+	if (core_dev_export(lun_ptr, tpg, lun) < 0)
 		return -1;
-	}
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_access = lun_access;
@@ -831,12 +826,11 @@ int core_tpg_post_dellun(
 
 	core_tpg_shutdown_lun(tpg, lun);
 
-	core_dev_unexport(lun->lun_type_ptr, tpg, lun);
+	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	lun->lun_type = 0;
-	lun->lun_type_ptr = NULL;
 	spin_unlock(&tpg->tpg_lun_lock);
 
 	spin_lock(&lun->lun_acl_lock);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1e5bd70..97b6254 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2532,17 +2532,6 @@ static struct se_task *transport_generic_get_task(
 	return task;
 }
 
-static inline int transport_generic_obj_start(
-	struct se_transform_info *ti,
-	void *p,
-	unsigned long long starting_lba)
-{
-	ti->ti_lba = starting_lba;
-	ti->ti_obj_ptr = p;
-
-	return 0;
-}
-
 static inline map_func_t transport_dev_get_map_SG(
 	struct se_device *dev,
 	int rw)
@@ -2702,7 +2691,7 @@ static int transport_generic_cmd_sequencer(struct se_cmd *, unsigned char *);
 void transport_device_setup_cmd(struct se_cmd *cmd)
 {
 	cmd->transport_add_cmd_to_queue = &transport_add_cmd_to_dev_queue;
-	cmd->se_dev = SE_LUN(cmd)->se_dev;
+	cmd->se_dev = SE_LUN(cmd)->lun_se_dev;
 }
 
 struct se_cmd *__transport_alloc_se_cmd(
@@ -4202,7 +4191,7 @@ static inline u32 transport_get_sectors_6(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->se_dev;
+	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -4230,7 +4219,7 @@ static inline u32 transport_get_sectors_10(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->se_dev;
+	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -4260,7 +4249,7 @@ static inline u32 transport_get_sectors_12(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->se_dev;
+	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -4290,7 +4279,7 @@ static inline u32 transport_get_sectors_16(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->se_dev;
+	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -5748,11 +5737,9 @@ struct se_cmd *transport_allocate_passthrough(
 	}
 
 	spin_lock_init(&cmd->se_lun->lun_sep_lock);
-	SE_LUN(cmd)->lun_type_ptr = type_ptr;
-
 	cmd->se_orig_obj_ptr = type_ptr;
 	cmd->se_cmd_flags = se_cmd_flags;
-	SE_LUN(cmd)->se_dev = (struct se_device *) type_ptr;
+	SE_LUN(cmd)->lun_se_dev = (struct se_device *) type_ptr;
 
 	/*
 	 * Double check that the passed object is currently accepting CDBs
@@ -5771,7 +5758,7 @@ struct se_cmd *transport_allocate_passthrough(
 
 	memset(&ti, 0, sizeof(struct se_transform_info));
 	ti.ti_data_length = cmd->data_length;
-	ti.ti_dev = SE_LUN(cmd)->se_dev;
+	ti.ti_dev = SE_LUN(cmd)->lun_se_dev;
 	ti.ti_se_cmd = cmd;
 	ti.se_obj_ptr = type_ptr;
 
@@ -5818,10 +5805,10 @@ struct se_cmd *transport_allocate_passthrough(
 #endif
 	}
 
-	if (transport_get_sectors(cmd, type_ptr) < 0)
+	if (transport_get_sectors(cmd) < 0)
 		goto fail;
 
-	if (transport_new_cmd_obj(cmd, &ti, type_ptr, 0) < 0)
+	if (transport_new_cmd_obj(cmd, &ti, 0) < 0)
 		goto fail;
 
 	return cmd;
@@ -6449,8 +6436,7 @@ static inline long long transport_dev_end_lba(struct se_device *dev)
 }
 
 int transport_get_sectors(
-	struct se_cmd *cmd,
-	void *obj_ptr)
+	struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 
@@ -6466,11 +6452,11 @@ int transport_get_sectors(
 		return 0;
 
 	if ((T_TASK(cmd)->t_task_lba + T_TASK(cmd)->t_task_sectors) >
-	     transport_dev_end_lba(obj_ptr)) {
+	     transport_dev_end_lba(dev)) {
 		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
 			T_TASK(cmd)->t_task_lba, T_TASK(cmd)->t_task_sectors,
-			transport_dev_end_lba(obj_ptr));
+			transport_dev_end_lba(dev));
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = SECTOR_COUNT_TOO_MANY;
 		return PYX_TRANSPORT_REQ_TOO_MANY_SECTORS;
@@ -6482,7 +6468,6 @@ int transport_get_sectors(
 int transport_new_cmd_obj(
 	struct se_cmd *cmd,
 	struct se_transform_info *ti,
-	void *obj_ptr,
 	int post_execute)
 {
 	u32 task_cdbs = 0;
@@ -6496,7 +6481,7 @@ int transport_new_cmd_obj(
 		ti->ti_set_counts = 1;
 		ti->ti_dev = dev;
 
-		task_cdbs = transport_generic_get_cdb_count(cmd, ti, obj_ptr,
+		task_cdbs = transport_generic_get_cdb_count(cmd, ti,
 				T_TASK(cmd)->t_task_lba,
 				T_TASK(cmd)->t_task_sectors,
 				NULL, &se_mem_out);
@@ -6692,21 +6677,21 @@ next:
 
 static inline int transport_set_task_sectors_disk(
 	struct se_task *task,
-	void *obj_ptr,
+	struct se_device *dev,
 	unsigned long long lba,
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if ((lba + sectors) > transport_dev_end_lba(obj_ptr)) {
-		task->task_sectors = ((transport_dev_end_lba(obj_ptr) - lba) + 1);
+	if ((lba + sectors) > transport_dev_end_lba(dev)) {
+		task->task_sectors = ((transport_dev_end_lba(dev) - lba) + 1);
 
-		if (task->task_sectors > transport_dev_max_sectors(obj_ptr)) {
-			task->task_sectors = transport_dev_max_sectors(obj_ptr);
+		if (task->task_sectors > transport_dev_max_sectors(dev)) {
+			task->task_sectors = transport_dev_max_sectors(dev);
 			*max_sectors_set = 1;
 		}
 	} else {
-		if (sectors > transport_dev_max_sectors(obj_ptr)) {
-			task->task_sectors = transport_dev_max_sectors(obj_ptr);
+		if (sectors > transport_dev_max_sectors(dev)) {
+			task->task_sectors = transport_dev_max_sectors(dev);
 			*max_sectors_set = 1;
 		} else
 			task->task_sectors = sectors;
@@ -6717,13 +6702,13 @@ static inline int transport_set_task_sectors_disk(
 
 static inline int transport_set_task_sectors_non_disk(
 	struct se_task *task,
-	void *obj_ptr,
+	struct se_device *dev,
 	unsigned long long lba,
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if (sectors > transport_dev_max_sectors(obj_ptr)) {
-		task->task_sectors = transport_dev_max_sectors(obj_ptr);
+	if (sectors > transport_dev_max_sectors(dev)) {
+		task->task_sectors = transport_dev_max_sectors(dev);
 		*max_sectors_set = 1;
 	} else
 		task->task_sectors = sectors;
@@ -6733,17 +6718,15 @@ static inline int transport_set_task_sectors_non_disk(
 
 static inline int transport_set_task_sectors(
 	struct se_task *task,
-	void *obj_ptr,
+	struct se_device *dev,
 	unsigned long long lba,
 	u32 sectors,
 	int *max_sectors_set)
 {
-	struct se_device *dev = obj_ptr;	
-
 	return (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK) ?
-		transport_set_task_sectors_disk(task, obj_ptr, lba, sectors,
+		transport_set_task_sectors_disk(task, dev, lba, sectors,
 				max_sectors_set) :
-		transport_set_task_sectors_non_disk(task, obj_ptr, lba, sectors,
+		transport_set_task_sectors_non_disk(task, dev, lba, sectors,
 				max_sectors_set);
 }
 
@@ -6952,14 +6935,12 @@ static int transport_do_se_mem_map(
 u32 transport_generic_get_cdb_count(
 	struct se_cmd *cmd,
 	struct se_transform_info *ti,
-	void *head_obj_ptr,
 	unsigned long long starting_lba,
 	u32 sectors,
 	struct se_mem *se_mem_in,
 	struct se_mem **se_mem_out)
 {
 	unsigned char *cdb = NULL;
-	void *obj_ptr;
 	struct se_task *task;
 	struct se_mem *se_mem, *se_mem_lout = NULL;
 	struct se_device *dev = SE_DEV(cmd);
@@ -6982,27 +6963,25 @@ u32 transport_generic_get_cdb_count(
 	 * Locate the start volume segment in which the received LBA will be
 	 * executed upon.
 	 */
-	ret = transport_generic_obj_start(ti, head_obj_ptr, starting_lba);
-	if (ret < 0)
-		return 0;
+	ti->ti_lba = starting_lba;
+        ti->ti_obj_ptr = dev;
 	/*
 	 * Locate starting object from original starting_lba.
 	 */
 	lba = ti->ti_lba;
-	obj_ptr = ti->ti_obj_ptr;
 	DEBUG_VOL("Starting Physical LBA(%llu)\n", lba);
 
 	while (sectors) {
 
 		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
 			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
-			transport_dev_end_lba(obj_ptr));
+			transport_dev_end_lba(dev));
 
-		task = cmd->transport_get_task(ti, cmd, obj_ptr);
+		task = cmd->transport_get_task(ti, cmd, dev);
 		if (!(task))
 			goto out;
 
-		transport_set_task_sectors(task, obj_ptr, lba, sectors,
+		transport_set_task_sectors(task, dev, lba, sectors,
 				&max_sectors_set);
 
 		task->task_lba = lba;
@@ -7010,7 +6989,7 @@ u32 transport_generic_get_cdb_count(
 		sectors -= task->task_sectors;
 		task->task_size = (task->task_sectors *
 				   DEV_ATTRIB(dev)->block_size);
-		task->transport_map_task = transport_dev_get_map_SG(obj_ptr,
+		task->transport_map_task = transport_dev_get_map_SG(dev,
 					cmd->data_direction);
 
 		cdb = TRANSPORT(dev)->get_cdb(task);
@@ -7024,7 +7003,7 @@ u32 transport_generic_get_cdb_count(
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
 		 * mapping for T_TASK(cmd)->t_mem_list.
 		 */
-		ret = transport_do_se_mem_map((struct se_device *)obj_ptr, task,
+		ret = transport_do_se_mem_map(dev, task,
 				T_TASK(cmd)->t_mem_list, NULL, se_mem,
 				&se_mem_lout, &se_mem_cnt, &task_offset_in);
 		if (ret < 0)
@@ -7075,7 +7054,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	memset((void *)&ti, 0, sizeof(struct se_transform_info));
 	ti.ti_se_cmd = cmd;
-	ti.se_obj_ptr = SE_LUN(cmd)->lun_type_ptr;
+	ti.se_obj_ptr = SE_LUN(cmd)->lun_se_dev;
 
 	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
 		/*
@@ -7093,12 +7072,11 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 				goto failure;
 		}
 
-		ret = transport_get_sectors(cmd, SE_LUN(cmd)->lun_type_ptr);
+		ret = transport_get_sectors(cmd);
 		if (ret < 0)
 			goto failure;
 
-		ret = transport_new_cmd_obj(cmd, &ti,
-					SE_LUN(cmd)->lun_type_ptr, 0);
+		ret = transport_new_cmd_obj(cmd, &ti, 0);
 		if (ret < 0)
 			goto failure;
 		/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f268a38..6d82641 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -854,7 +854,7 @@ struct se_device {
 	struct list_head	g_se_dev_list;
 }  ____cacheline_aligned;
 
-#define SE_DEV(cmd)		((struct se_device *)(cmd)->se_lun->se_dev)
+#define SE_DEV(cmd)		((struct se_device *)(cmd)->se_lun->lun_se_dev)
 #define SU_DEV(dev)		((struct se_subsystem_dev *)(dev)->se_sub_dev)
 #define ISCSI_DEV(cmd)		SE_DEV(cmd)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
@@ -902,8 +902,7 @@ struct se_lun {
 	struct completion	lun_shutdown_comp;
 	struct list_head	lun_cmd_list;
 	struct list_head	lun_acl_list;
-	struct se_device		*se_dev;
-	void			*lun_type_ptr;
+	struct se_device	*lun_se_dev;
 	struct config_group	lun_group;
 	struct se_port	*lun_sep;
 } ____cacheline_aligned;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index fefe20b..d1a3a9a 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -270,9 +270,9 @@ extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
 extern int transport_generic_do_transform(struct se_cmd *,
 					struct se_transform_info *);
-extern int transport_get_sectors(struct se_cmd *, void *);
+extern int transport_get_sectors(struct se_cmd *);
 extern int transport_new_cmd_obj(struct se_cmd *,
-				struct se_transform_info *, void *, int);
+				struct se_transform_info *, int);
 extern unsigned char *transport_get_vaddr(struct se_mem *);
 extern struct list_head *transport_init_se_mem_list(void);
 extern void transport_free_se_mem_list(struct list_head *);
@@ -285,8 +285,8 @@ extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
 					struct se_mem **, u32 *, u32 *);
 extern u32 transport_generic_get_cdb_count(struct se_cmd *,
 					struct se_transform_info *,
-					void *, unsigned long long, u32,
-					struct se_mem *, struct se_mem **);
+					unsigned long long, u32, struct se_mem *,
+					struct se_mem **);
 extern int transport_generic_new_cmd(struct se_cmd *);
 extern void transport_generic_process_write(struct se_cmd *);
 extern int transport_generic_do_tmr(struct se_cmd *);
-- 
1.5.6.5
