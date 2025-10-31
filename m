Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE27242D6A;
	Fri, 31 Oct 2025 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761913220; cv=none; b=hntAyPOBxZDmJxvUkWckFAQj4G4+5yLDHADl9jpq+cSYQAxzt9xsqcZ//TMM4NUW/D0KqMR7yX7oYYswRe2oDT3WJJztwqcjo3P4PY8qe9NzJfL2rUwBQVrrrH9E8Aj9dFTqCvvSeQg+tnMsvSc0nF0MfnoUMgL9ROEerKWNaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761913220; c=relaxed/simple;
	bh=d4QruSv1lElxzeFhg355PqgTOZcwg4+qTj9fRNfipAw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bdDCxKoMnIRBiacFANltNg2hENbZBJhaWwfD+DSO2lkoq6JGeo6F9GKJ7AKfaOVjLmvCOyaM+3I/c0bdwy427+4QyPa6QQX0TQ1ole7uIbo16FYiYP3TcyYTPXlCgduL+ppqtPZL1neuP9Imuv5OfhohBaLngujUlJurJpuW1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oDuaB826; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oDuaB826"
X-UUID: f27bbdfab65311f0b33aeb1e7f16c2b6-20251031
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=gTU6KsNp/+TiTs2Aeqfmf3gR4n/zV/REoxgn6Z0vMHQ=;
	b=oDuaB826EyfzqnTwMZDMimyB0TJ7Fxf8dRoZiDJMKWqOwKMQkltpr/7iPPqINpfaUvMob/k69eH/1b+ypGzXnT1IW47glToQWELb+ltUzOAFdZi+Bk0JUXfOenw8MrAyeKy/d2UasIOEOyMFM1zc0UJc+KcgOs25WH9iwrOPjW0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f2017535-c9cd-4233-a009-60515de517e4,IP:0,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:3cabfddf-3890-4bb9-a90e-2a6a4ecf6c66,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:97|99|83|106|11|1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f27bbdfab65311f0b33aeb1e7f16c2b6-20251031
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1198405061; Fri, 31 Oct 2025 20:20:11 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 31 Oct 2025 20:20:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Fri, 31 Oct 2025 20:20:09 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<lgirdwood@gmail.com>, <broonie@kernel.org>, <matthias.bgg@gmail.com>,
	<angelogioacchino.delregno@collabora.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <wenst@chromium.org>,
	<michael@walle.cc>, <conor.dooley@microchip.com>, <chu.stanley@gmail.com>,
	<chun-hung.wu@mediatek.com>, <peter.wang@mediatek.com>,
	<alice.chao@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1] dt-bindings: ufs: mediatek,ufs: Update maintainer information in mediatek,ufs.yaml
Date: Fri, 31 Oct 2025 20:19:12 +0800
Message-ID: <20251031122008.1517549-1-peter.wang@mediatek.com>
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
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 1dec54fb00f3..15c347f5e660 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Mediatek Universal Flash Storage (UFS) Controller
 
 maintainers:
-  - Stanley Chu <stanley.chu@mediatek.com>
+  - Peter Wang <peter.wang@mediatek.com>
+  - Chaotian Jing <chaotian.jing@mediatek.com>
 
 properties:
   compatible:
-- 
2.45.2

