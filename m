From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 18/52] atp870u: Introduce HW access wrappers
Date: Tue, 17 Nov 2015 19:23:54 +0100
Message-ID: <1447784668-23713-19-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56499 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:25 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Introduce *_read? and *_write? wrappers to improve code readability.
Also make sure that baseport is always initialized, not only for ATP880.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  472 ++++++++++++++++++++++++++----------------------
 1 file changed, 252 insertions(+), 220 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index fd2bb6f..07b50ac 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -44,6 +44,51 @@ static void send_s870(struct atp_unit *dev,unsigned char c);
 static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c);
 static void tscam_885(void);
 
+static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
+{
+	outb(val, atp->baseport + reg);
+}
+
+static inline void atp_writeb_io(struct atp_unit *atp, u8 channel, u8 reg, u8 val)
+{
+	outb(val, atp->ioport[channel] + reg);
+}
+
+static inline void atp_writew_io(struct atp_unit *atp, u8 channel, u8 reg, u16 val)
+{
+	outw(val, atp->ioport[channel] + reg);
+}
+
+static inline void atp_writeb_pci(struct atp_unit *atp, u8 channel, u8 reg, u8 val)
+{
+	outb(val, atp->pciport[channel] + reg);
+}
+
+static inline void atp_writel_pci(struct atp_unit *atp, u8 channel, u8 reg, u32 val)
+{
+	outl(val, atp->pciport[channel] + reg);
+}
+
+static inline u8 atp_readb_base(struct atp_unit *atp, u8 reg)
+{
+	return inb(atp->baseport + reg);
+}
+
+static inline u8 atp_readb_io(struct atp_unit *atp, u8 channel, u8 reg)
+{
+	return inb(atp->ioport[channel] + reg);
+}
+
+static inline u16 atp_readw_io(struct atp_unit *atp, u8 channel, u8 reg)
+{
+	return inw(atp->ioport[channel] + reg);
+}
+
+static inline u8 atp_readb_pci(struct atp_unit *atp, u8 channel, u8 reg)
+{
+	return inb(atp->pciport[channel] + reg);
+}
+
 static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 {
 	unsigned long flags;
@@ -59,7 +104,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	struct atp_unit *dev = (struct atp_unit *)&host->hostdata;
 
 	for (c = 0; c < 2; c++) {
-		j = inb(dev->ioport[c] + 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x80) != 0)
 			break;
 		dev->in_int[c] = 0;
@@ -70,29 +115,29 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	printk("atp870u_intr_handle enter\n");
 #endif	
 	dev->in_int[c] = 1;
-	cmdp = inb(dev->ioport[c] + 0x10);
+	cmdp = atp_readb_io(dev, c, 0x10);
 	if (dev->working[c] != 0) {
 		if (dev->dev_id == ATP885_DEVID) {
-			if ((inb(dev->ioport[c] + 0x16) & 0x80) == 0)
-				outb((inb(dev->ioport[c] + 0x16) | 0x80), dev->ioport[c] + 0x16);
+			if ((atp_readb_io(dev, c, 0x16) & 0x80) == 0)
+				atp_writeb_io(dev, c, 0x16, (atp_readb_io(dev, c, 0x16) | 0x80));
 		}		
-		if ((inb(dev->pciport[c]) & 0x08) != 0)
+		if ((atp_readb_pci(dev, c, 0x00) & 0x08) != 0)
 		{
 			for (k=0; k < 1000; k++) {
-				if ((inb(dev->pciport[c] + 2) & 0x08) == 0)
+				if ((atp_readb_pci(dev, c, 2) & 0x08) == 0)
 					break;
-				if ((inb(dev->pciport[c] + 2) & 0x01) == 0)
+				if ((atp_readb_pci(dev, c, 2) & 0x01) == 0)
 					break;
 			}
 		}
-		outb(0x00, dev->pciport[c]);
+		atp_writeb_pci(dev, c, 0, 0x00);
 		
-		i = inb(dev->ioport[c] + 0x17);
+		i = atp_readb_io(dev, c, 0x17);
 		
 		if (dev->dev_id == ATP885_DEVID)
-			outb(0x06, dev->pciport[c] + 2);
+			atp_writeb_pci(dev, c, 2, 0x06);
 
-		target_id = inb(dev->ioport[c] + 0x15);
+		target_id = atp_readb_io(dev, c, 0x15);
 
 		/*
 		 *	Remap wide devices onto id numbers
@@ -121,9 +166,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			}
 			if (dev->dev_id == ATP885_DEVID) {
 				adrcnt = 0;
-				((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
-				((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
-				((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
+				((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
+				((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
+				((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
 				if (dev->id[c][target_id].last_len != adrcnt)
 				{
 			   		k = dev->id[c][target_id].last_len;
@@ -140,10 +185,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			 *      Flip wide
 			 */			
 			if (dev->wide_id[c] != 0) {
-				outb(0x01, dev->ioport[c] + 0x1b);
-				while ((inb(dev->ioport[c] + 0x1b) & 0x01) != 0x01) {
-					outb(0x01, dev->ioport[c] + 0x1b);
-				}
+				atp_writeb_io(dev, c, 0x1b, 0x01);
+				while ((atp_readb_io(dev, c, 0x1b) & 0x01) != 0x01)
+					atp_writeb_io(dev, c, 0x1b, 0x01);
 			}		
 			/*
 			 *	Issue more commands
@@ -178,15 +222,15 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			   dev->last_cmd[c] = 0xff;
 			}
 			adrcnt = 0;
-			((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
-			((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
-			((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
+			((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
+			((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
+			((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
 			k = dev->id[c][target_id].last_len;
 			k -= adrcnt;
 			dev->id[c][target_id].tran_len = k;
 			dev->id[c][target_id].last_len = adrcnt;
-			outb(0x41, dev->ioport[c] + 0x10);
-			outb(0x08, dev->ioport[c] + 0x18);
+			atp_writeb_io(dev, c, 0x10, 0x41);
+			atp_writeb_io(dev, c, 0x18, 0x08);
 			dev->in_int[c] = 0;
 			return IRQ_HANDLED;
 		}
@@ -205,9 +249,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			printk(KERN_DEBUG "Device reselect\n");
 #endif			
 			lun = 0;
-			if (cmdp == 0x44 || i==0x80) {
-				lun = inb(dev->ioport[c] + 0x1d) & 0x07;
-			} else {
+			if (cmdp == 0x44 || i == 0x80)
+				lun = atp_readb_io(dev, c, 0x1d) & 0x07;
+			else {
 				if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 				   dev->last_cmd[c] = 0xff;
 				}
@@ -216,26 +260,26 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 					printk("cmdp = 0x41\n");
 #endif						
 					adrcnt = 0;
-					((unsigned char *) &adrcnt)[2] = inb(dev->ioport[c] + 0x12);
-					((unsigned char *) &adrcnt)[1] = inb(dev->ioport[c] + 0x13);
-					((unsigned char *) &adrcnt)[0] = inb(dev->ioport[c] + 0x14);
+					((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
+					((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
+					((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
 					k = dev->id[c][target_id].last_len;
 					k -= adrcnt;
 					dev->id[c][target_id].tran_len = k;
 					dev->id[c][target_id].last_len = adrcnt;
-					outb(0x08, dev->ioport[c] + 0x18);
+					atp_writeb_io(dev, c, 0x18, 0x08);
 					dev->in_int[c] = 0;
 					return IRQ_HANDLED;
 				} else {
 #ifdef ED_DBGP
 					printk("cmdp != 0x41\n");
 #endif						
-					outb(0x46, dev->ioport[c] + 0x10);
+					atp_writeb_io(dev, c, 0x10, 0x46);
 					dev->id[c][target_id].dirct = 0x00;
-					outb(0x00, dev->ioport[c] + 0x12);
-					outb(0x00, dev->ioport[c] + 0x13);
-					outb(0x00, dev->ioport[c] + 0x14);
-					outb(0x08, dev->ioport[c] + 0x18);
+					atp_writeb_io(dev, c, 0x12, 0x00);
+					atp_writeb_io(dev, c, 0x13, 0x00);
+					atp_writeb_io(dev, c, 0x14, 0x00);
+					atp_writeb_io(dev, c, 0x18, 0x08);
 					dev->in_int[c] = 0;
 					return IRQ_HANDLED;
 				}
@@ -244,12 +288,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			   dev->last_cmd[c] |= 0x40;
 			}
 			if (dev->dev_id == ATP885_DEVID) {
-				j = inb(dev->baseport + 0x29) & 0xfe;
-				outb(j, dev->baseport + 0x29);
+				j = atp_readb_base(dev, 0x29) & 0xfe;
+				atp_writeb_base(dev, 0x29, j);
 			} else
-				outb(0x45, dev->ioport[c] + 0x10);
+				atp_writeb_io(dev, c, 0x10, 0x45);
 
-			target_id = inb(dev->ioport[c] + 0x16);
+			target_id = atp_readb_io(dev, c, 0x16);
 			/*
 			 *	Remap wide identifiers
 			 */
@@ -259,7 +303,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				target_id &= 0x07;
 			}
 			if (dev->dev_id == ATP885_DEVID)
-				outb(0x45, dev->ioport[c] + 0x10);
+				atp_writeb_io(dev, c, 0x10, 0x45);
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
 			scmd_printk(KERN_DEBUG, workreq, "CDB");
@@ -268,16 +312,16 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			printk("\n");
 #endif	
 			
-			outb(lun, dev->ioport[c] + 0x0f);
-			outb(dev->id[c][target_id].devsp, dev->ioport[c] + 0x11);
+			atp_writeb_io(dev, c, 0x0f, lun);
+			atp_writeb_io(dev, c, 0x11, dev->id[c][target_id].devsp);
 			adrcnt = dev->id[c][target_id].tran_len;
 			k = dev->id[c][target_id].last_len;
 
-			outb(((unsigned char *) &k)[2], dev->ioport[c] + 0x12);
-			outb(((unsigned char *) &k)[1], dev->ioport[c] + 0x13);
-			outb(((unsigned char *) &k)[0], dev->ioport[c] + 0x14);
+			atp_writeb_io(dev, c, 0x12, ((unsigned char *) &k)[2]);
+			atp_writeb_io(dev, c, 0x13, ((unsigned char *) &k)[1]);
+			atp_writeb_io(dev, c, 0x14, ((unsigned char *) &k)[0]);
 #ifdef ED_DBGP			
-			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k, inb(dev->ioport[c] + 0x14), inb(dev->ioport[c] + 0x13), inb(dev->ioport[c] + 0x12));
+			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k, atp_readb_io(dev, c, 0x14), atp_readb_io(dev, c, 0x13), atp_readb_io(dev, c, 0x12));
 #endif			
 			/* Remap wide */
 			j = target_id;
