Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC85C6FA86
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiIWUM3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiIWUMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:12:21 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB6E12260E
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:20 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id iw17so1183685plb.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l/aLlXmMnRU00Ow6DKfjvx/KHHUnXAX6M5393iNpbng=;
        b=3XC5aqjel1f+d4ZwtxeIAivMH6Dgoj40/VL8KW5NV2s150TDoR3JZq9t+EU7rrTP4n
         SeNMF69RwUUIAf6d1KCDSb489IjyqdEeVBwiQo5QrPrJBh1coPHHPJ7j0BDtGYEGyzPY
         +PG0OL4fUMtghqPPNVk72aJtzcBGgld+0v03woCDAp5FBovcZTV/YO7i6LXmNdRW4kWO
         j4it5VxsvDiHBT980Ytp/rjuYzMHG3lJ7FsEWY/UQGKKNCR7BBAMxkwTKDJx9n/YPcef
         E4dENosLXb02fyR7RONH0kf8grm6xu8TKNawbdiMCv8HRO8RNP4ZvsHqASup9ojnenCy
         mbhw==
X-Gm-Message-State: ACrzQf2B0hK0900Hay7FsM06ib5ZRj5Dnb10ix4ogFgULcEs47577jtm
        DtYAvFxHvodJAv0HNiOnFlo=
X-Google-Smtp-Source: AMsMyM7AA1MBMlqtx4MAMkVENHhu3ai2cWJhwxwKCAjODqGGeS3qBozQLL4P+uvhrHSRba10urNo1g==
X-Received: by 2002:a17:902:ccd2:b0:178:29a3:df2c with SMTP id z18-20020a170902ccd200b0017829a3df2cmr10184632ple.77.1663963939898;
        Fri, 23 Sep 2022 13:12:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:12:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 4/8] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
Date:   Fri, 23 Sep 2022 13:11:34 -0700
Message-Id: <20220923201138.2113123-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert if (ret) { ... } if (!ret) { ... } into
if (ret) { ... } else { ... }.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 78c980585dc3..02e73208b921 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8798,10 +8798,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				scsi_print_sense_hdr(sdp, NULL, &sshdr);
 			ret = -EIO;
 		}
-	}
-
-	if (!ret)
+	} else {
 		hba->curr_dev_pwr_mode = pwr_mode;
+	}
 
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
