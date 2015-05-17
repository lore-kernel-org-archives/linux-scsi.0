From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 08/10] scsi: ufs-qcom: enable UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
Date: Sun, 17 May 2015 18:55:04 +0300
Message-ID: <1431878106-30579-9-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52203 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbEQPzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2015 11:55:48 -0400
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

Current version of host controller on QUALCOMM Technologies requires
this quirk to be enabled, as DME commands to device must be sent
only in AUTO mode (SLOW AUTO or FAST AUTO).

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6e5b183..de9cfb0 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -709,7 +709,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 	if (host->hw_ver.major == 0x01) {
 		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
-			    | UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP;
+			    | UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP
+			    | UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE;
 
 		if (host->hw_ver.minor == 0x0001 && host->hw_ver.step == 0x0001)
 			hba->quirks |= UFSHCD_QUIRK_BROKEN_INTR_AGGR;
@@ -721,6 +722,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
 			hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
+				| UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE
 				| UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP);
 	}
 }
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
