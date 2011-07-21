From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 007/103] target: use errno values instead of returning -1 for everything
Date: Thu, 21 Jul 2011 00:04:43 -0700
Message-ID: <1311231979-6631-8-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:25716 "HELO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834Ab1GUHFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:25 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

Return errno values instead of -1. If checking the errno of a function,
return what that function returned instead of -1, as well.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    4 +-
 drivers/target/target_core_alua.c      |   24 ++++----
 drivers/target/target_core_cdb.c       |   12 ++--
 drivers/target/target_core_configfs.c  |   12 ++--
 drivers/target/target_core_device.c    |   98 ++++++++++++++++----------------
 drivers/target/target_core_file.c      |   14 ++--
 drivers/target/target_core_iblock.c    |    2 +-
 drivers/target/target_core_pr.c        |   36 ++++++------
 drivers/target/target_core_pscsi.c     |    8 +-
 drivers/target/target_core_rd.c        |   24 ++++----
 drivers/target/target_core_tpg.c       |   11 ++-
 drivers/target/target_core_transport.c |   51 +++++++++--------
 drivers/target/target_core_ua.c        |   16 +++---
 drivers/target/tcm_fc/tfc_conf.c       |    4 +-
 14 files changed, 161 insertions(+), 155 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2d0f22a..3274fec 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1402,9 +1402,9 @@ static int tcm_loop_register_configfs(void)
 	 * Register the top level struct config_item_type with TCM core
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "loopback");
-	if (!fabric) {
+	if (IS_ERR(fabric)) {
 		printk(KERN_ERR "tcm_loop_register_configfs() failed!\n");
-		return -1;
+		return PTR_ERR(fabric);
 	}
 	/*
 	 * Setup the fabric API of function pointers used by target_core_mod
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 47abb42..a993f3c 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -522,7 +522,7 @@ static int core_alua_state_check(
 	default:
 		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n",
 				out_alua_state);
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -553,7 +553,7 @@ static int core_alua_check_transition(int state, int *primary)
 		break;
 	default:
 		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n", state);
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -977,7 +977,7 @@ static int core_alua_set_tg_pt_secondary_state(
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		printk(KERN_ERR "Unable to complete secondary state"
 				" transition\n");
-		return -1;
+		return -EINVAL;
 	}
 	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
 	/*
@@ -1015,7 +1015,7 @@ static int core_alua_set_tg_pt_secondary_state(
 		if (!(md_buf)) {
 			printk(KERN_ERR "Unable to allocate md_buf for"
 				" secondary ALUA access metadata\n");
-			return -1;
+			return -ENOMEM;
 		}
 		mutex_lock(&port->sep_tg_pt_md_mutex);
 		core_alua_update_tpg_secondary_metadata(tg_pt_gp_mem, port,
@@ -1062,7 +1062,7 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 	if (lu_gp->lu_gp_valid_id) {
 		printk(KERN_WARNING "ALUA LU Group already has a valid ID,"
 			" ignoring request\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	spin_lock(&se_global->lu_gps_lock);
@@ -1071,7 +1071,7 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 				" 0x0000ffff reached\n");
 		spin_unlock(&se_global->lu_gps_lock);
 		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
-		return -1;
+		return -ENOSPC;
 	}
 again:
 	lu_gp_id_tmp = (lu_gp_id != 0) ? lu_gp_id :
@@ -1086,7 +1086,7 @@ again:
 				" already exists, ignoring request\n",
 				lu_gp_id);
 			spin_unlock(&se_global->lu_gps_lock);
-			return -1;
+			return -EINVAL;
 		}
 	}
 
@@ -1330,7 +1330,7 @@ int core_alua_set_tg_pt_gp_id(
 	if (tg_pt_gp->tg_pt_gp_valid_id) {
 		printk(KERN_WARNING "ALUA TG PT Group already has a valid ID,"
 			" ignoring request\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
@@ -1339,7 +1339,7 @@ int core_alua_set_tg_pt_gp_id(
 			" 0x0000ffff reached\n");
 		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
-		return -1;
+		return -ENOSPC;
 	}
 again:
 	tg_pt_gp_id_tmp = (tg_pt_gp_id != 0) ? tg_pt_gp_id :
@@ -1354,7 +1354,7 @@ again:
 			printk(KERN_ERR "ALUA Target Port Group ID: %hu already"
 				" exists, ignoring request\n", tg_pt_gp_id);
 			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
-			return -1;
+			return -EINVAL;
 		}
 	}
 
@@ -1967,8 +1967,8 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 		 * LUN Group.
 		 */
 		lu_gp_mem = core_alua_allocate_lu_gp_mem(dev);
-		if (IS_ERR(lu_gp_mem) || !lu_gp_mem)
-			return -1;
+		if (IS_ERR(lu_gp_mem))
+			return PTR_ERR(lu_gp_mem);
 
 		alua->alua_type = SPC3_ALUA_EMULATED;
 		alua->alua_state_check = &core_alua_state_check;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 7f19c8b..b39ffad 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -75,7 +75,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 	if (cmd->data_length < 6) {
 		printk(KERN_ERR "SCSI Inquiry payload length: %u"
 			" too small for EVPD=0\n", cmd->data_length);
-		return -1;
+		return -EINVAL;
 	}
 
 	buf[0] = dev->transport->get_device_type(dev);
@@ -501,7 +501,7 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		printk(KERN_INFO "Received data_length: %u"
 			" too small for EVPD 0xb0\n",
 			cmd->data_length);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (have_tp && cmd->data_length < (0x3c + 4)) {
@@ -637,7 +637,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 	if (cmd->data_length < 4) {
 		printk(KERN_ERR "SCSI Inquiry payload length: %u"
 			" too small for EVPD=1\n", cmd->data_length);
-		return -1;
+		return -EINVAL;
 	}
 	buf[0] = dev->transport->get_device_type(dev);
 
@@ -656,7 +656,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 		return target_emulate_evpd_b2(cmd, buf);
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -991,7 +991,7 @@ target_emulate_unmap(struct se_task *task)
 		if (ret < 0) {
 			printk(KERN_ERR "blkdev_issue_discard() failed: %d\n",
 					ret);
-			return -1;
+			return ret;
 		}
 
 		ptr += 16;
@@ -1024,7 +1024,7 @@ target_emulate_write_same(struct se_task *task)
 	ret = dev->transport->do_discard(dev, lba, range);
 	if (ret < 0) {
 		printk(KERN_INFO "blkdev_issue_discard() failed for WRITE_SAME\n");
-		return -1;
+		return ret;
 	}
 
 	task->task_scsi_status = GOOD;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c614000..d140258 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -298,21 +298,21 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 
 	if (!(fabric_mod)) {
 		printk(KERN_ERR "Missing struct module *fabric_mod pointer\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	if (!(name)) {
 		printk(KERN_ERR "Unable to locate passed fabric name\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	if (strlen(name) >= TARGET_FABRIC_NAME_SIZE) {
 		printk(KERN_ERR "Passed name: %s exceeds TARGET_FABRIC"
 			"_NAME_SIZE\n", name);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	tf = kzalloc(sizeof(struct target_fabric_configfs), GFP_KERNEL);
 	if (!(tf))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&tf->tf_list);
 	atomic_set(&tf->tf_access_cnt, 0);
@@ -3133,7 +3133,7 @@ static int __init target_core_init_configfs(void)
 	init_scsi_index_table();
 	ret = init_se_global();
 	if (ret < 0)
-		return -1;
+		return ret;
 	/*
 	 * Create $CONFIGFS/target/core default group for HBA <-> Storage Object
 	 * and ALUA Logical Unit Group and Target Port Group infrastructure.
@@ -3241,7 +3241,7 @@ out_global:
 		kfree(hba_cg->default_groups);
 	kfree(target_cg->default_groups);
 	release_se_global();
-	return -1;
+	return ret;
 }
 
 static void __exit target_core_exit_configfs(void)
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b0ebe9a..818c65b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -67,7 +67,7 @@ int transport_get_lun_for_cmd(
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		return -1;
+		return -ENODEV;
 	}
 
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
@@ -109,7 +109,7 @@ out:
 				" Access for 0x%08x\n",
 				CMD_TFO(se_cmd)->get_fabric_name(),
 				unpacked_lun);
-			return -1;
+			return -EACCES;
 		} else {
 			/*
 			 * Use the se_portal_group->tpg_virt_lun0 to allow for
@@ -123,7 +123,7 @@ out:
 					" Access for 0x%08x\n",
 					CMD_TFO(se_cmd)->get_fabric_name(),
 					unpacked_lun);
-				return -1;
+				return -ENODEV;
 			}
 			/*
 			 * Force WRITE PROTECT for virtual LUN 0
@@ -132,7 +132,7 @@ out:
 			    (se_cmd->data_direction != DMA_NONE)) {
 				se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
 				se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-				return -1;
+				return -EACCES;
 			}
 #if 0
 			printk("TARGET_CORE[%s]: Using virtual LUN0! :-)\n",
@@ -151,7 +151,7 @@ out:
 	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		return -1;
+		return -ENODEV;
 	}
 
 	{
@@ -195,7 +195,7 @@ int transport_get_lun_for_tmr(
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		return -1;
+		return -ENODEV;
 	}
 
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
@@ -217,7 +217,7 @@ int transport_get_lun_for_tmr(
 			CMD_TFO(se_cmd)->get_fabric_name(),
 			unpacked_lun);
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		return -1;
+		return -ENODEV;
 	}
 	/*
 	 * Determine if the struct se_lun is online.
@@ -225,7 +225,7 @@ int transport_get_lun_for_tmr(
 /* #warning FIXME: Check for LUN_RESET + UNIT Attention */
 	if (se_dev_check_online(se_lun->lun_se_dev) != 0) {
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		return -1;
+		return -ENODEV;
 	}
 	se_tmr->tmr_dev = dev;
 
@@ -408,14 +408,14 @@ int core_update_device_list_for_node(
 					" already set for demo mode -> explict"
 					" LUN ACL transition\n");
 				spin_unlock_irq(&nacl->device_list_lock);
-				return -1;
+				return -EINVAL;
 			}
 			if (deve->se_lun != lun) {
 				printk(KERN_ERR "struct se_dev_entry->se_lun does"
 					" match passed struct se_lun for demo mode"
 					" -> explict LUN ACL transition\n");
 				spin_unlock_irq(&nacl->device_list_lock);
-				return -1;
+				return -EINVAL;
 			}
 			deve->se_lun_acl = lun_acl;
 			trans = 1;
@@ -514,7 +514,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 	port = kzalloc(sizeof(struct se_port), GFP_KERNEL);
 	if (!(port)) {
 		printk(KERN_ERR "Unable to allocate struct se_port\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&port->sep_alua_list);
 	INIT_LIST_HEAD(&port->sep_list);
@@ -527,7 +527,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 		printk(KERN_WARNING "Reached dev->dev_port_count =="
 				" 0x0000ffff\n");
 		spin_unlock(&dev->se_port_lock);
-		return NULL;
+		return ERR_PTR(-ENOSPC);
 	}
 again:
 	/*
@@ -630,8 +630,8 @@ int core_dev_export(
 	struct se_port *port;
 
 	port = core_alloc_port(dev);
-	if (!(port))
-		return -1;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	lun->lun_se_dev = dev;
 	se_dev_start(dev);
@@ -909,7 +909,7 @@ int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
 	if (task_timeout > DA_TASK_TIMEOUT_MAX) {
 		printk(KERN_ERR "dev[%p]: Passed task_timeout: %u larger then"
 			" DA_TASK_TIMEOUT_MAX\n", dev, task_timeout);
-		return -1;
+		return -EINVAL;
 	} else {
 		DEV_ATTRIB(dev)->task_timeout = task_timeout;
 		printk(KERN_INFO "dev[%p]: Set SE Device task_timeout: %u\n",
@@ -963,15 +963,15 @@ int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->dpo_emulated == NULL) {
 		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->dpo_emulated(dev) == 0) {
 		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated not supported\n");
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_dpo = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Page Out (DPO) Emulation"
@@ -983,15 +983,15 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->fua_write_emulated == NULL) {
 		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->fua_write_emulated(dev) == 0) {
 		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated not supported\n");
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_fua_write = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
@@ -1003,15 +1003,15 @@ int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->fua_read_emulated == NULL) {
 		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->fua_read_emulated(dev) == 0) {
 		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated not supported\n");
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_fua_read = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access READs: %d\n",
@@ -1023,15 +1023,15 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->write_cache_emulated == NULL) {
 		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->write_cache_emulated(dev) == 0) {
 		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated not supported\n");
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_write_cache = flag;
 	printk(KERN_INFO "dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
@@ -1043,7 +1043,7 @@ int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1) && (flag != 2)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
@@ -1051,7 +1051,7 @@ int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 			" UA_INTRLCK_CTRL while dev_export_obj: %d count"
 			" exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = flag;
 	printk(KERN_INFO "dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
@@ -1064,14 +1064,14 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
 		printk(KERN_ERR "dev[%p]: Unable to change SE Device TAS while"
 			" dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->emulate_tas = flag;
 	printk(KERN_INFO "dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
@@ -1084,7 +1084,7 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	/*
 	 * We expect this value to be non-zero when generic Block Layer
@@ -1105,7 +1105,7 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	/*
 	 * We expect this value to be non-zero when generic Block Layer
@@ -1126,7 +1126,7 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return -1;
+		return -EINVAL;
 	}
 	DEV_ATTRIB(dev)->enforce_pr_isids = flag;
 	printk(KERN_INFO "dev[%p]: SE Device enforce_pr_isids bit: %s\n", dev,
@@ -1145,12 +1145,12 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 		printk(KERN_ERR "dev[%p]: Unable to change SE Device TCQ while"
 			" dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
-		return -1;
+		return -EINVAL;
 	}
 	if (!(queue_depth)) {
 		printk(KERN_ERR "dev[%p]: Illegal ZERO value for queue"
 			"_depth\n", dev);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
@@ -1159,7 +1159,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 				" exceeds TCM/SE_Device TCQ: %u\n",
 				dev, queue_depth,
 				DEV_ATTRIB(dev)->hw_queue_depth);
-			return -1;
+			return -EINVAL;
 		}
 	} else {
 		if (queue_depth > DEV_ATTRIB(dev)->queue_depth) {
@@ -1168,7 +1168,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 					" %u exceeds TCM/SE_Device MAX"
 					" TCQ: %u\n", dev, queue_depth,
 					DEV_ATTRIB(dev)->hw_queue_depth);
-				return -1;
+				return -EINVAL;
 			}
 		}
 	}
@@ -1192,18 +1192,18 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
 			" max_sectors while dev_export_obj: %d count exists\n",
 			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
-		return -1;
+		return -EINVAL;
 	}
 	if (!(max_sectors)) {
 		printk(KERN_ERR "dev[%p]: Illegal ZERO value for"
 			" max_sectors\n", dev);
-		return -1;
+		return -EINVAL;
 	}
 	if (max_sectors < DA_STATUS_MAX_SECTORS_MIN) {
 		printk(KERN_ERR "dev[%p]: Passed max_sectors: %u less than"
 			" DA_STATUS_MAX_SECTORS_MIN: %u\n", dev, max_sectors,
 				DA_STATUS_MAX_SECTORS_MIN);
-		return -1;
+		return -EINVAL;
 	}
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (max_sectors > DEV_ATTRIB(dev)->hw_max_sectors) {
@@ -1211,7 +1211,7 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 				" greater than TCM/SE_Device max_sectors:"
 				" %u\n", dev, max_sectors,
 				DEV_ATTRIB(dev)->hw_max_sectors);
-			 return -1;
+			 return -EINVAL;
 		}
 	} else {
 		if (!(force) && (max_sectors >
@@ -1220,14 +1220,14 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 				" greater than TCM/SE_Device max_sectors"
 				": %u, use force=1 to override.\n", dev,
 				max_sectors, DEV_ATTRIB(dev)->hw_max_sectors);
-			return -1;
+			return -EINVAL;
 		}
 		if (max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
 			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
 				" greater than DA_STATUS_MAX_SECTORS_MAX:"
 				" %u\n", dev, max_sectors,
 				DA_STATUS_MAX_SECTORS_MAX);
-			return -1;
+			return -EINVAL;
 		}
 	}
 
@@ -1269,7 +1269,7 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 		printk(KERN_ERR "dev[%p]: Unable to change SE Device block_size"
 			" while dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
-		return -1;
+		return -EINVAL;
 	}
 
 	if ((block_size != 512) &&
@@ -1279,14 +1279,14 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 		printk(KERN_ERR "dev[%p]: Illegal value for block_device: %u"
 			" for SE device, must be 512, 1024, 2048 or 4096\n",
 			dev, block_size);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		printk(KERN_ERR "dev[%p]: Not allowed to change block_size for"
 			" Physical Device, use for Linux/SCSI to change"
 			" block_size for underlying hardware\n", dev);
-		return -1;
+		return -EINVAL;
 	}
 
 	DEV_ATTRIB(dev)->block_size = block_size;
@@ -1620,8 +1620,8 @@ int core_dev_setup_virtual_lun0(void)
 	t->set_configfs_dev_params(hba, se_dev, buf, sizeof(buf));
 
 	dev = t->create_virtdevice(hba, se_dev, se_dev->se_dev_su_ptr);
-	if (!(dev) || IS_ERR(dev)) {
-		ret = -ENOMEM;
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
 		goto out;
 	}
 	se_dev->se_dev_ptr = dev;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 150c430..40386ec 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -67,7 +67,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 	fd_host = kzalloc(sizeof(struct fd_host), GFP_KERNEL);
 	if (!(fd_host)) {
 		printk(KERN_ERR "Unable to allocate memory for struct fd_host\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	fd_host->fd_host_id = host_id;
@@ -300,7 +300,7 @@ static int fd_do_readv(struct se_task *task)
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < task->task_sg_num; i++) {
@@ -324,13 +324,13 @@ static int fd_do_readv(struct se_task *task)
 			printk(KERN_ERR "vfs_readv() returned %d,"
 				" expecting %d for S_ISBLK\n", ret,
 				(int)task->task_size);
-			return -1;
+			return (ret < 0 ? ret : -EINVAL);
 		}
 	} else {
 		if (ret < 0) {
 			printk(KERN_ERR "vfs_readv() returned %d for non"
 				" S_ISBLK\n", ret);
-			return -1;
+			return ret;
 		}
 	}
 
@@ -350,7 +350,7 @@ static int fd_do_writev(struct se_task *task)
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < task->task_sg_num; i++) {
@@ -367,7 +367,7 @@ static int fd_do_writev(struct se_task *task)
 
 	if (ret < 0 || ret != task->task_size) {
 		printk(KERN_ERR "vfs_writev() returned %d\n", ret);
-		return -1;
+		return (ret < 0 ? ret : -EINVAL);
 	}
 
 	return 1;
@@ -599,7 +599,7 @@ static ssize_t fd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 
 	if (!(fd_dev->fbd_flags & FBDF_HAS_PATH)) {
 		printk(KERN_ERR "Missing fd_dev_name=\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8663900..5d5bd6e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -527,7 +527,7 @@ static ssize_t iblock_check_configfs_dev_params(
 
 	if (!(ibd->ibd_flags & IBDF_HAS_UDEV_PATH)) {
 		printk(KERN_ERR "Missing udev_path= parameters for IBLOCK\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index b662db3..99b97db 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -105,13 +105,13 @@ static int core_scsi2_reservation_check(struct se_cmd *cmd, u32 *pr_reg_type)
 	}
 	if (dev->dev_reserved_node_acl != sess->se_node_acl) {
 		spin_unlock(&dev->dev_reservation_lock);
-		return -1;
+		return -EINVAL;
 	}
 	if (!(dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID)) {
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
-	ret = (dev->dev_res_bin_isid == sess->sess_bin_isid) ? 0 : -1;
+	ret = (dev->dev_res_bin_isid == sess->sess_bin_isid) ? 0 : -EINVAL;
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return ret;
@@ -362,7 +362,7 @@ static int core_scsi3_pr_seq_non_holder(
 			registered_nexus = 1;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 	/*
 	 * Referenced from spc4r17 table 45 for *NON* PR holder access
@@ -414,7 +414,7 @@ static int core_scsi3_pr_seq_non_holder(
 		default:
 			printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
 				" action: 0x%02x\n", cdb[1] & 0x1f);
-			return -1;
+			return -EINVAL;
 		}
 		break;
 	case RELEASE:
@@ -461,7 +461,7 @@ static int core_scsi3_pr_seq_non_holder(
 		default:
 			printk(KERN_ERR "Unknown MI Service Action: 0x%02x\n",
 				(cdb[1] & 0x1f));
-			return -1;
+			return -EINVAL;
 		}
 		break;
 	case ACCESS_CONTROL_IN:
@@ -592,14 +592,14 @@ static int core_scsi3_pr_reservation_check(
 	cmd->pr_res_key = dev->dev_pr_res_holder->pr_res_key;
 	if (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) {
 		spin_unlock(&dev->dev_reservation_lock);
-		return -1;
+		return -EINVAL;
 	}
 	if (!(dev->dev_pr_res_holder->isid_present_at_reg)) {
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
 	ret = (dev->dev_pr_res_holder->pr_reg_bin_isid ==
-	       sess->sess_bin_isid) ? 0 : -1;
+	       sess->sess_bin_isid) ? 0 : -EINVAL;
 	/*
 	 * Use bit in *pr_reg_type to notify ISID mismatch in
 	 * core_scsi3_pr_seq_non_holder().
@@ -819,13 +819,13 @@ int core_scsi3_alloc_aptpl_registration(
 
 	if (!(i_port) || !(t_port) || !(sa_res_key)) {
 		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "Unable to allocate struct t10_pr_registration\n");
-		return -1;
+		return -ENOMEM;
 	}
 	pr_reg->pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len, GFP_KERNEL);
 
@@ -1107,7 +1107,7 @@ static int core_scsi3_alloc_registration(
 	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve, isid,
 			sa_res_key, all_tg_pt, aptpl);
 	if (!(pr_reg))
-		return -1;
+		return -EPERM;
 
 	__core_scsi3_add_registration(dev, nacl, pr_reg,
 			register_type, register_move);
@@ -1240,7 +1240,7 @@ static int core_scsi3_check_implict_release(
 			" UNREGISTER while existing reservation with matching"
 			" key 0x%016Lx is present from another SCSI Initiator"
 			" Port\n", pr_reg->pr_res_key);
-		ret = -1;
+		ret = -EPERM;
 	}
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -1920,7 +1920,7 @@ static int __core_scsi3_update_aptpl_buf(
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&T10_RES(su_dev)->registration_lock);
-			return -1;
+			return -EMSGSIZE;
 		}
 		len += sprintf(buf+len, "%s", tmp);
 
@@ -1938,7 +1938,7 @@ static int __core_scsi3_update_aptpl_buf(
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&T10_RES(su_dev)->registration_lock);
-			return -1;
+			return -EMSGSIZE;
 		}
 		len += sprintf(buf+len, "%s", tmp);
 		reg_count++;
@@ -1989,7 +1989,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	if (strlen(&wwn->unit_serial[0]) >= 512) {
 		printk(KERN_ERR "WWN value for struct se_device does not fit"
 			" into path buffer\n");
-		return -1;
+		return -EMSGSIZE;
 	}
 
 	snprintf(path, 512, "/var/target/pr/aptpl_%s", &wwn->unit_serial[0]);
@@ -1997,7 +1997,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	if (IS_ERR(file) || !file || !file->f_dentry) {
 		printk(KERN_ERR "filp_open(%s) for APTPL metadata"
 			" failed\n", path);
-		return -1;
+		return (PTR_ERR(file) < 0 ? PTR_ERR(file) : -ENOENT);
 	}
 
 	iov[0].iov_base = &buf[0];
@@ -2014,7 +2014,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	if (ret < 0) {
 		printk("Error writing APTPL metadata file: %s\n", path);
 		filp_close(file, NULL);
-		return -1;
+		return -EIO;
 	}
 	filp_close(file, NULL);
 
@@ -2049,14 +2049,14 @@ static int core_scsi3_update_and_write_aptpl(
 	ret = core_scsi3_update_aptpl_buf(dev, buf, pr_aptpl_buf_len,
 				clear_aptpl_metadata);
 	if (ret != 0)
-		return -1;
+		return ret;
 	/*
 	 * __core_scsi3_write_aptpl_to_file() will call strlen()
 	 * on the passed buf to determine pr_aptpl_buf_len.
 	 */
 	ret = __core_scsi3_write_aptpl_to_file(dev, buf, 0);
 	if (ret != 0)
-		return -1;
+		return ret;
 
 	return ret;
 }
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 331d423..fb2e8cb 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -86,7 +86,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 	phv = kzalloc(sizeof(struct pscsi_hba_virt), GFP_KERNEL);
 	if (!(phv)) {
 		printk(KERN_ERR "Unable to allocate struct pscsi_hba_virt\n");
-		return -1;
+		return -ENOMEM;
 	}
 	phv->phv_host_id = host_id;
 	phv->phv_mode = PHV_VIRUTAL_HOST_ID;
@@ -236,7 +236,7 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 
 	buf = kzalloc(INQUIRY_VPD_SERIAL_LEN, GFP_KERNEL);
 	if (!buf)
-		return -1;
+		return -ENOMEM;
 
 	memset(cdb, 0, MAX_COMMAND_SIZE);
 	cdb[0] = INQUIRY;
@@ -259,7 +259,7 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 
 out_free:
 	kfree(buf);
-	return -1;
+	return -EPERM;
 }
 
 static void
@@ -1030,7 +1030,7 @@ static ssize_t pscsi_check_configfs_dev_params(
 	    !(pdv->pdv_flags & PDF_HAS_LUN_ID)) {
 		printk(KERN_ERR "Missing scsi_channel_id=, scsi_target_id= and"
 			" scsi_lun_id= parameters\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 7837dd3..793a94b 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -383,7 +383,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 
 	table = rd_get_sg_table(dev, req->rd_page);
 	if (!(table))
-		return -1;
+		return -EINVAL;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_d = task->task_sg;
@@ -481,7 +481,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 #endif
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
-			return -1;
+			return -EINVAL;
 
 		sg_s = &table->sg_table[j = 0];
 	}
@@ -506,7 +506,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 
 	table = rd_get_sg_table(dev, req->rd_page);
 	if (!(table))
-		return -1;
+		return -EINVAL;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_d = &table->sg_table[req->rd_page - table->page_start_offset];
@@ -604,7 +604,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 #endif
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
-			return -1;
+			return -EINVAL;
 
 		sg_d = &table->sg_table[j = 0];
 	}
@@ -664,7 +664,7 @@ static int rd_DIRECT_with_offset(
 
 	table = rd_get_sg_table(dev, req->rd_page);
 	if (!(table))
-		return -1;
+		return -EINVAL;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
@@ -678,7 +678,7 @@ static int rd_DIRECT_with_offset(
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -1;
+			return -ENOMEM;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
 
@@ -734,7 +734,7 @@ check_eot:
 #endif
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
-			return -1;
+			return -EINVAL;
 
 		sg_s = &table->sg_table[j = 0];
 	}
@@ -767,7 +767,7 @@ static int rd_DIRECT_without_offset(
 
 	table = rd_get_sg_table(dev, req->rd_page);
 	if (!(table))
-		return -1;
+		return -EINVAL;
 
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
 #ifdef DEBUG_RAMDISK_DR
@@ -780,7 +780,7 @@ static int rd_DIRECT_without_offset(
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -1;
+			return -ENOMEM;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
 
@@ -816,7 +816,7 @@ static int rd_DIRECT_without_offset(
 #endif
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
-			return -1;
+			return -EINVAL;
 
 		sg_s = &table->sg_table[j = 0];
 	}
@@ -876,7 +876,7 @@ static int rd_DIRECT_do_se_mem_map(
 	if (cmd->data_direction == DMA_TO_DEVICE) {
 		printk(KERN_ERR "DMA_TO_DEVICE not supported for"
 				" RAMDISK_DR with task_sg_chaining=1\n");
-		return -1;
+		return -ENOSYS;
 	}
 	/*
 	 * Special case for if task_sg_chaining is enabled, then
@@ -975,7 +975,7 @@ static ssize_t rd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 
 	if (!(rd_dev->rd_flags & RDF_HAS_PAGE_COUNT)) {
 		printk(KERN_INFO "Missing rd_pages= parameter\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5ec745f..dc024c1 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -233,7 +233,7 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 	if (!(nacl->device_list)) {
 		printk(KERN_ERR "Unable to allocate memory for"
 			" struct se_node_acl->device_list\n");
-		return -1;
+		return -ENOMEM;
 	}
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = &nacl->device_list[i];
@@ -614,7 +614,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 
 	ret = core_tpg_post_addlun(se_tpg, lun, lun_access, dev);
 	if (ret < 0)
-		return -1;
+		return ret;
 
 	return 0;
 }
@@ -772,8 +772,11 @@ int core_tpg_post_addlun(
 	u32 lun_access,
 	void *lun_ptr)
 {
-	if (core_dev_export(lun_ptr, tpg, lun) < 0)
-		return -1;
+	int ret;
+
+	ret = core_dev_export(lun_ptr, tpg, lun);
+	if (ret < 0)
+		return ret;
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_access = lun_access;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1882251..66c4093 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -234,7 +234,7 @@ int init_se_global(void)
 	global = kzalloc(sizeof(struct se_global), GFP_KERNEL);
 	if (!(global)) {
 		printk(KERN_ERR "Unable to allocate memory for struct se_global\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	INIT_LIST_HEAD(&global->g_lu_gps_list);
@@ -350,7 +350,7 @@ out:
 	if (t10_alua_tg_pt_gp_mem_cache)
 		kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 	kfree(global);
-	return -1;
+	return -ENOMEM;
 }
 
 void release_se_global(void)
@@ -444,13 +444,16 @@ static int transport_subsystem_reqmods(void)
 
 int transport_subsystem_check_init(void)
 {
+	int ret;
+
 	if (se_global->g_sub_api_initialized)
 		return 0;
 	/*
 	 * Request the loading of known TCM subsystem plugins..
 	 */
-	if (transport_subsystem_reqmods() < 0)
-		return -1;
+	ret = transport_subsystem_reqmods();
+	if (ret < 0)
+		return ret;
 
 	se_global->g_sub_api_initialized = 1;
 	return 0;
@@ -810,7 +813,7 @@ static int transport_add_cmd_to_queue(
 	if (!(qr)) {
 		printk(KERN_ERR "Unable to allocate memory for"
 				" struct se_queue_req\n");
-		return -1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
 
@@ -1404,7 +1407,7 @@ int transport_dump_vpd_assoc(
 		break;
 	default:
 		sprintf(buf+len, "Unknown 0x%02x\n", vpd->association);
-		ret = -1;
+		ret = -EINVAL;
 		break;
 	}
 
@@ -1461,7 +1464,7 @@ int transport_dump_vpd_ident_type(
 	default:
 		sprintf(buf+len, "Unsupported: 0x%02x\n",
 				vpd->device_identifier_type);
-		ret = -1;
+		ret = -EINVAL;
 		break;
 	}
 
@@ -1511,7 +1514,7 @@ int transport_dump_vpd_ident(
 	default:
 		sprintf(buf, "T10 VPD Device Identifier encoding unsupported:"
 			" 0x%02x", vpd->device_identifier_code_set);
-		ret = -1;
+		ret = -EINVAL;
 		break;
 	}
 
@@ -1876,7 +1879,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	if (cmd->sam_task_attr == MSG_ACA_TAG) {
 		DEBUG_STA("SAM Task Attribute ACA"
 			" emulation is not supported\n");
-		return -1;
+		return -EINVAL;
 	}
 	/*
 	 * Used to determine when ORDERED commands should go from
@@ -1931,7 +1934,7 @@ int transport_generic_allocate_tasks(
 		printk(KERN_ERR "Received SCSI CDB with command_size: %d that"
 			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
-		return -1;
+		return -EINVAL;
 	}
 	/*
 	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
@@ -1946,7 +1949,7 @@ int transport_generic_allocate_tasks(
 				" %u > sizeof(T_TASK(cmd)->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
 				(unsigned long)sizeof(T_TASK(cmd)->__t_task_cdb));
-			return -1;
+			return -ENOMEM;
 		}
 	} else
 		T_TASK(cmd)->t_task_cdb = &T_TASK(cmd)->__t_task_cdb[0];
@@ -1989,7 +1992,7 @@ int transport_generic_handle_cdb(
 	if (!SE_LUN(cmd)) {
 		dump_stack();
 		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
@@ -2008,7 +2011,7 @@ int transport_generic_handle_cdb_map(
 	if (!SE_LUN(cmd)) {
 		dump_stack();
 		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD_MAP);
@@ -2030,7 +2033,7 @@ int transport_generic_handle_data(
 	 * in interrupt code, the signal_pending() check is skipped.
 	 */
 	if (!in_interrupt() && signal_pending(current))
-		return -1;
+		return -EPERM;
 	/*
 	 * If the received CDB has aleady been ABORTED by the generic
 	 * target engine, we now call transport_check_aborted_status()
@@ -2318,7 +2321,7 @@ transport_generic_allocate_buf(struct se_cmd *cmd, u32 data_length)
 	buf = kzalloc(data_length, GFP_KERNEL);
 	if (!(buf)) {
 		printk(KERN_ERR "Unable to allocate memory for buffer\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	T_TASK(cmd)->t_tasks_se_num = 0;
@@ -2801,7 +2804,7 @@ static inline u32 transport_get_sectors_10(
 	 * XXX_10 is not defined in SSC, throw an exception
 	 */
 	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
-		*ret = -1;
+		*ret = -EINVAL;
 		return 0;
 	}
 
@@ -2831,7 +2834,7 @@ static inline u32 transport_get_sectors_12(
 	 * XXX_12 is not defined in SSC, throw an exception
 	 */
 	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
-		*ret = -1;
+		*ret = -EINVAL;
 		return 0;
 	}
 
@@ -4405,7 +4408,7 @@ out:
 	if (se_mem)
 		__free_pages(se_mem->se_page, 0);
 	kmem_cache_free(se_mem_cache, se_mem);
-	return -1;
+	return -ENOMEM;
 }
 
 u32 transport_calc_sg_num(
@@ -4484,7 +4487,7 @@ next:
 	if (!(task->task_sg)) {
 		printk(KERN_ERR "Unable to allocate memory for"
 				" task->task_sg\n");
-		return 0;
+		return -ENOMEM;
 	}
 	sg_init_table(&task->task_sg[0], task_sg_num_padded);
 	/*
@@ -4498,7 +4501,7 @@ next:
 		if (!(task->task_sg_bidi)) {
 			printk(KERN_ERR "Unable to allocate memory for"
 				" task->task_sg_bidi\n");
-			return 0;
+			return -ENOMEM;
 		}
 		sg_init_table(&task->task_sg_bidi[0], task_sg_num_padded);
 	}
@@ -4600,7 +4603,7 @@ static int transport_map_sg_to_mem(
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -1;
+			return -ENOMEM;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
 		DEBUG_MEM("sg_to_mem: Starting loop with cmd_size: %u"
@@ -4658,7 +4661,7 @@ int transport_map_mem_to_sg(
 	if (!sg) {
 		printk(KERN_ERR "Unable to locate valid struct"
 				" scatterlist pointer\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	while (task_size != 0) {
@@ -5350,7 +5353,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 			" TRUE, skipping\n", CMD_TFO(cmd)->get_task_tag(cmd));
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		transport_cmd_check_stop(cmd, 1, 0);
-		return -1;
+		return -EPERM;
 	}
 	atomic_set(&T_TASK(cmd)->transport_lun_fe_stop, 1);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -5506,7 +5509,7 @@ int transport_clear_lun_from_sessions(struct se_lun *lun)
 			"tcm_cl_%u", lun->unpacked_lun);
 	if (IS_ERR(kt)) {
 		printk(KERN_ERR "Unable to start clear_lun thread\n");
-		return -1;
+		return PTR_ERR(kt);
 	}
 	wait_for_completion(&lun->lun_shutdown_comp);
 
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index df35517..4f754ca 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -80,10 +80,10 @@ int core_scsi3_ua_check(
 	case REQUEST_SENSE:
 		return 0;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
-	return -1;
+	return -EINVAL;
 }
 
 int core_scsi3_ua_allocate(
@@ -98,12 +98,12 @@ int core_scsi3_ua_allocate(
 	 * PASSTHROUGH OPS
 	 */
 	if (!(nacl))
-		return -1;
+		return -EINVAL;
 
 	ua = kmem_cache_zalloc(se_ua_cache, GFP_ATOMIC);
 	if (!(ua)) {
 		printk(KERN_ERR "Unable to allocate struct se_ua\n");
-		return -1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&ua->ua_dev_list);
 	INIT_LIST_HEAD(&ua->ua_nacl_list);
@@ -285,17 +285,17 @@ int core_scsi3_ua_clear_for_request_sense(
 	int head = 1;
 
 	if (!(sess))
-		return -1;
+		return -EINVAL;
 
 	nacl = sess->se_node_acl;
 	if (!(nacl))
-		return -1;
+		return -EINVAL;
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[cmd->orig_fe_lun];
 	if (!(atomic_read(&deve->ua_count))) {
 		spin_unlock_irq(&nacl->device_list_lock);
-		return -1;
+		return -EPERM;
 	}
 	/*
 	 * The highest priority Unit Attentions are placed at the head of the
@@ -328,5 +328,5 @@ int core_scsi3_ua_clear_for_request_sense(
 		" ASCQ: 0x%02x\n", TPG_TFO(nacl->se_tpg)->get_fabric_name(),
 		cmd->orig_fe_lun, *asc, *ascq);
 
-	return (head) ? -1 : 0;
+	return (head) ? -EPERM : 0;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 84e868c..8c5067c 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -582,10 +582,10 @@ int ft_register_configfs(void)
 	 * Register the top level struct config_item_type with TCM core
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "fc");
-	if (!fabric) {
+	if (IS_ERR(fabric)) {
 		printk(KERN_INFO "%s: target_fabric_configfs_init() failed!\n",
 		       __func__);
-		return -1;
+		return PTR_ERR(fabric);
 	}
 	fabric->tf_ops = ft_fabric_ops;
 
-- 
1.7.6

