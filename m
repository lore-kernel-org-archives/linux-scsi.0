From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
Date: Wed, 08 May 2013 17:41:42 +0900
Message-ID: <002601ce4bc7$dd78f530$986adf90$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3EHIly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 04:41:54 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMH00G9E1HJI6A0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 08 May 2013 17:41:43 +0900 (KST)
In-reply-to: 
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

There is no need to check the version to clear
the interrupt status. And the order is changed
prior to actual handling.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index feaf221..e04c74e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1582,11 +1582,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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


