From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/7] [Target_Core_Mod]: Add SPC-3 PERSISTENT_RESERVE_*
	Infrastrcture
Date: Mon, 26 Jan 2009 01:07:14 -0800
Message-ID: <1232960834.24642.122.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:45752 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751369AbZAZJHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:07:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From c95cbb3437d09c5211a2ea3380526ff2f2541e69 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:28:54 -0800
Subject: [PATCH 1/7] [Target_Core_Mod]: Add SPC-3 PERSISTENT_RESERVE_* Infrastrcture

This patch adds additional structure members to t10_reservation_template_t and
adds t10_pr_registration_s and (placeholder) t10_pr_reservation_t structure defines
to Target_Core_Mod.

Tjos patch makes non-execption submission for se_cmd_t->emulate_cdb() function pointer
to queue generically in __transport_execute_tasks().

This patch also renames iscsi_send_check_condition_and_sense ->
transport_send_check_condition_and_sense() and updates
transport_generic_request_failure() to handle new exceptions.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   39 +++++++++++++--
 drivers/lio-core/target_core_transport.c |   75 ++++++++++++++++++++++-------
 drivers/lio-core/target_core_transport.h |   14 ++++--
 3 files changed, 100 insertions(+), 28 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 7e113d8..c5b6f3e 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -217,7 +217,10 @@
 #define DEV_STATUS_THR_TAKE_OFFLINE		3
 #define DEV_STATUS_THR_SHUTDOWN			4
 
-/* iscsi_send_check_condition_and_sense() */
+/* se_dev_entry_t->deve_flags */
+#define DEF_PR_REGISTERED			0x01
+
+/* transport_send_check_condition_and_sense() */
 #define NON_EXISTENT_LUN			0x1
 #define UNSUPPORTED_SCSI_OPCODE			0x2
 #define INCORRECT_AMOUNT_OF_DATA		0x3
@@ -226,9 +229,10 @@
 #define SNACK_REJECTED				0x6
 #define SECTOR_COUNT_TOO_MANY			0x7
 #define INVALID_CDB_FIELD			0x8
