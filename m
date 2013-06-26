From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 03/10] scsi: ufs: remove version check before IS reg clear
Date: Wed, 26 Jun 2013 22:33:59 +0530
Message-ID: <1372266246-2725-4-git-send-email-santoshsy@gmail.com>
References: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64245 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3FZREt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:04:49 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so14347495pbc.25
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:04:49 -0700 (PDT)
In-Reply-To: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

There is no need to check the version to clear
the interrupt status. And the order is changed
prior to actual handling.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1f1e085..2e02483 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1324,11 +1324,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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
1.8.3.1

