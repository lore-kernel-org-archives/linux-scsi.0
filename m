From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 2/6] ibmvscsis: Synchronize cmds at tpg_enable_store time
Date: Thu, 13 Oct 2016 11:02:39 -0500
Message-ID: <1476374563-13967-3-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42123 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933054AbcJMSBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 14:01:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DFx3iT074023
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:06 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 262cskagfg-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:06 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Thu, 13 Oct 2016 12:03:05 -0400
In-Reply-To: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

This patch changes the way the IBM vSCSI server driver manages its
Command/Response Queue (CRQ).  We used to register the CRQ with phyp at
probe time.  Now we wait until tpg_enable_store.  Similarly, when
tpg_enable_store is called to "disable" (i.e. the stored value is 0),
we unregister the queue with phyp.

One consquence to this is that we have no need for the PART_UP_WAIT_ENAB
state, since we can't get an Init Message from the client in our CRQ if
we're waiting to be enabled, since we haven't registered the queue yet.

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 224 ++++++-------------------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |   2 -
 2 files changed, 38 insertions(+), 188 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 01a430c..2ce1d73 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -61,8 +61,6 @@ static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 
 static void ibmvscsis_adapter_idle(struct scsi_info *vscsi);
 
-static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state);
-
 static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 				      struct srp_rsp *rsp)
 {
@@ -417,7 +415,6 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 					       proc_work);
 	u16 new_state;
 	bool wait_idle = false;
-	long rc = ADAPT_SUCCESS;
 
 	spin_lock_bh(&vscsi->intr_lock);
 	new_state = vscsi->new_state;
@@ -470,30 +467,12 @@ static void ibmvscsis_disconnect(struct work_struct *work)
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
+		/* should never happen */
 		case ERR_DISCONNECT:
-			vscsi->flags |= RESPONSE_Q_DOWN;
-			vscsi->state = new_state;
-			vscsi->flags &= ~(SCHEDULE_DISCONNECT |
-					  DISCONNECT_SCHEDULED);
-			ibmvscsis_free_command_q(vscsi);
-			break;
 		case ERR_DISCONNECT_RECONNECT:
-			ibmvscsis_reset_queue(vscsi, WAIT_ENABLED);
-			break;
-
-		/* should never happen */
 		case WAIT_IDLE:
-			rc = ERROR;
 			dev_err(&vscsi->dev, "disconnect: invalid state %d for WAIT_IDLE\n",
 				vscsi->state);
 			break;
@@ -630,7 +609,6 @@ static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_state,
 			break;
 
 		case WAIT_ENABLED:
-		case PART_UP_WAIT_ENAB:
 		case WAIT_IDLE:
 		case WAIT_CONNECTION:
 		case CONNECTED:
@@ -675,7 +653,6 @@ static long ibmvscsis_handle_init_compl_msg(struct scsi_info *vscsi)
 	case SRP_PROCESSING:
 	case CONNECTED:
 	case WAIT_ENABLED:
-	case PART_UP_WAIT_ENAB:
 	default:
 		rc = ERROR;
 		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init compl msg\n",
