From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Tue, 08 Nov 2016 16:50:46 +0900
Message-ID: <002201d23994$d0aae750$7200b5f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55094 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbcKHHus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 02:50:48 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGB01D71CGM7970@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 08 Nov 2016 16:50:46 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

Some UFS host controllers may clear a transfer request slot
by setting an associated bit in UTLRCLR/UTMLRCLR to 1, not 0.
That's opposite to what UFS spec decribes.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 32 ++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 549e3e8..24d6ea7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -392,7 +392,31 @@ static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	u32 clear;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
+		clear = (1 << pos);
+	else
+		clear = ~(1 << pos);
+
+	ufshcd_writel(hba, clear, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+}
+
+/**
+ * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
+ * @hba: per adapter instance
+ * @pos: position of the bit to be cleared
+ */
+static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
+{
+	u32 clear;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
+		clear = (1 << pos);
+	else
+		clear = ~(1 << pos);
+
+	ufshcd_writel(hba, clear, REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
@@ -1147,7 +1171,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  *
  * Returns 0 in case of success, non-zero value in case of failure
  */
-static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
+static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	struct ufshcd_sg_entry *prd_table;
 	struct scatterlist *sg;
@@ -1529,7 +1553,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
-	err = ufshcd_map_sg(lrbp);
+	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
 		clear_bit_unlock(tag, &hba->lrb_in_use);
@@ -4329,7 +4353,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 		goto out;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	ufshcd_utmrl_clear(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 565f005..c4abd76 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -495,6 +495,7 @@ struct ufs_hba {
 
 	#define UFSHCD_QUIRK_GET_VS_RESULT			UFS_BIT(6)
 	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
+	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
 
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
-- 
2.1.4

