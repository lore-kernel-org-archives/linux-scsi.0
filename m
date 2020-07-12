Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48B0C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C3E2067D
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgGLS3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:29:37 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50589 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgGLS3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 14:29:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A6D7F20425B;
        Sun, 12 Jul 2020 20:29:34 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jsg-Qf2VjIGT; Sun, 12 Jul 2020 20:29:31 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 4D52A204255;
        Sun, 12 Jul 2020 20:29:30 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH 1/2] scsi_debug: every_nth triggered error injection
Date:   Sun, 12 Jul 2020 14:29:26 -0400
Message-Id: <20200712182927.72044-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200712182927.72044-1-dgilbert@interlog.com>
References: <20200712182927.72044-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch simplifies, or at least makes more consistent, the way
setting the every_nth parameter injects errors. Here is a list of
'opts' flags and in which cases they inject errors when
abs(every_nth)%command_count == 0 is reached:

  - OPT_RECOVERED_ERR: issued on READ(*)s, WRITE(*)s and
                       WRITE_SCATTEREDs
  - OPT_DIF_ERR:       issued on READ(*)s, WRITE(*)s and
                       WRITE_SCATTEREDs
  - OPT_DIX_ERR:       issued on READ(*)s, WRITE(*)s and
                       WRITE_SCATTEREDs
  - OPT_SHORT_TRANSFER: issued on READ(*)s
  - OPT_TRANSPORT_ERR: issued on all commands
  - OPT_CMD_ABORT:     issued on all commands

The other uses of every_nth were not modified.

Previously if, for example, OPT_SHORT_TRANSFER was armed then
if (abs(every_nth)%command_count == 0) occurred during a
command that was _not_ a READ, then no error injection
occurred. This behaviour puzzled several testers. Now a global
"inject_pending" flag is set and the _next_ READ will get hit
and that flag is cleared. OPT_RECOVERED_ERR, OPT_DIF_ERR and
OPT_DIX_ERR have similar behaviour. A downside of this is
that there might be a hang-over pending injection that gets
triggered by a following test.

Also expand the every_nth runtime parameter so that it can
take hex value (i.e. with a leading '0x') as well as a
decimal value. Now both the 'opts' and the 'every_nth'
runtime parameters can take hexadecimal values.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 231 +++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 130 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4692f5b6ad13..e37df710c623 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -187,21 +187,8 @@ static const char *sdebug_version_date = "20200421";
 				  SDEBUG_OPT_SHORT_TRANSFER | \
 				  SDEBUG_OPT_HOST_BUSY | \
 				  SDEBUG_OPT_CMD_ABORT)
-/* When "every_nth" > 0 then modulo "every_nth" commands:
- *   - a missing response is simulated if SDEBUG_OPT_TIMEOUT is set
- *   - a RECOVERED_ERROR is simulated on successful read and write
- *     commands if SDEBUG_OPT_RECOVERED_ERR is set.
- *   - a TRANSPORT_ERROR is simulated on successful read and write
- *     commands if SDEBUG_OPT_TRANSPORT_ERR is set.
- *   - similarly for DIF_ERR, DIX_ERR, SHORT_TRANSFER, HOST_BUSY and
- *     CMD_ABORT
- *
- * When "every_nth" < 0 then after "- every_nth" commands the selected
- * error will be injected. The error will be injected on every subsequent
- * command until some other action occurs; for example, the user writing
- * a new value (other than -1 or 1) to every_nth:
- *      echo 0 > /sys/bus/pseudo/drivers/scsi_debug/every_nth
- */
+#define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
+				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
 
 /* As indicated in SAM-5 and SPC-4 Unit Attentions (UAs) are returned in
  * priority order. In the subset implemented here lower numbers have higher
@@ -357,13 +344,6 @@ struct sdebug_queued_cmd {
 	 */
 	struct sdebug_defer *sd_dp;
 	struct scsi_cmnd *a_cmnd;
-	unsigned int inj_recovered:1;
-	unsigned int inj_transport:1;
-	unsigned int inj_dif:1;
-	unsigned int inj_dix:1;
-	unsigned int inj_short:1;
-	unsigned int inj_host_busy:1;
-	unsigned int inj_cmd_abort:1;
 };
 
 struct sdebug_queue {
@@ -377,6 +357,7 @@ static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
 static atomic_t sdebug_completions;  /* count of deferred completions */
 static atomic_t sdebug_miss_cpus;    /* submission + completion cpus differ */
 static atomic_t sdebug_a_tsf;	     /* 'almost task set full' counter */
+static atomic_t sdeb_inject_pending;
 
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff */
@@ -3109,7 +3090,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u8 *cmd = scp->cmnd;
-	struct sdebug_queued_cmd *sqcp;
 
 	switch (cmd[0]) {
 	case READ_16:
@@ -3162,15 +3142,11 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
 				    "to DIF device\n");
 	}
