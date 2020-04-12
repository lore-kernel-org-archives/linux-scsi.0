Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D6BC2BA2B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1012070A
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O771hhU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgDLHm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:42:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31030 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgDLHm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 03:42:27 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200412074225epoutp044e6a7dbb756a3a27ff336a884936e31d~FAqOtqxXX2807828078epoutp048
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 07:42:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200412074225epoutp044e6a7dbb756a3a27ff336a884936e31d~FAqOtqxXX2807828078epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586677345;
        bh=N5xT+Tor3D+R1tVY/D303rOGE0vB3ZA1jQfCCEqyDjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O771hhU9fHl7qtpoo//QASdxW8Cb7BuohomzAFNQ+Oc8TMRGFMuxkVWH1Zh84jZMz
         CwwvzYFalVWfftmNDeVA5Z3v95xRqVqkCwQ4jn15SymVlYT23ikv8kKuIgHdJ1vGUP
         rXfvNAvFIyxp13vrcScUkX9J8Ter6L+CbMzDb8Bs=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200412074225epcas5p1fa3c900d928ebc52df3ae18fcd9c000d~FAqOE0RpX1241512415epcas5p1_;
        Sun, 12 Apr 2020 07:42:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.B2.04782.066C29E5; Sun, 12 Apr 2020 16:42:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200412074224epcas5p27defe5eab7d264dc6d7cfb032a76d3fb~FAqNO37y91436314363epcas5p2y;
        Sun, 12 Apr 2020 07:42:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200412074224epsmtrp1a40e1aec7b204b29bf9780cdf48532b4~FAqNOK8TW1966119661epsmtrp14;
        Sun, 12 Apr 2020 07:42:24 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-08-5e92c66000e2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.3E.04024.F56C29E5; Sun, 12 Apr 2020 16:42:24 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074221epsmtip1d4c122ecdaca83eb02bd92dbd3809e71~FAqLEsSgP0407304073epsmtip1G;
        Sun, 12 Apr 2020 07:42:21 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 5/5] arm64: dts: Add node for ufs exynos7
