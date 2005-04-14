From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove old scsi data direction macros
Date: Thu, 14 Apr 2005 13:20:34 +0200
Message-ID: <20050414112034.GA24671@lst.de>
References: <20050414105639.GA24332@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41356 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261479AbVDNLUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 07:20:38 -0400
Content-Disposition: inline
In-Reply-To: <20050414105639.GA24332@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2005 at 12:56:39PM +0200, Christoph Hellwig wrote:
> these have been wrappers for the generic dma direction bits since 2.5.x.
> This patch converts the few remaining drivers and removes the macros.

Arjan noticed there's some hunk in here that shouldn't.  Updated patch
below:

--- 1.24/Documentation/DMA-mapping.txt	2004-07-30 04:35:43 +02:00
+++ edited/Documentation/DMA-mapping.txt	2005-04-12 23:52:31 +02:00
@@ -443,15 +443,9 @@
 implicitly have a direction attribute setting of
 PCI_DMA_BIDIRECTIONAL.
 
-The SCSI subsystem provides mechanisms for you to easily obtain
-the direction to use, in the SCSI command:
-
-	scsi_to_pci_dma_dir(SCSI_DIRECTION)
-
-Where SCSI_DIRECTION is obtained from the 'sc_data_direction'
-member of the SCSI command your driver is working on.  The
-mentioned interface above returns a value suitable for passing
-into the streaming DMA mapping interfaces below.
+The SCSI subsystem tells you the direction to use in the
+'sc_data_direction' member of the SCSI command your driver is
+working on.
 
 For Networking drivers, it's a rather simple affair.  For transmit
 packets, map/unmap them with the PCI_DMA_TODEVICE direction
===== Documentation/scsi/scsi_mid_low_api.txt 1.23 vs edited =====
--- 1.23/Documentation/scsi/scsi_mid_low_api.txt	2004-11-20 21:25:56 +01:00
+++ edited/Documentation/scsi/scsi_mid_low_api.txt	2005-04-12 23:52:31 +02:00
@@ -389,8 +389,6 @@
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
    scsi_set_device - place device reference in host structure
-   scsi_to_pci_dma_dir - convert SCSI subsystem direction flag to PCI
-   scsi_to_sbus_dma_dir - convert SCSI subsystem direction flag to SBUS
    scsi_track_queue_full - track successive QUEUE_FULL events 
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
@@ -754,48 +752,6 @@
  *      Defined in: include/scsi/scsi_host.h .
  **/
 void scsi_set_device(struct Scsi_Host * shost, struct device * dev)
