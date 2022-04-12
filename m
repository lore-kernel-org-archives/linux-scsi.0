Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5BEC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 10:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244547AbiDLKFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355045AbiDLIGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 04:06:54 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E756B4A3F3;
        Tue, 12 Apr 2022 00:37:07 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.90,253,1643641200"; 
   d="scan'208";a="117519934"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 12 Apr 2022 16:37:06 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DA0AE400F501;
        Tue, 12 Apr 2022 16:37:06 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, robh+dt@kernel.org,
        krzk+dt@kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 1/7] dt-bindings: ufs: Document Renesas R-Car UFS host controller
Date:   Tue, 12 Apr 2022 16:36:41 +0900
Message-Id: <20220412073647.3808493-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412073647.3808493-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220412073647.3808493-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document Renesas R-Car UFS host controller for R-Car S4-8 (r8a779f0).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../devicetree/bindings/ufs/renesas,ufs.yaml  | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/renesas,ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml b/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
new file mode 100644
index 000000000000..04ff0ffd6efb
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/renesas,ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas R-Car UFS Host Controller
+
+maintainers:
+  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    items:
+      - const: renesas,r8a779f0-ufs
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 2
+
+  clock-names:
+    maxItems: 2
+    items:
+      - const: fck
+      - const: ref_clk
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - power-domains
+  - resets
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a779f0-sysc.h>
+
+    ufs: scsi@e686000 {
+            compatible = "renesas,r8a779f0-ufs";
+            reg = <0xe6860000 0x100>;
+            interrupts = <GIC_SPI 235 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
+            clock-names = "fck", "ref_clk";
+            freq-table-hz = <200000000 200000000>, <38400000 38400000>;
+            power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
+            resets = <&cpg 1514>;
+    };
-- 
2.25.1

