Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36545C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0142320CC7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ebPNSCH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgCSPHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 11:07:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17285 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgCSPHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 11:07:15 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200319150713epoutp01658dbb5cb4a68931f2254c08f5722210~9vPvKPg4t2717527175epoutp01Y
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 15:07:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200319150713epoutp01658dbb5cb4a68931f2254c08f5722210~9vPvKPg4t2717527175epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584630433;
        bh=RwV5Vt68kQmcCoecxf1d7B1jkFqNuPCLo2zXINj7zdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebPNSCH9rsGJigl4nuLqs0H0TNNOGLfmSpIS3pk89ABhhP1Vso52/tWqQlnm+ocms
         AiVERvR6UIl02woBx3L87aQSbzVmnL0tKHXmYxGKi3trcZcJ4SV2MhXOF0Qlm01L0D
         MXMzMmaIvpPy0DuWbDf15oHrSOKa3r4S1BJa3rjM=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200319150712epcas5p3b259584313f5cdcbbc0b85af09ea20e4~9vPuFeoEL2928829288epcas5p3S;
        Thu, 19 Mar 2020 15:07:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.26.04778.0AA837E5; Fri, 20 Mar 2020 00:07:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150712epcas5p24e99ea681e65e14cd2ca815b78ad0957~9vPt0l3JD1427414274epcas5p24;
        Thu, 19 Mar 2020 15:07:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200319150712epsmtrp140ea347eb4528ebe45ceaca0d63aa7c0~9vPty_fo_0357603576epsmtrp1j;
        Thu, 19 Mar 2020 15:07:12 +0000 (GMT)
X-AuditID: b6c32a4a-353ff700000012aa-d4-5e738aa0ed70
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.C7.04158.F9A837E5; Fri, 20 Mar 2020 00:07:11 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150710epsmtip2adc5f1a20c9c7e26761a97114114bbbb~9vPr9SItU0525805258epsmtip2N;
        Thu, 19 Mar 2020 15:07:09 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 5/5] arm64: dts: Add node for ufs exynos7
Date:   Thu, 19 Mar 2020 20:30:31 +0530
Message-Id: <20200319150031.11024-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319150031.11024-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmuu6CruI4g3vzhCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLFr3HmG3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEr493m98wFx6Qq+tY0MDUwHhTtYuTkkBAwkVj3ZyVzFyMXh5DAbkaJCzMmQjmf
        GCVOLrrABuF8Y5Ton3CNBabl+t1fUIm9jBJLfrSAJYQEWpgk/m1SA7HZBLQl7k7fwgRiiwgE
        SFx6fxCsgVlgHpPEokc9YAlhARuJu5tvsYHYLAKqEssWrmMGsXmB4le6+tkhtslLrN5wACzO
        KWArMefCdRaQQRICt9kknizdBnWSi8T0KxugGoQlXh3fAmVLSbzsbwOyOYDsbImeXcYQ4RqJ
        pfOOQbXaSxy4MocFpIRZQFNi/S59kDCzAJ9E7+8nTBCdvBIdbUIQ1aoSze+uQnVKS0zs7maF
        sD0k+k4cgIbJBEaJWw9msU9glJ2FMHUBI+MqRsnUguLc9NRi0wKjvNRyveLE3OLSvHS95Pzc
        TYzghKLltYNx2TmfQ4wCHIxKPLwz2orjhFgTy4orcw8xSnAwK4nw6qYDhXhTEiurUovy44tK
        c1KLDzFKc7AoifNOYr0aIySQnliSmp2aWpBaBJNl4uCUamDkmxLHoup44I+O9/M/NvecBPQn
        Hz12eXeFz/wix/nZ51q6v66yPP69269UxC3uat7jRywMLl63V04/e+x0sV773k8pu1jW2rje
        vWSn5rXv9OqCjNwZ5VYXd/JGlB5y0H4cXMpw53/gFW1xMfZrjzNmPxPj4TnQ2bF9Pqf7M6b2
        8GtNW5QbHsoqsRRnJBpqMRcVJwIAsXinLiQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSvO78ruI4gwdfbSwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLFr3HmG3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEr493m98wFx6Qq+tY0MDUwHhTtYuTkkBAwkbh+9xdbFyMXh5DAbkaJPzO/MUMk
        pCWub5zADmELS6z895wdoqiJSWLixnZGkASbgLbE3elbmEBsEYEgiXtr1rKCFDELrGKS6Ow9
        C1YkLGAjcXfzLTYQm0VAVWLZwnVgG3iB4le6+qE2yEus3nAALM4pYCsx58J1FhBbCKim89U1
        tgmMfAsYGVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgQHtJbWDsYTJ+IPMQpwMCrx
        8Dq0FMcJsSaWFVfmHmKU4GBWEuHVTQcK8aYkVlalFuXHF5XmpBYfYpTmYFES55XPPxYpJJCe
        WJKanZpakFoEk2Xi4JRqYFxzQzxD5tDrO/ftlyhfk4/S+sY1UW759HVN6Xl9pzY0MjPNCEl2
        vm99n/dGYvK39yZm6TzlUlH31mt0B4fIzMy+aKSnGCbrWnnYyylqydqj4nKxs8Iud/yTDFu5
        bFfc02WcYU7b/7T/WpnhVZMeWld+Z+cSlxMWXNqZHXz3PZfMmHHiTrfLNyWW4oxEQy3mouJE
        ACQ6OEpkAgAA
X-CMS-MailID: 20200319150712epcas5p24e99ea681e65e14cd2ca815b78ad0957
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319150712epcas5p24e99ea681e65e14cd2ca815b78ad0957
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
        <CGME20200319150712epcas5p24e99ea681e65e14cd2ca815b78ad0957@epcas5p2.samsung.com>
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

