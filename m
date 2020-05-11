Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A687C54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44C7206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YybkYe0s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgEKCOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:14:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34005 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgEKCOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:14:15 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200511021413epoutp0469cbd7c46623a2779b5d830847dc49e3~N148RXuF31437514375epoutp04a
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:14:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200511021413epoutp0469cbd7c46623a2779b5d830847dc49e3~N148RXuF31437514375epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163253;
        bh=/EgM78BRgJhvlBHBSPq8WNIKV3DNSoRwOkIucDKKIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YybkYe0swUUWkOcC5mfYo5Q/sCoZKNwGUp5uqlGiZlQIK51OkXQhdcCtZZGPGBY3I
         S2W6BNeUHI+oQQNMeYakIgKxTFgA+4CxgOocZaV5IDayk8Vwhic98DOf3XQdyCCjTW
         I0arAYxmkwJ6jr1Dfgpbc9kPRmx4GlkfY9z2NMUQ=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200511021412epcas5p1a66fa185ff0d312bfca4886658c338f3~N147yrPuA1717517175epcas5p1t;
        Mon, 11 May 2020 02:14:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.1A.23389.4F4B8BE5; Mon, 11 May 2020 11:14:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200511021411epcas5p40282690d856ef9d9541506967fd0e764~N147KhXcc3064630646epcas5p4p;
        Mon, 11 May 2020 02:14:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511021411epsmtrp22e18468f1f819f1ad659dd0038675ef4~N147JQh9w1467414674epsmtrp2j;
        Mon, 11 May 2020 02:14:11 +0000 (GMT)
X-AuditID: b6c32a4b-7adff70000005b5d-5c-5eb8b4f401f7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.64.25866.3F4B8BE5; Mon, 11 May 2020 11:14:11 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021409epsmtip238e517c47b32ebc72cb65f4fa03b0bec~N145Al4i70185501855epsmtip2V;
        Mon, 11 May 2020 02:14:09 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 10/10] arm64: dts: Add node for ufs exynos7
Date:   Mon, 11 May 2020 07:30:31 +0530
Message-Id: <20200511020031.25730-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7bCmuu6XLTviDHp7pC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxrZpmgV7JSpevO9lbmC8I9zFyMkhIWAisej7XrYuRi4OIYHdjBLvv19gAkkI
        CXxilLg03xsi8ZlRov3WYiaYjulXz7JDJHYxSrx+dYcJwmlhkvi16gojSBWbgLbE3elbwDpE
        BIQljnxrA4szC9xgkniw0qWLkYNDWMBO4t55VpAwi4CqxI+Tm1hAbF4BW4kDU78zQyyTl1i9
        4QCYzQkUn9awHapGUOLkzCcsECPlJZq3zmYGuUFCYAeHxOqdW9kgml0kln3aygJhC0u8Or6F
        HcKWkvj8DuRnDiA7W6JnlzFEuEZi6bxjUOX2EgeuzGEBKWEW0JRYv0sfYhWfRO/vJ0wQnbwS
        HW1CENWqEs3vrkJ1SktM7O5mhbA9JK4enwQNqgmMEjv+vGCawCg/C8kHs5B8MAth2wJG5lWM
        kqkFxbnpqcWmBcZ5qeV6xYm5xaV56XrJ+bmbGMGpSst7B+OjBx/0DjEycTAeYpTgYFYS4V2e
        uyNOiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/jxi1xQgLpiSWp2ampBalFMFkmDk6pBiaDxoiy
        zT23zywMm8H/fdYXw5TGSYlC7cneS542ONr4tF8635Fg9PZS93YJx1Npm4J0nPxmyYt62W4I
        FC3wKGs4fL7/uZrCH4WpCeI1CXf4/W/ESkS0HO9dfras7Prew8b80tcaVldb2U6vWvLA8ozm
        Eb7zM3793sKRtGZqdb+R0XPjrOtOCyZEZcm6fBT+kr5I9Mr1BrNtqX/nvbxaazV3TXU092xD
        2+tf1q2QvPM56Gx8zcPqf8t6q79U6yp/8mBs+Fl3+La9b3GkQ77FgdeZTzdGXfRbpnN7duEe
        lhrWhp/Pvy1r3Pw7Kz9WZiZbb8D3BZcjdy5tT53jm3gl+86EG5MDuva7v1m7OrTkiI8SS3FG
        oqEWc1FxIgDP3nB/xAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXvfzlh1xBndealg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujG3TNAv2SlS8eN/L3MB4R7iLkZNDQsBEYvrVs+xdjFwcQgI7GCX2d+9igkhI
        S1zfOIEdwhaWWPnvOZgtJNDEJLF5ZgCIzSagLXF3+hawehGgmiPf2hhBbGaBZ0wSpx6WdjFy
        cAgL2EncO88KEmYRUJX4cXITC4jNK2ArcWDqd2aI8fISqzccALM5geLTGrazQKyykZixaTMr
        RL2gxMmZT1hARjILqEusnycEsUleonnrbOYJjIKzkFTNQqiahaRqASPzKkbJ1ILi3PTcYsMC
        o7zUcr3ixNzi0rx0veT83E2M4KjS0trBuGfVB71DjEwcjIcYJTiYlUR4l+fuiBPiTUmsrEot
        yo8vKs1JLT7EKM3BoiTO+3XWwjghgfTEktTs1NSC1CKYLBMHp1QDUx+rNNvNRbobnl8Xcf/h
        eGjq5DmTD7qWPdlyn8WxL/jFkjOi325feaC1fLk7W7XzB703kxcW+Dxtl/wcFZA8+aDfOteH
        8RXNUx7aimfvOPMmlmHmPqO2bNbK/33NGnILox+9WXpUnrF6D3eHGodyRbPSo8r2E/cclOSm
        /PfWvLa2+PyWFcWOs2sd2YsyUqYWWqToeDV92P5lhV+xh32GrMm/gzJFTy4oy//h75nI+iDG
        QHb5buFX4ptmve/2MX2VlJy+wYfr75FNSt8nrJusnaXeryF78qz/MitFhUsnlhZFStRK2yzx
        8OrLUPhWKp145Zmsl59d+c3PlgyiPSWbOkvW1tz4kdF3ZuffdkcvJZbijERDLeai4kQAwLrM
        ZBkDAAA=
X-CMS-MailID: 20200511021411epcas5p40282690d856ef9d9541506967fd0e764
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021411epcas5p40282690d856ef9d9541506967fd0e764
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021411epcas5p40282690d856ef9d9541506967fd0e764@epcas5p4.samsung.com>
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
index 5558045637ac..759ffd024aba 100644
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

