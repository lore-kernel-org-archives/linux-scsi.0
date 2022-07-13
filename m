Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EBEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 18:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiGMSk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbiGMSkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 14:40:21 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF32F3B4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 11:40:20 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so5119630pjo.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 11:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kFgul6gA6DX3cHQh1Ulrnm4FIMJB2kFR32O/UhE+xxk=;
        b=gqxR+BwAivEbm/oVRgyctP9wap1ajFvlpqBNU+Q2/oybiEepycaSFg36suhIHrtkgP
         lBWNwJsqs+npOrKES/UdNMH6hu4RdYFfLT3S2m+0lHIKjk1IqeyuACs47Cpzbvv1EwX7
         F6toYosDbwi958G+JiRQMZ8yrqnA+4HYjImS4w+HZjKIQ/V2pP+arDHMA8s4ZvkZ8+eS
         mviNi/x0NbURED6/HmmgjTaVPWR0jzfm+rAUjiN/QK1lsC+uAbMxbIl0/t2WHXCFdyT2
         OagM9eaT45JIhWVonQOs6ZywJ7ZeOm5CLeWVd2hOBlUa+kEfq3CvL+YXOyeI47RnbTVY
         +vUA==
X-Gm-Message-State: AJIora9wHxXSwtYpUVt0/wg3IJ25eOND6deq7akefUd9btykMFUzxTJv
        fYyduhOPxyezYjNQfgkT8Qc=
X-Google-Smtp-Source: AGRyM1uWXxNabaRehtJN1II26XWscgWGUT848C4eTwTdLnd2/XwVKYOoQ2Fae2uL6r1SBa0I+hL3jg==
X-Received: by 2002:a17:902:6a88:b0:16a:901:3c7c with SMTP id n8-20020a1709026a8800b0016a09013c7cmr4708929plk.100.1657737619498;
        Wed, 13 Jul 2022 11:40:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cf8d:5409:1ca6:f804])
        by smtp.gmail.com with ESMTPSA id h16-20020a056a00001000b0051bada81bc7sm7075372pfk.161.2022.07.13.11.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 11:40:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@google.com>
Subject: [PATCH] scsi: ufs: Fix a race condition related to device management
Date:   Wed, 13 Jul 2022 11:40:08 -0700
Message-Id: <20220713184008.2232094-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@google.com>

If a device management command completion happens after
wait_for_completion_timeout() times out and before ufshcd_clear_cmds() is
called then the completion code may crash on the complete() call in
__ufshcd_transfer_req_compl(). This patch fixes the following crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
Call trace:
 complete+0x64/0x178
 __ufshcd_transfer_req_compl+0x30c/0x9c0
 ufshcd_poll+0xf0/0x208
 ufshcd_sl_intr+0xb8/0xf0
 ufshcd_intr+0x168/0x2f4
 __handle_irq_event_percpu+0xa0/0x30c
 handle_irq_event+0x84/0x178
 handle_fasteoi_irq+0x150/0x2e8
 __handle_domain_irq+0x114/0x1e4
 gic_handle_irq.31846+0x58/0x300
 el1_irq+0xe4/0x1c0
 efi_header_end+0x110/0x680
 __irq_exit_rcu+0x108/0x124
 __handle_domain_irq+0x118/0x1e4
 gic_handle_irq.31846+0x58/0x300
 el1_irq+0xe4/0x1c0
 cpuidle_enter_state+0x3ac/0x8c4
 do_idle+0x2fc/0x55c
 cpu_startup_entry+0x84/0x90
 kernel_init+0x0/0x310
 start_kernel+0x0/0x608
 start_kernel+0x4ec/0x608

Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Signed-off-by: Bart Van Assche <bvanassche@google.com>
---
 drivers/ufs/core/ufshcd.c | 57 ++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ff016807babf..641a219dbf50 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2991,37 +2991,58 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
-	int err = 0;
-	unsigned long time_left;
+	unsigned long time_left = msecs_to_jiffies(max_timeout);
 	unsigned long flags;
+	bool pending;
+	int err;
 
+retry:
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
-			msecs_to_jiffies(max_timeout));
+						time_left);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
+		/*
+		 * The caller of this function still owns the @lrbp tag so the
+		 * code below does not trigger any race conditions.
+		 */
+		hba->dev_cmd.complete = NULL;
 		err = ufshcd_get_tr_ocs(lrbp);
 		if (!err)
 			err = ufshcd_dev_cmd_completion(hba, lrbp);
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (!time_left) {
+	} else {
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
-		if (!ufshcd_clear_cmds(hba, 1U << lrbp->task_tag))
+		if (!ufshcd_clear_cmds(hba, 1U << lrbp->task_tag)) {
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
-		/*
-		 * in case of an error, after clearing the doorbell,
-		 * we also need to clear the outstanding_request
-		 * field in hba
-		 */
-		spin_lock_irqsave(&hba->outstanding_lock, flags);
-		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
-		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			/*
+			 * Since clearing the command succeeded we also need to
+			 * clear the task tag bit from the outstanding_reqs
+			 * variable.
+			 */
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			pending = test_bit(lrbp->task_tag,
+					   &hba->outstanding_reqs);
+			if (pending) {
+				hba->dev_cmd.complete = NULL;
+				__clear_bit(lrbp->task_tag,
+					    &hba->outstanding_reqs);
+			}
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+			if (!pending) {
+				/*
+				 * A race occurred between this function and the
+				 * completion handler.
+				 */
+				time_left = 1;
+				goto retry;
+			}
+		} else {
+			dev_err(hba->dev, "%s: failed to clear tag %d\n", __func__,
+				lrbp->task_tag);
+		}
 	}
 
 	return err;
