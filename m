Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15303C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiKHXeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiKHXeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:34:07 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F6A205D1
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:34:07 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so309311pjl.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oRrbQSGdvYUcE4BuW28QJ3skyWFt/5TBa/Fr/nBLjMg=;
        b=WkUsg2gcARjj+dgwxyMNaXbBEWSB1bTPHRe+TuF8SqIMypO9/azSXjFAT5ZUYI/f7/
         nFL+cpf74X/Aga/yaA2LRFHCvkwfe9FItviC9zEdS8c1s+ZwOOQnlT5whWm0Ygt0eGPU
         gtsHOpZ6NUqqsiiaB//4J5j7+rQ/LOMyb2/oXV12Bcybncqt73aOvjKhi5317pNh8BpA
         v4LAt62J+yuTw8+qwOC++at923LZlaAQ2Ea7jEEJhZblb3oO69IRa0N9Oq64xF+zoMDK
         AiZiW4nsaoJl1WZyc8esZZMWDeF7UJf2K8/ieTwOhJcbkYpdT59/eWUiQ7Z/IEKFf1OC
         FcoQ==
X-Gm-Message-State: ACrzQf0QanjmwSGJlnpO06SqHyjQN/9WgtCz/j/NRvfTyu9QmmZOkdUg
        cTMUWN+snXDzUK4gxhJvx3dUZTCbjQQ=
X-Google-Smtp-Source: AMsMyM41lL043ViUa8+71nKGJQML+BlPKXn62DKLI4vqd4W9KHfDPs0AYQ0RHRqIfwJ44rz01pp4hw==
X-Received: by 2002:a17:902:7786:b0:178:48c0:a083 with SMTP id o6-20020a170902778600b0017848c0a083mr58940805pll.125.1667950446402;
        Tue, 08 Nov 2022 15:34:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:34:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 2/5] scsi: ufs: Move a clock scaling check
Date:   Tue,  8 Nov 2022 15:33:36 -0800
Message-Id: <20221108233339.412808-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221108233339.412808-1-bvanassche@acm.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move a check related to clock scaling into ufshcd_devfreq_scale(). This
patch prepares for adding a second ufshcd_clock_scaling_prepare()
caller in a function not related to clock scaling.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 81c20e315dba..195261e3521c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1236,8 +1236,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1275,10 +1274,18 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	int ret = 0;
 	bool is_writelock = true;
 
+	if (!hba->clk_scaling.is_allowed)
+		return -EBUSY;
+
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
 		return ret;
 
+	if (!hba->clk_scaling.is_allowed) {
+		ret = -EBUSY;
+		goto out_unprepare;
+	}
+
 	/* scale down the gear before scaling down clocks */
 	if (!scale_up) {
 		ret = ufshcd_scale_gear(hba, false);
