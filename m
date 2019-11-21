Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B564C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C714206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKUWJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:09:09 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36560 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUWJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 17:09:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id k13so2349244pgh.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2019 14:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt4GcjOHOtoC4ADd8ONUS4TgX1zNZY6qc9ogwMUSNYA=;
        b=N5rnFxboN2pgG4/Fgrva44Ci3HZyR2Z4xEBeA6t2zwl3kdeghokQIExZVlMUgStm6Y
         cLh+wofTuPxOoKniP4NaDyF07PUVHKEiQVCjUUkU8tqOONSpbs0SICl4FnNcbcGTmDQk
         nSpkY6drufb4nBwOkDCsnvUt8v7RHMpaOR286+p1M4C+5+EmwVLK1RLkdP2BuKoPQ0Vh
         nkASUe6MzYviaYvnOgPOFkkTu3UaVMl0jNedAwFcZK1Afu+f8Gby4eixKA7GjJE8ayAq
         rRgbPx8vrY6Q5iumYhaxpZmQxZGcPOGzb6MZLe7gTGwhpz1az++TrshZYRQ5W6+I/e6g
         5FyQ==
X-Gm-Message-State: APjAAAXrMpIdcIcpvzB3BUi5fVVEJkyh4oSrqxJNZHF7GRZggD9BSetJ
        ukLgginN3sg13Bs37z5HEF8=
X-Google-Smtp-Source: APXvYqy/vXQebWe7r/ZqYLUGvQ5dGwYOvVv9CduWoRIUa2d10ovgn/qGxnjLydNzVQ9p9JEzM2BYgg==
X-Received: by 2002:a62:ce4b:: with SMTP id y72mr13974404pfg.9.1574374148046;
        Thu, 21 Nov 2019 14:09:08 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m15sm4617714pfh.19.2019.11.21.14.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 14:09:07 -0800 (PST)
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
Subject: [PATCH v6 1/4] ufs: Serialize error handling and command submission
Date:   Thu, 21 Nov 2019 14:08:47 -0800
Message-Id: <20191121220850.16195-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <20191121220850.16195-1-bvanassche@acm.org>
References: <20191121220850.16195-1-bvanassche@acm.org>
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
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Fixes: d5038a13eca7 ("scsi: core: switch to scsi-mq by default")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b5966faf3e98..deca1538e184 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5306,6 +5306,8 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
 	unsigned long flags;
 	u32 err_xfer = 0;
 	u32 err_tm = 0;
@@ -5314,10 +5316,19 @@ static void ufshcd_err_handler(struct work_struct *work)
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
@@ -5426,6 +5437,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (starget)
+		scsi_target_unblock(&starget->dev, SDEV_RUNNING);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
