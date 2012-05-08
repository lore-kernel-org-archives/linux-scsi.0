From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 1/3] scsi: downgrade "write through" error to notice
Date: Tue, 08 May 2012 12:20:35 +0200
Message-ID: <1336472435.1933.54.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For some reason all USB memory sticks I happen to have trigger an
    Assuming drive cache: write through

error when inserted into a USB port. But if one looks at the code
paths that trigger this error one notices that in most cases either:
- write through is explicitly requested (via the usb-storage
  NO_WP_DETECT flag);
- preceded by a previous error; or
- preceded by an ordinary notice.

So it seems this error can be safely downgraded to a notice.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ba5c2a..a887491 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2258,7 +2258,7 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
 
 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+	sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache: write through\n");
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
-- 
1.7.7.6
