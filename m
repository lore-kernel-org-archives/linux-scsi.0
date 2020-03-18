Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254CAC5ACDA
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E46C72077B
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EuNqq+Eb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgCRLSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:18:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13901 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgCRLSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 07:18:16 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200318111814epoutp034f32004243522923f6f254770bb2e3e6~9YehoVUts3163831638epoutp030
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2020 11:18:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200318111814epoutp034f32004243522923f6f254770bb2e3e6~9YehoVUts3163831638epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584530294;
        bh=RwV5Vt68kQmcCoecxf1d7B1jkFqNuPCLo2zXINj7zdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuNqq+Ebf2ibB905JdLYQrqPvWlu61iCmBYmAHk1YSrVkPzPamwwknswb8/FZiyw7
         V8cfKNyeYVD0ZV6LjYPn7aVhEvZZcWQYwVulGS9BlON6gcv3+IKE23lZOI5Xys9wLi
         9IM1yPAwJHNiLfRbpDvfQ0REDGQFD0SHCd7yEGqg=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200318111814epcas5p3f0ed04cea7d7d6a37ac3a32f33b4be5e~9YehKDpgA1474914749epcas5p3J;
        Wed, 18 Mar 2020 11:18:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.4E.04736.673027E5; Wed, 18 Mar 2020 20:18:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200318111813epcas5p126d7b871b194385099e8f71f2461303e~9YegtQjL53102031020epcas5p1y;
        Wed, 18 Mar 2020 11:18:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200318111813epsmtrp18970350639785df9a67d3d1338c3f535~9YegsYLCj1841218412epsmtrp1w;
        Wed, 18 Mar 2020 11:18:13 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-23-5e72037625d6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.3D.04024.573027E5; Wed, 18 Mar 2020 20:18:13 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200318111811epsmtip25f1300dc888d520b56e28e072c69fd62~9Yee_CYG00622906229epsmtip2x;
        Wed, 18 Mar 2020 11:18:11 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 5/5] arm64: dts: Add node for ufs exynos7
Date:   Wed, 18 Mar 2020 16:41:44 +0530
Message-Id: <20200318111144.39525-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318111144.39525-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmhm4Zc1GcwYkl3BYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFq17j7Bb
        LN16k9GB1+NyXy+Tx6ZVnWwem5fUe7Sc3M/i8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CV8W7ze+aCY1IVfWsamBoYD4p2MXJySAiYSDxom83UxcjFISSwm1Hie8N/Vgjn
        E6PEji+P2CGcb4wSnx49ZoNpOfjuN1TVXkaJA7vnMUI4LUwS146/ZwKpYhPQlrg7fQuYLSIQ
        IHHp/UE2kCJmgXlMEose9QAlODiEBWwk7l+1AalhEVCVOPnnFTOIzQsU/nOomRFim7zE6g0H
        wOKcArYSf++2gi2TELjPJjGx+SsrRJGLxOy5T6AahCVeHd/CDmFLSbzsb2MH2SUhkC3Rs8sY
        IlwjsXTeMRYI217iwJU5LCAlzAKaEut36YOEmQX4JHp/P2GC6OSV6GgTgqhWlWh+dxWqU1pi
        Ync31AEeEv9mTWCDBMMERolTDeuYJzDKzkKYuoCRcRWjZGpBcW56arFpgXFearlecWJucWle
        ul5yfu4mRnBC0fLewbjpnM8hRgEORiUeXo4NBXFCrIllxZW5hxglOJiVRHgXF+bHCfGmJFZW
        pRblxxeV5qQWH2KU5mBREuedxHo1RkggPbEkNTs1tSC1CCbLxMEp1cBYN11A2kwgcs0mm+NN
        hzY4xG6d7mp/pFr2iQ7Hqmd992Z6eNgIT+uVmChfMPt/WH7FqnblR+s+a2dvqJybXd46LTTq
        VtpkuUPnTjBNK3WZlHXixlVjtunCOm+/V2Zfenuh6oxK8Ow9hzcl2EftM3k+t3DrmpUzdb/p
        zn/Kb+56XP6eZ+uvCfv+KLEUZyQaajEXFScCAA/WmvckAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvG4pc1GcQUO3msWDedvYLF7+vMpm
        8Wn9MlaL+UfOsVqcP7+B3eLmlqMsFpseX2O1uLxrDpvFjPP7mCy6r+9gs1h+/B+TReveI+wW
        S7feZHTg9bjc18vksWlVJ5vH5iX1Hi0n97N4fHx6i8Wjb8sqRo/Pm+Q82g90MwVwRHHZpKTm
        ZJalFunbJXBlvNv8nrngmFRF35oGpgbGg6JdjJwcEgImEgff/WYFsYUEdjNKLO7PgohLS1zf
        OIEdwhaWWPnvOZDNBVTTxCTxcHkzM0iCTUBb4u70LUwgtohAkMS9NWtZQYqYBVYxSXT2nmXs
        YuTgEBawkbh/1QakhkVAVeLkn1dgvbxA4T+HmhkhFshLrN5wACzOKWAr8fduKyPEQTYSxyb/
        YpnAyLeAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwMGtp7mC8vCT+EKMAB6MS
        D2/CpoI4IdbEsuLK3EOMEhzMSiK8iwvz44R4UxIrq1KL8uOLSnNSiw8xSnOwKInzPs07Fikk
        kJ5YkpqdmlqQWgSTZeLglGpgnGkQVfHx3z9uqae1ja947JSK1GYslFerOFOQbx+h+YgrXK1Y
        2mLS7p9p6YsKJQ0qVvfP6Ha+5TlXalXHPfE3t3838AhaTg35LSUvk3Xr5IvE7V1TWSc8zP/m
        wZCbfz2MS27izgUqGVNVhfOk5uVUs/xJ7N5zpGZ9SKRc3stpSVusnVNU8zcosRRnJBpqMRcV
        JwIALZ7MAmICAAA=
X-CMS-MailID: 20200318111813epcas5p126d7b871b194385099e8f71f2461303e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200318111813epcas5p126d7b871b194385099e8f71f2461303e
References: <20200318111144.39525-1-alim.akhtar@samsung.com>
        <CGME20200318111813epcas5p126d7b871b194385099e8f71f2461303e@epcas5p1.samsung.com>
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

