Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362BAC6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 10:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjCWKZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjCWKZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 06:25:36 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10A51B2D4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:30 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r11so3074855wrr.12
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679567129;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpNLyip69wJmwS3OqBQsHCVctKdhVF4LiqZDmDMUITQ=;
        b=ksoJnpaK/Zy6H22m19pDj2+MsjnTWx5V52xHiYII2sZY3NnOGH/VCPayWVplJI49n4
         ND5pCgxvdcpo2zY5ivvI+6PaEQb3RUIrHghG0fXowpUPDaiRdFNFFoaptC6atp2LFDu4
         /7l8Ft9XzQI/dgI2u5Kwjzjf3EGfetJ/nD19W1xeFExSOR/0ZrGeJgeovF+mJ5cIQcS6
         IIUH+yBHXb4uTAbLYXpoijgnFWQYeSiSA6Q4cZyNbB1P4/nuqF4+tRfG4scuPUaaB4PZ
         oy7rac3DSmLy92YeMtCqS/0R/2asitjiEoWzOpdqfo6qh7rO6b/GqtLVjy5psj/Std9W
         pipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679567129;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KpNLyip69wJmwS3OqBQsHCVctKdhVF4LiqZDmDMUITQ=;
        b=rVwF0SdyrfcC4zyv1jB3r4vNOJCxASxvhA7HUtKhFYZjQgJq8P6Jbx6S2uCFV1VfY0
         kW0HSEyNsIMR9gyH1nma0it0v/WAnM/0PU/MqIWTQXLSXkIWv6jBMBQNs6ITjaEYOLsl
         AcC9pbWj3z6GvBij4GpSR4qSzZe0Kys4WL67bsMJ6eAMR5HfPeuL2GufHzbwmNY1utbB
         ek9Yk+Xxdn5BqMgjmvVbKbU6832EDF2zlw3g5Gem0hK94lCKub+EZRYM1S293ORAePJn
         l3189FSJMhEYzovGq4PjTTeMRPIJokM4YxGFG3XoOVXerm/j7l5mfFREKKk2q/CBzfxY
         aIZg==
X-Gm-Message-State: AAQBX9detxCylFjmRh3b9VpPZHpYRrtDlOhdv29+CokYxHIqwjq/6vJa
        QUm0FS1xZrlnklq3zLp17lMRQA==
X-Google-Smtp-Source: AKy350aWTw8oMw5mfdjhhl2Uko+aQ7QMPlClfObRzjyqr46IHBi4Ee5GKUOe7E4wHzsM5OQklZnfuQ==
X-Received: by 2002:a5d:6187:0:b0:2ce:adbf:cb14 with SMTP id j7-20020a5d6187000000b002ceadbfcb14mr1824465wru.28.1679567129412;
        Thu, 23 Mar 2023 03:25:29 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e23-20020a5d5957000000b002cfefa50a8esm15753530wri.98.2023.03.23.03.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 03:25:29 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 23 Mar 2023 11:25:18 +0100
Subject: [PATCH 3/8] dt-bindings: ufs: qcom: document the fact the UFS
 controller can have an ICE core
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-3-3ead1e418fe4@linaro.org>
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

Move the qcom,sm8450-ufshc to the right allOf:if allowing the ICE clocks
and registers to be specified.

Fixes: 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtschema")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index c5a06c048389..4527bcb949b7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -108,7 +108,6 @@ allOf:
               - qcom,sc8280xp-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc
-              - qcom,sm8450-ufshc
               - qcom,sm8550-ufshc
     then:
       properties:
@@ -137,6 +136,7 @@ allOf:
               - qcom,sdm845-ufshc
               - qcom,sm6350-ufshc
               - qcom,sm8150-ufshc
+              - qcom,sm8450-ufshc
     then:
       properties:
         clocks:

-- 
2.34.1

