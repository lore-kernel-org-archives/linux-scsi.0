Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31780C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01539206F5
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iytxvzb6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgFMDFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:05:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42782 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgFMDE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:58 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200613030456epoutp040af6765b43ed8b0c6eeb7b8ae434c7c6~X_3pOmTXH2880928809epoutp04D
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200613030456epoutp040af6765b43ed8b0c6eeb7b8ae434c7c6~X_3pOmTXH2880928809epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017496;
        bh=tic87tYGoP0wf8PhTKj7y0fX/KpDctpqswklLi69jbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iytxvzb6I7rtCLAsN4jCJQwOr0/Jvzv1HxJJXle5fBxGCi9KbE/ZxeFZbBP5InrD8
         UTcfbe9Y3s7ZWLgQMFeNWB+RRDGasZtILHnEFBWHCIsSBc7E3GFjVCm2pnx0RAl1CB
         SDE70zPPfgWiRxZSX5QbruMZEDvrjXPlimN6VZto=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200613030455epcas5p314dcc2854587018a89d55c318e150dd8~X_3ohj4Fe2337923379epcas5p3L;
        Sat, 13 Jun 2020 03:04:55 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.ED.09467.65244EE5; Sat, 13 Jun 2020 12:04:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8~X_3nXEa3N3234132341epcas5p43;
        Sat, 13 Jun 2020 03:04:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030454epsmtrp2c883d7e8adc7d44f9846932bde0c5957~X_3nWUAm62362123621epsmtrp2x;
        Sat, 13 Jun 2020 03:04:54 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-89-5ee44256d900
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.62.08382.55244EE5; Sat, 13 Jun 2020 12:04:53 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030451epsmtip29e8b473731e2eeea6163401eda4a513d~X_3lZQc1X0718207182epsmtip2E;
        Sat, 13 Jun 2020 03:04:51 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for Samsung
 ufs host
Date:   Sat, 13 Jun 2020 08:17:04 +0530
Message-Id: <20200613024706.27975-9-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSaUwTQRSAne122TYWl2JgAM8mKqCgIOpqyhE1YT2DMRHFiFaZUOSqLYgS
        jAcEsPVoCQqoKURAFJVCrUKKIAJa8QKtoG1EUcFYNZXDgCeYshr/fW/e946ZDMkRqrieZFxS
        CpInSRJEBB+/0eLj7Re5vDd6wVgORvdobxC07XsnQQ/qLnDp4tbHXLqj7xhBt7dXO9EWwx2c
        1r/r4tJm4zmCLmxvxGjV8zqCrjCNYvTYzTonuvy6BYQ5M+YTxzFGX3mUYK6VHWSy2m7hzECf
        FWdOGCoBY3pRizFD+mlMTpMKi+BF8cUxKCFuL5LPD9nBl14pagOy+277HhW+A4dAmYsSkCSk
        guBVfbAS8EkhVQ9gR30JzgaDALY2VjqxwTCAOmsJoQS88YqaIiWHTTQAOPqrB7BBFgZzO3W4
        wyKoubC7wIA5eDLlCluHs4GDOZQNg8a3Mge7UpFQ/bmG42CcmgU7NXnjvoASw4umLi47bTq8
        XN007vCoYHh7rARzDIOUhoRZ2f0Ye4mVUDu4h/Vd4UeTwYllTzhkbyBYJR4eMy5kjzNgufYu
        znIobHp2DncoHMoH6ozz2S2d4fGfvX+bC2ButpC1Z8FMe+ffSi+oUam4rMJA/ZMD7COoAWy3
        m7lqMPXM/6YlAFQCDyRTJMYixSJZQBJK81dIEhWpSbH+u5IT9WD8v/iuqgPdPf3+zQAjQTOA
        JEc0WeDi/iZaKIiR7E9H8uTt8tQEpGgGXiQucheIvj2MFlKxkhQUj5AMyf9lMZLneQjzImUW
        /kRvXipSm+3pUpe8DRNePVw8aejwPd9LtYkXxS97MwQbyk4ZPtmj3fslMcTTH5uMmQuK4yt2
        /5inSokJNzdsW1/ct20zLy2zxm1n4ZLATCpn55yK2dqID6+38HJn+Ib87s6v3hf6LRj1loWc
        jLNGba0qwAtVpdT5O7dsI6s9/TZO+RX23mOs9KgJ5dvEE0atJz+9ya4qylnxfB45o81y9uk6
        jVJq8AgX9yNrS1iPy5zzK992OYvW8B/NrHa1oIgo4Zeq08Nrj9gCpdp18bqvDUWmI6W1y07t
        rlcrO0I1Aa/fZ6UsDSJ02vDAYq+BkQ/3Ri88eKFLKwjOXx9ZXy7CFVJJgC9HrpD8ARl0rg2e
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvG6o05M4gwX3TS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MpYM/MkY8EpsYqzMx4zNjAuEexi5OSQEDCR2DizixnEFhLY
        zSix6UclRFxa4vrGCewQtrDEyn/PgWwuoJomJonvL6eANbAJaEvcnb6FCcQWASo68q2NEaSI
        WeA7k8SBCRPAioQFQiWubNwPZrMIqEpcnTgJrIFXwEZixfFrrBAb5CVWbzgAVsMpYCtx8P8C
        JoiLbCR2H/3JOoGRbwEjwypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAQ19Lcwbh9
        1Qe9Q4xMHIyHGCU4mJVEeAXFH8YJ8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1
        OzW1ILUIJsvEwSnVwGSfkjdL46/hmigu3qrcpn8zY+Z2r+Za/P6B5YpHdXGX5+wpqVv3tEov
        +ccMfl+HjKSDBY/3883UCwm3qd29rfhRdLbcw4ei51jn5c2s1l6zpnDrbg5Ha7VMhY3Bq6xF
        5/X9dA5pNH5c81nMonCxZfMZu6Bg/W2n84Pk4ozut1iXBG9x+LnL0V/3Mk/ojZpnszUien+c
        2t3bU/vlkKrgvDfivNbpux5yH7PzeD6B1UlLeW4v181T30zVL8c5KHObGy/jjxBVF9zBlbOm
        Ve7QnxzTUCtjF3HHvrPP91vNm3Ot5snJoI6wzrJ290Xx7d8YDy6+dXdXPs9FloNPUqbM/vKj
        a6v4dTORgBXTC2YxKrEUZyQaajEXFScCABYBhCHgAgAA
X-CMS-MailID: 20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds DT bindings for Samsung ufs hci

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
new file mode 100644
index 000000000000..38193975c9f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -0,0 +1,89 @@
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
+    items:
+      - description: ufs link core clock
+      - description: unipro main clock
+
+  clock-names:
+    items:
+      - const: core_clk
+      - const: sclk_unipro_main
+
+  interrupts:
+    maxItems: 1
+
+  phys:
+    maxItems: 1
+
+  phy-names:
+    const: ufs-phy
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
+additionalProperties: false
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
+       phys = <&ufs_phy>;
+       phy-names = "ufs-phy";
+    };
+...
-- 
2.17.1

