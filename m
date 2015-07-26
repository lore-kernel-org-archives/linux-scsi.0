From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 02/52] atp870u: Remove tmport1
Date: Sun, 26 Jul 2015 22:24:09 +0200
Message-ID: <1437942299-26674-3-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56643 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbbGZU4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:56:03 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTt-0003IN-Rw
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:09 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove tmport1 temporary variable to simplify the code.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 3db9d0c..aac7d47 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -51,7 +51,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	unsigned char i, j, c, target_id, lun,cmdp;
 	unsigned char *prd;
 	struct scsi_cmnd *workreq;
-	unsigned int tmport, tmport1;
+	unsigned int tmport;
 	unsigned long adrcnt, k;
 #ifdef ED_DBGP
 	unsigned long l;
@@ -78,9 +78,8 @@ ch_sel:
 	cmdp = inb(dev->ioport[c] + 0x10);
 	if (dev->working[c] != 0) {
 		if (dev->dev_id == ATP885_DEVID) {
-			tmport1 = dev->ioport[c] + 0x16;
-			if ((inb(tmport1) & 0x80) == 0)
-				outb((inb(tmport1) | 0x80), tmport1);
+			if ((inb(dev->ioport[c] + 0x16) & 0x80) == 0)
+				outb((inb(dev->ioport[c] + 0x16) | 0x80), dev->ioport[c] + 0x16);
 		}		
 		tmpcip = dev->pciport[c];
 		if ((inb(tmpcip) & 0x08) != 0)
-- 
Ondrej Zary

