Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07580C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D0D21501
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uq14pIJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgE1Bcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63150 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgE1Bcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:39 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200528013237epoutp0119ce594331c29c1d61d18605119ff978~TDSe89tTs2169721697epoutp01z
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200528013237epoutp0119ce594331c29c1d61d18605119ff978~TDSe89tTs2169721697epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629557;
        bh=DDMCtAVCNOenQhQBx8fCmPqcdSKUIHqMO34BELtm7U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uq14pIJPtuXOiBc7TNBrdOXS6i+FaNSVrYff9oL9jWh9lsOZAIMuKVUvIg61y7b2/
         VO+SEOQZiidtnaNysCZdru9CXn4kCwTphO8phsHL8b5sl+mTIlXeNdNsgo5Bnzusc3
         oCGWlXc4TxffSXOtwpm9lfhH3Y/EmMQGoIBmUsDQ=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200528013237epcas5p1d33a8234758f29086468dd2ebb10be8b~TDSeV0TKm1882918829epcas5p18;
        Thu, 28 May 2020 01:32:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.10.09467.4B41FCE5; Thu, 28 May 2020 10:32:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200528013236epcas5p3cc936778eabd07450fbb7f03a17fe757~TDSdydN1D1669516695epcas5p37;
        Thu, 28 May 2020 01:32:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528013236epsmtrp216d36acb80b09950b9885cd305b49901~TDSdxkZLP2193121931epsmtrp2J;
        Thu, 28 May 2020 01:32:36 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-35-5ecf14b4874b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.77.08303.4B41FCE5; Thu, 28 May 2020 10:32:36 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013234epsmtip1e3fd93dcfdee5a19216a2deb6e262e03~TDSb5uWHK1672616726epsmtip1P;
        Thu, 28 May 2020 01:32:34 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Thu, 28 May 2020 06:46:54 +0530
Message-Id: <20200528011658.71590-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7bCmuu4WkfNxBpcOWVs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujF99+xkLLohWtMw6z97AeE2gi5GTQ0LARGLPnp+sXYxcHEICuxklFv95yQLh
        fGKUWDnhEpTzmVFi86fV7DAtPecmMEEkdjFKnHx/jg3CaWGSuHPjDQtIFZuAtsTd6VuYQGwR
        AWGJI9/aGEFsZoEbTBIPVrqA2MICARIH/01mBrFZBFQlzr74D1bPK2AjceXCNGaIbfISqzcc
        ALI5ODgFbCX2TnCAKBGUODnzCQvESHmJ5q2zmUFukBDYwyFx7XAD1KUuEqf/f2CBsIUlXh3f
        AhWXkvj8bi8byEwJgWyJnl3GEOEaiaXzjkGV20scuDKHBaSEWUBTYv0ufYhVfBK9v58wQXTy
        SnS0CUFUq0o0v7sK1SktMbG7mxXC9pC4ef432CNCAhMYJZpXuUxglJ+F5IFZSB6YhbBsASPz
        KkbJ1ILi3PTUYtMCw7zUcr3ixNzi0rx0veT83E2M4GSl5bmD8e6DD3qHGJk4GA8xSnAwK4nw
        Op09HSfEm5JYWZValB9fVJqTWnyIUZqDRUmcV+nHmTghgfTEktTs1NSC1CKYLBMHp1QDE/+k
        J1Oz++t/lrUJ863SfLDKyb9e/vh0QcfwzOlmOyvn7CpdGbft6/3iJ5JzgmtmzGQwdo65u1lC
        ynVzgDy3Qlds9tnnrL8FFHuld3y3VkmLeswwIWPDJ8YFOl5PTY5w3XlqU173Rabl6Qw3H2Hd
        tf4fdr6V1Z9Qv6fU0rinLkjv7KHJXDJhnW9cdmeavtFwOZZzX/N7yob57UlRxoqp/LdE5s2a
        8Eu7+UNet8CCl1oZaa98lmzs/B6xZ5Vfx7es1k1aG89o/a91/HYv3e9slY3rdWnzDXs05jCw
        qIvlnYl82NJ/zkF4me5J19KVKZuuyMzgOn26O8H/wbrdr6/v7YoVylZ1K36SeCm0X6hCiaU4
        I9FQi7moOBEA+Wnk08UDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJTneLyPk4g6fnhS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxq++/YwFF0QrWmadZ29gvCbQxcjJISFgItFzbgJTFyMXh5DADkaJrce+s0Ek
        pCWub5zADmELS6z895wdoqiJSWLB3G8sIAk2AW2Ju9O3MIHYIkBFR761MYLYzALPmCROPSwF
        sYUF/CQ2LHkCNohFQFXi7Iv/YPW8AjYSVy5MY4ZYIC+xesMBIJuDg1PAVmLvBAeQsBBQyYRV
        exkhygUlTs58wgJSwiygLrF+nhDEJnmJ5q2zmScwCs5CUjULoWoWkqoFjMyrGCVTC4pz03OL
        DQuM8lLL9YoTc4tL89L1kvNzNzGCI0tLawfjnlUf9A4xMnEwHmKU4GBWEuF1Ons6Tog3JbGy
        KrUoP76oNCe1+BCjNAeLkjjv11kL44QE0hNLUrNTUwtSi2CyTBycUg1MJwX/+pkx6f7/ZtbE
        cXVS+YTi7BYzg5NyD5e4eUgqG9z+u8ylbf2sZXGJS2ryQv4sn3VZbUbQ8yPSLOf3XEr7+WLF
        ra87eLdEXM367zbljPOf+YItk60in5x2+PVg6Tb1HEt3rlOSkt821uzeN61W2Ksk9ugEg3lF
        OyyjVgnHh+0zW1qwwtBDgSXybk2LttKuGxse/Qg5abbGmN1f9pRfbE72dwfeGf94MyqFSxy2
        V7Z0ra+6uvTabedZ7HMfz2s9+KUssTjTO3vTz/msEyqNjZ0fWEftOnewwSyEoYmhb2prMnNW
        pHCd1LZ3f6+bH02Zyy++87FXrgtrcMsykWVtomlaHhHG7vtWPOI0MlynxFKckWioxVxUnAgA
        vtjbTBsDAAA=
X-CMS-MailID: 20200528013236epcas5p3cc936778eabd07450fbb7f03a17fe757
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013236epcas5p3cc936778eabd07450fbb7f03a17fe757
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013236epcas5p3cc936778eabd07450fbb7f03a17fe757@epcas5p3.samsung.com>
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

