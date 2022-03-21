Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AD3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 13:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347897AbiCUNfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 09:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347888AbiCUNfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 09:35:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23273C4A2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 06:33:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bg10so29863395ejb.4
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 06:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5GXEdYy1flkYD5H4ZjwtkKaTgHfQbeK4Fic81sbDM2g=;
        b=U93LM0PPjvVS1NMUtHanmhanW3zHZ770C883frfTHWmu1t88XsHFJ/SEtXT6n/lMMt
         re6IfjnHppIOC4ngM2HuHaGjJrVDx1YujqZCFxpIUF2EIr6QHsr5IefXFV395iZgIMOT
         YuYCc2UNxihTIk8dpTKJtRls/VJrqYoN1jm955IKVdCwcvVQ+uiKrlwX48B4hZGHMmid
         5Oef/sbbEqSkxUG0zUMPUlutcFL1zpajN67vtPokaziudtmOagUAm3oL2tXePRIA0CeQ
         UA3IVj6jtKwNiGl1XBj0ttF0J0RkHEkR0FKdlhmOkz/f0ksZyjranNksDpQ10DtlkOgK
         b0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5GXEdYy1flkYD5H4ZjwtkKaTgHfQbeK4Fic81sbDM2g=;
        b=FZtEo1fPDr5JyJ1+xUmlYQ7Y7NmIEPA4XHwDhu/cuW+4EIMw0oJvbmBm1PSHWGwnMH
         rhVhS+NoxNUp3f+tJjxFPQWxDJbdjGnCY4REZ01GoqllRimenqxN8OkBjgJsUIoIxKXe
         XuIpHnS4H+LV7mFHBcRV+Sw0kKOvsZIg7gZLiJJfoj01WyYaEeRBT9kVM3lXH/h5sxpd
         xWM3Zt8AkfuY1WSjQ+1NFOLRqKyCx8zrxDWyU4UjHMWlYIVL1MyaBtMpZVj3X01LmwaN
         tw4t6LNavzpxtyRMwY+M83uBAmacBrUzZxFgNqGHHMmDPJGniGAg17oHZ1zwVUE+HDRI
         rF0w==
X-Gm-Message-State: AOAM532kHrIhz+YamV/X/ZYvOJ3nBH72xgxHDEncSCGw3CgTjJbWvSeW
        2mAj9yaQ35WPDsx5ijHafJDMfg==
X-Google-Smtp-Source: ABdhPJxin6D4QUUEy9OSv7n0xOixCN3MCojKkmBkEpsKwnbOXMZ/kz4iQiW1Uk2i6FUu2r7N4MPGjQ==
X-Received: by 2002:a17:907:3f92:b0:6e0:2fed:968a with SMTP id hr18-20020a1709073f9200b006e02fed968amr1743024ejc.658.1647869629410;
        Mon, 21 Mar 2022 06:33:49 -0700 (PDT)
Received: from otso.arnhem.chello.nl (a246182.upc-a.chello.nl. [62.163.246.182])
        by smtp.gmail.com with ESMTPSA id r22-20020a17090638d600b006d584aaa9c9sm6862154ejd.133.2022.03.21.06.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 06:33:48 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
To:     linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v2 0/6] UFS support on SM6350 & FP4
Date:   Mon, 21 Mar 2022 14:33:12 +0100
Message-Id: <20220321133318.99406-1-luca.weiss@fairphone.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series adds support for UFS on SM6350 which is used for internal
storage.

Changes in v2:
- see individual patches

Luca Weiss (6):
  scsi: ufs: dt-bindings: Add SM6350 compatible string
  dt-bindings: phy: qcom,qmp: Add SM6350 UFS PHY bindings
  phy: qcom-qmp: Add SM6350 UFS PHY support
  pinctrl: qcom: sm6350: fix order of UFS & SDC pins
  arm64: dts: qcom: sm6350: Add UFS nodes
  arm64: dts: qcom: sm7225-fairphone-fp4: Enable UFS

 .../devicetree/bindings/phy/qcom,qmp-phy.yaml |  2 +
 .../devicetree/bindings/ufs/qcom,ufs.yaml     |  2 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi          | 77 +++++++++++++++++++
 .../boot/dts/qcom/sm7225-fairphone-fp4.dts    | 18 +++++
 drivers/phy/qualcomm/phy-qcom-qmp.c           |  3 +
 drivers/pinctrl/qcom/pinctrl-sm6350.c         | 16 ++--
 6 files changed, 110 insertions(+), 8 deletions(-)

-- 
2.35.1

