From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 034/103] target: Use cmd->se_dev over cmd->se_lun->lun_se_dev
Date: Thu, 21 Jul 2011 00:07:46 -0700
Message-ID: <1311232135-6653-35-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29.access.bullet.mail.sp2.yahoo.com ([98.139.44.156]:26050
	"HELO nm29.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751970Ab1GUHDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:03:14 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Once transport_device_setup_cmd() is called, cmd->se_dev has the same
value as cmd->se_lun->lun_se_dev, and it is ok to refer to this location
when needing to get the se_dev from the cmd, instead of the longer version.

(nab: Fix Fix virtual lun0 se_cmd->se_orig_obj_ptr initialization)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |    4 +-
 drivers/target/target_core_cdb.c       |   28 +++---
 drivers/target/target_core_device.c    |  141 ++++++++++++++-----------------
 drivers/target/target_core_file.c      |    2 +-
 drivers/target/target_core_iblock.c    |    4 +-
 drivers/target/target_core_pr.c        |   64 +++++++-------
 drivers/target/target_core_rd.c        |    2 +-
 drivers/target/target_core_transport.c |   86 ++++++++++----------
 drivers/target/target_core_ua.c        |    2 +-
 9 files changed, 160 insertions(+), 173 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 6dbceb4..76abd86 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -61,7 +61,7 @@ struct t10_alua_lu_gp *default_lu_gp;
  */
 int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 {
-	struct se_subsystem_dev *su_dev = cmd->se_lun->lun_se_dev->se_sub_dev;
+	struct se_subsystem_dev *su_dev = cmd->se_dev->se_sub_dev;
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
@@ -151,7 +151,7 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
  */
 int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct se_port *port, *l_port = cmd->se_lun->lun_sep;
 	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 6908f8a..95195d7 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -65,7 +65,7 @@ static int
 target_emulate_inquiry_std(struct se_cmd *cmd)
 {
 	struct se_lun *lun = cmd->se_lun;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf = cmd->t_task.t_task_buf;
 
 	/*
@@ -128,7 +128,7 @@ target_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 	 * Registered Extended LUN WWN has been set via ConfigFS
 	 * during device creation/restart.
 	 */
-	if (cmd->se_lun->lun_se_dev->se_sub_dev->su_dev_flags &
+	if (cmd->se_dev->se_sub_dev->su_dev_flags &
 			SDF_EMULATED_VPD_UNIT_SERIAL) {
 		buf[3] = 3;
 		buf[5] = 0x80;
@@ -143,7 +143,7 @@ target_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	u16 len = 0;
 
 	buf[1] = 0x80;
@@ -176,7 +176,7 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_lun *lun = cmd->se_lun;
 	struct se_port *port = NULL;
 	struct se_portal_group *tpg = NULL;
@@ -477,7 +477,7 @@ target_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	buf[5] = 0x07;
 
 	/* If WriteCache emulation is enabled, set V_SUP */
-	if (cmd->se_lun->lun_se_dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0)
+	if (cmd->se_dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0)
 		buf[6] = 0x01;
 	return 0;
 }
@@ -486,7 +486,7 @@ target_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	int have_tp = 0;
 
 	/*
@@ -568,7 +568,7 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * From sbc3r22 section 6.5.4 Thin Provisioning VPD page:
@@ -620,7 +620,7 @@ target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_inquiry(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf = cmd->t_task.t_task_buf;
 	unsigned char *cdb = cmd->t_task.t_task_cdb;
 
@@ -665,7 +665,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 static int
 target_emulate_readcapacity(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf = cmd->t_task.t_task_buf;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
 	u32 blocks;
@@ -695,7 +695,7 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 static int
 target_emulate_readcapacity_16(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf = cmd->t_task.t_task_buf;
 	unsigned long long blocks = dev->transport->get_blocks(dev);
 
@@ -830,7 +830,7 @@ target_modesense_dpofua(unsigned char *buf, int type)
 static int
 target_emulate_modesense(struct se_cmd *cmd, int ten)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	char *cdb = cmd->t_task.t_task_cdb;
 	unsigned char *rbuf = cmd->t_task.t_task_buf;
 	int type = dev->transport->get_device_type(dev);
@@ -964,7 +964,7 @@ static int
 target_emulate_unmap(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf = cmd->t_task.t_task_buf, *ptr = NULL;
 	unsigned char *cdb = &cmd->t_task.t_task_cdb[0];
 	sector_t lba;
@@ -1011,7 +1011,7 @@ static int
 target_emulate_write_same(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	sector_t lba = cmd->t_task.t_task_lba;
 	unsigned int range;
 	int ret;
@@ -1036,7 +1036,7 @@ int
 transport_emulate_control_cdb(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned short service_action;
 	int ret = 0;
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8e8d625..c7b9ef7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -61,11 +61,10 @@ struct se_device *g_lun0_dev;
 
 int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
-	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_device *dev;
 	unsigned long flags;
-	int read_only = 0;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
@@ -74,91 +73,84 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	}
 
 	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
-	deve = se_cmd->se_deve =
-			&se_sess->se_node_acl->device_list[unpacked_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		if (se_cmd) {
-			deve->total_cmds++;
-			deve->total_bytes += se_cmd->data_length;
-
-			if (se_cmd->data_direction == DMA_TO_DEVICE) {
-				if (deve->lun_flags &
-						TRANSPORT_LUNFLAGS_READ_ONLY) {
-					read_only = 1;
-					goto out;
-				}
-				deve->write_bytes += se_cmd->data_length;
-			} else if (se_cmd->data_direction ==
-				   DMA_FROM_DEVICE) {
-				deve->read_bytes += se_cmd->data_length;
-			}
+	se_cmd->se_deve = &se_sess->se_node_acl->device_list[unpacked_lun];
+	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+		struct se_dev_entry *deve = se_cmd->se_deve;
+
+		deve->total_cmds++;
+		deve->total_bytes += se_cmd->data_length;
+
+		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
+		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
+			se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
+			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			printk("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				" Access for 0x%08x\n",
+				se_cmd->se_tfo->get_fabric_name(),
+				unpacked_lun);
+			spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
+			return -EACCES;
 		}
+
+		if (se_cmd->data_direction == DMA_TO_DEVICE)
+			deve->write_bytes += se_cmd->data_length;
+		else if (se_cmd->data_direction == DMA_FROM_DEVICE)
+			deve->read_bytes += se_cmd->data_length;
+
 		deve->deve_cmds++;
 
-		se_lun = se_cmd->se_lun = deve->se_lun;
+		se_lun = deve->se_lun;
+		se_cmd->se_lun = deve->se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 	}
-out:
 	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
 	if (!se_lun) {
-		if (read_only) {
-			se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
+		/*
+		 * Use the se_portal_group->tpg_virt_lun0 to allow for
+		 * REPORT_LUNS, et al to be returned when no active
+		 * MappedLUN=0 exists for this Initiator Port.
+		 */
+		if (unpacked_lun != 0) {
+			se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-			printk("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+			printk("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 				" Access for 0x%08x\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
+			return -ENODEV;
+		}
+		/*
+		 * Force WRITE PROTECT for virtual LUN 0
+		 */
+		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
+		    (se_cmd->data_direction != DMA_NONE)) {
+			se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
+			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			return -EACCES;
-		} else {
-			/*
-			 * Use the se_portal_group->tpg_virt_lun0 to allow for
-			 * REPORT_LUNS, et al to be returned when no active
-			 * MappedLUN=0 exists for this Initiator Port.
-			 */
-			if (unpacked_lun != 0) {
-				se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
-				se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-				printk("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-					" Access for 0x%08x\n",
-					se_cmd->se_tfo->get_fabric_name(),
-					unpacked_lun);
-				return -ENODEV;
-			}
-			/*
-			 * Force WRITE PROTECT for virtual LUN 0
-			 */
-			if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
-			    (se_cmd->data_direction != DMA_NONE)) {
-				se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
-				se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-				return -EACCES;
-			}
-#if 0
-			printk("TARGET_CORE[%s]: Using virtual LUN0! :-)\n",
-				se_cmd->se_tfo->get_fabric_name());
-#endif
-			se_lun = se_cmd->se_lun = &se_sess->se_tpg->tpg_virt_lun0;
-			se_cmd->orig_fe_lun = 0;
-			se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
-			se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		}
+
+		se_lun = &se_sess->se_tpg->tpg_virt_lun0;
+		se_cmd->se_lun = &se_sess->se_tpg->tpg_virt_lun0;
+		se_cmd->orig_fe_lun = 0;
+		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
+		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 	}
 	/*
 	 * Determine if the struct se_lun is online.
+	 * FIXME: Check for LUN_RESET + UNIT Attention
 	 */
-/* #warning FIXME: Check for LUN_RESET + UNIT Attention */
 	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -ENODEV;
 	}
 
-	{
-	struct se_device *dev = se_lun->lun_se_dev;
+	/* TODO: get rid of this and use atomics for stats */
+	dev = se_lun->lun_se_dev;
 	spin_lock_irq(&dev->stats_lock);
 	dev->num_cmds++;
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
@@ -166,7 +158,6 @@ out:
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
 		dev->read_bytes += se_cmd->data_length;
 	spin_unlock_irq(&dev->stats_lock);
-	}
 
 	/*
 	 * Add the iscsi_cmd_t to the struct se_lun's cmd list.  This list is used
@@ -175,10 +166,6 @@ out:
 	spin_lock_irqsave(&se_lun->lun_cmd_lock, flags);
 	list_add_tail(&se_cmd->se_lun_list, &se_lun->lun_cmd_list);
 	atomic_set(&se_cmd->t_task.transport_lun_active, 1);
-#if 0
-	printk(KERN_INFO "Adding ITT: 0x%08x to LUN LIST[%d]\n",
-		se_cmd->se_tfo->get_task_tag(se_cmd), se_lun->unpacked_lun);
-#endif
 	spin_unlock_irqrestore(&se_lun->lun_cmd_lock, flags);
 
 	return 0;
@@ -187,7 +174,6 @@ EXPORT_SYMBOL(transport_lookup_cmd_lun);
 
 int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
-	struct se_device *dev = NULL;
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
@@ -200,15 +186,17 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	}
 
 	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
-	deve = se_cmd->se_deve =
-			&se_sess->se_node_acl->device_list[unpacked_lun];
+	se_cmd->se_deve = &se_sess->se_node_acl->device_list[unpacked_lun];
+	deve = se_cmd->se_deve;
+
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		se_lun = se_cmd->se_lun = se_tmr->tmr_lun = deve->se_lun;
-		dev = se_lun->lun_se_dev;
+		se_tmr->tmr_lun = deve->se_lun;
+		se_cmd->se_lun = deve->se_lun;
+		se_lun = deve->se_lun;
+		se_tmr->tmr_dev = se_lun->lun_se_dev;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
-		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
-/*		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD; */
+		se_cmd->se_orig_obj_ptr = se_cmd->se_dev;
 	}
 	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
