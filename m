Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B933FC6FD1E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 16:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjCHQAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 11:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjCHP7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 10:59:40 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBF4C889A
        for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2023 07:59:12 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso1654276wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2023 07:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678291150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3gnd/d/MLXJUAK0HLanbIn82QxPIkJ3zZK4UMU0euI=;
        b=rl8Drhy1ZHKjf0fTHD6/H53KQSiQI5SLJ7WfDX+eVtbeHnMlZ9yaESFaS0f1MQYon0
         oWcgidFWp0iYsFqXb9LaIvrzJVY557trMGZasbEDTaS7V08K+RociKRgNs1D2yTdwnhy
         Ve1Q7thOnHad90nPMxRFpuTfrdoi5j+1pW0itPn/xnen7r98T8TofWMt/9lqPvWcam9M
         D7di7CYxIZRHjoWmfX2R+wy3MCdp6mhZI6k+n53bIZUMrCur1cbM7pgC9soEeK4b24Ln
         ONNd9aICsTEvhbUi1y5HQ0lqg51hpSOAANrvT0hK8SrklnrqXig7GW5R1y+2HI8LPk9w
         LkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678291150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3gnd/d/MLXJUAK0HLanbIn82QxPIkJ3zZK4UMU0euI=;
        b=HMlGYPS9bZfopkSJ874so9vBUPRaDP4B968NjQCm2hHekUraOZOMSB4752c8holTbU
         EHZ4+EQJr25isAOm027XoUpoQKB2Uzixd3fFnJYKv3cUIw57UYNzmRM1hn+2I68lzjNs
         ClLNGA2iEyKs6WT9dzBJIWmcXmygxG7F0XqaXXoXviw6nG9rYaQgYh77F5bafyQ3xQNV
         auc8hRYSTyTO4CdmwEbhwtGFx6u5CQr3Nho3mmvtyU/YzXPVaRf1Y1xIWRT0+gCXOzDv
         OivPraDie043vydYqQEE7XvLvmYnzXWMiaKBKjogVAZqenhxSl4g119rOWjPw7yRfJL1
         4Xow==
X-Gm-Message-State: AO0yUKW8EK0fqPDF8Vo69A1H8gzMRzNAtxU4G7tqClvhqxjlimN1/YJ8
        dQTe7nYnDKOLL/i5ED1xZBpoPA==
X-Google-Smtp-Source: AK7set90j7W0DmZbPdYoUas5/sJDtvyaCTDeMr9rAzDAu0F/Vq88d/1lOJkxSxkDGM0IOQv3za/mdQ==
X-Received: by 2002:a05:600c:3111:b0:3eb:399d:ab24 with SMTP id g17-20020a05600c311100b003eb399dab24mr15404956wmo.28.1678291150619;
        Wed, 08 Mar 2023 07:59:10 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c229000b003eb2e33f327sm2548430wmf.2.2023.03.08.07.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 07:59:09 -0800 (PST)
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
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [RFC PATCH v2 2/7] dt-bindings: ufs: qcom: Add ICE phandle and drop core clock
Date:   Wed,  8 Mar 2023 17:58:33 +0200
Message-Id: <20230308155838.1094920-3-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308155838.1094920-1-abel.vesa@linaro.org>
References: <20230308155838.1094920-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ICE will have its own devicetree node, so drop the ICE core clock
and add the qcom,ice property instead.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---

This patch was not part of the v1.

 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index c5a06c048389..a0c93c2d7a42 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -70,6 +70,10 @@ properties:
   power-domains:
     maxItems: 1
 
+  qcom,ice:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the Inline Crypto Engine node
+
   reg:
     minItems: 1
     maxItems: 2
@@ -140,8 +144,8 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 9
-          maxItems: 9
+          minItems: 8
+          maxItems: 8
         clock-names:
           items:
             - const: core_clk
@@ -152,7 +156,6 @@ allOf:
             - const: tx_lane0_sync_clk
             - const: rx_lane0_sync_clk
             - const: rx_lane1_sync_clk
-            - const: ice_core_clk
         reg:
           minItems: 2
           maxItems: 2
@@ -166,8 +169,8 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 11
-          maxItems: 11
+          minItems: 10
+          maxItems: 10
         clock-names:
           items:
             - const: core_clk_src
@@ -177,7 +180,6 @@ allOf:
             - const: iface_clk
             - const: core_clk_unipro_src
             - const: core_clk_unipro
-            - const: core_clk_ice
             - const: ref_clk
             - const: tx_lane0_sync_clk
             - const: rx_lane0_sync_clk
-- 
2.34.1