-
-
-/**
- * scsi_to_pci_dma_dir - convert SCSI subsystem direction flag to PCI
- * @scsi_data_direction: SCSI subsystem direction flag
- *
- *      Returns DMA_TO_DEVICE given SCSI_DATA_WRITE,
- *              DMA_FROM_DEVICE given SCSI_DATA_READ
- *              DMA_BIDIRECTIONAL given SCSI_DATA_UNKNOWN
- *              else returns DMA_NONE
- *
- *      Might block: no
- *
- *      Notes: The SCSI subsystem now uses the same values for these
- *      constants as the PCI subsystem so this function is a nop.
- *      The recommendation is not to use this conversion function anymore
- *      (in the 2.6 kernel series) as it is not needed.
- *
- *      Defined in: drivers/scsi/scsi.h .
- **/
-int scsi_to_pci_dma_dir(unsigned char scsi_data_direction)
-
-
-/**
- * scsi_to_sbus_dma_dir - convert SCSI subsystem direction flag to SBUS
- * @scsi_data_direction: SCSI subsystem direction flag
- *
- *      Returns DMA_TO_DEVICE given SCSI_DATA_WRITE,
- *              FROM_DEVICE given SCSI_DATA_READ
- *              DMA_BIDIRECTIONAL given SCSI_DATA_UNKNOWN
- *              else returns DMA_NONE
- *
- *      Notes: The SCSI subsystem now uses the same values for these
- *      constants as the SBUS subsystem so this function is a nop.
- *      The recommendation is not to use this conversion function anymore
- *      (in the 2.6 kernel series) as it is not needed.
- *
- *      Might block: no
- *
- *      Defined in: drivers/scsi/scsi.h .
- **/
-int scsi_to_sbus_dma_dir(unsigned char scsi_data_direction)
 
 
 /**
--- 1.64/drivers/scsi/aic7xxx_old.c	2005-01-25 22:50:18 +01:00
+++ edited/drivers/scsi/aic7xxx_old.c	2005-04-12 23:52:31 +02:00
@@ -2700,12 +2700,12 @@
     struct scatterlist *sg;
 
     sg = (struct scatterlist *)cmd->request_buffer;
-    pci_unmap_sg(p->pdev, sg, cmd->use_sg, scsi_to_pci_dma_dir(cmd->sc_data_direction));
+    pci_unmap_sg(p->pdev, sg, cmd->use_sg, cmd->sc_data_direction);
   }
   else if (cmd->request_bufflen)
     pci_unmap_single(p->pdev, aic7xxx_mapping(cmd),
 		     cmd->request_bufflen,
-                     scsi_to_pci_dma_dir(cmd->sc_data_direction));
+                     cmd->sc_data_direction);
   if (scb->flags & SCB_SENSE)
   {
     pci_unmap_single(p->pdev,
@@ -10228,7 +10228,7 @@
 
     sg = (struct scatterlist *)cmd->request_buffer;
     scb->sg_length = 0;
-    use_sg = pci_map_sg(p->pdev, sg, cmd->use_sg, scsi_to_pci_dma_dir(cmd->sc_data_direction));
+    use_sg = pci_map_sg(p->pdev, sg, cmd->use_sg, cmd->sc_data_direction);
     /*
      * Copy the segments into the SG array.  NOTE!!! - We used to
      * have the first entry both in the data_pointer area and the first
@@ -10256,7 +10256,7 @@
     {
       unsigned int address = pci_map_single(p->pdev, cmd->request_buffer,
 					    cmd->request_bufflen,
-                                            scsi_to_pci_dma_dir(cmd->sc_data_direction));
+                                            cmd->sc_data_direction);
       aic7xxx_mapping(cmd) = address;
       scb->sg_list[0].address = cpu_to_le32(address);
       scb->sg_list[0].length = cpu_to_le32(cmd->request_bufflen);
===== drivers/scsi/cpqfcTSinit.c 1.49 vs edited =====
--- 1.49/drivers/scsi/cpqfcTSinit.c	2005-03-14 00:29:46 +01:00
+++ edited/drivers/scsi/cpqfcTSinit.c	2005-04-12 23:52:31 +02:00
@@ -642,12 +642,12 @@
 				return( -EFAULT);
 			}
 		}
-		ScsiPassThruReq->sr_data_direction = SCSI_DATA_WRITE; 
+		ScsiPassThruReq->sr_data_direction = DMA_TO_DEVICE; 
 	} else if (vendor_cmd->rw_flag == VENDOR_READ_OPCODE) {
-		ScsiPassThruReq->sr_data_direction = SCSI_DATA_READ; 
+		ScsiPassThruReq->sr_data_direction = DMA_FROM_DEVICE;
 	} else
 		// maybe this means a bug in the user app
-		ScsiPassThruReq->sr_data_direction = SCSI_DATA_NONE;
+		ScsiPassThruReq->sr_data_direction = DMA_BIDIRECTIONAL;
 	    
 	ScsiPassThruReq->sr_cmd_len = 0; // set correctly by scsi_do_req()
 	ScsiPassThruReq->sr_sense_buffer[0] = 0;
===== drivers/scsi/cpqfcTSworker.c 1.21 vs edited =====
--- 1.21/drivers/scsi/cpqfcTSworker.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/cpqfcTSworker.c	2005-04-12 23:52:31 +02:00
@@ -5129,7 +5129,7 @@
 	for (i=*sgPages_head; i != NULL ;i = next)
 	{
 		pci_unmap_single(pcidev, i->busaddr, i->maplen, 
-			scsi_to_pci_dma_dir(PCI_DMA_TODEVICE));
+			PCI_DMA_TODEVICE);
 		i->busaddr = (dma_addr_t) NULL; 
 		i->maplen = 0L; 
 		next = i->next;
@@ -5195,7 +5195,7 @@
 			contigaddr = ulBuff = pci_map_single(pcidev, 
 				Cmnd->request_buffer, 
 				Cmnd->request_bufflen,
-				scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+				Cmnd->sc_data_direction);
 			// printk("ms %p ", ulBuff);
 		}
 		else {
@@ -5224,7 +5224,7 @@
 		unsigned long btg;
 		contigaddr = pci_map_single(pcidev, Cmnd->request_buffer, 
 				Cmnd->request_bufflen,
-				scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+				Cmnd->sc_data_direction);
 
 		// printk("contigaddr = %p, len = %d\n", 
 		//	(void *) contigaddr, bytes_to_go);
@@ -5247,7 +5247,7 @@
  
 	sgl = (struct scatterlist*)Cmnd->request_buffer;  
 	sg_count = pci_map_sg(pcidev, sgl, Cmnd->use_sg, 
-		scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+		Cmnd->sc_data_direction);
   	if( sg_count <= 3 ) {
 
 	// we need to be careful here that no individual mapping
@@ -5400,7 +5400,7 @@
 
 	        cpqfc_undo_SEST_mappings(pcidev, contigaddr, 
 			Cmnd->request_bufflen,
-			scsi_to_pci_dma_dir(Cmnd->sc_data_direction),
+			Cmnd->sc_data_direction,
   			sgl, Cmnd->use_sg, sgPages_head, AllocatedPages+1);
 
 		// FIXME: testing shows that if we get here, 
@@ -5946,7 +5946,7 @@
 	// for each extended scatter gather region needing unmapping... 
 	for (i=fcChip->SEST->sgPages[x_ID] ; i != NULL ; i = i->next)
 		pci_unmap_single(pcidev, i->busaddr, i->maplen,
-			scsi_to_pci_dma_dir(PCI_DMA_TODEVICE));
+			PCI_DMA_TODEVICE);
 }
 
 // Called also from cpqfcTScontrol.o, so can't be static
@@ -5960,14 +5960,14 @@
 	if (cmd->use_sg) {	// Used scatter gather list for data buffer?
 		cpqfc_pci_unmap_extended_sg(pcidev, fcChip, x_ID);
 		pci_unmap_sg(pcidev, cmd->buffer, cmd->use_sg,
-			scsi_to_pci_dma_dir(cmd->sc_data_direction));
+			cmd->sc_data_direction);
 		// printk("umsg %d\n", cmd->use_sg);
 	}
 	else if (cmd->request_bufflen) {
 		// printk("ums %p ", fcChip->SEST->u[ x_ID ].IWE.GAddr1);
 		pci_unmap_single(pcidev, fcChip->SEST->u[ x_ID ].IWE.GAddr1,
 			cmd->request_bufflen,
-			scsi_to_pci_dma_dir(cmd->sc_data_direction));
+			cmd->sc_data_direction);
 	}	 
 }
 
===== drivers/scsi/ips.c 1.79 vs edited =====
--- 1.79/drivers/scsi/ips.c	2005-03-31 11:06:21 +02:00
+++ edited/drivers/scsi/ips.c	2005-04-12 23:52:31 +02:00
@@ -231,9 +231,9 @@
 #endif
 
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
-                         SCSI_DATA_NONE == scb->scsi_cmd->sc_data_direction) ? \
+                         DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \
-                         scsi_to_pci_dma_dir(scb->scsi_cmd->sc_data_direction))
+                         scb->scsi_cmd->sc_data_direction)
 
 #ifdef IPS_DEBUG
 #define METHOD_TRACE(s, i)    if (ips_debug >= (i+10)) printk(KERN_NOTICE s "\n");
@@ -2849,8 +2849,7 @@
 
 			sg = SC->request_buffer;
 			scb->sg_count = pci_map_sg(ha->pcidev, sg, SC->use_sg,
-						   scsi_to_pci_dma_dir(SC->
-								       sc_data_direction));
+						   SC->sc_data_direction);
 			scb->flags |= IPS_SCB_MAP_SG;
 			for (i = 0; i < scb->sg_count; i++) {
 				if (ips_fill_scb_sg_single
@@ -2865,8 +2864,7 @@
 				    pci_map_single(ha->pcidev,
 						   SC->request_buffer,
 						   SC->request_bufflen,
-						   scsi_to_pci_dma_dir(SC->
-								       sc_data_direction));
+						   SC->sc_data_direction);
 				scb->flags |= IPS_SCB_MAP_SINGLE;
 				ips_fill_scb_sg_single(ha, scb->data_busaddr,
 						       scb, 0,
===== drivers/scsi/libata-scsi.c 1.66 vs edited =====
--- 1.66/drivers/scsi/libata-scsi.c	2005-03-17 23:16:58 +01:00
+++ edited/drivers/scsi/libata-scsi.c	2005-04-12 23:52:31 +02:00
@@ -305,7 +305,7 @@
 	sb[0] = 0x70;
 	sb[2] = MEDIUM_ERROR;
 	sb[7] = 0x0A;
-	if (cmd->sc_data_direction == SCSI_DATA_READ) {
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		sb[12] = 0x11; /* "unrecovered read error" */
 		sb[13] = 0x04;
 	} else {
@@ -671,8 +671,8 @@
 		return;
 
 	/* data is present; dma-map it */
-	if (cmd->sc_data_direction == SCSI_DATA_READ ||
-	    cmd->sc_data_direction == SCSI_DATA_WRITE) {
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
+	    cmd->sc_data_direction == DMA_TO_DEVICE) {
 		if (unlikely(cmd->request_bufflen < 1)) {
 			printk(KERN_WARNING "ata%u(%u): WARNING: zero len r/w req\n",
 			       ap->id, dev->devno);
@@ -1304,7 +1304,7 @@
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
-	int nodata = (cmd->sc_data_direction == SCSI_DATA_NONE);
+	int nodata = (cmd->sc_data_direction == DMA_NONE);
 
 	if (!using_pio)
 		/* Check whether ATAPI DMA is safe */
@@ -1316,7 +1316,7 @@
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-	if (cmd->sc_data_direction == SCSI_DATA_WRITE) {
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		qc->tf.flags |= ATA_TFLAG_WRITE;
 		DPRINTK("direction: write\n");
 	}
@@ -1340,7 +1340,7 @@
 
 #ifdef ATAPI_ENABLE_DMADIR
 		/* some SATA bridges need us to indicate data xfer direction */
-		if (cmd->sc_data_direction != SCSI_DATA_WRITE)
+		if (cmd->sc_data_direction != DMA_TO_DEVICE)
 			qc->tf.feature |= ATAPI_DMADIR;
 #endif
 	}
===== drivers/scsi/pci2000.c 1.23 vs edited =====
--- 1.23/drivers/scsi/pci2000.c	2005-03-31 11:06:20 +02:00
+++ edited/drivers/scsi/pci2000.c	2005-04-12 23:52:31 +02:00
@@ -209,7 +209,7 @@
 	if ( SCpnt->use_sg )
 		{
 		sg = (struct scatterlist *)SCpnt->request_buffer;
-		zc = pci_map_sg (padapter->pdev, sg, SCpnt->use_sg, scsi_to_pci_dma_dir (SCpnt->sc_data_direction));
+		zc = pci_map_sg (padapter->pdev, sg, SCpnt->use_sg, SCpnt->sc_data_direction);
 		for ( z = 0;  z < zc;  z++ )
 			{
 			pdev->scatGath[z].address = cpu_to_le32 (sg_dma_address (sg));
@@ -225,7 +225,9 @@
 		outl (0, padapter->mb3);
 		return TRUE;
 		}
-	SCpnt->SCp.have_data_in = pci_map_single (padapter->pdev, SCpnt->request_buffer, SCpnt->request_bufflen, scsi_to_pci_dma_dir (SCpnt->sc_data_direction));
+	SCpnt->SCp.have_data_in = pci_map_single (padapter->pdev,
+			SCpnt->request_buffer, SCpnt->request_bufflen,
+			SCpnt->sc_data_direction);
 	outl (SCpnt->SCp.have_data_in, padapter->mb2);
 	outl (SCpnt->request_bufflen, padapter->mb3);
 	return TRUE;
@@ -340,11 +342,11 @@
 			}
 		}
 	if ( SCpnt->SCp.have_data_in )
-		pci_unmap_single (padapter->pdev, SCpnt->SCp.have_data_in, SCpnt->request_bufflen, scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+		pci_unmap_single (padapter->pdev, SCpnt->SCp.have_data_in, SCpnt->request_bufflen, SCpnt->sc_data_direction);
 	else 
 		{
 		if ( SCpnt->use_sg )
-			pci_unmap_sg (padapter->pdev, (struct scatterlist *)SCpnt->request_buffer, SCpnt->use_sg, scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+			pci_unmap_sg (padapter->pdev, (struct scatterlist *)SCpnt->request_buffer, SCpnt->use_sg, SCpnt->sc_data_direction);
 		}
 
 irqProceed:;
@@ -495,7 +497,7 @@
 						else
 							{
 							SCpnt->SCp.have_data_in = pci_map_single (padapter->pdev, SCpnt->request_buffer, SCpnt->request_bufflen,
-													  scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+													  SCpnt->sc_data_direction);
 							outl (SCpnt->SCp.have_data_in, padapter->mb2);
 							}
 						outl (cdb[5], padapter->mb0);
@@ -511,13 +513,13 @@
 				SCpnt->SCp.have_data_in = pci_map_single (padapter->pdev,
 									  ((struct scatterlist *)SCpnt->request_buffer)->address,
 									  SCpnt->request_bufflen,
-									  scsi_to_pci_dma_dir (SCpnt->sc_data_direction));
+									  SCpnt->sc_data_direction);
 				}
 			else
 				{
 				SCpnt->SCp.have_data_in = pci_map_single (padapter->pdev, SCpnt->request_buffer,
 									  SCpnt->request_bufflen,
-									  scsi_to_pci_dma_dir (SCpnt->sc_data_direction));
+									  SCpnt->sc_data_direction);
 				}
 			outl (SCpnt->SCp.have_data_in, padapter->mb2);
 			outl (SCpnt->request_bufflen, padapter->mb3);
