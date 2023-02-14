Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF89C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 12:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBNMDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 07:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjBNMDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 07:03:02 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ED7B749
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:03:01 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m20-20020a05600c3b1400b003e1e754657aso5048877wms.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I3shvzCeDJk0aJLXCz2Fi53c14j1PwpmIfo6GpvgOlk=;
        b=GpgoiPKZCtdioxmx0gpNue68w9ZlaCkccA7QGPdTjaq0zhsTmu2n/A6Sf2DDTex1eV
         hPu1awwYrwjVOpeW9mbLHBdo+bqvIKl69WQgU1R/+HtrD8JTMJNZzKFn9csfK1XzQ1Qo
         qnf4/FEFukt4IZkJyHVEO46RyN+xTpzg4QIwqp5WJzCo0LNflou2ta2wKp9ddNuqYc/V
         KIM8Ufp43Szcqq94MUptQxETSi2K5Pa0kYxe/uUfYcCOUolVip300AIRHhcVCU3yvRxu
         y4bFXfNvH0JlzH/NinYZfnZjMZy7X+SYCLZ12KGiF3mFysT5KlLnE5gV6v+rAvv1sLJF
         KQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3shvzCeDJk0aJLXCz2Fi53c14j1PwpmIfo6GpvgOlk=;
        b=rvCnNXYqAQyEyqPDIjZrz7y97rmccpHok4/+f9L9G6PKE9CivbosXRmcUWll/9qFLj
         WDWGRIrNooagF9CllW7PLRPQ9Ld8K8UYzoSuhnmb+C43iZcWiv712ASxfO9TTOD0mVYC
         tan4fEQaS3BzC9mYOQw71ezYe1/cL31sh//7D4QFzGPWh29fsHrcx+zcUzNqg+WVOEt5
         OTVivny3aAEulqUaCfqnnnuQRvHLbdFj18nh3PUSiNGKvhG4DMRGHYtIR9HHa8rOOwjf
         CCfd3q2OZ3WUfbubpl5YNvlYhMueymSN/l2mX9bfdG2MCQ8reNC8fHUmaP2H1dZEGM0h
         rzSw==
X-Gm-Message-State: AO0yUKUE8Apt3hthKPhyI0BVD9NdvKsc2FW2L5C3mI083ybOS9K1Gq/F
        KxTfh5oKP47ohIP0XyIx6ThEAA==
X-Google-Smtp-Source: AK7set8pUpgbV35UbjeKdI6zHSqyLvAQswd66/w+rS96k/B8bKl4FtFeNT0y8rMY3sTDuDNWKsM8nA==
X-Received: by 2002:a05:600c:4ab0:b0:3de:d9f:3025 with SMTP id b48-20020a05600c4ab000b003de0d9f3025mr1697260wmp.0.1676376179342;
        Tue, 14 Feb 2023 04:02:59 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id l40-20020a05600c1d2800b003dd1b00bd9asm18834846wms.32.2023.02.14.04.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 04:02:58 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [RFC PATCH 0/5] Add dedicated Qcom ICE driver
Date:   Tue, 14 Feb 2023 14:02:48 +0200
Message-Id: <20230214120253.1098426-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As both SDCC and UFS drivers use the ICE with duplicated implementation,
while none of the currently supported platforms make use concomitantly
of the ICE IP block, the new SM8550 allows both UFS and SDCC to do so.
In order to support such scenario, there is a need for a unified
implementation and a devicetree node to be shared between both types
of storage devices. So lets drop the duplicate implementation of the ICE
from both SDCC and UFS and make it a dedicated (soc) driver.

This RFC should be treated as work-in-progress. Initially, its goal is
to figure out what is the most agreeable implementation for both types
of storage. Note that currently, only one ICE instance is supported
(like the existing HW suggests) and it is laking refcounting and locking
of any sort. Also missing bindings schema file for now.

Any suggestions are welcome at this point, including the location of
such a new driver.

Abel Vesa (5):
  soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver
  arm64: dts: qcom: sm8450: Add the Inline Crypto Engine node
  arm64: dts: qcom: sdm630: Add the Inline Crypto Engine node
  scsi: ufs: ufs-qcom: Switch to the new ICE API
  mmc: sdhci-msm: Switch to the new ICE API

 arch/arm64/boot/dts/qcom/sdm630.dtsi          |  18 +-
 arch/arm64/boot/dts/qcom/sm8450-hdk.dts       |   4 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi          |  24 +-
 drivers/mmc/host/sdhci-msm.c                  | 252 ++----------------
 drivers/soc/qcom/Kconfig                      |  10 +
 drivers/soc/qcom/Makefile                     |   1 +
 .../ufs-qcom-ice.c => soc/qcom/qcom-ice.c}    | 247 +++++++++++------
 drivers/ufs/host/Kconfig                      |   1 -
 drivers/ufs/host/Makefile                     |   1 -
 drivers/ufs/host/ufs-qcom.c                   |  42 ++-
 drivers/ufs/host/ufs-qcom.h                   |  32 +--
 include/soc/qcom/ice.h                        |  61 +++++
 12 files changed, 326 insertions(+), 367 deletions(-)
 rename drivers/{ufs/host/ufs-qcom-ice.c => soc/qcom/qcom-ice.c} (50%)
 create mode 100644 include/soc/qcom/ice.h

-- 
2.34.1

