Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EF7C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 20:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjEXUhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjEXUhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 16:37:12 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D623180
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:11 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5307502146aso579081a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960630; x=1687552630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xTU511RNGl1AHFsKHmW3okpv21QbRYC3A6KDgyY3fw=;
        b=TspCFhMYSMo5iDPiTrxJHD++jAPABzi2AKNIS0EW5LXWFwMbyyzwwCVc2v46Ofeo1M
         oO9/vfaIv2gjkEvypQbmg8JNr1IYQll5lG+wK5r/YKRg/Enz4z9qVJo+HajdfBgpl61I
         Ntc+o9okwU96aR8EQ0ala70sOebywmwKQlzXMSiaxSOWYRq4h5hW5PkJfng3KljXdgBk
         2of94AFhB+ULCyJZBVPc4zKvHwf0p+6Zc3ve6wP8oFXt9teOzH21j/TJsThi1pFuWN79
         p/ZQ3mPQdI93GDRMGNAlIbp9o0Zj8mbt9CfxVXzMMSlToy3oiVnHFUacMcnrDALNI1+j
         HbWA==
X-Gm-Message-State: AC+VfDwAr1EgPLaD2qFjxXcSeXPORXMOLlm8AKpAMn5HVzuhSffW2b23
        MtvMru5VR09nJ3MHgV56BaY=
X-Google-Smtp-Source: ACHHUZ59qsIJE06LijbO8DVVeG67XXl5JW1VzerAfyA1OVJ04nUso7t1GJHGFG69jysEl+68Dt3GgQ==
X-Received: by 2002:a17:90b:4b01:b0:253:34da:480 with SMTP id lx1-20020a17090b4b0100b0025334da0480mr17713969pjb.31.1684960630419;
        Wed, 24 May 2023 13:37:10 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090a70c700b002535dc42bb5sm1690122pjm.47.2023.05.24.13.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:37:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH v3 1/4] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
Date:   Wed, 24 May 2023 13:36:19 -0700
Message-ID: <20230524203659.1394307-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org>
References: <20230524203659.1394307-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
Hence this patch that increases the UFS timeout to 10 s. This patch can
cause the total timeout to exceed 20 s, the Android shutdown timeout.
This is fine since the loop around ufshcd_execute_start_stop() exists to
deal with unit attentions and because unit attentions are reported
quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fdf5073c7c6c..dc4b047db27e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9170,7 +9170,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
