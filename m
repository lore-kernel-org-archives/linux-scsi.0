From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 2/2] SCSI: atp870u: Remove debug writes to port 0x80
Date: Sun, 16 May 2010 03:34:59 +0100
Message-ID: <1273977299.2564.75.camel@localhost>
References: <1273977241.2564.74.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34446 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab0EPCfD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2010 22:35:03 -0400
In-Reply-To: <1273977241.2564.74.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Use of port 0x80 is x86-specific and can even hang some newer x86 
systems.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/atp870u.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 80f41ef..dcefd8b 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1122,8 +1122,6 @@ wait_rdyok:
 	tmport = dev->ioport[0] + 0x1b;
 	outb(0x02, tmport);
 
-	outb(0, 0x80);
-
 	val = 0x0080;		/* bsy  */
 	tmport = dev->ioport[0] + 0x1c;
 	outw(val, tmport);
@@ -1141,7 +1139,6 @@ wait_nomsg:
 	if ((inb(tmport) & 0x04) != 0) {
 		goto wait_nomsg;
 	}
-	outb(1, 0x80);
 	udelay(100);
 	for (n = 0; n < 0x30000; n++) {
 		if ((inb(tmport) & 0x80) != 0) {	/* bsy ? */
@@ -1163,7 +1160,6 @@ wait_io1:
 	udelay(1);
 	val &= 0x00bf;		/* no sel     */
 	outw(val, tmport);
-	outb(2, 0x80);
 TCM_SYNC:
 	mdelay(2);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
@@ -1183,18 +1179,15 @@ TCM_SYNC:
 	val &= 0x00ff;		/* synchronization  */
 	val |= 0x3f00;
 	fun_scam(dev, &val);
-	outb(3, 0x80);
 	val &= 0x00ff;		/* isolation        */
 	val |= 0x2000;
 	fun_scam(dev, &val);
-	outb(4, 0x80);
 	i = 8;
 	j = 0;
 TCM_ID:
 	if ((inw(tmport) & 0x2000) == 0) {
 		goto TCM_ID;
 	}
-	outb(5, 0x80);
 	val &= 0x00ff;		/* get ID_STRING */
 	val |= 0x2000;
 	k = fun_scam(dev, &val);
-- 
1.7.1


