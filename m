Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9829C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 23:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AFB764D90
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 23:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBAXbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:31:15 -0500
Received: from smtp.infotech.no ([82.134.31.41]:48784 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhBAXbK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Feb 2021 18:31:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C7A7020418D;
        Tue,  2 Feb 2021 00:30:25 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aW6GXK8b6cK7; Tue,  2 Feb 2021 00:30:23 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id CE3572042A6;
        Tue,  2 Feb 2021 00:30:22 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH] scsi_debug: add new defer_type for mq_poll
Date:   Mon,  1 Feb 2021 18:30:20 -0500
Message-Id: <20210201233020.4773-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new sdeb_defer_type enumeration: SDEB_DEFER_POLL for requests
that have REQ_HIPRI set in cmd_flags field. It is expected that
these requests will be polled via the mq_poll entry point which
is driven by calls to blk_poll() in the block layer. Therefore
timer events are not 'wired up' in the normal fashion.

There are still cases with short delays (e.g. < 10 microseconds)
where by the time the command reponse processing occurs, the delay
is already exceeded in which case the code calls scsi_done()
directly. In such cases there is no window for mq_poll() to be
called.

This patch is against the 5.12/scsi-staging branch which includes
   a98d6bdf181eb71bf4686666eaf47c642a061642
   scsi_debug : iouring iopoll support
which it alters. So this patch is a fix of that patch which fails
in testing.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 106 +++++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 746eec521f79..d030c270796b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -322,17 +322,19 @@ struct sdeb_store_info {
 	container_of(d, struct sdebug_host_info, dev)
 
 enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
-		      SDEB_DEFER_WQ = 2};
+		      SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
 
 struct sdebug_defer {
 	struct hrtimer hrt;
 	struct execute_work ew;
+	ktime_t cmpl_ts;/* time since boot to complete this cmd */
 	int sqa_idx;	/* index of sdebug_queue array */
 	int qc_idx;	/* index of sdebug_queued_cmd array within sqa_idx */
 	int hc_idx;	/* hostwide tag index */
 	int issuing_cpu;
 	bool init_hrt;
 	bool init_wq;
+	bool init_poll;
 	bool aborted;	/* true when blk_abort_request() already called */
 	enum sdeb_defer_type defer_t;
 };
@@ -5517,40 +5519,62 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				kt -= d;
 			}
 		}
-		if (!sd_dp->init_hrt) {
-			sd_dp->init_hrt = true;
-			sqcp->sd_dp = sd_dp;
-			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL_PINNED);
-			sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
-			sd_dp->sqa_idx = sqp - sdebug_q_arr;
-			sd_dp->qc_idx = k;
+		sd_dp->cmpl_ts = ktime_add(ns_to_ktime(ns_from_boot), kt);
+		if (cmnd->request->cmd_flags & REQ_HIPRI) {
+			if (!sd_dp->init_poll) {
+				sd_dp->init_poll = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_POLL;
+		} else {
+			if (!sd_dp->init_hrt) {
+				sd_dp->init_hrt = true;
+				sqcp->sd_dp = sd_dp;
+				hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
+					     HRTIMER_MODE_REL_PINNED);
+				sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_HRT;
+			/* schedule the invocation of scsi_done() for a later time */
+			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 		}
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
-		sd_dp->defer_t = SDEB_DEFER_HRT;
-		/* schedule the invocation of scsi_done() for a later time */
-		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 	} else {	/* jdelay < 0, use work queue */
-		if (!sd_dp->init_wq) {
-			sd_dp->init_wq = true;
-			sqcp->sd_dp = sd_dp;
-			sd_dp->sqa_idx = sqp - sdebug_q_arr;
-			sd_dp->qc_idx = k;
-			INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
-		}
-		if (sdebug_statistics)
-			sd_dp->issuing_cpu = raw_smp_processor_id();
-		sd_dp->defer_t = SDEB_DEFER_WQ;
 		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
 			     atomic_read(&sdeb_inject_pending)))
 			sd_dp->aborted = true;
-		schedule_work(&sd_dp->ew.work);
-		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
-			     atomic_read(&sdeb_inject_pending))) {
+		sd_dp->cmpl_ts = ns_to_ktime(ns_from_boot);
+		if (cmnd->request->cmd_flags & REQ_HIPRI) {
+			if (!sd_dp->init_poll) {
+				sd_dp->init_poll = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_POLL;
+		} else {
+			if (!sd_dp->init_wq) {
+				sd_dp->init_wq = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+				INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
+			}
+			sd_dp->defer_t = SDEB_DEFER_WQ;
+			schedule_work(&sd_dp->ew.work);
+		}
+		if (sdebug_statistics)
+			sd_dp->issuing_cpu = raw_smp_processor_id();
+		if (unlikely(sd_dp->aborted)) {
 			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
 			blk_abort_request(cmnd->request);
 			atomic_set(&sdeb_inject_pending, 0);
+			sd_dp->aborted = false;
 		}
 	}
 	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) && scsi_result == device_qfull_result))
@@ -7246,30 +7270,47 @@ static int sdebug_map_queues(struct Scsi_Host *shost)
 
 static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 {
-	int qc_idx;
+	bool first = true;
 	int retiring = 0;
+	int num_entries = 0;
+	unsigned int qc_idx;
 	unsigned long iflags;
+	ktime_t kt_from_boot = ktime_get_boottime();
 	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct scsi_cmnd *scp;
 	struct sdebug_dev_info *devip;
-	int num_entries = 0;
 
 	sqp = sdebug_q_arr + queue_num;
 
 	do {
 		spin_lock_irqsave(&sqp->qc_lock, iflags);
-		qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
-		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
+		if (first) {
+			qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+			first = false;
+		} else {
+			qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1);
+		}
+		if (unlikely(qc_idx >= sdebug_max_queue))
 			goto out;
 
 		sqcp = &sqp->qc_arr[qc_idx];
 		scp = sqcp->a_cmnd;
 		if (unlikely(scp == NULL)) {
-			pr_err("scp is NULL, queue_num=%d, qc_idx=%d from %s\n",
+			pr_err("scp is NULL, queue_num=%d, qc_idx=%u from %s\n",
 			       queue_num, qc_idx, __func__);
 			goto out;
 		}
+		if (sqcp->sd_dp->defer_t == SDEB_DEFER_POLL) {
+			if (kt_from_boot < sqcp->sd_dp->cmpl_ts) {
+				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+				goto around;
+			}
+
+		} else {	/* ignoring non REQ_HIPRI requests */
+			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+			goto around;
+		}
 		devip = (struct sdebug_dev_info *)scp->device->hostdata;
 		if (likely(devip))
 			atomic_dec(&devip->num_in_q);
@@ -7280,7 +7321,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 		sqcp->a_cmnd = NULL;
 		if (unlikely(!test_and_clear_bit(qc_idx, sqp->in_use_bm))) {
-			pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%d from %s\n",
+			pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%u from %s\n",
 				sqp, queue_num, qc_idx, __func__);
 			goto out;
 		}
@@ -7302,6 +7343,9 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		scp->scsi_done(scp); /* callback to mid level */
 		num_entries++;
+around:
+		if (qc_idx + 1 == sdebug_max_queue)
+			return num_entries;
 	} while (1);
 
 out:
-- 
2.25.1

