Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D2B2D9EFF
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192018; cv=none; b=TpnY3DbtU7QSl25hUEqxZx8oUZmQbFztxqSLPMPqCmkbts770msQX8reV0Pwi+AuaPCJ1HZXUcHTcQyRTQckFxtDKklOcUwliYsu9sCKIQ9J0KYazcFSf80DlXJrkvfBD1Ivf656YuMWWRLhNQkphEptUmcXevOG+ls/hp3IdYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192018; c=relaxed/simple;
	bh=FygIqRn1dyiVnPC3A2QIxh1aSynjBipW646OpY0i0hI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nPZhvBpZUHV0X3WExOU6ZM5ir41mbFCoBBEjXhpGl9QJ3z43LmCP0AEvBpvtZQExxShQek6Id1d5ODn/G9yBPrJvsFcKrjkkToOrcRTCGdBig6rIuO8AIoEnm4+GhAgvpwD1VGuEH25zfjiwI3ELqki6TeFkXfpdCNbxItoE2qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ehVLr41b; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ehVLr41b"
X-UUID: d6b6e88c947b11f08d9e1119e76e3a28-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=NWBeRQFRAHGhBtLzpD8SDHSTn9exvx8PF7SkxuX7uUQ=;
	b=ehVLr41b6eow3oTIaiMcK9YQ0MoadhdICBb7ZfAQKF48j5jbdnpa/mHGJ7+ZkVP7BOnJwTyVCbwEaArwPRgRu9mUi5nC3jVmFqhWu33O93YZ6VqY7uCd2LyeUnKvHVjbnrvLG2GhqsqaUKPzJWffR89AJRCU4LnqmVyWwZuJ1/8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:a185809b-9045-4fa0-a05b-0d83222eda36,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:1ca6b93,CLOUDID:fb28b26c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d6b6e88c947b11f08d9e1119e76e3a28-20250918
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 61196394; Thu, 18 Sep 2025 18:40:05 +0800
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
Subject: [PATCH v1 08/10] ufs: host: mediatek: Remove duplicate function
Date: Thu, 18 Sep 2025 18:36:18 +0800
Message-ID: <20250918104000.208856-9-peter.wang@mediatek.com>
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

Remove the duplicate ufs_mtk_us_to_ahit function in the UFS
Mediatek driver and export the existing ufshcd_us_to_ahit
function for shared use. This change reduces redundancy
and maintains consistency across the codebase.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-sysfs.c    |  3 ++-
 drivers/ufs/host/ufs-mediatek.c | 14 +-------------
 include/ufs/ufshcd.h            |  1 +
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 4bd7d491e3c5..0fb236ce7f4c 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -235,7 +235,7 @@ static int ufshcd_ahit_to_us(u32 ahit)
 }
 
 /* Convert microseconds to Auto-Hibernate Idle Timer register value */
-static u32 ufshcd_us_to_ahit(unsigned int timer)
+u32 ufshcd_us_to_ahit(unsigned int timer)
 {
 	unsigned int scale;
 
@@ -245,6 +245,7 @@ static u32 ufshcd_us_to_ahit(unsigned int timer)
 	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
 	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
 }
+EXPORT_SYMBOL_GPL(ufshcd_us_to_ahit);
 
 static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
 {
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c56c85b55ba4..5aa42b8caa3b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1109,18 +1109,6 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 	}
 }
 
-/* Convert microseconds to Auto-Hibernate Idle Timer register value */
-static u32 ufs_mtk_us_to_ahit(unsigned int timer)
-{
-	unsigned int scale;
-
-	for (scale = 0; timer > UFSHCI_AHIBERN8_TIMER_MASK; ++scale)
-		timer /= UFSHCI_AHIBERN8_SCALE_FACTOR;
-
-	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
-	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
-}
-
 static void ufs_mtk_fix_ahit(struct ufs_hba *hba)
 {
 	unsigned int us;
@@ -1143,7 +1131,7 @@ static void ufs_mtk_fix_ahit(struct ufs_hba *hba)
 			break;
 		}
 
-		hba->ahit = ufs_mtk_us_to_ahit(us);
+		hba->ahit = ufshcd_us_to_ahit(us);
 	}
 
 	ufs_mtk_setup_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7df475ebd06d..27a88f0966ac 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1502,5 +1502,6 @@ int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 void ufshcd_force_error_recovery(struct ufs_hba *hba);
 void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on);
 void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
+u32 ufshcd_us_to_ahit(unsigned int timer);
 
 #endif /* End of Header */
-- 
2.45.2

