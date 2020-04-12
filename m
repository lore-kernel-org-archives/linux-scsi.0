Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07850C352BE
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD80E20732
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qpZUG7X8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgDLHmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:42:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45420 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgDLHmP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 03:42:15 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200412074214epoutp016b380b84a5165351e9650f5408b3b838~FAqD0Itn20625806258epoutp01O
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 07:42:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200412074214epoutp016b380b84a5165351e9650f5408b3b838~FAqD0Itn20625806258epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586677334;
        bh=HisTscgOdzzOb+y3T3lOdgunVqX2gCoBzsP3vUe7Hys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpZUG7X8L/RpjViiKEoktKyW67yymWi1UhjTJN77Z96TQBKbms45n2uYTUTBbW6Dc
         T0LeieLBfy2yOwZcZ/+rbtdJqrE4Ul9FEZkFLJNw0dfeokzmYQtVbo/ypYqyxKndZh
         qkzYKZv/e/To1nV76JVwGowzj9n0sb+zxE42uImY=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200412074212epcas5p157a6c3d573a6977f5c472a7e1cb9792b~FAqCpOw1y1241512415epcas5p17;
        Sun, 12 Apr 2020 07:42:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.91.04736.456C29E5; Sun, 12 Apr 2020 16:42:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200412074211epcas5p400dd260cd52a8eff831834f24fa2d113~FAqBiWisS2151521515epcas5p4J;
        Sun, 12 Apr 2020 07:42:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200412074211epsmtrp16dbf1893f021e29ae40bec90243a5ed0~FAqBhqWsY1966119661epsmtrp12;
        Sun, 12 Apr 2020 07:42:11 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-b2-5e92c654f8de
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.2D.04158.356C29E5; Sun, 12 Apr 2020 16:42:11 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074209epsmtip1714ac1e01afc681462976f6471d51582~FAp-mONBD0326303263epsmtip1M;
        Sun, 12 Apr 2020 07:42:09 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 3/5] dt-bindings: ufs: Add DT binding documentation for
 ufs
Date:   Sun, 12 Apr 2020 13:01:57 +0530
Message-Id: <20200412073159.37747-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200412073159.37747-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmhm7IsUlxBn9OaVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJbPexgLzohXTLu2jrmB8bNgFyMnh4SAiUTnoS1MXYxcHEICuxklHhy5xQrh
        fGKU6P/+jwXC+cYoMeNFM2MXIwdYy9Z9tRDxvYwST3+dgipqYZJYc3YuI8hcNgFtibvTQeZy
        cogIeEu8P3AebCyzwDwmiUWPesASwgIBEjf/PmAFsVkEVCVOHl0L1swrYCPRteswK8SB8hKr
        NxxgBrE5BWwlFtzpAjtWQuA+m8Ta/ftYIIpcJG5emM0OYQtLvDq+BcqWknjZ38YOcXa2RM8u
        Y4hwjcTSecegWu0lDlyZwwJSwiygKbF+lz5ImFmAT6L39xMmiE5eiY42IYhqVYnmd1ehOqUl
        JnZ3Q13pIXHiwlFmSDhMYJR42HuGaQKj7CyEqQsYGVcxSqYWFOempxabFhjnpZbrFSfmFpfm
        pesl5+duYgQnFC3vHYybzvkcYhTgYFTi4T1wbWKcEGtiWXFl7iFGCQ5mJRHeJ+VAId6UxMqq
        1KL8+KLSnNTiQ4zSHCxK4ryTWK/GCAmkJ5akZqemFqQWwWSZODilGhiDNJivSNR9mPju3m6r
        PycsPY3Cbf7unywzy0Ft5XeVyRySKjpapVNblnaWfRCc73BO8PDTbLG/GUZX8sM3/grq9J7s
        duIb55YJ84VC+ifYKE/u9qxaolpmXH/jWaH3gcov1adqk1idt/lenMofsrXUi+Hl/bP7H6z6
        yTD1tPUeW3/V9S4T1gsqsRRnJBpqMRcVJwIAe8xuRyQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnG7wsUlxBi+nyFs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJbPexgLzohXTLu2jrmB8bNgFyMHh4SAicTWfbVdjFwcQgK7GSUOn5zH3sXI
        CRSXlri+cQKULSyx8t9zdoiiJiaJg5MWMIIk2AS0Je5O38IEYosI+Ev8+X4MrIhZYBWTRGfv
        WUaQDcICfhInLweB1LAIqEqcPLoWrJdXwEaia9dhVogF8hKrNxxgBrE5BWwlFtzpApspBFTz
        d8dxxgmMfAsYGVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgQHs5bWDsYTJ+IPMQpw
        MCrx8B64NjFOiDWxrLgy9xCjBAezkgjvk3KgEG9KYmVValF+fFFpTmrxIUZpDhYlcV75/GOR
        QgLpiSWp2ampBalFMFkmDk6pBkaRrqcX3IvY26XPHfXa9Cx/tbbazVBuTq1APb2Ypzaz1O9W
        dU+5+1nJZH3YkuIvPcxfPIzt9Deyy8U5XmgJ6HqcKbZiVXHPj8+zDWqOOX5ummP7oM5JQdvR
        U+NDe0XY+rkJaup7/sYZzy0ImZ07c3vyt91WqVFPleofpzw+Z7Jgpf5a4Z4jc5RYijMSDbWY
        i4oTAcVUdkdiAgAA
X-CMS-MailID: 20200412074211epcas5p400dd260cd52a8eff831834f24fa2d113
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074211epcas5p400dd260cd52a8eff831834f24fa2d113
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
        <CGME20200412074211epcas5p400dd260cd52a8eff831834f24fa2d113@epcas5p4.samsung.com>
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

