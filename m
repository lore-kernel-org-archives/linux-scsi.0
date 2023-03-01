Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086B6C64ED6
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 07:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCAHbV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 02:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCAHbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 02:31:19 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01252367D8
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2023 23:31:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso5509186pjr.5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2023 23:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=keeUYhycEW3Fs0u8iJwpD0KGXx2mVNbdHJgnTSIvKAQ=;
        b=sVilUO5IJz+6Keu2KbNrdXW7UCqg6p4UHXAKmARsbMRAgQfi6tRvXeYyhdXB4t2JuC
         sIRzpJVaHFkoC5xlbcqrXaU/h21MJg91/6eapbrfxjZ+Ehoxvy3drb+f54TlF2+oliHb
         /8g8Dxwe1djEAU5oO8Xuknt0NXyLvgaYnkgjE442UAuMxUkKv097wIZDDVrLA0erg5ht
         LxnvqK4f8ZbykNgQah+V56ASX0ixa9QMuP71N7a/Fidr4oAGUAqoJz7jSJABhDbKE/Vz
         B5QpdEwS6PX221dBo5cAlYCtiYwVhLEoZNHLZl9cOyGkWZFx+v864ur1+VaPfwQEIBY1
         OM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=keeUYhycEW3Fs0u8iJwpD0KGXx2mVNbdHJgnTSIvKAQ=;
        b=dwuWOqNDD0ObGYTSUqZKF4rmzItIyHgUMl3BILpTEeiuycsPVH4J6umSL8/FStPhCN
         jdSoUsmjNfajEq1v31rhACM1cNcq6cdwvEgR/SnegL0/EPk7MjjiTV73kopLyEPTlYg+
         8pPA1bOsRpnt5XLAJfr/2yeGpzxKczcPHjKpdHQuEJhNhZKfXaBqxyFR0AUveA4eKT0J
         rnuFO/wAO2X2OVPAN3LWEtYwd1Y7Dhl6zPMZhTmcyeL1X4Gw0Ele14YYsb/YAF6UXxn+
         40QKwmx1cO6EDMuM9QcQMwDtmyJkqQ2lM2CpHSAxlSfkhN3iZfeo+wUoR/xIJJZF3E55
         Cvww==
X-Gm-Message-State: AO0yUKU7UU8enrI9zUDjEhZ93bThIivHgknRrihyxPeLHSVFBIvreJSj
        FTmL+sg7gm7c5saLOqQJXCNK
X-Google-Smtp-Source: AK7set8qgBlc4bW0B/Ysf/MSZEbIbjA0cKfAm8NP7z1Xj/jazGYsg0N5QA6ZR90+NRDda9aCIboDWg==
X-Received: by 2002:a05:6a20:6903:b0:c7:164c:edf7 with SMTP id q3-20020a056a20690300b000c7164cedf7mr5864858pzj.36.1677655878373;
        Tue, 28 Feb 2023 23:31:18 -0800 (PST)
Received: from localhost.localdomain ([220.158.158.89])
        by smtp.gmail.com with ESMTPSA id f17-20020aa782d1000000b005dfc8a35793sm7262740pfn.38.2023.02.28.23.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 23:31:17 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        quic_asutoshd@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] ufs: host: ufs-qcom: Return directly if MCQ resource is provided in DT
Date:   Wed,  1 Mar 2023 13:01:10 +0530
Message-Id: <20230301073110.9083-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using a goto label to return, let's return directly in the
"if" condition after setting mcq_base.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 34fc453f3eb1..d90f963eed02 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1460,8 +1460,10 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
 	/* MCQ resource provided in DT */
 	res = &hba->res[RES_MCQ];
 	/* Bail if MCQ resource is provided */
-	if (res->base)
-		goto out;
+	if (res->base) {
+		hba->mcq_base = res->base;
+		return 0;
+	}
 
 	/* Explicitly allocate MCQ resource from ufs_mem */
 	res_mcq = devm_kzalloc(hba->dev, sizeof(*res_mcq), GFP_KERNEL);
@@ -1489,9 +1491,6 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
 		goto ioremap_err;
 	}
 
-out:
-	hba->mcq_base = res->base;
-	return 0;
 ioremap_err:
 	res->base = NULL;
 	remove_resource(res_mcq);
-- 
2.25.1

