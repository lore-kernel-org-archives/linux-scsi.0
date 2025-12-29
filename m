Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7436030FC2F;
	Mon, 29 Dec 2025 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767022187; cv=none; b=uGRg/XsEqnyRezA9krdI9NLKp/VDbWmyXJPGQ1TxXwZ2KCHD4dkOGPmjXzVK3/8YkHV6then3wSXmaf5RYbnc1uxWa4hrF0sBjJ35YtMhB82OJsRqg+N/28bkVMJuHDubXjW5dWuzFsooW7uF5kPl7Z03olmZqv9CUYEs6+hO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767022187; c=relaxed/simple;
	bh=OGe2keu470F8oGZ18Sv/YjhqxJchZUDLKIksDQ1smho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mabEQxe2dGNK6x982faHMal/NvKCSxXFpVC0WlDH99K/LmCQooaeReKl22KzQC40ZGgw6TykE0bWhiowIfkcpzhyxX9ETU7V89Y3xkWL1/ThmFFwl4tTS/qabeBJGZKnh1fKNvpPIrwUQK6pQHOWHx3TI7IV+QB94qcUPc5FAVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=lwdkOQDb; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="lwdkOQDb"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2eeaefa8c;
	Mon, 29 Dec 2025 23:29:40 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: hpsa: Fix memory leak in hpsa_undo_allocations_after_kdump_soft_reset()
Date: Mon, 29 Dec 2025 15:29:38 +0000
Message-Id: <20251229152938.481054-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6abab8d703a1kunmfe13044e127923
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGUJJVh5CQxlMT00YQhpDH1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZS1VLVUtVS1kG
DKIM-Signature: a=rsa-sha256;
	b=lwdkOQDbyUtRY4cpGE9xF6QshayDfnlIV3vKuEfsVzqM97oTkfxIT1LJnI2EYFH+A6UuE1GX2BNIfJVtXVLX0QXU/R1jQkyPh+UlAC6JAN/E8NZfVOWCUNalkMtbCJ/DIs3mze8tk/0ab+ruFN686m1jHzwomDIdKyEG47suIao=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=Nzxfr+xr572CFBTI/MkzHnFOI9oANMISf4gwmHkYUg4=;
	h=date:mime-version:subject:message-id:from;

The h->reply_map is allocated in hpda_alloc_ctlr_info() via kcalloc().
If the controller reset fails during initialization in hpsa_init_one(),
hpsa_undo_allocations_after_kdump_soft_reset() is called to clean up
resources. However, this function frees the controller structure h but
fails to free h->reply_map, leading to a memory leak.

Fix this by freeing h->reply_map before freeing h in the cleanup function.

Fixes: 8b834bff1b73 ("scsi: hpsa: fix selection of reply queue")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/hpsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..c35d7b097252 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8212,6 +8212,8 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		h->monitor_ctlr_wq = NULL;
 	}
 
+	kfree(h->reply_map);		/* init_one 1 */
+	h->reply_map = NULL;		/* init_one 1 */
 	kfree(h);				/* init_one 1 */
 }
 
-- 
2.34.1

