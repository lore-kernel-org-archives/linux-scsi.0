From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 08/22] advansys: Remove `done' queue
Date: Sun,  9 Sep 2007 08:56:33 -0600
Message-ID: <11893498073763-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43073 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXIIO4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:48 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Move the guts of asc_scsi_done_list() into a new function, asc_scsi_done.
 - Call asc_scsi_done() in asc_isr_callback() and adv_isr_callback().  The
   comment was wrong; scsi_done cannot enable interrupts.
 - All other places which queued an scp on the done list are error paths
   for queuecommand, and so we can just call asc_scsi_done() in queuecommand
   if we receive an error.
 - We no longer need to keep a list of done requests in advansys_interrupt

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  120 +++++++++-------------------------------------
 1 files changed, 24 insertions(+), 96 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index cd17f28..90f05c5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2852,7 +2852,6 @@ typedef struct asc_board {
 	} dvc_cfg;
 	ushort asc_n_io_port;	/* Number I/O ports. */
 	asc_queue_t active;	/* Active command queue */
-	asc_queue_t done;	/* Done command queue */
 	ADV_SCSI_BIT_ID_TYPE init_tidmask;	/* Target init./valid mask */
 	struct scsi_device *device[ADV_MAX_TID + 1];	/* Mid-Level Scsi Device */
 	ushort reqcnt[ADV_MAX_TID + 1];	/* Starvation request count */
@@ -3258,6 +3257,23 @@ static const char *advansys_info(struct Scsi_Host *shost)
 	return info;
 }
 
+static void asc_scsi_done(struct scsi_cmnd *scp)
+{
+	struct asc_board *boardp = ASC_BOARDP(scp->device->host);
+
+	if (scp->use_sg)
+		dma_unmap_sg(boardp->dev,
+			     (struct scatterlist *)scp->request_buffer,
+			     scp->use_sg, scp->sc_data_direction);
+	else if (scp->request_bufflen)
+		dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
+				 scp->request_bufflen, scp->sc_data_direction);
+
+	ASC_STATS(scp->device->host, done);
+
+	scp->scsi_done(scp);
+}
+
 /*
  * advansys_queuecommand() - interrupt-driven I/O entrypoint.
  *
@@ -3270,7 +3286,6 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 	struct Scsi_Host *shost;
 	asc_board_t *boardp;
 	ulong flags;
-	struct scsi_cmnd *done_scp;
 	int asc_res, result = 0;
 
 	shost = scp->device->host;
@@ -3291,9 +3306,8 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 		break;
 	case ASC_ERROR:
 	default:
-		done_scp = asc_dequeue_list(&boardp->done, NULL, ASC_TID_ALL);
 		/* Interrupts could be enabled here. */
-		asc_scsi_done_list(done_scp);
+		asc_scsi_done(scp);
 		break;
 	}
 	spin_unlock_irqrestore(&boardp->lock, flags);
@@ -3410,12 +3424,6 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	/* Board lock is held. */
 
 	/*
-	 * Dequeue all board 'done' requests. A pointer to the last request
-	 * is returned in 'last_scp'.
-	 */
-	done_scp = asc_dequeue_list(&boardp->done, &last_scp, ASC_TID_ALL);
-
-	/*
 	 * Dequeue all board 'active' requests for all devices and set
 	 * the request status to DID_RESET. A pointer to the last request
 	 * is returned in 'last_scp'.
@@ -3548,8 +3556,6 @@ static struct scsi_host_template advansys_template = {
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
 	unsigned long flags;
-	struct scsi_cmnd *done_scp = NULL, *last_scp = NULL;
-	struct scsi_cmnd *new_last_scp;
 	struct Scsi_Host *shost = dev_id;
 	asc_board_t *boardp = ASC_BOARDP(shost);
 	irqreturn_t result = IRQ_NONE;
@@ -3577,49 +3583,13 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	/*
-	 * Create a list of completed requests.
-	 *
-	 * If a reset request is being performed for the board, the reset
-	 * handler will complete pending requests after it has completed.
-	 */
-	if ((boardp->flags & ASC_HOST_IN_RESET) == 0) {
-		ASC_DBG2(1, "advansys_interrupt: done_scp 0x%p, "
-			 "last_scp 0x%p\n", done_scp, last_scp);
-
-		/*
-		 * Add to the list of requests that must be completed.
-		 *
-		 * 'done_scp' will always be NULL on the first iteration of
-		 * this loop. 'last_scp' is set at the same time as 'done_scp'.
-		 */
-		if (done_scp == NULL) {
-			done_scp = asc_dequeue_list(&boardp->done,
-						&last_scp, ASC_TID_ALL);
-		} else {
-			ASC_ASSERT(last_scp != NULL);
-			last_scp->host_scribble =
-			    (unsigned char *)asc_dequeue_list(&boardp->
-							      done,
-							      &new_last_scp,
-							      ASC_TID_ALL);
-			if (new_last_scp != NULL) {
-				ASC_ASSERT(REQPNEXT(last_scp) != NULL);
-				last_scp = new_last_scp;
-			}
-		}
-	}
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
 	/*
 	 * If interrupts were enabled on entry, then they
 	 * are now enabled here.
-	 *
-	 * Complete all requests on the done list.
 	 */
 
-	asc_scsi_done_list(done_scp);
-
 	ASC_DBG(1, "advansys_interrupt: end\n");
 	return result;
 }
@@ -3836,27 +3806,11 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
 
 	ASC_DBG(2, "asc_scsi_done_list: begin\n");
 	while (scp != NULL) {
-		asc_board_t *boardp;
-
 		ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong)scp);
 		tscp = REQPNEXT(scp);
 		scp->host_scribble = NULL;
 
-		boardp = ASC_BOARDP(scp->device->host);
-
-		if (scp->use_sg)
-			dma_unmap_sg(boardp->dev,
-				     (struct scatterlist *)scp->request_buffer,
-				     scp->use_sg, scp->sc_data_direction);
-		else if (scp->request_bufflen)
-			dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
-					 scp->request_bufflen,
-					 scp->sc_data_direction);
-
-		ASC_STATS(scp->device->host, done);
-		ASC_ASSERT(scp->scsi_done != NULL);
-
-		scp->scsi_done(scp);
+		asc_scsi_done(scp);
 
 		scp = tscp;
 	}
@@ -3904,8 +3858,8 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
  * on the board's 'active' queue and will be completed from the
  * interrupt handler.
  *
- * If this function returns ASC_NOERROR the request has been enqueued
- * on the board's 'done' queue and must be completed by the caller.
+ * If this function returns ASC_ERROR the host error code has been set,
+ * and the called must call asc_scsi_done.
  *
  * If ASC_BUSY is returned the request will be returned to the midlayer
  * and re-tried later.
@@ -3972,7 +3926,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				boardp->id, asc_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_error);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		default:
 			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
@@ -3980,7 +3933,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				boardp->id, asc_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_unknown);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		}
 	} else {
@@ -4011,11 +3963,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			 */
 			return ASC_BUSY;
 		case ASC_ERROR:
-			/* 
-			 * If an error is returned, then the request has been
-			 * queued on the board done queue. It will be completed
-			 * by the caller.
-			 */
 		default:
 			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
 				"ASC_ERROR\n");
@@ -4048,7 +3995,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				boardp->id, adv_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_error);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		default:
 			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
@@ -4056,7 +4002,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				boardp->id, adv_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_unknown);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		}
 	}
@@ -4071,8 +4016,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
  * The global structures 'asc_scsi_q' and 'asc_sg_head' are
  * used to build the request.
  *
- * If an error occurs, then queue the request on the board done
- * queue and return ASC_ERROR.
+ * If an error occurs, then return ASC_ERROR.
  */
 static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 {
@@ -4098,7 +4042,6 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 			"ASC_MAX_CDB_LEN %d\n", boardp->id, scp->cmd_len,
 			ASC_MAX_CDB_LEN);
 		scp->result = HOST_BYTE(DID_ERROR);
-		asc_enqueue(&boardp->done, scp, ASC_BACK);
 		return ASC_ERROR;
 	}
 	asc_scsi_q.cdbptr = &scp->cmnd[0];
@@ -4167,7 +4110,6 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			return ASC_ERROR;
 		}
 
@@ -4274,7 +4216,6 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 		    ("adv_build_req: board %d: cmd_len %d > ADV_MAX_CDB_LEN  %d\n",
 		     boardp->id, scp->cmd_len, ADV_MAX_CDB_LEN);
 		scp->result = HOST_BYTE(DID_ERROR);
-		asc_enqueue(&boardp->done, scp, ASC_BACK);
 		return ASC_ERROR;
 	}
 	scsiqp->cdb_len = scp->cmd_len;
@@ -4342,7 +4283,6 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
 			scp->result = HOST_BYTE(DID_ERROR);
-			asc_enqueue(&boardp->done, scp, ASC_BACK);
 
 			/*
 			 * Free the 'adv_req_t' structure by adding it back
@@ -4628,13 +4568,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
 	}
 
-	/*
-	 * Because interrupts may be enabled by the 'struct scsi_cmnd' done
-	 * function, add the command to the end of the board's done queue.
-	 * The done function for the command will be called from
-	 * advansys_interrupt().
-	 */
-	asc_enqueue(&boardp->done, scp, ASC_BACK);
+	asc_scsi_done(scp);
 
 	return;
 }
@@ -4790,13 +4724,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
 	}
 
-	/*
-	 * Because interrupts may be enabled by the 'struct scsi_cmnd' done
-	 * function, add the command to the end of the board's done queue.
-	 * The done function for the command will be called from
-	 * advansys_interrupt().
-	 */
-	asc_enqueue(&boardp->done, scp, ASC_BACK);
+	asc_scsi_done(scp);
 
 	/*
 	 * Free all 'adv_sgblk_t' structures allocated for the request.
-- 
1.5.2.4

