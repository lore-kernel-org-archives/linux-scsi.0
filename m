Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17A1C38A2C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78CD22247
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sJjU7dUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbgDQSKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11708 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgDQSKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:22 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200417181020epoutp03e4d4755420a6dfeda1069e81ff0d8d2e~Grc5D5rgg0168001680epoutp03_
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200417181020epoutp03e4d4755420a6dfeda1069e81ff0d8d2e~Grc5D5rgg0168001680epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147020;
        bh=PdZr65Wo5TW1cANP8kk5hrsoRREQWBxl8FwYNrvhuxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJjU7dUvF/uMLlq3aNfm5+sxAgZDJ+zRl3zh70J1Y8cOButiQSnBLIo+MD3NneANG
         9wUVdjzLV/7QxC3Hp4Kzshat4s/1SxQ2T2N5Gm7+O30d9Qii3U+Ilv4Yv/5tto0cD/
         3W79vtvvPcNhTuaHVbw1i7+Q064gOqqHvIMDwhuU=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200417181018epcas5p1780e8f8ae8262419dd53e1a1cdf26506~Grc30j19k2627826278epcas5p1X;
        Fri, 17 Apr 2020 18:10:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.58.04782.A01F99E5; Sat, 18 Apr 2020 03:10:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181018epcas5p1e51c7ca0fe81df16554548df5b82e3e4~Grc3ddRR72627826278epcas5p1W;
        Fri, 17 Apr 2020 18:10:18 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200417181018epsmtrp16283c84c1c3752011f4c957ad7c7863d~Grc3cnTYy0669906699epsmtrp1L;
        Fri, 17 Apr 2020 18:10:18 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-f7-5e99f10a8203
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.DE.04158.A01F99E5; Sat, 18 Apr 2020 03:10:18 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181016epsmtip11ac446900faf56c9c6768e208a0d9089~Grc1oSJCc2094920949epsmtip1H;
        Fri, 17 Apr 2020 18:10:16 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Fri, 17 Apr 2020 23:29:40 +0530
Message-Id: <20200417175944.47189-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmhi7Xx5lxBu8Palk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujEPddQUbRCtuX+lhbWDcJtDFyMkhIWAi8f7hBUYQW0hgN6PEgpnMXYxcQPYn
        Ron5i1dAJb4xSkzrMIZpWL1iGjtE0V5GieVfJ0A5LUwSaz+9ZAapYhPQlrg7fQsTiC0iICxx
        5Fsb2CRmgRtMEg9WuoDYwgL+Ek1vXrGB2CwCqhIvTz0Hq+cVsJE4OPcYM8Q2eYnVGw6A2ZwC
        thJtLUuhagQlTs58wgIxU16ieetssLMlBNrZJRoXtjBBNLtIzPuxnQXCFpZ4dXwLO4QtJfGy
        vw3I5gCysyV6dkF9ViOxdN4xqHJ7iQNX5rCAlDALaEqs36UPsYpPovf3EyaITl6JjjYhiGpV
        ieZ3V6E6pSUmdnezQtgeEhM/74WG4QRGic37lScwys9C8sAsJA/MQli2gJF5FaNkakFxbnpq
        sWmBYV5quV5xYm5xaV66XnJ+7iZGcKLS8tzBOOuczyFGAQ5GJR7ejr6ZcUKsiWXFlbmHGCU4
        mJVEeA+6AYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzTmK9GiMkkJ5YkpqdmlqQWgSTZeLglGpg
        lHn03aFaVd/wz6ovNundvPuvsrSdSp6xMHPGzL5fF88+v+Udwse+pcJsBWvzyZcNrxT3snWo
        MLt0BrpM130WdmG9qOa09+oJhcHr2s2iMi6enmcx/S1L4eFXpnpfqkWu/FQpZH66wXDTdlML
        kSydTV82LTWf89vR/l2a29q0jPCggnirDU4KSizFGYmGWsxFxYkARoug5lADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSnC7Xx5lxBmt3Clg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujEPddQUbRCtuX+lhbWDcJtDFyMkhIWAisXrFNPYuRi4OIYHdjBIrr+5ggkhI
        S1zfOIEdwhaWWPnvOVRRE5NE66QdrCAJNgFtibvTt4A1iAAVHfnWxghiMws8Y5I49bAUxBYW
        8JU4uGE12CAWAVWJl6eeg9XzCthIHJx7jBligbzE6g0HwGxOAVuJtpalQDUcQMtsJDY8iYEo
        F5Q4OfMJC0iYWUBdYv08IYhN8hLNW2czT2AUnIWkahZC1SwkVQsYmVcxSqYWFOem5xYbFhjl
        pZbrFSfmFpfmpesl5+duYgTHlZbWDsYTJ+IPMQpwMCrx8Hb0zYwTYk0sK67MPcQowcGsJMJ7
        0A0oxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc+/1ikkEB6YklqdmpqQWoRTJaJg1OqgVGJw8t7
        4tmp740ybJM7Tlp0vl9z4+SGrYUC579JSJ3Om3RF/6rJs7Qv+w6L/bxfqwGMuh8maS+Kb/Vc
        j+MKFDnKdS1C6nzbgZNWZ8/fOvWgwGXbscbEezo1pg5TZlsY72LeE5VsnCJdkDtBebvfWYeQ
        eVPsTiz/0LepUW3JHpWErO3qzGf0ZZVYijMSDbWYi4oTAYJYPHanAgAA
