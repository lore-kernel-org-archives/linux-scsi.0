From: Jes Sorensen <jes@trained-monkey.org>
Subject: [patch] qla1280 update for 2.6.1-mm4
Date: Mon, 19 Jan 2004 07:08:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16395.51364.833229.536552@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:20410 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S264894AbUASMIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 07:08:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, jeremy@sgi.com

Hi,

I am attaching the latest patch for qla1280, which includes Andrew's and
James' patches (modulo the 64 bit enable part) as well changes to make
it handle pci_set_dma_mask() correctly and switch to only use one of the
two SCSI command issuing versions depending on whether the driver is
compiled for 64 or 32 bit DMA. The old code effectively did this anyway,
but with this change it is no longer compiling in the part not used.

Cheers,
Jes

--- orig/linux-2.6.1-mm4/drivers/scsi/qla1280.c	Fri Jan 16 01:59:19 2004
+++ linux-2.6.1-mm4/drivers/scsi/qla1280.c	Mon Jan 19 03:50:29 2004
@@ -17,9 +17,16 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.24.1"
+#define QLA1280_VERSION      "3.24.3"
 /*****************************************************************************
     Revision History:
+    Rev  3.24.3 January 19, 2004, Jes Sorensen
+	- Handle PCI DMA mask settings correctly
+	- Correct order of error handling in probe_one, free_irq should not
+	  be called if request_irq failed
+    Rev  3.24.2 January 19, 2004, James Bottomley & Andrew Vasquez
+	- Big endian fixes (James)
+	- Remove bogus IOCB content on zero data transfer commands (Andrew)
     Rev  3.24.1 January 5, 2004, Jes Sorensen
 	- Initialize completion queue to avoid OOPS on probe
 	- Handle interrupts during mailbox testing
@@ -507,8 +514,11 @@
 static int qla1280_abort_device(struct scsi_qla_host *, int, int, int);
 static int qla1280_abort_command(struct scsi_qla_host *, struct srb *, int);
 static int qla1280_abort_isp(struct scsi_qla_host *);
+#ifdef QLA_64BIT_PTR
 static int qla1280_64bit_start_scsi(struct scsi_qla_host *, struct srb *);
+#else
 static int qla1280_32bit_start_scsi(struct scsi_qla_host *, struct srb *);
+#endif
 static void qla1280_nv_write(struct scsi_qla_host *, uint16_t);
 static void qla1280_poll(struct scsi_qla_host *);
 static void qla1280_reset_adapter(struct scsi_qla_host *);
@@ -765,7 +775,7 @@
 {
 	uint16_t *wptr;
 	uint8_t chksum;
-	int cnt;
+	int cnt, i;
 	struct nvram *nv;
 
 	ENTER("qla1280_read_nvram");
@@ -812,6 +822,28 @@
 	} else
 		ha->nvram_valid = 1;
 
+	/* The firmware interface is, um, interesting, in that the
+	 * actual firmware image on the chip is little endian, thus,
+	 * the process of taking that image to the CPU would end up
+	 * little endian.  However, the firmare interface requires it
+	 * to be read a word (two bytes) at a time.
+	 *
+	 * The net result of this would be that the word (and
+	 * doubleword) quantites in the firmware would be correct, but
+	 * the bytes would be pairwise reversed.  Since most of the
+	 * firmware quantites are, in fact, bytes, we do an extra
+	 * le16_to_cpu() in the firmware read routine.
+	 *
+	 * The upshot of all this is that the bytes in the firmware
+	 * are in the correct places, but the 16 and 32 bit quantites
+	 * are still in little endian format.  We fix that up below by
+	 * doing extra reverses on them */
+	nv->isp_parameter = cpu_to_le16(nv->isp_parameter);
+	nv->firmware_feature.w = cpu_to_le16(nv->firmware_feature.w);
+	for(i = 0; i < MAX_BUSES; i++) {
+		nv->bus[i].selection_timeout = cpu_to_le16(nv->bus[i].selection_timeout);
+		nv->bus[i].max_queue_depth = cpu_to_le16(nv->bus[i].max_queue_depth);
+	}
 	dprintk(1, "qla1280_read_nvram: Completed Reading NVRAM\n");
 	LEAVE("qla1280_read_nvram");
 
@@ -860,6 +892,7 @@
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
 	struct srb *sp = (struct srb *)&cmd->SCp;
+	int status;
 
 	cmd->scsi_done = fn;
 	sp->cmd = cmd;
@@ -867,9 +900,18 @@
 
 	qla1280_print_scsi_cmd(5, cmd);
 
