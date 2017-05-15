From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] sd: fix sysfs writes to "provisioning_mode" and "zeroing_mode"
Date: Mon, 15 May 2017 15:13:26 -0400
Message-ID: <1494875606-6298-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964967AbdEOTN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 15:13:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D07E63680B
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 19:13:27 +0000 (UTC)
Received: from emilne.csb (unknown [10.18.25.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E69A5DD6D
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 19:13:27 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Change to use strlen() of the desired string for the length
parameter to strncmp().  Otherwise one cannot simply use a
command like 'echo "writesame_16" > .../provisioning_mode'.
This patch makes sysfs writes consistent with other usage.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432..a5eacea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -402,15 +402,20 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (sdp->type != TYPE_DISK)
 		return -EINVAL;
 
-	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP], 20))
+	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP],
+		     strlen(lbp_mode[SD_LBP_UNMAP])))
 		sd_config_discard(sdkp, SD_LBP_UNMAP);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_WS16], 20))
+	else if (!strncmp(buf, lbp_mode[SD_LBP_WS16],
+			  strlen(lbp_mode[SD_LBP_WS16])))
 		sd_config_discard(sdkp, SD_LBP_WS16);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_WS10], 20))
+	else if (!strncmp(buf, lbp_mode[SD_LBP_WS10],
+			  strlen(lbp_mode[SD_LBP_WS10])))
 		sd_config_discard(sdkp, SD_LBP_WS10);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_ZERO], 20))
+	else if (!strncmp(buf, lbp_mode[SD_LBP_ZERO],
+			  strlen(lbp_mode[SD_LBP_ZERO])))
 		sd_config_discard(sdkp, SD_LBP_ZERO);
-	else if (!strncmp(buf, lbp_mode[SD_LBP_DISABLE], 20))
+	else if (!strncmp(buf, lbp_mode[SD_LBP_DISABLE],
+			  strlen(lbp_mode[SD_LBP_DISABLE])))
 		sd_config_discard(sdkp, SD_LBP_DISABLE);
 	else
 		return -EINVAL;
@@ -444,13 +449,17 @@ zeroing_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
+	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE],
+		     strlen(zeroing_mode[SD_ZERO_WRITE])))
 		sdkp->zeroing_mode = SD_ZERO_WRITE;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS],
+			  strlen(zeroing_mode[SD_ZERO_WS])))
 		sdkp->zeroing_mode = SD_ZERO_WS;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP],
+			  strlen(zeroing_mode[SD_ZERO_WS16_UNMAP])))
 		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
-	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
+	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP],
+			  strlen(zeroing_mode[SD_ZERO_WS10_UNMAP])))
 		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
 	else
 		return -EINVAL;
-- 
2.1.0
