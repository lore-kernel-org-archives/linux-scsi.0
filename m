Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA52C77B6D
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 19:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjCaT7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCaT7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 15:59:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856E935A9
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:59:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q19so20505675wrc.5
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 12:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680292771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKMqWuHq1atNt6umWF5yeL6AWpUb/E2kDARevmv/t7E=;
        b=R1yGbDzZkXSfNAmHOrec1xK+vmJwYF1I9Tmf/86J//hF4fFCeObYLB/wng4+xQouEu
         IRHckzWQYRtWBSOU99bxb3/VfvIaF0Tp0i8TCxAZtDqKgW27pDehQGLXzHUeUT+3Xo9j
         1JNeCmWulw+B2RmWzURTrsKrqvE84OJxJ+WiVJAhfBw6IYh2cNeDEpF+B91M/JIJXvT1
         Bnc2FU0rLYrCRcM1iwhSjaAdIXBXGayRbyBnQd0Vz0w4I80SRNkIbgDRHzcd5Rj2XLSh
         MwC2Q0SkR9bstLKfuXsue7hxTLABhSZA2MuwSZVlL6L93HdYBkIwJ9QkMOKQW9UMB/yv
         lY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680292771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKMqWuHq1atNt6umWF5yeL6AWpUb/E2kDARevmv/t7E=;
        b=YfBiv9sZ3hvhqDDhUBqY3sKXD65cRS7klCXL03UlGgcIxIJcy07BOQmuUpoyRyoHtw
         0g0V07BAvL8XkeybCwkfL5ZAjarK7FPyG3aeBgCkQkGvef7D7fsO5NUEjmJ5yotnkRye
         juMxFWtaeNtaRuejUzcZqBXZGu+2JEi4U0dzu2UM9zLFVuR6/rtZkWt22ir/4Awn+il4
         eht2YQnAGtrBHtCPbtpm6m7YAaDbbYQHEJLc6cjZ1NnE1t07oaq78UM+nCW/UFe4EHCR
         vPbLplGF1/FxGkt0dtfQ1SoSggqm6X7I3dxqOGObhEGbscuTGAu0TIYjWJBYUnleCdi/
         SFNA==
X-Gm-Message-State: AAQBX9cRAH3L5iZiYnEgeNXJWxHgOMdZiEk2sHUtGINabcK5a5muxg8i
        k1HIFzmMZc5FH5jFq7+bFFYzaw==
X-Google-Smtp-Source: AKy350a1XhX1OiVE2JDxPVA6mRqh+3WGPa6RQJBfgkXi+23ET2/y3h1dJrDNAhcrcMzEY25bJ5KkdA==
X-Received: by 2002:a5d:4e47:0:b0:2e4:cbfe:da52 with SMTP id r7-20020a5d4e47000000b002e4cbfeda52mr5117629wrt.3.1680292771045;
        Fri, 31 Mar 2023 12:59:31 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:1dc:d1f:e44f:2a1d])
        by smtp.gmail.com with ESMTPSA id c13-20020a5d4ccd000000b002cff0e213ddsm2990286wrt.14.2023.03.31.12.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 12:59:30 -0700 (PDT)
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
Subject: [PATCH 0/5] arm64: qcom: sa8775p: add support for UFS
Date:   Fri, 31 Mar 2023 21:59:15 +0200
Message-Id: <20230331195920.582620-1-brgl@bgdev.pl>
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

Bartosz Golaszewski (5):
  dt-bindings: ufs: qcom: add compatible for sa8775p
  dt-bindings: phy: qmp-ufs: describe the UFS PHY for sa8775p
  phy: qualcomm: phy-qcom-qmp-ufs: add definitions for sa8775p
  arm64: dts: qcom: sa8775p: add UFS nodes
  arm64: dts: qcom: sa8775p-ride: enable UFS

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        | 34 ++++++++++--
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |  2 +
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts     | 19 +++++++
 arch/arm64/boot/dts/qcom/sa8775p.dtsi         | 54 +++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 38 +++++++++++++
 5 files changed, 143 insertions(+), 4 deletions(-)

-- 
2.37.2

