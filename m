Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7750FC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 18:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbiBSSnE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 13:43:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242886AbiBSSm7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 13:42:59 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF4B26AEF
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:39 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9DDAD405F2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645296152;
        bh=WPcW8NWUMCzy2JTNuQQQREfZ+SUwrjpg/KLSIOSfPWo=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=dIE7OXzALGMegPGqgiirxA7+MRzQLzAPgcJa8j2jJF2WmOP7UqJMfc0Yr9thnDdgd
         Ikpg2Xa8S9yePuQ/5Eeq65MN2DZXQXjiTSKlQjuMU/SkFYl+qbG/CJrXqmpgL2WtmN
         RcQ1++fL8jymgGE+BXS12L0R4MCwHmFwZzvHooXLdiNISMFTRPeJCcFcgk8uWvhZt4
         F1NapdLuzJ3xDcR2AdhzE43lc2UK9Mw89zLkhJv+9VxL3OT3SXw3T14zA6xB4a5B6C
         V6BB3R4d3iXxSHWGEoWxcFKwa0Ii+f4JSsZVDsXl9m6lD3PKHLfVoADPM8fcsubLdt
         KhA4DkmaeB3Wg==
Received: by mail-ed1-f71.google.com with SMTP id eq13-20020a056402298d00b00412cfa4bb0eso2771703edb.7
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPcW8NWUMCzy2JTNuQQQREfZ+SUwrjpg/KLSIOSfPWo=;
        b=76EZXmcgURC+Mswl8hJbR0TfzqQMIn5y3EgsokjoZ7L6hRxpx4crzK6ZpgsOYU6try
         Sf4fijxi/0SpN7hUUzBDqXxoUEQuZ9NnX6pz21GJEtEgeo7iUqusdH6rMP5hepLOcnpt
         IseYdbM9mtjh//eGRlmnyz9Uh2qbab5seW3uJWMHphRReNERKcqasvgEG/Xe6skTbbcM
         okdHNz4UHUZY6Nt6PaDNdM2qPqOYeGWOyE2Gl6ydDZ8ZepP82px9d83YL2cr1Mw6Ql8s
         J3TBm9miZSDPG3r5Oa123WdJa2JKZUc6nQG+35nZReK64RhQIf9FJ8QmWDCt9NNTeL4A
         9Crw==
X-Gm-Message-State: AOAM532O3qxoP+kT7eBB0UqUr2B/0A9GeDZV+DHSB9gI8cQRb/NU5ja8
        eVV4ZGZDsJWVWcEBsFv+vTIYy/4P4Uz+R1NcBidafVUrA4evMZs9eLmwuRBBEAr79t1fZfsMiLa
        Fstx/XTW5abMqARcZymNCnwUVOnXYWqY2ocr8T6o=
X-Received: by 2002:a05:6402:294e:b0:40f:905b:dab5 with SMTP id ed14-20020a056402294e00b0040f905bdab5mr13853824edb.103.1645296152248;
        Sat, 19 Feb 2022 10:42:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5GhfIf0huNIJ/pQcpXPASV6pT9kSKCqt7N4u74cDFIfTjfwRFcQoz1nbzofCZtXrbD3dyZw==
X-Received: by 2002:a05:6402:294e:b0:40f:905b:dab5 with SMTP id ed14-20020a056402294e00b0040f905bdab5mr13853807edb.103.1645296152062;
        Sat, 19 Feb 2022 10:42:32 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id j8sm6680745edw.40.2022.02.19.10.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 10:42:31 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Xu <xuwei5@hisilicon.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [RFC PATCH 3/8] dt-bindings: ufs: cdns,ufshc: convert to dtschema
Date:   Sat, 19 Feb 2022 19:42:19 +0100
Message-Id: <20220219184224.44339-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
References: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the Cadence Universal Flash Storage (UFS) Controlle to DT schema
format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/ufs/cdns,ufshc.txt    | 32 -----------
 .../devicetree/bindings/ufs/cdns,ufshc.yaml   | 56 +++++++++++++++++++
 2 files changed, 56 insertions(+), 32 deletions(-)
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
index 000000000000..68ae5663cd25
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
@@ -0,0 +1,56 @@
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
+  reg:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: core_clk
+      - const: phy_clk
+      - const: ref_clk
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
+        freq-table = <0 0 0 0>;
+        clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
+        clock-names = "core_clk", "phy_clk";
+    };
-- 
2.32.0

