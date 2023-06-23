Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B23EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 11:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjFWLa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjFWLaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 07:30:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400742686
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51beb527a89so557437a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 04:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687519816; x=1690111816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdYoL4tmbwTZuD91LiWi1VOBXorpaCxfk3Oa1MlS4bs=;
        b=TaBkYtOl9AULVW7HulYaVbmyn3vNVRpEgBUa2gW1YfqqeECQiI5ZqeS/Ar/cydqNUX
         KuKIGbw5qriXMG0GvUiP5W602KYeZ/jrPokIhClce5O6W8dSFaQeEV0aFMbryylqYfnW
         iL++jcIkR7E1NMwmNs2+opGYZmmkA5sS84Q+pzU0O/P/QfKI5y9mD9T805NbH70934M5
         fiPWlDTNvhsiFWJjqbK96ZWDmz2Q2WFF4ovUkQKU3wrC0fm3TWoKoaVTP5/T29xpQXnH
         o1ydIANZR+PSJUQxqB4Or4HhyR1hRjBqkL9WpGQnwBb4lVN2welM/KYTIlVIsv37MOa9
         LFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519816; x=1690111816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IdYoL4tmbwTZuD91LiWi1VOBXorpaCxfk3Oa1MlS4bs=;
        b=SJkSRg9Y34k2bYHgtUrFF3L4Zwzn1Ebu41rqCitVijYoJceI2RLbHRQ9IEXFtP3Wd4
         FIMerYZbwzVxiHMd5SRKAdM2UEN2u5VE4IPwaAKAd2873FkmGAIYeFAe8WP9g0/w/aK7
         gCl4eUfhwX93PWiEY3ozdxlTyDQq3mqDQC+KtU17LeF7fdbZcSgkRT4bb77QniiCVfVU
         kjacZYiZ2AcpTlY029gyl+fyOlI9vNfNqWawqnlt7F/YdSjU0oftmNlBRACu5GQVqohr
         bxYd8tz1l+hQOW3ZvbUycH4wRs8UdU3Ke5SxBI01DKuEFyqyo6jdXZng61vBLdXbX9Qi
         hqYg==
X-Gm-Message-State: AC+VfDx8etWZUbTvXEINFoSSVRLCl45N1Zp4MwRbmNISvoSCnwoT2Po9
        QxJRfCG9NAuabdgPvLOHrPnYPQ==
X-Google-Smtp-Source: ACHHUZ5scCkLTmJhlnUviPE6BCxa3dLa9bOAE+xQtpQ5suJmyEok4UJ6tW3/cTMFeCQKFp9fCqDpRw==
X-Received: by 2002:a17:907:25cc:b0:989:450:e567 with SMTP id ae12-20020a17090725cc00b009890450e567mr10065506ejc.65.1687519816758;
        Fri, 23 Jun 2023 04:30:16 -0700 (PDT)
Received: from hackbox.lan ([62.231.110.100])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709063ad100b009821ce1ea33sm5908033ejd.7.2023.06.23.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:30:16 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] scsi: dt-bindings: ufs: qcom: Add compatible for sm6115 and sm6125
Date:   Fri, 23 Jun 2023 14:30:06 +0300
Message-Id: <20230623113009.2512206-3-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230623113009.2512206-1-abel.vesa@linaro.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the compatible string for the UFS on sm6115 and sm6125 platforms.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 .../devicetree/bindings/ufs/qcom,ufs.yaml     | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index bdfa86a0cc98..46f454ec3688 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -29,6 +29,8 @@ properties:
           - qcom,sa8775p-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
+          - qcom,sm6115-ufshc
+          - qcom,sm6125-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
           - qcom,sm8250-ufshc
@@ -163,6 +165,36 @@ allOf:
           minItems: 2
           maxItems: 2
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sm6115-ufshc
+              - qcom,sm6125-ufshc
+    then:
+      properties:
+        clocks:
+          minItems: 8
+          maxItems: 8
+        clock-names:
+          items:
+            - const: core_clk
+            - const: bus_aggr_clk
+            - const: iface_clk
+            - const: core_clk_unipro
+            - const: ref_clk
+            - const: tx_lane0_sync_clk
+            - const: rx_lane0_sync_clk
+            - const: ice_core_clk
+        reg:
+          minItems: 2
+          maxItems: 2
+        reg-names:
+          items:
+            - const: std
+            - const: ice
+
   - if:
       properties:
         compatible:
-- 
2.34.1

