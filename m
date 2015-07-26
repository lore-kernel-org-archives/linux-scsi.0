From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 16/52] atp870u: Remove ugly gotos #4
Date: Sun, 26 Jul 2015 22:24:23 +0200
Message-ID: <1437942299-26674-17-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56667 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbbGZU46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:56:58 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTw-0003IN-0v
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:12 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b3d4e9d..68afe11 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -970,19 +970,19 @@ static void tscam(struct Scsi_Host *host)
 		} else {
 			outb(0x00, dev->ioport[0] + 0x1b);
 		}
-wait_rdyok:
-		outb(0x09, dev->ioport[0] + 0x18);
-
-		while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0x00)
-			cpu_relax();
-		k = inb(dev->ioport[0] + 0x17);
-		if (k != 0x16) {
-			if ((k == 0x85) || (k == 0x42)) {
-				continue;
-			}
-			outb(0x41, dev->ioport[0] + 0x10);
-			goto wait_rdyok;
-		}
+		do {
+			outb(0x09, dev->ioport[0] + 0x18);
+
+			while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0x00)
+				cpu_relax();
+			k = inb(dev->ioport[0] + 0x17);
+			if ((k == 0x85) || (k == 0x42))
+				break;
+			if (k != 0x16)
+				outb(0x41, dev->ioport[0] + 0x10);
+		} while (k != 0x16);
+		if ((k == 0x85) || (k == 0x42))
+			continue;
 		assignid_map |= m;
 
 	}
@@ -1003,10 +1003,8 @@ wait_rdyok:
 	mdelay(128);
 	val &= 0x00fb;		/* after 1ms no msg */
 	outw(val, dev->ioport[0] + 0x1c);
-wait_nomsg:
-	if ((inb(dev->ioport[0] + 0x1c) & 0x04) != 0) {
-		goto wait_nomsg;
-	}
+	while ((inb(dev->ioport[0] + 0x1c) & 0x04) != 0)
+		;
 	outb(1, 0x80);
 	udelay(100);
 	for (n = 0; n < 0x30000; n++) {
-- 
Ondrej Zary

