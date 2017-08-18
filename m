From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH] scsi: sd: remove duplicated setting of gd->minors
Date: Fri, 18 Aug 2017 14:49:30 +0800
Message-ID: <20170818064923.GA36375@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:7364 "EHLO
        BJEXCAS002.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750960AbdHRGtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 02:49:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

gd->minors has been set when call alloc_disk() in sd_probe.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36ad..c18ca7a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3223,7 +3223,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
 
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
-- 
2.9.4
