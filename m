Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEFBC10F26
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DFE20880
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Enefzvm6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCFPKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:10:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30156 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCFPKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2020 10:10:24 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200306151022epoutp0138a274a8212973177a5f5850fa00a525~5v5xuWhTs0856708567epoutp01i
        for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2020 15:10:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200306151022epoutp0138a274a8212973177a5f5850fa00a525~5v5xuWhTs0856708567epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583507422;
        bh=F7LuECssz+f+nx9HSNPfSiMeSU0q4TnbQepL+ELHjpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Enefzvm6Kj6uluggiLfMbdv63I4YU4lZf+mM5o48o52l9PzXkEUGY7WpUqFvIaNdd
         +jDgFdCZFf/rN+8j24dSGfDpvAm0QxF7JmtwO59P+ALeCjZ3MJ3agnHPex4YAjxyMi
         oiE0oVjfWBZNiP0iw75a940gFG9MqVWFM8M+V2z8=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200306151021epcas5p38cbaa63f838c46dbc2d936c7da404c09~5v5xFJ3CC2035720357epcas5p3o;
        Fri,  6 Mar 2020 15:10:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.D5.19726.DD7626E5; Sat,  7 Mar 2020 00:10:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f~5v5wqLdp10468404684epcas5p4V;
        Fri,  6 Mar 2020 15:10:21 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200306151021epsmtrp10f60fb9c07070d7714c1aabf8e0f4673~5v5wpOz0s0082800828epsmtrp1J;
        Fri,  6 Mar 2020 15:10:21 +0000 (GMT)
X-AuditID: b6c32a49-7a9ff70000014d0e-d2-5e6267dd19b1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.04.06569.DD7626E5; Sat,  7 Mar 2020 00:10:21 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200306151019epsmtip1d2adcd8027a5437c3dee4a326d2a47ec~5v5vJXBAc0045300453epsmtip1Z;
        Fri,  6 Mar 2020 15:10:19 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Date:   Fri,  6 Mar 2020 20:35:25 +0530
Message-Id: <20200306150529.3370-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306150529.3370-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWy7bCmpu7d9KQ4g5OzDC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsei+voPNYvnxf0wWrXuPsFss3XqT0YHL43JfL5PHplWd
        bB4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZdz4NoutYDZ/xdWP
        d1kbGC9ydzFyckgImEic/z2bqYuRi0NIYDejxKY9qxghnE+MEss/X4NyvjFKTJz9jhWmZVrD
        LzaIxF5GiV/vjzGCJIQEWpgklp+SB7HZBLQl7k7fwgRiiwgESFx6fxCsgVlgK6NE67Ul7CAJ
        YQEPiZ7pU1lAbBYBVYmPG9eBDeIVsJa49OUAC8Q2eYnVGw4wg9icAjYSPxbdYgYZJCFwhE1i
        6bMWNogiF4kHm1axQ9jCEq+Ob4GypSRe9rcB2RxAdrZEzy5jiHCNxNJ5x6Dm20scuDKHBaSE
        WUBTYv0ufZAwswCfRO/vJ0wQnbwSHW1CENWqEs3vrkJ1SktM7O6GhomHRPeNk+yQMOlnlLi0
        8yPjBEbZWQhTFzAyrmKUTC0ozk1PLTYtMMxLLdcrTswtLs1L10vOz93ECE4VWp47GGed8znE
        KMDBqMTD62CdFCfEmlhWXJl7iFGCg1lJhFfYND5OiDclsbIqtSg/vqg0J7X4EKM0B4uSOO8k
        1qsxQgLpiSWp2ampBalFMFkmDk6pBsYpif8CIs/yBM0+kPqluuLDXae4ucKyh1KP5h6pb55z
        7Ug1s/3UuR97PI+veVx9vTGyVTPrS7Cq5Q4dZ75HwZkiZw507FvdH7xQdNW7W74th6v5//7/
        HPguxS6W7a2O3KK86XU86t4vQ3nV7VKfvD62+9+pbNbLWlf3Teq+XuzIW9zF9vboDiklluKM
        REMt5qLiRAAaF3auEQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnO7d9KQ4g827hCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsei+voPNYvnxf0wWrXuPsFss3XqT0YHL43JfL5PHplWd
        bB4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZdz4NoutYDZ/xdWP
        d1kbGC9ydzFyckgImEhMa/jF1sXIxSEksJtRYt6VLhaIhLTE9Y0T2CFsYYmV/56zQxQ1MUl8
        uz8FrIhNQFvi7vQtTCC2iECQxL01a1lBipgF9jJKbD56jBUkISzgIdEzfSpYA4uAqsTHjesY
        QWxeAWuJS18OQG2Tl1i94QAziM0pYCPxY9EtMFsIqOb8rA3sExj5FjAyrGKUTC0ozk3PLTYs
        MMpLLdcrTswtLs1L10vOz93ECA5VLa0djCdOxB9iFOBgVOLhdbBOihNiTSwrrsw9xCjBwawk
        witsGh8nxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc+/1ikkEB6YklqdmpqQWoRTJaJg1OqgdFZ
        +FN1yL53G7fzZ5mH3L5x7sksD5XivDM7/d98rS6VdPh3kIE/tCQqaIL9i8buirfczF1nrMti
        fFY93cvWs/yebNRzhhe6eRuron9FKrtKrX9538zxSsTJnZyrJ/quDZmqwPinp/GI/9XV/1WS
        /ctFVzx9O+m/g9TLjPRJEfkmds/ulJ3rO6jEUpyRaKjFXFScCAB5a/vhUQIAAA==
X-CMS-MailID: 20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..6e204ea5c8ff
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,60 @@
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
+    items:
+     - description: PHY base register address
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
+      - const: ref_clk
+      - const: ref_clk_parent
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

