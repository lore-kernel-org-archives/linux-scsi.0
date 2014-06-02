From: Alain Kalker <a.c.kalker@gmail.com>
Subject: [PATCH] sd: Reduce log level to KERN_NOTICE for missing caching mode page
Date: Mon,  2 Jun 2014 12:46:46 +0200
Message-ID: <1401706006-7914-1-git-send-email-a.c.kalker@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49146 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBKq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 06:46:59 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so4822166wes.22
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 03:46:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alain Kalker <a.c.kalker@gmail.com>

Reduce the lernel log level to KERN_NOTICE for messages related
to a missing caching mode page.

Reasons why I think this change is justified:
- The condition is non-fatal; the existing workaround assumes
  a write through cache. Although this reduces write performance,
  it doesn't limit functionality in any way.
- The current log level suggests that immediate action is
  required, however, as it is a hardware limitation, there is
  nothing much the user can do about it besides replacing the
  affected hardware.
- The current situation breaks quiet boot (kernel commandline
  parameter 'quiet'), and may trip log monitoring software
  unneccessarily, either on every boot or whenever an affected
  external device is plugged in.

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

