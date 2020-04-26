Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08165C7C885
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEED921707
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ru3QAE3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgDZRmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33798 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgDZRmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:23 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200426174221epoutp0317588ccde069034e605fa9ab998bd62e~Jb4CVcGK11078010780epoutp03B
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200426174221epoutp0317588ccde069034e605fa9ab998bd62e~Jb4CVcGK11078010780epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922941;
        bh=HisTscgOdzzOb+y3T3lOdgunVqX2gCoBzsP3vUe7Hys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru3QAE3lmGGCnMZYD41WHQ1Y4naRSK9k/t8JlGJIQA6DHlwciMw6LoXgvVU7/YWi5
         sk99DnPLIWb5f2/XkV/fMpxgdLvhq9NyXBaDssjWcWOWU7+RY/aFLKNQYezAzNIMK5
         9ogPD8zdhHocoYBo7YXSMIEcAfdUuC1+CrBjJfXE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426174221epcas5p221417f320fa986ff7388a5e0c62ab720~Jb4BvxTwX0053600536epcas5p2j;
        Sun, 26 Apr 2020 17:42:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0C.DE.04736.CF7C5AE5; Mon, 27 Apr 2020 02:42:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200426174219epcas5p460c8637629afd930313ae0fa936593cd~Jb4ApSQta2671526715epcas5p4f;
        Sun, 26 Apr 2020 17:42:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426174219epsmtrp163c11c8803367755f7cdd9cb28e4b503~Jb4AofeF40798907989epsmtrp1Y;
        Sun, 26 Apr 2020 17:42:19 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-0a-5ea5c7fc0736
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.FF.18461.BF7C5AE5; Mon, 27 Apr 2020 02:42:19 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174217epsmtip1fad4b19c55f05919c9010c10af56539c~Jb3_x6_JI0513305133epsmtip1F;
        Sun, 26 Apr 2020 17:42:17 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 08/10] dt-bindings: ufs: Add DT binding documentation for
 ufs
Date:   Sun, 26 Apr 2020 23:00:22 +0530
Message-Id: <20200426173024.63069-9-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdlhTQ/fP8aVxBp9/W1g8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJbPexgLzohXTLu2jrmB8bNgFyMnh4SAicStDQvZuhi5OIQEdjNKTG+7xALh
        fGKUmHnxKFTmG6PEh7YTTDAtrbteMYLYQgJ7GSV231OFKGphknj4qZ0ZJMEmoC1xd/oWsAYR
        AWGJI9/awBqYBW4wSTxY6QJiCwsESby8+wOshkVAVaLx4Q4wm1fARuLOhM8sEMvkJVZvOAA2
        k1PAVuLUjF1MIMskBDo5JC59uAA0lAPIcZFY88cRol5Y4tXxLewQtpTEy/42doiSbImeXcYQ
        4RqJpfOOQY23lzhwZQ4LSAmzgKbE+l36EFfySfT+fsIE0ckr0dEmBFGtKtH87ipUp7TExO5u
        VgjbQ2L9hhdMkFCYwCgxZ+oclgmMsrMQpi5gZFzFKJlaUJybnlpsWmCcl1quV5yYW1yal66X
        nJ+7iRGcTLS8dzBuOudziFGAg1GJh5dj+9I4IdbEsuLK3EOMEhzMSiK8MSWL4oR4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzTmK9GiMkkJ5YkpqdmlqQWgSTZeLglGpgLG+8l2ynlad6YmXGtoKE
        f3u9dpW0bLZV/Cb87PSy3u/Lj6fm67yoC9PNe//S0qhVxffatUKxhSkvG088+ODs4O2/tfnO
        Qc0Zk7VjioM5j916tGTW5DkJXZ/3lsQvS57h2mJ92239RIvJyRvKJlofk20ozf+3+F13W5fQ
        ZEvPlW/1/zwWeJkwQ4mlOCPRUIu5qDgRAKN5poIiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnO7v40vjDHbd07d4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGS2f9zAWnBGvmHZtHXMD42fBLkZODgkBE4nWXa8Yuxi5OIQEdjNKNB78zgaR
        kJa4vnECO4QtLLHy33N2iKImJomrS08xgyTYBLQl7k7fwgRiiwAVHfnWxghiMws8Y5I49bAU
        xBYWCJD40XaWFcRmEVCVaHy4A6yeV8BG4s6EzywQC+QlVm84ADaTU8BW4tSMXUA1HEDLbCSm
        r/efwMi3gJFhFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcDBrae5g3L7qg94hRiYO
        xkOMEhzMSiK8MSWL4oR4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgST
        ZeLglGpgWpF5X+ZB8uLj/g2vNa+8j5/94NAuw4TDm2yF/zB83KQ2q8P/i/S8eT3ZlT9aQmYe
        t5/WzSC7dtv1chsjc4Epp2wqZ7j8n5+n0ui+84KLqWdWhVd02Mc29h1CHvfqL05S4fXe4Px6
        3pXbmSKT/3NpVKgeO/Sw9uwFzqKoJqMkkeVsIsua1v9dz5g+ea5x2Jx3O2fW3Fo6Ydv/l78r
        EtuW+n72EHNft2JO8pSa14oFHfuc38yWPmikmMPAef5gBENToExNXtZ1a4k2idtdJla858U3
        LqqZVPT6+q3ajyZr3+o/Nsk6q3F5opaAXdtk34WNfhe0Xee4tkUEVuUf8azzXVOxbcLn7lqO
        B9MS7lu7K7EUZyQaajEXFScCAF2myyDVAgAA
X-CMS-MailID: 20200426174219epcas5p460c8637629afd930313ae0fa936593cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174219epcas5p460c8637629afd930313ae0fa936593cd
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174219epcas5p460c8637629afd930313ae0fa936593cd@epcas5p4.samsung.com>
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

