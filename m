Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547EFC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF2661357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhGIUaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:11 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:44892 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:11 -0400
Received: by mail-pj1-f41.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so6711010pjo.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SW7VBAvb2dU6HdiGSxml5JEReM1DcbGR+LS+WdnS/4I=;
        b=arZ0220OHKskLevnGUJIVMFTc9JjA1lE6cep2FbInvNiH/Dca3TEk0EKX9O+Baca4V
         BKupXCDXmgwUTjIAyjrvnT1+GXk0QwknxJ5/fJNPM3g02bkG6fGXrDU49H9XCIzvrIib
         UwWHSyjoNOlWlD4Acna4/6rEhQt8ZU6nVEQ2zn2QXw4Vz7WwCIeCdzLkhL322Atw1cvi
         KGKkKsMXb4LkUEHxTjc2Y7IIMx18gu8LAICGHagG9h65S0QZMeAHpdKszSQU0cQDce0s
         UAdP8Mdagz8lqzpxJRoKoY8jC6fKx+0eu/GQElkVnI1fQA7qfpKjloPJqgMnPCRiOu0F
         Zd6g==
X-Gm-Message-State: AOAM531eUITWN78i48T29uOFpm3jI6z+k7gcVBjAcDJ7MaU5qjfMja/1
        /tRpAbpFqbQaA75SAdcVzpg=
X-Google-Smtp-Source: ABdhPJxmdU195P0b1PoAktEODwIooPKQcwKUKLM6N0aNvw81mc86cVlZHVVGmqt06PR022IDA4vbdw==
X-Received: by 2002:a17:90a:ccc:: with SMTP id 12mr39986606pjt.57.1625862447312;
        Fri, 09 Jul 2021 13:27:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:26 -0700 (PDT)
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
Subject: [PATCH v2 09/19] scsi: ufs: Remove several wmb() calls
Date:   Fri,  9 Jul 2021 13:26:28 -0700
Message-Id: <20210709202638.9480-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
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
index 1585eea27200..4bed4791720a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2770,8 +2770,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		ufshcd_release(hba);
 		goto out;
 	}
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 out:
@@ -2881,8 +2879,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
 			msecs_to_jiffies(max_timeout));
 
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
@@ -2958,8 +2954,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
@@ -6517,9 +6511,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
 
-	/* Make sure descriptors are ready before ringing the task doorbell */
-	wmb();
-
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
@@ -6691,8 +6682,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	/*
