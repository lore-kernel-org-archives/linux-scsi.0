Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3102C2D0F0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7830D2082F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fAUiBLpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgC0RO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:14:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47607 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgC0RO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:14:26 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200327171424epoutp03ede9d1a12385dd2f9f6e93f4fb2b1a88~AOJEOUKBZ1871718717epoutp03G
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 17:14:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200327171424epoutp03ede9d1a12385dd2f9f6e93f4fb2b1a88~AOJEOUKBZ1871718717epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585329264;
        bh=RwV5Vt68kQmcCoecxf1d7B1jkFqNuPCLo2zXINj7zdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAUiBLpw/y4LNiUkipPcspT/horE3f4+9uIcw0JdbSIssjzCL48TN+JpMnRgwBZ9J
         dMdYKvkUzKG/rnGQqi3+R7mE347g3Rewh+3ykEkSz59Xu6mXIhgW/tJhBZ+qfqNgPO
         VMB32SmrCYDdgX7HZE5KYUNoKBEnYCZXHrU5Vi9Q=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200327171423epcas5p25f8a266ced89a692fd25b71e606630e9~AOJDG9ACR1294012940epcas5p2w;
        Fri, 27 Mar 2020 17:14:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.4F.04778.F643E7E5; Sat, 28 Mar 2020 02:14:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a~AOJC3QT1v2894128941epcas5p4i;
        Fri, 27 Mar 2020 17:14:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200327171423epsmtrp22b7cfbb603a0c44e4524f18d459bad14~AOJC2UKZo2787527875epsmtrp2W;
        Fri, 27 Mar 2020 17:14:23 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-c3-5e7e346fd5b6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.4E.04158.E643E7E5; Sat, 28 Mar 2020 02:14:22 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200327171421epsmtip1bea67745c10da7983bb01cc87a795c46~AOJA_lYih1865318653epsmtip1U;
        Fri, 27 Mar 2020 17:14:20 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
Date:   Fri, 27 Mar 2020 22:36:38 +0530
Message-Id: <20200327170638.17670-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327170638.17670-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe0hTYRjG+c5tR2lymJavEw0GShpeKsMTWBlEHEJKiP6ohrnyoKLOsaOW
        YjXI5WVqKqESNjOvzWQyL03L2/JCUFrqLIMgdBYmKE2KrLA6HqP/fs/zPu/Dy8dH44pKUkmn
        arN4vVaTrqI8id5nISFhmVHXEyIbmhn2g7mXYpc3nBTrtraQbP3oJMlOTXXK2PnuMYK1Lc6R
        7Ex/HcXWTg1irOmNnWJbJzYx1jgwKmObe+ZRrJybKS/DOJulmOK6mm5wBc+HCO7L0juCK++2
        IG7dFsgVDpuwePq8Z0wSn56aw+sjjiR6pqx2reG6ceXV8kcGzIBGdpYgDxqYKJhdeYFKkCet
        YJ4gKO58TUrCjeB2h3NbfENg+rEqK0H01spc0y7JH0BgNw4RkijAYLnHSIm9FLMX3td0YyL7
        MPEwvTZCiSGcMWPwYKF0a+DNxMD8dCshMsEEQYfdRoos/+u7OqQiYHZDe+cwLrIHcxje9lXj
        YhEwixQ8nnVjUug4GDcWttkbPk90yyRWwvrqACWdnQal/QckOx+azeOExEdheLaOECM4EwLW
        /gjRxhkvKPvpwqRNORTdUkjpILi56tze9IdKk4mUmIPe9lfbj1WBwDregVeggLv/W+8jZEF+
        vE7ISOaFg7r9Wv5KuKDJELK1yeGXMzNsaOujhJ60o5bJOAdiaKTaIW9zXktQkJocITfDgYDG
        VT7ypXP5CQp5kiY3j9dnXtRnp/OCA/nThMpXXkU61QomWZPFp/G8jtf/m2K0h9KA4j86zjnG
        veLctVmDE7ro7/dyg+FC0q+8xmT1glA9GKAO/Co87DUXjvnFeucFnw01RBf1fbI0GFsjtKej
        g1+eWVlfsyyqFXG+/WFr5ScacWs7BFyyei1tBrpMd/KN9a68+qe/S41zWFtC68Ii5Ve1Rymz
        UzWnlkCtjUw8dkhFCCmafaG4XtD8AavbkkwkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnG6eSV2cQec3C4sH87axWbz8eZXN
        4tP6ZawW84+cY7U4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi9a9R9gt
        lm69yejA63G5r5fJY9OqTjaPzUvqPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKeLf5PXPBMamKvjUNTA2MB0W7GDk4JARMJK4tEeti5OIQEtjNKNF87yhrFyMn
        UFxa4vrGCewQtrDEyn/P2SGKmpgkZv+6xASSYBPQlrg7fQuYLSIQJHFvzVpWkCJmgVVMEp29
        ZxlBEsICNhI3Ly1nAbFZBFQl1u7YBLaBFyj+ZG0rG8QGeYnVGw4wg9icArYSN3ZOA7OFgGo+
        NB1gnsDIt4CRYRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnA4a2ntYDxxIv4QowAH
        oxIP74qrtXFCrIllxZW5hxglOJiVRHifRtbECfGmJFZWpRblxxeV5qQWH2KU5mBREueVzz8W
        KSSQnliSmp2aWpBaBJNl4uCUamAsPDnjqNNizaLV71b9P52VVSXjMmn29qCKg6d4Z8pPU1AL
        LSn6eFr9ZorpjDnzzgQZaN162KjT0dOndusLw27nUKYI3jUfWUtM8+d+zPvV1vCTv+GNavdL
        H7tnCrumrWgzenLpKWd55RrmOof1j088/8xnJs3h6GSunxqsMKdAsyy3XnBJX6ESS3FGoqEW
        c1FxIgAavTr8YwIAAA==
