Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5BCC433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7A023403
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAGSyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 13:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbhAGSyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 13:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B027223406;
        Thu,  7 Jan 2021 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610045607;
        bh=wZlEKoUTut7Ta2lwXD3pCQy/hjX8qt2LFA8HJ2Y+NuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVVZyAeUPuuz7dfWULNBLT2kn3ZYmBOxCtbvR1kZl1/jmF+4Fb/VjbH4CDqSHAfcD
         M9ANs3y8/HBKKoTWy4TZGVq++4KUnwPnGItYK7f+ZV49MmSdDuu5dMNiseC8f2LzNy
         iuNAFy/KpDVBiOIeao+/2A9wU+Jj+Qv+UcjWDdgGaT5DHyX/HWsUNSFuVvVt0WBnCy
         3Y/iOzI8PqH7U0soEqxpvluoh/iooOP9IDNeMB8l/sFYtDt4kf8uZSSaWDYYed8bGP
         RLxVc+VSUpswZq+kqK70ft6RwB+qowAKynU9KyRIhr7JemMI+3lqCa6cL8sB3S8+tw
         BJYpsJpIjEP7g==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v5 2/2] scsi: ufs: fix tm request correctly when non-fatal error happens
Date:   Thu,  7 Jan 2021 10:53:16 -0800
Message-Id: <20210107185316.788815-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20210107185316.788815-1-jaegeuk@kernel.org>
References: <20210107185316.788815-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When non-fatal error like line-reset happens, ufshcd_err_handler() starts to
abort tasks by ufshcd_try_to_abort_task(). When it tries to issue tm request,
we've hit two warnings.

WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 blk_mq_get_tag+0x438/0x46c

After fixing the above warnings, I've hit another tm_cmd timeout, which may be
caused by unstable controller state.

__ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out

Then, ufshcd_err_handler() enters full reset, and I hit kernel stuck. It turned
out ufshcd_print_trs() printed too many messages in console which requires CPU
locks. Likewise hba->silence_err_logs, we need to avoid too verbose messages.
Actually it came from ufshcd_transfer_rsp_status() when requeuing commands back.
Indeed, this is actually not an error case, so let's fix it.

Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e6e7bdf99cd7..2a715f13fe1d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4996,7 +4996,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	} /* end of switch */
 
-	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
+	if ((host_byte(result) != DID_OK) &&
+	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -6302,9 +6303,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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
 
@@ -6348,7 +6353,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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

