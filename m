From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/3] scsi: Convert everyone to scsi_sglist and scsi_sg_count
Date: Thu, 3 Jan 2008 19:50:11 +1100
Message-ID: <200801031950.12090.rusty@rustcorp.com.au>
References: <200801031800.02537.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:54362 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYACIua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 03:50:30 -0500
In-Reply-To: <200801031800.02537.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

This patch simply converts direct uses of ->use_sg and ->request_buffer to
use the wrapper macros.  This removes the assumption that the sg list is
overloaded on request_buffer, and that there's an explicit use_sg field.

The ->request_buffer assumption is explicit in scsi_debug.c's paranoid
checking, so that code had to be shuffled a little.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/scsi/NCR5380.c       |    6 +++---
 drivers/scsi/NCR53C9x.c      |    6 +++---
 drivers/scsi/aha1542.c       |   14 +++++++-------
 drivers/scsi/atari_NCR5380.c |    2 +-
 drivers/scsi/atp870u.c       |   22 +++++++++++-----------
 drivers/scsi/eata_pio.c      |    6 +++---
 drivers/scsi/fd_mcs.c        |    6 +++---
 drivers/scsi/imm.c           |    5 ++---
 drivers/scsi/in2000.c        |    6 +++---
 drivers/scsi/libsrp.c        |   12 ++++++------
 drivers/scsi/pcmcia/nsp_cs.c |    8 ++++----
 drivers/scsi/ppa.c           |    4 ++--
 drivers/scsi/qlogicpti.c     |   12 ++++++------
 drivers/scsi/scsi_debug.c    |   14 +++++++-------
 drivers/scsi/seagate.c       |    4 ++--
 drivers/scsi/sr.c            |    6 +++---
 drivers/scsi/sun3_NCR5380.c  |    6 +++---
 drivers/scsi/sun3x_esp.c     |    4 ++--
 drivers/scsi/wd33c93.c       |    6 +++---
 21 files changed, 77 insertions(+), 76 deletions(-)

