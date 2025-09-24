Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7825F27603A
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707143; cv=none; b=CzNfZA35uqrvsG90wFSR12EunfoU7+/rMvj7VMyEPr0xREvKjT4KaSy+z95tiZxm38ppHs6fqm5hnCX/wsmxgmFFi/dm4auSk8SlQ2EJC1Q0PbiybzM9AjJcTBn1+h6l8J7UjjfrbT6/G40Wkzac7R3adO3hnbFyLmrodURvr8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707143; c=relaxed/simple;
	bh=5DREKSd9bUEXsP4EdOogDcA4GT2UsLULxkcUVucpf1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4ewNT/qaH6Qw80QBXlJ+cyhgPCemtKPiY6hFHu0rrj8k0kpJT0ZccsL2TXWZ+HSsEcUuFy3wMtDzsILh2aTxgoL8Gg60lmS3i9doDwfGdOuTEcXZkWZKhhuhR0NzqHvsePiRtyp6tZ3krqYSu+U4amWfMf8PSEp77q/Uwjn21w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PQxTed1c; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PQxTed1c"
X-UUID: 351e1950992b11f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TmkhDaikzvljJHWaXtO7a719Lo6SlnD6KO3rjUjKuHA=;
	b=PQxTed1cVWxE6ExEYKJ7ESW+0xg29/2mpLk5KZVfvdgIB/ZiDYZcOlMgTe7R15OrkJs7dRIrrcY2SD4CFHXmak11HvfnFgg+7dYNo+6sFbsW8kWjko7b0etcIHsCMH5Cnhhv8AMStGzGj9Pw8QXlluwpMMDfu99N1p7POnW1ZfI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:152e4459-53ce-45d9-96f8-56a864aad958,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:1ca6b93,CLOUDID:c3decc21-c299-443d-bb51-d77d2f000e20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 351e1950992b11f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 833280284; Wed, 24 Sep 2025 17:45:30 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:28 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:45:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 1/8] ufs: host: mediatek: Correct clock scaling with PM QoS flow
Date: Wed, 24 Sep 2025 17:43:23 +0800
Message-ID: <20250924094527.2992256-2-peter.wang@mediatek.com>
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
index c9eb89dccd1e..436e2a16363c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1075,13 +1075,14 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
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
index 758a393a9de1..009031fee744 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1744,6 +1744,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 {
 	int err;
 	struct arm_smccc_res res;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba))
@@ -1773,6 +1774,10 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	ufs_mtk_sram_pwr_ctrl(false, res);
 
+	/* Release pm_qos if in scale-up mode during suspend */
+	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up))
+		ufshcd_pm_qos_update(hba, false);
+
 	return 0;
 fail:
 	/*
@@ -1788,6 +1793,7 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
 	struct arm_smccc_res res;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 		ufs_mtk_dev_vreg_set_lpm(hba, false);
@@ -1798,6 +1804,10 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
index ea0021f067c9..53b837b024ce 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1483,5 +1483,6 @@ int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
 void ufshcd_force_error_recovery(struct ufs_hba *hba);
+void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on);
 
 #endif /* End of Header */
-- 
2.45.2

