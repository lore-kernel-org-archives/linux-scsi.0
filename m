Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4748BC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172D420409
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Kq00mnAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCFPKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:10:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43626 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgCFPKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2020 10:10:31 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200306151030epoutp027068554ca263aee2feffe931e9084ef4~5v54wDYv71874718747epoutp02s
        for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2020 15:10:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200306151030epoutp027068554ca263aee2feffe931e9084ef4~5v54wDYv71874718747epoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583507430;
        bh=Uv4cai3N/6iGiG+frqpXISdvuE4Q8SV0BV8u68PjRt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kq00mnAmiD9l5aDJ5ccZR+Vs23eWp7KCyLgmVwP0dtZ3mJBn3+aO3S+zhQmFiIW64
         34M1JmtFt6wzk+XBEhgQeo8aHE26ErPy11+Mh4/UzfzIsIYKLPYZBlFSkvRgpjPPmB
         CEpkTseasmVYmSqpuMeDmyOKYJzMZJ5RCDtwKqZw=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200306151028epcas5p3d69f1b1620a40b2f7212e02e8c875574~5v53gmdVe2035720357epcas5p32;
        Fri,  6 Mar 2020 15:10:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.14.20197.4E7626E5; Sat,  7 Mar 2020 00:10:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200306151028epcas5p25ec9ccacedf49fa47ebb94bcdff42c54~5v53IuP8v2890128901epcas5p2K;
        Fri,  6 Mar 2020 15:10:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200306151028epsmtrp25864d648bdb966e92e8102eb7bc59ca5~5v53H-DSy3206832068epsmtrp2g;
        Fri,  6 Mar 2020 15:10:28 +0000 (GMT)
X-AuditID: b6c32a4a-781ff70000014ee5-0a-5e6267e496ed
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.32.10238.4E7626E5; Sat,  7 Mar 2020 00:10:28 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200306151026epsmtip1e2fe9ac0d6c97df9c3a1f53f7a38116a~5v51p22VU0060400604epsmtip1V;
        Fri,  6 Mar 2020 15:10:26 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 5/5] arm64: dts: Add node for ufs exynos7
