Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CEBC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiBVPAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiBVPAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:39 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C14510E073
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:54 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4127D3FCAC
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541993;
        bh=arKzCg0MYWfR0buWW2cokaDng0neBp5ISe/OJX5gEOA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=s79/HWjw0vltJG7esBPEesb9PGJmdud05s/1suoumwCsxcDpTrK3cVJNmIfinD40G
         GS6DW74tBHkQb2T+oyzJr/2wBMpC8rxZfeaCSK8pC7ee6G3B+jGyfsbyhRMyVA9/fJ
         j3Mx6fIHDQUqbJRcorO+L2pbi0DjA+pFkqTL3pW1W57cll0x221uz+dJdOjGOecSeq
         Zcd+YMaPoHCsw9BAOpWyCzqUz/S06RUWLfbmDmnjtuqEh7xSBcahtorqz7f5tnW9VP
         yC6WB318w+IVwh0SIEzKAsAl61s7Dag5OXBwdzeILsxv9i1vhb0G2dPJ+jDk3CQjlC
         2X1p7D4pxHj8Q==
Received: by mail-ej1-f71.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so5826690ejw.9
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=arKzCg0MYWfR0buWW2cokaDng0neBp5ISe/OJX5gEOA=;
        b=mcTHhCtv6ff11akzTppzAKBCb7Ze9FtsyQenuaQBnuIrv2VCLGNC/NOwZW0CVYFNmO
         bnjMNjMGZv6CZC5O+0aFKV7RNRhI3cQD2SgZoTEHS/+V9EBQeE7mfpb7RiHptZPoX1pW
         gb1/OMCQQL+MQJuIcSvUZtTwdL0YA7teHhpxA62bBbgfrVHYf242zI0jGgC+j+QSDbnm
         gF+mpmUN+A3vLnTdN8GUrHwzYq3hhFyjVYpcfEPj8zil2AUZZkKhY9fAfkY+XRcEXbhV
         lmL+nUEx8UbhLuGloTlw2+mIP7ouNOwF5ySjpmQsdqiceEE1ViXKNIccBjANSSncMx7S
         4omQ==
X-Gm-Message-State: AOAM530AzMmsFFKuB27NhPWkZIQCA46OFEqb/X7MxoM++8KoFUHBjvbs
        lskXmikP0c6ptp3Lh+LgDHhPlUSP2UDIlNhUabeg89aONq/MyFNvSNylK2XOsTXWnZg1HcZgGG2
        e0nAGsLnV770LxGIjxCowvEYqf2Yyop0JKMGSm34=
X-Received: by 2002:a05:6402:1941:b0:413:2b5f:9074 with SMTP id f1-20020a056402194100b004132b5f9074mr2026077edz.414.1645541992922;
        Tue, 22 Feb 2022 06:59:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuGCh02ChhaQcgWP8AI9k0NhxlMiAPxSs3pga+zesBZndYOMg1ZtIGJuD44dDaZzrGAARhjg==
X-Received: by 2002:a05:6402:1941:b0:413:2b5f:9074 with SMTP id f1-20020a056402194100b004132b5f9074mr2026054edz.414.1645541992714;
        Tue, 22 Feb 2022 06:59:52 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:52 -0800 (PST)
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
Subject: [PATCH v2 08/15] dt-bindings: ufs: snps,tc-dwc-g210: convert to dtschema
Date:   Tue, 22 Feb 2022 15:58:47 +0100
Message-Id: <20220222145854.358646-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the Synopsys Universal Flash Storage (UFS) Controller to DT
schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/ufs/snps,tc-dwc-g210.yaml        | 51 +++++++++++++++++++
 .../bindings/ufs/tc-dwc-g210-pltfrm.txt       | 26 ----------
 2 files changed, 51 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/snps,tc-dwc-g210.yaml
 delete mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt

diff --git a/Documentation/devicetree/bindings/ufs/snps,tc-dwc-g210.yaml b/Documentation/devicetree/bindings/ufs/snps,tc-dwc-g210.yaml
new file mode 100644
index 000000000000..671a70d95138
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/snps,tc-dwc-g210.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/snps,tc-dwc-g210.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Universal Flash Storage (UFS) Controller
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
+          - snps,dwc-ufshcd-1.40a
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
+          - snps,g210-tc-6.00-20bit
+          - snps,g210-tc-6.00-40bit
+      - const: snps,dwc-ufshcd-1.40a
+      - const: jedec,ufs-2.0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufs@d0000000 {
+        compatible = "snps,g210-tc-6.00-40bit",
+                     "snps,dwc-ufshcd-1.40a",
+                     "jedec,ufs-2.0";
+        reg = <0xd0000000 0x10000>;
+        interrupts = <24>;
+    };
diff --git a/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
deleted file mode 100644
index 71c0777960e9..000000000000
--- a/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
+++ /dev/null
@@ -1,26 +0,0 @@
-* Universal Flash Storage (UFS) DesignWare Host Controller
-
-DWC_UFS nodes are defined to describe on-chip UFS host controllers and MPHY.
-Each UFS controller instance should have its own node.
-
-Required properties:
-- compatible	: compatible list must contain the PHY type & version:
-			"snps,g210-tc-6.00-20bit"
-			"snps,g210-tc-6.00-40bit"
-		  complemented with the Controller IP version:
-			"snps,dwc-ufshcd-1.40a"
-		  complemented with the JEDEC version:
-			"jedec,ufs-1.1"
-			"jedec,ufs-2.0"
-
-- reg		: <registers mapping>
-- interrupts	: <interrupt mapping for UFS host controller IRQ>
-
-Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
-	dwc-ufs@d0000000 {
-		compatible = "snps,g210-tc-6.00-40bit",
-			     "snps,dwc-ufshcd-1.40a",
-			     "jedec,ufs-2.0";
-		reg = < 0xd0000000 0x10000 >;
-		interrupts = < 24 >;
-	};
-- 
2.32.0