-	if (ha->flags.enable_64bit_addressing)
-		return qla1280_64bit_start_scsi(ha, sp);
-	return qla1280_32bit_start_scsi(ha, sp);
+#ifdef QLA_64BIT_PTR
+	/*
+	 * Using 64 bit commands if the PCI bridge doesn't support it is a
+	 * bit wasteful, however this should really only happen if one's
+	 * PCI controller is completely broken, like the BCM1250. For
+	 * sane hardware this is not an issue.
+	 */
+	status = qla1280_64bit_start_scsi(ha, sp);
+#else
+	status = qla1280_32bit_start_scsi(ha, sp);
+#endif
+	return status;
 }
 
 enum action {
@@ -1558,6 +1600,10 @@
 qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 {
 	int host_status = DID_ERROR;
+	uint16_t comp_status = le16_to_cpu(sts->comp_status);
+	uint16_t state_flags = le16_to_cpu(sts->state_flags);
+	uint16_t residual_length = le16_to_cpu(sts->residual_length);
+	uint16_t scsi_status = le16_to_cpu(sts->scsi_status);
 #if DEBUG_QLA1280_INTR
 	static char *reason[] = {
 		"DID_OK",
@@ -1578,26 +1624,27 @@
 #if DEBUG_QLA1280_INTR
 	/*
 	  dprintk(1, "qla1280_return_status: compl status = 0x%04x\n",
-	  sts->comp_status);
+	  comp_status);
 	*/
 #endif
-	switch (sts->comp_status) {
+
+	switch (comp_status) {
 	case CS_COMPLETE:
 		host_status = DID_OK;
 		break;
 
 	case CS_INCOMPLETE:
-		if (!(sts->state_flags & SF_GOT_BUS))
+		if (!(state_flags & SF_GOT_BUS))
 			host_status = DID_NO_CONNECT;
-		else if (!(sts->state_flags & SF_GOT_TARGET))
+		else if (!(state_flags & SF_GOT_TARGET))
 			host_status = DID_BAD_TARGET;
-		else if (!(sts->state_flags & SF_SENT_CDB))
+		else if (!(state_flags & SF_SENT_CDB))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_TRANSFERRED_DATA))
+		else if (!(state_flags & SF_TRANSFERRED_DATA))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_GOT_STATUS))
+		else if (!(state_flags & SF_GOT_STATUS))
 			host_status = DID_ERROR;
-		else if (!(sts->state_flags & SF_GOT_SENSE))
+		else if (!(state_flags & SF_GOT_SENSE))
 			host_status = DID_ERROR;
 		break;
 
@@ -1614,14 +1661,14 @@
 		break;
 
 	case CS_DATA_OVERRUN:
-		dprintk(2, "Data overrun 0x%x\n", sts->residual_length);
+		dprintk(2, "Data overrun 0x%x\n", residual_length);
 		dprintk(2, "qla1280_isr: response packet data\n");
 		qla1280_dump_buffer(2, (char *)sts, RESPONSE_ENTRY_SIZE);
 		host_status = DID_ERROR;
 		break;
 
 	case CS_DATA_UNDERRUN:
-		if ((cp->request_bufflen - sts->residual_length) <
+		if ((cp->request_bufflen - residual_length) <
 		    cp->underflow) {
 			printk(KERN_WARNING
 			       "scsi: Underflow detected - retrying "
@@ -1638,12 +1685,12 @@
 
 #if DEBUG_QLA1280_INTR
 	dprintk(1, "qla1280 ISP status: host status (%s) scsi status %x\n",
-		reason[host_status], sts->scsi_status);
+		reason[host_status], scsi_status);
 #endif
 
 	LEAVE("qla1280_return_status");
 
-	return (sts->scsi_status & 0xff) | (host_status << 16);
+	return (scsi_status & 0xff) | (host_status << 16);
 }
 
 /****************************************************************************/
@@ -2394,23 +2441,6 @@
 	ha->flags.disable_risc_code_load =
 		nv->cntr_flags_1.disable_loading_risc_code;
 
-#ifdef QLA_64BIT_PTR
-	/* Enable 64bit addressing for OS/System combination supporting it   */
-	/* actual NVRAM bit is: nv->cntr_flags_1.enable_64bit_addressing     */
-	/* but we will ignore it and use BITS_PER_LONG macro to setup for    */
-	/* 64 or 32 bit access of host memory in all x86/ia-64/Alpha systems */
-	ha->flags.enable_64bit_addressing = 1;
-#else
-	ha->flags.enable_64bit_addressing = 0;
-#endif
-
-	if (ha->flags.enable_64bit_addressing) {
-		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
-			ha->host_no);
-
-		pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL);
-	}
-
 	/* Set ISP hardware DMA burst */
 	mb[0] = nv->isp_config.c;
 	/* Enable DMA arbitration on dual channel controllers */
