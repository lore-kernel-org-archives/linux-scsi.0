From: Christoph Hellwig <hch@lst.de>
Subject: Re: areca RAID driver
Date: Thu, 20 Apr 2006 22:36:43 +0200
Message-ID: <20060420203643.GA9365@lst.de>
References: <20060419155300.321c352e.akpm@osdl.org> <20060420194831.GA7923@lst.de> <20060420130723.2cc2396e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36305 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751260AbWDTUhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 16:37:05 -0400
Content-Disposition: inline
In-Reply-To: <20060420130723.2cc2396e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, axboe@suse.de, erich@areca.com.tw, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

Here's another patch doign some basic cleanup, this time for the scsi
entry points.


Index: hch/areca/drivers/scsi/arcmsr/arcmsr_hba.c
===================================================================
--- hch.orig/areca/drivers/scsi/arcmsr/arcmsr_hba.c	2006-04-20 21:46:49.000000000 +0200
+++ hch/areca/drivers/scsi/arcmsr/arcmsr_hba.c	2006-04-20 22:33:21.000000000 +0200
@@ -74,43 +74,10 @@
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *pACB, struct scsi_cmnd *cmd);
-static int arcmsr_cmd_abort(struct scsi_cmnd *);
-static int arcmsr_bus_reset(struct scsi_cmnd *);
-static int arcmsr_bios_param(struct scsi_device *sdev,
-				struct block_device *bdev, sector_t capacity, int *info);
-static int arcmsr_queue_command(struct scsi_cmnd * cmd,
-				void (*done) (struct scsi_cmnd *));
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *pACB);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *pACB);
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *pACB);
 static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *pACB);
-static const char *arcmsr_info(struct Scsi_Host *);
-
-static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
-{
-	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
-		queue_depth = ARCMSR_MAX_CMD_PERLUN;
-	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
-	return queue_depth;
-}
-
-static struct scsi_host_template arcmsr_scsi_host_template = {
-	.module			= THIS_MODULE,
-	.name			= "ARCMSR ARECA SATA RAID HOST Adapter" ARCMSR_DRIVER_VERSION,
-	.info			= arcmsr_info,
-	.queuecommand		= arcmsr_queue_command,
-	.eh_abort_handler	= arcmsr_cmd_abort,
-	.eh_bus_reset_handler	= arcmsr_bus_reset,
-	.bios_param		= arcmsr_bios_param,
-	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
-	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
-	.this_id		= ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize		= ARCMSR_MAX_SG_ENTRIES,
-	.max_sectors    	= ARCMSR_MAX_XFER_SECTORS,
-	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.shost_attrs		= arcmsr_host_attrs,
-};
 
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id,
 	struct pt_regs *regs)
@@ -127,8 +94,486 @@
 	return handle_state;
 }
 
