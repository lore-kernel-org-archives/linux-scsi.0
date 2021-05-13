Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09574C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DBF61206
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhEMF5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 01:57:30 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:2036 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhEMF5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 01:57:20 -0400
IronPort-SDR: vYRvV5bYodqEndZ0KnOncADjjEaqKW8MZVVQHICXZm2bporKLx9zafZM5qgc7xVsotN5n8GGce
 AR568biYIE8SX43rC4nzRcNKmV7w44soGZz/+yj+oLv9AVlEAyH38k/sM2rNqvUdtgZGckuHj+
 ZMxCra7TN1oz3aJ/RG8AG5xD04jcAOlh+K3gzsz1iaj7ITQcWeo9iuVYSgPyn75GvzTNERSTDM
 85fPbkUD6ZoAQ8LCKFK8wXbZAtzHVnsMtoKJfQU/rqNJeHNcH6UacO9rtEx0wUJ+lHRUTwADYU
 xrs=
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="29767599"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 12 May 2021 22:56:08 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 12 May 2021 22:56:08 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3E7C321A85; Wed, 12 May 2021 22:56:08 -0700 (PDT)
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
Subject: [PATCH v1 6/6] scsi: ufs: Update the fast abort path in ufshcd_abort() for PM requests
Date:   Wed, 12 May 2021 22:55:19 -0700
Message-Id: <1620885319-15151-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If PM requests fail during runtime suspend/resume, RPM framework saves the
error to dev->power.runtime_error. Before the runtime_error gets cleared,
runtime PM on this specific device won't work again, leaving the device
in either suspended or active state permanently.

When task abort happens to a PM request sent during runtime suspend/resume,
even if it can be successfully aborted, RPM framework anyways saves the
(TIMEOUT) error. But we want more and we can do better - let error handling
recover and clear the runtime_error. So, let PM requests take the fast
abort path in ufshcd_abort().

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a6313cf40..2a814e2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2643,7 +2643,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp = &hba->lrb[tag];
 	if (unlikely(lrbp->in_use)) {
-		if (hba->wl_pm_op_in_progress)
+		if (cmd->request->rq_flags & RQF_PM)
 			set_host_byte(cmd, DID_BAD_TARGET);
 		else
 			err = SCSI_MLQUEUE_HOST_BUSY;
@@ -2690,7 +2690,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		 * err handler blocked for too long. So, just fail the scsi cmd
 		 * sent from PM ops, err handler can recover PM error anyways.
 		 */
-		if (hba->wl_pm_op_in_progress) {
+		if (cmd->request->rq_flags & RQF_PM) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
 			goto out_compl_cmd;
@@ -6959,14 +6959,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 
 	/*
-	 * Task abort to the device W-LUN is illegal. When this command
-	 * will fail, due to spec violation, scsi err handling next step
-	 * will be to send LU reset which, again, is a spec violation.
-	 * To avoid these unnecessary/illegal steps, first we clean up
-	 * the lrb taken by this cmd and mark the lrb as in_use, then
-	 * queue the eh_work and bail.
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
 		spin_lock_irqsave(host->host_lock, flags);
 		if (lrbp->cmd) {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