===== drivers/scsi/qlogicfc.c 1.46 vs edited =====
--- 1.46/drivers/scsi/qlogicfc.c	2005-03-14 00:30:01 +01:00
+++ edited/drivers/scsi/qlogicfc.c	2005-04-12 23:52:31 +02:00
@@ -1261,7 +1261,7 @@
 
 	if (Cmnd->use_sg) {
 		sg = (struct scatterlist *) Cmnd->request_buffer;
-		sg_count = pci_map_sg(hostdata->pci_dev, sg, Cmnd->use_sg, scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+		sg_count = pci_map_sg(hostdata->pci_dev, sg, Cmnd->use_sg, Cmnd->sc_data_direction);
 		cmd->segment_cnt = cpu_to_le16(sg_count);
 		ds = cmd->dataseg;
 		/* fill in first two sg entries: */
@@ -1307,7 +1307,7 @@
 		dma_addr_t busaddr = pci_map_page(hostdata->pci_dev,
 						  page, offset,
 						  Cmnd->request_bufflen,
-						  scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+						  Cmnd->sc_data_direction);
 		Cmnd->SCp.dma_handle = busaddr;
 
 		cmd->dataseg[0].d_base = cpu_to_le32(pci64_dma_lo32(busaddr));
@@ -1320,7 +1320,7 @@
 		cmd->segment_cnt = cpu_to_le16(1); /* Shouldn't this be 0? */
 	}
 
-	if (Cmnd->sc_data_direction == SCSI_DATA_WRITE)
+	if (Cmnd->sc_data_direction == DMA_TO_DEVICE)
 		cmd->control_flags = cpu_to_le16(CFLAG_WRITE);
 	else 
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
@@ -1405,13 +1405,13 @@
 						 pci_unmap_sg(hostdata->pci_dev,
 							      (struct scatterlist *)Cmnd->buffer,
 							      Cmnd->use_sg,
-							      scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+							      Cmnd->sc_data_direction);
 					 else if (Cmnd->request_bufflen &&
 						  Cmnd->sc_data_direction != PCI_DMA_NONE) {
 						 pci_unmap_page(hostdata->pci_dev,
 								Cmnd->SCp.dma_handle,
 								Cmnd->request_bufflen,
-								scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+								Cmnd->sc_data_direction);
 					 }
 
 					 hostdata->handle_ptrs[i]->result = DID_SOFT_ERROR << 16;
@@ -1515,13 +1515,13 @@
 					pci_unmap_sg(hostdata->pci_dev,
 						     (struct scatterlist *)Cmnd->buffer,
 						     Cmnd->use_sg,
-						     scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+						     Cmnd->sc_data_direction);
 				else if (Cmnd->request_bufflen &&
 					 Cmnd->sc_data_direction != PCI_DMA_NONE)
 					pci_unmap_page(hostdata->pci_dev,
 						       Cmnd->SCp.dma_handle,
 						       Cmnd->request_bufflen,
-						       scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+						       Cmnd->sc_data_direction);
 				Cmnd->result = 0x0;
 				(*Cmnd->scsi_done) (Cmnd);
 			} else
