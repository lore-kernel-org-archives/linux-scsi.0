Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8E813AC1;
	Fri, 24 Jan 2025 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737704211; cv=none; b=XIhnW8YcIHtj6KVgEpFC//J+cf/NkHHWG9Om/gLUX9Wjce8e4tShQTxsJQw/W34vLNmiMp9Uy2zuRR9kAJDnKKCRfF7Zue7Ty0oI8cEEBP4IEaut5z6ryVSGpSxy7+Olp1YPK+a2fOMghZ0L39RE6C//JrAX+tLPNoneB8w7HHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737704211; c=relaxed/simple;
	bh=III9aeivKKsByI2pyvRmy4KldHI+hMPrNe3oADAH9B4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q5G6ZwLswh3DLGr1t90onE8OMhJBf26uxdDnKlFucftxI5Sn+Ll9jleiwMzyByxe1lNSFl4q0J0n+VkEZcS0fW4r2y1AlZCnVxzqbUbmoYh5ZqiJ0yHyGSyOsHzj/63Ss8fDUUkfRiWrK8ururPNuo4iMS+hweITQYoV2ciNPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=W+AHWRcP; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W+AHWRcP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737704209; x=1769240209;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=III9aeivKKsByI2pyvRmy4KldHI+hMPrNe3oADAH9B4=;
  b=W+AHWRcPszTICf8kNSeC0YAQi53M7eMy4HHxKLN/FH+IyTmonFlgHhtX
   hHHtCgPI0/03w2LjlJr0bo4zj0Jp07tMqYTQ8EVyODglmIPnvjoBQQGXP
   5ehJ7BB5YMgFyEiw2glCmHHRNmCaefSZhjgoJxVo1fkO1Fgo4PPednu9l
   vm2MN1TGIaKiGKRY/pfKHBeiEdcLk0rGNYzB3Ezoh6ELBpJqkpcu9HAOl
   y3n9EA02hQe7D503phwtSy0SprW5rHGDj2LsjHV3wdhOemY1ZICegCdua
   Qa0OIXrxv7x2/jPdIczh6AbeAuftwfByDEyOpzRB1T35qVa8ObgvFjwPi
   g==;
X-CSE-ConnectionGUID: vmcXwT+aQTqfuQSp/HCtxQ==
X-CSE-MsgGUID: iMWohm79TYC2lV1Yx+6pZw==
X-IronPort-AV: E=Sophos;i="6.13,230,1732550400"; 
   d="scan'208";a="37226748"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2025 15:36:45 +0800
IronPort-SDR: 67933571_OTWnJbEV1dNHOvsfWuzVITONh21pqUJqZ96YZp1XhejVjAf
 dy4S3VZfFd6aUvVCNAmCrxhLrqI3gZO24JLd9Jg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2025 22:38:41 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2025 23:36:41 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
Date: Fri, 24 Jan 2025 09:33:54 +0200
Message-Id: <20250124073354.3814674-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
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

Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes since v1:
 - move the spin_lock_init(&hba->clk_gating.lock) call from
   ufshcd_init_clk_gating() just before the ufshcd_hba_init() call in
   ufshcd_init() (Bart)
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c38cf10382..9b17f6e2f807 100644
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
@@ -10412,6 +10410,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->irq = irq;
 	hba->vps = &ufs_hba_vps;
 
+	/*
+	 * Initialize clk_gating.lock early since it is being used in
+	 * ufshcd_setup_clocks()
+	 */
+	if (ufshcd_is_clkgating_allowed(hba))
+		spin_lock_init(&hba->clk_gating.lock);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
-- 
2.25.1

