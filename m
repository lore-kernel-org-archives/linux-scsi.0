Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C687C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0508D20FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tz5jcXY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgE1Bcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35219 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgE1Bcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:48 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200528013246epoutp0243dc454fc476e0fb2ddb13cbdff65e62~TDSnBaDHT3030230302epoutp02u
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200528013246epoutp0243dc454fc476e0fb2ddb13cbdff65e62~TDSnBaDHT3030230302epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629566;
        bh=YqesGE9QRWzbUFapaH4d6ciy/qj5O7BFUrBR3w8MJ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tz5jcXY5hipzfZ3eh1NCnkPzpSQIlJBgyxkI27ctPmIAhKlzJyqOLcGF8HbrIkkf8
         STDaPUsrm4AZ+wZUkfx9MIv/En97YoiNfRyj4DzB0uv6K/Su8jvBEuAMr5nSKUjLDB
         4vxD8LdFTfTW+4fDP3GDvu1qosod8L9Puv1twR8Q=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200528013245epcas5p38aa13d5d814a3fa69821a0fe32d92eae~TDSmTrT1u1669616696epcas5p3a;
        Thu, 28 May 2020 01:32:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.20.09467.DB41FCE5; Thu, 28 May 2020 10:32:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200528013245epcas5p37851891649512882c7b1ffb5f903c506~TDSl0hDU21669616696epcas5p3X;
        Thu, 28 May 2020 01:32:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200528013245epsmtrp157c7b006bc9e5ef5e23d76b2ebcf1cba~TDSlzfQkC0638506385epsmtrp1u;
        Thu, 28 May 2020 01:32:45 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-5e-5ecf14bdaa52
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.F7.08382.CB41FCE5; Thu, 28 May 2020 10:32:44 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013243epsmtip1e2ac487d7a5b5c26119f98d65a37b08f~TDSj95nFz1371113711epsmtip1X;
        Thu, 28 May 2020 01:32:42 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 10/10] arm64: dts: Add node for ufs exynos7
Date:   Thu, 28 May 2020 06:46:58 +0530
Message-Id: <20200528011658.71590-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRj1d3d3dxVntyn1peRqYOVK0+xxQ0srqxuhlARGkTbspuJ0ujkr
        CVovLTdzReSrXIUVrUSbU2w1s+U0qTRaZrkEQ6MHYdpbKqvrNeq/851zvu8cfvxIgaRW6E+m
        Z+Wy6iyFUkZ44Y13gueE2P26ksJ6LIF0f1UjQb8Z7SboD7UXhbSptVNId3XViehnVidOWwae
        CGmX7TRBl3U1Y7S+p4mgL7WPYfSvm00i+kLDMxQjZlzHijHGYj5KMPXV+5hDHbdwZuRlL84c
        s5oR89ESyBS26LEN5BavqB2sMj2PVc9fvt0rrfoVkV0Eu7+2W0Q6dM23CHmSQC2E0WEnUYS8
        SAl1A4FzpFzEDx8QmBsvC/jhC4KHpmrB3xWX8T3iBTuCoWankBMk1CEMDpxL5DBBzYW+UivG
        YT/KF1q/FCAOC6inGPRfjuWwLxUNledHx3mcCoIfxuFxLKaWgb2qVciHSeFKXcufYJL05Hhj
        DG+ZDB3lgzh/UgoHGyrHiwJVQ4Ku1Sri/EDFwmdrAH/GF962czSH/eFNScGEJQMMtgie3gsX
        qtpwHkdDy+PTOGcRUMFQa5vPJ/lA8fdBjN8Uw5ECCe8OgoND3RObAXBcr5/ozsD9qw8x/m2M
        CGy1KUYkrfivf8V//Sv+hZ1FAjOaxmZrMlNZzaLs8Cx2V6hGkanRZqWGpqgyLWj8T8nXNaG+
        /uFQB8JI5EBACmR+4pUP7iVJxDsUe/JZtSpZrVWyGgcKIHHZVLHs2/0kCZWqyGUzWDabVf9V
        MdLTX4eV1GhLG8Lk+pThTzGHFxm8zynnDc7BH0TE3Z3iPYg5ZhauD4k2N2GTNzhzQjrl8wLD
        PidXOlweRet+HO6f7fM42t7TtlM14u02/6rJX5gRuQSNbRo7n7/CXb96qbIgMcGxatbmd6cM
        L8p0vaatjvePYgdKc+NK3KdeR1bqrHtMCfa3cfa2+LD1nt2TPJq93enJweayjrwcQ+OLVaap
        3T2SgZzmOunzSMJe6PqU0LKADU8ox7Wh18/4eRydtbJ4o6N+m2trg8/atqhlYMjYeYu0xZuF
        eRdvnwiSfp2+YMXP+CBX7/7rwhuqqDWLT+a7h9wb1xRr5S8TY/e+s4hVkXU/Z8hwTZoiXC5Q
        axS/AcbguGnCAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LZdlhJTnePyPk4g23frC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxpLnbAVdEhXfj29ib2DcKNzFyMkhIWAicXnCe0YQW0hgN6PE5Gk5EHFpiesb
        J7BD2MISK/89Z4eoaWKSOHucB8RmE9CWuDt9CxOILQJUc+RbG9gcZoFnTBKnHpaC2MIC9hKz
        F/0Ei7MIqEr8mfABzOYVsJXYO+8IK8R8eYnVGw4wdzFycHCCxCc4QKyykZiwai9UuaDEyZlP
        WEBKmAXUJdbPE4LYJC/RvHU28wRGwVlIqmYhVM1CUrWAkXkVo2RqQXFuem6xYYFhXmq5XnFi
        bnFpXrpecn7uJkZwTGlp7mDcvuqD3iFGJg7GQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQW
        H2KU5mBREue9UbgwTkggPbEkNTs1tSC1CCbLxMEp1cCkO6+7wUaOaZ5TrOPEd7PLnRKunnFb
        NU9T+XxN8q65Vy6qbdJezhbyZZJ2+XKhinPx3z4032Pb9Ct/yrL1GeoJXR/uHxe3yWiLtbcI
        uB995dPSkxbH/h5q8hPwcl1fleT5O89bee+7oy/jyy5rPszbHqEk9CVRrtU/Mjhs2sp9/Rfe
        h05dVBi492jW7AIDbrm7+kd1y9fblz2fepqPLX8X97qfzZqMx3hEuT5cM5//q+esO1vtRJNe
        njuTnQzcutxquz51CL8yW/OWKyGx4x2bBqPM4q1TVlo3c227czLvQ3i14CzB2SIXF7r8OSJg
        bKjcanr/4ZZtZvzbZm2tmPBg3Y9nJ0Ka+4+JLzxvotuvxFKckWioxVxUnAgAnWVK0BgDAAA=
X-CMS-MailID: 20200528013245epcas5p37851891649512882c7b1ffb5f903c506
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013245epcas5p37851891649512882c7b1ffb5f903c506
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013245epcas5p37851891649512882c7b1ffb5f903c506@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding dt node foe UFS and UFS-PHY for exynos7 SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../boot/dts/exynos/exynos7-espresso.dts      |  4 ++
 arch/arm64/boot/dts/exynos/exynos7.dtsi       | 43 ++++++++++++++++++-
 2 files changed, 45 insertions(+), 2 deletions(-)

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
index 5558045637ac..300ad7326ea8 100644
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
+			phys = <&ufs_phy>;
+			phy-names = "ufs-phy";
+			status = "disabled";
+		};
+
+		ufs_phy: ufs-phy@15571800 {
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