@@ -286,30 +330,28 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			}
 			/* Add direction */
 			j |= dev->id[c][target_id].dirct;
-			outb(j, dev->ioport[c] + 0x15);
-			outb(0x80, dev->ioport[c] + 0x16);
+			atp_writeb_io(dev, c, 0x15, j);
+			atp_writeb_io(dev, c, 0x16, 0x80);
 			
 			/* enable 32 bit fifo transfer */	
 			if (dev->dev_id == ATP885_DEVID) {
-				i=inb(dev->pciport[c] + 1) & 0xf3;
+				i = atp_readb_pci(dev, c, 1) & 0xf3;
 				//j=workreq->cmnd[0];	    		    	
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 				   i |= 0x0c;
 				}
-				outb(i, dev->pciport[c] + 1);
+				atp_writeb_pci(dev, c, 1, i);
 			} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    		    	   (dev->dev_id == ATP880_DEVID2) ) {
-				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-					outb((unsigned char) ((inb(dev->ioport[c] - 0x05) & 0x3f) | 0xc0), dev->ioport[c] - 0x05);///minus 0x05???
-				} else {
-					outb((unsigned char) (inb(dev->ioport[c] - 0x05) & 0x3f), dev->ioport[c] - 0x05);///minus 0x05???
-				}
+				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+					atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
+				else
+					atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
 			} else {				
-				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-					outb((unsigned char) ((inb(dev->ioport[c] + 0x3a) & 0xf3) | 0x08), dev->ioport[c] + 0x3a);
-				} else {
-					outb((unsigned char) (inb(dev->ioport[c] + 0x3a) & 0xf3), dev->ioport[c] + 0x3a);
-				}														
+				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+					atp_writeb_io(dev, c, 0x3a, (atp_readb_io(dev, c, 0x3a) & 0xf3) | 0x08);
+				else
+					atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xf3);
 			}	
 			j = 0;
 			id = 1;
