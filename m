From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 06/22] advansys: Remove `waiting' queue
Date: Sun,  9 Sep 2007 08:56:31 -0600
Message-ID: <11893498071713-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43203 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbXIIO4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:50 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

If the adapter is busy, return the request to the midlayer rather than
queueing it in the driver.  asc_execute_queue() and asc_dequeue() become
unused, and we don't need to print out stats on the waiting queue any more.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  186 ++--------------------------------------------
 1 files changed, 9 insertions(+), 177 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fe289b1..526239a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2852,7 +2852,6 @@ typedef struct asc_board {
 	} dvc_cfg;
 	ushort asc_n_io_port;	/* Number I/O ports. */
 	asc_queue_t active;	/* Active command queue */
-	asc_queue_t waiting;	/* Waiting command queue */
 	asc_queue_t done;	/* Done command queue */
 	ADV_SCSI_BIT_ID_TYPE init_tidmask;	/* Target init./valid mask */
 	struct scsi_device *device[ADV_MAX_TID + 1];	/* Mid-Level Scsi Device */
@@ -2922,10 +2921,8 @@ static int asc_build_req(asc_board_t *, struct scsi_cmnd *);
 static int adv_build_req(asc_board_t *, struct scsi_cmnd *, ADV_SCSI_REQ_Q **);
 static int adv_get_sglist(asc_board_t *, adv_req_t *, struct scsi_cmnd *, int);
 static void asc_enqueue(asc_queue_t *, REQP, int);
-static REQP asc_dequeue(asc_queue_t *, int);
 static REQP asc_dequeue_list(asc_queue_t *, REQP *, int);
 static int asc_rmqueue(asc_queue_t *, REQP);
-static void asc_execute_queue(asc_queue_t *);
 #ifdef CONFIG_PROC_FS
 static int asc_proc_copy(off_t, off_t, char *, int, char *, int);
 static int asc_prt_board_devices(struct Scsi_Host *, char *, int);
@@ -3274,6 +3271,7 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 	asc_board_t *boardp;
 	ulong flags;
 	struct scsi_cmnd *done_scp;
+	int asc_res, result = 0;
 
 	shost = scp->device->host;
 	boardp = ASC_BOARDP(shost);
@@ -3302,37 +3300,13 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 		return 0;
 	}
 
-	/*
-	 * Attempt to execute any waiting commands for the board.
-	 */
-	if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
-		ASC_DBG(1,
-			"advansys_queuecommand: before asc_execute_queue() waiting\n");
-		asc_execute_queue(&boardp->waiting);
-	}
-
-	/*
-	 * Save the function pointer to Linux mid-level 'done' function
-	 * and attempt to execute the command.
-	 *
-	 * If ASC_NOERROR is returned the request has been added to the
-	 * board's 'active' queue and will be completed by the interrupt
-	 * handler.
-	 *
-	 * If ASC_BUSY is returned add the request to the board's per
-	 * target waiting list. This is the first time the request has
-	 * been tried. Add it to the back of the waiting list. It will be
-	 * retried later.
-	 *
-	 * If an error occurred, the request will have been placed on the
-	 * board's 'done' queue and must be completed before returning.
-	 */
 	scp->scsi_done = done;
-	switch (asc_execute_scsi_cmnd(scp)) {
+	asc_res = asc_execute_scsi_cmnd(scp);
+	switch (asc_res) {
 	case ASC_NOERROR:
 		break;
 	case ASC_BUSY:
-		asc_enqueue(&boardp->waiting, scp, ASC_BACK);
+		result = SCSI_MLQUEUE_HOST_BUSY;
 		break;
 	case ASC_ERROR:
 	default:
@@ -3343,7 +3317,7 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 	}
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
-	return 0;
+	return result;
 }
 
 /*
@@ -3488,33 +3462,6 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		}
 	}
 
-	/*
-	 * Dequeue all 'waiting' requests and set the request status
-	 * to DID_RESET.
-	 */
-	if (done_scp == NULL) {
-		done_scp = asc_dequeue_list(&boardp->waiting, &last_scp,
-					    ASC_TID_ALL);
-		for (tscp = done_scp; tscp; tscp = REQPNEXT(tscp)) {
-			tscp->result = HOST_BYTE(DID_RESET);
-		}
-	} else {
-		/* Append to 'done_scp' at the end with 'last_scp'. */
-		ASC_ASSERT(last_scp != NULL);
-		last_scp->host_scribble =
-		    (unsigned char *)asc_dequeue_list(&boardp->waiting,
-						      &new_last_scp,
-						      ASC_TID_ALL);
-		if (new_last_scp != NULL) {
-			ASC_ASSERT(REQPNEXT(last_scp) != NULL);
-			for (tscp = REQPNEXT(last_scp); tscp;
-			     tscp = REQPNEXT(tscp)) {
-				tscp->result = HOST_BYTE(DID_RESET);
-			}
-			last_scp = new_last_scp;
-		}
-	}
-
 	/* Save the time of the most recently completed reset. */
 	boardp->last_reset = jiffies;
 
@@ -3650,7 +3597,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	}
 
 	/*
-	 * Start waiting requests and create a list of completed requests.
+	 * Create a list of completed requests.
 	 *
 	 * If a reset request is being performed for the board, the reset
 	 * handler will complete pending requests after it has completed.
@@ -3659,13 +3606,6 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 		ASC_DBG2(1, "advansys_interrupt: done_scp 0x%p, "
 			 "last_scp 0x%p\n", done_scp, last_scp);
 
-		/* Start any waiting commands for the board. */
-		if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
-			ASC_DBG(1, "advansys_interrupt: before "
-				"asc_execute_queue()\n");
-			asc_execute_queue(&boardp->waiting);
-		}
-
 		/*
 		 * Add to the list of requests that must be completed.
 		 *
@@ -3986,8 +3926,8 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
  * If this function returns ASC_NOERROR the request has been enqueued
  * on the board's 'done' queue and must be completed by the caller.
  *
- * If ASC_BUSY is returned the request will be enqueued by the
- * caller on the target's waiting queue and re-tried later.
+ * If ASC_BUSY is returned the request will be returned to the midlayer
+ * and re-tried later.
  */
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
@@ -4043,10 +3983,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				"ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
-			/*
-			 * Caller will enqueue request on the target's waiting
-			 * queue and retry later.
-			 */
 			ASC_STATS(scp->device->host, exe_busy);
 			break;
 		case ASC_ERROR:
@@ -4087,10 +4023,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
 				"ASC_BUSY\n");
 			/*
-			 * If busy is returned the request has not been
-			 * enqueued.  It will be enqueued by the caller on the
-			 * target's waiting queue and retried later.
-			 *
 			 * The asc_stats fields 'adv_build_noreq' and
 			 * 'adv_build_nosg' count wide board busy conditions.
 			 * They are updated in adv_build_req and
@@ -4127,10 +4059,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 				"ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
-			/*
-			 * Caller will enqueue request on the target's waiting
-			 * queue and retry later.
-			 */
 			ASC_STATS(scp->device->host, exe_busy);
 			break;
 		case ASC_ERROR:
@@ -5005,39 +4933,6 @@ static void asc_enqueue(asc_queue_t *ascq, REQP reqp, int flag)
 }
 
 /*
- * Return first queued 'REQP' on the specified queue for
- * the specified target device. Clear the 'tidmask' bit for
- * the device if no more commands are left queued for it.
- *
- * 'REQPNEXT(reqp)' returns reqp's next pointer.
- */
-static REQP asc_dequeue(asc_queue_t *ascq, int tid)
-{
-	REQP reqp;
-
-	ASC_DBG2(3, "asc_dequeue: ascq 0x%lx, tid %d\n", (ulong)ascq, tid);
-	ASC_ASSERT(tid >= 0 && tid <= ADV_MAX_TID);
-	if ((reqp = ascq->q_first[tid]) != NULL) {
-		ASC_ASSERT(ascq->q_tidmask & ADV_TID_TO_TIDMASK(tid));
-		ascq->q_first[tid] = REQPNEXT(reqp);
-		/* If the queue is empty, clear its bit and the last pointer. */
-		if (ascq->q_first[tid] == NULL) {
-			ascq->q_tidmask &= ~ADV_TID_TO_TIDMASK(tid);
-			ASC_ASSERT(ascq->q_last[tid] == reqp);
-			ascq->q_last[tid] = NULL;
-		}
-#ifdef ADVANSYS_STATS
-		/* Maintain request queue statistics. */
-		ascq->q_cur_cnt[tid]--;
-		ASC_ASSERT(ascq->q_cur_cnt[tid] >= 0);
-		REQTIMESTAT("asc_dequeue", ascq, reqp, tid);
-#endif /* ADVANSYS_STATS */
-	}
-	ASC_DBG1(3, "asc_dequeue: reqp 0x%lx\n", (ulong)reqp);
-	return reqp;
-}
-
-/*
  * Return a pointer to a singly linked list of all the requests queued
  * for 'tid' on the 'asc_queue_t' pointed to by 'ascq'.
  *
@@ -5202,45 +5097,6 @@ static int asc_rmqueue(asc_queue_t *ascq, REQP reqp)
 	return ret;
 }
 
-/*
- * Execute as many queued requests as possible for the specified queue.
- *
- * Calls asc_execute_scsi_cmnd() to execute a REQP/struct scsi_cmnd.
- */
-static void asc_execute_queue(asc_queue_t *ascq)
-{
-	ADV_SCSI_BIT_ID_TYPE scan_tidmask;
-	REQP reqp;
-	int i;
-
-	ASC_DBG1(1, "asc_execute_queue: ascq 0x%lx\n", (ulong)ascq);
-	/*
-	 * Execute queued commands for devices attached to
-	 * the current board in round-robin fashion.
-	 */
-	scan_tidmask = ascq->q_tidmask;
-	do {
-		for (i = 0; i <= ADV_MAX_TID; i++) {
-			if (scan_tidmask & ADV_TID_TO_TIDMASK(i)) {
-				if ((reqp = asc_dequeue(ascq, i)) == NULL) {
-					scan_tidmask &= ~ADV_TID_TO_TIDMASK(i);
-				} else
-				    if (asc_execute_scsi_cmnd
-					((struct scsi_cmnd *)reqp)
-					== ASC_BUSY) {
-					scan_tidmask &= ~ADV_TID_TO_TIDMASK(i);
-					/*
-					 * The request returned ASC_BUSY. Enqueue at the front of
-					 * target's waiting list to maintain correct ordering.
-					 */
-					asc_enqueue(ascq, reqp, ASC_FRONT);
-				}
-			}
-		}
-	} while (scan_tidmask);
-	return;
-}
-
 #ifdef CONFIG_PROC_FS
 /*
  * asc_prt_board_devices()
@@ -6723,7 +6579,6 @@ asc_prt_target_stats(struct Scsi_Host *shost, int tgt_id, char *cp, int cplen)
 	ushort chip_scsi_id;
 	asc_board_t *boardp;
 	asc_queue_t *active;
-	asc_queue_t *waiting;
 
 	leftlen = cplen;
 	totlen = len = 0;
@@ -6732,7 +6587,6 @@ asc_prt_target_stats(struct Scsi_Host *shost, int tgt_id, char *cp, int cplen)
 	s = &boardp->asc_stats;
 
 	active = &ASC_BOARDP(shost)->active;
-	waiting = &ASC_BOARDP(shost)->waiting;
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		chip_scsi_id = boardp->dvc_cfg.asc_dvc_cfg.chip_scsi_id;
@@ -6746,8 +6600,7 @@ asc_prt_target_stats(struct Scsi_Host *shost, int tgt_id, char *cp, int cplen)
 	}
 
 	do {
-		if (active->q_tot_cnt[tgt_id] > 0
-		    || waiting->q_tot_cnt[tgt_id] > 0) {
+		if (active->q_tot_cnt[tgt_id] > 0) {
 			len = asc_prt_line(cp, leftlen, " target %d\n", tgt_id);
 			ASC_PRT_NEXT();
 
@@ -6771,27 +6624,6 @@ asc_prt_target_stats(struct Scsi_Host *shost, int tgt_id, char *cp, int cplen)
 								q_tot_cnt
 								[tgt_id]));
 			ASC_PRT_NEXT();
-
-			len = asc_prt_line(cp, leftlen,
-					   "   waiting: cnt [cur %d, max %d, tot %u], time [min %u, max %u, avg %lu.%01lu]\n",
-					   waiting->q_cur_cnt[tgt_id],
-					   waiting->q_max_cnt[tgt_id],
-					   waiting->q_tot_cnt[tgt_id],
-					   waiting->q_min_tim[tgt_id],
-					   waiting->q_max_tim[tgt_id],
-					   (waiting->q_tot_cnt[tgt_id] ==
-					    0) ? 0 : (waiting->
-						      q_tot_tim[tgt_id] /
-						      waiting->
-						      q_tot_cnt[tgt_id]),
-					   (waiting->q_tot_cnt[tgt_id] ==
-					    0) ? 0 : ASC_TENTHS(waiting->
-								q_tot_tim
-								[tgt_id],
-								waiting->
-								q_tot_cnt
-								[tgt_id]));
-			ASC_PRT_NEXT();
 		}
 	} while (0);
 
-- 
1.5.2.4

