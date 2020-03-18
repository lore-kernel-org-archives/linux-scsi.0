Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8357C5ACD6
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8EBC20784
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jE/y5/rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgCRLSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:18:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46618 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgCRLSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 07:18:08 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200318111806epoutp01ab6f5e474e1e771e402b90c198c122a6~9YeaTyTxQ2379423794epoutp01X
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2020 11:18:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200318111806epoutp01ab6f5e474e1e771e402b90c198c122a6~9YeaTyTxQ2379423794epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584530286;
        bh=QSwap29dffjiAFMYZwi5uQktsX9rEC0TxACpkot0PIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jE/y5/rrhtRzRri2B6KJUMiz9y+UeOyGBGjESBbfg7NKuBnbLelPzoeO/uPBE7vfL
         hg1pJtR07n/MAU6sC6Jj2gCFjwxxv6SzaVrEqmPGaekYSOmbKsBewmVFt2P5Zhd8BE
         YD7yqOvE1vU5jLD0YTDm9yI81/2GCDfOBJ9mGpoQ=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200318111805epcas5p1f6310151d1e5b6fddbda3c901e790e80~9YeZfPmPb3101931019epcas5p1Y;
        Wed, 18 Mar 2020 11:18:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.4C.04782.D63027E5; Wed, 18 Mar 2020 20:18:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200318111805epcas5p3e68724d923a07ddd80a45e3316292940~9YeZK2i4_1474914749epcas5p38;
        Wed, 18 Mar 2020 11:18:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200318111805epsmtrp26a258907d0da3a0d87085279c4fb4acd~9YeZJ5e7Z3128231282epsmtrp2x;
        Wed, 18 Mar 2020 11:18:05 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-eb-5e72036d85e8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.AD.04158.D63027E5; Wed, 18 Mar 2020 20:18:05 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200318111803epsmtip2cf132877222eaf72216367fd9edd656b~9YeXbqW7A0257602576epsmtip2e;
        Wed, 18 Mar 2020 11:18:03 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Date:   Wed, 18 Mar 2020 16:41:40 +0530
Message-Id: <20200318111144.39525-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318111144.39525-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmlm4uc1GcwZcWU4sH87axWbz8eZXN
        4tP6ZawW84+cY7U4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi9a9R9gt
        lm69yejA63G5r5fJY9OqTjaPzUvqPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKeLRvC3PBRf6KD6svsTQw/ufuYuTkkBAwkVg54RdzFyMXh5DAbkaJTRuOMUE4
        nxglnqycwAJSJSTwjVHi8HVvmI4TN6+zQhTtZZS4cesjO4TTwiTx4O55ZpAqNgFtibvTtzCB
        2CICARKX3h9kAyliFpjHJLHoUQ9YQljAW6J962+wFSwCqhJNfRvAmnkFbCQeHbjDArFOXmL1
        hgNgcU4BW4m/d1sZQQZJCNxnk1j5bw4bRJGLxO0PR5khbGGJV8e3sEPYUhKf3+0FquEAsrMl
        enYZQ4RrJJbOOwY1317iwJU5LCAlzAKaEut36YOEmQX4JHp/P2GC6OSV6GgTgqhWlWh+dxWq
        U1piYnc3K4TtIfHozQFoME5glDi26zT7BEbZWQhTFzAyrmKUTC0ozk1PLTYtMMxLLdcrTswt
        Ls1L10vOz93ECE4oWp47GGed8znEKMDBqMTDy7GhIE6INbGsuDL3EKMEB7OSCO/iwvw4Id6U
        xMqq1KL8+KLSnNTiQ4zSHCxK4ryTWK/GCAmkJ5akZqemFqQWwWSZODilGhgXOPjodTp7ZO8N
        ZeV3k36o1fB9i/6y2m+S/7/dVmPzyXm1g/3xr5cB0e4y5oIWQgpee8462iwzU+5pkJnbsHOu
        TGX8MRu7bU1Tdsha237KmD+74FDw/c45u9l3rTncMD3D+l3woguvPk570clneOH7JG7BBRmp
        UwX4/7T85OBWXbLqz4XQlDtKLMUZiYZazEXFiQBKruV5JAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSvG4uc1GcwdYZChYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFq17j7Bb
        LN16k9GB1+NyXy+Tx6ZVnWwem5fUe7Sc3M/i8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CV8WjfFuaCi/wVH1ZfYmlg/M/dxcjJISFgInHi5nXWLkYuDiGB3YwSv89cZINI
        SEtc3ziBHcIWllj57zk7RFETk8TvjmdMIAk2AW2Ju9O3gNkiAkES99asBZvELLCKSaKz9ywj
        SEJYwFuifetvFhCbRUBVoqlvAzOIzStgI/HowB0WiA3yEqs3HACLcwrYSvy92wrWKwRUc2zy
        L5YJjHwLGBlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEB7SW1g7GEyfiDzEKcDAq
        8fAmbCqIE2JNLCuuzD3EKMHBrCTCu7gwP06INyWxsiq1KD++qDQntfgQozQHi5I4r3z+sUgh
        gfTEktTs1NSC1CKYLBMHp1QDY5ewtTB/pe3RnTbbTpQcqHz7k6+7qdinNkbkTcRxjv99mREf
        01z3Hdt3Trp0+aId3d6Fni8ZxPtYF8xn6WG+nzBDrpw3SebSuha5JoO1Jedf3v6SmK36hTNi
        sqDB8g6nvtt/0vb/nRW3SL6354+Ne6aUXUlnZcv8hb6HWPpNpwgdKBR2N+xUYinOSDTUYi4q
        TgQAr9/R/2QCAAA=
X-CMS-MailID: 20200318111805epcas5p3e68724d923a07ddd80a45e3316292940
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200318111805epcas5p3e68724d923a07ddd80a45e3316292940
References: <20200318111144.39525-1-alim.akhtar@samsung.com>
        <CGME20200318111805epcas5p3e68724d923a07ddd80a45e3316292940@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..df54129004e9
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: (GPL-2.0)
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
+      - description: Referencec clock parrent
+
+  clock-names:
+    items:
+      - const: ref_clk_parent
+      - const: ref_clk
+
+required:
+  - "#phy-cells"
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/clock/exynos7-clk.h>
+
+    ufs_phy: ufs-phy@0x15571800 {
+        compatible = "samsung,exynos7-ufs-phy";
+        reg = <0x15571800 0x240>;
+        reg-names = "phy-pma";
+        samsung,pmu-syscon = <&pmu_system_controller>;
+        #phy-cells = <0>;
+        clocks = <&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
+                 <&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
+        clock-names = "ref_clk_parent",
+                      "ref_clk";
+    };
+
+...
-- 
2.17.1

