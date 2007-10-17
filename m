From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 14/32] atp870u.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 19:55:15 +0200
Message-ID: <47164C83.5010204@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16215 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933148AbXJQR4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:56:08 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup
 - Probably not ready for sg-chaining

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/atp870u.c |  102 ++++++++----------------------------------------
 1 files changed, 17 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index fec58cc..db6de5e 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -471,18 +471,8 @@ go_42:
 			/*
 			 *	Complete the command
 			 */
-			if (workreq->use_sg) {
-				pci_unmap_sg(dev->pdev,
-					(struct scatterlist *)workreq->request_buffer,
-					workreq->use_sg,
-					workreq->sc_data_direction);
-			} else if (workreq->request_bufflen &&
-					workreq->sc_data_direction != DMA_NONE) {
-				pci_unmap_single(dev->pdev,
-					workreq->SCp.dma_handle,
-					workreq->request_bufflen,
-					workreq->sc_data_direction);
-			}			
+			scsi_dma_unmap(workreq);
+
 			spin_lock_irqsave(dev->host->host_lock, flags);
 			(*workreq->scsi_done) (workreq);
 #ifdef ED_DBGP
@@ -624,7 +614,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 
 	c = scmd_channel(req_p);
 	req_p->sense_buffer[0]=0;
-	req_p->resid = 0;
+	scsi_set_resid(req_p, 0);
 	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
 		done(req_p);
@@ -722,7 +712,6 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	unsigned short int tmpcip, w;
 	unsigned long l, bttl = 0;
 	unsigned int workport;
-	struct scatterlist *sgpnt;
 	unsigned long  sg_count;
 
 	if (dev->in_snd[c] != 0) {
@@ -793,6 +782,8 @@ oktosend:
 	}
 	printk("\n");
 #endif	
+	l = scsi_bufflen(workreq);
+
 	if (dev->dev_id == ATP885_DEVID) {
 		j = inb(dev->baseport + 0x29) & 0xfe;
 		outb(j, dev->baseport + 0x29);
@@ -800,12 +791,11 @@ oktosend:
 	}
 	
 	if (workreq->cmnd[0] == READ_CAPACITY) {
-		if (workreq->request_bufflen > 8) {
-			workreq->request_bufflen = 0x08;
-		}
+		if (l > 8)
+			l = 8;
 	}
 	if (workreq->cmnd[0] == 0x00) {
-		workreq->request_bufflen = 0;
+		l = 0;
 	}
 
 	tmport = workport + 0x1b;
@@ -852,40 +842,8 @@ oktosend:
 #ifdef ED_DBGP	
 	printk("dev->id[%d][%d].devsp = %2x\n",c,target_id,dev->id[c][target_id].devsp);
 #endif
-	/*
-	 *	Figure out the transfer size
-	 */
-	if (workreq->use_sg) {
-#ifdef ED_DBGP
-		printk("Using SGL\n");
-#endif		
-		l = 0;
-		
-		sgpnt = (struct scatterlist *) workreq->request_buffer;
-		sg_count = pci_map_sg(dev->pdev, sgpnt, workreq->use_sg,
-	   			workreq->sc_data_direction);		
-		
-		for (i = 0; i < workreq->use_sg; i++) {
-			if (sgpnt[i].length == 0 || workreq->use_sg > ATP870U_SCATTER) {
-				panic("Foooooooood fight!");
-			}
-			l += sgpnt[i].length;
-		}
-#ifdef ED_DBGP		
-		printk( "send_s870: workreq->use_sg %d, sg_count %d l %8ld\n", workreq->use_sg, sg_count, l);
-#endif
-	} else if(workreq->request_bufflen && workreq->sc_data_direction != PCI_DMA_NONE) {
-#ifdef ED_DBGP
-		printk("Not using SGL\n");
-#endif					
-		workreq->SCp.dma_handle = pci_map_single(dev->pdev, workreq->request_buffer,
-				workreq->request_bufflen,
-				workreq->sc_data_direction);		
-		l = workreq->request_bufflen;
-#ifdef ED_DBGP		
-		printk( "send_s870: workreq->use_sg %d, l %8ld\n", workreq->use_sg, l);
-#endif
-	} else l = 0;
+
+	sg_count = scsi_dma_map(workreq);
 	/*
 	 *	Write transfer size
 	 */
@@ -938,16 +896,16 @@ oktosend:
 	 *	a linear chain.
 	 */
 
-	if (workreq->use_sg) {
-		sgpnt = (struct scatterlist *) workreq->request_buffer;
+	if (l) {
+		struct scatterlist *sgpnt;
 		i = 0;
-		for (j = 0; j < workreq->use_sg; j++) {
-			bttl = sg_dma_address(&sgpnt[j]);
-			l=sg_dma_len(&sgpnt[j]);
+		scsi_for_each_sg(workreq, sgpnt, sg_count, j) {
+			bttl = sg_dma_address(sgpnt);
+			l=sg_dma_len(sgpnt);
 #ifdef ED_DBGP		
-		printk("1. bttl %x, l %x\n",bttl, l);
+			printk("1. bttl %x, l %x\n",bttl, l);
 #endif			
-		while (l > 0x10000) {
+			while (l > 0x10000) {
 				(((u16 *) (prd))[i + 3]) = 0x0000;
 				(((u16 *) (prd))[i + 2]) = 0x0000;
 				(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
@@ -965,32 +923,6 @@ oktosend:
 		printk("prd %4x %4x %4x %4x\n",(((unsigned short int *)prd)[0]),(((unsigned short int *)prd)[1]),(((unsigned short int *)prd)[2]),(((unsigned short int *)prd)[3]));
 		printk("2. bttl %x, l %x\n",bttl, l);
 #endif			
-	} else {
-		/*
-		 *	For a linear request write a chain of blocks
-		 */        
-		bttl = workreq->SCp.dma_handle;
-		l = workreq->request_bufflen;
-		i = 0;
-#ifdef ED_DBGP		
-		printk("3. bttl %x, l %x\n",bttl, l);
-#endif			
-		while (l > 0x10000) {
-				(((u16 *) (prd))[i + 3]) = 0x0000;
-				(((u16 *) (prd))[i + 2]) = 0x0000;
-				(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
-				l -= 0x10000;
-				bttl += 0x10000;
-				i += 0x04;
-			}
-			(((u16 *) (prd))[i + 3]) = cpu_to_le16(0x8000);
-			(((u16 *) (prd))[i + 2]) = cpu_to_le16(l);
-			(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);		
-#ifdef ED_DBGP		
-		printk("prd %4x %4x %4x %4x\n",(((unsigned short int *)prd)[0]),(((unsigned short int *)prd)[1]),(((unsigned short int *)prd)[2]),(((unsigned short int *)prd)[3]));
-		printk("4. bttl %x, l %x\n",bttl, l);
-#endif			
-		
 	}
 	tmpcip += 4;
 #ifdef ED_DBGP		
-- 
1.5.3.1


