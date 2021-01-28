Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2F2C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8864B64DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhA1ES1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:18:27 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:40784 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhA1ESX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:18:23 -0500
IronPort-SDR: vRrkMxQsdGMEIcqNhHyKASMbZVtumbeFANqc7e5DocJgLnQtUp2OhGSesWcldGsJK8yTQXgkoZ
 IyenLQj5tnEdL4wHTQ5/VVXGWsfTXNmEUZCeXatU4lK6faThte6B8mfZPhlmGiWsIzd/a1D6+V
 F5k9BfwDsQBwnq2QjkE8+1mJwazKzaR6Woo0HHttniA7vXYI0AKIA2EzWcKQmuHq+r7TJbTwN9
 n2wpS4ZmnyFVDy5rTIjsd8HVV93DUPGreLkpJAi9ognRAGU4XKZ0TUhZjr5dWfr/K9ZApii+Sk
 aBw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="47715650"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 27 Jan 2021 20:17:48 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 27 Jan 2021 20:17:47 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id B120A219A2; Wed, 27 Jan 2021 20:17:47 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org, bvanassche@acm.org, asutoshd@codeaurora.org,
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
Subject: [PATCH v3 2/3] scsi: ufs: Fix a race condition btw task management request send and compl
Date:   Wed, 27 Jan 2021 20:16:03 -0800
Message-Id: <1611807365-35513-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_compl_tm() looks for all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL
and call complete() for each req who has the req->end_io_data set. There
can be a race condition btw tmc send/compl, because the req->end_io_data is
set, in __ufshcd_issue_tm_cmd(), without host lock protection, so it is
possible that when ufshcd_compl_tm() checks the req->end_io_data, it is set
but the corresponding tag has not been set in REG_UTP_TASK_REQ_DOOR_BELL.
Thus, ufshcd_tmc_handler() may wrongly complete TMRs which have not been
sent out. Fix it by protecting req->end_io_data with host lock, and let
ufshcd_compl_tm() only handle those tm cmds which have been completed
instead of looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.

Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c0c5925..43894a3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6225,7 +6225,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 
 struct ctm_info {
 	struct ufs_hba	*hba;
-	unsigned long	pending;
+	unsigned long	completed;
 	unsigned int	ncpl;
 };
 
@@ -6234,13 +6234,13 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
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
 
@@ -6255,12 +6255,19 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
 	struct request_queue *q = hba->tmf_queue;
+	u32 tm_doorbell;
+	unsigned long completed;
 	struct ctm_info ci = {
-		.hba	 = hba,
-		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
+		.hba = hba,
+		.ncpl = 0,
 	};
 
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+	completed = tm_doorbell ^ hba->outstanding_tasks;
+	if (completed) {
+		ci.completed = completed;
+		blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	}
 	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
@@ -6388,12 +6395,12 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	req->end_io_data = &wait;
 	free_slot = req->tag;
 	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
+	req->end_io_data = &wait;
 	task_tag = hba->nutrs + free_slot;
 	blk_mq_start_request(req);
 
@@ -6420,11 +6427,13 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

