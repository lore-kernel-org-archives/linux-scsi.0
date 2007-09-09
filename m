From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 09/22] advansys: Remove `active' queue and all remaining internal queueing code
Date: Sun,  9 Sep 2007 08:56:34 -0600
Message-ID: <11893498072336-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53980 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbXIIO4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:48 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The `active' list was used in the reset handler -- but the midlayer
guarantees that list is empty by the time the reset handler is invoked.
It was also checked in the interrupt routines to be sure that this command
belonged to this board, but we don't need to check that either.  We can
then delete the asc_prt_target_stats() function as it will never print
anything, along with asc_enqueue(), asc_dequeue_list(), asc_rmqueue(),
asc_scsi_done_list(), struct asc_queue, ASC_QUEUE_EMPTY, ASC_TID_ALL,
ASC_FRONT, ASC_BACK, and all the REQ* macros.  Also remove this item from
the todo list.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  504 +----------------------------------------------
 1 files changed, 6 insertions(+), 498 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 90f05c5..67cdfe6 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -63,11 +63,10 @@
  *     has not occurred then print a message and run in polled mode.
  *  4. Need to add support for target mode commands, cf. CAM XPT.
  *  5. check DMA mapping functions for failure
- *  6. Remove internal queueing
- *  7. Use scsi_transport_spi
- *  8. advansys_info is not safe against multiple simultaneous callers
- *  9. Kill boardp->id
- * 10. Add module_param to override ISA/VLB ioport array
+ *  6. Use scsi_transport_spi
+ *  7. advansys_info is not safe against multiple simultaneous callers
+ *  8. Kill boardp->id
+ *  9. Add module_param to override ISA/VLB ioport array
  */
 #warning this driver is still not properly converted to the DMA API
 
