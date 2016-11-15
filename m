From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: introduce UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR quirk
Date: Tue, 15 Nov 2016 19:57:19 +0900
Message-ID: <00eb01d23f2f$09299aa0$1b7ccfe0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34946 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbcKOK5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 05:57:21 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGO02IQUJRJC280@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 15 Nov 2016 19:57:19 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vinholikatti@gmail.com
Cc: cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

If UFS driver resets interrupt aggregation timer and counter
when there are some pended tasks, an IO competion interrupt
of any corresponing task may be issued.
That would casue a command timeout.

One thing you should mind to use interrupt aggreation
with this quirk is that the host controller should be
able to refresh interrupt aggreation counter or timer
in other way, such as doing it automatically when receiving
any response. 

V2
- modify the commit message
- change the name of the quirk
(s/ UFSHCI_QUIRK_SKIP_INTR_AGGR/UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR)

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8aac98f..7b62d8b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3713,7 +3713,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if ((ufshcd_is_intr_aggr_allowed(hba))
+		&& !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index dfa17ac..d6861ed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -505,6 +505,13 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_HCE				UFS_BIT(9)
 
+	/*
+	 * This quirk is only not to reset interrupt aggregation logic
+	 * in ISR. The reset can make the host controller miss an event
+	 * of previously completed IO.
+	 */
+	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		UFS_BIT(10)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.1.4


