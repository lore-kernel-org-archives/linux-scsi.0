From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Thu, 16 Feb 2006 21:33:33 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602162121020.4944@poirot.grange>
References: <Pine.LNX.4.60.0602130043540.19775@poirot.grange>
 <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
 <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
 <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se>
 <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:48562 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932353AbWBPUdQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 15:33:16 -0500
In-Reply-To: <20060216113027.GA3412@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

Hi Fredrik

Thanks for your help so far, and, please, don't give up - I know it's, 
probably, much easier for you to just through away the damn thing (dc315) 
and get something modern, but - what about the fun?:-)

On Thu, 16 Feb 2006, Fredrik Roubert wrote:

> On Wed 15 Feb 23:33 CET 2006, Guennadi Liakhovetski wrote:

...

> > Could you, please, remove / comment out these 2 lines and try again?
> 
> OK, this is the log from loading the new module until the second failed
> scan:

Looks like all those lengths / counters are somewhat less consistent than 
what I'd hoped for. Please, try the patch below on the top of your 
current version - it MUST trigger. With the vanilla 2.6.15 the first 
"reselect w/o disconnect" message, after each boot / insmod dc395x, was 
_always_ accompanied by requests to contact linux-scsi, right?

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	14 Feb 2006 06:25:54 -0000	1.1.1.9.4.2
+++ b/drivers/scsi/dc395x.c	16 Feb 2006 20:18:05 -0000
@@ -2269,7 +2269,7 @@
 	 * seem to be a bad idea, actually.
 	 */
 	if (!(srb->state & SRB_XFERPAD)) {
-		unsigned int d_left_counter;
+		unsigned int d_left_counter, sc, fc;
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
 				"Parity Error\n", srb->cmd->pid);
@@ -2306,18 +2306,18 @@
 				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
-		d_left_counter = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER)
-		    + ((DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f)
-		       << ((srb->dcb->sync_period & WIDE_SYNC) ? 1 :
-			   0));
+		sc = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+		fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+		d_left_counter = sc + ((fc & 0x1f) <<
+				       ((srb->dcb->sync_period & WIDE_SYNC) ? 1 : 0));
 		dprintkdbg(DBG_KG, "data_in_phase0: "
 			"SCSI{fifocnt=0x%02x%s ctr=0x%08x} "
 			"DMA{fifocnt=0x%02x fifostat=0x%02x ctr=0x%08x} "
 			"Remain{totxfer=%i scsi_fifo+ctr=%i}\n",
-			DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+			fc,
 			(srb->dcb->sync_period & WIDE_SYNC) ? "words" : "bytes",
 			DC395x_read32(acb, TRM_S1040_SCSI_COUNTER),
-			DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+			fc,
 			DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
 			DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
 			srb->total_xfer_length, d_left_counter);
@@ -2331,7 +2331,7 @@
 			/*sg_update_list (srb, d_left_counter); */
 			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) "
 				"for remaining %i bytes:",
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
+				fc & 0x1f,
 				(srb->dcb->sync_period & WIDE_SYNC) ?
 				    "words" : "bytes",
 				srb->total_xfer_length);
@@ -2339,6 +2339,9 @@
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);
 
+			printk(KERN_INFO "%s[%d]: %u, %u, %u, %u, %x, %d\n", __FILE__, __LINE__,
+			       left_io, d_left_counter, sc, fc, srb->dcb->sync_period & WIDE_SYNC, srb->cmd->use_sg);
+
 			while (left_io) {
 				unsigned char *virt, *base = NULL;
 				unsigned long flags = 0;
@@ -2566,6 +2569,9 @@
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				     CFG2_WIDEFIFO);
 
+			printk(KERN_INFO "%s[%d]: %u, %x, %d\n", __FILE__, __LINE__,
+			       left_io, srb->dcb->sync_period & WIDE_SYNC, srb->cmd->use_sg);
+
 			while (left_io) {
 				unsigned char *virt, *base = NULL;
 				unsigned long flags = 0;
