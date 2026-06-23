Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13FD3D3CEF;
	Tue, 23 Jun 2026 11:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213887; cv=none; b=vDJdc0y6SCkBya+kAgM/3+j5DpyzWELzD81kq0EY7RqzwnxZluC/EMpwuPoWf7nKerQ1wvzk91MgFPIMYZGs2YdsjPiOKIrimXuDU5oi92vj3fWPHLfyG4B/l3nUCQPPJxtqWGr0AUMeRS4mSmVGQkHek5usgslJNOwUGIKex/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213887; c=relaxed/simple;
	bh=8F2UYglKfcTF+eykTaNG40sEotWPB0loPhGNrQCuVwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DYuebWSEa4RWvB2KYDCk4lr1ASbkC32Afix5wWzkSMBatkhM/AiZxxtdrN3xh4qXPkllVkqifMwTw6WmDHz3ytq++G/GoXc/Icb5DHCuCnEVScnhAvI/l+v0lO4ECfYzJ7NsHHz21se0D5i5scRi6YAylNu7X0iZTPZLvpPz1W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1f2cca006ef611f1aa26b74ffac11d73-20260623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5e3740d4-7035-4767-9bec-9164a60ddd5c,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:d6899cbf62ed25ed1230be757a2743cd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|865|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f2cca006ef611f1aa26b74ffac11d73-20260623
X-User: pengcan@kylinos.cn
Received: from lenovo [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <pengcan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1149366949; Tue, 23 Jun 2026 19:24:38 +0800
From: Can Peng <pengcan@kylinos.cn>
To: skashyap@marvell.com,
	jhasan@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH] scsi: bnx2fc: Use kmalloc_array() for array allocations
Date: Tue, 23 Jun 2026 19:24:28 +0800
Message-ID: <20260623112428.98097-1-pengcan@kylinos.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Documentation/process/deprecated.rst discourages open-coded arithmetic
in allocator arguments and recommends using the 2-factor allocator forms.

The unsolicited completion path allocates num_rq buffers of
BNX2FC_RQ_BUF_SZ bytes, and task_ctx_dma is an array of task_ctx_arr_sz
dma_addr_t entries. Use kmalloc_array() for both allocations.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index a5ecb87d5b2d..af6d27c3966e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -655,8 +655,8 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		if (rq_data) {
 			buf = rq_data;
 		} else {
-			buf1 = buf = kmalloc((num_rq * BNX2FC_RQ_BUF_SZ),
-					      GFP_ATOMIC);
+			buf1 = buf = kmalloc_array(num_rq, BNX2FC_RQ_BUF_SZ,
+						   GFP_ATOMIC);
 
 			if (!buf1) {
 				BNX2FC_TGT_DBG(tgt, "Memory alloc failure\n");
@@ -1904,8 +1904,8 @@ int bnx2fc_setup_task_ctx(struct bnx2fc_hba *hba)
 	/*
 	 * Allocate task_ctx_dma which is an array of dma addresses
 	 */
-	hba->task_ctx_dma = kmalloc((task_ctx_arr_sz *
-					sizeof(dma_addr_t)), GFP_KERNEL);
+	hba->task_ctx_dma = kmalloc_array(task_ctx_arr_sz,
+					  sizeof(dma_addr_t), GFP_KERNEL);
 	if (!hba->task_ctx_dma) {
 		printk(KERN_ERR PFX "unable to alloc context mapping array\n");
 		rc = -1;
-- 
2.53.0

