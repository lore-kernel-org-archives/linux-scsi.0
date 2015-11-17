From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 03/52] atp870u: Untangle tmport
Date: Tue, 17 Nov 2015 19:23:39 +0100
Message-ID: <1447784668-23713-4-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56409 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  186 ++++++++++++++++++------------------------------
 1 file changed, 71 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index aac7d47..a25a300 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -51,7 +51,6 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	unsigned char i, j, c, target_id, lun,cmdp;
 	unsigned char *prd;
 	struct scsi_cmnd *workreq;
-	unsigned int tmport;
 	unsigned long adrcnt, k;
 #ifdef ED_DBGP
 	unsigned long l;
@@ -61,8 +60,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	struct atp_unit *dev = (struct atp_unit *)&host->hostdata;
 
 	for (c = 0; c < 2; c++) {
-		tmport = dev->ioport[c] + 0x1f;
-		j = inb(tmport);
+		j = inb(dev->ioport[c] + 0x1f);
 		if ((j & 0x80) != 0)
 		{			
 	   		goto ch_sel;
@@ -97,9 +95,8 @@ ch_sel:
 stop_dma:
 		tmpcip = dev->pciport[c];
 		outb(0x00, tmpcip);
-		tmport -= 0x08;
 		
-		i = inb(tmport);
+		i = inb(dev->ioport[c] + 0x17);
 		
 		if (dev->dev_id == ATP885_DEVID) {
 			tmpcip += 2;
@@ -107,9 +104,7 @@ stop_dma:
 			tmpcip -= 2;
 		}
 
-		tmport -= 0x02;
-		target_id = inb(tmport);
-		tmport += 0x02;
+		target_id = inb(dev->ioport[c] + 0x15);
 
 		/*
 		 *	Remap wide devices onto id numbers
@@ -137,11 +132,10 @@ stop_dma:
 			   dev->last_cmd[c] = 0xff;
 			}
 			if (dev->dev_id == ATP885_DEVID) {
-				tmport -= 0x05;
 				adrcnt = 0;
-				((unsigned char *) &adrcnt)[2] = inb(tmport++);
-				((unsigned char *) &adrcnt)[1] = inb(tmport++);
-				((unsigned char *) &adrcnt)[0] = inb(tmport);
+				((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
+				((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
+				((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
 				if (dev->id[c][target_id].last_len != adrcnt)
 				{
 			   		k = dev->id[c][target_id].last_len;
@@ -150,7 +144,7 @@ stop_dma:
 			   	dev->id[c][target_id].last_len = adrcnt;			   
 				}
 #ifdef ED_DBGP
-				printk("tmport = %x dev->id[c][target_id].last_len = %d dev->id[c][target_id].tran_len = %d\n",tmport,dev->id[c][target_id].last_len,dev->id[c][target_id].tran_len);
+				printk("dev->id[c][target_id].last_len = %d dev->id[c][target_id].tran_len = %d\n",dev->id[c][target_id].last_len,dev->id[c][target_id].tran_len);
 #endif		
 			}
 
@@ -158,10 +152,9 @@ stop_dma:
 			 *      Flip wide
 			 */			
 			if (dev->wide_id[c] != 0) {
-				tmport = dev->ioport[c] + 0x1b;
-				outb(0x01, tmport);
-				while ((inb(tmport) & 0x01) != 0x01) {
-					outb(0x01, tmport);
+				outb(0x01, dev->ioport[c] + 0x1b);
+				while ((inb(dev->ioport[c] + 0x1b) & 0x01) != 0x01) {
+					outb(0x01, dev->ioport[c] + 0x1b);
 				}
 			}		
 			/*
@@ -196,19 +189,16 @@ stop_dma:
 			if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 			   dev->last_cmd[c] = 0xff;
 			}
-			tmport -= 0x05;
 			adrcnt = 0;
-			((unsigned char *) &adrcnt)[2] = inb(tmport++);
-			((unsigned char *) &adrcnt)[1] = inb(tmport++);
-			((unsigned char *) &adrcnt)[0] = inb(tmport);
+			((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
+			((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
+			((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
 			k = dev->id[c][target_id].last_len;
 			k -= adrcnt;
 			dev->id[c][target_id].tran_len = k;
 			dev->id[c][target_id].last_len = adrcnt;
-			tmport -= 0x04;
-			outb(0x41, tmport);
-			tmport += 0x08;
-			outb(0x08, tmport);
+			outb(0x41, dev->ioport[c] + 0x10);
+			outb(0x08, dev->ioport[c] + 0x18);
 			dev->in_int[c] = 0;
 			goto handled;
 		}
@@ -227,10 +217,8 @@ stop_dma:
 			printk(KERN_DEBUG "Device reselect\n");
 #endif			
 			lun = 0;
-			tmport -= 0x07;
 			if (cmdp == 0x44 || i==0x80) {
-				tmport += 0x0d;
-				lun = inb(tmport) & 0x07;
+				lun = inb(dev->ioport[c] + 0x1d) & 0x07;
 			} else {
 				if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 				   dev->last_cmd[c] = 0xff;
@@ -239,31 +227,27 @@ stop_dma:
 #ifdef ED_DBGP
 					printk("cmdp = 0x41\n");
 #endif						
-					tmport += 0x02;
 					adrcnt = 0;
-					((unsigned char *) &adrcnt)[2] = inb(tmport++);
-					((unsigned char *) &adrcnt)[1] = inb(tmport++);
-					((unsigned char *) &adrcnt)[0] = inb(tmport);
+					((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
+					((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
+					((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
 					k = dev->id[c][target_id].last_len;
 					k -= adrcnt;
 					dev->id[c][target_id].tran_len = k;
 					dev->id[c][target_id].last_len = adrcnt;
-					tmport += 0x04;
-					outb(0x08, tmport);
+					outb(0x08, dev->ioport[c] + 0x18);
 					dev->in_int[c] = 0;
 					goto handled;
 				} else {
 #ifdef ED_DBGP
 					printk("cmdp != 0x41\n");
 #endif						
-					outb(0x46, tmport);
+					outb(0x46, dev->ioport[c] + 0x10);
 					dev->id[c][target_id].dirct = 0x00;
-					tmport += 0x02;
-					outb(0x00, tmport++);
-					outb(0x00, tmport++);
-					outb(0x00, tmport++);
-					tmport += 0x03;
-					outb(0x08, tmport);
+					outb(0x00, dev->ioport[c] + 0x12);
+					outb(0x00, dev->ioport[c] + 0x13);
+					outb(0x00, dev->ioport[c] + 0x14);
+					outb(0x08, dev->ioport[c] + 0x18);
 					dev->in_int[c] = 0;
 					goto handled;
 				}
@@ -274,14 +258,10 @@ stop_dma:
 			if (dev->dev_id == ATP885_DEVID) {
 				j = inb(dev->baseport + 0x29) & 0xfe;
 				outb(j, dev->baseport + 0x29);
-				tmport = dev->ioport[c] + 0x16;
-			} else {
-				tmport = dev->ioport[c] + 0x10;
-				outb(0x45, tmport);
-				tmport += 0x06;				
-			}
-			
-			target_id = inb(tmport);
+			} else
+				outb(0x45, dev->ioport[c] + 0x10);
+
+			target_id = inb(dev->ioport[c] + 0x16);
 			/*
 			 *	Remap wide identifiers
 			 */
@@ -290,10 +270,8 @@ stop_dma:
 			} else {
 				target_id &= 0x07;
 			}
-			if (dev->dev_id == ATP885_DEVID) {
-				tmport = dev->ioport[c] + 0x10;
-				outb(0x45, tmport);
-			}
+			if (dev->dev_id == ATP885_DEVID)
+				outb(0x45, dev->ioport[c] + 0x10);
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
 			scmd_printk(KERN_DEBUG, workreq, "CDB");
@@ -302,18 +280,16 @@ stop_dma:
 			printk("\n");
 #endif	
 			
-			tmport = dev->ioport[c] + 0x0f;
-			outb(lun, tmport);
-			tmport += 0x02;
-			outb(dev->id[c][target_id].devsp, tmport++);
+			outb(lun, dev->ioport[c] + 0x0f);
+			outb(dev->id[c][target_id].devsp, dev->ioport[c] + 0x11);
 			adrcnt = dev->id[c][target_id].tran_len;
 			k = dev->id[c][target_id].last_len;
 
-			outb(((unsigned char *) &k)[2], tmport++);
-			outb(((unsigned char *) &k)[1], tmport++);
-			outb(((unsigned char *) &k)[0], tmport++);
+			outb(((unsigned char *) &k)[2], dev->ioport[c] + 0x12);
+			outb(((unsigned char *) &k)[1], dev->ioport[c] + 0x13);
+			outb(((unsigned char *) &k)[0], dev->ioport[c] + 0x14);
 #ifdef ED_DBGP			
-			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k, inb(tmport-1), inb(tmport-2), inb(tmport-3));
+			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k, inb(dev->ioport[c] + 0x14), inb(dev->ioport[c] + 0x13), inb(dev->ioport[c] + 0x12));
 #endif			
 			/* Remap wide */
 			j = target_id;