+static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+	u32 orig_mask = readl(&reg->outbound_intmask);
+
+	writel(orig_mask | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+			&reg->outbound_intmask);
+	return orig_mask;
+}
+
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+		u32 orig_mask)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+	u32 mask;
+
+	mask = orig_mask & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
+			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
+	writel(mask, &reg->outbound_intmask);
+}
+
+static void arcmsr_pci_unmap_dma(struct CommandControlBlock *pCCB)
+{
+	struct AdapterControlBlock *acb = pCCB->pACB;
+	struct scsi_cmnd *pcmd = pCCB->pcmd;
+
+	if (pcmd->use_sg != 0) {
+		struct scatterlist *sl;
+
+		sl = (struct scatterlist *)pcmd->request_buffer;
+		pci_unmap_sg(acb->pdev, sl, pcmd->use_sg, pcmd->sc_data_direction);
+	}
+	else if (pcmd->request_bufflen != 0)
+		pci_unmap_single(acb->pdev,
+			(dma_addr_t)(unsigned long)pcmd->SCp.ptr,
+			pcmd->request_bufflen, pcmd->sc_data_direction);
+}
+
+static void arcmsr_ccb_complete(struct CommandControlBlock *pCCB, int stand_flag)
+{
+	struct AdapterControlBlock *acb = pCCB->pACB;
+	struct scsi_cmnd *pcmd = pCCB->pcmd;
+
+	arcmsr_pci_unmap_dma(pCCB);
+	if (stand_flag == 1)
+		atomic_dec(&acb->ccboutstandingcount);
+	pCCB->startdone = ARCMSR_CCB_DONE;
+	pCCB->ccb_flags = 0;
+	list_add_tail(&pCCB->list, &acb->ccb_free_list);
+	pcmd->scsi_done(pcmd);
+}
+
+static struct CommandControlBlock *arcmsr_get_freeccb(
+		struct AdapterControlBlock *acb)
+{
+	struct list_head *head = &acb->ccb_free_list;
+	struct CommandControlBlock *pCCB = NULL;
+
+	if (!list_empty(head)) {
+		pCCB = list_entry(head->next, struct CommandControlBlock, list);
+		list_del(head->next);
+	}
+	return pCCB;
+}
+
+static void arcmsr_build_ccb(struct AdapterControlBlock *pACB, struct CommandControlBlock *pCCB,
+	struct scsi_cmnd *pcmd)
+{
+	struct ARCMSR_CDB *pARCMSR_CDB = (struct ARCMSR_CDB *)&pCCB->arcmsr_cdb;
+	int8_t *psge = (int8_t *)&pARCMSR_CDB->u;
+	uint32_t address_lo, address_hi;
+	int arccdbsize = 0x30;
+
+	pCCB->pcmd = pcmd;
+	memset(pARCMSR_CDB, 0, sizeof (struct ARCMSR_CDB));
+	pARCMSR_CDB->Bus = 0;
+	pARCMSR_CDB->TargetID = pcmd->device->id;
+	pARCMSR_CDB->LUN = pcmd->device->lun;
+	pARCMSR_CDB->Function = 1;
+	pARCMSR_CDB->CdbLength = (uint8_t)pcmd->cmd_len;
+	pARCMSR_CDB->Context = (unsigned long)pARCMSR_CDB;
+	memcpy(pARCMSR_CDB->Cdb, pcmd->cmnd, pcmd->cmd_len);
+	if (pcmd->use_sg) {
+		int length, sgcount, i, cdb_sgcount = 0;
+		struct scatterlist *sl;
+
+		/* Get Scatter Gather List from scsiport. */
+		sl = (struct scatterlist *) pcmd->request_buffer;
+		sgcount = pci_map_sg(pACB->pdev, sl, pcmd->use_sg,
+				pcmd->sc_data_direction);
+		/* map stor port SG list to our iop SG List. */
+		for(i = 0; i < sgcount; i++) {
+			/* Get the physical address of the current data pointer */
+			length = cpu_to_le32(sg_dma_len(sl));
+			address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sl)));
+			address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sl)));
+			if (address_hi == 0) {
+				struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
+
+				pdma_sg->address = address_lo;
+				pdma_sg->length = length;
+				psge += sizeof (struct SG32ENTRY);
+				arccdbsize += sizeof (struct SG32ENTRY);
+			} else {
+				struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
+
+				pdma_sg->addresshigh = address_hi;
+				pdma_sg->address = address_lo;
+				pdma_sg->length = length|IS_SG64_ADDR;
+				psge += sizeof (struct SG64ENTRY);
+				arccdbsize += sizeof (struct SG64ENTRY);
+			}
+			sl++;
+			cdb_sgcount++;
+		}
+		pARCMSR_CDB->sgcount = (uint8_t)cdb_sgcount;
+		pARCMSR_CDB->DataLength = pcmd->request_bufflen;
+		if ( arccdbsize > 256)
+			pARCMSR_CDB->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
+	} else if (pcmd->request_bufflen) {
+		dma_addr_t dma_addr;
+		dma_addr = pci_map_single(pACB->pdev, pcmd->request_buffer,
+				pcmd->request_bufflen, pcmd->sc_data_direction);
+		pcmd->SCp.ptr = (char *)(unsigned long) dma_addr;
+		address_lo = cpu_to_le32(dma_addr_lo32(dma_addr));
+		address_hi = cpu_to_le32(dma_addr_hi32(dma_addr));
+		if (address_hi == 0) {
+			struct  SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
+			pdma_sg->address = address_lo;
+			pdma_sg->length = pcmd->request_bufflen;
+		} else {
+			struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
+			pdma_sg->addresshigh = address_hi;
+			pdma_sg->address = address_lo;
+			pdma_sg->length = pcmd->request_bufflen|IS_SG64_ADDR;
+		}
+		pARCMSR_CDB->sgcount = 1;
+		pARCMSR_CDB->DataLength = pcmd->request_bufflen;
+	}
+	if (pcmd->sc_data_direction == DMA_TO_DEVICE ) {
+		pARCMSR_CDB->Flags |= ARCMSR_CDB_FLAG_WRITE;
+		pCCB->ccb_flags |= CCB_FLAG_WRITE;
+	}
+}
+
+static void arcmsr_post_ccb(struct AdapterControlBlock *pACB, struct CommandControlBlock *pCCB)
+{
+	struct MessageUnit __iomem *reg = pACB->pmu;
+	uint32_t cdb_shifted_phyaddr = pCCB->cdb_shifted_phyaddr;
+	struct ARCMSR_CDB *pARCMSR_CDB = (struct ARCMSR_CDB *)&pCCB->arcmsr_cdb;
+
+	atomic_inc(&pACB->ccboutstandingcount);
+	pCCB->startdone = ARCMSR_CCB_START;
+	if (pARCMSR_CDB->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
+		writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			&reg->inbound_queueport);
+	else
+		writel(cdb_shifted_phyaddr, &reg->inbound_queueport);
+}
+
+static void arcmsr_report_sense_info(struct CommandControlBlock *pCCB)
+{
+	struct scsi_cmnd *pcmd = pCCB->pcmd;
+	struct SENSE_DATA *psenseBuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
+
+	pcmd->result = DID_OK << 16;
+	if (psenseBuffer) {
+		int sense_data_length =
+			sizeof (struct SENSE_DATA) < sizeof (pcmd->sense_buffer)
+			? sizeof (struct SENSE_DATA) : sizeof (pcmd->sense_buffer);
+		memset(psenseBuffer, 0, sizeof (pcmd->sense_buffer));
+		memcpy(psenseBuffer, pCCB->arcmsr_cdb.SenseData, sense_data_length);
+		psenseBuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
+		psenseBuffer->Valid = 1;
+	}
+}
+
+static void arcmsr_polling_ccbdone(struct AdapterControlBlock *pACB,
+		struct CommandControlBlock *poll_ccb)
+{
+	struct MessageUnit __iomem *reg = pACB->pmu;
+	struct CommandControlBlock *pCCB;
+	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
+	int id, lun;
+
+polling_ccb_retry:
+	poll_count++;
+	outbound_intstatus = readl(&reg->outbound_intstatus)
+					& pACB->outbound_int_enable;
+	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
+	while (1) {
+		flag_ccb = readl(&reg->outbound_queueport);
+		if (flag_ccb == 0xFFFFFFFF) {
+			if (poll_ccb_done)
+				break;
+			msleep(25);
+			if (poll_count > 100)
+				break;
+			goto polling_ccb_retry;
+		}
+
+		pCCB = (struct CommandControlBlock *)(pACB->vir2phy_offset + (flag_ccb << 5));
+		if ((pCCB->pACB != pACB) || (pCCB->startdone != ARCMSR_CCB_START)) {
+			if ((pCCB->startdone == ARCMSR_CCB_ABORTED) && (pCCB == poll_ccb)) {
+				printk(KERN_NOTICE
+					"arcmsr%d: scsi id=%d lun=%d ccb='0x%p'"
+					" poll command abort successfully \n"
+					, pACB->host->host_no
+					, pCCB->pcmd->device->id
+					, pCCB->pcmd->device->lun
+					, pCCB);
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB, 1);
+				poll_ccb_done = 1;
+				continue;
+			}
+			printk(KERN_NOTICE
+				"arcmsr%d: polling get an illegal ccb"
+				" command done ccb='0x%p'"
+				"ccboutstandingcount=%d \n"
+				, pACB->host->host_no
+				, pCCB
+				, atomic_read(&pACB->ccboutstandingcount));
+			continue;
+		}
+		id = pCCB->pcmd->device->id;
+		lun = pCCB->pcmd->device->lun;
+		if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
+			if (pACB->devstate[id][lun] == ARECA_RAID_GONE)
+				pACB->devstate[id][lun] = ARECA_RAID_GOOD;
+			pCCB->pcmd->result = DID_OK << 16;
+			arcmsr_ccb_complete(pCCB, 1);
+			continue;
+		}
+
+		switch(pCCB->arcmsr_cdb.DeviceStatus) {
+		case ARCMSR_DEV_SELECT_TIMEOUT:
+			pACB->devstate[id][lun] = ARECA_RAID_GONE;
+			pCCB->pcmd->result = DID_TIME_OUT << 16;
+			arcmsr_ccb_complete(pCCB, 1);
+			break;
+		case ARCMSR_DEV_ABORTED:
+		case ARCMSR_DEV_INIT_FAIL:
+			pACB->devstate[id][lun] = ARECA_RAID_GONE;
+			pCCB->pcmd->result = DID_BAD_TARGET << 16;
+			arcmsr_ccb_complete(pCCB, 1);
+			break;
+		case ARCMSR_DEV_CHECK_CONDITION:
+			pACB->devstate[id][lun] = ARECA_RAID_GOOD;
+			arcmsr_report_sense_info(pCCB);
+			arcmsr_ccb_complete(pCCB, 1);
+			break;
+		default:
+			printk(KERN_NOTICE "arcmsr%d: scsi id=%d lun=%d "
+				"polling and getting command error done "
+				"but got unknown DeviceStatus = 0x%x\n",
+				pACB->host->host_no, id, lun,
+				pCCB->arcmsr_cdb.DeviceStatus);
+			pACB->devstate[id][lun] = ARECA_RAID_GONE;
+			pCCB->pcmd->result = DID_BAD_TARGET << 16;
+			arcmsr_ccb_complete(pCCB, 1);
+			break;
+		}
+	}
+}
+
+static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit __iomem *reg = acb->pmu;
+	char *acb_firm_model = acb->firm_model;
+	char *acb_firm_version = acb->firm_version;
+	char __iomem *iop_firm_model = (char __iomem *) &reg->message_rwbuffer[15];
+	char __iomem *iop_firm_version = (char __iomem *) &reg->message_rwbuffer[17];
+	int count;
+
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+	if (arcmsr_wait_msgint_ready(acb))
+		printk(KERN_NOTICE
+			"arcmsr%d: wait "
+			"'get adapter firmware miscellaneous data' timeout \n",
+			acb->host->host_no);
+	count = 8;
+	while (count) {
+		*acb_firm_model = readb(iop_firm_model);
+		acb_firm_model++;
+		iop_firm_model++;
+		count--;
+	}
+	count = 16;
+	while (count) {
+		*acb_firm_version = readb(iop_firm_version);
+		acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+
+	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
+	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
+	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
+	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
+}
+
+static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
+		struct scsi_cmnd *cmd)
+{
+	switch (cmd->cmnd[0]) {
+	case INQUIRY: {
+		unsigned char inqdata[36];
+		char *buffer;
+
+		if (cmd->device->lun) {
+			cmd->result = (DID_TIME_OUT << 16);
+			cmd->scsi_done(cmd);
+			return;
+		}
+
+		inqdata[0] = TYPE_PROCESSOR;
+		/* Periph Qualifier & Periph Dev Type */
+		inqdata[1] = 0;
+		/* rem media bit & Dev Type Modifier */
+		inqdata[2] = 0;
+		/* ISO,ECMA,& ANSI versions */
+		inqdata[4] = 31;
+		/* length of additional data */
+		strncpy(&inqdata[8], "Areca   ", 8);
+		/* Vendor Identification */
+		strncpy(&inqdata[16], "RAID controller ", 16);
+		/* Product Identification */
+		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
+		if (cmd->use_sg) {
+			struct scatterlist *sg;
+
+			sg = (struct scatterlist *) cmd->request_buffer;
+			buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		} else {
+			buffer = cmd->request_buffer;
+		}
+		memcpy(buffer, inqdata, sizeof(inqdata));
+		if (cmd->use_sg) {
+			struct scatterlist *sg;
+
+			sg = (struct scatterlist *) cmd->request_buffer;
+			kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+		}
+		cmd->scsi_done(cmd);
+	}
+	case WRITE_BUFFER:
+	case READ_BUFFER:
+		if (arcmsr_iop_message_xfer(acb, cmd))
+    			cmd->result = (DID_ERROR << 16);
+		cmd->scsi_done(cmd);
+	default:
+		cmd->scsi_done(cmd);
+	}
+}
+
+static int arcmsr_queue_command(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
+{
+	struct Scsi_Host *host = cmd->device->host;
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *) host->hostdata;
+	struct CommandControlBlock *pCCB;
+	int target = cmd->device->id;
+	int lun = cmd->device->lun;
+
+	cmd->scsi_done = done;
+	cmd->host_scribble = NULL;
+	cmd->result = 0;
+
+	if (acb->acb_flags & ACB_F_BUS_RESET) {
+		printk(KERN_NOTICE "arcmsr%d: bus reset"
+			" and return busy\n",
+			acb->host->host_no);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	if (target == 16) {
+		arcmsr_handle_virtual_command(acb, cmd);
+		return 0;
+	}
+
+	if (acb->devstate[target][lun] == ARECA_RAID_GONE) {
+		uint8_t block_cmd;
+
+		block_cmd = cmd->cmnd[0] & 0x0f;
+		if (block_cmd == 0x08 || block_cmd == 0x0a) {
+			printk(KERN_NOTICE
+				"arcmsr%d: block 'read/write'"
+				"command with gone raid volume"
+				" Cmd=%2x, TargetId=%d, Lun=%d\n",
+				acb->host->host_no, cmd->cmnd[0],
+				target, lun);
+			cmd->result = (DID_NO_CONNECT << 16);
+			cmd->scsi_done(cmd);
+			return 0;
+		}
+	}
+
+	if (atomic_read(&acb->ccboutstandingcount) >=
+			ARCMSR_MAX_OUTSTANDING_CMD)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	pCCB = arcmsr_get_freeccb(acb);
+	if (!pCCB)
+		return SCSI_MLQUEUE_HOST_BUSY;
+	arcmsr_build_ccb(acb, pCCB, cmd);
+	arcmsr_post_ccb(acb, pCCB);
+	return 0;
+}
+
+static void arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
+		struct CommandControlBlock *ccb)
+{
+	u32 intmask;
+
+	ccb->startdone = ARCMSR_CCB_ABORTED;
+
+	/*
+	 * Wait for 3 sec for all command done.
+	 */
+	msleep_interruptible(3000);
+
+	intmask = arcmsr_disable_outbound_ints(acb);
+	arcmsr_polling_ccbdone(acb, ccb);
+	arcmsr_enable_outbound_ints(acb, intmask);
+}
+
+static int arcmsr_abort(struct scsi_cmnd *cmd)
+{
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)cmd->device->host->hostdata;
+	int i = 0;
+
+	printk(KERN_NOTICE
+	       "arcmsr%d: abort device command of scsi id=%d lun=%d\n",
+	       acb->host->host_no, cmd->device->id, cmd->device->lun);
+	acb->num_aborts++;
+
+	/*
+	 * First determine if we currently own this command.
+	 * Start by searching the device queue. If not found
+	 * at all, and the system wanted us to just abort the
+	 * command return success.
+	 */
+	if (!atomic_read(&acb->ccboutstandingcount))
+		return SUCCESS;
+
+	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		struct CommandControlBlock *ccb = acb->pccb_pool[i];
+		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
+			arcmsr_abort_one_cmd(acb, ccb);
+			break;
+		}
+	}
+
+	return SUCCESS;
+}
+
+static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
+{
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)cmd->device->host->hostdata;
+	int i;
+
+	acb->num_resets++;
+	acb->acb_flags |= ACB_F_BUS_RESET;
+	for (i = 0; i < 400; i++) {
+		if (!atomic_read(&acb->ccboutstandingcount))
+			break;
+		arcmsr_interrupt(acb);
+		msleep(25);
+	}
+	arcmsr_iop_reset(acb);
+	acb->acb_flags &= ~ACB_F_BUS_RESET;
+	return SUCCESS;
+}
+
 static int arcmsr_bios_param(struct scsi_device *sdev,
-	struct block_device *bdev, sector_t capacity, int *geom)
+		struct block_device *bdev, sector_t capacity, int *geom)
 {
 	int ret, heads, sectors, cylinders, total_capacity;
 	unsigned char *buffer;/* return copy of block device's partition table */
@@ -155,73 +600,73 @@
 	return 0;
 }
 
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *pCCB)
-{
-	struct AdapterControlBlock *acb = pCCB->pACB;
-	struct scsi_cmnd *pcmd = pCCB->pcmd;
-
-	if (pcmd->use_sg != 0) {
-		struct scatterlist *sl;
-
-		sl = (struct scatterlist *)pcmd->request_buffer;
-		pci_unmap_sg(acb->pdev, sl, pcmd->use_sg, pcmd->sc_data_direction);
-	}
-	else if (pcmd->request_bufflen != 0)
-		pci_unmap_single(acb->pdev,
-			(dma_addr_t)(unsigned long)pcmd->SCp.ptr,
-			pcmd->request_bufflen, pcmd->sc_data_direction);
-}
-
-static void arcmsr_ccb_complete(struct CommandControlBlock *pCCB, int stand_flag)
+static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
+		int queue_depth)
 {
-	struct AdapterControlBlock *acb = pCCB->pACB;
-	struct scsi_cmnd *pcmd = pCCB->pcmd;
-
-	arcmsr_pci_unmap_dma(pCCB);
-	if (stand_flag == 1)
-		atomic_dec(&acb->ccboutstandingcount);
-	pCCB->startdone = ARCMSR_CCB_DONE;
-	pCCB->ccb_flags = 0;
-	list_add_tail(&pCCB->list, &acb->ccb_free_list);
-	pcmd->scsi_done(pcmd);
+	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
+		queue_depth = ARCMSR_MAX_CMD_PERLUN;
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+	return queue_depth;
 }
 
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+static const char *arcmsr_info(struct Scsi_Host *host)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
-	char *acb_firm_model = acb->firm_model;
-	char *acb_firm_version = acb->firm_version;
-	char __iomem *iop_firm_model = (char __iomem *) &reg->message_rwbuffer[15];
-	char __iomem *iop_firm_version = (char __iomem *) &reg->message_rwbuffer[17];
-	int count;
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *) host->hostdata;
+	static char buf[256];
+	char *type;
+	int raid6 = 1;
 
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait "
-			"'get adapter firmware miscellaneous data' timeout \n",
-			acb->host->host_no);
-	count = 8;
-	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
-		acb_firm_model++;
-		iop_firm_model++;
-		count--;
-	}
-	count = 16;
-	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
-		acb_firm_version++;
-		iop_firm_version++;
-		count--;
+	switch (acb->pdev->device) {
+	case PCI_DEVICE_ID_ARECA_1110:
+	case PCI_DEVICE_ID_ARECA_1210:
+		raid6 = 0;
+		/*FALLTHRU*/
+	case PCI_DEVICE_ID_ARECA_1120:
+	case PCI_DEVICE_ID_ARECA_1130:
+	case PCI_DEVICE_ID_ARECA_1160:
+	case PCI_DEVICE_ID_ARECA_1170:
+	case PCI_DEVICE_ID_ARECA_1220:
+	case PCI_DEVICE_ID_ARECA_1230:
+	case PCI_DEVICE_ID_ARECA_1260:
+	case PCI_DEVICE_ID_ARECA_1270:
+	case PCI_DEVICE_ID_ARECA_1280:
+		type = "SATA";
+		break;
+	case PCI_DEVICE_ID_ARECA_1380:
+	case PCI_DEVICE_ID_ARECA_1381:
+	case PCI_DEVICE_ID_ARECA_1680:
+	case PCI_DEVICE_ID_ARECA_1681:
+		type = "SAS";
+		break;
+	default:
+		type = "X-TYPE";
+		break;
 	}
 
