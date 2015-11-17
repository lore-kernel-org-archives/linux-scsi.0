From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 05/52] atp870u: Untangle tmport #3
Date: Tue, 17 Nov 2015 19:23:41 +0100
Message-ID: <1447784668-23713-6-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56413 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  118 ++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7112337..a23f387 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -933,38 +933,36 @@ oktosend:
 
 static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 {
-	unsigned int tmport;
 	unsigned short int i, k;
 	unsigned char j;
 
-	tmport = dev->ioport[0] + 0x1c;
-	outw(*val, tmport);
+	outw(*val, dev->ioport[0] + 0x1c);
 FUN_D7:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
-		k = inw(tmport);
+		k = inw(dev->ioport[0] + 0x1c);
 		j = (unsigned char) (k >> 8);
 		if ((k & 0x8000) != 0) {	/* DB7 all release?    */
 			goto FUN_D7;
 		}
 	}
 	*val |= 0x4000;		/* assert DB6           */
-	outw(*val, tmport);
+	outw(*val, dev->ioport[0] + 0x1c);
 	*val &= 0xdfff;		/* assert DB5           */
-	outw(*val, tmport);
+	outw(*val, dev->ioport[0] + 0x1c);
 FUN_D5:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns) */
-		if ((inw(tmport) & 0x2000) != 0) {	/* DB5 all release?       */
+		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) != 0) {	/* DB5 all release?       */
 			goto FUN_D5;
 		}
 	}
 	*val |= 0x8000;		/* no DB4-0, assert DB7    */
 	*val &= 0xe0ff;
-	outw(*val, tmport);
+	outw(*val, dev->ioport[0] + 0x1c);
 	*val &= 0xbfff;		/* release DB6             */
-	outw(*val, tmport);
+	outw(*val, dev->ioport[0] + 0x1c);
 FUN_D6:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
-		if ((inw(tmport) & 0x4000) != 0) {	/* DB6 all release?  */
+		if ((inw(dev->ioport[0] + 0x1c) & 0x4000) != 0) {	/* DB6 all release?  */
 			goto FUN_D6;
 		}
 	}
@@ -975,7 +973,6 @@ FUN_D6:
 static void tscam(struct Scsi_Host *host)
 {
 
-	unsigned int tmport;
 	unsigned char i, j, k;
 	unsigned long n;
 	unsigned short int m, assignid_map, val;
@@ -992,11 +989,9 @@ static void tscam(struct Scsi_Host *host)
 	}
  */
 
-	tmport = dev->ioport[0] + 1;
-	outb(0x08, tmport++);
-	outb(0x7f, tmport);
-	tmport = dev->ioport[0] + 0x11;
-	outb(0x20, tmport);
+	outb(0x08, dev->ioport[0] + 1);
+	outb(0x7f, dev->ioport[0] + 2);
+	outb(0x20, dev->ioport[0] + 0x11);
 
 	if ((dev->scam_on & 0x40) == 0) {
 		return;
@@ -1009,14 +1004,13 @@ static void tscam(struct Scsi_Host *host)
 		j = 8;
 	}
 	assignid_map = m;
-	tmport = dev->ioport[0] + 0x02;
-	outb(0x02, tmport++);	/* 2*2=4ms,3EH 2/32*3E=3.9ms */
-	outb(0, tmport++);
-	outb(0, tmport++);
-	outb(0, tmport++);
-	outb(0, tmport++);
-	outb(0, tmport++);
-	outb(0, tmport++);
+	outb(0x02, dev->ioport[0] + 0x02);	/* 2*2=4ms,3EH 2/32*3E=3.9ms */
+	outb(0, dev->ioport[0] + 0x03);
+	outb(0, dev->ioport[0] + 0x04);
+	outb(0, dev->ioport[0] + 0x05);
+	outb(0, dev->ioport[0] + 0x06);
+	outb(0, dev->ioport[0] + 0x07);
+	outb(0, dev->ioport[0] + 0x08);
 
 	for (i = 0; i < j; i++) {
 		m = 1;
@@ -1024,79 +1018,69 @@ static void tscam(struct Scsi_Host *host)
 		if ((m & assignid_map) != 0) {
 			continue;
 		}
-		tmport = dev->ioport[0] + 0x0f;
-		outb(0, tmport++);
-		tmport += 0x02;
-		outb(0, tmport++);
-		outb(0, tmport++);
-		outb(0, tmport++);
+		outb(0, dev->ioport[0] + 0x0f);
+		outb(0, dev->ioport[0] + 0x12);
+		outb(0, dev->ioport[0] + 0x13);
+		outb(0, dev->ioport[0] + 0x14);
 		if (i > 7) {
 			k = (i & 0x07) | 0x40;
 		} else {
 			k = i;
 		}
-		outb(k, tmport++);
-		tmport = dev->ioport[0] + 0x1b;
+		outb(k, dev->ioport[0] + 0x15);
 		if (dev->chip_ver == 4) {
-			outb(0x01, tmport);
+			outb(0x01, dev->ioport[0] + 0x1b);
 		} else {
-			outb(0x00, tmport);
+			outb(0x00, dev->ioport[0] + 0x1b);
 		}
 wait_rdyok:
-		tmport = dev->ioport[0] + 0x18;
-		outb(0x09, tmport);
-		tmport += 0x07;
+		outb(0x09, dev->ioport[0] + 0x18);
 
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		k = inb(tmport);
+		k = inb(dev->ioport[0] + 0x17);
 		if (k != 0x16) {
 			if ((k == 0x85) || (k == 0x42)) {
 				continue;
 			}
-			tmport = dev->ioport[0] + 0x10;
-			outb(0x41, tmport);
+			outb(0x41, dev->ioport[0] + 0x10);
 			goto wait_rdyok;
 		}
 		assignid_map |= m;
 
 	}
