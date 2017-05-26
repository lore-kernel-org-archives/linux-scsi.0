From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Use sysfs_match_string()
Date: Fri, 26 May 2017 13:02:39 -0400
Message-ID: <20170526170239.19709-1-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23869 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEZRCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2017 13:02:48 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4QH2l0s005803
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 17:02:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4QH2kY4008759
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 17:02:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v4QH2kIa032423
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 17:02:46 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Avoid unnecessary snprintf() when formatting variables for display in
sysfs and switch to sysfs_match_string() for validating user input.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 71 ++++++++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432d7cc5..aaf5cd7e4e6f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -155,7 +155,7 @@ static ssize_t
 cache_type_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
-	int i, ct = -1, rcd, wce, sp;
+	int ct = -1, rcd, wce, sp;
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
 	char buffer[64];
@@ -178,16 +178,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		sdkp->cache_override = 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
-		len = strlen(sd_cache_types[i]);
-		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
-		    buf[len] == '\n') {
-			ct = i;
-			break;
-		}
-	}
+	ct = sysfs_match_string(sd_cache_types, buf);
 	if (ct < 0)
 		return -EINVAL;
+
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
 
@@ -227,7 +221,7 @@ manage_start_stop_show(struct device *dev, struct device_attribute *attr,
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
 
-	return snprintf(buf, 20, "%u\n", sdp->manage_start_stop);
+	return sprintf(buf, "%u\n", sdp->manage_start_stop);
 }
 
 static ssize_t
@@ -251,7 +245,7 @@ allow_restart_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 40, "%d\n", sdkp->device->allow_restart);
+	return sprintf(buf, "%u\n", sdkp->device->allow_restart);
 }
 
 static ssize_t
@@ -279,7 +273,7 @@ cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	int ct = sdkp->RCD + 2*sdkp->WCE;
 
-	return snprintf(buf, 40, "%s\n", sd_cache_types[ct]);
+	return sprintf(buf, "%s\n", sd_cache_types[ct]);
 }
 static DEVICE_ATTR_RW(cache_type);
 
@@ -288,7 +282,7 @@ FUA_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
+	return sprintf(buf, "%u\n", sdkp->DPOFUA);
 }
 static DEVICE_ATTR_RO(FUA);
 
@@ -298,7 +292,7 @@ protection_type_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->protection_type);
+	return sprintf(buf, "%u\n", sdkp->protection_type);
 }
 
 static ssize_t
@@ -341,9 +335,9 @@ protection_mode_show(struct device *dev, struct device_attribute *attr,
 	}
 
 	if (!dif && !dix)
-		return snprintf(buf, 20, "none\n");
+		return sprintf(buf, "none\n");
 
-	return snprintf(buf, 20, "%s%u\n", dix ? "dix" : "dif", dif);
+	return sprintf(buf, "%s%u\n", dix ? "dix" : "dif", dif);
 }
 static DEVICE_ATTR_RO(protection_mode);
 
@@ -352,7 +346,7 @@ app_tag_own_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->ATO);
+	return sprintf(buf, "%u\n", sdkp->ATO);
 }
 static DEVICE_ATTR_RO(app_tag_own);
 
@@ -362,7 +356,7 @@ thin_provisioning_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->lbpme);
+	return sprintf(buf, "%u\n", sdkp->lbpme);
 }
 static DEVICE_ATTR_RO(thin_provisioning);
 
@@ -381,7 +375,7 @@ provisioning_mode_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%s\n", lbp_mode[sdkp->provisioning_mode]);
+	return sprintf(buf, "%s\n", lbp_mode[sdkp->provisioning_mode]);
 }
 
 static ssize_t
@@ -389,7 +383,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
-	struct scsi_device *sdp = sdkp->device;
+	int mode;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -399,21 +393,11 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
-	if (sdp->type != TYPE_DISK)
+	mode = sysfs_match_string(lbp_mode, buf);
+	if (mode < 0)
 		return -EINVAL;
 
-	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP], 20))
-		sd_config_discard(sdkp, SD_LBP_UNMAP);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_WS16], 20))
-		sd_config_discard(sdkp, SD_LBP_WS16);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_WS10], 20))
-		sd_config_discard(sdkp, SD_LBP_WS10);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_ZERO], 20))
-		sd_config_discard(sdkp, SD_LBP_ZERO);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_DISABLE], 20))
-		sd_config_discard(sdkp, SD_LBP_DISABLE);
-	else
-		return -EINVAL;
+	sd_config_discard(sdkp, mode);
 
 	return count;
 }
@@ -432,7 +416,7 @@ zeroing_mode_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%s\n", zeroing_mode[sdkp->zeroing_mode]);
+	return sprintf(buf, "%s\n", zeroing_mode[sdkp->zeroing_mode]);
 }
 
 static ssize_t
@@ -440,21 +424,17 @@ zeroing_mode_store(struct device *dev, struct device_attribute *attr,
 		   const char *buf, size_t count)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	int mode;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
-		sdkp->zeroing_mode = SD_ZERO_WRITE;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
-		sdkp->zeroing_mode = SD_ZERO_WS;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
-		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
-		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
-	else
+	mode = sysfs_match_string(zeroing_mode, buf);
+	if (mode < 0)
 		return -EINVAL;
 
+	sdkp->zeroing_mode = mode;
+
 	return count;
 }
 static DEVICE_ATTR_RW(zeroing_mode);
@@ -465,7 +445,7 @@ max_medium_access_timeouts_show(struct device *dev,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->max_medium_access_timeouts);
+	return sprintf(buf, "%u\n", sdkp->max_medium_access_timeouts);
 }
 
 static ssize_t
@@ -491,7 +471,7 @@ max_write_same_blocks_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->max_ws_blocks);
+	return sprintf(buf, "%u\n", sdkp->max_ws_blocks);
 }
 
 static ssize_t
@@ -696,6 +676,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	switch (mode) {
 
+	case SD_LBP_FULL:
 	case SD_LBP_DISABLE:
 		blk_queue_max_discard_sectors(q, 0);
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
-- 
2.13.0
