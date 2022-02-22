Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48772C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiBVPAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiBVPAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:09 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB710DA49
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:43 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id ADB16405D7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541982;
        bh=S4dRVCvOCJBf/TgKU+SSH97N+njRRxFUmbUfADNYkMQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tutXKflI6CrBnmxvsXIvLlXU1L62TQ6A7AytQc3LQ1J6OKnuFgmF3lsENv1PqDuW5
         Kk8kokRYQcoFAPBZLuEzEVy7bN51bXJI2Q49geo2sNTUiiUjVQ4LKKb8HZbTj/YFV9
         oPvy59NaHSczDcd1Fnr94rvYrpOirBn88FXaItUqMFjRmt8QjPWVY8dhZA4+t3QC1I
         6W6ibS0916GDoiRahtkRdqp+UtDTk6E8JEO6BW6hakFd9Avx5iMWDYlLE3Kal2awPf
         Rr+g9uYtAc/Y0a3DUPcoWi1kpAol8gMUcD2xCiS6NNh6aUfGRezPVrnCU8AvhFyHb6
         Umf1RFxbmPBqA==
Received: by mail-ej1-f72.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso5862347ejk.17
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4dRVCvOCJBf/TgKU+SSH97N+njRRxFUmbUfADNYkMQ=;
        b=3JiP5R8XiAXQuOwBDxRx19XS705NTc6NYp4w7emtRvzc+n+cFBstovAxE10l8MGRDJ
         1qCNCrNL71pKdfht9vdtDmzxTeFYtJrrszfM4fTsV+mPlL9YMUcHYVuvgAsI+xFl7Kgy
         W2Y5Fa38MTIyA1kciEoXP2wOyTQiwTP5z7f30uBnVtvP3pgiqPddD5b5mo8kapdA0P+6
         W7xT0DbP7Tm2qgdOy0ypyARgpbJvFKfkurewZ1dU+9od+vjiV1aENUvwFkXZqjcEyogk
         GILQDCuQpf+C6v6JbNiNhgtB3m7dHgjTa/eyfYQl3u+V2OKjpSTRFsxuTWFfEa93OGBh
         3KGA==
X-Gm-Message-State: AOAM533GaJ+KPbSd40lWGI86IVq8LJzNGQQb5f2GJAcJV5bAOKQCGTw0
        bbK7TPagyCLoLAkZ4Oqez2JTM9kV81icBlus8S6Mch9/TWtrRTwaSOCZ8UYDws2Shp7ZhpKxH9o
        9Lpjpc+lZJR0VaODlmqDNe9waXP/mirMiR1nDpao=
X-Received: by 2002:a17:906:cc8d:b0:6c9:6df1:7c55 with SMTP id oq13-20020a170906cc8d00b006c96df17c55mr19473160ejb.317.1645541982088;
        Tue, 22 Feb 2022 06:59:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIhq541BP8xUfNXZfL1fB9MquqPsLmy1uzBQ8P2KwTPXTxvLGRbz9RKniac/wyFeuTOl8HKA==
X-Received: by 2002:a17:906:cc8d:b0:6c9:6df1:7c55 with SMTP id oq13-20020a170906cc8d00b006c96df17c55mr19473139ejb.317.1645541981833;
        Tue, 22 Feb 2022 06:59:41 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:41 -0800 (PST)
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
Subject: [PATCH v2 01/15] dt-bindings: ufs: add common platform bindings
Date:   Tue, 22 Feb 2022 15:58:40 +0100
Message-Id: <20220222145854.358646-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add bindings for common parts (platform) of Universal Flash Storage
(UFS) Host Controllers in dtschema format.

The 'freq-table-hz' is not correct in dtschema, because '-hz' suffix
defines uint32 type, not an array.  Therefore deprecate 'freq-table-hz'
and use 'freq-table' instead.

Include also the bindings directory in UFS maintainers entry.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml |  2 +-
 .../devicetree/bindings/ufs/ufs-common.yaml   | 88 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-common.yaml

diff --git a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
index 4d13e6bc1c50..dc93fe2d3458 100644
--- a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
@@ -80,7 +80,7 @@ examples:
                 compatible = "cdns,ufshc-m31-16nm", "jedec,ufs-2.0";
                 reg = <0x0 0x4000 0x0 0x10000>;
                 interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
-                freq-table-hz = <19200000 19200000>;
+                freq-table = <19200000 19200000>;
                 power-domains = <&k3_pds 277>;
                 clocks = <&k3_clks 277 1>;
                 assigned-clocks = <&k3_clks 277 1>;
diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
new file mode 100644
index 000000000000..85c73d2853e9
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -0,0 +1,88 @@
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
+    deprecated: true
+    description:
+      Use freq-table.
+
+  freq-table:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    items:
+      items:
+        - description: Minimum frequency for given clock
+        - description: Maximum frequency for given clock
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
+  freq-table: [ 'clocks' ]
+
+required:
+  - interrupts
+
+additionalProperties: true
diff --git a/MAINTAINERS b/MAINTAINERS
index aa0f6cbb634e..c2cff57d32f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20015,6 +20015,7 @@ R:	Alim Akhtar <alim.akhtar@samsung.com>
 R:	Avri Altman <avri.altman@wdc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/ufs/
 F:	Documentation/scsi/ufs.rst
 F:	drivers/scsi/ufs/
 
-- 
2.32.0

