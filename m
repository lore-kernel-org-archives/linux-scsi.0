Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72097C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiLVOMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbiLVOLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:11:43 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9002CCB7
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:11:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b2so2115072pld.7
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvxrIOSMwPwfBmbLwjUh7RSQgKGQFWcoHbzhG+iF/Ko=;
        b=WTuaje8tBT2fOIy1a89lMB6i5Ui5tAVSKgOIChDqLuXMxQfla11Z26p3l/4upQXjty
         hQWeqnUOuLVzQxm/O1+zc9CT1O+4OI5nySj2hdFdrLYHnYTHJoVhQsKKLkD+wvc/dW83
         u3derLOcuSM4NHgyZ1D+A5NXU5HpWnDP7XStujDSVyEDXWHbPkrgm5DGI0fx5xyEOcsX
         wwI9tvGlrHeleujah3LHXJmJO3vehHZh6xYcInFXHu3xjMTkIB0ZIOy8Rx7h1ASPJVlE
         Ob1CAvP6zGAFCKiupTAcbsYV9foos269qV9m5jKYxNicOVBTd2ElbPW9T5wHcpy8MX5c
         nkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YvxrIOSMwPwfBmbLwjUh7RSQgKGQFWcoHbzhG+iF/Ko=;
        b=pAOMh014jA7OEh4rOq4rnZ6AC65sTGrK8Ay4inn28BcOQ4Qa0yYJQ5aY9ajl958xnE
         0EYiFVGubfZ8PY9hi/iN6rHjgyfgECk5cxHMThMTdFbW4+un3Ph+8GcwgCx2QJSnsL+l
         pAAocTI/JqadUTkL71JBeipT7ina8F150ZcavCNBlg4Ngr9DDamL8+svuK7JnP8oLysQ
         Q05rs1Iqxhcp2a53EtGzpr0U7xwwR+6gVABFk0oXVGqrGigbp1I/dV4OEVYgBjxIXnZO
         d+30U75JrbAs1AiPcNgEnc0nD6/gw6SrNRR5HZR8vvhRfguOThjqYYq+bmq9gS4SLXLa
         ZJlg==
X-Gm-Message-State: AFqh2kpsbHd7GlxtVlqbVll8GhJttwzmomEDSFLaDPD3r+lBifq1+DrP
        C9FVERSifSncUiIwjO5zWEqn
X-Google-Smtp-Source: AMrXdXuIDJp7seq7NruDAODEgmaT+tpNvsXqsojyyuPeLQ3wM9nFLZgl91mCfYZlnbwQbD/Vfa7yLw==
X-Received: by 2002:a17:902:e382:b0:189:db2b:93ad with SMTP id g2-20020a170902e38200b00189db2b93admr5438517ple.2.1671718275957;
        Thu, 22 Dec 2022 06:11:15 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:11:15 -0800 (PST)
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
Subject: [PATCH v5 09/23] phy: qcom-qmp-ufs: Avoid setting HS G3 specific registers
Date:   Thu, 22 Dec 2022 19:39:47 +0530
Message-Id: <20221222141001.54849-10-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
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

Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
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

