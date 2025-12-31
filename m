Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0206E28750A;
	Wed, 31 Dec 2025 15:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193888; cv=none; b=G9nU/SfTibi7ZzxJNtNy2mC6PkT6FlqyLXQ5LstWwRon+URgy/5gx1TySOl0SN2k9uFa3nc00L+xALmn12MEPPHD0ZKWn0xyhMUfBHtBrBLLne0WzcMrPcmdI5RZ9E+hqIsx0YvTb7X/fjjeJNewWnO5Sq1bKFrC34EH2H9Uz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193888; c=relaxed/simple;
	bh=uZ2b2SsQEsySyZ5nurKp8yxedYrQ+vq58wK0WwtIP4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IXNWijoDinSaWB5Y9YOot0SXhlWxsKID8FYQwd2sklTut1/W53nMtXLinkKnxiH5m3WeSJbCHUT3HP3LGap6xhfOaqaF4xeT+A4XXKiaNEHbRr+BzUgXCeaB3m5g7hD6EXVTVUGKy2YgkFv9TvC1OAFlDn9whDxJp+xjuJZKnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=e+FVXYDv; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="e+FVXYDv"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2ecc5;
	Wed, 31 Dec 2025 23:11:21 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus.Elfring@web.de,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v3 2/3] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Wed, 31 Dec 2025 15:11:08 +0000
Message-Id: <20251231151109.362373-3-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231151109.362373-1-zilin@seu.edu.cn>
References: <20251231151109.362373-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74f6aa9403a1kunmad4383ff1aba5c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTEIaVk9OShhDTk1CT0kdGFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=e+FVXYDve0k0rzPz/rpH9YCDmlNLeXQTOk10EeYnzx5UePHVRnoqFI62wrQ6k+WirP59vIOgTbqhaGxrIFPhGb2Cw2npKcG8dwQ/uIaUdFTd6JqID6uAGOe6i48hq3Do2b8MlXpsRWM+D7iexJc+k1BwT2DpQbvyGQnP2iprJ/s=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=X07tNlP/m2RBdq3nJP6IegvzLKT1Bj1xmFRUUNyOGs4=;
	h=date:mime-version:subject:message-id:from;

In lpfc_sli4_driver_resource_setup(), mboxq is allocated via
mempool_alloc() but is not freed when the allocation of
phba->lpfc_sg_dma_buf_pool or phba->lpfc_cmd_rsp_buf_pool fails.

Fix this by adding mempool_free() in the error paths.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c520d314b131..6f4d9c618829 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8295,6 +8295,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					i, 0);
 	if (!phba->lpfc_sg_dma_buf_pool) {
 		rc = -ENOMEM;
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_bsmbx;
 	}
 
@@ -8306,6 +8307,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					i, 0);
 	if (!phba->lpfc_cmd_rsp_buf_pool) {
 		rc = -ENOMEM;
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_sg_dma_buf;
 	}
 
-- 
2.34.1

