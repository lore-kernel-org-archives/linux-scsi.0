Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59914C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiCFLOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbiCFLNm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:13:42 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C58D7668
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:12:29 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 17E6A3F612
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565122;
        bh=Vg8tRLsLvpBSAUpunNCltvlBq0IRIqfiwZSZWoN0aPY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Lp6+Ssrw4c/Ugq02Ls01T7e/7HbZ4WB/VY5Hp61grXA++qrdoRE2fBhnVb+UC/LZR
         fiYt/ME87rlbsrSf6NZvmzMyZJ7ym1oB9xhYQ1V5WWOXzM3JP5l0UmBg6KwnBBgKpD
         /QkFCerAKNlcOc0dznRPjcbadRVZeOkEnoxDLHDfa6oExz4mRknCWqB3SlUL/hyxLF
         i0mrfg6ulifGzPA0ML7DluyecJDY7DRb1zOd3178yhliI0ABRSNhlWbL9JpioTEjh6
         oG9pz5WhJL3k6OIvLMQOCiShPewoqpKp0dWZDdmewA6wKgxeHDcOqPAxGs8YzQa+IL
         yOgkc4PAM7bkw==
Received: by mail-ed1-f71.google.com with SMTP id co2-20020a0564020c0200b00415f9fa6ca8so3281586edb.6
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vg8tRLsLvpBSAUpunNCltvlBq0IRIqfiwZSZWoN0aPY=;
        b=1vAfWIzZustclPTO/Kk4VOePcCt+Hh19va8F4rhHBWEXPmYa2PURP0ejlGOCB95UQJ
         ckIQ6wDQyObd33VgUG9GyoiVlZ1hJAFGrGg+nhTQoUScqpPHrOFGCvOuoAbEbq0ZBxxd
         iRxLF6HYnAzNb+lMMuvY3xxiooou9LSrkaFHAAPU0Rk9m6G/dUna5TwucEjsBZRCymZW
         eNHXYgTjN43lKDj21WuS0oFeDDJUe4Q1fOJdyM9Qg4eZNaoZHD4F5EfLyPxDQIPjhl6O
         MfVjwrmtFIeS0ceo+6jcMA6b7TYNGrLe1tVh/K03eF71HVRAiML0Zwj5gdYqt43hVuf0
         A3Qw==
X-Gm-Message-State: AOAM533TT0zzqAJznTJQJA0OclGdOQnI0UuEPUEmggpu6BuYZDir6EEm
        E5C1SCt63rGi93lBtvQ4aqB03gSmRp7egTZ6d0PreWvcTWQLbfe9z/Vz7D5lUtQM9v32ECJC6HW
        K1ma9Htzip97JqDQoUVyZiUwaFP9HtwqbOjk7AGU=
X-Received: by 2002:a17:906:974e:b0:6bb:4f90:a6ae with SMTP id o14-20020a170906974e00b006bb4f90a6aemr5639442ejy.452.1646565100150;
        Sun, 06 Mar 2022 03:11:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg9GrLl2vImMKicyylrKdSYL2GcjHe67LtxvgKYKieQMgGqw6UjbbuYj5qEBZ/bq+RTQ8lpA==
X-Received: by 2002:a17:906:974e:b0:6bb:4f90:a6ae with SMTP id o14-20020a170906974e00b006bb4f90a6aemr5639419ejy.452.1646565099880;
        Sun, 06 Mar 2022 03:11:39 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:39 -0800 (PST)
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
Subject: [PATCH v3 06/12] dt-bindings: ufs: hisilicon,ufs: convert to dtschema
Date:   Sun,  6 Mar 2022 12:11:19 +0100
Message-Id: <20220306111125.116455-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the HiSilicon Universal Flash Storage (UFS) Controller to DT
schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/ufs/hisilicon,ufs.yaml           | 90 +++++++++++++++++++
 .../devicetree/bindings/ufs/ufs-hisi.txt      | 42 ---------
 2 files changed, 90 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml
 delete mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt

diff --git a/Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml b/Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml
new file mode 100644
index 000000000000..4432bfa0cbc7
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml
@@ -0,0 +1,90 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/hisilicon,ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: HiSilicon Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Li Wei <liwei213@huawei.com>
+
+# Select only our matches, not all jedec,ufs
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - hisilicon,hi3660-ufs
+          - hisilicon,hi3670-ufs
+  required:
+    - compatible
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - const: hisilicon,hi3660-ufs
+          - const: jedec,ufs-1.1
+      - items:
+          - enum:
+              - hisilicon,hi3670-ufs
+          - const: jedec,ufs-2.1
+
+  clocks:
+    minItems: 2
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: ref_clk
+      - const: phy_clk
+
+  reg:
+    items:
+      - description: UFS register address space
+      - description: UFS SYS CTRL register address space
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: rst
+
+required:
+  - compatible
+  - reg
+  - resets
+  - reset-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/hi3670-clock.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        ufs@ff3c0000 {
+            compatible = "hisilicon,hi3670-ufs", "jedec,ufs-2.1";
+            reg = <0x0 0xff3c0000 0x0 0x1000>,
+                  <0x0 0xff3e0000 0x0 0x1000>;
+            interrupt-parent = <&gic>;
+            interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
+                     <&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
+            clock-names = "ref_clk", "phy_clk";
+            freq-table-hz = <0 0>,
+                            <0 0>;
+
+            resets = <&crg_rst 0x84 12>;
+            reset-names = "rst";
+        };
+    };
diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
deleted file mode 100644
index 0b83df1a5418..000000000000
--- a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
+++ /dev/null
@@ -1,42 +0,0 @@
-* Hisilicon Universal Flash Storage (UFS) Host Controller
-
-UFS nodes are defined to describe on-chip UFS hardware macro.
-Each UFS Host Controller should have its own node.
-
-Required properties:
-- compatible        : compatible list, contains one of the following -
-					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
-					host controller present on Hi3660 chipset.
-					"hisilicon,hi3670-ufs", "jedec,ufs-2.1" for hisi ufs
-					host controller present on Hi3670 chipset.
-- reg               : should contain UFS register address space & UFS SYS CTRL register address,
-- interrupts        : interrupt number
-- clocks	        : List of phandle and clock specifier pairs
-- clock-names       : List of clock input name strings sorted in the same
-					order as the clocks property. "ref_clk", "phy_clk" is optional
-- freq-table-hz     : Array of <min max> operating frequencies stored in the same
-                      order as the clocks property. If this property is not
-                      defined or a value in the array is "0" then it is assumed
-                      that the frequency is set by the parent clock or a
-                      fixed rate clock source.
-- resets            : describe reset node register
-- reset-names       : reset node register, the "rst" corresponds to reset the whole UFS IP.
-
-Example:
-
-	ufs: ufs@ff3b0000 {
-		compatible = "hisilicon,hi3660-ufs", "jedec,ufs-1.1";
-		/* 0: HCI standard */
-		/* 1: UFS SYS CTRL */
-		reg = <0x0 0xff3b0000 0x0 0x1000>,
-			<0x0 0xff3b1000 0x0 0x1000>;
-		interrupt-parent = <&gic>;
-		interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
-			<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
-		clock-names = "ref_clk", "phy_clk";
-		freq-table-hz = <0 0>, <0 0>;
-		/* offset: 0x84; bit: 12  */
-		resets = <&crg_rst 0x84 12>;
-		reset-names = "rst";
-	};
-- 
2.32.0

