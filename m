Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E62E29E0EC
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753946170; cv=none; b=ANXJJNZoOsTWrKyD0ukrVe7oElaBRR7vf0KV/IXNB40VJf27JJN3mnj8pB48XLB3EGWRlDaLTob1H9hIDWpevipwIHcahO37FogUe5MsD/tOVy+QIOqEnPiEpPQAFrUoayeihMAGGjZWvT8NlAv+V2nzQWURAuw3pQu12Buw1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753946170; c=relaxed/simple;
	bh=m4Q58xqf9/x4E0jlUz4rpnXUwO4kR+noNYCXUYqKHk0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U7UthrWpX5bmfNW0TmaAcgpwyXNIN4lUtaSiODZ1xEB864booI6UNl/+DWO8bp9M1f5qtvnC38lPMk3HmmWc4dANN6SouCfyens526EHaAauRrMzOaDBFYBeOHXhdV9FvK5U2W+L0Vt8AXLmjltVk1Az1bHWyzA6fk8Hf6ao1qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=INqFFHFB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="INqFFHFB"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b78ae64756so10740f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 00:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753946166; x=1754550966; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Th90s93dptO85T/mQtVXLdgDB41QrPyKFC7Dy2GHecI=;
        b=INqFFHFBgGxqvDQGTYrLbcMoqvtZSBLAWdmO5+1xV0KU5R68FLygPmaUNnNvAXzHGV
         A5JRNxEE0QFDqYj+jUeQNDe47EL+Xzpx0Q89s6As0WKcv/NTw7xufkvuhZRCEF3X1OB5
         xvyXJi41XiayikkN7PSOLnOCG3bgmSPKsS29sOsoWog67J4arYYc3kHFvqkG2Qays1ve
         v90XMJjOFRjz9aPB4j2m18MHvKzlywu2rXnTcaIjETRO6KmCMhCoikbtSmVhGbRQzrpN
         UMApBRpj4y9Uh2NBMlnzU02Ufe518JHrc43X6lRgVvKXB6l3QZXaw+GHQtSQRymVF4yO
         bnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753946166; x=1754550966;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Th90s93dptO85T/mQtVXLdgDB41QrPyKFC7Dy2GHecI=;
        b=cWP/NAVxAZ3jRJ6taiXixqIuB8D+6IcxNFlqLOs/sUEq6bebX2sYKAghJ/v0oWU0EG
         urVdYUTenH9bgOogrWI6BH0/ino+TpVNefwFqW5nwHXlvvOP9Kv4qx0G8f6l3OFM8X0O
         VcelOqywny0vCTQfW0SBlzfViGRLwpS/YWk3Lj9nwqxHI83JyA1idNEH7SWZ8ghD6PRv
         gezpcGE9Q30L8+IXzGInulMlkxRuyiNCrEQ2KmGEx10BXwkhoQv+QtascponP/bAJAyM
         6uB9p6XIp1SPCDxY+siDtHBJZQCaaC1cG7wFImUdxhN5pN9c2Z0H7vhbPWaVmU44j6R2
         T3Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUnzWKlkvhuK7hnTz9YQq4cPGzaygU6EUHepdn7B5LUiCd6YGFNudt9EAMz8FGUKPmwrFNFY4K/H3Us@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5t6FL/B4ePdGXPheOmd2+NyqKVjRNJss3YpsGhQi7CH4BDMOk
	j27Tl1iTAWzmm3bNTx4QL3BCc8HOVR+7LpXnntAjYt5jWAb3w+LZZ/6u3FVOf++hnwk=
X-Gm-Gg: ASbGncsB8smZG4DAbt+Izt8BYzZYFuUEBdljVy1lTFdzmMqqzEtuwM4VUa9q6C5o3nt
	MigDWQKR+nIJ4ZnXvPuiM21rEj1pLwjykgLxU6Fki/vGALbXSw9sYld5RoCdtBNS+v+1pL4Px7n
	OsWkOUAMTjiIuhCaVuXDpGGx023Lrdu7Gf32BRsEKF/C/6Focxvh2O0wJkyyCmxMNRluICxK5iR
	jV6swHWfpePvdePUgexUMzRsU+dPWNOlO8Xyk5fCSCAeDxwX0hS68Bj5QGWU6QjbUASABPErNWy
	wp8f8hF85LQgreGUPhLStrbQ/qiwHOT6b3933US/bs63rLVeVeqZKtYTACx5Og+MB3PmR9Zbv9/
	KO/NxX7ZGuHVFAUtlPI75TqGTAvZSPKpcnKGP3js=
