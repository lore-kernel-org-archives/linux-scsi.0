Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3926E719;
	Mon, 29 Dec 2025 07:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992547; cv=none; b=bK8CE2hl2WNktWkHUKKx/9zR1L9Mkg7NDFPA71nUaSPnZ82LF3klWXfxHVE/0sMYk5yMVqVlYu+rU9wXdrfR94/xJJoCWO1v+GYep9FRK6RZ67kD2qwKOiNzP1qI2RNKOsavt4VmJuDu424HlkLmlnahXntTWIE7o4k6/Qek2LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992547; c=relaxed/simple;
	bh=O+QciBJbADSaEJqqa17FzaO5KFlVsl5nHJn1HU0YpT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uwamqmuBBn7/M/kC5SLDLWOTdVgiRhk/IzD21SXlzGoEYjxZARHnwvl5BB5MnFIatzKT5n9MsmJRMPJ/4nH0df9zEwltOOCCXnXXkFcitaYdki239BoSVW5wZ1oW5Cl1yWZYOck+Hs0lc8L2nFh0HG4Q6fyyKOLEBlqu97j4isM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Cmi+TNVt; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Cmi+TNVt"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2edd6884b;
	Mon, 29 Dec 2025 15:15:33 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH 1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Mon, 29 Dec 2025 07:15:13 +0000
Message-Id: <20251229071515.155412-2-zilin@seu.edu.cn>
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
X-HM-Tid: 0a9b68f6573903a1kunmcfb873511111c8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHU1PVh5NQkhPH00ZSh9PT1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=Cmi+TNVtUWpBuhm/QVL6QC2/u32+4WYvxJ3ah5EIuNC1m3BuTiYHqQhAN2NVmL1SoPzS/VoIdxJTbCf0wxmZEFrYk8Tr/4By2r+bH7Im8JIO1Jd8lGqGMcnR0+mlNXEaaKS8iijvwVRJq8P4eg2DhuUI/C3viaLAUEi0lfkbEao=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=EZTrvzY9XgD6F14g5xRiljsY3FD1vszdcu/ygLBH/qc=;
	h=date:mime-version:subject:message-id:from;

In lpfc_config_port_post(), pmb is allocated via mempool_alloc() but
is not freed when lpfc_readl() fails.

Fix this by adding mempool_free() in the error path.

Fixes: 9940b97bb30d ("[SCSI] lpfc 8.3.22: Add support for PCI Adapter Failure")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b1460b16dd91..bc2e55f6a50f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -572,6 +572,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Enable appropriate host interrupts */
 	if (lpfc_readl(phba->HCregaddr, &status)) {
 		spin_unlock_irq(&phba->hbalock);
+		mempool_free(pmb, phba->mbox_mem_pool);
 		return -EIO;
 	}
 	status |= HC_MBINT_ENA | HC_ERINT_ENA | HC_LAINT_ENA;
-- 
2.34.1

