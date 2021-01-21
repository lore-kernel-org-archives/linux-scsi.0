Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3306CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D300F2389A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733290AbhAUD4F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:56:05 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:55403 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732616AbhAUDX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:23:57 -0500
IronPort-SDR: t5UuSi4kM6fxEGFF/J78THeEzwbXRDfNYha/4mFia/z0jtG+6Ej3lLvqzF2doSXM+Gp83mlW/D
 LTAJBuoc0miYVmbmMmadt1w8wW0SHDSpd2qpeWi2tiFk7yqVEqhtw8m2o9AwoguFbLNieNQKwh
 AnIY9BLlRNXETJ2im6gLbPdUx0VR7P8MvyUtZY3V+IU/NbNXzn5D6rHz8EE4STu09HmZEK2KVL
 vpXzSJ4qUeRKEosV5iFCsC0fN5PpuGyHYv3dVOYoe4Mqs7PLtczZUTnTCeV7O0d2d/6Bg+ExMg
 meU=
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="47685556"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 20 Jan 2021 19:23:10 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 20 Jan 2021 19:23:09 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 7BE56218EF; Wed, 20 Jan 2021 19:23:09 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] scsi: ufs: Fix some problems in task management request implementation
Date:   Wed, 20 Jan 2021 19:23:03 -0800
Message-Id: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current task management request send/compl implementation is broken, the
problems and fixes are listed as below:

Problem: TMR completion timeout. ufshcd_tmc_handler() calls
         blk_mq_tagset_busy_iter(fn == ufshcd_compl_tm()), but since
         blk_mq_tagset_busy_iter() only iterates over all reserved tags and
         started requests, so ufshcd_compl_tm() never gets a chance to run.
Fix:     Call blk_mq_start_request() in __ufshcd_issue_tm_cmd().

Problem: Race condition in send/compl paths. ufshcd_compl_tm() looks for
         all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL and call complete()
         for each req who has the req->end_io_data set. There can be a race
         condition btw tmc send/compl, because req->end_io_data is set, in
         __ufshcd_issue_tm_cmd(), without host lock protection, so it is
         possible that when ufshcd_compl_tm() checks the req->end_io_data,
         req->end_io_data is set but the corresponding tag has not been set
         in the REG_UTP_TASK_REQ_DOOR_BELL. Thus, ufshcd_tmc_handler() may
         wrongly complete TMRs which have not been sent.
Fix:     Protect req->end_io_data with host lock. And let ufshcd_compl_tm()
         only handle those tm cmds which have been completed instead of
         looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.

Problem: In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs +
         req->tag as the Task Tag in one TMR UPIU.
Fix:     Directly use req->tag as Task Tag.

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---

Change since v1:
- Typo fixed

This change is based on Jaegeuk's change - https://git.kernel.org/mkp/scsi/c/eeb1b55b6e25

---
 drivers/scsi/ufs/ufshcd.c | 71 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4be35bf..8935c57 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6213,7 +6213,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 
 struct ctm_info {
 	struct ufs_hba	*hba;
-	unsigned long	pending;
+	unsigned long	completed;
 	unsigned int	ncpl;
 };
 
@@ -6222,13 +6222,13 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
 	struct ctm_info *const ci = priv;
 	struct completion *c;
 
-	WARN_ON_ONCE(reserved);
-	if (test_bit(req->tag, &ci->pending))
-		return true;
-	ci->ncpl++;
-	c = req->end_io_data;
-	if (c)
-		complete(c);
+	if (test_bit(req->tag, &ci->completed)) {
+		__clear_bit(req->tag, &ci->hba->outstanding_tasks);
+		ci->ncpl++;
+		c = req->end_io_data;
+		if (c)
+			complete(c);
+	}
 	return true;
 }
 
@@ -6244,11 +6244,19 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
 	struct request_queue *q = hba->tmf_queue;
 	struct ctm_info ci = {
-		.hba	 = hba,
-		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
+		.hba = hba,
+		.ncpl = 0,
 	};
+	u32 tm_doorbell;
+	unsigned long completed;
+
+	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+	completed = tm_doorbell ^ hba->outstanding_tasks;
 
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	if (completed) {
+		ci.completed = completed;
+		blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	}
 	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
@@ -6366,37 +6374,33 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
-	int free_slot, task_tag, err;
+	int task_tag, err;
 
 	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 * blk_get_request() used here is only to get a free tag.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	req->end_io_data = &wait;
-	free_slot = req->tag;
-	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
-
 	spin_lock_irqsave(host->host_lock, flags);
-	task_tag = hba->nutrs + free_slot;
+	req->end_io_data = &wait;
+	blk_mq_start_request(req);
 
+	task_tag = req->tag;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
-	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
+	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
+	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
 	/* send command to the controller */
-	__set_bit(free_slot, &hba->outstanding_tasks);
+	__set_bit(task_tag, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
 	wmb();
 
-	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 
@@ -6408,32 +6412,33 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		/*
 		 * Make sure that ufshcd_compl_tm() does not trigger a
 		 * use-after-free.
 		 */
 		req->end_io_data = NULL;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
-			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
-					__func__, free_slot);
+		if (ufshcd_clear_tm_cmd(hba, task_tag)) {
+			dev_WARN(hba->dev, "%s: unable to clear tm cmd (slot %d) after timeout\n",
+					__func__, task_tag);
+		} else {
+			__clear_bit(task_tag, &hba->outstanding_tasks);
+		}
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	__clear_bit(free_slot, &hba->outstanding_tasks);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
+	ufshcd_release(hba);
 	blk_put_request(req);
 
-	ufshcd_release(hba);
 	return err;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

