Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AA32DAFDA
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918077; cv=none; b=GblZtDfXlPPoWvRmqNY/URpj4pOn4G4lxlberaDYZX6g/Cpl+ySJd6S6YrZhPstOk5AHrfc9Dg3h4RWlZtHN4umEkimcvpKmCYVSUNsYQAHMOiOCPcAsVBQNVzZMd9XelUhqnYmjhBvuAlNEG5CFudW5ibGIBh6i5CJmv2Fqlbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918077; c=relaxed/simple;
	bh=79rLqh1bMOnjFlgr4WuezJduyZqhEipL2yBNtim/YFA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fR8vZ4M3Tz6B2ARbLmb56E1VUeqgGCGLnFs26CdTcMkbgrVb6VXx0W9dk71P8FC4zpU1vo8dElsg9Zz/TkE7AioLfPbxPX5P4ulqQOGLs7B4tyq/HFGMIrle/K6sjZVzDK7V7mBkFMcV7uhVnHl4x+oLxohivfayDg3qThGGFc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ve4req1S; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ve4req1S"
X-UUID: 1ac461ce76b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0aNP92JqaijV5VE7pQrVe5uMTtVsWwMm88oJ8BoLAd8=;
	b=Ve4req1SXIZKk2vSQj1MyFoz2KPtj4gF52XPaU4bJcdT0l++gjbDX6O0ODleAUnjrQ/tUxL6L1pavyKrVJ+EnGdByPfSFPTkb0KPC5V8BU94zvP5ZElHpCwH6+psDGz9rTK/fCY7dXjUJ9n4FK8Wwc249Jxj15AgCDVVq8UVFQk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:c41aa74b-56fb-4b03-b8af-9c61ee3afe68,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:6edb4fa1-1800-4e4f-b665-a3d622db32cf,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ac461ce76b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1936759441; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:25 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 06/10] ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change
Date: Mon, 11 Aug 2025 21:11:22 +0800
Message-ID: <20250811131423.3444014-7-peter.wang@mediatek.com>
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

This patch assigns power mode userdata settings before transitioning
to FASTAUTO power mode. It ensures that default timeout values are
set for various parameters, enhancing the reliability and performance
of the power mode change process.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e0a51b86469c..517c26362ac6 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1367,6 +1367,28 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
 			       PA_NO_ADAPT);
 
+		if (!(hba->quirks & UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING)) {
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+					DL_FC0ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+					DL_TC0ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+					DL_AFC0ReqTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+					DL_FC1ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+					DL_TC1ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+					DL_AFC1ReqTimeOutVal_Default);
+
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+					DL_FC0ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+					DL_TC0ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+					DL_AFC0ReqTimeOutVal_Default);
+		}
+
 		ret = ufshcd_uic_change_pwr_mode(hba,
 					FASTAUTO_MODE << 4 | FASTAUTO_MODE);
 
-- 
2.45.2

