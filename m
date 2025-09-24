Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090BE1E491B
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707143; cv=none; b=Y2dc1J1eBYWsS4zVUDn9I28rC79sGTRdnbkhVrqV5KoejVElcsFxaZ2AmZij2eYCCLTWgMGhjb585WQ6JL+PknACEs3Zq7+9r76O1ojFZANUBM836fhLACeupX1LtQDHbCJixjYAs2wtt/A6gYf3yYWQR7WzkQHDX9w/kcc+GQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707143; c=relaxed/simple;
	bh=L5halvX012M1DMEavD7RbqiDNCSRACM+2FgDmQkQMwo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnN5bQFVpliZ+omXmTY87mjHnUqVVaOlvH4czBfq2ZKPdWl6wpE7zHbO/urPqt9PpE/CL8M90144SyeuDD8+JIXI+zfe7S9e0qBlMdJ2MusTk7qWwUopcxAoMRjOj03q4grkp2GuZ0nLqrpJD61rqh24d0OSySRX37rVTAxoniI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lE9tadoV; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lE9tadoV"
X-UUID: 35e99378992b11f08d9e1119e76e3a28-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UpyMC+ep+sTappzx28K1ZXJgoWfl2iVo88rIY5JOS8I=;
	b=lE9tadoVqTDf3T27W5jJMnoWz/4QCTn2IJpyRFZ4ZIL/iVn6zakCs2xW/gLAZhPDeULnzO95evfrdqnau/VabGzoUHeQ4OlqSR9DVwSEuN7FhrZu7WzhGq/IzA6stDogBwxyQj1EEwWOzCFeqUh69gmntyGRTVCv8LUfX56Jq6w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:5ec4c7c1-1a63-4cda-af3f-d2bfc1118d02,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:083ce56c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35e99378992b11f08d9e1119e76e3a28-20250924
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1077264798; Wed, 24 Sep 2025 17:45:31 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:29 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:45:29 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 8/8] ufs: host: mediatek: Support new feature for MT6991
Date: Wed, 24 Sep 2025 17:43:30 +0800
Message-ID: <20250924094527.2992256-9-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
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
index 8498e95e263a..eee56f5aed30 100644
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
index f96fd032371d..9747277f11e8 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -20,6 +20,9 @@
 #define MCQ_MULTI_INTR_EN       BIT(2)
 #define MCQ_CMB_INTR_EN         BIT(3)
 #define MCQ_AH8                 BIT(4)
+#define MON_EN                  BIT(5)
+#define MRTT_EN                 BIT(25)
+#define RDN_PFM_IMPV_DIS        BIT(28)
 
 #define MCQ_INTR_EN_MSK         (MCQ_MULTI_INTR_EN | MCQ_CMB_INTR_EN)
 
-- 
2.45.2

