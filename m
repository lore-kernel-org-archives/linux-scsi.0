Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB040FA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiJaSem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJaSel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:34:41 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91112D3C
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:34:41 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id q1so11399626pgl.11
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEEnVlz0aFrJUuHDCThuApZHi8690v4Hq0VP5GTHg/U=;
        b=t6UvESUABChYXeNNPNA0I8W+z1H4d4P1nRhRhq/bj/0lgB1ZmHdeRW0A9JrVjnIBu2
         Qy/Uh2Wz+828tKdz9WQOnZRhCufpk0OHB/PGyfCvDQNRr1oqHmPYm7ae/JDIL6K9t+wT
         z8cXK1v88CDSwGDEdB9vFE8/TOLhzpgzkFqUsNsCjX551qBp4Gp1qcnsqcHe2FJ1VGZO
         jppcyTn28uS+a9H5N6GQtb7Fu9gmC/oqyWRbD6jCB90Xuuo78oqHT0cMgjNy4SKl5Dyj
         kNKfLnYNqO9uGR9Acfz10I5J8eAZb8TAuLWAsPYhdAPruJVlDGpgzkYl2iFOTcw7s/Pd
         p88Q==
X-Gm-Message-State: ACrzQf0aMUQuR+uS71dum/HgDvA/NnwKJtvR9kKiLQdVkV0UsQ2LK85/
        /OgVfCPpX/HChYLCYVtxIoo=
X-Google-Smtp-Source: AMsMyM7Q44VwtZoB8wQCOF4oUBcDzDUJuF/9MiVueWBUN+BEW9w1ShLUYkRxkah/7rD0RD8edkt6hA==
X-Received: by 2002:a05:6a00:a94:b0:562:dcbb:47c3 with SMTP id b20-20020a056a000a9400b00562dcbb47c3mr15978413pfl.79.1667241280457;
        Mon, 31 Oct 2022 11:34:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902684b00b00186bc66d2cbsm4731811pln.73.2022.10.31.11.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:34:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2] scsi: ufs: Introduce ufshcd_abort_all()
Date:   Mon, 31 Oct 2022 11:34:21 -0700
Message-Id: <20221031183433.2443554-1-bvanassche@acm.org>
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

Changes compared to v1:
- changed type of 'tag' and 'ret' from 'unsigned int' into 'int'.

 drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b81a218f5644..d91e1f31c66f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6159,6 +6159,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	return false;
 }
 
+static bool ufshcd_abort_all(struct ufs_hba *hba)
+{
+	bool needs_reset = false;
+	int tag, ret;
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
@@ -6170,10 +6202,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool needs_restore;
 	bool needs_reset;
-	bool err_xfer;
-	bool err_tm;
 	int pmc_err;
-	int tag;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -6202,8 +6231,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 again:
 	needs_restore = false;
 	needs_reset = false;
-	err_xfer = false;
-	err_tm = false;
 
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
@@ -6272,34 +6299,13 @@ static void ufshcd_err_handler(struct work_struct *work)
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
