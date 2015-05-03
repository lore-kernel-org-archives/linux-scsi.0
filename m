From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 15/34] atp870u: Remove ugly gotos #3
Date: Sun,  3 May 2015 19:31:31 +0200
Message-ID: <1430674310-11576-16-git-send-email-linux@rainbow-software.org>
References: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36056 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbbECRv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:51:59 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkL-0000Ql-O8
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:05 +0200
In-Reply-To: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 83dff58..233fcb2 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -880,34 +880,28 @@ static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 	unsigned char j;
 
 	outw(*val, dev->ioport[0] + 0x1c);
-FUN_D7:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
 		k = inw(dev->ioport[0] + 0x1c);
 		j = (unsigned char) (k >> 8);
-		if ((k & 0x8000) != 0) {	/* DB7 all release?    */
-			goto FUN_D7;
-		}
+		if ((k & 0x8000) != 0)	/* DB7 all release?    */
+			i = 0;
 	}
 	*val |= 0x4000;		/* assert DB6           */
 	outw(*val, dev->ioport[0] + 0x1c);
 	*val &= 0xdfff;		/* assert DB5           */
 	outw(*val, dev->ioport[0] + 0x1c);
-FUN_D5:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns) */
-		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) != 0) {	/* DB5 all release?       */
-			goto FUN_D5;
-		}
+		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) != 0)	/* DB5 all release?       */
+			i = 0;
 	}
 	*val |= 0x8000;		/* no DB4-0, assert DB7    */
 	*val &= 0xe0ff;
 	outw(*val, dev->ioport[0] + 0x1c);
 	*val &= 0xbfff;		/* release DB6             */
 	outw(*val, dev->ioport[0] + 0x1c);
-FUN_D6:
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
-		if ((inw(dev->ioport[0] + 0x1c) & 0x4000) != 0) {	/* DB6 all release?  */
-			goto FUN_D6;
-		}
+		if ((inw(dev->ioport[0] + 0x1c) & 0x4000) != 0)	/* DB6 all release?  */
+			i = 0;
 	}
 
 	return j;
-- 
Ondrej Zary

