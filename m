Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEE7C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938C02251F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgLWEOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:14:42 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41649 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgLWEOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 23:14:41 -0500
X-UUID: 86e4ba70f9944399bf2cb2de1ccac07d-20201223
X-UUID: 86e4ba70f9944399bf2cb2de1ccac07d-20201223
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1420034519; Wed, 23 Dec 2020 12:13:55 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Dec 2020 12:13:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 12:13:46 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, <hanks.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] arm64: dts: mt6779: Support ufshci and ufsphy
Date:   Wed, 23 Dec 2020 12:13:45 +0800
Message-ID: <20201223041345.24864-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201223041345.24864-1-stanley.chu@mediatek.com>
References: <20201223041345.24864-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support UFS on MT6779 platforms by adding ufshci and ufsphy
nodes in dts file.

Reviewed-by: Hanks Chen <hanks.chen@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt6779.dtsi | 36 +++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6779.dtsi b/arch/arm64/boot/dts/mediatek/mt6779.dtsi
index 370f309d32de..a8584b00cc9d 100644
--- a/arch/arm64/boot/dts/mediatek/mt6779.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6779.dtsi
@@ -225,6 +225,41 @@
 			#clock-cells = <1>;
 		};
 
+		ufshci: ufshci@11270000 {
+			compatible = "mediatek,mt8183-ufshci";
+			reg = <0 0x11270000 0 0x2300>;
+			interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_LOW 0>;
+			phys = <&ufsphy>;
+
+			clocks = <&infracfg_ao CLK_INFRA_UFS>,
+				 <&infracfg_ao CLK_INFRA_UFS_TICK>,
+				 <&infracfg_ao CLK_INFRA_UFS_AXI>,
+				 <&infracfg_ao CLK_INFRA_UNIPRO_TICK>,
+				 <&infracfg_ao CLK_INFRA_UNIPRO_MBIST>,
+				 <&topckgen CLK_TOP_FAES_UFSFDE>,
+				 <&infracfg_ao CLK_INFRA_AES_UFSFDE>,
+				 <&infracfg_ao CLK_INFRA_AES_BCLK>;
+			clock-names = "ufs", "ufs_tick", "ufs_axi",
+				      "unipro_tick", "unipro_mbist",
+				      "aes_top", "aes_infra", "aes_bclk";
+			freq-table-hz = <0 0>, <0 0>, <0 0>,
+					<0 0>, <0 0>, <0 0>,
+					<0 0>, <0 0>;
+
+			mediatek,ufs-disable-ah8;
+			mediatek,ufs-support-va09;
+		};
+
+		ufsphy: phy@11fa0000 {
+			compatible = "mediatek,mt8183-ufsphy";
+			reg = <0 0x11fa0000 0 0xc000>;
+			#phy-cells = <0>;
+
+			clocks = <&infracfg_ao CLK_INFRA_UNIPRO_SCK>,
+				 <&infracfg_ao CLK_INFRA_UFS_MP_SAP_BCLK>;
+			clock-names = "unipro", "mp";
+		};
+
 		mfgcfg: clock-controller@13fbf000 {
 			compatible = "mediatek,mt6779-mfgcfg", "syscon";
 			reg = <0 0x13fbf000 0 0x1000>;
@@ -266,6 +301,5 @@
 			reg = <0 0x1b000000 0 0x1000>;
 			#clock-cells = <1>;
 		};
-
 	};
 };
-- 
2.18.0

