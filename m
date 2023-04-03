Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55736C77B6C
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 20:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjDCUFn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjDCUFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 16:05:42 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB713581
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 13:05:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s13so17760949wmr.4
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2023 13:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680552338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMtS8+3vZlgnCGkT1exYxWnCIJOSzjNXrQ+UkT+wR24=;
        b=ZxRt7rkQyjmlQpCHuQGn7hMAN9N5cPyC0L6f1OXUIi/BEqX8+xK4PC05gizf8l6291
         XLX8Tn590rxE6qp4cQVfYr/7tsM4Gf9vXBoQBFf6p17QLH4z879SSQU0p+7Ac3+5VGHC
         1EFfZynRD+bFC9Spwb9iA+SNsTsE+mi5qJQ3TlZr/vsi5ekSrStQDYriph0S/h3NJH6e
         Siv4+vLlUya5JBG0AP0egDPvYRrTODRcLTOTOOrn9KoXdhiS+C8Mr5M58mJspyYWEAa7
         AfOSvp1vxuJXodkrmqOmhhE5AriOvtlvbRSC9JHM1rg3RDt6RwAWZC3O1rQGC21vW1jN
         t4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMtS8+3vZlgnCGkT1exYxWnCIJOSzjNXrQ+UkT+wR24=;
        b=QdEthDpN9AjimICJNKiA8bSYSnFcRU2+IgcScoPR1CeKdg5kEDh+glYFhx7mB4yDhb
         E3s7eGWUf59G3hgmv6SW8dnTUwTiJJPclqTYcd/e0A1bSY8IIqyd6Lb+IU7KMHM2CTKz
         pCmT98hOQtgw77eVvRXnm/3LJ1UE9j0TlKS05WHhssrbs+rWuzmVW1ZtOkvupGJ1Tgs8
         bfoMEY2FWI7frSr17tyrfLKBuwGHa1nwkF0Y2zBTHP375f0f0FOxZr+NsMwshQaAt5iT
         HBljI2FQ4gCHq+xold/J2VSRQqcniZNGgdB473yF9uUeeENfRZH8D0kihhHviKW0/iXS
         h/ng==
X-Gm-Message-State: AAQBX9f4oiiH3WkeaXYiBW+mE7+Rmu2y2qb9Tl0d3lTOOYLgMuOflaG1
        uzz3mVm9cwcmZaDRD8NhP5t7iA==
X-Google-Smtp-Source: AKy350bl6WGWzHFV0PYy6AyP4+rPWk7CLiQtYdaTG5D5DSHQbRaoYXhSPZLJp12G75Nx5czzI63sOg==
X-Received: by 2002:a1c:7918:0:b0:3db:8de:6993 with SMTP id l24-20020a1c7918000000b003db08de6993mr173588wme.4.1680552338146;
        Mon, 03 Apr 2023 13:05:38 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id iv19-20020a05600c549300b003ef69873cf1sm20798037wmb.40.2023.04.03.13.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:05:37 -0700 (PDT)
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v5 1/6] dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
Date:   Mon,  3 Apr 2023 23:05:25 +0300
Message-Id: <20230403200530.2103099-2-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403200530.2103099-1-abel.vesa@linaro.org>
References: <20230403200530.2103099-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add schema file for new Qualcomm Inline Crypto Engine driver.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---

The v4 is here:
https://lore.kernel.org/all/20230327134734.3256974-2-abel.vesa@linaro.org/

Changes since v4:
 * added Eric's R-b tag

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

