Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BFE2D3EDC
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918079; cv=none; b=U5xf2spAEzdORewg+JqYD1CCF6819f2nxLd+mXBDUXiMTMhWhJAaarFrI8r69MJ5+KovkVPCYFykoOmClJxapz7l7LYdZ1IrUdbyoY/gEjFid36iUSuXsfj58JZPpFrvmaWDmqdnKZFibeSFVwXzlEi/YY/XaJoAPPhtAv/43zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918079; c=relaxed/simple;
	bh=e0roZKxtyVWFGL/OFg+Z8JCmn+67YcIvENHj6LqL/4w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeRrtGCEeZghe/z6nQA+Yzh70bK7Lk5TzRtDNvpugGu1WJx1nCtbc1zxr+SU5d8+l4uR2whJ8vK7YdlutpF0g5HK93Y23rlpzSbVhWPQkyG/WKFouYfo/IjYZqhHe6CXqic4GGoNZ8N6kbZ1V92xZBWITBecmo9y2rhZ1jYc218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kE4INCTb; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kE4INCTb"
X-UUID: 1b74738e76b511f08729452bf625a8b4-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=sqa4p3dUd5BTvnVb/OAREuaE4bvk8Dmdvj1S8yQ4u2E=;
	b=kE4INCTbySE3WPv5wMq3ZQuXg1t4ncXHaTFHv5WBNGQCZdueKHIjriYJ5AYWmzMfF+3ZnVk6n2pwe/EYV00KHJ7MC6atqQkCsnzGe+9Swox5ARYySd8Lrxp1xgaSfJxSq5rjWj+qWwfL3036A4yxRL3d07ZTvNbUetXFU461FLY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:f8329041-90ed-4fb3-9412-8755d89cc8d4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:78a549ce-1ac4-40cd-97d9-e8f32bab97d5,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b74738e76b511f08729452bf625a8b4-20250811
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 932514578; Mon, 11 Aug 2025 21:14:27 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:26 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:26 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 10/10] ufs: host: mediatek: Fix invalid access in vccqx handling
Date: Mon, 11 Aug 2025 21:11:26 +0800
Message-ID: <20250811131423.3444014-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

This patch adds a NULL check before accessing the 'vccqx' pointer
to prevent invalid memory access. This ensures that the function
safely handles cases where 'vccq' and 'vccq2' are not initialized,
improving the robustness of the power management code.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ae458c4a7a46..5ef0ba4527e4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1629,6 +1629,9 @@ static void ufs_mtk_vccqx_set_lpm(struct ufs_hba *hba, bool lpm)
 {
 	struct ufs_vreg *vccqx = NULL;
 
+	if (!hba->vreg_info.vccq && !hba->vreg_info.vccq2)
+		return;
+
 	if (hba->vreg_info.vccq)
 		vccqx = hba->vreg_info.vccq;
 	else
-- 
2.45.2

