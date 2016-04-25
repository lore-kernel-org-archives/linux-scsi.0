From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 03/12] scsi_debug: replace jiffy timers with hr timers
Date: Mon, 25 Apr 2016 12:16:30 -0400
Message-ID: <1461600999-28893-4-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36956 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbcDYQQw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:16:52 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

The driver supports two command delay interfaces, the
original one whose unit is a jiffy, and a newer one whose
unit is a nanosecond. Each had different implementations.
Keep both interfaces but simplify the implemenation to use a
single delay mechanism based on high resolution timers.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 56 ++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 42e5c37..9dc0349 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -24,7 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/timer.h>
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -518,7 +518,7 @@ struct sdebug_scmd_extra_t {
 
 static int sdebug_add_host = DEF_NUM_HOST;
 static int sdebug_ato = DEF_ATO;
-static int sdebug_delay = DEF_DELAY;
+static int sdebug_delay = DEF_DELAY;	/* in jiffies */
 static int sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 static int sdebug_dif = DEF_DIF;
 static int sdebug_dix = DEF_DIX;
@@ -530,7 +530,7 @@ static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
 static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
-static int sdebug_ndelay = DEF_NDELAY;
+static int sdebug_ndelay = DEF_NDELAY;	/* in nanoseconds */
 static int sdebug_no_lun_0 = DEF_NO_LUN_0;
 static int sdebug_no_uld;
 static int sdebug_num_parts = DEF_NUM_PARTS;
@@ -617,7 +617,6 @@ struct sdebug_hrtimer {		/* ... is derived from hrtimer */
 
 struct sdebug_queued_cmd {
 	/* in_use flagged by a bit in queued_in_use_bm[] */
-	struct timer_list *cmnd_timerp;
 	struct tasklet_struct *tletp;
 	struct sdebug_hrtimer *sd_hrtp;
 	struct scsi_cmnd * a_cmnd;
@@ -3151,7 +3150,7 @@ resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
+	buf = kzalloc(scsi_bufflen(scp), GFP_ATOMIC);
 	if (!buf) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
@@ -3298,7 +3297,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	struct sg_mapping_iter miter;
 
 	/* better not to use temporary buffer. */
-	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
+	buf = kzalloc(scsi_bufflen(scp), GFP_ATOMIC);
 	if (!buf) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
@@ -3350,7 +3349,7 @@ resp_xdwriteread_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return resp_xdwriteread(scp, lba, num, devip);
 }
 
-/* When timer or tasklet goes off this function is called. */
+/* When tasklet goes off this function is called. */
 static void sdebug_q_cmd_complete(unsigned long indx)
 {
 	int qa_indx;
@@ -3592,14 +3591,11 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (sdebug_ndelay > 0) {
+				if ((sdebug_delay > 0) ||
+				    (sdebug_ndelay > 0)) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_delay > 0) {
-					if (sqcp->cmnd_timerp)
-						del_timer_sync(
-							sqcp->cmnd_timerp);
 				} else if (sdebug_delay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
@@ -3633,14 +3629,11 @@ static void stop_all_queued(void)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (sdebug_ndelay > 0) {
+				if ((sdebug_delay > 0) ||
+				    (sdebug_ndelay > 0)) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_delay > 0) {
-					if (sqcp->cmnd_timerp)
-						del_timer_sync(
-							sqcp->cmnd_timerp);
 				} else if (sdebug_delay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
@@ -3663,8 +3656,6 @@ static void free_all_queued(void)
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
 		sqcp = &queued_arr[k];
-		kfree(sqcp->cmnd_timerp);
-		sqcp->cmnd_timerp = NULL;
 		kfree(sqcp->tletp);
 		sqcp->tletp = NULL;
 		kfree(sqcp->sd_hrtp);
@@ -3921,24 +3912,19 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	sqcp->a_cmnd = cmnd;
 	cmnd->result = scsi_result;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	if (delta_jiff > 0) {
-		if (NULL == sqcp->cmnd_timerp) {
-			sqcp->cmnd_timerp = kmalloc(sizeof(struct timer_list),
-						    GFP_ATOMIC);
-			if (NULL == sqcp->cmnd_timerp)
-				return SCSI_MLQUEUE_HOST_BUSY;
-			init_timer(sqcp->cmnd_timerp);
-		}
-		sqcp->cmnd_timerp->function = sdebug_q_cmd_complete;
-		sqcp->cmnd_timerp->data = k;
-		sqcp->cmnd_timerp->expires = get_jiffies_64() + delta_jiff;
-		add_timer(sqcp->cmnd_timerp);
-	} else if (sdebug_ndelay > 0) {
-		ktime_t kt = ktime_set(0, sdebug_ndelay);
+	if ((delta_jiff > 0) || (sdebug_ndelay > 0)) {
 		struct sdebug_hrtimer *sd_hp = sqcp->sd_hrtp;
+		ktime_t kt;
 
+		if (delta_jiff > 0) {
+			struct timespec ts;
+
+			jiffies_to_timespec(delta_jiff, &ts);
+			kt = ktime_set(ts.tv_sec, ts.tv_nsec);
+		} else
+			kt = ktime_set(0, sdebug_ndelay);
 		if (NULL == sd_hp) {
-			sd_hp = kmalloc(sizeof(*sd_hp), GFP_ATOMIC);
+			sd_hp = kzalloc(sizeof(*sd_hp), GFP_ATOMIC);
 			if (NULL == sd_hp)
 				return SCSI_MLQUEUE_HOST_BUSY;
 			sqcp->sd_hrtp = sd_hp;
@@ -3950,7 +3936,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		hrtimer_start(&sd_hp->hrt, kt, HRTIMER_MODE_REL);
 	} else {	/* delay < 0 */
 		if (NULL == sqcp->tletp) {
-			sqcp->tletp = kmalloc(sizeof(*sqcp->tletp),
+			sqcp->tletp = kzalloc(sizeof(*sqcp->tletp),
 					      GFP_ATOMIC);
 			if (NULL == sqcp->tletp)
 				return SCSI_MLQUEUE_HOST_BUSY;
-- 
2.7.4

