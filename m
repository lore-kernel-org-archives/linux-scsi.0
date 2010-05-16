From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 1/2] SCSI: atp870u: Clean up delays
Date: Sun, 16 May 2010 03:34:01 +0100
Message-ID: <1273977241.2564.74.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab0EPCeG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2010 22:34:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Replace udelay(0x800) with mdelay(2).  udelay() is inaccurate for such
large arguments and this may result in a build-time assertion failure;
in particular it fails to build on ARM.  The conversion is not quite
accurate, but neither is the current delay.  (It was originally
implemented by calling inb(0x80) in a loop, which is even less so.)

Replace inb(0x80) with udelay(1).  Use of port 0x80 is x86-specific
and can even hang some newer x86 systems.

Remove the commented-out initial delay in tscam(), which has been
disabled throughout the 2.6.x series.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/atp870u.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index ab5bdda..80f41ef 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1047,13 +1047,6 @@ static void tscam(struct Scsi_Host *host)
 		0x38, 0x31, 0x32, 0x2b, 0x34, 0x2d, 0x2e, 0x27
 	};
 
-/*  I can't believe we need this before we've even done anything.  Remove it
- *  and see if anyone bitches.
-	for (i = 0; i < 0x10; i++) {
-		udelay(0xffff);
-	}
- */
-
 	tmport = dev->ioport[0] + 1;
 	outb(0x08, tmport++);
 	outb(0x7f, tmport);
@@ -1138,7 +1131,7 @@ wait_rdyok:
 	outw(val, tmport);
 	val |= 0x0004;		/* msg  */
 	outw(val, tmport);
-	inb(0x80);		/* 2 deskew delay(45ns*2=90ns) */
+	udelay(1);		/* 2 deskew delay(45ns*2=90ns) */
 	val &= 0x007f;		/* no bsy  */
 	outw(val, tmport);
 	mdelay(128);
@@ -1164,15 +1157,15 @@ wait_io:
 	}
 	goto TCM_SYNC;
 wait_io1:
-	inb(0x80);
+	udelay(1);
 	val |= 0x8003;		/* io,cd,db7  */
 	outw(val, tmport);
-	inb(0x80);
+	udelay(1);
 	val &= 0x00bf;		/* no sel     */
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	mdelay(2);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
-- 
1.7.1



