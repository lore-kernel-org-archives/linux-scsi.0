From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] lio-target: Convert to use pre-allocated struct se_cmd descriptors
Date: Fri, 10 Sep 2010 02:26:54 -0700
Message-ID: <1284110814-361-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joe Eykholt <jeykholt@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the LIO-Target fabric module to use pre-allocated struct se_cmd
descriptors and sense data buffer located at struct iscsi_cmd->se_cmd and
struct iscsi_cmd->sense_buffer respectively.

This includes updating iscsi_allocate_se_cmd() to use transport_init_se_cmd() for
the main iSCSI CDB RX side entry point.  It also includes some special case handling
in the struct iscsi_cmd I/O descriptor release path where previously assuming a NULL
struct iscsi_cmd->se_cmd in iscsi_target_tx_thread() and iscsi_release_commands_from_conn()
meant the struct iscsi_cmd is an iSCSI level PDU, and does not contain an
transport_init_se_cmd() initialized struct iscsi_cmd->se_cmd.

This also includes the conversion of a number of functions to use container_of()
instead of struct se_cmd->se_fabric_cmd_ptr to locate the struct iscsi_cmd.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target.c      |   27 +++++++++------
 drivers/target/lio-target/iscsi_target_core.h |   10 ++++-
 drivers/target/lio-target/iscsi_target_erl1.c |    8 ++--
 drivers/target/lio-target/iscsi_target_tmr.c  |   23 ++++---------
 drivers/target/lio-target/iscsi_target_util.c |   44 ++++++++++++-------------
 5 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index 2228e45..1b51c0e 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -1170,18 +1170,22 @@ char *iscsi_get_fabric_name(void)
 
 struct iscsi_cmd *iscsi_get_cmd(struct se_cmd *se_cmd)
 {
-	return (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+
+	return cmd;
 }
 
 u32 iscsi_get_task_tag(struct se_cmd *se_cmd)
 {
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+
 	return cmd->init_task_tag;
 }
 
 int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 {
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+
 	return cmd->i_state;
 }
 
@@ -4294,6 +4298,7 @@ int iscsi_target_tx_thread(void *arg)
 	struct iscsi_cmd *cmd = NULL;
 	struct iscsi_conn *conn;
 	struct iscsi_queue_req *qr = NULL;
+	struct se_cmd *se_cmd;
 	struct se_thread_set *ts = (struct se_thread_set *) arg;
 	struct se_unmap_sg unmap_sg;
 
@@ -4352,11 +4357,12 @@ get_immediate:
 				 * Determine if a struct se_cmd is assoicated with
 				 * this struct iscsi_cmd.
 				 */
-				if (!(SE_CMD(cmd)))
+				if (!(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
+				    !(cmd->tmr_req))
 					iscsi_release_cmd_to_pool(cmd);
 				else
-					transport_generic_free_cmd(
-							SE_CMD(cmd), 1, 1, 0);
+					transport_generic_free_cmd(SE_CMD(cmd),
+								1, 1, 0);
 				goto get_immediate;
 			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
 				spin_unlock_bh(&cmd->istate_lock);
@@ -4491,8 +4497,10 @@ check_rsp_state:
 				goto transport_err;
 			}
 
+			se_cmd = &cmd->se_cmd;
+
 			if (map_sg && !CONN_OPS(conn)->IFMarker &&
-			    T_TASK(cmd->se_cmd)->t_tasks_se_num) {
+			    T_TASK(se_cmd)->t_tasks_se_num) {
 				SE_CMD(cmd)->transport_map_SG_segments(&unmap_sg);
 				if (iscsi_fe_sendpage_sg(&unmap_sg, conn) < 0) {
 					conn->tx_response_queue = 0;
@@ -4816,10 +4824,9 @@ static void iscsi_release_commands_from_conn(struct iscsi_conn *conn)
 			 * transport_get_lun_for_cmd() failing from
 			 * iscsi_get_lun_for_cmd() in iscsi_handle_scsi_cmd().
 			 */
-			if (cmd->tmr_req && se_cmd &&
-			    se_cmd->transport_wait_for_tasks)
+			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
 				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
-			else if (se_cmd)
+			else if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)
 				transport_release_cmd_to_pool(se_cmd);
 			else
 				__iscsi_release_cmd_to_pool(cmd, sess);
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 418c425..7fa24b1 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -5,6 +5,7 @@
 #include <linux/configfs.h>
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <scsi/scsi_cmnd.h>
 #include <iscsi_target_version.h>	    /* get version definition */
 
 #include <target/target_core_base.h>
@@ -29,6 +30,8 @@
 #define ISCSI_MAX_TPGS			64
 /* Size of the Network Device Name Buffer */
 #define ISCSI_NETDEV_NAME_SIZE		12
+/* Size of iSCSI specific sense buffer */
+#define ISCSI_SENSE_BUFFER_LEN		TRANSPORT_SENSE_BUFFER + 2
 
 #include <iscsi_target_mib.h>
 
@@ -487,10 +490,13 @@ struct iscsi_cmd {
 	struct iscsi_cmd	*t_next;
 	/* Previous command in DAS transport list */
 	struct iscsi_cmd	*t_prev;
-	struct se_cmd		*se_cmd;
+	/* The TCM I/O descriptor that is accessed via container_of() */
+	struct se_cmd		se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char		sense_buffer[ISCSI_SENSE_BUFFER_LEN];
 }  ____cacheline_aligned;
 
-#define SE_CMD(cmd)		((struct se_cmd *)(cmd)->se_cmd)
+#define SE_CMD(cmd)		(&(cmd)->se_cmd)
 
 #include <iscsi_seq_and_pdu_list.h>
 
diff --git a/drivers/target/lio-target/iscsi_target_erl1.c b/drivers/target/lio-target/iscsi_target_erl1.c
index 6b6ad6d..6de09e1 100644
--- a/drivers/target/lio-target/iscsi_target_erl1.c
+++ b/drivers/target/lio-target/iscsi_target_erl1.c
@@ -443,7 +443,7 @@ static inline int iscsi_handle_recovery_datain(
 {
 	struct iscsi_conn *conn = CONN(cmd);
 	struct iscsi_datain_req *dr;
-	struct se_cmd *se_cmd = cmd->se_cmd;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	if (!(atomic_read(&T_TASK(se_cmd)->t_transport_complete))) {
 		printk(KERN_ERR "Ignoring ITT: 0x%08x Data SNACK\n",
@@ -991,7 +991,7 @@ int iscsi_execute_ooo_cmdsns(struct iscsi_session *sess)
  */
 int iscsi_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 {
-	struct se_cmd *se_cmd = cmd->se_cmd;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	int lr = 0;
 
 	spin_lock_bh(&cmd->istate_lock);
@@ -1040,7 +1040,7 @@ int iscsi_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
 				spin_unlock_bh(&cmd->istate_lock);
 				return transport_generic_handle_data(
-						cmd->se_cmd);
+						&cmd->se_cmd);
 			}
 			spin_unlock_bh(&cmd->istate_lock);
 
@@ -1079,7 +1079,7 @@ int iscsi_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			iscsi_start_dataout_timer(cmd, CONN(cmd));
 			spin_unlock_bh(&cmd->dataout_timeout_lock);
 		}
-		return transport_generic_handle_cdb(cmd->se_cmd);
+		return transport_generic_handle_cdb(&cmd->se_cmd);
 
 	case ISCSI_INIT_NOP_OUT:
 	case ISCSI_INIT_TEXT_CMND:
diff --git a/drivers/target/lio-target/iscsi_target_tmr.c b/drivers/target/lio-target/iscsi_target_tmr.c
index 21d62db..8a62939 100644
--- a/drivers/target/lio-target/iscsi_target_tmr.c
+++ b/drivers/target/lio-target/iscsi_target_tmr.c
@@ -71,11 +71,6 @@ u8 iscsi_tmr_abort_task(
 			(hdr->ref_cmd_sn <= SESS(conn)->max_cmd_sn)) ?
 				FUNCTION_COMPLETE : TASK_DOES_NOT_EXIST;
 	}
-	if (!(ref_cmd->se_cmd)) {
-		printk(KERN_ERR "ref_cmd->se_cmd for RefTaskTag: 0x%08x is"
-			" NULL!\n", hdr->ref_task_tag);
-		return TASK_DOES_NOT_EXIST;
-	}
 	if (ref_cmd->cmd_sn != hdr->ref_cmd_sn) {
 		printk(KERN_ERR "RefCmdSN 0x%08x does not equal"
 			" task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
@@ -84,7 +79,7 @@ u8 iscsi_tmr_abort_task(
 	}
 
 	se_tmr->ref_task_tag		= hdr->ref_task_tag;
-	se_tmr->ref_cmd			= ref_cmd->se_cmd;
+	se_tmr->ref_cmd			= &ref_cmd->se_cmd;
 	se_tmr->ref_task_lun		= hdr->lun;
 	tmr_req->ref_cmd_sn		= hdr->ref_cmd_sn;
 	tmr_req->exp_data_sn		= hdr->exp_data_sn;
@@ -182,10 +177,6 @@ u8 iscsi_tmr_task_reassign(
 			" connection recovery command list.\n",
 				hdr->ref_task_tag);
 		return TASK_DOES_NOT_EXIST;
-	} else if (!(ref_cmd->se_cmd)) {
-		printk(KERN_ERR "ref_cmd->se_cmd for RefTaskTag: 0x%08x is"
-			" NULL!\n", hdr->ref_task_tag);
-		return TASK_DOES_NOT_EXIST;
 	}
 	/*
 	 * Temporary check to prevent connection recovery for
@@ -200,7 +191,7 @@ u8 iscsi_tmr_task_reassign(
 	}
 
 	se_tmr->ref_task_tag		= hdr->ref_task_tag;
-	se_tmr->ref_cmd			= ref_cmd->se_cmd;
+	se_tmr->ref_cmd			= &ref_cmd->se_cmd;
 	se_tmr->ref_task_lun		= hdr->lun;
 	tmr_req->ref_cmd_sn		= hdr->ref_cmd_sn;
 	tmr_req->exp_data_sn		= hdr->exp_data_sn;
@@ -247,7 +238,7 @@ static int iscsi_task_reassign_complete_nop_out(
 {
 	struct se_tmr_req *se_tmr = tmr_req->se_tmr_req;
 	struct se_cmd *se_cmd = se_tmr->ref_cmd;
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
@@ -433,7 +424,7 @@ static int iscsi_task_reassign_complete_scsi_cmnd(
 {
 	struct se_tmr_req *se_tmr = tmr_req->se_tmr_req;
 	struct se_cmd *se_cmd = se_tmr->ref_cmd;
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
@@ -493,7 +484,7 @@ static int iscsi_task_reassign_complete(
 		return -1;
 	}
 	se_cmd = se_tmr->ref_cmd;
-	cmd = se_cmd->se_fabric_cmd_ptr;
+	cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->conn = conn;
 
@@ -633,7 +624,7 @@ int iscsi_task_reassign_prepare_write(
 {
 	struct se_tmr_req *se_tmr = tmr_req->se_tmr_req;
 	struct se_cmd *se_cmd = se_tmr->ref_cmd;
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 	struct iscsi_pdu *pdu = NULL;
 	struct iscsi_r2t *r2t = NULL, *r2t_tmp;
 	int first_incomplete_r2t = 1, i = 0;
@@ -869,7 +860,7 @@ int iscsi_check_task_reassign_expdatasn(
 {
 	struct se_tmr_req *se_tmr = tmr_req->se_tmr_req;
 	struct se_cmd *se_cmd = se_tmr->ref_cmd;
-	struct iscsi_cmd *ref_cmd = (struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct iscsi_cmd *ref_cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	if (ref_cmd->iscsi_opcode != ISCSI_INIT_SCSI_CMND)
 		return 0;
diff --git a/drivers/target/lio-target/iscsi_target_util.c b/drivers/target/lio-target/iscsi_target_util.c
index ad05952..91bbf80 100644
--- a/drivers/target/lio-target/iscsi_target_util.c
+++ b/drivers/target/lio-target/iscsi_target_util.c
@@ -277,6 +277,7 @@ struct iscsi_cmd *iscsi_allocate_se_cmd(
 	int iscsi_task_attr)
 {
 	struct iscsi_cmd *cmd;
+	struct se_cmd *se_cmd;
 	int sam_task_attr;
 
 	cmd = iscsi_allocate_cmd(conn);
@@ -302,21 +303,15 @@ struct iscsi_cmd *iscsi_allocate_se_cmd(
 			" TASK_ATTR_SIMPLE\n", iscsi_task_attr);
 		sam_task_attr = TASK_ATTR_SIMPLE;
 	}
+
+	se_cmd = &cmd->se_cmd;
 	/*
-	 * Use struct target_fabric_configfs->tf_ops for
-	 * lio_target_fabric_configfs
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
-	cmd->se_cmd = transport_alloc_se_cmd(
-			&lio_target_fabric_configfs->tf_ops,
-			SESS(conn)->se_sess, (void *)cmd, data_length,
-			data_direction, sam_task_attr);
-	if (!(cmd->se_cmd))
-		goto out;
-
+	transport_init_se_cmd(se_cmd, &lio_target_fabric_configfs->tf_ops,
+			SESS(conn)->se_sess, data_length, data_direction,
+			sam_task_attr, &cmd->sense_buffer[0]);
 	return cmd;
-out:
-	iscsi_release_cmd_to_pool(cmd);
-	return NULL;
 }
 
 /*	iscsi_allocate_tmr_req():
@@ -328,7 +323,7 @@ struct iscsi_cmd *iscsi_allocate_se_cmd_for_tmr(
 	u8 function)
 {
 	struct iscsi_cmd *cmd;
-	struct se_cmd *se_cmd = NULL;
+	struct se_cmd *se_cmd;
 
 	cmd = iscsi_allocate_cmd(conn);
 	if (!(cmd))
@@ -349,14 +344,13 @@ struct iscsi_cmd *iscsi_allocate_se_cmd_for_tmr(
 	if (function == TASK_REASSIGN)
 		return cmd;
 
-	cmd->se_cmd = transport_alloc_se_cmd(
-				&lio_target_fabric_configfs->tf_ops,
-				SESS(conn)->se_sess, (void *)cmd, 0,
-				SE_DIRECTION_NONE, TASK_ATTR_SIMPLE);
-	if (!(cmd->se_cmd))
-		goto out;
-
-	se_cmd = cmd->se_cmd;
+	se_cmd = &cmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
+	 */
+	transport_init_se_cmd(se_cmd, &lio_target_fabric_configfs->tf_ops,
+				SESS(conn)->se_sess, 0, SE_DIRECTION_NONE,
+				TASK_ATTR_SIMPLE, &cmd->sense_buffer[0]);
 
 	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd,
 				(void *)cmd->tmr_req, function);
@@ -1030,7 +1024,9 @@ void iscsi_release_cmd_direct(struct iscsi_cmd *cmd)
 
 void lio_release_cmd_direct(struct se_cmd *se_cmd)
 {
-	iscsi_release_cmd_direct((struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr);
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+
+	iscsi_release_cmd_direct(cmd);
 }
 
 /*	__iscsi_release_cmd_to_pool():
@@ -1074,7 +1070,9 @@ void iscsi_release_cmd_to_pool(struct iscsi_cmd *cmd)
 
 void lio_release_cmd_to_pool(struct se_cmd *se_cmd)
 {
-	iscsi_release_cmd_to_pool((struct iscsi_cmd *)se_cmd->se_fabric_cmd_ptr);
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+
+	iscsi_release_cmd_to_pool(cmd);
 }
 
 /*	iscsi_pack_lun():
-- 
1.5.6.5