@@ -698,10 +675,6 @@ static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
 	long rc = ADAPT_SUCCESS;
 
 	switch (vscsi->state) {
-	case WAIT_ENABLED:
-		vscsi->state = PART_UP_WAIT_ENAB;
-		break;
-
 	case WAIT_CONNECTION:
 		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
 		switch (rc) {
@@ -737,7 +710,7 @@ static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
 	case UNCONFIGURING:
 		break;
 
-	case PART_UP_WAIT_ENAB:
+	case WAIT_ENABLED:
 	case CONNECTED:
 	case SRP_PROCESSING:
 	case WAIT_IDLE:
@@ -800,11 +773,10 @@ static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_crq *crq)
 /**
  * ibmvscsis_establish_new_q() - Establish new CRQ queue
  * @vscsi:	Pointer to our adapter structure
- * @new_state:	New state being established after resetting the queue
  *
  * Must be called with interrupt lock held.
  */
-static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
+static long ibmvscsis_establish_new_q(struct scsi_info *vscsi)
 {
 	long rc = ADAPT_SUCCESS;
 	uint format;
@@ -816,19 +788,19 @@ static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
 
 	rc = vio_enable_interrupts(vscsi->dma_dev);
 	if (rc) {
-		pr_warn("reset_queue: failed to enable interrupts, rc %ld\n",
+		pr_warn("establish_new_q: failed to enable interrupts, rc %ld\n",
 			rc);
 		return rc;
 	}
 
 	rc = ibmvscsis_check_init_msg(vscsi, &format);
 	if (rc) {
-		dev_err(&vscsi->dev, "reset_queue: check_init_msg failed, rc %ld\n",
+		dev_err(&vscsi->dev, "establish_new_q: check_init_msg failed, rc %ld\n",
 			rc);
 		return rc;
 	}
 
-	if (format == UNUSED_FORMAT && new_state == WAIT_CONNECTION) {
+	if (format == UNUSED_FORMAT) {
 		rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
 		switch (rc) {
 		case H_SUCCESS:
@@ -846,6 +818,8 @@ static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
 			rc = H_HARDWARE;
 			break;
 		}
+	} else if (format == INIT_MSG) {
+		rc = ibmvscsis_handle_init_msg(vscsi);
 	}
 
 	return rc;
@@ -854,7 +828,6 @@ static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
 /**
  * ibmvscsis_reset_queue() - Reset CRQ Queue
  * @vscsi:	Pointer to our adapter structure
- * @new_state:	New state to establish after resetting the queue
  *
  * This function calls h_free_q and then calls h_reg_q and does all
  * of the bookkeeping to get us back to where we can communicate.
@@ -871,7 +844,7 @@ static long ibmvscsis_establish_new_q(struct scsi_info *vscsi, uint new_state)
  * EXECUTION ENVIRONMENT:
  *	Process environment, called with interrupt lock held
  */
-static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state)
+static void ibmvscsis_reset_queue(struct scsi_info *vscsi)
 {
 	int bytes;
 	long rc = ADAPT_SUCCESS;
@@ -884,19 +857,18 @@ static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state)
 		vscsi->rsp_q_timer.timer_pops = 0;
 		vscsi->debit = 0;
 		vscsi->credit = 0;
-		vscsi->state = new_state;
+		vscsi->state = WAIT_CONNECTION;
 		vio_enable_interrupts(vscsi->dma_dev);
 	} else {
 		rc = ibmvscsis_free_command_q(vscsi);
 		if (rc == ADAPT_SUCCESS) {
-			vscsi->state = new_state;
+			vscsi->state = WAIT_CONNECTION;
 
 			bytes = vscsi->cmd_q.size * PAGE_SIZE;
 			rc = h_reg_crq(vscsi->dds.unit_id,
 				       vscsi->cmd_q.crq_token, bytes);
 			if (rc == H_CLOSED || rc == H_SUCCESS) {
-				rc = ibmvscsis_establish_new_q(vscsi,
-							       new_state);
+				rc = ibmvscsis_establish_new_q(vscsi);
 			}
 
 			if (rc != ADAPT_SUCCESS) {
@@ -1015,10 +987,6 @@ static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 						   TRANS_EVENT));
 			break;
 
-		case PART_UP_WAIT_ENAB:
-			vscsi->state = WAIT_ENABLED;
-			break;
-
 		case SRP_PROCESSING:
 			if ((vscsi->debit > 0) ||
 			    !list_empty(&vscsi->schedule_q) ||
@@ -1219,15 +1187,18 @@ static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
 
 	switch (vscsi->state) {
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
@@ -1772,8 +1743,8 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					be64_to_cpu(msg_hi),
 					be64_to_cpu(cmd->rsp.tag));
 
-			pr_debug("send_messages: tag 0x%llx, rc %ld\n",
-				 be64_to_cpu(cmd->rsp.tag), rc);
+			pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
+				 cmd, be64_to_cpu(cmd->rsp.tag), rc);
 
 			/* if all ok free up the command element resources */
 			if (rc == H_SUCCESS) {
@@ -2788,36 +2759,6 @@ static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
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
@@ -2828,77 +2769,19 @@ static long ibmvscsis_check_q(struct scsi_info *vscsi)
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
@@ -2918,7 +2801,6 @@ handle_state_change:
  */
 static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 {
-	long rc = 0;
 	int pages;
 	struct vio_dev *vdev = vscsi->dma_dev;
 
@@ -2942,22 +2824,7 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
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
@@ -3487,31 +3354,12 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
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
@@ -3905,18 +3753,22 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
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
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
index 981a0c9..17e0ef4 100644
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
-- 
2.5.0

