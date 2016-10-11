From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v1 1/3] Synchronization of cmds during termination conditions
Date: Tue, 11 Oct 2016 17:58:03 -0500
Message-ID: <1476226685-2276-2-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1082 +++++++++++++-----------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |    5 +-
 2 files changed, 486 insertions(+), 601 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 642b739..34f758c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -22,7 +22,7 @@
  *
  ****************************************************************************/
 
-#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -81,7 +81,7 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 		}
 	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
 		if (se_cmd->data_direction == DMA_TO_DEVICE) {
-			/*  residual data from an overflow write */
+			/* residual data from an overflow write */
 			rsp->flags = SRP_RSP_FLAG_DOOVER;
 			rsp->data_out_res_cnt = cpu_to_be32(residual_count);
 		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
@@ -101,7 +101,7 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
  * and the function returns TRUE.
  *
  * EXECUTION ENVIRONMENT:
- *      Interrupt or Process environment
+ *	Interrupt or Process environment
  */
 static bool connection_broken(struct scsi_info *vscsi)
 {
@@ -324,7 +324,7 @@ static struct viosrp_crq *ibmvscsis_cmd_q_dequeue(uint mask,
 }
 
 /**
- * ibmvscsis_send_init_message() -  send initialize message to the client
+ * ibmvscsis_send_init_message() - send initialize message to the client
  * @vscsi:	Pointer to our adapter structure
  * @format:	Which Init Message format to send
  *
@@ -382,13 +382,13 @@ static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *format)
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
@@ -397,166 +397,6 @@ static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *format)
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
@@ -575,7 +415,6 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 					       proc_work);
 	u16 new_state;
 	bool wait_idle = false;
-	long rc = ADAPT_SUCCESS;
 
 	spin_lock_bh(&vscsi->intr_lock);
 	new_state = vscsi->new_state;
@@ -589,7 +428,7 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 	 * should transitition to the new state
 	 */
 	switch (vscsi->state) {
-	/*  Should never be called while in this state. */
+	/* Should never be called while in this state. */
 	case NO_QUEUE:
 	/*
 	 * Can never transition from this state;
@@ -628,30 +467,24 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 			vscsi->state = new_state;
 		break;
 
-	/*
-	 * If this is a transition into an error state.
-	 * a client is attempting to establish a connection
-	 * and has violated the RPA protocol.
-	 * There can be nothing pending on the adapter although
-	 * there can be requests in the command queue.
-	 */
 	case WAIT_ENABLED:
-	case PART_UP_WAIT_ENAB:
 		switch (new_state) {
-		case ERR_DISCONNECT:
-			vscsi->flags |= RESPONSE_Q_DOWN;
+		case UNCONFIGURING:
 			vscsi->state = new_state;
+			vscsi->flags |= RESPONSE_Q_DOWN;
 			vscsi->flags &= ~(SCHEDULE_DISCONNECT |
 					  DISCONNECT_SCHEDULED);
-			ibmvscsis_free_command_q(vscsi);
-			break;
-		case ERR_DISCONNECT_RECONNECT:
-			ibmvscsis_reset_queue(vscsi, WAIT_ENABLED);
+			dma_rmb();
+			if (vscsi->flags & CFG_SLEEPING) {
+				vscsi->flags &= ~CFG_SLEEPING;
+				complete(&vscsi->unconfig);
+			}
 			break;
 
 		/* should never happen */
+		case ERR_DISCONNECT:
+		case ERR_DISCONNECT_RECONNECT:
 		case WAIT_IDLE:
-			rc = ERROR;
 			dev_err(&vscsi->dev, "disconnect: invalid state %d for WAIT_IDLE\n",
 				vscsi->state);
 			break;
@@ -660,6 +493,13 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 
 	case WAIT_IDLE:
 		switch (new_state) {
+		case UNCONFIGURING:
+			vscsi->flags |= RESPONSE_Q_DOWN;
+			vscsi->state = new_state;
+			vscsi->flags &= ~(SCHEDULE_DISCONNECT |
+					  DISCONNECT_SCHEDULED);
+			ibmvscsis_free_command_q(vscsi);
+			break;
 		case ERR_DISCONNECT:
 		case ERR_DISCONNECT_RECONNECT:
 			vscsi->state = new_state;
@@ -764,45 +604,349 @@ static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_state,
 		else
 			state = vscsi->state;
 
-		switch (state) {
-		case NO_QUEUE:
-		case UNCONFIGURING:
-			break;
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
+	case WAIT_ENABLED:
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
+ *
+ * Must be called with interrupt lock held.
+ */
+static long ibmvscsis_establish_new_q(struct scsi_info *vscsi)
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
+		pr_warn("establish_new_q: failed to enable interrupts, rc %ld\n",
+			rc);
+		return rc;
+	}
+
+	rc = ibmvscsis_check_init_msg(vscsi, &format);
+	if (rc) {
+		dev_err(&vscsi->dev, "establish_new_q: check_init_msg failed, rc %ld\n",
+			rc);
+		return rc;
+	}
+
+	if (format == UNUSED_FORMAT) {
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
+	else if (format == INIT_MSG) {
+		rc = ibmvscsis_handle_init_msg(vscsi);
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_reset_queue() - Reset CRQ Queue
+ * @vscsi:	Pointer to our adapter structure
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
+static void ibmvscsis_reset_queue(struct scsi_info *vscsi)
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
+		vscsi->state = WAIT_CONNECTION;
+		vio_enable_interrupts(vscsi->dma_dev);
+	} else {
+		rc = ibmvscsis_free_command_q(vscsi);
+		if (rc == ADAPT_SUCCESS) {
+			vscsi->state = WAIT_CONNECTION;
+
+			bytes = vscsi->cmd_q.size * PAGE_SIZE;
+			rc = h_reg_crq(vscsi->dds.unit_id,
+				       vscsi->cmd_q.crq_token, bytes);
+			if (rc == H_CLOSED || rc == H_SUCCESS) {
+				rc = ibmvscsis_establish_new_q(vscsi);
+			}
 
-		case ERR_DISCONNECTED:
-		case ERR_DISCONNECT:
-		case UNDEFINED:
-			if (new_state == UNCONFIGURING)
-				vscsi->new_state = new_state;
-			break;
+			if (rc != ADAPT_SUCCESS) {
+				pr_debug("reset_queue: reg_crq rc %ld\n", rc);
 
-		case ERR_DISCONNECT_RECONNECT:
-			switch (new_state) {
-			case UNCONFIGURING:
-			case ERR_DISCONNECT:
-				vscsi->new_state = new_state;
-				break;
-			default:
-				break;
+				vscsi->state = ERR_DISCONNECTED;
+				vscsi->flags |= RESPONSE_Q_DOWN;
+				ibmvscsis_free_command_q(vscsi);
 			}
-			break;
+		} else {
+			vscsi->state = ERR_DISCONNECTED;
+			vscsi->flags |= RESPONSE_Q_DOWN;
+		}
+	}
+}
 
-		case WAIT_ENABLED:
-		case PART_UP_WAIT_ENAB:
-		case WAIT_IDLE:
-		case WAIT_CONNECTION:
-		case CONNECTED:
-		case SRP_PROCESSING:
-			vscsi->new_state = new_state;
-			break;
+/**
+ * ibmvscsis_free_cmd_resources() - Free command resources
+ * @vscsi:	Pointer to our adapter structure
+ * @cmd:	Command which is not longer in use
+ *
+ * Must be called with interrupt lock held.
+ */
+static void ibmvscsis_free_cmd_resources(struct scsi_info *vscsi,
+					 struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
 
-		default:
-			break;
-		}
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
+		break;
+	default:
+		dev_err(&vscsi->dev, "free_cmd_resources unknown type %d\n",
+			cmd->type);
+		break;
 	}
 
-	pr_debug("Leaving post_disconnect: flags 0x%x, new_state 0x%x\n",
-		 vscsi->flags, vscsi->new_state);
+	cmd->iue = NULL;
+	list_add_tail(&cmd->list, &vscsi->free_cmd);
+	srp_iu_put(iue);
+
+	if (list_empty(&vscsi->active_q) && list_empty(&vscsi->schedule_q) &&
+	    list_empty(&vscsi->waiting_rsp) && (vscsi->flags & WAIT_FOR_IDLE)) {
+		vscsi->flags &= ~WAIT_FOR_IDLE;
+		complete(&vscsi->wait_idle);
+	}
 }
 
 /**
@@ -863,10 +1007,6 @@ static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 						   TRANS_EVENT));
 			break;
 
-		case PART_UP_WAIT_ENAB:
-			vscsi->state = WAIT_ENABLED;
-			break;
-
 		case SRP_PROCESSING:
 			if ((vscsi->debit > 0) ||
 			    !list_empty(&vscsi->schedule_q) ||
@@ -895,7 +1035,7 @@ static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 		}
 	}
 
-	rc =  vscsi->flags & SCHEDULE_DISCONNECT;
+	rc = vscsi->flags & SCHEDULE_DISCONNECT;
 
 	pr_debug("Leaving trans_event: flags 0x%x, state 0x%hx, rc %ld\n",
 		 vscsi->flags, vscsi->state, rc);
@@ -1066,16 +1206,28 @@ static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
 		free_qs = true;
 
 	switch (vscsi->state) {
+	case UNCONFIGURING:
+		ibmvscsis_free_command_q(vscsi);
+		dma_rmb();
+		isync();
+		if (vscsi->flags & CFG_SLEEPING) {
+			vscsi->flags &= ~CFG_SLEEPING;
+			complete(&vscsi->unconfig);
+		}
+		break;
 	case ERR_DISCONNECT_RECONNECT:
-		ibmvscsis_reset_queue(vscsi, WAIT_CONNECTION);
+		ibmvscsis_reset_queue(vscsi);
 		pr_debug("adapter_idle, disc_rec: flags 0x%x\n", vscsi->flags);
 		break;
 
 	case ERR_DISCONNECT:
 		ibmvscsis_free_command_q(vscsi);
-		vscsi->flags &= ~DISCONNECT_SCHEDULED;
+		vscsi->flags &= ~(SCHEDULE_DISCONNECT | DISCONNECT_SCHEDULED);
 		vscsi->flags |= RESPONSE_Q_DOWN;
-		vscsi->state = ERR_DISCONNECTED;
+		if (vscsi->tport.enabled)
+			vscsi->state = ERR_DISCONNECTED;
+		else
+			vscsi->state = WAIT_ENABLED;
 		pr_debug("adapter_idle, disc: flags 0x%x, state 0x%hx\n",
 			 vscsi->flags, vscsi->state);
 		break;
@@ -1220,7 +1372,7 @@ static long ibmvscsis_copy_crq_packet(struct scsi_info *vscsi,
  * @iue:	Information Unit containing the Adapter Info MAD request
  *
  * EXECUTION ENVIRONMENT:
- *	Interrupt adpater lock is held
+ *	Interrupt adapter lock is held
  */
 static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 				   struct iu_entry *iue)
@@ -1620,8 +1772,8 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					be64_to_cpu(msg_hi),
 					be64_to_cpu(cmd->rsp.tag));
 
-			pr_debug("send_messages: tag 0x%llx, rc %ld\n",
-				 be64_to_cpu(cmd->rsp.tag), rc);
+			pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
+				 cmd, be64_to_cpu(cmd->rsp.tag), rc);
 
 			/* if all ok free up the command element resources */
 			if (rc == H_SUCCESS) {
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
@@ -2083,254 +2235,104 @@ static void ibmvscsis_srp_cmd(struct scsi_info *vscsi, struct viosrp_crq *crq)
 	}
 
 	if (vscsi->state == SRP_PROCESSING) {
-		switch (srp->opcode) {
-		case SRP_LOGIN_REQ:
-			rc = ibmvscsis_srp_login(vscsi, cmd, crq);
-			break;
-
-		case SRP_TSK_MGMT:
-			tsk = &vio_iu(iue)->srp.tsk_mgmt;
-			pr_debug("tsk_mgmt tag: %llu (0x%llx)\n", tsk->tag,
-				 tsk->tag);
-			cmd->rsp.tag = tsk->tag;
-			vscsi->debit += 1;
-			cmd->type = TASK_MANAGEMENT;
-			list_add_tail(&cmd->list, &vscsi->schedule_q);
-			queue_work(vscsi->work_q, &cmd->work);
-			break;
-
-		case SRP_CMD:
-			pr_debug("srp_cmd tag: %llu (0x%llx)\n", srp->tag,
-				 srp->tag);
-			cmd->rsp.tag = srp->tag;
-			vscsi->debit += 1;
-			cmd->type = SCSI_CDB;
-			/*
-			 * We want to keep track of work waiting for
-			 * the workqueue.
-			 */
-			list_add_tail(&cmd->list, &vscsi->schedule_q);
-			queue_work(vscsi->work_q, &cmd->work);
-			break;
-
-		case SRP_I_LOGOUT:
-			rc = ibmvscsis_srp_i_logout(vscsi, cmd, crq);
-			break;
-
-		case SRP_CRED_RSP:
-		case SRP_AER_RSP:
-		default:
-			ibmvscsis_free_cmd_resources(vscsi, cmd);
-			dev_err(&vscsi->dev, "invalid srp cmd, opcode %d\n",
-				(uint)srp->opcode);
-			ibmvscsis_post_disconnect(vscsi,
-						  ERR_DISCONNECT_RECONNECT, 0);
-			break;
-		}
-	} else if (srp->opcode == SRP_LOGIN_REQ && vscsi->state == CONNECTED) {
-		rc = ibmvscsis_srp_login(vscsi, cmd, crq);
-	} else {
-		ibmvscsis_free_cmd_resources(vscsi, cmd);
-		dev_err(&vscsi->dev, "Invalid state %d to handle srp cmd\n",
-			vscsi->state);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-	}
-}
-
-/**
- * ibmvscsis_ping_response() - Respond to a ping request
- * @vscsi:	Pointer to our adapter structure
- *
- * Let the client know that the server is alive and waiting on
- * its native I/O stack.
- * If any type of error occurs from the call to queue a ping
- * response then the client is either not accepting or receiving
- * interrupts.  Disconnect with an error.
- *
- * EXECUTION ENVIRONMENT:
- *	Interrupt, interrupt lock held
- */
-static long ibmvscsis_ping_response(struct scsi_info *vscsi)
-{
-	struct viosrp_crq *crq;
-	u64 buffer[2] = { 0, 0 };
-	long rc;
-
-	crq = (struct viosrp_crq *)&buffer;
-	crq->valid = VALID_CMD_RESP_EL;
-	crq->format = (u8)MESSAGE_IN_CRQ;
-	crq->status = PING_RESPONSE;
-
-	rc = h_send_crq(vscsi->dds.unit_id, cpu_to_be64(buffer[MSG_HI]),
-			cpu_to_be64(buffer[MSG_LOW]));
-
-	switch (rc) {
-	case H_SUCCESS:
-		break;
-	case H_CLOSED:
-		vscsi->flags |= CLIENT_FAILED;
-	case H_DROPPED:
-		vscsi->flags |= RESPONSE_Q_DOWN;
-	case H_REMOTE_PARM:
-		dev_err(&vscsi->dev, "ping_response: h_send_crq failed, rc %ld\n",
-			rc);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-		break;
-	default:
-		dev_err(&vscsi->dev, "ping_response: h_send_crq returned unknown rc %ld\n",
-			rc);
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
-		break;
-	}
-
-	return rc;
-}
-
-/**
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
+		switch (srp->opcode) {
+		case SRP_LOGIN_REQ:
+			rc = ibmvscsis_srp_login(vscsi, cmd, crq);
+			break;
 
-	switch (vscsi->state) {
-	case WAIT_ENABLED:
-		vscsi->state = PART_UP_WAIT_ENAB;
-		break;
+		case SRP_TSK_MGMT:
+			tsk = &vio_iu(iue)->srp.tsk_mgmt;
+			pr_debug("tsk_mgmt tag: %llu (0x%llx)\n", tsk->tag,
+				 tsk->tag);
+			cmd->rsp.tag = tsk->tag;
+			vscsi->debit += 1;
+			cmd->type = TASK_MANAGEMENT;
+			list_add_tail(&cmd->list, &vscsi->schedule_q);
+			queue_work(vscsi->work_q, &cmd->work);
+			break;
 
-	case WAIT_CONNECTION:
-		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
-		switch (rc) {
-		case H_SUCCESS:
-			vscsi->state = CONNECTED;
+		case SRP_CMD:
+			pr_debug("srp_cmd tag: %llu (0x%llx)\n", srp->tag,
+				 srp->tag);
+			cmd->rsp.tag = srp->tag;
+			vscsi->debit += 1;
+			cmd->type = SCSI_CDB;
+			/*
+			 * We want to keep track of work waiting for
+			 * the workqueue.
+			 */
+			list_add_tail(&cmd->list, &vscsi->schedule_q);
+			queue_work(vscsi->work_q, &cmd->work);
 			break;
 
