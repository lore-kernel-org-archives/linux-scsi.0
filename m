Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC8CC10F14
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127F220B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="uutwVOyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbfJJId5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:33:57 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43210 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731959AbfJJId4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 04:33:56 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9A8XjtI127735;
        Thu, 10 Oct 2019 03:33:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570696425;
        bh=FhquN/1OPnzSIofRbpd8657kQgDexsa7zYHjkstaN0g=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uutwVOyxz7Ybc/SgJ+e6Z205PIhRuMyH0VWQfwYt4A4zognI4AwKqlLik3KXwGkQE
         MRCR8QTtQllth9LMA8AxVQxaCKFKAWsG3yV27/L6xoUCIRsPyUgcLwQRwKqJ+JHldT
         3fcnnLkXE6Ga+8lAu1fwT24WtdMPH6DBGLd2Bvtk=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9A8Xjsw043983
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Oct 2019 03:33:45 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 10
 Oct 2019 03:33:41 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 10 Oct 2019 03:33:41 -0500
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9A8XaSa019061;
        Thu, 10 Oct 2019 03:33:41 -0500
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, <nsekhar@ti.com>
Subject: [PATCH v2 1/2] dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for TI UFS wrapper
Date:   Thu, 10 Oct 2019 14:03:56 +0530
Message-ID: <20191010083357.28982-2-vigneshr@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083357.28982-1-vigneshr@ti.com>
References: <20191010083357.28982-1-vigneshr@ti.com>
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
---

v2:
Define Cadence UFS controller as child node of the wrapper as suggested
by Rob H

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
2.23.0

