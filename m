From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 2/4] scsi: ufs: add quirk not to allow reset of interrupt
 aggregation
Date: Sun, 06 May 2018 15:44:16 +0530
Message-ID: <1525601658-31989-3-git-send-email-alim.akhtar@samsung.com>
References: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20180506102639epcas2p13ac44966a64e539f611ccdc2479e1abb@epcas2p1.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net, alim.akhtar@samsung.com
List-Id: linux-scsi@vger.kernel.org

Some host controller supports interrupt aggregation, but doesn't
allow to reset counter and timer by s/w.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9898ce5..253257c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4695,7 +4695,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 43035f8..5c91ff1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -600,6 +600,12 @@ struct ufs_hba {
 	 */
 	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		0x100
 
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		0x200
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.7.4