@@ -320,12 +362,11 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			if ((id & dev->wide_id[c]) != 0) {
 				j |= 0x01;
 			}
-			outb(j, dev->ioport[c] + 0x1b);
-			while ((inb(dev->ioport[c] + 0x1b) & 0x01) != j) {
-				outb(j,dev->ioport[c] + 0x1b);
-			}
+			atp_writeb_io(dev, c, 0x1b, j);
+			while ((atp_readb_io(dev, c, 0x1b) & 0x01) != j)
+				atp_writeb_io(dev, c, 0x1b, j);
 			if (dev->id[c][target_id].last_len == 0) {
-				outb(0x08, dev->ioport[c] + 0x18);
+				atp_writeb_io(dev, c, 0x18, 0x08);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("dev->id[c][target_id].last_len = 0\n");
@@ -358,28 +399,28 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 					}
 				}				
 			}
-			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 0x04);
+			atp_writel_pci(dev, c, 0x04, dev->id[c][target_id].prdaddr);
 #ifdef ED_DBGP
 			printk("dev->id[%d][%d].prdaddr 0x%8x\n", c, target_id, dev->id[c][target_id].prdaddr);
 #endif
 			if (dev->dev_id != ATP885_DEVID) {
-				outb(0x06, dev->pciport[c] + 2);
-				outb(0x00, dev->pciport[c] + 2);
+				atp_writeb_pci(dev, c, 2, 0x06);
+				atp_writeb_pci(dev, c, 2, 0x00);
 			}
 			/*
 			 *	Check transfer direction
 			 */
 			if (dev->id[c][target_id].dirct != 0) {
-				outb(0x08, dev->ioport[c] + 0x18);
-				outb(0x01, dev->pciport[c]);
+				atp_writeb_io(dev, c, 0x18, 0x08);
+				atp_writeb_pci(dev, c, 0, 0x01);
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("status 0x80 return dirct != 0\n");
 #endif				
 				return IRQ_HANDLED;
 			}
-			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x09, dev->pciport[c]);
+			atp_writeb_io(dev, c, 0x18, 0x08);
+			atp_writeb_pci(dev, c, 0, 0x09);
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
 			printk("status 0x80 return dirct = 0\n");
