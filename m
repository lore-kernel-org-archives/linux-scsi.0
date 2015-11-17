From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 12/52] atp870u: Untangle tmpcip #2
Date: Tue, 17 Nov 2015 19:23:48 +0100
Message-ID: <1447784668-23713-13-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56565 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbbKQShs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:48 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmpcip crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 32544bb..4d840a5 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -645,7 +645,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	unsigned int i;//,k;
 	unsigned char  j, target_id;
 	unsigned char *prd;
-	unsigned short int tmpcip, w;
+	unsigned short int w;
 	unsigned long l, bttl = 0;
 	unsigned long  sg_count;
 
@@ -813,7 +813,6 @@ oktosend:
 		dev->in_snd[c] = 0;
 		return;
 	}
-	tmpcip = dev->pciport[c];
 	prd = dev->id[c][target_id].prd_table;
 	dev->id[c][target_id].prd_pos = prd;
 
@@ -850,34 +849,28 @@ oktosend:
 		printk("2. bttl %x, l %x\n",bttl, l);
 #endif			
 	}
-	tmpcip += 4;
 #ifdef ED_DBGP		
-	printk("send_s870: prdaddr_2 0x%8x tmpcip %x target_id %d\n", dev->id[c][target_id].prdaddr,tmpcip,target_id);
+	printk("send_s870: prdaddr_2 0x%8x target_id %d\n", dev->id[c][target_id].prdaddr,target_id);
 #endif	
 	dev->id[c][target_id].prdaddr = dev->id[c][target_id].prd_bus;
-	outl(dev->id[c][target_id].prdaddr, tmpcip);
-	tmpcip = tmpcip - 2;
-	outb(0x06, tmpcip);
-	outb(0x00, tmpcip);
+	outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
+	outb(0x06, dev->pciport[c] + 2);
+	outb(0x00, dev->pciport[c] + 2);
 	if (dev->dev_id == ATP885_DEVID) {
-		tmpcip--;
-		j=inb(tmpcip) & 0xf3;
+		j = inb(dev->pciport[c] + 1) & 0xf3;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
 	    	(workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 	   		j |= 0x0c;
 		}
-		outb(j,tmpcip);
-		tmpcip--;	    	
+		outb(j, dev->pciport[c] + 1);
 	} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    	   (dev->dev_id == ATP880_DEVID2)) {
-		tmpcip =tmpcip -2;	
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 			outb((unsigned char) ((inb(dev->ioport[c] - 0x05) & 0x3f) | 0xc0), dev->ioport[c] - 0x05);
 		} else {
 			outb((unsigned char) (inb(dev->ioport[c] - 0x05) & 0x3f), dev->ioport[c] - 0x05);
 		}		
 	} else {		
-		tmpcip =tmpcip -2;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 			outb((inb(dev->ioport[c] + 0x3a) & 0xf3) | 0x08, dev->ioport[c] + 0x3a);
 		} else {
@@ -889,7 +882,7 @@ oktosend:
 		dev->id[c][target_id].dirct = 0x20;
 		if (inb(dev->ioport[c] + 0x1c) == 0) {
 			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x01, tmpcip);
+			outb(0x01, dev->pciport[c]);
 #ifdef ED_DBGP		
 		printk( "start DMA(to target)\n");
 #endif				
@@ -901,7 +894,7 @@ oktosend:
 	}
 	if (inb(dev->ioport[c] + 0x1c) == 0) {
 		outb(0x08, dev->ioport[c] + 0x18);
-		outb(0x09, tmpcip);
+		outb(0x09, dev->pciport[c]);
 #ifdef ED_DBGP		
 		printk( "start DMA(to host)\n");
 #endif			
-- 
Ondrej Zary

