Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9B2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 14:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BFE2089D
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 14:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgGBOyK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 10:54:10 -0400
Received: from smtp.infotech.no ([82.134.31.41]:51501 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgGBOyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Jul 2020 10:54:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5F188204190;
        Thu,  2 Jul 2020 16:54:05 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FjG8xnektdJ6; Thu,  2 Jul 2020 16:53:59 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 989B420414B;
        Thu,  2 Jul 2020 16:53:58 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH] scsi_debug: fix in_use bitmap corruption
Date:   Thu,  2 Jul 2020 10:53:55 -0400
Message-Id: <20200702145355.522283-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Heavy testing indicates the irqsave() spinlock around the
__set_bit() is insufficient to stop following clear_bit() calls
being rarely applied out-of-order. Also the nearby failed
kzalloc() path leading to SCSI_MLQUEUE_HOST_BUSY does not
properly undo the in_use bitmap and num_in_q, fix.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 843cccb38cb7..4692f5b6ad13 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5430,7 +5430,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		else
 			return SCSI_MLQUEUE_HOST_BUSY;
 	}
-	__set_bit(k, sqp->in_use_bm);
+	set_bit(k, sqp->in_use_bm);
 	atomic_inc(&devip->num_in_q);
 	sqcp = &sqp->qc_arr[k];
 	sqcp->a_cmnd = cmnd;
@@ -5439,10 +5439,13 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	if (unlikely(sdebug_every_nth && sdebug_any_injecting_opt))
 		setup_inject(sqp, sqcp);
-	if (sd_dp == NULL) {
+	if (!sd_dp) {
 		sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
-		if (sd_dp == NULL)
+		if (!sd_dp) {
+			atomic_dec(&devip->num_in_q);
+			clear_bit(k, sqp->in_use_bm);
 			return SCSI_MLQUEUE_HOST_BUSY;
+		}
 		new_sd_dp = true;
 	} else {
 		new_sd_dp = false;
-- 
2.25.1

