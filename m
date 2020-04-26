Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1982AC7C886
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E522168B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EVNJHZ6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgDZRml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25065 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgDZRm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:29 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200426174226epoutp04d1b75e2edb5fa552be86218a4b5642ae~Jb4Ga3HP_1821218212epoutp04Q
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200426174226epoutp04d1b75e2edb5fa552be86218a4b5642ae~Jb4Ga3HP_1821218212epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922946;
        bh=N5xT+Tor3D+R1tVY/D303rOGE0vB3ZA1jQfCCEqyDjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVNJHZ6dWViafdHYMZ1IpxaGiHhzM0stNuPmDeFLZpJnQspxJOvWvXIEoqM++GJWl
         ygpYvjkscVkPFMHVvjr8syfIb7dbDNpStbS0QuM8J8NVEkbEmCeMsXq5mq8+IZTP0r
         YZhiY6EfTvEIaIGlUnVsgF8zqPfmBywS2inKgkCs=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200426174225epcas5p46e8ed90dac5869ac76c9554cb41cf820~Jb4F3I3Cg1741817418epcas5p46;
        Sun, 26 Apr 2020 17:42:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.23.10083.108C5AE5; Mon, 27 Apr 2020 02:42:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200426174224epcas5p43a1223a63bb414a5060fa9044681f933~Jb4ExKSu52671526715epcas5p4g;
        Sun, 26 Apr 2020 17:42:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200426174224epsmtrp2fce8c0694fa0809aba8db6b9a53e0c46~Jb4Ewaj651150211502epsmtrp2h;
        Sun, 26 Apr 2020 17:42:24 +0000 (GMT)
X-AuditID: b6c32a4a-875ff70000002763-90-5ea5c80128cc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.DC.25866.008C5AE5; Mon, 27 Apr 2020 02:42:24 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174222epsmtip10ef095e69617c0abf8d2f7f5c5415534~Jb4C3Asuq2817828178epsmtip1W;
        Sun, 26 Apr 2020 17:42:22 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 10/10] arm64: dts: Add node for ufs exynos7
Date:   Sun, 26 Apr 2020 23:00:24 +0530
Message-Id: <20200426173024.63069-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec9tx+HqNIUeJyQshFTUMosDeSuEjhES9SXDtJEHFZ2OHa8R
        aGhaTkUl8Yp28VJGKqZm03Ity0swI1Mz8lJNSCmrKWZZmdtR8tvveZ7//7m8vDQu7yUVdGxC
        Eq9NUMUrKSnR+dTN3RMN1EfsNcw5sTM1nRQ793OUYi0tDSRb22ci2eHhVgk70f6MYNs+jpHs
        iL6aYsuHH2OsbryLYhv7/2LsWk+XhK3vmEBBMm6ksADj2pquUtz9ugwue7CX4L7PviW4wvYm
        xC227eJyDTrsBH1G6hfFx8em8FrvgHPSmNLLJkrTC2l1Y7UoE0055CE7GhhfqL7Rg1lZznQj
        aC7zzkPSdbYg+D1ZgYnBIoLbeUa06SidMiOxoEewsvSVFINsDEwWE2lVUYwHTJa12/o6Mg7Q
        t5xjc+PMGwxm7gTnIZp2YALgQx1jTROMK6xZFiRWljH+0GxuxMVhLnC31WBju/X8ULkeEzU7
        YLDCTIgtXSCrowq37gBMDw2zxVOUaA6G+UsjhMgOMN/fLhFZAYsLjyjrDsDEQb5+v5i+CPU1
        zzfkgWB4XU1YJTjjBi16b3HUNihYNWOiUwZXcuSi2hWyFkY3nM5QrNORInPwaWlZIr5OEYL5
        X1WoCLlUbrmgcssFlf+nXUd4E3LiNYI6mhcOaHwS+FQvQaUWkhOivc4nqtuQ7Vu5H+tCDabj
        RsTQSGkvox/UR8hJVYqQrjYioHGloyw86WaEXBalSr/AaxMjtcnxvGBEzjSh3CkrIUfD5Uy0
        KomP43kNr92sYrSdIhOFdM/6OnVP5ufa89/G0gKaj8TNoIyHnzVH2SzfmHuKIIE7/GTPSuC4
        cWYVc/cN8trt6Rw5fVZaF4f/+CI99CfVzz8sp6Qg9VZI4PZTYwNhMSenPdw0oSvvpP5D3UOn
        kSMy6N4PBHOzoa+Izsiwln5jvA9Z0lRsabz2Ivngy+VyJSHEqPa541pB9Q93C1Q2UgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJTpfhxNI4g0tNPBYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFv/37GC3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY2rrObaC/RIVS67NZ2xgvCfcxcjJISFgIjH13hPGLkYuDiGBHYwSV2ceZIVI
        SEtc3ziBHcIWllj57zk7RFETk0TDy6VgRWwC2hJ3p29hArFFgIqOfGtjBLGZBZ4xSZx6WNrF
        yMEhLGAn8WiJAEiYRUBV4v+nd2AzeQVsJdY9Wc4MMV9eYvWGA2A2J1D81IxdTCCtQgI2EtPX
        +0OUC0qcnPmEBSTMLKAusX6eEMQieYnmrbOZJzAKzkJSNQuhahaSqgWMzKsYJVMLinPTc4sN
        C4zyUsv1ihNzi0vz0vWS83M3MYLjSktrB+OeVR/0DjEycTAeYpTgYFYS4Y0pWRQnxJuSWFmV
        WpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkmDk6pBqbjpRez9pXZXl/StjSF
        w/iZ1+8bmQu+Wc66peX04vc8wbXK9bYvXiZscl4yn20Zt58dT9Tp6PR+Udd1Dks/szFtZ/ac
        dFft44mJPKKf58ZNTeKYNMeG5drBVa/X9+idSv59Rl84Y8mU/V0HT886sOV6QKxQVcTcCbZa
        hx/Z8PwxvdmnEnfDSHCCk+NE4Ulcl4MfOtwqtPreKV7wad7bLe1r70u42XCVvpx16OzE0mgt
        xoPCndruc91ZlUMeBzLI3yjyOBOwpU5FOk6Ye8UBnYlS3vd2ba07Gv/p0nQnYe/H0gkvRMtF
        Z60vzI2z5W54qKjw2etRok1aeXuDz6n2crG4mx4+Xn+qJ+x3/2t4S0WJpTgj0VCLuag4EQBW
        zYpKGgMAAA==
X-CMS-MailID: 20200426174224epcas5p43a1223a63bb414a5060fa9044681f933
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174224epcas5p43a1223a63bb414a5060fa9044681f933
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174224epcas5p43a1223a63bb414a5060fa9044681f933@epcas5p4.samsung.com>
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

