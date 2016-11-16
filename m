From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Wed, 16 Nov 2016 14:03:04 +0900
Message-ID: <000401d23fc6$b6685110$2338f330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54750 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750697AbcKPFDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 00:03:21 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGP029MEY11QV60@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 16 Nov 2016 14:03:04 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

Some UFS host controllers may clear a transfer request slot
by setting an associated bit in UTRLCLR/UTMRLCLR to 1, not 0.
That's opposite to what UFS spec describes.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  7 +++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d6e3112..c9cf011 100644
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
@@ -4312,7 +4336,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 		goto out;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	ufshcd_utmrl_clear(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7d9ff22..9838598 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -491,6 +491,13 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
 
+	/*
+	 * This quirk needs to be enabled if the host contoller has to set
+	 * the bit corresponding the slot to be cleared to 1, not 0 as
+	 * described in UFS spec.
+	 */
+	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.1.4


