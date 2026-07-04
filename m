Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [4.193.249.245])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C528716DC28;
	Sat,  4 Jul 2026 01:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.193.249.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783129885; cv=none; b=EPfkyXsc3fA+SlAqC31IHjoanpNPnwzw5m9GTwtgOgGP0SifntlMzPHKSJmpExurLnvmybpLufrOqiMYsFxML2lmJ3kzbmIT2a5QuBAU6is/LnPEek14C34auZmfLx6uS8OPWKfq2ytd3Wmnq8BU6ozWRn1tkfPdA41rEtuXWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783129885; c=relaxed/simple;
	bh=Rk4Slocyzo+Yelgb4XdxwsLvRVYn1p2S/K14Tb9eLJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n0XP8a84R2I+4fZB2OyIK/5y481to8GmaISh7K2RvzAJxaoPS2QugoT18luwgluFLDniGKPcbygvAnVI1tSbXyV8Pp85BtehLTR2bAioWXoKoxGwlxRdzLuUJBfg1NM/ODiOCHEH7aBhwa0+4YPzqivg2/x/EV6n5rkhHE/q5mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=4.193.249.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wD3_18NZ0hq8_AAAA--.2113S3;
	Sat, 04 Jul 2026 09:51:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgBnMXUKZ0hq5T3SAg--.25549S2;
	Sat, 04 Jul 2026 09:51:09 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH v2] scsi: smartpqi: drain controller workers before freeing controller
Date: Sat,  4 Jul 2026 01:50:11 +0000
Message-Id: <20260704015011.21283-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260701142757.8447-1-fanwu01@zju.edu.cn>
References: <20260701142757.8447-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgBnMXUKZ0hq5T3SAg--.25549S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?3GGZEgXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WN+s7ZayU/iDTZ9S3og6h4AEjXddY+tMD55RWHLL8mWCJv/
	X5CW1XKbumUPSYqqcwqp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoWxCw4DXw4xKr1kWryDAFW7ZFc_yoW5Kry7pr
	4fJ3sxJr48tF13u3Wqv3W8ZFyrCw4kKrZ8C34xt3sxCF43Ary0qa4UCF4jvFy5Jrsayr42
	vrsYva43WF98JacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
	xVWxJr0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjx
	CEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAF
	wI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0x
	vY0x0EwIxGrwACjcxG0xvY0x0EwIxGrVCF72vEw4AK0wCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_
	GrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

pqi_remove_ctrl() stops the heartbeat timer and cancels the rescan and
update_time delayed workers, but the controller can still have
ctrl_offline_work, event_work, ofa_memory_alloc_work and ofa_quiesce_work
queued (armed from the heartbeat timer and IRQ/error paths). These recover
struct pqi_ctrl_info through container_of and dereference it, so a worker
that runs after pqi_free_ctrl_info() frees the controller is a
use-after-free.

Drain them in pqi_free_ctrl_resources(). pqi_event_worker() starts by
wait_event()ing on block_requests, which pqi_remove_ctrl() sets and never
clears in the remove path, so cancelling it while blocked would wait
forever; unblock first. The controller is already offline by then
(controller_online was cleared earlier in pqi_remove_ctrl()), so the
released worker returns without rearming rescan or OFA work.

ctrl_offline_work is disabled rather than cancelled because
pqi_take_ctrl_offline() can re-queue it. Its callback also calls
pqi_free_interrupts(), so it must be drained before the teardown's own
pqi_free_interrupts() to avoid a concurrent double free_irq() on the same
MSIX vectors.

After the IRQs are freed and event_work is drained, cancel the rescan
worker again: an event worker that passed the pqi_ctrl_offline() check
before the controller went offline may still have scheduled rescan via
pqi_schedule_rescan_worker_with_delay(). The OFA workers are cancelled
last; their sole producer is event_work, already drained.

This bug was found by static analysis.

Fixes: 5f310425c8ea ("scsi: smartpqi: update rescan worker")
Cc: stable@vger.kernel.org # needs adjustments for <= 6.6: use cancel_work_sync()
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>

---

Changes from v1:
- Fixed deadlock: cancel_work_sync(event_work) while block_requests was
  set could wait forever; now unblocks first.
- Moved disable_work_sync(ctrl_offline_work) before pqi_free_interrupts()
  to avoid concurrent double free_irq() with the offline worker's own
  interrupt freeing.
- Cancel rescan_work again after draining event_work, to catch a rescan
  armed by an event worker that passed the offline check before the
  controller went offline.
---
 drivers/scsi/smartpqi/smartpqi_init.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fe549e2b7c94..14f85fb95dfa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8891,7 +8891,19 @@ static void pqi_free_interrupts(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
 {
+	/*
+	 * Release blocked workers first.  Disable ctrl_offline_work before
+	 * freeing IRQs because its callback can also free them.  event_work
+	 * can requeue rescan_work, so drain event_work before cancelling
+	 * rescan again.
+	 */
+	pqi_ctrl_unblock_requests(ctrl_info);
+	disable_work_sync(&ctrl_info->ctrl_offline_work);
 	pqi_free_interrupts(ctrl_info);
+	cancel_work_sync(&ctrl_info->event_work);
+	pqi_cancel_rescan_worker(ctrl_info);
+	cancel_work_sync(&ctrl_info->ofa_memory_alloc_work);
+	cancel_work_sync(&ctrl_info->ofa_quiesce_work);
 	if (ctrl_info->queue_memory_base)
 		dma_free_coherent(&ctrl_info->pci_dev->dev,
 			ctrl_info->queue_memory_length,
-- 
2.34.1

