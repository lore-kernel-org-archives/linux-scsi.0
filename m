Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAAEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiI2WBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiI2WBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:01:04 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F5132FE4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:04 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id u69so2612006pgd.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l/aLlXmMnRU00Ow6DKfjvx/KHHUnXAX6M5393iNpbng=;
        b=u19ZOFvXcyHC4JRbcGGEyPBKuWZhg7GGLIwjJ2oE050fU/V0pkWCwDIcTKR3hOzc9N
         tDLAQ9XK688bnFJQCQ9tG9UedJGZMyxO9AbJ10aFeqx35VgxyTiSotxA1m8UTnyb4Ta3
         QRCoxpTuXRSnNzAuXON634vEljn8A0oxE2+rehGZbQ2uRvVDGB9GQqKQEFh0MBCBOjMr
         INEcdDJynIvdX+0ezvjv4YcKCYp5xdjOcOT3wFUPYCTdBG5zazDyrz+lSv2dZJ/5ZvdQ
         E1Gdjj0njtzGUMacaqDVswSEM80nODV7BrrFJbol3SuBR9ocEI3RFEOMKHHRSDGYe1Zv
         tGmw==
X-Gm-Message-State: ACrzQf3b1cGaqsGsj3K9Snoz/KxETRHluGGN0fA80e1mhvnvVXarn1Ey
        0k+UvSM21LYwGJMO7tdy/eM=
X-Google-Smtp-Source: AMsMyM5UGpl0I3fcrllVscvoFz4X6Nzq7aaFq3Wy5u1stBMCqoqKtZbeQuL74ohwOtqYqDGdYCp/hg==
X-Received: by 2002:a05:6a00:248b:b0:542:6ae2:24d5 with SMTP id c11-20020a056a00248b00b005426ae224d5mr5662121pfv.65.1664488863648;
        Thu, 29 Sep 2022 15:01:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:01:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 5/8] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
Date:   Thu, 29 Sep 2022 15:00:18 -0700
Message-Id: <20220929220021.247097-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
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
