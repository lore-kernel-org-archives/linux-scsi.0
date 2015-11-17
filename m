From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 13/52] atp870u: Remove ugly gotos
Date: Tue, 17 Nov 2015 19:23:49 +0100
Message-ID: <1447784668-23713-14-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56568 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbbKQShy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:54 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   84 +++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 4d840a5..886e54b 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -55,20 +55,17 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 #ifdef ED_DBGP
 	unsigned long l;
 #endif
-	int errstus;
 	struct Scsi_Host *host = dev_id;
 	struct atp_unit *dev = (struct atp_unit *)&host->hostdata;
 
 	for (c = 0; c < 2; c++) {
 		j = inb(dev->ioport[c] + 0x1f);
 		if ((j & 0x80) != 0)
-		{			
-	   		goto ch_sel;
-		}
+			break;
 		dev->in_int[c] = 0;
 	}
-	return IRQ_NONE;
-ch_sel:
+	if ((j & 0x80) == 0)
+		return IRQ_NONE;
 #ifdef ED_DBGP	
 	printk("atp870u_intr_handle enter\n");
 #endif	
@@ -82,15 +79,12 @@ ch_sel:
 		if ((inb(dev->pciport[c]) & 0x08) != 0)
 		{
 			for (k=0; k < 1000; k++) {
-				if ((inb(dev->pciport[c] + 2) & 0x08) == 0) {
-					goto stop_dma;
-				}
-				if ((inb(dev->pciport[c] + 2) & 0x01) == 0) {
-					goto stop_dma;
-				}
+				if ((inb(dev->pciport[c] + 2) & 0x08) == 0)
+					break;
+				if ((inb(dev->pciport[c] + 2) & 0x01) == 0)
+					break;
 			}
 		}
-stop_dma:
 		outb(0x00, dev->pciport[c]);
 		
 		i = inb(dev->ioport[c] + 0x17);
@@ -170,13 +164,13 @@ stop_dma:
 #ifdef ED_DBGP
 				printk("Status 0x85 return\n");
 #endif				
-			goto handled;
+			return IRQ_HANDLED;
 		}
 
 		if (i == 0x40) {
 		     dev->last_cmd[c] |= 0x40;
 		     dev->in_int[c] = 0;
-		     goto handled;
+		     return IRQ_HANDLED;
 		}
 
 		if (i == 0x21) {
@@ -194,7 +188,7 @@ stop_dma:
 			outb(0x41, dev->ioport[c] + 0x10);
 			outb(0x08, dev->ioport[c] + 0x18);
 			dev->in_int[c] = 0;
-			goto handled;
+			return IRQ_HANDLED;
 		}
 
 		if (dev->dev_id == ATP885_DEVID) {
@@ -231,7 +225,7 @@ stop_dma:
 					dev->id[c][target_id].last_len = adrcnt;
 					outb(0x08, dev->ioport[c] + 0x18);
 					dev->in_int[c] = 0;
-					goto handled;
+					return IRQ_HANDLED;
 				} else {
 #ifdef ED_DBGP
 					printk("cmdp != 0x41\n");
@@ -243,7 +237,7 @@ stop_dma:
 					outb(0x00, dev->ioport[c] + 0x14);
 					outb(0x08, dev->ioport[c] + 0x18);
 					dev->in_int[c] = 0;
-					goto handled;
+					return IRQ_HANDLED;
 				}
 			}
 			if (dev->last_cmd[c] != 0xff) {
@@ -336,7 +330,7 @@ stop_dma:
 #ifdef ED_DBGP
 				printk("dev->id[c][target_id].last_len = 0\n");
 #endif					
-				goto handled;
+				return IRQ_HANDLED;
 			}
 #ifdef ED_DBGP
 			printk("target_id = %d adrcnt = %d\n",target_id,adrcnt);
@@ -382,7 +376,7 @@ stop_dma:
 #ifdef ED_DBGP
 				printk("status 0x80 return dirct != 0\n");
 #endif				
-				goto handled;
+				return IRQ_HANDLED;
 			}
 			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x09, dev->pciport[c]);
@@ -390,7 +384,7 @@ stop_dma:
 #ifdef ED_DBGP
 			printk("status 0x80 return dirct = 0\n");
 #endif			
-			goto handled;
+			return IRQ_HANDLED;
 		}
 
 		/*
@@ -399,27 +393,19 @@ stop_dma:
 
 		workreq = dev->id[c][target_id].curr_req;
 
-		if (i == 0x42) {
-			if ((dev->last_cmd[c] & 0xf0) != 0x40)
-			{
-			   dev->last_cmd[c] = 0xff;
-			}
-			errstus = 0x02;
-			workreq->result = errstus;
-			goto go_42;
-		}
-		if (i == 0x16) {
+		if (i == 0x42 || i == 0x16) {
 			if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 			   dev->last_cmd[c] = 0xff;
 			}
-			errstus = 0;
-			errstus = inb(dev->ioport[c] + 0x0f);
-			if (((dev->r1f[c][target_id] & 0x10) != 0)&&(dev->dev_id==ATP885_DEVID)) {
-			   printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
-			   errstus = 0x02;
-			}
-			workreq->result = errstus;
-go_42:
+			if (i == 0x16) {
+				workreq->result = inb(dev->ioport[c] + 0x0f);
+				if (((dev->r1f[c][target_id] & 0x10) != 0)&&(dev->dev_id==ATP885_DEVID)) {
+					printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
+					workreq->result = 0x02;
+				}
+			} else
+				workreq->result = 0x02;
+
 			if (dev->dev_id == ATP885_DEVID) {		
 				j = inb(dev->baseport + 0x29) | 0x01;
 				outb(j, dev->baseport + 0x29);
@@ -462,7 +448,7 @@ go_42:
 			}
 			spin_unlock_irqrestore(dev->host->host_lock, flags);
 			dev->in_int[c] = 0;
-			goto handled;
+			return IRQ_HANDLED;
 		}
 		if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 		   dev->last_cmd[c] = 0xff;
@@ -488,7 +474,7 @@ go_42:
 			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x09, dev->pciport[c]);
 			dev->in_int[c] = 0;
-			goto handled;
+			return IRQ_HANDLED;
 		}
 		if (i == 0x08) {
 			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
@@ -506,7 +492,7 @@ go_42:
 			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x01, dev->pciport[c]);
 			dev->in_int[c] = 0;
-			goto handled;
+			return IRQ_HANDLED;
 		}
 		if (i == 0x0a) {
 			outb(0x30, dev->ioport[c] + 0x10);
@@ -518,19 +504,9 @@ go_42:
 		outb(0x00, dev->ioport[c] + 0x13);
 		outb(0x00, dev->ioport[c] + 0x14);
 		outb(0x08, dev->ioport[c] + 0x18);
-		dev->in_int[c] = 0;
-		goto handled;
-	} else {
-//		inb(dev->ioport[c] + 0x17);
-//		dev->working[c] = 0;
-		dev->in_int[c] = 0;
-		goto handled;
 	}
-	
-handled:
-#ifdef ED_DBGP
-	printk("atp870u_intr_handle exit\n");
-#endif			
+	dev->in_int[c] = 0;
+
 	return IRQ_HANDLED;
 }
 /**
-- 
Ondrej Zary

