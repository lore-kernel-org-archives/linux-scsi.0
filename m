Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E948C21CC44;
	Thu, 16 Jul 2026 06:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182841; cv=none; b=FE+wIg4sTFUJG7f7+5vvlwH0NgPq8jMkWZ+an1KwrPfrjzfTzrUO6/xaSCrAKA7xkcWxDKlcPSeopLT1j1zdUkuJU+kwVZYA5Y2x8zCd7gSYT4w/ADfqF2aoMdopIUDB0C76qjTjKs6DzUlZj+ug1Vm9+ocjQ7/jcYzheIHSDZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182841; c=relaxed/simple;
	bh=qhzOcBK8pmD67n01Gg87xOaDGvMfm+nCRJN2A7xlYFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJPstn4uYNjeMDrYOEZW4MveGzZ7ikFmlZXZ/C5aQjXlOic1iZ5E2mN91sqPBQsU6SjNMAwagJcnuYPQDzDqNABbrTb6Uy3dkitI5d1Yn3G/LgUD+BIddtAj21yDoJDrwLMBsRuE1FCKmiVetIiOfEBcLagpYLF/VPMV6S91F/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 74a73c1e80de11f1aa26b74ffac11d73-20260716
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fb403757-7971-4c4d-a7bc-92557e8f0814,IP:15,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:fb403757-7971-4c4d-a7bc-92557e8f0814,IP:15,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:71be0df4a289e05bef4e49303aaccbd8,BulkI
	D:2607161420353BTX94ED,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 74a73c1e80de11f1aa26b74ffac11d73-20260716
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 549025416; Thu, 16 Jul 2026 14:20:35 +0800
From: liqiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH 2/5] scsi: ufs: Fix NULL dereferences after tag lookup
Date: Thu, 16 Jul 2026 14:19:52 +0800
Message-ID: <a761788934d27cef7cbd099674923fd1c7c00f48.1784182493.git.liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Qiang <liqiang01@kylinos.cn>

ufshcd_tag_to_cmd() can return NULL when no command is associated
with a tag. The MCQ cleanup and completion paths dereferenced the
result before checking it.

Move private-command and request lookups after the NULL checks. Also
avoid dereferencing cqe while reporting an invalid tag because the
single-doorbell completion path passes a NULL CQE.

Fixes: 22089c218037 ("scsi: ufs: core: Optimize the hot path")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufs-mcq.c | 6 ++++--
 drivers/ufs/core/ufshcd.c  | 7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 13b60a2d06db..15850b0658f9 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -555,8 +555,8 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
-	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct ufshcd_lrb *lrbp;
+	struct request *rq;
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
 	u32 nexus, id, val;
@@ -568,6 +568,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 	if (!cmd)
 		return -EINVAL;
 
+	lrbp = scsi_cmd_priv(cmd);
+	rq = scsi_cmd_to_rq(cmd);
 	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
 	if (!hwq)
 		return 0;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3541da5b6f4d..f2a5fa624e74 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5857,13 +5857,14 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	enum utp_ocs ocs;
 
-	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
-		      le64_to_cpu(cqe->command_desc_base_addr)))
+	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
+		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
 		return;
 
+	lrbp = scsi_cmd_priv(cmd);
 	if (hba->monitor.enabled) {
 		lrbp->compl_time_stamp = ktime_get();
 		lrbp->compl_time_stamp_local_clock = local_clock();
-- 
2.43.0

