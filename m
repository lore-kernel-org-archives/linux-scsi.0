From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of obsolete scsi APIs in cciss_scsi
Date: Sun, 3 Oct 2004 13:48:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041003114849.GA32437@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:14517 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267823AbUJCLs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2004 07:48:57 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com, iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org


--- 1.22/drivers/block/cciss_scsi.c	2004-06-19 17:24:11 +02:00
+++ edited/drivers/block/cciss_scsi.c	2004-10-02 15:19:49 +02:00
@@ -28,11 +28,14 @@
    through the array controller.  Note in particular, neither 
    physical nor logical disks are presented through the scsi layer. */
 
-#include "../scsi/scsi.h" 
-#include <scsi/scsi_host.h> 
-#include <asm/atomic.h>
-#include <linux/timer.h>
 #include <linux/completion.h>
+#include <linux/timer.h>
+#include <asm/atomic.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h> 
 
 #include "cciss_scsi.h"
 
@@ -61,15 +64,8 @@
 		int length, 	   /* length of data in buffer */
 		int func);	   /* 0 == read, 1 == write */
 
-int cciss_scsi_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *));
-#if 0
-int cciss_scsi_abort(Scsi_Cmnd *cmd);
-#if defined SCSI_RESET_SYNCHRONOUS && defined SCSI_RESET_ASYNCHRONOUS
-int cciss_scsi_reset(Scsi_Cmnd *cmd, unsigned int reset_flags);
-#else
-int cciss_scsi_reset(Scsi_Cmnd *cmd);
-#endif
-#endif
+int cciss_scsi_queue_command(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *));
 
 static struct cciss_scsi_hba_t ccissscsi[MAX_CTLR] = {
 	{ .name = "cciss0", .ndevices = 0 },
@@ -82,7 +78,7 @@
 	{ .name = "cciss7", .ndevices = 0 },
 };
 
-static Scsi_Host_Template cciss_driver_template = {
+static struct scsi_host_template cciss_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "cciss",
 	.proc_name		= "cciss",
@@ -552,7 +548,7 @@
 static void
 complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	ctlr_info_t *ctlr;
 	u64bit addr64;
 	ErrorInfo_struct *ei;
@@ -565,22 +561,20 @@
 		return;
 	}
 
-	cmd = (Scsi_Cmnd *) cp->scsi_cmd;	
+	cmd = (struct scsi_cmnd *) cp->scsi_cmd;	
 	ctlr = hba[cp->ctlr];
 
 	/* undo the DMA mappings */
 
 	if (cmd->use_sg) {
-		pci_unmap_sg(ctlr->pdev,
-			cmd->buffer, cmd->use_sg,
-				scsi_to_pci_dma_dir(cmd->sc_data_direction)); 
+		pci_unmap_sg(ctlr->pdev, cmd->buffer, cmd->use_sg,
+				cmd->sc_data_direction); 
 	}
 	else if (cmd->request_bufflen) {
 		addr64.val32.lower = cp->SG[0].Addr.lower;
                 addr64.val32.upper = cp->SG[0].Addr.upper;
                 pci_unmap_single(ctlr->pdev, (dma_addr_t) addr64.val,
-                	cmd->request_bufflen, 
-				scsi_to_pci_dma_dir(cmd->sc_data_direction));
+				cmd->request_bufflen, cmd->sc_data_direction);
 	}
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
@@ -783,9 +777,8 @@
 	cp->Request.Type.Direction = direction;
 
 	/* Fill in the SG list and do dma mapping */
-	cciss_map_one(c->pdev, cp, 
-			(unsigned char *) buf, bufsize,
-			scsi_to_pci_dma_dir(SCSI_DATA_READ)); 
+	cciss_map_one(c->pdev, cp, (unsigned char *) buf,
+			bufsize, DMA_FROM_DEVICE); 
 
 	cp->waiting = &wait;
 
@@ -799,10 +792,8 @@
 	wait_for_completion(&wait);
 
 	/* undo the dma mapping */
-	cciss_unmap_one(c->pdev, cp, bufsize,
-				scsi_to_pci_dma_dir(SCSI_DATA_READ)); 
-
-	return(0);
+	cciss_unmap_one(c->pdev, cp, bufsize, DMA_FROM_DEVICE);
+	return 0;
 }
 
 static void 
@@ -1180,14 +1171,14 @@
 }
 
 
-/* cciss_scatter_gather takes a Scsi_Cmnd, (cmd), and does the pci 
+/* cciss_scatter_gather takes a scsi_cmnd, (cmd), and does the pci 
    dma mapping  and fills in the scatter gather entries of the 
    cciss command, cp. */
 
 static void
 cciss_scatter_gather(struct pci_dev *pdev, 
 		CommandList_struct *cp,	
-		Scsi_Cmnd *cmd)
+		struct scsi_cmnd *cmd)
 {
 	unsigned int use_sg, nsegs=0, len;
 	struct scatterlist *scatter = (struct scatterlist *) cmd->buffer;
@@ -1200,7 +1191,7 @@
 			addr64 = (__u64) pci_map_single(pdev, 
 				cmd->request_buffer, 
 				cmd->request_bufflen, 
-				scsi_to_pci_dma_dir(cmd->sc_data_direction)); 
+				cmd->sc_data_direction);
 	
 			cp->SG[0].Addr.lower = 
 			  (__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
@@ -1213,7 +1204,7 @@
 	else if (cmd->use_sg <= MAXSGENTRIES) {	/* not too many addrs? */
 
 		use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, 
-			scsi_to_pci_dma_dir(cmd->sc_data_direction));
+				cmd->sc_data_direction);
 
 		for (nsegs=0; nsegs < use_sg; nsegs++) {
 			addr64 = (__u64) sg_dma_address(&scatter[nsegs]);
@@ -1234,7 +1225,8 @@
 
 
 int 
-cciss_scsi_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *))
+cciss_scsi_queue_command(struct scsi_cmnd *cmd,
+		void (* done)(struct scsi_cmnd *))
 {
 	ctlr_info_t **c;
 	int ctlr, rc;
@@ -1302,11 +1294,11 @@
 	cp->Request.Type.Attribute = ATTR_SIMPLE;
 	switch(cmd->sc_data_direction)
 	{
-	  case SCSI_DATA_WRITE: cp->Request.Type.Direction = XFER_WRITE; break;
-	  case SCSI_DATA_READ: cp->Request.Type.Direction = XFER_READ; break;
-	  case SCSI_DATA_NONE: cp->Request.Type.Direction = XFER_NONE; break;
+	  case DMA_TO_DEVICE: cp->Request.Type.Direction = XFER_WRITE; break;
+	  case DMA_FROM_DEVICE: cp->Request.Type.Direction = XFER_READ; break;
+	  case DMA_NONE: cp->Request.Type.Direction = XFER_NONE; break;
 
-	  case SCSI_DATA_UNKNOWN:
+	  case DMA_BIDIRECTIONAL:
 		// This can happen if a buggy application does a scsi passthru
 		// and sets both inlen and outlen to non-zero. ( see
 		// ../scsi/scsi_ioctl.c:scsi_ioctl_send_command() )