-	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
-	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
-	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
-	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
+	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n        %s",
+			type, raid6 ? "( RAID6 capable)" : "",
+			ARCMSR_DRIVER_VERSION);
+	return buf;
 }
 
+static struct scsi_host_template arcmsr_scsi_host_template = {
+	.module			= THIS_MODULE,
+	.name			= "ARCMSR ARECA SATA RAID HOST Adapter" ARCMSR_DRIVER_VERSION,
+	.info			= arcmsr_info,
+	.queuecommand		= arcmsr_queue_command,
+	.eh_abort_handler	= arcmsr_abort,
+	.eh_bus_reset_handler	= arcmsr_bus_reset,
+	.bios_param		= arcmsr_bios_param,
+	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
+	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
+	.this_id		= ARCMSR_SCSI_INITIATOR_ID,
+	.sg_tablesize		= ARCMSR_MAX_SG_ENTRIES,
+	.max_sectors    	= ARCMSR_MAX_XFER_SECTORS,
+	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= arcmsr_host_attrs,
+};
 
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
@@ -282,9 +727,6 @@
 				acb->host->host_no);
 	}
 
-	writel(readl(&reg->outbound_intmask) |
-			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-	       &reg->outbound_intmask);
 	return 0;
 }
 
@@ -311,8 +753,8 @@
 	outbound_doorbell = readl(&reg->outbound_doorbell);
 	writel(outbound_doorbell, &reg->outbound_doorbell);
 	writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