-		case H_PARAMETER:
-			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
-				rc);
-			ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+		case SRP_I_LOGOUT:
+			rc = ibmvscsis_srp_i_logout(vscsi, cmd, crq);
 			break;
 
-		case H_DROPPED:
-			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
-				rc);
-			rc = ERROR;
+		case SRP_CRED_RSP:
+		case SRP_AER_RSP:
+		default:
+			ibmvscsis_free_cmd_resources(vscsi, cmd);
+			dev_err(&vscsi->dev, "invalid srp cmd, opcode %d\n",
+				(uint)srp->opcode);
 			ibmvscsis_post_disconnect(vscsi,
 						  ERR_DISCONNECT_RECONNECT, 0);
 			break;
-
-		case H_CLOSED:
-			pr_warn("init_msg: failed to send, rc %ld\n", rc);
-			rc = 0;
-			break;
 		}
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
+	} else if (srp->opcode == SRP_LOGIN_REQ && vscsi->state == CONNECTED) {
+		rc = ibmvscsis_srp_login(vscsi, cmd, crq);
+	} else {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		dev_err(&vscsi->dev, "Invalid state %d to handle srp cmd\n",
 			vscsi->state);
 		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-		break;
 	}
-
-	return rc;
 }
 
 /**
- * ibmvscsis_init_msg() - Respond to an init message
+ * ibmvscsis_ping_response() - Respond to a ping request
  * @vscsi:	Pointer to our adapter structure
- * @crq:	Pointer to CRQ element containing the Init Message
+ *
+ * Let the client know that the server is alive and waiting on
+ * its native I/O stack.
+ * If any type of error occurs from the call to queue a ping
+ * response then the client is either not accepting or receiving
+ * interrupts.  Disconnect with an error.
  *
  * EXECUTION ENVIRONMENT:
  *	Interrupt, interrupt lock held
  */