@@ -1569,12 +1569,12 @@
 				if (Cmnd->use_sg)
 					pci_unmap_sg(hostdata->pci_dev,
 						     (struct scatterlist *)Cmnd->buffer, Cmnd->use_sg,
-						     scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+						     Cmnd->sc_data_direction);
 				else if (Cmnd->request_bufflen && Cmnd->sc_data_direction != PCI_DMA_NONE)
 					pci_unmap_page(hostdata->pci_dev,
 						       Cmnd->SCp.dma_handle,
 						       Cmnd->request_bufflen,
-						       scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+						       Cmnd->sc_data_direction);
 
 				/* 
 				 * if any of the following are true we do not
===== drivers/scsi/qlogicisp.c 1.26 vs edited =====
--- 1.26/drivers/scsi/qlogicisp.c	2005-03-14 00:30:01 +01:00
+++ edited/drivers/scsi/qlogicisp.c	2005-04-12 23:52:31 +02:00
@@ -877,7 +877,7 @@
 		ds = cmd->dataseg;
 
 		sg_count = pci_map_sg(hostdata->pci_dev, sg, Cmnd->use_sg,
-				      scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+				      Cmnd->sc_data_direction);
 
 		cmd->segment_cnt = cpu_to_le16(sg_count);
 
@@ -934,7 +934,7 @@
 		dma_addr = pci_map_single(hostdata->pci_dev,
 				       Cmnd->request_buffer,
 				       Cmnd->request_bufflen,
-				       scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+				       Cmnd->sc_data_direction);
 		Cmnd->SCp.ptr = (char *)(unsigned long) dma_addr;
 
 		cmd->dataseg[0].d_base =
@@ -1067,7 +1067,7 @@
 			pci_unmap_sg(hostdata->pci_dev,
 				     (struct scatterlist *)Cmnd->buffer,
 				     Cmnd->use_sg,
-				     scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+				     Cmnd->sc_data_direction);
 		else if (Cmnd->request_bufflen)
 			pci_unmap_single(hostdata->pci_dev,
 #ifdef CONFIG_QL_ISP_A64
@@ -1076,7 +1076,7 @@
 					 (u32)((long)Cmnd->SCp.ptr),
 #endif
 					 Cmnd->request_bufflen,
-					 scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
+					 Cmnd->sc_data_direction);
 
 		isp_outw(out_ptr, host, MBOX5);
 		(*Cmnd->scsi_done)(Cmnd);
===== drivers/scsi/scsi.h 1.96 vs edited =====
--- 1.96/drivers/scsi/scsi.h	2005-04-04 16:09:48 +02:00
+++ edited/drivers/scsi/scsi.h	2005-04-12 23:52:51 +02:00
@@ -45,21 +45,6 @@
 struct scsi_target;
 struct scatterlist;
 
-/*
- * Legacy dma direction interfaces.
- *
- * This assumes the pci/sbus dma mapping flags have the same numercial
- * values as the generic dma-mapping ones.  Currently they have but there's
- * no way to check.  Better don't use these interfaces!
- */
-#define SCSI_DATA_UNKNOWN	(DMA_BIDIRECTIONAL)
-#define SCSI_DATA_WRITE		(DMA_TO_DEVICE)
-#define SCSI_DATA_READ		(DMA_FROM_DEVICE)
-#define SCSI_DATA_NONE		(DMA_NONE)
-
-#define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
-#define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
-
 /* obsolete typedef junk. */
 #include "scsi_typedefs.h"
 
