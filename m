From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 01/52] atp870u: Remove workport
Date: Tue, 17 Nov 2015 19:23:37 +0100
Message-ID: <1447784668-23713-2-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56410 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Remove workport temporary variable to simplify the code.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   59 +++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 05301bc..3db9d0c 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -51,7 +51,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	unsigned char i, j, c, target_id, lun,cmdp;
 	unsigned char *prd;
 	struct scsi_cmnd *workreq;
-	unsigned int workport, tmport, tmport1;
+	unsigned int tmport, tmport1;
 	unsigned long adrcnt, k;
 #ifdef ED_DBGP
 	unsigned long l;
@@ -76,10 +76,9 @@ ch_sel:
 #endif	
 	dev->in_int[c] = 1;
 	cmdp = inb(dev->ioport[c] + 0x10);
-	workport = dev->ioport[c];
 	if (dev->working[c] != 0) {
 		if (dev->dev_id == ATP885_DEVID) {
-			tmport1 = workport + 0x16;
+			tmport1 = dev->ioport[c] + 0x16;
 			if ((inb(tmport1) & 0x80) == 0)
 				outb((inb(tmport1) | 0x80), tmport1);
 		}		
@@ -160,7 +159,7 @@ stop_dma:
 			 *      Flip wide
 			 */			
 			if (dev->wide_id[c] != 0) {
-				tmport = workport + 0x1b;
+				tmport = dev->ioport[c] + 0x1b;
 				outb(0x01, tmport);
 				while ((inb(tmport) & 0x01) != 0x01) {
 					outb(0x01, tmport);
@@ -276,9 +275,9 @@ stop_dma:
 			if (dev->dev_id == ATP885_DEVID) {
 				j = inb(dev->baseport + 0x29) & 0xfe;
 				outb(j, dev->baseport + 0x29);
-				tmport = workport + 0x16;
+				tmport = dev->ioport[c] + 0x16;
 			} else {
-				tmport = workport + 0x10;
+				tmport = dev->ioport[c] + 0x10;
 				outb(0x45, tmport);
 				tmport += 0x06;				
 			}
@@ -293,7 +292,7 @@ stop_dma:
 				target_id &= 0x07;
 			}
 			if (dev->dev_id == ATP885_DEVID) {
-				tmport = workport + 0x10;
+				tmport = dev->ioport[c] + 0x10;
 				outb(0x45, tmport);
 			}
 			workreq = dev->id[c][target_id].curr_req;
@@ -304,7 +303,7 @@ stop_dma:
 			printk("\n");
 #endif	
 			
-			tmport = workport + 0x0f;
+			tmport = dev->ioport[c] + 0x0f;
 			outb(lun, tmport);
 			tmport += 0x02;
 			outb(dev->id[c][target_id].devsp, tmport++);
@@ -338,21 +337,21 @@ stop_dma:
 				outb(i,tmpcip);		    		    		
 			} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    		    	   (dev->dev_id == ATP880_DEVID2) ) {
-				tmport = workport - 0x05;
+				tmport = dev->ioport[c] - 0x05;
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 					outb((unsigned char) ((inb(tmport) & 0x3f) | 0xc0), tmport);
 				} else {
 					outb((unsigned char) (inb(tmport) & 0x3f), tmport);
 				}
 			} else {				
-				tmport = workport + 0x3a;
+				tmport = dev->ioport[c] + 0x3a;
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 					outb((unsigned char) ((inb(tmport) & 0xf3) | 0x08), tmport);
 				} else {
 					outb((unsigned char) (inb(tmport) & 0xf3), tmport);
 				}														
 			}	
-			tmport = workport + 0x1b;
+			tmport = dev->ioport[c] + 0x1b;
 			j = 0;
 			id = 1;
 			id = id << target_id;
@@ -367,7 +366,7 @@ stop_dma:
 				outb(j,tmport);
 			}
 			if (dev->id[c][target_id].last_len == 0) {
-				tmport = workport + 0x18;
+				tmport = dev->ioport[c] + 0x18;
 				outb(0x08, tmport);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
@@ -414,7 +413,7 @@ stop_dma:
 				outb(0x00, tmpcip);
 				tmpcip -= 0x02;
 			}
-			tmport = workport + 0x18;
+			tmport = dev->ioport[c] + 0x18;
 			/*
 			 *	Check transfer direction
 			 */
