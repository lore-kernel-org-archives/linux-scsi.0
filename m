Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBED70839;
	Sun, 26 Jan 2025 06:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737874117; cv=none; b=XtC02gL+VMdYruYuCOFlp838psqOOO43dDRZJuZ7bgcTsu/80HH6AoBr6b9L6M/9bQuPUU0Iqu5cji7vuLdc2WQZ3z/eUe/DxBPD++BTA5ZrhE//asjMA0cSyYJyeyPGJ0KgH5qSD38DlzqKaFePX7twNWNqscEyZ0KvHYl8jG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737874117; c=relaxed/simple;
	bh=d19W+FapVGrIgQjfm3lNAjqHEF57wreNHedB3RFpZY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tcm/2bksO1aNofJLaUlbk0tffBPG2+DPP9a+/piZKX+9nwRDQiFOmbP5loxrEi46SEzurYXZXUEXwXoBSPzLFDZaWmSLSfe9SOfxwr5jQOZFkyBUpUIPu/hC71l49HKQZcyWBs+2W9P/qoqeZ8CS7KvUZZXNti/fVJJxr7yJZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eoT0watW; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eoT0watW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737874115; x=1769410115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d19W+FapVGrIgQjfm3lNAjqHEF57wreNHedB3RFpZY4=;
  b=eoT0watWp9g93dyENtY5F4Nb6AETHJPimunXjb/hVsi+sccsRDNRMmH9
   jBdnVn2H+LlbsSeq1jMZr7lVIuBqpE8e0Y7C/U0u8mBvy/6Urjm4i2wGy
   C11d4EVzLbgNKti5cpl6sZPThlguXS5OtRAq8LTfLBLIYUZl2LD2NTslu
   n69d4fD9Fzbrr7tVgnbCDoVl0JQYaTWOjTW8bHFqBcAwEuIcYzWnyLmJd
   Mx0y3BUkGfYegu4hYcA7B8xS+ctPSFgicvu47+BsMgsC3uM/6075iIXw7
   1gJFmzjbm3e9iO8GCxAJqQ5Aau5eTIvPsBDy7Tgdt66Jttx86WzXoUst+
   w==;
X-CSE-ConnectionGUID: q4SEr/DiTyKNPu81Vipurw==
X-CSE-MsgGUID: 5VfNDJwNR9KPVbNi2YhMOw==
X-IronPort-AV: E=Sophos;i="6.13,235,1732550400"; 
   d="scan'208";a="37344168"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2025 14:48:34 +0800
IronPort-SDR: 6795cd26_cbGJzkz8wAG+BExxANnKap0Xb73nXH288r+120eEGgw6PRz
 JG18iHGEzevgqD2OjpfQBBSXhDEFcUIWcdZj4xA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2025 21:50:30 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2025 22:48:33 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/2] scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed
Date: Sun, 26 Jan 2025 08:45:21 +0200
Message-Id: <20250126064521.3857557-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250126064521.3857557-1-avri.altman@wdc.com>
References: <20250126064521.3857557-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit addresses an issue where `clk_gating.state` is being toggled
in `ufshcd_setup_clocks` even if clock gating is not allowed. This can
lead to a crash with the following error:

    BUG: spinlock bad magic on CPU#6, swapper/0/1
     lock: 0xffffff84443014e8, .magic: 00000000, .owner: <none>/-1,
    .owner_cpu: 0
    CPU: 6 UID: 0 PID: 1 Comm: swapper/0 Not tainted
    6.13.0-rcar3-initrd-08318-g75abbef32a94 #896
    Hardware name: R-Car S4 Starter Kit board (DT)
    Call trace:
     show_stack+0x18/0x24 (C)
     dump_stack_lvl+0x60/0x80
     dump_stack+0x18/0x24
     spin_bug+0x7c/0xa0
     do_raw_spin_lock+0x34/0xb4
     _raw_spin_lock_irqsave+0x1c/0x30
     class_spinlock_irqsave_constructor+0x18/0x30
     ufshcd_setup_clocks+0x98/0x23c
     ufshcd_init+0x288/0xd38
     ufshcd_pltfrm_init+0x618/0x738
     ufs_renesas_probe+0x18/0x24
     platform_probe+0x68/0xb8
     really_probe+0x138/0x268
     __driver_probe_device+0xf4/0x10c
     driver_probe_device+0x3c/0xf8
     __driver_attach+0xf0/0x100
     bus_for_each_dev+0x84/0xdc
     driver_attach+0x24/0x30
     bus_add_driver+0xe8/0x1dc
     driver_register+0xbc/0xf8
     __platform_driver_register+0x24/0x30
     ufs_renesas_platform_init+0x1c/0x28
     do_one_initcall+0x84/0x1f4
     kernel_init_freeable+0x238/0x23c
     kernel_init+0x20/0x120
     ret_from_fork+0x10/0x20

The root cause of the issue is that `clk_gating.state` is being toggled
even if clock gating is not allowed. This can lead to the spinlock being
used before it is properly initialized.

The fix is to add a check for `hba->clk_gating.is_initialized` before
toggling `clk_gating.state` in `ufshcd_setup_clocks`. Since
`clk_gating.lock` is now initialized unconditionally, this is for
documentation purposes, to ensure clarity in the code. The primary fix
remains to prevent toggling the `clk_gating.state` if clock gating is
not allowed.

Fixes: 1ab27c9cf8b6 ("ufs: Add support for clock gating")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b73c87da383d..abe0774133f5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9140,7 +9140,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
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

