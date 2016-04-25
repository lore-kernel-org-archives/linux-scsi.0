From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 05/12] scsi_debug: replace tasklet with work queue
Date: Mon, 25 Apr 2016 12:16:32 -0400
Message-ID: <1461600999-28893-6-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36969 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbcDYQQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:16:56 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

When a negative value was placed in the delay parameter, a tasklet
was scheduled. Change the tasklet to a work queue. Previously a
delay of -1 scheduled a high priority tasklet; since there are no
high priority work queues, treat -1 like other negative values
in delay and schedule a work item.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 230 +++++++++++++++++++---------------------------
 1 file changed, 95 insertions(+), 135 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5ad16e6..8ee9df6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -610,15 +610,15 @@ static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
 
-struct sdebug_hrtimer {		/* ... is derived from hrtimer */
-	struct hrtimer hrt;	/* must be first element */
+struct sdebug_defer {
+	struct hrtimer hrt;
+	struct execute_work ew;
 	int qa_indx;
 };
 
 struct sdebug_queued_cmd {
 	/* in_use flagged by a bit in queued_in_use_bm[] */
-	struct tasklet_struct *tletp;
-	struct sdebug_hrtimer *sd_hrtp;
+	struct sdebug_defer *sd_dp;
 	struct scsi_cmnd * a_cmnd;
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
@@ -3349,8 +3349,9 @@ resp_xdwriteread_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return resp_xdwriteread(scp, lba, num, devip);
 }
 
-/* When tasklet goes off this function is called. */
-static void sdebug_q_cmd_complete(unsigned long indx)
+/* Queued command completions converge here. */
+static void
+sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
 	int qa_indx;
 	int retiring = 0;
@@ -3360,7 +3361,7 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 	struct sdebug_dev_info *devip;
 
 	atomic_inc(&sdebug_completions);
-	qa_indx = indx;
+	qa_indx = sd_dp->qa_indx;
 	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
 		pr_err("wild qa_indx=%d\n", qa_indx);
 		return;
@@ -3411,64 +3412,21 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 static enum hrtimer_restart
 sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 {
-	int qa_indx;
-	int retiring = 0;
-	unsigned long iflags;
-	struct sdebug_hrtimer *sd_hrtp = (struct sdebug_hrtimer *)timer;
-	struct sdebug_queued_cmd *sqcp;
-	struct scsi_cmnd *scp;
-	struct sdebug_dev_info *devip;
-
-	atomic_inc(&sdebug_completions);
-	qa_indx = sd_hrtp->qa_indx;
-	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
-		pr_err("wild qa_indx=%d\n", qa_indx);
-		goto the_end;
-	}
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	sqcp = &queued_arr[qa_indx];
-	scp = sqcp->a_cmnd;
-	if (NULL == scp) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("scp is NULL\n");
-		goto the_end;
-	}
-	devip = (struct sdebug_dev_info *)scp->device->hostdata;
-	if (devip)
-		atomic_dec(&devip->num_in_q);
-	else
-		pr_err("devip=NULL\n");
-	if (atomic_read(&retired_max_queue) > 0)
-		retiring = 1;
-
-	sqcp->a_cmnd = NULL;
-	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("Unexpected completion\n");
-		goto the_end;
-	}
-
-	if (unlikely(retiring)) {	/* user has reduced max_queue */
-		int k, retval;
-
-		retval = atomic_read(&retired_max_queue);
-		if (qa_indx >= retval) {
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			pr_err("index %d too large\n", retval);
-			goto the_end;
-		}
-		k = find_last_bit(queued_in_use_bm, retval);
-		if ((k < sdebug_max_queue) || (k == retval))
-			atomic_set(&retired_max_queue, 0);
-		else
-			atomic_set(&retired_max_queue, k + 1);
-	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	scp->scsi_done(scp); /* callback to mid level */
-the_end:
+	struct sdebug_defer *sd_dp = container_of(timer, struct sdebug_defer,
+						  hrt);
+	sdebug_q_cmd_complete(sd_dp);
 	return HRTIMER_NORESTART;
 }
 
