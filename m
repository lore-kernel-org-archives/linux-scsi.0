Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953B8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbhK3XiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:12 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:43544 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbhK3XiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:38:10 -0500
Received: by mail-pf1-f172.google.com with SMTP id n85so22242928pfd.10
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qr0lteHE2MHHWadRe8v5OkBA+Kt4SnjvEPdPF2o6ReY=;
        b=y7rrYt85cnnv8K3d7LAjIabSe0VcuULD/vzwx6ByQizApgkuFJ6Msav+cZUgw35GFS
         QsNrsVjyKqWSF2WSx58iuYjg/NoK5wz/rF0fs0cPNnamF2jkkOvBGWGdltL3tgq9RXKg
         bK763TWdqBhTtu3YlPKASXhvoftkebfP1KmThRmB2aikPGUJIJPq4oHcJqt80O5Y4e5J
         JrslJMmivgVvWbzhz1U1YjKzNxKIUc2sqTphK2vZAmqwd2vs5XTrOozBxtjuADUBv+tJ
         5MYn/fixQUBT/9dsepxClrtJ6jtZLwuEcqQ/vTM866r6ud3wBhVcj9153IWUSc3z1xng
         izAg==
X-Gm-Message-State: AOAM532RozMAoDpThrpx3KZ7H2TKy9mlFGZ+dnXRF2QxijKM9tVU09N7
        CBespsRLfby+pUXs/1k2olk=
X-Google-Smtp-Source: ABdhPJzQeT9WoAnm93cDSeUg0dmSVBUWTCFS6HYD/wt7cNfMYpSnndb/CT7+0hfYZP5M0Kw8l1PrLQ==
X-Received: by 2002:aa7:9586:0:b0:4a2:78b4:a402 with SMTP id z6-20020aa79586000000b004a278b4a402mr2534069pfj.21.1638315290000;
        Tue, 30 Nov 2021 15:34:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 14/17] scsi: ufs: Fix a kernel crash during shutdown
Date:   Tue, 30 Nov 2021 15:33:21 -0800
Message-Id: <20211130233324.1402448-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
index 1a4f2ebf955e..074ea9ae54e0 100644
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
