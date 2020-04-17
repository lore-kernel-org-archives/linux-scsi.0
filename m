Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA456C38A2D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C248C2223C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ifnIN3QX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgDQSKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62572 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgDQSK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:27 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200417181024epoutp01124fdb0bc83e02ac7f1c89a2196ae4f7~Grc9PUGq-0233302333epoutp010
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200417181024epoutp01124fdb0bc83e02ac7f1c89a2196ae4f7~Grc9PUGq-0233302333epoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147024;
        bh=HisTscgOdzzOb+y3T3lOdgunVqX2gCoBzsP3vUe7Hys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifnIN3QXOYkPNMN5HmL9NDlcJrMb/duVGf+ZTKP7EVOvywaoUeLES6wRPDEjeOrUY
         Qm8czgSp3Q/nPUY+PWqYNtCNpiCKy2xAKR3cbbAGIC/cLhQOA8bAT80/ohZf9npwwA
         C1udri++FVeCJB6SJKOhi1+B57KN88FxIJMze4Gk=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200417181023epcas5p15b3e1a1156ed44f4fa200e6ffd0f91a9~Grc8A0Mi52627826278epcas5p1f;
        Fri, 17 Apr 2020 18:10:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.58.04782.F01F99E5; Sat, 18 Apr 2020 03:10:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181022epcas5p1f83138da6e76ff0917de88e913ef8e32~Grc7X14oB2627826278epcas5p1d;
        Fri, 17 Apr 2020 18:10:22 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200417181022epsmtrp17a6c5e8c2d3d1fc3ad072f8e53389709~Grc7XDrSj0669906699epsmtrp1N;
        Fri, 17 Apr 2020 18:10:22 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-fc-5e99f10f622a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.DE.04158.E01F99E5; Sat, 18 Apr 2020 03:10:22 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181020epsmtip1d54494acf3cc758048fee28f2558ed14~Grc5mr71N2094920949epsmtip1I;
        Fri, 17 Apr 2020 18:10:20 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 08/10] dt-bindings: ufs: Add DT binding documentation for
 ufs
Date:   Fri, 17 Apr 2020 23:29:42 +0530
Message-Id: <20200417175944.47189-9-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWy7bCmpi7/x5lxBh8mcVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJbPexgLzohXTLu2jrmB8bNgFyMnh4SAicTr3XNZuxi5OIQEdjNKrJk0lx3C
        +cQocev0XRYI5xujxP3LB4EyHGAtrZ8DIOJ7GSUmn5/FBOG0MElcPdjLCjKXTUBb4u70LUwg
        toiAsMSRb22MIDazwA0miQcrXUBsYYEgiQt777OD2CwCqhLPllxkA7F5BWwkWl7tZoS4T15i
        9YYDzCA2p4CtRFvLUrBlEgL32SSOvl3MAlHkInGxfR0bhC0s8er4FnYIW0riZX8b1NXZEj27
        jCHCNRJL5x2DarWXOHBlDgtICbOApsT6XfoQZ/JJ9P5+wgTRySvR0SYEUa0q0fzuKlSntMTE
        7m5WCNtDYlvTAUZIMExglHh44x/jBEbZWQhTFzAyrmKUTC0ozk1PLTYtMMxLLdcrTswtLs1L
        10vOz93ECE4nWp47GGed8znEKMDBqMTD29E3M06INbGsuDL3EKMEB7OSCO9BN6AQb0piZVVq
        UX58UWlOavEhRmkOFiVx3kmsV2OEBNITS1KzU1MLUotgskwcnFINjEda+bhOv7OPvJaSrv+4
        7rCSztFANl6Whv+TN4u3WyZzaMledfhw2Sjo3cuvPLtSAlNWLvD/Eub6klteY96VVZ91os/r
        yAjoq8nw6m61M9ranZPqvTghQNfvPW+ngU/fbJ3NzX8mXSme+6h77vFi7z8RzxeqPpid5r/H
        aMGPY3s8uB7dkrdgVGIpzkg01GIuKk4EAMcrah0jAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSnC7fx5lxBqfuK1g8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJbPexgLzohXTLu2jrmB8bNgFyMHh4SAiUTr54AuRk4OIYHdjBLPm8VAbAkB
        aYnrGyewQ9jCEiv/PQeyuYBqmpgkHv98wwiSYBPQlrg7fQsTiC0CVHTkWxtYnFngGZPEqYel
        ILawQIDEufn/wWpYBFQlni25yAZi8wrYSLS82s0IsUBeYvWGA8wgNqeArURby1ImkNuEgGo2
        PImZwMi3gJFhFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcCBrae1gPHEi/hCjAAej
        Eg9vR9/MOCHWxLLiytxDjBIczEoivAfdgEK8KYmVValF+fFFpTmpxYcYpTlYlMR55fOPRQoJ
        pCeWpGanphakFsFkmTg4pRoYUx0DN83S93v72nTV8e1rTP8vvP73acCpOssT58yCbuWrNt01
        3579PztLgLtnf3e5sEHgtiVy9ipGQaJx9RxGF3cFSHNOn770jJaVOcPxxBNZZqqNDvzrGGY6
        nP3qJpEQtIepfdLKNfktERyijiLSrsrT0qacOmefsEK/o5ThTPOh67LftL4osRRnJBpqMRcV
        JwIAg/fxwmACAAA=
X-CMS-MailID: 20200417181022epcas5p1f83138da6e76ff0917de88e913ef8e32
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181022epcas5p1f83138da6e76ff0917de88e913ef8e32
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181022epcas5p1f83138da6e76ff0917de88e913ef8e32@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds DT binding for samsung ufs hci

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
new file mode 100644
index 000000000000..954338b7f37d
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -0,0 +1,93 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/samsung,exynos-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung SoC series UFS host controller Device Tree Bindings
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+
+description: |
+  Each Samsung UFS host controller instance should have its own node.
+  This binding define Samsung specific binding other then what is used
+  in the common ufshcd bindings
+  [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+
+properties:
+
+  compatible:
+    enum:
+      - samsung,exynos7-ufs
+
+  reg:
+    items:
+     - description: HCI register
+     - description: vendor specific register
+     - description: unipro register
+     - description: UFS protector register
+
+  reg-names:
+    items:
+      - const: hci
+      - const: vs_hci
+      - const: unipro
+      - const: ufsp
+
+  clocks:
+    maxItems: 2
+    items:
+      - description: ufs link core clock
+      - description: unipro main clock
+
+  clock-names:
+    maxItems: 2
+    items:
+      - const: core_clk
+      - const: sclk_unipro_main
+
+  interrupts:
+    items:
+      - description: interrupt signal for various ufshc status
+
+  phys:
+    maxItems: 1
+    description:
+      phandle of the ufs phy node
+
+  phy-names:
+      const: ufs-phy
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phys
+  - phy-names
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/exynos7-clk.h>
+
+    ufs: ufs@15570000 {
+       compatible = "samsung,exynos7-ufs";
+       reg = <0x15570000 0x100>,
+             <0x15570100 0x100>,
+             <0x15571000 0x200>,
+             <0x15572000 0x300>;
+       reg-names = "hci", "vs_hci", "unipro", "ufsp";
+       interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
+       clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
+                <&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
+       clock-names = "core_clk", "sclk_unipro_main";
+       pinctrl-names = "default";
+       pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
+       pclk-freq-avail-range = <70000000 133000000>;
+       phys = <&ufs_phy>;
+       phy-names = "ufs-phy";
+    };
+...
-- 
2.17.1

