Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C11C07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4720F61261
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhGVCy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:57 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38869 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhGVCyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:54 -0400
Received: by mail-pj1-f54.google.com with SMTP id j8-20020a17090aeb08b0290173bac8b9c9so2304247pjz.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0GWws2OAsH1ul1LzZ9S16twx2o4RWhgGMwE8zRCCzU=;
        b=UX87bExEkiIhmc3PDc/6yfFYggVTZs45sDvzMk58AvWMo+FkrZ4Mmth+hphs37usvG
         vWUDwp6UYwrJibXmu337QwSm6IJZ+cBRKFRsh2/rbXakZyENcR2/Zun02HL2oy06xzj3
         K5w7+Ct0NxY3LDEhfoaq+uxuGxKa4AuP645VHWafrTxKoY+lzk1/MyWGowYy/V3SIBgp
         b6R3O2FNNY/zMR0VLTExYXAmG1ug6k2vB03YtBxpe2mM+8WlFMh020/pllMyz2io3dU0
         cR5thBmFclo2og1/umdAi13+r6r7ApUZXlv3e/OAoBItm8+lYK1FCVOSDSOSChNMdnTF
         l44g==
X-Gm-Message-State: AOAM530l4r5mqKi+BLGSra7vpuqN8PBkki+d5ByMHn+yNojVOZAok4wd
        T13Or4todMfogpI9F6H0MJ9xOOdAnvI=
X-Google-Smtp-Source: ABdhPJzCP6iNGiTd0NE/bcC2C6BKQK23G+grtDzq60SRfr+E1SovlhZx21ROcTE29B8uwEu8vB6CEw==
X-Received: by 2002:a17:90a:f40a:: with SMTP id ch10mr6767610pjb.149.1626924930345;
        Wed, 21 Jul 2021 20:35:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:29 -0700 (PDT)
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
Subject: [PATCH v3 09/18] scsi: ufs: Remove several wmb() calls
Date:   Wed, 21 Jul 2021 20:34:30 -0700
Message-Id: <20210722033439.26550-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From arch/arm/include/asm/io.h

  #define __iowmb() wmb()
  [ ... ]
  #define writel(v,c) ({ __iowmb(); writel_relaxed(v,c); })

From Documentation/memory-barriers.txt: "Note that, when using writel(), a
prior wmb() is not needed to guarantee that the cache coherent memory
writes have completed before writing to the MMIO region."

In other words, calling wmb() before writel() is not necessary. Hence
remove the wmb() calls that precede a writel() call. Remove the wmb()
calls that precede a ufshcd_send_command() call since the latter function
uses writel(). Remove the wmb() call from ufshcd_wait_for_dev_cmd()
since the following chain of events guarantees that the CPU will see
up-to-date LRB values:
* UFS controller writes to host memory.
* UFS controller posts completion interrupt after the memory writes from
  the previous step are visible to the CPU.
* complete(hba->dev_cmd.complete) is called from the UFS interrupt handler.
* The wait_for_completion(hba->dev_cmd.complete) call in
  ufshcd_wait_for_dev_cmd() returns.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f467630be7df..d1c3a984d803 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2769,8 +2769,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		ufshcd_release(hba);
 		goto out;
 	}
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 out:
@@ -2880,8 +2878,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
 			msecs_to_jiffies(max_timeout));
 
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
@@ -2960,8 +2956,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
@@ -6521,9 +6515,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
 
-	/* Make sure descriptors are ready before ringing the task doorbell */
-	wmb();
-
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
@@ -6695,8 +6686,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	/*
