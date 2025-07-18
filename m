Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851B224244;
	Fri, 18 Jul 2025 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752827302; cv=none; b=pZUragNjUeIwds5VkK/TjaG++N8/NZ3dhuDT2seiOIuTbUsp6eouYc6gtgjgvewZPkC30vUQaMp9OK1ksEaB1HMQ69nHG8Fo6Oh3DcHTHJDT1omSA0L3CyfSO6UEJuAhF2vZBTvSwW9sa8amfNgxbGQBPy6/wKwrjqUCuyaNzIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752827302; c=relaxed/simple;
	bh=/DR9yS+KLp30aqF0cUnSG3uJhf2+LBf/ATFKS9NeWrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6EybGW4m57O7DB4hfNpt43Kp42wJAGjnlflnpZoZIt7jfO12RH0jJMxJWR3DXzC8065+iGBAYGDhwIZ6N1lhf+76suEnnF89IL5rLk9mf+4lsKGenRmYaah4VtQ3AO1ih2N0lqIjjsu+6qDjQkrQpJgzkr+GRh/7zAJvCSXDbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qRIAxUZR; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qRIAxUZR"
X-UUID: 25205f7c63b111f0b33aeb1e7f16c2b6-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=i1serjV4kH1/wTwHKRcE1GEbwr2ev0ug7m/0IdNMSBs=;
	b=qRIAxUZRgwMG/qwDw7fSuP+FjMoebPX2eyVxaCFURXMBUdtQIzo7ENZdg9QyDFeD4Ocgm3cQGjj5olzjx//m40/6PdB/ttmy377qzconSAy2OL5grCUdXbZ6vEGT2TiZAp81v5CcyfUdOCrgytYrx8m0Rj/e0w2/QV7hvIO6Byc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:643bbc30-2fd2-4eb2-ab57-4dfb01c200cb,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:5cf89484-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 25205f7c63b111f0b33aeb1e7f16c2b6-20250718
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1599903196; Fri, 18 Jul 2025 16:28:13 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 16:28:11 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 18 Jul 2025 16:28:11 +0800
From: Macpaul Lin <macpaul.lin@mediatek.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Peter Wang
	<peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	<openembedded-core@lists.openembedded.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>
CC: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul.lin@mediatek.com>,
	Macpaul Lin <macpaul@gmail.com>, MediaTek Chromebook Upstream
	<Project_Global_Chrome_Upstream_Group@mediatek.com>, Rice Lee
	<ot_riceyj.lee@mediatek.com>, Eric Lin <ht.lin@mediatek.com>
Subject: [PATCH 3/3] arm64: dts: mediatek: mt8195: add UFSHCI node
Date: Fri, 18 Jul 2025 16:27:18 +0800
Message-ID: <20250718082719.653228-3-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250718082719.653228-1-macpaul.lin@mediatek.com>
References: <20250718082719.653228-1-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Rice Lee <ot_riceyj.lee@mediatek.com>

Add a UFS host controller interface (UFSHCI) node to mt8195.dtsi.
Introduce the 'mediatek,ufs-disable-mcq' property to allow disabling
Multiple Circular Queue (MCQ) support.

Signed-off-by: Rice Lee <ot_riceyj.lee@mediatek.com>
Signed-off-by: Eric Lin <ht.lin@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 25 ++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index dd065b1bf94a..8877953ce292 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1430,6 +1430,31 @@ mmc2: mmc@11250000 {
 			status = "disabled";
 		};
 
+		ufshci: ufshci@11270000 {
+			compatible = "mediatek,mt8195-ufshci";
+			reg = <0 0x11270000 0 0x2300>;
+			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH 0>;
+			phys = <&ufsphy>;
+			clocks = <&infracfg_ao CLK_INFRA_AO_AES_UFSFDE>,
+				 <&infracfg_ao CLK_INFRA_AO_AES>,
+				 <&infracfg_ao CLK_INFRA_AO_UFS_TICK>,
+				 <&infracfg_ao CLK_INFRA_AO_UNIPRO_SYS>,
+				 <&infracfg_ao CLK_INFRA_AO_UNIPRO_TICK>,
+				 <&infracfg_ao CLK_INFRA_AO_UFS_MP_SAP_B>,
+				 <&infracfg_ao CLK_INFRA_AO_UFS_TX_SYMBOL>,
+				 <&infracfg_ao CLK_INFRA_AO_PERI_UFS_MEM_SUB>;
+			clock-names = "ufs", "ufs_aes", "ufs_tick",
+					"unipro_sysclk", "unipro_tick",
+					"unipro_mp_bclk", "ufs_tx_symbol",
+					"ufs_mem_sub";
+			freq-table-hz = <0 0>, <0 0>, <0 0>,
+					<0 0>, <0 0>, <0 0>,
+					<0 0>, <0 0>;
+
+			mediatek,ufs-disable-mcq;
+			status = "disabled";
+		};
+
 		lvts_mcu: thermal-sensor@11278000 {
 			compatible = "mediatek,mt8195-lvts-mcu";
 			reg = <0 0x11278000 0 0x1000>;
-- 
2.45.2