@@ -3315,7 +3345,7 @@
 #endif
 			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
 			*dword_ptr++ = cpu_to_le32(pci_dma_hi32(dma_handle));
-			*dword_ptr = (uint32_t)cmd->request_bufflen;
+			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
 
 			dprintk(5, "qla1280_64bit_start_scsi: No scatter/"
 				"gather command packet data - b %i, t %i, "
@@ -3325,10 +3355,6 @@
 					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer */
-		dword_ptr = (uint32_t *)(pkt + 1);
-		*dword_ptr++ = 0;
-		*dword_ptr++ = 0;
-		*dword_ptr = 0;
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
 			"packet data - b %i, t %i, l %i \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
@@ -3359,6 +3385,7 @@
 }
 
 
+#ifndef QLA_64BIT_PTR
 /*
  * qla1280_32bit_start_scsi
  *      The start SCSI is responsible for building request packets on
@@ -3593,9 +3620,6 @@
 			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
 		}
 	} else {	/* No data transfer at all */
-		dword_ptr = (uint32_t *)(pkt + 1);
-		*dword_ptr++ = 0;
-		*dword_ptr = 0;
 		dprintk(5, "qla1280_32bit_start_scsi: No data, command "
 			"packet data - \n");
 		qla1280_dump_buffer(5, (char *)pkt, REQUEST_ENTRY_SIZE);
@@ -3627,6 +3651,7 @@
 
 	return status;
 }
+#endif
 
 /*
  * qla1280_req_pkt
@@ -4686,6 +4711,26 @@
 	ha->pdev = pdev;
 	ha->devnum = devnum;	/* specifies microcode load address */
 
+#ifdef QLA_64BIT_PTR
+	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+		if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+			printk(KERN_WARNING "scsi(%li): Unable to set a "
+			       " suitable DMA mask - aboring\n", ha->host_no);
+			error = -ENODEV;
+			goto error_free_irq;
+		}
+	} else
+		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
+			ha->host_no);
+#else
+	if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+		printk(KERN_WARNING "scsi(%li): Unable to set a "
+		       " suitable DMA mask - aboring\n", ha->host_no);
+		error = -ENODEV;
+		goto error_free_irq;
+	}
+#endif
+
 	ha->request_ring = pci_alloc_consistent(ha->pdev,
 			((REQUEST_ENTRY_CNT + 1) * (sizeof(request_t))),
 			&ha->request_dma);
@@ -4780,14 +4825,14 @@
  error_disable_adapter:
 	WRT_REG_WORD(&ha->iobase->ictrl, 0);
 #endif
+ error_free_irq:
+	free_irq(pdev->irq, ha);
  error_release_region:
 #if MEMORY_MAPPED_IO
 	iounmap(ha->mmpbase);
 #else
 	release_region(host->io_port, 0xff);
 #endif
- error_free_irq:
-	free_irq(pdev->irq, ha);
  error_free_response_ring:
 	pci_free_consistent(ha->pdev,
 			((RESPONSE_ENTRY_CNT + 1) * (sizeof(struct response))),
--- orig/linux-2.6.1-mm4/drivers/scsi/qla1280.h	Fri Jan 16 01:59:19 2004
+++ linux-2.6.1-mm4/drivers/scsi/qla1280.h	Mon Jan 19 00:41:15 2004
@@ -309,16 +309,19 @@
 	} cntr_flags_1;		/* 5 */
 
 	struct {
-		uint16_t boot_lun_number:5;
-		uint16_t scsi_bus_number:1;
-		uint16_t unused_6:1;
-		uint16_t unused_7:1;
-		uint16_t boot_target_number:4;
-		uint16_t unused_12:1;
-		uint16_t unused_13:1;
-		uint16_t unused_14:1;
-		uint16_t unused_15:1;
-	} cntr_flags_2;		/* 6, 7 */
+		uint8_t boot_lun_number:5;
+		uint8_t scsi_bus_number:1;
+		uint8_t unused_6:1;
+		uint8_t unused_7:1;
+	} cntr_flags_2l;	/* 7 */
+
+	struct {
+		uint8_t boot_target_number:4;
+		uint8_t unused_12:1;
+		uint8_t unused_13:1;
+		uint8_t unused_14:1;
+		uint8_t unused_15:1;
+	} cntr_flags_2h;	/* 8 */
 
 	uint16_t unused_8;	/* 8, 9 */
 	uint16_t unused_10;	/* 10, 11 */
