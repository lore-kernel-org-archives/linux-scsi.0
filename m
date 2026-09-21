Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948BE489FCF;
	Mon, 21 Sep 2026 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999480; cv=none; b=SBvl+jUX0xs4UC5/DV7y+lNjAZcNvPMb6hO6L4V3Sbo0wVQPqxdvtPVUcei3xokoPEE1PSeIrQYmteho3CqC2yBT0RhNiIWvbswqAFdM+0iC0wUOxy3xek/J6kti5Y/tLTEf32fo8LOhmCx6VjeCziGhu03wtqiO0jwIgLx9aiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999480; c=relaxed/simple;
	bh=gzJY6OGTFyEJObmEW5YFsD3UN6ByF7WKJSOatE72Zoc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NPAflBjhkQTwCOntg4wB4XL+3lQ3oVMy2/PbD1TmrkGWwEPR3ldiz0HHUmy8hBP9L2+lWi6uyrhkQN9vGJSNQExZdMThNR62RJ0F3mQim+MCrWjNewWeOm7HZOEbtE1bucEuyDblFZGKPTdDEz7CmmVnECcpVGt1kj2nGPK0qNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=FyxqUK9H; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="FyxqUK9H"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4e967d614;
	Mon, 21 Sep 2026 22:04:23 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: mptfusion: avoid freeing an unregistered IRQ
Date: Mon, 21 Sep 2026 22:04:18 +0800
Message-Id: <20260921140418.170920-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0c4483b4503a1kunm9d10e2f450ea7
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHh5NVkIfShgaSR0dGE1DT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=FyxqUK9H6wEhchwyvZObM2RFlULMfeFwUWJhDyQffCXfosYO9CMU4tNzfxUkhcO6YomKFEx8ESxo2zbc0Em/Vy51gQaiFYrchGobD0/5wHW4EyolizsV+GmR/Jz6qKWixz1rIcYloepCjRx/v5PPaAt1+Jt5MR3GH5ThMw0k+8g=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=GfoMtLLWM8pqWzSgFJweDQ1Z4Ltg6d17nIEGy43G6wQ=;
	h=date:mime-version:subject:message-id:from;

mpt_do_ioc_recovery() can successfully request an IRQ during IOC bringup
and fail later. The recovery cleanup frees the IRQ but leaves pci_irq
pointing at the released IRQ. A later adapter disposal can then attempt to
free it again.

mpt_suspend() also unconditionally calls free_irq() when the bringup path
did not register an IRQ and left pci_irq at -1. Guard the suspend cleanup
and clear pci_irq after recovery cleanup so the field reflects whether the
handler is registered.

Reproducer:
Build both kernels with a test-only hook that makes the first
SendIocInit() call during resume recovery return -EIO after the IRQ has
been registered. Boot an x86_64 guest in QEMU with an mptsas1068 device:

    -device mptsas1068,id=scsi0

As root in the guest, run:

    printf mem > /sys/power/state
    printf mem > /sys/power/state
    dmesg | grep 'Trying to free already-free IRQ'

The unfixed kernel reports the warning during the second suspend, while
the fixed kernel completes both suspend/resume cycles without it. The
failure injection is test-only and does not claim that SendIocInit()
fails spontaneously during normal operation.

Fixes: 9bf0a28c9a24 ("[SCSI] kdump: mpt fusion driver initialization failure fix")
Fixes: 4d4109d0eb69 ("[SCSI] mpt fusion: Power Management fixes for MPT SAS PCI-E controllers")
Cc: stable@vger.kernel.org

Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/message/fusion/mptbase.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 3a431ffd3e2eb..79e0cb8fa5c56 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2160,10 +2160,12 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Clear any lingering interrupt */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
-	free_irq(ioc->pci_irq, ioc);
-	if (ioc->msi_enable)
-		pci_disable_msi(ioc->pcidev);
-	ioc->pci_irq = -1;
+	if (ioc->pci_irq != -1) {
+		free_irq(ioc->pci_irq, ioc);
+		if (ioc->msi_enable)
+			pci_disable_msi(ioc->pcidev);
+		ioc->pci_irq = -1;
+	}
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_release_selected_regions(pdev, ioc->bars);
@@ -2615,6 +2617,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
  out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
+		ioc->pci_irq = -1;
 		if (ioc->msi_enable)
 			pci_disable_msi(ioc->pcidev);
 	}
-- 
2.34.1

