Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9746DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E5C2339F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbhAMJGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:06:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:53812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbhAMJGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 04:06:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A22AAB73C;
        Wed, 13 Jan 2021 09:05:03 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/35] atp870u: Whitespace cleanup
Date:   Wed, 13 Jan 2021 10:04:30 +0100
Message-Id: <20210113090500.129644-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113090500.129644-1-hare@suse.de>
References: <20210113090500.129644-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/atp870u.c | 431 ++++++++++++++++++++++++-----------------
 drivers/scsi/atp870u.h |  14 +-
 2 files changed, 258 insertions(+), 187 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index c6a752309dda..e559baeb0329 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -42,7 +42,8 @@
 
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
-static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode);
+static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip,
+		   unsigned char lvdmode);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
 {
@@ -137,16 +138,17 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 	}
 	if ((j & 0x80) == 0)
 		return IRQ_NONE;
-#ifdef ED_DBGP	
+#ifdef ED_DBGP
 	printk("atp870u_intr_handle enter\n");
-#endif	
+#endif
 	dev->in_int[c] = 1;
 	cmdp = atp_readb_io(dev, c, 0x10);
 	if (dev->working[c] != 0) {
 		if (is885(dev)) {
 			if ((atp_readb_io(dev, c, 0x16) & 0x80) == 0)
-				atp_writeb_io(dev, c, 0x16, (atp_readb_io(dev, c, 0x16) | 0x80));
-		}		
+				atp_writeb_io(dev, c, 0x16,
+					      (atp_readb_io(dev, c, 0x16) | 0x80));
+		}
 		if ((atp_readb_pci(dev, c, 0x00) & 0x08) != 0)
 		{
 			for (k=0; k < 1000; k++) {
@@ -157,9 +159,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			}
 		}
 		atp_writeb_pci(dev, c, 0, 0x00);
-		
+
 		i = atp_readb_io(dev, c, 0x17);
-		
+
 		if (is885(dev))
 			atp_writeb_pci(dev, c, 2, 0x06);
 
@@ -185,44 +187,51 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			dev->r1f[c][target_id] |= j;
 #ifdef ED_DBGP
 		printk("atp870u_intr_handle status = %x\n",i);
