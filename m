Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BD4C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJRUbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJRUbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:31:01 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26B1BBE26
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:51 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id f193so14356656pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gva4In/fI1SGCtfYkg1KFz1ttrzFT+ngch9UhJe9hYQ=;
        b=3FTtfFkd390lBFRyiCEXc5jlwoMngn8yFpQoWTFkRYGaO8bFXAtgvpoDIxz69t3UPV
         Jgdg/y7NxZjs7c0thRS+x1Ow8AE7IEd7HMFs5Jg41qLMbAq4EjxFs7i8rYH3IM3JD4JA
         q/1h1hgYHDP7KD/s1Ys8rE5fWYcRFs8sDY0CX6D5bmXTI2B/LNoQvwqE49tvK+96Gsc0
         SF6tevKiylxDBbR3lglRP3FpEI9yhcNjG7SWWMviBn2lU/DvjDYcGjaSdfhvoNOgU0ay
         dHCJUcci2L/w5Gs7K6u53Il4oO78kIP+TeuF9/AoViCJ50uAloxAYNyb8VPyX31SvDtD
         wUwQ==
X-Gm-Message-State: ACrzQf01k8ck0sUOSeSmCeqq312QxtqTHh0QXtaV8lmXpFG2xcG557p7
        xvPxMPZBZWVPRy0yXSFhIIs=
X-Google-Smtp-Source: AMsMyM5u0BQnR1DHfusduiBgJa4Hu+D4AQ3+07Pf8xDxuIy42gxgkWs4xEYmEL1lkJhfYcdDpz2qrA==
X-Received: by 2002:a62:3206:0:b0:562:524a:ed55 with SMTP id y6-20020a623206000000b00562524aed55mr5133338pfy.0.1666125051334;
        Tue, 18 Oct 2022 13:30:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 06/10] scsi: ufs: Reduce the START STOP UNIT timeout
Date:   Tue, 18 Oct 2022 13:29:54 -0700
Message-Id: <20221018202958.1902564-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce the START STOP UNIT command timeout to one second since on Android
devices a kernel panic is triggered if an attempt to suspend the system
takes more than 20 seconds. One second should be enough for the START
STOP UNIT command since this command completes in less than a millisecond
for the UFS devices I have access to.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index db1997e99da2..f83a0045a129 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8746,8 +8746,6 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
-	unsigned long deadline;
-	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -8775,14 +8773,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
-		ret = -ETIMEDOUT;
-		remaining = deadline - jiffies;
-		if (remaining <= 0)
-			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+				   HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