-	if (unlikely(sdebug_any_injecting_opt)) {
-		sqcp = (struct sdebug_queued_cmd *)scp->host_scribble;
-
-		if (sqcp) {
-			if (sqcp->inj_short)
-				num /= 2;
-		}
-	} else
-		sqcp = NULL;
+	if (unlikely((sdebug_opts & SDEBUG_OPT_SHORT_TRANSFER) &&
+		     atomic_read(&sdeb_inject_pending))) {
+		num /= 2;
+		atomic_set(&sdeb_inject_pending, 0);
+	}
 
 	ret = check_device_access_params(scp, lba, num, false);
 	if (ret)
@@ -3211,21 +3187,20 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 
-	if (unlikely(sqcp)) {
-		if (sqcp->inj_recovered) {
-			mk_sense_buffer(scp, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			return check_condition_result;
-		} else if (sqcp->inj_transport) {
-			mk_sense_buffer(scp, ABORTED_COMMAND,
-					TRANSPORT_PROBLEM, ACK_NAK_TO);
+	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
+		     atomic_read(&sdeb_inject_pending))) {
+		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
+			mk_sense_buffer(scp, RECOVERED_ERROR, THRESHOLD_EXCEEDED, 0);
+			atomic_set(&sdeb_inject_pending, 0);
 			return check_condition_result;
-		} else if (sqcp->inj_dif) {
+		} else if (sdebug_opts & SDEBUG_OPT_DIF_ERR) {
 			/* Logical block guard check failed */
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+			atomic_set(&sdeb_inject_pending, 0);
 			return illegal_condition_result;
-		} else if (sqcp->inj_dix) {
+		} else if (SDEBUG_OPT_DIX_ERR & sdebug_opts) {
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+			atomic_set(&sdeb_inject_pending, 0);
 			return illegal_condition_result;
 		}
 	}
@@ -3504,23 +3479,21 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
-	if (unlikely(sdebug_any_injecting_opt)) {
-		struct sdebug_queued_cmd *sqcp =
-				(struct sdebug_queued_cmd *)scp->host_scribble;
-
-		if (sqcp) {
-			if (sqcp->inj_recovered) {
-				mk_sense_buffer(scp, RECOVERED_ERROR,
-						THRESHOLD_EXCEEDED, 0);
-				return check_condition_result;
-			} else if (sqcp->inj_dif) {
-				/* Logical block guard check failed */
-				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
-				return illegal_condition_result;
-			} else if (sqcp->inj_dix) {
-				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
-				return illegal_condition_result;
-			}
+	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
+		     atomic_read(&sdeb_inject_pending))) {
+		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
+			mk_sense_buffer(scp, RECOVERED_ERROR, THRESHOLD_EXCEEDED, 0);
+			atomic_set(&sdeb_inject_pending, 0);
+			return check_condition_result;
+		} else if (sdebug_opts & SDEBUG_OPT_DIF_ERR) {
+			/* Logical block guard check failed */
+			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+			atomic_set(&sdeb_inject_pending, 0);
+			return illegal_condition_result;
+		} else if (sdebug_opts & SDEBUG_OPT_DIX_ERR) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+			atomic_set(&sdeb_inject_pending, 0);
+			return illegal_condition_result;
 		}
 	}
 	return 0;