-	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
-			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
+	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
+			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
 	writel(intmask_org & mask, &reg->outbound_intmask);
 	acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
 	acb->acb_flags |= ACB_F_IOP_INITED;
@@ -400,6 +842,8 @@
 	if (error)
 		goto out_iounmap;
 
+	arcmsr_disable_outbound_ints(acb);
+
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
 			SA_INTERRUPT | SA_SHIRQ, "arcmsr", acb);
 	if (error)
@@ -444,9 +888,7 @@
 
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
-	writel(readl(&reg->outbound_intmask) |
-		ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-		&reg->outbound_intmask);
+	arcmsr_disable_outbound_ints(acb);
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
@@ -536,180 +978,64 @@
 
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit __iomem *reg=pACB->pmu;
-
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(pACB))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait 'flush adapter cache' timeout \n"
-			, pACB->host->host_no);
-}
-
-static void arcmsr_report_sense_info(struct CommandControlBlock *pCCB)
-{
-	struct scsi_cmnd *pcmd = pCCB->pcmd;
-	struct SENSE_DATA *psenseBuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-
-	pcmd->result = DID_OK << 16;
-	if (psenseBuffer) {
-		int sense_data_length =
-			sizeof (struct SENSE_DATA) < sizeof (pcmd->sense_buffer)
-			? sizeof (struct SENSE_DATA) : sizeof (pcmd->sense_buffer);
-		memset(psenseBuffer, 0, sizeof (pcmd->sense_buffer));
-		memcpy(psenseBuffer, pCCB->arcmsr_cdb.SenseData, sense_data_length);
-		psenseBuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
-		psenseBuffer->Valid = 1;
-	}
-}
-
-static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	uint32_t Index;
-	uint8_t Retries = 0x00;
-
-	do {
-		for(Index = 0; Index < 100; Index++) {
-			if (readl(&reg->outbound_intstatus)
-				& ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
-				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT
-					, &reg->outbound_intstatus);
-				return 0x00;
-			}
-			msleep_interruptible(10);
-		}/*max 1 seconds*/
-	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
-}
-
-void arcmsr_iop_reset(struct AdapterControlBlock *pACB)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	struct CommandControlBlock *pCCB;
-	uint32_t intmask_org, mask;
-	int i = 0;
-
-	if (atomic_read(&pACB->ccboutstandingcount) != 0) {
-		/* talk to iop 331 outstanding command aborted */
-		arcmsr_abort_allcmd(pACB);
-		/* wait for 3 sec for all command aborted*/
-		msleep_interruptible(3000);
-		/* disable all outbound interrupt */
-		intmask_org = readl(&reg->outbound_intmask);
-		writel(intmask_org | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-			&reg->outbound_intmask);
-		/* clear all outbound posted Q */
-		for(i = 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)
-			readl(&reg->outbound_queueport);
-		for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			pCCB = pACB->pccb_pool[i];
-			if (pCCB->startdone == ARCMSR_CCB_START) {
-				pCCB->startdone = ARCMSR_CCB_ABORTED;
-				pCCB->pcmd->result = DID_ABORT << 16;
-				arcmsr_ccb_complete(pCCB, 1);
-			}
-		}
-		/* enable all outbound interrupt */
-		mask =~ (ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
-			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
-		writel(intmask_org & mask, &reg->outbound_intmask);
-	}
-	atomic_set(&pACB->ccboutstandingcount, 0);
-}
-
-static void arcmsr_build_ccb(struct AdapterControlBlock *pACB, struct CommandControlBlock *pCCB,
-	struct scsi_cmnd *pcmd)
-{
-	struct ARCMSR_CDB *pARCMSR_CDB = (struct ARCMSR_CDB *)&pCCB->arcmsr_cdb;
-	int8_t *psge = (int8_t *)&pARCMSR_CDB->u;
-	uint32_t address_lo, address_hi;
-	int arccdbsize = 0x30;
-
-	pCCB->pcmd = pcmd;
-	memset(pARCMSR_CDB, 0, sizeof (struct ARCMSR_CDB));
-	pARCMSR_CDB->Bus = 0;
-	pARCMSR_CDB->TargetID = pcmd->device->id;
-	pARCMSR_CDB->LUN = pcmd->device->lun;
-	pARCMSR_CDB->Function = 1;
-	pARCMSR_CDB->CdbLength = (uint8_t)pcmd->cmd_len;
-	pARCMSR_CDB->Context = (unsigned long)pARCMSR_CDB;
-	memcpy(pARCMSR_CDB->Cdb, pcmd->cmnd, pcmd->cmd_len);
-	if (pcmd->use_sg) {
-		int length, sgcount, i, cdb_sgcount = 0;
-		struct scatterlist *sl;
-
-		/* Get Scatter Gather List from scsiport. */
-		sl = (struct scatterlist *) pcmd->request_buffer;
-		sgcount = pci_map_sg(pACB->pdev, sl, pcmd->use_sg,
-				pcmd->sc_data_direction);
-		/* map stor port SG list to our iop SG List. */
-		for(i = 0; i < sgcount; i++) {
-			/* Get the physical address of the current data pointer */
-			length = cpu_to_le32(sg_dma_len(sl));
-			address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sl)));
-			address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sl)));
-			if (address_hi == 0) {
-				struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
-
-				pdma_sg->address = address_lo;
-				pdma_sg->length = length;
-				psge += sizeof (struct SG32ENTRY);
-				arccdbsize += sizeof (struct SG32ENTRY);
-			} else {
-				struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
-
-				pdma_sg->addresshigh = address_hi;
-				pdma_sg->address = address_lo;
-				pdma_sg->length = length|IS_SG64_ADDR;
-				psge += sizeof (struct SG64ENTRY);
-				arccdbsize += sizeof (struct SG64ENTRY);
-			}
-			sl++;
-			cdb_sgcount++;
-		}
-		pARCMSR_CDB->sgcount = (uint8_t)cdb_sgcount;
-		pARCMSR_CDB->DataLength = pcmd->request_bufflen;
-		if ( arccdbsize > 256)
-			pARCMSR_CDB->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	} else if (pcmd->request_bufflen) {
-		dma_addr_t dma_addr;
-		dma_addr = pci_map_single(pACB->pdev, pcmd->request_buffer,
-				pcmd->request_bufflen, pcmd->sc_data_direction);
-		pcmd->SCp.ptr = (char *)(unsigned long) dma_addr;
-		address_lo = cpu_to_le32(dma_addr_lo32(dma_addr));
-		address_hi = cpu_to_le32(dma_addr_hi32(dma_addr));
-		if (address_hi == 0) {
-			struct  SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
-			pdma_sg->address = address_lo;
-			pdma_sg->length = pcmd->request_bufflen;
-		} else {
-			struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
-			pdma_sg->addresshigh = address_hi;
-			pdma_sg->address = address_lo;
-			pdma_sg->length = pcmd->request_bufflen|IS_SG64_ADDR;
-		}
-		pARCMSR_CDB->sgcount = 1;
-		pARCMSR_CDB->DataLength = pcmd->request_bufflen;
-	}
-	if (pcmd->sc_data_direction == DMA_TO_DEVICE ) {
-		pARCMSR_CDB->Flags |= ARCMSR_CDB_FLAG_WRITE;
-		pCCB->ccb_flags |= CCB_FLAG_WRITE;
-	}
+	struct MessageUnit __iomem *reg=pACB->pmu;
+
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	if (arcmsr_wait_msgint_ready(pACB))
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'flush adapter cache' timeout \n"
+			, pACB->host->host_no);
 }
 
