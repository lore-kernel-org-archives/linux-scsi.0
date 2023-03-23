Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4200C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 10:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjCWK0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCWKZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 06:25:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D31B566
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r11so3074957wrr.12
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679567132;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=la//61tmt1JcHM3ugdeN6VnhDtVEZYhOaulQ5DfrvTk=;
        b=S2plp2biPGbwxEiLWBmwLJwun7H46QDGsXGyrABWfNZDdJqJh2PBS9voTj3QSeOUh1
         99qv2UbnDsZDzXJoIi3Y5+uzdePQTnw9tRFUmz1d5jUJ5nQkjPojZ1mzrEt3ZPs0Bj5W
         sW/yzmYBz3xuR0ejrvsfxWKx7sHxGHnRCxXb62Qq+AX03L2q1sRPSNCrUF9eYAMdea8z
         /QdKTwqDEAwXxUtwONLXbjwlFiFGL1e09KILItMUY3q7lSet92LZ96YQZq4YpHhRPxG/
         cehXuvJTmhmnLF/DLCGs8Qd0WUWsclH+WvciD7ootrnnzur54KUypGkVhvyjSRiz6Lj6
         HzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679567132;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=la//61tmt1JcHM3ugdeN6VnhDtVEZYhOaulQ5DfrvTk=;
        b=WbaHj3W7bkxx+Bk/c541GYpmxkiXZ8ML1VAo/O3RLZIk6AghXOFfYr7uVFU4sTtuTD
         JYLLTdsCRo6YNyG364n7R97wOpl6TKe4EkCsRB7hzQAMg/VhcB6Ifxh42YEYw1R83CAY
         HPFvlZjluBzFSqjDssJsC7OH6xlIib+jwmUvIM6A7ZujQFIlcqylv7ayIVva8UEgCLwt
         +c8e95OZnU1eqrWNXGcp08XmPw6QKeL1J0AcnWuTvKlgAqJ/jfl9Ii+ourqWcDBXzkla
         L/Ve1DjO3UKBN5tTwLA/YqHwnhyHjf64U1Iy9NwudUCowIMar0ueC1uk5qUWXKcJD90v
         eP6A==
X-Gm-Message-State: AAQBX9dEAFz9PYM4uNrMawwuBjSqjM6ix/htLwJHkZ3furEEjIPIWRdC
        tR7ql/LQby6p/Ub+/RuUa5kInw==
X-Google-Smtp-Source: AKy350b44afSbkJF5DaYq1NUD5d4106/qJV/mKTzn9m9WMT0RNlmV8eElddHIPWpkEOECHczSuNPjg==
X-Received: by 2002:adf:f14e:0:b0:2cf:e77e:2eef with SMTP id y14-20020adff14e000000b002cfe77e2eefmr2254862wro.8.1679567131835;
        Thu, 23 Mar 2023 03:25:31 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e23-20020a5d5957000000b002cfefa50a8esm15753530wri.98.2023.03.23.03.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 03:25:31 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 23 Mar 2023 11:25:20 +0100
Subject: [PATCH 5/8] arm64: dts: qcom: sm8450: remove invalid
 power-domain-names in pcie nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-5-3ead1e418fe4@linaro.org>
References: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-0-3ead1e418fe4@linaro.org>
In-Reply-To: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-0-3ead1e418fe4@linaro.org>
To:     Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-scsi@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following DT bindings check error:
pci@1c00000: Unevaluated properties are not allowed ('power-domain-names' were unexpected)

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index ff55fcfdd676..bcb51e612261 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1792,7 +1792,6 @@ pcie0: pci@1c00000 {
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_0_GDSC>;
-			power-domain-names = "gdsc";
 
 			phys = <&pcie0_lane>;
 			phy-names = "pciephy";
@@ -1905,7 +1904,6 @@ pcie1: pci@1c08000 {
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_1_GDSC>;
-			power-domain-names = "gdsc";
 
 			phys = <&pcie1_lane>;
 			phy-names = "pciephy";

-- 
2.34.1

