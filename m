From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 04/10] scsi: ufs: add quirk not to allow reset of interrupt
 aggregation
Date: Fri, 21 Aug 2015 14:57:55 +0530
Message-ID: <1440149281-26336-5-git-send-email-alim.akhtar@samsung.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, JBottomley@odin.com, Seungwon Jeon <tgih.jun@samsung.com>
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <tgih.jun@samsung.com>

Some host controller supports interrupt aggregation, but doesn't
allow to reset counter and timer by s/w.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    3 ++-
 drivers/scsi/ufs/ufshcd.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b441a39..35380aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3204,7 +3204,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_BROKEN_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 24245c9..7986a54 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -471,6 +471,12 @@ struct ufs_hba {
 	 */
 	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		UFS_BIT(7)
 
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	#define UFSHCI_QUIRK_BROKEN_RESET_INTR_AGGR		UFS_BIT(8)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.7.10.4
