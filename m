Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAB8C76196
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 10:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbjDGKus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 06:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbjDGKun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 06:50:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F8EA5CE
        for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2023 03:50:41 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so25026424wms.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Apr 2023 03:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680864639; x=1683456639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=06TnYBdo9T2x70dl6lUY38eRXb4b9fDtFg6W0E/jF9s=;
        b=wYDrtmyCUeuPHoQ+a+L+bYIKD5tVHF0T4I7wDqd7k8R9pfkM+J9OhoQDyESXnzz1iz
         k3ooh1VU2Q8gW2TSMLRlbtghkI19sy19ypdWoc+Omxxem6YZuXrgCPFr2LGsUITxWliE
         +zBT3kCgH6wuumOU7JtR9EXz8g2jSMCePAMrqaI2lCCSey7kNVinVsK5dKZLfyxYqxVp
         gySoNb8rDY/w1WGiu9q8a23DHmXgXkXf7veY050tTyaiF3nf+/mROPMw7MS6i60JLSEW
         pbhVwVkWGBoCGj+2wJv+zy42hiGSIYRliEDZRZysa98BQX7OD7u+MFN7XB7Gr72FM0OU
         A2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680864639; x=1683456639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06TnYBdo9T2x70dl6lUY38eRXb4b9fDtFg6W0E/jF9s=;
        b=LCIZx1qxFefTGYEtuJKIsIP1OnOefJb1s31d6i3STzdtkHOXMaMIZdPLiEzaxWp2j8
         UQ9MbqEwN7XrjdEdGobcy5duLy9YuKO48Ot8nC/BWXO4U4zX89zCJ1dwHW8xz/2CS3RS
         ZcTOODjchxGA3UPk/0lYSSTxnKIM7jjHKxHexfDfQ/pFAqs8CXc3HQqXSfH1DktsHvRM
         B55xS9iwc2xgwZyNZufS2dUpXXCtjqEn6WnEfjj4cYtBPNU3wSDWwKVcQj6utq/jMyfE
         cDnDHarxMem7mq2KA+Yo9BK8vgsEyN3EjWgBzAzzTK/tpKbjmWD3/8zKjORJwMxBweYU
         e+nQ==
X-Gm-Message-State: AAQBX9fPMYZWe1vuzUiUKxgUx7vtyuezBReFhUgpeFBmYfCiN6OXEYOA
        Z5AW6uGLi/k/mek+y73itDH9CQ==
X-Google-Smtp-Source: AKy350ZwCtSoQjiiwA1Djng0xz4M3/ZbNCZlAcTQ8nHuWoyebrI7lbwqlVuy6DqJem2lF9sXrcoJ7A==
X-Received: by 2002:a05:600c:2285:b0:3ee:ed5:6115 with SMTP id 5-20020a05600c228500b003ee0ed56115mr1076006wmf.19.1680864639120;
        Fri, 07 Apr 2023 03:50:39 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id i16-20020a05600c355000b003ede6540190sm8131909wmq.0.2023.04.07.03.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 03:50:38 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 0/6] Add dedicated Qcom ICE driver
Date:   Fri,  7 Apr 2023 13:50:23 +0300
Message-Id: <20230407105029.2274111-1-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As both SDCC and UFS drivers use the ICE with duplicated implementation,
while none of the currently supported platforms make use concomitantly
of the same ICE IP block instance, the new SM8550 allows both UFS and
SDCC to do so. In order to support such scenario, there is a need for
a unified implementation and a devicetree node to be shared between
both types of storage devices. So lets drop the duplicate implementation
of the ICE from both SDCC and UFS and make it a dedicated (soc) driver.

For now, only SM8550 has been added to support the new approach. This
also involves adding support for HW version 4.x.

The v5 is here:
https://lore.kernel.org/all/20230403200530.2103099-1-abel.vesa@linaro.org/

Changes since v5:
 * See each individual patch for changelogs.

Changes since v4:
 * dropped the SDHCI dt-bindings patch as it will be added along
   with the first use of qcom,ice property from an SDHCI DT node

Abel Vesa (6):
  dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
  dt-bindings: ufs: qcom: Add ICE phandle
  soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver
  scsi: ufs: ufs-qcom: Switch to the new ICE API
  mmc: sdhci-msm: Switch to the new ICE API
  arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node

 .../crypto/qcom,inline-crypto-engine.yaml     |  42 ++
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |  26 ++
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |   9 +
 drivers/mmc/host/Kconfig                      |   2 +-
 drivers/mmc/host/sdhci-msm.c                  | 223 +++--------
 drivers/soc/qcom/Kconfig                      |   4 +
 drivers/soc/qcom/Makefile                     |   1 +
 drivers/soc/qcom/ice.c                        | 366 ++++++++++++++++++
 drivers/ufs/host/Kconfig                      |   2 +-
 drivers/ufs/host/Makefile                     |   4 +-
 drivers/ufs/host/ufs-qcom-ice.c               | 244 ------------
 drivers/ufs/host/ufs-qcom.c                   |  99 ++++-
 drivers/ufs/host/ufs-qcom.h                   |  32 +-
 include/soc/qcom/ice.h                        |  37 ++
 14 files changed, 637 insertions(+), 454 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
 create mode 100644 drivers/soc/qcom/ice.c
 delete mode 100644 drivers/ufs/host/ufs-qcom-ice.c
 create mode 100644 include/soc/qcom/ice.h

-- 
2.34.1

