Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D06C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiCFLNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiCFLNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:13:05 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD160CF5
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:12:10 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EF69F3F5FC
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565109;
        bh=XXqgQ+cuaWzLih+IxYNjcqnJP94TLIhig/Ow2N98IAk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Ksukk3Gw1sXcvvpIQF4GFGvaA9Dp6llUwkfwwXoJ64N5vCT5b4QzpsgGtMJsdkl7N
         mHuCeq+z1gjgakSs/h14xCWPY84JY8LxNTSrvVr5m1GHJwHwbOaUVFZpiVPlhI1pyP
         8UhkVila2yHS0itmKgyEEiHsk0cR/Ty3CBiLQFVqCjbf6WG4itV21I21vUjRRDvq9u
         J2r+v66mpF7c3y4mJl98RNyJSmBMHEftwigUFp47NgAHzn6JFiBtjsAz6BPPw4/5Yx
         6CkOm/si2XMZKXgofFqyAfu9ZSmrZ63P0btdh4oFSgSA6Idl8UJYBTNeaS95OC6IlD
         FmEJQlSdZES+A==
Received: by mail-ej1-f71.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso6126004ejk.17
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:11:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXqgQ+cuaWzLih+IxYNjcqnJP94TLIhig/Ow2N98IAk=;
        b=umUPqYJpT4513BX4PMuzAl4qtqHpAH3jngqh8nWgdiTKNUjGDaw8aKM75yRwuYyIuK
         /fi71j33gmfY2qYdVMd7LGBUF8roCzkp058SgTaQ8Xj4oe2n5CTTMYGLTvHUKfKjgH5j
         FBSRgia3guELkr9s4a77t83GdL5fC8pJ4qxeFg/5wtGPB2hIVrtIsRy4asZJIXqHRpkf
         9XRT5RPoiSxihsSE/IeifwK6lxNtd2QZFZH6fV+QtevnUuLaOauYidtjFHrFoevFg3U8
         8N2LgwDAdAzsJgKswmRg8fVxjX5bCKeUg0qbLc/i45l+QAHFCxs6ivT+9maPu4LqvoVp
         YNpg==
X-Gm-Message-State: AOAM533Odrcah4M1w+U/1+LT9Z8xmNWTkAo0lw/Mm11dC3GZ8TeHa7ux
        PkHKNDxTpqIMUTw9Y1yIZG3NKZMcc6TqB/Az23F3OxEwOQt40mIIl7A7LTM8DoAQaLI2GE/IGK8
        YSJggUjNEYSexVe/m+s2Sf6Kd1Eg2Ojf9GtDdX60=
X-Received: by 2002:a05:6402:424b:b0:40f:1386:5fa6 with SMTP id g11-20020a056402424b00b0040f13865fa6mr6352595edb.268.1646565094789;
        Sun, 06 Mar 2022 03:11:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXebW2FRHxJVYm8J3fXHmnRdTAf7ZamehBdj0d6YMfLqjOEMT1nQnh5DIuu0Stinsuh9xtgw==
X-Received: by 2002:a05:6402:424b:b0:40f:1386:5fa6 with SMTP id g11-20020a056402424b00b0040f13865fa6mr6352563edb.268.1646565094576;
        Sun, 06 Mar 2022 03:11:34 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:33 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Cc:     Rob Herring <robh@kernel.org>
Subject: [PATCH v3 03/12] dt-bindings: ufs: cdns,ufshc: convert to dtschema
Date:   Sun,  6 Mar 2022 12:11:16 +0100
Message-Id: <20220306111125.116455-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the Cadence Universal Flash Storage (UFS) Controlle to DT schema
format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/ufs/cdns,ufshc.txt    | 32 ---------
 .../devicetree/bindings/ufs/cdns,ufshc.yaml   | 68 +++++++++++++++++++
 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml |  7 +-
 3 files changed, 71 insertions(+), 36 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
 create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
deleted file mode 100644
index 02347b017abd..000000000000
--- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
+++ /dev/null
@@ -1,32 +0,0 @@
-* Cadence Universal Flash Storage (UFS) Controller
-
-UFS nodes are defined to describe on-chip UFS host controllers.
-Each UFS controller instance should have its own node.
-Please see the ufshcd-pltfrm.txt for a list of all available properties.
-
-Required properties:
-- compatible	: Compatible list, contains one of the following controllers:
-			"cdns,ufshc" - Generic CDNS HCI,
-			"cdns,ufshc-m31-16nm" - CDNS UFS HC + M31 16nm PHY
-		  complemented with the JEDEC version:
-			"jedec,ufs-2.0"
-
-- reg		: Address and length of the UFS register set.
-- interrupts	: One interrupt mapping.
-- freq-table-hz	: Clock frequency table.
-		  See the ufshcd-pltfrm.txt for details.
-- clocks	: List of phandle and clock specifier pairs.
-- clock-names	: List of clock input name strings sorted in the same
-		  order as the clocks property. "core_clk" is mandatory.
-		  Depending on a type of a PHY,
-		  the "phy_clk" clock can also be added, if needed.
-
-Example:
-	ufs@fd030000 {
-		compatible = "cdns,ufshc", "jedec,ufs-2.0";
-		reg = <0xfd030000 0x10000>;
-		interrupts = <0 1 IRQ_TYPE_LEVEL_HIGH>;
-		freq-table-hz = <0 0>, <0 0>;
-		clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
-		clock-names = "core_clk", "phy_clk";
-	};
diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
new file mode 100644
index 000000000000..d227dea368be
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/cdns,ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Cadence Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Jan Kotas <jank@cadence.com>
+
+# Select only our matches, not all jedec,ufs-2.0
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - cdns,ufshc
+          - cdns,ufshc-m31-16nm
+  required:
+    - compatible
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - cdns,ufshc
+            # CDNS UFS HC + M31 16nm PHY
+          - cdns,ufshc-m31-16nm
+      - const: jedec,ufs-2.0
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core_clk
+      - const: phy_clk
+      - const: ref_clk
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ufs@fd030000 {
+        compatible = "cdns,ufshc", "jedec,ufs-2.0";
+        reg = <0xfd030000 0x10000>;
+        interrupts = <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>;
+        freq-table-hz = <0 0>, <0 0>;
+        clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
+        clock-names = "core_clk", "phy_clk";
+    };
diff --git a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
index 4d13e6bc1c50..c5eca7735f76 100644
--- a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
@@ -47,11 +47,10 @@ required:
 
 patternProperties:
   "^ufs@[0-9a-f]+$":
-    type: object
+    $ref: cdns,ufshc.yaml
     description: |
-      Cadence UFS controller node must be the child node. Refer
-      Documentation/devicetree/bindings/ufs/cdns,ufshc.txt for binding
-      documentation of child node
+      Cadence UFS controller node must be the child node.
+    unevaluatedProperties: false
 
 additionalProperties: false
 
-- 
2.32.0

