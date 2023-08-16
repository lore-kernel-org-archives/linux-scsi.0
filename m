Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3566C25B75
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345958AbjHPTz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345955AbjHPTzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:39 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16381E55;
        Wed, 16 Aug 2023 12:55:39 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6889288a31fso149997b3a.1;
        Wed, 16 Aug 2023 12:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215738; x=1692820538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=02q7BnxcFpL3p2sPDrxUxFMijGfj0ettab/jJOKKOXQ=;
        b=gZaKkaR1SwoEbryrUtxKtNEH7dxHrCvWEIoDp9xG8JN6EqattCLYmELiSUaIaKLeoz
         fQZH+8gJCcIl2cFILhTArh4FXfjG1v0zSA12EWYFr1YOCFjd4Zt2Of7AdtZr9RpgG5m2
         dOisGAmu4wcSt2vk1HdaeTu6jU288SNwSWJj8coC1dz9YzSHQdfX79qUWZjPjtxzkAX/
         N/P/v7KPhEnAc9AVYTeYeLe+s8i7pv6mpEmibPLDdIlqBXwr7dxNZf16FQ2Eu/noixxC
         t4mzT32eK6kxUh7Cacj54sCddkTFbvj/OwfbWssTpPXnvkJB/p0oebxVQzyhlzoyLy5o
         Ziqg==
X-Gm-Message-State: AOJu0Yz30om3jhksG+S+1QytLU/FB+7wATzaigziWMrQWOxOyD5YLK11
        iEyGn1GdqQOttFaKXe0mbR7fOkg06Sw=
X-Google-Smtp-Source: AGHT+IFcbLgVF3ok3DWOjHY4ZizSbxx0CwP13mvUhonSS/IK4bW5HMOmYtv13P+HWANzm7csnjanjA==
X-Received: by 2002:a05:6a00:a14:b0:67f:830f:b809 with SMTP id p20-20020a056a000a1400b0067f830fb809mr750958pfh.3.1692215738470;
        Wed, 16 Aug 2023 12:55:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhe Wang <zhe.wang1@unisoc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v9 13/17] scsi: ufs: sprd: Rework the code for disabling auto-hibernation
Date:   Wed, 16 Aug 2023 12:53:25 -0700
Message-ID: <20230816195447.3703954-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call ufshcd_auto_hibern8_update() instead of writing directly into the
auto-hibernation control register. This patch is part of an effort to
move all auto-hibernation register changes into the UFSHCI driver core.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-sprd.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 2bad75dd6d58..a8e631bb695b 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -180,15 +180,8 @@ static int sprd_ufs_pwr_change_notify(struct ufs_hba *hba,
 static int ufs_sprd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 			    enum ufs_notify_change_status status)
 {
-	unsigned long flags;
-
-	if (status == PRE_CHANGE) {
-		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			spin_lock_irqsave(hba->host->host_lock, flags);
-			ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
-		}
-	}
+	if (status == PRE_CHANGE)
+		ufshcd_auto_hibern8_update(hba, 0);
 
 	return 0;
 }
