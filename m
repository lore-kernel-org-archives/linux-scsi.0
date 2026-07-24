Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4827B340;
	Fri, 24 Jul 2026 03:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.187.6.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862161; cv=none; b=TjKjy6hrUbFrAOT9RxKlpG3d3Rzjy1m94ghHdLjBgMaWiv0Wa/azd7f+ta2/EFeq869F7RqGD76AQPRip7QLOtye2bnqlD8RQlhKz5PQ8t0gdpKe3dVMQAhtV2qpuoMdZOqGEA8czIUPmd+yFUYMNnZd+ZLzxJ1/+BKE0MxSo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862161; c=relaxed/simple;
	bh=iUGrkeEnU0zFKwmzl9YF9vPhtUddhfLS8bGTVEEShG0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Dg/j9kpXEWWxCqzo7x2TTqQmhTdr+xrzFi3O6GsRmm6i1sya8SaI34BjfpPTa+xUKsRsqtmOQrtxrBQnTQwEOS9dZCRz8mrGbdBf9Wgjs6TFxSYPv/N366RegL9gl/w/dhJXbLNyVmLJJYpKrN7M3LSFL5De/bRPW6xq+NxBF2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.187.6.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wBnUffG1WJqmxo1AA--.54595S3;
	Fri, 24 Jul 2026 11:02:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with SMTP id zC_KCgDHFMnF1WJqiAspAw--.55174S2;
	Fri, 24 Jul 2026 11:02:30 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: Don Brace <don.brace@microchip.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Kevin Barnett <Kevin.Barnett@pmcs.com>,
	Webb Scales <webbnh@hp.com>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: hpsa: destroy resubmit workqueue after unregistering IRQs
Date: Fri, 24 Jul 2026 03:01:34 +0000
Message-Id: <20260724030134.16434-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgDHFMnF1WJqiAspAw--.55174S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?VESbfQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfncGSG+szpQCInt5Y8rbJUI0cbbfRGw8Fl34gGnb4IuD14LrozZrarVxuP5mZ1TiHqNH4
	UJ3JeypcXgUz+YkVvlCp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoWxWw45GrWDAryrKFyrXF1kZwc_yoW5tFy8pr
	Z8Aw15Cay0qF4UK39rZw1UXFy3uFs5JrWUCayxW3srAr98AryUua40kFWjqFyrWrWvyrWa
	yFWDJas8XFWUAFgCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8
	JbIYCTnIWIevJa73UjIFyTuYvjxU7gAwDUUUU

An IOACCEL command that completes with a retryable error is retried from
hard-IRQ context through hpsa_retry_cmd(), which calls INIT_WORK() on the
command and queue_work_on(h->resubmit_wq).  Unlike the rescan, monitor and
event delayed workers, which are cancelled and self-guarded by
remove_in_progress before their workqueues are destroyed, resubmit_wq is
armed from the interrupt completion path and has no such guard.

hpsa_remove_one() destroys resubmit_wq, together with rescan_ctlr_wq and
monitor_ctlr_wq, before calling __hpsa_shutdown(), where hpsa_free_irqs()
unregisters the interrupt handler.  Between the workqueue destruction and
hpsa_free_irqs() the handler can still fire and call queue_work_on() on
resubmit_wq.  queue_work_on() refuses new work on a workqueue being torn
down, dropping the retry with a WARN_ONCE; and once the structure has been
freed through call_rcu(), a later queue_work_on() may dereference freed
memory, a potential use-after-free.  The window is reachable because
scsi_remove_host(), which runs between the two points, can itself generate
I/O (SYNCHRONIZE CACHE, per the existing comment).

Destroy resubmit_wq after __hpsa_shutdown() instead.  This restores the
ordering from before commit 6636e7f455b3 ("hpsa: Use local workqueues
instead of system workqueues"), which moved the
destroy_workqueue(h->resubmit_wq) call in hpsa_remove_one() ahead of the
controller shutdown; resubmit_wq was originally torn down after
hpsa_shutdown(), as introduced by commit 080ef1cc7fdf ("hpsa: use
workqueue to resubmit failed ioaccel commands").

Keeping resubmit_wq alive until after __hpsa_shutdown() is safe.
Each retry stays associated with its SCSI request until the command is
completed with scsi_done(); hpsa_remove_one() runs scsi_remove_host()
first, which tears down each request queue and waits for outstanding
requests, so it cannot return while retry work (including work that a
later IOACCEL completion requeues) remains outstanding.  __hpsa_shutdown()
then masks and frees the interrupts, and free_irq() waits for any handler
still running on another CPU, so by the time destroy_workqueue() runs on
resubmit_wq the completion path can no longer queue new work.

This issue was found by an in-house static analysis tool.

Fixes: 6636e7f455b3 ("hpsa: Use local workqueues instead of system workqueues")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..8e039011aeaf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9057,7 +9057,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
 	cancel_delayed_work_sync(&h->event_monitor_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
-	destroy_workqueue(h->resubmit_wq);
 	destroy_workqueue(h->monitor_ctlr_wq);
 
 	hpsa_delete_sas_host(h);
@@ -9073,6 +9072,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	/* includes hpsa_free_irqs - init_one 4 */
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
 	__hpsa_shutdown(pdev);
+	destroy_workqueue(h->resubmit_wq);
 
 	hpsa_free_device_info(h);		/* scan */
 
-- 
2.34.1

