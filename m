Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5E7C76196
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 19:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbjDFTrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbjDFTrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 15:47:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CF29F
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2023 12:47:15 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g5so667579wrb.5
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2023 12:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680810433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BHIz3c+rkfz06Sf8NSwUCq2DbSMskpnedxbRiKolYg8=;
        b=nVRx4wz4CHS1HdYP5a9u/tqYWbB6fOinyORdjhh4t5204D41HHL79oIO/CFeaT6L11
         4GTuGY/Dh+MXeL4vzy2J8Zuee3wV18Rwyc4o5h1T2msmcMh4IAGRQuAcCl3Esib/8zj0
         zdLeojELnGQ6i+GElHhS97GckQmX4pNgry4TNRtk6jifs+rlTfhEppuzdgJQZiHQGmig
         Zy0vSnkr8oHFvsDlXEMhEpfS7bBAP8OsGz6WmkUXHE4cQlW2F5uZE6mmYpctL7WNmous
         QYLqO/ct2lj+YzLGHs3tjzkjGG7qVZNRU/BSaMtGigiYZBASqpeAmD6JqzEs6iX23dSc
         dJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680810433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BHIz3c+rkfz06Sf8NSwUCq2DbSMskpnedxbRiKolYg8=;
        b=OPjUzMCdGRGIokKsqp1KQtsoqQlag6loWjwrtLM9s8nt95hVr2aROl14G1Y754Txh9
         Mm/7+DgYZcQqlw4llOnVJhWTApmUGxI+iLNf2B4z6H2AslqAN4DZr+ydO1d1myL7mo7+
         WDR0ZeX3oQnFb6EyPXvd/MvWPtdsQecM/NlFqFhAn8GGfdwqFOTRFSKMs5+FeUV9tEqg
         uIcWSLY4JebaTN4qRWB6mMTwjHtF9SWaKzwI8zk2smbRgllYDRaeLQHkDY8QcW+MNXpS
         CRlhI2d2Za/fe8ywLYtPFtAsj5qs1UCWBH5LfOVBgiw1PLNsQT1JCcaFd4JhCb96KSkv
         J8ZA==
X-Gm-Message-State: AAQBX9fpa5tnogIW38wxPkhN1OtGjz7o/Yxigs5vHGF0Mz/ZS1bDIid9
        jUS6kPzoenN+/UAQH9yG9Xr32Q==
X-Google-Smtp-Source: AKy350Yv8/Vi44BZfkJ1gJ8f2FGeuqH5yR48dzc/pmWlrkbe4sONzyJAbRFJhaanQgIyt8rDT7Oh7w==
X-Received: by 2002:adf:dd92:0:b0:2d4:a843:d000 with SMTP id x18-20020adfdd92000000b002d4a843d000mr7368870wrl.56.1680810433541;
        Thu, 06 Apr 2023 12:47:13 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:4793:cb9a:340b:2f72])
        by smtp.gmail.com with ESMTPSA id k15-20020a056000004f00b002c71dd1109fsm2593323wrx.47.2023.04.06.12.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 12:47:13 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v2 0/5] arm64: qcom: sa8775p: add support for UFS
Date:   Thu,  6 Apr 2023 21:46:58 +0200
Message-Id: <20230406194703.495836-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Update relevant DT bindings, add new config to the driver and add UFS
and PHY nodes to the .dtsi and enable them in the board .dts for
sa8775p-ride.

v1 -> v2:
- order new compatibles alphabetically
- rework the UFS PHY bindings to accomodate more clocks
- add a comment in the .dts regarding a non-standard clock used
  by the UFS PHY

Bartosz Golaszewski (5):
  dt-bindings: ufs: qcom: add compatible for sa8775p
  dt-bindings: phy: qmp-ufs: describe the UFS PHY for sa8775p
  phy: qualcomm: phy-qcom-qmp-ufs: add definitions for sa8775p
  arm64: dts: qcom: sa8775p: add UFS nodes
  arm64: dts: qcom: sa8775p-ride: enable UFS

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        | 26 ++++++++-
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |  2 +
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts     | 19 ++++++
 arch/arm64/boot/dts/qcom/sa8775p.dtsi         | 58 +++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 38 ++++++++++++
 5 files changed, 142 insertions(+), 1 deletion(-)

-- 
2.37.2

