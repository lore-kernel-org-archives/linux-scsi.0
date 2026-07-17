Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15D33431F5;
	Fri, 17 Jul 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302774; cv=none; b=qiEK0sxgDnaEVlz6EMnHqSBBSPEvx+1mJCcy7ywyVPHG+vzLtAfSWckTvSRNTzfQq+UvidEVq+fu2alr1cqGZVNevA5woYw/MDdfCuJebbai4lv+nYqTJHdiBd5cWPQquJnNBg48X0O4biNmGlUNfhPgK9ATFjL/kGQ2Q/G4ixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302774; c=relaxed/simple;
	bh=q7QRYf46sB8tTr6KtwkIa7G1amqSmOQCtKSG/gIiFxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjt7nQrvxqtkTgGSJcaHTTQCzSbf7HflhWh2HOKPhnFxbfSkcV+twJLdlgRNHrmv8lJwi+7yWZFyAs39uV4+APGakUXS6v0mGFsy4paCq8yc9n+XuKPlSbOPRwi+uiDYE1Vjvd+hQNUP/u4FPCtflNZYk5I8vLKuSnqQnAVjx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b082ee3281f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fb181998-a7a4-4324-87da-31ac1409716c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:fb181998-a7a4-4324-87da-31ac1409716c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:1b678ea77aa8a6225db9755f3d9150ce,BulkI
	D:2607172339262CVU7MKK,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	136|865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b082ee3281f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1921946345; Fri, 17 Jul 2026 23:39:25 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH v2 2/6] scsi: ufs: Avoid NULL CQE dereference when reporting invalid tags
Date: Fri, 17 Jul 2026 23:39:09 +0800
Message-ID: <20260717153914.26321-3-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The single-doorbell completion path can call ufshcd_compl_one_cqe() with

a NULL CQE. If no command is associated with the completion tag, the

warning message dereferences the CQE while reporting the error.

Avoid that dereference and include the invalid tag in the warning.

Fixes: 22089c218037 ("scsi: ufs: core: Optimize the hot path")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3541da5b6f4d..d1b989abc9e2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5860,8 +5860,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	enum utp_ocs ocs;
 
-	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
-		      le64_to_cpu(cqe->command_desc_base_addr)))
+	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
+		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
 		return;
 
 	if (hba->monitor.enabled) {
-- 
2.43.0

