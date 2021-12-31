Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495EBC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 02:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbhLaCQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:16:10 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46078 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242534AbhLaCQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Dec 2021 21:16:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0888520414C;
        Fri, 31 Dec 2021 03:08:40 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lF-hqJLtYN98; Fri, 31 Dec 2021 03:08:38 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        by smtp.infotech.no (Postfix) with ESMTPA id A54042041AF;
        Fri, 31 Dec 2021 03:08:33 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: [PATCH 2/9] scsi_debug: strengthen defer_t accesses
Date:   Thu, 30 Dec 2021 21:08:22 -0500
Message-Id: <20211231020829.29147-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231020829.29147-1-dgilbert@interlog.com>
References: <20211231020829.29147-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use READ_ONCE() and WRITE_ONCE() macros when accessing the
sdebug_defer::defer_t value.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 48b44ea2ab57..3fb9e0072627 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4782,7 +4782,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		return;
 	}
 	spin_lock_irqsave(&sqp->qc_lock, iflags);
-	sd_dp->defer_t = SDEB_DEFER_NONE;
+	WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 	sqcp = &sqp->qc_arr[qc_idx];
 	scp = sqcp->a_cmnd;
 	if (unlikely(scp == NULL)) {
@@ -5103,8 +5103,8 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 				sqcp->a_cmnd = NULL;
 				sd_dp = sqcp->sd_dp;
 				if (sd_dp) {
-					l_defer_t = sd_dp->defer_t;
-					sd_dp->defer_t = SDEB_DEFER_NONE;
+					l_defer_t = READ_ONCE(sd_dp->defer_t);
+					WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 				} else
 					l_defer_t = SDEB_DEFER_NONE;
 				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
@@ -5145,8 +5145,8 @@ static void stop_all_queued(bool done_with_no_conn)
 				sqcp->a_cmnd = NULL;
 				sd_dp = sqcp->sd_dp;
 				if (sd_dp) {
-					l_defer_t = sd_dp->defer_t;
-					sd_dp->defer_t = SDEB_DEFER_NONE;
+					l_defer_t = READ_ONCE(sd_dp->defer_t);
+					WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 				} else
 					l_defer_t = SDEB_DEFER_NONE;
 				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
@@ -5627,7 +5627,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				sd_dp->sqa_idx = sqp - sdebug_q_arr;
 				sd_dp->qc_idx = k;
 			}
-			sd_dp->defer_t = SDEB_DEFER_POLL;
+			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		} else {
 			if (!sd_dp->init_hrt) {
@@ -5639,7 +5639,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				sd_dp->sqa_idx = sqp - sdebug_q_arr;
 				sd_dp->qc_idx = k;
 			}
-			sd_dp->defer_t = SDEB_DEFER_HRT;
+			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_HRT);
 			/* schedule the invocation of scsi_done() for a later time */
 			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 		}
@@ -5658,7 +5658,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				sd_dp->sqa_idx = sqp - sdebug_q_arr;
 				sd_dp->qc_idx = k;
 			}
-			sd_dp->defer_t = SDEB_DEFER_POLL;
+			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		} else {
 			if (!sd_dp->init_wq) {
@@ -5668,7 +5668,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				sd_dp->qc_idx = k;
 				INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
 			}
-			sd_dp->defer_t = SDEB_DEFER_WQ;
+			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_WQ);
 			schedule_work(&sd_dp->ew.work);
 		}
 		if (sdebug_statistics)
@@ -7436,7 +7436,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 			       queue_num, qc_idx, __func__);
 			break;
 		}
-		if (sd_dp->defer_t == SDEB_DEFER_POLL) {
+		if (READ_ONCE(sd_dp->defer_t) == SDEB_DEFER_POLL) {
 			if (kt_from_boot < sd_dp->cmpl_ts)
 				continue;
 
@@ -7470,7 +7470,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 			else
 				atomic_set(&retired_max_queue, k + 1);
 		}
-		sd_dp->defer_t = SDEB_DEFER_NONE;
+		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		scsi_done(scp); /* callback to mid level */
 		spin_lock_irqsave(&sqp->qc_lock, iflags);
-- 
2.25.1

