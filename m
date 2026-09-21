Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B6249B5A4;
	Mon, 21 Sep 2026 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002451; cv=none; b=UR9xRDflFsZMJ98X4GP0RFsQoNImt51lPiN75epPh2+F11/rmBzX0cs7JDUg5AylWIBbPq1KXw2lzfo5I4WmAjn1P+Jlp0TrUFu64PtokbyAYe6nF0aOAdwbzZKaI+N57BYj/8p3zihzch4umzmcGEUL4D1RGH+SnDnLVc0z+ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002451; c=relaxed/simple;
	bh=4tljT0UkC55usKowBbdeFYcEaGePDIjXOwpNQ1L4Pcw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d+OE4zOnPHec6Q8R4TvHV8ge+1Mcdi9KF2PDWvPVwEcepIh3DEB7S+yX2bjYGmv2JXyJyZpO8CVRiXJItFTAkp7gY/qDHvPtAEYyG3XRsHTVKGIZal+Og+3twAl0hqocySZyRkulM97ZW7mL3POtiD359jlK4lbWoozfWspjJwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Z9gx2Fft; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Z9gx2Fft"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4e97fb598;
	Mon, 21 Sep 2026 22:53:45 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Vishal Bhakta <vishal.bhakta@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jim Gill <jgill@vmware.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: vmw_pvscsi: only free a requested IRQ
Date: Mon, 21 Sep 2026 22:53:39 +0800
Message-Id: <20260921145339.307402-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0c4756e0303a1kunmf1aca89053058
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSBhPVh5PTkhJTxlISEpMS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Z9gx2FftTv9qEk9q4XrYnV3uVAudxN1o/mr9BgIFlWgrTdgUu7Di5lOumMwZCFXDkOxu8JZ6gcRFywuXc6xwhHFrWwxfo0mEh63KSt1mdpWQjJrfd7uRU8gvCFLgF/ZWQu6US3gXEiOtnz1mHEXuozqehtmwifAU7ed4uSX4JDc=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=KEuHVsjNPxiQYkvXDKOhWZsKO1tEFxl0yddp6YFoVPs=;
	h=date:mime-version:subject:message-id:from;

pvscsi_shutdown_intr() is used by both normal teardown and probe failure
paths. It unconditionally calls free_irq(), even when probe fails before
request_irq() or pci_alloc_irq_vectors() has succeeded. That passes an
unregistered IRQ to free_irq(), which reports an already-free IRQ.

Track successful request_irq() registration and only free the IRQ on that
path. Clear the state after freeing so repeated shutdown paths remain safe.

Reproducer:

  Build an x86_64 kernel with CONFIG_PCI=y, CONFIG_SCSI=y,
  CONFIG_SCSI_LOWLEVEL=y, CONFIG_VMWARE_PVSCSI=m,
  CONFIG_FUNCTION_ERROR_INJECTION=y, CONFIG_FAULT_INJECTION=y,
  CONFIG_FAULT_INJECTION_DEBUG_FS=y, and CONFIG_FAIL_FUNCTION=y. For
  testing, add ALLOW_ERROR_INJECTION(scsi_host_alloc, NULL) to
  drivers/scsi/hosts.c, then boot QEMU with a PVSCSI device:

    qemu-system-x86_64 -machine pc -m 1G -smp 2 -nodefaults \
      -no-reboot -display none -serial file:console.log \
      -kernel arch/x86/boot/bzImage -initrd test.cpio.gz \
      -append 'console=ttyS0 rdinit=/init loglevel=7 panic=1' \
      -device pvscsi,id=scsi0

  In the guest, mount debugfs and inject one NULL return from
  scsi_host_alloc() before loading vmw_pvscsi:

    mount -t debugfs none /sys/kernel/debug
    echo 100 > /sys/kernel/debug/fail_function/probability
    echo 1 > /sys/kernel/debug/fail_function/times
    echo scsi_host_alloc > /sys/kernel/debug/fail_function/inject
    echo 0 > /sys/kernel/debug/fail_function/scsi_host_alloc/retval
    insmod vmw_pvscsi.ko

  On the unfixed kernel, the probe reaches pvscsi_shutdown_intr() before
  request_irq() and prints "Trying to free already-free IRQ 10" followed
  by a warning from __free_irq(). The fixed kernel reaches the same
  failure path without the unmatched free_irq() warning. The injection
  is deliberate and is not expected during ordinary probing.

Fixes: 2e48e3491189 ("scsi: vmw_pvscsi: switch to pci_alloc_irq_vectors")
Cc: stable@vger.kernel.org
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/vmw_pvscsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..7babef882 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -69,6 +69,7 @@ struct pvscsi_adapter {
 	u8				rev;
 	bool				use_msg;
 	bool				use_req_threshold;
+	bool				irq_requested;
 
 	spinlock_t			hw_lock;
 
@@ -1212,7 +1213,10 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 
 static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
 {
-	free_irq(pci_irq_vector(adapter->dev, 0), adapter);
+	if (adapter->irq_requested) {
+		free_irq(pci_irq_vector(adapter->dev, 0), adapter);
+		adapter->irq_requested = false;
+	}
 	pci_free_irq_vectors(adapter->dev);
 }
 
@@ -1526,6 +1530,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		       "vmw_pvscsi: unable to request IRQ: %d\n", error);
 		goto out_reset_adapter;
 	}
+	adapter->irq_requested = true;
 
 	error = scsi_add_host(host, &pdev->dev);
 	if (error) {
-- 
2.34.1
