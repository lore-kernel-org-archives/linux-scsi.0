From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 04/52] atp870u: Untangle tmport #2
Date: Tue, 17 Nov 2015 19:23:40 +0100
Message-ID: <1447784668-23713-5-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56414 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   79 ++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a25a300..7112337 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -562,7 +562,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 			 void (*done) (struct scsi_cmnd *))
 {
 	unsigned char c;
-	unsigned int tmport,m;	
+	unsigned int m;
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
 
@@ -631,11 +631,10 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 		return 0;
 	}
 	dev->quereq[c][dev->quend[c]] = req_p;
-	tmport = dev->ioport[c] + 0x1c;
 #ifdef ED_DBGP	
-	printk("dev->ioport[c] = %x inb(tmport) = %x dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",dev->ioport[c],inb(tmport),c,dev->in_int[c],c,dev->in_snd[c]);
+	printk("dev->ioport[c] = %x inb(dev->ioport[c] + 0x1c) = %x dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",dev->ioport[c],inb(dev->ioport[c] + 0x1c),c,dev->in_int[c],c,dev->in_snd[c]);
 #endif
-	if ((inb(tmport) == 0) && (dev->in_int[c] == 0) && (dev->in_snd[c] == 0)) {
+	if ((inb(dev->ioport[c] + 0x1c) == 0) && (dev->in_int[c] == 0) && (dev->in_snd[c] == 0)) {
 #ifdef ED_DBGP
 		printk("Call sent_s870(atp870u_queuecommand)\n");
 #endif		
@@ -660,7 +659,6 @@ static DEF_SCSI_QCMD(atp870u_queuecommand)
  */
 static void send_s870(struct atp_unit *dev,unsigned char c)
 {
-	unsigned int tmport;
 	struct scsi_cmnd *workreq;
 	unsigned int i;//,k;
 	unsigned char  j, target_id;
@@ -712,12 +710,10 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	dev->in_snd[c] = 0;
 	return;
 cmd_subp:
-	tmport = dev->ioport[c] + 0x1f;
-	if ((inb(tmport) & 0xb0) != 0) {
+	if ((inb(dev->ioport[c] + 0x1f) & 0xb0) != 0) {
 		goto abortsnd;
 	}
-	tmport = dev->ioport[c] + 0x1c;
-	if (inb(tmport) == 0) {
+	if (inb(dev->ioport[c] + 0x1c) == 0) {
 		goto oktosend;
 	}
 abortsnd:
@@ -752,7 +748,6 @@ oktosend:
 		l = 0;
 	}
 
-	tmport = dev->ioport[c] + 0x1b;
 	j = 0;
 	target_id = scmd_id(workreq);
 
@@ -764,9 +759,9 @@ oktosend:
 	if ((w & dev->wide_id[c]) != 0) {
 		j |= 0x01;
 	}
-	outb(j, tmport);
-	while ((inb(tmport) & 0x01) != j) {
-		outb(j,tmport);
+	outb(j, dev->ioport[c] + 0x1b);
+	while ((inb(dev->ioport[c] + 0x1b) & 0x01) != j) {
+		outb(j,dev->ioport[c] + 0x1b);
 #ifdef ED_DBGP
 		printk("send_s870 while loop 1\n");
 #endif
@@ -775,24 +770,21 @@ oktosend:
 	 *	Write the command
 	 */
 
-	tmport = dev->ioport[c];
-	outb(workreq->cmd_len, tmport++);
-	outb(0x2c, tmport++);
+	outb(workreq->cmd_len, dev->ioport[c] + 0x00);
+	outb(0x2c, dev->ioport[c] + 0x01);
 	if (dev->dev_id == ATP885_DEVID) {
-		outb(0x7f, tmport++);
+		outb(0x7f, dev->ioport[c] + 0x02);
 	} else {
-		outb(0xcf, tmport++); 	
+		outb(0xcf, dev->ioport[c] + 0x02);
 	}	
 	for (i = 0; i < workreq->cmd_len; i++) {
-		outb(workreq->cmnd[i], tmport++);
+		outb(workreq->cmnd[i], dev->ioport[c] + 0x03 + i);
 	}
-	tmport = dev->ioport[c] + 0x0f;
-	outb(workreq->device->lun, tmport);
-	tmport += 0x02;
+	outb(workreq->device->lun, dev->ioport[c] + 0x0f);
 	/*
 	 *	Write the target
 	 */
-	outb(dev->id[c][target_id].devsp, tmport++);	 
+	outb(dev->id[c][target_id].devsp, dev->ioport[c] + 0x11);
 #ifdef ED_DBGP	
 	printk("dev->id[%d][%d].devsp = %2x\n",c,target_id,dev->id[c][target_id].devsp);
 #endif
@@ -801,9 +793,9 @@ oktosend:
 	/*
 	 *	Write transfer size
 	 */
-	outb((unsigned char) (((unsigned char *) (&l))[2]), tmport++);
-	outb((unsigned char) (((unsigned char *) (&l))[1]), tmport++);
-	outb((unsigned char) (((unsigned char *) (&l))[0]), tmport++);
+	outb((unsigned char) (((unsigned char *) (&l))[2]), dev->ioport[c] + 0x12);
+	outb((unsigned char) (((unsigned char *) (&l))[1]), dev->ioport[c] + 0x13);
+	outb((unsigned char) (((unsigned char *) (&l))[0]), dev->ioport[c] + 0x14);
 	j = target_id;	
 	dev->id[c][j].last_len = l;
 	dev->id[c][j].tran_len = 0;
@@ -820,21 +812,19 @@ oktosend:
 	 *	Check transfer direction
 	 */
 	if (workreq->sc_data_direction == DMA_TO_DEVICE) {
-		outb((unsigned char) (j | 0x20), tmport++);
+		outb((unsigned char) (j | 0x20), dev->ioport[c] + 0x15);
 	} else {
-		outb(j, tmport++);
+		outb(j, dev->ioport[c] + 0x15);
 	}
-	outb((unsigned char) (inb(tmport) | 0x80), tmport);
-	outb(0x80, tmport);
-	tmport = dev->ioport[c] + 0x1c;
+	outb((unsigned char) (inb(dev->ioport[c] + 0x16) | 0x80), dev->ioport[c] + 0x16);
+	outb(0x80, dev->ioport[c] + 0x16);
 	dev->id[c][target_id].dirct = 0;
 	if (l == 0) {
-		if (inb(tmport) == 0) {
-			tmport = dev->ioport[c] + 0x18;
+		if (inb(dev->ioport[c] + 0x1c) == 0) {
 #ifdef ED_DBGP
 			printk("change SCSI_CMD_REG 0x08\n");	
 #endif				
-			outb(0x08, tmport);
+			outb(0x08, dev->ioport[c] + 0x18);
 		} else {
 			dev->last_cmd[c] |= 0x40;
 		}
@@ -899,28 +889,24 @@ oktosend:
 	} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    	   (dev->dev_id == ATP880_DEVID2)) {
 		tmpcip =tmpcip -2;	
-		tmport = dev->ioport[c] - 0x05;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-			outb((unsigned char) ((inb(tmport) & 0x3f) | 0xc0), tmport);
+			outb((unsigned char) ((inb(dev->ioport[c] - 0x05) & 0x3f) | 0xc0), dev->ioport[c] - 0x05);
 		} else {
-			outb((unsigned char) (inb(tmport) & 0x3f), tmport);
+			outb((unsigned char) (inb(dev->ioport[c] - 0x05) & 0x3f), dev->ioport[c] - 0x05);
 		}		
 	} else {		
 		tmpcip =tmpcip -2;
-		tmport = dev->ioport[c] + 0x3a;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-			outb((inb(tmport) & 0xf3) | 0x08, tmport);
+			outb((inb(dev->ioport[c] + 0x3a) & 0xf3) | 0x08, dev->ioport[c] + 0x3a);
 		} else {
-			outb(inb(tmport) & 0xf3, tmport);
+			outb(inb(dev->ioport[c] + 0x3a) & 0xf3, dev->ioport[c] + 0x3a);
 		}		
 	}	
-	tmport = dev->ioport[c] + 0x1c;
 
 	if(workreq->sc_data_direction == DMA_TO_DEVICE) {
 		dev->id[c][target_id].dirct = 0x20;
-		if (inb(tmport) == 0) {
-			tmport = dev->ioport[c] + 0x18;
-			outb(0x08, tmport);
+		if (inb(dev->ioport[c] + 0x1c) == 0) {
+			outb(0x08, dev->ioport[c] + 0x18);
 			outb(0x01, tmpcip);
 #ifdef ED_DBGP		
 		printk( "start DMA(to target)\n");
@@ -931,9 +917,8 @@ oktosend:
 		dev->in_snd[c] = 0;
 		return;
 	}
-	if (inb(tmport) == 0) {		
-		tmport = dev->ioport[c] + 0x18;
-		outb(0x08, tmport);
+	if (inb(dev->ioport[c] + 0x1c) == 0) {
+		outb(0x08, dev->ioport[c] + 0x18);
 		outb(0x09, tmpcip);
 #ifdef ED_DBGP		
 		printk( "start DMA(to host)\n");
-- 
Ondrej Zary

