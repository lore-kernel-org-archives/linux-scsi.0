Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794743287;
	b=z72qG3YFYtZhfeZ2NEEFhIquZuVBvWfCmLwPKmufKC+ZvewvaUbOX8wQ7y405t7OTutu
	 bZUQjV7yF6tRXjZBXIvIRXa56bCrnisiexaDQOURlkmogHipxFQ3I3+4r7Tori5Eyp0c1
	 WjuHJ0gH2Ar3c+3HBo7JEaQ5sf7hj7dMunGGBK6/Gu//c2+81VrbDdJxONzP4eXIOYsp7
	 y/OoN8pe29zNhE3IZ1hc86FXTekoVu6nwZZNoIkhui0HmnBGkm0SZrjbS4v2KAvoktndh
	 S+/7Z10R+ZEdS0qVAVvkMmK05yrmGWerMVbMdHLnbnbu/1NzH8B6QKFiMFZr5RO7D/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794743287;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=sEIXH/msDV9GvyF0+qxvVFtvVjXp874INh9AATinf40=;
	b=RlBy9Xgi5Avh3jI7PZFRzHvy1vomMHRaAVApGrV/EUKY21JWrnLKbk6calSA3UJNukFf
	 HHPA1fpg7BtokeNm93oaYaP0zahmuHQaALGTAAJr0xIYAsNhUxOidAZ2uSa6dUQ5nva/8
	 ltTIDC5LZICljGTVZatcAKw+pJ6yZXnC72G0UqTuImovecWDDkXEt4bbVtoY2GwX7ZtV1
	 KSyRNUC4jLib4v/uwSp/E/T2s/5MjCZ+be2SVbj7BpQ2gBQu6CBhdLbhWd5RGpQnrk3Zb
	 btCvLxIUigKTkYsiEkSJJQEWKhK0su8W6eabvu2WrDnfRHaxEJI5JSxESCEblUZtR+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=seu.edu.cn;
	spf=pass smtp.mailfrom=seu.edu.cn;
	dkim=pass header.d=seu.edu.cn header.i=@seu.edu.cn header.a=rsa-sha256 header.s=default header.b=TNPpIQ2t;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AFC606A8A0;
	Sun, 15 Nov 2026 11:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00AFC606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.a=rsa-sha256 header.s=default header.b=TNPpIQ2t
Received: from [192.168.17.1] (unknown [124.79.98.159])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54b7e04e2;
	Sun, 15 Nov 2026 19:47:57 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: Paul Ely <paul.ely@broadcom.com>,
 James E.J. Bottomley <James.Bottomley@HansenPartnership.com>,
 Martin K. Petersen <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Nigel Kirkland <nigel.kirkland@broadcom.com>
Subject:
 [PATCH v2] scsi: lpfc: drain all CQ work before releasing queue dependencies
Date: Sun, 15 Nov 2026 19:47:54 +0800
Message-ID: <179474327480.103840.7747335244166055751@seu.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa1df09173903a1kunmbac61c98bf791
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSE5CVkNOHUhPHxoaQksaSFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VTEJVQkNVSk5CWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=TNPpIQ2tCMYBiOQcudke4EaZmDSD3MEuvEinUVh8CbYmM6FZJPlSmrci2JtT1S1nY/xaE2tW1cCA/UJ8Q/4udV3dRwtA/SgOV8Cc4hhZ7byX1l8cdLJjEwnpZazbEdgg51UdYVYsZPkx7fRNt0woirKrtNimVbdGmYU/MWAw7Aw=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=sEIXH/msDV9GvyF0+qxvVFtvVjXp874INh9AATinf40=;
	h=date:mime-version:subject:message-id:from;

A delayed CQ handler can remain on a timer after an HBA workqueue flush.
Disabling it only in the final per-queue free also misses peer resources:
release_hdwq() frees EQs before the ELS, NVMe LS and mailbox CQs, while a
slow CQ callback still updates its associated EQ even for an empty CQ.

Disable both delayed works for every published CQ before releasing any
queues. Once all CQ timers are disabled, flush the HBA workqueue so direct
CQ handlers have completed and cannot rearm a delayed handler. Only then
release fast queues, EQs and the remaining slow queues. Keep the existing
poll-list cleanup ahead of the drain and retain the caller's interrupt
and HBA shutdown requirements. In PCI error recovery, join the registered
interrupt handlers before queue destruction rather than afterwards.

