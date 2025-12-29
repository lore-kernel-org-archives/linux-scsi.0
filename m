Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27222E7BB6;
	Mon, 29 Dec 2025 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992546; cv=none; b=BlEGkUV/TmhddwvwtuG2pENg2aSM3oBtMCVH7aiY2RI9QTwBC827OaGLIPQgJLqFWtGjarnBv/gn6/yoE3rcuI9Mruw4G6l0lIm5FAUulN4K6IPueJ+X1YQF3IXuNx8Lspnlw/dj6OibSo1gQY/cUPaaE8vClCQYxqepywtAK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992546; c=relaxed/simple;
	bh=F1Zd7PK5qv/Q3FCmkouzGY2//UDeMu1s9JuoGaeqCTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FGCph1s6zRCbjWa2krD6vwu+3E6JEInh0LILSRiXSletsX8JCuzz5KGfb7ksICmPCgxW8JzgVRATcDPsxlTHA5R3ZAqlS7wD/xDk1qnQCUsUTw9qe92IAKxMZPN3F19Im/hQqtXr/bLIZdhetMWJzoZB+NFoYhkUaN5B5L18WAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=SueoOfV2; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="SueoOfV2"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2edd68851;
	Mon, 29 Dec 2025 15:15:37 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH 3/3] scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()
Date: Mon, 29 Dec 2025 07:15:15 +0000
Message-Id: <20251229071515.155412-4-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229071515.155412-1-zilin@seu.edu.cn>
References: <20251229071515.155412-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b68f6665003a1kunmcfb873511111db
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHkxDVh1NGB4eH0oaHhkZSVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=SueoOfV2zdB0Tey/H0+1BOHJAAWrFRHIqkt47J/dmXootwDMELRBHp6tOPCj9MHktC/4KrUNSE6Lnn7iFp91HmYYQGU0loFx3kxmRdt+zywuNhFMoI33+WOicbpWut6jgOp3MMDfobCRuaKLysIAyDaYF3Vx162ddUlmN/WJcJ8=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=sDdO+nwO8UMsubRHt9hljG4K4gbAZAqcwzGsSX6eUh4=;
	h=date:mime-version:subject:message-id:from;

In lpfc_cmpl_plogi_plogi_issue(), mbox is allocated via
mempool_alloc() and initialized. However, if lpfc_nlp_get() fails,
the mbox and its resources are not freed.

Fix this by using lpfc_mbox_rsrc_cleanup() to free the mailbox and
its associated resources.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8240d59f4120..e81640223276 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1505,8 +1505,10 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		}
 
 		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-		if (!mbox->ctx_ndlp)
+		if (!mbox->ctx_ndlp) {
+			lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
 			goto out;
+		}
 
 		mbox->vport = vport;
 		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
-- 
2.34.1

