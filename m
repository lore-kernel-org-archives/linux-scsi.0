From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 02/52] atp870u: Remove tmport1
Date: Tue, 17 Nov 2015 19:23:38 +0100
Message-ID: <1447784668-23713-3-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56417 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

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

