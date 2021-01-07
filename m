Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8ECC43381
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1EA20705
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbhAGHr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 02:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbhAGHr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 02:47:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A81C2312C;
        Thu,  7 Jan 2021 07:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610005635;
        bh=13x/aMrJHQQPVB8F9oQzX7H6jaKgP3Tkp3MjMmKNa3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+H+jVHRJaK28DXbJ2RyU5DEdVl+o3n1dBBkturx0xHVRLwP70WbTHp66O7v5ezlJ
         6worKeObn+7lsAEDvA6I7BcDyetWF7evgwG6XTO6uol8YOFI7iXIj20HBfKnaGCQtp
         trcGmxHu+uZH6lXSRDZPZ9bY2g2d6+eRvr0x1V9L/r0TLqrdx3Fr6oaZbZBAF8AvoN
         BFjxHyOBCi+rdSROP98Qbha9Td5i1nsJvtMim5YvYxBXQ7hj6/j9TdVaAuvJgCU5Gr
         WxL1rvKt/Nfcrvafx8rWlcU0zA+0FAREKrPTyuP9gnh3uwhvO0BXXRbCPVtFC1F+L4
         OnDBdWG9xQ3PQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v4 2/2] scsi: ufs: handle LINERESET with correct tm_cmd
Date:   Wed,  6 Jan 2021 23:47:10 -0800
Message-Id: <20210107074710.549309-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20210107074710.549309-1-jaegeuk@kernel.org>
References: <20210107074710.549309-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

This fixes a warning caused by wrong reserve tag usage in __ufshcd_issue_tm_cmd.

WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 blk_mq_get_tag+0x438/0x46c

And, in ufshcd_err_handler(), we can avoid to send tm_cmd before aborting
outstanding commands by waiting a bit for IO completion like this.

__ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out

Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Fixes: 2355b66ed20c ("scsi: ufs: Handle LINERESET indication in err handler")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e6e7bdf99cd7..340dd5e515dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -44,6 +44,9 @@
 /* Query request timeout */
 #define QUERY_REQ_TIMEOUT 1500 /* 1.5 seconds */
 
+/* LINERESET TIME OUT */
+#define LINERESET_IO_TIMEOUT_MS			(30000) /* 30 sec */
+
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
@@ -5826,6 +5829,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int err = 0, pmc_err;
 	int tag;
 	bool needs_reset = false, needs_restore = false;
+	ktime_t start;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -5911,6 +5915,22 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 	hba->silence_err_logs = true;
+
+	/* Wait for IO completion for non-fatal errors to avoid aborting IOs */
+	start = ktime_get();
+	while (hba->outstanding_reqs) {
+		ufshcd_complete_requests(hba);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		schedule();
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
+						LINERESET_IO_TIMEOUT_MS) {
+			dev_err(hba->dev, "%s: timeout, outstanding=0x%lx\n",
+					__func__, hba->outstanding_reqs);
+			break;
+		}
+	}
+
 	/* release lock as clear command might sleep */
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Clear pending transfer requests */
@@ -6302,9 +6322,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (enabled_intr_status && retval == IRQ_NONE) {
-		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
-					__func__, intr_status);
+	if (enabled_intr_status && retval == IRQ_NONE &&
+				!ufshcd_eh_in_progress(hba)) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
+					__func__,
+					intr_status,
+					hba->ufs_stats.last_intr_status,
+					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
@@ -6348,7 +6372,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
 	req->end_io_data = &wait;
 	free_slot = req->tag;
 	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
-- 
2.29.2.729.g45daf8777d-goog