-static void arcmsr_post_ccb(struct AdapterControlBlock *pACB, struct CommandControlBlock *pCCB)
+static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit __iomem *reg = pACB->pmu;
-	uint32_t cdb_shifted_phyaddr = pCCB->cdb_shifted_phyaddr;
-	struct ARCMSR_CDB *pARCMSR_CDB = (struct ARCMSR_CDB *)&pCCB->arcmsr_cdb;
+	uint32_t Index;
+	uint8_t Retries = 0x00;
 
-	atomic_inc(&pACB->ccboutstandingcount);
-	pCCB->startdone = ARCMSR_CCB_START;
-	if (pARCMSR_CDB->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-		writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
-			&reg->inbound_queueport);
-	else
-		writel(cdb_shifted_phyaddr, &reg->inbound_queueport);
+	do {
+		for(Index = 0; Index < 100; Index++) {
+			if (readl(&reg->outbound_intstatus)
+				& ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
+				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT
+					, &reg->outbound_intstatus);
+				return 0x00;
+			}
+			msleep_interruptible(10);
+		}/*max 1 seconds*/
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
+
+void arcmsr_iop_reset(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit __iomem *reg = pACB->pmu;
+	struct CommandControlBlock *pCCB;
+	uint32_t intmask_org;
+	int i = 0;
+
+	if (atomic_read(&pACB->ccboutstandingcount) != 0) {
+		/* talk to iop 331 outstanding command aborted */
+		arcmsr_abort_allcmd(pACB);
+		/* wait for 3 sec for all command aborted*/
+		msleep_interruptible(3000);
+		/* disable all outbound interrupt */
+		intmask_org = arcmsr_disable_outbound_ints(pACB);
+		/* clear all outbound posted Q */
+		for(i = 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)
+			readl(&reg->outbound_queueport);
+		for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			pCCB = pACB->pccb_pool[i];
+			if (pCCB->startdone == ARCMSR_CCB_START) {
+				pCCB->startdone = ARCMSR_CCB_ABORTED;
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB, 1);
+			}
+		}
+		/* enable all outbound interrupt */
+		arcmsr_enable_outbound_ints(pACB, intmask_org);
+	}
+	atomic_set(&pACB->ccboutstandingcount, 0);
 }
 
 void arcmsr_post_Qbuffer(struct AdapterControlBlock *pACB)