@@ -398,7 +439,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			   dev->last_cmd[c] = 0xff;
 			}
 			if (i == 0x16) {
-				workreq->result = inb(dev->ioport[c] + 0x0f);
+				workreq->result = atp_readb_io(dev, c, 0x0f);
 				if (((dev->r1f[c][target_id] & 0x10) != 0)&&(dev->dev_id==ATP885_DEVID)) {
 					printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
 					workreq->result = 0x02;
@@ -407,8 +448,8 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				workreq->result = 0x02;
 
 			if (dev->dev_id == ATP885_DEVID) {		
-				j = inb(dev->baseport + 0x29) | 0x01;
-				outb(j, dev->baseport + 0x29);
+				j = atp_readb_base(dev, 0x29) | 0x01;
+				atp_writeb_base(dev, 0x29, j);
 			}
 			/*
 			 *	Complete the command
@@ -430,10 +471,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			 *      Take it back wide
 			 */
 			if (dev->wide_id[c] != 0) {
-				outb(0x01, dev->ioport[c] + 0x1b);
-				while ((inb(dev->ioport[c] + 0x1b) & 0x01) != 0x01) {
-					outb(0x01, dev->ioport[c] + 0x1b);
-				}       
+				atp_writeb_io(dev, c, 0x1b, 0x01);
+				while ((atp_readb_io(dev, c, 0x1b) & 0x01) != 0x01)
+					atp_writeb_io(dev, c, 0x1b, 0x01);
 			} 
 			/*
 			 *	If there is stuff to send and nothing going then send it
@@ -458,52 +498,51 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 		}
 		i &= 0x0f;
 		if (i == 0x09) {
-			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
-			outb(0x06, dev->pciport[c] + 2);
-			outb(0x00, dev->pciport[c] + 2);
-			outb(0x41, dev->ioport[c] + 0x10);
+			atp_writel_pci(dev, c, 4, dev->id[c][target_id].prdaddr);
+			atp_writeb_pci(dev, c, 2, 0x06);
+			atp_writeb_pci(dev, c, 2, 0x00);
+			atp_writeb_io(dev, c, 0x10, 0x41);
 			if (dev->dev_id == ATP885_DEVID) {
 				k = dev->id[c][target_id].last_len;
-				outb((unsigned char) (((unsigned char *) (&k))[2]), dev->ioport[c] + 0x12);
-				outb((unsigned char) (((unsigned char *) (&k))[1]), dev->ioport[c] + 0x13);
-				outb((unsigned char) (((unsigned char *) (&k))[0]), dev->ioport[c] + 0x14);
+				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
+				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
+				atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&k))[0]);
 				dev->id[c][target_id].dirct = 0x00;
 			} else {
 				dev->id[c][target_id].dirct = 0x00;
 			}
-			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x09, dev->pciport[c]);
+			atp_writeb_io(dev, c, 0x18, 0x08);
+			atp_writeb_pci(dev, c, 0, 0x09);
 			dev->in_int[c] = 0;
 			return IRQ_HANDLED;
 		}
 		if (i == 0x08) {
-			outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
-			outb(0x06, dev->pciport[c] + 2);
-			outb(0x00, dev->pciport[c] + 2);
-			outb(0x41, dev->ioport[c] + 0x10);
+			atp_writel_pci(dev, c, 4, dev->id[c][target_id].prdaddr);
+			atp_writeb_pci(dev, c, 2, 0x06);
+			atp_writeb_pci(dev, c, 2, 0x00);
+			atp_writeb_io(dev, c, 0x10, 0x41);
 			if (dev->dev_id == ATP885_DEVID) {		
 				k = dev->id[c][target_id].last_len;
-				outb((unsigned char) (((unsigned char *) (&k))[2]), dev->ioport[c] + 0x12);
-				outb((unsigned char) (((unsigned char *) (&k))[1]), dev->ioport[c] + 0x13);
-				outb((unsigned char) (((unsigned char *) (&k))[0]), dev->ioport[c] + 0x14);
+				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
+				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
+				atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&k))[0]);
 			}
-			outb((unsigned char) (inb(dev->ioport[c] + 0x15) | 0x20), dev->ioport[c] + 0x15);
+			atp_writeb_io(dev, c, 0x15, atp_readb_io(dev, c, 0x15) | 0x20);
 			dev->id[c][target_id].dirct = 0x20;
-			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x01, dev->pciport[c]);
+			atp_writeb_io(dev, c, 0x18, 0x08);
+			atp_writeb_pci(dev, c, 0, 0x01);
 			dev->in_int[c] = 0;
 			return IRQ_HANDLED;
 		}
-		if (i == 0x0a) {
-			outb(0x30, dev->ioport[c] + 0x10);
-		} else {
-			outb(0x46, dev->ioport[c] + 0x10);
-		}
+		if (i == 0x0a)
+			atp_writeb_io(dev, c, 0x10, 0x30);
+		else
+			atp_writeb_io(dev, c, 0x10, 0x46);
 		dev->id[c][target_id].dirct = 0x00;
-		outb(0x00, dev->ioport[c] + 0x12);
-		outb(0x00, dev->ioport[c] + 0x13);
-		outb(0x00, dev->ioport[c] + 0x14);
-		outb(0x08, dev->ioport[c] + 0x18);
+		atp_writeb_io(dev, c, 0x12, 0x00);
+		atp_writeb_io(dev, c, 0x13, 0x00);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 	}
 	dev->in_int[c] = 0;
 
@@ -590,9 +629,9 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	}
 	dev->quereq[c][dev->quend[c]] = req_p;
 #ifdef ED_DBGP	
-	printk("dev->ioport[c] = %x inb(dev->ioport[c] + 0x1c) = %x dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",dev->ioport[c],inb(dev->ioport[c] + 0x1c),c,dev->in_int[c],c,dev->in_snd[c]);
+	printk("dev->ioport[c] = %x atp_readb_io(dev, c, 0x1c) = %x dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",dev->ioport[c],atp_readb_io(dev, c, 0x1c),c,dev->in_int[c],c,dev->in_snd[c]);
 #endif
-	if ((inb(dev->ioport[c] + 0x1c) == 0) && (dev->in_int[c] == 0) && (dev->in_snd[c] == 0)) {
+	if ((atp_readb_io(dev, c, 0x1c) == 0) && (dev->in_int[c] == 0) && (dev->in_snd[c] == 0)) {
 #ifdef ED_DBGP
 		printk("Call sent_s870(atp870u_queuecommand)\n");
 #endif		
@@ -666,7 +705,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		dev->id[c][scmd_id(workreq)].curr_req = workreq;
 		dev->last_cmd[c] = scmd_id(workreq);
 	}
-	if ((inb(dev->ioport[c] + 0x1f) & 0xb0) != 0 || inb(dev->ioport[c] + 0x1c) != 0) {
+	if ((atp_readb_io(dev, c, 0x1f) & 0xb0) != 0 || atp_readb_io(dev, c, 0x1c) != 0) {
 #ifdef ED_DBGP
 		printk("Abort to Send\n");
 #endif
@@ -685,8 +724,8 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	l = scsi_bufflen(workreq);
 
 	if (dev->dev_id == ATP885_DEVID) {
-		j = inb(dev->baseport + 0x29) & 0xfe;
-		outb(j, dev->baseport + 0x29);
+		j = atp_readb_base(dev, 0x29) & 0xfe;
+		atp_writeb_base(dev, 0x29, j);
 		dev->r1f[c][scmd_id(workreq)] = 0;
 	}
 	
@@ -709,9 +748,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	if ((w & dev->wide_id[c]) != 0) {
 		j |= 0x01;
 	}
-	outb(j, dev->ioport[c] + 0x1b);
-	while ((inb(dev->ioport[c] + 0x1b) & 0x01) != j) {
-		outb(j,dev->ioport[c] + 0x1b);
+	atp_writeb_io(dev, c, 0x1b, j);
+	while ((atp_readb_io(dev, c, 0x1b) & 0x01) != j) {
+		atp_writeb_pci(dev, c, 0x1b, j);
 #ifdef ED_DBGP
 		printk("send_s870 while loop 1\n");
 #endif
@@ -720,21 +759,19 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	 *	Write the command
 	 */
 
-	outb(workreq->cmd_len, dev->ioport[c] + 0x00);
-	outb(0x2c, dev->ioport[c] + 0x01);
-	if (dev->dev_id == ATP885_DEVID) {
-		outb(0x7f, dev->ioport[c] + 0x02);
-	} else {
-		outb(0xcf, dev->ioport[c] + 0x02);
-	}	
-	for (i = 0; i < workreq->cmd_len; i++) {
-		outb(workreq->cmnd[i], dev->ioport[c] + 0x03 + i);
-	}
-	outb(workreq->device->lun, dev->ioport[c] + 0x0f);
+	atp_writeb_io(dev, c, 0x00, workreq->cmd_len);
+	atp_writeb_io(dev, c, 0x01, 0x2c);
+	if (dev->dev_id == ATP885_DEVID)
+		atp_writeb_io(dev, c, 0x02, 0x7f);
+	else
+		atp_writeb_io(dev, c, 0x02, 0xcf);
+	for (i = 0; i < workreq->cmd_len; i++)
+		atp_writeb_io(dev, c, 0x03 + i, workreq->cmnd[i]);
+	atp_writeb_io(dev, c, 0x0f, workreq->device->lun);
 	/*
 	 *	Write the target
 	 */
-	outb(dev->id[c][target_id].devsp, dev->ioport[c] + 0x11);
+	atp_writeb_io(dev, c, 0x11, dev->id[c][target_id].devsp);
 #ifdef ED_DBGP	
 	printk("dev->id[%d][%d].devsp = %2x\n",c,target_id,dev->id[c][target_id].devsp);
 #endif
@@ -743,9 +780,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	/*
 	 *	Write transfer size
 	 */
-	outb((unsigned char) (((unsigned char *) (&l))[2]), dev->ioport[c] + 0x12);
-	outb((unsigned char) (((unsigned char *) (&l))[1]), dev->ioport[c] + 0x13);
-	outb((unsigned char) (((unsigned char *) (&l))[0]), dev->ioport[c] + 0x14);
+	atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&l))[2]);
+	atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&l))[1]);
+	atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&l))[0]);
 	j = target_id;	
 	dev->id[c][j].last_len = l;
 	dev->id[c][j].tran_len = 0;
