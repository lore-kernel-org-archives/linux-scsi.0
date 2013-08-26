From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 2/2] scsi: replace the deprecated flush_work_sync
Date: Mon, 26 Aug 2013 23:20:17 +0900
Message-ID: <003401cea267$6349df80$29dd9e80$%jun@samsung.com>
References: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
 <1377512423.20958.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:32085 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3HZOUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 10:20:18 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MS500CHD6HTS660@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 26 Aug 2013 23:20:17 +0900 (KST)
In-reply-to: <1377512423.20958.7.camel@dabdike>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Tejun Heo' <tj@kernel.org>

flush_work_sync is replaced by flush_work with commit
4382973(workqueue: deprecate flush[_delayed]_work_sync()).

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    4 ++--
 drivers/scsi/ufs/ufshcd.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index aac6378..e1ea1ca 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1599,7 +1599,7 @@ arcmsr_remove(struct pci_dev *pdev)
 	int poll_count = 0, i;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
 	arcmsr_stop_adapter_bgrb(acb);
@@ -1661,7 +1661,7 @@ arcmsr_shutdown(struct pci_dev *pdev)
 		pci_disable_msix(pdev);
 	} else
 		free_irq(pdev->irq, acb);
-	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a0f5ac2..1b99c0a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2737,7 +2737,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 			break;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
-		flush_work_sync(&hba->eh_work);
+		flush_work(&hba->eh_work);
 	} while (1);
 
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
-- 
1.7.0.4


