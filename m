Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215FCC77B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjEDXvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjEDXvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:20 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBF713291
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:19 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1aaea3909d1so10238205ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244279; x=1685836279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6DQ9zd8GvGmSw/78qAuY9Lsrz4TpocdRjZ2BdVTCWGg=;
        b=YXwu1CMnAbat4cdf3tCpkHRHW7r2XoA+yS4c3jdCDWoQTauZIdHU8IcZHxKX7YnLHR
         ZlOy7D9SiOFEAQjjPvM/XxVcIoX+Irr8ce9/UxzUuSd/PilS/xKs1U89yiTMy8nDlKaE
         AqKT9R17FqrIDfTcNMEXmPtxR/4Qr+tmGsJBMHY8h60nr40af/d4HGW7XU+X5epdaXvf
         3LExgvNjRsAzfL21y5N4S3yuFSYiXLZ76mHUHSgsMSRawLn9V++L2jkhB9i9HV8p73m3
         SJqxhA+MOoCGkyRvCtlEbU5UP7JTxvC+LioRgnPspMd3eNr2rZxJVINfGQjyet45AdsC
         HM+w==
X-Gm-Message-State: AC+VfDzhtFqi7wfFulAk6AfQ2xRTTzcAMSmcoD5JgWXVxnnDrKCXZlrB
        Q8cwIs8Os6OLSiMYUdq5mOM=
X-Google-Smtp-Source: ACHHUZ5m5etfFdOfk7QGqJrgJj6bgjQNEqwnaAkqIQjNXeSdWeeqO9HLDCQmh4tc1Gi2a0CCgnlZJQ==
X-Received: by 2002:a17:903:2306:b0:1a8:1f43:70f3 with SMTP id d6-20020a170903230600b001a81f4370f3mr6582542plh.63.1683244278995;
        Thu, 04 May 2023 16:51:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 3/5] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Date:   Thu,  4 May 2023 16:50:50 -0700
Message-Id: <20230504235052.4423-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504235052.4423-1-bvanassche@acm.org>
References: <20230504235052.4423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2b8c2613f7d7..a1bce9c6aee5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8755,6 +8755,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.queuecommand_may_block = true,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
