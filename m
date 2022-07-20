Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E852CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 17:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiGTRCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiGTRCj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 13:02:39 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC17E69F12
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 10:02:38 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id gn24so3953731pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 10:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkXdFV3u3E0siR+xTVivQ3YVSktJVBj9i/kTbKvs8pE=;
        b=4lz3XzAZz+1UQfYq8NO5KKbY0tOZ9u6CF33D/WBwgUApNewFhRj+Ot4QtzXI9RkW9Y
         l4eJ5umCLnmuC8ncYOjks07hsJZ6sGHvgvJaMuWVZEBt/+U6M9PZSiHoODzSnAeaf6D3
         7engP/LWOx9zocV1ddnGF8aHMtDpk8M4kcEwT5752bp0FLw66W1XRqW8kLZ/JMIFd6/K
         iflbZ7x2dHljJrYHJqP69Op/9xeZnMiRBAFNbavDmzE4ZoHWu/svyTe6m07n1QZDjxyG
         HtjebxtMKqK3jhxcoXgSvNOIT/UXUh0j9SInyHaKQ90IURNjhzU7B5jF58UQ73gZmOlu
         ip5Q==
X-Gm-Message-State: AJIora/i3D6WRgwZP8vZtim18lI8ZdFXXibol/Cbar36CEbMUxNvhH8Y
        KyX/HDYZKAUXdD3WUY03Zbc=
X-Google-Smtp-Source: AGRyM1stgiIbUF7E+w40S5BOTaLyQErzU4ehRPWGFVw5ZsZi3ew8t+nOs3MZVuVTO3ai5rEydero9Q==
X-Received: by 2002:a17:902:ce10:b0:16c:9ac3:86cc with SMTP id k16-20020a170902ce1000b0016c9ac386ccmr36910025plg.116.1658336558182;
        Wed, 20 Jul 2022 10:02:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a7e0:78fc:9269:215b])
        by smtp.gmail.com with ESMTPSA id r16-20020aa79890000000b005254e44b748sm13733858pfl.84.2022.07.20.10.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:02:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v2] scsi: ufs: Fix a race condition related to device management
Date:   Wed, 20 Jul 2022 10:02:23 -0700
Message-Id: <20220720170228.1598842-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: made source code comments more clear.

 drivers/ufs/core/ufshcd.c | 58 +++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index decadd227b96..36b7212e9cb5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2992,37 +2992,59 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
+		 * The completion handler called complete() and the caller of
+		 * this function still owns the @lrbp tag so the code below does
+		 * not trigger any race conditions.
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
+		if (ufshcd_clear_cmds(hba, 1U << lrbp->task_tag) == 0) {
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
+				 * The completion handler ran while we tried to
+				 * clear the command.
+				 */
+				time_left = 1;
+				goto retry;
+			}
+		} else {
+			dev_err(hba->dev, "%s: failed to clear tag %d\n",
+				__func__, lrbp->task_tag);
+		}
 	}
 
 	return err;