--- 1.109/drivers/scsi/sg.c	2005-03-29 17:34:48 +02:00
+++ edited/drivers/scsi/sg.c	2005-04-12 23:52:31 +02:00
@@ -747,16 +747,16 @@
 	switch (hp->dxfer_direction) {
 	case SG_DXFER_TO_FROM_DEV:
 	case SG_DXFER_FROM_DEV:
-		SRpnt->sr_data_direction = SCSI_DATA_READ;
+		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 		break;
 	case SG_DXFER_TO_DEV:
-		SRpnt->sr_data_direction = SCSI_DATA_WRITE;
+		SRpnt->sr_data_direction = DMA_TO_DEVICE;
 		break;
 	case SG_DXFER_UNKNOWN:
-		SRpnt->sr_data_direction = SCSI_DATA_UNKNOWN;
+		SRpnt->sr_data_direction = DMA_BIDIRECTIONAL;
 		break;
 	default:
-		SRpnt->sr_data_direction = SCSI_DATA_NONE;
+		SRpnt->sr_data_direction = DMA_NONE;
 		break;
 	}
 	SRpnt->upper_private_data = srp;
===== drivers/scsi/aic7xxx/aic79xx_osm.c 1.64 vs edited =====
--- 1.64/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-01-08 06:44:35 +01:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-04-12 23:52:31 +02:00
@@ -687,7 +687,7 @@
 	int direction;
 
 	cmd = scb->io_ctx;