@@ -761,23 +798,21 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	/*
 	 *	Check transfer direction
 	 */
-	if (workreq->sc_data_direction == DMA_TO_DEVICE) {
-		outb((unsigned char) (j | 0x20), dev->ioport[c] + 0x15);
-	} else {
-		outb(j, dev->ioport[c] + 0x15);
-	}
-	outb((unsigned char) (inb(dev->ioport[c] + 0x16) | 0x80), dev->ioport[c] + 0x16);
-	outb(0x80, dev->ioport[c] + 0x16);
+	if (workreq->sc_data_direction == DMA_TO_DEVICE)
+		atp_writeb_io(dev, c, 0x15, j | 0x20);
+	else
+		atp_writeb_io(dev, c, 0x15, j);
+	atp_writeb_io(dev, c, 0x16, atp_readb_io(dev, c, 0x16) | 0x80);
+	atp_writeb_io(dev, c, 0x16, 0x80);
 	dev->id[c][target_id].dirct = 0;
 	if (l == 0) {
-		if (inb(dev->ioport[c] + 0x1c) == 0) {
+		if (atp_readb_io(dev, c, 0x1c) == 0) {
 #ifdef ED_DBGP
 			printk("change SCSI_CMD_REG 0x08\n");	
 #endif				
-			outb(0x08, dev->ioport[c] + 0x18);
-		} else {
+			atp_writeb_io(dev, c, 0x18, 0x08);
+		} else
 			dev->last_cmd[c] |= 0x40;
-		}
 		dev->in_snd[c] = 0;
 		return;
 	}
