Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BB8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8921A61184
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKJAsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:31 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:39498 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJAsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:30 -0500
Received: by mail-pl1-f169.google.com with SMTP id t21so1570464plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8OTrU3GYFu3CL1REgFDh5Hbm8EDgLqeuKAhDQBFGAlg=;
        b=V5zBxGJa3BCnLnDmNpjdp2lo+DwC5LYNBxaHu+yGeyg6PS8nGfqtawrjfi6iTFJcf0
         qRUM8IcaFyaD/psCD97IJ0D2P9zTzz/wKTPUofLuBogUezqZ0t6yYa7vdNhLyEsDfpD5
         KUK4N7L/9qs9m97GKI+cFJgfHuEO88/7byVJ1QCsa56eFwVrtP0Q3ACxWXNYOSpxakIn
         kcm94ZSngJU8ZD/sEfetbwFfuuBvz7aLyFVZ5tqFMmoTAN+MNCenSxtvvFROI4ufb57b
         WUTQzWk0IgvVLSxillQxbLXCTbJfdl6/IIzPPhoTunVaYVaw5oM3qzQCFi9PezxK+4g9
         Bfcw==
X-Gm-Message-State: AOAM533FsYnAp5TL9f1WbDZv4YrI045bS3sNCBjwYCqP2uWm1LrJn2Jr
        zz5IRLIdq2dm8BciaY5QbZA=
X-Google-Smtp-Source: ABdhPJxNUtCMwwPH0g400aI1MxFryurjCF9pzxgO+ctxtxCy+J/yVxyHQvrObDMV4H4MqaYTIHghFg==
X-Received: by 2002:a17:902:c404:b0:142:28c5:5416 with SMTP id k4-20020a170902c40400b0014228c55416mr11989508plk.62.1636505143330;
        Tue, 09 Nov 2021 16:45:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 09/11] scsi: ufs: Fix a kernel crash during shutdown
Date:   Tue,  9 Nov 2021 16:44:38 -0800
Message-Id: <20211110004440.3389311-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel crash:

Unable to handle kernel paging request at virtual address ffffffc91e735000
Call trace:
 __queue_work+0x26c/0x624
 queue_work_on+0x6c/0xf0
 ufshcd_hold+0x12c/0x210
 __ufshcd_wl_suspend+0xc0/0x400
 ufshcd_wl_shutdown+0xb8/0xcc
 device_shutdown+0x184/0x224
 kernel_restart+0x4c/0x124
 __arm64_sys_reboot+0x194/0x264
 el0_svc_common+0xc8/0x1d4
 do_el0_svc+0x30/0x8c
 el0_svc+0x20/0x30
 el0_sync_handler+0x84/0xe4
 el0_sync+0x1bc/0x1c0

Fix this crash by ungating the clock before destroying the work queue
on which clock gating work is queued.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1e15ed1f639f..13848e93cda8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1666,7 +1666,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	bool flush_result;
 	unsigned long flags;
 
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!ufshcd_is_clkgating_allowed(hba) ||
+	    !hba->clk_gating.is_initialized)
 		goto out;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
@@ -1826,7 +1827,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks ||
+	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
 	    hba->active_uic_cmd || hba->uic_async_done ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
@@ -1961,11 +1962,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
 	if (!hba->clk_gating.is_initialized)
 		return;
+
 	ufshcd_remove_clk_gating_sysfs(hba);
-	cancel_work_sync(&hba->clk_gating.ungate_work);
-	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
-	destroy_workqueue(hba->clk_gating.clk_gating_workq);
+
+	/* Ungate the clock if necessary. */
+	ufshcd_hold(hba, false);
 	hba->clk_gating.is_initialized = false;
+	ufshcd_release(hba);
+
+	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
 /* Must be called with host lock acquired */
