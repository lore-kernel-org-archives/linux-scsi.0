Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C22C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C8682178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="gD1t6nRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfKHQuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:50:07 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:49550 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKHQuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 11:50:07 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA8GmVLv023950;
        Fri, 8 Nov 2019 10:48:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573231711;
        bh=RNrJsp/5NYwS2QsIpeLrKLXLtyzwpT//dGLitwAFGxE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=gD1t6nRnCW4j6mVhUQml4zPC6Vkp/VJCtAtoDlcl6wgU8YVb55emsZCfur7ZtMGv9
         02SJUef/HYefIAXW9T6VbOqAerSpAT8FHUZiKHS0l34lMvBeA2wwq5b7SAcojV/tym
         WDROkoFUVFstirfcWhazxEECEfBEFUkrw9qyse4M=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA8GmVRr106798
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 Nov 2019 10:48:31 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 8 Nov
 2019 10:48:15 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 8 Nov 2019 10:48:15 -0600
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA8GmNLX117597;
        Fri, 8 Nov 2019 10:48:27 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for TI UFS wrapper
Date:   Fri, 8 Nov 2019 22:18:56 +0530
Message-ID: <20191108164857.11466-2-vigneshr@ti.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108164857.11466-1-vigneshr@ti.com>
References: <20191108164857.11466-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add binding documentation of TI wrapper for Cadence UFS Controller.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v3: No change

 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
new file mode 100644
index 000000000000..c8a2a92074df
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/ti,j721e-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TI J721e UFS Host Controller Glue Driver
+
+maintainers:
+  - Vignesh Raghavendra <vigneshr@ti.com>
+
+properties:
+  compatible:
+    items:
+      - const: ti,j721e-ufs
+
+  reg:
+    maxItems: 1
+    description: address of TI UFS glue registers
+
+  clocks:
+    maxItems: 1
+    description: phandle to the M-PHY clock
+
+  power-domains:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - power-domains
+
+patternProperties:
+  "^ufs@[0-9a-f]+$":
+    type: object
+    description: |
+      Cadence UFS controller node must be the child node. Refer
+      Documentation/devicetree/bindings/ufs/cdns,ufshc.txt for binding
+      documentation of child node
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ufs_wrapper: ufs-wrapper@4e80000 {
+       compatible = "ti,j721e-ufs";
+       reg = <0x0 0x4e80000 0x0 0x100>;
+       power-domains = <&k3_pds 277>;
+       clocks = <&k3_clks 277 1>;
+       assigned-clocks = <&k3_clks 277 1>;
+       assigned-clock-parents = <&k3_clks 277 4>;
+       #address-cells = <2>;
+       #size-cells = <2>;
+
+       ufs@4e84000 {
+          compatible = "cdns,ufshc-m31-16nm", "jedec,ufs-2.0";
+          reg = <0x0 0x4e84000 0x0 0x10000>;
+          interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+          freq-table-hz = <19200000 19200000>;
+          power-domains = <&k3_pds 277>;
+          clocks = <&k3_clks 277 1>;
+          assigned-clocks = <&k3_clks 277 1>;
+          assigned-clock-parents = <&k3_clks 277 4>;
+          clock-names = "core_clk";
+       };
+    };
-- 
2.24.0

