Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3902A3002AF
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 11:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759145272; cv=none; b=r9flhPSYrSK1XMIxyjgObR1sorgRAcgpi1eCCAfxkajuDpKlv6DyynxMuL1v+GzPwzb4mtrecm1teE5RNGYVQ8Ogzm2gOfi67Mbw2QCwQy0s/Zcz8qqhk/J9tVfUzqUazJBC5GBlZirYhyjtv/UD8nSRfVZ6O3za2ghvzOVlGug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759145272; c=relaxed/simple;
	bh=K4dDR17SKQ+iYYKthLN5oCT/pg1dmS959JMpR7euNx4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=DzP3b//kcNjSse+EdJ3ncHZIDUUGxKrAtUbKMhDCrMtB2+AaeneB9C88xgfxLnlcpDpwgbvkZAjWoycU7XNxiatTKwq3RgymmV8d6BmC/LdYsJ268naVG6nrIDyV7N1278FNwIMosZ2pr3OjGmMBSVMmg8kaOfp3/dtgqD/BqIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dEueFhTj; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dEueFhTj"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250929112741euoutp0145d61cbf68f56b0b078e402d0541c811~pvUtsFimV3101831018euoutp01n
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 11:27:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250929112741euoutp0145d61cbf68f56b0b078e402d0541c811~pvUtsFimV3101831018euoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759145261;
	bh=Is61J66vqLlTRTlRtdZNarB4aHnsTBxzCeofbT6hdKY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=dEueFhTjCRPSm6+BghHONFrFHGtumyK4tC7Dvuk5p17KuMdWy/QsN5ktIwRxBCWM/
	 5uhLaO5+3GSfDtjdh/AS8MA43MuN703fx6O5d9jhenK0Nax/Rn1nCAjPmA2z1niggY
	 42lMenU+YSZLFqg8DNF5bxUCNL88yRVJntXurYDI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138~pvUtUob8Q1108011080eucas1p2G;
	Mon, 29 Sep 2025 11:27:40 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250929112740eusmtip144609c4746f46fcc5e314eb037ef18bd~pvUs4XQu11536915369eusmtip1j;
	Mon, 29 Sep 2025 11:27:40 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: [PATCH] scsi: ufs: core: Fix PM QoS mutex initialization
Date: Mon, 29 Sep 2025 13:27:30 +0200
Message-Id: <20250929112730.3782765-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138
X-EPHeader: CA
X-CMS-RootMailID: 20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138
References: <CGME20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138@eucas1p2.samsung.com>

hba->pm_qos_mutex is used very early as a part of ufshcd_init(), so it
need to be initialized before that call. This fixes the following
warning:
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:577 at __mutex_lock+0x268/0x894, CPU#4: kworker/u32:4/72
Modules linked in:
CPU: 4 UID: 0 PID: 72 Comm: kworker/u32:4 Not tainted 6.17.0-rc7-next-20250926+ #11223 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: events_unbound deferred_probe_work_func
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __mutex_lock+0x268/0x894
lr : __mutex_lock+0x268/0x894
...
Call trace:
 __mutex_lock+0x268/0x894 (P)
 mutex_lock_nested+0x24/0x30
 ufshcd_pm_qos_update+0x30/0x78
 ufshcd_setup_clocks+0x2d4/0x3c4
 ufshcd_init+0x234/0x126c
 ufshcd_pltfrm_init+0x62c/0x82c
 ufs_qcom_probe+0x20/0x58
 platform_probe+0x5c/0xac
 really_probe+0xbc/0x298
 __driver_probe_device+0x78/0x12c
 driver_probe_device+0x40/0x164
 __device_attach_driver+0xb8/0x138
 bus_for_each_drv+0x80/0xdc
 __device_attach+0xa8/0x1b0
 device_initial_probe+0x14/0x20
 bus_probe_device+0xb0/0xb4
 deferred_probe_work_func+0x8c/0xc8
 process_one_work+0x208/0x60c
 worker_thread+0x244/0x388
 kthread+0x150/0x228
 ret_from_fork+0x10/0x20
irq event stamp: 57267
hardirqs last  enabled at (57267): [<ffffd761485e868c>] _raw_spin_unlock_irqrestore+0x74/0x78
hardirqs last disabled at (57266): [<ffffd76147b13c44>] clk_enable_lock+0x7c/0xf0
softirqs last  enabled at (56270): [<ffffd7614734446c>] handle_softirqs+0x4c4/0x4dc
softirqs last disabled at (56265): [<ffffd76147290690>] __do_softirq+0x14/0x20
---[ end trace 0000000000000000 ]---

Fixes: 79dde5f7dc7c ("scsi: ufs: core: Fix data race in CPU latency PM QoS request handling")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d9632d7c5f01..b3b14af4a726 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10677,6 +10677,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	spin_lock_init(&hba->clk_gating.lock);
 
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Host controller drivers can override them in their
@@ -10765,9 +10768,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	mutex_init(&hba->wb_mutex);
 
-	/* Initialize mutex for PM QoS request synchronization */
-	mutex_init(&hba->pm_qos_mutex);
-
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
-- 
2.34.1

