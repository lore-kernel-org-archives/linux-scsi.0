From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 14/24][RFC]] dc395x: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon,  4 Feb 2008 19:11:35 +0200
Message-ID: <1202145095-5035-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44936 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYBDRQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:16:47 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Using scsi_eh_{prep,restore}_cmnd() for synchronous
    REQUEST_SENSE invocation. simplifies code alot, because
    it can now use the regular command invocation code path.
  - Use new sense accessors where needed.
  - use scsi_print_sense() (that is there for ages) in place
    of a driver's made one. (Is that needed still)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/dc395x.c |  140 ++++++++----------------------------------------
 1 files changed, 24 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 22ef371..5e92fcc 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -64,6 +64,8 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_dbg.h>
 
 #include "dc395x.h"
 
@@ -236,16 +238,8 @@ struct ScsiReqBlk {
 	u8 sg_index;			/* Index of HW sg entry for this request */
 	size_t total_xfer_length;	/* Total number of bytes remaining to be transfered */
 	size_t request_length;		/* Total number of bytes in this request */
-	/*
-	 * The sense buffer handling function, request_sense, uses
-	 * the first hw sg entry (segment_x[0]) and the transfer
-	 * length (total_xfer_length). While doing this it stores the
-	 * original values into the last sg hw list
-	 * (srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1] and the
-	 * total_xfer_length in xferred. These values are restored in
-	 * pci_unmap_srb_sense. This is the only place xferred is used.
-	 */
-	size_t xferred;		        /* Saved copy of total_xfer_length */
+
+	struct scsi_eh_save ses;
 
 	u16 state;
 
@@ -1624,18 +1618,11 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
 		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
-	if (srb->flag & AUTO_REQSENSE) {
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, SCSI_SENSE_BUFFERSIZE);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-	} else {
-		ptr = (u8 *)srb->cmd->cmnd;
-		for (i = 0; i < srb->cmd->cmd_len; i++)
-			DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
-	}
+	ptr = (u8 *)srb->cmd->cmnd;
+
+	for (i = 0; i < srb->cmd->cmd_len; i++)
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
+
       no_cmd:
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 		       DO_HWRESELECT | DO_DATALATCH);
@@ -1894,29 +1881,19 @@ static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 static void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
 	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->serial_number);
 
 	clear_fifo(acb, "command_phase1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
-	if (!(srb->flag & AUTO_REQSENSE)) {
-		ptr = (u8 *)srb->cmd->cmnd;
-		for (i = 0; i < srb->cmd->cmd_len; i++) {
-			DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr);
-			ptr++;
-		}
-	} else {
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
-		dcb = acb->active_dcb;
-		/* target id */
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, SCSI_SENSE_BUFFERSIZE);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
+
+	ptr = (u8 *)srb->cmd->cmnd;
+	for (i = 0; i < srb->cmd->cmd_len; i++) {
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr);
+		ptr++;
 	}
+
 	srb->state |= SRB_COMMAND;
 	/* it's important for atn stop */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
@@ -3290,17 +3267,9 @@ static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
 {
 	if (!(srb->flag & AUTO_REQSENSE))
 		return;
-	/* Unmap sense buffer */
-	dprintkdbg(DBG_SG, "pci_unmap_srb_sense: buffer=%08x\n",
-	       srb->segment_x[0].address);
-	pci_unmap_single(acb->dev, srb->segment_x[0].address,
-			 srb->segment_x[0].length, PCI_DMA_FROMDEVICE);
-	/* Restore SG stuff */
-	srb->total_xfer_length = srb->xferred;
-	srb->segment_x[0].address =
-	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address;
-	srb->segment_x[0].length =
-	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].length;
+
+	pci_unmap_srb(acb, srb);
+	scsi_eh_restore_cmnd(srb->cmd, &srb->ses);
 }
 
 
@@ -3331,51 +3300,8 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		srb->flag &= ~AUTO_REQSENSE;
 		srb->adapter_status = 0;
 		srb->target_status = CHECK_CONDITION << 1;
