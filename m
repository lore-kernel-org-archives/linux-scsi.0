From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [Target_Core_Mod]: Update core code for new
	reservations infrastructure
Date: Thu, 22 Jan 2009 00:23:38 -0800
Message-ID: <1232612618.1274.531.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:23446 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750802AbZAVIYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 03:24:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From b0eee0162e2b3bbd0a39d8470980e7923e721775 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 21 Jan 2009 22:16:10 -0800
Subject: [PATCH 2/4] [Target_Core_Mod]: Update core code for new reservations infrastructure

This patch adds t10_reservations_index_t:

typedef enum {
       SPC_PASSTHROUGH,
       SPC2_RESERVATIONS,
       SPC3_PERSISTENT_RESERVATIONS
} t10_reservations_index_t;

and t10_reservation_template_t:

typedef struct t10_reservation_template_s {
       t10_reservations_index_t res_type;
       int (*t10_reservation_check)(struct se_cmd_s *);
       int (*t10_reserve)(struct se_cmd_s *);
       int (*t10_release)(struct se_cmd_s *);
       int (*t10_seq_non_holder)(struct se_cmd_s *, unsigned char *);
       int (*t10_pr_register)(struct se_cmd_s *);
       int (*t10_pr_clear)(struct se_cmd_s *);
} ____cacheline_aligned t10_reservation_template_t;

and adds se_dev_attrib->emulate_reservations (to be used with
Target_Core_Mod/ConfigFS).  It adds the support to target_core_transport.c
for using generic target_core_pr.c code for both SPC-2 Reservations (up and
running) and >= SPC-3 Persistent Reservations (WIP) with target_core_mod, and
removes the legacy code functions from target_core_transport.c

This patch also adds support for a number of SPC-4 defined CDBs in
target_core_transport.c:transport_generic_cmd_sequencer()

It also adds transport_passthrough_get_fabric_name() to SE_PASSTHROUGH_OPS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   35 +++-
 drivers/lio-core/target_core_device.c    |    1 +
 drivers/lio-core/target_core_tpg.c       |    4 -
 drivers/lio-core/target_core_transport.c |  315 ++++++++++++++----------------
 drivers/lio-core/target_core_transport.h |    4 +-
 5 files changed, 177 insertions(+), 182 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 086067a..8902128 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -255,6 +255,24 @@ typedef struct t10_wwn_s {
 	struct list_head t10_evpd_list;
 } ____cacheline_aligned t10_wwn_t;
 
