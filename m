Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C92C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 12:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLIMpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 07:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIMpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 07:45:18 -0500
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB666CBF;
        Fri,  9 Dec 2022 04:45:14 -0800 (PST)
Received: from SHSend.spreadtrum.com (shmbx06.spreadtrum.com [10.0.1.11])
        by SHSQR01.spreadtrum.com with ESMTP id 2B9Ch5nX005226;
        Fri, 9 Dec 2022 20:43:05 +0800 (+08)
        (envelope-from Zhe.Wang1@unisoc.com)
Received: from xm13705pcu.spreadtrum.com (10.13.3.189) by
 shmbx06.spreadtrum.com (10.0.1.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 9 Dec 2022 20:43:00 +0800
From:   Zhe Wang <zhe.wang1@unisoc.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>
CC:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <orsonzhai@gmail.com>, <yuelin.tang@unisoc.com>,
        <zhenxiong.lai@unisoc.com>, <zhang.lyra@gmail.com>,
        <zhewang116@gmail.com>
Subject: [PATCH v4 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
Date:   Fri, 9 Dec 2022 20:41:20 +0800
Message-ID: <20221209124121.20306-2-zhe.wang1@unisoc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209124121.20306-1-zhe.wang1@unisoc.com>
References: <20221209124121.20306-1-zhe.wang1@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.13.3.189]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 shmbx06.spreadtrum.com (10.0.1.11)
X-MAIL: SHSQR01.spreadtrum.com 2B9Ch5nX005226
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add Unisoc ums9620 ufs host controller devicetree document.

Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/ufs/sprd,ums9620-ufs.yaml        | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
new file mode 100644
index 000000000000..36a8ae77949f
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/sprd,ums9620-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Unisoc Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Zhe Wang <zhe.wang1@unisoc.com>
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    const: sprd,ums9620-ufs
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: controller_eb
+      - const: cfg_eb
+      - const: core
+
+  resets:
+    maxItems: 2
+
+  reset-names:
+    items:
+      - const: controller
+      - const: device
+
+  vdd-mphy-supply:
+    description:
+      Phandle to vdd-mphy supply regulator node.
+
+  sprd,ufs-anlg-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle of syscon used to control ufs analog regs.
+
+  sprd,aon-apb-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle of syscon used to control always-on regs.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ufs: ufs@22000000 {
+        compatible = "sprd,ums9620-ufs";
+        reg = <0x22000000 0x3000>;
+        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
+        vcc-supply = <&vddemmccore>;
+        vdd-mphy-supply = <&vddufs1v2>;
+        clocks = <&apahb_gate 5>, <&apahb_gate 22>, <&aonapb_clk 52>;
+        clock-names = "controller_eb", "cfg_eb", "core";
+        assigned-clocks = <&aonapb_clk 52>;
+        assigned-clock-parents = <&g5l_pll 12>;
+        resets = <&apahb_gate 4>, <&aonapb_gate 69>;
+        reset-names = "controller", "device";
+        sprd,ufs-anlg-syscon = <&anlg_phy_g12_regs>;
+        sprd,aon-apb-syscon = <&aon_apb_regs>;
+    };
-- 
2.17.1

