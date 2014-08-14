From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RFC V2 09/16] scsi: sd: Avoid sending medium write commands if device is write protected
Date: Thu, 14 Aug 2014 16:31:00 +0300
Message-ID: <1408023067-26103-10-git-send-email-draviv@codeaurora.org>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbaHNNbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2014 09:31:44 -0400
In-Reply-To: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

The SYNCHRONIZE_CACHE command is a medium write command and hence can
fail when the device is write protected. Avoid sending such commands by
making sure that write-cache-enable is disabled even though the device
claim to support it.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3663e38..67282bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -185,7 +185,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	if (ct < 0)
 		return -EINVAL;
 	rcd = ct & 0x01 ? 1 : 0;
-	wce = ct & 0x02 ? 1 : 0;
+	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
 
 	if (sdkp->cache_override) {
 		sdkp->WCE = wce;
@@ -2493,6 +2493,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			sdkp->DPOFUA = 0;
 		}
 
+		/* No cache flush allowed for write protected devices */
+		if (sdkp->WCE && sdkp->write_prot)
+			sdkp->WCE = 0;
+
 		if (sdkp->first_scan || old_wce != sdkp->WCE ||
 		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
 			sd_printk(KERN_NOTICE, sdkp,
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

