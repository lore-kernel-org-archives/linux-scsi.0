Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC038C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 10:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCWKZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCWKZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 06:25:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4261AF
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r29so19837845wra.13
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679567128;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MbMpIW2XeTgOIuij0DvAphORXQYIJr8R5bBmK3u0n4s=;
        b=OiM1Yacj+a6ZH6zyF+4WbfsKHoee7NXm2MM9OOs2n5bJzfOLIGXc12cwtoMMbg5V3G
         3E7MUGqH2EfT+LLrFi30N1TD5vnz9MtKSQJ7qwGhKdoghrG2YNuKlZpFNEbNpPfb+JNC
         For/VV8QIang/A28V7HMQQzpxwmJI796xxhu2taDRIfLRuuphtt55iNSeSB1TPRM88kr
         MbeZOoHUYvYqUSMsB/kCZa2vQ1FUlEiDJMmqJPeIQn3BXlnkPEmWDHVnFESQ6FJvikYa
         cSWdtPSS6SLsNYVNt6bjg783EluGuECjGfV2WXUqqcBqC1eByii9qGUXoZ2JXGQ/O6yJ
         vBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679567128;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbMpIW2XeTgOIuij0DvAphORXQYIJr8R5bBmK3u0n4s=;
        b=FLkqQBafAbeKdzRTBCieJ7CJ0eCozDucGHEPm7mBYn1YujReFCuAkDXu5+mlISagEd
         h/3lh05TU8z9yRGo4MU6Vq2Ap5NiGgZ+2a2pfGAyrh/gm4trU7UpviK3PSaXx8VDUJ58
         QpLnMvKB1a0zF5mflbs1DYHJmprpLT7HJAUlAdXcmnYAKN7IXjU3yS8DwMnxiQvI3CXt
         KmHQpfCF3fCgg7CtxR0t2EIqmhNuQt8LIXH9du7x4L3OJNKOvq6owpb1fnktBFc+omun
         KHPwAYVdZVnFoTdQZ+jhLXynmv/or+cuPjc6/QVNivtQ0cVsS/60Se7MR6VwmGlaIDuv
         92AA==
X-Gm-Message-State: AAQBX9d96A0I8R5lDKc4WQinFIY9jDAA4Bm6NDGs5kun3k8XfFUKQqTa
        IxY770n55GrWjV/ZZsVucRCduw==
X-Google-Smtp-Source: AKy350YnpJ9aARdt0vtWcfFYEivcldCh8Vl38PKNmqoJ8yqlx/THGzhpYzjoV1hW1Xn0hKBSv96fHw==
X-Received: by 2002:adf:ed43:0:b0:2ce:a8d5:4a89 with SMTP id u3-20020adfed43000000b002cea8d54a89mr2146384wro.37.1679567128111;
        Thu, 23 Mar 2023 03:25:28 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e23-20020a5d5957000000b002cfefa50a8esm15753530wri.98.2023.03.23.03.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 03:25:27 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 23 Mar 2023 11:25:17 +0100
Subject: [PATCH 2/8] dt-bindings: mfd: qcom,spmi-pmic: document pm8450 pmic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-2-3ead1e418fe4@linaro.org>
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

Add a compatible for PM8450, commonly found with SM8450.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
index 975c30aad23c..15deeff2d447 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
@@ -57,6 +57,7 @@ properties:
           - qcom,pm8350
           - qcom,pm8350b
           - qcom,pm8350c
+          - qcom,pm8450
           - qcom,pm8550
           - qcom,pm8550b
           - qcom,pm8550ve

-- 
2.34.1

