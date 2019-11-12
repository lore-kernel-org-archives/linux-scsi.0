Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C580C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F031214E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKLRhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 12:37:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37666 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLRhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 12:37:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id z24so12317730pgu.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 09:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RC2IGkn2oPUfvIzXiI1AnU80T0pyTqhutovQB4IX/K4=;
        b=KhcIFPxCKowCRElfdC2JsZ+ICzyTE9BBjToRLEP9xnC/XMoaj9G49AN1BFd7z4jii4
         HiiOJigAmTIJVeOzHEjtNyk0frYA1yuKR0+H9y6rylfX2iyD1q8tyB/V0DRWwGG0yJS1
         ds6vfLpPw2KQuPmUS7r1pMOeYvF1G31UeqF1ri98/MaxSYO3J6ukOPIqqdgsQTSgwiKp
         mlxwWDp1WI6LSgmBLbaiiwbH/KsR9QMfXt+1V8iSQHfOhjREmPfY3+O9R0H714tftkaw
         J3ETzeOuvm8C5n2ZUx2P1uA7WJtSrpEOcdh7kteMv26vrJyYYt94g2rlk2mKFWFhHfzW
         hIYg==
X-Gm-Message-State: APjAAAVBzmvPNyxdd3f+D/IGnda3Gedzd41M7OiwWJyVtvHwhfcLyPoN
        6SZk5VWAOPqBeDUFsgwp3kk=
X-Google-Smtp-Source: APXvYqwe/5R3Xjl902H+WrcPdSN55KeaAuekJfaYxrM2nSTKLFVs4rKpHHO85mBmadlmz5mPLi/rdA==
X-Received: by 2002:a17:90a:970a:: with SMTP id x10mr79630pjo.39.1573580272769;
        Tue, 12 Nov 2019 09:37:52 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w19sm12930969pga.83.2019.11.12.09.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 09:37:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v5 1/4] ufs: Serialize error handling and command submission
Date:   Tue, 12 Nov 2019 09:37:40 -0800
Message-Id: <20191112173743.141503-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191112173743.141503-1-bvanassche@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the legacy SCSI core holding the host lock was sufficient to serialize
queuecommand() calls and error handling. With scsi-mq a call to
blk_mq_quiesce() is required to wait until ongoing queuecommand calls have
finished. scsi_target_block() calls blk_mq_quiesce().

Cc: Bean Huo <beanhuo@micron.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Fixes: d5038a13eca7 ("scsi: core: switch to scsi-mq by default")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cbe3b45cf1c..a03538165a12 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5275,6 +5275,8 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
 	unsigned long flags;
 	u32 err_xfer = 0;
 	u32 err_tm = 0;
@@ -5283,10 +5285,19 @@ static void ufshcd_err_handler(struct work_struct *work)
 	bool needs_reset = false;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
+	sdev = hba->sdev_ufs_device;
+	starget = sdev ? sdev->sdev_target : NULL;
 
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
 
+	/*
+	 * Wait until ongoing ufshcd_queuecommand() calls have finished
+	 * without waiting for command completion.
+	 */
+	if (starget)
+		scsi_target_block(&starget->dev);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		goto out;
@@ -5395,6 +5406,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (starget)
+		scsi_target_unblock(&starget->dev, SDEV_RUNNING);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
