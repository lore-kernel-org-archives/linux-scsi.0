From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 45/52] atp870u: Introduce is880(), is885() and remove dev_id
Date: Tue, 17 Nov 2015 19:24:21 +0100
Message-ID: <1447784668-23713-46-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56514 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbbKQSgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:38 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Introduce chip type inline functions to simplify code, allowing to delete
dev_id from struct atp_unit.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   70 ++++++++++++++++++++++++++----------------------
 drivers/scsi/atp870u.h |    1 -
 2 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 8af51a9..4bb0f4f 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -103,6 +103,17 @@ static inline u8 atp_readb_pci(struct atp_unit *atp, u8 channel, u8 reg)
 	return inb(atp->pciport[channel] + reg);
 }
 
+static inline bool is880(struct atp_unit *atp)
+{
+	return atp->pdev->device == ATP880_DEVID1 ||
+	       atp->pdev->device == ATP880_DEVID2;
+}
+
+static inline bool is885(struct atp_unit *atp)
+{
+	return atp->pdev->device == ATP885_DEVID;
+}
+
 static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 {
 	unsigned long flags;
@@ -131,7 +142,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	dev->in_int[c] = 1;
 	cmdp = atp_readb_io(dev, c, 0x10);
 	if (dev->working[c] != 0) {
-		if (dev->dev_id == ATP885_DEVID) {
+		if (is885(dev)) {
 			if ((atp_readb_io(dev, c, 0x16) & 0x80) == 0)
 				atp_writeb_io(dev, c, 0x16, (atp_readb_io(dev, c, 0x16) | 0x80));
 		}		
@@ -148,7 +159,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 		
 		i = atp_readb_io(dev, c, 0x17);
 		
-		if (dev->dev_id == ATP885_DEVID)
+		if (is885(dev))
 			atp_writeb_pci(dev, c, 2, 0x06);
 
 		target_id = atp_readb_io(dev, c, 0x15);
@@ -169,7 +180,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 		     }
 		     dev->last_cmd[c] |= 0x40;
 		}
-		if (dev->dev_id == ATP885_DEVID) 
+		if (is885(dev))
 			dev->r1f[c][target_id] |= j;
 #ifdef ED_DBGP
 		printk("atp870u_intr_handle status = %x\n",i);
@@ -178,7 +189,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 			   dev->last_cmd[c] = 0xff;
 			}