Keep synchronous per-queue disabling for allocation-error cleanup and
initialize both delayed work items before queue allocation can fail.
The global traversal uses the same existing CQ inventory that teardown
releases and accepts NULL entries from partial setup. No new global queue
list or lifetime lock is introduced.

Found by the author's in-house static analysis tool.

Fixes: 32517fc0975b ("scsi: lpfc: Rework EQ/CQ processing to address interrupt coalescing")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260928134154.1595-1-getshell@seu.edu.cn/
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Zehao Gao <gaozehao@iie.ac.cn>
---

Discovery: found by the author's in-house static analysis tool.

 drivers/scsi/lpfc/lpfc_init.c | 36 +++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c  |  7 +++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6df5f4e..0724dd8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10808,6 +10808,37 @@ lpfc_sli4_release_queues(struct lpfc_queue ***qs, int max)
 	*qs = NULL;
 }
 
+static void lpfc_sli4_disable_cq_work(struct lpfc_queue *cq)
+{
+	if (!cq)
+		return;
+
+	disable_delayed_work_sync(&cq->sched_irqwork);
+	disable_delayed_work_sync(&cq->sched_spwork);
+}
+
+static void lpfc_sli4_drain_cq_work(struct lpfc_hba *phba)
+{
+	struct lpfc_sli4_hba *sli4 = &phba->sli4_hba;
+	unsigned int i;
+
+	if (sli4->hdwq)
+		for (i = 0; i < phba->cfg_hdw_queue; i++)
+			lpfc_sli4_disable_cq_work(sli4->hdwq[i].io_cq);
+
+	if (sli4->nvmet_cqset)
+		for (i = 0; i < phba->cfg_nvmet_mrq; i++)
+			lpfc_sli4_disable_cq_work(sli4->nvmet_cqset[i]);
+
+	lpfc_sli4_disable_cq_work(sli4->els_cq);
+	lpfc_sli4_disable_cq_work(sli4->nvmels_cq);
+	lpfc_sli4_disable_cq_work(sli4->mbx_cq);
+
+	/* Direct CQ work cannot rearm the disabled delayed work. */
+	if (phba->wq)
+		flush_workqueue(phba->wq);
+}
+
 static inline void
 lpfc_sli4_release_hdwq(struct lpfc_hba *phba)
 {
@@ -10868,6 +10899,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	lpfc_sli4_cleanup_poll_list(phba);
+	lpfc_sli4_drain_cq_work(phba);
 
 	/* Release HBA eqs */
 	if (phba->sli4_hba.hdwq)
@@ -15130,9 +15162,9 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba)
 	/* stop all timers */
 	lpfc_stop_hba_timers(phba);
 
-	lpfc_sli4_queue_destroy(phba);
-	/* Disable interrupt and pci device */
+	/* Join interrupt handlers before releasing their queues. */
 	lpfc_sli4_disable_intr(phba);
+	lpfc_sli4_queue_destroy(phba);
 	pci_disable_device(phba->pcidev);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9173263..1f56978 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15815,6 +15815,9 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 	if (!queue)
 		return;
 
+	disable_delayed_work_sync(&queue->sched_irqwork);
+	disable_delayed_work_sync(&queue->sched_spwork);
+
 	if (!list_empty(&queue->wq_list))
 		list_del(&queue->wq_list);
 
@@ -15879,6 +15882,8 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	INIT_LIST_HEAD(&queue->page_list);
 	INIT_LIST_HEAD(&queue->child_list);
 	INIT_LIST_HEAD(&queue->cpu_list);
+	INIT_DELAYED_WORK(&queue->sched_irqwork, lpfc_sli4_dly_hba_process_cq);
+	INIT_DELAYED_WORK(&queue->sched_spwork, lpfc_sli4_dly_sp_process_cq);
 
 	/* Set queue parameters now.  If the system cannot provide memory
 	 * resources, the free routine needs to know what was allocated.
@@ -15909,8 +15914,6 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	}
 	INIT_WORK(&queue->irqwork, lpfc_sli4_hba_process_cq);
 	INIT_WORK(&queue->spwork, lpfc_sli4_sp_process_cq);
-	INIT_DELAYED_WORK(&queue->sched_irqwork, lpfc_sli4_dly_hba_process_cq);
-	INIT_DELAYED_WORK(&queue->sched_spwork, lpfc_sli4_dly_sp_process_cq);
 
 	/* notify_interval will be set during q creation */
 
-- 
2.50.1.windows.1
