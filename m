Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A18C433E5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8601E20659
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hEuX2L7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgENAxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46096 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbgENAxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:14 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200514005310epoutp02e94a6ba9381287211e6c32c769cfc89c~OvuCWkJHd1742217422epoutp02R
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200514005310epoutp02e94a6ba9381287211e6c32c769cfc89c~OvuCWkJHd1742217422epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417590;
        bh=fsRDJ0h1yMqYOs2pKmhnI3SSBhLPwZ2LmEElFF1iDFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEuX2L7sJ5o+imcGGMpdVEiOG4SBEd7lXJQoMcDAtUxyvB4oaU9AuXWjfdkEokqzA
         ZQ0prrn5oxlZ7C9IndV279cJgJbslh0KRg4B/NuZSShDcI9/3voPrgi7KqzKFJU699
         ISPOV7bp+ky5dMcBUZMVBNZH0efKVMHtb1k8AfAQ=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200514005309epcas5p27113d13454cd01894936bc8f55161f72~OvuB1adoU0273002730epcas5p2e;
        Thu, 14 May 2020 00:53:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.DC.23569.5769CBE5; Thu, 14 May 2020 09:53:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e~OvuBbgG0_1578415784epcas5p3G;
        Thu, 14 May 2020 00:53:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200514005309epsmtrp224ed3faf75c752ee13c0017b331eee76~OvuBashdq1517815178epsmtrp2i;
        Thu, 14 May 2020 00:53:09 +0000 (GMT)
X-AuditID: b6c32a4a-3c7ff70000005c11-1a-5ebc96751802
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.D3.18461.5769CBE5; Thu, 14 May 2020 09:53:09 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005307epsmtip25acec01adf94242af8a3656d6a121a34~Ovt-lAjNf3258132581epsmtip2x;
        Thu, 14 May 2020 00:53:07 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 08/10] dt-bindings: ufs: Add DT binding documentation for
 ufs
Date:   Thu, 14 May 2020 06:09:12 +0530
Message-Id: <20200514003914.26052-9-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsWy7bCmum7ptD1xBnu3qlk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujOYvyxkL9olVTPn/nKmBsV+wi5GDQ0LAROLJJp4uRi4OIYHdjBJ//39jh3A+
        MUrsWb2OGcL5xiixpPMFWxcjJ1jHpZfX2EFsIYG9jBLPD6dC2C1MEo8v6oLYbALaEnenb2EC
        sUUEhCWOfGtjBLGZBW4wSTxY6QJiCwsESXS1bWIDuYJFQFVi+01xkDCvgI3E/0PfGSFWyUus
        3nCAGcTmFLCV2PLlGCtEvJND4lRzOYTtIrFu/TaoemGJV8e3sEPYUhKf3+1lg3gyW6JnlzFE
        uEZi6bxjLBC2vcSBK3NYQEqYBTQl1u/ShziST6L39xMmiE5eiY42IYhqVYnmd1ehOqUlJnZ3
        Qx3jIbFtz0QWSEBNYJT4cf0F6wRG2VkIUxcwMq5ilEwtKM5NTy02LTDKSy3XK07MLS7NS9dL
        zs/dxAhOI1peOxgfPvigd4iRiYPxEKMEB7OSCK/f+t1xQrwpiZVVqUX58UWlOanFhxilOViU
        xHmTGrfECQmkJ5akZqemFqQWwWSZODilGpgK17HdF/7V4DHRR+bM5PsXQhe2Z92NdZ5fLM9w
        vvbG4h6Wo2uMy3bPiOmQajgue+FHnfUsQ8E5gRevPniZLXp7dZR3RoiU1OMDP9n5jW6f3fFg
        K+eJvy80wg6XLWUIklj2zWT/x4ZrOx9OOanzTHq+odqBl6k6tbusA9NWzes12Kb5vjPr+p+6
        axE+Dwu1nkipVkZPvzflW9k7cemo6aeep6y4fLDylXiqt43sK+2VEw5fyhASnZ/EvihCUeLz
        36eBWXefeogdebu9vDJ4Zqf4nJboc7NFJS8/e1qgbqNgta5j17/e1StKP2qcOW/DZXvATvv9
        Y7GuZ5oVN/kCH5cyLH1T9L9/SvTTOQoz51x/osRSnJFoqMVcVJwIAIml5TmSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSvG7ptD1xBtPXClg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujOYvyxkL9olVTPn/nKmBsV+wi5GTQ0LAROLSy2vsXYxcHEICuxklNvzuYINI
        SEtc3ziBHcIWllj57zlUUROTxIpN05hBEmwC2hJ3p29hArFFgIqOfGtjBLGZBZ4xSZx6WApi
        CwsESJzo/c3SxcjBwSKgKrH9pjhImFfARuL/oe+MEPPlJVZvOAA2klPAVmLLl2OsILYQUM2y
        NcsYJzDyLWBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERzMWpo7GLev+qB3iJGJ
        g/EQowQHs5IIr9/63XFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8ULowTEkhPLEnNTk0tSC2C
        yTJxcEo1MKWUiumY3VjLGc8zv+/z95v9b6cIGIuZzlQ+VmjUkD/vheTWR8dKZ00ybZVh9f5a
        E7Ryo98C7cOcyXsaVmant73edbfMXVmIiXvNSv4j/5gFtd9qXsmoPat1een3rKhA72ru6q1G
        /kvTUz4Lijoe0zX5dN760eQ/kW5Nb7jvrxHePe9cpjy3Sov6l0XpdfMfLty81ynimHPy2Vnr
        fjUET57XUO3e+feJs+XL27/YRTKM7fI3t6+N4X+wtPj/oWkXelNmHE5uyPvOpV7A6J4tIvbV
        x7y6rCHw2oI7U2U68zL+SDz4o9T/+Ooh8exy3wQOGw6G53uuv3j+f8u1bcWbbb5bz/XN76vZ
        tas15MrP+UosxRmJhlrMRcWJAFpRpVTVAgAA
X-CMS-MailID: 20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds DT binding for samsung ufs hci

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
new file mode 100644
index 000000000000..eaa64cc32d52
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -0,0 +1,91 @@
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
+    maxItems: 1
+
+  phys:
+    maxItems: 1
+
+  phy-names:
+    maxItems: 1
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

