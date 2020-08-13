Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB7BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 15:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E703A20791
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 15:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHMP5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:57:52 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53404 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgHMP5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Aug 2020 11:57:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 69FA1204179;
        Thu, 13 Aug 2020 17:57:47 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7PtyCqgIIg6q; Thu, 13 Aug 2020 17:57:41 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 252D420415B;
        Thu, 13 Aug 2020 17:57:39 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        john.garry@huawei.com
Subject: [PATCH] scsi_debug: fix scp is NULL errors
Date:   Thu, 13 Aug 2020 11:57:38 -0400
Message-Id: <20200813155738.109298-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

John Garry reported 'sdebug_q_cmd_complete: scp is NULL' failures
that were mainly seen on aarch64 machines (e.g. RPi 4 with four
A72 CPUs). The problem was tracked down to a missing critical
section on a "short circuit" path. Namely, the time to process
the current command so far has already exceeded the requested
command duration (i.e. the number of nanoseconds in the ndelay
parameter).

The random=1 parameter setting was pivotal in finding this error.
The failure scenario involved first taking that "short circuit"
path (due to a very short command duration) and then taking the
more likely hrtimer_start() path (due to a longer command
duration). With random=1 each command's duration is taken from
the uniformly distributed [0..ndelay) interval.
The fio utility also helped by reliably generating the error
scenario at about once per minute on a RPi 4 (64 bit OS).

Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d95822dceeb6..4b4e31af22bd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5471,9 +5471,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				u64 d = ktime_get_boottime_ns() - ns_from_boot;
 
 				if (kt <= d) {	/* elapsed duration >= kt */
+					spin_lock_irqsave(&sqp->qc_lock, iflags);
 					sqcp->a_cmnd = NULL;
 					atomic_dec(&devip->num_in_q);
 					clear_bit(k, sqp->in_use_bm);
+					spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 					if (new_sd_dp)
 						kfree(sd_dp);
 					/* call scsi_done() from this thread */
-- 
2.25.1