X-CMS-MailID: 20200417181018epcas5p1e51c7ca0fe81df16554548df5b82e3e4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181018epcas5p1e51c7ca0fe81df16554548df5b82e3e4
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181018epcas5p1e51c7ca0fe81df16554548df5b82e3e4@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..352d5dda320d
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,74 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/samsung,ufs-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung SoC series UFS PHY Device Tree Bindings
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+
+properties:
+  "#phy-cells":
+    const: 0
+
+  compatible:
+    enum:
+      - samsung,exynos7-ufs-phy
+
+  reg:
+    maxItems: 1
+    description: PHY base register address
+
+  reg-names:
+    items:
+      - const: phy-pma
+
+  clocks:
+    items:
+      - description: PLL reference clock
+      - description: symbol clock for input symbol ( rx0-ch0 symbol clock)
+      - description: symbol clock for input symbol ( rx1-ch1 symbol clock)
+      - description: symbol clock for output symbol ( tx0 symbol clock)
+
+  clock-names:
+    items:
+      - const: ref_clk
+      - const: rx1_symbol_clk
+      - const: rx0_symbol_clk
+      - const: tx0_symbol_clk
+
+  samsung,pmu-syscon:
+    $ref: '/schemas/types.yaml#/definitions/phandle'
+    description: phandle for PMU system controller interface, used to
+                 control pmu registers bits for ufs m-phy
+
+required:
+  - "#phy-cells"
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - samsung,pmu-syscon
+
+examples:
+  - |
+    #include <dt-bindings/clock/exynos7-clk.h>
+
+    ufs_phy: ufs-phy@15571800 {
+        compatible = "samsung,exynos7-ufs-phy";
+        reg = <0x15571800 0x240>;
+        reg-names = "phy-pma";
+        samsung,pmu-syscon = <&pmu_system_controller>;
+        #phy-cells = <0>;
+        clocks = <&clock_fsys1 SCLK_COMBO_PHY_EMBEDDED_26M>,
+                 <&clock_fsys1 PHYCLK_UFS20_RX1_SYMBOL_USER>,
+                 <&clock_fsys1 PHYCLK_UFS20_RX0_SYMBOL_USER>,
+                 <&clock_fsys1 PHYCLK_UFS20_TX0_SYMBOL_USER>;
+        clock-names = "ref_clk", "rx1_symbol_clk",
+                      "rx0_symbol_clk", "tx0_symbol_clk";
+
+    };
+...
-- 
2.17.1

