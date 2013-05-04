From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v2 4/7] scsi: ufs: fix interrupt status clears
Date: Sat, 04 May 2013 17:45:25 +0900
Message-ID: <000e01ce48a3$b86b6c40$294244c0$%jun@samsung.com>
References: <002101ce4105$b184dec0$148e9c40$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23906 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3EDIp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 May 2013 04:45:26 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM900KQ9MZP1YF0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Sat, 04 May 2013 17:45:25 +0900 (KST)
In-reply-to: <002101ce4105$b184dec0$148e9c40$%jun@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

There is no need to check the version to clear
the interrupt status. And the order is changed
prior to actual handling.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bc956e8..442195c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1591,11 +1591,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 
 	if (intr_status) {
+		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		ufshcd_sl_intr(hba, intr_status);
-
-		/* If UFSHCI 1.0 then clear interrupt status register */
-		if (hba->ufs_version == UFSHCI_VERSION_10)
-			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		retval = IRQ_HANDLED;
 	}
 	spin_unlock(hba->host->host_lock);
-- 
1.7.0.4


