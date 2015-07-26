From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 11/52] atp870u: Untangle tmpcip
Date: Sun, 26 Jul 2015 22:24:18 +0200
Message-ID: <1437942299-26674-12-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56634 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbbGZUzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:55:49 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTv-0003IN-AO
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:11 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Untangle the tmpcip crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   64 +++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 993442d..32544bb 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -47,7 +47,7 @@ static void tscam_885(void);
 static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 {
 	unsigned long flags;
-	unsigned short int tmpcip, id;
+	unsigned short int id;
 	unsigned char i, j, c, target_id, lun,cmdp;
 	unsigned char *prd;
 	struct scsi_cmnd *workreq;
@@ -79,30 +79,24 @@ ch_sel:
 			if ((inb(dev->ioport[c] + 0x16) & 0x80) == 0)
 				outb((inb(dev->ioport[c] + 0x16) | 0x80), dev->ioport[c] + 0x16);
 		}		
-		tmpcip = dev->pciport[c];
-		if ((inb(tmpcip) & 0x08) != 0)
+		if ((inb(dev->pciport[c]) & 0x08) != 0)
 		{
-			tmpcip += 0x2;
 			for (k=0; k < 1000; k++) {
-				if ((inb(tmpcip) & 0x08) == 0) {
+				if ((inb(dev->pciport[c] + 2) & 0x08) == 0) {
 					goto stop_dma;
 				}
-				if ((inb(tmpcip) & 0x01) == 0) {
+				if ((inb(dev->pciport[c] + 2) & 0x01) == 0) {
 					goto stop_dma;
 				}
 			}
 		}
 stop_dma:
-		tmpcip = dev->pciport[c];
-		outb(0x00, tmpcip);
+		outb(0x00, dev->pciport[c]);
 		
 		i = inb(dev->ioport[c] + 0x17);
 		
-		if (dev->dev_id == ATP885_DEVID) {
-			tmpcip += 2;
-			outb(0x06, tmpcip);
-			tmpcip -= 2;
-		}
+		if (dev->dev_id == ATP885_DEVID)
+			outb(0x06, dev->pciport[c] + 2);
 
 		target_id = inb(dev->ioport[c] + 0x15);
 
@@ -303,13 +297,12 @@ stop_dma:
 			
 			/* enable 32 bit fifo transfer */	
 			if (dev->dev_id == ATP885_DEVID) {
-				tmpcip = dev->pciport[c] + 1;
-				i=inb(tmpcip) & 0xf3;
+				i=inb(dev->pciport[c] + 1) & 0xf3;
 				//j=workreq->cmnd[0];	    		    	
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 				   i |= 0x0c;
 				}
-				outb(i,tmpcip);		    		    		
+				outb(i, dev->pciport[c] + 1);
 			} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    		    	   (dev->dev_id == ATP880_DEVID2) ) {
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
@@ -371,25 +364,20 @@ stop_dma:
 					}
 				}				
 			}
-			tmpcip = dev->pciport[c] + 0x04;
-			outl(dev->id[c][target_id].prdaddr, tmpcip);
+			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 0x04);
 #ifdef ED_DBGP
 			printk("dev->id[%d][%d].prdaddr 0x%8x\n", c, target_id, dev->id[c][target_id].prdaddr);
 #endif
-			if (dev->dev_id == ATP885_DEVID) {
-				tmpcip -= 0x04;
-			} else {
-				tmpcip -= 0x02;
-				outb(0x06, tmpcip);
-				outb(0x00, tmpcip);
-				tmpcip -= 0x02;
+			if (dev->dev_id != ATP885_DEVID) {
+				outb(0x06, dev->pciport[c] + 2);
+				outb(0x00, dev->pciport[c] + 2);
 			}
 			/*
 			 *	Check transfer direction
 			 */
 			if (dev->id[c][target_id].dirct != 0) {
 				outb(0x08, dev->ioport[c] + 0x18);
-				outb(0x01, tmpcip);
+				outb(0x01, dev->pciport[c]);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("status 0x80 return dirct != 0\n");
@@ -397,7 +385,7 @@ stop_dma:
 				goto handled;
 			}
 			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x09, tmpcip);
+			outb(0x09, dev->pciport[c]);
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
 			printk("status 0x80 return dirct = 0\n");
@@ -484,12 +472,9 @@ go_42:
 		}
 		i &= 0x0f;
 		if (i == 0x09) {
-			tmpcip += 4;
-			outl(dev->id[c][target_id].prdaddr, tmpcip);
-			tmpcip = tmpcip - 2;
-			outb(0x06, tmpcip);
-			outb(0x00, tmpcip);
-			tmpcip = tmpcip - 2;
+			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
+			outb(0x06, dev->pciport[c] + 2);
+			outb(0x00, dev->pciport[c] + 2);
 			outb(0x41, dev->ioport[c] + 0x10);
 			if (dev->dev_id == ATP885_DEVID) {
 				k = dev->id[c][target_id].last_len;
@@ -501,17 +486,14 @@ go_42:
 				dev->id[c][target_id].dirct = 0x00;
 			}
 			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x09, tmpcip);
+			outb(0x09, dev->pciport[c]);
 			dev->in_int[c] = 0;
 			goto handled;
 		}
 		if (i == 0x08) {
-			tmpcip += 4;
-			outl(dev->id[c][target_id].prdaddr, tmpcip);
-			tmpcip = tmpcip - 2;
-			outb(0x06, tmpcip);
-			outb(0x00, tmpcip);
-			tmpcip = tmpcip - 2;
+			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
+			outb(0x06, dev->pciport[c] + 2);
+			outb(0x00, dev->pciport[c] + 2);
 			outb(0x41, dev->ioport[c] + 0x10);
 			if (dev->dev_id == ATP885_DEVID) {		
 				k = dev->id[c][target_id].last_len;
@@ -522,7 +504,7 @@ go_42:
 			outb((unsigned char) (inb(dev->ioport[c] + 0x15) | 0x20), dev->ioport[c] + 0x15);
 			dev->id[c][target_id].dirct = 0x20;
 			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x01, tmpcip);
+			outb(0x01, dev->pciport[c]);
 			dev->in_int[c] = 0;
 			goto handled;
 		}
-- 
Ondrej Zary

