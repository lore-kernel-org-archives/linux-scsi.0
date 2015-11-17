From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 15/52] atp870u: Remove ugly gotos #3
Date: Tue, 17 Nov 2015 19:23:51 +0100
Message-ID: <1447784668-23713-16-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56505 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbbKQSga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:30 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 999bf74..b3d4e9d 100644
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