@@ -821,36 +856,34 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	printk("send_s870: prdaddr_2 0x%8x target_id %d\n", dev->id[c][target_id].prdaddr,target_id);
 #endif	
 	dev->id[c][target_id].prdaddr = dev->id[c][target_id].prd_bus;
-	outl(dev->id[c][target_id].prdaddr, dev->pciport[c] + 4);
-	outb(0x06, dev->pciport[c] + 2);
-	outb(0x00, dev->pciport[c] + 2);
+	atp_writel_pci(dev, c, 4, dev->id[c][target_id].prdaddr);
+	atp_writeb_pci(dev, c, 2, 0x06);
+	atp_writeb_pci(dev, c, 2, 0x00);
 	if (dev->dev_id == ATP885_DEVID) {
-		j = inb(dev->pciport[c] + 1) & 0xf3;
+		j = atp_readb_pci(dev, c, 1) & 0xf3;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
 	    	(workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 	   		j |= 0x0c;
 		}
-		outb(j, dev->pciport[c] + 1);
+		atp_writeb_pci(dev, c, 1, j);
 	} else if ((dev->dev_id == ATP880_DEVID1) ||
 	    	   (dev->dev_id == ATP880_DEVID2)) {
-		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-			outb((unsigned char) ((inb(dev->ioport[c] - 0x05) & 0x3f) | 0xc0), dev->ioport[c] - 0x05);
-		} else {
-			outb((unsigned char) (inb(dev->ioport[c] - 0x05) & 0x3f), dev->ioport[c] - 0x05);
-		}		
+		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+			atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
+		else
+			atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
 	} else {		
-		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-			outb((inb(dev->ioport[c] + 0x3a) & 0xf3) | 0x08, dev->ioport[c] + 0x3a);
-		} else {
-			outb(inb(dev->ioport[c] + 0x3a) & 0xf3, dev->ioport[c] + 0x3a);
-		}		
+		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+			atp_writeb_io(dev, c, 0x3a, (atp_readb_io(dev, c, 0x3a) & 0xf3) | 0x08);
+		else
+			atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xf3);
 	}	
 
 	if(workreq->sc_data_direction == DMA_TO_DEVICE) {
 		dev->id[c][target_id].dirct = 0x20;
-		if (inb(dev->ioport[c] + 0x1c) == 0) {
-			outb(0x08, dev->ioport[c] + 0x18);
-			outb(0x01, dev->pciport[c]);
+		if (atp_readb_io(dev, c, 0x1c) == 0) {
+			atp_writeb_io(dev, c, 0x18, 0x08);
+			atp_writeb_pci(dev, c, 0, 0x01);
 #ifdef ED_DBGP		
 		printk( "start DMA(to target)\n");
 #endif				
@@ -860,9 +893,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		dev->in_snd[c] = 0;
 		return;
 	}
-	if (inb(dev->ioport[c] + 0x1c) == 0) {
-		outb(0x08, dev->ioport[c] + 0x18);
-		outb(0x09, dev->pciport[c]);
+	if (atp_readb_io(dev, c, 0x1c) == 0) {
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		atp_writeb_pci(dev, c, 0, 0x09);
 #ifdef ED_DBGP		
 		printk( "start DMA(to host)\n");
 #endif			
@@ -879,28 +912,28 @@ static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 	unsigned short int i, k;
 	unsigned char j;
 
-	outw(*val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, *val);
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
-		k = inw(dev->ioport[0] + 0x1c);
+		k = atp_readw_io(dev, 0, 0x1c);
 		j = (unsigned char) (k >> 8);
 		if ((k & 0x8000) != 0)	/* DB7 all release?    */
 			i = 0;
 	}
 	*val |= 0x4000;		/* assert DB6           */
-	outw(*val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, *val);
 	*val &= 0xdfff;		/* assert DB5           */
-	outw(*val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, *val);
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns) */
-		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) != 0)	/* DB5 all release?       */
+		if ((atp_readw_io(dev, 0, 0x1c) & 0x2000) != 0)	/* DB5 all release?       */
 			i = 0;
 	}
 	*val |= 0x8000;		/* no DB4-0, assert DB7    */
 	*val &= 0xe0ff;
