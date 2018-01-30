From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufshcd: fix possible unclocked register access
Date: Tue, 30 Jan 2018 08:52:25 +0530
Message-ID: <1517282545-10502-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53252 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbeA3DXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 22:23:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

vendor specific setup_clocks ops may depend on clocks managed by ufshcd
driver so if the vendor specific setup_clocks callback is called when
the required clocks are turned off, it results into unclocked register
access.

This change make sure that required clocks are enabled before vendor
specific setup_clocks callback is called.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8af2af3..c5ee686 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6763,9 +6763,16 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (list_empty(head))
 		goto out;
 
-	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
-	if (ret)
-		return ret;
+	/*
+	 * vendor specific setup_clocks ops may depend on clocks managed by
+	 * this standard driver hence call the vendor specific setup_clocks
+	 * before disabling the clocks managed here.
+	 */
+	if (!on) {
+		ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
+		if (ret)
+			return ret;
+	}
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
@@ -6789,9 +6796,16 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 		}
 	}
 
-	ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
-	if (ret)
-		return ret;
+	/*
+	 * vendor specific setup_clocks ops may depend on clocks managed by
+	 * this standard driver hence call the vendor specific setup_clocks
+	 * after enabling the clocks managed here.
+	 */
+	if (on) {
+		ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
+		if (ret)
+			return ret;
+	}
 
 out:
 	if (ret) {
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
