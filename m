Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673D2D879C;
	Tue, 22 Jul 2025 08:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753174673; cv=none; b=PV3dv0msXhfQLtooNUYKnhj+i7QyGYkmBWJgmEqcT+6Re3YS0ehHZGN+SWJ+z/l5H3cgVQBnrqPjU5dh7drZV9QhDadKU6tz7vZ3MUTxNK9c7AXc/LwBWsYYPdg3aJigIaMjmYW2nfaxbshPtAp2r8kpOweohK/7bbgRwv/MW5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753174673; c=relaxed/simple;
	bh=R6ZijVeg8VUkqySlYSIlCFa+USG4jCJR2hNpPOd8jxw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CW7gHo9d4YJOhDkZlCRYKjP2hFWgNUGCoiQlko652H1fxwi7Fo0S6DE+TwW4RegOyWs7WeC6UqY5WRvJiEzuMRWbpHOSuJUuJNcucdLJCH01S4mxM/7tVbZjjwiCNrC8tp6jCMqWW1DpFZoGadSyXof7uqSNaWPsDRpUYjpEv7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qdupOaGF; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qdupOaGF"
X-UUID: ebe38b9a66d911f08b7dc59d57013e23-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=X0dKErEL1skRnp95LZxhIE6KOtuvu+ympj6r/1bWpSA=;
	b=qdupOaGFq4ZL4PTC3NskoEy6J7MtspTaCh88QJP1nUv9nj+gVFpm/fMNJgi2FeaBdhphjp+QZB18y+FzjMO3S5E5z+7EC3BMmP8NUVwurA0+7cYaZ3yJz3I6zNLjtB6ZvfXFVPYxXsB51BFGYoVR7ULkpTxfa3TKKGR6PvP98uc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:ff973ac8-da01-41a9-aa16-de0797252902,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:1a641f50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ebe38b9a66d911f08b7dc59d57013e23-20250722
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 634969686; Tue, 22 Jul 2025 16:57:39 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 16:57:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 16:57:36 +0800
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
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>
CC: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul.lin@mediatek.com>,
	Macpaul Lin <macpaul@gmail.com>, MediaTek Chromebook Upstream
	<Project_Global_Chrome_Upstream_Group@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 2/4] dt-bindings: ufs: mediatek,ufs: add ufs-disable-mcq flag for UFS host
Date: Tue, 22 Jul 2025 16:57:18 +0800
Message-ID: <20250722085721.2062657-2-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Add the 'mediatek,ufs-disable-mcq' property to the UFS device-tree
bindings. This flag corresponds to the UFS_MTK_CAP_DISABLE_MCQ host
capability recently introduced in the UFS host driver, allowing it
to disable the Multiple Circular Queue (MCQ) feature when present.
The binding schema has also been updated to resolve DTBS check errors.

Cc: stable@vger.kernel.org
Fixes: 46bd3e31d74b ("scsi: ufs: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 4 ++++
 1 file changed, 4 insertions(+)

Changes for v2:
 - Split new property from the origin patch.
 - Add dependency description. Since the code in ufs-mediatek.c
   has been backport to stable tree. The dt-bindings should be backport
   to the same stable tree as well.

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 32fd535a514a..20f341d25ebc 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -33,6 +33,10 @@ properties:
 
   vcc-supply: true
 
+  mediatek,ufs-disable-mcq:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description: The mask to disable MCQ (Multi-Circular Queue) for UFS host.
+
 required:
   - compatible
   - clocks
-- 
2.45.2

