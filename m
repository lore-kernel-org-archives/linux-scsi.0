Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D540C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C7F61403
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhGAVP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:58 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:33728 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbhGAVP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:58 -0400
Received: by mail-pj1-f46.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so6562429pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJ6FaxFx0oA6AN+dUX1DBLpUAWG5Zf+YsfdE/KZuwqQ=;
        b=OBMmxmWqIDcWkUx0f5DjDVNIotXtlIhlnnhx/Z4hI2MnMnfmc4u779qrdmQDW/vb/m
         uJFWlHKWOcGjw31cYgjZX6ph13ticHFYmKvtRbR6QhaYxbryybZWPdnx7fB+wK+/vDaf
         ATxaSYSo2GBooJyaLGS8SvQplS9upV6wW/7S+cBY3SHDFEp+AuHK9RA5E33d+zX44wuG
         ezc/AOPmytXiEB/uqTwvmSx4hFYqNQSvdbJJg9Y/8QgLWayH7SlNX4fRDqChc2l/nKGd
         oFvO4Egluk1rNC6F7adsbuZa/D9qwegr3jByalfDxOh2UqiJV7w+C4ItyEe7051TpxEN
         96pw==
X-Gm-Message-State: AOAM5339x6BcC0K4iCo7QbwYQr//YNgGkMx7kozLyOUOFf/ST6IlqwBJ
        eksPDbMg3jOTQVL3lkmE9sU=
X-Google-Smtp-Source: ABdhPJz5moMiYLxBZ/imbLhmNAtYtrYN/mDv8AvNNaYDwLM2O2dgUr/YycFfoliJZCEX8TNJwR9Vng==
X-Received: by 2002:a17:902:b717:b029:11a:fae3:ba7c with SMTP id d23-20020a170902b717b029011afae3ba7cmr1276218pls.28.1625174006444;
        Thu, 01 Jul 2021 14:13:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:25 -0700 (PDT)
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
Subject: [PATCH 13/21] ufs: Remove several wmb() calls
Date:   Thu,  1 Jul 2021 14:12:16 -0700
Message-Id: <20210701211224.17070-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
index 7091798e6245..25ab603acad1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2768,8 +2768,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		ufshcd_release(hba);
 		goto out;
 	}
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 out:
@@ -2879,8 +2877,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
 			msecs_to_jiffies(max_timeout));
 
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
@@ -2955,8 +2951,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
@@ -6514,9 +6508,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
 
-	/* Make sure descriptors are ready before ringing the task doorbell */
-	wmb();
-
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
@@ -6687,8 +6678,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	/* Make sure descriptors are ready before ringing the doorbell */
-	wmb();
 
 	ufshcd_send_command(hba, tag);
 	/*