Date:   Fri,  6 Mar 2020 20:35:29 +0530
Message-Id: <20200306150529.3370-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306150529.3370-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsWy7bCmuu6T9KQ4g0+3tC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsei+voPNYvnxf0wWrXuPsFss3XqT0YHL43JfL5PHplWd
        bB4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZZxoOspasFO64ljT
        OtYGxjeiXYycHBICJhJfv61i62Lk4hAS2M0oMW3mbnYI5xOjxMEZr5khnG+MEveur2GCafly
        oYkVxBYS2Mso8XVqMURRC5PE8y+b2UESbALaEnenbwFrEBEIkLj0/iDYDmaBrYwSrdeWABVx
        cAgLWErs++INUsMioCqx6MQkVpAwr4C1xMNuR4hd8hKrNxxgBrE5BWwkfiy6BXaQhMABNonZ
        vyezQhS5SMx/vYAdwhaWeHV8C5QtJfH53V42kJkSAtkSPbuMIcI1EkvnHWOBsO0lDlyZwwJS
        wiygKbF+lz5ImFmAT6L39xMmiE5eiY42IYhqVYnmd1ehOqUlJnZ3Qx3gIbH6/WI2SIj0M0rM
        PSY9gVF2FsLQBYyMqxglUwuKc9NTi00LjPJSy/WKE3OLS/PS9ZLzczcxgpOEltcOxmXnfA4x
        CnAwKvHwOlgnxQmxJpYVV+YeYpTgYFYS4RU2jY8T4k1JrKxKLcqPLyrNSS0+xCjNwaIkzjuJ
        9WqMkEB6YklqdmpqQWoRTJaJg1OqgXH+VK7T6/+zV3VNSf9y6W/LhPBpNitbi7WqHO/zPjCf
        zmTQKBh41qC9wvCd2rz+81HshquWHIt+smTPBXHr/wf0hE4WBHXprD+1ecu8jyfk5ZMuNBzm
        /H2h5JjKDpZFjw99WKawzEJgjmfBixsNDK0TPMtCU1fKnvxRLi9w+NLXS0kd3N7Rhz4qsRRn
        JBpqMRcVJwIAH12Hpw4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnO6T9KQ4g/5DQhYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWHRf38Fmsfz4PyaL1r1H2C2Wbr3J6MDlcbmvl8lj06pO
        No+Wk/tZPD4+vcXi0bdlFaPH501yHu0HupkC2KO4bFJSczLLUov07RK4Mk40HWUt2Cldcaxp
        HWsD4xvRLkZODgkBE4kvF5pYuxi5OIQEdjNKvF/fxAKRkJa4vnECO4QtLLHy33N2iKImJokf
        U68xgiTYBLQl7k7fwgRiiwgESdxbsxZsErPAXkaJzUePATkcHMIClhL7vniD1LAIqEosOjEJ
        LMwrYC3xsNsRYr68xOoNB5hBbE4BG4kfi26B2UJAJednbWCfwMi3gJFhFaNkakFxbnpusWGB
        YV5quV5xYm5xaV66XnJ+7iZGcJhqae5gvLwk/hCjAAejEg/vDNukOCHWxLLiytxDjBIczEoi
        vMKm8XFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZ/mHYsUEkhPLEnNTk0tSC2CyTJxcEo1MDKw
        aq68tuLifalXRqmGte5WC7fGLRG62lHenxtp4L4xQ6Ng+aHDCbarMyR27b0dc+8C74LJLi2z
        v1XlmTK8eausofVrjnZELfsTXtM/R4U/M3NsTX/te+2aVG+QwkE9n4V5aUn5uy6ULL6/6Mrx
        BlOTWS/YWxgMbxxrDLm14ibfCx3O/9amIkosxRmJhlrMRcWJADQw0yJPAgAA
X-CMS-MailID: 20200306151028epcas5p25ec9ccacedf49fa47ebb94bcdff42c54
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151028epcas5p25ec9ccacedf49fa47ebb94bcdff42c54
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151028epcas5p25ec9ccacedf49fa47ebb94bcdff42c54@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding dt node foe UFS and UFS-PHY for exynos7 SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../boot/dts/exynos/exynos7-espresso.dts      | 16 ++++++
 arch/arm64/boot/dts/exynos/exynos7.dtsi       | 56 ++++++++++++++++++-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index 7af288fa9475..dee5a3ae7de3 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -410,3 +410,19 @@
 	vbus-supply = <&usb30_vbus_reg>;
 	vbus-boost-supply = <&usb3drd_boost_5v>;
 };
+
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
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 5558045637ac..3edf63d18873 100644
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
@@ -634,6 +639,53 @@
 				phy-names = "usb2-phy", "usb3-phy";
 			};
 		};
+
+		ufs: ufs@15570000 {
+			compatible ="samsung,exynos7-ufs";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg =
+				<0x15570000 0x100>,  /* 0: HCI standard */
+				<0x15570100 0x100>,  /* 1: Vendor specificed */
+				<0x15571000 0x200>,  /* 2: UNIPRO */
+				<0x15572000 0x300>;  /* 3: UFS protector */
+			reg-names = "hci", "vs_hci", "unipro", "ufsp";
+			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
+			clocks =
+				/* core clock */
+				<&clock_fsys1 ACLK_UFS20_LINK>,
+				/* unipro clocks */
+				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
+			clock-names =
+				/* core clocks */
+				"core_clk",
+				/* unipro clocks */
+				"sclk_unipro_main";
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
+			clocks =
+				/* refclk clocks */
+				<&clock_fsys1 MOUT_FSYS1_PHYCLK_SEL1>,
+				<&clock_top1 CLK_SCLK_PHY_FSYS1_26M>;
+			clock-names =
+				/* refclk clocks */
+				"ref_clk_parent",
+				"ref_clk";
+		};
 	};
 
 	timer {
-- 
2.17.1

