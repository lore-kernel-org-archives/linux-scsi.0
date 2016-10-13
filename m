From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 1/6] ibmvscsis: Rearrange functions for future patches
Date: Thu, 13 Oct 2016 11:02:38 -0500
Message-ID: <1476374563-13967-2-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch reorders functions in a manner necessary for a follow-on
patch.  It also makes some minor styling changes (mostly removing extra
spaces) and fixes some typos.

There are no code changes in this patch, with one exception: due to the
reordering of the functions, I needed to explicitly declare a function
at the top of the file.  However, this will be removed in the next patch,
since the code requiring the predeclaration will be removed.

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 796 ++++++++++++++++---------------
 1 file changed, 399 insertions(+), 397 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 642b739..01a430c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -22,7 +22,7 @@
  *
  ****************************************************************************/
 
-#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -61,6 +61,8 @@ static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 
 static void ibmvscsis_adapter_idle(struct scsi_info *vscsi);
 
+static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state);
+
 static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 				      struct srp_rsp *rsp)
 {
@@ -81,7 +83,7 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 		}
 	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
 		if (se_cmd->data_direction == DMA_TO_DEVICE) {
-			/*  residual data from an overflow write */
+			/* residual data from an overflow write */
 			rsp->flags = SRP_RSP_FLAG_DOOVER;
 			rsp->data_out_res_cnt = cpu_to_be32(residual_count);
 		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
@@ -101,7 +103,7 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
  * and the function returns TRUE.
  *
  * EXECUTION ENVIRONMENT:
- *      Interrupt or Process environment
+ *	Interrupt or Process environment
  */
 static bool connection_broken(struct scsi_info *vscsi)
 {
@@ -324,7 +326,7 @@ static struct viosrp_crq *ibmvscsis_cmd_q_dequeue(uint mask,
 }
 
 /**
- * ibmvscsis_send_init_message() -  send initialize message to the client
+ * ibmvscsis_send_init_message() - send initialize message to the client
  * @vscsi:	Pointer to our adapter structure
  * @format:	Which Init Message format to send
  *
@@ -382,13 +384,13 @@ static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *format)
 					      vscsi->cmd_q.base_addr);
 		if (crq) {
 			*format = (uint)(crq->format);
-			rc =  ERROR;
+			rc = ERROR;
 			crq->valid = INVALIDATE_CMD_RESP_EL;
 			dma_rmb();
 		}
 	} else {
 		*format = (uint)(crq->format);
-		rc =  ERROR;
+		rc = ERROR;
 		crq->valid = INVALIDATE_CMD_RESP_EL;
 		dma_rmb();
 	}
@@ -397,166 +399,6 @@ static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *format)
 }
 
 /**
- * ibmvscsis_establish_new_q() - Establish new CRQ queue
- * @vscsi:	Pointer to our adapter structure
- * @new_state:	New state being established after resetting the queue
- *
- * Must be called with interrupt lock held.
- */
-static long ibmvscsis_establish_new_q(struct scsi_info *vscsi,  uint new_state)
-{
-	long rc = ADAPT_SUCCESS;
-	uint format;
-
-	vscsi->flags &= PRESERVE_FLAG_FIELDS;
-	vscsi->rsp_q_timer.timer_pops = 0;
-	vscsi->debit = 0;
-	vscsi->credit = 0;
-
-	rc = vio_enable_interrupts(vscsi->dma_dev);
-	if (rc) {
-		pr_warn("reset_queue: failed to enable interrupts, rc %ld\n",
-			rc);
-		return rc;
-	}
-
-	rc = ibmvscsis_check_init_msg(vscsi, &format);
-	if (rc) {
-		dev_err(&vscsi->dev, "reset_queue: check_init_msg failed, rc %ld\n",
-			rc);
-		return rc;
-	}
-
-	if (format == UNUSED_FORMAT && new_state == WAIT_CONNECTION) {
-		rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
-		switch (rc) {
-		case H_SUCCESS:
-		case H_DROPPED:
-		case H_CLOSED:
-			rc = ADAPT_SUCCESS;
-			break;
-
-		case H_PARAMETER:
-		case H_HARDWARE:
-			break;
-
-		default:
-			vscsi->state = UNDEFINED;
-			rc = H_HARDWARE;
-			break;
-		}
-	}
-
-	return rc;
-}
-
-/**
- * ibmvscsis_reset_queue() - Reset CRQ Queue
- * @vscsi:	Pointer to our adapter structure
- * @new_state:	New state to establish after resetting the queue
- *
- * This function calls h_free_q and then calls h_reg_q and does all
- * of the bookkeeping to get us back to where we can communicate.
- *
- * Actually, we don't always call h_free_crq.  A problem was discovered
- * where one partition would close and reopen his queue, which would
- * cause his partner to get a transport event, which would cause him to
- * close and reopen his queue, which would cause the original partition
- * to get a transport event, etc., etc.  To prevent this, we don't
- * actually close our queue if the client initiated the reset, (i.e.
- * either we got a transport event or we have detected that the client's
- * queue is gone)
- *
- * EXECUTION ENVIRONMENT:
- *	Process environment, called with interrupt lock held
- */
-static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state)
-{
-	int bytes;
-	long rc = ADAPT_SUCCESS;
-
-	pr_debug("reset_queue: flags 0x%x\n", vscsi->flags);
-
-	/* don't reset, the client did it for us */
-	if (vscsi->flags & (CLIENT_FAILED | TRANS_EVENT)) {
-		vscsi->flags &=  PRESERVE_FLAG_FIELDS;
-		vscsi->rsp_q_timer.timer_pops = 0;
-		vscsi->debit = 0;
-		vscsi->credit = 0;
-		vscsi->state = new_state;
-		vio_enable_interrupts(vscsi->dma_dev);
-	} else {
-		rc = ibmvscsis_free_command_q(vscsi);
-		if (rc == ADAPT_SUCCESS) {
-			vscsi->state = new_state;
-
-			bytes = vscsi->cmd_q.size * PAGE_SIZE;
-			rc = h_reg_crq(vscsi->dds.unit_id,
-				       vscsi->cmd_q.crq_token, bytes);
-			if (rc == H_CLOSED || rc == H_SUCCESS) {
-				rc = ibmvscsis_establish_new_q(vscsi,
-							       new_state);
-			}
-
-			if (rc != ADAPT_SUCCESS) {
-				pr_debug("reset_queue: reg_crq rc %ld\n", rc);
-
-				vscsi->state = ERR_DISCONNECTED;
-				vscsi->flags |=  RESPONSE_Q_DOWN;
-				ibmvscsis_free_command_q(vscsi);
-			}
-		} else {
-			vscsi->state = ERR_DISCONNECTED;
-			vscsi->flags |= RESPONSE_Q_DOWN;
-		}
-	}
-}
-
-/**
- * ibmvscsis_free_cmd_resources() - Free command resources
- * @vscsi:	Pointer to our adapter structure
- * @cmd:	Command which is not longer in use
- *
- * Must be called with interrupt lock held.
- */
-static void ibmvscsis_free_cmd_resources(struct scsi_info *vscsi,
-					 struct ibmvscsis_cmd *cmd)
-{
-	struct iu_entry *iue = cmd->iue;
-
-	switch (cmd->type) {
-	case TASK_MANAGEMENT:
-	case SCSI_CDB:
-		/*
-		 * When the queue goes down this value is cleared, so it
-		 * cannot be cleared in this general purpose function.
-		 */
-		if (vscsi->debit)
-			vscsi->debit -= 1;
-		break;
-	case ADAPTER_MAD:
-		vscsi->flags &= ~PROCESSING_MAD;
-		break;
-	case UNSET_TYPE:
-		break;
-	default:
-		dev_err(&vscsi->dev, "free_cmd_resources unknown type %d\n",
-			cmd->type);
-		break;
-	}
-
-	cmd->iue = NULL;
-	list_add_tail(&cmd->list, &vscsi->free_cmd);
-	srp_iu_put(iue);
-
-	if (list_empty(&vscsi->active_q) && list_empty(&vscsi->schedule_q) &&
-	    list_empty(&vscsi->waiting_rsp) && (vscsi->flags & WAIT_FOR_IDLE)) {
-		vscsi->flags &= ~WAIT_FOR_IDLE;
-		complete(&vscsi->wait_idle);
-	}
-}
-
-/**
  * ibmvscsis_disconnect() - Helper function to disconnect
  * @work:	Pointer to work_struct, gives access to our adapter structure
  *
@@ -589,7 +431,7 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 	 * should transitition to the new state
 	 */
 	switch (vscsi->state) {
-	/*  Should never be called while in this state. */
+	/* Should never be called while in this state. */
 	case NO_QUEUE:
 	/*
 	 * Can never transition from this state;
@@ -725,84 +567,394 @@ static void ibmvscsis_disconnect(struct work_struct *work)
  * the new state (if the one passed in is more "severe" than the
  * previous one).
  *
- * PRECONDITION:
- *	interrupt lock is held
+ * PRECONDITION:
+ *	interrupt lock is held
+ */
+static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_state,
+				      uint flag_bits)
+{
+	uint state;
+
+	/* check the validity of the new state */
+	switch (new_state) {
+	case UNCONFIGURING:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case WAIT_IDLE:
+		break;
+
+	default:
+		dev_err(&vscsi->dev, "post_disconnect: Invalid new state %d\n",
+			new_state);
+		return;
+	}
+
+	vscsi->flags |= flag_bits;
+
+	pr_debug("post_disconnect: new_state 0x%x, flag_bits 0x%x, vscsi->flags 0x%x, state %hx\n",
+		 new_state, flag_bits, vscsi->flags, vscsi->state);
+
+	if (!(vscsi->flags & (DISCONNECT_SCHEDULED | SCHEDULE_DISCONNECT))) {
+		vscsi->flags |= SCHEDULE_DISCONNECT;
+		vscsi->new_state = new_state;
+
+		INIT_WORK(&vscsi->proc_work, ibmvscsis_disconnect);
+		(void)queue_work(vscsi->work_q, &vscsi->proc_work);
+	} else {
+		if (vscsi->new_state)
+			state = vscsi->new_state;
+		else
+			state = vscsi->state;
+
+		switch (state) {
+		case NO_QUEUE:
+		case UNCONFIGURING:
+			break;
+
+		case ERR_DISCONNECTED:
+		case ERR_DISCONNECT:
+		case UNDEFINED:
+			if (new_state == UNCONFIGURING)
+				vscsi->new_state = new_state;
+			break;
+
+		case ERR_DISCONNECT_RECONNECT:
+			switch (new_state) {
+			case UNCONFIGURING:
+			case ERR_DISCONNECT:
+				vscsi->new_state = new_state;
+				break;
+			default:
+				break;
+			}
+			break;
+
+		case WAIT_ENABLED:
+		case PART_UP_WAIT_ENAB:
+		case WAIT_IDLE:
+		case WAIT_CONNECTION:
+		case CONNECTED:
+		case SRP_PROCESSING:
+			vscsi->new_state = new_state;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	pr_debug("Leaving post_disconnect: flags 0x%x, new_state 0x%x\n",
+		 vscsi->flags, vscsi->new_state);
+}
+
+/**
+ * ibmvscsis_handle_init_compl_msg() - Respond to an Init Complete Message
+ * @vscsi:	Pointer to our adapter structure
+ *
+ * Must be called with interrupt lock held.
+ */
+static long ibmvscsis_handle_init_compl_msg(struct scsi_info *vscsi)
+{
+	long rc = ADAPT_SUCCESS;
+
+	switch (vscsi->state) {
+	case NO_QUEUE:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case ERR_DISCONNECTED:
+	case UNCONFIGURING:
+	case UNDEFINED:
+		rc = ERROR;
+		break;
+
+	case WAIT_CONNECTION:
+		vscsi->state = CONNECTED;
+		break;
+
+	case WAIT_IDLE:
+	case SRP_PROCESSING:
+	case CONNECTED:
+	case WAIT_ENABLED:
+	case PART_UP_WAIT_ENAB:
+	default:
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init compl msg\n",
+			vscsi->state);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_handle_init_msg() - Respond to an Init Message
+ * @vscsi:	Pointer to our adapter structure
+ *
+ * Must be called with interrupt lock held.
+ */
+static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
+{
+	long rc = ADAPT_SUCCESS;
+
+	switch (vscsi->state) {
+	case WAIT_ENABLED:
+		vscsi->state = PART_UP_WAIT_ENAB;
+		break;
+
+	case WAIT_CONNECTION:
+		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
+		switch (rc) {
+		case H_SUCCESS:
+			vscsi->state = CONNECTED;
+			break;
+
+		case H_PARAMETER:
+			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
+				rc);
+			ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+			break;
+
+		case H_DROPPED:
+			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
+				rc);
+			rc = ERROR;
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+			break;
+
+		case H_CLOSED:
+			pr_warn("init_msg: failed to send, rc %ld\n", rc);
+			rc = 0;
+			break;
+		}
+		break;
+
+	case UNDEFINED:
+		rc = ERROR;
+		break;
+
+	case UNCONFIGURING:
+		break;
+
+	case PART_UP_WAIT_ENAB:
+	case CONNECTED:
+	case SRP_PROCESSING:
+	case WAIT_IDLE:
+	case NO_QUEUE:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case ERR_DISCONNECTED:
+	default:
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init msg\n",
+			vscsi->state);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_init_msg() - Respond to an init message
+ * @vscsi:	Pointer to our adapter structure
+ * @crq:	Pointer to CRQ element containing the Init Message
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt, interrupt lock held
+ */
+static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_crq *crq)
+{
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("init_msg: state 0x%hx\n", vscsi->state);
+
+	rc = h_vioctl(vscsi->dds.unit_id, H_GET_PARTNER_INFO,
+		      (u64)vscsi->map_ioba | ((u64)PAGE_SIZE << 32), 0, 0, 0,
+		      0);
+	if (rc == H_SUCCESS) {
+		vscsi->client_data.partition_number =
+			be64_to_cpu(*(u64 *)vscsi->map_buf);
+		pr_debug("init_msg, part num %d\n",
+			 vscsi->client_data.partition_number);
+	} else {
+		pr_debug("init_msg h_vioctl rc %ld\n", rc);
+		rc = ADAPT_SUCCESS;
+	}
+
+	if (crq->format == INIT_MSG) {
+		rc = ibmvscsis_handle_init_msg(vscsi);
+	} else if (crq->format == INIT_COMPLETE_MSG) {
+		rc = ibmvscsis_handle_init_compl_msg(vscsi);
+	} else {
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid format %d\n",
+			(uint)crq->format);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_establish_new_q() - Establish new CRQ queue
+ * @vscsi:	Pointer to our adapter structure
+ * @new_state:	New state being established after resetting the queue
+ *
+ * Must be called with interrupt lock held.
+ */
+static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
+{
+	long rc = ADAPT_SUCCESS;
+	uint format;
+
+	vscsi->flags &= PRESERVE_FLAG_FIELDS;
+	vscsi->rsp_q_timer.timer_pops = 0;
+	vscsi->debit = 0;
+	vscsi->credit = 0;
+
+	rc = vio_enable_interrupts(vscsi->dma_dev);
+	if (rc) {
+		pr_warn("reset_queue: failed to enable interrupts, rc %ld\n",
+			rc);
+		return rc;
+	}
+
+	rc = ibmvscsis_check_init_msg(vscsi, &format);
+	if (rc) {
+		dev_err(&vscsi->dev, "reset_queue: check_init_msg failed, rc %ld\n",
+			rc);
+		return rc;
+	}
+
+	if (format == UNUSED_FORMAT && new_state == WAIT_CONNECTION) {
+		rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
+		switch (rc) {
+		case H_SUCCESS:
+		case H_DROPPED:
+		case H_CLOSED:
+			rc = ADAPT_SUCCESS;
+			break;
+
+		case H_PARAMETER:
+		case H_HARDWARE:
+			break;
+
+		default:
+			vscsi->state = UNDEFINED;
+			rc = H_HARDWARE;
+			break;
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_reset_queue() - Reset CRQ Queue
+ * @vscsi:	Pointer to our adapter structure
+ * @new_state:	New state to establish after resetting the queue
+ *
+ * This function calls h_free_q and then calls h_reg_q and does all
+ * of the bookkeeping to get us back to where we can communicate.
+ *
+ * Actually, we don't always call h_free_crq.  A problem was discovered
+ * where one partition would close and reopen his queue, which would
+ * cause his partner to get a transport event, which would cause him to
+ * close and reopen his queue, which would cause the original partition
+ * to get a transport event, etc., etc.  To prevent this, we don't
+ * actually close our queue if the client initiated the reset, (i.e.
+ * either we got a transport event or we have detected that the client's
+ * queue is gone)
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process environment, called with interrupt lock held
+ */
+static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state)
+{
+	int bytes;
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("reset_queue: flags 0x%x\n", vscsi->flags);
+
+	/* don't reset, the client did it for us */
+	if (vscsi->flags & (CLIENT_FAILED | TRANS_EVENT)) {
+		vscsi->flags &= PRESERVE_FLAG_FIELDS;
+		vscsi->rsp_q_timer.timer_pops = 0;
+		vscsi->debit = 0;
+		vscsi->credit = 0;
+		vscsi->state = new_state;
+		vio_enable_interrupts(vscsi->dma_dev);
+	} else {
+		rc = ibmvscsis_free_command_q(vscsi);
+		if (rc == ADAPT_SUCCESS) {
+			vscsi->state = new_state;
+
+			bytes = vscsi->cmd_q.size * PAGE_SIZE;
+			rc = h_reg_crq(vscsi->dds.unit_id,
+				       vscsi->cmd_q.crq_token, bytes);
+			if (rc == H_CLOSED || rc == H_SUCCESS) {
+				rc = ibmvscsis_establish_new_q(vscsi,
+							       new_state);
+			}
+
+			if (rc != ADAPT_SUCCESS) {
+				pr_debug("reset_queue: reg_crq rc %ld\n", rc);
+
+				vscsi->state = ERR_DISCONNECTED;
+				vscsi->flags |= RESPONSE_Q_DOWN;
+				ibmvscsis_free_command_q(vscsi);
+			}
+		} else {
+			vscsi->state = ERR_DISCONNECTED;
+			vscsi->flags |= RESPONSE_Q_DOWN;
+		}
+	}
+}
+
+/**
+ * ibmvscsis_free_cmd_resources() - Free command resources
+ * @vscsi:	Pointer to our adapter structure
+ * @cmd:	Command which is not longer in use
+ *
+ * Must be called with interrupt lock held.
  */
-static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_state,
-				      uint flag_bits)
+static void ibmvscsis_free_cmd_resources(struct scsi_info *vscsi,
+					 struct ibmvscsis_cmd *cmd)
 {
-	uint state;
+	struct iu_entry *iue = cmd->iue;
 
-	/* check the validity of the new state */
-	switch (new_state) {
-	case UNCONFIGURING:
-	case ERR_DISCONNECT:
-	case ERR_DISCONNECT_RECONNECT:
-	case WAIT_IDLE:
+	switch (cmd->type) {
+	case TASK_MANAGEMENT:
+	case SCSI_CDB:
+		/*
+		 * When the queue goes down this value is cleared, so it
+		 * cannot be cleared in this general purpose function.
+		 */
+		if (vscsi->debit)
+			vscsi->debit -= 1;
+		break;
+	case ADAPTER_MAD:
+		vscsi->flags &= ~PROCESSING_MAD;
+		break;
+	case UNSET_TYPE:
 		break;
-
 	default:
-		dev_err(&vscsi->dev, "post_disconnect: Invalid new state %d\n",
-			new_state);
-		return;
+		dev_err(&vscsi->dev, "free_cmd_resources unknown type %d\n",
+			cmd->type);
+		break;
 	}
 
-	vscsi->flags |= flag_bits;
-
-	pr_debug("post_disconnect: new_state 0x%x, flag_bits 0x%x, vscsi->flags 0x%x, state %hx\n",
-		 new_state, flag_bits, vscsi->flags, vscsi->state);
-
-	if (!(vscsi->flags & (DISCONNECT_SCHEDULED | SCHEDULE_DISCONNECT))) {
-		vscsi->flags |= SCHEDULE_DISCONNECT;
-		vscsi->new_state = new_state;
-
-		INIT_WORK(&vscsi->proc_work, ibmvscsis_disconnect);
-		(void)queue_work(vscsi->work_q, &vscsi->proc_work);
-	} else {
-		if (vscsi->new_state)
-			state = vscsi->new_state;
-		else
-			state = vscsi->state;
-
-		switch (state) {
-		case NO_QUEUE:
-		case UNCONFIGURING:
-			break;
-
-		case ERR_DISCONNECTED:
-		case ERR_DISCONNECT:
-		case UNDEFINED:
-			if (new_state == UNCONFIGURING)
-				vscsi->new_state = new_state;
-			break;
-
-		case ERR_DISCONNECT_RECONNECT:
-			switch (new_state) {
-			case UNCONFIGURING:
-			case ERR_DISCONNECT:
-				vscsi->new_state = new_state;
-				break;
-			default:
-				break;
-			}
-			break;
-
-		case WAIT_ENABLED:
-		case PART_UP_WAIT_ENAB:
-		case WAIT_IDLE:
-		case WAIT_CONNECTION:
-		case CONNECTED:
-		case SRP_PROCESSING:
-			vscsi->new_state = new_state;
-			break;
+	cmd->iue = NULL;
+	list_add_tail(&cmd->list, &vscsi->free_cmd);
+	srp_iu_put(iue);
 
-		default:
-			break;
-		}
+	if (list_empty(&vscsi->active_q) && list_empty(&vscsi->schedule_q) &&
+	    list_empty(&vscsi->waiting_rsp) && (vscsi->flags & WAIT_FOR_IDLE)) {
+		vscsi->flags &= ~WAIT_FOR_IDLE;
+		complete(&vscsi->wait_idle);
 	}
-
-	pr_debug("Leaving post_disconnect: flags 0x%x, new_state 0x%x\n",
-		 vscsi->flags, vscsi->new_state);
 }
 
 /**
@@ -895,7 +1047,7 @@ static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 		}
 	}
 
-	rc =  vscsi->flags & SCHEDULE_DISCONNECT;
+	rc = vscsi->flags & SCHEDULE_DISCONNECT;
 
 	pr_debug("Leaving trans_event: flags 0x%x, state 0x%hx, rc %ld\n",
 		 vscsi->flags, vscsi->state, rc);
@@ -1220,7 +1372,7 @@ static long ibmvscsis_copy_crq_packet(struct scsi_info *vscsi,
  * @iue:	Information Unit containing the Adapter Info MAD request
  *
  * EXECUTION ENVIRONMENT:
- *	Interrupt adpater lock is held
+ *	Interrupt adapter lock is held
  */
 static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 				   struct iu_entry *iue)
@@ -1691,7 +1843,7 @@ static void ibmvscsis_send_mad_resp(struct scsi_info *vscsi,
  * @crq:	Pointer to the CRQ entry containing the MAD request
  *
  * EXECUTION ENVIRONMENT:
- *	Interrupt  called with adapter lock held
+ *	Interrupt, called with adapter lock held
  */
 static long ibmvscsis_mad(struct scsi_info *vscsi, struct viosrp_crq *crq)
 {
@@ -1864,7 +2016,7 @@ static long ibmvscsis_srp_login_rej(struct scsi_info *vscsi,
 		break;
 	case H_PERMISSION:
 		if (connection_broken(vscsi))
-			flag_bits =  RESPONSE_Q_DOWN | CLIENT_FAILED;
+			flag_bits = RESPONSE_Q_DOWN | CLIENT_FAILED;
 		dev_err(&vscsi->dev, "login_rej: error copying to client, rc %ld\n",
 			rc);
 		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT,
@@ -2187,156 +2339,6 @@ static long ibmvscsis_ping_response(struct scsi_info *vscsi)
 }
 
 /**
- * ibmvscsis_handle_init_compl_msg() - Respond to an Init Complete Message
- * @vscsi:	Pointer to our adapter structure
- *
- * Must be called with interrupt lock held.
- */
-static long ibmvscsis_handle_init_compl_msg(struct scsi_info *vscsi)
-{
-	long rc = ADAPT_SUCCESS;
-
-	switch (vscsi->state) {
-	case NO_QUEUE:
-	case ERR_DISCONNECT:
-	case ERR_DISCONNECT_RECONNECT:
-	case ERR_DISCONNECTED:
-	case UNCONFIGURING:
-	case UNDEFINED:
-		rc = ERROR;
-		break;
-
-	case WAIT_CONNECTION:
-		vscsi->state = CONNECTED;
-		break;
-
-	case WAIT_IDLE:
-	case SRP_PROCESSING:
-	case CONNECTED:
-	case WAIT_ENABLED:
-	case PART_UP_WAIT_ENAB:
-	default:
-		rc = ERROR;
-		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init compl msg\n",
-			vscsi->state);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-		break;
-	}
-
-	return rc;
-}
-
-/**
- * ibmvscsis_handle_init_msg() - Respond to an Init Message
- * @vscsi:	Pointer to our adapter structure
- *
- * Must be called with interrupt lock held.
- */
-static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
-{
-	long rc = ADAPT_SUCCESS;
-
-	switch (vscsi->state) {
-	case WAIT_ENABLED:
-		vscsi->state = PART_UP_WAIT_ENAB;
-		break;
-
-	case WAIT_CONNECTION:
-		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
-		switch (rc) {
-		case H_SUCCESS:
-			vscsi->state = CONNECTED;
-			break;
-
-		case H_PARAMETER:
-			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
-				rc);
-			ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
-			break;
-
-		case H_DROPPED:
-			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
-				rc);
-			rc = ERROR;
-			ibmvscsis_post_disconnect(vscsi,
-						  ERR_DISCONNECT_RECONNECT, 0);
-			break;
-
-		case H_CLOSED:
-			pr_warn("init_msg: failed to send, rc %ld\n", rc);
-			rc = 0;
-			break;
-		}
-		break;
-
-	case UNDEFINED:
-		rc = ERROR;
-		break;
-
-	case UNCONFIGURING:
-		break;
-
-	case PART_UP_WAIT_ENAB:
-	case CONNECTED:
-	case SRP_PROCESSING:
-	case WAIT_IDLE:
-	case NO_QUEUE:
-	case ERR_DISCONNECT:
-	case ERR_DISCONNECT_RECONNECT:
-	case ERR_DISCONNECTED:
-	default:
-		rc = ERROR;
-		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init msg\n",
-			vscsi->state);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-		break;
-	}
-
-	return rc;
-}
-
-/**
- * ibmvscsis_init_msg() - Respond to an init message
- * @vscsi:	Pointer to our adapter structure
- * @crq:	Pointer to CRQ element containing the Init Message
- *
- * EXECUTION ENVIRONMENT:
- *	Interrupt, interrupt lock held
- */
-static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_crq *crq)
-{
-	long rc = ADAPT_SUCCESS;
-
-	pr_debug("init_msg: state 0x%hx\n", vscsi->state);
-
-	rc = h_vioctl(vscsi->dds.unit_id, H_GET_PARTNER_INFO,
-		      (u64)vscsi->map_ioba | ((u64)PAGE_SIZE << 32), 0, 0, 0,
-		      0);
-	if (rc == H_SUCCESS) {
-		vscsi->client_data.partition_number =
-			be64_to_cpu(*(u64 *)vscsi->map_buf);
-		pr_debug("init_msg, part num %d\n",
-			 vscsi->client_data.partition_number);
-	} else {
-		pr_debug("init_msg h_vioctl rc %ld\n", rc);
-		rc = ADAPT_SUCCESS;
-	}
-
-	if (crq->format == INIT_MSG) {
-		rc = ibmvscsis_handle_init_msg(vscsi);
-	} else if (crq->format == INIT_COMPLETE_MSG) {
-		rc = ibmvscsis_handle_init_compl_msg(vscsi);
-	} else {
-		rc = ERROR;
-		dev_err(&vscsi->dev, "init_msg: invalid format %d\n",
-			(uint)crq->format);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-	}
-
-	return rc;
-}
-
-/**
  * ibmvscsis_parse_command() - Parse an element taken from the cmd rsp queue.
  * @vscsi:	Pointer to our adapter structure
  * @crq:	Pointer to CRQ element containing the SRP request
@@ -2391,7 +2393,7 @@ static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 		break;
 
 	case VALID_TRANS_EVENT:
-		rc =  ibmvscsis_trans_event(vscsi, crq);
+		rc = ibmvscsis_trans_event(vscsi, crq);
 		break;
 
 	case VALID_INIT_MSG:
@@ -3270,7 +3272,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
 	/*
 	 * if we are in a path where we are waiting for all pending commands
 	 * to complete because we received a transport event and anything in
-	 * the command queue is for a new connection,  do nothing
+	 * the command queue is for a new connection, do nothing
 	 */
 	if (TARGET_STOP(vscsi)) {
 		vio_enable_interrupts(vscsi->dma_dev);
@@ -3314,7 +3316,7 @@ cmd_work:
 				 * everything but transport events on the queue
 				 *
 				 * need to decrement the queue index so we can
-				 * look at the elment again
+				 * look at the element again
 				 */
 				if (vscsi->cmd_q.index)
 					vscsi->cmd_q.index -= 1;
@@ -3983,10 +3985,10 @@ static struct attribute *ibmvscsis_dev_attrs[] = {
 ATTRIBUTE_GROUPS(ibmvscsis_dev);
 
 static struct class ibmvscsis_class = {
-	.name           = "ibmvscsis",
-	.dev_release    = ibmvscsis_dev_release,
-	.class_attrs    = ibmvscsis_class_attrs,
-	.dev_groups     = ibmvscsis_dev_groups,
+	.name		= "ibmvscsis",
+	.dev_release	= ibmvscsis_dev_release,
+	.class_attrs	= ibmvscsis_class_attrs,
+	.dev_groups	= ibmvscsis_dev_groups,
 };
 
 static struct vio_device_id ibmvscsis_device_table[] = {
-- 
2.5.0