@@ -222,17 +210,16 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	}
 	/*
 	 * Determine if the struct se_lun is online.
+	 * FIXME: Check for LUN_RESET + UNIT Attention
 	 */
-/* #warning FIXME: Check for LUN_RESET + UNIT Attention */
 	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -ENODEV;
 	}
-	se_tmr->tmr_dev = dev;
 
-	spin_lock(&dev->se_tmr_lock);
-	list_add_tail(&se_tmr->tmr_list, &dev->dev_tmr_list);
-	spin_unlock(&dev->se_tmr_lock);
+	spin_lock(&se_tmr->tmr_dev->se_tmr_lock);
+	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
+	spin_unlock(&se_tmr->tmr_dev->se_tmr_lock);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index bd094ba..2e7ea74 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -279,7 +279,7 @@ fd_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	fd_req->fd_dev = cmd->se_lun->lun_se_dev->dev_ptr;
+	fd_req->fd_dev = cmd->se_dev->dev_ptr;
 
 	return &fd_req->fd_task;
 }
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f2c8c73..c73baef 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -240,7 +240,7 @@ iblock_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	ib_req->ib_dev = cmd->se_lun->lun_se_dev->dev_ptr;
+	ib_req->ib_dev = cmd->se_dev->dev_ptr;
 	atomic_set(&ib_req->ib_bio_cnt, 0);
 	return &ib_req->ib_task;
 }
