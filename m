Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22566325705;
	Tue, 30 Dec 2025 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106755; cv=none; b=sFCaF4yREixv83tbrStVWNxeYmV3Rzer2nDberplbwsUPuVk2oDGErj09aKnNBpQCrLdn/qGgS44VNllVEPAakxr0dcSVj37RehGD8Ojznu1oJ61ZqTRqL07KKBFBxHMsEwMVy1jw50tCTMU8nS1/gXUI4u+LNBq5EFeqvsjNag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106755; c=relaxed/simple;
	bh=Wt+mIuYGopcVWGXs5VLcPZ9XeS7veaE5oh4v1RZV/b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AB0WcxcHDI/xAAVxS0lXGprPG5P9e3txk/XXPnBSAsg4d+PMr2CwQIjxDd1MavEQAmBnsygiNynUBdHKhKOpx3X+XNNcv7rnyAzRHlxBKPQYKf7kovTx1XD63a+X1Tqm2j6O+L2+tOcMJQj2BB2N0YDDv7PCK45hynzV+FYTdA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=d4IsFeZN; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="d4IsFeZN"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f0b6655b;
	Tue, 30 Dec 2025 22:59:08 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Markus.Elfring@web.de,
	jianhao.xu@seu.edu.cn,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH v2 2/3] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Tue, 30 Dec 2025 14:58:57 +0000
Message-Id: <20251230145858.1356864-3-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251230145858.1356864-1-zilin@seu.edu.cn>
References: <20251230145858.1356864-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6fc5222603a1kunmc44e99e11660bf
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHU8dVkMaT05CSRhLSB1ITVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=d4IsFeZNWIZkG+JVnAlEQ696nL4TEZRibq5ax3wq+0PHJnV4L7MxxsNqfsIw7opoB1At+lViDbam4SeloFqAeT4i90hrG2JVyqJPNvIil57O3Sgwuf3jRXuQu+rNhpA82zxq+f9VyaenLPrwcnkGPtteYn8ppW14Dxpnrn1+KKQ=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=5XWe7wnospZyX+YNXUD8i5AYsnEWhI919NVPHOmDrsQ=;
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
index 1390d2b5095d..54a8d290c2e1 100644
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