@@ -3662,28 +3635,24 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
-		if (unlikely(sdebug_any_injecting_opt)) {
-			struct sdebug_queued_cmd *sqcp =
-				(struct sdebug_queued_cmd *)scp->host_scribble;
-
-			if (sqcp) {
-				if (sqcp->inj_recovered) {
-					mk_sense_buffer(scp, RECOVERED_ERROR,
-							THRESHOLD_EXCEEDED, 0);
-					ret = illegal_condition_result;
-					goto err_out_unlock;
-				} else if (sqcp->inj_dif) {
-					/* Logical block guard check failed */
-					mk_sense_buffer(scp, ABORTED_COMMAND,
-							0x10, 1);
-					ret = illegal_condition_result;
-					goto err_out_unlock;
-				} else if (sqcp->inj_dix) {
-					mk_sense_buffer(scp, ILLEGAL_REQUEST,
-							0x10, 1);
-					ret = illegal_condition_result;
-					goto err_out_unlock;
-				}
+		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
+			     atomic_read(&sdeb_inject_pending))) {
+			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
+				mk_sense_buffer(scp, RECOVERED_ERROR, THRESHOLD_EXCEEDED, 0);
+				atomic_set(&sdeb_inject_pending, 0);
+				ret = check_condition_result;
+				goto err_out_unlock;
+			} else if (sdebug_opts & SDEBUG_OPT_DIF_ERR) {
+				/* Logical block guard check failed */
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+				atomic_set(&sdeb_inject_pending, 0);
+				ret = illegal_condition_result;
+				goto err_out_unlock;
+			} else if (sdebug_opts & SDEBUG_OPT_DIX_ERR) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+				atomic_set(&sdeb_inject_pending, 0);
+				ret = illegal_condition_result;
+				goto err_out_unlock;
 			}
 		}
 		sg_off += num_by;
@@ -5333,24 +5302,11 @@ static void clear_queue_stats(void)
 	atomic_set(&sdebug_a_tsf, 0);
 }
 
-static void setup_inject(struct sdebug_queue *sqp,
-			 struct sdebug_queued_cmd *sqcp)
+static bool inject_on_this_cmd(void)
 {
-	if ((atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) > 0) {
-		if (sdebug_every_nth > 0)
-			sqcp->inj_recovered = sqcp->inj_transport
-				= sqcp->inj_dif
-				= sqcp->inj_dix = sqcp->inj_short
-				= sqcp->inj_host_busy = sqcp->inj_cmd_abort = 0;
-		return;
-	}
-	sqcp->inj_recovered = !!(SDEBUG_OPT_RECOVERED_ERR & sdebug_opts);
-	sqcp->inj_transport = !!(SDEBUG_OPT_TRANSPORT_ERR & sdebug_opts);
-	sqcp->inj_dif = !!(SDEBUG_OPT_DIF_ERR & sdebug_opts);
-	sqcp->inj_dix = !!(SDEBUG_OPT_DIX_ERR & sdebug_opts);
-	sqcp->inj_short = !!(SDEBUG_OPT_SHORT_TRANSFER & sdebug_opts);
-	sqcp->inj_host_busy = !!(SDEBUG_OPT_HOST_BUSY & sdebug_opts);
-	sqcp->inj_cmd_abort = !!(SDEBUG_OPT_CMD_ABORT & sdebug_opts);
+	if (sdebug_every_nth == 0)
+		return false;
+	return (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
 }
 
 #define INCLUSIVE_TIMING_MAX_NS 1000000		/* 1 millisecond */
@@ -5367,7 +5323,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			 int delta_jiff, int ndelay)
 {
 	bool new_sd_dp;
-	int k, num_in_q, qdepth, inject;
+	bool inject = false;
+	int k, num_in_q, qdepth;
 	unsigned long iflags;
 	u64 ns_from_boot = 0;
 	struct sdebug_queue *sqp;
@@ -5393,7 +5350,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
 	qdepth = cmnd->device->queue_depth;
-	inject = 0;
 	if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
 		if (scsi_result) {
 			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
@@ -5407,7 +5363,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		    (atomic_inc_return(&sdebug_a_tsf) >=
 		     abs(sdebug_every_nth))) {
 			atomic_set(&sdebug_a_tsf, 0);
-			inject = 1;
+			inject = true;
 			scsi_result = device_qfull_result;
 		}
 	}