-	direction = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	direction = cmd->sc_data_direction;
 	ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
 	if (cmd->use_sg != 0) {
 		struct scatterlist *sg;
@@ -3338,7 +3338,7 @@
 	}
 
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = INQUIRY;
 	cmd->cmnd[4] = request_length;
@@ -3363,7 +3363,7 @@
 #endif
 	/* Do a TUR to clear out any non-fatal transitional state */
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
+	cmd->sc_data_direction = DMA_NONE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = TEST_UNIT_READY;
 }
@@ -3385,7 +3385,7 @@
 		free(targ->dv_buffer, M_DEVBUF);
 	targ->dv_buffer = malloc(AHD_REBD_LEN, M_DEVBUF, M_WAITOK);
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = READ_BUFFER;
 	cmd->cmnd[1] = 0x0b;
@@ -3407,7 +3407,7 @@
 	}
 #endif
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_WRITE;
+	cmd->sc_data_direction = DMA_TO_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = WRITE_BUFFER;
 	cmd->cmnd[1] = 0x0a;
@@ -3429,7 +3429,7 @@
 	}
 #endif
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = READ_BUFFER;
 	cmd->cmnd[1] = 0x0a;
@@ -3455,7 +3455,7 @@
 	}
 #endif
 	ahd_linux_dv_fill_cmd(ahd, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
+	cmd->sc_data_direction = DMA_NONE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = START_STOP_UNIT;
 	cmd->cmnd[4] = le | SSS_START;
@@ -4018,7 +4018,7 @@
 			int	 dir;
 
 			cur_seg = (struct scatterlist *)cmd->request_buffer;
-			dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+			dir = cmd->sc_data_direction;
 			nseg = pci_map_sg(ahd->dev_softc, cur_seg,
 					  cmd->use_sg, dir);
 			scb->platform_data->xfer_len = 0;
@@ -4038,7 +4038,7 @@
 			int dir;
 
 			sg = scb->sg_list;
-			dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+			dir = cmd->sc_data_direction;
 			addr = pci_map_single(ahd->dev_softc,
 					      cmd->request_buffer,
 					      cmd->request_bufflen, dir);
===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.63 vs edited =====
--- 1.63/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-01-08 06:44:36 +01:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-12 23:52:31 +02:00
@@ -693,12 +693,12 @@
 
 		sg = (struct scatterlist *)cmd->request_buffer;
 		pci_unmap_sg(ahc->dev_softc, sg, cmd->use_sg,
-			     scsi_to_pci_dma_dir(cmd->sc_data_direction));
+			     cmd->sc_data_direction);
 	} else if (cmd->request_bufflen != 0) {
 		pci_unmap_single(ahc->dev_softc,
 				 scb->platform_data->buf_busaddr,
 				 cmd->request_bufflen,
-				 scsi_to_pci_dma_dir(cmd->sc_data_direction));
+				 cmd->sc_data_direction);
 	}
 }
 
