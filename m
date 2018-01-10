From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 1/1] scsi_debug: delay stress fix
Date: Wed, 10 Jan 2018 16:57:31 -0500
Message-ID: <20180110215731.4805-2-dgilbert@interlog.com>
References: <20180110215731.4805-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44665 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbeAJV5m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 16:57:42 -0500
In-Reply-To: <20180110215731.4805-1-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, bart.vanassche@sandisk.com, hare@suse.de

Introduce a state enum into sdebug_defer objects to indicate which,
if any, defer method has been used with the associated command.
Also add 2 bools to indicate which of the defer methods has been
initialized. Those objects are re-used but the initialization
only needs to be done once. This simplifies command cancellation
handling.

Now the delay associated with a deferred response of a command
cannot be changed (once started) by changing the delay (and ndelay)
parameters in sysfs. Command aborts and driver shutdown are still
honoured immediately when received.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 72 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e4f037f0f38b..f5d0098b5a6a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -263,12 +263,18 @@ struct sdebug_host_info {
 #define to_sdebug_host(d)	\
 	container_of(d, struct sdebug_host_info, dev)
 
+enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
+		      SDEB_DEFER_WQ = 2};
+
 struct sdebug_defer {
 	struct hrtimer hrt;
 	struct execute_work ew;
 	int sqa_idx;	/* index of sdebug_queue array */
 	int qc_idx;	/* index of sdebug_queued_cmd array within sqa_idx */
 	int issuing_cpu;
+	bool init_hrt;
+	bool init_wq;
+	enum sdeb_defer_type defer_t;
 };
 
 struct sdebug_queued_cmd {
@@ -3495,6 +3501,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	struct scsi_cmnd *scp;
 	struct sdebug_dev_info *devip;
 
+	sd_dp->defer_t = SDEB_DEFER_NONE;
 	qc_idx = sd_dp->qc_idx;
 	sqp = sdebug_q_arr + sd_dp->sqa_idx;
 	if (sdebug_statistics) {
@@ -3678,13 +3685,14 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	}
 }
 
-static void stop_qc_helper(struct sdebug_defer *sd_dp)
+static void stop_qc_helper(struct sdebug_defer *sd_dp,
+			   enum sdeb_defer_type defer_t)
 {
 	if (!sd_dp)
 		return;
-	if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0))
+	if (defer_t == SDEB_DEFER_HRT)
 		hrtimer_cancel(&sd_dp->hrt);
-	else if (sdebug_jdelay < 0)
+	else if (defer_t == SDEB_DEFER_WQ)
 		cancel_work_sync(&sd_dp->ew.work);
 }
 
@@ -3694,6 +3702,7 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 {
 	unsigned long iflags;
 	int j, k, qmax, r_qmax;
+	enum sdeb_defer_type l_defer_t;
 	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
@@ -3717,8 +3726,13 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 					atomic_dec(&devip->num_in_q);
 				sqcp->a_cmnd = NULL;
 				sd_dp = sqcp->sd_dp;
+				if (sd_dp) {
+					l_defer_t = sd_dp->defer_t;
+					sd_dp->defer_t = SDEB_DEFER_NONE;
+				} else
+					l_defer_t = SDEB_DEFER_NONE;
 				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-				stop_qc_helper(sd_dp);
+				stop_qc_helper(sd_dp, l_defer_t);
 				clear_bit(k, sqp->in_use_bm);
 				return true;
 			}
@@ -3733,6 +3747,7 @@ static void stop_all_queued(void)
 {
 	unsigned long iflags;
 	int j, k;
+	enum sdeb_defer_type l_defer_t;
 	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
@@ -3751,8 +3766,13 @@ static void stop_all_queued(void)
 					atomic_dec(&devip->num_in_q);
 				sqcp->a_cmnd = NULL;
 				sd_dp = sqcp->sd_dp;
+				if (sd_dp) {
+					l_defer_t = sd_dp->defer_t;
+					sd_dp->defer_t = SDEB_DEFER_NONE;
+				} else
+					l_defer_t = SDEB_DEFER_NONE;
 				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-				stop_qc_helper(sd_dp);
+				stop_qc_helper(sd_dp, l_defer_t);
 				clear_bit(k, sqp->in_use_bm);
 				spin_lock_irqsave(&sqp->qc_lock, iflags);
 			}
