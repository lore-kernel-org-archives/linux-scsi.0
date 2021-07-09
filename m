Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE69C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B03613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhGIUaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:25 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:46065 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:24 -0400
Received: by mail-pj1-f50.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so6706576pjh.4
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YSIhc5oCB+V54Ur2uHMshEx8bD3uhxwrmebNYC304Wg=;
        b=HQnSWpmeA8/jebomI+pEW7baDObOH1rN8XbLZoIJoowbPK4hin6SB68SKK18gEQGOQ
         RK0OZmF1yV2/yw3G5zfGXHXo7yGlr+SWa9AJkUrb49RhyYcpdIPw8TxAfAZcXUmBr9HB
         Sp5+fa01+r+yde8KvDD80iHpfI8Vmn0xVqB8z47wyLyrC6TNKAbdnKQeXq84oMVwRzvW
         VJd1QX2B+up3ANSXUTv2loZxC1YjjQq5MDUxhVSH8nBGe617fNrO+Tus7FoXdkjgQG6Z
         5nCifC2e/DXakIbQsEg5v1Uj2+wBJaoESHj0YAX/n9NIlLVTkqEOJWI2iTFIcLgsfciU
         HWRA==
X-Gm-Message-State: AOAM533m0SBsY2RMvFXcdqEpO10dKPf1micVXb5YOKNUfnPB3mcX+OMn
        XwJ9aKOvVPEJg899wrdcfhY=
X-Google-Smtp-Source: ABdhPJyyJoJMBCSTzCOUSzmI5h0pQkmPZUGCJ2JKs/FIXVYsjWgMuJZcrRmgdEcuksHKhCGjlGSjfg==
X-Received: by 2002:a17:90a:8c87:: with SMTP id b7mr691628pjo.230.1625862460727;
        Fri, 09 Jul 2021 13:27:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:40 -0700 (PDT)
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
Subject: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Date:   Fri,  9 Jul 2021 13:26:32 -0700
Message-Id: <20210709202638.9480-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following unlikely races can be triggered by the completion path
(ufshcd_trc_handler()):
- After the UTRLCNR register has been read from interrupt context and
  before it is cleared, the UFS error handler reads the UTRLCNR register.
  Hold the SCSI host lock until the UTRLCNR register has been cleared to
  prevent that this register is accessed from another CPU before it has
  been cleared.
- After the doorbell register has been read and before outstanding_reqs
  is cleared, the error handler reads the doorbell register. This can also
  result in double completions. Fix this by clearing outstanding_reqs
  before calling ufshcd_transfer_req_compl().

Due to this change ufshcd_trc_handler() no longer updates outstanding_reqs
atomically. Hence protect all other outstanding_reqs changes with the SCSI
host lock.

This patch is a performance improvement because it reduces the number of
atomic operations in the hot path (test_and_clear_bit()).

See also commit a45f937110fa ("scsi: ufs: Optimize host lock on transfer
requests send/compl paths").

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 83a32b71240e..996b95ab74aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2088,6 +2088,7 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
@@ -2096,19 +2097,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
-	if (ufshcd_has_utrlcnr(hba)) {
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	} else {
-		unsigned long flags;
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	__set_bit(task_tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -2890,7 +2884,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
 
 	return err;
@@ -5197,8 +5193,6 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		if (!test_and_clear_bit(index, &hba->outstanding_reqs))
-			continue;
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
@@ -5241,6 +5235,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 {
 	unsigned long completed_reqs;
+	unsigned long flags;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5253,6 +5248,7 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (use_utrlcnr) {
 		completed_reqs = ufshcd_readl(hba,
 					      REG_UTP_TRANSFER_REQ_LIST_COMPL);
@@ -5260,14 +5256,16 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 			ufshcd_writel(hba, completed_reqs,
 				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
 	} else {
-		unsigned long flags;
 		u32 tr_doorbell;
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
 		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
 	}
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
 		ufshcd_transfer_req_compl(hba, completed_reqs);
