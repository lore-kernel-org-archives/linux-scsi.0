From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] scsi: aic7xxx: fix ahc_delay and ahd_delay
Date: Fri, 14 Oct 2016 16:20:00 +0200
Message-ID: <20161014142000.18833-1-dvlasenk@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754307AbcJNOUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 10:20:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

They are buggy:

        while (usec > 0)
               udelay(usec % 1024);
               usec -= 1024;

For example, for usec = 100*1024 + 1, old code will udelay(1) 101 times,
i.e. it will be approximately equivalent to udelay(101),
not the expected udelay(102400).

This did not bite because all callers use values far from "pathological" ones,
such as 500 and 1000 - these work fine with buggy code.

This was reported in 2006 but was missed.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: James Bottomley <JBottomley@Parallels.com>
CC: Hannes Reinicke <hare@suse.de>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 7 ++++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2588b8f..e7a7838 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -380,9 +380,10 @@ ahd_delay(long usec)
 	 * multi-millisecond waits.  Wait at most
 	 * 1024us per call.
 	 */
-	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
+	udelay(usec & 1023);
+	usec >>= 10;
+	while (--usec >= 0) {
+		udelay(1024);
 	}
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fc6a831..c81798e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -388,9 +388,10 @@ ahc_delay(long usec)
 	 * multi-millisecond waits.  Wait at most
 	 * 1024us per call.
 	 */
-	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
+	udelay(usec & 1023);
+	usec >>= 10;
+	while (--usec >= 0) {
+		udelay(1024);
 	}
 }
 
-- 
2.9.2

