From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] [Target_Core_Mod]: Add emulated REQUEST_SENSE and
	Control mode page TAS bit
Date: Tue, 24 Mar 2009 22:52:38 -0700
Message-ID: <1237960358.4138.394.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:43353 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752741AbZCYFwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 01:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>From 09bbe19217c4a9dbd07562b1c220a878d1ed1e96 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 23 Mar 2009 22:21:27 -0700
Subject: [PATCH 1/5] [Target_Core_Mod]: Add emulated REQUEST_SENSE and Control mode page TAS bit

This patch adds transport_generic_emulate_request_sense(), and updates
transport_modesense_control() to set the TASK_ABORTED Status (TAS) bit
based on DEV_ATTRIB(dev)->emulated_tas.

This patch also adds transport_cmd_finish_abort() and
transport_cmd_finish_abort_tmr() functions (used by new LUN_RESET code).
Also, transport_send_check_condition_and_sense() is updated to use
new SPC_ASC_KEY_OFFSET and SPC_ASCQ_KEY_OFFSET defines.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    7 +-
 drivers/lio-core/target_core_transport.c |  149 +++++++++++++++++++++++++-----
 drivers/lio-core/target_core_transport.h |   13 +++
 3 files changed, 145 insertions(+), 24 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 3341cb2..cab978f 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -55,7 +55,8 @@
 #define TRANSPORT_SENSE_BUFFER              SCSI_SENSE_BUFFERSIZE
 
 #define SPC_SENSE_KEY_OFFSET			2
-#define SPC_ASQ_KEY_OFFSET			12
+#define SPC_ASC_KEY_OFFSET			12
+#define SPC_ASCQ_KEY_OFFSET			13
 
 /* Currently same as ISCSI_IQN_LEN */
 #define TRANSPORT_IQN_LEN			224
@@ -195,6 +196,7 @@
 #define LOGICAL_UNIT_COMMUNICATION_FAILURE	0xa
 #define UNKNOWN_MODE_PAGE			0xb
 #define WRITE_PROTECTED				0xc
