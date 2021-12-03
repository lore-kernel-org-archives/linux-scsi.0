Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE87BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383441AbhLCXY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:57 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44012 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383434AbhLCXY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:57 -0500
Received: by mail-pj1-f51.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso3741451pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5dKjNMEoD+YYSnRcW9rBk3RuQnWvccJRl67nvbgmks=;
        b=NMdrrqbkOhe1CpIkfbXSPqoUQZpxhX/5Bu31LZNYr+IbChVaV4E5sj8+8U52bTX0Tk
         sVpw4A+hpWC48z3Ur7rvR23D5oGrlGr7sGOaktEZ7+duEkAQIDq2W1/WD3nQyftPzonR
         CPITJ/zlDfvZJeym4hXaN6fqCMZ++0nQqYxxHHRpg6ApPl+2E/GyJ+RRa11FbVrIaHmh
         7m8ze9AJd03OJ9G4M6iL56rY+IeclA9cbIupGxYBWGC9KgOo8TjZtVVoG2aynEngrbjq
         tenlU9kLzgyNhHKR4dKd4Va+84rXMVtueBnxliRe2/7V7uFTEmnn/xJDqgPBuAXaxE4P
         Hn9Q==
X-Gm-Message-State: AOAM533Q9jnRr4g1r4CgkL5ruCaA1pqh14CBl8/XFFFxUewVZ74rQcST
        1sQvIJHpOWnAKnBUQ0BfGzo=
X-Google-Smtp-Source: ABdhPJxeUO80l+ENYdDAEAOhhPH2IES1DO/fa02XhHriRqgCXfwyoHEbYPGeoLiHQLuzoUi6Lnq0GQ==
X-Received: by 2002:a17:90b:4c8b:: with SMTP id my11mr18042521pjb.96.1638573692270;
        Fri, 03 Dec 2021 15:21:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 14/17] scsi: ufs: Fix a kernel crash during shutdown
Date:   Fri,  3 Dec 2021 15:19:47 -0800
Message-Id: <20211203231950.193369-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 06954a6e9d5d..d434d76aa657 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1648,7 +1648,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	bool flush_result;
 	unsigned long flags;
 
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!ufshcd_is_clkgating_allowed(hba) ||
+	    !hba->clk_gating.is_initialized)
 		goto out;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
@@ -1808,7 +1809,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks ||
+	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
 	    hba->active_uic_cmd || hba->uic_async_done ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
@@ -1943,11 +1944,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
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
