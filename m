Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8DEC6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 07:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjCXHlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 03:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCXHlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 03:41:39 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818241A4B9
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w9so4438020edc.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1679643695;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nPqFaK3PfCV9f0plVHjaFnI0EQVHjWHhUIO49LkNrrg=;
        b=1AANZ2/bS3AMQkcUUHO0ZZCL8X6ou4PlmramzhRfkFPTwV38Z8DusOr510nm698Ftl
         VjA/CQCFhtvTL+pdi3bjgqkq+JHDtEkJ2gXUW+hlfDOolcf0Y6L1kUR32bFZPREnNSCd
         3Vq/DZZblF0vbLRvP4D8+UgiCSGuj/iLZo+zYzoHHAhE3Jkjt5p3pIoU/SYiU4saj+Km
         M2gZaPLJJgX6+kBpGqAIqrniptKyXtahslLtZKezjgpbDfTNirJkKXNa4/E5RHHch6l1
         Si7WQO7sLLaYFnK1s9e1mAVMuj+9Kn4bsTnF+aLtGPibaSd2dQkWv4pNVul7haQ5AFBT
         q7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679643695;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPqFaK3PfCV9f0plVHjaFnI0EQVHjWHhUIO49LkNrrg=;
        b=LiXZEIoK5F+ER1Wins+ep3MdqrxsJNcIsppnWRtwcBsXJX3lYOC2QWfAJpwGAiWG9R
         ab2bkpjjF9nj7iO5paWtoJTdKyZE6Mq8DEYGOw40Y7ztA6xDqQzpAcHQlS6NzwbSwu/x
         AZX5w96bIf5pjcKTDh82D+9hOI70771rlysBKwhECV2Ygll0qLXEbOimlMJ4sLanHXZA
         ddxLPqH/WNMqfl5gXDPKpxo4prPE5fYj3KKtpBAGwvh48ASG8KsUx3jkNzxCvqWQxZrq
         SL7/uMBKdO+DmBuPs8wDuBbA5i4Js9v9hJp2IreWe/pTAnPmZc7qEn3wyyGFbMPivnSD
         iiOw==
X-Gm-Message-State: AAQBX9d+l3iwbdZloRMASCrZpVplWUjA5iuRi6U8lWp4VRtciEDxlaMm
        m5MTYKdNpNVdRbRtJFh4di6zLQ==
X-Google-Smtp-Source: AKy350aAXImvzI8NjEszfNA39ejVSja1xKQWepyXhUlX9yXoeMEm+YLwAc3Pz8I1zp5f2RtdzuJxKw==
X-Received: by 2002:a50:ed11:0:b0:4fc:b51f:ff50 with SMTP id j17-20020a50ed11000000b004fcb51fff50mr2052797eds.30.1679643695136;
        Fri, 24 Mar 2023 00:41:35 -0700 (PDT)
Received: from [192.168.0.29] (84-115-214-73.cable.dynamic.surfer.at. [84.115.214.73])
        by smtp.gmail.com with ESMTPSA id d23-20020a50f697000000b004fd2a7aa1ecsm10271227edn.32.2023.03.24.00.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 00:41:34 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Fri, 24 Mar 2023 08:41:28 +0100
Subject: [PATCH v3 1/3] dt-bindings: ufs: qcom: Add sm6115 binding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v3-1-499dff23a03c@fairphone.com>
References: <20221209-dt-binding-ufs-v3-0-499dff23a03c@fairphone.com>
In-Reply-To: <20221209-dt-binding-ufs-v3-0-499dff23a03c@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Iskren Chernev <me@iskren.info>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Iskren Chernev <me@iskren.info>

Add SM6115 UFS to DT schema.

Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index c5a06c048389..23447281deec 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -28,6 +28,7 @@ properties:
           - qcom,msm8998-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
+          - qcom,sm6115-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
           - qcom,sm8250-ufshc
@@ -185,6 +186,31 @@ allOf:
           minItems: 1
           maxItems: 1
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sm6115-ufshc
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
+
     # TODO: define clock bindings for qcom,msm8994-ufshc
 
 unevaluatedProperties: false

-- 
2.40.0