+#define CHECK_CONDITION_ABORT_CMD		0xd
 
 typedef struct se_obj_s {
 	atomic_t obj_access_count;
@@ -320,7 +322,7 @@ typedef struct se_queue_req_s {
 typedef struct se_queue_obj_s {
 	atomic_t		queue_cnt;
 	spinlock_t		cmd_queue_lock;
-	struct list_head	qobj_list;		
+	struct list_head	qobj_list;
 	wait_queue_head_t	thread_wq;
 	struct semaphore	thread_create_sem;
 	struct semaphore	thread_done_sem;
@@ -604,6 +606,7 @@ typedef struct se_dev_entry_s {
 typedef struct se_dev_attrib_s {
 	int		status_thread;
 	int		status_thread_tur;
+	int		emulate_tas;
 	int		emulate_reservations;
 	int		emulate_alua;
 	u32		hw_block_size;
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 4597e1b..6fa358d 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -899,7 +899,36 @@ static void transport_lun_remove_cmd(se_cmd_t *cmd)
 	spin_unlock_irqrestore(&lun->lun_cmd_lock, flags);
 }
 
-extern int transport_add_cmd_to_queue(
+void transport_cmd_finish_abort(se_cmd_t *cmd, int remove)
+{
+	transport_remove_cmd_from_queue(cmd,
+		CMD_ORIG_OBJ_API(cmd)->get_queue_obj(
+			cmd->se_orig_obj_ptr));
+
+	transport_lun_remove_cmd(cmd);
+
+	if (!(transport_cmd_check_stop(cmd, 1, 0))) {
+		transport_passthrough_check_stop(cmd);
+		return;
+	}
+	if (remove)
+		transport_generic_remove(cmd, 0, 0);
+}
+
+void transport_cmd_finish_abort_tmr(se_cmd_t *cmd)
+{
+	transport_remove_cmd_from_queue(cmd,
+			CMD_ORIG_OBJ_API(cmd)->get_queue_obj(
+			cmd->se_orig_obj_ptr));
+
+	if (!(transport_cmd_check_stop(cmd, 1, 0))) {
+		transport_passthrough_check_stop(cmd);
+		return;
+	}
+	transport_generic_remove(cmd, 0, 0);
+}
+
+int transport_add_cmd_to_queue(
 	se_cmd_t *cmd,
 	se_queue_obj_t *qobj,
 	u8 t_state)
@@ -955,7 +984,7 @@ se_queue_req_t *__transport_get_qr_from_queue(se_queue_obj_t *qobj)
 
 	list_for_each_entry(qr, &qobj->qobj_list, qr_list)
 		break;
-	
+
 	if (qr->cmd) {
 		cmd = (se_cmd_t *)qr->cmd;
 		atomic_dec(&T_TASK(cmd)->t_transport_queue_active);
@@ -992,7 +1021,7 @@ se_queue_req_t *transport_get_qr_from_queue(se_queue_obj_t *qobj)
 	return qr;
 }
 
-static void transport_remove_cmd_from_queue(se_cmd_t *cmd, se_queue_obj_t *qobj)
+void transport_remove_cmd_from_queue(se_cmd_t *cmd, se_queue_obj_t *qobj)
 {
 	se_cmd_t *q_cmd;
 	se_queue_req_t *qr = NULL, *qr_p = NULL;
@@ -4467,11 +4496,36 @@ static int transport_modesense_rwrecovery(unsigned char *p)
 	return 12;
 }
 
-static int transport_modesense_control(unsigned char *p)
+static int transport_modesense_control(se_device_t *dev, unsigned char *p)
 {
 	p[0] = 0x0a;
 	p[1] = 0x0a;
 	p[2] = 2;
+	/*
+	 * From spc4r17, section 7.4.6 Control mode Page
+	 *
+	 * Unit Attention interlocks control (UN_INTLCK_CTRL) to code 00b
+	 *
+	 * 00b: The logical unit shall clear any unit attention condition
+	 * reported in the same I_T_L_Q nexus transaction as a CHECK CONDITION
+	 * status and shall not establish a unit attention condition when a com-
+	 * mand is completed with BUSY, TASK SET FULL, or RESERVATION CONFLICT
+	 * status.
+	 */
+	p[4] = 0x00;
+	/*
+	 * From spc4r17, section 7.4.6 Control mode Page
+	 *
+	 * Task Aborted Status (TAS) bit set to zero.
+	 *
+	 * A task aborted status (TAS) bit set to zero specifies that aborted
+	 * tasks shall be terminated by the device server without any response
+	 * to the application client. A TAS bit set to one specifies that tasks
+	 * aborted by the actions of an I_T nexus other than the I_T nexus on
+	 * which the command was received shall be completed with TASK ABORTED
+	 * status (see SAM-4).
+	 */
+	p[5] = (DEV_ATTRIB(dev)->emulate_tas) ? 0x40 : 0x00;
 	p[8] = 0xff;
 	p[9] = 0xff;
 	p[11] = 30;
@@ -4525,6 +4579,7 @@ int transport_generic_emulate_modesense(
 	int ten,
 	int type)
 {
+	se_device_t *dev = SE_DEV(cmd);
 	int offset = (ten) ? 8 : 4;
 	int length = 0;
 	unsigned char buf[SE_MODE_PAGE_BUF];
@@ -4539,7 +4594,7 @@ int transport_generic_emulate_modesense(
 		length = transport_modesense_caching(&buf[offset]);
 		break;
 	case 0x0a:
-		length = transport_modesense_control(&buf[offset]);
+		length = transport_modesense_control(dev, &buf[offset]);
 		break;
 #if 0
 	case 0x2a:
@@ -4549,7 +4604,7 @@ int transport_generic_emulate_modesense(
 	case 0x3f:
 		length = transport_modesense_rwrecovery(&buf[offset]);
 		length += transport_modesense_caching(&buf[offset+length]);
-		length += transport_modesense_control(&buf[offset+length]);
+		length += transport_modesense_control(dev, &buf[offset+length]);
 #if 0
 		length += transport_modesense_devicecaps(&buf[offset+length]);
 #endif
@@ -4591,6 +4646,38 @@ int transport_generic_emulate_modesense(
 	return 0;
 }
 
+int transport_generic_emulate_request_sense(
+	se_cmd_t *cmd,
+	unsigned char *cdb)
+{
+	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
+
+	if (cdb[1] & 0x01) {
+		printk(KERN_ERR "REQUEST_SENSE description emulation not"
+			" supported\n");
+		return PYX_TRANSPORT_INVALID_CDB_FIELD;
+	}
+	/*
+	 * CURRENT ERROR
+	 */
+	buf[0] = 0x70;
+	buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
+	/*
+	 * Make sure request data length is enough for additional sense data.
+	 */
+	if (cmd->data_length <= 18) {
+		buf[7] = 0x00;
+		return 0;
+	}
+	/*
+	 * NO ADDITIONAL SENSE INFORMATION
+	 */
+	buf[SPC_ASC_KEY_OFFSET] = 0x00;
+	buf[7] = 0x0A;
+
+	return 0;
+}
+
 /*
  * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
  */
@@ -4692,7 +4779,8 @@ static int transport_generic_cmd_sequencer(
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
 
 	if (T10_RES(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
-		if (T10_RES(su_dev)->t10_seq_non_holder(cmd, cdb, pr_reg_type) != 0) {
+		if (T10_RES(su_dev)->t10_seq_non_holder(
+					cmd, cdb, pr_reg_type) != 0) {
 			cmd->transport_wait_for_tasks =
 					&transport_nop_wait_for_tasks;
 			transport_get_maps(cmd);
@@ -7051,7 +7139,7 @@ int transport_send_check_condition_and_sense(
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID COMMAND OPERATION CODE */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x20;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x20;
 		break;
 	case UNKNOWN_MODE_PAGE:
 		/* CURRENT ERROR */
@@ -7059,7 +7147,16 @@ int transport_send_check_condition_and_sense(
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID FIELD IN CDB */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x24;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x24;
+		break;
+	case CHECK_CONDITION_ABORT_CMD:
+		/* CURRENT ERROR */
+		buffer[offset] = 0x70;
+		/* ABORTED COMMAND */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
+		/* BUS DEVICE RESET FUNCTION OCCURRED */
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x29;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = 0x03;
 		break;
 	case INCORRECT_AMOUNT_OF_DATA:
 		/* CURRENT ERROR */
@@ -7067,9 +7164,9 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* WRITE ERROR */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x0c;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x0c;
 		/* NOT ENOUGH UNSOLICITED DATA */
-		buffer[offset+SPC_ASQ_KEY_OFFSET+1] = 0x0d;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = 0x0d;
 		break;
 	case INVALID_CDB_FIELD:
 		/* CURRENT ERROR */
@@ -7077,7 +7174,7 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* INVALID FIELD IN CDB */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x24;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x24;
 		break;
 	case INVALID_PARAMETER_LIST:
 		/* CURRENT ERROR */
@@ -7085,7 +7182,7 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* INVALID FIELD IN PARAMETER LIST */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x26;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x26;
 		break;
 	case UNEXPECTED_UNSOLICITED_DATA:
 		/* CURRENT ERROR */
@@ -7093,9 +7190,9 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* WRITE ERROR */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x0c;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x0c;
 		/* UNEXPECTED_UNSOLICITED_DATA */
-		buffer[offset+SPC_ASQ_KEY_OFFSET+1] = 0x0c;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = 0x0c;
 		break;
 	case SERVICE_CRC_ERROR:
 		/* CURRENT ERROR */
@@ -7103,9 +7200,9 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* PROTOCOL SERVICE CRC ERROR */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x47;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x47;
 		/* N/A */
-		buffer[offset+SPC_ASQ_KEY_OFFSET+1] = 0x05;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = 0x05;
 		break;
 	case SNACK_REJECTED:
 		/* CURRENT ERROR */
@@ -7113,9 +7210,9 @@ int transport_send_check_condition_and_sense(
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* READ ERROR */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x11;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x11;
 		/* FAILED RETRANSMISSION REQUEST */
-		buffer[offset+SPC_ASQ_KEY_OFFSET+1] = 0x13;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = 0x13;
 		break;
 	case WRITE_PROTECTED:
 		/* CURRENT ERROR */
@@ -7123,7 +7220,7 @@ int transport_send_check_condition_and_sense(
 		/* DATA PROTECT */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = DATA_PROTECT;
 		/* WRITE PROTECTED */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x27;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x27;
 		break;
 	case LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
@@ -7132,7 +7229,7 @@ int transport_send_check_condition_and_sense(
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[offset+SPC_ASQ_KEY_OFFSET] = 0x80;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x80;
 		break;
 	}
 	/*
@@ -7153,6 +7250,14 @@ after_reason:
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
+void transport_send_task_abort(se_cmd_t *cmd)
+{
+	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
+
+	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
+		CMD_TFO(cmd)->queue_status(cmd);
+}
+
 /*	transport_generic_do_tmr():
  *
  *
@@ -7388,7 +7493,7 @@ static int transport_status_thread_tur(
  *	Called with spin_lock_irq(&dev->execute_task_lock); held
  *
  */
-static se_task_t *transport_get_task_from_state_list(se_device_t *dev)
+se_task_t *transport_get_task_from_state_list(se_device_t *dev)
 {
 	se_task_t *task;
 
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index e8c3c3f..f3637ec 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -102,6 +102,8 @@
 #define DA_STATUS_THREAD			0
 /* Disabled by default */
 #define DA_STATUS_THREAD_TUR			0
+/* Emulation for TASK_ABORTED status (TAS) by default */
+#define DA_EMULATE_TAS				1
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_RESERVATIONS			0
 /* No Emulation for PSCSI by default */
@@ -139,8 +141,14 @@ extern void transport_deregister_session_configfs(struct se_session_s *);
 extern void transport_deregister_session(struct se_session_s *);
 extern void transport_task_dev_remove_state(struct se_task_s *,
 						struct se_device_s *);
+extern void transport_cmd_finish_abort(struct se_cmd_s *, int);
+extern void transport_cmd_finish_abort_tmr(struct se_cmd_s *);
 extern int transport_add_cmd_to_queue(struct se_cmd_s *,
 					struct se_queue_obj_s *, u8);
+extern struct se_queue_req_s *__transport_get_qr_from_queue(
+					struct se_queue_obj_s *);
+extern void transport_remove_cmd_from_queue(struct se_cmd_s *,
+					    struct se_queue_obj_s *);
 extern void transport_complete_cmd(se_cmd_t *, int);
 extern void transport_complete_task(struct se_task_s *, int);
 extern void transport_add_task_to_execute_queue(struct se_task_s *,
@@ -208,6 +216,8 @@ extern int transport_generic_emulate_readcapacity_16(struct se_cmd_s *,
 extern int transport_generic_emulate_modesense(struct se_cmd_s *,
 						unsigned char *,
 						unsigned char *, int, int);
+extern int transport_generic_emulate_request_sense(struct se_cmd_s *,
+						   unsigned char *);
 extern int transport_get_sense_data(struct se_cmd_s *);
 extern void transport_memcpy_read_contig(struct se_cmd_s *, unsigned char *);
 extern void transport_memcpy_read_sg(struct se_cmd_s *, struct scatterlist *);
@@ -232,6 +242,7 @@ extern int transport_generic_remove(se_cmd_t *, int, int);
 extern int transport_lun_wait_for_tasks(se_cmd_t *, se_lun_t *);
 extern void transport_clear_lun_from_sessions(se_lun_t *);
 extern int transport_send_check_condition_and_sense(se_cmd_t *, u8, int);
+extern void transport_send_task_abort(struct se_cmd_s *);
 extern void transport_release_cmd_to_pool(se_cmd_t *);
 extern void transport_generic_free_cmd(se_cmd_t *, int, int, int);
 extern void transport_generic_wait_for_cmds(se_cmd_t *, int);
@@ -267,6 +278,8 @@ extern void transport_generic_process_write(se_cmd_t *);
 extern int transport_generic_do_tmr(se_cmd_t *);
 extern void transport_start_status_timer(se_device_t *);
 extern void transport_stop_status_timer(se_device_t *);
+extern struct se_task_s *transport_get_task_from_state_list(
+					struct se_device_s *);
 extern void transport_status_thr_force_offline(se_device_t *,
 					struct se_obj_lun_type_s *,
 					void *);
-- 
1.5.4.1




