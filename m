Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF66BC54E92
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FE82137B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Fk4Hlj10"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgEKCOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:14:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52113 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbgEKCOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:14:07 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200511021403epoutp030399c18e728e4720e58263ae2be37d6b~N14zB9ZL02320523205epoutp03Y
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:14:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200511021403epoutp030399c18e728e4720e58263ae2be37d6b~N14zB9ZL02320523205epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163243;
        bh=DDMCtAVCNOenQhQBx8fCmPqcdSKUIHqMO34BELtm7U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk4Hlj10Qkl6Sv5uKI9a585+h1YaJfpcH3MAd9OdVWtXjF//Vhy6QanjAcE9jtRL0
         TPT0YP1+6Koapu8kXRRxZeDhJodOAAJ60U4HMYff1O+Epbz9zgLv2mWuRsVqKgQlgC
         dxXXGtugOn3jgmrwKpfu4TJdrkBtyINLKnDSht0s=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200511021402epcas5p1c80ab5279772b7eceb4f0e67c488ad97~N14yj3qY61717717177epcas5p1l;
        Mon, 11 May 2020 02:14:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.C5.10010.AE4B8BE5; Mon, 11 May 2020 11:14:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200511021401epcas5p3b86ec5772ad700736eba6472e1fce8f6~N14x1Vfab1506415064epcas5p3Y;
        Mon, 11 May 2020 02:14:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200511021401epsmtrp1113f2a9df789233e02eb4520c15ca9d8~N14xyitFi0628006280epsmtrp1c;
        Mon, 11 May 2020 02:14:01 +0000 (GMT)
X-AuditID: b6c32a49-735ff7000000271a-91-5eb8b4ea14a5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.64.25866.9E4B8BE5; Mon, 11 May 2020 11:14:01 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021359epsmtip24cae2f65c2139bb5ef13ca192ba52d0c~N14vs5dhD0185501855epsmtip2S;
        Mon, 11 May 2020 02:13:59 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Mon, 11 May 2020 07:30:27 +0530
Message-Id: <20200511020031.25730-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7bCmpu6rLTviDJrfy1o8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujF99+xkLLohWtMw6z97AeE2gi5GTQ0LARGLBgx0sILaQwG5GiasLfLoYuYDs
        T4wSzRd/sUE4nxklPnfuYIbpOPHoOTtEYhejxLKzv1ggnBYmiQOXb7GBVLEJaEvcnb6FCcQW
        ERCWOPKtjRHEZha4wSTxYKULiC0s4C/x+eUasN0sAqoSn/4fZAexeQVsJH40HmCF2CYvsXrD
        AbDNnAK2EtMatrNA1AhKnJz5hAViprxE89bZzCBHSAjs4ZA4fv4UG0Szi8S8p2+gzhaWeHV8
        CzuELSXxsr8NyOYAsrMlenYZQ4RrJJbOO8YCYdtLHLgyhwWkhFlAU2L9Ln2IVXwSvb+fMEF0
        8kp0tAlBVKtKNL+7CtUpLTGxu5sVosRD4tLJekjoTGCUWP/hCesERvlZSB6YheSBWQjLFjAy
        r2KUTC0ozk1PLTYtMMxLLdcrTswtLs1L10vOz93ECE5WWp47GO8++KB3iJGJg/EQowQHs5II
        7/LcHXFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeU+nbYkTEkhPLEnNTk0tSC2CyTJxcEo1MHG8
        du4/8y1p0urzRnzXXkhf+t+95ertHmsBn//rL3ee3dTKOiVJNuX+lA4WNc3lvobsCavT5FdJ
        ZP8t9f7a/uzF5xzGL+9V7211Wmu72u6DrdJipV45hoQ7e0wU+5YqP5xiWZaoW6BrkjNZf7JC
        m+ydM83/mu4e2smeFnCghr30+FL1j6a1bAcEjKLPbFz3TWH66yNJW94LJ74R5/jyk9mynP2c
        walpl7u5ItNcsu6fazh8dUnHfFZBq8NsjSXtTKemJjC7bPn0OOLSgfIrye1+vn4f/q9vi2rd
        PHXNNzlXxdVPHP0DXpYeC33dyuz7otT0nZaeC/fZI7ZyD/bM3tcX437U2qukOs+Qb1VLnBJL
        cUaioRZzUXEiAARVaGvFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXvfllh1xBtN7tSwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxq++/YwFF0QrWmadZ29gvCbQxcjJISFgInHi0XP2LkYuDiGBHYwSG2deY4ZI
        SEtc3ziBHcIWllj5D6aoiUli5YdnrCAJNgFtibvTtzCB2CJARUe+tTGC2MwCz5gkTj0s7WLk
        4BAW8JX42iENEmYRUJX49P8g2ExeARuJH40HWCHmy0us3nAAbC+ngK3EtIbtLCC2EFDNjE2b
        WSHqBSVOznzCAjKSWUBdYv08IYhN8hLNW2czT2AUnIWkahZC1SwkVQsYmVcxSqYWFOem5xYb
        FhjlpZbrFSfmFpfmpesl5+duYgRHlpbWDsY9qz7oHWJk4mA8xCjBwawkwrs8d0ecEG9KYmVV
        alF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5akZqemFqQWwWSZODilGpgOP/yn8L1ivup6xSvP
        re9fNv9Vc2yixgPfWZ7Pb95w/WanmPQ2qb/sw+/rpf8vO0VWdF5Tzqu/9IXL7uZRmzTrBAOe
        tXMlrK5MzDpra6PZVSv8cU9uRL1Jy9Ut6yW9efbJ5OTPdZPNsPvmOGXzzcxvLmnNoraz/xw2
        81ofHRZmpz/J0FbpwRyZxVO2PKk0eBF+IFcwaGk98/MXkmu+sO/q15ya8TFl+hmb1N2NbL9K
        U59r+6+0CGm9t7hHQjvh2sUbn76sdtpx/dJ6ps7tE5g3Gchd09fcE7JvvzS7kHZC5k6dpFLm
        ZekTdvoHL1PiaPzxRlvmzLxjjDHib4ymuzq05Zj8k+RuyE31eJrYGKPEUpyRaKjFXFScCABa
        JaKMGwMAAA==
X-CMS-MailID: 20200511021401epcas5p3b86ec5772ad700736eba6472e1fce8f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021401epcas5p3b86ec5772ad700736eba6472e1fce8f6
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021401epcas5p3b86ec5772ad700736eba6472e1fce8f6@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..636cc501b54f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,75 @@
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
+additionalProperties: false
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

