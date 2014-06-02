From: Alain Kalker <a.c.kalker@gmail.com>
Subject: [PATCH V2] sd: Reduce log level to KERN_NOTICE for missing caching mode page
Date: Mon,  2 Jun 2014 14:10:47 +0200
Message-ID: <1401711047-8865-1-git-send-email-a.c.kalker@gmail.com>
References: <538C6528.5030504@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59521 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaFBMLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 08:11:07 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so4362100wiw.14
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 05:11:05 -0700 (PDT)
In-Reply-To: <538C6528.5030504@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alain Kalker <a.c.kalker@gmail.com>

Reduce the lernel log level to KERN_NOTICE for messages related
to a missing caching mode page.

Reasons why I think this change is justified:
- The condition is not an error; the existing workaround of assuming
  a write through cache doesn't limit functionality in any way.
- It doesn't warrant a warning either: as it is most likely
  a hardware limitation, there is little that an ordinary user can do
  about it besides replacing the affected hardware.
  Making it a warning would still break quiet boot (kernel commandline
  parameter 'quiet'), and may still trip log monitoring software
  unneccessarily, either on every boot or whenever an affected
  external device is plugged in.
- It should be a notice, for it is a normal but significant condition,
  as it may impact write performance. This would bring it on par with
  the log messages in the same function.

Signed-off-by: Alain Kalker <a.c.kalker@gmail.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..5f0f6c6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2442,7 +2442,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_NOTICE, sdkp, "No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2489,7 +2489,7 @@ defaults:
 				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_first_printk(KERN_ERR, sdkp,
+		sd_first_printk(KERN_NOTICE, sdkp,
 				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
-- 
2.0.0