@@ -4003,7 +4023,7 @@ static void setup_inject(struct sdebug_queue *sqp,
  * SCSI_MLQUEUE_HOST_BUSY if temporarily out of resources.
  */
 static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
-			 int scsi_result, int delta_jiff)
+			 int scsi_result, int delta_jiff, int ndelay)
 {
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
@@ -4081,7 +4101,12 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	if (unlikely(sdebug_every_nth && sdebug_any_injecting_opt))
 		setup_inject(sqp, sqcp);
-	if (delta_jiff > 0 || sdebug_ndelay > 0) {
+	if (sd_dp == NULL) {
+		sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
+		if (sd_dp == NULL)
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	if (delta_jiff > 0 || ndelay > 0) {
 		ktime_t kt;
 
 		if (delta_jiff > 0) {
@@ -4090,11 +4115,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			jiffies_to_timespec(delta_jiff, &ts);
 			kt = ktime_set(ts.tv_sec, ts.tv_nsec);
 		} else
-			kt = sdebug_ndelay;
-		if (NULL == sd_dp) {
-			sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
-			if (NULL == sd_dp)
-				return SCSI_MLQUEUE_HOST_BUSY;
+			kt = ndelay;
+		if (!sd_dp->init_hrt) {
+			sd_dp->init_hrt = true;
 			sqcp->sd_dp = sd_dp;
 			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
 				     HRTIMER_MODE_REL_PINNED);
@@ -4104,12 +4127,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		}
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
+		sd_dp->defer_t = SDEB_DEFER_HRT;
 		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 	} else {	/* jdelay < 0, use work queue */
-		if (NULL == sd_dp) {
-			sd_dp = kzalloc(sizeof(*sqcp->sd_dp), GFP_ATOMIC);
-			if (NULL == sd_dp)
-				return SCSI_MLQUEUE_HOST_BUSY;
+		if (!sd_dp->init_wq) {
+			sd_dp->init_wq = true;
 			sqcp->sd_dp = sd_dp;
 			sd_dp->sqa_idx = sqp - sdebug_q_arr;
 			sd_dp->qc_idx = k;
@@ -4117,6 +4139,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		}
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
+		sd_dp->defer_t = SDEB_DEFER_WQ;
 		schedule_work(&sd_dp->ew.work);
 	}
 	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
@@ -4360,9 +4383,6 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 				}
 			}
 			if (res > 0) {
-				/* make sure sdebug_defer instances get
-				 * re-allocated for new delay variant */
-				free_all_queued();
 				sdebug_jdelay = jdelay;
 				sdebug_ndelay = 0;
 			}
@@ -4403,9 +4423,6 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 				}
 			}
 			if (res > 0) {
-				/* make sure sdebug_defer instances get
-				 * re-allocated for new delay variant */
-				free_all_queued();
 				sdebug_ndelay = ndelay;
 				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
 							: DEF_JDELAY;
@@ -5420,12 +5437,15 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		errsts = r_pfp(scp, devip);
 
 fini:
-	return schedule_resp(scp, devip, errsts,
-			     ((F_DELAY_OVERR & flags) ? 0 : sdebug_jdelay));
+	if (F_DELAY_OVERR & flags)
+		return schedule_resp(scp, devip, errsts, 0, 0);
+	else
+		return schedule_resp(scp, devip, errsts, sdebug_jdelay,
+				     sdebug_ndelay);
 check_cond:
-	return schedule_resp(scp, devip, check_condition_result, 0);
+	return schedule_resp(scp, devip, check_condition_result, 0, 0);
 err_out:
-	return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0);
+	return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0, 0);
 }
 
 static struct scsi_host_template sdebug_driver_template = {
-- 
2.14.1
