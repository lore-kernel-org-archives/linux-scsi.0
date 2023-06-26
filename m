Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358D1EB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 08:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjFZIQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjFZIQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 04:16:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66599E73
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:16:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-98bcc533490so358644866b.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687767373; x=1690359373;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=au1yDGBbuG2KvGbbaHGSTXZWdfA4ztHMw3WrPNWrTzo=;
        b=ATmDKIVxKZmu6V2OsJmS527ytHC3/nzhAbRym76yS1NeD0+Rl11EaV+HO0ewbaZALG
         MEJl2a0KoLifFgC61un/CxkkQyWvbMVcigawRXi/j2CSev3MQoJAzLlL4Yavs9uZchum
         Wdfd9Nv0pP8+vFSK18PQ64Hq5Y5ovz61Nfo5CZGSvpiSelBdOeBJfPDPHlZWro/J1rFi
         qCC405LjI0EUPZGqRDMVXJfPjjd0/VQ2oP+EfJoDCIgXdlsymOccP3j2CTO9tvI80kyd
         yyQECLszW3UYtIIMGNfuhhmInfYL/0ty9f1fQ7+SLUEp9T9KVJQiSkk2TTRvfY+Rbv3k
         twhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687767373; x=1690359373;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=au1yDGBbuG2KvGbbaHGSTXZWdfA4ztHMw3WrPNWrTzo=;
        b=L6sStrjqIUpiWIBj0nE7oSBQ84sUKhfbAiwnhDeGOkjMhqxBJllvwPAFeetuLPOVUy
         NNi3GGf0k0dA+exDnfjLGekK6yBTd6ofi3urArs4rVRq6kC1xB801LHw4/EdjRBQQ4Aq
         jCEJZqg32zNggyO/+Yhx6Iu4dhYeCh6cWU0s7oiYzNUJ3XjAZE/MSXNQLsa0ysa3iRTC
         TjoxZX1SIuQpfDEmIAVtVaLbJE243uQXtAU74pKIAZry0+stzncl2Hlfayrv2rvkovU8
         SizygOxWGtO8fkme969omcULncMr5jT4+ueDdy3Xqbj4bd25S2vmiGmOkIw7BATpPO/d
         d9Bw==
X-Gm-Message-State: AC+VfDxGAimG9MFGTYnsu3JHieEDUxYbVoNs4ijs/lkOL7d1hoiCa/Pr
        Jd358+w99sp37yK4mwJJRW+RbQ==
X-Google-Smtp-Source: ACHHUZ7O4faFqU7lLgdylwIcAApDlj7SmoDKa5OSu959zyIml4rFcUIj0XvEDXRwVvYzXDhoXQv9UQ==
X-Received: by 2002:a17:907:2d20:b0:991:de8e:4f91 with SMTP id gs32-20020a1709072d2000b00991de8e4f91mr734446ejc.11.1687767372890;
        Mon, 26 Jun 2023 01:16:12 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id bm4-20020a170906c04400b0094f07545d40sm2935617ejb.220.2023.06.26.01.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 01:16:12 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Mon, 26 Jun 2023 10:15:57 +0200
Subject: [PATCH v4 1/3] dt-bindings: ufs: qcom: Add sm6115 binding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v4-1-14ced60f3d1b@fairphone.com>
References: <20221209-dt-binding-ufs-v4-0-14ced60f3d1b@fairphone.com>
In-Reply-To: <20221209-dt-binding-ufs-v4-0-14ced60f3d1b@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Iskren Chernev <me@iskren.info>
X-Mailer: b4 0.12.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Iskren Chernev <me@iskren.info>

Add SM6115 UFS to DT schema.

Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Iskren Chernev <me@iskren.info>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index bdfa86a0cc98..eb3de2fde6b0 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -29,6 +29,7 @@ properties:
           - qcom,sa8775p-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
+          - qcom,sm6115-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
           - qcom,sm8250-ufshc
@@ -191,6 +192,31 @@ allOf:
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
 
   - if:

-- 
2.41.0