@@ -3007,7 +3007,7 @@
 	}
 
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = INQUIRY;
 	cmd->cmnd[4] = request_length;
@@ -3032,7 +3032,7 @@
 #endif
 	/* Do a TUR to clear out any non-fatal transitional state */
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
+	cmd->sc_data_direction = DMA_NONE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = TEST_UNIT_READY;
 }
@@ -3054,7 +3054,7 @@
 		free(targ->dv_buffer, M_DEVBUF);
 	targ->dv_buffer = malloc(AHC_REBD_LEN, M_DEVBUF, M_WAITOK);
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = READ_BUFFER;
 	cmd->cmnd[1] = 0x0b;
@@ -3076,7 +3076,7 @@
 	}
 #endif
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_WRITE;
+	cmd->sc_data_direction = DMA_TO_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = WRITE_BUFFER;
 	cmd->cmnd[1] = 0x0a;
@@ -3098,7 +3098,7 @@
 	}
 #endif
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_READ;
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = READ_BUFFER;
 	cmd->cmnd[1] = 0x0a;
@@ -3124,7 +3124,7 @@
 	}
 #endif
 	ahc_linux_dv_fill_cmd(ahc, cmd, devinfo);
-	cmd->sc_data_direction = SCSI_DATA_NONE;
+	cmd->sc_data_direction = DMA_NONE;
 	cmd->cmd_len = 6;
 	cmd->cmnd[0] = START_STOP_UNIT;
 	cmd->cmnd[4] = le | SSS_START;
