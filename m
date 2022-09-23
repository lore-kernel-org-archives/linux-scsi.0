Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFD1C04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiIWUM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiIWUMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:12:19 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27FA1319BA
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:11 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so1205808pjh.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cz1PgeKTn10An2IKf+t7NNHyCEyzuWg32f1pYLRz/Sc=;
        b=uy7uo+Ks8zw/7iNBdHp+8++EoZ6r+WmDV4RFiKR4jgqhxqC29zKoOBURIMLXl1yw7J
         p1i7Kjf+ndvCktNceoeqHki2kGdQgSc1Q9aAWhgDydWo/UIwc+LHcSbtv1hQJEciGArT
         hoNN4yT5lsDSXqRxClRpKGsD14W5/hATdpdM5+9GaAgVMUPlW/8jmlMRlh6PpsZ8QgaG
         jy3veiJpNaxfRb1cG6YdBkf+PUGgaXSI342n8iqIPpZMOfVGzuxGMmiyMaF78ctV1HT6
         vLayf8ZqpM8LLPquALL5knUUPniR//Aon91xcxT0wIcY2zhlAqyYiALUhXnYG0/SoWtO
         952Q==
X-Gm-Message-State: ACrzQf36gDgZDoxJt29gkVI+AKiVXyb8o7vV+cHAppvER76TiQpAoWiu
        C7Qm8UHg0CwLASIOjwxVhTX7BScoVzE=
X-Google-Smtp-Source: AMsMyM524L4b9s1ci7830Fc7aHz9T2Xi3f65uwd6P9hrPIX2O8PR/rzpYWWxzQjK8sKcxGaI2X9c1Q==
X-Received: by 2002:a17:90b:4c45:b0:202:6308:d9c4 with SMTP id np5-20020a17090b4c4500b002026308d9c4mr11390983pjb.40.1663963930472;
        Fri, 23 Sep 2022 13:12:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:12:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 3/8] scsi: ufs: Remove an outdated comment
Date:   Fri, 23 Sep 2022 13:11:33 -0700
Message-Id: <20220923201138.2113123-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
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