+/* When work queue schedules work, it calls this function. */
+static void
+sdebug_q_cmd_wq_complete(struct work_struct *work)
+{
+	struct sdebug_defer *sd_dp = container_of(work, struct sdebug_defer,
+						  ew.work);
+	sdebug_q_cmd_complete(sd_dp);
+}
+
 static struct sdebug_dev_info *
 sdebug_device_create(struct sdebug_host_info *sdbg_host, gfp_t flags)
 {
@@ -3567,13 +3525,15 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	}
 }
 
-/* Returns 1 if cmnd found (deletes its timer or tasklet), else returns 0 */
-static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
+/* If @cmnd found deletes its timer or work queue and returns true; else
+   returns false */
+static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 {
 	unsigned long iflags;
 	int k, qmax, r_qmax;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
+	struct sdebug_defer *sd_dp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	qmax = sdebug_max_queue;
@@ -3583,64 +3543,63 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 	for (k = 0; k < qmax; ++k) {
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
-			if (cmnd == sqcp->a_cmnd) {
-				devip = (struct sdebug_dev_info *)
-					cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
-				spin_unlock_irqrestore(&queued_arr_lock,
-						       iflags);
-				if ((sdebug_jdelay > 0) ||
-				    (sdebug_ndelay > 0)) {
-					if (sqcp->sd_hrtp)
-						hrtimer_cancel(
-							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_jdelay < 0) {
-					if (sqcp->tletp)
-						tasklet_kill(sqcp->tletp);
-				}
-				clear_bit(k, queued_in_use_bm);
-				return 1;
+			if (cmnd != sqcp->a_cmnd)
+				continue;
+			/* found command */
+			devip = (struct sdebug_dev_info *)
+				cmnd->device->hostdata;
+			if (devip)
+				atomic_dec(&devip->num_in_q);
+			sqcp->a_cmnd = NULL;
+			sd_dp = sqcp->sd_dp;
+			spin_unlock_irqrestore(&queued_arr_lock,
+					       iflags);
+			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
+				if (sd_dp)
+					hrtimer_cancel(&sd_dp->hrt);
+			} else if (sdebug_jdelay < 0) {
+				if (sd_dp)
+					cancel_work_sync(&sd_dp->ew.work);
 			}
+			clear_bit(k, queued_in_use_bm);
+			return true;
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return 0;
+	return false;
 }
 
-/* Deletes (stops) timers or tasklets of all queued commands */
+/* Deletes (stops) timers or work queues of all queued commands */
 static void stop_all_queued(void)
 {
 	unsigned long iflags;
 	int k;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
+	struct sdebug_defer *sd_dp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
-			if (sqcp->a_cmnd) {
-				devip = (struct sdebug_dev_info *)
-					sqcp->a_cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
-				spin_unlock_irqrestore(&queued_arr_lock,
-						       iflags);
-				if ((sdebug_jdelay > 0) ||
-				    (sdebug_ndelay > 0)) {
-					if (sqcp->sd_hrtp)
-						hrtimer_cancel(
-							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_jdelay < 0) {
-					if (sqcp->tletp)
-						tasklet_kill(sqcp->tletp);
-				}
-				clear_bit(k, queued_in_use_bm);
-				spin_lock_irqsave(&queued_arr_lock, iflags);
+			if (NULL == sqcp->a_cmnd)
+				continue;
+			devip = (struct sdebug_dev_info *)
+				sqcp->a_cmnd->device->hostdata;
+			if (devip)
+				atomic_dec(&devip->num_in_q);
+			sqcp->a_cmnd = NULL;
+			sd_dp = sqcp->sd_dp;
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
+				if (sd_dp)
+					hrtimer_cancel(&sd_dp->hrt);
+			} else if (sdebug_jdelay < 0) {
+				if (sd_dp)
+					cancel_work_sync(&sd_dp->ew.work);
 			}
+			clear_bit(k, queued_in_use_bm);
+			spin_lock_irqsave(&queued_arr_lock, iflags);
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
@@ -3649,30 +3608,27 @@ static void stop_all_queued(void)
 /* Free queued command memory on heap */
 static void free_all_queued(void)
 {
-	unsigned long iflags;
 	int k;
 	struct sdebug_queued_cmd *sqcp;
 
-	spin_lock_irqsave(&queued_arr_lock, iflags);
 	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
 		sqcp = &queued_arr[k];
-		kfree(sqcp->tletp);
-		sqcp->tletp = NULL;
-		kfree(sqcp->sd_hrtp);
-		sqcp->sd_hrtp = NULL;
+		kfree(sqcp->sd_dp);
+		sqcp->sd_dp = NULL;
 	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
 static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 {
+	bool ok;
+
 	++num_aborts;
 	if (SCpnt) {
-		if (SCpnt->device &&
-		    (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
-			sdev_printk(KERN_INFO, SCpnt->device, "%s\n",
-				    __func__);
-		stop_queued_cmnd(SCpnt);
+		ok = stop_queued_cmnd(SCpnt);
+		if (SCpnt->device && (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
+			sdev_printk(KERN_INFO, SCpnt->device,
+				    "%s: command%s found\n", __func__,
+				    ok ? "" : " not");
 	}
 	return SUCCESS;
 }
@@ -3846,6 +3802,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	int k, num_in_q, qdepth, inject;
 	struct sdebug_queued_cmd *sqcp = NULL;
 	struct scsi_device *sdp;
+	struct sdebug_defer *sd_dp;
 
 	/* this should never happen */
 	if (WARN_ON(!cmnd))
@@ -3912,8 +3869,8 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	sqcp->a_cmnd = cmnd;
 	cmnd->result = scsi_result;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	sd_dp = sqcp->sd_dp;
 	if ((delta_jiff > 0) || (sdebug_ndelay > 0)) {
-		struct sdebug_hrtimer *sd_hp = sqcp->sd_hrtp;
 		ktime_t kt;
 
 		if (delta_jiff > 0) {
@@ -3923,30 +3880,27 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			kt = ktime_set(ts.tv_sec, ts.tv_nsec);
 		} else
 			kt = ktime_set(0, sdebug_ndelay);
-		if (NULL == sd_hp) {
-			sd_hp = kzalloc(sizeof(*sd_hp), GFP_ATOMIC);
-			if (NULL == sd_hp)
+		if (NULL == sd_dp) {
+			sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
+			if (NULL == sd_dp)
 				return SCSI_MLQUEUE_HOST_BUSY;
-			sqcp->sd_hrtp = sd_hp;
-			hrtimer_init(&sd_hp->hrt, CLOCK_MONOTONIC,
+			sqcp->sd_dp = sd_dp;
+			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
 				     HRTIMER_MODE_REL);
-			sd_hp->hrt.function = sdebug_q_cmd_hrt_complete;
-			sd_hp->qa_indx = k;
+			sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
+			sd_dp->qa_indx = k;
 		}
-		hrtimer_start(&sd_hp->hrt, kt, HRTIMER_MODE_REL);
+		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL);
 	} else {	/* jdelay < 0 */
-		if (NULL == sqcp->tletp) {
-			sqcp->tletp = kzalloc(sizeof(*sqcp->tletp),
-					      GFP_ATOMIC);
-			if (NULL == sqcp->tletp)
+		if (NULL == sd_dp) {
+			sd_dp = kzalloc(sizeof(*sqcp->sd_dp), GFP_ATOMIC);
+			if (NULL == sd_dp)
 				return SCSI_MLQUEUE_HOST_BUSY;
-			tasklet_init(sqcp->tletp,
-				     sdebug_q_cmd_complete, k);
+			sqcp->sd_dp = sd_dp;
+			sd_dp->qa_indx = k;
+			INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
 		}
-		if (-1 == delta_jiff)
-			tasklet_hi_schedule(sqcp->tletp);
-		else
-			tasklet_schedule(sqcp->tletp);
+		schedule_work(&sd_dp->ew.work);
 	}
 	if ((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
 	    (scsi_result == device_qfull_result))
@@ -4149,6 +4103,9 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else {
+				/* make sure sdebug_defer instances get
+				 * re-allocated for new delay variant */
+				free_all_queued();
 				sdebug_jdelay = jdelay;
 				sdebug_ndelay = 0;
 			}
@@ -4181,6 +4138,9 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else {
+				/* make sure sdebug_defer instances get
+				 * re-allocated for new delay variant */
+				free_all_queued();
 				sdebug_ndelay = ndelay;
 				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
 							: DEF_JDELAY;
-- 
2.7.4

