Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F9BC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbiCFLMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiCFLMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:12:43 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D8C60A9E
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:11:51 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 590073F604
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565097;
        bh=lf3L+0o9CMSrEd/gKJSlHCZX7vz5FnWuL1aM1XjlPVQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kFMHpAcI0q4R7L59BJQ86RjZnxtGY8XncUR4loWcSUFXIxj1k1kGvEe8LBQ/jRl62
         CFGGz2XOa4H0TSKPz4hVAudb0pqcZ8VM+9rlZD8weHygt18z3ZyTa1L+YKqL5e6gVN
         ZCA+d4MiRWsFp4Vt8tpEtC57ukEqO8mjpECiMasRs+AYpoVyMYY1OYbyB0p5b9DDHx
         zNjEEXQgsVZTsBDvk2+gEA4rF5TDsQvI2zWfVdn1ZcNDs0aFc0FKWOwr2lWxXVeP5Y
         xdTdQ8XSGC8iMWbtzpogD0biDEte94Qhc3KqEowNaL48qEZ6tETun3kvhK2lI/AW6m
         nvU/rnPXTYZZw==
Received: by mail-ed1-f69.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso6761589edh.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:11:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lf3L+0o9CMSrEd/gKJSlHCZX7vz5FnWuL1aM1XjlPVQ=;
        b=gk3C1ur0Afp214KUPgsPLaYq/jIvQRFSF5kuNBUjlis3UwqvcQxuPMP5o20Wlz8cfL
         q8Wturh5iPdftmdY8Ig2k1nxkXzJgfShni9VdYPHKl7gvahGr1/cnFEh+8OYdeYJ8ccb
         M2KCj5bMy9y2SdrHe4iT8oP+jMAHdm3tg/bRqKUOP+Rmy5YCsmQu7Wosrb/UhdrIynFv
         pz7DYpypEPPuh+FTewzX5BbsKABJwKAiZvmO9r1yN8WnpYzvIiWWtrrGSiW+HPDQc24i
         v35Q93fpMNsEXoxYmQW97y8qk2kJX8t2TJChHm/sahLln4cBTsQdF4wixDHgCSHgc4XP
         02DA==
X-Gm-Message-State: AOAM533GT/DfzY9TzntMNPHl6dxXpJU2iT1LfylXSjIlb0YsoOnOnUSc
        FrckVnvgOaFVEtfjL3SYzAURaIoVqx7sna67BqYTWFW1fwdbMqgcy1f8RPb4jGEt28u8nXo25PU
        +kDjCnYaO37Rf9K5Ch+EoubvKsYshdUATdh9XCwQ=
X-Received: by 2002:a05:6402:d0d:b0:416:1d69:f23b with SMTP id eb13-20020a0564020d0d00b004161d69f23bmr6273176edb.141.1646565091330;
        Sun, 06 Mar 2022 03:11:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZtXPDKuzvvxfR2qyr8z+IQLrONJ/y+63x3Fbz/V1C7LxKea28+CanHlFXHMdCVOY2o4Xmiw==
X-Received: by 2002:a05:6402:d0d:b0:416:1d69:f23b with SMTP id eb13-20020a0564020d0d00b004161d69f23bmr6273165edb.141.1646565091125;
        Sun, 06 Mar 2022 03:11:31 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:30 -0800 (PST)
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
Subject: [PATCH v3 01/12] dt-bindings: ufs: add common platform bindings
Date:   Sun,  6 Mar 2022 12:11:14 +0100
Message-Id: <20220306111125.116455-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add bindings for common parts (platform) of Universal Flash Storage
(UFS) Host Controllers in dtschema format.

Include also the bindings directory in the UFS maintainers entry.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 82 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 83 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-common.yaml

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
new file mode 100644
index 000000000000..47a4e9e1a775
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/ufs-common.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Common properties for Universal Flash Storage (UFS) Host Controllers
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+  - Avri Altman <avri.altman@wdc.com>
+
+properties:
+  clocks: true
+
+  clock-names: true
+
+  freq-table-hz:
+    items:
+      items:
+        - description: Minimum frequency for given clock in Hz
+        - description: Maximum frequency for given clock in Hz
+    description: |
+      Array of <min max> operating frequencies in Hz stored in the same order
+      as the clocks property. If this property is not defined or a value in the
+      array is "0" then it is assumed that the frequency is set by the parent
+      clock or a fixed rate clock source.
+
+  interrupts:
+    maxItems: 1
+
+  lanes-per-direction:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [1, 2]
+    default: 2
+    description:
+      Number of lanes available per direction.  Note that it is assume same
+      number of lanes is used both directions at once.
+
+  vdd-hba-supply:
+    description:
+      Phandle to UFS host controller supply regulator node.
+
+  vcc-supply:
+    description:
+      Phandle to VCC supply regulator node.
+
+  vccq-supply:
+    description:
+      Phandle to VCCQ supply regulator node.
+
+  vccq2-supply:
+    description:
+      Phandle to VCCQ2 supply regulator node.
+
+  vcc-supply-1p8:
+    type: boolean
+    description:
+      For embedded UFS devices, valid VCC range is 1.7-1.95V or 2.7-3.6V. This
+      boolean property when set, specifies to use low voltage range of
+      1.7-1.95V. Note for external UFS cards this property is invalid and valid
+      VCC range is always 2.7-3.6V.
+
+  vcc-max-microamp:
+    description:
+      Specifies max. load that can be drawn from VCC supply.
+
+  vccq-max-microamp:
+    description:
+      Specifies max. load that can be drawn from VCCQ supply.
+
+  vccq2-max-microamp:
+    description:
+      Specifies max. load that can be drawn from VCCQ2 supply.
+
+dependencies:
+  freq-table-hz: [ 'clocks' ]
+
+required:
+  - interrupts
+
+additionalProperties: true
diff --git a/MAINTAINERS b/MAINTAINERS
index d7ea92ce1b1d..ef16268b6ca6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20100,6 +20100,7 @@ R:	Alim Akhtar <alim.akhtar@samsung.com>
 R:	Avri Altman <avri.altman@wdc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/ufs/
 F:	Documentation/scsi/ufs.rst
 F:	drivers/scsi/ufs/
 
-- 
2.32.0