@@ -2514,64 +2513,6 @@ do { \
 #define HOST_BYTE(byte)     ((byte) << 16)
 #define DRIVER_BYTE(byte)   ((byte) << 24)
 
-/*
- * The following definitions and macros are OS independent interfaces to
- * the queue functions:
- *  REQ - SCSI request structure
- *  REQP - pointer to SCSI request structure
- *  REQPTID(reqp) - reqp's target id
- *  REQPNEXT(reqp) - reqp's next pointer
- *  REQPNEXTP(reqp) - pointer to reqp's next pointer
- *  REQPTIME(reqp) - reqp's time stamp value
- *  REQTIMESTAMP() - system time stamp value
- */
-typedef struct scsi_cmnd REQ, *REQP;
-#define REQPNEXT(reqp)       ((REQP) ((reqp)->host_scribble))
-#define REQPNEXTP(reqp)      ((REQP *) &((reqp)->host_scribble))
-#define REQPTID(reqp)        ((reqp)->device->id)
-#define REQPTIME(reqp)       ((reqp)->SCp.this_residual)
-#define REQTIMESTAMP()       (jiffies)
-
-#define REQTIMESTAT(function, ascq, reqp, tid) \
-{ \
-    /*
-     * If the request time stamp is less than the system time stamp, then \
-     * maybe the system time stamp wrapped. Set the request time to zero.\
-     */ \
-    if (REQPTIME(reqp) <= REQTIMESTAMP()) { \
-        REQPTIME(reqp) = REQTIMESTAMP() - REQPTIME(reqp); \
-    } else { \
-        /* Indicate an error occurred with the assertion. */ \
-        ASC_ASSERT(REQPTIME(reqp) <= REQTIMESTAMP()); \
-        REQPTIME(reqp) = 0; \
-    } \
-    /* Handle first minimum time case without external initialization. */ \
-    if (((ascq)->q_tot_cnt[tid] == 1) ||  \
-        (REQPTIME(reqp) < (ascq)->q_min_tim[tid])) { \
-            (ascq)->q_min_tim[tid] = REQPTIME(reqp); \
-            ASC_DBG3(1, "%s: new q_min_tim[%d] %u\n", \
-                (function), (tid), (ascq)->q_min_tim[tid]); \
-        } \
-    if (REQPTIME(reqp) > (ascq)->q_max_tim[tid]) { \
-        (ascq)->q_max_tim[tid] = REQPTIME(reqp); \
-        ASC_DBG3(1, "%s: new q_max_tim[%d] %u\n", \
-            (function), tid, (ascq)->q_max_tim[tid]); \
-    } \
-    (ascq)->q_tot_tim[tid] += REQPTIME(reqp); \
-    /* Reset the time stamp field. */ \
-    REQPTIME(reqp) = 0; \
-}
-
-/* asc_enqueue() flags */
-#define ASC_FRONT       1
-#define ASC_BACK        2
-
-/* asc_dequeue_list() argument */
-#define ASC_TID_ALL        (-1)
-
-/* Return non-zero, if the queue is empty. */
-#define ASC_QUEUE_EMPTY(ascq)    ((ascq)->q_tidmask == 0)
-
 #ifndef ADVANSYS_STATS
 #define ASC_STATS(shost, counter)
 #define ASC_STATS_ADD(shost, counter, count)
@@ -2784,23 +2725,6 @@ struct asc_stats {
 #endif /* ADVANSYS_STATS */
 
 /*
- * Request queuing structure
- */
-typedef struct asc_queue {
-	ADV_SCSI_BIT_ID_TYPE q_tidmask;	/* queue mask */
-	REQP q_first[ADV_MAX_TID + 1];	/* first queued request */
-	REQP q_last[ADV_MAX_TID + 1];	/* last queued request */
-#ifdef ADVANSYS_STATS
-	short q_cur_cnt[ADV_MAX_TID + 1];	/* current queue count */
-	short q_max_cnt[ADV_MAX_TID + 1];	/* maximum queue count */
-	ADV_DCNT q_tot_cnt[ADV_MAX_TID + 1];	/* total enqueue count */
-	ADV_DCNT q_tot_tim[ADV_MAX_TID + 1];	/* total time queued */
-	ushort q_max_tim[ADV_MAX_TID + 1];	/* maximum time queued */
-	ushort q_min_tim[ADV_MAX_TID + 1];	/* minimum time queued */
-#endif				/* ADVANSYS_STATS */
-} asc_queue_t;
-
-/*
  * Adv Library Request Structures
  *
  * The following two structures are used to process Wide Board requests.
@@ -2851,7 +2775,6 @@ typedef struct asc_board {
 		ADV_DVC_CFG adv_dvc_cfg;	/* Wide board */
 	} dvc_cfg;
 	ushort asc_n_io_port;	/* Number I/O ports. */
-	asc_queue_t active;	/* Active command queue */
 	ADV_SCSI_BIT_ID_TYPE init_tidmask;	/* Target init./valid mask */
 	struct scsi_device *device[ADV_MAX_TID + 1];	/* Mid-Level Scsi Device */
 	ushort reqcnt[ADV_MAX_TID + 1];	/* Starvation request count */
@@ -2914,14 +2837,10 @@ static int asc_dbglvl = 3;
  */
 
 static int advansys_slave_configure(struct scsi_device *);
-static void asc_scsi_done_list(struct scsi_cmnd *);
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
 static int asc_build_req(asc_board_t *, struct scsi_cmnd *);
 static int adv_build_req(asc_board_t *, struct scsi_cmnd *, ADV_SCSI_REQ_Q **);
 static int adv_get_sglist(asc_board_t *, adv_req_t *, struct scsi_cmnd *, int);
-static void asc_enqueue(asc_queue_t *, REQP, int);
-static REQP asc_dequeue_list(asc_queue_t *, REQP *, int);
-static int asc_rmqueue(asc_queue_t *, REQP);
 #ifdef CONFIG_PROC_FS
 static int asc_proc_copy(off_t, off_t, char *, int, char *, int);
 static int asc_prt_board_devices(struct Scsi_Host *, char *, int);
@@ -2939,7 +2858,6 @@ static int asc_prt_line(char *, int, char *fmt, ...);
 #ifdef ADVANSYS_STATS
 #ifdef CONFIG_PROC_FS
 static int asc_prt_board_stats(struct Scsi_Host *, char *, int);
-static int asc_prt_target_stats(struct Scsi_Host *, int, char *, int);
 #endif /* CONFIG_PROC_FS */
 #endif /* ADVANSYS_STATS */
 
@@ -2991,9 +2909,6 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	int leftlen;
 	char *curbuf;
 	off_t advoffset;
-#ifdef ADVANSYS_STATS
-	int tgt_id;
-#endif /* ADVANSYS_STATS */
 
 	ASC_DBG(1, "advansys_proc_info: begin\n");
 
@@ -3123,26 +3038,6 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	}
 	advoffset += cplen;
 	curbuf += cnt;
