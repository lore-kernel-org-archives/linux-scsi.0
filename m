From: akpm@linux-foundation.org
Subject: [patch 5/5] drivers/scsi/atp870u.c: fix bad use of udelay
Date: Fri, 04 May 2012 14:35:10 -0700
Message-ID: <20120504213510.DBFADA04FA@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41639 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab2EDVfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 17:35:11 -0400
Received: by yhgm50 with SMTP id m50so368794yhg.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2012 14:35:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tbm@cyrius.com, jrnieder@gmail.com, stable@vger.kernel.org

From: Martin Michlmayr <tbm@cyrius.com>
Subject: drivers/scsi/atp870u.c: fix bad use of udelay

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1

This is because udelay is defined on ARM, roughly speaking, as

	#define udelay(n) ((n) > 2000 ? __bad_udelay() : \
		__const_udelay((n) * ((2199023U*HZ)>>11)))

The argument to __const_udelay is the number of jiffies to wait divided by
4, but this does not work unless the multiplication does not overflow, and
that is what the build error is designed to prevent.  The intended
behavior can be achieved by using mdelay to call udelay multiple times in
a loop.

[jn: adding context]
Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/atp870u.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/atp870u.c~drivers-scsi-atp870uc-fix-bad-use-of-udelay drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c~drivers-scsi-atp870uc-fix-bad-use-of-udelay
+++ a/drivers/scsi/atp870u.c
@@ -1173,7 +1173,16 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	/*
+	 * The funny division into multiple delays is to accomodate
+	 * arches like ARM where udelay() multiplies its argument by
+	 * a large number to initialize a loop counter.  To avoid
+	 * overflow, the maximum supported udelay is 2000 microseconds.
+	 *
+	 * XXX it would be more polite to find a way to use msleep()
+	 */
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
_