@@ -1130,374 +1456,3 @@
 	}
 	return retvalue;
 }
-
-static struct CommandControlBlock *arcmsr_get_freeccb(struct AdapterControlBlock *pACB)
-{
-	struct list_head *head = &pACB->ccb_free_list;
-	struct CommandControlBlock *pCCB = NULL;
-
-	if (!list_empty(head)) {
-		pCCB = list_entry(head->next, struct CommandControlBlock, list);
-		list_del(head->next);
-	}
-	return pCCB;
-}
-
-static int arcmsr_queue_command(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
-{
-	struct Scsi_Host *host = cmd->device->host;
-	struct AdapterControlBlock *pACB = (struct AdapterControlBlock *) host->hostdata;
-	struct CommandControlBlock *pCCB;
-	int target = cmd->device->id;
-	int lun = cmd->device->lun;
-	uint8_t scsicmd = cmd->cmnd[0];
-
-	cmd->scsi_done = done;
-	cmd->host_scribble = NULL;
-	cmd->result = 0;
-	if (scsicmd == SYNCHRONIZE_CACHE) {
-		/*
-		** 0x35 avoid synchronizing disk cache cmd after
-		** .remove : arcmsr_device_remove (linux bug)
-		*/
-		if (pACB->devstate[target][lun] == ARECA_RAID_GONE)
-			cmd->result = (DID_NO_CONNECT << 16);
-		cmd->scsi_done(cmd);
-		return 0;
-	}
-	if (pACB->acb_flags & ACB_F_BUS_RESET) {
-		printk(KERN_NOTICE "arcmsr%d: bus reset"
-			" and return busy \n"
-			, pACB->host->host_no);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-	if(target == 16) {
-		/* virtual device for iop message transfer */
-		switch(scsicmd) {
-		case INQUIRY: {
-				unsigned char inqdata[36];
-				char *buffer;
-
-				if(lun != 0) {
-					cmd->result = (DID_TIME_OUT << 16);
-					cmd->scsi_done(cmd);
-					return 0;
-				}
-				inqdata[0] = TYPE_PROCESSOR;
-				/* Periph Qualifier & Periph Dev Type */
-				inqdata[1] = 0;
-				/* rem media bit & Dev Type Modifier */
-				inqdata[2] = 0;
-				/* ISO,ECMA,& ANSI versions */
-				inqdata[4] = 31;
-				/* length of additional data */
-				strncpy(&inqdata[8], "Areca   ", 8);
-				/* Vendor Identification */
-				strncpy(&inqdata[16], "RAID controller ", 16);
-				/* Product Identification */
-				strncpy(&inqdata[32], "R001", 4); /* Product Revision */
-				if (cmd->use_sg) {
-					struct scatterlist *sg;
-
-					sg = (struct scatterlist *) cmd->request_buffer;
-					buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
-				} else {
-					buffer = cmd->request_buffer;
-				}
-				memcpy(buffer, inqdata, sizeof(inqdata));
-				if (cmd->use_sg) {
-					struct scatterlist *sg;
-
-					sg = (struct scatterlist *) cmd->request_buffer;
-					kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-				}
-				cmd->scsi_done(cmd);
-				return 0;
-			}
-		case WRITE_BUFFER:
-		case READ_BUFFER: {
-				if (arcmsr_iop_message_xfer(pACB, cmd)) {
-    					cmd->result = (DID_ERROR << 16);
-				}
-				cmd->scsi_done(cmd);
-				return 0;
-			}
-		default:
-			cmd->scsi_done(cmd);
-			return 0;
-		}
-	}
-	if (pACB->devstate[target][lun] == ARECA_RAID_GONE) {
-		uint8_t block_cmd;
-
-		block_cmd = cmd->cmnd[0] & 0x0f;
-		if (block_cmd == 0x08 || block_cmd == 0x0a) {
-			printk(KERN_NOTICE
-				"arcmsr%d: block 'read/write'"
-				"command with gone raid volume"
-				" Cmd=%2x, TargetId=%d, Lun=%d \n"
-				, pACB->host->host_no
-				, cmd->cmnd[0]
-				, target
-				, lun);
-			cmd->result = (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
-			return 0;
-		}
-	}
-	if (atomic_read(&pACB->ccboutstandingcount) < ARCMSR_MAX_OUTSTANDING_CMD) {
-		pCCB = arcmsr_get_freeccb(pACB);
-		if (pCCB) {
-			arcmsr_build_ccb(pACB, pCCB, cmd);
-			arcmsr_post_ccb(pACB, pCCB);
-			return 0;
-		}
-	}
-	return SCSI_MLQUEUE_HOST_BUSY;
-}
-
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *pACB, struct CommandControlBlock 	*poll_ccb)
-{
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	struct CommandControlBlock *pCCB;
-	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
-	int id, lun;
-
-polling_ccb_retry:
-	poll_count++;
-	outbound_intstatus = readl(&reg->outbound_intstatus)
-					& pACB->outbound_int_enable;
-	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
-	while (1) {
-		if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF) {
-			if (poll_ccb_done)
-				break;
-			else {
-				msleep(25);
-				if (poll_count > 100)
-					break;
-				goto polling_ccb_retry;
-			}
-		}
-		pCCB = (struct CommandControlBlock *)(pACB->vir2phy_offset + (flag_ccb << 5));
-		if ((pCCB->pACB != pACB) || (pCCB->startdone != ARCMSR_CCB_START)) {
-			if ((pCCB->startdone == ARCMSR_CCB_ABORTED) && (pCCB == poll_ccb)) {
-				printk(KERN_NOTICE
-					"arcmsr%d: scsi id=%d lun=%d ccb='0x%p'"
-					" poll command abort successfully \n"
-					, pACB->host->host_no
-					, pCCB->pcmd->device->id
-					, pCCB->pcmd->device->lun
-					, pCCB);
-				pCCB->pcmd->result = DID_ABORT << 16;
-				arcmsr_ccb_complete(pCCB, 1);
-				poll_ccb_done = 1;
-				continue;
-			}
-			printk(KERN_NOTICE
-				"arcmsr%d: polling get an illegal ccb"
-				" command done ccb='0x%p'"
-				"ccboutstandingcount=%d \n"
-				, pACB->host->host_no
-				, pCCB
-				, atomic_read(&pACB->ccboutstandingcount));
-			continue;
-		}
-		id = pCCB->pcmd->device->id;
-		lun = pCCB->pcmd->device->lun;
-		if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
-			if (pACB->devstate[id][lun] == ARECA_RAID_GONE)
-				pACB->devstate[id][lun] = ARECA_RAID_GOOD;
-			pCCB->pcmd->result = DID_OK << 16;
-			arcmsr_ccb_complete(pCCB, 1);
-		} else {
-			switch(pCCB->arcmsr_cdb.DeviceStatus) {
-			case ARCMSR_DEV_SELECT_TIMEOUT: {
-					pACB->devstate[id][lun] = ARECA_RAID_GONE;
-					pCCB->pcmd->result = DID_TIME_OUT << 16;
-					arcmsr_ccb_complete(pCCB, 1);
-				}
-				break;
-			case ARCMSR_DEV_ABORTED:
-			case ARCMSR_DEV_INIT_FAIL: {
-					pACB->devstate[id][lun] = ARECA_RAID_GONE;
-					pCCB->pcmd->result = DID_BAD_TARGET << 16;
-					arcmsr_ccb_complete(pCCB, 1);
-				}
-				break;
-			case ARCMSR_DEV_CHECK_CONDITION: {
-					pACB->devstate[id][lun] = ARECA_RAID_GOOD;
-					arcmsr_report_sense_info(pCCB);
-					arcmsr_ccb_complete(pCCB, 1);
-				}
-				break;
-			default:
-				printk(KERN_NOTICE
-					"arcmsr%d: scsi id=%d lun=%d"
-					" polling and getting command error done"
-					"but got unknown DeviceStatus = 0x%x \n"
-					, pACB->host->host_no
-					, id
-					, lun
-					, pCCB->arcmsr_cdb.DeviceStatus);
-				pACB->devstate[id][lun] = ARECA_RAID_GONE;
-				pCCB->pcmd->result = DID_BAD_TARGET << 16;
-				arcmsr_ccb_complete(pCCB, 1);
-				break;
-			}
-		}
-	}
-}
-
-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
-{
-	struct AdapterControlBlock *pACB;
-	int retry = 0;
-
-	pACB = (struct AdapterControlBlock *) cmd->device->host->hostdata;
-	printk(KERN_NOTICE "arcmsr%d: bus reset ..... \n", pACB->host->host_no);
-	pACB->num_resets++;
-	pACB->acb_flags |= ACB_F_BUS_RESET;
-	while (atomic_read(&pACB->ccboutstandingcount) != 0 && retry < 400) {
-		arcmsr_interrupt(pACB);
-		msleep(25);
-		retry++;
-	}
-	arcmsr_iop_reset(pACB);
-	pACB->acb_flags &= ~ACB_F_BUS_RESET;
-	return SUCCESS;
-}
-
-static int arcmsr_seek_cmd2abort(struct scsi_cmnd *abortcmd)
-{
-	struct AdapterControlBlock *pACB = (struct AdapterControlBlock *)
-			abortcmd->device->host->hostdata;
-	struct MessageUnit __iomem *reg = pACB->pmu;
-	struct CommandControlBlock *pCCB;
-	uint32_t intmask_org, mask;
-	int i = 0;
-
-	pACB->num_aborts++;
-	/*
-	*****************************************************************
-	** It is the upper layer do abort command this lock just prior
-	** to calling us.
-	** First determine if we currently own this command.
-	** Start by searching the device queue. If not found
-	** at all, and the system wanted us to just abort the
-	** command return success.
-	*****************************************************************
-	*/
-	if (atomic_read(&pACB->ccboutstandingcount) != 0) {
-		for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			pCCB = pACB->pccb_pool[i];
-			if (pCCB->startdone == ARCMSR_CCB_START) {
-				if (pCCB->pcmd == abortcmd) {
-					pCCB->startdone = ARCMSR_CCB_ABORTED;
-					printk(KERN_NOTICE
-					"arcmsr%d: scsi id=%d lun=%d"
-					" abort ccb '0x%p' outstanding command\n"
-					, pACB->host->host_no
-					, abortcmd->device->id
-					, abortcmd->device->lun
-					, pCCB);
-					goto abort_outstanding_cmd;
-				}
-			}
-		}
-	}
-	return SUCCESS;
-abort_outstanding_cmd:
-	/*wait for 3 sec for all command done*/
-	msleep_interruptible(3000);
-	/* disable all outbound interrupt */
-	intmask_org = readl(&reg->outbound_intmask);
-	writel(intmask_org | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE
-		, &reg->outbound_intmask);
-	arcmsr_polling_ccbdone(pACB, pCCB);
-	/* enable all outbound interrupt */
-	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
-			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
-	writel(intmask_org & mask, &reg->outbound_intmask);
-	return SUCCESS;
-}
-
-static int arcmsr_cmd_abort(struct scsi_cmnd *cmd)
-{
-	struct AdapterControlBlock *pACB = (struct AdapterControlBlock *)
-			 cmd->device->host->hostdata;
-	int error;
-
-	printk(KERN_NOTICE
-		"arcmsr%d: abort device command of scsi id=%d lun=%d \n"
-		, pACB->host->host_no
-		, cmd->device->id
-		, cmd->device->lun);
-	/*
-	************************************************
-	** the all interrupt service routine is locked
-	** we need to handle it as soon as possible and exit
-	************************************************
-	*/
-	error = arcmsr_seek_cmd2abort(cmd);
-	if (error != SUCCESS)
-		printk(KERN_NOTICE
-		"arcmsr%d: abort command failed scsi id=%d lun=%d \n"
-		, pACB->host->host_no
-		, cmd->device->id
-		, cmd->device->lun);
-	return error;
-}
-
-static const char *arcmsr_info(struct Scsi_Host *host)
-{
-	static char buf[256];
-	struct AdapterControlBlock *pACB;
-	uint16_t device_id;
-
-	pACB = (struct AdapterControlBlock *) host->hostdata;
-	device_id = pACB->pdev->device;
-	switch(device_id) {
-	case PCI_DEVICE_ID_ARECA_1110:
-	case PCI_DEVICE_ID_ARECA_1210:{
-			sprintf(buf,
-			"ARECA SATA HOST ADAPTER RAID CONTROLLER "
-			"\n        %s"
-			, ARCMSR_DRIVER_VERSION);
-			break;
-		}
-	case PCI_DEVICE_ID_ARECA_1120:
-	case PCI_DEVICE_ID_ARECA_1130:
-	case PCI_DEVICE_ID_ARECA_1160:
-	case PCI_DEVICE_ID_ARECA_1170:
-	case PCI_DEVICE_ID_ARECA_1220:
-	case PCI_DEVICE_ID_ARECA_1230:
-	case PCI_DEVICE_ID_ARECA_1260:
-	case PCI_DEVICE_ID_ARECA_1270:
-	case PCI_DEVICE_ID_ARECA_1280: {
-			sprintf(buf,
-			"ARECA SATA HOST ADAPTER RAID CONTROLLER "
-			"(RAID6-ENGINE Inside)\n        %s"
-			, ARCMSR_DRIVER_VERSION);
-			break;
-		}
-	case PCI_DEVICE_ID_ARECA_1380:
-	case PCI_DEVICE_ID_ARECA_1381:
-	case PCI_DEVICE_ID_ARECA_1680:
-	case PCI_DEVICE_ID_ARECA_1681: {
-			sprintf(buf,
-			"ARECA SAS HOST ADAPTER RAID CONTROLLER "
-			"(RAID6-ENGINE Inside)\n        %s"
-			, ARCMSR_DRIVER_VERSION);
-			break;
-		}
-	default: {
-			sprintf(buf,
-			"ARECA X-TYPE HOST ADAPTER RAID CONTROLLER "
-			"(RAID6-ENGINE Inside)\n        %s"
-			, ARCMSR_DRIVER_VERSION);
-			break;
-		}
-	}
-	return buf;
-}
