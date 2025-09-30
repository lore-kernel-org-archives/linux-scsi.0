Received: from mail-m3297.qiye.163.com (mail-m3297.qiye.163.com [220.197.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB124886E;
	Tue, 30 Sep 2025 08:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759221685; cv=none; b=eiUkUhG+BqXLo0q6Sjl5R3wsIDpbTDt4DQjslqAoI/EsvNJOyDfp08jJ+EWhFTC8vNce0HYrs5X3QBE0T1jlzbqjU9KdOTFlpfmT67sFvCwPFGkInE7htqpP49LDzlfUuuj6KJeGzTg+yAf+udRhYYWDDLrBIlI5USqJorbhF70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759221685; c=relaxed/simple;
	bh=pZyLSJvAIGtzzPT+iqfWfenmT7ZjTW55yGfzBnuFK9A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d2ApQPnS9q0OIrgZfPrbIx9MH40WtBAmje5P9UpDRNg0ehhEj8o9wmjjzq5MChkc7SDPKHiPX3dkLW/KbFEdCcmmOA5N0+yNt2rwTzVv9WrU2y1dBYDHaMhTjN+1pmSIYoVU4Mcril0mIZG9h3rCEyNuDs2pqeBAfLvH2MA7EDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=220.197.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 10fa00c0c;
	Tue, 30 Sep 2025 16:05:52 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ips: Fix potential ioremap memory leak in ips_init_phase1()
Date: Tue, 30 Sep 2025 16:05:43 +0800
Message-Id: <20250930080543.453552-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9999a80fec0229kunm115c61031b1c88
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHk9MVkkZGB9JHUJKQhlNSlYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+

In ips_init_phase1(), most early-exit error paths use ips_abort_init(),
which properly releases ioremap_ptr. However, the path where kzalloc()
fails does not go through ips_abort_init() and therefore skips unmapping
ioremap_ptr, leading to a potential resource leak.

Add the missing iounmap() call in this specific failure path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 drivers/scsi/ips.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 94adb6ac02a4..a34167ec3038 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6877,6 +6877,8 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	if (ha == NULL) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
 			   "Unable to allocate temporary ha struct\n");
+		if (ioremap_ptr)
+			iounmap(ioremap_ptr);
 		return -1;
 	}
 
-- 
2.20.1

