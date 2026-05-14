Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333D3F4127
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778749295; cv=none; b=VuYZWgncczl1x0OP6Um++7aiXgib0UDDENBNWiFJZqDU+qTiQ3WbUQMpX5015Wz2NuEbbFD8ejFMqYOtLy2jBdvBVwh6w6uEgjZmPeFzTuC763Bfk9GrddwqpgSgBPCBjsp5jNSeHI2Ou29s0MJYpqHtSnzJGYp9xpMIdi86vCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778749295; c=relaxed/simple;
	bh=mw+if1/wZfhQR+fsSe6lZatuQbGUmbVHH67Ng0SVDCo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ubtr5E6RW8l3Q1OxphZ9rkvVLJQlEEoYiGY6zKawelb3Zcr/eJFYhLFOOOEhAshLIs4DfsUzjhmXxtLZ9KvzTjSbInk6wYl3WEHjUtEaphjxzeBh2ZGtl6DzqXaFibtYf96V9ZP2v2oIvzYEeslotE//52OHVNAoG6B6cO5OsqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=g95NK8WF; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g95NK8WF"
X-UUID: 7c4868044f7311f1a3561939bc42ff46-20260514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1HD9rxwTY1qIhGlY5kodoQ8SagKtKiWqYuGlUGSzJJ0=;
	b=g95NK8WFRsikCJDh70BgJjTa/fsbNku+jQqvLA2Deg9MXs1Tyd7oDHQpsXlg78n3C7Ry2hTDkhMiuWEQI+GKmUJ37h55w09o7zDL/P/DEvAqWc4isviL4CtGnIVMPPrgF7J26A/PoAQ5HOHrLj7jJ9izmMOnCFUwZl0022vew64=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:5c052823-142d-4e93-af63-7b2eb8e78d6a,IP:0,U
	RL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-20
X-CID-META: VersionHash:9091e75,CLOUDID:80c416f6-8c44-46d7-a1ca-a9bdc4d4a626,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:1,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7c4868044f7311f1a3561939bc42ff46-20260514
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 293015713; Thu, 14 May 2026 17:01:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 14 May 2026 17:01:23 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 14 May 2026 17:01:23 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>, <quic_cang@guicinc.com>, <quic_asutoshd@guicinc.com>,
	<light.hsieh@mediatek.com>
Subject: [PATCH v1] ufs: core: decouple CQE processing from spinlock critical section
Date: Thu, 14 May 2026 16:26:39 +0800
Message-ID: <20260514082906.58593-1-peter.wang@mediatek.com>
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

Currently, ufshcd_mcq_process_cqe() is called while holding the CQ
spinlock, which can lead to unnecessary lock contention since CQE
processing may involve time-consuming operations like completing I/O
requests and invoking callbacks.

Refactor the CQE processing flow to separate the lock-protected queue
head/tail slot updates from the actual CQE processing:

1. Add a new 'cqe_last_addr' field to 'ufs_hw_queue' to cache the
   address of the last CQE entry, precomputed during memory allocation
   in ufshcd_mcq_memory_alloc(). This avoids repeated recalculation
   during the hot path.

2. Introduce ufshcd_mcq_inc_cqe_addr() helper in ufshcd-priv.h to
   increment a CQE pointer with wraparound, using 'cqe_last_addr' for
   boundary checking.

3. Refactor ufshcd_mcq_process_cqe() to accept a 'struct cq_entry *'
   directly instead of deriving it from the hardware queue, decoupling
   it from queue state.

4. In both ufshcd_mcq_compl_all_cqes_lock() and
   ufshcd_mcq_poll_cqe_lock(), snapshot the starting CQE pointer before
   advancing the head slot under the spinlock, then process the collected
   CQEs after releasing the lock using the new helper.

