From: akpm@linux-foundation.org
Subject: [patch 10/10] scsi: fix bad use of udelay in atp870u.c
Date: Mon, 01 Dec 2008 14:32:16 -0800
Message-ID: <200812012232.mB1MWGFe019560@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYLAWdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 17:33:10 -0500
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