-
-	/*
-	 * Display driver statistics for each target.
-	 */
-	for (tgt_id = 0; tgt_id <= ADV_MAX_TID; tgt_id++) {
-		cp = boardp->prtbuf;
-		cplen = asc_prt_target_stats(shost, tgt_id, cp,
-					     ASC_PRTBUF_SIZE);
-		ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
-		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
-				    cplen);
-		totcnt += cnt;
-		leftlen -= cnt;
-		if (leftlen == 0) {
-			ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-			return totcnt;
-		}
-		advoffset += cplen;
-		curbuf += cnt;
-	}
 #endif /* ADVANSYS_STATS */
 
 	/*
@@ -3331,8 +3226,6 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	ulong flags;
-	struct scsi_cmnd *done_scp = NULL, *last_scp = NULL;
-	struct scsi_cmnd *tscp, *new_last_scp;
 	int status;
 	int ret = SUCCESS;
 
@@ -3423,34 +3316,6 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	}
 	/* Board lock is held. */
 
-	/*
-	 * Dequeue all board 'active' requests for all devices and set
-	 * the request status to DID_RESET. A pointer to the last request
-	 * is returned in 'last_scp'.
-	 */
-	if (done_scp == NULL) {
-		done_scp = asc_dequeue_list(&boardp->active, &last_scp,
-					    ASC_TID_ALL);
-		for (tscp = done_scp; tscp; tscp = REQPNEXT(tscp)) {
-			tscp->result = HOST_BYTE(DID_RESET);
-		}
-	} else {
-		/* Append to 'done_scp' at the end with 'last_scp'. */
-		ASC_ASSERT(last_scp != NULL);
-		last_scp->host_scribble =
-		    (unsigned char *)asc_dequeue_list(&boardp->active,
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
 
@@ -3458,12 +3323,6 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	boardp->flags &= ~ASC_HOST_IN_RESET;
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
-	/*
-	 * Complete all the 'done_scp' requests.
-	 */
-	if (done_scp)
-		asc_scsi_done_list(done_scp);
-
 	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
 
 	return ret;
@@ -3795,30 +3654,6 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 }
 
 /*
- * Complete all requests on the singly linked list pointed
- * to by 'scp'.
- *
- * Interrupts can be enabled on entry.
- */
-static void asc_scsi_done_list(struct scsi_cmnd *scp)
-{
-	struct scsi_cmnd *tscp;
-
-	ASC_DBG(2, "asc_scsi_done_list: begin\n");
-	while (scp != NULL) {
-		ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong)scp);
-		tscp = REQPNEXT(scp);
-		scp->host_scribble = NULL;
-
-		asc_scsi_done(scp);
-
-		scp = tscp;
-	}
-	ASC_DBG(2, "asc_scsi_done_list: done\n");
-	return;
-}
-
-/*
  * Execute a single 'Scsi_Cmnd'.
  *
  * The function 'done' is called when the request has been completed.
@@ -3854,9 +3689,8 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
  *    scsi_done - used to save caller's done function
  *    host_scribble - used for pointer to another struct scsi_cmnd
  *
- * If this function returns ASC_NOERROR the request has been enqueued
- * on the board's 'active' queue and will be completed from the
- * interrupt handler.
+ * If this function returns ASC_NOERROR the request will be completed
+ * from the interrupt handler.
  *
  * If this function returns ASC_ERROR the host error code has been set,
  * and the called must call asc_scsi_done.
@@ -3901,10 +3735,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			return ASC_ERROR;
 		}
 
-		/*
-		 * Execute the command. If there is no error, add the command
-		 * to the active queue.
-		 */
 		switch (ret = AscExeScsiQueue(asc_dvc_varp, &asc_scsi_q)) {
 		case ASC_NOERROR:
 			ASC_STATS(scp->device->host, exe_noerror);
@@ -3913,7 +3743,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			 * successful request counter. Wrapping doesn't matter.
 			 */
 			boardp->reqcnt[scp->device->id]++;
-			asc_enqueue(&boardp->active, scp, ASC_BACK);
 			ASC_DBG(1, "asc_execute_scsi_cmnd: AscExeScsiQueue(), "
 				"ASC_NOERROR\n");
 			break;
@@ -3970,10 +3799,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			return ASC_ERROR;
 		}
 
