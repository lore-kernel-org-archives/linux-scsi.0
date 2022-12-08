Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5A1C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 23:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiLHXor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiLHXoS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 18:44:18 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A51D75BC5
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 15:44:09 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so3157751pjj.4
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2022 15:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1RGrXhiFjjJr40W596rrs0dfZV608Hp/WW+viPhr5I4=;
        b=WQsKP8C06zcmHBej/0e4knU0EIWW5E7M9e9iclNaif1VBmiRlirkQJ/iY1qjNHzIyP
         IrW1PYWysS+/pQ5gYXScNsIFZKrxTAGNbFW3puaY57PUmsjNZal+HyfXRt72YzihO/X6
         guf49w+qDW7Q/7R0bYva4b4Ue9kh0+maBXUsQO9+tH3J443/JjvO/fkSC+a2kc1rQvEi
         ptQ7k0SOWsWrGt4ChjKRVD+eX6Z4yIBBnPyl1XbbTqjdhRFeAsmMPYPLYcObNzQBgIbf
         l0DvW4d2X0dqCRTpdr3okJyigVSZmWy6Z3iUmusezyk60QyVbNucRrSbWxgc9LlrmjKY
         JD5A==
X-Gm-Message-State: ANoB5plx33W3cfX/M8dBPs+2i2FGfUWcUdfkJ71F531k12B9Q9iRJPic
        83wlcxwNFSGJLCATFj9VFR/9t8YEcUA=
X-Google-Smtp-Source: AA0mqf5CWUl1MMe2dI7qrIGSiWx9En4Ib9xfiI04xO6i6gWAckCTBJk+rPf7cAqp7UaRcNauf2uihw==
X-Received: by 2002:a17:90a:7e93:b0:219:6626:3b63 with SMTP id j19-20020a17090a7e9300b0021966263b63mr3795512pjl.25.1670543049211;
        Thu, 08 Dec 2022 15:44:09 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090a2f8f00b00213d28a6dedsm148553pjd.13.2022.12.08.15.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 15:44:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 2/3] scsi: ufs: Pass the clock scaling timeout as an argument
Date:   Thu,  8 Dec 2022 15:43:57 -0800
Message-Id: <20221208234358.252031-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
In-Reply-To: <20221208234358.252031-1-bvanassche@acm.org>
References: <20221208234358.252031-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding an additional ufshcd_clock_scaling_prepare() call
with a different timeout.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b5d9088b7de3..a7d1cf2377e1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1121,6 +1121,12 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 	return pending;
 }
 
+/*
+ * Wait until all pending SCSI commands and TMFs have finished or the timeout
+ * has expired.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
@@ -1225,9 +1231,14 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 	return ret;
 }
 
-static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
+/*
+ * Wait until all pending SCSI commands and TMFs have finished or the timeout
+ * has expired.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
+static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
 	int ret = 0;
 	/*
 	 * make sure that there are no outstanding requests when
@@ -1237,7 +1248,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	down_write(&hba->clk_scaling_lock);
 
 	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1275,7 +1286,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	int ret = 0;
 	bool is_writelock = true;
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
