Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7AAC6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiI0SoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiI0SoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:44:06 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640071C4832
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:59 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id c7so10157184pgt.11
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cz1PgeKTn10An2IKf+t7NNHyCEyzuWg32f1pYLRz/Sc=;
        b=SzzaxDpASbBxFLBBgA2GM5czdTzXmLaDttWnNzpBEOmbxYLtqmvw8tUmMLUYQgklow
         PmqgpTWwToR2fWFEvuqqT54hWgiW2+ZZyPG0jKtDfsVPlNOSRW91begCD5i+Uo2Pe+7x
         RfvqftQdLYcNgHa0l7nXisU3VRBJp9DfwNDRBP10Vji8H0C1ZFHmtQ4yYwZYmEUn4Tac
         ViP3GKu5nn9ihFdJVt4I7ITGCRIz0JJu6f31a+71t12PUDqgMxEa//19KenjYV02EhD4
         8/HFlSS8m6FlClxzrTg5HASWiqnTSwcR9OwlnRIHvWsvrmBB/u23GBx/PKNQGrtekNaC
         6QJA==
X-Gm-Message-State: ACrzQf3d4OF4ST+L/iH7QvsAdQyYlBYJcYcXjCOBzD+G6pV+9jhWKsQX
        jC0+6Of5JV6OwQbCZyv/LrrOHMPajR4=
X-Google-Smtp-Source: AMsMyM4algH1iknfZ6qScTMextg8A6rWYMk/M9DD/Nz6YXb5kpLERjY4MIxEdXBFnEhhyeu7Mm+ZIQ==
X-Received: by 2002:a63:8348:0:b0:43c:bcba:d638 with SMTP id h69-20020a638348000000b0043cbcbad638mr8653170pge.408.1664304238815;
        Tue, 27 Sep 2022 11:43:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:43:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 4/8] scsi: ufs: Remove an outdated comment
Date:   Tue, 27 Sep 2022 11:43:05 -0700
Message-Id: <20220927184309.2223322-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although the host lock had to be held by ufshcd_clk_scaling_start_busy()
callers when that function was introduced, that is no longer the case
today. Hence remove the comment that claims that callers of this function
must hold the host lock.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c15cbc737b4..78c980585dc3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2013,7 +2013,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
-/* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
