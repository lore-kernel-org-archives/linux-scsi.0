Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C506B2882C6
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753086999; cv=none; b=vDccfozWzEBphLD87reDqM2JHjnzd2AqmGqc2IaQ0PYkxMXy3pOHXa8n+LkRlLfmPjnD7kJcdwrExgnnjSZfCB5njvl0tJlcK9+aN54zqKoS+ngCDoG7R8c6k8IT/ieJTrmZYZaGaCGyuGs4NIzfT74+KSLaVChZx75eR5dVtSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753086999; c=relaxed/simple;
	bh=AH/nTjXQbfFZeMm5euFu3nGmVMuN9XNRZ5ZXCYSwGTk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adUtnR4KdqvHpi2wETzA9eT8kKgeo3XlJvezRmDWyyfSiIU1k7WNDbX7H0nBub1Ue9rZSiWQPSexxGEP7RzgadUPO0t516J+3THGdpia6MKXujbq4e8vANuIb+y5VZc5vmjO/Uhc5oYbAYRzBGHbiVPADIKNsCRL+n8BOEayhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=peBCQT+6; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="peBCQT+6"
X-UUID: cd060792660d11f0b33aeb1e7f16c2b6-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Lhm61uQtzzxcCtHqS+mRq9wqfDqT5aoWNXjiumLBCJ4=;
	b=peBCQT+6xoJIcxI6aePo7Uw6gcAkIOrM94F9mFm2hHXJJ8el5IzpBpockTfxqMv67aAHjqy/pC6NkoG725O2zdhuP/CvlSDz3M2J7VhB+qzCveZd7c0SV3lVoU2FZBPhdN1n9/AKaVCfj/QuMITiB6FW9hdJxY1PfBtDM1hPLV8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:b4b90bb0-8ead-4a2b-a344-68b079dcb07d,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:05d7199a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cd060792660d11f0b33aeb1e7f16c2b6-20250721
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1204517875; Mon, 21 Jul 2025 16:36:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 16:36:29 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 16:36:29 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v3 5/9] ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
Date: Mon, 21 Jul 2025 16:35:14 +0800
Message-ID: <20250721083626.1801668-6-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250721083626.1801668-1-peter.wang@mediatek.com>
References: <20250721083626.1801668-1-peter.wang@mediatek.com>
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

This patch sets the IRQ affinity for MCQ mode to improve
performance. Specifically, it migrates the IRQ from CPU0 to
CPU3 to enhance IRQ handling efficiency.

Setting IRQ affinity directly from the kernel allows the
configuration to take effect earlier, and provides greater
security and consistency, especially important for systems
with strict performanceor real-time requirements.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 47 +++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 112056e5d8e0..78eaf057cdc3 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -798,6 +798,46 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 	return ret;
 }
 
+static u32 ufs_mtk_mcq_get_irq(struct ufs_hba *hba, unsigned int cpu)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	struct blk_mq_tag_set *tag_set = &hba->host->tag_set;
+	struct blk_mq_queue_map	*map = &tag_set->map[HCTX_TYPE_DEFAULT];
+	unsigned int nr = map->nr_queues;
+	unsigned int q_index;
+
+	q_index = map->mq_map[cpu];
+	if (q_index > nr) {
+		dev_err(hba->dev, "hwq index %d exceed %d\n",
+			q_index, nr);
+		return MTK_MCQ_INVALID_IRQ;
+	}
+
+	return host->mcq_intr_info[q_index].irq;
+}
+
+static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
+{
+	unsigned int irq, _cpu;
+	int ret;
+
+	irq = ufs_mtk_mcq_get_irq(hba, cpu);
+	if (irq == MTK_MCQ_INVALID_IRQ) {
+		dev_err(hba->dev, "invalid irq. unable to bind irq to cpu%d", cpu);
+		return;
+	}
+
+	/* force migrate irq of cpu0 to cpu3 */
+	_cpu = (cpu == 0) ? 3 : cpu;
+	ret = irq_set_affinity(irq, cpumask_of(_cpu));
+	if (ret) {
+		dev_err(hba->dev, "set irq %d affinity to CPU %d failed\n",
+			irq, _cpu);
+		return;
+	}
+	dev_info(hba->dev, "set irq %d affinity to CPU: %d\n", irq, _cpu);
+}
+
 static void ufs_mtk_get_controller_version(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1527,6 +1567,13 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u16 mid = dev_info->wmanufacturerid;
+	unsigned int cpu;
+
+	if (hba->mcq_enabled) {
+		/* Iterate all cpus to set affinity for mcq irqs */
+		for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+			ufs_mtk_mcq_set_irq_affinity(hba, cpu);
+	}
 
 	if (mid == UFS_VENDOR_SAMSUNG) {
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
-- 
2.45.2

