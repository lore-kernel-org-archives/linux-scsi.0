Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1017B425
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771829834; cv=none; b=IBBHXxEi8o/okgQ3Nsy1km8LyLMT2QsBD0pZtK7QghHpldOnmPYXh724Lx/LbCx8J0g8KLF8gLDC5eRuoVItV1WrLJIbza3+f5z9DLU2E7R/6XrvRvkqPWFxAzmnhlF3YIuN2oxG/uMtnhHAFFzXH4uyD7ChYvkfGnEdy+eyBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771829834; c=relaxed/simple;
	bh=rxeU39h//MSNuw79LserCZzPC739DdXiRnENGLxWDyg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S3anWCchlg3yNAoNOqA0VbkO9tK5I8DvsDYBPbvesmv1zbjoA4D5HbPWVVa8xPp/EPomIWuEAF38Kw0zmFSZauCoDcO2bo/q+DqAG1qQ2imVVPrWGag/ASEeMVIsZJw/jxtzDMlIIPQ4JiYhB1U7n+j4K3587wXxUo8vJrVVbOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PJfsKonv; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PJfsKonv"
X-UUID: d9e9dcbe108411f1b7fc4fdb8733b2bc-20260223
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PnKHKbS0tYRL7zhDFbfgQRpnO9atRsLQ8ji2feJHYDA=;
	b=PJfsKonvTp6sSUyp4AXBEnAOvZ1pXNYpZmp8ey0mutEYGpYkHH1b/m/KBRuKyv+4iNvtn9UNzPoBmVur8fEgodpTG/lNR4bdaWSnx4G7lx35c7OW1Q4cCTl+8MhlgYJO1rU2ep2Gd3PP2IyBp9DR29RZiQrRHl4TYzPHtxjZ4V4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:f36597b8-6f88-4ef5-b4fe-afafc1086391,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:0955297b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d9e9dcbe108411f1b7fc4fdb8733b2bc-20260223
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 248146021; Mon, 23 Feb 2026 14:57:00 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 23 Feb 2026 14:56:58 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 23 Feb 2026 14:56:58 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()
Date: Mon, 23 Feb 2026 14:56:09 +0800
Message-ID: <20260223065657.2432447-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

The kernel log indicates a crash in ufshcd_add_command_trace,
due to a NULL pointer dereference when accessing hwq->id.
This can happen if ufshcd_mcq_req_to_hwq() returns NULL.

This patch adds a NULL check for hwq before accessing its
id field to prevent a kernel crash.

Kernel log excerpt:
[<ffffffd5d192dc4c>] notify_die+0x4c/0x8c
[<ffffffd5d1814e58>] __die+0x60/0xb0
[<ffffffd5d1814d64>] die+0x4c/0xe0
[<ffffffd5d181575c>] die_kernel_fault+0x74/0x88
[<ffffffd5d1864db4>] __do_kernel_fault+0x314/0x318
[<ffffffd5d2a3cdf8>] do_page_fault+0xa4/0x5f8
[<ffffffd5d2a3cd34>] do_translation_fault+0x34/0x54
[<ffffffd5d1864524>] do_mem_abort+0x50/0xa8
[<ffffffd5d2a297dc>] el1_abort+0x3c/0x64
[<ffffffd5d2a29718>] el1h_64_sync_handler+0x44/0xcc
[<ffffffd5d181133c>] el1h_64_sync+0x80/0x88
[<ffffffd5d255c1dc>] ufshcd_add_command_trace+0x23c/0x320
[<ffffffd5d255bad8>] ufshcd_compl_one_cqe+0xa4/0x404
[<ffffffd5d2572968>] ufshcd_mcq_poll_cqe_lock+0xac/0x104
[<ffffffd5d11c7460>] ufs_mtk_mcq_intr+0x54/0x74 [ufs_mediatek_mod]
[<ffffffd5d19ab92c>] __handle_irq_event_percpu+0xc8/0x348
[<ffffffd5d19abca8>] handle_irq_event+0x3c/0xa8
[<ffffffd5d19b1f0c>] handle_fasteoi_irq+0xf8/0x294
[<ffffffd5d19aa778>] generic_handle_domain_irq+0x54/0x80
[<ffffffd5d18102bc>] gic_handle_irq+0x1d4/0x330
[<ffffffd5d1838210>] call_on_irq_stack+0x44/0x68
[<ffffffd5d183af30>] do_interrupt_handler+0x78/0xd8
[<ffffffd5d2a29c00>] el1_interrupt+0x48/0xa8
[<ffffffd5d2a29ba8>] el1h_64_irq_handler+0x14/0x24
[<ffffffd5d18113c4>] el1h_64_irq+0x80/0x88
[<ffffffd5d2527fb4>] arch_local_irq_enable+0x4/0x1c
[<ffffffd5d25282e4>] cpuidle_enter+0x34/0x54
[<ffffffd5d195a678>] do_idle+0x1dc/0x2f8
[<ffffffd5d195a7c4>] cpu_startup_entry+0x30/0x3c
[<ffffffd5d18155c4>] secondary_start_kernel+0x134/0x1ac
[<ffffffd5d18640bc>] __secondary_switched+0xc4/0xcc

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ec175a099459..44efb03765b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -515,8 +515,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 
 	if (hba->mcq_enabled) {
 		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
-
-		hwq_id = hwq->id;
+		if (hwq)
+			hwq_id = hwq->id;
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-- 
2.45.2