@@ -608,7 +608,7 @@ static struct bio *iblock_get_bio(
 static int iblock_map_task_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct iblock_dev *ib_dev = task->se_dev->dev_ptr;
 	struct iblock_req *ib_req = IBLOCK_REQ(task);
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 06f9afb..19406a3 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1471,7 +1471,7 @@ static int core_scsi3_decode_spec_i_port(
 	int all_tg_pt,
 	int aptpl)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_port *tmp_port;
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
@@ -1509,7 +1509,7 @@ static int core_scsi3_decode_spec_i_port(
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
 	tidh_new->dest_se_deve = local_se_deve;
 
-	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
+	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
 	if (!(local_pr_reg)) {
@@ -1741,7 +1741,7 @@ static int core_scsi3_decode_spec_i_port(
 		 * and then call __core_scsi3_add_registration() in the
 		 * 2nd loop which will never fail.
 		 */
-		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
+		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, all_tg_pt, aptpl);
 		if (!(dest_pr_reg)) {
@@ -1787,7 +1787,7 @@ static int core_scsi3_decode_spec_i_port(
 		prf_isid = core_pr_dump_initiator_port(dest_pr_reg, &i_buf[0],
 						PR_REG_ISID_ID_LEN);
 
-		__core_scsi3_add_registration(cmd->se_lun->lun_se_dev, dest_node_acl,
+		__core_scsi3_add_registration(cmd->se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
 		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
@@ -2071,7 +2071,7 @@ static int core_scsi3_emulate_pro_register(
 	int ignore_key)
 {
 	struct se_session *se_sess = cmd->se_sess;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
 	struct se_portal_group *se_tpg;
@@ -2117,7 +2117,7 @@ static int core_scsi3_emulate_pro_register(
 			 * Port Endpoint that the PRO was received from on the
 			 * Logical Unit of the SCSI device server.
 			 */
-			ret = core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
+			ret = core_scsi3_alloc_registration(cmd->se_dev,
 					se_sess->se_node_acl, se_deve, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					ignore_key, 0);
@@ -2145,7 +2145,7 @@ static int core_scsi3_emulate_pro_register(
 		 */
 		if (!(aptpl)) {
 			pr_tmpl->pr_aptpl_active = 0;
-			core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
+			core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
 			printk("SPC-3 PR: Set APTPL Bit Deactivated for"
 					" REGISTER\n");
 			return 0;
@@ -2155,10 +2155,10 @@ static int core_scsi3_emulate_pro_register(
 		 * update the APTPL metadata information using its
 		 * preallocated *pr_reg->pr_aptpl_buf.
 		 */
-		pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev,
+		pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev,
 				se_sess->se_node_acl, se_sess);
 
-		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret)) {
@@ -2223,7 +2223,7 @@ static int core_scsi3_emulate_pro_register(
 		 */
 		if (!(sa_res_key)) {
 			pr_holder = core_scsi3_check_implict_release(
-					cmd->se_lun->lun_se_dev, pr_reg);
+					cmd->se_dev, pr_reg);
 			if (pr_holder < 0) {
 				kfree(pr_aptpl_buf);
 				core_scsi3_put_pr_reg(pr_reg);
@@ -2260,7 +2260,7 @@ static int core_scsi3_emulate_pro_register(
 			/*
 			 * Release the calling I_T Nexus registration now..
 			 */
-			__core_scsi3_free_registration(cmd->se_lun->lun_se_dev, pr_reg,
+			__core_scsi3_free_registration(cmd->se_dev, pr_reg,
 							NULL, 1);
 			/*
 			 * From spc4r17, section 5.7.11.3 Unregistering
@@ -2315,7 +2315,7 @@ static int core_scsi3_emulate_pro_register(
 			 * READ_KEYS service action.
 			 */
 			pr_reg->pr_res_generation = core_scsi3_pr_generation(
-							cmd->se_lun->lun_se_dev);
+							cmd->se_dev);
 			pr_reg->pr_res_key = sa_res_key;
 			printk("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
 				" Key for %s to: 0x%016Lx PRgeneration:"
@@ -2398,7 +2398,7 @@ static int core_scsi3_pro_reserve(
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -2527,7 +2527,7 @@ static int core_scsi3_pro_reserve(
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -2758,7 +2758,7 @@ static int core_scsi3_emulate_pro_release(
 
 write_aptpl:
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -2783,7 +2783,7 @@ static int core_scsi3_emulate_pro_clear(
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev,
+	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -2849,7 +2849,7 @@ static int core_scsi3_emulate_pro_clear(
 		cmd->se_tfo->get_fabric_name());
 
 	if (pr_tmpl->pr_aptpl_active) {
-		core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
+		core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
 		printk(KERN_INFO "SPC-3 PR: Updated APTPL metadata"
 				" for CLEAR\n");
 	}
@@ -2954,7 +2954,7 @@ static int core_scsi3_pro_preempt(
 	u64 sa_res_key,
 	int abort)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_node_acl *pr_reg_nacl;
 	struct se_session *se_sess = cmd->se_sess;
@@ -2969,7 +2969,7 @@ static int core_scsi3_pro_preempt(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
-	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
+	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -3111,7 +3111,7 @@ static int core_scsi3_pro_preempt(
 		spin_unlock(&dev->dev_reservation_lock);
 
 		if (pr_tmpl->pr_aptpl_active) {
-			ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+			ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 					&pr_reg_n->pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
 			if (!(ret))
@@ -3121,7 +3121,7 @@ static int core_scsi3_pro_preempt(
 		}
 
 		core_scsi3_put_pr_reg(pr_reg_n);
-		core_scsi3_pr_generation(cmd->se_lun->lun_se_dev);
+		core_scsi3_pr_generation(cmd->se_dev);
 		return 0;
 	}
 	/*
@@ -3247,7 +3247,7 @@ static int core_scsi3_pro_preempt(
 	}
 
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg_n->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -3256,7 +3256,7 @@ static int core_scsi3_pro_preempt(
 	}
 
 	core_scsi3_put_pr_reg(pr_reg_n);
-	core_scsi3_pr_generation(cmd->se_lun->lun_se_dev);
+	core_scsi3_pr_generation(cmd->se_dev);
 	return 0;
 }
 
@@ -3298,7 +3298,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	int unreg)
 {
 	struct se_session *se_sess = cmd->se_sess;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve, *dest_se_deve = NULL;
 	struct se_lun *se_lun = cmd->se_lun;
 	struct se_node_acl *pr_res_nacl, *pr_reg_nacl, *dest_node_acl = NULL;
@@ -3330,7 +3330,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 *
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate PR_REGISTERED"
@@ -3612,7 +3612,7 @@ after_iport_check:
 	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
 	if (!(dest_pr_reg)) {
-		ret = core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_alloc_registration(cmd->se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, 0, aptpl, 2, 1);
 		if (ret != 0) {
@@ -3683,12 +3683,12 @@ after_iport_check:
 	 */
 	if (!(aptpl)) {
 		pr_tmpl->pr_aptpl_active = 0;
-		core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
+		core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
 		printk("SPC-3 PR: Set APTPL Bit Deactivated for"
 				" REGISTER_AND_MOVE\n");
 	} else {
 		pr_tmpl->pr_aptpl_active = 1;
-		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&dest_pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -3827,7 +3827,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
  */
 static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
+	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
 	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
@@ -3882,7 +3882,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
+	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
 	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
@@ -3963,7 +3963,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
@@ -4014,7 +4014,7 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
+	struct se_device *se_dev = cmd->se_dev;
 	struct se_node_acl *se_nacl;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct se_portal_group *se_tpg;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4db4ac3..4215f5f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -336,7 +336,7 @@ rd_alloc_task(struct se_cmd *cmd)
 		printk(KERN_ERR "Unable to allocate struct rd_request\n");
 		return NULL;
 	}
-	rd_req->rd_dev = cmd->se_lun->lun_se_dev->dev_ptr;
+	rd_req->rd_dev = cmd->se_dev->dev_ptr;
 
 	return &rd_req->rd_task;
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4caab19..8a71ad8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -734,7 +734,7 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
@@ -745,7 +745,7 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 {
-	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
@@ -1083,7 +1083,7 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 
 static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_task *task, *task_prev = NULL;
 	unsigned long flags;
 
@@ -1681,7 +1681,7 @@ transport_generic_get_task(struct se_cmd *cmd,
 		enum dma_data_direction data_direction)
 {
 	struct se_task *task;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
 
 	task = dev->transport->alloc_task(cmd);
@@ -1753,7 +1753,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Check if SAM Task Attribute emulation is enabled for this
 	 * struct se_device storage object
 	 */
-	if (cmd->se_lun->lun_se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
 		return 0;
 
 	if (cmd->sam_task_attr == MSG_ACA_TAG) {
@@ -1765,7 +1765,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Used to determine when ORDERED commands should go from
 	 * Dormant to Active status.
 	 */
-	cmd->se_ordered_id = atomic_inc_return(&cmd->se_lun->lun_se_dev->dev_ordered_id);
+	cmd->se_ordered_id = atomic_inc_return(&cmd->se_dev->dev_ordered_id);
 	smp_mb__after_atomic_inc();
 	DEBUG_STA("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
@@ -2384,14 +2384,14 @@ static inline int transport_tcq_window_closed(struct se_device *dev)
  */
 static inline int transport_execute_task_attr(struct se_cmd *cmd)
 {
-	if (cmd->se_lun->lun_se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
 		return 1;
 	/*
 	 * Check for the existence of HEAD_OF_QUEUE, and if true return 1
 	 * to allow the passed struct se_cmd list of tasks to the front of the list.
 	 */
 	 if (cmd->sam_task_attr == MSG_HEAD_TAG) {
-		atomic_inc(&cmd->se_lun->lun_se_dev->dev_hoq_count);
+		atomic_inc(&cmd->se_dev->dev_hoq_count);
 		smp_mb__after_atomic_inc();
 		DEBUG_STA("Added HEAD_OF_QUEUE for CDB:"
 			" 0x%02x, se_ordered_id: %u\n",
@@ -2399,12 +2399,12 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 			cmd->se_ordered_id);
 		return 1;
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
-		spin_lock(&cmd->se_lun->lun_se_dev->ordered_cmd_lock);
+		spin_lock(&cmd->se_dev->ordered_cmd_lock);
 		list_add_tail(&cmd->se_ordered_list,
-				&cmd->se_lun->lun_se_dev->ordered_cmd_list);
-		spin_unlock(&cmd->se_lun->lun_se_dev->ordered_cmd_lock);
+				&cmd->se_dev->ordered_cmd_list);
+		spin_unlock(&cmd->se_dev->ordered_cmd_lock);
 
-		atomic_inc(&cmd->se_lun->lun_se_dev->dev_ordered_sync);
+		atomic_inc(&cmd->se_dev->dev_ordered_sync);
 		smp_mb__after_atomic_inc();
 
 		DEBUG_STA("Added ORDERED for CDB: 0x%02x to ordered"
@@ -2416,13 +2416,13 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		 * no other older commands exist that need to be
 		 * completed first.
 		 */
-		if (!(atomic_read(&cmd->se_lun->lun_se_dev->simple_cmds)))
+		if (!(atomic_read(&cmd->se_dev->simple_cmds)))
 			return 1;
 	} else {
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc(&cmd->se_lun->lun_se_dev->simple_cmds);
+		atomic_inc(&cmd->se_dev->simple_cmds);
 		smp_mb__after_atomic_inc();
 	}
 	/*
@@ -2430,16 +2430,16 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 	 * add the dormant task(s) built for the passed struct se_cmd to the
 	 * execution queue and become in Active state for this struct se_device.
 	 */
-	if (atomic_read(&cmd->se_lun->lun_se_dev->dev_ordered_sync) != 0) {
+	if (atomic_read(&cmd->se_dev->dev_ordered_sync) != 0) {
 		/*
 		 * Otherwise, add cmd w/ tasks to delayed cmd queue that
 		 * will be drained upon completion of HEAD_OF_QUEUE task.
 		 */
-		spin_lock(&cmd->se_lun->lun_se_dev->delayed_cmd_lock);
+		spin_lock(&cmd->se_dev->delayed_cmd_lock);
 		cmd->se_cmd_flags |= SCF_DELAYED_CMD_FROM_SAM_ATTR;
 		list_add_tail(&cmd->se_delayed_list,
-				&cmd->se_lun->lun_se_dev->delayed_cmd_list);
-		spin_unlock(&cmd->se_lun->lun_se_dev->delayed_cmd_lock);
+				&cmd->se_dev->delayed_cmd_list);
+		spin_unlock(&cmd->se_dev->delayed_cmd_lock);
 
 		DEBUG_STA("Added CDB: 0x%02x Task Attr: 0x%02x to"
 			" delayed CMD list, se_ordered_id: %u\n",
@@ -2498,7 +2498,7 @@ static int transport_execute_tasks(struct se_cmd *cmd)
 	 * storage object.
 	 */
 execute_tasks:
-	__transport_execute_tasks(cmd->se_lun->lun_se_dev);
+	__transport_execute_tasks(cmd->se_dev);
 	return 0;
 }
 
@@ -2631,7 +2631,7 @@ static inline u32 transport_get_sectors_6(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2659,7 +2659,7 @@ static inline u32 transport_get_sectors_10(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2689,7 +2689,7 @@ static inline u32 transport_get_sectors_12(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2719,7 +2719,7 @@ static inline u32 transport_get_sectors_16(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2761,7 +2761,7 @@ static inline u32 transport_get_size(
 	unsigned char *cdb,
 	struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE) {
 		if (cdb[1] & 1) { /* sectors */
@@ -2968,7 +2968,7 @@ static int transport_generic_cmd_sequencer(
 	struct se_cmd *cmd,
 	unsigned char *cdb)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0, passthrough;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
@@ -3292,7 +3292,7 @@ static int transport_generic_cmd_sequencer(
 		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
 		 * See spc4r17 section 5.3
 		 */
-		if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+		if (cmd->se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
@@ -3500,7 +3500,7 @@ static int transport_generic_cmd_sequencer(
 		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
 		 * See spc4r17 section 5.3
 		 */
-		if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+		if (cmd->se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
@@ -3655,7 +3655,7 @@ static void transport_memcpy_se_mem_read_contig(
  */
 static void transport_complete_task_attr(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_cmd *cmd_p, *cmd_tmp;
 	int new_active_tasks = 0;
 
@@ -3726,7 +3726,7 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 	 * delayed execution list after a HEAD_OF_QUEUE or ORDERED Task
 	 * Attribute.
 	 */
-	if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 		transport_complete_task_attr(cmd);
 	/*
 	 * Check if we need to retrieve a sense buffer from
@@ -4102,7 +4102,7 @@ static inline long long transport_dev_end_lba(struct se_device *dev)
 
 static int transport_get_sectors(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 
 	cmd->t_task.t_tasks_sectors =
 		(cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
@@ -4128,7 +4128,7 @@ static int transport_get_sectors(struct se_cmd *cmd)
 
 static int transport_new_cmd_obj(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	u32 task_cdbs = 0, rc;
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
@@ -4280,7 +4280,7 @@ int transport_init_task_sg(
 	u32 task_offset)
 {
 	struct se_cmd *se_cmd = task->task_se_cmd;
-	struct se_device *se_dev = se_cmd->se_lun->lun_se_dev;
+	struct se_device *se_dev = se_cmd->se_dev;
 	struct se_mem *se_mem = in_se_mem;
 	struct target_core_fabric_ops *tfo = se_cmd->se_tfo;
 	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
@@ -4781,7 +4781,7 @@ static u32 transport_generic_get_cdb_count(
 	struct se_task *task;
 	struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 	struct se_mem *se_mem_bidi = NULL, *se_mem_bidi_lout = NULL;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	int max_sectors_set = 0, ret;
 	u32 task_offset_in = 0, se_mem_cnt = 0, se_mem_bidi_cnt = 0, task_cdbs = 0;
 
@@ -4894,7 +4894,7 @@ out:
 static int
 transport_map_control_cmd_to_task(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb;
 	struct se_task *task;
 	int ret;
@@ -4959,7 +4959,7 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 {
 	struct se_portal_group *se_tpg;
 	struct se_task *task;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	int ret = 0;
 
 	/*
@@ -5221,7 +5221,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	atomic_set(&cmd->t_task.transport_lun_fe_stop, 1);
 	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
 
-	wake_up_interruptible(&cmd->se_lun->lun_se_dev->dev_queue_obj.thread_wq);
+	wake_up_interruptible(&cmd->se_dev->dev_queue_obj.thread_wq);
 
 	ret = transport_stop_tasks_for_cmd(cmd);
 
@@ -5234,7 +5234,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
 				cmd->se_tfo->get_task_tag(cmd));
 	}
-	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 
 	return 0;
 }
@@ -5440,7 +5440,7 @@ static void transport_generic_wait_for_tasks(
 
 	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
 
-	wake_up_interruptible(&cmd->se_lun->lun_se_dev->dev_queue_obj.thread_wq);
+	wake_up_interruptible(&cmd->se_dev->dev_queue_obj.thread_wq);
 
 	wait_for_completion(&cmd->t_task.t_transport_stop_comp);
 
@@ -5707,7 +5707,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 int transport_generic_do_tmr(struct se_cmd *cmd)
 {
 	struct se_cmd *ref_cmd;
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;
 
@@ -5852,7 +5852,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 					cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
 					0);
 				transport_remove_cmd_from_queue(cmd,
-					&cmd->se_lun->lun_se_dev->dev_queue_obj);
+					&cmd->se_dev->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 				transport_cmd_check_stop(cmd, 1, 0);
@@ -5861,7 +5861,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 					&cmd->t_task.t_state_lock, flags);
 
 				transport_remove_cmd_from_queue(cmd,
-					&cmd->se_lun->lun_se_dev->dev_queue_obj);
+					&cmd->se_dev->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 
@@ -5881,7 +5881,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 			transport_remove_cmd_from_queue(cmd,
-				&cmd->se_lun->lun_se_dev->dev_queue_obj);
+				&cmd->se_dev->dev_queue_obj);
 
 			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop(cmd, 1, 0);
@@ -5890,7 +5890,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				&cmd->t_task.t_state_lock, flags);
 
 			transport_remove_cmd_from_queue(cmd,
-				&cmd->se_lun->lun_se_dev->dev_queue_obj);
+				&cmd->se_dev->dev_queue_obj);
 			transport_lun_remove_cmd(cmd);
 
 			if (transport_cmd_check_stop(cmd, 1, 0))
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 33a96e3..3b8b02c 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -208,7 +208,7 @@ void core_scsi3_ua_for_check_condition(
 	u8 *asc,
 	u8 *ascq)
 {
-	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
 	struct se_node_acl *nacl;
-- 
1.7.6

