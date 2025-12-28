Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2122BD5BF;
	Sun, 28 Dec 2025 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766926741; cv=none; b=vCb46bYnwkmDvUtbgdC/zP6/IlfXjh2JXj0KOc2lBiXB2saPzowWnDTDzEUbDzPfTOIrhwIIndD9hD43xf4lYipflTwMsm4R9ckDkW0iCtFLyC5bBazK4dKqn0JhQ/643QxEwQCY9/aY+a4jwohBGfAYdj4qOKm+9hft+7uRBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766926741; c=relaxed/simple;
	bh=7dAVh8n+MpAjEAVIM+FyoK/RdBqdVI+am67SUl1naSg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tU37+k4agscVrVK+SOqyscaevx1WAesj36mV2lxjGEb77v9KLOXFCJLCZN9UFgGvaCDfqrJ/JLRm6q5uG+we6ci4/qjAO9g3bMzNbU3SGDKYJrTjydlt6jrM2PrxD9V0aI0a2t5G9rYYEut294BbL8DYu2qIi+X0wy/V+RSRuT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=NyLr0vqm; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="NyLr0vqm"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2ecacd086;
	Sun, 28 Dec 2025 20:58:55 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: sathya.prakash@broadcom.com
Cc: sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: mpt3sas: Fix memory leak in _base_enable_msix()
Date: Sun, 28 Dec 2025 12:58:52 +0000
Message-Id: <20251228125852.3690161-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b650a566c03a1kunmc02b318ca5dd0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSx8eVk1DSkwYGRgdSk1LHVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=NyLr0vqmnqTfg9o1DAg+4hmAvQ0cvv39vWmrg3HJOfk1BJ0aGMkOH5SMEntbQc9adVjxmk1SAhYcxWAprsnV19WfqbM7Frp1oVXwM4LLHH8DaKKGlxMEWP4DV/n8F1l+dDWk8twBxy1S7bE4AA4g9dc0XaDevwvtyTrRzWEpWBc=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=B/8kwrPDy4wB9ZKmT/tDxU/I7owR0AkYIT7J3lKrtow=;
	h=date:mime-version:subject:message-id:from;

In _base_enable_msix(), if _base_alloc_irq_vectors() fails, the function
jumps to the try_ioapic label without freeing the allocated
ioc->io_uring_poll_queues, leading to a memory leak.

Fix this by freeing ioc->io_uring_poll_queues before jumping to
try_ioapic.

Fixes: 1d55abc0e98a ("scsi: mpt3sas: switch to pci_alloc_irq_vectors")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0d652db8fe24..2b7f823fb4cb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3507,6 +3507,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	r = _base_alloc_irq_vectors(ioc);
 	if (r < 0) {
 		ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n", r);
+		kfree(ioc->io_uring_poll_queues);
 		goto try_ioapic;
 	}
 
-- 
2.34.1

