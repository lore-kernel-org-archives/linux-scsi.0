Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780B1FA3740
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 20:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiJ0UoW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiJ0UoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 16:44:03 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7737646A
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2022 13:44:03 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id pb15so2743506pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2022 13:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lR9iJmJbV/MCHxwQI08savFMzXXQH/aTa391ABoAr8o=;
        b=xITeUhJWMBsqENRZJ9KKMNjrXi+iWm8FbuQWEywgF7LnwovGdszzCyI52qIzG63oLD
         viO9j5Fl0UX93M3+dPrjnGS1YiF9fNSYZLMV2t6ep2A65MwrKOJA8WAjemuxQlbPizaR
         uNi6qdwPFqTKlSWECXbgQA8uBmK6HlKgdPB8nIpEEzrvQCpwec5muKIk+mNR7fkP5aC7
         oLco8BqYnAhO/kRND3ZPX9Sbu64C8YOr3ItVjWrhEL4G900mPvH6/VZEa41Ntb1fMOaL
         Zv0t7H8XWMVV7VIHQH4G+nDS8Jb1G5Kw31GPvN3+3PyR/rRqiZkYDwBn30vIvLNfrOmN
         /N8w==
X-Gm-Message-State: ACrzQf3Qbr1smmQFSurh2pxPbVXrSjVLk9IdOSyvcSlQvrxVLzPGdzsu
        8M5d3+FN4KQ7/VssgFEUb30=
X-Google-Smtp-Source: AMsMyM6SzPxyyi2FVPO6TQBKk7W+stEb1VABZLA5I10dtc429LWlUbcJ/jEdlixL01nd3ehMO5KtGA==
X-Received: by 2002:a17:90a:bf11:b0:211:84c5:42d7 with SMTP id c17-20020a17090abf1100b0021184c542d7mr11890395pjs.122.1666903442495;
        Thu, 27 Oct 2022 13:44:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bc2b:ff19:1b02:257b])
        by smtp.gmail.com with ESMTPSA id d7-20020a17090a498700b0021134a19ae2sm2992050pjh.50.2022.10.27.13.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH] scsi: ufs: Introduce ufshcd_abort_all()
Date:   Thu, 27 Oct 2022 13:43:43 -0700
Message-Id: <20221027204356.1146212-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the code for aborting all SCSI commands and TMFs into a new function.
This patch makes the ufshcd_err_handler() easier to read. Except for adding
more logging, this patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee73d7036133..05feec10fad3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6157,6 +6157,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	return false;
 }
 
+static bool ufshcd_abort_all(struct ufs_hba *hba)
+{
+	bool needs_reset = false;
+	unsigned int tag, ret;
+
+	/* Clear pending transfer requests */
+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
+		ret = ufshcd_try_to_abort_task(hba, tag);
+		dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
+			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
+			ret ? "failed" : "succeeded");
+		if (ret) {
+			needs_reset = true;
+			goto out;
+		}
+	}
+
+	/* Clear pending task management requests */
+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
+		if (ufshcd_clear_tm_cmd(hba, tag)) {
+			needs_reset = true;
+			goto out;
+		}
+	}
+
+out:
+	/* Complete the requests that are cleared by s/w */
+	ufshcd_complete_requests(hba);
+
+	return needs_reset;
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -6168,10 +6200,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool needs_restore;
 	bool needs_reset;
-	bool err_xfer;
-	bool err_tm;
 	int pmc_err;
-	int tag;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -6200,8 +6229,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 again:
 	needs_restore = false;
 	needs_reset = false;
-	err_xfer = false;
-	err_tm = false;
 
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
@@ -6270,34 +6297,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 	hba->silence_err_logs = true;
 	/* release lock as clear command might sleep */
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	/* Clear pending transfer requests */
-	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
-		if (ufshcd_try_to_abort_task(hba, tag)) {
-			err_xfer = true;
-			goto lock_skip_pending_xfer_clear;
-		}
-		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
-			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
-	}
 
-	/* Clear pending task management requests */
-	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
-		if (ufshcd_clear_tm_cmd(hba, tag)) {
-			err_tm = true;
-			goto lock_skip_pending_xfer_clear;
-		}
-	}
-
-lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	needs_reset = ufshcd_abort_all(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
-	if (err_xfer || err_tm) {
-		needs_reset = true;
+	if (needs_reset)
 		goto do_reset;
-	}
 
 	/*
 	 * After all reqs and tasks are cleared from doorbell,