-		/*
-		 * Execute the command. If there is no error, add the command
-		 * to the active queue.
-		 */
 		switch (ret = AdvExeScsiQueue(adv_dvc_varp, adv_scsiqp)) {
 		case ASC_NOERROR:
 			ASC_STATS(scp->device->host, exe_noerror);
@@ -3982,7 +3807,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			 * successful request counter. Wrapping doesn't matter.
 			 */
 			boardp->reqcnt[scp->device->id]++;
-			asc_enqueue(&boardp->active, scp, ASC_BACK);
 			ASC_DBG(1, "asc_execute_scsi_cmnd: AdvExeScsiQueue(), "
 				"ASC_NOERROR\n");
 			break;
@@ -4467,19 +4291,8 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
 
-	/*
-	 * If the request isn't found on the active queue, it may
-	 * have been removed to handle a reset request.
-	 * Display a message and return.
-	 */
 	boardp = ASC_BOARDP(shost);
 	ASC_ASSERT(asc_dvc_varp == &boardp->dvc_var.asc_dvc_var);
-	if (asc_rmqueue(&boardp->active, scp) == ASC_FALSE) {
-		ASC_PRINT2
-		    ("asc_isr_callback: board %d: scp 0x%lx not on active queue\n",
-		     boardp->id, (ulong)scp);
-		return;
-	}
 
 	/*
 	 * 'qdonep' contains the command's ending status.
@@ -4624,21 +4437,8 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
 
-	/*
-	 * If the request isn't found on the active queue, it may have been
-	 * removed to handle a reset request. Display a message and return.
-	 *
-	 * Note: Because the structure may still be in use don't attempt
-	 * to free the adv_req_t and adv_sgblk_t, if any, structures.
-	 */
 	boardp = ASC_BOARDP(shost);
 	ASC_ASSERT(adv_dvc_varp == &boardp->dvc_var.adv_dvc_var);
-	if (asc_rmqueue(&boardp->active, scp) == ASC_FALSE) {
-		ASC_PRINT2
-		    ("adv_isr_callback: board %d: scp 0x%lx not on active queue\n",
-		     boardp->id, (ulong)scp);
-		return;
-	}
 
 	/*
 	 * 'done_status' contains the command's ending status.
@@ -4787,225 +4587,6 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
 	}
 }
 
-/*
- * Add a 'REQP' to the end of specified queue. Set 'tidmask'
- * to indicate a command is queued for the device.
- *
- * 'flag' may be either ASC_FRONT or ASC_BACK.
- *
- * 'REQPNEXT(reqp)' returns reqp's next pointer.
- */
-static void asc_enqueue(asc_queue_t *ascq, REQP reqp, int flag)
-{
-	int tid;
-
-	ASC_DBG3(3, "asc_enqueue: ascq 0x%lx, reqp 0x%lx, flag %d\n",
-		 (ulong)ascq, (ulong)reqp, flag);
-	ASC_ASSERT(reqp != NULL);
-	ASC_ASSERT(flag == ASC_FRONT || flag == ASC_BACK);
-	tid = REQPTID(reqp);
-	ASC_ASSERT(tid >= 0 && tid <= ADV_MAX_TID);
-	if (flag == ASC_FRONT) {
-		reqp->host_scribble = (unsigned char *)ascq->q_first[tid];
-		ascq->q_first[tid] = reqp;
-		/* If the queue was empty, set the last pointer. */
-		if (ascq->q_last[tid] == NULL) {
-			ascq->q_last[tid] = reqp;
-		}
-	} else {		/* ASC_BACK */
-		if (ascq->q_last[tid] != NULL) {
-			ascq->q_last[tid]->host_scribble =
-			    (unsigned char *)reqp;
-		}
-		ascq->q_last[tid] = reqp;
-		reqp->host_scribble = NULL;
-		/* If the queue was empty, set the first pointer. */
-		if (ascq->q_first[tid] == NULL) {
-			ascq->q_first[tid] = reqp;
-		}
-	}
-	/* The queue has at least one entry, set its bit. */
-	ascq->q_tidmask |= ADV_TID_TO_TIDMASK(tid);
-#ifdef ADVANSYS_STATS
-	/* Maintain request queue statistics. */
-	ascq->q_tot_cnt[tid]++;
-	ascq->q_cur_cnt[tid]++;
-	if (ascq->q_cur_cnt[tid] > ascq->q_max_cnt[tid]) {
-		ascq->q_max_cnt[tid] = ascq->q_cur_cnt[tid];
-		ASC_DBG2(2, "asc_enqueue: new q_max_cnt[%d] %d\n",
-			 tid, ascq->q_max_cnt[tid]);
-	}
-	REQPTIME(reqp) = REQTIMESTAMP();
-#endif /* ADVANSYS_STATS */
-	ASC_DBG1(3, "asc_enqueue: reqp 0x%lx\n", (ulong)reqp);
-	return;
-}
-
-/*
- * Return a pointer to a singly linked list of all the requests queued
- * for 'tid' on the 'asc_queue_t' pointed to by 'ascq'.
- *
- * If 'lastpp' is not NULL, '*lastpp' will be set to point to the
- * the last request returned in the singly linked list.
- *
- * 'tid' should either be a valid target id or if it is ASC_TID_ALL,
- * then all queued requests are concatenated into one list and
- * returned.
- *
- * Note: If 'lastpp' is used to append a new list to the end of
- * an old list, only change the old list last pointer if '*lastpp'
- * (or the function return value) is not NULL, i.e. use a temporary
- * variable for 'lastpp' and check its value after the function return
- * before assigning it to the list last pointer.
- *
- * Unfortunately collecting queuing time statistics adds overhead to
- * the function that isn't inherent to the function's algorithm.
- */
-static REQP asc_dequeue_list(asc_queue_t *ascq, REQP *lastpp, int tid)
-{
-	REQP firstp, lastp;
-	int i;
-
-	ASC_DBG2(3, "asc_dequeue_list: ascq 0x%lx, tid %d\n", (ulong)ascq, tid);
-	ASC_ASSERT((tid == ASC_TID_ALL) || (tid >= 0 && tid <= ADV_MAX_TID));
-
-	/*
-	 * If 'tid' is not ASC_TID_ALL, return requests only for
-	 * the specified 'tid'. If 'tid' is ASC_TID_ALL, return all
-	 * requests for all tids.
-	 */
-	if (tid != ASC_TID_ALL) {
-		/* Return all requests for the specified 'tid'. */
-		if ((ascq->q_tidmask & ADV_TID_TO_TIDMASK(tid)) == 0) {
-			/* List is empty; Set first and last return pointers to NULL. */
-			firstp = lastp = NULL;
-		} else {
-			firstp = ascq->q_first[tid];
-			lastp = ascq->q_last[tid];
-			ascq->q_first[tid] = ascq->q_last[tid] = NULL;
-			ascq->q_tidmask &= ~ADV_TID_TO_TIDMASK(tid);
-#ifdef ADVANSYS_STATS
-			{
-				REQP reqp;
-				ascq->q_cur_cnt[tid] = 0;
-				for (reqp = firstp; reqp; reqp = REQPNEXT(reqp)) {
-					REQTIMESTAT("asc_dequeue_list", ascq,
-						    reqp, tid);
-				}
-			}
-#endif /* ADVANSYS_STATS */
-		}
-	} else {
-		/* Return all requests for all tids. */
-		firstp = lastp = NULL;
-		for (i = 0; i <= ADV_MAX_TID; i++) {
-			if (ascq->q_tidmask & ADV_TID_TO_TIDMASK(i)) {
-				if (firstp == NULL) {
-					firstp = ascq->q_first[i];
-					lastp = ascq->q_last[i];
-				} else {
-					ASC_ASSERT(lastp != NULL);
-					lastp->host_scribble =
-					    (unsigned char *)ascq->q_first[i];
-					lastp = ascq->q_last[i];
-				}
-				ascq->q_first[i] = ascq->q_last[i] = NULL;
-				ascq->q_tidmask &= ~ADV_TID_TO_TIDMASK(i);
-#ifdef ADVANSYS_STATS
-				ascq->q_cur_cnt[i] = 0;
-#endif /* ADVANSYS_STATS */
-			}
-		}
-#ifdef ADVANSYS_STATS
-		{
-			REQP reqp;
-			for (reqp = firstp; reqp; reqp = REQPNEXT(reqp)) {
-				REQTIMESTAT("asc_dequeue_list", ascq, reqp,
-					    reqp->device->id);
-			}
-		}
-#endif /* ADVANSYS_STATS */
-	}
-	if (lastpp) {
-		*lastpp = lastp;
-	}
-	ASC_DBG1(3, "asc_dequeue_list: firstp 0x%lx\n", (ulong)firstp);
-	return firstp;
-}
-
-/*
- * Remove the specified 'REQP' from the specified queue for
- * the specified target device. Clear the 'tidmask' bit for the
- * device if no more commands are left queued for it.
- *
- * 'REQPNEXT(reqp)' returns reqp's the next pointer.
- *
- * Return ASC_TRUE if the command was found and removed,
- * otherwise return ASC_FALSE.
- */
-static int asc_rmqueue(asc_queue_t *ascq, REQP reqp)
-{
-	REQP currp, prevp;
-	int tid;
-	int ret = ASC_FALSE;
-
-	ASC_DBG2(3, "asc_rmqueue: ascq 0x%lx, reqp 0x%lx\n",
-		 (ulong)ascq, (ulong)reqp);
-	ASC_ASSERT(reqp != NULL);
-
-	tid = REQPTID(reqp);
-	ASC_ASSERT(tid >= 0 && tid <= ADV_MAX_TID);
-
-	/*
-	 * Handle the common case of 'reqp' being the first
-	 * entry on the queue.
-	 */
-	if (reqp == ascq->q_first[tid]) {
-		ret = ASC_TRUE;
-		ascq->q_first[tid] = REQPNEXT(reqp);
-		/* If the queue is now empty, clear its bit and the last pointer. */
-		if (ascq->q_first[tid] == NULL) {
-			ascq->q_tidmask &= ~ADV_TID_TO_TIDMASK(tid);
-			ASC_ASSERT(ascq->q_last[tid] == reqp);
-			ascq->q_last[tid] = NULL;
-		}
-	} else if (ascq->q_first[tid] != NULL) {
-		ASC_ASSERT(ascq->q_last[tid] != NULL);
-		/*
-		 * Because the case of 'reqp' being the first entry has been
-		 * handled above and it is known the queue is not empty, if
-		 * 'reqp' is found on the queue it is guaranteed the queue will
-		 * not become empty and that 'q_first[tid]' will not be changed.
-		 *
-		 * Set 'prevp' to the first entry, 'currp' to the second entry,
-		 * and search for 'reqp'.
-		 */
-		for (prevp = ascq->q_first[tid], currp = REQPNEXT(prevp);
-		     currp; prevp = currp, currp = REQPNEXT(currp)) {
-			if (currp == reqp) {
-				ret = ASC_TRUE;
-				prevp->host_scribble =
-				    (unsigned char *)REQPNEXT(currp);
-				reqp->host_scribble = NULL;
-				if (ascq->q_last[tid] == reqp) {
-					ascq->q_last[tid] = prevp;
-				}
-				break;
-			}
-		}
-	}
-#ifdef ADVANSYS_STATS
-	/* Maintain request queue statistics. */
-	if (ret == ASC_TRUE) {
-		ascq->q_cur_cnt[tid]--;
-		REQTIMESTAT("asc_rmqueue", ascq, reqp, tid);
-	}
-	ASC_ASSERT(ascq->q_cur_cnt[tid] >= 0);
-#endif /* ADVANSYS_STATS */
-	ASC_DBG2(3, "asc_rmqueue: reqp 0x%lx, ret %d\n", (ulong)reqp, ret);
-	return ret;
-}
-
 #ifdef CONFIG_PROC_FS
 /*
  * asc_prt_board_devices()
@@ -6465,79 +6046,6 @@ static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 
 	return totlen;
 }
-
-/*
- * asc_prt_target_stats()
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * This is separated from asc_prt_board_stats because a full set
- * of targets will overflow ASC_PRTBUF_SIZE.
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
- */
-static int
-asc_prt_target_stats(struct Scsi_Host *shost, int tgt_id, char *cp, int cplen)
-{
-	int leftlen;
-	int totlen;
-	int len;
-	struct asc_stats *s;
-	ushort chip_scsi_id;
-	asc_board_t *boardp;
-	asc_queue_t *active;
-
-	leftlen = cplen;
-	totlen = len = 0;
-
-	boardp = ASC_BOARDP(shost);
-	s = &boardp->asc_stats;
-
-	active = &ASC_BOARDP(shost)->active;
-
-	if (ASC_NARROW_BOARD(boardp)) {
-		chip_scsi_id = boardp->dvc_cfg.asc_dvc_cfg.chip_scsi_id;
-	} else {
-		chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
-	}
-
-	if ((chip_scsi_id == tgt_id) ||
-	    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(tgt_id)) == 0)) {
-		return 0;
-	}
-
-	do {
-		if (active->q_tot_cnt[tgt_id] > 0) {
-			len = asc_prt_line(cp, leftlen, " target %d\n", tgt_id);
-			ASC_PRT_NEXT();
-
-			len = asc_prt_line(cp, leftlen,
-					   "   active: cnt [cur %d, max %d, tot %u], time [min %d, max %d, avg %lu.%01lu]\n",
-					   active->q_cur_cnt[tgt_id],
-					   active->q_max_cnt[tgt_id],
-					   active->q_tot_cnt[tgt_id],
-					   active->q_min_tim[tgt_id],
-					   active->q_max_tim[tgt_id],
-					   (active->q_tot_cnt[tgt_id] ==
-					    0) ? 0 : (active->
-						      q_tot_tim[tgt_id] /
-						      active->
-						      q_tot_cnt[tgt_id]),
-					   (active->q_tot_cnt[tgt_id] ==
-					    0) ? 0 : ASC_TENTHS(active->
-								q_tot_tim
-								[tgt_id],
-								active->
-								q_tot_cnt
-								[tgt_id]));
-			ASC_PRT_NEXT();
-		}
-	} while (0);
-
-	return totlen;
-}
 #endif /* CONFIG_PROC_FS */
 #endif /* ADVANSYS_STATS */
 
-- 
1.5.2.4

