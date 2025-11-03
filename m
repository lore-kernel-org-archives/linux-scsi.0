Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016722D7BF;
	Mon,  3 Nov 2025 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762171098; cv=none; b=NjGMlSy2BKxHch8/5aN0UtrhFd8fVfi/NyG+5zluVbGPoMhiPIkZjcpTJBAPsYeR/dr4UOmMg4A+VoRvUsyeUlze2Ph/Nf7BsZGTl3/ZFDy/RPnTZSI2iTaWyULYEp3iJemgMfCaIp/GMCXQQbrUIsFAcR7U5RqRgrvbVVmy7qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762171098; c=relaxed/simple;
	bh=9f3gCIriMaW9vu+07GtY5VjvGBNYiwVCGnBM2hedpOE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EfKLjmxhYwiyWAtZ0dezyD5sEWZVik6/hUaCN5FCg8vg1pDy0kqGmbbCPIbtu3/VcUZ97WERErnD4uzClYWHx4EeVFhj5PyWEiD+hdwWVXKDQpBDVhIS4ymW0YViTCYk2KoONHFzR20XGS76tqVxvNxmKITJBwB90OJ7Ar6bLvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EY6UN7uP; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EY6UN7uP"
X-UUID: 5eead250b8ac11f0b33aeb1e7f16c2b6-20251103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=RHKonKHpuu8h2tauK0dzekelgQBO2YV089GcLoFAdyw=;
	b=EY6UN7uPF+IpU25XwBchGixP4+bKlnnbw3CuiPi6iIXX8FjovB0TOv0xNatm3AKr1F1eUXM5ia7k5cbgeqEW4a36SpNjbml/fy8gP+S8AtgiQU/1PUnr95KChjH3HvAta6JDU9kgW3H7SYOL1hETgSI9rKygRHjSZP/L90mQWyQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:4e402ce6-0129-402b-a267-f49be04019c8,IP:0,UR
	L:25,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:fea78e26-cfd6-4a1d-a1a8-72ac3fdb69c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:1,IP:nil,URL:11|97|99|83|106|1,File:130,RT:0,Bulk:nil,QS:nil,BEC
	:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5eead250b8ac11f0b33aeb1e7f16c2b6-20251103
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2112950668; Mon, 03 Nov 2025 19:58:11 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 3 Nov 2025 19:58:12 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 3 Nov 2025 19:58:12 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<lgirdwood@gmail.com>, <broonie@kernel.org>, <matthias.bgg@gmail.com>,
	<angelogioacchino.delregno@collabora.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <wenst@chromium.org>,
	<conor.dooley@microchip.com>, <chu.stanley@gmail.com>,
	<chun-hung.wu@mediatek.com>, <peter.wang@mediatek.com>,
	<alice.chao@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<chunfeng.yun@mediatek.com>
Subject: [PATCH v1] dt-bindings: phy: mediatek,ufs-phy: Update maintainer information in mediatek,ufs-phy.yaml
Date: Mon, 3 Nov 2025 19:57:36 +0800
Message-ID: <20251103115808.3771214-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Replace Stanley Chu with me and Chaotian in the maintainers field,
since his email address is no longer active.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
index 3e62b5d4da61..6e2edd43fc2a 100644
--- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -8,8 +8,9 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: MediaTek Universal Flash Storage (UFS) M-PHY
 
 maintainers:
-  - Stanley Chu <stanley.chu@mediatek.com>
   - Chunfeng Yun <chunfeng.yun@mediatek.com>
+  - Peter Wang <peter.wang@mediatek.com>
+  - Chaotian Jing <chaotian.jing@mediatek.com>
 
 description: |
   UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
-- 
2.45.2

