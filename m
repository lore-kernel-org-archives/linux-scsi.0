Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECFBC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 13:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKJNjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 08:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiKJNjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 08:39:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220052EF4E;
        Thu, 10 Nov 2022 05:39:04 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 130so2106849pfu.8;
        Thu, 10 Nov 2022 05:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9YStsrv646S5/Ra0LSeQAQHXe2pFKQK80lEpe0dS19o=;
        b=oxXjzvHddNkZq6LQRRgSLZspMU/41i8WvS084Zk0F/cn7bTFt0MWP/4ROS1KShRDUG
         cja8UUh8ZQ10XGWifp4gAUFWLF/OiUOWLQiQsmyQfaCiDVENV68ygKaUi7sZ9Fh50nmM
         vyoE2DmuF/H8m8Z3EOuXwZaoYJZRax3g/njNTG++gF3KMEqbaGTueU4tnWz3A4LgWPSs
         4aw7BIDhaocekEbgr+PcQCT+tYsLV7bvsgkjushnoXIwXsgCCo3ub2hMQo6pTmXfXXe3
         sTfOKAvxQLCHYt96e0MvkKsuPn8Ac+3iL7XCeu9nGRSOt5DE2prijIx3DYQ7EqBlA19R
         NIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9YStsrv646S5/Ra0LSeQAQHXe2pFKQK80lEpe0dS19o=;
        b=6spPKktKaVxFvNdkX0nisagu8wRnjXYsbnZFKC7ViykCe0PmMdr+RDJ2YnVGmzlHwV
         MwUyMTOqTmP31DjqHTrhJ5hi4Gxm/X0+676ciu7AjV4XJ990UKSmXFugLB2rnVfCbc4+
         aCX9x/IrXx1vFPbCZaxZzjJlOapnSQ9+w7qziAhO5r/JjpKg2dVqpT74BCOwYG+H3x3t
         Mvwx4Hsgre/HwKtmD0wKmyt1dL2sc1HG+PTsTuUnqHPTKYe2UPZcw6pa1c61kQwfc1/s
         cu7Ir/ccLPIHfy31tmNlDpd2nEHjvSdX0pM4P08BCFF6hQtqUdt46a5qC9qkXHGJCKDM
         GX5A==
X-Gm-Message-State: ACrzQf3lTPfn0LfFQeDb4WoDqveypk6fnlxqyiYDwjxugQhPLmroef9k
        2QdKr0pgYI3C+R1zsVsc5z0=
X-Google-Smtp-Source: AMsMyM5+tqHwmK/Rm7F8nGQvE3BGMxgdTmIMIkvfvn68F27Jqdo8SKcjCvdb5b0ux0CJTkh5mc42HA==
X-Received: by 2002:a62:ea09:0:b0:562:a86f:63af with SMTP id t9-20020a62ea09000000b00562a86f63afmr65778003pfh.71.1668087543665;
        Thu, 10 Nov 2022 05:39:03 -0800 (PST)
Received: from xm06403pcu.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id j8-20020a170903024800b00186b758c9fasm1609045plh.33.2022.11.10.05.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:39:03 -0800 (PST)
From:   Zhe Wang <zhewang116@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
Subject: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
Date:   Thu, 10 Nov 2022 21:36:39 +0800
Message-Id: <20221110133640.30522-2-zhewang116@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221110133640.30522-1-zhewang116@gmail.com>
References: <20221110133640.30522-1-zhewang116@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhe Wang <zhe.wang1@unisoc.com>

Add Unisoc ums9620 ufs host controller devicetree document.

Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
---
 .../devicetree/bindings/ufs/sprd,ufs.yaml     | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
new file mode 100644
index 000000000000..88f2c670b0a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
@@ -0,0 +1,72 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/sprd,ufs.yaml#
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
+    enum:
+      - sprd,ums9620-ufs
+
+  clocks:
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: hclk
+      - const: hclk_source
+
+  resets:
+    maxItems: 2
+
+  reset-names:
+    items:
+      - const: ufs_soft_rst
+      - const: ufsdev_soft_rst
+
+  sprd,ufs-anly-reg-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle of syscon used to control ufs analog reg.
+
+  sprd,aon-apb-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle of syscon used to control always-on reg.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufs: ufs@22000000 {
+        compatible = "sprd,ums9620-ufs";
+        reg = <0x22000000 0x3000>;
+        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
+        vcc-supply = <&vddemmcore>;
+        vdd-mphy-supply = <&vddufs1v2>;
+        clocks-name = "ufs_eb", "ufs_cfg_eb",
+            "ufs_hclk", "ufs_hclk_source";
+        clocks = <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_CFG_EB>,
+            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
+        freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>;
+        reset-names = "ufs_soft_rst", "ufsdev_soft_rst";
+        resets = <&apahb_gate RESET_AP_AHB_UFS_SOFT_RST>,
+            <&aonapb_gate RESET_AON_APB_UFSDEV_SOFT_RST>;
+        sprd,ufs-anly-reg-syscon = <&anly_phy_g12_regs>;
+        sprd,aon-apb-syscon = <&aon_apb_regs>;
+        status = "disable";
+    };
-- 
2.17.1

