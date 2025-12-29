Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA612E6CC7;
	Mon, 29 Dec 2025 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992549; cv=none; b=IUm+8i/D9xqvuSyj/D41c54QQHU6Bw/2E9GXLXTZlq2rgGVJ7RBOyPQZBROAnheyiRXhTA2amBefAUt/EmT4JHNDzxXNHztV9AHsU/Ww5wBY9xWZlmPZAJbXHnsMKlbfRufA4mKr/phn501JfACGkxxd+t8kIH3/Bjdpn2vQ0jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992549; c=relaxed/simple;
	bh=ySk+QENIyvJ9tWxSP98h2d4oXdoSisbprOADCnkwu8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gq4KQRwXef7Eg1BZ0qcUx/Xpd1YsDzWRqB6VnhFQPAFwqbeyYpyozsQ8js5o7Im35wSjEznfqUQIbgDc2oguPWHBUyKjiefsHtOgjzYvdihVWS+DJMuYsw3SBm4ze4U2l+97isyyX1tmoUepH6QHErJqaVaWwn+EfYAixbIE7hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=as+yXnsu; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="as+yXnsu"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2edd6884c;
	Mon, 29 Dec 2025 15:15:35 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH 2/3] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Mon, 29 Dec 2025 07:15:14 +0000
Message-Id: <20251229071515.155412-3-zilin@seu.edu.cn>
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
X-HM-Tid: 0a9b68f65e9303a1kunmcfb873511111ce
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHkMeVh5LHxlLGR5NT0MYSlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=as+yXnsu4tSTeH5akUqoJ3aL0TO1z22cUkKo0oTLtafv4ba3G/RyhXIySMZ7Dwd3whaqryC6Ivckfu2Vda8BlLgY2lLq3UyE2feVX08P8ArRLayAm0WOEjUS7rdrEYJTgcZLNAcsugpP9ULNaqRiPiNvjlT42aEtAjZBQSfICtw=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=vnSddw+NE9uBTb17hEurbXcfC7FM2Vw1cP3jHFURIaE=;
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
index bc2e55f6a50f..760e38b778fb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8297,6 +8297,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					i, 0);
 	if (!phba->lpfc_sg_dma_buf_pool) {
 		rc = -ENOMEM;
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_bsmbx;
 	}
 
@@ -8308,6 +8309,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					i, 0);
 	if (!phba->lpfc_cmd_rsp_buf_pool) {
 		rc = -ENOMEM;
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_sg_dma_buf;
 	}
 
-- 
2.34.1