@@ -5437,8 +5393,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	cmnd->host_scribble = (unsigned char *)sqcp;
 	sd_dp = sqcp->sd_dp;
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-	if (unlikely(sdebug_every_nth && sdebug_any_injecting_opt))
-		setup_inject(sqp, sqcp);
 	if (!sd_dp) {
 		sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
 		if (!sd_dp) {
@@ -5455,13 +5409,20 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
-	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
+	cmnd->result = pfp ? pfp(cmnd, devip) : 0;
 	if (cmnd->result & SDEG_RES_IMMED_MASK) {
 		cmnd->result &= ~SDEG_RES_IMMED_MASK;
 		delta_jiff = ndelay = 0;
 	}
 	if (cmnd->result == 0 && scsi_result != 0)
 		cmnd->result = scsi_result;
+	if (cmnd->result == 0 && unlikely(sdebug_opts & SDEBUG_OPT_TRANSPORT_ERR)) {
+		if (atomic_read(&sdeb_inject_pending)) {
+			mk_sense_buffer(cmnd, ABORTED_COMMAND, TRANSPORT_PROBLEM, ACK_NAK_TO);
+			atomic_set(&sdeb_inject_pending, 0);
+			cmnd->result = check_condition_result;
+		}
+	}
 
 	if (unlikely(sdebug_verbose && cmnd->result))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
@@ -5527,21 +5488,20 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
 		sd_dp->defer_t = SDEB_DEFER_WQ;
-		if (unlikely(sqcp->inj_cmd_abort))
+		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
+			     atomic_read(&sdeb_inject_pending)))
 			sd_dp->aborted = true;
 		schedule_work(&sd_dp->ew.work);
-		if (unlikely(sqcp->inj_cmd_abort)) {
-			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n",
-				    cmnd->request->tag);
+		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
+			     atomic_read(&sdeb_inject_pending))) {
+			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
 			blk_abort_request(cmnd->request);
+			atomic_set(&sdeb_inject_pending, 0);
 		}
 	}
-	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
-		     (scsi_result == device_qfull_result)))
-		sdev_printk(KERN_INFO, sdp,
-			    "%s: num_in_q=%d +1, %s%s\n", __func__,
-			    num_in_q, (inject ? "<inject> " : ""),
-			    "status: TASK SET FULL");
+	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) && scsi_result == device_qfull_result))
+		sdev_printk(KERN_INFO, sdp, "%s: num_in_q=%d +1, %s%s\n", __func__,
+			    num_in_q, (inject ? "<inject> " : ""), "status: TASK SET FULL");
 	return 0;
 
 respond_in_thread:	/* call back to mid-layer using invocation thread */
@@ -6075,17 +6035,27 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
 	int nth;
+	char work[20];
 
-	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
-		sdebug_every_nth = nth;
-		if (nth && !sdebug_statistics) {
-			pr_info("every_nth needs statistics=1, set it\n");
-			sdebug_statistics = true;
+	if (sscanf(buf, "%10s", work) == 1) {
+		if (strncasecmp(work, "0x", 2) == 0) {
+			if (kstrtoint(work + 2, 16, &nth) == 0)
+				goto every_nth_done;
+		} else {
+			if (kstrtoint(work, 10, &nth) == 0)
+				goto every_nth_done;
 		}
-		tweak_cmnd_count();
-		return count;
 	}
 	return -EINVAL;
+
+every_nth_done:
+	sdebug_every_nth = nth;
+	if (nth && !sdebug_statistics) {
+		pr_info("every_nth needs statistics=1, set it\n");
+		sdebug_statistics = true;
+	}
+	tweak_cmnd_count();
+	return count;
 }
 static DRIVER_ATTR_RW(every_nth);
 
@@ -7047,12 +7017,6 @@ static bool fake_timeout(struct scsi_cmnd *scp)
 	return false;
 }
 
-static bool fake_host_busy(struct scsi_cmnd *scp)
-{
-	return (sdebug_opts & SDEBUG_OPT_HOST_BUSY) &&
-		(atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
-}
-
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -7061,7 +7025,6 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	struct sdebug_dev_info *devip;
-
 	u8 *cmd = scp->cmnd;
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
@@ -7071,10 +7034,15 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	u16 sa;
 	u8 opcode = cmd[0];
 	bool has_wlun_rl;
+	bool inject_now;
 
 	scsi_set_resid(scp, 0);
-	if (sdebug_statistics)
+	if (sdebug_statistics) {
 		atomic_inc(&sdebug_cmnd_count);
+		inject_now = inject_on_this_cmd();
+	} else {
+		inject_now = false;
+	}
 	if (unlikely(sdebug_verbose &&
 		     !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts))) {
 		char b[120];
@@ -7092,7 +7060,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
 			    blk_mq_unique_tag(scp->request), b);
 	}
-	if (fake_host_busy(scp))
+	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
@@ -7106,6 +7074,9 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (NULL == devip)
 			goto err_out;
 	}
+	if (unlikely(inject_now && !atomic_read(&sdeb_inject_pending)))
+		atomic_set(&sdeb_inject_pending, 1);
+
 	na = oip->num_attached;
 	r_pfp = oip->pfp;
 	if (na) {	/* multiple commands with this opcode */
-- 
2.25.1

