Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71CDC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46B220CC7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fWPlbnMx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgCSPHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 11:07:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60431 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgCSPHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 11:07:08 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200319150705epoutp04ffd76e2c231e2581dc2fcb326efc95e6~9vPnpgEQs2525225252epoutp04c
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 15:07:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200319150705epoutp04ffd76e2c231e2581dc2fcb326efc95e6~9vPnpgEQs2525225252epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584630425;
        bh=5qDUTijKcFAre6lcv86TSthFVvifGYP26ZX+SiiMELQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWPlbnMxvxvwC36TRsY3VPzUtEqJDl9MobIV+Xl9TbXtlexLh3DRGR6lyBktjieeF
         tqsWADgInEZrx3EUtnWeznwUCs+KQ8m8hnRelEFpXzSbhV0P2ilv3BTcPPCkwtB3LC
         a49153CRe2648D7WYLKd0g5uruHr+ZZ9w3l+SLZc=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200319150704epcas5p4641617feed8159a6916b81240c0fb2b3~9vPmUi4oJ0491704917epcas5p4d;
        Thu, 19 Mar 2020 15:07:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.78.04782.79A837E5; Fri, 20 Mar 2020 00:07:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507~9vPlhPKFB0318203182epcas5p2D;
        Thu, 19 Mar 2020 15:07:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200319150703epsmtrp2f81c05237b5626a37b2833aa1e846dc5~9vPlgaxh41476414764epsmtrp2S;
        Thu, 19 Mar 2020 15:07:03 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-ab-5e738a97c43a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.C7.04158.79A837E5; Fri, 20 Mar 2020 00:07:03 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150701epsmtip29c57472630a1383081538127fc2ee78c~9vPjyxKYS0556705567epsmtip2W;
        Thu, 19 Mar 2020 15:07:01 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Date:   Thu, 19 Mar 2020 20:30:27 +0530
Message-Id: <20200319150031.11024-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319150031.11024-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsWy7bCmuu70ruI4g+ezLC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLFr3HmG3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEro/NuM0tBl0DF5+O9TA2Mm3m6GDk5JARMJKb/mMfcxcjFISSwm1FiY9NTRgjn
        E6PE1MNvmCCcb4wSt4+uZ4JpOb1pM1TVXkaJjw09UE4Lk8S2Hx1sIFVsAtoSd6dvAesQEQiQ
        uPT+IBtIEbPAPCaJRY96wBLCAt4SB09uZQaxWQRUJY78XA9m8wrYSCyd/pIdYp28xOoNB8Di
        nAK2EnMuXGcBGSQhcJtN4ubKc4wQRS4SM35dgLKFJV4d3wLVLCXx+d1eoM0cQHa2RM8uY4hw
        jcTSecdYIGx7iQNX5rCAlDALaEqs36UPEmYW4JPo/f2ECaKTV6KjTQiiWlWi+d1VqE5piYnd
        3awQtofE0T+/WSDhMIFRYnXHM+YJjLKzEKYuYGRcxSiZWlCcm55abFpgmJdarlecmFtcmpeu
        l5yfu4kRnFK0PHcwzjrnc4hRgINRiYd3RltxnBBrYllxZe4hRgkOZiURXt10oBBvSmJlVWpR
        fnxRaU5q8SFGaQ4WJXHeSaxXY4QE0hNLUrNTUwtSi2CyTBycUg2M4id21epH9c85KHRupuX5
        uyw2Z7ZNWeJ+LXf3z6wTYqUKc+rO5wn0WpRnKHJc+H3/3qeved7VZ7Psd5/g+hysv0ZbRSJ6
        +Zwn7+tW3Jk4f8LmmgM8LwPXJrw5zuPs1L0o5HtRoNnnqiD+08UZlxSUC/Km5js+VyhZNft6
        8fW4lh9Hf0098WL/eyWW4oxEQy3mouJEAJjOcaAlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSvO70ruI4g1m72CwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLFr3HmG3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEro/NuM0tBl0DF5+O9TA2Mm3m6GDk5JARMJE5v2szYxcjFISSwm1HiyqrDrBAJ
        aYnrGyewQ9jCEiv/PWeHKGpikjhyqxsswSagLXF3+hYmEFtEIEji3pq1rCBFzAKrmCQ6e88y
        giSEBbwlDp7cygxiswioShz5uR7M5hWwkVg6/SXUBnmJ1RsOgMU5BWwl5ly4zgJiCwHVdL66
        xjaBkW8BI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzggNbS2sF44kT8IUYBDkYl
        Hl6HluI4IdbEsuLK3EOMEhzMSiK8uulAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzy+ccihQTS
        E0tSs1NTC1KLYLJMHJxSDYyMzyW+rcrQur5LaYpWy3vltTumONvtLJ6dITJLMGzDhbZ/N7mk
        NbM2OJTKWPO5bMv4mvV2b4jLMx5XOwaBe11ZvJ3pFX/yN5/lFH99gVnU1VBbSEd+US3z/A3r
        HXTz5ut1HTrWMTdUfu2JEpuY2zP/WybctM/MKSq3vie+7a5L6ZGpfrpJekosxRmJhlrMRcWJ
        AALC1NZkAgAA
X-CMS-MailID: 20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
        <CGME20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507@epcas5p2.samsung.com>
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

base-commit: fb33c6510d5595144d585aa194d377cf74d31911
-- 
2.17.1

