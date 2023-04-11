Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6AEC77B77
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 13:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjDKNFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 09:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjDKNFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 09:05:03 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931714228
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 06:04:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so2156962wmq.5
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1681218289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qYe+MGPT9BvgNTQao8r5YoHx9jSImbM+Yzl5JdLRqIc=;
        b=hVZ3SwYl0OMmYsZaktA4PBdt9FadcHLKLFYV9Y3oM0OwQMDSvu0iLQvhsEk273pBFz
         xMjYDP0n7IEjOWvg0jISH4vr2oIC/LyzfkTZe4at0Vr/uAALu81PnqpyLw+wnzfZTkOu
         TmmYK/UpBhgsP/7GQxJnjCUe2pBPAKV/CQTAmMGl8sZ1EImT7qlINWkY4JXfZ/GrWP4R
         kNx5eTCgbw5jeQ3dd40Zt6Xm+q2a3SxD5X8uzYor6aZ6NYE+DFGibBhxxrQmDPt07nNo
         UO/oZCVEaKDxUGsMoWQdcNXYTyk7IivtZey9/F1/u1rsT/Wp5oauw87Dn7CTk390xBgT
         EPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qYe+MGPT9BvgNTQao8r5YoHx9jSImbM+Yzl5JdLRqIc=;
        b=PFHYrwtOKrrkPE82rqqvHqml1qjXunBB+t6lH/55INYZP5ijD0R7rvP0SI3O7Z5Y+q
         WdPetYHmoRGxCUMUwInyMZgHCM7p01iYR2vM++8Eoo+a4fzMD3v+oMBToG5Bdr34AvaH
         /8RR+5L9XSqO/Nhh86W4Xoj0gokfhoH7Fp09ztXNonbMWfqNkJqZT8hLNS0+CMB9/4px
         KVskzYBMIURYQz1oDmVaWp/riP+P7bi0sF7tZHUhNxJx8UUcoEzq6m/y/wwWlqmXq27J
         i4Afa50E5ioBGJRSACfuA2vL8KWdAjRducItuHrwtKMIL0Ho59KgeRfg6Nodhi+s3X4X
         l/rQ==
X-Gm-Message-State: AAQBX9fU9nPty5vN8Lo/dYg7BhKeLDme/CLS/P/BJg/Rjg4Lzjg1apMP
        GTaA8R4QNQWcTRMoAtacJGQVyg==
X-Google-Smtp-Source: AKy350ZfLdAiU/iKV0HLRk3Wy+S1F1keCNjX+IH2eaUg8QZgScVfnsLzAoOiiBKsX+Op60vdlbkezw==
X-Received: by 2002:a05:600c:2294:b0:3ef:f26b:a173 with SMTP id 20-20020a05600c229400b003eff26ba173mr1910380wmf.14.1681218288917;
        Tue, 11 Apr 2023 06:04:48 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a099:fc1d:c99a:bfc3])
        by smtp.gmail.com with ESMTPSA id t6-20020a7bc3c6000000b003f04646838esm16921301wmj.39.2023.04.11.06.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:04:48 -0700 (PDT)
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
Subject: [PATCH v3 0/5] arm64: qcom: sa8775p: add support for UFS
Date:   Tue, 11 Apr 2023 15:04:41 +0200
Message-Id: <20230411130446.401440-1-brgl@bgdev.pl>
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

v2 -> v3:
- fix DT bindings: move allOf: below required:
- collect review tags

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

