Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D0DC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 07:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjCXHll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 03:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCXHlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 03:41:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9896B2594B
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:37 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ew6so4352659edb.7
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 00:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1679643696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0n73iZ8VJIt54nEx9Q7fNmrfFMw8zxjDedrs3LziIE=;
        b=ZgoCJhbx7jqrXRcPUZMkEl51Sb5ctO/NU6fKtzeFTfNP1oNNxxD9ihAaBkwLDBxnrP
         jO4HJBcfgCEjbRTNTNMa8IiAjtqWV6itywJhUg0dksc+NVYbi1M/mwNSAtCl/RQafFfu
         cMeOj527FqHLT+mt2w1m+kOKsdTD62sAG4yuidM05mE/Z1EdvjDE/zdhY4qtF7hZuFAC
         OGSLIcRrraavOdOg8I1Oc3ILsDnMHv+agbnXyDRmlAjrho17JK2PRt5ylXhb/jab5ZAH
         Ef/PdRbCRy7Az12rQb2HNXfhQjPrTBJT69BMq4/v16OUv9U+hyDu90HuHnqHKbC+SoTn
         QixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679643696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0n73iZ8VJIt54nEx9Q7fNmrfFMw8zxjDedrs3LziIE=;
        b=GZoyOHsZoH4POzWzo7ZOdjz/AejWjCW1oOCdDSfa6W4HxSxJBX00u5RuIOLCzNsgfh
         myW0MyiYNTiNUshWJoo+5OlJH9bRwORonoRASp9JxOOuxnICRj0jlJvaXiaA3ojSEgey
         E6twaiDypev8yYwqujp1QTq/sJgGCjiVw+UxslEllRxGHPFGoLXmRJP4A+mQ+3i2s8E5
         nMoQ8MgZxRifiBexjiYIZYuthC5IbbgE2BEZAgw2UZHY8im/v7hT8xn5Wh/o0fBtoa1M
         XIIjfos+ydKMql1CBl2zZwgBAWGkMtn9AhNCKWxxECbKDYt5nZ7+3+VIkkGbGmR9GbcG
         JsOQ==
X-Gm-Message-State: AAQBX9fS2zVnVE/QphJuwP6dMgy6VkkgZb8U9BqfwneKcFZMiWDX73o2
        G8GlOS8padXuu9R1VRIk+F6ytQ==
X-Google-Smtp-Source: AKy350abskR8P4cqQaIB6SmOAJ/5w82M5UcNawDqlSgx0L7XYyF4R1ERvpCx/v3JOC3ev2IBCfj27g==
X-Received: by 2002:a17:907:1905:b0:8b1:3467:d71b with SMTP id ll5-20020a170907190500b008b13467d71bmr1987216ejc.48.1679643696142;
        Fri, 24 Mar 2023 00:41:36 -0700 (PDT)
Received: from [192.168.0.29] (84-115-214-73.cable.dynamic.surfer.at. [84.115.214.73])
        by smtp.gmail.com with ESMTPSA id d23-20020a50f697000000b004fd2a7aa1ecsm10271227edn.32.2023.03.24.00.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 00:41:35 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Fri, 24 Mar 2023 08:41:29 +0100
Subject: [PATCH v3 2/3] dt-bindings: ufs: qcom: Add reg-names property for
 ICE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v3-2-499dff23a03c@fairphone.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
in the bindings so the existing dts can validate successfully.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 23447281deec..ebc8e1adbc6f 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -75,6 +75,10 @@ properties:
     minItems: 1
     maxItems: 2
 
+  reg-names:
+    minItems: 1
+    maxItems: 2
+
   required-opps:
     maxItems: 1
 
@@ -129,6 +133,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
   - if:
       properties:
@@ -157,6 +163,12 @@ allOf:
         reg:
           minItems: 2
           maxItems: 2
+        reg-names:
+          items:
+            - const: std
+            - const: ice
+      required:
+        - reg-names
 
   - if:
       properties:
@@ -185,6 +197,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
   - if:
       properties:
@@ -210,6 +224,12 @@ allOf:
         reg:
           minItems: 2
           maxItems: 2
+        reg-names:
+          items:
+            - const: std
+            - const: ice
+      required:
+        - reg-names
 
     # TODO: define clock bindings for qcom,msm8994-ufshc
 

-- 
2.40.0

