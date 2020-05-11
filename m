Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A67C54E92
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB946206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MPxSZbl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgEKCON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:14:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36363 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbgEKCOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:14:10 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200511021408epoutp01e59a1ff29566578c871331aa6cac62a1~N1430t-jk2365623656epoutp015
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:14:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200511021408epoutp01e59a1ff29566578c871331aa6cac62a1~N1430t-jk2365623656epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163248;
        bh=Sjo2Sj1S7d70JVxw6eTgCHnZ/EiW76oG21OsjWYCQfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPxSZbl4RwVX4A4jkzwUfbhlLT0GhxvWv/hjnMnDDybqjPo9yEc6R0cdKrmGvaMzv
         JpHViFWBltd3ONpNj6vfBNNutE9CdH3IH1KfznMYnRzoMshS0Y8BjQTHqxSQa5n5Vb
         Dc4rPtaNGVsjTUobFnWDrAAT7p++0GDLC8r5vmKA=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200511021407epcas5p47d41152fcfdbf6766481e212d705036f~N142-BSTm2083520835epcas5p4J;
        Mon, 11 May 2020 02:14:07 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.D5.10010.FE4B8BE5; Mon, 11 May 2020 11:14:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021406epcas5p229fb46815d3c29ae06709fa6160e0308~N142pGjtn1638516385epcas5p2Q;
        Mon, 11 May 2020 02:14:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200511021406epsmtrp140579ea0a754f339916fccf4d5aab33f~N142oV1mk0628006280epsmtrp1o;
        Mon, 11 May 2020 02:14:06 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-a0-5eb8b4efcb8d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.F6.18461.EE4B8BE5; Mon, 11 May 2020 11:14:06 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021404epsmtip2826cd2568c416bac3779cc2b35773864~N140bQAEO0194601946epsmtip2t;
        Mon, 11 May 2020 02:14:04 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 08/10] dt-bindings: ufs: Add DT binding documentation for
 ufs
Date:   Mon, 11 May 2020 07:30:29 +0530
Message-Id: <20200511020031.25730-9-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZdlhTQ/f9lh1xBu2zeC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxsoVa9kLvopVTL++kbmBcZdgFyMHh4SAicTKXRxdjFwcQgK7GSVa/y5ihXA+
        MUrM/LKGBcL5xihxtqOHrYuRE6zj84OFjBCJvYwS3ZsWsUM4LUwSu26cAKtiE9CWuDt9CxOI
        LSIgLHHkWxsjiM0scINJ4sFKFxBbWCBIYvX2gywgNouAqsSKudvBbF4BG4nLWxYyQWyTl1i9
        4QAziM0pYCsxrWE72EkSAp0cEn/XbYAqcpHYu72VBcIWlnh1fAs7hC0l8bK/jR3i0WyJnl3G
        EOEaiaXzjkGV20scuDKHBaSEWUBTYv0ufYgz+SR6fz9hgujklehoE4KoVpVofncVqlNaYmJ3
        NytEiYfE84PCkFCYAAzFT69ZJzDKzkIYuoCRcRWjZGpBcW56arFpgWFearlecWJucWleul5y
        fu4mRnAy0fLcwXj3wQe9Q4xMHIyHGCU4mJVEeJfn7ogT4k1JrKxKLcqPLyrNSS0+xCjNwaIk
        zns6bUuckEB6YklqdmpqQWoRTJaJg1OqgWmbRd+rFxelutmZnlhXVRqc3Z6pVPmd0z3+s1HR
        n1rx34cEymTqns5sTFj7RaWjb9Mn5xxx3cv1Ntk+nDKNE2VjfHPOXd2ue/DbtZfRptOK//DG
        cXo37M/yPbjA716224qL5bZzLHz6LnIe3DhP4N385w9195io11gd5jsU4r3238+WGx6LfCS+
        P+KO965Ov/eK993Wa67vNLiOHhf5HCISOUcx09m34YLR/PuJbd27vmfZ3+fxP/PL1f8Ma1Jf
        bxlP1kP+zTGnMxb1pZaYN6Rqbl7W98f1+27Lo4dMZ6z7tUrpuCtzZIki/4nHCXx+H+89fvex
        OCtVY+OBCOnXrbsNTTtzblzOFdi618LrsRJLcUaioRZzUXEiAGaoI92VAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSvO67LTviDLa90bN4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGStXrGUv+CpWMf36RuYGxl2CXYycHBICJhKfHyxk7GLk4hAS2M0ose3CVSaI
        hLTE9Y0T2CFsYYmV/56zQxQ1MUnMvbKXGSTBJqAtcXf6FrAGEaCiI9/aGEFsZoFnTBKnHpZ2
        MXJwCAsESOx8HQASZhFQlVgxdzsLiM0rYCNxectCqF3yEqs3HAAbySlgKzGtAaJGCKhmxqbN
        rBMY+RYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOZi3NHYzbV33QO8TIxMF4
        iFGCg1lJhHd57o44Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3ChfGCQmkJ5akZqemFqQWwWSZ
        ODilGpj6vk3YXztjS/gPUZHPX246r/g54bKb77HmzyrSXZV72qZFNSRc/3tkF692389f+z4X
        z3l82kf72UaXqXemJqgxt614J8ds9fHBeqWkpM1zP+vsL+iMOLPqQNXR6xXKm00czBr6Cm8v
        OsAR92zp66zHBaslXD32uAkuf7s/+GGm48QpctNC4rlUmAUP7v73V1Xeu7n9zg/v99vE1dKL
        srWXZsxY2dn78sqyr6GfllraOXoV6lgfPMb33nGSqnl6+F07rWsPshq/Sn2Y1/lqWlFUxt6l
        k/8ynN33b0nWRFHZPW7lF37b624oVHlucDOsjDMj5zGTtPSNzUu77+15K/On8/x2ube9jF1z
        vr+M92z8qcRSnJFoqMVcVJwIAEs9FtTVAgAA
X-CMS-MailID: 20200511021406epcas5p229fb46815d3c29ae06709fa6160e0308
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021406epcas5p229fb46815d3c29ae06709fa6160e0308
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021406epcas5p229fb46815d3c29ae06709fa6160e0308@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds DT binding for samsung ufs hci

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
new file mode 100644
index 000000000000..0c50f5cb4619
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -0,0 +1,92 @@
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
+       pclk-freq-avail-range = <70000000 133000000>;
+       phys = <&ufs_phy>;
+       phy-names = "ufs-phy";
+    };
+...
-- 
2.17.1

