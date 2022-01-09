Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A47C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jan 2022 01:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiAIB3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jan 2022 20:29:05 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37828 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235007AbiAIB3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Jan 2022 20:29:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 678A02041BB;
        Sun,  9 Jan 2022 02:29:02 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H9+0fuEBwHs6; Sun,  9 Jan 2022 02:29:02 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 3FDB720413E;
        Sun,  9 Jan 2022 02:29:01 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v2 4/9] scsi_debug: refine sdebug_blk_mq_poll
Date:   Sat,  8 Jan 2022 20:28:48 -0500
Message-Id: <20220109012853.301953-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220109012853.301953-1-dgilbert@interlog.com>
References: <20220109012853.301953-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Refine the sdebug_blk_mq_poll() function so it only takes the
spinlock on the queue when it can see one or more requests
with the in_use bitmap flag set.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8abe95a0d869..c6798d991fbe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7396,6 +7396,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 {
 	bool first;
 	bool retiring = false;
+	bool locked = false;
 	int num_entries = 0;
 	unsigned int qc_idx = 0;
 	unsigned long iflags;
@@ -7407,16 +7408,23 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	struct sdebug_defer *sd_dp;
 
 	sqp = sdebug_q_arr + queue_num;
-	spin_lock_irqsave(&sqp->qc_lock, iflags);
+	qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+	if (qc_idx >= sdebug_max_queue)
+		return 0;
 
 	for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
+		if (!locked) {
+			spin_lock_irqsave(&sqp->qc_lock, iflags);
+			locked = true;
+		}
 		if (first) {
-			qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
 			first = false;
+			if (!test_bit(qc_idx, sqp->in_use_bm))
+				continue;
 		} else {
 			qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1);
 		}
-		if (unlikely(qc_idx >= sdebug_max_queue))
+		if (qc_idx >= sdebug_max_queue)
 			break;
 
 		sqcp = &sqp->qc_arr[qc_idx];
@@ -7465,11 +7473,14 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 		}
 		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		locked = false;
 		scsi_done(scp); /* callback to mid level */
-		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		num_entries++;
+		if (find_first_bit(sqp->in_use_bm, sdebug_max_queue) >= sdebug_max_queue)
+			break;	/* if no more then exit without retaking spinlock */
 	}
-	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+	if (locked)
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	if (num_entries > 0)
 		atomic_add(num_entries, &sdeb_mq_poll_count);
 	return num_entries;
-- 
2.25.1

