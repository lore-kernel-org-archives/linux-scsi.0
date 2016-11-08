From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: introduce UFSHCI_QUIRK_SKIP_INTR_AGGR quirk
Date: Tue, 08 Nov 2016 16:59:58 +0900
Message-ID: <002401d23996$1986d4b0$4c947e10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:56035 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbcKHH77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 02:59:59 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGB01N2LCVUSH60@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 08 Nov 2016 16:59:58 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

If UFS driver resets interrupt aggregation timer and counter
when there is a pending doorbell, an interrupt of IO completion
of a corresponding task may be missed.
That would cause a command timeout.

If UFS driver resets interrupt aggregation timer and counter
when there is a pending doorbell, a competion interrupt
of a corresponing task may be issued.
That would casue a command timeout.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c904854..65bbf59 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3730,7 +3730,9 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if ((ufshcd_is_intr_aggr_allowed(hba))
+		&& !(hba->quirks & UFSHCI_QUIRK_SKIP_INTR_AGGR))
+		ufshcd_reset_intr_aggr(hba);
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6a96f24..6a9c6e9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -497,6 +497,7 @@ struct ufs_hba {
 	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
 	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
 	#define UFSHCD_QUIRK_USE_OF_HCE				UFS_BIT(9)
+	#define UFSHCI_QUIRK_SKIP_INTR_AGGR			UFS_BIT(10)
 
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
-- 
2.1.4

