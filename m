From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 09/11] scsi: ufs: fix condition in which DME command failure msg is printed out
Date: Wed, 23 Nov 2016 16:32:49 -0800
Message-ID: <1479947569-7256-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

The condition in which error message is printed out was incorrect and
resulted error message only if retries exhausted.
But retries happens only if DME command is a peer command, and thus
DME commands which are not peer commands and fail are not printed out.
This change fixes this issue.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ec4c99a..b826078 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2516,10 +2516,10 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
 	} while (ret && peer && --retries);
 
-	if (!retries)
+	if (ret)
 		dev_err(hba->dev, "%s: attr-id 0x%x val 0x%x failed %d retries\n",
-				set, UIC_GET_ATTR_ID(attr_sel), mib_val,
-				retries);
+			set, UIC_GET_ATTR_ID(attr_sel), mib_val,
+			UFS_UIC_COMMAND_RETRIES - retries);
 
 	return ret;
 }
@@ -2583,9 +2583,10 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 				get, UIC_GET_ATTR_ID(attr_sel), ret);
 	} while (ret && peer && --retries);
 
-	if (!retries)
+	if (ret)
 		dev_err(hba->dev, "%s: attr-id 0x%x failed %d retries\n",
-				get, UIC_GET_ATTR_ID(attr_sel), retries);
+			get, UIC_GET_ATTR_ID(attr_sel),
+			UFS_UIC_COMMAND_RETRIES - retries);
 
 	if (mib_val && !ret)
 		*mib_val = uic_cmd.argument3;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
