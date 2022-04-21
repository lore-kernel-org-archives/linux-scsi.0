Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F7FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 00:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383415AbiDUA1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 20:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiDUA1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 20:27:23 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A201AD94
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 17:24:35 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id bo5so3466586pfb.4
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 17:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+O0q7IHi9Z/77MzUAH3gtIeijCtM5lzo72F5MxSBqg=;
        b=H3gO+l1t17Rea/95mXd0xrw5AKUogTU3kr0LAgoeIhG+Ys/Qi2pb/yyenQehgMCpeH
         2z1eOUApRN4mtwkfD4eYkoUIC0AuK2+WAqrFsSBr6V2dX29Rne7KZDZz/p1YoPZBfLIN
         5dsYeKy6fWK6yU/cC5d3hIY8qF7GslHO81/pkdgyOVAnqOddAdq8rbRMCTCKssAksw8e
         owjRoQN6v3pbNLyIo6UY+a+r0NVTKhxBGPjlNABIC4PjDv5tZ9xPiHToBybA18d4rFtE
         2/eGV+4AovRtmJNZBgSVnEb/10hMwJhKw+09bspBjyp+ShBWpDUOYajmNok6j9rG99Jx
         PeZA==
X-Gm-Message-State: AOAM530GYVqN3ZNU8c1dv5ExFYUfh7nBcKKFB+U2yqxIxVMZtCqzaKnM
        yj7txleidlrWQM4QX1lCejg=
X-Google-Smtp-Source: ABdhPJzL/up+cFnwqLWIOlpe8uC0ffuTXVS/0XDo+ykCr4uSRG+D6pcyAgezINwgU8VXCr4BEckChw==
X-Received: by 2002:a05:6a00:198b:b0:50a:90fd:59f8 with SMTP id d11-20020a056a00198b00b0050a90fd59f8mr13355361pfl.22.1650500675281;
        Wed, 20 Apr 2022 17:24:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c3e8:e9ae:c289:5688])
        by smtp.gmail.com with ESMTPSA id r13-20020a635d0d000000b003aa482388dbsm5832426pgb.9.2022.04.20.17.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 17:24:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Konstantin Vyshetsky <vkon@google.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: ufs: Increase fDeviceInit poll frequency
Date:   Wed, 20 Apr 2022 17:24:29 -0700
Message-Id: <20220421002429.3136933-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Konstantin Vyshetsky <vkon@google.com>

UFS devices are expected to clear fDeviceInit flag in single digit
milliseconds. Current values of 5 to 10 millisecond sleep add to
increased latency during the initialization and resume path. This CL
lowers the sleep range to 500 to 1000 microseconds.

Signed-off-by: Konstantin Vyshetsky <vkon@google.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..ba9c7f9ec424 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4438,7 +4438,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
 		if (!flag_res)
 			break;
-		usleep_range(5000, 10000);
+		usleep_range(500, 1000);
 	} while (ktime_before(ktime_get(), timeout));
 
 	if (err) {
