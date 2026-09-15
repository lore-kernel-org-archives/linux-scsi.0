Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBEB48F852;
	Tue, 15 Sep 2026 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483540; cv=none; b=kgbgIg6bkF6RMtXoFvGNp3qF0keIYTSU3BZlhD1yw4FzpzbV6Orz17h1/iS33MMGN0drMHoMewLvqUzpqftc4XkysFbD213fGL+YgCOSssQfOBjTWTOq5ByL7rNVnJ5wh3h4WdGLWoAqvK1hIkt7wlpb4IzXsVYkmi96jhElbOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483540; c=relaxed/simple;
	bh=ngtFN2V7ULql4DUgNtKS4FIutat4Fea3e7vRM4yoZuo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AmZ/mk+UwnNtb3Xc33cYoWKLuEvfDpDtFtJUULRX/jeKZeq6nTm/l2dc1kmon76xpCbyOy2mi7yTCr6xg9VyeblAWxQn/He9s4QgQY3FA1tFxMl7BqOv9LuG7gtRuZCI0MOh514rlwl1Ay8k4BFfHYbsokGiXDTUNvGV1xcAWvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=vo9uy1po; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="vo9uy1po"
Received: from tju.edu.cn (gy-adaptive-ssl-proxy-3-entmail-virt135.gy.ntes [183.242.150.9])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4ddceb51f;
	Tue, 15 Sep 2026 22:45:25 +0800 (GMT+08:00)
From: Yibo Tan <lhfff@tju.edu.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Nick Cheng <nick.cheng@areca.com.tw>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: arcmsr: Flush message work after stopping IRQs
Date: Tue, 15 Sep 2026 22:45:21 +0800
Message-Id: <20260915144521.3464486-1-lhfff@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0a587a5c303a1kunme20085972df811
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCT09NVhkaTkJNTUhLSh1LQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKQ0hVSU9JVUpOS1VCWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=vo9uy1poMbqPZhfneFB4JBnF0i9dhN8ZM7S3D9XMk0JVpZXKmMsJt7rqt18W7ud+p+KNZr+O+96rqLWwXSnp5aTeGF6fSm98+OdkprtvIabkdp/ByLyk1N3kg8ZrtKPDuK4Zu90q2aU8wB7FRWLbdBV1F7jMBt+0AbEGg2veLUg=; c=relaxed/relaxed; s=default; d=tju.edu.cn; v=1;
	bh=I8vSmh7Ds3qx5wd4jSnnaD0chD8RLu19OJ58Uz1XJDM=;
	h=date:mime-version:subject:message-id:from;

The adapter message interrupt handlers schedule
arcmsr_do_message_isr_bh.  The work item is embedded in the adapter control
block, which is released with the SCSI host.

The probe error path, hot-disconnect path and normal remove path all
flush this work before arcmsr_free_irq().  An interrupt can therefore
queue it again after the flush.  The normal remove path can also call the
interrupt handler while it waits for outstanding commands.  The SCSI
host can then be freed while the new work is still pending.

KASAN reported a use-after-free in arcmsr_message_isr_bh_fn() in two
unload tests.  Moving the flush after arcmsr_free_irq() made unload wait
for the work to finish, and both tests completed without a kernel
diagnostic.

Move the existing flush after arcmsr_free_irq() in all three paths.  This
matches arcmsr_shutdown(): remove and synchronize the IRQ handlers, wait
for the work to finish, and then free the SCSI host.

Fixes: 36b83ded062a ("[SCSI] arcmsr: Support HW reset for EH and polling scheme for scsi device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8aa948f06cac..1a497de2a762 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1164,10 +1164,10 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (set_date_time)
 		timer_delete_sync(&acb->refresh_timer);
 	timer_delete_sync(&acb->eternal_timer);
-	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_free_irq(pdev, acb);
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 scsi_host_remove:
 	scsi_remove_host(host);
 free_ccb_pool:
@@ -1685,12 +1685,12 @@ static void arcmsr_free_pcidev(struct AdapterControlBlock *acb)
 	host = acb->host;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	flush_work(&acb->arcmsr_do_message_isr_bh);
 	timer_delete_sync(&acb->eternal_timer);
 	if (set_date_time)
 		timer_delete_sync(&acb->refresh_timer);
 	pdev = acb->pdev;
 	arcmsr_free_irq(pdev, acb);
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_free_ccb_pool(acb);
 	if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
 		arcmsr_free_io_queue(acb);
@@ -1718,7 +1718,6 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	}
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	flush_work(&acb->arcmsr_do_message_isr_bh);
 	timer_delete_sync(&acb->eternal_timer);
 	if (set_date_time)
 		timer_delete_sync(&acb->refresh_timer);
@@ -1750,6 +1749,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 		}
 	}
 	arcmsr_free_irq(pdev, acb);
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_free_ccb_pool(acb);
 	if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
 		arcmsr_free_io_queue(acb);
-- 
2.39.5

