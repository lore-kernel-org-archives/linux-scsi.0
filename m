Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD69419E992;
	Wed, 31 Dec 2025 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193212; cv=none; b=qvi5zwH4IZ8KHxpGJ9wH8jx4Gmlpw9PkRAq+52b9Ww25TEbcGtGyFjE4AWd2HO3PUqYpsVUNPG+vwXdaUfKIirdN7ZB9OyKY4IBXlJJCzfT1P55fSXs1kuaY9xJzkNy2OHBRbSYdevj2jh/gnh/36MiG23MHzlFQtdvGituil/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193212; c=relaxed/simple;
	bh=lzr5sEPB8DE3Ax+3+Iw5jogvxjM/QEHK9KRdeNmgMFA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MLyoHBR9QsMMOabI9XjngBbe+kA9DI2Zo6MVoFOGrHE8KZlBAmEY2SVPMi3QlO2tT3k80Xm/p5KwcL1QfvtKkH9Bj6oHPVK49Gb9HXTlA2Zliq6Ihe71vREPzw33d4S81sDdSrGqdJ2pLUXjoYr7JQus6zS83qcReR0uHTxEnu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Y+LVlND0; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Y+LVlND0"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2eb08;
	Wed, 31 Dec 2025 22:59:56 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus.Elfring@web.de,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] scsi: hpsa: Fix memory leak in hpsa_undo_allocations_after_kdump_soft_reset()
Date: Wed, 31 Dec 2025 14:59:37 +0000
Message-Id: <20251231145937.354593-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74ec381803a1kunm69224f141ab109
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGkkeVhoeTkNMSh1MQkofTFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Y+LVlND0wzcPXZNCqhxi1KIocwF8nUZUivf9fF4wk9AA4QM1SLyYWygmSvVleOJJvi44B3C/8tSy5go/5o9stkIn97oDOKbm613ABFkMhzWlbLH9HD5Pt+8nyFcymYaZxnV65ASc1VxLblMKteLEDTaGczkYgLsOb0MKGXix8mo=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=tx19Q1FhtlIddIO+5SJNaLwCCwIh0vMyDO5iKO2g1r0=;
	h=date:mime-version:subject:message-id:from;

The h->reply_map is allocated in hpda_alloc_ctlr_info() via kcalloc().
If the controller reset fails during initialization in hpsa_init_one(),
hpsa_undo_allocations_after_kdump_soft_reset() is called to clean up
resources. However, this function frees the controller structure h but
fails to free h->reply_map, leading to a memory leak.

Fix this by freeing h->reply_map before freeing h in the cleanup function.

Fixes: 8b834bff1b73 ("scsi: hpsa: fix selection of reply queue")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
Changes in v2:
- Remove redundant NULL assignment for h->reply_map.

 drivers/scsi/hpsa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..ce69cd381e9f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8212,6 +8212,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		h->monitor_ctlr_wq = NULL;
 	}
 
+	kfree(h->reply_map);		/* init_one 1 */
 	kfree(h);				/* init_one 1 */
 }
 
-- 
2.34.1

