Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A86C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiD0Xml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiD0Xmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 19:42:39 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BEB5F266
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:26 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso2937210pjj.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0scTl9jILL9mKGSNSrFA00jf2Zsqg7JYqUtzIar3uhc=;
        b=AhtZGqqJ0i1gfyVtSqRInVjK5JOM5Ui7HYp9CXzZDbbL1ZKBoEDwZDlX4ZTKWlPFqR
         nuIPXvFPFD2LzNq9v4funEJC1i4x9kF5PbzzvTq0aD+fJ4gdEDOTvQtEXiVQ0TKrlfgQ
         Db4MXaroeKfaTyW1pPtv+TB3JO/nrZcndc8V58QBXyX5Y2Tkl69FU2pwSMV4BpnFBezR
         qfz1VM3NGaH9FJpA8PlChNcKcbIMvxQgIlBBDsepTmBYo7J+znGM3nnv6nT1UoRb0FiO
         p3297SScQavt/1XENhUha+g4tbpG2F2c7Z9jyVSpm1sRPGYIEk+dmPLXetpnoj5Iva3u
         qBNw==
X-Gm-Message-State: AOAM533uLp1tSiRFimM4WMj/vCDWEpG5O9lj7NVKPNIHObpRIQKsfmoW
        k25jVvH00xDpNf7spJ2SZl8=
X-Google-Smtp-Source: ABdhPJwjDUsTRS6LlVw/t3Ryk8iKrtT4T6gPrkRe0il7JKLP967/1j4dBAF1T1I57dEKpwlLQzBtLQ==
X-Received: by 2002:a17:90a:a82:b0:1da:3763:5cf5 with SMTP id 2-20020a17090a0a8200b001da37635cf5mr6381918pjw.55.1651102766387;
        Wed, 27 Apr 2022 16:39:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19817580pfd.198.2022.04.27.16.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:39:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/4] scsi: ufs: Move a clock scaling check
Date:   Wed, 27 Apr 2022 16:38:53 -0700
Message-Id: <20220427233855.2685505-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220427233855.2685505-1-bvanassche@acm.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move a check related to clock scaling into ufshcd_devfreq_scale(). This
patch prepares for adding a second ufshcd_clock_scaling_prepare()
caller.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a3fecbb403d3..3c83f4049031 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1223,8 +1223,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1262,10 +1261,18 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
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
