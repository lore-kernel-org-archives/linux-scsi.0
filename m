Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA979C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiBVPBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiBVPAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:55 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7210810EC64
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:07 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 14F224081F
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645542004;
        bh=4tGOeE6Vpb8oaNs+KDz1VN9VoEsDCHdqvyHLI/+JDW4=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ALik62sPwpWS8Za7g28B/yBGI06HBnLIOmai/vfihXTxsduCD9tz7Tgq0rsZ/vZNp
         DiYEgnqcURBxa+AeWiF0/Z0cyr7hI36CPUcSJdN8q+itWWMjNHW5WpY6STN8bTart7
         /sQbX6h7DKkRlICIPseSiEpS8i6xggvy9AJ0cZwLSCRpuH9FREq7bPf2oxDkRKRZDl
         4ftnirG+lAiKjC3ZrJh50T9V7gJsiMzxzr+wXb3QItrSxy7E16/tC3H2XeTnvLA07E
         ZCKHWElELLmw1Lj2EGqZ0LblLLRAb1aSoa+bKDzUIn9KOy5ac+8HWLHu+pGFdvEmOu
         hqXbhbLmiIyhw==
Received: by mail-ej1-f71.google.com with SMTP id o22-20020a1709061d5600b006d1aa593787so1979485ejh.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4tGOeE6Vpb8oaNs+KDz1VN9VoEsDCHdqvyHLI/+JDW4=;
        b=2gOlrE5VxH8z28QNxFfjDP2rdob2dAKHdnr/antG1/R3C2+b6Eg7Vi/CtIsPvpiDbB
         v1VvZHXZ1p7J9ETRSYDdqiUshd6tSU/m2bOztcpD6pakGaVw+9mDDM6m1VRMliyn67vU
         GjPyRrWnfC7Kst6IGazPzw/afM2hfE+oR+9mU0Ltz0ww6sjQUCjQc8ORaTYZsNBt45hi
         Dzm9vsE0aw6u5debgkotbx+3+gxTCjMq/X+Gi0wFub6JLzC4JFSvUBZ+zwK6iZGGY6mt
         /8T2Gr1geF5rp77VChHJAVFVQsdiRiTlannRAaatXtgGW2+0umTkqjU+MpoD0hdyjpbx
         hWtw==
X-Gm-Message-State: AOAM533LFy9Htw8xtggHJHcBvTUOIUgFEbxr470lxLgAdvGWn6qjzBku
        HfJ51dFp1+y9yQSO9bGYY4Q769IEJZlN3zIc4BM81LazQ8AF1m3A/MgZOyMWKvT2Bph6Bl6VAYK
        nfUm5gnj8BnbRVtgx5xYfJSNJnc3l0JS+U92BV/E=
X-Received: by 2002:aa7:cfda:0:b0:410:aaaa:320 with SMTP id r26-20020aa7cfda000000b00410aaaa0320mr26911190edy.360.1645541989561;
        Tue, 22 Feb 2022 06:59:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxh7yewuGQzlFhBRvYx0VSbUW/aGZFnH2j0pyBL985ZqnUYO1c9cthLLmadhlhhpXgOFIy8rw==
X-Received: by 2002:aa7:cfda:0:b0:410:aaaa:320 with SMTP id r26-20020aa7cfda000000b00410aaaa0320mr26911156edy.360.1645541989384;
        Tue, 22 Feb 2022 06:59:49 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:48 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 06/15] dt-bindings: ufs: hisilicon,ufs: convert to dtschema
Date:   Tue, 22 Feb 2022 15:58:45 +0100
Message-Id: <20220222145854.358646-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the HiSilicon Universal Flash Storage (UFS) Controller to DT
schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/ufs/hisilicon,ufs.yaml           | 90 +++++++++++++++++++
 .../devicetree/bindings/ufs/ufs-hisi.txt      | 42 ---------
 2 files changed, 90 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml
 delete mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt

diff --git a/Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml b/Documentation/devicetree/bindings/ufs/hisilicon,ufs.yaml
new file mode 100644
index 000000000000..3e3bf7d2df55
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
+            freq-table = <0 0>,
+                         <0 0>;
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