-static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_crq *crq)
+static long ibmvscsis_ping_response(struct scsi_info *vscsi)
 {
-	long rc = ADAPT_SUCCESS;
+	struct viosrp_crq *crq;
+	u64 buffer[2] = { 0, 0 };
+	long rc;
 
-	pr_debug("init_msg: state 0x%hx\n", vscsi->state);
+	crq = (struct viosrp_crq *)&buffer;
+	crq->valid = VALID_CMD_RESP_EL;
+	crq->format = (u8)MESSAGE_IN_CRQ;
+	crq->status = PING_RESPONSE;
 
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
+	rc = h_send_crq(vscsi->dds.unit_id, cpu_to_be64(buffer[MSG_HI]),
+			cpu_to_be64(buffer[MSG_LOW]));
 
-	if (crq->format == INIT_MSG) {
-		rc = ibmvscsis_handle_init_msg(vscsi);
-	} else if (crq->format == INIT_COMPLETE_MSG) {
-		rc = ibmvscsis_handle_init_compl_msg(vscsi);
-	} else {
-		rc = ERROR;
-		dev_err(&vscsi->dev, "init_msg: invalid format %d\n",
-			(uint)crq->format);
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+	case H_CLOSED:
+		vscsi->flags |= CLIENT_FAILED;
+	case H_DROPPED:
+		vscsi->flags |= RESPONSE_Q_DOWN;
+	case H_REMOTE_PARM:
+		dev_err(&vscsi->dev, "ping_response: h_send_crq failed, rc %ld\n",
+			rc);
 		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	default:
+		dev_err(&vscsi->dev, "ping_response: h_send_crq returned unknown rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+		break;
 	}
 
 	return rc;
@@ -2391,7 +2393,7 @@ static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 		break;
 
 	case VALID_TRANS_EVENT:
-		rc =  ibmvscsis_trans_event(vscsi, crq);
+		rc = ibmvscsis_trans_event(vscsi, crq);
 		break;
 
 	case VALID_INIT_MSG:
@@ -2786,36 +2788,6 @@ static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
 }
 
 /**
- * ibmvscsis_check_q() - Helper function to Check Init Message Valid
- * @vscsi:	Pointer to our adapter structure
- *
- * Checks if a initialize message was queued by the initiatior
- * while the timing window was open.  This function is called from
- * probe after the CRQ is created and interrupts are enabled.
- * It would only be used by adapters who wait for some event before
- * completing the init handshake with the client.  For ibmvscsi, this
- * event is waiting for the port to be enabled.
- *
- * EXECUTION ENVIRONMENT:
- *	Process level only, interrupt lock held
- */
-static long ibmvscsis_check_q(struct scsi_info *vscsi)
-{
-	uint format;
-	long rc;
-
-	rc = ibmvscsis_check_init_msg(vscsi, &format);
-	if (rc)
-		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
-	else if (format == UNUSED_FORMAT)
-		vscsi->state = WAIT_ENABLED;
-	else
-		vscsi->state = PART_UP_WAIT_ENAB;
-
-	return rc;
-}
-
-/**
  * ibmvscsis_enable_change_state() - Set new state based on enabled status
  * @vscsi:	Pointer to our adapter structure
  *
@@ -2826,77 +2798,19 @@ static long ibmvscsis_check_q(struct scsi_info *vscsi)
  */
 static long ibmvscsis_enable_change_state(struct scsi_info *vscsi)
 {
+	int bytes;
 	long rc = ADAPT_SUCCESS;
 
-handle_state_change:
-	switch (vscsi->state) {
-	case WAIT_ENABLED:
-		rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
-		switch (rc) {
-		case H_SUCCESS:
-		case H_DROPPED:
-		case H_CLOSED:
-			vscsi->state =  WAIT_CONNECTION;
-			rc = ADAPT_SUCCESS;
-			break;
-
-		case H_PARAMETER:
-			break;
-
-		case H_HARDWARE:
-			break;
-
-		default:
-			vscsi->state = UNDEFINED;
-			rc = H_HARDWARE;
-			break;
-		}
-		break;
-	case PART_UP_WAIT_ENAB:
-		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
-		switch (rc) {
-		case H_SUCCESS:
-			vscsi->state = CONNECTED;
-			rc = ADAPT_SUCCESS;
-			break;
-
-		case H_DROPPED:
-		case H_CLOSED:
-			vscsi->state = WAIT_ENABLED;
-			goto handle_state_change;
-
-		case H_PARAMETER:
-			break;
-
-		case H_HARDWARE:
-			break;
-
-		default:
-			rc = H_HARDWARE;
-			break;
-		}
-		break;
-
-	case WAIT_CONNECTION:
-	case WAIT_IDLE:
-	case SRP_PROCESSING:
-	case CONNECTED:
-		rc = ADAPT_SUCCESS;
-		break;
-		/* should not be able to get here */
-	case UNCONFIGURING:
-		rc = ERROR;
-		vscsi->state = UNDEFINED;
-		break;
+	bytes = vscsi->cmd_q.size * PAGE_SIZE;
+	rc = h_reg_crq(vscsi->dds.unit_id, vscsi->cmd_q.crq_token, bytes);
+	if (rc == H_CLOSED || rc == H_SUCCESS) {
+		vscsi->state = WAIT_CONNECTION;
+		rc = ibmvscsis_establish_new_q(vscsi);
+	}
 
-		/* driver should never allow this to happen */
-	case ERR_DISCONNECT:
-	case ERR_DISCONNECT_RECONNECT:
-	default:
-		dev_err(&vscsi->dev, "in invalid state %d during enable_change_state\n",
-			vscsi->state);
-		rc = ADAPT_SUCCESS;
-		break;
+	if (rc != ADAPT_SUCCESS) {
+		vscsi->state = ERR_DISCONNECTED;
+		vscsi->flags |= RESPONSE_Q_DOWN;
 	}
 
 	return rc;
@@ -2916,7 +2830,6 @@ handle_state_change:
  */
 static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 {
-	long rc = 0;
 	int pages;
 	struct vio_dev *vdev = vscsi->dma_dev;
 
@@ -2940,22 +2853,7 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 		return -ENOMEM;
 	}
 
-	rc =  h_reg_crq(vscsi->dds.unit_id, vscsi->cmd_q.crq_token, PAGE_SIZE);
-	if (rc) {
-		if (rc == H_CLOSED) {
-			vscsi->state = WAIT_ENABLED;
-			rc = 0;
-		} else {
-			dma_unmap_single(&vdev->dev, vscsi->cmd_q.crq_token,
-					 PAGE_SIZE, DMA_BIDIRECTIONAL);
-			free_page((unsigned long)vscsi->cmd_q.base_addr);
-			rc = -ENODEV;
-		}
-	} else {
-		vscsi->state = WAIT_ENABLED;
-	}
-
-	return rc;
+	return 0;
 }
 
 /**
@@ -3270,7 +3168,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
 	/*
 	 * if we are in a path where we are waiting for all pending commands
 	 * to complete because we received a transport event and anything in
-	 * the command queue is for a new connection,  do nothing
+	 * the command queue is for a new connection, do nothing
 	 */
 	if (TARGET_STOP(vscsi)) {
 		vio_enable_interrupts(vscsi->dma_dev);
@@ -3314,7 +3212,7 @@ cmd_work:
 				 * everything but transport events on the queue
 				 *
 				 * need to decrement the queue index so we can
-				 * look at the elment again
+				 * look at the element again
 				 */
 				if (vscsi->cmd_q.index)
 					vscsi->cmd_q.index -= 1;
@@ -3469,6 +3367,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 		     (unsigned long)vscsi);
 
 	init_completion(&vscsi->wait_idle);
+	init_completion(&vscsi->unconfig);
 
 	snprintf(wq_name, 24, "ibmvscsis%s", dev_name(&vdev->dev));
 	vscsi->work_q = create_workqueue(wq_name);
@@ -3485,31 +3384,12 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 		goto destroy_WQ;
 	}
 
-	spin_lock_bh(&vscsi->intr_lock);
-	vio_enable_interrupts(vdev);
-	if (rc) {
-		dev_err(&vscsi->dev, "enabling interrupts failed, rc %d\n", rc);
-		rc = -ENODEV;
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto free_irq;
-	}
-
-	if (ibmvscsis_check_q(vscsi)) {
-		rc = ERROR;
-		dev_err(&vscsi->dev, "probe: check_q failed, rc %d\n", rc);
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto disable_interrupt;
-	}
-	spin_unlock_bh(&vscsi->intr_lock);
+	vscsi->state = WAIT_ENABLED;
 
 	dev_set_drvdata(&vdev->dev, vscsi);
 
 	return 0;
 
-disable_interrupt:
-	vio_disable_interrupts(vdev);
-free_irq:
-	free_irq(vdev->irq, vscsi);
 destroy_WQ:
 	destroy_workqueue(vscsi->work_q);
 unmap_buf:
@@ -3543,10 +3423,11 @@ static int ibmvscsis_remove(struct vio_dev *vdev)
 
 	pr_debug("remove (%s)\n", dev_name(&vscsi->dma_dev->dev));
 
-	/*
-	 * TBD: Need to handle if there are commands on the waiting_rsp q
-	 *      Actually, can there still be cmds outstanding to tcm?
-	 */
+	spin_lock_bh(&vscsi->intr_lock);
+	ibmvscsis_post_disconnect(vscsi, UNCONFIGURING, 0);
+	vscsi->flags |= CFG_SLEEPING;
+	spin_unlock_bh(&vscsi->intr_lock);
+	wait_for_completion(&vscsi->unconfig);
 
 	vio_disable_interrupts(vdev);
 	free_irq(vdev->irq, vscsi);
@@ -3555,7 +3436,6 @@ static int ibmvscsis_remove(struct vio_dev *vdev)
 			 DMA_BIDIRECTIONAL);
 	kfree(vscsi->map_buf);
 	tasklet_kill(&vscsi->work_task);