-#endif	
+#endif
 		if (i == 0x85) {
 			if ((dev->last_cmd[c] & 0xf0) != 0x40) {
 			   dev->last_cmd[c] = 0xff;
 			}
 			if (is885(dev)) {
 				adrcnt = 0;
-				((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
-				((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
-				((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
+				((unsigned char *) &adrcnt)[2] =
+					atp_readb_io(dev, c, 0x12);
+				((unsigned char *) &adrcnt)[1] =
+					atp_readb_io(dev, c, 0x13);
+				((unsigned char *) &adrcnt)[0] =
+					atp_readb_io(dev, c, 0x14);
 				if (dev->id[c][target_id].last_len != adrcnt) {
 					k = dev->id[c][target_id].last_len;
-			   		k -= adrcnt;
-			   		dev->id[c][target_id].tran_len = k;			   
+					k -= adrcnt;
+					dev->id[c][target_id].tran_len = k;
 					dev->id[c][target_id].last_len = adrcnt;
 				}
 #ifdef ED_DBGP
-				printk("dev->id[c][target_id].last_len = %d dev->id[c][target_id].tran_len = %d\n",dev->id[c][target_id].last_len,dev->id[c][target_id].tran_len);
-#endif		
+				printk("dev->id[c][target_id].last_len = %d "
+				       "dev->id[c][target_id].tran_len = %d\n",
+				       dev->id[c][target_id].last_len,
+				       dev->id[c][target_id].tran_len);
+#endif
 			}
 
 			/*
 			 *      Flip wide
-			 */			
+			 */
 			if (dev->wide_id[c] != 0) {
 				atp_writeb_io(dev, c, 0x1b, 0x01);
 				while ((atp_readb_io(dev, c, 0x1b) & 0x01) != 0x01)
 					atp_writeb_io(dev, c, 0x1b, 0x01);
-			}		
+			}
 			/*
 			 *	Issue more commands
 			 */
-			spin_lock_irqsave(dev->host->host_lock, flags);			 			 
-			if (((dev->quhd[c] != dev->quend[c]) || (dev->last_cmd[c] != 0xff)) &&
+			spin_lock_irqsave(dev->host->host_lock, flags);
+			if (((dev->quhd[c] != dev->quend[c]) ||
+			     (dev->last_cmd[c] != 0xff)) &&
 			    (dev->in_snd[c] == 0)) {
 #ifdef ED_DBGP
 				printk("Call sent_s870\n");
-#endif				
+#endif
 				send_s870(dev,c);
 			}
 			spin_unlock_irqrestore(dev->host->host_lock, flags);
@@ -232,7 +241,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("Status 0x85 return\n");
-#endif				
+#endif
 			return IRQ_HANDLED;
 		}
 
@@ -247,9 +256,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			   dev->last_cmd[c] = 0xff;
 			}
 			adrcnt = 0;
-			((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
-			((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
-			((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
+			((unsigned char *) &adrcnt)[2] =
+				atp_readb_io(dev, c, 0x12);
+			((unsigned char *) &adrcnt)[1] =
+				atp_readb_io(dev, c, 0x13);
+			((unsigned char *) &adrcnt)[0] =
+				atp_readb_io(dev, c, 0x14);
 			k = dev->id[c][target_id].last_len;
 			k -= adrcnt;
 			dev->id[c][target_id].tran_len = k;
@@ -262,17 +274,16 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 
 		if (is885(dev)) {
 			if ((i == 0x4c) || (i == 0x4d) || (i == 0x8c) || (i == 0x8d)) {
-		   		if ((i == 0x4c) || (i == 0x8c)) 
-		      			i=0x48;
-		   		else 
-		      			i=0x49;
-		   	}	
-			
+				if ((i == 0x4c) || (i == 0x8c))
+					i=0x48;
+				else
+					i=0x49;
+			}
 		}
 		if ((i == 0x80) || (i == 0x8f)) {
 #ifdef ED_DBGP
 			printk(KERN_DEBUG "Device reselect\n");
-#endif			
+#endif
 			lun = 0;
 			if (cmdp == 0x44 || i == 0x80)
 				lun = atp_readb_io(dev, c, 0x1d) & 0x07;
@@ -283,11 +294,14 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				if (cmdp == 0x41) {
 #ifdef ED_DBGP
 					printk("cmdp = 0x41\n");
-#endif						
+#endif
 					adrcnt = 0;
-					((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
-					((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
-					((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
+					((unsigned char *) &adrcnt)[2] =
+						atp_readb_io(dev, c, 0x12);
+					((unsigned char *) &adrcnt)[1] =
+						atp_readb_io(dev, c, 0x13);
+					((unsigned char *) &adrcnt)[0] =
+						atp_readb_io(dev, c, 0x14);
 					k = dev->id[c][target_id].last_len;
 					k -= adrcnt;
 					dev->id[c][target_id].tran_len = k;
@@ -298,7 +312,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				} else {
 #ifdef ED_DBGP
 					printk("cmdp != 0x41\n");
-#endif						
+#endif
 					atp_writeb_io(dev, c, 0x10, 0x46);
 					dev->id[c][target_id].dirct = 0x00;
 					atp_writeb_io(dev, c, 0x12, 0x00);
@@ -330,13 +344,13 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			if (is885(dev))
 				atp_writeb_io(dev, c, 0x10, 0x45);
 			workreq = dev->id[c][target_id].curr_req;
-#ifdef ED_DBGP			
+#ifdef ED_DBGP
 			scmd_printk(KERN_DEBUG, workreq, "CDB");
 			for (l = 0; l < workreq->cmd_len; l++)
 				printk(KERN_DEBUG " %x",workreq->cmnd[l]);
 			printk("\n");
-#endif	
-			
+#endif
+
 			atp_writeb_io(dev, c, 0x0f, lun);
 			atp_writeb_io(dev, c, 0x11, dev->id[c][target_id].devsp);
 			adrcnt = dev->id[c][target_id].tran_len;
@@ -345,9 +359,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_io(dev, c, 0x12, ((unsigned char *) &k)[2]);
 			atp_writeb_io(dev, c, 0x13, ((unsigned char *) &k)[1]);
 			atp_writeb_io(dev, c, 0x14, ((unsigned char *) &k)[0]);
-#ifdef ED_DBGP			
-			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k, atp_readb_io(dev, c, 0x14), atp_readb_io(dev, c, 0x13), atp_readb_io(dev, c, 0x12));
-#endif			
+#ifdef ED_DBGP
+			printk("k %x, k[0] 0x%x k[1] 0x%x k[2] 0x%x\n", k,
+			       atp_readb_io(dev, c, 0x14),
+			       atp_readb_io(dev, c, 0x13),
+			       atp_readb_io(dev, c, 0x12));
+#endif
 			/* Remap wide */
 			j = target_id;
 			if (target_id > 7) {
@@ -357,26 +374,39 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			j |= dev->id[c][target_id].dirct;
 			atp_writeb_io(dev, c, 0x15, j);
 			atp_writeb_io(dev, c, 0x16, 0x80);
-			
-			/* enable 32 bit fifo transfer */	
+
+			/* enable 32 bit fifo transfer */
 			if (is885(dev)) {
 				i = atp_readb_pci(dev, c, 1) & 0xf3;
-				//j=workreq->cmnd[0];	    		    	
-				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
+				//j=workreq->cmnd[0];
+				if ((workreq->cmnd[0] == 0x08) ||
+				    (workreq->cmnd[0] == 0x28) ||
+				    (workreq->cmnd[0] == 0x0a) ||
+				    (workreq->cmnd[0] == 0x2a)) {
 				   i |= 0x0c;
 				}
 				atp_writeb_pci(dev, c, 1, i);
 			} else if (is880(dev)) {
-				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-					atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
+				if ((workreq->cmnd[0] == 0x08) ||
+				    (workreq->cmnd[0] == 0x28) ||
+				    (workreq->cmnd[0] == 0x0a) ||
+				    (workreq->cmnd[0] == 0x2a))
+					atp_writeb_base(dev, 0x3b,
+							(atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
 				else
-					atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
-			} else {				
-				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-					atp_writeb_base(dev, 0x3a, (atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
+					atp_writeb_base(dev, 0x3b,
+							atp_readb_base(dev, 0x3b) & 0x3f);
+			} else {
+				if ((workreq->cmnd[0] == 0x08) ||
+				    (workreq->cmnd[0] == 0x28) ||
+				    (workreq->cmnd[0] == 0x0a) ||
+				    (workreq->cmnd[0] == 0x2a))
+					atp_writeb_base(dev, 0x3a,
+							(atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
 				else
-					atp_writeb_base(dev, 0x3a, atp_readb_base(dev, 0x3a) & 0xf3);
-			}	
+					atp_writeb_base(dev, 0x3a,
+							atp_readb_base(dev, 0x3a) & 0xf3);
+			}
 			j = 0;
 			id = 1;
 			id = id << target_id;
@@ -394,12 +424,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("dev->id[c][target_id].last_len = 0\n");
-#endif					
+#endif
 				return IRQ_HANDLED;
 			}
 #ifdef ED_DBGP
 			printk("target_id = %d adrcnt = %d\n",target_id,adrcnt);
-#endif			
+#endif
 			prd = dev->id[c][target_id].prd_pos;
 			while (adrcnt != 0) {
 				id = ((unsigned short int *)prd)[2];
@@ -409,8 +439,8 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 					k = id;
 				}
 				if (k > adrcnt) {
-					((unsigned short int *)prd)[2] = (unsigned short int)
-					    (k - adrcnt);
+					((unsigned short int *)prd)[2] =
+						(unsigned short int)(k - adrcnt);
 					((unsigned long *)prd)[0] += adrcnt;
 					adrcnt = 0;
 					dev->id[c][target_id].prd_pos = prd;
@@ -421,11 +451,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 					if (adrcnt == 0) {
 						dev->id[c][target_id].prd_pos = prd;
 					}
-				}				
+				}
 			}
 			atp_writel_pci(dev, c, 0x04, dev->id[c][target_id].prdaddr);
 #ifdef ED_DBGP
-			printk("dev->id[%d][%d].prdaddr 0x%8x\n", c, target_id, dev->id[c][target_id].prdaddr);
+			printk("dev->id[%d][%d].prdaddr 0x%8x\n",
+			       c, target_id, dev->id[c][target_id].prdaddr);
 #endif
 			if (!is885(dev)) {
 				atp_writeb_pci(dev, c, 2, 0x06);
@@ -440,7 +471,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				dev->in_int[c] = 0;
 #ifdef ED_DBGP
 				printk("status 0x80 return dirct != 0\n");
-#endif				
+#endif
 				return IRQ_HANDLED;
 			}
 			atp_writeb_io(dev, c, 0x18, 0x08);
@@ -448,7 +479,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
 			printk("status 0x80 return dirct = 0\n");
-#endif			
+#endif
 			return IRQ_HANDLED;
 		}
 
@@ -484,7 +515,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			(*workreq->scsi_done) (workreq);
 #ifdef ED_DBGP
 			   printk("workreq->scsi_done\n");
-#endif	
+#endif
 			/*
 			 *	Clear it off the queue
 			 */
@@ -498,16 +529,17 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				atp_writeb_io(dev, c, 0x1b, 0x01);
 				while ((atp_readb_io(dev, c, 0x1b) & 0x01) != 0x01)
 					atp_writeb_io(dev, c, 0x1b, 0x01);
-			} 
+			}
 			/*
 			 *	If there is stuff to send and nothing going then send it
 			 */
 			spin_lock_irqsave(dev->host->host_lock, flags);
-			if (((dev->last_cmd[c] != 0xff) || (dev->quhd[c] != dev->quend[c])) &&
+			if (((dev->last_cmd[c] != 0xff) ||
+			     (dev->quhd[c] != dev->quend[c])) &&
 			    (dev->in_snd[c] == 0)) {
 #ifdef ED_DBGP
 			   printk("Call sent_s870(scsi_done)\n");
-#endif				   
+#endif
 			   send_s870(dev,c);
 			}
 			spin_unlock_irqrestore(dev->host->host_lock, flags);
@@ -528,9 +560,12 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_io(dev, c, 0x10, 0x41);
 			if (is885(dev)) {
 				k = dev->id[c][target_id].last_len;
-				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
-				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
-				atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&k))[0]);
+				atp_writeb_io(dev, c, 0x12,
+					      ((unsigned char *) (&k))[2]);
+				atp_writeb_io(dev, c, 0x13,
+					      ((unsigned char *) (&k))[1]);
+				atp_writeb_io(dev, c, 0x14,
+					      ((unsigned char *) (&k))[0]);
 				dev->id[c][target_id].dirct = 0x00;
 			} else {
 				dev->id[c][target_id].dirct = 0x00;
@@ -547,11 +582,15 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			atp_writeb_io(dev, c, 0x10, 0x41);
 			if (is885(dev)) {
 				k = dev->id[c][target_id].last_len;
-				atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&k))[2]);
-				atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&k))[1]);
-				atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&k))[0]);
+				atp_writeb_io(dev, c, 0x12,
+					      ((unsigned char *) (&k))[2]);
+				atp_writeb_io(dev, c, 0x13,
+					      ((unsigned char *) (&k))[1]);
+				atp_writeb_io(dev, c, 0x14,
+					      ((unsigned char *) (&k))[0]);
 			}
-			atp_writeb_io(dev, c, 0x15, atp_readb_io(dev, c, 0x15) | 0x20);
+			atp_writeb_io(dev, c, 0x15,
+				      atp_readb_io(dev, c, 0x15) | 0x20);
 			dev->id[c][target_id].dirct = 0x20;
 			atp_writeb_io(dev, c, 0x18, 0x08);
 			atp_writeb_pci(dev, c, 0, 0x01);
@@ -593,17 +632,15 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
 		done(req_p);
-#ifdef ED_DBGP		
-		printk("atp870u_queuecommand : req_p->device->channel > 1\n");	
-#endif			
+#ifdef ED_DBGP
+		printk("atp870u_queuecommand : req_p->device->channel > 1\n");
+#endif
 		return 0;
 	}
 
 	host = req_p->device->host;
 	dev = (struct atp_unit *)&host->hostdata;
-		
 
-		
 	m = 1;
 	m = m << scmd_id(req_p);
 
@@ -620,14 +657,14 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	if (done) {
 		req_p->scsi_done = done;
 	} else {
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk( "atp870u_queuecommand: done can't be NULL\n");
-#endif		
+#endif
 		req_p->result = 0;
 		done(req_p);
 		return 0;
 	}
-	
+
 	/*
 	 *	Count new command
 	 */
@@ -635,7 +672,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	if (dev->quend[c] >= qcnt) {
 		dev->quend[c] = 0;
 	}
-	
+
 	/*
 	 *	Check queue state
 	 */
@@ -643,27 +680,32 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 		if (dev->quend[c] == 0) {
 			dev->quend[c] = qcnt;
 		}
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk("atp870u_queuecommand : dev->quhd[c] == dev->quend[c]\n");
-#endif		
+#endif
 		dev->quend[c]--;
 		req_p->result = 0x00020000;
-		done(req_p);	
+		done(req_p);
 		return 0;
 	}
 	dev->quereq[c][dev->quend[c]] = req_p;
-#ifdef ED_DBGP	
-	printk("dev->ioport[c] = %x atp_readb_io(dev, c, 0x1c) = %x dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",dev->ioport[c],atp_readb_io(dev, c, 0x1c),c,dev->in_int[c],c,dev->in_snd[c]);
+#ifdef ED_DBGP
+	printk("dev->ioport[c] = %x atp_readb_io(dev, c, 0x1c) = %x "
+	       "dev->in_int[%d] = %d dev->in_snd[%d] = %d\n",
+	       dev->ioport[c], atp_readb_io(dev, c, 0x1c), c,
+	       dev->in_int[c],c,dev->in_snd[c]);
 #endif
-	if ((atp_readb_io(dev, c, 0x1c) == 0) && (dev->in_int[c] == 0) && (dev->in_snd[c] == 0)) {
+	if ((atp_readb_io(dev, c, 0x1c) == 0) &&
+	    (dev->in_int[c] == 0) &&
+	    (dev->in_snd[c] == 0)) {
 #ifdef ED_DBGP
 		printk("Call sent_s870(atp870u_queuecommand)\n");
-#endif		
+#endif
 		send_s870(dev,c);
 	}
-#ifdef ED_DBGP	
+#ifdef ED_DBGP
 	printk("atp870u_queuecommand : exit\n");
-#endif	
+#endif
 	return 0;
 }
 
@@ -674,7 +716,7 @@ static DEF_SCSI_QCMD(atp870u_queuecommand)
  *	@host: host
  *
  *	On entry there is work queued to be done. We move some of that work to the
- *	controller itself. 
+ *	controller itself.
  *
  *	Caller holds the host lock.
  */
@@ -689,7 +731,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	unsigned long  sg_count;
 
 	if (dev->in_snd[c] != 0) {
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk("cmnd in_snd\n");
 #endif
 		return;
@@ -729,7 +771,8 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		dev->id[c][scmd_id(workreq)].curr_req = workreq;
 		dev->last_cmd[c] = scmd_id(workreq);
 	}
-	if ((atp_readb_io(dev, c, 0x1f) & 0xb0) != 0 || atp_readb_io(dev, c, 0x1c) != 0) {
+	if ((atp_readb_io(dev, c, 0x1f) & 0xb0) != 0 ||
+	    atp_readb_io(dev, c, 0x1c) != 0) {
 #ifdef ED_DBGP
 		printk("Abort to Send\n");
 #endif
@@ -744,7 +787,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		printk(" %x",workreq->cmnd[i]);
 	}
 	printk("\n");
-#endif	
+#endif
 	l = scsi_bufflen(workreq);
 
 	if (is885(dev)) {
@@ -752,7 +795,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		atp_writeb_base(dev, 0x29, j);
 		dev->r1f[c][scmd_id(workreq)] = 0;
 	}
-	
+
 	if (workreq->cmnd[0] == READ_CAPACITY) {
 		if (l > 8)
 			l = 8;
@@ -796,8 +839,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	 *	Write the target
 	 */
 	atp_writeb_io(dev, c, 0x11, dev->id[c][target_id].devsp);
-#ifdef ED_DBGP	
-	printk("dev->id[%d][%d].devsp = %2x\n",c,target_id,dev->id[c][target_id].devsp);
+#ifdef ED_DBGP
+	printk("dev->id[%d][%d].devsp = %2x\n",c,target_id,
+	       dev->id[c][target_id].devsp);
 #endif
 
 	sg_count = scsi_dma_map(workreq);
@@ -807,12 +851,12 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	atp_writeb_io(dev, c, 0x12, ((unsigned char *) (&l))[2]);
 	atp_writeb_io(dev, c, 0x13, ((unsigned char *) (&l))[1]);
 	atp_writeb_io(dev, c, 0x14, ((unsigned char *) (&l))[0]);
-	j = target_id;	
+	j = target_id;
 	dev->id[c][j].last_len = l;
 	dev->id[c][j].tran_len = 0;
-#ifdef ED_DBGP	
+#ifdef ED_DBGP
 	printk("dev->id[%2d][%2d].last_len = %d\n",c,j,dev->id[c][j].last_len);
-#endif	
+#endif
 	/*
 	 *	Flip the wide bits
 	 */
@@ -832,8 +876,8 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	if (l == 0) {
 		if (atp_readb_io(dev, c, 0x1c) == 0) {
 #ifdef ED_DBGP
-			printk("change SCSI_CMD_REG 0x08\n");	
-#endif				
+			printk("change SCSI_CMD_REG 0x08\n");
+#endif
 			atp_writeb_io(dev, c, 0x18, 0x08);
 		} else
 			dev->last_cmd[c] |= 0x40;
@@ -854,9 +898,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		scsi_for_each_sg(workreq, sgpnt, sg_count, j) {
 			bttl = sg_dma_address(sgpnt);
 			l=sg_dma_len(sgpnt);
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 			printk("1. bttl %x, l %x\n",bttl, l);
-#endif			
+#endif
 			while (l > 0x10000) {
 				(((u16 *) (prd))[i + 3]) = 0x0000;
 				(((u16 *) (prd))[i + 2]) = 0x0000;
@@ -868,17 +912,22 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 			(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
 			(((u16 *) (prd))[i + 2]) = cpu_to_le16(l);
 			(((u16 *) (prd))[i + 3]) = 0;
-			i += 0x04;			
+			i += 0x04;
 		}
-		(((u16 *) (prd))[i - 1]) = cpu_to_le16(0x8000);	
-#ifdef ED_DBGP		
-		printk("prd %4x %4x %4x %4x\n",(((unsigned short int *)prd)[0]),(((unsigned short int *)prd)[1]),(((unsigned short int *)prd)[2]),(((unsigned short int *)prd)[3]));
+		(((u16 *) (prd))[i - 1]) = cpu_to_le16(0x8000);
+#ifdef ED_DBGP
+		printk("prd %4x %4x %4x %4x\n",
+		       (((unsigned short int *)prd)[0]),
+		       (((unsigned short int *)prd)[1]),
+		       (((unsigned short int *)prd)[2]),
+		       (((unsigned short int *)prd)[3]));
 		printk("2. bttl %x, l %x\n",bttl, l);
-#endif			
+#endif
 	}
-#ifdef ED_DBGP		
-	printk("send_s870: prdaddr_2 0x%8x target_id %d\n", dev->id[c][target_id].prdaddr,target_id);
-#endif	
+#ifdef ED_DBGP
+	printk("send_s870: prdaddr_2 0x%8x target_id %d\n",
+	       dev->id[c][target_id].prdaddr,target_id);
+#endif
 	dev->id[c][target_id].prdaddr = dev->id[c][target_id].prd_bus;
 	atp_writel_pci(dev, c, 4, dev->id[c][target_id].prdaddr);
 	atp_writeb_pci(dev, c, 2, 0x06);
@@ -886,30 +935,36 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	if (is885(dev)) {
 		j = atp_readb_pci(dev, c, 1) & 0xf3;
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
-	    	(workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
-	   		j |= 0x0c;
+		    (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a)) {
+			j |= 0x0c;
 		}
 		atp_writeb_pci(dev, c, 1, j);
 	} else if (is880(dev)) {
-		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-			atp_writeb_base(dev, 0x3b, (atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
+		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
+		    (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+			atp_writeb_base(dev, 0x3b,
+					(atp_readb_base(dev, 0x3b) & 0x3f) | 0xc0);
 		else
-			atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
-	} else {		
-		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-			atp_writeb_base(dev, 0x3a, (atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
+			atp_writeb_base(dev, 0x3b,
+					atp_readb_base(dev, 0x3b) & 0x3f);
+	} else {
+		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) ||
+		    (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
+			atp_writeb_base(dev, 0x3a,
+					(atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
 		else
-			atp_writeb_base(dev, 0x3a, atp_readb_base(dev, 0x3a) & 0xf3);
-	}	
+			atp_writeb_base(dev, 0x3a,
+					atp_readb_base(dev, 0x3a) & 0xf3);
+	}
 
 	if(workreq->sc_data_direction == DMA_TO_DEVICE) {
 		dev->id[c][target_id].dirct = 0x20;
 		if (atp_readb_io(dev, c, 0x1c) == 0) {
 			atp_writeb_io(dev, c, 0x18, 0x08);
 			atp_writeb_pci(dev, c, 0, 0x01);
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk( "start DMA(to target)\n");
-#endif				
+#endif
 		} else {
 			dev->last_cmd[c] |= 0x40;
 		}
@@ -919,9 +974,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	if (atp_readb_io(dev, c, 0x1c) == 0) {
 		atp_writeb_io(dev, c, 0x18, 0x08);
 		atp_writeb_pci(dev, c, 0, 0x09);
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk( "start DMA(to host)\n");
-#endif			
+#endif
 	} else {
 		dev->last_cmd[c] |= 0x40;
 	}
@@ -1193,7 +1248,9 @@ static void atp870u_free_tables(struct Scsi_Host *host)
 		for (k = 0; k < 16; k++) {
 			if (!atp_dev->id[j][k].prd_table)
 				continue;
-			dma_free_coherent(&atp_dev->pdev->dev, 1024, atp_dev->id[j][k].prd_table, atp_dev->id[j][k].prd_bus);
+			dma_free_coherent(&atp_dev->pdev->dev, 1024,
+					  atp_dev->id[j][k].prd_table,
+					  atp_dev->id[j][k].prd_bus);
 			atp_dev->id[j][k].prd_table = NULL;
 		}
 	}
@@ -1204,35 +1261,38 @@ static int atp870u_init_tables(struct Scsi_Host *host)
 	struct atp_unit *atp_dev = (struct atp_unit *)&host->hostdata;
 	int c,k;
 	for(c=0;c < 2;c++) {
-	   	for(k=0;k<16;k++) {
-				atp_dev->id[c][k].prd_table = dma_alloc_coherent(&atp_dev->pdev->dev, 1024, &(atp_dev->id[c][k].prd_bus), GFP_KERNEL);
-	   			if (!atp_dev->id[c][k].prd_table) {
-	   				printk("atp870u_init_tables fail\n");
+		for(k=0;k<16;k++) {
+			atp_dev->id[c][k].prd_table =
+				dma_alloc_coherent(&atp_dev->pdev->dev, 1024,
+						   &(atp_dev->id[c][k].prd_bus),
+						   GFP_KERNEL);
+			if (!atp_dev->id[c][k].prd_table) {
+				printk("atp870u_init_tables fail\n");
 				atp870u_free_tables(host);
 				return -ENOMEM;
 			}
 			atp_dev->id[c][k].prdaddr = atp_dev->id[c][k].prd_bus;
 			atp_dev->id[c][k].devsp=0x20;
 			atp_dev->id[c][k].devtype = 0x7f;
-			atp_dev->id[c][k].curr_req = NULL;			   
-	   	}
-	   			
-	   	atp_dev->active_id[c] = 0;
-	   	atp_dev->wide_id[c] = 0;
-	   	atp_dev->host_id[c] = 0x07;
-	   	atp_dev->quhd[c] = 0;
-	   	atp_dev->quend[c] = 0;
-	   	atp_dev->last_cmd[c] = 0xff;
-	   	atp_dev->in_snd[c] = 0;
-	   	atp_dev->in_int[c] = 0;
-	   	
-	   	for (k = 0; k < qcnt; k++) {
-	   		  atp_dev->quereq[c][k] = NULL;
-	   	}	   		   
-	   	for (k = 0; k < 16; k++) {
+			atp_dev->id[c][k].curr_req = NULL;
+		}
+
+		atp_dev->active_id[c] = 0;
+		atp_dev->wide_id[c] = 0;
+		atp_dev->host_id[c] = 0x07;
+		atp_dev->quhd[c] = 0;
+		atp_dev->quend[c] = 0;
+		atp_dev->last_cmd[c] = 0xff;
+		atp_dev->in_snd[c] = 0;
+		atp_dev->in_int[c] = 0;
+
+		for (k = 0; k < qcnt; k++) {
+			atp_dev->quereq[c][k] = NULL;
+		}
+		for (k = 0; k < 16; k++) {
 			   atp_dev->id[c][k].curr_req = NULL;
 			   atp_dev->sp[c][k] = 0x04;
-	   	}		   
+		}
 	}
 	return 0;
 }
@@ -1263,7 +1323,8 @@ static void atp870_init(struct Scsi_Host *shpnt)
 
 	pci_read_config_byte(pdev, 0x49, &host_id);
 
-	dev_info(&pdev->dev, "ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: IO:%lx, IRQ:%d.\n",
+	dev_info(&pdev->dev, "ACARD AEC-671X PCI Ultra/W SCSI-2/3 "
+		 "Host Adapter: IO:%lx, IRQ:%d.\n",
 		 shpnt->io_port, shpnt->irq);
 
 	atpdev->ioport[0] = shpnt->io_port;
@@ -1314,7 +1375,8 @@ static void atp880_init(struct Scsi_Host *shpnt)
 
 	host_id = atp_readb_base(atpdev, 0x39) >> 4;
 
-	dev_info(&pdev->dev, "ACARD AEC-67160 PCI Ultra3 LVD Host Adapter: IO:%lx, IRQ:%d.\n",
+	dev_info(&pdev->dev, "ACARD AEC-67160 PCI Ultra3 LVD "
+		 "Host Adapter: IO:%lx, IRQ:%d.\n",
 		 shpnt->io_port, shpnt->irq);
 	atpdev->host_id[0] = host_id;
 
@@ -1393,7 +1455,8 @@ static void atp885_init(struct Scsi_Host *shpnt)
 	unsigned int n;
 	unsigned char setupdata[2][16];
 
-	dev_info(&pdev->dev, "ACARD AEC-67162 PCI Ultra3 LVD Host Adapter: IO:%lx, IRQ:%d.\n",
+	dev_info(&pdev->dev, "ACARD AEC-67162 PCI Ultra3 LVD "
+		 "Host Adapter: IO:%lx, IRQ:%d.\n",
 		 shpnt->io_port, shpnt->irq);
 
 	atpdev->ioport[0] = shpnt->io_port + 0x80;
@@ -1413,11 +1476,13 @@ static void atp885_init(struct Scsi_Host *shpnt)
 			atpdev->global_map[m] = 0;
 			for (k = 0; k < 4; k++) {
 				atp_writew_base(atpdev, 0x3c, n++);
-				((u32 *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
+				((u32 *)&setupdata[m][0])[k] =
+					atp_readl_base(atpdev, 0x38);
 			}
 			for (k = 0; k < 4; k++) {
 				atp_writew_base(atpdev, 0x3c, n++);
-				((u32 *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
+				((u32 *)&atpdev->sp[m][0])[k] =
+					atp_readl_base(atpdev, 0x38);
 			}
 			n += 8;
 		}
@@ -1510,17 +1575,17 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto fail;
 
 	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-                printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
-                err = -EIO;
-                goto disable_device;
-        }
+		printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
+		err = -EIO;
+		goto disable_device;
+	}
 
 	err = pci_request_regions(pdev, "atp870u");
 	if (err)
 		goto disable_device;
 	pci_set_master(pdev);
 
-        err = -ENOMEM;
+	err = -ENOMEM;
 	shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 	if (!shpnt)
 		goto release_region;
@@ -1586,7 +1651,7 @@ static int atp870u_abort(struct scsi_cmnd * SCpnt)
 {
 	unsigned char  j, k, c;
 	struct scsi_cmnd *workrequ;
-	struct atp_unit *dev;	
+	struct atp_unit *dev;
 	struct Scsi_Host *host;
 	host = SCpnt->device->host;
 
@@ -1655,11 +1720,10 @@ static int atp870u_biosparam(struct scsi_device *disk, struct block_device *dev,
 }
 
 static void atp870u_remove (struct pci_dev *pdev)
-{	
+{
 	struct atp_unit *devext = pci_get_drvdata(pdev);
 	struct Scsi_Host *pshost = devext->host;
-	
-	
+
 	scsi_remove_host(pshost);
 	free_irq(pshost->irq, pshost);
 	pci_release_regions(pdev);
@@ -1671,23 +1735,23 @@ MODULE_LICENSE("GPL");
 
 static struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
-     .name              	= "atp870u"		/* name */,
+     .name			= "atp870u"		/* name */,
      .proc_name			= "atp870u",
      .show_info			= atp870u_show_info,
-     .info              	= atp870u_info		/* info */,
-     .queuecommand      	= atp870u_queuecommand	/* queuecommand */,
-     .eh_abort_handler  	= atp870u_abort		/* abort */,
-     .bios_param        	= atp870u_biosparam	/* biosparm */,
-     .can_queue         	= qcnt			/* can_queue */,
-     .this_id           	= 7			/* SCSI ID */,
-     .sg_tablesize      	= ATP870U_SCATTER	/*SG_ALL*/,
+     .info			= atp870u_info		/* info */,
+     .queuecommand		= atp870u_queuecommand	/* queuecommand */,
+     .eh_abort_handler		= atp870u_abort		/* abort */,
+     .bios_param		= atp870u_biosparam	/* biosparm */,
+     .can_queue			= qcnt			/* can_queue */,
+     .this_id			= 7			/* SCSI ID */,
+     .sg_tablesize		= ATP870U_SCATTER	/*SG_ALL*/,
      .max_sectors		= ATP870U_MAX_SECTORS,
 };
 
 static struct pci_device_id atp870u_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP885_DEVID)			  },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID1)			  },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID2)			  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID1)		  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID2)		  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_AEC7610)    },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_AEC7612UW)  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, PCI_DEVICE_ID_ARTOP_AEC7612U)   },
@@ -1709,7 +1773,8 @@ static struct pci_driver atp870u_driver = {
 
 module_pci_driver(atp870u_driver);
 
-static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
+static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip,
+		   unsigned char lvdmode)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
@@ -1982,8 +2047,9 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 			m = m << i;
 			dev->wide_id[c] |= m;
 			dev->id[c][i].devsp = 0xce;
-#ifdef ED_DBGP		   
-			printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
+#ifdef ED_DBGP
+			printk("dev->id[%2d][%2d].devsp = %2x\n",
+			       c, i, dev->id[c][i].devsp);
 #endif
 			continue;
 		}
@@ -2005,7 +2071,8 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 &&
+		    atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
@@ -2109,7 +2176,9 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 		m = m << i;
 		dev->wide_id[c] |= m;
 not_wide:
-		if ((dev->id[c][i].devtype == 0x00) || (dev->id[c][i].devtype == 0x07) || ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
+		if ((dev->id[c][i].devtype == 0x00) ||
+		    (dev->id[c][i].devtype == 0x07) ||
+		    ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
 			m = 1;
 			m = m << i;
 			if ((dev->async[c] & m) != 0) {
@@ -2148,7 +2217,8 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 &&
+		    atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
@@ -2310,7 +2380,8 @@ static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsign
 set_syn_ok:
 		dev->id[c][i].devsp = (dev->id[c][i].devsp & 0x0f) | j;
 #ifdef ED_DBGP
-		printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
+		printk("dev->id[%2d][%2d].devsp = %2x\n",
+		       c,i,dev->id[c][i].devsp);
 #endif
 	}
 }
diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index 75c44399fc88..31f6ab24b5cb 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -7,10 +7,10 @@
 
 /* I/O Port */
 
-#define MAX_CDB 	12
-#define MAX_SENSE 	14
-#define qcnt	       	32
-#define ATP870U_SCATTER 	128
+#define MAX_CDB		12
+#define MAX_SENSE	14
+#define qcnt		32
+#define ATP870U_SCATTER	128
 
 #define MAX_ADAPTER	8
 #define MAX_SCSI_ID	16
@@ -40,7 +40,7 @@ struct atp_unit
 	unsigned short ultra_map[2];
 	unsigned short async[2];
 	unsigned char sp[2][16];
-	unsigned char r1f[2][16];		
+	unsigned char r1f[2][16];
 	struct scsi_cmnd *quereq[2][qcnt];
 	struct atp_id
 	{
@@ -55,8 +55,8 @@ struct atp_unit
 		dma_addr_t prdaddr;		/* Dynamically updated in driver */
 		struct scsi_cmnd *curr_req;
 	} id[2][16];
-    	struct Scsi_Host *host;
-    	struct pci_dev *pdev;
+	struct Scsi_Host *host;
+	struct pci_dev *pdev;
 	unsigned int unit;
 };
 
-- 
2.29.2

