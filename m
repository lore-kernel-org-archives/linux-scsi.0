Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF121C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiKVW0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiKVW0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:26:46 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5076579E2B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:46 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id b185so15663345pfb.9
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oRrbQSGdvYUcE4BuW28QJ3skyWFt/5TBa/Fr/nBLjMg=;
        b=wyaV3uxI6VusQzNSnfhkaJ0nnN5G8vYYylbMXJ2W0+SE7I/zB42lQqPcppvKHfH565
         krM1VAq2ChykOJLWPEzI0jWAOyb1sKpF5drCp7NyCxVdhOBuHiiodaoexVKE7SjfFQjI
         OLvIb+1OIRaiUYB4VXQyx2PxabQFSIzgyC3SY0BuZpgSjJ7N5xfJuVRCkJsAN4/6l+Ja
         jQWDiTQxvpWyxzh5c5cKw7d/u/V/6XufebR+jW10SOMfR5TzaRy4jOb2rocKaY70rfXW
         3pmHlJO0CWi+tba4zrVgUUd0e7UlvnFAe+mM/m3FbRrenNnPNh0k4YwAPwMfZnhZq5Hj
         eFBQ==
X-Gm-Message-State: ANoB5pkEPxUULwWrL4Vc1kkxyWL4tiBTOqo1lhYUNkksi4LVH7mYyH3W
        nendPU38frDt2gl51/hT89Y=
X-Google-Smtp-Source: AA0mqf5SXA0lr6A2wxDZaVJfn/xMb1cC3ao2aSJI8QK4BS47Rt2NslIKfXnDacTGg4sO06BK3GqNzw==
X-Received: by 2002:a62:1a8b:0:b0:572:7c58:540 with SMTP id a133-20020a621a8b000000b005727c580540mr7246726pfa.69.1669156005725;
        Tue, 22 Nov 2022 14:26:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00172973d3cd9sm12539551plb.55.2022.11.22.14.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:26:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 2/5] scsi: ufs: Move a clock scaling check
Date:   Tue, 22 Nov 2022 14:26:14 -0800
Message-Id: <20221122222617.3449081-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221122222617.3449081-1-bvanassche@acm.org>
References: <20221122222617.3449081-1-bvanassche@acm.org>
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