@@ -322,8 +298,8 @@ stop_dma:
 			}
 			/* Add direction */
 			j |= dev->id[c][target_id].dirct;
-			outb(j, tmport++);
-			outb(0x80,tmport);
+			outb(j, dev->ioport[c] + 0x15);
+			outb(0x80, dev->ioport[c] + 0x16);
 			
 			/* enable 32 bit fifo transfer */	
 			if (dev->dev_id == ATP885_DEVID) {
@@ -336,21 +312,18 @@ stop_dma:
 				outb(i,tmpcip);		    		    		
 			} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    		    	   (dev->dev_id == ATP880_DEVID2) ) {
-				tmport = dev->ioport[c] - 0x05;
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-					outb((unsigned char) ((inb(tmport) & 0x3f) | 0xc0), tmport);
+					outb((unsigned char) ((inb(dev->ioport[c] - 0x05) & 0x3f) | 0xc0), dev->ioport[c] - 0x05);///minus 0x05???
 				} else {
-					outb((unsigned char) (inb(tmport) & 0x3f), tmport);
+					outb((unsigned char) (inb(dev->ioport[c] - 0x05) & 0x3f), dev->ioport[c] - 0x05);///minus 0x05???
 				}
 			} else {				
-				tmport = dev->ioport[c] + 0x3a;
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-					outb((unsigned char) ((inb(tmport) & 0xf3) | 0x08), tmport);
+					outb((unsigned char) ((inb(dev->ioport[c] + 0x3a) & 0xf3) | 0x08), dev->ioport[c] + 0x3a);
 				} else {
-					outb((unsigned char) (inb(tmport) & 0xf3), tmport);
+					outb((unsigned char) (inb(dev->ioport[c] + 0x3a) & 0xf3), dev->ioport[c] + 0x3a);
 				}														
 			}	
