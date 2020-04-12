Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4BDC2BB85
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567992078B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M7SBuoUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDLHmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:42:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55256 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgDLHmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 03:42:06 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200412074205epoutp026a6e7ab6546d122cdfa18e65d41f9fdf~FAp7rpYHy0904709047epoutp02Z
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 07:42:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200412074205epoutp026a6e7ab6546d122cdfa18e65d41f9fdf~FAp7rpYHy0904709047epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586677325;
        bh=PdZr65Wo5TW1cANP8kk5hrsoRREQWBxl8FwYNrvhuxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7SBuoUVAC/CowKwz91/zlp4phzOuhZ+YmncO69EfeRenS8qPWySGwea1dWDa6Euz
         L6jIQ0SHmjDuB759Sz8QhR2MXDMffeWzIs9PT2L/+Lq3DKoWGwDw4WX6kDCKLCxbQ9
         QFjkruufauVzbpfnXblLxgNspmS4ZXAbv4N6WLLU=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200412074204epcas5p2290bc7abe666298739815abcaec714f4~FAp6iYfLs1436314363epcas5p2u;
        Sun, 12 Apr 2020 07:42:04 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.91.04736.B46C29E5; Sun, 12 Apr 2020 16:42:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200412074203epcas5p4b8a73ef32cf27a3ebd9398caa69149a1~FAp55CYua1693016930epcas5p44;
        Sun, 12 Apr 2020 07:42:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200412074203epsmtrp29ed47a338efc3afbe9240a304d6ad3d7~FAp51lIiP0481304813epsmtrp24;
        Sun, 12 Apr 2020 07:42:03 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-a8-5e92c64be02a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.3E.04024.B46C29E5; Sun, 12 Apr 2020 16:42:03 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074201epsmtip16e8388ebcd66159ae232129f76e1acca~FAp35DDDA0326303263epsmtip1L;
        Sun, 12 Apr 2020 07:42:01 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Date:   Sun, 12 Apr 2020 13:01:55 +0530
Message-Id: <20200412073159.37747-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200412073159.37747-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmpq7PsUlxBtNdLR7M28Zm8fLnVTaL
        T+uXsVrMP3KO1eL8+Q3sFje3HGWx2PT4GqvF5V1z2CxmnN/HZNF9fQebxfLj/5gs/u/ZwW6x
        dOtNRgdej8t9vUwem1Z1snlsXlLv0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBHFJdNSmpO
        Zllqkb5dAlfGoe66gg2iFbev9LA2MG4T6GLk5JAQMJG4/PgIaxcjF4eQwG5GiTtHnzBDOJ+A
        nNvbGCGcb4wS+45/ZoVp6Z10CaplL6PE/Bt7oFpamCQ+fZ3NBlLFJqAtcXf6FiYQW0TAW+L9
        gfNgHcwC85gkFj3qAUsIAyXuTZvNCGKzCKhKrNjWA2RzcPAK2Eg8uxQCsU1eYvWGA8wgNqeA
        rcSCO11grbwCghInZz5hAbGZgWqat85mhqjvZ5e48JUTwnaROHz7GSOELSzx6vgWdghbSuLz
        u71sIKskBLIlenYZQ4RrJJbOO8YCYdtLHLgyhwWkhFlAU2L9Ln2ITXwSvb+fMEF08kp0tAlB
        VKtKNL+7CtUpLTGxuxsaVB4Sd1buZ4KEzgRGiT3zNzJOYJSfheSBWUgemIWwbQEj8ypGydSC
        4tz01GLTAuO81HK94sTc4tK8dL3k/NxNjOBUpeW9g3HTOZ9DjAIcjEo8vAeuTYwTYk0sK67M
        PcQowcGsJML7pBwoxJuSWFmVWpQfX1Sak1p8iFGag0VJnHcS69UYIYH0xJLU7NTUgtQimCwT
        B6dUAyPfSqOvL103f7H/HZlS8KWxIDK49pTylmqtq0ad/xb5KL7gE/Jd3/wpJOpXuFz6PnOj
        bSHH+5OUGH24xAqfKKV1RrOFstpLHii+oyRkdPLmq+8/W2vL7PrD7HNfK/BKb7oTYflB/Gm8
        89NINnuVhReYpsh75d3w6dZcxVHH8bRIVD/E5vkKJZbijERDLeai4kQAlbKYX1EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnK73sUlxBism8ls8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujEPddQUbRCtuX+lhbWDcJtDFyMkhIWAi0TvpEmsXIxeHkMBuRomnu7+zQCSk
        Ja5vnMAOYQtLrPz3nB2iqIlJ4ureeWwgCTYBbYm707cwgdgiAv4Sf74fAytiFljFJNHZe5YR
        JCEs4C1xb9psMJtFQFVixbYeIJuDg1fARuLZpRCIBfISqzccYAaxOQVsJRbc6QKbKQRU8nfH
        cbBWXgFBiZMzn7CAtDILqEusnycEEmYGam3eOpt5AqPgLCRVsxCqZiGpWsDIvIpRMrWgODc9
        t9iwwDAvtVyvODG3uDQvXS85P3cTIziytDR3MF5eEn+IUYCDUYmH98C1iXFCrIllxZW5hxgl
        OJiVRHiflAOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8z7NOxYpJJCeWJKanZpakFoEk2Xi4JRq
        YFzx0jNK4KhaW3GlxqX0IiarP5WsGo/tD61ad+MjP9sNrSN+Gl1TNn/eX1K15lKrXYTPIuM+
        4yl34yoyBOx7xeZ90YvmFNTdt/xJNcvLGR/z2rpWbw/49TeqbXOTzZ+YTUfuZq++FrYowlc6
        Vt1VTm21m4bPPZHEH7vOH3n3fJm6ROzVFi+vlUosxRmJhlrMRcWJADDWXraoAgAA
X-CMS-MailID: 20200412074203epcas5p4b8a73ef32cf27a3ebd9398caa69149a1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074203epcas5p4b8a73ef32cf27a3ebd9398caa69149a1
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
        <CGME20200412074203epcas5p4b8a73ef32cf27a3ebd9398caa69149a1@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..352d5dda320d
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,74 @@
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
+    description: PHY base register address
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

