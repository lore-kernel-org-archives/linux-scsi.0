Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7046F2BEFFE
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192019; cv=none; b=MkhWEtcsB6INavXn/nk3UpQsB+VPk0IbaTVkGxtzWmV8+WmXJP0CnzA82bpcFLocTScKug/QIO/5abvFHPPAz+YWGfGe6jC/O8P54zmL8ySJwPM6S2SOo0cLLNiN4zLdBe4ucg+09jczaz2mG3kytNE4jWj+tcuzWuE/Ow5DWjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192019; c=relaxed/simple;
	bh=1aenMsfLjmE92AaUExBOSY9BF8SylPkn+IYWEOye2XM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUNe1+FtvlzEjWVRyerkVnB13T9+88cO+NkQG9RJVRRHIKibzhqei6BLmnfdFZ6DneGPtJrmEMvc5FPKoZCHOtAh1t17f5mgup2Dyf7p6xFXYzvBorn2XmrNccMRriBeKqBOie3NPMkIXaATSKSzBj0ytj8U2dZ9+0Q/ckv+PVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EEFmXq6G; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EEFmXq6G"
X-UUID: d6b5c010947b11f08d9e1119e76e3a28-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=toU0P22Jm/x0Gj0jIhwkoxtEoQOm15Pmx+DS4gZemx8=;
	b=EEFmXq6G0IdzlczDtDEjTNm2KIwUVj1jaH64eAQT3+cKrNZg8GC8ETAXJ2zQUwy3UL7sZqUJjsUkCmMmhhRHa54zUYSMhXp1ibEr+rxNKTYYwx3OhP47+OGzi9qov32+eoPhs2miYuGuoT0E7kwIZYYBs5KxZaYTDbPcmSi4kIE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:bc57b21e-12e8-45ba-8123-baa1e8e7eae9,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:1ca6b93,CLOUDID:b9fd1891-68e1-4022-b848-86f5c49a6751,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d6b5c010947b11f08d9e1119e76e3a28-20250918
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 304287592; Thu, 18 Sep 2025 18:40:05 +0800
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
Subject: [PATCH v1 07/10] ufs: host: mediatek: Fix shutdown/suspend race condition
Date: Thu, 18 Sep 2025 18:36:17 +0800
Message-ID: <20250918104000.208856-8-peter.wang@mediatek.com>
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

From: Peter Wang <peter.wang@mediatek.com>

Address a race condition between shutdown and suspend
operations in the UFS Mediatek driver. Before entering
suspend, check if a shutdown is in progress to prevent
conflicts and ensure system stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd-priv.h  | 5 -----
 drivers/ufs/host/ufs-mediatek.c | 6 ++++++
 include/ufs/ufshcd.h            | 5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c963a27d..3ab50ece5abf 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -6,11 +6,6 @@
 #include <linux/pm_runtime.h>
 #include <ufs/ufshcd.h>
 
-static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
-{
-	return !hba->shutting_down;
-}
-
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 
 static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 18ce985970f3..c56c85b55ba4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2433,6 +2433,12 @@ static int ufs_mtk_system_suspend(struct device *dev)
 	struct arm_smccc_res res;
 	int ret;
 
+	/* Check if shutting down */
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
 		goto out;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 109cbb36c02d..7df475ebd06d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1436,6 +1436,11 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
+static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
+{
+	return !hba->shutting_down;
+}
+
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
-- 
2.45.2

