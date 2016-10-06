From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH] scsi: ufshcd: fix possible unclocked register access
Date: Wed,  5 Oct 2016 17:57:46 -0700
Message-ID: <1475715466-1765-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Vendor specific setup_clocks callback may require the clocks managed
by ufshcd driver to be ON. So if the vendor specific setup_clocks callback
is called while the required clocks are turned off, it could result into
unclocked register access.

To prevent possible unclock register access, this change makes sure that
required clocks remain enabled before calling into vendor specific
setup_clocks callback.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05c7456..acee5a3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5389,6 +5389,17 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (!head || list_empty(head))
 		goto out;
 
+	/*
+	 * vendor specific setup_clocks ops may depend on clocks managed by
+	 * this standard driver hence call the vendor specific setup_clocks
+	 * before disabling the clocks managed here.
+	 */
+	if (!on) {
+		ret = ufshcd_vops_setup_clocks(hba, on);
+		if (ret)
+			return ret;
+	}
+
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
 			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
@@ -5410,6 +5421,11 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 		}
 	}
 
+	/*
+	 * vendor specific setup_clocks ops may depend on clocks managed by
+	 * this standard driver hence call the vendor specific setup_clocks
+	 * after enabling the clocks managed here.
+	 */
 	ret = ufshcd_vops_setup_clocks(hba, on);
 out:
 	if (ret) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
