From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 17/34] atp870u: Remove ugly gotos #5
Date: Sun,  3 May 2015 19:31:33 +0200
Message-ID: <1430674310-11576-18-git-send-email-linux@rainbow-software.org>
References: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36054 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbbECRv4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:51:56 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkM-0000Ql-8e
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:06 +0200
In-Reply-To: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  134 ++++++++++++++++++++++--------------------------
 1 file changed, 62 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 91644e9..1eeaaf8 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1007,28 +1007,22 @@ static void tscam(struct Scsi_Host *host)
 		;
 	outb(1, 0x80);
 	udelay(100);
-	for (n = 0; n < 0x30000; n++) {
-		if ((inb(dev->ioport[0] + 0x1c) & 0x80) != 0) {	/* bsy ? */
-			goto wait_io;
-		}
-	}
-	goto TCM_SYNC;
-wait_io:
-	for (n = 0; n < 0x30000; n++) {
-		if ((inb(dev->ioport[0] + 0x1c) & 0x81) == 0x0081) {
-			goto wait_io1;
-		}
-	}
-	goto TCM_SYNC;
-wait_io1:
-	inb(0x80);
-	val |= 0x8003;		/* io,cd,db7  */
-	outw(val, dev->ioport[0] + 0x1c);
-	inb(0x80);
-	val &= 0x00bf;		/* no sel     */
-	outw(val, dev->ioport[0] + 0x1c);
-	outb(2, 0x80);
-TCM_SYNC:
+	for (n = 0; n < 0x30000; n++)
+		if ((inb(dev->ioport[0] + 0x1c) & 0x80) != 0)	/* bsy ? */
+			break;
+	if (n < 0x30000)
+		for (n = 0; n < 0x30000; n++)
+			if ((inb(dev->ioport[0] + 0x1c) & 0x81) == 0x0081) {
+				inb(0x80);
+				val |= 0x8003;		/* io,cd,db7  */
+				outw(val, dev->ioport[0] + 0x1c);
+				inb(0x80);
+				val &= 0x00bf;		/* no sel     */
+				outw(val, dev->ioport[0] + 0x1c);
+				outb(2, 0x80);
+				break;
+			}
+	while (1) {
 	/*
 	 * The funny division into multiple delays is to accomodate
 	 * arches like ARM where udelay() multiplies its argument by
@@ -1059,31 +1053,28 @@ TCM_SYNC:
 	outb(4, 0x80);
 	i = 8;
 	j = 0;
-TCM_ID:
-	if ((inw(dev->ioport[0] + 0x1c) & 0x2000) == 0) {
-		goto TCM_ID;
-	}
-	outb(5, 0x80);
-	val &= 0x00ff;		/* get ID_STRING */
-	val |= 0x2000;
-	k = fun_scam(dev, &val);
-	if ((k & 0x03) == 0) {
-		goto TCM_5;
-	}
-	mbuf[j] <<= 0x01;
-	mbuf[j] &= 0xfe;
-	if ((k & 0x02) != 0) {
-		mbuf[j] |= 0x01;
-	}
-	i--;
-	if (i > 0) {
-		goto TCM_ID;
+
+	while (1) {
+		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) == 0)
+			continue;
+		outb(5, 0x80);
+		val &= 0x00ff;		/* get ID_STRING */
+		val |= 0x2000;
+		k = fun_scam(dev, &val);
+		if ((k & 0x03) == 0)
+			break;
+		mbuf[j] <<= 0x01;
+		mbuf[j] &= 0xfe;
+		if ((k & 0x02) != 0)
+			mbuf[j] |= 0x01;
+		i--;
+		if (i > 0)
+			continue;
+		j++;
+		i = 8;
 	}
-	j++;
-	i = 8;
-	goto TCM_ID;
 
-TCM_5:			/* isolation complete..  */
+	/* isolation complete..  */
 /*    mbuf[32]=0;
 	printk(" \n%x %x %x %s\n ",assignid_map,mbuf[0],mbuf[1],&mbuf[2]); */
 	i = 15;
@@ -1091,33 +1082,33 @@ TCM_5:			/* isolation complete..  */
 	if ((j & 0x20) != 0) {	/* bit5=1:ID up to 7      */
 		i = 7;
 	}
-	if ((j & 0x06) == 0) {	/* IDvalid?             */
-		goto G2Q5;
-	}
-	k = mbuf[1];
-small_id:
-	m = 1;
-	m <<= k;
-	if ((m & assignid_map) == 0) {
-		goto G2Q_QUIN;
-	}
-	if (k > 0) {
-		k--;
-		goto small_id;
-	}
-G2Q5:			/* srch from max acceptable ID#  */
-	k = i;			/* max acceptable ID#            */
-G2Q_LP:
-	m = 1;
-	m <<= k;
-	if ((m & assignid_map) == 0) {
-		goto G2Q_QUIN;
+	if ((j & 0x06) != 0) {	/* IDvalid?             */
+		k = mbuf[1];
+		while (1) {
+			m = 1;
+			m <<= k;
+			if ((m & assignid_map) == 0)
+				break;
+			if (k > 0)
+				k--;
+			else
+				break;
+		}
 	}
-	if (k > 0) {
-		k--;
-		goto G2Q_LP;
+	if ((m & assignid_map) != 0) {	/* srch from max acceptable ID#  */
+		k = i;			/* max acceptable ID#            */
+		while (1) {
+			m = 1;
+			m <<= k;
+			if ((m & assignid_map) == 0)
+				break;
+			if (k > 0)
+				k--;
+			else
+				break;
+		}
 	}
-G2Q_QUIN:		/* k=binID#,       */
+	/* k=binID#,       */
 	assignid_map |= m;
 	if (k < 8) {
 		quintet[0] = 0x38;	/* 1st dft ID<8    */
@@ -1136,8 +1127,7 @@ G2Q_QUIN:		/* k=binID#,       */
 	val |= m;
 	fun_scam(dev, &val);
 
-	goto TCM_SYNC;
-
+	}
 }
 
 static void is870(struct atp_unit *dev, unsigned int wkport)
-- 
Ondrej Zary