-	tmport = dev->ioport[0] + 0x02;
-	outb(0x7f, tmport);
-	tmport = dev->ioport[0] + 0x1b;
-	outb(0x02, tmport);
+	outb(0x7f, dev->ioport[0] + 0x02);
+	outb(0x02, dev->ioport[0] + 0x1b);
 
 	outb(0, 0x80);
 
 	val = 0x0080;		/* bsy  */
-	tmport = dev->ioport[0] + 0x1c;
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	val |= 0x0040;		/* sel  */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	val |= 0x0004;		/* msg  */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	inb(0x80);		/* 2 deskew delay(45ns*2=90ns) */
 	val &= 0x007f;		/* no bsy  */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	mdelay(128);
 	val &= 0x00fb;		/* after 1ms no msg */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 wait_nomsg:
-	if ((inb(tmport) & 0x04) != 0) {
+	if ((inb(dev->ioport[0] + 0x1c) & 0x04) != 0) {
 		goto wait_nomsg;
 	}
 	outb(1, 0x80);
 	udelay(100);
 	for (n = 0; n < 0x30000; n++) {
-		if ((inb(tmport) & 0x80) != 0) {	/* bsy ? */
+		if ((inb(dev->ioport[0] + 0x1c) & 0x80) != 0) {	/* bsy ? */
 			goto wait_io;
 		}
 	}
 	goto TCM_SYNC;
 wait_io:
 	for (n = 0; n < 0x30000; n++) {
-		if ((inb(tmport) & 0x81) == 0x0081) {
+		if ((inb(dev->ioport[0] + 0x1c) & 0x81) == 0x0081) {
 			goto wait_io1;
 		}
 	}
@@ -1104,10 +1088,10 @@ wait_io:
 wait_io1:
 	inb(0x80);
 	val |= 0x8003;		/* io,cd,db7  */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	inb(0x80);
 	val &= 0x00bf;		/* no sel     */
-	outw(val, tmport);
+	outw(val, dev->ioport[0] + 0x1c);
 	outb(2, 0x80);
 TCM_SYNC:
 	/*
@@ -1120,18 +1104,14 @@ TCM_SYNC:
 	 */
 	mdelay(2);
 	udelay(48);
-	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
-		outw(0, tmport--);
-		outb(0, tmport);
-		tmport = dev->ioport[0] + 0x15;
-		outb(0, tmport);
-		tmport += 0x03;
-		outb(0x09, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0)
+	if ((inb(dev->ioport[0] + 0x1c) & 0x80) == 0x00) {	/* bsy ? */
+		outw(0, dev->ioport[0] + 0x1c);
+		outb(0, dev->ioport[0] + 0x1b);
+		outb(0, dev->ioport[0] + 0x15);
+		outb(0x09, dev->ioport[0] + 0x18);
+		while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0)
 			cpu_relax();
-		tmport -= 0x08;
-		inb(tmport);
+		inb(dev->ioport[0] + 0x17);
 		return;
 	}
 	val &= 0x00ff;		/* synchronization  */
@@ -1145,7 +1125,7 @@ TCM_SYNC:
 	i = 8;
 	j = 0;
 TCM_ID:
-	if ((inw(tmport) & 0x2000) == 0) {
+	if ((inw(dev->ioport[0] + 0x1c) & 0x2000) == 0) {
 		goto TCM_ID;
 	}
 	outb(5, 0x80);
-- 
Ondrej Zary

