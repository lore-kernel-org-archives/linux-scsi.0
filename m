From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] atp870u: Split long udelay()
Date: Fri, 19 Feb 2010 01:56:59 +0000
Message-ID: <1266544619.10567.715.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145Ab0BSB5E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 20:57:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

udelay() is supposed to be limited to 1 ms, and will generate a
__bad_udelay() on ARM for constant arguments > 2000.  Split
udelay(0x800) into mdelay(2); udelay(48).  (I suspect that msleep(3)
would work but I do not know how critical the timing is here.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/atp870u.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b137e56..bf0ecda 100644
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
1.6.6.2


