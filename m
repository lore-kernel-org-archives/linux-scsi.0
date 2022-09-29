Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2DAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiI2WBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiI2WBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:01:01 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0373D153EDE
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:56 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d11so2378180pll.8
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cz1PgeKTn10An2IKf+t7NNHyCEyzuWg32f1pYLRz/Sc=;
        b=3E8oKTa+IHmYBot7kqOTKAx5G8oQQyNbrpQXbvQnRatJQ3q/6F4xcMD4LXMh7cPi6a
         6/YzJ/ZljuxyVALYaaqFpvtSlfon/ScaVHT1m3kMHa9qE6HKl789pkbfw1IANF6UQUvA
         ec/diEE6WA/VqbnhpUpY/sUTrAznE1KKMVc3Px6bSm4gHsCFJuttogyZWMqGvjlLr8dq
         RAJ7GULQomcf4IfauNrl4/GSurGJekEJdA8w2Das6NPgtZUOZLT/lKhDVJPfTYWCaiZq
         GAR6Ai0Y5mtrCayaK6sT2KcyRIdueEVePDm+NJPYD5OCfSJQNtlh1Nf7CfLtIfv+RViq
         7vow==
X-Gm-Message-State: ACrzQf3nWZ2irx4Il0NpbyGw8G0rh17DvfVuh9yUW7cEbAq6X+fvcO/l
        mhAcBrKq4hRRIg2lO1eo5BM=
X-Google-Smtp-Source: AMsMyM7GJ3MRuBYgHdjbM6Z8Y0x3wH+bf98bvcHAgYn8vb4vAzj0NGOj5LZ+gLKmHB4G8ve0f2hLzw==
X-Received: by 2002:a17:90b:1d02:b0:203:2d73:8efb with SMTP id on2-20020a17090b1d0200b002032d738efbmr18256653pjb.214.1664488855335;
        Thu, 29 Sep 2022 15:00:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:00:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 4/8] scsi: ufs: Remove an outdated comment
Date:   Thu, 29 Sep 2022 15:00:17 -0700
Message-Id: <20220929220021.247097-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
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
