Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5CEC11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2393561403
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhGAVQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:13 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36670 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhGAVQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:13 -0400
Received: by mail-pj1-f42.google.com with SMTP id 67-20020a17090a0fc9b02901725ed49016so1866416pjz.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tAb3tX7zzWO04y6o6jDI253i/hUt1xi+4u/RiYn0rQY=;
        b=I9xQNuz3nEqN994Z4BQvALzjnXm/UbZuXZdYXCuqfCkFFaobJsNjFccabzmMLcM54b
         JNmoYKaSLNPNK9HaiLLzOxpa3su0HPTTwSp81n8aqNT9sr4lhF84pLj99UWaqOwAxWBL
         1lGVv0PsYjGgCJ/Qe4AjARzI+F1J2fGuGUeEF7IhlStTCjRL41CtuzvuLW+jT2ap7vU0
         N9yqCoeMlFwhrxFeBZGiac0hOdejRbNQqj4yLwfbgzgW450Tup/9XbJDwxRRGpRHFDgZ
         L66iuyOfGOEo3t2EVZ/REuWpT3FZYryuPXa4xC6IwVSZQM3gH5s0T+mwN1CNlC4+mJ5Q
         njQg==
X-Gm-Message-State: AOAM530FZcl3B0rYv97GGyUKDA1OuBMBR9xGW8kwbiXFxtQJPj+FEBsF
        4zAvyoPZedeZElxrW4n2rX8=
X-Google-Smtp-Source: ABdhPJzM7zFp+mROPjziPmQXZdb5KIOG+03J93snIvt5ELYvLiJsI3zy5XrFf9THCHoqV9emfizNZQ==
X-Received: by 2002:a17:90a:7884:: with SMTP id x4mr11482712pjk.53.1625174022038;
        Thu, 01 Jul 2021 14:13:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:41 -0700 (PDT)
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
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 17/21] ufs: Fix a race in the completion path
Date:   Thu,  1 Jul 2021 14:12:20 -0700
Message-Id: <20210701211224.17070-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 47 +++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aa23fe6f5ddd..71db56c72af6 100644
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
@@ -2879,7 +2873,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
 
 	return err;
@@ -5179,8 +5175,6 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		if (!test_and_clear_bit(index, &hba->outstanding_reqs))
-			continue;
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
@@ -5223,6 +5217,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 {
 	unsigned long completed_reqs = 0;
+	unsigned long flags;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5235,24 +5230,24 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (use_utrlcnr) {
-		u32 utrlcnr;
-
-		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
-		if (utrlcnr) {
-			ufshcd_writel(hba, utrlcnr,
+		completed_reqs = ufshcd_readl(hba,
+					      REG_UTP_TRANSFER_REQ_LIST_COMPL);
+		if (completed_reqs)
+			ufshcd_writel(hba, completed_reqs,
 				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
-			completed_reqs = utrlcnr;
-		}
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