X-Google-Smtp-Source: AGHT+IFHoBRIn9mfQGbL5mI3ID9nYuUwh9NPEx0zHR3qVguO0qoABtm0LpJfgXYr4o9mY6Gylf5cfA==
X-Received: by 2002:a05:6000:2383:b0:3b7:8b43:ac7d with SMTP id ffacd0b85a97d-3b794fc0779mr1676031f8f.3.1753946166381;
        Thu, 31 Jul 2025 00:16:06 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.218.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47ae8esm1353483f8f.61.2025.07.31.00.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 00:16:05 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 31 Jul 2025 09:15:54 +0200
Subject: [PATCH v2 3/3] dt-bindings: ufs: qcom: Split SM8650 and similar
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-dt-bindings-ufs-qcom-v2-3-53bb634bf95a@linaro.org>
References: <20250731-dt-bindings-ufs-qcom-v2-0-53bb634bf95a@linaro.org>
In-Reply-To: <20250731-dt-bindings-ufs-qcom-v2-0-53bb634bf95a@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8603;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=m4Q58xqf9/x4E0jlUz4rpnXUwO4kR+noNYCXUYqKHk0=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBoixgvSf90OB3oyLSCdRTgI1O1KtbPcZh2rWUMe
 uiBfXwVx46JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaIsYLwAKCRDBN2bmhouD
 16xjD/9hofBF29vglaxv/+fCMf1vugvzZliqr08i1pEj8x1+VTFwn/QEQWNiPDQO2+TxTMr0uOJ
 xMAsZExfNQtyABjS3jGytOBAAT7M6CTfhdb73dn8cMLV4pr/64208LFlveU+00imNXkXKiYapMn
 YmaC6RA5gfy3bWkkNNkz3Ytzq/hNjBaOcvHR+RNjebdjOT7oZLa6qOsHAgCTzIHIp6vrLTCmTYA
 hGqlIGyHGqUe+ExLf2oYUCs/lYespdCI5S1dKCNfaDW2mYujqlLnxiETcRuFXH8OxQ96KT+4d8e
 OvAPSiQdLLKjx83rMU7Klv4b9mpvCDrJmdX+Y2liug2OlrxI3hIr1UhXCTOmcc946CJsYXAzwTs
 kcWUSyp2c/8DpUTzZhm7qHDOo3G64nz673r8NudR27oWryrbzYnyA1ox7B46+73HvAu9AFRGP+v
 fcla15kkOjt3BvTwe2koSN7ndTWPOKVFFmLxpFANvcqQXiAr7oieKH7Tcexz05LF+hjlcWTSDpm
 d/pjwWN9UPasnuzGq0vRiVJx7wwM767IHrgCEn0OxJtRE82JbDTQA7OSz7LniCtYqI/BWrarwzU
 rjGQkdsUwSO+vjxcWcLbVmRRa64pwz9Il868JHCcs3+2fFI+SxssOoX6XKVSZz+5EidDgWzK3CM
 VdMAXh2tLjtRdsw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

The binding for Qualcomm SoC UFS controllers grew and it will grow
further.  Split SM8650 and SM8750 UFS controllers which:
1. Do not reference ICE as IO address space, but as phandle,
2. Have same order of clocks.
3. Have MCQ IO address space. Document that MCQ address space as
   optional to maintain backwards compatibility and because Linux
   drivers can operate perfectly fine without it (thus without MCQ
   feature).  Linux driver already uses "mcq" as possible name for
   "reg-names" property.

The split allows easier review and maintenance of the binding.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 178 +++++++++++++++++++++
 .../devicetree/bindings/ufs/qcom,ufs.yaml          |  32 ----
 2 files changed, 178 insertions(+), 32 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
