Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1C4C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780F6613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGIUad (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:33 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:41820 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:33 -0400
Received: by mail-pg1-f177.google.com with SMTP id s18so11096003pgg.8
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b/v7uB/YP9ehVQYlmoiWZmVmWWaSmg8+KSUaByScH0s=;
        b=bZAgzLf7YYUxeKSjwPe+Bskhba3xLFyTzsCPEOgbTc0pu403OBSg5/lwLGGrTG01EX
         aIDCY9XnBH2xQkHLKVnL53FtjhZZYmSvbyWwTIO201R1T4XzmsjPBeXgv0to0vPNXQvg
         oblwEgkYbK/8uzno85gbUWXMvgFfu1GPWzT61qGn46crqm5WqeQGf/b+p0TYz6xSFJv2
         V01wNvLcEnpSzxSJmkRDiHaeZiKW6EE+6/2qWgs09txAB771AigMFOzRpzIC8Jmf+gub
         MvlKW8pXVDfHP4bJ7ON/FhWpR9y37me8Gt/XaGsIQJX6fPj2KgsQYE0s9FFf1hIuwSxI
         NKSA==
X-Gm-Message-State: AOAM532JpaZaUPU/lZX55WDHCGMWRZI02a90F1RFkGJz0pFyD9VZloSZ
        khkHafKlz3ae9hZfijzQU5E=
X-Google-Smtp-Source: ABdhPJx/UNy5POOKFMPs5X/amYYqT3DLb624D46cxUxgsdeez3sdiS6eaICHOez6ikNiH8ts2SNp3Q==
X-Received: by 2002:a63:1622:: with SMTP id w34mr778557pgl.354.1625862468666;
        Fri, 09 Jul 2021 13:27:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 15/19] scsi: ufs: Fix the SCSI abort handler
Date:   Fri,  9 Jul 2021 13:26:34 -0700
Message-Id: <20210709202638.9480-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the following changes in ufshcd_abort():
- Return FAILED instead of SUCCESS if the abort handler notices that a SCSI
  command has already been completed. Returning SUCCESS in this case
  triggers a use-after-free and may trigger a kernel crash.
- Fix the code for aborting SCSI commands submitted to a WLUN.

The current approach for aborting SCSI commands that have been submitted to
a WLUN and that timed out is as follows:
- Report to the SCSI core that the command has completed successfully.
  Let the block layer free any data buffers associated with the command.
- Mark the command as outstanding in 'outstanding_reqs'.
- If the block layer tries to reuse the tag associated with the aborted
  command, busy-wait until the tag is freed.

This approach can result in:
- Memory corruption if the controller accesses the data buffer after the
  block layer has freed the associated data buffers.
- A race condition if ufshcd_queuecommand() or ufshcd_exec_dev_cmd()
  checks the bit that corresponds to an aborted command in 'outstanding_reqs'
  after it has been cleared and before it is reset.
- High energy consumption if ufshcd_queuecommand() repeatedly returns
  SCSI_MLQUEUE_HOST_BUSY.

Fix this by reporting to the SCSI error handler that aborting a SCSI
command failed if the SCSI command was submitted to a WLUN.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Fixes: 7a7e66c65d41 ("scsi: ufs: Fix a race condition between ufshcd_abort() and eh_work()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 62 +++++++++++++--------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index becd9e2829f4..ea3c2d052123 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2724,15 +2724,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
 		(hba->clk_gating.state != CLKS_ON));
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		if (hba->pm_op_in_progress)
-			set_host_byte(cmd, DID_BAD_TARGET);
-		else
-			err = SCSI_MLQUEUE_HOST_BUSY;
-		ufshcd_release(hba);
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
@@ -2926,11 +2917,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -6625,11 +6611,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
@@ -6928,19 +6909,19 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	unsigned int tag = cmd->request->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
-	int err = 0;
+	int err = FAILED, res;
 	u32 reg;
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	/* If command is already aborted/completed, return SUCCESS */
+	/* If command is already aborted/completed, return FAILED. */
 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
 		dev_err(hba->dev,
 			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
 			__func__, tag, hba->outstanding_reqs, reg);
-		goto out;
+		goto release;
 	}
 
 	/* Print Transfer Request of aborted task */
@@ -6969,7 +6950,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		goto cleanup;
+		ufshcd_transfer_req_compl(hba, 1UL << tag);
+		goto release;
 	}
 
 	/*
@@ -6982,36 +6964,32 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
-		ufshcd_transfer_req_compl(hba, 1UL << tag);
-		set_bit(tag, &hba->outstanding_reqs);
+
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
 		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
-		goto out;
+		goto release;
 	}
 
 	/* Skip task abort in case previous aborts failed and report failure */
-	if (lrbp->req_abort_skip)
-		err = -EIO;
-	else
-		err = ufshcd_try_to_abort_task(hba, tag);
+	if (lrbp->req_abort_skip) {
+		dev_err(hba->dev, "%s: skipping abort\n", __func__);
+		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
+		goto release;
+	}
 
-	if (!err) {
-cleanup:
-		ufshcd_transfer_req_compl(hba, 1UL << tag);
-out:
-		err = SUCCESS;
-	} else {
-		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
+	res = ufshcd_try_to_abort_task(hba, tag);
+	if (res) {
+		dev_err(hba->dev, "%s: failed with err %d\n", __func__, res);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
-		err = FAILED;
+		goto release;
 	}
 
-	/*
-	 * This ufshcd_release() corresponds to the original scsi cmd that got
-	 * aborted here (as we won't get any IRQ for it).
-	 */
+	err = SUCCESS;
+
+release:
+	/* Matches the ufshcd_hold() call at the start of this function. */
 	ufshcd_release(hba);
 	return err;
 }