diff -r 297d045c5da1 drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/NCR5380.c	Wed Jan 02 18:00:10 2008 +1100
@@ -295,9 +295,9 @@ static __inline__ void initialize_SCp(Sc
 	 * various queues are valid.
 	 */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_sg_count(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
diff -r 297d045c5da1 drivers/scsi/NCR53C9x.c
--- a/drivers/scsi/NCR53C9x.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/NCR53C9x.c	Wed Jan 02 18:00:10 2008 +1100
@@ -910,7 +910,7 @@ EXPORT_SYMBOL(esp_proc_info);
 
 static void esp_get_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	if(sp->use_sg == 0) {
+	if(scsi_sg_count(sp) == 0) {
 		sp->SCp.this_residual = sp->request_bufflen;
 		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
 		sp->SCp.buffers_residual = 0;
@@ -920,8 +920,8 @@ static void esp_get_dmabufs(struct NCR_E
 			sp->SCp.ptr =
 				(char *) virt_to_phys(sp->request_buffer);
 	} else {
-		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
-		sp->SCp.buffers_residual = sp->use_sg - 1;
+		sp->SCp.buffer = scsi_sglist(sp->request_buffer);
+		sp->SCp.buffers_residual = scsi_sg_count(sp) - 1;
 		sp->SCp.this_residual = sp->SCp.buffer->length;
 		if (esp->dma_mmu_get_scsi_sgl)
 			esp->dma_mmu_get_scsi_sgl(esp, sp);
diff -r 297d045c5da1 drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/aha1542.c	Wed Jan 02 18:00:10 2008 +1100
@@ -689,7 +689,7 @@ static int aha1542_queuecommand(Scsi_Cmn
 
 	memcpy(ccb[mbo].cdb, cmd, ccb[mbo].cdblen);
 
-	if (SCpnt->use_sg) {
+	if (scsi_sg_count(SCpnt)) {
 		struct scatterlist *sg;
 		struct chain *cptr;
 #ifdef DEBUG
@@ -704,12 +704,12 @@ static int aha1542_queuecommand(Scsi_Cmn
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-		scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
-			if (sg->length == 0 || SCpnt->use_sg > 16 ||
+		scsi_for_each_sg(SCpnt, sg, scsi_sg_count(SCpnt), i) {
+			if (sg->length == 0 || scsi_sg_count(SCpnt) > 16 ||
 			    (((int) sg->offset) & 1) || (sg->length & 1)) {
 				unsigned char *ptr;
-				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
-				scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
+				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", scsi_sg_count(SCpnt), i);
+				scsi_for_each_sg(SCpnt, sg, scsi_sg_count(SCpnt), i) {
 					printk(KERN_CRIT "%d: %p %d\n", i,
 					       sg_virt(sg), sg->length);
 				};
@@ -721,10 +721,10 @@ static int aha1542_queuecommand(Scsi_Cmn
 			};
 			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
 			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
-				BAD_SG_DMA(SCpnt, sg, SCpnt->use_sg, i);
+				BAD_SG_DMA(SCpnt, sg, scsi_sg_count(SCpnt), i);
 			any2scsi(cptr[i].datalen, sg->length);
 		};
-		any2scsi(ccb[mbo].datalen, SCpnt->use_sg * sizeof(struct chain));
+		any2scsi(ccb[mbo].datalen, scsi_sg_count(SCpnt) * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(cptr));
 #ifdef DEBUG
 		printk("cptr %x: ", cptr);
diff -r 297d045c5da1 drivers/scsi/atari_NCR5380.c
--- a/drivers/scsi/atari_NCR5380.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/atari_NCR5380.c	Wed Jan 02 18:00:10 2008 +1100
@@ -512,7 +512,7 @@ static inline void initialize_SCp(Scsi_C
 	 */
 
 	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *)cmd->request_buffer;
+		cmd->SCp.buffer = scsi_sglist(cmd->request_buffer);
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
diff -r 297d045c5da1 drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/atp870u.c	Wed Jan 02 18:00:10 2008 +1100
@@ -471,10 +471,10 @@ go_42:
 			/*
 			 *	Complete the command
 			 */
-			if (workreq->use_sg) {
+			if (scsi_sg_count(workreq)) {
 				pci_unmap_sg(dev->pdev,
-					(struct scatterlist *)workreq->request_buffer,
-					workreq->use_sg,
+					scsi_sglist(workreq->request_buffer),
+					scsi_sg_count(workreq), 
 					workreq->sc_data_direction);
 			} else if (workreq->request_bufflen &&
 					workreq->sc_data_direction != DMA_NONE) {
@@ -855,18 +855,18 @@ oktosend:
 	/*
 	 *	Figure out the transfer size
 	 */
-	if (workreq->use_sg) {
+	if (scsi_sg_count(workreq)) {
 #ifdef ED_DBGP
 		printk("Using SGL\n");
 #endif		
 		l = 0;
 		
-		sgpnt = (struct scatterlist *) workreq->request_buffer;
-		sg_count = pci_map_sg(dev->pdev, sgpnt, workreq->use_sg,
+		sgpnt = scsi_sglist(workreq);
+		sg_count = pci_map_sg(dev->pdev, sgpnt, scsi_sg_count(workreq),
 	   			workreq->sc_data_direction);		
 		
-		for (i = 0; i < workreq->use_sg; i++) {
-			if (sgpnt[i].length == 0 || workreq->use_sg > ATP870U_SCATTER) {
+		for (i = 0; i < scsi_sg_count(workreq); i++) {
+			if (sgpnt[i].length == 0 || scsi_sg_count(workreq) > ATP870U_SCATTER) {
 				panic("Foooooooood fight!");
 			}
 			l += sgpnt[i].length;
@@ -938,10 +938,10 @@ oktosend:
 	 *	a linear chain.
 	 */
 
-	if (workreq->use_sg) {
-		sgpnt = (struct scatterlist *) workreq->request_buffer;
+	if (scsi_sg_count(workreq)) {
+		sgpnt = scsi_sglist(workreq->request_buffer);
 		i = 0;
-		for (j = 0; j < workreq->use_sg; j++) {
+		for (j = 0; j < scsi_sg_count(workreq); j++) {
 			bttl = sg_dma_address(&sgpnt[j]);
 			l=sg_dma_len(&sgpnt[j]);
 #ifdef ED_DBGP		
diff -r 297d045c5da1 drivers/scsi/eata_pio.c
--- a/drivers/scsi/eata_pio.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/eata_pio.c	Wed Jan 02 18:00:10 2008 +1100
@@ -402,14 +402,14 @@ static int eata_pio_queue(struct scsi_cm
 	cp->cmd = cmd;
 	cmd->host_scribble = (char *) &hd->ccb[y];
 
-	if (cmd->use_sg == 0) {
+	if (scsi_sg_count(cmd) == 0) {
 		cmd->SCp.buffers_residual = 1;
 		cmd->SCp.ptr = cmd->request_buffer;
 		cmd->SCp.this_residual = cmd->request_bufflen;
 		cmd->SCp.buffer = NULL;
 	} else {
-		cmd->SCp.buffer = cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg;
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd);
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	}
diff -r 297d045c5da1 drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/fd_mcs.c	Wed Jan 02 18:00:10 2008 +1100
@@ -1107,11 +1107,11 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpn
 
 	/* Initialize static data */
 
-	if (current_SC->use_sg) {
-		current_SC->SCp.buffer = (struct scatterlist *) current_SC->request_buffer;
+	if (scsi_sg_count(current_SC)) {
+		current_SC->SCp.buffer = scsi_sglist(current_SC->request_buffer);
 		current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 		current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
-		current_SC->SCp.buffers_residual = current_SC->use_sg - 1;
+		current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
 	} else {
 		current_SC->SCp.ptr = (char *) current_SC->request_buffer;
 		current_SC->SCp.this_residual = current_SC->request_bufflen;
diff -r 297d045c5da1 drivers/scsi/imm.c
--- a/drivers/scsi/imm.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/imm.c	Wed Jan 02 18:00:10 2008 +1100
@@ -837,10 +837,9 @@ static int imm_engine(imm_struct *dev, s
 
 		/* Phase 4 - Setup scatter/gather buffers */
 	case 4:
-		if (cmd->use_sg) {
+		if (scsi_sg_count(cmd)) {
 			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer =
-			    (struct scatterlist *) cmd->request_buffer;
+			cmd->SCp.buffer = scsi_sglist(cmd);
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
 			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		} else {
diff -r 297d045c5da1 drivers/scsi/in2000.c
--- a/drivers/scsi/in2000.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/in2000.c	Wed Jan 02 18:00:10 2008 +1100
@@ -369,9 +369,9 @@ static int in2000_queuecommand(Scsi_Cmnd
  *  - SCp.phase records this command's SRCID_ER bit setting
  */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_sg_count(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd->request_buffer);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
diff -r 297d045c5da1 drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/libsrp.c	Wed Jan 02 18:00:10 2008 +1100
@@ -192,15 +192,15 @@ static int srp_direct_data(struct scsi_c
 
 	if (dma_map) {
 		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = sc->request_buffer;
+		sg = scsi_sglist(sc);
 
 		dprintk("%p %u %u %d\n", iue, sc->request_bufflen,
 			md->len, sc->use_sg);
 
-		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg,
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
 				 DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			printk("fail to map %p %d\n", iue, sc->use_sg);
+			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
 			return 0;
 		}
 		len = min(sc->request_bufflen, md->len);
@@ -229,7 +229,7 @@ static int srp_indirect_data(struct scsi
 
 	if (dma_map || ext_desc) {
 		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = sc->request_buffer;
+		sg = scsi_sglist(sc);
 
 		dprintk("%p %u %u %d %d\n",
 			iue, sc->request_bufflen, id->len,
@@ -268,9 +268,9 @@ static int srp_indirect_data(struct scsi
 
 rdma:
 	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg, DMA_BIDIRECTIONAL);
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc), DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			eprintk("fail to map %p %d\n", iue, sc->use_sg);
+			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
 			err = -EIO;
 			goto free_mem;
 		}
diff -r 297d045c5da1 drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/pcmcia/nsp_cs.c	Wed Jan 02 18:00:10 2008 +1100
@@ -233,11 +233,11 @@ static int nsp_queuecommand(struct scsi_
 	   SCp.buffer		: next buffer
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase		: current state of the command */
-	if (SCpnt->use_sg) {
-		SCpnt->SCp.buffer	    = (struct scatterlist *) SCpnt->request_buffer;
+	if (scsi_sg_count(SCpnt)) {
+		SCpnt->SCp.buffer	    = scsi_sglist(SCpnt);
 		SCpnt->SCp.ptr		    = BUFFER_ADDR;
 		SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 	} else {
 		SCpnt->SCp.ptr		    = (char *) SCpnt->request_buffer;
 		SCpnt->SCp.this_residual    = SCpnt->request_bufflen;
@@ -911,7 +911,7 @@ static int nsp_nexus(struct scsi_cmnd *S
 	nsp_index_write(base, SYNCREG,	sync->SyncRegister);
 	nsp_index_write(base, ACKWIDTH, sync->AckWidth);
 
-	if (SCpnt->use_sg    == 0        ||
+	if (scsi_sg_count(SCpnt) == 0    ||
 	    SCpnt->resid % 4 != 0        ||
 	    SCpnt->resid     <= PAGE_SIZE ) {
 		data->TransferMode = MODE_IO8;
diff -r 297d045c5da1 drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/ppa.c	Wed Jan 02 18:00:10 2008 +1100
@@ -750,9 +750,9 @@ static int ppa_engine(ppa_struct *dev, s
 		cmd->SCp.phase++;
 
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
-		if (cmd->use_sg) {
+		if (scsi_sg_count(cmd)) {
 			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
+			cmd->SCp.buffer = scsi_sglist(cmd);
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
 			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		} else {
diff -r 297d045c5da1 drivers/scsi/qlogicpti.c
--- a/drivers/scsi/qlogicpti.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/qlogicpti.c	Wed Jan 02 18:00:10 2008 +1100
@@ -871,11 +871,11 @@ static inline int load_cmd(struct scsi_c
 	struct scatterlist *sg, *s;
 	int i, n;
 
-	if (Cmnd->use_sg) {
+	if (scsi_sg_count(Cmnd)) {
 		int sg_count;
 
-		sg = (struct scatterlist *) Cmnd->request_buffer;
-		sg_count = sbus_map_sg(qpti->sdev, sg, Cmnd->use_sg, Cmnd->sc_data_direction);
+		sg = scsi_sglist(Cmnd);
+		sg_count = sbus_map_sg(qpti->sdev, sg, scsi_sg_count(Cmnd), Cmnd->sc_data_direction);
 
 		ds = cmd->dataseg;
 		cmd->segment_cnt = sg_count;
@@ -1159,10 +1159,10 @@ static struct scsi_cmnd *qlogicpti_intr_
 		else
 			Cmnd->result = DID_ERROR << 16;
 
-		if (Cmnd->use_sg) {
+		if (scsi_sg_count(Cmnd)) {
 			sbus_unmap_sg(qpti->sdev,
-				      (struct scatterlist *)Cmnd->request_buffer,
-				      Cmnd->use_sg,
+				      scsi_sglist(Cmnd->request_buffer),
+				      scsi_sg_count(Cmnd),
 				      Cmnd->sc_data_direction);
 		} else if (Cmnd->request_bufflen) {
 			sbus_unmap_single(qpti->sdev,
diff -r 297d045c5da1 drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/scsi_debug.c	Wed Jan 02 18:00:10 2008 +1100
@@ -605,12 +605,10 @@ static int fill_from_dev_buffer(struct s
 
 	if (0 == scp->request_bufflen)
 		return 0;
-	if (NULL == scp->request_buffer)
-		return (DID_ERROR << 16);
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_FROM_DEVICE)))
 		return (DID_ERROR << 16);
-	if (0 == scp->use_sg) {
+	if (0 == scsi_sg_count(scp)) {
 		req_len = scp->request_bufflen;
 		act_len = (req_len < arr_len) ? req_len : arr_len;
 		memcpy(scp->request_buffer, arr, act_len);
@@ -620,9 +618,11 @@ static int fill_from_dev_buffer(struct s
 			scp->resid = req_len - act_len;
 		return 0;
 	}
+	if (!scsi_sglist(scp))
+		return (DID_ERROR << 16);
 	active = 1;
 	req_len = act_len = 0;
-	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
+	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), k) {
 		if (active) {
 			kaddr = (unsigned char *)
 				kmap_atomic(sg_page(sg), KM_USER0);
@@ -658,12 +658,12 @@ static int fetch_to_dev_buffer(struct sc
 
 	if (0 == scp->request_bufflen)
 		return 0;
-	if (NULL == scp->request_buffer)
+	if (NULL == scsi_sglist(scp))
 		return -1;
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_TO_DEVICE)))
 		return -1;
-	if (0 == scp->use_sg) {
+	if (0 == scsi_sg_count(scp)) {
 		req_len = scp->request_bufflen;
 		len = (req_len < max_arr_len) ? req_len : max_arr_len;
 		memcpy(arr, scp->request_buffer, len);
@@ -671,7 +671,7 @@ static int fetch_to_dev_buffer(struct sc
 	}
 	sg = scsi_sglist(scp);
 	req_len = fin = 0;
-	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
+	for (k = 0; k < scsi_sg_count(scp); ++k, sg = sg_next(sg)) {
 		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
 		if (NULL == kaddr)
 			return -1;
diff -r 297d045c5da1 drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/seagate.c	Wed Jan 02 18:00:10 2008 +1100
@@ -991,7 +991,7 @@ connect_loop:
 
 		/* Establish current pointers.  Take into account scatter / gather */
 
-		if ((nobuffs = SCint->use_sg)) {
+		if ((nobuffs = scsi_sg_count(SCint))) {
 #if (DEBUG & DEBUG_SG)
 			{
 				int i;
@@ -1004,7 +1004,7 @@ connect_loop:
 			}
 #endif
 
-			buffer = (struct scatterlist *) SCint->request_buffer;
+			buffer = scsi_sglist(SCint->request_buffer);
 			len = buffer->length;
 			data = sg_virt(buffer);
 		} else {
diff -r 297d045c5da1 drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/sr.c	Wed Jan 02 18:00:10 2008 +1100
@@ -366,12 +366,12 @@ static int sr_prep_fn(struct request_que
 	}
 
 	{
-		struct scatterlist *sg = SCpnt->request_buffer;
+		struct scatterlist *sg = scsi_sglist(SCpnt);
 		int i, size = 0;
-		for (i = 0; i < SCpnt->use_sg; i++)
+		for (i = 0; i < scsi_sg_count(SCpnt); i++)
 			size += sg[i].length;
 
-		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+		if (size != SCpnt->request_bufflen && scsi_sg_count(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				"mismatch count %d, bytes %d\n",
 				size, SCpnt->request_bufflen);
diff -r 297d045c5da1 drivers/scsi/sun3_NCR5380.c
--- a/drivers/scsi/sun3_NCR5380.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/sun3_NCR5380.c	Wed Jan 02 18:00:10 2008 +1100
@@ -515,9 +515,9 @@ static __inline__ void initialize_SCp(st
      * various queues are valid.
      */
 
-    if (cmd->use_sg) {
-	cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-	cmd->SCp.buffers_residual = cmd->use_sg - 1;
+    if (scsi_sg_count(cmd)) {
+	cmd->SCp.buffer = scsi_sglist(cmd);
+	cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 	cmd->SCp.ptr = (char *) SGADDR(cmd->SCp.buffer);
 	cmd->SCp.this_residual = cmd->SCp.buffer->length;
 
diff -r 297d045c5da1 drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/sun3x_esp.c	Wed Jan 02 18:00:10 2008 +1100
@@ -346,8 +346,8 @@ static void dma_mmu_release_scsi_one (st
 
 static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-    int sz = sp->use_sg - 1;
-    struct scatterlist *sg = (struct scatterlist *)sp->request_buffer;
+    int sz = scsi_sg_count(sp) - 1;
+    struct scatterlist *sg = scsi_sglist(sp);
                         
     while(sz >= 0) {
         dvma_unmap((char *)sg[sz].dma_address);
diff -r 297d045c5da1 drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c	Wed Jan 02 17:18:59 2008 +1100
+++ b/drivers/scsi/wd33c93.c	Wed Jan 02 18:00:10 2008 +1100
@@ -407,9 +407,9 @@ wd33c93_queuecommand(struct scsi_cmnd *c
  *  - SCp.phase records this command's SRCID_ER bit setting
  */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_sgcount(cmd)) {
+		cmd->SCp.buffer = scsi_sg_list(cmd);
+		cmd->SCp.buffers_residual = scsi_sgcount(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
