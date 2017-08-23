From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 11/19] sd: Remove a useless comparison
Date: Wed, 23 Aug 2017 14:40:01 -0700
Message-ID: <20170823214009.15015-12-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57495 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHWVmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:42:33 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

This patch avoids that gcc reports the following warning when
building with W=1:

drivers/scsi/sd.c:315:10: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  if (val >= 0 && val <= T10_PI_TYPE3_PROTECTION)

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b3d7994e182..7c0f9eb5a5fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -312,7 +312,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
-	if (val >= 0 && val <= T10_PI_TYPE3_PROTECTION)
+	if (val <= T10_PI_TYPE3_PROTECTION)
 		sdkp->protection_type = val;
 
 	return count;
-- 
2.14.0
