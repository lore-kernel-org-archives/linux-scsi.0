Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9F9C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4810F6128A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhFWHkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:40:02 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:7940 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhFWHji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:38 -0400
IronPort-SDR: jy8uAwflVNG+L5mclM1eGNhOAaQWdfjN3TOGMex+azcwwvAn9JAsMofy2Ux3pLL4Mj36hUrrzd
 g3BuEs135RWNFD2He1jBrohucf1Ny+ym3HB98pyP1K+BuupL130U16erqRxGIrUCjfPqFWZvU9
 mprPr07lNKsFH0LXVWqyAYxb5sYct8pKlqyh0wmv6Czb9S0GP4NzVtCoykep2j83FPhgj0Zh/2
 kdGxrcXKbJgTQKBHCuLWzq8klqn9CqZgZByn3bbVrvey313zYe0WOQo3YVnj+E41HVoKhYj6+m
 AE0=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="47902947"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:21 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:37:21 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 86AB321BC1; Wed, 23 Jun 2021 00:37:21 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 09/10] scsi: ufs: Update the fast abort path in ufshcd_abort() for PM requests
Date:   Wed, 23 Jun 2021 00:35:09 -0700
Message-Id: <1624433711-9339-11-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If PM requests fail during runtime suspend/resume, RPM framework saves the
error to dev->power.runtime_error. Before the runtime_error gets cleared,
runtime PM on this specific device won't work again, leaving the device
either runtime active or runtime suspended permanently.

When task abort happens to a PM request sent during runtime suspend/resume,
even if it can be successfully aborted, RPM framework anyways saves the
(TIMEOUT) error. In this situation, we can leverage error handling to
recover and clear the runtime_error. So, let PM requests take the fast
abort path in ufshcd_abort().

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d739401..59fc521 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2737,7 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		 * err handler blocked for too long. So, just fail the scsi cmd
 		 * sent from PM ops, err handler can recover PM error anyways.
 		 */
-		if (hba->wlu_pm_op_in_progress) {
+		if (cmd->request->rq_flags & RQF_PM) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
 			cmd->scsi_done(cmd);
@@ -6981,11 +6981,14 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	int err = 0;
 	struct ufshcd_lrb *lrbp;
 	u32 reg;
+	bool need_eh = false;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 	lrbp = &hba->lrb[tag];
+
+	dev_info(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
 			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
@@ -7003,9 +7006,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	/* Print Transfer Request of aborted task */
-	dev_info(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
-
 	/*
 	 * Print detailed info about aborted request.
 	 * As more than one request might get aborted at the same time,
@@ -7033,21 +7033,21 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 
 	/*
-	 * Task abort to the device W-LUN is illegal. When this command
-	 * will fail, due to spec violation, scsi err handling next step
-	 * will be to send LU reset which, again, is a spec violation.
-	 * To avoid these unnecessary/illegal steps, first we clean up
-	 * the lrb taken by this cmd and re-set it in outstanding_reqs,
-	 * then queue the eh_work and bail.
+	 * This fast path guarantees the cmd always gets aborted successfully,
+	 * meanwhile it invokes the error handler. It allows contexts, which
+	 * are blocked by this cmd, to fail fast. It serves multiple purposes:
+	 * #1 To avoid unnecessary/illagal abort attempts to the W-LU.
+	 * #2 To avoid live lock between eh_work and specific contexts, i.e.,
+	 *    suspend/resume and eh_work itself.
+	 * #3 To let eh_work recover runtime PM error in case abort happens
+	 *    to cmds sent from runtime suspend/resume ops.
 	 */
-	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
+	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN ||
+	    (cmd->request->rq_flags & RQF_PM)) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
 		set_bit(tag, &hba->outstanding_reqs);
-		spin_lock_irqsave(host->host_lock, flags);
-		hba->force_reset = true;
-		ufshcd_schedule_eh_work(hba);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		need_eh = true;
 		goto out;
 	}
 
@@ -7061,6 +7061,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 cleanup:
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
 out:
+		if (cmd->request->rq_flags & RQF_PM || need_eh) {
+			spin_lock_irqsave(host->host_lock, flags);
+			hba->force_reset = true;
+			ufshcd_schedule_eh_work(hba);
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