-#define LOGICAL_UNIT_COMMUNICATION_FAILURE	0x9
-#define UNKNOWN_MODE_PAGE			0xa
-#define WRITE_PROTECTED				0xb
+#define INVALID_PARAMETER_LIST			0x9
+#define LOGICAL_UNIT_COMMUNICATION_FAILURE	0xa
+#define UNKNOWN_MODE_PAGE			0xb
+#define WRITE_PROTECTED				0xc
 
 typedef struct se_obj_s {
 	atomic_t obj_access_count;
@@ -264,7 +268,12 @@ typedef enum {
 struct se_cmd_s;
 
 typedef struct t10_reservation_template_s {
+	int pr_all_tg_pt; /* Reservation effects all target ports */
+	u32 pr_generation;
 	t10_reservations_index_t res_type;
+	spinlock_t registration_lock;
+	struct se_node_acl_s *pr_res_holder; /* Reservation holder when pr_all_tg_pt=1 */
+	struct list_head registration_list;
 	int (*t10_reservation_check)(struct se_cmd_s *);
 	int (*t10_reserve)(struct se_cmd_s *);
 	int (*t10_release)(struct se_cmd_s *);
@@ -273,6 +282,21 @@ typedef struct t10_reservation_template_s {
 	int (*t10_pr_clear)(struct se_cmd_s *);
 } ____cacheline_aligned t10_reservation_template_t;
 
+typedef struct t10_pr_registration_s {
+	int pr_reg_all_tg_pt; /* Reservation effects all target ports */
+	int pr_res_type;
+	int pr_res_scope;
+	u32 pr_res_generation;
+	u64 pr_res_key;
+	struct se_node_acl_s *pr_reg_nacl;
+	struct se_dev_entry_s *pr_reg_deve;
+	struct list_head pr_reg_list;
+} t10_pr_registration_t;
+
+typedef struct t10_pr_reservation_s {
+	
+} t10_pr_reservation_t;
+
 typedef struct se_queue_req_s {
         int                     state;
         void                    *queue_se_obj_ptr;
@@ -522,6 +546,7 @@ typedef struct se_lun_acl_s {
 typedef struct se_dev_entry_s {
 	u32			lun_flags;
 	u32			deve_cmds;
+	u32			deve_flags;
 	u32			mapped_lun;
 	u32			average_bytes;
 	u32			last_byte_count;
@@ -602,7 +627,8 @@ typedef struct se_device_s {
 	spinlock_t		dev_status_lock;
 	spinlock_t		dev_status_thr_lock;
 	spinlock_t		se_port_lock;
-	struct se_node_acl_s	*dev_reserved_node_acl;
+	struct se_node_acl_s	*dev_reserved_node_acl; /* Used for legacy SPC-2 reservationsa */
+	struct t10_pr_registration_s *dev_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
@@ -623,6 +649,7 @@ typedef struct se_device_s {
 }  ____cacheline_aligned se_device_t;
 
 #define SE_DEV(cmd)		((se_device_t *)(cmd)->se_lun->se_dev)
+#define SU_DEV(dev)		((se_subsystem_dev_t *)(dev)->se_sub_dev)
 #define ISCSI_DEV(cmd)		SE_DEV(cmd)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
@@ -662,6 +689,7 @@ typedef struct se_lun_s {
 	int			lun_type;
 	int			lun_status;
 	u32			lun_access;
+	u32			lun_flags;
 	u32			unpacked_lun;
 	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_cmd_lock;
@@ -671,6 +699,7 @@ typedef struct se_lun_s {
 	se_lun_acl_t		*lun_acl_head;
 	se_lun_acl_t		*lun_acl_tail;
 	se_device_t		*se_dev;
+	struct t10_pr_registration_s *lun_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
 	void			*lun_type_ptr;
 	struct config_group	lun_group;
 	struct se_obj_lun_type_s *lun_obj_api;
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index c83ed5d..ad2dd75 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -206,6 +206,7 @@ se_global_t *se_global;
 struct kmem_cache *se_cmd_cache = NULL;
 struct kmem_cache *se_task_cache = NULL;
 struct kmem_cache *se_sess_cache = NULL;
+struct kmem_cache *t10_pr_reg_cache = NULL;
 
 EXPORT_SYMBOL(se_global);
 static int transport_generic_write_pending (se_cmd_t *);
@@ -271,7 +272,12 @@ extern int init_se_global (void)
 		printk(KERN_ERR "kmem_cache_create() for se_session_t failed\n");
 		goto out;
 	}
-
+	if (!(t10_pr_reg_cache = kmem_cache_create("t10_pr_reg_cache",
+			sizeof(t10_pr_registration_t), __alignof__(t10_pr_registration_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for t10_pr_registration_t failed\n");
+		goto out;
+	}
         if (!(global->hba_list = kzalloc((sizeof(se_hba_t) *
 				TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->hba_list\n");
@@ -309,6 +315,8 @@ out:
 		kmem_cache_destroy(se_task_cache);
 	if (se_sess_cache)
 		kmem_cache_destroy(se_sess_cache);
+	if (t10_pr_reg_cache)
+		kmem_cache_destroy(t10_pr_reg_cache);
 	kfree(global);
         return(-1);
 }
@@ -325,6 +333,7 @@ extern void release_se_global (void)
 	kmem_cache_destroy(se_cmd_cache);
 	kmem_cache_destroy(se_task_cache);
 	kmem_cache_destroy(se_sess_cache);
+	kmem_cache_destroy(t10_pr_reg_cache);
 	kfree(global);
 
 	se_global = NULL;
@@ -2946,6 +2955,9 @@ extern void transport_generic_request_failure (se_cmd_t *cmd, se_device_t *dev,
 	case PYX_TRANSPORT_INVALID_CDB_FIELD:
 		cmd->scsi_sense_reason = INVALID_CDB_FIELD;
 		break;
+	case PYX_TRANSPORT_INVALID_PARAMETER_LIST:
+		cmd->scsi_sense_reason = INVALID_PARAMETER_LIST;
+		break;
 	case PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES:
 		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
 			if (!sc)
@@ -2970,6 +2982,18 @@ extern void transport_generic_request_failure (se_cmd_t *cmd, se_device_t *dev,
 	case PYX_TRANSPORT_WRITE_PROTECTED:
 		cmd->scsi_sense_reason = WRITE_PROTECTED;
 		break;
+	case PYX_TRANSPORT_RESERVATION_CONFLICT:
+		/*
+		 * No SENSE Data payload for this case, set SCSI Status
+		 * and queue the response to $FABRIC_MOD.  
+		 *
+		 * Uses linux/include/scsi/scsi.h SAM status codes defs
+		 */
+		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
+		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
+			CMD_TFO(cmd)->queue_status(cmd);
+
+		goto check_stop;
 	default:
 		TRACE_ERROR("Unknown transport error for CDB 0x%02x: %d\n",
 			T_TASK(cmd)->t_task_cdb[0], cmd->transport_error_status);
@@ -2980,8 +3004,8 @@ extern void transport_generic_request_failure (se_cmd_t *cmd, se_device_t *dev,
 	if (!sc)
 		transport_new_cmd_failure(cmd);
 	else
-		iscsi_send_check_condition_and_sense(cmd, cmd->scsi_sense_reason, 0);
-	
+		transport_send_check_condition_and_sense(cmd,
+			cmd->scsi_sense_reason, 0);
 check_stop:
 	transport_lun_remove_cmd(cmd);
 	if (!(transport_cmd_check_stop(cmd, 2, 0)))
@@ -3828,7 +3852,15 @@ check_depth:
 			atomic_set(&cmd->transport_sent, 0);
 			transport_stop_tasks_for_cmd(cmd);
 			transport_generic_request_failure(cmd, dev, 0, 1);
+			goto check_depth;
 		}
+		/*
+		 * Handle the successful completion for transport_emulate_cdb()
+		 * usage.
+		 */
+		cmd->scsi_status = SAM_STAT_GOOD;
+		task->task_scsi_status = GOOD;
+		transport_complete_task(task, 1);
 	} else {
 		if ((error = TRANSPORT(dev)->do_task(task)) != 0) {
 			cmd->transport_error_status = error;
@@ -4004,7 +4036,7 @@ extern int transport_generic_emulate_inquiry (
 	if (!(cdb[1] & 0x1)) {
 		if (type == TYPE_TAPE)
 			buf[1] = 0x80;
-		buf[2]          = 0x02;
+		buf[2]          = TRANSPORT(dev)->get_device_rev(dev);
 		buf[4]          = 31;
 		buf[7]		= 0x32; /* Sync=1 and CmdQue=1 */
 		
@@ -4506,9 +4538,9 @@ static int transport_generic_cmd_sequencer (
 			(T10_RES(su_dev)->res_type == SPC3_PERSISTENT_RESERVATIONS) ?
 			&core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
-		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
-		ret = 1;
+		ret = 2;
 		break;
 	case READ_DVD_STRUCTURE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
@@ -5147,7 +5179,7 @@ extern void transport_generic_complete_ok (se_cmd_t *cmd)
 		 * a non GOOD status.
 		 */
 		if (cmd->scsi_status) {
-			iscsi_send_check_condition_and_sense(cmd, reason, 1);
+			transport_send_check_condition_and_sense(cmd, reason, 1);
 			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop(cmd, 2, 0);
 			return;
@@ -6445,7 +6477,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                  * Initiator Node.  Return this SCSI CDB back with an CHECK_CONDITION
                  * status.
                  */
-                iscsi_send_check_condition_and_sense(cmd, NON_EXISTENT_LUN, 0);
+                transport_send_check_condition_and_sense(cmd, NON_EXISTENT_LUN, 0);
 
                 /*
                  * If the iSCSI frontend is waiting for this iscsi_cmd_t to be released,
@@ -6556,7 +6588,7 @@ remove:
 	return;
 }
 
-extern int iscsi_send_check_condition_and_sense (se_cmd_t *cmd, u8 reason, int from_transport)
+extern int transport_send_check_condition_and_sense (se_cmd_t *cmd, u8 reason, int from_transport)
 {
 	unsigned char *buffer = NULL;
 	unsigned long flags;
@@ -6620,6 +6652,11 @@ extern int iscsi_send_check_condition_and_sense (se_cmd_t *cmd, u8 reason, int f
                 buffer[4] = 0x0b; /* ABORTED COMMAND */
                 buffer[14] = 0x24; /* INVALID FIELD IN CDB */
                 break;
+	case INVALID_PARAMETER_LIST:
+		buffer[2] = 0x70; /* CURRENT ERROR */
+		buffer[4] = 0x0b; /* ABORTED COMMAND */
+		buffer[14] = 0x26; /* INVALID FIELD IN PARAMETER LIST */
+		break;
         case UNEXPECTED_UNSOLICITED_DATA:
                 buffer[2] = 0x70; /* CURRENT ERROR */
                 buffer[4] = 0x0b; /* ABORTED COMMAND */
@@ -6650,12 +6687,13 @@ extern int iscsi_send_check_condition_and_sense (se_cmd_t *cmd, u8 reason, int f
                 buffer[14] = 0x80; /* LOGICAL UNIT COMMUNICATION FAILURE */
                 break;
         }
-
 	/*
-	 * LINUX defines CHECK_CONDITION as 0x01, but follow SPC-3 anyways.
+	 * This code uses linux/include/scsi/scsi.h SAM status codes!
 	 */
-        cmd->scsi_status        = 0x02; /* CHECK CONDITION */
-        cmd->scsi_sense_length  = TRANSPORT_SENSE_SEGMENT_LENGTH; /* Automatically padded */
+	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+
+	/* Automatically padded */
+	cmd->scsi_sense_length  = TRANSPORT_SENSE_SEGMENT_LENGTH;
 
 after_reason:
         if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
@@ -6664,7 +6702,7 @@ after_reason:
 	return(0);
 }
 
-EXPORT_SYMBOL(iscsi_send_check_condition_and_sense);
+EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
 /*	transport_generic_lun_reset():
  *
@@ -7159,7 +7197,7 @@ fail_cmd:
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
 		if (!remove)
-			iscsi_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+			transport_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 
 		transport_remove_cmd_from_queue(cmd,
 			CMD_ORIG_OBJ_API(cmd)->get_queue_obj(cmd->se_orig_obj_ptr));
@@ -7403,7 +7441,7 @@ static void transport_processing_shutdown (se_device_t *dev)
 
 			if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
 				spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-				iscsi_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+				transport_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 				transport_remove_cmd_from_queue(cmd,
 						CMD_ORIG_OBJ_API(cmd)->get_queue_obj(cmd->se_orig_obj_ptr));
 
@@ -7431,7 +7469,7 @@ static void transport_processing_shutdown (se_device_t *dev)
 
 		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
 			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);	
-			iscsi_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+			transport_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 			transport_remove_cmd_from_queue(cmd,
 					CMD_ORIG_OBJ_API(cmd)->get_queue_obj(cmd->se_orig_obj_ptr));
 
@@ -7468,7 +7506,8 @@ static void transport_processing_shutdown (se_device_t *dev)
 		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n", cmd, state);
 		
 		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
-			iscsi_send_check_condition_and_sense(cmd, LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+			transport_send_check_condition_and_sense(cmd,
+				LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 
 			transport_lun_remove_cmd(cmd);
 			if (!(transport_cmd_check_stop(cmd, 1, 0)))
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 27a127c..768b8c7 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -46,10 +46,12 @@
 #define PYX_TRANSPORT_REQ_TOO_MANY_SECTORS	-3
 #define PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES	-4
 #define PYX_TRANSPORT_INVALID_CDB_FIELD		-5
-#define PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE -6
-#define PYX_TRANSPORT_UNKNOWN_MODE_PAGE		-7
-#define PYX_TRANSPORT_WRITE_PROTECTED		-8
-#define PYX_TRANSPORT_TASK_TIMEOUT		-9
+#define PYX_TRANSPORT_INVALID_PARAMETER_LIST	-6
+#define PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE -7
+#define PYX_TRANSPORT_UNKNOWN_MODE_PAGE		-8
+#define PYX_TRANSPORT_WRITE_PROTECTED		-9
+#define PYX_TRANSPORT_TASK_TIMEOUT		-10
+#define PYX_TRANSPORT_RESERVATION_CONFLICT	-11
 
 #ifndef SAM_STAT_RESERVATION_CONFLICT
 #define SAM_STAT_RESERVATION_CONFLICT		0x18
@@ -89,6 +91,8 @@
 #define DF_PERSISTENT_CLAIMED_BLOCKDEV		0x00000020
 #define DF_DISABLE_STATUS_THREAD		0x00000040
 #define DF_READ_ONLY				0x00000080
+#define DF_SPC3_PERSISTENT_RESERVE		0x00000100
+#define DF_SPC2_RESERVATIONS			0x00000200
 
 /* se_dev_attrib_t sanity values */
 #define DA_TASK_TIMEOUT_MAX			600 /* 10 Minutes, see transport_get_default_task_timeout()  */
@@ -189,7 +193,7 @@ extern void transport_release_fe_cmd (se_cmd_t *);
 extern int transport_generic_remove (se_cmd_t *, int, int);
 extern int transport_lun_wait_for_tasks (se_cmd_t *, se_lun_t *);
 extern void transport_clear_lun_from_sessions (se_lun_t *);
-extern int iscsi_send_check_condition_and_sense (se_cmd_t *, __u8, int);
+extern int transport_send_check_condition_and_sense (se_cmd_t *, __u8, int);
 extern void transport_release_cmd_to_pool (se_cmd_t *);
 extern void transport_generic_free_cmd (se_cmd_t *, int, int, int);
 extern void transport_generic_wait_for_cmds (se_cmd_t *, int);
-- 
1.5.4.1