-			tmport = dev->ioport[c] + 0x1b;
 			j = 0;
 			id = 1;
 			id = id << target_id;
@@ -360,13 +333,12 @@ stop_dma:
 			if ((id & dev->wide_id[c]) != 0) {
 				j |= 0x01;
 			}
-			outb(j, tmport);
-			while ((inb(tmport) & 0x01) != j) {
-				outb(j,tmport);
+			outb(j, dev->ioport[c] + 0x1b);
+			while ((inb(dev->ioport[c] + 0x1b) & 0x01) != j) {
+				outb(j,dev->ioport[c] + 0x1b);
 			}
 			if (dev->id[c][target_id].last_len == 0) {
-				tmport = dev->ioport[c] + 0x18;
-				outb(0x08, tmport);
+				outb(0x08, dev->ioport[c] + 0x18);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("dev->id[c][target_id].last_len = 0\n");
@@ -412,12 +384,11 @@ stop_dma:
 				outb(0x00, tmpcip);
 				tmpcip -= 0x02;
 			}
-			tmport = dev->ioport[c] + 0x18;
 			/*
 			 *	Check transfer direction
 			 */
 			if (dev->id[c][target_id].dirct != 0) {
-				outb(0x08, tmport);
+				outb(0x08, dev->ioport[c] + 0x18);
 				outb(0x01, tmpcip);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
@@ -425,7 +396,7 @@ stop_dma:
 #endif				
 				goto handled;
 			}
-			outb(0x08, tmport);
+			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x09, tmpcip);
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
@@ -454,8 +425,7 @@ stop_dma:
 			   dev->last_cmd[c] = 0xff;
 			}
 			errstus = 0;
