Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26C1B424F;
	Wed, 22 Jan 2025 06:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737527410; cv=none; b=nHksHx8S5WfS8o8Eory5mDgQmwpMApiqOGl6ucQWCbTS4ZnFzx0NAvDA9tuSQa9PXGocP2jnoWCrmBM4MWndnp3liBBrz0gEayDsqDsqKKUpryr1JJqLGWOYpI+0WAbs2YAXqoKo0lFNM0wORmxj/2jBukrGcwtoT1//g1tZM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737527410; c=relaxed/simple;
	bh=0IARh6OvCC+lst6TB1sLLDPQuzZovuikeU6taFP7Mmw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mbAQmhrAMjqlXnLKEaslEkAiLFZHmA46ph79DAZdUhHwB8vy7ZKTjBHvClWopzAlHK9TC3DkW+Vs8uXdaez1IcD0hmYfRJk6S6JH5N+R05y2yLto7i77xf+DqnPQMWugNJORoNLnKVARAd0UPqBciYG1ecde0ACDojl60fiqfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ieS4r2Vy; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ieS4r2Vy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737527408; x=1769063408;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0IARh6OvCC+lst6TB1sLLDPQuzZovuikeU6taFP7Mmw=;
  b=ieS4r2Vy7VtIUurqhM1IrujgMgag58JG/halnvXnzz25MQoxgvsZ5b31
   WljRZj616nDxiqIf5X8Jk7tNT1q2A111Uj1hX4na9lJaHkSGEK5dgbIhC
   nyBm9SfVYV0hKv17fyqJEVv4xjw2JBciTTBWgd+tUM5xIFB9PgM3cZ1HH
   C4iKucRVSdL8iMkrfQa62EmuZqqB7cV1wAJzUbnf8oihp+RdHfn3ko8Sh
   Vv8Q1b6tSKnzTBd4vtcRpmg/LM4CiG5/xlRM7ltEEDZko10yxh4he+Nsm
   phbOfM0rEu4zi5BWRzH2x8yT7yoc84SaGzLBiOSH1mlOt6Y3Qo5xvaTz9
   Q==;
X-CSE-ConnectionGUID: ncWnu9bmRiypSzmuBpgOIA==
X-CSE-MsgGUID: WdSRf46xSQejhKq78kI5CQ==
X-IronPort-AV: E=Sophos;i="6.13,224,1732550400"; 
   d="scan'208";a="37020922"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 14:30:07 +0800
IronPort-SDR: 679082d8_mKbNsqk5VrbYSUsQzCtEZ0lCkXIRllEkv3aq6kYxZIjE9eE
 Jkkpwc6aiucdADqA1SbxIWMNUagaWiPIvgb55lA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2025 21:32:09 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2025 22:30:05 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
Date: Wed, 22 Jan 2025 08:27:18 +0200
Message-Id: <20250122062718.3736823-1-avri.altman@wdc.com>
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

To fix this issue, we use the existing `is_initialized` flag in the
`clk_gating` structure to ensure that the spinlock is only used after it
has been properly initialized. We check this flag before using the
spinlock in the `ufshcd_setup_clocks` function.

It was incorrect in the first place to call `setup_clocks()` before
`ufshcd_init_clk_gating()`, and the introduction of the new lock
unmasked this bug.

Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c38cf10382..a778fc51ca2a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9142,7 +9142,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on) {
+	} else if (!ret && on && hba->clk_gating.is_initialized) {
 		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
 			hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-- 
2.25.1

