From: Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH] scsi: Remove unnecessary comparison
Date: Thu, 11 Aug 2016 01:08:25 -0400
Message-ID: <20160811050825.8435-1-bobby.prani@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33608 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbcHKFI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 01:08:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

val is an unsigned int which makes the comparison >=0
unnecessary. This patch removes it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..7a919b2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -314,7 +314,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
-	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
+	if (val <= SD_DIF_TYPE3_PROTECTION)
 		sdkp->protection_type = val;
 
 	return count;
-- 
2.9.2