+typedef enum {
+	SPC_PASSTHROUGH,
+	SPC2_RESERVATIONS,
+	SPC3_PERSISTENT_RESERVATIONS
+} t10_reservations_index_t;
+
+struct se_cmd_s;
+
+typedef struct t10_reservation_template_s {
+	t10_reservations_index_t res_type;
+	int (*t10_reservation_check)(struct se_cmd_s *);
+	int (*t10_reserve)(struct se_cmd_s *);
+	int (*t10_release)(struct se_cmd_s *);
+	int (*t10_seq_non_holder)(struct se_cmd_s *, unsigned char *);
+	int (*t10_pr_register)(struct se_cmd_s *);
+	int (*t10_pr_clear)(struct se_cmd_s *);
+} ____cacheline_aligned t10_reservation_template_t;
+
 typedef struct se_queue_req_s {
         int                     state;
         void                    *queue_se_obj_ptr;
@@ -520,6 +538,7 @@ typedef struct se_dev_entry_s {
 typedef struct se_dev_attrib_s {
         int             status_thread;
         int             status_thread_tur;
+	int		emulate_reservations;
 	u32		hw_max_sectors;
         u32             max_sectors;
 	u32		hw_queue_depth;
@@ -534,11 +553,14 @@ typedef struct se_subsystem_dev_s {
         struct se_device_s *se_dev_ptr;
         se_dev_attrib_t se_dev_attrib;
 	t10_wwn_t	t10_wwn;	/* T10 Inquiry and EVPD WWN Information */
+	t10_reservation_template_t t10_reservation;	/* T10 SPC-2 + SPC-3 Reservations */
         spinlock_t      se_dev_lock;
         void            *se_dev_su_ptr;
         struct config_group se_dev_group;
 } ____cacheline_aligned se_subsystem_dev_t;
 
+#define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
+
 typedef struct se_device_s {
 	__u8			type;		/* Type of disk transport used for device */
 	__u8			thread_active;	/* Set to 1 if thread is NOT sleeping on thread_sem */
@@ -572,10 +594,12 @@ typedef struct se_device_s {
 	se_queue_obj_t		*dev_status_queue_obj;
 	spinlock_t		execute_task_lock;
 	spinlock_t		state_task_lock;
+	spinlock_t		dev_reservation_lock;
 	spinlock_t		dev_state_lock;
 	spinlock_t		dev_status_lock;
 	spinlock_t		dev_status_thr_lock;
 	spinlock_t		se_port_lock;
+	struct se_node_acl_s	*dev_reserved_node_acl;
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
@@ -595,7 +619,8 @@ typedef struct se_device_s {
 	struct se_device_s	*prev;
 }  ____cacheline_aligned se_device_t;
 
-#define ISCSI_DEV(cmd)		((se_device_t *)(cmd)->se_lun->se_dev)
+#define SE_DEV(cmd)		((se_device_t *)(cmd)->se_lun->se_dev)
+#define ISCSI_DEV(cmd)		SE_DEV(cmd)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
 #define DEV_OBJ_API(dev)	((struct se_obj_lun_type_s *)(dev)->dev_obj_api)
@@ -637,24 +662,20 @@ typedef struct se_lun_s {
 	u32			unpacked_lun;
 	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_cmd_lock;
-	spinlock_t		lun_reservation_lock;
 	spinlock_t		lun_sep_lock;
 	se_cmd_t		*lun_cmd_head;
 	se_cmd_t		*lun_cmd_tail;
 	se_lun_acl_t		*lun_acl_head;
 	se_lun_acl_t		*lun_acl_tail;
-	struct se_node_acl_s	*lun_reserved_node_acl;
 	se_device_t		*se_dev;
 	void			*lun_type_ptr;
 	struct config_group	lun_group;
 	struct se_obj_lun_type_s *lun_obj_api;
 	struct se_port_s	*lun_sep;
-	int (*persistent_reservation_check)(se_cmd_t *);
-	int (*persistent_reservation_release)(se_cmd_t *);
-	int (*persistent_reservation_reserve)(se_cmd_t *);
 } ____cacheline_aligned se_lun_t;
 
-#define ISCSI_LUN(c)            ((se_lun_t *)(c)->se_lun)
+#define SE_LUN(c)		((se_lun_t *)(c)->se_lun)
+#define ISCSI_LUN(c)		SE_LUN(c)
 #define LUN_OBJ_API(lun)	((struct se_obj_lun_type_s *)(lun)->lun_obj_api)
 
 typedef struct se_port_s {
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 16e7766..49d25b9 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -725,6 +725,7 @@ extern void se_dev_set_default_attribs (se_device_t *dev)
 {
 	DEV_ATTRIB(dev)->status_thread = DA_STATUS_THREAD;
 	DEV_ATTRIB(dev)->status_thread_tur = DA_STATUS_THREAD_TUR;
+	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	/*
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
diff --git a/drivers/lio-core/target_core_tpg.c b/drivers/lio-core/target_core_tpg.c
index 9986321..4fd05ae 100644
--- a/drivers/lio-core/target_core_tpg.c
+++ b/drivers/lio-core/target_core_tpg.c
@@ -672,13 +672,9 @@ extern se_portal_group_t *core_tpg_register (
 		lun = &se_tpg->tpg_lun_list[i];
 		lun->unpacked_lun = i;
 		lun->lun_type_ptr = NULL;
-		lun->persistent_reservation_check = &core_tpg_persistent_reservation_check;
-		lun->persistent_reservation_release = &core_tpg_persistent_reservation_release;
-		lun->persistent_reservation_reserve = &core_tpg_persistent_reservation_reserve;
 		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 		spin_lock_init(&lun->lun_acl_lock);
 		spin_lock_init(&lun->lun_cmd_lock);
-		spin_lock_init(&lun->lun_reservation_lock);
 		spin_lock_init(&lun->lun_sep_lock);
 	}
 
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 4cccf85..1cc0a59 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -55,20 +55,14 @@
 #include <target_core_base.h>
 #include <iscsi_target_error.h>
 #include <target_core_device.h>
-#include <iscsi_target_device.h>
-#include <iscsi_target_erl0.h>
-#include <iscsi_target_erl1.h>
 #include <target_core_hba.h>
 #include <target_core_scdb.h>
-#include <iscsi_target_tpg.h>
-#include <iscsi_target_util.h>
+#include <target_core_pr.h>
 #include <target_core_transport.h>
-
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
 #include <target_core_seobj_plugins.h>
 #include <target_core_transport_plugin.h>
-
 #include <target_core_fabric_ops.h>
 #include <target_core_configfs.h>
 
@@ -214,10 +208,14 @@ struct kmem_cache *se_task_cache = NULL;
 struct kmem_cache *se_sess_cache = NULL;
 
 EXPORT_SYMBOL(se_global);
-extern int iscsi_release_sessions_for_tpg (iscsi_portal_group_t *, int);
 static int transport_generic_write_pending (se_cmd_t *);
 static int transport_processing_thread (void *);
 
+static char *transport_passthrough_get_fabric_name (void)
+{
+	return("PT");
+}
+
 static u32 transport_passthrough_get_task_tag (se_cmd_t *cmd)
 {
 	return(0);
@@ -235,6 +233,7 @@ static void transport_passthrough_release_cmd_direct (se_cmd_t *cmd)
 
 #define SE_PASSTHROUGH_OPS {						\
 	release_cmd_direct:	transport_passthrough_release_cmd_direct, \
+	get_fabric_name:	transport_passthrough_get_fabric_name,	\
 	get_task_tag:		transport_passthrough_get_task_tag,	\
 	get_cmd_state:		transport_passthrough_get_cmd_state,	\
 };
@@ -2053,6 +2052,7 @@ extern se_device_t *transport_add_device_to_core_hba (
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_sem);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->state_task_lock);
+	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->dev_status_lock);
 	spin_lock_init(&dev->dev_status_thr_lock);
 	spin_lock_init(&dev->se_port_lock);
@@ -2083,7 +2083,13 @@ extern se_device_t *transport_add_device_to_core_hba (
 	 */
 	if (!(dev->dev_obj_api = se_obj_get_api(TRANSPORT_LUN_TYPE_DEVICE)))
 		goto out;
-	
+	/*
+	 * Setup the Reservations infrastructure for se_device_t
+	 */
+	core_setup_reservations(dev);
+	/*
+	 * Startup the se_device_t processing thread
+	 */	
 	transport_generic_activate_device(dev);
 
 	/*
@@ -4303,9 +4309,9 @@ extern int transport_get_sense_data (se_cmd_t *cmd)
 }
 
 /*
- * Generic function pointers for the iSCSI Transport.
+ * Generic function pointers for target_core_mod/ConfigFS
  */
-#define SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd)					\
+#define SET_GENERIC_TRANSPORT_FUNCTIONS(cmd)						\
 	cmd->transport_allocate_iovecs = &transport_generic_allocate_iovecs;		\
 	cmd->transport_get_task = &transport_generic_get_task;				\
 	cmd->transport_map_buffers_to_tasks = &transport_generic_map_buffers_to_tasks;	\
@@ -4315,7 +4321,7 @@ extern int transport_get_sense_data (se_cmd_t *cmd)
  *
  *	Generic Command Sequencer that should work for most DAS transport drivers.
  *
- *	Called from transport_generic_allocate_tasks() in the iSCSI RX Thread.
+ *	Called from transport_generic_allocate_tasks() in the $FABRIC_MOD RX Thread.
  * 
  *	FIXME: Need to support other SCSI OPCODES where as well.
  */
@@ -4323,39 +4329,27 @@ static int transport_generic_cmd_sequencer (
 	se_cmd_t *cmd,
 	unsigned char *cdb)
 {
+	se_device_t *dev = SE_DEV(cmd);
+	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0;
 	u32 sectors = 0, size = 0;
 
-	if (ISCSI_LUN(cmd)->persistent_reservation_check(cmd) != 0) {
-		switch (cdb[0]) {
-		case INQUIRY:
-	                SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
-	                size = cdb[4];
-	                CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
-			transport_get_maps(cmd);
-	                ret = 2;
-	                break;
-		case RELEASE:
-		case RELEASE_10:
-			SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
-			cmd->transport_allocate_resources = &transport_generic_allocate_none;
-			transport_get_maps(cmd);
-
-			ISCSI_LUN(cmd)->persistent_reservation_release(cmd);
-			ret = 3;
-			break;
-		default:
+	if (T10_RES(su_dev)->t10_reservation_check(cmd) != 0) {
+		if (T10_RES(su_dev)->t10_seq_non_holder(cmd, cdb) != 0) {
 			cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 			transport_get_maps(cmd);
-			return(5);
+			return(5); // RESERVATION CONFLIT
 		}
-			
-		goto check_size;
+		/*
+		 * This means the CDB is allowed for the SCSI Initiator port
+		 * when said port is *NOT* holding the legacy SPC-2 or
+		 * SPC-3 Persistent Reservation.
+		 */
 	}
 
 	switch (cdb[0]) {
 	case READ_6:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4366,7 +4360,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_21;
 		break; 
 	case READ_10:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4377,7 +4371,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_32;
 		break;
 	case READ_12:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4388,7 +4382,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_32;
 		break;
 	case READ_16:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4399,7 +4393,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_long_lba = &transport_lba_64;
 		break;
 	case WRITE_6:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4410,7 +4404,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_21;
 		break;
 	case WRITE_10:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4421,7 +4415,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_32;
 		break;
 	case WRITE_12:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4432,7 +4426,7 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_get_lba = &transport_lba_32;
 		break;
 	case WRITE_16:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return(4);
@@ -4442,29 +4436,35 @@ static int transport_generic_cmd_sequencer (
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
 		break;
-	case SEND_KEY:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
-		size = (cdb[8] << 8) + cdb[9];
+	case 0xa3:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		if (TRANSPORT(dev)->get_device_type(dev) == TYPE_RAID) {
+			// MAINTENANCE_IN from SCC-2
+			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
+		} else {
+			// SEND_KEY from multi media commands
+			size = (cdb[8] << 8) + cdb[9];
+		}
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case MODE_SELECT:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case MODE_SELECT_10:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case MODE_SENSE:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4]; 
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
@@ -4473,15 +4473,16 @@ static int transport_generic_cmd_sequencer (
 	case MODE_SENSE_10:
 	case READ_BUFFER_CAPACITY:
 	case SEND_OPC_INFORMATION:
+	case LOG_SELECT:
 	case LOG_SENSE:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case READ_BLOCK_LIMITS:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_BLOCK_LEN;
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
@@ -4490,67 +4491,112 @@ static int transport_generic_cmd_sequencer (
 	case GET_CONFIGURATION:
 	case READ_DISK_INFORMATION:
 	case READ_TRACK_RZONE_INFO:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		size = (cdb[7] << 8) + cdb[8];
+		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		ret = 1;
+		break;
 	case PERSISTENT_RESERVE_IN:
 	case PERSISTENT_RESERVE_OUT:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		cmd->transport_emulate_cdb =
+			(T10_RES(su_dev)->res_type == SPC3_PERSISTENT_RESERVATIONS) ?
+			&core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case READ_DVD_STRUCTURE:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[8] << 8) + cdb[9];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case READ_POSITION:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_POSITION_LEN;
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-	case REPORT_KEY:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
-		size = (cdb[8] << 8) + cdb[9];
+	case 0xa4:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		if (TRANSPORT(dev)->get_device_type(dev) == TYPE_RAID) {
+			// MAINTENANCE_OUT from SCC-2
+			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
+		} else  {
+			// REPORT_KEY from multi media commands
+			size = (cdb[8] << 8) + cdb[9];
+		}
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 1;
 		break;
 	case INQUIRY:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case READ_BUFFER:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case READ_CAPACITY:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_CAP_LEN;
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
+	case READ_MEDIA_SERIAL_NUMBER:
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		ret = 2;
+		break;
 	case SERVICE_ACTION_IN:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+	case ACCESS_CONTROL_IN:
+	case ACCESS_CONTROL_OUT:
+	case EXTENDED_COPY:
+	case READ_ATTRIBUTE:
+	case RECEIVE_COPY_RESULTS:
+	case WRITE_ATTRIBUTE:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[10] << 24) | (cdb[11] << 16) | (cdb[12] << 8) | cdb[13];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
+	case RECEIVE_CREDENTIAL:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		size = (cdb[10] << 8) | cdb[11];
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		ret = 2;
+		break;
+	case RECEIVE_DIAGNOSTIC:
+	case SEND_DIAGNOSTIC:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		size = (cdb[3] << 8) | cdb[4];
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		ret = 2;
+		break;
 //#warning FIXME: Figure out correct READ_CD blocksize.
 #if 0
 	case READ_CD:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		size = (2336 * sectors);
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
@@ -4559,28 +4605,28 @@ static int transport_generic_cmd_sequencer (
 		break;
 #endif
 	case READ_TOC:  
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case REQUEST_SENSE:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case READ_ELEMENT_STATUS:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
 	case WRITE_BUFFER:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
@@ -4588,22 +4634,43 @@ static int transport_generic_cmd_sequencer (
 		break;
 	case RESERVE:
 	case RESERVE_10:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		/*
+		 * The SPC-2 RESERVE does not contain a size in the SCSI CDB.
+		 * Assume the passthrough or $FABRIC_MOD will tell us about it.
+		 */
+		if (cdb[0] == RESERVE_10)
+			size = (cdb[7] << 8) | cdb[8];	
+		else
+			size = cmd->data_length;
+
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		cmd->transport_allocate_resources = &transport_generic_allocate_none;
 		transport_get_maps(cmd);
 		
-		if ((ret = ISCSI_LUN(cmd)->persistent_reservation_reserve(cmd)))
-			return(ret);
-		
+		if ((ret = T10_RES(su_dev)->t10_reserve(cmd)) != 0) {
+			if (ret > 0)
+				return(5); // RESERVATION_CONFILIT
+			else
+				return(7); // ILLEGAL_REQUEST
+		}	
 		ret = 3;
 		break;
 	case RELEASE:
 	case RELEASE_10:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		/*
+		 * The SPC-2 RELEASE does not contain a size in the SCSI CDB.
+		 * Assume the passthrough or $FABRIC_MOD will tell us about it.
+		*/
+		if (cdb[0] == RELEASE_10)
+			size = (cdb[7] << 8) | cdb[8];
+		else
+			size = cmd->data_length;
+
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		cmd->transport_allocate_resources = &transport_generic_allocate_none;
 		transport_get_maps(cmd);
 		
-		ISCSI_LUN(cmd)->persistent_reservation_release(cmd);
+		T10_RES(su_dev)->t10_release(cmd);
 		ret = 3;
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
@@ -4621,13 +4688,13 @@ static int transport_generic_cmd_sequencer (
 	case VERIFY:
 	case WRITE_FILEMARKS:
 	case MOVE_MEDIUM:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		cmd->transport_allocate_resources = &transport_generic_allocate_none;
 		transport_get_maps(cmd);
 		ret = 3;
 		break;
 	case REPORT_LUNS:
-		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		cmd->transport_emulate_cdb = &transport_core_report_lun_response;
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
@@ -4635,18 +4702,19 @@ static int transport_generic_cmd_sequencer (
 		ret = 2;
 		break;
 	default:
-		TRACE_ERROR("Unsupported SCSI Opcode 0x%02x, sending"
-			" CHECK_CONDITION.\n", cdb[0]);
+		TRACE_ERROR("TARGET_CORE[%s]: Unsupported SCSI Opcode 0x%02x,"
+			" sending CHECK_CONDITION.\n",
+			CMD_TFO(cmd)->get_fabric_name(), cdb[0]);
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 		transport_get_maps(cmd);
 		return(4);
 	}
 
-check_size:
 	if (size != cmd->data_length) {
-		TRACE_ERROR("iSCSI Expected Transfer Length: %u does not"
-		" match SCSI CDB Length: %u for SAM Opcode: 0x%02x\n",
-			cmd->data_length, size, cdb[0]);
+		TRACE_ERROR("TARGET_CORE[%s]: Expected Transfer Length: %u"
+			" does not match SCSI CDB Length: %u for SAM Opcode:"
+			" 0x%02x\n", CMD_TFO(cmd)->get_fabric_name(),
+				cmd->data_length, size, cdb[0]);
 
 		cmd->cmd_spdtl = size;
 
@@ -4896,9 +4964,6 @@ extern se_cmd_t *transport_allocate_passthrough (
 		}
 	}
 
-	ISCSI_LUN(cmd)->persistent_reservation_check = &core_tpg_persistent_reservation_check;
-	ISCSI_LUN(cmd)->persistent_reservation_release = &core_tpg_persistent_reservation_release;
-	ISCSI_LUN(cmd)->persistent_reservation_reserve = &core_tpg_persistent_reservation_reserve;
 	cmd->data_length = length;
 	cmd->data_direction = data_direction;
 	cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH;
@@ -6599,92 +6664,6 @@ after_reason:
 
 EXPORT_SYMBOL(iscsi_send_check_condition_and_sense);
 
-extern int core_tpg_persistent_reservation_check (se_cmd_t *cmd)
-{
-	se_lun_t *lun = cmd->se_lun;
-	se_session_t *sess = cmd->se_sess;
-        int ret;
-
-        spin_lock(&lun->lun_reservation_lock);
-        if (!lun->lun_reserved_node_acl || !sess) {
-                spin_unlock(&lun->lun_reservation_lock);
-                return(0);
-        }
-        ret = (lun->lun_reserved_node_acl != sess->se_node_acl) ? -1 : 0;
-        spin_unlock(&lun->lun_reservation_lock);
-
-        return(ret);
-}
-
-EXPORT_SYMBOL(core_tpg_persistent_reservation_check);
-
-extern int core_tpg_persistent_reservation_release (se_cmd_t *cmd)
-{
-	se_lun_t *lun = cmd->se_lun;
-	se_session_t *sess = cmd->se_sess;
-	se_portal_group_t *tpg = sess->se_tpg;
-
-        spin_lock(&lun->lun_reservation_lock);
-        if (!lun->lun_reserved_node_acl || !sess) {
-                spin_unlock(&lun->lun_reservation_lock);
-                return(0);
-        }
-
-        if (lun->lun_reserved_node_acl != sess->se_node_acl) {
-                spin_unlock(&lun->lun_reservation_lock);
-                return(0);
-        }
-        lun->lun_reserved_node_acl = NULL;
-        PYXPRINT("Released %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
-		TPG_TFO(tpg)->get_fabric_name(),
-		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
-		sess->se_node_acl->initiatorname);
-        spin_unlock(&lun->lun_reservation_lock);
-
-        return(0);
-}
-
-EXPORT_SYMBOL(core_tpg_persistent_reservation_release);
-
-extern int core_tpg_persistent_reservation_reserve (se_cmd_t *cmd)
-{
-	se_lun_t *lun = cmd->se_lun;
-	se_session_t *sess = cmd->se_sess;
-	se_portal_group_t *tpg = sess->se_tpg;
-
-        if ((T_TASK(cmd)->t_task_cdb[1] & 0x01) && (T_TASK(cmd)->t_task_cdb[1] & 0x02)) {
-                TRACE_ERROR("LongIO and Obselete Bits set, returning ILLEGAL_REQUEST\n");
-                return(7);
-        }
-
-	if (!(sess))
-		return(5);
-
-        spin_lock(&lun->lun_reservation_lock);
-        if (lun->lun_reserved_node_acl && (lun->lun_reserved_node_acl != sess->se_node_acl)) {
-                TRACE_ERROR("RESERVATION CONFLIFT for %s fabric\n",
-				TPG_TFO(tpg)->get_fabric_name());
-                TRACE_ERROR("Original reserver TPG LUN: %u %s\n", lun->unpacked_lun,
-                                lun->lun_reserved_node_acl->initiatorname);
-                TRACE_ERROR("Current attempt - TPG LUN: %u -> MAPPED LUN: %u from %s \n",
-                                lun->unpacked_lun, cmd->se_deve->mapped_lun,
-                                sess->se_node_acl->initiatorname);
-                spin_unlock(&lun->lun_reservation_lock);
-                return(5);
-        }
-
-        lun->lun_reserved_node_acl = sess->se_node_acl;
-        PYXPRINT("Reserved %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
-		TPG_TFO(tpg)->get_fabric_name(),
-		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
-		sess->se_node_acl->initiatorname);
-        spin_unlock(&lun->lun_reservation_lock);
-
-        return(0);
-}
-
-EXPORT_SYMBOL(core_tpg_persistent_reservation_reserve);
-
 /*	transport_generic_lun_reset():
  *
  *
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 3aea1e6..5087280 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -88,6 +88,7 @@
 #define DA_TASK_TIMEOUT_MAX			600 /* 10 Minutes, see transport_get_default_task_timeout()  */
 #define DA_STATUS_THREAD			0 /* Disabled by default */
 #define DA_STATUS_THREAD_TUR			0 /* Disabled by default */
+#define DA_EMULATE_RESERVATIONS			0 /* No Emulation for PSCSI by default */
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 
@@ -184,9 +185,6 @@ extern int transport_generic_remove (se_cmd_t *, int, int);
 extern int transport_lun_wait_for_tasks (se_cmd_t *, se_lun_t *);
 extern void transport_clear_lun_from_sessions (se_lun_t *);
 extern int iscsi_send_check_condition_and_sense (se_cmd_t *, __u8, int);
-extern int core_tpg_persistent_reservation_check (se_cmd_t *);
-extern int core_tpg_persistent_reservation_release (se_cmd_t *);
-extern int core_tpg_persistent_reservation_reserve (se_cmd_t *);
 extern void transport_release_cmd_to_pool (se_cmd_t *);
 extern void transport_generic_free_cmd (se_cmd_t *, int, int, int);
 extern void transport_generic_wait_for_cmds (se_cmd_t *, int);
-- 
1.5.4.1



