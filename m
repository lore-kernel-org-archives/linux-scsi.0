From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 04/11] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date: Wed, 14 Oct 2015 18:25:44 +0530
Message-ID: <1444827351-24128-5-git-send-email-alim.akhtar@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, alim.akhtar@samsung.com, arnd@arndb.de
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

In the right behavior, setting the bit to '0' indicates clear and
'1' indicates no change. If host contoller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   21 +++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |    5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 587a9c8fbfe9..2b16eb363203 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -356,7 +356,24 @@ static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
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
@@ -3685,7 +3702,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 		goto out;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	ufshcd_utmrl_clear(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6cd542a803d5..d625d01110b0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -474,6 +474,11 @@ struct ufs_hba {
 	 */
 	#define UFSHCI_QUIRK_BYTE_ALIGN_UTRD			UFS_BIT(6)
 
+	/*
+	 * Cleaer handling for transfer/task request list is just opposite.
+	 */
+	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		UFS_BIT(7)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.7.10.4
