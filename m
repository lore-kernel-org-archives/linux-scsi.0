Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9640C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLARpg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiLARpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:45:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BC2B68D2
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:44:44 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h33so2266482pgm.9
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/BNw/j/jyyiC6Nde2Mk6v6dKHHqRWva/o8+iSkZe08=;
        b=VkALK2zJnqUvofpKNzlp4vh4yPYZ7VRwFNZOMPsnXGxrSdZ2HXQiwxrOwQvBqyTIoN
         +C8vtvUZDt2Js6yqWsQwGZDL5Y9KLzeaGW0yPZnq9906hh/u4ZvoEl66lDOcOzuEo+Ln
         8FSbdy81bmwKX59FlZi+O84yZwEyqbaROC/cse1ZhsMJj9k9Fh5kbAAvZgTAvxCGdJ6b
         iTlvlkingi72L2yaQdBp999tZ3eaoTy7Qb2k1L7vdS3XVr50Ee1LoQbVp4YvY8na7o94
         +uVyR8FsmEUgPH8zG/xJkZkyc6IE/sXcpqhOXbjjFXk2ZTCwrPGulsTSeAJcwAVjgk6j
         WsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/BNw/j/jyyiC6Nde2Mk6v6dKHHqRWva/o8+iSkZe08=;
        b=1HofuzvKPWkfH0cyis0nwD+LxXkJQYEXRta/0gT4bVIxQMuA4WqNnFw9gODEqiM1qg
         VqkgAQtz/Ve5vY9B58mjt28mYrCJC14HrwcHnZnXUDGYIz9UrMbNUknOCLSujxSIpKuT
         4w3Nh4XulQKrJPOstB3iI2Ovk4WoKdUG4vyfpxat2qVIOoAYC6i5mjfRZmWAKmOgbjV1
         9N5kh6b4y19m5+Uc62DkFOtM+KCR/Lsm8EcorTpMG3AmrdCdLW4ECMNIV7PlFAGD6pfP
         Rq5UrURAMI6wcukFhYcQWz/dadHlDGkrJ7pQI4ASvz+qsrTEECprq55q/IIeskNSywwE
         47hA==
X-Gm-Message-State: ANoB5pmwvdcuA6tKqKScc2QcjuIxyW5RipYL48y/Xi9N+nNZVkv2XyPf
        dMXmzQxqIxR+51QppAs4AYu0
X-Google-Smtp-Source: AA0mqf6xV5CiNhOXSOwJd9AqSTlFTaoJjHREQvuOzcYW+q7bae6vQ0BHQv5u7CMeWrtGKQX66+M1TA==
X-Received: by 2002:a05:6a00:198d:b0:569:92fa:cbbc with SMTP id d13-20020a056a00198d00b0056992facbbcmr48793744pfl.77.1669916683821;
        Thu, 01 Dec 2022 09:44:43 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:44:43 -0800 (PST)
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
Subject: [PATCH v4 09/23] phy: qcom-qmp-ufs: Avoid setting HS G3 specific registers
Date:   Thu,  1 Dec 2022 23:13:14 +0530
Message-Id: <20221201174328.870152-10-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SM8350 default init sequence sets some PCS registers to HS G3, thereby
disabling HS G4 mode. This has the effect on MPHY capability negotiation
between the host and the device during link startup and causes the
PA_MAXHSGEAR to G3 irrespective of device max gear.

Due to that, the agreed gear speed determined by the UFS core will become
G3 only and the platform won't run at G4.

So, let's remove setting these registers for SM8350 as like other G4
compatible platforms. One downside of this is that, when the board design
uses non-G4 compatible device, then MPHY will continue to run in the
default mode (G4) even if UFSHCD runs in G3. But this is the case for
other platforms as well.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index d5324c4e8513..6c7c6a06fe3b 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -567,13 +567,6 @@ static const struct qmp_phy_init_tbl sm8350_ufsphy_pcs[] = {
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_DEBUG_BUS_CLKSEL, 0x1f),
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_RX_MIN_HIBERN8_TIME, 0xff),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_PLL_CNTL, 0x03),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TIMER_20US_CORECLK_STEPS_MSB, 0x16),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TIMER_20US_CORECLK_STEPS_LSB, 0xd8),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_PWM_GEAR_BAND, 0xaa),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_HS_GEAR_BAND, 0x06),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x03),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x03),
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_RX_SIGDET_CTRL1, 0x0e),
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 };
-- 
2.25.1