This reduces the time spent holding the CQ spinlock to only the
minimal queue slot management operations, improving concurrency and
reducing latency under heavy I/O workloads.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c     | 23 ++++++++++++++++++-----
 drivers/ufs/core/ufshcd-priv.h | 20 ++++++++++++++++++++
 include/ufs/ufshcd.h           |  1 +
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c1b1d67a1ddc..74a6595f9bda 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -248,6 +248,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 			dev_err(hba->dev, "CQE allocation failed\n");
 			return -ENOMEM;
 		}
+		hwq->cqe_last_addr = hwq->cqe_base_addr + hwq->max_entries - 1;
 	}
 
 	return 0;
@@ -307,10 +308,8 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 }
 
 static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
-				   struct ufs_hw_queue *hwq)
+			           struct cq_entry *cqe)
 {
-	struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
-
 	if (cqe->command_desc_base_addr) {
 		int tag = ufshcd_mcq_get_tag(hba, cqe);
 
@@ -335,10 +334,12 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 {
 	unsigned long flags;
 	u32 entries = hwq->max_entries;
+	struct cq_entry *cqe;
+	int i;
 
 	spin_lock_irqsave(&hwq->cq_lock, flags);
+	cqe = ufshcd_mcq_cur_cqe(hwq);
 	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		entries--;
 	}
@@ -346,6 +347,11 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 	ufshcd_mcq_update_cq_tail_slot(hwq);
 	hwq->cq_head_slot = hwq->cq_tail_slot;
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
+
+	for (i = 0; i < hwq->max_entries; i++) {
+		ufshcd_mcq_process_cqe(hba, cqe);
+		cqe = ufshcd_mcq_inc_cqe_addr(hwq, cqe);
+	}
 }
 
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
@@ -353,11 +359,13 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 {
 	unsigned long completed_reqs = 0;
 	unsigned long flags;
+	struct cq_entry *cqe;
+	int i;
 
 	spin_lock_irqsave(&hwq->cq_lock, flags);
+	cqe = ufshcd_mcq_cur_cqe(hwq);
 	ufshcd_mcq_update_cq_tail_slot(hwq);
 	while (!ufshcd_mcq_is_cq_empty(hwq)) {
-		ufshcd_mcq_process_cqe(hba, hwq);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		completed_reqs++;
 	}
@@ -366,6 +374,11 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 		ufshcd_mcq_update_cq_head(hwq);
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
+	for (i = 0; i < completed_reqs; i++) {
+		ufshcd_mcq_process_cqe(hba, cqe);
+		cqe = ufshcd_mcq_inc_cqe_addr(hwq, cqe);
+	}
+
 	return completed_reqs;
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_cqe_lock);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 0a72148cb053..6d4d3e726a9a 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -440,6 +440,26 @@ static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, u32 tag)
 	return blk_mq_rq_to_pdu(rq);
 }
 
+/**
+ * ufshcd_mcq_inc_cqe_addr - increment CQE pointer with wraparound
+ * @hwq: pointer to the hardware queue
+ * @cqe: current CQE pointer to increment
+ *
+ * Increments the CQE pointer to the next entry. If the pointer
+ * exceeds the last entry, it wraps around to the base address.
+ *
+ * Returns: pointer to the next cq_entry
+ */
+static inline struct cq_entry *ufshcd_mcq_inc_cqe_addr(struct ufs_hw_queue *q,
+	struct cq_entry *cqe)
+{
+        cqe++;
+        if (cqe > q->cqe_last_addr)
+                cqe = q->cqe_base_addr;
+
+        return cqe;
+}
+
 static inline void ufshcd_inc_sq_tail(struct ufs_hw_queue *q)
 	__must_hold(&q->sq_lock)
 {
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..1becb38e215e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1291,6 +1291,7 @@ struct ufs_hw_queue {
 	struct utp_transfer_req_desc *sqe_base_addr;
 	dma_addr_t sqe_dma_addr;
 	struct cq_entry *cqe_base_addr;
+	struct cq_entry *cqe_last_addr;
 	dma_addr_t cqe_dma_addr;
 	u32 max_entries;
 	u32 id;
-- 
2.45.2

