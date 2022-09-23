Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB2DC04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiIWUMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIWUMj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:12:39 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338F6122635
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:39 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id w10so1116904pll.11
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=i1jyau84prJieE2HclaLqAMm6ptQVFeieqAEFbMFfME=;
        b=eNNIUEjY28cpWz7io926cT4ZQOKTDKB1r7Os18zaW4wiqDQ7EIMtpqzUeflwsZDQKT
         1RtOX6uoL1L2vntHbmoeAk4CJLNsauWt+14GEyz+R45gJ81VRgoPJEC1hep2U6XBPZ3x
         /jd3p+WoO95dZlW+nRb3CJXipeeXaIO9NXilqrPBHW+9ztkHewh6Oy8W8dGAlua7EfmP
         7XvV4vFKe4XfbHNFrTHF57DH36deT5q+p5ik0LCGKicgkAMuCJs+YGW3dSVzs04Efcsk
         W8wOu2lkHKj7pnMaSmrwvKIbJlD11mWeOcRplrVPu1YbljPD9TGyF225QQvoa/kMMI+d
         ipeQ==
X-Gm-Message-State: ACrzQf22mi2dGY1IsLq83rMbgLQIq/Y3NkWHcOSoGbZEKLF+p1at7nZi
        M+5SZOv8XtGMOXXcBAJqgdw=
X-Google-Smtp-Source: AMsMyM6GCKBD38TW89nCm93tmfK3gFEVTNvwCp4yU5pCNcsWkwBf1YiQ4Rm1/pLUAMoxmmuu9hstWA==
X-Received: by 2002:a17:902:db0f:b0:176:e70f:6277 with SMTP id m15-20020a170902db0f00b00176e70f6277mr10156543plx.13.1663963958566;
        Fri, 23 Sep 2022 13:12:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:12:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 6/8] scsi: ufs: Split ufshcd_err_handler()
Date:   Fri, 23 Sep 2022 13:11:36 -0700
Message-Id: <20220923201138.2113123-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for invoking error handling without holding 'host_sem'. The only
functional change in this patch is that two dev_info() calls now happen
while 'host_sem' is held instead without holding 'host_sem'.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8c0504e9e83..d7453f788d0d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6201,14 +6201,9 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	return false;
 }
 
-/**
- * ufshcd_err_handler - handle UFS errors that require s/w attention
- * @work: pointer to work structure
- */
-static void ufshcd_err_handler(struct work_struct *work)
+static void ufshcd_recover_link(struct ufs_hba *hba)
 {
 	int retries = MAX_ERR_HANDLER_RETRIES;
-	struct ufs_hba *hba;
 	unsigned long flags;
 	bool needs_restore;
 	bool needs_reset;
@@ -6217,8 +6212,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int pmc_err;
 	int tag;
 
-	hba = container_of(work, struct ufs_hba, eh_work);
-
 	dev_info(hba->dev,
 		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
 		 __func__, ufshcd_state_name[hba->ufshcd_state],
@@ -6226,13 +6219,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
-	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		up(&hba->host_sem);
 		return;
 	}
 	ufshcd_set_eh_in_progress(hba);
@@ -6401,12 +6392,24 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
-	up(&hba->host_sem);
 
 	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
 		 ufshcd_state_name[hba->ufshcd_state]);
 }
 
+/**
+ * ufshcd_err_handler - handle UFS errors that require s/w attention
+ * @work: pointer to work structure
+ */
+static void ufshcd_err_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba, eh_work);
+
+	down(&hba->host_sem);
+	ufshcd_recover_link(hba);
+	up(&hba->host_sem);
+}
+
 /**
  * ufshcd_update_uic_error - check and set fatal UIC error flags.
  * @hba: per-adapter instance
