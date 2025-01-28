Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F13192D84;
	Tue, 28 Jan 2025 07:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738048518; cv=none; b=HSDtB6W7issUFQHdTsG7MXk9j7bBMh5jBR0FeOkdkAbf8jLRbkf+dZ7nk+KI0UNtlWCSpbGy2VrHItD44OvmGvyWhHVfqMlMMWr17qkjHXyi9X4RiSCzsugFAE3o5zkNI8y0bQiI9JRhWlIoTYWdw6oMUmSsZ3okNtTNWYt/w/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738048518; c=relaxed/simple;
	bh=Ef3upsXnnmq9KUQz7WRB+zhN6wdIMrBB6Aeh/3jJQ5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J3XGft9yZ0ga0VgK5b1aZbE/98ZX9nMoAOYLhKiLCWm865N+YI/XIw5N4j5Lk3sZ1KywYP69jgLmTJsp4dmEpIFQ9Y+rzkARsoSqvVtu7RL5M/FJgSqslCozWVdP26aaCDde0eOTJjs2n2q7TH9/ODaKPBDgxU99GU87Y+JXt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c/6eKZi1; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c/6eKZi1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738048516; x=1769584516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ef3upsXnnmq9KUQz7WRB+zhN6wdIMrBB6Aeh/3jJQ5Q=;
  b=c/6eKZi1rcWnGX0KMW+EBq25la+UvBz27YelITDRuTDC6OWJal7Tp178
   YyTLGBzgDAJsDoQ32Dgn8NT9L4myYw3sEDdxWHJ8hWiSwUAElfsgnFeaQ
   dfRo2xOkIi4NNTHIZssWLZr0ZCnkmPuXqSnng7LBeMleWWXgyDs1UM0jG
   z9hOjoioT2unp5LNyOhN40es6xrG7l2SH3huW9U4d8vF5puC2QiqDwr+d
   O5k8Iz4h6yNOLOG5Xufl8uR14dLC2cH+wkNkgzYvzJkhWfctud5h0NBCh
   2xqDGAZPbm+pEK8QeWWHbNzVIu1lPVjJBsfPl9TJOoKmGkkeCYlrC/IgI
   A==;
X-CSE-ConnectionGUID: /wOXKjVHQ2miF80SPoPwmA==
X-CSE-MsgGUID: DEX89FtHQtC2fkC8TfRqGQ==
X-IronPort-AV: E=Sophos;i="6.13,240,1732550400"; 
   d="scan'208";a="37987017"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2025 15:15:09 +0800
IronPort-SDR: 6798765f_SqRKcpFTtjXzpsckS51Wst2DJuwvXYJqiwD5WPop29xNjPP
 8fI1lBm/M8UcZtZGMXz43pItC3RnLHOssGcaUlw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 22:17:03 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 23:15:07 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 1/2] scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
Date: Tue, 28 Jan 2025 09:12:06 +0200
Message-Id: <20250128071207.75494-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250128071207.75494-1-avri.altman@wdc.com>
References: <20250128071207.75494-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit addresses a lockdep warning triggered by the use of the
clk_gating.lock before it is properly initialized. The warning is as
follows:

[    4.388838] INFO: trying to register non-static key.
[    4.395673] The code is fine but needs lockdep annotation, or maybe
[    4.402118] you didn't initialize this object before use?
[    4.407673] turning off the locking correctness validator.
[    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12-rc1 #185
[    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
[    4.413362] Call trace:
[    4.413364]  show_stack+0x18/0x24 (C)
[    4.413374]  dump_stack_lvl+0x90/0xd0
[    4.413384]  dump_stack+0x18/0x24
[    4.413392]  register_lock_class+0x498/0x4a8
[    4.413400]  __lock_acquire+0xb4/0x1b90
[    4.413406]  lock_acquire+0x114/0x310
[    4.413413]  _raw_spin_lock_irqsave+0x60/0x88
[    4.413423]  ufshcd_setup_clocks+0x2c0/0x490
[    4.413433]  ufshcd_init+0x198/0x10ec
[    4.413437]  ufshcd_pltfrm_init+0x600/0x7c0
[    4.413444]  ufs_qcom_probe+0x20/0x58
[    4.413449]  platform_probe+0x68/0xd8
[    4.413459]  really_probe+0xbc/0x268
[    4.413466]  __driver_probe_device+0x78/0x12c
[    4.413473]  driver_probe_device+0x40/0x11c
[    4.413481]  __device_attach_driver+0xb8/0xf8
[    4.413489]  bus_for_each_drv+0x84/0xe4
[    4.413495]  __device_attach+0xfc/0x18c
[    4.413502]  device_initial_probe+0x14/0x20
[    4.413510]  bus_probe_device+0xb0/0xb4
[    4.413517]  deferred_probe_work_func+0x8c/0xc8
[    4.413524]  process_scheduled_works+0x250/0x658
[    4.413534]  worker_thread+0x15c/0x2c8
[    4.413542]  kthread+0x134/0x200
[    4.413550]  ret_from_fork+0x10/0x20

To fix this issue, ensure that the spinlock is only used after it
has been properly initialized before using it in `ufshcd_setup_clocks`.
Do that unconditionally as initializing a spinlock is a fast operation.

Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c38cf10382..b73c87da383d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2120,8 +2120,6 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
-	spin_lock_init(&hba->clk_gating.lock);
-
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -10412,6 +10410,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->irq = irq;
 	hba->vps = &ufs_hba_vps;
 
+	/*
+	 * Initialize clk_gating.lock early since it is being used in
+	 * ufshcd_setup_clocks()
+	 */
+	spin_lock_init(&hba->clk_gating.lock);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
-- 
2.25.1

