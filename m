Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170A2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiKVW07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbiKVW0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:26:55 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C387818D
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:55 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id r18so15204172pgr.12
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHCnAXPPmp2IpgajiXHrcVTx/+rpqECCL4FFj/zhSbc=;
        b=cGZ8D+5HPftkgB01Hnu6ltfW9DdUDmIkmANIqp6uQa+dTR/WmjBgUYdgyhEWd/4bXV
         F7iLFes+8DDrP1d9kAOuF9Bfjcjja63H/5mcXzmJeetT3OzHhQYFqb0Em97N5VPCzP5H
         o+OIcJ0E8dv6Pb3aYweyHvJCrKru0I2Omh6SwHxyMz70zkTcdmOBvuNlVhyUK26PIqWj
         4TVgMCuIbxNMRJLrlZVhfff/teFVVn3/qPCPChcWQQRoxBg+c+GgATFyrWxjsQIIDp6x
         CqJlThCuVfhIKpMJWAkAlWD/ZMpVtPWTXfZAan6MtYpLLDq4f0XeYw8PJXgiEbhzht6Z
         N2yw==
X-Gm-Message-State: ANoB5plhH6OpVT/fxYKNZLrCJCXwuIFV5nSwHanvbGe0YNaQngecJbkZ
        yiY0XH5wx2g7UodEJ6tpCyA=
X-Google-Smtp-Source: AA0mqf6vSiSKRQ6m//wYelIy/B7XGxEWt5PIhGPl26OV8pKPFCfk2VP0PW5KUy1aaU7J1jbBdIZOoQ==
X-Received: by 2002:a63:580a:0:b0:477:12e3:6e1c with SMTP id m10-20020a63580a000000b0047712e36e1cmr8235362pgb.126.1669156014600;
        Tue, 22 Nov 2022 14:26:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00172973d3cd9sm12539551plb.55.2022.11.22.14.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:26:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 3/5] scsi: ufs: Pass the clock scaling timeout as an argument
Date:   Tue, 22 Nov 2022 14:26:15 -0800
Message-Id: <20221122222617.3449081-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221122222617.3449081-1-bvanassche@acm.org>
References: <20221122222617.3449081-1-bvanassche@acm.org>
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
index 195261e3521c..7b2948592c4a 100644
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
@@ -1236,7 +1247,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1277,7 +1288,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	if (!hba->clk_scaling.is_allowed)
 		return -EBUSY;
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
