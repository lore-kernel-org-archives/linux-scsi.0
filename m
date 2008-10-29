From: akpm@linux-foundation.org
Subject: [patch 14/17] scsi: fix bad use of udelay in atp870u.c
Date: Wed, 29 Oct 2008 14:24:46 -0700
Message-ID: <200810292124.m9TLOk2b021279@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYJ2VYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:24:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tbm@cyrius.com

From: Martin Michlmayr <tbm@cyrius.com>

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1
Fix this by using a combination of mdelay and udelay.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/atp870u.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/atp870u.c~scsi-fix-bad-use-of-udelay-in-atp870uc drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c~scsi-fix-bad-use-of-udelay-in-atp870uc
+++ a/drivers/scsi/atp870u.c
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
_
