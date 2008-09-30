From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] scsi: Fix bad use of udelay in atp870u.c
Date: Tue, 30 Sep 2008 10:39:04 +0300
Message-ID: <20080930073904.GA24339@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2716 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYI3Hj1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 03:39:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1
Fix this by using a combination of mdelay and udelay.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1171,7 +1171,8 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);

-- 
Martin Michlmayr
http://www.cyrius.com/