new file mode 100644
index 0000000000000000000000000000000000000000..aaa0bbb5bfe1673e3e0d25812c2829350b137abb
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -0,0 +1,178 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/qcom,sm8650-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm SM8650 and Other SoCs UFS Controllers
+
+maintainers:
+  - Bjorn Andersson <bjorn.andersson@linaro.org>
+
+# Select only our matches, not all jedec,ufs-2.0
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - qcom,sm8650-ufshc
+          - qcom,sm8750-ufshc
+  required:
+    - compatible
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - qcom,sm8650-ufshc
+          - qcom,sm8750-ufshc
+      - const: qcom,ufshc
+      - const: jedec,ufs-2.0
+
+  reg:
+    minItems: 1
+    maxItems: 2
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: std
+      - const: mcq
+
+  clocks:
+    minItems: 8
+    maxItems: 8
+
+  clock-names:
+    items:
+      - const: core_clk
+      - const: bus_aggr_clk
+      - const: iface_clk
+      - const: core_clk_unipro
+      - const: ref_clk
+      - const: tx_lane0_sync_clk
+      - const: rx_lane0_sync_clk
+      - const: rx_lane1_sync_clk
+
+  qcom,ice:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the Inline Crypto Engine node
+
+required:
+  - compatible
+  - reg
+
+allOf:
+  - $ref: qcom,ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,sm8650-gcc.h>
+    #include <dt-bindings/clock/qcom,sm8650-tcsr.h>
+    #include <dt-bindings/clock/qcom,rpmh.h>
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interconnect/qcom,icc.h>
+    #include <dt-bindings/interconnect/qcom,sm8650-rpmh.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        ufshc@1d84000 {
+            compatible = "qcom,sm8650-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
+            reg = <0x0 0x01d84000 0x0 0x3000>;
+
+            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
+
+            clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+                     <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+                     <&gcc GCC_UFS_PHY_AHB_CLK>,
+                     <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+                     <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
+                     <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+                     <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+                     <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+            clock-names = "core_clk",
+                          "bus_aggr_clk",
+                          "iface_clk",
+                          "core_clk_unipro",
+                          "ref_clk",
+                          "tx_lane0_sync_clk",
+                          "rx_lane0_sync_clk",
+                          "rx_lane1_sync_clk";
+
+            resets = <&gcc GCC_UFS_PHY_BCR>;
+            reset-names = "rst";
+            reset-gpios = <&tlmm 210 GPIO_ACTIVE_LOW>;
+
+            interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+                             &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+                            <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+                             &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+            interconnect-names = "ufs-ddr",
+                         "cpu-ufs";
+
+            power-domains = <&gcc UFS_PHY_GDSC>;
+            required-opps = <&rpmhpd_opp_nom>;
+
+            operating-points-v2 = <&ufs_opp_table>;
+
+            iommus = <&apps_smmu 0x60 0>;
+
+            lanes-per-direction = <2>;
+            qcom,ice = <&ice>;
+
+            phys = <&ufs_mem_phy>;
+            phy-names = "ufsphy";
+
+            #reset-cells = <1>;
+
+            vcc-supply = <&vreg_l7b_2p5>;
+            vcc-max-microamp = <1100000>;
+            vccq-supply = <&vreg_l9b_1p2>;
+            vccq-max-microamp = <1200000>;
+
+            ufs_opp_table: opp-table {
+                compatible = "operating-points-v2";
+
+                opp-100000000 {
+                    opp-hz = /bits/ 64 <100000000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <100000000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>;
+                    required-opps = <&rpmhpd_opp_low_svs>;
+                };
+
+                opp-201500000 {
+                    opp-hz = /bits/ 64 <201500000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <201500000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>;
+                    required-opps = <&rpmhpd_opp_svs>;
+                };
+
+                opp-403000000 {
+                    opp-hz = /bits/ 64 <403000000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <403000000>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>,
+                             /bits/ 64 <0>;
+                    required-opps = <&rpmhpd_opp_nom>;
+                };
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 191b88120d139a47632e3dce3d3f3a37d7a55c72..1dd41f6d5258014d59c8c8005bc54f7994351a52 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -24,8 +24,6 @@ select:
           - qcom,sm6125-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
-          - qcom,sm8650-ufshc
-          - qcom,sm8750-ufshc
   required:
     - compatible
 
@@ -41,8 +39,6 @@ properties:
           - qcom,sm6125-ufshc
           - qcom,sm6350-ufshc
           - qcom,sm8150-ufshc
-          - qcom,sm8650-ufshc
-          - qcom,sm8750-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
 
@@ -66,34 +62,6 @@ required:
 allOf:
   - $ref: qcom,ufs-common.yaml
 
-  - if:
-      properties:
-        compatible:
-          contains:
-            enum:
-              - qcom,sm8650-ufshc
-              - qcom,sm8750-ufshc
-    then:
-      properties:
-        clocks:
-          minItems: 8
-          maxItems: 8
-        clock-names:
-          items:
-            - const: core_clk
-            - const: bus_aggr_clk
-            - const: iface_clk
-            - const: core_clk_unipro
-            - const: ref_clk
-            - const: tx_lane0_sync_clk
-            - const: rx_lane0_sync_clk
-            - const: rx_lane1_sync_clk
-        reg:
-          minItems: 1
-          maxItems: 1
-        reg-names:
-          maxItems: 1
-
   - if:
       properties:
         compatible:

-- 
2.48.1

