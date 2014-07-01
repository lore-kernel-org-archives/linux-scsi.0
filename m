From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 3/3] scsi: ufs: retry if the link-startup fails
Date: Tue,  1 Jul 2014 12:22:39 +0300
Message-ID: <1404206559-21445-4-git-send-email-draviv@codeaurora.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911AbaGAJXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 05:23:07 -0400
In-Reply-To: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

In some cases, due to hardware timing issues the Uni-Pro link-startup
might fail. The UFS HCI recovery procedure contradicts the Uni-Pro
sequence. The UFS HCI specifies to resend DME_LINKSTARTUP command
after IS.ULLS (link-lost interrupt) is received. The Uni-Pro specifies
that if link-startup fails the link is in "down" state. The link-lost is
indicated to the DME user only when the link is up. Hence, the UFS HCI
recovery procedure of waiting for IS.ULLS and retrying link-startup may
not work properly.

In order to resolve the ambiguity, reset the host controller to make
sure the link is in down state and retry the link-startup.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f189e8a..3776f5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -58,6 +58,9 @@
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
+/* maximum number of link-startup retries */
+#define DME_LINKSTARTUP_RETRIES 3
+
 /* Expose the flag value from utp_upiu_query.value */
 #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
 
@@ -1923,12 +1926,32 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 static int ufshcd_link_startup(struct ufs_hba *hba)
 {
 	int ret;
+	int retries = DME_LINKSTARTUP_RETRIES;
 
 	/* enable UIC related interrupts */
 	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 
-	ret = ufshcd_dme_link_startup(hba);
+	do {
+		ret = ufshcd_dme_link_startup(hba);
+
+		/* check if device is detected by inter-connect layer */
+		if (!ret && !ufshcd_is_device_present(hba)) {
+			dev_err(hba->dev, "%s: Device not present\n", __func__);
+			ret = -ENXIO;
+			goto out;
+		}
+
+		/*
+		 * DME link lost indication is only received when link is up,
+		 * but we can't be sure if the link is up until link startup
+		 * succeeds. So reset the local Uni-Pro and try again.
+		 */
+		if (ret && ufshcd_hba_enable(hba))
+			goto out;
+	} while (ret && retries--);
+
 	if (ret)
+		/* failed to get the link up... retire */
 		goto out;
 
 	ret = ufshcd_make_hba_operational(hba);
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


