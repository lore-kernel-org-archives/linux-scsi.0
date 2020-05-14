Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2959FC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC40207BB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FKYAX0m9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbgENAxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45994 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbgENAxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:17 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200514005314epoutp01495c7302706f89d1b44c7ffff671008b~OvuGnvE9G2940929409epoutp01P
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200514005314epoutp01495c7302706f89d1b44c7ffff671008b~OvuGnvE9G2940929409epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417594;
        bh=YqesGE9QRWzbUFapaH4d6ciy/qj5O7BFUrBR3w8MJ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKYAX0m9Tvqp4s7BdcJTpmIgfiecnNvYY08Pp/AR67U3VMy8TcPmFKHA3b55Tkrtn
         ba2oLhohiGNQIvFu2YgZ+L3U7XjNooBAFHSWKAdVyqDLN3ZipkSKUvx1FzF9S7x7fx
         UuCzeggHlHHR8sNwQP7mMDWgpxtpIJMGbjSV5rag=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200514005314epcas5p28eb25c6accaf5dd39326cde31db4bb50~OvuGCaOLN0273002730epcas5p2r;
        Thu, 14 May 2020 00:53:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.55.10010.A769CBE5; Thu, 14 May 2020 09:53:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec~OvuFpLUWX0947309473epcas5p3B;
        Thu, 14 May 2020 00:53:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514005313epsmtrp177e6753c225f240c01eaf36bd25e8ff7~OvuFnUU461129711297epsmtrp1o;
        Thu, 14 May 2020 00:53:13 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-2e-5ebc967ac2b5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.D3.18461.9769CBE5; Thu, 14 May 2020 09:53:13 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005311epsmtip2f8904f0fb29298daef612621d92c40f1~OvuDtJcps3258132581epsmtip2y;
        Thu, 14 May 2020 00:53:11 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 10/10] arm64: dts: Add node for ufs exynos7
Date:   Thu, 14 May 2020 06:09:14 +0530
Message-Id: <20200514003914.26052-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmum7VtD1xBmd6uCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxpLnbAVdEhXfj29ib2DcKNzFyMkhIWAiMWX/CZYuRi4OIYHdjBKTH/6Hcj4x
        SkxvP8YO4XxjlJi55g4jTMuEnXOgqvYySszvu8sE4bQwSZy43MMEUsUmoC1xd/oWMFtEQFji
        yLc2sG5mgRtMEg9WuoDYwgJ2EmdWbQCrYRFQlZi1Zz8riM0rYCvxvvUJE8Q2eYnVGw4wg9ic
        QPEtX45B1QhKnJz5hAViprxE89bZzCBHSAhs4ZBo/f+SFaLZRWLhvRVsELawxKvjW9ghbCmJ
        l/1tQDYHkJ0t0bPLGCJcI7F03jEWCNte4sAVkC85gOZrSqzfpQ+xik+i9zfIaSCdvBIdbUIQ
        1aoSze+uQnVKS0zs7oY6wENidsN7RkjwTGCU6HiymHECo/wsJB/MQvLBLIRtCxiZVzFKphYU
        56anFpsWGOallusVJ+YWl+al6yXn525iBKcrLc8djHcffNA7xMjEwXiIUYKDWUmE12/97jgh
        3pTEyqrUovz4otKc1OJDjNIcLErivKfTtsQJCaQnlqRmp6YWpBbBZJk4OKUamNoDL6jl/Ik/
        Jr6LdUlD0aTPtsl3dsWm/mQ48LAp4nT3douTVQ/Wy83W0s+LuLXo3YHwhYqydm9ndqntst32
        5CvXm9NlCpNTni0/M8+75JDYDTZun3rTK9UHl7zab/997RXWA7LPXe/o/p/wm3XuFP6kqf/f
        th7Ve+HmY2PUcSaiTang0UW+yLDpqTMenNEN4FNbxTvDOKLwR+rcLMOo7aHJRek+nd9TD4kr
        S7jOTTjyi+O3acsigR/HTafpLg29vjBUyK3kxjyX+3HfZJptrj1028E5T9af6V3bqs4S76g8
        LhHOd3JfFM47LP309ceGNM1LMybMv7H67z47tarpEsFRUW3l3OXsRq/Xah04J6zEUpyRaKjF
        XFScCACbxsGbxgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJXrdy2p44g6XvtS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxpLnbAVdEhXfj29ib2DcKNzFyMkhIWAiMWHnHBYQW0hgN6PE7jsxEHFpiesb
        J7BD2MISK/89B7K5gGqamCTeLZnKCJJgE9CWuDt9CxOILQJUdORbG1icWeAZk8Sph6UgtrCA
        ncSZVRvAalgEVCVm7dnPCmLzCthKvG99wgSxQF5i9YYDzCA2J1B8y5djrBAH2UgsW7OMEaJe
        UOLkzCdAh3IAzVeXWD9PCGKVvETz1tnMExgFZyGpmoVQNQtJ1QJG5lWMkqkFxbnpucWGBYZ5
        qeV6xYm5xaV56XrJ+bmbGMFxpaW5g3H7qg96hxiZOBgPMUpwMCuJ8Pqt3x0nxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwTB6dUA9ORxWrOy2IEFyXFTbQJK2QQ
        bd6rGCj1sVj7zEzZ5vdiVqd3PJEtMRArnu/gmPv4PGPEL+lXbtcf73IzqT9+rI9r06SACRm3
        +1eKN077I7iY89A/tY/LHzV0tHFoGAkm/PSOPmvWL5vKGjt54T9lYRnb7WZZAbNnblxhYZAv
        39Hzc5eTy5Oz05RdHrkqyh5y+LLP8X5l2goH5o7fE/p6znilMkWUzc0uShXYnvBCY5WW7cmb
        XBNWn/14uuz94fJVjal6T9bMaFnKe3DBsa119wU/eCx3FG8pK1e9ZuD1UuL32eCNzP0Svx15
        nZjL43p16/z6vv+5lfLkh8+eXfIKj1ZyCj/4uvuW4SK3PSfSFJRYijMSDbWYi4oTARjBggga
        AwAA
X-CMS-MailID: 20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec@epcas5p3.samsung.com>
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

