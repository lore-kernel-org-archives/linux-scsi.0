Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C1EC433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F54C2078E
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CaQiQLvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgFMDE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54580 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgFMDEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:54 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200613030451epoutp0307374347b5fead05a72f6786df27ad70~X_3kvS4rs0174301743epoutp03D
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200613030451epoutp0307374347b5fead05a72f6786df27ad70~X_3kvS4rs0174301743epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017491;
        bh=DDMCtAVCNOenQhQBx8fCmPqcdSKUIHqMO34BELtm7U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaQiQLvEHvaOkNidr76kFxhDfaDI17dP44enBwmC+ORz7mZxkHoynLLrA3JU6wYc+
         SRtmKHWpT3vn579vL5jhtfk476oHb423xURzHE0abakDROwhDi33vljBIZqXTsxDoz
         Lqd0yuIw1iXM/9RHieg1sjVA5UNk48bSc8mW5Pkk=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200613030450epcas5p44c361ac88dcedcaaea3af8510792b754~X_3kPso5X1361613616epcas5p4k;
        Sat, 13 Jun 2020 03:04:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.43.09475.25244EE5; Sat, 13 Jun 2020 12:04:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200613030449epcas5p3cb1139c47ed1c9055c22facf2f5a933b~X_3jRrmkG2337923379epcas5p3J;
        Sat, 13 Jun 2020 03:04:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030449epsmtrp20eaba93413a849007a91638c1cb26658~X_3jRAivs2362123621epsmtrp2w;
        Sat, 13 Jun 2020 03:04:49 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-c3-5ee442523541
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.C4.08303.15244EE5; Sat, 13 Jun 2020 12:04:49 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030447epsmtip28b01438409c01baec22211f5fd88a7a9~X_3hV4yPF0718207182epsmtip2C;
        Sat, 13 Jun 2020 03:04:47 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Sat, 13 Jun 2020 08:17:02 +0530
Message-Id: <20200613024706.27975-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsWy7bCmpm6Q05M4g9nLFSwezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mr41befseCCaEXLrPPsDYzXBLoYOTkkBEwkdkw6wdzFyMUh
        JLCbUWLLx3YWCOcTo8Sxm6fZQaqEBD4zSny6qtHFyAHWcWkeP0TNLkaJ+bsuQjW0MElc23yL
        FaSBTUBb4u70LUwgtoiAsMSRb22MIDazwEsmiV2PCkBsYYFwiQtrpoDVsAioSkxfuBHM5hWw
        kXh/7jsjxHnyEqs3HGAGsTkFbCUO/l8AVSMocXLmExaImfISzVtng70gIXCBQ2LO/W0sEM0u
        Eueuv2aHsIUlXh3fAmVLSXx+t5cN4ptsiZ5dxhDhGoml845BtdpLHLgyhwWkhFlAU2L9Ln2I
        VXwSvb+fMEF08kp0tAlBVKtKNL+7CtUpLTGxu5sVwvaQ+LLgEjQIJwCD8DrjBEb5WUgemIXk
        gVkIyxYwMq9ilEwtKM5NTy02LTDOSy3XK07MLS7NS9dLzs/dxAhOX1reOxgfPfigd4iRiYPx
        EKMEB7OSCK+g+MM4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxKP87ECQmkJ5akZqemFqQWwWSZ
        ODilGph8midoSL9frtCoPPXUngCpFSkzfm6zUNr43eX86zMne0vWyz6+mbLgxq1fDX/4b/x5
        /bNz+78TOyuuLLn8e5qnnpyYt+CDW4XbFqmsjNa76M99KJxPRdy8NvJYkpCvU8zq+NdvXByb
        Pn/QMyiaIizs4r7yUcyPFVMfW14Tb0yVd14tpjFfYwVnUPWn8HP2t+/88vmhteuve5u+VPL2
        qPCOSVelrqinJBq+++pi3Bt1ZGYQ262a+g07IxYcz1y3RCKE/3/u05hnbtJ3eKat69i46dIq
        s4OL0pb6rKmN6WpsXblLlaE64uD+UE25mp89Bk9uVDy51SZnmvOsX1Xij+cbbqt5Zgcjp/7e
        +Pzx7C3LlFiKMxINtZiLihMBWLiGgs4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG6g05M4g433FSwezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mr41befseCCaEXLrPPsDYzXBLoYOTgkBEwkLs3j72Lk4hAS
        2MEocWDuCqYuRk6guLTE9Y0T2CFsYYmV/56zQxQ1MUl8/XWNESTBJqAtcXf6FrAGEaCiI9/a
        GEGKmAW+M0kcmDCBGSQhLBAqMWnlDzYQm0VAVWL6wo1gDbwCNhLvz31nhNggL7F6wwGwek4B
        W4mD/xeA1QgB1ew++pMVol5Q4uTMJywgVzMLqEusnycEEmYGam3eOpt5AqPgLCRVsxCqZiGp
        WsDIvIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjetLR2MO5Z9UHvECMTB+MhRgkO
        ZiURXkHxh3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb/OWhgnJJCeWJKanZpakFoEk2Xi4JRq
        YLKXjDB4fEkn7KPMl7W/0mcXelQfy/9s9G91wF2/2zLSbtWLKmX2+FxM9tPX25x5KG4rw99Z
        8zfnVGnsC0sq3nuidnn3G6GmQvFSeQ+7C/PS5r+aISiv6ZF8kvd3TfvD4/NedsrPf21yyiHc
        g+Oe4uIF76qPB5xgKzrk3WNodtPHmHNTpFp/vYXcxIccPy+stbjzondKSfBS/9fnb8Q0S828
        tpztk5n1IfWbRatfFSrefJIw8+bd6YGbJJv+f415x6Sn/WD3ovD1mfp8rC8Y3x5T0tBb8cjh
        aL+bglDV0q6QaWe/9mx9UN/5rUhleSxn9SWb4iSLU+2Xpkx8dTGvcvXtVfffftgyyeXglW07
        Y7yUWIozEg21mIuKEwHcC+QhJgMAAA==
X-CMS-MailID: 20200613030449epcas5p3cb1139c47ed1c9055c22facf2f5a933b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030449epcas5p3cb1139c47ed1c9055c22facf2f5a933b
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030449epcas5p3cb1139c47ed1c9055c22facf2f5a933b@epcas5p3.samsung.com>
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

