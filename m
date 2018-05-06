From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 1/4] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date: Sun, 06 May 2018 15:44:15 +0530
Message-ID: <1525601658-31989-2-git-send-email-alim.akhtar@samsung.com>
References: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20180506102638epcas1p17bea76e1a5dbac535d5d6a10181f7e29@epcas1p1.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net, alim.akhtar@samsung.com
List-Id: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and
'1' indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 21 +++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 00e7905..9898ce5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -675,7 +675,24 @@ static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+}
+
+/**
+ * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
+ * @hba: per adapter instance
+ * @pos: position of the bit to be cleared
+ */
+static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
+{
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
@@ -5398,7 +5415,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 		goto out;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	ufshcd_utmrl_clear(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8110dcd..43035f8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -595,6 +595,11 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			0x80
 
+	/*
+	 * Cleaer handling for transfer/task request list is just opposite.
+	 */
+	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		0x100
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.7.4
