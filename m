Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9CE1DFD8B
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867603; cv=none; b=F7UvHB95l0cuoQmJaxNnhzFcnbtlKn/AXx2jrxfR/Gp5du4/hWRHjFib5fkKw5Qev2lvx6WtvG4c1brLdi1V4hUEZruCxAVuJYIDoguF7V8SzF+kvTTkOAhhNzChj/TS659qZeAzTislgMQPCyYCbiMhue7X2AgMfyB4Bam3oCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867603; c=relaxed/simple;
	bh=5PdXh+JUarNWR8XAGvn5paQDRd983V53nxgKcBc2r5s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+vAu6bB7faBL9NmcmX27cw7DB2apTP1RL41NFhNfeVCRuuNCKsSYkA4zp37UtXoPukyBsmzUzyDyTHo499QAXmdJ5mZXe3RksMuyAkpsaGxGhRolTiSbx0QyWvzxNjG3z/wRvkutWcVDtTOqlohQgqI/jSBSr3RfqGne6aU6Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NRZynZAf; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NRZynZAf"
X-UUID: 3454119e887011f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dz9QrR7w1Zh79j7ACXZVFTMDhPH8Rn4GBrIe+/k/TUM=;
	b=NRZynZAfeT9g5Ue537jRePT99+1CEZK3sew63N3bhAIN8B8cGEqoXDjYNqjyGaMGYP3JphBUoh5nnUKutosMpLONCR3eiPmaJ9/vWxobfjRsGofxVk0lbOFmStV9qm8rhmsloIpwrqcKNL7uzrLjUAv51QUimEY/8Rz7tjielMU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:798c5bb9-4108-433b-ba60-1b4d57d841c3,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:f03a5f84-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3454119e887011f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1991447149; Wed, 03 Sep 2025 10:46:34 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:33 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v3 04/10] ufs: host: mediatek: Correct resume flow for LPM and MTCMOS
Date: Wed, 3 Sep 2025 10:44:40 +0800
Message-ID: <20250903024631.496693-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903024631.496693-1-peter.wang@mediatek.com>
References: <20250903024631.496693-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

Correct the system resume flow by turning MTCMOS on before setting
LPM to false. During system suspend, set LPM to true and turn
MTCMOS off. Ensure proper power management and system stability
with the updated resume sequence.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index d762f096e32e..a47713a047c1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2327,11 +2327,11 @@ static int ufs_mtk_system_resume(struct device *dev)
 	if (pm_runtime_suspended(hba->dev))
 		goto out;
 
-	ufs_mtk_dev_vreg_set_lpm(hba, false);
-
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
+	ufs_mtk_dev_vreg_set_lpm(hba, false);
+
 out:
 	ret = ufshcd_system_resume(dev);
 
-- 
2.45.2

