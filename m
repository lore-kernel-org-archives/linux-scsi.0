Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF8BC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964082053B
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZEDK2gbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgFMDFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:05:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10161 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgFMDFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:05:01 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200613030459epoutp019926a2104edc15f4dbdf85d356c4fdc5~X_3sNQZb63032330323epoutp01t
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200613030459epoutp019926a2104edc15f4dbdf85d356c4fdc5~X_3sNQZb63032330323epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017499;
        bh=YqesGE9QRWzbUFapaH4d6ciy/qj5O7BFUrBR3w8MJ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEDK2gbrAIoM48Ca213OVKtM6LxqS5pOHZfh6nwsA20JVx+g8sFca23DTBnnmRBlE
         N+pRTKD4bJhSx/81ES60XHthar9KZ7V6tguImY79gKigmBpnpjVZMhIPBBw3zL5Jyd
         1qA3yMED3W06fABtM16JV4z+kKC+VRkgl0oO4wZc=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200613030458epcas5p40ca0e86dd249a02e957f618bf3d8ea94~X_3rzYODB1026610266epcas5p4z;
        Sat, 13 Jun 2020 03:04:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.BA.09703.A5244EE5; Sat, 13 Jun 2020 12:04:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85~X_3rfWZ2a2268422684epcas5p3Y;
        Sat, 13 Jun 2020 03:04:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030458epsmtrp213570b9b3ec310e6200a70c1492c8bf3~X_3rem7pH2362123621epsmtrp20;
        Sat, 13 Jun 2020 03:04:58 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-67-5ee4425a3624
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.62.08382.A5244EE5; Sat, 13 Jun 2020 12:04:58 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030456epsmtip29f05f6acdb20feda87c8f3c3096c25c1~X_3pjejrC0718207182epsmtip2F;
        Sat, 13 Jun 2020 03:04:56 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 10/10] arm64: dts: Add node for ufs exynos7
Date:   Sat, 13 Jun 2020 08:17:06 +0530
Message-Id: <20200613024706.27975-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsWy7bCmhm6U05M4gzebdCwezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MpY8pytoEui4vvxTewNjBuFuxg5OSQETCQmPH7C2MXIxSEk
        sJtRYmVHFytIQkjgE6NE5x1JiMQ3RokvJz6xw3S0rrnLBFG0l1Fi54ZQiKIWJompt/uYQRJs
        AtoSd6dvASsSERCWOPKtjRHEZhZ4ySSx61EBiC0s4CbxftJDsG0sAqoSq/80sIDYvAK2Etv2
        90Atk5dYveEA2ExOoPjB/wuYIGoEJU7OfMICMVNeonnrbGaQIyQETnBIfF93jAWi2UXi3Y/9
        rBC2sMSr41ughkpJfH63l62LkQPIzpbo2WUMEa6RWDoPptVe4sCVOSwgJcwCmhLrd+lDrOKT
        6P39hAmik1eio00IolpVovndVahOaYmJ3d1QSz0kDrTvY4cEzwRGiR9z3rFPYJSfheSDWUg+
        mIWwbQEj8ypGydSC4tz01GLTAqO81HK94sTc4tK8dL3k/NxNjOD0peW1g/Hhgw96hxiZOBgP
        MUpwMCuJ8AqKP4wT4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqv040yckEB6YklqdmpqQWoRTJaJ
        g1OqganK4LAs38lFOqaV2X6N8knfG+IjA8xaFA8ubUoNsjy7y8qF9Uiqzq+k5a9T6lhs3kTb
        nNTpst6pd67gbuDt7qcrcyK3ZR5fuY7LeWHOdzFvpk17rRtcWr+XPO+eJG4mxOQzw3VhSdSm
        5JkKhw/Ie7xQYNxg92Ae19Z/My88Fg5NKMifPs/+zhvFuo0/6qccNN4e9uzH9uzVYfb5azdr
        rcrnnnqY8+mdut399xoeN2ompi3RZJkVuS+zrCbaNLSFw6l/Uqzuilc1vzsDxWMcVS5ebltj
        LXP744JskTtXcj60fX8Z8i5nuf0eSeHkWR/ZeHNPbPnuN/8a4yuX+TtiGftM28JsOiYt0a/i
        XDK5TomlOCPRUIu5qDgRAP1GtcjOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG6U05M4g59/RSwezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MpY8pytoEui4vvxTewNjBuFuxg5OSQETCRa19xl6mLk4hAS
        2M0oMf/qSlaIhLTE9Y0T2CFsYYmV/56zQxQ1MUnc/NPMCJJgE9CWuDt9CxOILQJUdORbGyNI
        EbPAdyaJAxMmMIMkhAXcJN5Pegg2lUVAVWL1nwYWEJtXwFZi2/4eqA3yEqs3HACr5wSKH/y/
        AGyokICNxO6jP1kh6gUlTs58AtTLAbRAXWL9PCGQMDNQa/PW2cwTGAVnIamahVA1C0nVAkbm
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwfGmpbmDcfuqD3qHGJk4GA8xSnAwK4nw
        Coo/jBPiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpiSWp2ampBahFMlomDU6qBSUQi
        Jfde+kI5/4TAtZFG2jcd5gdMs2HkNBLK3+d+wejFRP1mGUM7h9tb1xaJxoteq20zlNv32Liq
        RiN2jtb3eRbrnhXKZJ9ubLomoXZadKF2dUdoHhNHhrpn5hSmpc/e/MxICOvT13uxitl8Qm3h
        Nuc3q6OZnBhdnG37n+dll50OFnB5cCtum+Gh55FxVk3sfwLXFM+PrNye96TbYIPkhpnxud7G
        D64JLm40mMrNUHryiGPmpcdv86pt3ofvNN/emrBz/zyTHZ5x096xxXKsvL1s9yrVe38i9J32
        VBs8a+1e+fWlzyEe18wjd36bX/swp3bPlg2Hj87zbW+d2yKZrfFcaLrtpRWhVqu5mT8rsRRn
        JBpqMRcVJwIArYFcgyYDAAA=
X-CMS-MailID: 20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85@epcas5p3.samsung.com>
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

