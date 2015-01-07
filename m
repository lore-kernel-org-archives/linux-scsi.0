From: Giel van Schijndel <me@mortis.eu>
Subject: [PATCH RESEND] scsi: cleanup: snprintf() always NUL-terminates: depend on it
Date: Wed,  7 Jan 2015 20:20:15 +0100
Message-ID: <1420658416-20839-1-git-send-email-me@mortis.eu>
References: <1420394759-20345-1-git-send-email-me@mortis.eu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from khitomer.mortis.eu ([185.27.175.75]:21845 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbAGTUe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 14:20:34 -0500
In-Reply-To: <1420394759-20345-1-git-send-email-me@mortis.eu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Giel van Schijndel <me@mortis.eu>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>

Especially since one very strange piece of code seems to be written in
such a way that a NUL needs to be placed where a NUL is present already.
The author probably meant to fill the last byte of the buffer with a NUL
instead. But regardless of that: that isn't necessary since snprintf()
already guarantees NUL termination for buffers sizes > 0 and <= INT_MAX.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
Reported-at: http://www.viva64.com/en/b/0299/
---
 drivers/scsi/ipr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df4e27c..b49fe45 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3990,7 +3990,6 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 		return -EACCES;
 
 	len = snprintf(fname, 99, "%s", buf);
-	fname[len-1] = '\0';
 
 	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
@@ -9358,13 +9357,12 @@ static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int vec_idx, n = sizeof(ioa_cfg->vectors_info[0].desc) - 1;
+	int vec_idx;
 
 	for (vec_idx = 0; vec_idx < ioa_cfg->nvectors; vec_idx++) {
-		snprintf(ioa_cfg->vectors_info[vec_idx].desc, n,
+		snprintf(ioa_cfg->vectors_info[vec_idx].desc,
+			 sizeof(ioa_cfg->vectors_info[vec_idx].desc),
 			 "host%d-%d", ioa_cfg->host->host_no, vec_idx);
-		ioa_cfg->vectors_info[vec_idx].
-			desc[strlen(ioa_cfg->vectors_info[vec_idx].desc)] = 0;
 	}
 }
 
-- 
2.1.4

