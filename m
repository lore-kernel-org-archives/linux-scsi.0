Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EECA405C3F;
	Mon, 24 Aug 2026 11:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571408; cv=none; b=VXIHtPMrcG5StH+7MyXBXng+INUaXdIoJGJhbuYU0RU1s/QNrYQ9pM9+hH7v4TIwTVSTBY4i6QpX5c/+/61bkJI7NMIF1YnR27DeD4CpnxR92iOPAthYijxAVRcnh1jFM0i6nWbrrNd0rAY33eSKD2WExSCVWSJyngTYkWjElbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571408; c=relaxed/simple;
	bh=T3Mw4IxXHQGlq00EaitD6+1dpV/KL4PbSWsaZvO22+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TyzJ/gdIHHwM47xjVWdO5i2v4wQSJrj/eDi98+XPb5j5tqU3dZ5lnFWnAUu4Hy9pjc47mz+PJWPWMHDbvBc8z/c0XtRgzI36t+PF3G3tGsUIENWwVY0yGH//l8GkleD70QlfJ7BZM6xIb67tlA7A3iJ/9y98dVDU/RQejFKmzI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=dHv6Q43V; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="dHv6Q43V"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4b1a0b505;
	Mon, 24 Aug 2026 19:36:34 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X vectors
Date: Mon, 24 Aug 2026 19:36:18 +0800
Message-Id: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0338ed97303a1kunmba8a283c2268a9
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTR9OVkJLGh5PTE1NSxhPTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=dHv6Q43VKxoJWkitp02IIMoP/mI2zr0Bw7SzDLU8VrtE+E63XKSGisl/7FyWuMKXjK8VKexoaJurV7xDA9ISjGSmPC0+t/+JvgOC701nxK8d/f5zqDysTGTBhqxfH9AuLpmdWzG6ewY7BMFzIayoIZvS7MwdMhGbbGT6dfYou6M=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=TwSXypq6xqOYTYG42OhR27zQHgxYnkbkRhwp4/mvE/k=;
	h=date:mime-version:subject:message-id:from;

pm8001_request_msix() unwinds previously registered handlers with
free_irq() when request_irq() fails. The rollback loop uses the
failing index i for every iteration instead of the already
registered vector index j.

That passes the wrong IRQ/dev_id pair to free_irq() and leaves the
earlier handlers installed. Use j for both pci_irq_vector() and the
matching irq_vector entry in the rollback loop.

Fixes: a76037ff3479 ("scsi: pm8001: switch to pci_irq_alloc_vectors")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..21419e46c16d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 			&(pm8001_ha->irq_vector[i]));
 		if (rc) {
 			for (j = 0; j < i; j++) {
-				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
-					&(pm8001_ha->irq_vector[i]));
+				free_irq(pci_irq_vector(pm8001_ha->pdev, j),
+					 &pm8001_ha->irq_vector[j]);
 			}
 			pci_free_irq_vectors(pm8001_ha->pdev);
 			break;
-- 
2.34.1