@@ -488,7 +487,7 @@ go_42:
 			 *      Take it back wide
 			 */
 			if (dev->wide_id[c] != 0) {
-				tmport = workport + 0x1b;
+				tmport = dev->ioport[c] + 0x1b;
 				outb(0x01, tmport);
 				while ((inb(tmport) & 0x01) != 0x01) {
 					outb(0x01, tmport);
@@ -523,7 +522,7 @@ go_42:
 			outb(0x06, tmpcip);
 			outb(0x00, tmpcip);
 			tmpcip = tmpcip - 2;
-			tmport = workport + 0x10;
+			tmport = dev->ioport[c] + 0x10;
 			outb(0x41, tmport);
 			if (dev->dev_id == ATP885_DEVID) {
 				tmport += 2;
@@ -549,7 +548,7 @@ go_42:
 			outb(0x06, tmpcip);
 			outb(0x00, tmpcip);
 			tmpcip = tmpcip - 2;
-			tmport = workport + 0x10;
+			tmport = dev->ioport[c] + 0x10;
 			outb(0x41, tmport);
 			if (dev->dev_id == ATP885_DEVID) {		
 				tmport += 2;
@@ -584,7 +583,7 @@ go_42:
 		dev->in_int[c] = 0;
 		goto handled;
 	} else {
-//		tmport = workport + 0x17;
+//		tmport = dev->ioport[c] + 0x17;
 //		inb(tmport);
 //		dev->working[c] = 0;
 		dev->in_int[c] = 0;
@@ -713,7 +712,6 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	unsigned char *prd;
 	unsigned short int tmpcip, w;
 	unsigned long l, bttl = 0;
-	unsigned int workport;
 	unsigned long  sg_count;
 
 	if (dev->in_snd[c] != 0) {
@@ -759,12 +757,11 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	dev->in_snd[c] = 0;
 	return;
 cmd_subp:
-	workport = dev->ioport[c];
-	tmport = workport + 0x1f;
+	tmport = dev->ioport[c] + 0x1f;
 	if ((inb(tmport) & 0xb0) != 0) {
 		goto abortsnd;
 	}
-	tmport = workport + 0x1c;
+	tmport = dev->ioport[c] + 0x1c;
 	if (inb(tmport) == 0) {
 		goto oktosend;
 	}
@@ -800,7 +797,7 @@ oktosend:
 		l = 0;
 	}
 
-	tmport = workport + 0x1b;
+	tmport = dev->ioport[c] + 0x1b;
 	j = 0;
 	target_id = scmd_id(workreq);
 
@@ -823,7 +820,7 @@ oktosend:
 	 *	Write the command
 	 */
 
-	tmport = workport;
+	tmport = dev->ioport[c];
 	outb(workreq->cmd_len, tmport++);
 	outb(0x2c, tmport++);
 	if (dev->dev_id == ATP885_DEVID) {
@@ -834,7 +831,7 @@ oktosend:
 	for (i = 0; i < workreq->cmd_len; i++) {
 		outb(workreq->cmnd[i], tmport++);
 	}
-	tmport = workport + 0x0f;
+	tmport = dev->ioport[c] + 0x0f;
 	outb(workreq->device->lun, tmport);
 	tmport += 0x02;
 	/*
@@ -874,11 +871,11 @@ oktosend:
 	}
 	outb((unsigned char) (inb(tmport) | 0x80), tmport);
 	outb(0x80, tmport);
-	tmport = workport + 0x1c;
+	tmport = dev->ioport[c] + 0x1c;
 	dev->id[c][target_id].dirct = 0;
 	if (l == 0) {
 		if (inb(tmport) == 0) {
-			tmport = workport + 0x18;
+			tmport = dev->ioport[c] + 0x18;
 #ifdef ED_DBGP
 			printk("change SCSI_CMD_REG 0x08\n");	
 #endif				
@@ -947,7 +944,7 @@ oktosend:
 	} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    	   (dev->dev_id == ATP880_DEVID2)) {
 		tmpcip =tmpcip -2;	
-		tmport = workport - 0x05;
+		tmport = dev->ioport[c] - 0x05;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 			outb((unsigned char) ((inb(tmport) & 0x3f) | 0xc0), tmport);
 		} else {
@@ -955,19 +952,19 @@ oktosend:
 		}		
 	} else {		
 		tmpcip =tmpcip -2;
-		tmport = workport + 0x3a;
+		tmport = dev->ioport[c] + 0x3a;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 			outb((inb(tmport) & 0xf3) | 0x08, tmport);
 		} else {
 			outb(inb(tmport) & 0xf3, tmport);
 		}		
 	}	
-	tmport = workport + 0x1c;
+	tmport = dev->ioport[c] + 0x1c;
 
 	if(workreq->sc_data_direction == DMA_TO_DEVICE) {
 		dev->id[c][target_id].dirct = 0x20;
 		if (inb(tmport) == 0) {
-			tmport = workport + 0x18;
+			tmport = dev->ioport[c] + 0x18;
 			outb(0x08, tmport);
 			outb(0x01, tmpcip);
 #ifdef ED_DBGP		
@@ -980,7 +977,7 @@ oktosend:
 		return;
 	}
 	if (inb(tmport) == 0) {		
-		tmport = workport + 0x18;
+		tmport = dev->ioport[c] + 0x18;
 		outb(0x08, tmport);
 		outb(0x09, tmpcip);
 #ifdef ED_DBGP		
-- 
Ondrej Zary

