From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 09/10] scsi: sd: Avoid sending medium write commands if device is write protected
Date: Mon, 11 Aug 2014 15:40:37 +0300
Message-ID: <1407760838-6406-10-git-send-email-draviv@codeaurora.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

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
