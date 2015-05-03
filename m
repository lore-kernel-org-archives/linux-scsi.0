From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 32/34] atp870u: Replace port 0x80 delay by udelay
Date: Sun,  3 May 2015 19:31:48 +0200
Message-ID: <1430674310-11576-33-git-send-email-linux@rainbow-software.org>
References: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36063 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbbECRwM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:52:12 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkP-0000Ql-9N
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:09 +0200
In-Reply-To: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

tscam() is using port 0x80 access for delays but that's x86-only.
Use udelay(2) instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 6ff8910..53c04f4 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1036,7 +1036,7 @@ static void tscam(struct Scsi_Host *host)
 	atp_writeb_io(dev, 0, 0x02, 0x7f);
 	atp_writeb_io(dev, 0, 0x1b, 0x02);
 
-	outb(0, 0x80);
+	udelay(2);
 
 	val = 0x0080;		/* bsy  */
 	atp_writew_io(dev, 0, 0x1c, val);
@@ -1044,7 +1044,7 @@ static void tscam(struct Scsi_Host *host)
 	atp_writew_io(dev, 0, 0x1c, val);
 	val |= 0x0004;		/* msg  */
 	atp_writew_io(dev, 0, 0x1c, val);
-	inb(0x80);		/* 2 deskew delay(45ns*2=90ns) */
+	udelay(2);		/* 2 deskew delay(45ns*2=90ns) */
 	val &= 0x007f;		/* no bsy  */
 	atp_writew_io(dev, 0, 0x1c, val);
 	mdelay(128);
@@ -1052,7 +1052,7 @@ static void tscam(struct Scsi_Host *host)
 	atp_writew_io(dev, 0, 0x1c, val);
 	while ((atp_readb_io(dev, 0, 0x1c) & 0x04) != 0)
 		;
-	outb(1, 0x80);
+	udelay(2);
 	udelay(100);
 	for (n = 0; n < 0x30000; n++)
 		if ((atp_readb_io(dev, 0, 0x1c) & 0x80) != 0)	/* bsy ? */
@@ -1060,13 +1060,13 @@ static void tscam(struct Scsi_Host *host)
 	if (n < 0x30000)
 		for (n = 0; n < 0x30000; n++)
 			if ((atp_readb_io(dev, 0, 0x1c) & 0x81) == 0x0081) {
-				inb(0x80);
+				udelay(2);
 				val |= 0x8003;		/* io,cd,db7  */
 				atp_writew_io(dev, 0, 0x1c, val);
-				inb(0x80);
+				udelay(2);
 				val &= 0x00bf;		/* no sel     */
 				atp_writew_io(dev, 0, 0x1c, val);
-				outb(2, 0x80);
+				udelay(2);
 				break;
 			}
 	while (1) {
@@ -1093,18 +1093,18 @@ static void tscam(struct Scsi_Host *host)
 	val &= 0x00ff;		/* synchronization  */
 	val |= 0x3f00;
 	fun_scam(dev, &val);
-	outb(3, 0x80);
+	udelay(2);
 	val &= 0x00ff;		/* isolation        */
 	val |= 0x2000;
 	fun_scam(dev, &val);
-	outb(4, 0x80);
+	udelay(2);
 	i = 8;
 	j = 0;
 
 	while (1) {
 		if ((atp_readw_io(dev, 0, 0x1c) & 0x2000) == 0)
 			continue;
-		outb(5, 0x80);
+		udelay(2);
 		val &= 0x00ff;		/* get ID_STRING */
 		val |= 0x2000;
 		k = fun_scam(dev, &val);
-- 
Ondrej Zary

