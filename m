Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6832DC76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 13:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjC0Nr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjC0Nru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 09:47:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF8B40DC
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:47:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so36449925ede.8
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679924866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0KD/jLws7DEnQqR3LPOKCTTyWTBeDFcUElMUlrf4Cs=;
        b=OEHVtldo3KwjwlQXEc6AulF0M5fxWxFB+xezRDLngj5ZhWFsH+T0v4IpuyThaABiFA
         Hhz+2y2vSeMDR9BVp0HpD01XbjEJ8XdhyTcEanTF31Sf2pfDPl9nUQJKGcy80ZLUkgsE
         DuNtAXiqDQcM9YpooWMQToKiZ+6lXyohY3cjdhUyiZP5qqiS9RbWC/mOkVB7UbziYeb0
         +SHvoMk9+F/GFS8du1+/q4I6Wgc2khRmfye5cFB8AV6czzzE6kUTsvWXe3OYccPM1Ltj
         86L/bOf0pdahkhUdHXF6DjYBd/Oh5qGRGQnOT6v6RTwzao0+q7vYtgWGTpyWiblyGx3p
         EwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p0KD/jLws7DEnQqR3LPOKCTTyWTBeDFcUElMUlrf4Cs=;
        b=0mkyE39EW87F2h/ROdB2Bj7xSxvv1Aceq0tYpoLlJm0WpIOUkg0L1gbt2I7eE8xLJ6
         dw1nw/NqsYYqTu+JaxMwPxW2GAgfhSjLlaP+76gkwbLKb7+2YL+iiCm9TXnvCOUnDLT4
         bWEg+X/IFRPFvbvbSmOsCXUiY92xtyMuLM70V7RPmnVBTFx/3fpW9ozR0kZbdQJ3As7M
         IFQZB8KiY58/7gfZoB/wIwTFvzxvFDqlWMKRQAjGxAakedCZFrb4RXMgUKWQG0AatWNE
         p80UdIl+gsxKXvEatqo4hH5ssrLJXTF4pVAuBUtG9CuI5O2OeSPRTKPPuAQhiXjyKcj8
         1RrQ==
X-Gm-Message-State: AAQBX9emB42M9JmfpEUR5ikRNAbbh1+3ULkyjCG0KMzp3PNNuqZhSzBb
        /3ip3DxxQZM7ykrZ2EQXi7FmWQ==
X-Google-Smtp-Source: AKy350YceXgl+kZDDd+NLFArfrp+OzKfRgRbJyXdyikVpbjrlnWrwtsLu04uGpjohcRf725rAumMvA==
X-Received: by 2002:a17:907:c710:b0:8b1:806b:7dbb with SMTP id ty16-20020a170907c71000b008b1806b7dbbmr13213372ejc.51.1679924866013;
        Mon, 27 Mar 2023 06:47:46 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id n7-20020a509347000000b005023ddb37eesm2394303eda.8.2023.03.27.06.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:47:45 -0700 (PDT)
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
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v4 1/7] dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
Date:   Mon, 27 Mar 2023 16:47:28 +0300
Message-Id: <20230327134734.3256974-2-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327134734.3256974-1-abel.vesa@linaro.org>
References: <20230327134734.3256974-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add schema file for new Qualcomm Inline Crypto Engine driver.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---

The v3 (RFC) is here:
https://lore.kernel.org/all/20230313115202.3960700-2-abel.vesa@linaro.org/

Changes since v3:
 * added Krzysztof's R-b tag

Changes since v2:
 * moved the file to crypto dir
 * added soc specific compatible
 * dropped top level description
 * renamed node to crypto and dropped label in example

 .../crypto/qcom,inline-crypto-engine.yaml     | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
new file mode 100644
index 000000000000..92e1d76e29ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/qcom,inline-crypto-engine.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies, Inc. (QTI) Inline Crypto Engine
+
+maintainers:
+  - Bjorn Andersson <andersson@kernel.org>
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - qcom,sm8550-inline-crypto-engine
+      - const: qcom,inline-crypto-engine
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,sm8550-gcc.h>
+
+    crypto@1d88000 {
+      compatible = "qcom,sm8550-inline-crypto-engine",
+                   "qcom,inline-crypto-engine";
+      reg = <0x01d88000 0x8000>;
+      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+    };
+...
-- 
2.34.1

