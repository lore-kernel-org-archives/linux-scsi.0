Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6021AC001B2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiLVOOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbiLVONZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:13:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A532CC8C
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:09 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o31-20020a17090a0a2200b00223fedffb30so1973682pjo.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Umv4TvSxWOIQ+FsO7JFyleWWrH/ciDg2B2wQfJu0u8=;
        b=lFSSRkVosTBl7NH1CjbznzIGAhg1vr0OY58REMnY5M10cAyYyb2kWljgPPZK+purpL
         tkoP2lQhnWegg7up4xJ7Glzy1oRsWoz+U4ZzaV2EZylwUbdC59PnTlUSQTVkJ5O99jGM
         dxwsmXAnqzqkf4CWzclp7h8P0im11vTrb/mwtclro3NVJ2zi6pS2rVWrrXYIzh/dMG4y
         N8kItD1Dhc0fSBQHdSQ8WUXMgIy2C4HWNoVYUTizsMwgNzJIb1y6buVo1qTzWGJ0FNvq
         DnKtsXUl341uWX/LhSn8MJZ/hpYKPNR3XRta/FNYJ7+PRgzpJvgucZ1qRmvMqnM9ccts
         5o9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Umv4TvSxWOIQ+FsO7JFyleWWrH/ciDg2B2wQfJu0u8=;
        b=MTLAuXDWk/ytmfoIOtWu1/lOFO9TAyaLC8JBwq2p90Nxoh9pF7knFer+xNcz0MhY8P
         yDDd/xqlZRqzWUL/xiTnZR6DWRSXfU12oVDyjFr5jZ1gtIHgyi+8545zAWyiWfU6OExA
         TwKjzi7GWDEzg0qTLTAHSlNGemX8pR6CpUcjdDobUQcN/Ek3u2as22I4Hjc7jKwQUZEs
         0CFYNH2yaCd7v4GRpZ2bg8Tgh/0oAbx1cNcovoLptAZf7k2cPS1QcZvGtMay1QWqyj0j
         L8X/NU2GxFvOIwPBCt/AmXdXjKdS2qVm91Fi59qSxtAqwsNiY8zrhE7NGJIafjJSIFej
         V5xw==
X-Gm-Message-State: AFqh2koyVcS9G2qYbPu7s3m1lHdiCTLRsKztCSPn8ZojlNGXRsxbrSdW
        WpYcH9Lg4MA8bmCiWGW9MJDXEbwvv09E4mk=
X-Google-Smtp-Source: AMrXdXsfA22qTY7Dpuhd3BPItBnKL5MRnihwLcXslA73ddu+1EMjMQTU80L5uyMZTcdu/fyDqeutaQ==
X-Received: by 2002:a17:90b:300f:b0:219:823f:7216 with SMTP id hg15-20020a17090b300f00b00219823f7216mr20532049pjb.31.1671718329192;
        Thu, 22 Dec 2022 06:12:09 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:12:08 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v5 16/23] scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
Date:   Thu, 22 Dec 2022 19:39:54 +0530
Message-Id: <20221222141001.54849-17-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make use of dev_err_probe() for printing the probe error.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8bb0f4415f1a..38e2ed749d75 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1441,9 +1441,9 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 	/* Perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
 	if (err)
-		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
 
-	return err;
+	return 0;
 }
 
 /**
-- 
2.25.1

