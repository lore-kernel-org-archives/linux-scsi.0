Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC1433D6F8;
	Thu, 13 Nov 2025 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763046777; cv=none; b=GXily2k7xOR31mZNCdJVd65PgGEYvJpKM/4UAvtt6AHRiNPG2emnqP9eZ3xwwModdDa2C13YOPnijH7BsKZ8EXDRPzEUa1oxxdp9RXU8VHlsxDQCrTCDG+wBWQw6MUQoNNv2lRuWuV+LMaEpSVnty8UIfZNMREt6UlnJAEfOCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763046777; c=relaxed/simple;
	bh=mVe85YN/6UgnEJRflaix0KfQKJ7qA5DKNuAhgd5KeKE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=STcuoIQIeBwrLi3OvKJgnSbnhYiGfQtFTSf7A2lGheIlTlTEsHoZO7I+ho3/857SULOP99x2nXCZ1liEu+feso8W765r/6+jVS6futAQ8voW7bH/oMox99/4X91HZi9nEX/ZWdsn7CPU8Dv6dL98zRS/5LK5Xy9jsvjr8SAWqA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=hRVIADyT; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="hRVIADyT"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 297e69aa1;
	Thu, 13 Nov 2025 23:12:50 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: njavali@marvell.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: qla2xxx: Fix improper freeing of purex item
Date: Thu, 13 Nov 2025 15:12:46 +0000
Message-Id: <20251113151246.762510-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a7dc6c6d903a1kunm6ad063bd14a79b
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSh8YVk4eTUtMH0sZSxhDQlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=hRVIADyTI852FDAiRYwCE79FHX9OSXuBnGwa0vrvy1kKL5WySER+QAIuv1MnxHAXt4u7cx71z5A08HTzIebKQGvgOnZorIVcVDTqXuIrd6KqVZG/nvlTympIP0xGPpnk6+SbUZHmzmDppl4YoyeJsI+SAocn36HISGpC6z7WDR4=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=oHlscegUSxTGy0gMUpyhgX+Wzcidm9ihl9c1V4/l+9M=;
	h=date:mime-version:subject:message-id:from;

In qla2xxx_process_purls_iocb(), an item is allocated via
qla27xx_copy_multiple_pkt(), which internally calls
qla24xx_alloc_purex_item().

The qla24xx_alloc_purex_item() function may return a pre-allocated item
from a per-adapter pool for small allocations, instead of dynamically
allocating memory with kzalloc().

An error handling path in qla2xxx_process_purls_iocb() incorrectly uses
kfree() to release the item. If the item was from the pre-allocated pool,
calling kfree() on it is a bug that can lead to memory corruption.

Fix this by using the correct deallocation function,
qla24xx_free_purex_item(), which properly handles both dynamically
allocated and pre-allocated items.

Fixes: 875386b988578 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 316594aa40cc..42eb65a62f1f 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1292,7 +1292,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 		a.reason = FCNVME_RJT_RC_LOGIC;
 		a.explanation = FCNVME_RJT_EXP_NONE;
 		xmt_reject = true;
-		kfree(item);
+		qla24xx_free_purex_item(item);
 		goto out;
 	}
 
-- 
2.34.1