-	outw(*val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, *val);
 	*val &= 0xbfff;		/* release DB6             */
-	outw(*val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, *val);
 	for (i = 0; i < 10; i++) {	/* stable >= bus settle delay(400 ns)  */
-		if ((inw(dev->ioport[0] + 0x1c) & 0x4000) != 0)	/* DB6 all release?  */
+		if ((atp_readw_io(dev, 0, 0x1c) & 0x4000) != 0)	/* DB6 all release?  */
 			i = 0;
 	}
 
@@ -926,9 +959,9 @@ static void tscam(struct Scsi_Host *host)
 	}
  */
 
-	outb(0x08, dev->ioport[0] + 1);
-	outb(0x7f, dev->ioport[0] + 2);
-	outb(0x20, dev->ioport[0] + 0x11);
+	atp_writeb_io(dev, 0, 1, 0x08);
+	atp_writeb_io(dev, 0, 2, 0x7f);
+	atp_writeb_io(dev, 0, 0x11, 0x20);
 
 	if ((dev->scam_on & 0x40) == 0) {
 		return;
@@ -941,13 +974,13 @@ static void tscam(struct Scsi_Host *host)
 		j = 8;
 	}
 	assignid_map = m;
-	outb(0x02, dev->ioport[0] + 0x02);	/* 2*2=4ms,3EH 2/32*3E=3.9ms */
-	outb(0, dev->ioport[0] + 0x03);
-	outb(0, dev->ioport[0] + 0x04);
-	outb(0, dev->ioport[0] + 0x05);
-	outb(0, dev->ioport[0] + 0x06);
-	outb(0, dev->ioport[0] + 0x07);
-	outb(0, dev->ioport[0] + 0x08);
+	atp_writeb_io(dev, 0, 0x02, 0x02);	/* 2*2=4ms,3EH 2/32*3E=3.9ms */
+	atp_writeb_io(dev, 0, 0x03, 0);
+	atp_writeb_io(dev, 0, 0x04, 0);
+	atp_writeb_io(dev, 0, 0x05, 0);
+	atp_writeb_io(dev, 0, 0x06, 0);
+	atp_writeb_io(dev, 0, 0x07, 0);
+	atp_writeb_io(dev, 0, 0x08, 0);
 
 	for (i = 0; i < j; i++) {
 		m = 1;
@@ -955,70 +988,69 @@ static void tscam(struct Scsi_Host *host)
 		if ((m & assignid_map) != 0) {
 			continue;
 		}
-		outb(0, dev->ioport[0] + 0x0f);
-		outb(0, dev->ioport[0] + 0x12);
-		outb(0, dev->ioport[0] + 0x13);
-		outb(0, dev->ioport[0] + 0x14);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, 0);
+		atp_writeb_io(dev, 0, 0x14, 0);
 		if (i > 7) {
 			k = (i & 0x07) | 0x40;
 		} else {
 			k = i;
 		}
-		outb(k, dev->ioport[0] + 0x15);
-		if (dev->chip_ver == 4) {
-			outb(0x01, dev->ioport[0] + 0x1b);
-		} else {
-			outb(0x00, dev->ioport[0] + 0x1b);
-		}
+		atp_writeb_io(dev, 0, 0x15, k);
+		if (dev->chip_ver == 4)
+			atp_writeb_io(dev, 0, 0x1b, 0x01);
+		else
+			atp_writeb_io(dev, 0, 0x1b, 0x00);
 		do {
-			outb(0x09, dev->ioport[0] + 0x18);
+			atp_writeb_io(dev, 0, 0x18, 0x09);
 
-			while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0x00)
+			while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 				cpu_relax();
-			k = inb(dev->ioport[0] + 0x17);
+			k = atp_readb_io(dev, 0, 0x17);
 			if ((k == 0x85) || (k == 0x42))
 				break;
 			if (k != 0x16)
-				outb(0x41, dev->ioport[0] + 0x10);
+				atp_writeb_io(dev, 0, 0x10, 0x41);
 		} while (k != 0x16);
 		if ((k == 0x85) || (k == 0x42))
 			continue;
 		assignid_map |= m;
 
 	}
-	outb(0x7f, dev->ioport[0] + 0x02);
-	outb(0x02, dev->ioport[0] + 0x1b);
+	atp_writeb_io(dev, 0, 0x02, 0x7f);
+	atp_writeb_io(dev, 0, 0x1b, 0x02);
 
 	outb(0, 0x80);
 
 	val = 0x0080;		/* bsy  */
-	outw(val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, val);
 	val |= 0x0040;		/* sel  */
-	outw(val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, val);
 	val |= 0x0004;		/* msg  */
-	outw(val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, val);
 	inb(0x80);		/* 2 deskew delay(45ns*2=90ns) */
 	val &= 0x007f;		/* no bsy  */
-	outw(val, dev->ioport[0] + 0x1c);
+	atp_writew_io(dev, 0, 0x1c, val);
 	mdelay(128);
 	val &= 0x00fb;		/* after 1ms no msg */
