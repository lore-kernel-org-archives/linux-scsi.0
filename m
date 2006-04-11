From: akpm@osdl.org
Subject: [patch 15/15] aic7xxx: ahd_delay() fix
Date: Mon, 10 Apr 2006 23:27:26 -0700
Message-ID: <200604110728.k3B7S85f015378@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:12425 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932310AbWDKH33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:29:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, vda@ilport.com.ua


From: Denis Vlasenko <vda@ilport.com.ua>

ahd_delay() isn't delaying for as long as it should - each time around the
allegedly 1024-usec loop it actually delays for something less than that,
depending upon the value of the incoming arg.

Signed-off-by: Denis Vlasenko <vda@ilport.com.ua>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm_o.c |    6 ++++--
 drivers/scsi/aic7xxx/aic7xxx_osm_o.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm_o.c~aic7xxx-ahd_delay-fix drivers/scsi/aic7xxx/aic79xx_osm_o.c
--- devel/drivers/scsi/aic7xxx/aic79xx_osm_o.c~aic7xxx-ahd_delay-fix	2006-04-10 00:20:48.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm_o.c	2006-04-10 00:20:48.000000000 -0700
@@ -28,9 +28,11 @@ ahd_delay(long usec)
 	 * multi-millisecond waits.  Wait at most
 	 * 1024us per call.
 	 */
+	udelay(usec & 1023);
+	usec >>= 10;
 	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
+		udelay(1024);
+		usec--;
 	}
 }
 
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_o.c~aic7xxx-ahd_delay-fix drivers/scsi/aic7xxx/aic7xxx_osm_o.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm_o.c~aic7xxx-ahd_delay-fix	2006-04-10 00:20:48.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm_o.c	2006-04-10 00:20:48.000000000 -0700
@@ -14,9 +14,11 @@ ahc_delay(long usec)
 	 * multi-millisecond waits.  Wait at most
 	 * 1024us per call.
 	 */
+	udelay(usec & 1023);
+	usec >>= 10;
 	while (usec > 0) {
-		udelay(usec % 1024);
-		usec -= 1024;
+		udelay(1024);
+		usec--;
 	}
 }
 
_
