Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7A3172BD3
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=clpgvDa7QIvCAAn3wYKZcIVn4so7HgbdR/SPQlcvDPCxYaEpKXxz4WgnmnLND6PrTCkt3/p1NgHsezmRgGE2f1wAFHZ7RbFCXMT8LbbdrvTy0it/2JKEVEyozSzOwv7W1TZLejfy4XIE+O1D1iB/dXXbExmES+CQbgBlZxQEe50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=4WpKlLgpqRqpKuuDkg/DMLuyfrvi5SrfALUcu4Nwhuo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpCWq/ltu/nb5pc9bOfaebID0cg/N1E0upnmzw2HQl4DifKrDt74xrjVNCXBaExFwNFvNePSiOurRQKGCVf7K7dozqLVl52zmZIAgZrYhjMNHPwjKzXXGDwdjGcime2/lYSfFI483LluQc5MaVVYMUF7pT1rLseUtoY/So/5r6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XDbvT3ybJz1SBbN;
	Thu, 26 Sep 2024 09:42:45 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CA241A016C;
	Thu, 26 Sep 2024 09:43:34 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:34 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 08/13] scsi: hisi_sas: Default enable interrupt coalescing
Date: Thu, 26 Sep 2024 09:43:27 +0800
Message-ID: <20240926014332.3905399-9-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

In the current interrupt reporting mode, each CQ entry reports an
interrupt. However, when there are a large number of I/O hardware
completion interrupts, the following issue may occur:

[ 4682.678657][  C129] irq 134: nobody cared (try booting with the "irqpoll" option)
[ 4682.708455][  C129] Call trace:
[ 4682.711589][  C129]  dump_backtrace+0x0/0x1e4
[ 4682.715934][  C129]  show_stack+0x20/0x2c
[ 4682.719933][  C129]  dump_stack+0xd8/0x140
[ 4682.724017][  C129]  __report_bad_irq+0x54/0x180
[ 4682.728625][  C129]  note_interrupt+0x1ec/0x2f0
[ 4682.733143][  C129]  handle_irq_event+0x118/0x1ac
[ 4682.737834][  C129]  handle_fasteoi_irq+0xc8/0x200
[ 4682.742613][  C129]  __handle_domain_irq+0x84/0xf0
[ 4682.747391][  C129]  gic_handle_irq+0x88/0x2c0
[ 4682.751822][  C129]  el1_irq+0xbc/0x140
[ 4682.755648][  C129]  _find_next_bit.constprop.0+0x20/0x94
[ 4682.761036][  C129]  cpumask_next+0x24/0x30
[ 4682.765208][  C129]  gic_ipi_send_mask+0x48/0x170
[ 4682.769900][  C129]  __ipi_send_mask+0x34/0x110
[ 4682.775720][  C129]  smp_cross_call+0x3c/0xcc
[ 4682.780064][  C129]  arch_send_call_function_single_ipi+0x38/0x44
[ 4682.786146][  C129]  send_call_function_single_ipi+0xd0/0xe0
[ 4682.791794][  C129]  generic_exec_single+0xb4/0x170
[ 4682.796659][  C129]  smp_call_function_single_async+0x2c/0x40
[ 4682.802395][  C129]  blk_mq_complete_request_remote.part.0+0xec/0x100
[ 4682.808822][  C129]  blk_mq_complete_request+0x30/0x70
[ 4682.813950][  C129]  scsi_mq_done+0x48/0xac
[ 4682.818128][  C129]  sas_scsi_task_done+0xb0/0x150 [libsas]
[ 4682.823692][  C129]  slot_complete_v3_hw+0x230/0x710 [hisi_sas_v3_hw]
[ 4682.830120][  C129]  cq_thread_v3_hw+0xbc/0x190 [hisi_sas_v3_hw]
[ 4682.836114][  C129]  irq_thread_fn+0x34/0xa4
[ 4682.840371][  C129]  irq_thread+0xc4/0x130
[ 4682.844455][  C129]  kthread+0x108/0x13c
[ 4682.848365][  C129]  ret_from_fork+0x10/0x18
[ 4682.852621][  C129] handlers:
[ 4682.855577][  C129] [<00000000949e52bf>] cq_interrupt_v3_hw [hisi_sas_v3_hw] threaded [<000000005d8e3b68>] cq_thread_v3_hw [hisi_sas_v3_hw]
[ 4682.868084][  C129] Disabling IRQ #134

When the IRQ management layer processes each hardware interrupt, if the
return value of the interrupt handler is IRQ_WAKE_THREAD, it will wake up
the handler thread for this interrupt action and set IRQTF_RUNTHREAD flag,
wait for the interrupt handling thread to clear the IRQTF_RUNTHREAD flag
after execution. Later in note_interrupt(), use irq_count to count
hardware interrupts and irqs_unhandled to count interrupts for which no
thread handler is responsible. When irq_count reaches 100000 and
irqs_unhandled reaches 99000, irq will be disabled.

In the performance test scenario, I/O completion hardware interrupts are
continuously and quickly generated. As a result, the interrupt processing
thread is cyclically called in irq_thread() and does not exit, this
affects the response of the interrupt thread to the hardware interrupt and
causes irqs_unhandled to grow to 99000. Finally, the irq is disabled.

Therefore, default enable interrupt coalescing to reduce the generation of
hardware interrupts, this helps interrupt processing threads to stop
calling in irq_thread().

For interrupt coalescing, according to the actual performance test, set
the count of CQ entries to 10 and the interrupt coalescing timeout period
to 10us based on the actual performance test.

Before and after interrupt coalescing is enabled, the 4K read/write
performance is improved by about 3%, and the 256K read/write performance
is basically the same.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e6fbbefe9959..310c782b4926 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -638,9 +638,11 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, TRANS_LOCK_ICT_TIME, 0x4A817C80);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
-	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
-	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
-	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
+	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x3);
+	/* configure the interrupt coalescing timeout period 10us */
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0xa);
+	/* configure the count of CQ entries 10 */
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0xa);
 	hisi_sas_write32(hisi_hba, CQ_INT_CONVERGE_EN,
 			 hisi_sas_intr_conv);
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 0xffff);
@@ -2797,14 +2799,15 @@ static void config_intr_coal_v3_hw(struct hisi_hba *hisi_hba)
 {
 	/* config those registers between enable and disable PHYs */
 	hisi_sas_stop_phys(hisi_hba);
+	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x3);
 
 	if (hisi_hba->intr_coal_ticks == 0 ||
 	    hisi_hba->intr_coal_count == 0) {
-		hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
-		hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
-		hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
+		/* configure the interrupt coalescing timeout period 10us */
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0xa);
+		/* configure the count of CQ entries 10 */
+		hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0xa);
 	} else {
-		hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x3);
 		hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME,
 				 hisi_hba->intr_coal_ticks);
 		hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT,
-- 
2.33.0