-		if (debug_enabled(DBG_1)) {
-			switch (cmd->sense_buffer[2] & 0x0f) {
-			case NOT_READY:
-				dprintkl(KERN_DEBUG,
-				     "ReqSense: NOT_READY cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
-				     cmd->cmnd[0], dcb->target_id,
-				     dcb->target_lun, status, acb->scan_devices);
-				break;
-			case UNIT_ATTENTION:
-				dprintkl(KERN_DEBUG,
-				     "ReqSense: UNIT_ATTENTION cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
-				     cmd->cmnd[0], dcb->target_id,
-				     dcb->target_lun, status, acb->scan_devices);
-				break;
-			case ILLEGAL_REQUEST:
-				dprintkl(KERN_DEBUG,
-				     "ReqSense: ILLEGAL_REQUEST cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
-				     cmd->cmnd[0], dcb->target_id,
-				     dcb->target_lun, status, acb->scan_devices);
-				break;
-			case MEDIUM_ERROR:
-				dprintkl(KERN_DEBUG,
-				     "ReqSense: MEDIUM_ERROR cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
-				     cmd->cmnd[0], dcb->target_id,
-				     dcb->target_lun, status, acb->scan_devices);
-				break;
-			case HARDWARE_ERROR:
-				dprintkl(KERN_DEBUG,
-				     "ReqSense: HARDWARE_ERROR cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
-				     cmd->cmnd[0], dcb->target_id,
-				     dcb->target_lun, status, acb->scan_devices);
-				break;
-			}
-			if (cmd->sense_buffer[7] >= 6)
-				printk("sense=0x%02x ASC=0x%02x ASCQ=0x%02x "
-					"(0x%08x 0x%08x)\n",
-					cmd->sense_buffer[2], cmd->sense_buffer[12],
-					cmd->sense_buffer[13],
-					*((unsigned int *)(cmd->sense_buffer + 3)),
-					*((unsigned int *)(cmd->sense_buffer + 8)));
-			else
-				printk("sense=0x%02x No ASC/ASCQ (0x%08x)\n",
-					cmd->sense_buffer[2],
-					*((unsigned int *)(cmd->sense_buffer + 3)));
-		}
+		if (debug_enabled(DBG_1))
+			scsi_print_sense("dc395x", cmd);
 
 		if (status == (CHECK_CONDITION << 1)) {
 			cmd->result = DID_BAD_TARGET << 16;
@@ -3678,32 +3604,13 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
 		cmd->serial_number, cmd->device->id, cmd->device->lun);
 
+	scsi_eh_prep_cmnd(cmd, &srb->ses, NULL, 0, ~0);
+	build_srb(cmd, dcb, srb);
+
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
 
-	/* KG: Can this prevent crap sense data ? */
-	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
-	/* Save some data */
-	srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address =
-	    srb->segment_x[0].address;
-	srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].length =
-	    srb->segment_x[0].length;
-	srb->xferred = srb->total_xfer_length;
-	/* srb->segment_x : a one entry of S/G list table */
-	srb->total_xfer_length = SCSI_SENSE_BUFFERSIZE;
-	srb->segment_x[0].length = SCSI_SENSE_BUFFERSIZE;
-	/* Map sense buffer */
-	srb->segment_x[0].address =
-	    pci_map_single(acb->dev, cmd->sense_buffer,
-			   SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE);
-	dprintkdbg(DBG_SG, "request_sense: map buffer %p->%08x(%05x)\n",
-	       cmd->sense_buffer, srb->segment_x[0].address,
-	       SCSI_SENSE_BUFFERSIZE);
-	srb->sg_count = 1;
-	srb->sg_index = 0;
-
 	if (start_scsi(acb, dcb, srb)) {	/* Should only happen, if sb. else grabs the bus */
 		dprintkl(KERN_DEBUG,
 			"request_sense: (pid#%li) failed <%02i-%i>\n",
@@ -4763,6 +4670,7 @@ static struct scsi_host_template dc395x_driver_template = {
 	.eh_bus_reset_handler   = dc395x_eh_bus_reset,
 	.unchecked_isa_dma      = 0,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 
-- 
1.5.3.3