Date:   Sun, 12 Apr 2020 13:01:59 +0530
Message-Id: <20200412073159.37747-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200412073159.37747-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUhUYRSG+e42V2vsNk540lKZ0lBJExNuoBUUdaOgwPwjag55U9EZbcY1
        hCTNdMadzJrcMBe0Hy6N5lYOZm6EBuaWW6gVWiQuBCVqzlwl/z3nPe/L+x34aFxiIK3pMGU0
        r1LKI2SUOdH0zunEyaDuvMBTWUle7JfiJopd+DNMsSu1lSRb0jVAsoODdSJ2XP+eYBvmRkh2
        qLWQYp8OvsVY7WgzxVb1bGLsVnuziK1oHEfnxdxQVibGNdSkU9yr8vtcSl8HwS1//UxwWfoa
        xK022HKPDFrsBu1n7hXMR4TF8iq3s0HmofkPB6ioDogvHylBSWjaUoPMaGBOQ++PMVyDzGkJ
        04ZgLPkvEoYVBGWFqzvDbwSj7f34bqR0IYkUFm8QTHct7uRTMFibnKCMLopxgakCPWZkKXMV
        lgyDpgTOFGNQNpthWlgyXvDg2YxIg2iaYBxg64XSKIu35f7SKUpos4OXdQZTsxnjDaWTGkzw
        HIS+Z/OEkfFtT3Ljc9MjgMkWwfr3J0gIX4SC7k2RwJaw2KPfYWtYyE419QITDhmtHoKcCBXF
        3YTA58DwqZAwWnDGCWpb3YQqC8hcn8eEpBjSUiWC2wGSfw3vJG0gV6slBeZAX9diYgmTg6Bk
        QpGD7HR7DtDtOUD3v6wU4TXoMB+lVoTwas8odyUf56qWK9QxyhDX25GKBmT6V85XmpFu4Fon
        Ymgk2y82jOQGSkh5rDpB0YmAxmVS8XzctiQOlifc41WRt1QxEby6E9nQhMxKnEcO+0uYEHk0
        H87zUbxqd4vRZtZJ6KhHNambdLAqcjmzMZPgI0K1aT7ytDvOh7Q/JRZdOYkf/RP81uyz0kXX
        pQsZM8dLfEMd03VSe2LDNn+g43Jyr2o2uCmmRuV54XFV+esPS8Px9XPVawcc27z3WaARpduy
        zeKlImlL87HYgJu+lfUBR/T2msVvQ/EhU3fz1t1Tt9ZkhDpU7u6Mq9TyfxJHS45TAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnG7CsUlxBmdrLB7M28Zm8fLnVTaL
        T+uXsVrMP3KO1eL8+Q3sFje3HGWx2PT4GqvF5V1z2CxmnN/HZNF9fQebxfLj/5gs/u/ZwW6x
        dOtNRgdej8t9vUwem1Z1snlsXlLv0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBHFJdNSmpO
        Zllqkb5dAlfG1NZzbAX7JSqWXJvP2MB4T7iLkZNDQsBEYsHLBtYuRi4OIYHdjBKbzsxhg0hI
        S1zfOIEdwhaWWPnvOTtEUROTxLbtO8ESbALaEnenb2ECsUUE/CX+fD8GVsQssIpJorP3LCNI
        QljARqJp5n2gBAcHi4CqxP/FeSBhXqDwqQV3oZbJS6zecIAZxOYUsJVYcKcLbKYQUM3fHccZ
        IeoFJU7OfMICMoZZQF1i/TwhkDAzUGvz1tnMExgFZyGpmoVQNQtJ1QJG5lWMkqkFxbnpucWG
        BYZ5qeV6xYm5xaV56XrJ+bmbGMGRpaW5g/HykvhDjAIcjEo8vAeuTYwTYk0sK67MPcQowcGs
        JML7pBwoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdp3rFIIYH0xJLU7NTUgtQimCwTB6dUA6N+
        YtQ5jo6j6qVv2K2cdC1PL7p08ZmlvMVXG0mN26/zFjTbz1luuHqFhr+Fj65me5j2dLPAK89e
        et5Y4bm4ap9xx6ZPs/75LuPaNav85lQe18yP8XkZvy3/TLrk+3K6PB/3y+7bH6+cmnzP6mNV
        4qVnn/rSJKaciTSd1DHjU/GUr2Xv3lt5+HQosRRnJBpqMRcVJwIAyqpg0agCAAA=
X-CMS-MailID: 20200412074224epcas5p27defe5eab7d264dc6d7cfb032a76d3fb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074224epcas5p27defe5eab7d264dc6d7cfb032a76d3fb
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
        <CGME20200412074224epcas5p27defe5eab7d264dc6d7cfb032a76d3fb@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding dt node foe UFS and UFS-PHY for exynos7 SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../boot/dts/exynos/exynos7-espresso.dts      |  4 ++
 arch/arm64/boot/dts/exynos/exynos7.dtsi       | 44 ++++++++++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index 7af288fa9475..790f12ca8981 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -406,6 +406,10 @@
 	};
 };
 
+&ufs {
+	status = "okay";
+};
+
 &usbdrd_phy {
 	vbus-supply = <&usb30_vbus_reg>;
 	vbus-boost-supply = <&usb3drd_boost_5v>;
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 5558045637ac..0c1ebd3ea294 100644
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
@@ -601,6 +606,41 @@
 			};
 		};
 
+		ufs: ufs@15570000 {
+			compatible = "samsung,exynos7-ufs";
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
+			pinctrl-names = "default";
+			pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
+			pclk-freq-avail-range = <70000000 133000000>;
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
+			clocks = <&clock_fsys1 SCLK_COMBO_PHY_EMBEDDED_26M>,
+				 <&clock_fsys1 PHYCLK_UFS20_RX1_SYMBOL_USER>,
+				 <&clock_fsys1 PHYCLK_UFS20_RX0_SYMBOL_USER>,
+				 <&clock_fsys1 PHYCLK_UFS20_TX0_SYMBOL_USER>;
+			clock-names = "ref_clk", "rx1_symbol_clk",
+				      "rx0_symbol_clk",
+				      "tx0_symbol_clk";
+		};
+
 		usbdrd_phy: phy@15500000 {
 			compatible = "samsung,exynos7-usbdrd-phy";
 			reg = <0x15500000 0x100>;
-- 
2.17.1

