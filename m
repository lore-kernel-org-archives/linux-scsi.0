Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55950C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiCFLOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiCFLNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:13:44 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAF037006
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:12:33 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 360E33F636
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565131;
        bh=ooKaXowXEnZxahywb1wfZAg4AWHbsKObfN/Ew6XXXRw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cEPsw94i0f7PA7UR4VWlCfX15VWwUzsnBKjGag1gLRvMEmOCHvGXBA0PljgI/kuVI
         dn/pyHXxozef/77N9vtpIIXjB2I5zmY12e2vJ2HvmpN80VVWxm1EeJxHbEKHxVtago
         A3oSfQV/vJh2bqukG5PxK1i0ACUDE/NPLYpzt8MK1ZYtyd5ya1GGElkLa7y3d0/Hen
         K2auwQgyw8JxIOr0PnorxSvq//egamr9eJl0EnHgcxWpkm+ZLrO8byON2Eos+HtPYE
         oMzXAEAAUMHCQg59WBdMPyLx3Oea0i83X8OGmoubok1mwksUpxq3skPsIKuBIwqESY
         M/KhrBpZfde7A==
Received: by mail-ed1-f69.google.com with SMTP id h17-20020a05640250d100b004133863d836so6778553edb.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:12:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ooKaXowXEnZxahywb1wfZAg4AWHbsKObfN/Ew6XXXRw=;
        b=VDQZIc8I28lWhz+rSkuUx7OZQa9WnNfJ4DzWdkHeRiGl/NpiooRdermPvtNhoT64VD
         SwC/81x9WWIWMy7Ft1UPvbEepnVwYsU9ZrxTBxOl8S8o41u1bPdMivDyLGkGKIBtgiyS
         QF0lmgIhDkccW9uuR/k1oPdcF3jIYuL6igdbcKnwFFpCG+TiZjpWK9Mn02gBRDcrUzKG
         mmJd/+Le82/sbfAoDVZBcW0bNTG+rtdb8KtqYVj1j5mL3a217QSxrMDWtnG47tYpjWzA
         azyf6fLNnm8e0i36eVntZXLO+0xOSu/quyRMJkbjkGD/UjHYKdbW6vfY0+nLwB4McXKn
         KqFA==
X-Gm-Message-State: AOAM531F3inIRqxW8n2I/QVOHkT4pFuJdBM6nDi5xTIaVkY6/0gd+HPX
        +xWQ9ulwTa20MLixr3mee8aUj+JJs/WQG1hNK636I+JBv7057CNwTsGRLeGx71+uZUeiEMNfoXi
        pDKp3Kml1H08Few2cwB+dAW7R7wQc/swM+kJDKlU=
X-Received: by 2002:a17:906:1ec3:b0:6cf:d118:59e2 with SMTP id m3-20020a1709061ec300b006cfd11859e2mr5452643ejj.767.1646565103212;
        Sun, 06 Mar 2022 03:11:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZ1ed4qzxBbYzHrlnD8XX/sT7klp5jhLS9V8sQLJhk1P830VQKhrTEknvYCZVGqRqW8eDEQg==
X-Received: by 2002:a17:906:1ec3:b0:6cf:d118:59e2 with SMTP id m3-20020a1709061ec300b006cfd11859e2mr5452623ejj.767.1646565102968;
        Sun, 06 Mar 2022 03:11:42 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:42 -0800 (PST)
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
Subject: [PATCH v3 08/12] dt-bindings: ufs: snps,tc-dwc-g210: convert to dtschema
Date:   Sun,  6 Mar 2022 12:11:21 +0100
Message-Id: <20220306111125.116455-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the Synopsys Universal Flash Storage (UFS) Controller to DT
schema format.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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

