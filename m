From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/16] libfc: Do not invoke the response handler after
 fc_exch_done()
Date: Thu, 05 Sep 2013 12:13:22 -0700
Message-ID: <20130905191322.15235.24868.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab3IETNY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:24 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

While the FCoE initiator driver invokes fc_exch_done() from inside
the libfc response handler, FCoE target drivers typically invoke
fc_exch_done() from outside the libfc response handler. The object
fc_exch.arg points at may disappear as soon as fc_exch_done() has
finished. So it's important not to invoke the response handler
function after fc_exch_done() has finished. Modify libfc such that
this guarantee is provided if fc_exch_done() is invoked from
outside a response handler. This patch fixes a sporadic crash in
FCoE target implementations after a command has been aborted.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |  131 +++++++++++++++++++++++++++++-------------
 include/scsi/libfc.h         |    9 +++
 2 files changed, 101 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 47ebc7b..1b3a094 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -381,6 +381,8 @@ static void fc_exch_timer_set(struct fc_exch *ep, unsigned int timer_msec)
 /**
  * fc_exch_done_locked() - Complete an exchange with the exchange lock held
  * @ep: The exchange that is complete
+ *
+ * Note: May sleep if invoked from outside a response handler.
  */
 static int fc_exch_done_locked(struct fc_exch *ep)
 {
@@ -392,7 +394,6 @@ static int fc_exch_done_locked(struct fc_exch *ep)
 	 * ep, and in that case we only clear the resp and set it as
 	 * complete, so it can be reused by the timer to send the rrq.
 	 */
-	ep->resp = NULL;
 	if (ep->state & FC_EX_DONE)
 		return rc;
 	ep->esb_stat |= ESB_ST_COMPLETE;
@@ -589,6 +590,8 @@ static struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
 
 /*
  * Set the response handler for the exchange associated with a sequence.
+ *
+ * Note: May sleep if invoked from outside a response handler.
  */
 static void fc_seq_set_resp(struct fc_seq *sp,
 			    void (*resp)(struct fc_seq *, struct fc_frame *,
@@ -596,8 +599,18 @@ static void fc_seq_set_resp(struct fc_seq *sp,
 			    void *arg)
 {
 	struct fc_exch *ep = fc_seq_exch(sp);
+	DEFINE_WAIT(wait);
 
 	spin_lock_bh(&ep->ex_lock);
+	while (ep->resp_active && ep->resp_task != current) {
+		prepare_to_wait(&ep->resp_wq, &wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock_bh(&ep->ex_lock);
+
+		schedule();
+
+		spin_lock_bh(&ep->ex_lock);
+	}
+	finish_wait(&ep->resp_wq, &wait);
 	ep->resp = resp;
 	ep->arg = arg;
 	spin_unlock_bh(&ep->ex_lock);
@@ -681,6 +694,61 @@ static int fc_seq_exch_abort(const struct fc_seq *req_sp,
 }
 
 /**
+ * fc_invoke_resp() - invoke ep->resp()
+ *
+ * Notes:
+ * It is assumed that after initialization finished (this means the
+ * first unlock of ex_lock after fc_exch_alloc()) ep->resp and ep->arg are
+ * modified only via fc_seq_set_resp(). This guarantees that none of these
+ * two variables changes if ep->resp_active > 0.
+ *
+ * If an fc_seq_set_resp() call is busy modifying ep->resp and ep->arg when
+ * this function is invoked, the first spin_lock_bh() call in this function
+ * will wait until fc_seq_set_resp() has finished modifying these variables.
+ *
+ * Since fc_exch_done() invokes fc_seq_set_resp() it is guaranteed that that
+ * ep->resp() won't be invoked after fc_exch_done() has returned.
+ *
+ * The response handler itself may invoke fc_exch_done(), which will clear the
+ * ep->resp pointer.
+ *
+ * Return value:
+ * Returns true if and only if ep->resp has been invoked.
+ */
+static bool fc_invoke_resp(struct fc_exch *ep, struct fc_seq *sp,
+			   struct fc_frame *fp)
+{
+	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
+	void *arg;
+	bool res = false;
+
+	spin_lock_bh(&ep->ex_lock);
+	ep->resp_active++;
+	if (ep->resp_task != current)
+		ep->resp_task = !ep->resp_task ? current : NULL;
+	resp = ep->resp;
+	arg = ep->arg;
+	spin_unlock_bh(&ep->ex_lock);
+
+	if (resp) {
+		resp(sp, fp, arg);
+		res = true;
+	} else if (!IS_ERR(fp)) {
+		fc_frame_free(fp);
+	}
+
+	spin_lock_bh(&ep->ex_lock);
+	if (--ep->resp_active == 0)
+		ep->resp_task = NULL;
+	spin_unlock_bh(&ep->ex_lock);
+
+	if (ep->resp_active == 0)
+		wake_up(&ep->resp_wq);
+
+	return res;
+}
+
+/**
  * fc_exch_timeout() - Handle exchange timer expiration
  * @work: The work_struct identifying the exchange that timed out
  */
@@ -689,8 +757,6 @@ static void fc_exch_timeout(struct work_struct *work)
 	struct fc_exch *ep = container_of(work, struct fc_exch,
 					  timeout_work.work);
 	struct fc_seq *sp = &ep->seq;
-	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
-	void *arg;
 	u32 e_stat;
 	int rc = 1;
 
@@ -708,16 +774,13 @@ static void fc_exch_timeout(struct work_struct *work)
 			fc_exch_rrq(ep);
 		goto done;
 	} else {
-		resp = ep->resp;
-		arg = ep->arg;
-		ep->resp = NULL;
 		if (e_stat & ESB_ST_ABNORMAL)
 			rc = fc_exch_done_locked(ep);
 		spin_unlock_bh(&ep->ex_lock);
 		if (!rc)
 			fc_exch_delete(ep);
-		if (resp)
-			resp(sp, ERR_PTR(-FC_EX_TIMEOUT), arg);
+		fc_invoke_resp(ep, sp, ERR_PTR(-FC_EX_TIMEOUT));
+		fc_seq_set_resp(sp, NULL, ep->arg);
 		fc_seq_exch_abort(sp, 2 * ep->r_a_tov);
 		goto done;
 	}
@@ -804,6 +867,8 @@ hit:
 	ep->f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
 	ep->rxid = FC_XID_UNKNOWN;
 	ep->class = mp->class;
+	ep->resp_active = 0;
+	init_waitqueue_head(&ep->resp_wq);
 	INIT_DELAYED_WORK(&ep->timeout_work, fc_exch_timeout);
 out:
 	return ep;
@@ -864,6 +929,8 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
  * fc_exch_done() - Indicate that an exchange/sequence tuple is complete and
  *		    the memory allocated for the related objects may be freed.
  * @sp: The sequence that has completed
+ *
+ * Note: May sleep if invoked from outside a response handler.
  */
 static void fc_exch_done(struct fc_seq *sp)
 {
@@ -873,6 +940,8 @@ static void fc_exch_done(struct fc_seq *sp)
 	spin_lock_bh(&ep->ex_lock);
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
+
+	fc_seq_set_resp(sp, NULL, ep->arg);
 	if (!rc)
 		fc_exch_delete(ep);
 }
@@ -1436,9 +1505,7 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 		 * If new exch resp handler is valid then call that
 		 * first.
 		 */
-		if (ep->resp)
-			ep->resp(sp, fp, ep->arg);
-		else
+		if (!fc_invoke_resp(ep, sp, fp))
 			lport->tt.lport_recv(lport, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
@@ -1462,8 +1529,6 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	struct fc_exch *ep;
 	enum fc_sof sof;
 	u32 f_ctl;
-	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
-	void *ex_resp_arg;
 	int rc;
 
 	ep = fc_exch_find(mp, ntohs(fh->fh_ox_id));
@@ -1506,14 +1571,11 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 
 	if (fc_sof_needs_ack(sof))
 		fc_seq_send_ack(sp, fp);
-	resp = ep->resp;
-	ex_resp_arg = ep->arg;
 
 	if (fh->fh_type != FC_TYPE_FCP && fr_eof(fp) == FC_EOF_T &&
 	    (f_ctl & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
 		spin_lock_bh(&ep->ex_lock);
-		resp = ep->resp;
 		rc = fc_exch_done_locked(ep);
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);
@@ -1534,10 +1596,8 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	 * If new exch resp handler is valid then call that
 	 * first.
 	 */
-	if (resp)
-		resp(sp, fp, ex_resp_arg);
-	else
-		fc_frame_free(fp);
+	fc_invoke_resp(ep, sp, fp);
+
 	fc_exch_release(ep);
 	return;
 rel:
@@ -1576,8 +1636,6 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
  */
 static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 {
-	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
-	void *ex_resp_arg;
 	struct fc_frame_header *fh;
 	struct fc_ba_acc *ap;
 	struct fc_seq *sp;
@@ -1622,9 +1680,6 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 		break;
 	}
 
-	resp = ep->resp;
-	ex_resp_arg = ep->arg;
-
 	/* do we need to do some other checks here. Can we reuse more of
 	 * fc_exch_recv_seq_resp
 	 */
@@ -1636,17 +1691,14 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	    ntoh24(fh->fh_f_ctl) & FC_FC_LAST_SEQ)
 		rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
+
+	fc_exch_hold(ep);
 	if (!rc)
 		fc_exch_delete(ep);
-
-	if (resp)
-		resp(sp, fp, ex_resp_arg);
-	else
-		fc_frame_free(fp);
-
+	fc_invoke_resp(ep, sp, fp);
 	if (has_rec)
 		fc_exch_timer_set(ep, ep->r_a_tov);
-
+	fc_exch_release(ep);
 }
 
 /**
@@ -1768,32 +1820,33 @@ static void fc_seq_ls_rjt(struct fc_frame *rx_fp, enum fc_els_rjt_reason reason,
 /**
  * fc_exch_reset() - Reset an exchange
  * @ep: The exchange to be reset
+ *
+ * Note: May sleep if invoked from outside a response handler.
  */
 static void fc_exch_reset(struct fc_exch *ep)
 {
 	struct fc_seq *sp;
-	void (*resp)(struct fc_seq *, struct fc_frame *, void *);
-	void *arg;
 	int rc = 1;
 
 	spin_lock_bh(&ep->ex_lock);
 	fc_exch_abort_locked(ep, 0);
 	ep->state |= FC_EX_RST_CLEANUP;
 	fc_exch_timer_cancel(ep);
-	resp = ep->resp;
-	ep->resp = NULL;
 	if (ep->esb_stat & ESB_ST_REC_QUAL)
 		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec_qual */
 	ep->esb_stat &= ~ESB_ST_REC_QUAL;
-	arg = ep->arg;
 	sp = &ep->seq;
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
+
+	fc_exch_hold(ep);
+
 	if (!rc)
 		fc_exch_delete(ep);
 
-	if (resp)
-		resp(sp, ERR_PTR(-FC_EX_CLOSED), arg);
+	fc_invoke_resp(ep, sp, ERR_PTR(-FC_EX_CLOSED));
+	fc_seq_set_resp(sp, NULL, ep->arg);
+	fc_exch_release(ep);
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index e1379b4..52beadf 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -410,6 +410,12 @@ struct fc_seq {
  * @fh_type:      The frame type
  * @class:        The class of service
  * @seq:          The sequence in use on this exchange
+ * @resp_active:  Number of tasks that are concurrently executing @resp().
+ * @resp_task:    If @resp_active > 0, either the task executing @resp(), the
+ *                task that has been interrupted to execute the soft-IRQ
+ *                executing @resp() or NULL if more than one task is executing
+ *                @resp concurrently.
+ * @resp_wq:      Waitqueue for the tasks waiting on @resp_active.
  * @resp:         Callback for responses on this exchange
  * @destructor:   Called when destroying the exchange
  * @arg:          Passed as a void pointer to the resp() callback
@@ -441,6 +447,9 @@ struct fc_exch {
 	u32		    r_a_tov;
 	u32		    f_ctl;
 	struct fc_seq       seq;
+	int		    resp_active;
+	struct task_struct  *resp_task;
+	wait_queue_head_t   resp_wq;
 	void		    (*resp)(struct fc_seq *, struct fc_frame *, void *);
 	void		    *arg;
 	void		    (*destructor)(struct fc_seq *, void *);

