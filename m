From: Denis Vlasenko <vda@ilport.com.ua>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k of text
Date: Mon, 10 Apr 2006 08:49:37 +0300
Message-ID: <200604100849.37943.vda@ilport.com.ua>
References: <200604100844.12151.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xHfOE5YeiHnHSq5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 167.imtp.Ilyichevsk.Odessa.UA ([195.66.192.167]:63462 "HELO
	ilport.com.ua") by vger.kernel.org with SMTP id S1751015AbWDJFuQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 01:50:16 -0400
In-Reply-To: <200604100844.12151.vda@ilport.com.ua>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gibbs@scsiguy.com, linux-kernel@vger.kernel.org

--Boundary-00=_xHfOE5YeiHnHSq5
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 10 April 2006 08:44, Denis Vlasenko wrote:
> I also spotted two bugs in the process, patches
> for those will follow.

ahd_delay(usec) is buggy. Just think how would it work
with usec == 1024*100 + 1...

Signed-off-by: Denis Vlasenko <vda@ilport.com.ua>
--
vda

--Boundary-00=_xHfOE5YeiHnHSq5
Content-Type: text/x-diff;
  charset="koi8-r";
  name="2.6.16.aic7_42.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.16.aic7_42.patch"

Fix yet another bug

diff -urpN linux-2.6.16.aic7_2/drivers/scsi/aic7xxx/aic79xx_osm_o.c linux-2.6.16.aic7_3/drivers/scsi/aic7xxx/aic79xx_osm_o.c
--- linux-2.6.16.aic7_2/drivers/scsi/aic7xxx/aic79xx_osm_o.c	Sun Apr  9 21:53:01 2006
+++ linux-2.6.16.aic7_3/drivers/scsi/aic7xxx/aic79xx_osm_o.c	Sun Apr  9 22:25:30 2006
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
 
diff -urpN linux-2.6.16.aic7_2/drivers/scsi/aic7xxx/aic7xxx_osm_o.c linux-2.6.16.aic7_3/drivers/scsi/aic7xxx/aic7xxx_osm_o.c
--- linux-2.6.16.aic7_2/drivers/scsi/aic7xxx/aic7xxx_osm_o.c	Sun Apr  9 21:54:39 2006
+++ linux-2.6.16.aic7_3/drivers/scsi/aic7xxx/aic7xxx_osm_o.c	Sun Apr  9 22:24:59 2006
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
 

--Boundary-00=_xHfOE5YeiHnHSq5--
