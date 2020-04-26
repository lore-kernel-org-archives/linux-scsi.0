Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DEDC7C886
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0DC6214D8
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t+vrbECA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDZRmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22873 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgDZRmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:22 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200426174217epoutp02baffd28561b4c9ce382aae0ffddb7037~Jb3_Oi_4d1534515345epoutp02d
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200426174217epoutp02baffd28561b4c9ce382aae0ffddb7037~Jb3_Oi_4d1534515345epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922937;
        bh=PdZr65Wo5TW1cANP8kk5hrsoRREQWBxl8FwYNrvhuxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+vrbECAsJCf1zlivg/1ua82B5CZTcqDUTTAW52d3ZM/Y6uoModrZWPmf4ZjS8AyI
         wbzKfcbUxHUcIWWaawIvsABDb+Gns1h0mooznuV8MemeJCyr5gxdMOocEk7l57tVrM
         oeROsNUALh/1/B3Hi9txEn8Z42kWHYmvn68oXt4s=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426174216epcas5p29f36074e5665f43ad0574df1baad0ab1~Jb39H6blU0368603686epcas5p2j;
        Sun, 26 Apr 2020 17:42:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.52.04782.7F7C5AE5; Mon, 27 Apr 2020 02:42:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200426174215epcas5p3e87abccf47976f6318eb470efef9db39~Jb38kQAtD0554805548epcas5p3K;
        Sun, 26 Apr 2020 17:42:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426174215epsmtrp13077a1995009c4c8d0a9515aca2f504e~Jb38jeI5v0798907989epsmtrp1T;
        Sun, 26 Apr 2020 17:42:15 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-59-5ea5c7f7b2e1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.DC.25866.7F7C5AE5; Mon, 27 Apr 2020 02:42:15 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174213epsmtip184a32627c316a28d738fa1f1c4bbdda6~Jb36r17AJ2626126261epsmtip1j;
        Sun, 26 Apr 2020 17:42:13 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Sun, 26 Apr 2020 23:00:20 +0530
Message-Id: <20200426173024.63069-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe89lHqXpcSo9KSQMhTTSxKLzwS6EwQkK/dKXEmvoQUWnY8dL
        hpakqdu8RpJNnRnOyiHa1DmmqXhpWaCRl/IWkhppoKnQjExrO0p++z3v8/+/z/N/eSlc0kN6
        UwnJqZwyWZYkFbkQpv6Ao8dtVn30iQ+tYcycziRiln6Ni5j15gaSqR0YJpmRkRYnZrJtkGCM
        8xMkM2qpFjGVI90Yo/loFjHPrNsYs9NldmL07ZPovJgdLSnGWGOjSsS21t9l84Z6CHZtcYpg
        S9oaEbthPMIW9GqwSOqaS1gsl5SQzimDz950ie/T3FG0eN2aHisic5CJViNnCuiTsFCe76RG
        LpSE7kRQ3NG2W6wj0M42IaHYQDBUYsb2LCZbPS40LAi2v63uWvIwMHRrcLtKRB+D2UdtDocn
        7QEDP/ORnXH6EwZzL8Lt7EFHwIpuUGRngvaH2pebDhbTYZBvWsWFab5gaOl1sDN9Bt5WWjBB
        4w5DjxcI4U5fyG2vcmwEtJkC6/oKKZjDQVeXhwT2gGWrPZydvWGp1J6a+seJUGQJFY6zQK97
        TQh8DnrHqgm7BKcDoNkSLIxyheLfC5jgFENhvkRQ+0Puyviu0wfKNRpSkLCgV10QXqcMQXdH
        F1mGfLX7Amj3BdD+H/YE4Y3oMKfg5XEcf0oRksxlBPEyOZ+WHBcUkyI3Ise3CrxkRtrhy32I
        ppD0oJjq0EdLSFk6nynvQ0DhUk9xVOrTaIk4VpZ5m1Om3FCmJXF8H/KhCOkh8QNyPEpCx8lS
        uUSOU3DKvS5GOXvnoIKtUi7rue19/7zlvvuMqu56s7Jsa+d0RW72veWJBmf5oF+GV11Ht7yR
        cMvIDp0umPiujfxRrPmqr/HjP3vWh9imgtTc2o6rOqKuirtqQBtyPz4lq6WJePewwHZA5bad
        orNKXKM7a9ZfhS/+uVLdyudszlx8o/4SE2OqKAwySAk+XhYSiCt52V8cH1xkUgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJTvf78aVxBl07xS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxqHuuoINohW3r/SwNjBuE+hi5OSQEDCR2PZ9CXMXIxeHkMAORoknC3rZIBLS
        Etc3TmCHsIUlVv57zg5R1MQksfj5bmaQBJuAtsTd6VuYQGwRoKIj39oYQWxmgWdMEqceloLY
        wgK+Ev/O7GABsVkEVCXmb/wBtoBXwEaibdt7ZogF8hKrNxwAszkFbCVOzdgFNJMDaJmNxPT1
        /hDlghInZz5hAQkzC6hLrJ8nBLFJXqJ562zmCYyCs5BUzUKomoWkagEj8ypGydSC4tz03GLD
        AqO81HK94sTc4tK8dL3k/NxNjOC40tLawbhn1Qe9Q4xMHIyHGCU4mJVEeGNKFsUJ8aYkVlal
        FuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoRTJaJg1OqgUlS/+f+tLceKfm/T2Z9
        7FQ9MeftvBSrZBX/h2/uZHe+tw4wjXo5r6D15WkdlsXqPOWnlfVVRNLqjSOvFX/2+XAoqeJb
        H8/OPtuQN2zTpnwMaw57/KEuULa5eabU5cgcT/eLmuFX2QKaPr9t+BnA0KfyW847XL3zptMF
        uSVNm4zabrRUx/qckJlz5vmODYu/5nju7HJsVnviwpV0/Hpac+y905+frXcPLvaqdzZrl2O8
        enfaYn1XraDIktKDF5+efPzQZF1pT+HThTxHWmqSbhxwWbZSWWV9gfKZaBP3qIsLLRgDbARv
        n954Z52ps0zevMTz4gf5/MRk4iYXvtpmX/JJZVqrl/TMDT/OtS2ZpMRSnJFoqMVcVJwIANL1
        iJEaAwAA
X-CMS-MailID: 20200426174215epcas5p3e87abccf47976f6318eb470efef9db39
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174215epcas5p3e87abccf47976f6318eb470efef9db39
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174215epcas5p3e87abccf47976f6318eb470efef9db39@epcas5p3.samsung.com>
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

