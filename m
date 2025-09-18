Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704ED2F3614
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192019; cv=none; b=g9bTT1q3g0ytW2aYhIJRAfWefPn5GsYnMtDCx41bvTuUGOQV9CEF2MVBWX3UvfRU91DreCUyoypCoTsdcaFMHhT9lCQBHO4iI6Pe5drgVa4dUhe791xtei7W/cTAwUGJUV9gBcdbkuGYGmUo6c2CqwvgRg+LncSsRBQBRRIvYgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192019; c=relaxed/simple;
	bh=+bBRN62E66b+E+LuwU2mlgPI++at0VmNAeQeswYwcp8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGRVlCZYKG/a6vBLU2HKiARsvRox8gOTEdASW15xbZbxWV3lW/ClbMgIj4yKLAOvaVSgW4j6f5tHBKDB8lLKmHIvoUOatUic0oQDRvIhCemw3mSUR2byYphJSf0e7oAITIQlyIsxToMDNkZjLGHodBS85EhStld4Mq1xeYmCEu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lFUrvZNq; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lFUrvZNq"
X-UUID: d6b93c90947b11f08d9e1119e76e3a28-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ndr++jp+26DFR/R5ApsAQ+s693GcWtCYReKXOnDLZQM=;
	b=lFUrvZNqscQypiiCJPuxWrFrJ8uU8C102qTdtexMrDgIuHnRKUkxYnZeGuga9tWnlnGFph4C8HAyxdFPUrNZif91PmnqDBxJkV6QUKeQmO8nYgaFat6m9B2A9X6SufYx4GxoinXN5Pnnh2JLoRZ8N1/XIs1Bv/g8o7BCQgHNBlU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:8bbd332f-e66b-4e96-8d70-580eb505008d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:bafd1891-68e1-4022-b848-86f5c49a6751,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d6b93c90947b11f08d9e1119e76e3a28-20250918
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 599403411; Thu, 18 Sep 2025 18:40:05 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 18:40:03 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 18:40:03 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 10/10] ufs: host: mediatek: Support new feature for MT6991
Date: Thu, 18 Sep 2025 18:36:20 +0800
Message-ID: <20250918104000.208856-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250918104000.208856-1-peter.wang@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Naomi Chu <naomi.chu@mediatek.com>

Add support for the MT6991 platform by enabling MRTT settings
and random performance improvements. These enhancements aim
to optimize performance and efficiency on the MT6991 hardware.

Enable multi-Round Trip Time (MRTT) for improved data handling.
Enable random performance improvement features to boost
overall system responsiveness.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 6 ++++++
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0cc372e0ac75..f62f08cdfcbc 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -289,6 +289,12 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 				0x453000, REG_UFS_MMIO_OPT_CTRL_0);
 		}
 
+		if (host->ip_ver >= IP_VER_MT6991_A0) {
+			/* Enable multi-rtt */
+			ufshcd_rmwl(hba, MRTT_EN, MRTT_EN, REG_UFS_MMIO_OPT_CTRL_0);
+			/* Enable random performance improvement */
+			ufshcd_rmwl(hba, RDN_PFM_IMPV_DIS, 0, REG_UFS_MMIO_OPT_CTRL_0);
+		}
 	}
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 32687dd12527..db9f21ef481c 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -23,6 +23,9 @@
 #define MCQ_MULTI_INTR_EN       BIT(2)
 #define MCQ_CMB_INTR_EN         BIT(3)
 #define MCQ_AH8                 BIT(4)
+#define MON_EN                  BIT(5)
+#define MRTT_EN                 BIT(25)
+#define RDN_PFM_IMPV_DIS        BIT(28)
 
 #define MCQ_INTR_EN_MSK         (MCQ_MULTI_INTR_EN | MCQ_CMB_INTR_EN)
 
-- 
2.45.2

