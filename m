From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 2/3] scsi_debug: give unit attention and other errors precedence
 over TSF
Date: Tue, 05 Aug 2014 12:20:46 +0200
Message-ID: <53E0AFFE.6080202@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050902000306070901030608"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32802 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbaHEKUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 06:20:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Elliott, Robert (Server Storage)" <elliott@hp.com>

This is a multi-part message in MIME format.
--------------050902000306070901030608
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Give existing errors priority over the generation of Task
Set Full (TSF) errors. So that max_queue is not exceeded,
existing errors may be sent back in the invocation thread.
This is done so errors like Unit Attentions are not hidden
and lost by either max_queue exceeded or real/injected
TSFs.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------050902000306070901030608
Content-Type: text/x-patch;
 name="0002-give-unit-attention-and-other-errors-precedence-over.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-give-unit-attention-and-other-errors-precedence-over.pa";
 filename*1="tch"

---
 drivers/scsi/scsi_debug.c | 67 +++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 07d224a..693f2fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3006,7 +3006,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	      int scsi_result, int delta_jiff)
 {
 	unsigned long iflags;
-	int k, num_in_q, tsf, qdepth, inject;
+	int k, num_in_q, qdepth, inject;
 	struct sdebug_queued_cmd *sqcp = NULL;
 	struct scsi_device *sdp = cmnd->device;
 
@@ -3019,55 +3019,48 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
-	if (delta_jiff == 0) {
-		/* using same thread to call back mid-layer */
-		cmnd->result = scsi_result;
-		cmnd->scsi_done(cmnd);
-		return 0;
-	}
+	if (delta_jiff == 0)
+		goto respond_in_thread;
 
-	/* deferred response cases */
+	/* schedule the response at a later time if resources permit */
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	num_in_q = atomic_read(&devip->num_in_q);
 	qdepth = cmnd->device->queue_depth;
-	k = find_first_zero_bit(queued_in_use_bm, scsi_debug_max_queue);
-	tsf = 0;
 	inject = 0;
-	if ((qdepth > 0) && (num_in_q >= qdepth))
-		tsf = 1;
-	else if ((scsi_debug_every_nth != 0) &&
-		 (SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts)) {
+	if ((qdepth > 0) && (num_in_q >= qdepth)) {
+		if (scsi_result) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			goto respond_in_thread;
+		} else
+			scsi_result = device_qfull_result;
+	} else if ((scsi_debug_every_nth != 0) &&
+		   (SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts) &&
+		   (scsi_result == 0)) {
 		if ((num_in_q == (qdepth - 1)) &&
 		    (atomic_inc_return(&sdebug_a_tsf) >=
 		     abs(scsi_debug_every_nth))) {
 			atomic_set(&sdebug_a_tsf, 0);
 			inject = 1;
-			tsf = 1;
+			scsi_result = device_qfull_result;
 		}
 	}
 
-	/* if (tsf) simulate device reporting SCSI status of TASK SET FULL.
-	 * Might override existing CHECK CONDITION. */
-	if (tsf)
-		scsi_result = device_qfull_result;
+	k = find_first_zero_bit(queued_in_use_bm, scsi_debug_max_queue);
 	if (k >= scsi_debug_max_queue) {
-		if (SCSI_DEBUG_OPT_ALL_TSF & scsi_debug_opts)
-			tsf = 1;
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		if (scsi_result)
+			goto respond_in_thread;
+		else if (SCSI_DEBUG_OPT_ALL_TSF & scsi_debug_opts)
+			scsi_result = device_qfull_result;
 		if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts)
 			sdev_printk(KERN_INFO, sdp,
-				    "%s: num_in_q=%d, bypass q, %s%s\n",
-				    __func__, num_in_q,
-				    (inject ? "<inject> " : ""),
-				    (tsf ?  "status: TASK SET FULL" :
-					    "report: host busy"));
-		if (tsf) {
-			/* queued_arr full so respond in same thread */
-			cmnd->result = scsi_result;
-			cmnd->scsi_done(cmnd);
-			/* As scsi_done() is called "inline" must return 0 */
-			return 0;
-		} else
+				    "%s: max_queue=%d exceeded, %s\n",
+				    __func__, scsi_debug_max_queue,
+				    (scsi_result ?  "status: TASK SET FULL" :
+						    "report: host busy"));
+		if (scsi_result)
+			goto respond_in_thread;
+		else
 			return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	__set_bit(k, queued_in_use_bm);
@@ -3117,12 +3110,18 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		else
 			tasklet_schedule(sqcp->tletp);
 	}
-	if (tsf && (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts))
+	if ((SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) &&
+	    (scsi_result == device_qfull_result))
 		sdev_printk(KERN_INFO, sdp,
 			    "%s: num_in_q=%d +1, %s%s\n", __func__,
 			    num_in_q, (inject ? "<inject> " : ""),
 			    "status: TASK SET FULL");
 	return 0;
+
+respond_in_thread:	/* call back to mid-layer using invocation thread */
+	cmnd->result = scsi_result;
+	cmnd->scsi_done(cmnd);
+	return 0;
 }
 
 /* Note: The following macros create attribute files in the
-- 
1.9.1



--------------050902000306070901030608--