-			if (dev->dev_id == ATP885_DEVID) {
+			if (is885(dev)) {
 				adrcnt = 0;
 				((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
 				((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
@@ -249,7 +260,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			return IRQ_HANDLED;
 		}
 
-		if (dev->dev_id == ATP885_DEVID) {
+		if (is885(dev)) {
 			if ((i == 0x4c) || (i == 0x4d) || (i == 0x8c) || (i == 0x8d)) {
 		   		if ((i == 0x4c) || (i == 0x8c)) 
 		      			i=0x48;
@@ -301,7 +312,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			if (dev->last_cmd[c] != 0xff) {
 			   dev->last_cmd[c] |= 0x40;
 			}
-			if (dev->dev_id == ATP885_DEVID) {
+			if (is885(dev)) {
 				j = atp_readb_base(dev, 0x29) & 0xfe;
 				atp_writeb_base(dev, 0x29, j);
 			} else
@@ -316,7 +327,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			} else {
 				target_id &= 0x07;
 			}
-			if (dev->dev_id == ATP885_DEVID)
+			if (is885(dev))
 				atp_writeb_io(dev, c, 0x10, 0x45);
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
@@ -348,15 +359,14 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_io(dev, c, 0x16, 0x80);
 			
 			/* enable 32 bit fifo transfer */	
-			if (dev->dev_id == ATP885_DEVID) {
+			if (is885(dev)) {
 				i = atp_readb_pci(dev, c, 1) & 0xf3;
 				//j=workreq->cmnd[0];	    		    	
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 				   i |= 0x0c;
 				}
 				atp_writeb_pci(dev, c, 1, i);
-			} else if ((dev->dev_id == ATP880_DEVID1) ||
-	    		    	   (dev->dev_id == ATP880_DEVID2) ) {
+			} else if (is880(dev)) {
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
 					atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
 				else
@@ -417,7 +427,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 #ifdef ED_DBGP
 			printk("dev->id[%d][%d].prdaddr 0x%8x\n", c, target_id, dev->id[c][target_id].prdaddr);
 #endif
-			if (dev->dev_id != ATP885_DEVID) {
+			if (!is885(dev)) {
 				atp_writeb_pci(dev, c, 2, 0x06);
 				atp_writeb_pci(dev, c, 2, 0x00);
 			}
@@ -454,14 +464,14 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			}
 			if (i == 0x16) {
 				workreq->result = atp_readb_io(dev, c, 0x0f);
-				if (((dev->r1f[c][target_id] & 0x10) != 0)&&(dev->dev_id==ATP885_DEVID)) {
+				if (((dev->r1f[c][target_id] & 0x10) != 0) && is885(dev)) {
 					printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
 					workreq->result = 0x02;
 				}
 			} else
 				workreq->result = 0x02;
 
-			if (dev->dev_id == ATP885_DEVID) {		
+			if (is885(dev)) {
 				j = atp_readb_base(dev, 0x29) | 0x01;
 				atp_writeb_base(dev, 0x29, j);
 			}
@@ -516,7 +526,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_pci(dev, c, 2, 0x06);
 			atp_writeb_pci(dev, c, 2, 0x00);
 			atp_writeb_io(dev, c, 0x10, 0x41);
-			if (dev->dev_id == ATP885_DEVID) {
+			if (is885(dev)) {
 				k = dev->id[c][target_id].last_len;
 				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
 				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
@@ -535,7 +545,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_pci(dev, c, 2, 0x06);
 			atp_writeb_pci(dev, c, 2, 0x00);
 			atp_writeb_io(dev, c, 0x10, 0x41);
-			if (dev->dev_id == ATP885_DEVID) {		
+			if (is885(dev)) {
 				k = dev->id[c][target_id].last_len;
 				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
 				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
@@ -737,7 +747,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 #endif	
 	l = scsi_bufflen(workreq);
 
-	if (dev->dev_id == ATP885_DEVID) {
+	if (is885(dev)) {
 		j = atp_readb_base(dev, 0x29) & 0xfe;
 		atp_writeb_base(dev, 0x29, j);
 		dev->r1f[c][scmd_id(workreq)] = 0;
@@ -775,7 +785,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 
 	atp_writeb_io(dev, c, 0x00, workreq->cmd_len);
 	atp_writeb_io(dev, c, 0x01, 0x2c);
-	if (dev->dev_id == ATP885_DEVID)
+	if (is885(dev))
 		atp_writeb_io(dev, c, 0x02, 0x7f);
 	else
 		atp_writeb_io(dev, c, 0x02, 0xcf);
@@ -873,15 +883,14 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	atp_writel_pci(dev, c, 4, dev->id[c][target_id].prdaddr);
 	atp_writeb_pci(dev, c, 2, 0x06);
 	atp_writeb_pci(dev, c, 2, 0x00);
-	if (dev->dev_id == ATP885_DEVID) {
+	if (is885(dev)) {
 		j = atp_readb_pci(dev, c, 1) & 0xf3;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
 	    	(workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
 	   		j |= 0x0c;
 		}
 		atp_writeb_pci(dev, c, 1, j);
-	} else if ((dev->dev_id == ATP880_DEVID1) ||
-	    	   (dev->dev_id == ATP880_DEVID2)) {
+	} else if (is880(dev)) {
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
 			atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
 		else
@@ -1285,7 +1294,7 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	shpnt->unique_id = shpnt->io_port;
 	shpnt->irq = pdev->irq;
 
-	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
+	if (is880(atpdev)) {
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
 		atpdev->ioport[0] = shpnt->io_port + 0x40;
@@ -1296,7 +1305,6 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter:"
 			"    IO:%lx, IRQ:%d.\n", shpnt->io_port, shpnt->irq);
-		atpdev->dev_id = ent->device;
 		atpdev->host_id[0] = host_id;
 
 		atpdev->scam_on = atp_readb_base(atpdev, 0x22);
@@ -1384,12 +1392,11 @@ flash_ok_880:
 		atp_writeb_base(atpdev, 0x38, 0xb0);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
-	} else if (ent->device == ATP885_DEVID) {	
+	} else if (is885(atpdev)) {
 			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%lx, IRQ:%d.\n"
 			       , shpnt->io_port, shpnt->irq);
         	
 		atpdev->pdev = pdev;
-		atpdev->dev_id  = ent->device;
 		atpdev->ioport[0] = shpnt->io_port + 0x80;
 		atpdev->ioport[1] = shpnt->io_port + 0xc0;
 		atpdev->pciport[0] = shpnt->io_port + 0x40;
@@ -1528,7 +1535,6 @@ flash_ok_885:
 
 		atpdev->ioport[0] = shpnt->io_port;
 		atpdev->pciport[0] = shpnt->io_port + 0x20;
-		atpdev->dev_id = ent->device;
 		host_id &= 0x07;
 		atpdev->host_id[0] = host_id;
 		atpdev->scam_on = atp_readb_pci(atpdev, 0, 2);
@@ -1797,7 +1803,7 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 		dev->active_id[c] |= m;
 
 		atp_writeb_io(dev, c, 0x10, 0x30);
-		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+		if (is885(dev) || is880(dev))
 			atp_writeb_io(dev, c, 0x14, 0x00);
 		else /* result of is870() merge - is this a bug? */
 			atp_writeb_io(dev, c, 0x04, 0x00);
@@ -1877,7 +1883,7 @@ inq_ok:
 		if ((mbuf[7] & 0x60) == 0) {
 			goto not_wide;
 		}
-		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+		if (is885(dev) || is880(dev)) {
 			if ((i < 8) && ((dev->global_map[c] & 0x20) == 0))
 				goto not_wide;
 		} else { /* result of is870() merge - is this a bug? */
@@ -2146,7 +2152,7 @@ not_wide:
 		}
 		continue;
 set_sync:
-		if ((dev->dev_id != ATP885_DEVID && dev->dev_id != ATP880_DEVID1 && dev->dev_id != ATP880_DEVID2) || (dev->sp[c][i] == 0x02)) {
+		if ((!is885(dev) && !is880(dev)) || (dev->sp[c][i] == 0x02)) {
 			synu[4] = 0x0c;
 			synuw[4] = 0x0c;
 		} else {
@@ -2190,7 +2196,7 @@ try_sync:
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
 			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[c]) != 0) {
-					if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+					if (is885(dev) || is880(dev)) {
 						if ((m & dev->ultra_map[c]) != 0) {
 							atp_writeb_io(dev, c, 0x19, synuw[j++]);
 						} else {
@@ -2245,7 +2251,7 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+		if (is885(dev) || is880(dev))
 			atp_writeb_io(dev, c, 0x14, 0x06);
 		else
 			atp_writeb_io(dev, c, 0x14, 0xff);
@@ -2303,7 +2309,7 @@ tar_dcons:
 		if (mbuf[3] > 0x64) {
 			continue;
 		}
-		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+		if (is885(dev) || is880(dev)) {
 			if (mbuf[4] > 0x0e) {
 				mbuf[4] = 0x0e;
 			}
@@ -2313,7 +2319,7 @@ tar_dcons:
 			}
 		}
 		dev->id[c][i].devsp = mbuf[4];
-		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+		if (is885(dev) || is880(dev))
 			if (mbuf[3] < 0x0c) {
 				j = 0xb0;
 				goto set_syn_ok;
diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index 8c47c53..f9d62a2 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -39,7 +39,6 @@ struct atp_unit
 	unsigned short active_id[2];
 	unsigned short ultra_map[2];
 	unsigned short async[2];
-	unsigned short dev_id;
 	unsigned char sp[2][16];
 	unsigned char r1f[2][16];		
 	struct scsi_cmnd *quereq[2][qcnt];
-- 
Ondrej Zary

