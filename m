Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC941C38A2B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22CA2223F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ug8rAMP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgDQSKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56491 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbgDQSKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:32 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200417181028epoutp04f4a641f15458fedc4521206becdc127e~GrdBVLlEs1451714517epoutp04W
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200417181028epoutp04f4a641f15458fedc4521206becdc127e~GrdBVLlEs1451714517epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147029;
        bh=N5xT+Tor3D+R1tVY/D303rOGE0vB3ZA1jQfCCEqyDjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug8rAMP1zXC+WOj8YJzXE3+Or4EPCD3+0vHEKKh9++yLBZ3c51Iqo3TE0HYGM3Q7D
         cJjk6nfHwyzJVE2RHjdkO9Ye6RDu0gJIYKtSnV1zxWTYoiNdhwHWI/Dugq6YkH0spT
         +LEmeQxdhlaZK+Ox8alhy3GCLpZ8z3hf5AeEb/bY=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200417181027epcas5p2d1e9be455e717c1162b4a7c387052a4a~GrdAJVBml0105401054epcas5p2D;
        Fri, 17 Apr 2020 18:10:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.0B.04736.311F99E5; Sat, 18 Apr 2020 03:10:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200417181026epcas5p434bcc980e1fe334969ef6f1641525ee0~Grc-dKQPw1060310603epcas5p4z;
        Fri, 17 Apr 2020 18:10:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200417181026epsmtrp1ff38fd0a6760bf978df02b1a7a79b233~Grc-cTVIc0669906699epsmtrp1Q;
        Fri, 17 Apr 2020 18:10:26 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-69-5e99f1134ec5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.E0.04024.211F99E5; Sat, 18 Apr 2020 03:10:26 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181024epsmtip148fc720f88d9c0ccd1c0edbd14c5340b~Grc9ip4wB2094920949epsmtip1J;
        Fri, 17 Apr 2020 18:10:24 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 10/10] arm64: dts: Add node for ufs exynos7
Date:   Fri, 17 Apr 2020 23:29:44 +0530
Message-Id: <20200417175944.47189-11-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+87OOTuai9Mm+KaVMTLTSAszzx/lBSQOJtEfCRJlzTyo6XRt
        3gsSvLu8dbOZuEDXxQhlbiKWOe+YpuDSVLCMtKGh5iVBKs3tKPXf732+5/me94OPEohbCWcq
        NiGJUybI4qWkPd7Y4eF+VLKoiThm2vBgJqsaSWZmbZhkluqeEoy2c4BgBgfrhcyYoQtn9F9H
        CMbcXEkyjwbfYoz6YxPJPOtZx5iNN01CRmccQ4Ei1lxchLH62gKSbai5zWb3tuLs4vQ4zhYb
        ahG7rN/P5pnU2Hnqov2pKC4+NoVTevtftY95kDNAKlohrWZEizLRJ0khsqOAPgHm+nWsENlT
        Yvo1gg1LiZAflhCsVS8gflhF8OfVkHA7Upv3eyvSguB++TTJD9kYjHf9QFYXSR+BiXIDZmVH
        WgKdq7k2XUCPYjD5ItjKEtofzG3zAivjtBtodVobi+jTUDRrwfg2V3hZb7Lpdpt6brYO4z27
        oVczhfN3ukKW8bGA96uFUDkUxHMwTMy1IZ4lMNtj2HqBM8yU5G4ytclxcKfZh5dvga6qG+c5
        AEwfKnGrRUB7QF2zN9+0C4p+TWF8UgT5uWLe7QZZ88NbSRcoU6sJnlno/r5mW0BMlyIYN4aX
        IteK//av+G//in9lT5CgFu3hFCp5NKfyVfgkcKleKplclZwQ7XUtUa5Htm/lebYJ6QdC2xFN
        IamDKL9YEyEmZCmqdHk7AkogdRS1ndmURFGy9AxOmXhFmRzPqdqRC4VLnUR3ieFLYjpalsTF
        cZyCU26fYpSdcyYKxdsGjTHlziFaTtz9sB9ldaaluo998/Jb/tLl1TEUuKTrd9Gnc5/vtZh8
        Mne2RG40HfbJ8ZhcMIYceB9XWFZ98PKow80LK25Efp8mKohmIhsSA/b6TdzoPKRY0Rh21IWl
        iXyfW5qdMq7DPv2cPDqceBc2H7gaf9JcMGXp+3lOiqtiZMc9BUqV7C/dDytQUgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnK7Qx5lxBn8nGVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujKmt59gK9ktULLk2n7GB8Z5wFyMnh4SAicSq9j9MXYxcHEICuxklFq65wA6R
        kJa4vnEClC0ssfLfc3aIoiYmiYONx9hAEmwC2hJ3p29hArFFgIqOfGtjBLGZBZ4xSZx6WApi
        CwvYSVw++I4ZxGYRUJWYv3Q+mM0rYCvR++o5E8QCeYnVGw6AxTmB4m0tS4HiHEDLbCQ2PImB
        KBeUODnzCQtImFlAXWL9PCGITfISzVtnM09gFJyFpGoWQtUsJFULGJlXMUqmFhTnpucWGxYY
        5qWW6xUn5haX5qXrJefnbmIER5aW5g7Gy0viDzEKcDAq8fAa9MyME2JNLCuuzD3EKMHBrCTC
        e9ANKMSbklhZlVqUH19UmpNafIhRmoNFSZz3ad6xSCGB9MSS1OzU1ILUIpgsEwenVAPj5Ab9
        uXl6CfvEXlYXKGfWXdxz5OrjuZfmxl1sM5/gx7Uy6aCnbNHJ7AiPJYuKFkitajl9eYLmipbN
        NZU7fD1r1aY7nj3XOMv4af1Z4wsG927Gii5oWX3b8prz4oW3F+lHbM/YrSh5fUvz++12CtLW
        JWkptur14lLntysv1Twd35+xQONXAVeuEktxRqKhFnNRcSIA9UAqM6gCAAA=
X-CMS-MailID: 20200417181026epcas5p434bcc980e1fe334969ef6f1641525ee0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181026epcas5p434bcc980e1fe334969ef6f1641525ee0
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181026epcas5p434bcc980e1fe334969ef6f1641525ee0@epcas5p4.samsung.com>
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