-	outw(val, dev->ioport[0] + 0x1c);
-	while ((inb(dev->ioport[0] + 0x1c) & 0x04) != 0)
+	atp_writew_io(dev, 0, 0x1c, val);
+	while ((atp_readb_io(dev, 0, 0x1c) & 0x04) != 0)
 		;
 	outb(1, 0x80);
 	udelay(100);
 	for (n = 0; n < 0x30000; n++)
-		if ((inb(dev->ioport[0] + 0x1c) & 0x80) != 0)	/* bsy ? */
+		if ((atp_readb_io(dev, 0, 0x1c) & 0x80) != 0)	/* bsy ? */
 			break;
 	if (n < 0x30000)
 		for (n = 0; n < 0x30000; n++)
-			if ((inb(dev->ioport[0] + 0x1c) & 0x81) == 0x0081) {
+			if ((atp_readb_io(dev, 0, 0x1c) & 0x81) == 0x0081) {
 				inb(0x80);
 				val |= 0x8003;		/* io,cd,db7  */
-				outw(val, dev->ioport[0] + 0x1c);
+				atp_writew_io(dev, 0, 0x1c, val);
 				inb(0x80);
 				val &= 0x00bf;		/* no sel     */
-				outw(val, dev->ioport[0] + 0x1c);
+				atp_writew_io(dev, 0, 0x1c, val);
 				outb(2, 0x80);
 				break;
 			}
@@ -1033,14 +1065,14 @@ static void tscam(struct Scsi_Host *host)
 	 */
 	mdelay(2);
 	udelay(48);
-	if ((inb(dev->ioport[0] + 0x1c) & 0x80) == 0x00) {	/* bsy ? */
-		outw(0, dev->ioport[0] + 0x1c);
-		outb(0, dev->ioport[0] + 0x1b);
-		outb(0, dev->ioport[0] + 0x15);
-		outb(0x09, dev->ioport[0] + 0x18);
-		while ((inb(dev->ioport[0] + 0x1f) & 0x80) == 0)
+	if ((atp_readb_io(dev, 0, 0x1c) & 0x80) == 0x00) {	/* bsy ? */
+		atp_writew_io(dev, 0, 0x1c, 0);
+		atp_writeb_io(dev, 0, 0x1b, 0);
+		atp_writeb_io(dev, 0, 0x15, 0);
+		atp_writeb_io(dev, 0, 0x18, 0x09);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0)
 			cpu_relax();
-		inb(dev->ioport[0] + 0x17);
+		atp_readb_io(dev, 0, 0x17);
 		return;
 	}
 	val &= 0x00ff;		/* synchronization  */
@@ -1055,7 +1087,7 @@ static void tscam(struct Scsi_Host *host)
 	j = 0;
 
 	while (1) {
-		if ((inw(dev->ioport[0] + 0x1c) & 0x2000) == 0)
+		if ((atp_readw_io(dev, 0, 0x1c) & 0x2000) == 0)
 			continue;
 		outb(5, 0x80);
 		val &= 0x00ff;		/* get ID_STRING */
@@ -2232,6 +2264,7 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	base_io = pci_resource_start(pdev, 0);
 	base_io &= 0xfffffff8;
+	atpdev->baseport = base_io;
 
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
 		atpdev->chip_ver = pdev->revision;
@@ -2356,7 +2389,6 @@ flash_ok_880:
         	
 		atpdev->pdev = pdev;
 		atpdev->dev_id  = ent->device;
-		atpdev->baseport = base_io;
 		atpdev->ioport[0] = base_io + 0x80;
 		atpdev->ioport[1] = base_io + 0xc0;
 		atpdev->pciport[0] = base_io + 0x40;
@@ -2651,12 +2683,12 @@ static int atp870u_abort(struct scsi_cmnd * SCpnt)
 	printk("working=%x last_cmd=%x ", dev->working[c], dev->last_cmd[c]);
 	printk(" quhdu=%x quendu=%x ", dev->quhd[c], dev->quend[c]);
 	for (j = 0; j < 0x18; j++) {
-		printk(" r%2x=%2x", j, inb(dev->ioport[c] + j));
+		printk(" r%2x=%2x", j, atp_readb_io(dev, c, j));
 	}
-	printk(" r1c=%2x", inb(dev->ioport[c] + 0x1c));
-	printk(" r1f=%2x in_snd=%2x ", inb(dev->ioport[c] + 0x1f), dev->in_snd[c]);
-	printk(" d00=%2x", inb(dev->pciport[c]));
-	printk(" d02=%2x", inb(dev->pciport[c] + 0x02));
+	printk(" r1c=%2x", atp_readb_io(dev, c, 0x1c));
+	printk(" r1f=%2x in_snd=%2x ", atp_readb_io(dev, c, 0x1f), dev->in_snd[c]);
+	printk(" d00=%2x", atp_readb_pci(dev, c, 0x00));
+	printk(" d02=%2x", atp_readb_pci(dev, c, 0x02));
 	for(j=0;j<16;j++) {
 	   if (dev->id[c][j].curr_req != NULL) {
 		workrequ = dev->id[c][j].curr_req;
-- 
Ondrej Zary

