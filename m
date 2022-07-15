Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EA9C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 21:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiGOVZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGOVZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 17:25:49 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1D243E69
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:48 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id f65so5452150pgc.12
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lxWAv2EChn51hExylSSAviLP25c6GTSyIQ0V215GCTI=;
        b=t0dqb2oCgp3oALk7jGNbk5pM1TzUmqvSnWrW0ie+Sc0dQ6qp6wObtXUnzg0oBZvWys
         /wYfg+KdRgI0IoODAPZjn4BrrXope5S55jdyHLp79qFJqP4EAY+A1UQu8tlDffuQRPh7
         u/RHDxMq7LoVCBxhm/NpWAtvKc8IR+OL7I60ddXI8bFvXm/6H38dwtqsO4PSsaVRLyLJ
         rt3sukmuWypxR3kj+t02mVGPAAb9OdnxC2nupfJORcgYh18fNMZDw+7Qo5Yn0hsTUqMN
         25HSai8pfxyvvjGOihX5MPANLGz1+3R9Z7ey9IipaklV4bFmVyqQkRhu2Ypgp40PC32L
         5+DA==
X-Gm-Message-State: AJIora/Q+5Dd/DLX8WpAbCuvAKq8muOt++Y8gP+sa1Ebh2+O5L0Zni46
        vvw/SYRYlN89eSMf986wnAw=
X-Google-Smtp-Source: AGRyM1veT+Xq6KZ4nF4u25m6a9wyM0p7KPf3jSd3k+MtpO0wjiJ34pDBr0QxSLcwZ7xlGw4A9t2U7A==
X-Received: by 2002:a63:4e09:0:b0:412:1ba3:672a with SMTP id c9-20020a634e09000000b004121ba3672amr14188930pgb.597.1657920348359;
        Fri, 15 Jul 2022 14:25:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id e35-20020a630f23000000b0040c40b022fbsm3535944pgl.94.2022.07.15.14.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 14:25:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/5] scsi: ufs: Move a clock scaling check
Date:   Fri, 15 Jul 2022 14:25:12 -0700
Message-Id: <20220715212515.347664-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715212515.347664-1-bvanassche@acm.org>
References: <20220715212515.347664-1-bvanassche@acm.org>
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
index a51644bcfbb7..f7af5cd3124e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1231,8 +1231,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1270,10 +1269,18 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
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
