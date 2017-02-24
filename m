From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: remove redundant zero check on ret
Date: Fri, 24 Feb 2017 14:43:30 +0000
Message-ID: <20170224144330.6707-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38696 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdBXOoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2017 09:44:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check for ret being zero is redundant as a few statements earlier
we break out of the while loop if ret is non-zero.  Thus we can
remove the zero check and also the dead-code non-zero case too.

Detected by CoverityScan, CID#1411632 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/commsup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1994c74..a3ad042 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2508,8 +2508,7 @@ int aac_command_thread(void *data)
 			 && (now.tv_usec > (1000000 / HZ)))
 				difference = (((1000000 - now.tv_usec) * HZ)
 				  + 500000) / 1000000;
-			else if (ret == 0) {
-
+			else {
 				if (now.tv_usec > 500000)
 					++now.tv_sec;
 
@@ -2520,9 +2519,6 @@ int aac_command_thread(void *data)
 					ret = aac_send_hosttime(dev, &now);
 
 				difference = (long)(unsigned)update_interval*HZ;
-			} else {
-				/* retry shortly */
-				difference = 10 * HZ;
 			}
 			next_jiffies = jiffies + difference;
 			if (time_before(next_check_jiffies,next_jiffies))
-- 
2.10.2
