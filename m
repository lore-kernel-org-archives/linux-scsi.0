Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D52C76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 13:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC0Nrs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjC0Nrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 09:47:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CD03C02
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:47:45 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eh3so36387159edb.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679924864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t7BV/Kx6UCtJpUovRhPsWRP5SzZ7y1ukt8uk3iZ8eAE=;
        b=IewDs8GfHgkOhz6SEJ76/sfVp2pbQV1qLHUFVt9GRUWIq1NZA0XMYREj5e4akzn1dG
         lsffQvwAOqeoRRbA2dwP2l9prPLaageiaAgiUoLpPHc2yvjOoVZQZJ5MArHpqUDfdowd
         OoUCSigMB7NJHVF3pQlYyHBL/ySMsK9DjyK81FHyBVgXlXTCdYOGeVb7HkENSIGwSa/2
         2Upn7J23OxE5ZIKjgU3RS9oqiAByAs7uaGqtgX6GKKF0P22yvhJJZsXOnqVsK1j2YToT
         4WWHxRWNjm6FqOGzDPqwQ4K9FM3uPeYfm5jdQ3OsvHZTh043qyblUEeNDSdhvrqx7WF5
         1skA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7BV/Kx6UCtJpUovRhPsWRP5SzZ7y1ukt8uk3iZ8eAE=;
        b=vtRXwa0ORT6+iYHsK140KyOhkwX8UtgevnYkT6SrD1TaOSGaLlIQF4It5gdwFSrI1v
         XgWhKnpXCbuasxCsXPilyoKSqqvPjxAo4Y05Fv9EOlGWXzHUGkH8GVZbUNxHQ5Ke30BS
         UiimKeBJXJxgpfsfgrDEsGwnWNz8agcWZwrUqA5ppJfUNGblKH95S/HpJreS/hvMjwKq
         GXAqdaK453dNYOaQU0P5+BumGrbeDK4aB/cZkQ62+lf9fuLsEfbszkbFIy304Sid6N0S
         kWcsWPX+Qr4DivVVLzmnj5QDofvOd29UbyybeM7sJGPvMpdvJW0RBwQy0ScVLhWJmqvU
         C4Tw==
X-Gm-Message-State: AAQBX9dC78M+uj1xa+1xSM/HSELnrwuQlAG57jTZbDDZ4FCodZHXKHKB
        QHnoa51A1d9vTcZpRl8sM1blNg==
X-Google-Smtp-Source: AKy350Y6BVy0kKsBIvMlaCwci6jrmq2SWtNUQBKSoPRQSgF4V0DbngHfYOsYUcqXoCyxZHTNP9etyQ==
X-Received: by 2002:a17:906:5288:b0:932:3d1b:b67a with SMTP id c8-20020a170906528800b009323d1bb67amr12335753ejm.41.1679924864341;
        Mon, 27 Mar 2023 06:47:44 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id n7-20020a509347000000b005023ddb37eesm2394303eda.8.2023.03.27.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:47:43 -0700 (PDT)
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
Subject: [PATCH v4 0/7] Add dedicated Qcom ICE driver
Date:   Mon, 27 Mar 2023 16:47:27 +0300
Message-Id: <20230327134734.3256974-1-abel.vesa@linaro.org>
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
Also, switch all UFS and SDCC devicetree nodes to use the new ICE
approach.

See each individual patch for changelogs.

The v3 is here:
https://lore.kernel.org/all/20230313115202.3960700-1-abel.vesa@linaro.org/

Abel Vesa (7):
  dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
  dt-bindings: mmc: sdhci-msm: Add ICE phandle
  dt-bindings: ufs: qcom: Add ICE phandle
  soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver
  scsi: ufs: ufs-qcom: Switch to the new ICE API
  mmc: sdhci-msm: Switch to the new ICE API
  arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node

 .../crypto/qcom,inline-crypto-engine.yaml     |  42 +++
 .../devicetree/bindings/mmc/sdhci-msm.yaml    |   4 +
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |   4 +
 arch/arm64/boot/dts/qcom/sm8550.dtsi          |  10 +
 drivers/mmc/host/Kconfig                      |   2 +-
 drivers/mmc/host/sdhci-msm.c                  | 220 +++--------
 drivers/soc/qcom/Kconfig                      |   4 +
 drivers/soc/qcom/Makefile                     |   1 +
 drivers/soc/qcom/ice.c                        | 342 ++++++++++++++++++
 drivers/ufs/host/Kconfig                      |   2 +-
 drivers/ufs/host/Makefile                     |   4 +-
 drivers/ufs/host/ufs-qcom-ice.c               | 244 -------------
 drivers/ufs/host/ufs-qcom.c                   |  95 ++++-
 drivers/ufs/host/ufs-qcom.h                   |  32 +-
 include/soc/qcom/ice.h                        |  37 ++
 15 files changed, 591 insertions(+), 452 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
 create mode 100644 drivers/soc/qcom/ice.c
 delete mode 100644 drivers/ufs/host/ufs-qcom-ice.c
 create mode 100644 include/soc/qcom/ice.h

-- 
2.34.1

