Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E7C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB3160FF4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGVCzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:14 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:35429 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhGVCzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:13 -0400
Received: by mail-pj1-f47.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so2338646pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mqHs5wcg4/QnNX8m2Rw7La34Iw3FyLv4uEJaEfD1Elc=;
        b=kh1WghsPDq/WYIA0G4z3LU6KHYmmQ3bK1dYkCerFr0oRZWUjuRVVZq8pHO/ub3Q5BQ
         wz0IZuJOsfmBsRNAGTdVBwF7CPMnxEqcGxeTDQmOP8nCfuQLNMkS4wIzdkiAwm3tkyrW
         4ZJ850Owe5VVvSf8/55giclYipFTy+TBDQwAyLF3Mo4/wYa7AZZ2bXxj/cCCurC5ozHP
         l7h0RBh2FD6vIHVMEEetSxFtOvasc0Ggy+L5JYxH8wQ5tJmQ3h9K4Ax6cstlfyza6ZUx
         WzjHDnpTdsxl5t6Ip+BsNLJgTkIo8NlvorCDgjrupuwwUQIi7QRlyUaIXNA9FnJBCiAI
         t5rA==
X-Gm-Message-State: AOAM531NJ2V2Q/TzxBsLJduJAUtpUt9aUoVQrvHBptTdjFej9w+/Ci7Q
        +wzNiCw6FYbOGZorzl8iReE=
X-Google-Smtp-Source: ABdhPJxE94HoLKzY61495ALEo5a3005DEVJLoTrhDYjShQm3p8SAOJi5Qghtgqtut5bOFxHTmX8yew==
X-Received: by 2002:a65:4307:: with SMTP id j7mr38587503pgq.387.1626924948359;
        Wed, 21 Jul 2021 20:35:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 13/18] scsi: ufs: Optimize SCSI command processing
Date:   Wed, 21 Jul 2021 20:34:34 -0700
Message-Id: <20210722033439.26550-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use a spinlock to protect hba->outstanding_reqs instead of using atomic
operations to update this member variable.

This patch is a performance improvement because it reduces the number of
atomic operations in the hot path (test_and_clear_bit()) and because it
reduces the lock contention on the SCSI host lock. On my test setup this
patch improves IOPS by about 1%.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 29 ++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 436d814f4c1e..a3ad83a3bae0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2095,12 +2095,14 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	if (hba->vops && hba->vops->setup_xfer_req)
 		hba->vops->setup_xfer_req(hba, task_tag, !!lrbp->cmd);
-	set_bit(task_tag, &hba->outstanding_reqs);
+	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -2882,7 +2884,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_lock_irqsave(&hba->outstanding_lock, flags);
+		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 	}
 
 	return err;
@@ -5194,8 +5198,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		if (!test_and_clear_bit(index, &hba->outstanding_reqs))
-			continue;
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
@@ -5250,10 +5252,14 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs) {
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -9340,10 +9346,11 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
-	*hba_handle = hba;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
-
 	INIT_LIST_HEAD(&hba->clk_list_head);
+	spin_lock_init(&hba->outstanding_lock);
+
+	*hba_handle = hba;
 
 out_error:
 	return err;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6df847facd1d..91b0b278469d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -695,6 +695,7 @@ struct ufs_hba_monitor {
  * @lrb: local reference block
  * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_lock: Protects @outstanding_reqs.
  * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
@@ -781,6 +782,7 @@ struct ufs_hba {
 	struct ufshcd_lrb *lrb;
 
 	unsigned long outstanding_tasks;
+	spinlock_t outstanding_lock;
 	unsigned long outstanding_reqs;
 
 	u32 capabilities;
