Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715D4D2EE4;
	Mon, 28 Sep 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602924; cv=none; b=nmt0/zjZ0a1PH0BWJtqR1vIP9NPqFY/RqvvOtBiUNv3WUbaD46OtHY+jN2Kj6k8P86FpEBpQnVxinWJg2XyaON4MlbpOhJ8XUE3NQEhXoAbjsKsSlYe1MW6jHZc6z6ZstdoTcNHjmlX564xnO8mQDF4aYtA2GB71gBoOqH5HwaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602924; c=relaxed/simple;
	bh=XRcvmDDB+5xh98ZvLE35xZfvq4+KvKPVPVvlgMByAhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H013pEQ9j2kLU70P1y87c6vPJoUSCkEKCNfmyxcFhb00WgpvVvbxPHUuCoUCUxFxWU9O/OWdWgaHUxHspUxwjDvhwhM2d2Konh+SxFjAr7eCkhlnQGBQf2qCP2lX99qkNsP2hvjhAfierg68y/tJzfD+pXSPhtleOh9npXLm7Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=aFptQ0Ca; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="aFptQ0Ca"
Received: from LAPTOP-99KJFSET (unknown [36.153.54.109])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f5d6f43f;
	Mon, 28 Sep 2026 21:41:55 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: justin.tee@broadcom.com,
	paul.ely@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Hongyan Xu <getshell@seu.edu.cn>
Subject: [PATCH] scsi: lpfc: disable delayed CQ work before freeing a queue
Date: Mon, 28 Sep 2026 21:41:54 +0800
Message-ID: <20260928134154.1595-1-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e8402b8603a1kunmc550c0a8200227
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSkMaVklNH0lLHUhOTUJNSFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlITVVKTkhVTk9VSktCWVdZFhoPEhUdFFlBWU9LSFVKS0hKT0
	hMVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=aFptQ0CaobaYW8RNJZecDljCElGCeiZBq4SrhprlWRC/Rgifq4RrcuVtNKSZiTah9rSmjmD76/jF+QXTOLT08voDtPwXCkNI3SgJXdVycL4eRa8SmIZ09+07HDaotFgrs/8LiNCkx48M9QtC2rXCO84pxpz/mzADKMbv3FMdZ+8=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=bKeaclT9gczNNNbjMNNIzyt+R5Y2qcBepSErsvHqTpY=;
	h=date:mime-version:subject:message-id:from;

CQ processing can leave sched_irqwork or sched_spwork pending on a
delayed work timer. Flushing the HBA workqueue does not wait for delayed
work whose timer has not yet queued it, allowing lpfc_sli4_queue_free()
to release the embedded work item and its queue first.

Initialize both delayed works before allocation can fail, and disable
them synchronously before freeing any queue resources.

Fixes: 32517fc0975b ("scsi: lpfc: Rework EQ/CQ processing to address interrupt coalescing")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cfa4371169f1..0348442b979f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15828,6 +15828,9 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 	if (!queue)
 		return;
 
+	disable_delayed_work_sync(&queue->sched_irqwork);
+	disable_delayed_work_sync(&queue->sched_spwork);
+
 	if (!list_empty(&queue->wq_list))
 		list_del(&queue->wq_list);
 
@@ -15892,6 +15895,8 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	INIT_LIST_HEAD(&queue->page_list);
 	INIT_LIST_HEAD(&queue->child_list);
 	INIT_LIST_HEAD(&queue->cpu_list);
+	INIT_DELAYED_WORK(&queue->sched_irqwork, lpfc_sli4_dly_hba_process_cq);
+	INIT_DELAYED_WORK(&queue->sched_spwork, lpfc_sli4_dly_sp_process_cq);
 
 	/* Set queue parameters now.  If the system cannot provide memory
 	 * resources, the free routine needs to know what was allocated.
@@ -15922,8 +15927,6 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	}
 	INIT_WORK(&queue->irqwork, lpfc_sli4_hba_process_cq);
 	INIT_WORK(&queue->spwork, lpfc_sli4_sp_process_cq);
-	INIT_DELAYED_WORK(&queue->sched_irqwork, lpfc_sli4_dly_hba_process_cq);
-	INIT_DELAYED_WORK(&queue->sched_spwork, lpfc_sli4_dly_sp_process_cq);
 
 	/* notify_interval will be set during q creation */
 
-- 
2.50.1.windows.1