@@ -3659,7 +3659,7 @@
 
 			cur_seg = (struct scatterlist *)cmd->request_buffer;
 			nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
-			    scsi_to_pci_dma_dir(cmd->sc_data_direction));
+			    cmd->sc_data_direction);
 			end_seg = cur_seg + nseg;
 			/* Copy the segments into the SG list. */
 			sg = scb->sg_list;
@@ -3703,7 +3703,7 @@
 			addr = pci_map_single(ahc->dev_softc,
 			       cmd->request_buffer,
 			       cmd->request_bufflen,
-			       scsi_to_pci_dma_dir(cmd->sc_data_direction));
+			       cmd->sc_data_direction);
 			scb->platform_data->buf_busaddr = addr;
 			scb->sg_count = ahc_linux_map_seg(ahc, scb,
 							  sg, addr,
===== drivers/scsi/aic7xxx/cam.h 1.6 vs edited =====
--- 1.6/drivers/scsi/aic7xxx/cam.h	2004-09-23 19:36:11 +02:00
+++ edited/drivers/scsi/aic7xxx/cam.h	2005-04-12 23:52:31 +02:00
@@ -103,9 +103,9 @@
 } ac_code;
 
 typedef enum {
-	CAM_DIR_IN		= SCSI_DATA_READ,
-	CAM_DIR_OUT		= SCSI_DATA_WRITE,
-	CAM_DIR_NONE		= SCSI_DATA_NONE
+	CAM_DIR_IN		= DMA_FROM_DEVICE,
+	CAM_DIR_OUT		= DMA_TO_DEVICE,
+	CAM_DIR_NONE		= DMA_NONE,
 } ccb_flags;
 
 #endif /* _AIC7XXX_CAM_H */
===== drivers/scsi/arm/fas216.c 1.33 vs edited =====
--- 1.33/drivers/scsi/arm/fas216.c	2005-03-29 17:34:11 +02:00
+++ edited/drivers/scsi/arm/fas216.c	2005-04-12 23:52:31 +02:00
@@ -2117,7 +2117,7 @@
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
 	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
-	SCpnt->sc_data_direction = SCSI_DATA_READ;
+	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	SCpnt->use_sg = 0;
 	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
