Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA69221FD8;
	Fri, 18 Jul 2025 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752827301; cv=none; b=H1+EsIoRnYplGNjh4LHYMaEN/DUmRCcQ/erdz0rjl8uau3XHPFdcoHyW8orQMeUIbZadQ8gtJTThze0Q5cWNjA24tn+6i6gWQH0AgfiT9w9g04YZLZCKwP2Y66G9cCve1Ow9uY7k+8oObu+fu4wJmNkX5ogG0POTv5CnSr5NTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752827301; c=relaxed/simple;
	bh=IulC7aRAtOoD0ePVXC5qAMqQzHrKv266+g7lCVZ3ssU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAXLCoKbliQd8g5O5ivtdXLvnpZsM74ZfiH7B5nOxPR9WtAuXCu7x3Ie3QJoeD3i9fVCkNH0qyeB+CLJnJOLS/AuF4vOcIUSHrPheDwpwyS/2AywZMGdcDAIG//qpWjGVXYt/4ohg44L0OXpOkjUjBZ0U/9Q0xCqanUc7bIm3kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TH8ppZSe; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TH8ppZSe"
X-UUID: 2523f47063b111f08b7dc59d57013e23-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=au7Gm+cwAdzmzWZ7KtyI+fto0iWyCahRua7raPnIuJI=;
	b=TH8ppZSeItjLgmkKxjaMFYKrJg6EDQekSo8KByIdlWgMCa8OOoLYi6E9Fn9qaeEyeAPW6pjlINVEuYc1jgJkOvSAZDKD7+y10BVWrAH5Q7+6Dq9xVyER3wRuoLWk6pE5YO95bpKekYnDBk/GPzjAvJDxn2kKk56Y56G4LqrwScI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:46f32222-27e1-4f45-aa4a-bb1e73ae9bef,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:4f832673-f565-4a89-86be-304708e7ad47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2523f47063b111f08b7dc59d57013e23-20250718
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1122582082; Fri, 18 Jul 2025 16:28:13 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 16:28:10 +0800
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
	<Project_Global_Chrome_Upstream_Group@mediatek.com>
Subject: [PATCH 2/3] dt-bindings: ufs: mediatek,ufs: add MT8195 compatible and update clock nodes
Date: Fri, 18 Jul 2025 16:27:17 +0800
Message-ID: <20250718082719.653228-2-macpaul.lin@mediatek.com>
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

Add 'mediatek,mt8195-ufshci' to compatible list.
Update clocks and clock-names constraints to allow one to eight entries.
Introduce 'mediatek,ufs-disable-mcq' property to disable
MCQ (Multi-Circular Queue). Update conditional schema for mt8195
requiring eight 'clocks' and eight 'clock-names'.

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml | 49 ++++++++++++++++---
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 32fd535a514a..9d6bcf735920 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -9,21 +9,20 @@ title: Mediatek Universal Flash Storage (UFS) Controller
 maintainers:
   - Stanley Chu <stanley.chu@mediatek.com>
 
-allOf:
-  - $ref: ufs-common.yaml
-
 properties:
   compatible:
     enum:
       - mediatek,mt8183-ufshci
       - mediatek,mt8192-ufshci
+      - mediatek,mt8195-ufshci
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 8
 
   clock-names:
-    items:
-      - const: ufs
+    minItems: 1
+    maxItems: 8
 
   phys:
     maxItems: 1
@@ -33,6 +32,11 @@ properties:
 
   vcc-supply: true
 
+  mediatek,ufs-disable-mcq:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description: The mask to disable MCQ (Multi-Circular Queue) for UFS host.
+    type: boolean
+
 required:
   - compatible
   - clocks
@@ -43,6 +47,39 @@ required:
 
 unevaluatedProperties: false
 
+allOf:
+  - $ref: ufs-common.yaml
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - mediatek,mt8195-ufshci
+    then:
+      properties:
+        clocks:
+          minItems: 8
+          maxItems: 8
+        clock-names:
+          items:
+            - const: ufs
+            - const: ufs_aes
+            - const: ufs_tick
+            - const: unipro_sysclk
+            - const: unipro_tick
+            - const: unipro_mp_bclk
+            - const: ufs_tx_symbol
+            - const: ufs_mem_sub
+    else:
+      properties:
+        clocks:
+          minItems: 1
+          maxItems: 1
+        clock-names:
+          items:
+            - const: ufs
+
 examples:
   - |
     #include <dt-bindings/clock/mt8183-clk.h>
-- 
2.45.2