-			tmport -= 0x08;
-			errstus = inb(tmport);
+			errstus = inb(dev->ioport[c] + 0x0f);
 			if (((dev->r1f[c][target_id] & 0x10) != 0)&&(dev->dev_id==ATP885_DEVID)) {
 			   printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
 			   errstus = 0x02;
@@ -486,10 +456,9 @@ go_42:
 			 *      Take it back wide
 			 */
 			if (dev->wide_id[c] != 0) {
-				tmport = dev->ioport[c] + 0x1b;
-				outb(0x01, tmport);
-				while ((inb(tmport) & 0x01) != 0x01) {
-					outb(0x01, tmport);
+				outb(0x01, dev->ioport[c] + 0x1b);
+				while ((inb(dev->ioport[c] + 0x1b) & 0x01) != 0x01) {
+					outb(0x01, dev->ioport[c] + 0x1b);
 				}       
 			} 
 			/*
@@ -521,21 +490,17 @@ go_42:
 			outb(0x06, tmpcip);
 			outb(0x00, tmpcip);
 			tmpcip = tmpcip - 2;
-			tmport = dev->ioport[c] + 0x10;
-			outb(0x41, tmport);
+			outb(0x41, dev->ioport[c] + 0x10);
 			if (dev->dev_id == ATP885_DEVID) {
-				tmport += 2;
 				k = dev->id[c][target_id].last_len;
-				outb((unsigned char) (((unsigned char *) (&k))[2]), tmport++);
-				outb((unsigned char) (((unsigned char *) (&k))[1]), tmport++);
-				outb((unsigned char) (((unsigned char *) (&k))[0]), tmport);
+				outb((unsigned char) (((unsigned char *) (&k))[2]), dev->ioport[c] + 0x12);
+				outb((unsigned char) (((unsigned char *) (&k))[1]), dev->ioport[c] + 0x13);
+				outb((unsigned char) (((unsigned char *) (&k))[0]), dev->ioport[c] + 0x14);
 				dev->id[c][target_id].dirct = 0x00;
-				tmport += 0x04;
 			} else {
 				dev->id[c][target_id].dirct = 0x00;
-				tmport += 0x08;				
 			}
-			outb(0x08, tmport);
+			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x09, tmpcip);
 			dev->in_int[c] = 0;
 			goto handled;
@@ -547,43 +512,34 @@ go_42:
 			outb(0x06, tmpcip);
 			outb(0x00, tmpcip);
 			tmpcip = tmpcip - 2;
-			tmport = dev->ioport[c] + 0x10;
-			outb(0x41, tmport);
+			outb(0x41, dev->ioport[c] + 0x10);
 			if (dev->dev_id == ATP885_DEVID) {		
-				tmport += 2;
 				k = dev->id[c][target_id].last_len;
-				outb((unsigned char) (((unsigned char *) (&k))[2]), tmport++);
-				outb((unsigned char) (((unsigned char *) (&k))[1]), tmport++);
-				outb((unsigned char) (((unsigned char *) (&k))[0]), tmport++);
-			} else {
-				tmport += 5;
+				outb((unsigned char) (((unsigned char *) (&k))[2]), dev->ioport[c] + 0x12);
+				outb((unsigned char) (((unsigned char *) (&k))[1]), dev->ioport[c] + 0x13);
+				outb((unsigned char) (((unsigned char *) (&k))[0]), dev->ioport[c] + 0x14);
 			}
-			outb((unsigned char) (inb(tmport) | 0x20), tmport);
+			outb((unsigned char) (inb(dev->ioport[c] + 0x15) | 0x20), dev->ioport[c] + 0x15);
 			dev->id[c][target_id].dirct = 0x20;
-			tmport += 0x03;
-			outb(0x08, tmport);
+			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x01, tmpcip);
 			dev->in_int[c] = 0;
 			goto handled;
 		}
-		tmport -= 0x07;
 		if (i == 0x0a) {
-			outb(0x30, tmport);
+			outb(0x30, dev->ioport[c] + 0x10);
 		} else {
-			outb(0x46, tmport);
+			outb(0x46, dev->ioport[c] + 0x10);
 		}
 		dev->id[c][target_id].dirct = 0x00;
-		tmport += 0x02;
-		outb(0x00, tmport++);
-		outb(0x00, tmport++);
-		outb(0x00, tmport++);
-		tmport += 0x03;
-		outb(0x08, tmport);
+		outb(0x00, dev->ioport[c] + 0x12);
+		outb(0x00, dev->ioport[c] + 0x13);
+		outb(0x00, dev->ioport[c] + 0x14);
+		outb(0x08, dev->ioport[c] + 0x18);
 		dev->in_int[c] = 0;
 		goto handled;
 	} else {
-//		tmport = dev->ioport[c] + 0x17;
-//		inb(tmport);
+//		inb(dev->ioport[c] + 0x17);
 //		dev->working[c] = 0;
 		dev->in_int[c] = 0;
 		goto handled;
-- 
Ondrej Zary

