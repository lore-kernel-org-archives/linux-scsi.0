From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 05/11] scsi: ufs: add quirk not to allow reset of interrupt
 aggregation
Date: Wed, 14 Oct 2015 18:25:45 +0530
Message-ID: <1444827351-24128-6-git-send-email-alim.akhtar@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, alim.akhtar@samsung.com, arnd@arndb.de
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

Some host controller supports interrupt aggregation, but doesn't
allow to reset counter and timer by s/w.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    3 ++-
 drivers/scsi/ufs/ufshcd.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2b16eb363203..ca7483cd899e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3199,7 +3199,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d625d01110b0..4ae32e9316de 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -479,6 +479,12 @@ struct ufs_hba {
 	 */
 	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		UFS_BIT(7)
 
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		UFS_BIT(8)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.7.10.4