X-CMS-MailID: 20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding dt node foe UFS and UFS-PHY for exynos7 SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../boot/dts/exynos/exynos7-espresso.dts      | 16 +++++++
 arch/arm64/boot/dts/exynos/exynos7.dtsi       | 43 ++++++++++++++++++-
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index 7af288fa9475..b59a0a32620a 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -406,6 +406,22 @@
 	};
 };
 
+&ufs {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
+	ufs,pwr-attr-mode = "FAST";
+	ufs,pwr-attr-lane = <2>;
+	ufs,pwr-attr-gear = <2>;
+	ufs,pwr-attr-hs-series = "HS_rate_b";
+	ufs-rx-adv-fine-gran-sup_en = <1>;
+	ufs-rx-adv-fine-gran-step = <3>;
+	ufs-rx-adv-min-activate-time-cap = <9>;
+	ufs-pa-granularity = <6>;
+	ufs-pa-tacctivate = <3>;
+	ufs-pa-hibern8time = <20>;
+};
+
 &usbdrd_phy {
 	vbus-supply = <&usb30_vbus_reg>;
 	vbus-boost-supply = <&usb3drd_boost_5v>;
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 5558045637ac..9d16c90edd07 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -220,9 +220,14 @@
 			#clock-cells = <1>;
 			clocks = <&fin_pll>, <&clock_top1 DOUT_ACLK_FSYS1_200>,
 				 <&clock_top1 DOUT_SCLK_MMC0>,
-				 <&clock_top1 DOUT_SCLK_MMC1>;
+				 <&clock_top1 DOUT_SCLK_MMC1>,
+				 <&clock_top1 DOUT_SCLK_UFSUNIPRO20>,
+				 <&clock_top1 DOUT_SCLK_PHY_FSYS1>,
+				 <&clock_top1 DOUT_SCLK_PHY_FSYS1_26M>;
 			clock-names = "fin_pll", "dout_aclk_fsys1_200",
-				      "dout_sclk_mmc0", "dout_sclk_mmc1";
+				      "dout_sclk_mmc0", "dout_sclk_mmc1",
+				      "dout_sclk_ufsunipro20", "dout_sclk_phy_fsys1",
+				      "dout_sclk_phy_fsys1_26m";
 		};
 
 		serial_0: serial@13630000 {
@@ -601,6 +606,40 @@
 			};
 		};
 
+		ufs: ufs@15570000 {
+			compatible = "samsung,exynos7-ufs";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <0x15570000 0x100>,  /* 0: HCI standard */
+				<0x15570100 0x100>,  /* 1: Vendor specificed */
+				<0x15571000 0x200>,  /* 2: UNIPRO */
+				<0x15572000 0x300>;  /* 3: UFS protector */
+			reg-names = "hci", "vs_hci", "unipro", "ufsp";
+			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
+				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
+			clock-names = "core_clk", "sclk_unipro_main";
+			freq-table-hz = <0 0>, <0 0>;
+			pclk-freq-avail-range = <70000000 133000000>;
+			ufs,pwr-local-l2-timer = <8000 28000 20000>;
+			ufs,pwr-remote-l2-timer = <12000 32000 16000>;
+			phys = <&ufs_phy>;
+			phy-names = "ufs-phy";
+			status = "disabled";
+		};
+
+		ufs_phy: ufs-phy@0x15571800 {
+			compatible = "samsung,exynos7-ufs-phy";
+			reg = <0x15571800 0x240>;
+			reg-names = "phy-pma";
+			samsung,pmu-syscon = <&pmu_system_controller>;
+			#phy-cells = <0>;
+			clocks = <&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
+				<&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
+			clock-names = "ref_clk_parent", "ref_clk";
+		};
+
 		usbdrd_phy: phy@15500000 {
 			compatible = "samsung,exynos7-usbdrd-phy";
 			reg = <0x15500000 0x100>;
-- 
2.17.1

