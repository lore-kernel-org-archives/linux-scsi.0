Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2971D2DEA78
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192017; cv=none; b=N/hCVwZzEf1y0g62U03L1Jf+E1Tj6Zhdclai50yiTqjN4g3XTr0fxTac++VtgGE3fLxCFuLu5N+SjYpDy05JjuqlVGohdtPA+Jo9Hqx2xMZ8x/RvM/nLbHwOr6v5Yn5jivB/ln5hQtvn7DSjWhG0YOb2U+5s2NTZ+ClkRTsR79Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192017; c=relaxed/simple;
	bh=0P0Jw3aTNJi2hj6hkL6MQNVbjuawevwbYCiHEhmqvTI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/V+CjzJI6krXX8RVO/MUjmW81NoUgm62b/VoZr/JMLljDePGepsGkKWPJJl/CpluEdlHFyM5GWr8RvvvNkraxcMkjDEE3QU597FaZOoZ1/T3Fmik6gjgEoeE88fDMWxA1wD9Vc5iRYGNShb4vUW0fz3Tvb4ebw01e08GPQbQwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nL9+YuWf; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nL9+YuWf"
X-UUID: d608d1d4947b11f0b33aeb1e7f16c2b6-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=p7EKyydxDduJ9nnXEi7w/3LXd5OTabCSYGgV1urwhHQ=;
	b=nL9+YuWf0DI1Sw8jySF1MpR4qfM5Od5TwVBO0dKJJZasYx5Kxg4VEIMVGFkzCMxeTDYd+t4KqUYFm7rbZXzp27oM2T7eNSeNjZHJwaX+xZpv+fTuy8WkzuBXr0LdKjtgLQKaR/L0uQJuwmv/+snrYr3cwLx9KhtIZ9qhaVcYMwA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:a4e7e41b-415c-4bc0-a9bf-ad5383ca1557,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:1ca6b93,CLOUDID:fa28b26c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d608d1d4947b11f0b33aeb1e7f16c2b6-20250918
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2018556980; Thu, 18 Sep 2025 18:40:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 18:40:02 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 18:40:02 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with PM QoS flow
Date: Thu, 18 Sep 2025 18:36:12 +0800
Message-ID: <20250918104000.208856-3-peter.wang@mediatek.com>
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

Correct clock scaling with PM QoS during suspend and resume.
Ensure PM QoS is released during suspend if scaling up and
re-applied after resume. This prevents performance issues
and maintains proper power management.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       |  3 ++-
 drivers/ufs/host/ufs-mediatek.c | 10 ++++++++++
 include/ufs/ufshcd.h            |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7a12748e479..4e0de3a6d9b6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1063,13 +1063,14 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
  * @hba: per adapter instance
  * @on: If True, vote for perf PM QoS mode otherwise power save mode
  */
-static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
+void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
 {
 	if (!hba->pm_qos_enabled)
 		return;
 
 	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
 }
+EXPORT_SYMBOL_GPL(ufshcd_pm_qos_update);
 
 /**
  * ufshcd_set_clk_freq - set UFS controller clock frequencies
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index b1797386668c..e3d8e0fdbbe3 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1744,6 +1744,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 {
 	int err;
 	struct arm_smccc_res res;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	if (status == PRE_CHANGE) {
 		if (!ufshcd_is_auto_hibern8_supported(hba))
@@ -1779,6 +1780,10 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	ufs_mtk_sram_pwr_ctrl(false, res);
 
+	/* Release pm_qos if in scale-up mode during suspend */
+	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up))
+		ufshcd_pm_qos_update(hba, false);
+
 	return 0;
 fail:
 	/*
@@ -1794,6 +1799,7 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
 	struct arm_smccc_res res;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 		ufs_mtk_dev_vreg_set_lpm(hba, false);
@@ -1804,6 +1810,10 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (err)
 		goto fail;
 
+	/* Request pm_qos if in scale-up mode after resume */
+	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up))
+		ufshcd_pm_qos_update(hba, true);
+
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_hpm(hba);
 		if (err)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 45e2ca65de90..a6ed7aa59533 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1495,5 +1495,6 @@ int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
 void ufshcd_force_error_recovery(struct ufs_hba *hba);
+void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on);
 
 #endif /* End of Header */
-- 
2.45.2

