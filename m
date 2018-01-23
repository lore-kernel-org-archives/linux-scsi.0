From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: Allowing power mode change
Date: Tue, 23 Jan 2018 17:32:00 +0530
Message-ID: <1516708920-20620-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@quicinc.com, cang@codeaurora.org, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

Due to M-PHY issues, moving from HS to any other mode or gear or
even Hibern8 causes some un-predicted behavior of the device.
This patch fixes this issues.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011c336..d74d529 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4167,9 +4167,13 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	} while (ret && retries--);
 
-	if (ret)
+	if (ret) {
 		/* failed to get the link up... retire */
 		goto out;
+	} else {
+		ufshcd_dme_set(hba, UIC_ARG_MIB(TX_LCC_ENABLE), 0);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(TX_LCC_ENABLE), 1);
+	}
 
 	if (link_startup_again) {
 		link_startup_again = false;
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
