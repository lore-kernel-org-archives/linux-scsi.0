From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 5/8] scsi: ufs: fix interrupt status clears
Date: Mon, 13 May 2013 13:02:15 +0300
Message-ID: <1368439340-26346-6-git-send-email-draviv@codeaurora.org>
References: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Seungwon Jeon <tgih.jun@samsung.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

There is no need to check the version to clear
the interrupt status. And the order is changed
prior to actual handling.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
Acked-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c342a38..f4293d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1478,11 +1478,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