-	ibmvscsis_unregister_command_q(vscsi);
 	ibmvscsis_destroy_command_q(vscsi);
 	ibmvscsis_freetimer(vscsi);
 	ibmvscsis_free_cmds(vscsi);
@@ -3903,18 +3783,22 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 	}
 
 	if (tmp) {
-		tport->enabled = true;
 		spin_lock_bh(&vscsi->intr_lock);
+		tport->enabled = true;
 		lrc = ibmvscsis_enable_change_state(vscsi);
 		if (lrc)
 			pr_err("enable_change_state failed, rc %ld state %d\n",
 			       lrc, vscsi->state);
 		spin_unlock_bh(&vscsi->intr_lock);
 	} else {
+		spin_lock_bh(&vscsi->intr_lock);
 		tport->enabled = false;
+		/* This simulates the server going down */
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+		spin_unlock_bh(&vscsi->intr_lock);
 	}
 
-	pr_debug("tpg_enable_store, state %d\n", vscsi->state);
+	pr_debug("tpg_enable_store, tmp %ld, state %d\n", tmp, vscsi->state);
 
 	return count;
 }
@@ -3983,10 +3867,10 @@ static struct attribute *ibmvscsis_dev_attrs[] = {
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
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
index 981a0c9..98b0ca7 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
@@ -204,8 +204,6 @@ struct scsi_info {
 	struct list_head waiting_rsp;
 #define NO_QUEUE                    0x00
 #define WAIT_ENABLED                0X01
-	/* driver has received an initialize command */
-#define PART_UP_WAIT_ENAB           0x02
 #define WAIT_CONNECTION             0x04
 	/* have established a connection */
 #define CONNECTED                   0x08
@@ -259,6 +257,8 @@ struct scsi_info {
 #define SCHEDULE_DISCONNECT           0x00400
 	/* disconnect handler is scheduled */
 #define DISCONNECT_SCHEDULED          0x00800
+	/* remove function is sleeping */
+#define CFG_SLEEPING                  0x01000
 	u32 flags;
 	/* adapter lock */
 	spinlock_t intr_lock;
@@ -287,6 +287,7 @@ struct scsi_info {
 
 	struct workqueue_struct *work_q;
 	struct completion wait_idle;
+	struct completion unconfig;
 	struct device dev;
 	struct vio_dev *dma_dev;
 	struct srp_target target;
-- 
2.5.0
