From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH 2/3] 3ware 5/6/7/8000 driver v1.26.02.000
Date: Thu, 9 Sep 2004 14:21:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <I3SM0D00.NO8@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:8645 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S267511AbUIIVVu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 17:21:50 -0400
Received: from mailhost02.amcc.com ([192.195.69.49]) by
          hadar.amcc.com (Netscape Messaging Server 4.15) with SMTP id
          I3SM0D00.NO8 for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004
          14:21:49 -0700
Received: (from ving-pc [10.66.6.122])
 by mailhost02.amcc.com (SMSSMTP 4.0.0.59) with SMTP id M2004090914223820769
 for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2004 14:22:38 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

diff -Naur linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c
--- linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c	2004-08-14 03:56:22.000000000 -0700
+++ linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c	2004-09-08 17:41:45.000000000 -0700
@@ -1369,1263 +1288,737 @@
 
 	tw_dev->pending_head = TW_Q_START;
 	tw_dev->pending_tail = TW_Q_START;
-	spin_lock_init(&tw_dev->tw_lock);
 	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
 
+	init_MUTEX(&tw_dev->ioctl_sem);
+	init_waitqueue_head(&tw_dev->ioctl_wqueue);
+
 	return 0;
 } /* End tw_initialize_device_extension() */
 
-/* This function will get unit info from the controller */
-int tw_initialize_units(TW_Device_Extension *tw_dev) 
+static int tw_map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	int found = 0;
-	unsigned char request_id = 0;
-	TW_Command *command_packet;
-	TW_Param *param;
-	int i, imax, num_units = 0;
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	u32 response_que_addr;
-	TW_Response_Queue response_queue;
-	unsigned long param_value;
-	unsigned char *is_unit_present;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_initialize_units()\n");
+	int use_sg;
 
-	command_que_addr = tw_dev->registers.command_que_addr;
-	response_que_addr = tw_dev->registers.response_que_addr;
-  
-	/* Setup the command packet */
+	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data()\n");
+	
+	if (cmd->use_sg == 0)
+		return 0;
+
+	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
+	
+	if (use_sg == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.\n");
+		return 0;
+	}
+
+	cmd->SCp.phase = TW_PHASE_SGLIST;
+	cmd->SCp.have_data_in = use_sg;
+	
+	return use_sg;
+} /* End tw_map_scsi_sg_data() */
+
+static u32 tw_map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
+{
+	dma_addr_t mapping;
+
+	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_single_data()\n");
+
+	if (cmd->request_bufflen == 0)
+		return 0;
+
+	mapping = pci_map_page(pdev, virt_to_page(cmd->request_buffer), offset_in_page(cmd->request_buffer), cmd->request_bufflen, DMA_BIDIRECTIONAL);
+
+	if (mapping == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_single_data(): pci_map_page() failed.\n");
+		return 0;
+	}
+
+	cmd->SCp.phase = TW_PHASE_SINGLE;
+	cmd->SCp.have_data_in = mapping;
+
+	return mapping;
+} /* End tw_map_scsi_single_data() */
+
+static void tw_unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
+{
+	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
+
+	switch(cmd->SCp.phase) {
+		case TW_PHASE_SINGLE:
+			pci_unmap_page(pdev, cmd->SCp.have_data_in, cmd->request_bufflen, DMA_BIDIRECTIONAL);
+			break;
+		case TW_PHASE_SGLIST:
+			pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
+			break;
+	}
+} /* End tw_unmap_scsi_data() */
+
+/* This function will reset a device extension */
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset) 
+{
+	int i = 0;
+	struct scsi_cmnd *srb;
+	unsigned long flags = 0;
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_reset_device_extension()\n");
+
+	set_bit(TW_IN_RESET, &tw_dev->flags);
+	TW_DISABLE_INTERRUPTS(tw_dev);
+	TW_MASK_COMMAND_INTERRUPT(tw_dev);
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+
+	/* Abort all requests that are in progress */
+	for (i=0;i<TW_Q_LENGTH;i++) {
+		if ((tw_dev->state[i] != TW_S_FINISHED) && 
+		    (tw_dev->state[i] != TW_S_INITIAL) &&
+		    (tw_dev->state[i] != TW_S_COMPLETED)) {
+			srb = tw_dev->srb[i];
+			if (srb != NULL) {
+				srb->result = (DID_RESET << 16);
+				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
+				tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[i]);
+			}
+		}
+	}
+
+	/* Reset queues and counts */
+	for (i=0;i<TW_Q_LENGTH;i++) {
+		tw_dev->free_queue[i] = i;
+		tw_dev->state[i] = TW_S_INITIAL;
+	}
+	tw_dev->free_head = TW_Q_START;
+	tw_dev->free_tail = TW_Q_START;
+	tw_dev->posted_request_count = 0;
+	tw_dev->pending_request_count = 0;
+	tw_dev->pending_head = TW_Q_START;
+	tw_dev->pending_tail = TW_Q_START;
+	tw_dev->reset_print = 0;
+
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+
+	if (tw_reset_sequence(tw_dev)) {
+		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset sequence failed.\n", tw_dev->host->host_no);
+		return 1;
+	}
+	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+
+	/* Wake up any ioctl that was pending before the reset */
+	if ((tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE) || (ioctl_reset)) {
+		clear_bit(TW_IN_RESET, &tw_dev->flags);
+	} else {
+		tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+		wake_up(&tw_dev->ioctl_wqueue);
+	}
+
+	return 0;
+} /* End tw_reset_device_extension() */
+
+/* This funciton returns unit geometry in cylinders/heads/sectors */
+static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+		sector_t capacity, int geom[]) 
+{
+	int heads, sectors, cylinders;
+	TW_Device_Extension *tw_dev;
+	
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_biosparam()\n");
+	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
+
+	heads = 64;
+	sectors = 32;
+	cylinders = sector_div(capacity, heads * sectors);
+
+	if (capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		cylinders = sector_div(capacity, heads * sectors);
+	}
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_biosparam(): heads = %d, sectors = %d, cylinders = %d\n", heads, sectors, cylinders);
+	geom[0] = heads;			 
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	return 0;
+} /* End tw_scsi_biosparam() */
+
+/* This is the new scsi eh reset function */
+static int tw_scsi_eh_reset(struct scsi_cmnd *SCpnt) 
+{
+	TW_Device_Extension *tw_dev=NULL;
+	int retval = FAILED;
+
+	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+
+	spin_unlock_irq(tw_dev->host->host_lock);
+
+	tw_dev->num_resets++;
+
+	printk(KERN_WARNING "3w-xxxx: scsi%d: WARNING: Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, SCpnt->device->id, SCpnt->cmnd[0]);
+
+	/* Now reset the card and some of the device extension data */
+	if (tw_reset_device_extension(tw_dev, 0)) {
+		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
+		goto out;
+	}
+
+	retval = SUCCESS;
+out:
+	spin_lock_irq(tw_dev->host->host_lock);
+	return retval;
+} /* End tw_scsi_eh_reset() */
+
+/* This function handles scsi inquiry commands */
+static int tw_scsiop_inquiry(TW_Device_Extension *tw_dev, int request_id)
+{
+	TW_Param *param;
+	TW_Command *command_packet;
+	unsigned long command_que_value;
+	unsigned long param_value;
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry()\n");
+
+	/* Initialize command packet */
 	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
 	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): Bad command packet virtual address.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad command packet virtual address.\n");
 		return 1;
 	}
 	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode      = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset  = 2;
-	command_packet->size              = 4;
-	command_packet->request_id        = request_id;
-	command_packet->byte3.unit        = 0;
-	command_packet->byte3.host_id     = 0;
-	command_packet->status            = 0;
-	command_packet->flags             = 0;
-	command_packet->byte6.block_count = 1;
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size = 4;
+	command_packet->request_id = request_id;
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.parameter_count = 1;
 
 	/* Now setup the param */
 	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): Bad alignment virtual address.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad alignment virtual address.\n");
 		return 1;
 	}
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = 3;       /* unit summary table */
-	param->parameter_id = 3;   /* unitstatus parameter */
+	param->table_id = 3;	 /* unit summary table */
+	param->parameter_id = 3; /* unitsstatus parameter */
 	param->parameter_size_bytes = TW_MAX_UNITS;
 	param_value = tw_dev->alignment_physical_address[request_id];
 	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): Bad alignment physical address.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad alignment physical address.\n");
 		return 1;
 	}
 
 	command_packet->byte8.param.sgl[0].address = param_value;
 	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-
-	/* Post the command packet to the board */
 	command_que_value = tw_dev->command_packet_physical_address[request_id];
 	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): Bad command packet physical address.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad command packet physical address.\n");
 		return 1;
 	}
-	outl(command_que_value, command_que_addr);
 
-	/* Poll for completion */
-	if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
-		response_queue.value = inl(response_que_addr);
-		request_id = (unsigned char)response_queue.u.response_id;
-		if (request_id != 0) {
-			/* unexpected request id */
-			printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): Unexpected request id.\n");
-			return 1;
-		}
-		if (command_packet->status != 0) {
-			/* bad response */
-			tw_decode_sense(tw_dev, request_id, 0);
-			return 1;
-		}
-		found = 1;
-	}
-	if (found == 0) {
-		/* response never received */
-		printk(KERN_WARNING "3w-xxxx: tw_initialize_units(): No response.\n");
+	/* Now try to post the command packet */
+	tw_post_command_packet(tw_dev, request_id);
+
+	return 0;
+} /* End tw_scsiop_inquiry() */
+
+/* This function is called by the isr to complete an inquiry command */
+static int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_id)
+{
+	unsigned char *is_unit_present;
+	unsigned char *request_buffer;
+	TW_Param *param;
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry_complete()\n");
+
+	/* Fill request buffer */
+	if (tw_dev->srb[request_id]->request_buffer == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Request buffer NULL.\n");
 		return 1;
 	}
+	request_buffer = tw_dev->srb[request_id]->request_buffer;
+	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	request_buffer[0] = TYPE_DISK; /* Peripheral device type */
+	request_buffer[1] = 0;	       /* Device type modifier */
+	request_buffer[2] = 0;	       /* No ansi/iso compliance */
+	request_buffer[4] = 31;	       /* Additional length */
+	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
+	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
+	memcpy(&request_buffer[32], tw_driver_version, 3);
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	is_unit_present = (unsigned char *)&(param->data[0]);
-  
-	/* Show all units present */
-	imax = TW_MAX_UNITS;
-	for(i=0; i<imax; i++) {
-		if (is_unit_present[i] == 0) {
-			tw_dev->is_unit_present[i] = FALSE;
-		} else {
-		  if (is_unit_present[i] & TW_UNIT_ONLINE) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_initialize_units(): Unit %d found.\n", i);
-			tw_dev->is_unit_present[i] = TRUE;
-			num_units++;
-		  }
-		}
+	if (param == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Bad alignment virtual address.\n");
+		return 1;
 	}
-	tw_dev->num_units = num_units;
+	is_unit_present = &(param->data[0]);
 
-	if (num_units == 0) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_initialize_units(): No units found.\n");
-		return 1;
+	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
+		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
+	} else {
+		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
+		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
+		return TW_ISR_DONT_RESULT;
 	}
 
 	return 0;
-} /* End tw_initialize_units() */
+} /* End tw_scsiop_inquiry_complete() */
 
-/* This function is the interrupt service routine */
-static irqreturn_t tw_interrupt(int irq, void *dev_instance,
-					struct pt_regs *regs) 
+/* This function handles scsi mode_sense commands */
+static int tw_scsiop_mode_sense(TW_Device_Extension *tw_dev, int request_id)
 {
-	int request_id;
-	u32 status_reg_addr, status_reg_value;
-	u32 response_que_addr;
-	TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
-	TW_Response_Queue response_que;
-	int error = 0, retval = 0;
-	unsigned long flags = 0;
+	TW_Param *param;
 	TW_Command *command_packet;
-	int handled = 0;
+	unsigned long command_que_value;
+	unsigned long param_value;
 
-	dprintk(KERN_WARNING "3w-xxxx: tw_interrupt()\n");
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense()\n");
 
-	/* See if we are already running on another processor */
-	if (test_and_set_bit(TW_IN_INTR, &tw_dev->flags))
-		return IRQ_NONE;
+	/* Only page control = 0, page code = 0x8 (cache page) supported */
+	if (tw_dev->srb[request_id]->cmnd[2] != 0x8) {
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		tw_state_request_finish(tw_dev, request_id);
+		tw_dev->srb[request_id]->result = (DID_OK << 16);
+		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+		return 0;
+	}
 
-	/* Get the host lock for io completions */
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	/* Now read firmware cache setting for this unit */
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	if (command_packet == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad command packet virtual address.\n");
+		return 1;
+	}
 
-	/* See if the interrupt matches this instance */
-	if (tw_dev->tw_pci_dev->irq == irq) {
+	/* Setup the command packet */
+	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size = 4;
+	command_packet->request_id = request_id;
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.parameter_count = 1;
 
-		handled = 1;
-		/* Make sure io isn't queueing */
-		spin_lock(&tw_dev->tw_lock);
+	/* Setup the param */
+	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad alignment virtual address.\n");
+		return 1;
+	}
 
-		/* Read the registers */
-		status_reg_addr = tw_dev->registers.status_reg_addr;
-		response_que_addr = tw_dev->registers.response_que_addr;
-		status_reg_value = inl(status_reg_addr);
-
-		/* Check if this is our interrupt, otherwise bail */
-		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
-			goto tw_interrupt_bail;
-
-		/* Check controller for errors */
-		if (tw_check_bits(status_reg_value)) {
-			dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
-			if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
-				tw_clear_all_interrupts(tw_dev);
-				goto tw_interrupt_bail;
-			}
-		}
-
-		/* Handle host interrupt */
-		if (status_reg_value & TW_STATUS_HOST_INTERRUPT) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received host interrupt.\n");
-			tw_clear_host_interrupt(tw_dev);
-		}
-
-		/* Handle attention interrupt */
-		if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention interrupt.\n");
-			tw_clear_attention_interrupt(tw_dev);
-			tw_state_request_start(tw_dev, &request_id);
-			error = tw_aen_read_queue(tw_dev, request_id);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen queue.\n", tw_dev->host->host_no);
-				tw_dev->state[request_id] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, request_id);
-			}
-		}
-
-		/* Handle command interrupt */
-		if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
-			/* Drain as many pending commands as we can */
-			while (tw_dev->pending_request_count > 0) {
-				request_id = tw_dev->pending_queue[tw_dev->pending_head];
-				if (tw_dev->state[request_id] != TW_S_PENDING) {
-					printk(KERN_WARNING "3w-xxxx: scsi%d: Found request id that wasn't pending.\n", tw_dev->host->host_no);
-					break;
-				}
-				if (tw_post_command_packet(tw_dev, request_id)==0) {
-					if (tw_dev->pending_head == TW_Q_LENGTH-1) {
-						tw_dev->pending_head = TW_Q_START;
-					} else {
-						tw_dev->pending_head = tw_dev->pending_head + 1;
-					}
-					tw_dev->pending_request_count--;
-				} else {
-					/* If we get here, we will continue re-posting on the next command interrupt */
-					break;
-				}
-			}
-			/* If there are no more pending requests, we mask command interrupt */
-			if (tw_dev->pending_request_count == 0) 
-				tw_mask_command_interrupt(tw_dev);
-		}
-
-		/* Handle response interrupt */
-		if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
-			/* Drain the response queue from the board */
-			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-				/* Read response queue register */
-				response_que.value = inl(response_que_addr);
-				request_id = response_que.u.response_id;
-				command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-				error = 0;
-
-				/* Check for bad response */
-				if (command_packet->status != 0) {
-					/* If internal command, don't error, don't fill sense */
-					if (tw_dev->srb[request_id] == 0) {
-						tw_decode_sense(tw_dev, request_id, 0);
-					} else {
-						error = tw_decode_sense(tw_dev, request_id, 1);
-					}
-				}
-
-				/* Check for correct state */
-				if (tw_dev->state[request_id] != TW_S_POSTED) {
-					/* Handle timed out ioctl's */
-					if (tw_dev->srb[request_id] != 0) {
-						if (tw_dev->srb[request_id]->cmnd[0] != TW_IOCTL) {
-							printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id (%d) (opcode = 0x%x) that wasn't posted.\n", tw_dev->host->host_no, request_id, command_packet->byte0.opcode);
-							error = 1;
-						}
-					}
-				}
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	memset(param, 0, sizeof(TW_Sector));
+	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + tw_dev->srb[request_id]->device->id;
+	param->parameter_id = 7; /* unit flags */
+	param->parameter_size_bytes = 1;
+	param_value = tw_dev->alignment_physical_address[request_id];
+	if (param_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad alignment physical address.\n");
+		return 1;
+	}
 
-				dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue request id: %d.\n", request_id);
+	command_packet->byte8.param.sgl[0].address = param_value;
+	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad command packet physical address.\n");
+		return 1;
+	}
 
-				/* Check for internal command completion */
-				if (tw_dev->srb[request_id] == 0) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Found internally posted command.\n");
-					/* Check for chrdev ioctl completion */
-					if (request_id != tw_dev->chrdev_request_id) {
-						retval = tw_aen_complete(tw_dev, request_id);
-						if (retval) {
-							printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing aen.\n", tw_dev->host->host_no);
-						}
-					} else {
-						tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-						wake_up(&tw_dev->ioctl_wqueue);
-					}
-				} else {
-				switch (tw_dev->srb[request_id]->cmnd[0]) {
-					case READ_10:
-					case READ_6:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_10/READ_6\n");
-						break;
-					case WRITE_10:
-					case WRITE_6:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught WRITE_10/WRITE_6\n");
-						break;
-					case TEST_UNIT_READY:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught TEST_UNIT_READY\n");
-						error = tw_scsiop_test_unit_ready_complete(tw_dev, request_id);
-						break;
-					case INQUIRY:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught INQUIRY\n");
-						error = tw_scsiop_inquiry_complete(tw_dev, request_id);
-						break;
-					case READ_CAPACITY:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_CAPACITY\n");
-						error = tw_scsiop_read_capacity_complete(tw_dev, request_id);
-						break;
-					case MODE_SENSE:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught MODE_SENSE\n");
-						error = tw_scsiop_mode_sense_complete(tw_dev, request_id);
-						break;
-					case SYNCHRONIZE_CACHE:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught SYNCHRONIZE_CACHE\n");
-						break;
-					case TW_IOCTL:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught TW_IOCTL\n");
-						error = tw_ioctl_complete(tw_dev, request_id);
-						break;
-					default:
-						printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
-						error = 1;
-					}
+	/* Now try to post the command packet */
+	tw_post_command_packet(tw_dev, request_id);
+	
+	return 0;
+} /* End tw_scsiop_mode_sense() */
 
-					/* If no error command was a success */
-					if (error == 0) {
-						tw_dev->srb[request_id]->result = (DID_OK << 16);
-					}
+/* This function is called by the isr to complete a mode sense command */
+static int tw_scsiop_mode_sense_complete(TW_Device_Extension *tw_dev, int request_id)
+{
+	TW_Param *param;
+	unsigned char *flags;
+	unsigned char *request_buffer;
 
-					/* If error, command failed */
-					if (error == 1) {
-						/* Ask for a host reset */
-						tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-					}
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense_complete()\n");
 
-					/* Now complete the io */
-					if ((error != TW_ISR_DONT_COMPLETE)) {
-						tw_dev->state[request_id] = TW_S_COMPLETED;
-						tw_state_request_finish(tw_dev, request_id);
-						tw_dev->posted_request_count--;
-						tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	if (param == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense_complete(): Bad alignment virtual address.\n");
+		return 1;
+	}
+	flags = (char *)&(param->data[0]);
+	request_buffer = tw_dev->srb[request_id]->buffer;
+	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
 
-						tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-					}
-				}
-				
-				/* Check for valid status after each drain */
-				status_reg_value = inl(status_reg_addr);
-				if (tw_check_bits(status_reg_value)) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
-					if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
-						tw_clear_all_interrupts(tw_dev);
-						goto tw_interrupt_bail;
-					}
-				}
-			}
-		}
-tw_interrupt_bail:
-		spin_unlock(&tw_dev->tw_lock);
-	} else
-		dprintk(KERN_WARNING "3w-xxxx: tw_interrupt() called for wrong instance.\n");
+	request_buffer[0] = 0xf;        /* mode data length */
+	request_buffer[1] = 0;          /* default medium type */
+	request_buffer[2] = 0x10;       /* dpo/fua support on */
+	request_buffer[3] = 0;          /* no block descriptors */
+	request_buffer[4] = 0x8;        /* caching page */
+	request_buffer[5] = 0xa;        /* page length */
+	if (*flags & 0x1)
+		request_buffer[6] = 0x4;        /* WCE on */
+	else
+		request_buffer[6] = 0x0;        /* WCE off */
 
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
-	clear_bit(TW_IN_INTR, &tw_dev->flags);
-	return IRQ_RETVAL(handled);
-} /* End tw_interrupt() */
+	return 0;
+} /* End tw_scsiop_mode_sense_complete() */
 
-/* This function handles ioctls from userspace to the driver */
-int tw_ioctl(TW_Device_Extension *tw_dev, int request_id)
+/* This function handles scsi read_capacity commands */
+static int tw_scsiop_read_capacity(TW_Device_Extension *tw_dev, int request_id) 
 {
-	unsigned char opcode;
-	int bufflen, error = 0;
 	TW_Param *param;
-	TW_Command *command_packet, *command_save;
+	TW_Command *command_packet;
+	unsigned long command_que_value;
 	unsigned long param_value;
-	TW_Ioctl *ioctl = NULL;
-	TW_Passthru *passthru = NULL;
-	int tw_aen_code, i, use_sg;
-	unsigned long *data_ptr;
-	int total_bytes = 0, posted = 0;
-	dma_addr_t dma_handle;
-	struct timeval before, timeout;
 
-	ioctl = (TW_Ioctl *)tw_dev->srb[request_id]->request_buffer;
-	if (ioctl == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Request buffer NULL.\n");
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-		return 0;
-	}
-	bufflen = tw_dev->srb[request_id]->request_bufflen;
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity()\n");
 
 	/* Initialize command packet */
 	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+
 	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Bad command packet virtual address.\n");
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-		return 0;
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad command packet virtual address.\n");
+		return 1;
 	}
 	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size = 4;
+	command_packet->request_id = request_id;
+	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.block_count = 1;
 
-	/* Initialize param */
+	/* Now setup the param */
 	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Bad alignment virtual address.\n");
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-		return 0;
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad alignment virtual address.\n");
+		return 1;
 	}
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
-
-	dprintk(KERN_NOTICE "opcode = %d table_id = %d parameter_id = %d parameter_size_bytes = %d\n", ioctl->opcode, ioctl->table_id, ioctl->parameter_id, ioctl->parameter_size_bytes);
-	opcode = ioctl->opcode;
-
-	switch (opcode) {
-		case TW_OP_NOP:
-			dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): caught TW_OP_NOP.\n");
-			command_packet->byte0.opcode = TW_OP_NOP;
-			break;
-		case TW_OP_GET_PARAM:
-			dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): caught TW_OP_GET_PARAM.\n");
-			command_packet->byte0.opcode = TW_OP_GET_PARAM;
-			command_packet->byte3.unit = ioctl->unit_index;
-			param->table_id = ioctl->table_id;
-			param->parameter_id = ioctl->parameter_id;
-			param->parameter_size_bytes = ioctl->parameter_size_bytes;
-			tw_dev->ioctl_size[request_id] = ioctl->parameter_size_bytes;
-			dprintk(KERN_NOTICE "table_id = %d parameter_id = %d parameter_size_bytes %d\n", param->table_id, param->parameter_id, param->parameter_size_bytes);
-			break;
-		case TW_OP_SET_PARAM:
-			dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): caught TW_OP_SET_PARAM: table_id = %d, parameter_id = %d, parameter_size_bytes = %d.\n",
-			ioctl->table_id, ioctl->parameter_id, ioctl->parameter_size_bytes);
-			if (ioctl->data != NULL) {
-				command_packet->byte0.opcode = TW_OP_SET_PARAM;
-				param->table_id = ioctl->table_id;
-				param->parameter_id = ioctl->parameter_id;
-				param->parameter_size_bytes = ioctl->parameter_size_bytes;
-				memcpy(param->data, ioctl->data, ioctl->parameter_size_bytes);
-				break;
-			} else {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl(): ioctl->data NULL.\n");
-				return 1;
-			}
-		case TW_OP_AEN_LISTEN:
-			dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): caught TW_OP_AEN_LISTEN.\n");
-			if (tw_dev->aen_head == tw_dev->aen_tail) {
-				/* aen queue empty */
-				dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): Aen queue empty.\n");
-				tw_aen_code = TW_AEN_QUEUE_EMPTY;
-				memcpy(tw_dev->srb[request_id]->request_buffer, &tw_aen_code, ioctl->parameter_size_bytes);
-			} else {
-				/* Copy aen queue entry to request buffer */
-				dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl(): Returning aen 0x%x\n", tw_dev->aen_queue[tw_dev->aen_head]);
-				tw_aen_code = tw_dev->aen_queue[tw_dev->aen_head];
-				memcpy(tw_dev->srb[request_id]->request_buffer, &tw_aen_code, ioctl->parameter_size_bytes);
-				if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
-					tw_dev->aen_head = TW_Q_START;
-				} else {
-					tw_dev->aen_head = tw_dev->aen_head + 1;
-				}
-			}
-			tw_dev->state[request_id] = TW_S_COMPLETED;
-			tw_state_request_finish(tw_dev, request_id);
-			tw_dev->srb[request_id]->result = (DID_OK << 16);
-			tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-			return 0;
-		case TW_ATA_PASSTHRU:
-			if (ioctl->data != NULL) {
-				memcpy(command_packet, ioctl->data, sizeof(TW_Command));
-				command_packet->request_id = request_id;
-			} else {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl(): ioctl->data NULL.\n");
-				return 1;
-			}
-
-			passthru = (TW_Passthru *)tw_dev->command_packet_virtual_address[request_id];
-			/* Don't load sg_list for non-data ATA cmds */
-			if ((passthru->param != 0) && (passthru->param != 0x8)) {
-				passthru->sg_list[0].length = passthru->sector_count*512;
-				if (passthru->sg_list[0].length > TW_MAX_PASSTHRU_BYTES) {
-					printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Passthru size (%d) too big.\n", passthru->sg_list[0].length);
-					return 1;
-				}
-				passthru->sg_list[0].address = tw_dev->alignment_physical_address[request_id];
-			}
-			tw_post_command_packet(tw_dev, request_id);
-			return 0;
-		case TW_CMD_PACKET:
-			dprintk(KERN_WARNING "3w-xxxx: tw_ioctl(): caught TW_CMD_PACKET.\n");
-			if (ioctl->data != NULL) {
-				memcpy(command_packet, ioctl->data, sizeof(TW_Command));
-				command_packet->request_id = request_id;
-				tw_post_command_packet(tw_dev, request_id);
-				return 0;
-			} else {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl(): ioctl->data NULL.\n");
-				return 1;
-			}
-		case TW_CMD_PACKET_WITH_DATA:
-			dprintk(KERN_WARNING "3w-xxxx: tw_ioctl(): caught TW_CMD_PACKET_WITH_DATA.\n");
-			command_save = (TW_Command *)tw_dev->alignment_virtual_address[request_id];
-			if (command_save == NULL) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Bad alignment virtual address.\n", tw_dev->host->host_no);
-				return 1;
-			}
-			if (ioctl->data != NULL) {
-				/* Copy down the command packet */
-				memcpy(command_packet, ioctl->data, sizeof(TW_Command));
-				memcpy(command_save, ioctl->data, sizeof(TW_Command));
-				command_packet->request_id = request_id;
-
-				/* Now deal with the two possible sglists */
-				if (command_packet->byte0.sgl_offset == 2) {
-					use_sg = command_packet->size - 3;
-					for (i=0;i<use_sg;i++)
-						total_bytes+=command_packet->byte8.param.sgl[i].length;
-					tw_dev->ioctl_data[request_id] = pci_alloc_consistent(tw_dev->tw_pci_dev, total_bytes, &dma_handle);
-
-					if (!tw_dev->ioctl_data[request_id]) {
-						printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): pci_alloc_consistent() failed for request_id %d.\n", tw_dev->host->host_no, request_id);
-						return 1;
-					}
-
-					/* Copy param sglist into the kernel */
-					data_ptr = tw_dev->ioctl_data[request_id];
-					for (i=0;i<use_sg;i++) {
-						if (command_packet->byte8.param.sgl[i].address != 0) {
-							error = copy_from_user(data_ptr, (void *)(unsigned long)command_packet->byte8.param.sgl[i].address, command_packet->byte8.param.sgl[i].length);
-							if (error) {
-								dprintk(KERN_WARNING "3w-xxxx: scsi%d: Error copying param sglist from userspace.\n", tw_dev->host->host_no);
-								goto tw_ioctl_bail;
-							}
-						} else {
-							printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Bad param sgl address.\n", tw_dev->host->host_no);
-							tw_dev->srb[request_id]->result = (DID_RESET << 16);
-							goto tw_ioctl_bail;
-						}
-						data_ptr+=command_packet->byte8.param.sgl[i].length;
-					}
-					command_packet->size = 4;
-					command_packet->byte8.param.sgl[0].address = dma_handle;
-					command_packet->byte8.param.sgl[0].length = total_bytes;
-				}
-				if (command_packet->byte0.sgl_offset == 3) {
-					use_sg = command_packet->size - 4;
-					for (i=0;i<use_sg;i++)
-						total_bytes+=command_packet->byte8.io.sgl[i].length;
-					tw_dev->ioctl_data[request_id] = pci_alloc_consistent(tw_dev->tw_pci_dev, total_bytes, &dma_handle);
-
-					if (!tw_dev->ioctl_data[request_id]) {
-						printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): pci_alloc_consistent() failed for request_id %d.\n", tw_dev->host->host_no, request_id);
-						return 1;
-					}
-					if (command_packet->byte0.opcode == TW_OP_WRITE) {
-						/* Copy io sglist into the kernel */
-						data_ptr = tw_dev->ioctl_data[request_id];
-						for (i=0;i<use_sg;i++) {
-							if (command_packet->byte8.io.sgl[i].address != 0) {
-								error = copy_from_user(data_ptr, (void *)(unsigned long)command_packet->byte8.io.sgl[i].address, command_packet->byte8.io.sgl[i].length);
-								if (error) {
-									dprintk(KERN_WARNING "3w-xxxx: scsi%d: Error copying io sglist from userspace.\n", tw_dev->host->host_no);
-									goto tw_ioctl_bail;
-								}
-							} else {
-								printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Bad io sgl address.\n", tw_dev->host->host_no);
-								tw_dev->srb[request_id]->result = (DID_RESET << 16);
-								goto tw_ioctl_bail;
-							}
-							data_ptr+=command_packet->byte8.io.sgl[i].length;
-						}
-					}
-					command_packet->size = 5;
-					command_packet->byte8.io.sgl[0].address = dma_handle;
-					command_packet->byte8.io.sgl[0].length = total_bytes;
-				}
-
-				spin_unlock(&tw_dev->tw_lock);
-				spin_unlock_irq(tw_dev->host->host_lock);
-
-				set_bit(TW_IN_IOCTL, &tw_dev->flags);
-
-				/* Finally post the command packet */
-				tw_post_command_packet(tw_dev, request_id);
-				posted = 1;
-				do_gettimeofday(&before);
-
-			tw_ioctl_retry:
-				mdelay(TW_IOCTL_WAIT_TIME);
-				if (test_bit(TW_IN_IOCTL, &tw_dev->flags)) {
-					do_gettimeofday(&timeout);
-					if (before.tv_sec + TW_IOCTL_TIMEOUT < timeout.tv_sec) {
-						spin_lock_irq(tw_dev->host->host_lock);
-						spin_lock(&tw_dev->tw_lock);
-						goto tw_ioctl_bail;
-					} else {
-						goto tw_ioctl_retry;
-					}
-				}
-
-				spin_lock_irq(tw_dev->host->host_lock);
-				spin_lock(&tw_dev->tw_lock);
-
-				if (signal_pending(current)) {
-					dprintk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Signal pending, aborting ioctl().\n", tw_dev->host->host_no);
-					tw_dev->srb[request_id]->result = (DID_OK << 16);
-					goto tw_ioctl_bail;
-				}
-
-				tw_dev->srb[request_id]->result = (DID_OK << 16);
-				/* Now copy up the param or io sglist to userspace */
-				if (command_packet->byte0.sgl_offset == 2) {
-					use_sg = command_save->size - 3;
-					data_ptr = tw_dev->ioctl_data[request_id];
-					for (i=0;i<use_sg;i++) {
-						if (command_save->byte8.param.sgl[i].address != 0) {
-							error = copy_to_user((void *)(unsigned long)command_save->byte8.param.sgl[i].address, data_ptr, command_save->byte8.param.sgl[i].length);
-							if (error) {
-								dprintk(KERN_WARNING "3w-xxxx: scsi%d: Error copying param sglist to userspace.\n", tw_dev->host->host_no);
-								goto tw_ioctl_bail;
-							}
-							dprintk(KERN_WARNING "3w-xxxx: scsi%d: Copied %ld bytes to pid %d.\n", tw_dev->host->host_no, command_save->byte8.param.sgl[i].length, current->pid);
-							data_ptr+=command_save->byte8.param.sgl[i].length;
-						} else {
-							printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Bad param sgl address.\n", tw_dev->host->host_no);
-							tw_dev->srb[request_id]->result = (DID_RESET << 16);
-							goto tw_ioctl_bail;
-						}
-					}
-				}
-				if (command_packet->byte0.sgl_offset == 3) {
-					use_sg = command_save->size - 4;
-					if (command_packet->byte0.opcode == TW_OP_READ) {
-						data_ptr = tw_dev->ioctl_data[request_id];
-						for(i=0;i<use_sg;i++) {
-							if (command_save->byte8.io.sgl[i].address != 0) {
-								error = copy_to_user((void *)(unsigned long)command_save->byte8.io.sgl[i].address, data_ptr, command_save->byte8.io.sgl[i].length);
-								if (error) {
-									dprintk(KERN_WARNING "3w-xxxx: scsi%d: Error copying io sglist to userspace.\n", tw_dev->host->host_no);
-									goto tw_ioctl_bail;
-								}
-								dprintk(KERN_WARNING "3w-xxxx: scsi%d: Copied %ld bytes to pid %d.\n", tw_dev->host->host_no, command_save->byte8.io.sgl[i].length, current->pid);
-								data_ptr+=command_save->byte8.io.sgl[i].length;
-							} else {
-								printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Bad io sgl address.\n", tw_dev->host->host_no);
-								tw_dev->srb[request_id]->result = (DID_RESET << 16);
-								goto tw_ioctl_bail;
-							}
-						}
-					}
-				}
-				
-			tw_ioctl_bail:
-
-				/* Free up sglist memory */
-				if (tw_dev->ioctl_data[request_id])
-					pci_free_consistent(tw_dev->tw_pci_dev, total_bytes, tw_dev->ioctl_data[request_id], dma_handle);
-				else
-					printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl(): Error freeing ioctl data.\n", tw_dev->host->host_no);
-				
-				/* Now complete the io */
-				tw_dev->state[request_id] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, request_id);
-				if (posted)
-					tw_dev->posted_request_count--;
-				tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-				return 0;
-			} else {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl(): ioctl->data NULL.\n");
-				return 1;
-			}
-		default:
-			dprintk(KERN_WARNING "3w-xxxx: Unknown ioctl 0x%x.\n", opcode);
-			tw_dev->state[request_id] = TW_S_COMPLETED;
-			tw_state_request_finish(tw_dev, request_id);
-			tw_dev->srb[request_id]->result = (DID_OK << 16);
-			tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-			return 0;
-	}
-
+	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + 
+	tw_dev->srb[request_id]->device->id;
+	param->parameter_id = 4;	/* unitcapacity parameter */
+	param->parameter_size_bytes = 4;
 	param_value = tw_dev->alignment_physical_address[request_id];
 	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Bad alignment physical address.\n");
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad alignment physical address.\n");
+		return 1;
 	}
-
+  
 	command_packet->byte8.param.sgl[0].address = param_value;
 	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad command packet physical address.\n");
+		return 1;
+	}
 
 	/* Now try to post the command to the board */
 	tw_post_command_packet(tw_dev, request_id);
-
+  
 	return 0;
-} /* End tw_ioctl() */
+} /* End tw_scsiop_read_capacity() */
 
-/* This function is called by the isr to complete ioctl requests */
-int tw_ioctl_complete(TW_Device_Extension *tw_dev, int request_id)
+/* This function is called by the isr to complete a readcapacity command */
+static int tw_scsiop_read_capacity_complete(TW_Device_Extension *tw_dev, int request_id)
 {
 	unsigned char *param_data;
-	unsigned char *buff;
+	u32 capacity;
+	char *buff;
 	TW_Param *param;
-	TW_Ioctl *ioctl = NULL;
-	TW_Passthru *passthru = NULL;
-	TW_Command *command_packet;
 
-	ioctl = (TW_Ioctl *)tw_dev->srb[request_id]->request_buffer;
-	dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl_complete()\n");
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete()\n");
+
 	buff = tw_dev->srb[request_id]->request_buffer;
 	if (buff == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl_complete(): Request buffer NULL.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Request buffer NULL.\n");
 		return 1;
 	}
-
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: tw_ioctl_complete(): Bad command packet virtual address.\n", tw_dev->host->host_no);
+	memset(buff, 0, tw_dev->srb[request_id]->request_bufflen);
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	if (param == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Bad alignment virtual address.\n");
 		return 1;
 	}
+	param_data = &(param->data[0]);
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_ioctl_complete(): Request_bufflen = %d\n", tw_dev->srb[request_id]->request_bufflen);
+	capacity = (param_data[3] << 24) | (param_data[2] << 16) | 
+		   (param_data[1] << 8) | param_data[0];
 
-	ioctl = (TW_Ioctl *)buff;
-	switch (ioctl->opcode) {
-		case TW_ATA_PASSTHRU:
-			passthru = (TW_Passthru *)ioctl->data;
-			/* Don't return data for non-data ATA cmds */
-			if ((passthru->param != 0) && (passthru->param != 0x8))
-				memcpy(buff, tw_dev->alignment_virtual_address[request_id], passthru->sector_count * 512);
-			else {
-				/* For non-data cmds, return cmd pkt */
-				if (tw_dev->srb[request_id]->request_bufflen >= sizeof(TW_Command))
-					memcpy(buff, tw_dev->command_packet_virtual_address[request_id], sizeof(TW_Command));
-			}
-			break;
-		case TW_CMD_PACKET_WITH_DATA:
-			dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_complete(): caught TW_CMD_PACKET_WITH_DATA.\n");
-			clear_bit(TW_IN_IOCTL, &tw_dev->flags);
-			return TW_ISR_DONT_COMPLETE; /* Special case for isr to not complete io */
-		default:
-			memset(buff, 0, tw_dev->srb[request_id]->request_bufflen);
-			param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-			if (param == NULL) {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl_complete(): Bad alignment virtual address.\n");
-				return 1;
-			}
-			param_data = &(param->data[0]);
-			memcpy(buff, param_data, tw_dev->ioctl_size[request_id]);
-	}
-	return 0;
-} /* End tw_ioctl_complete() */
+	/* Subtract one sector to fix get last sector ioctl */
+	capacity -= 1;
 
-static int tw_map_scsi_sg_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
-{
-	int use_sg;
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete(): Capacity = 0x%x.\n", capacity);
 
-	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data()\n");
-	
-	if (cmd->use_sg == 0)
-		return 0;
+	/* Number of LBA's */
+	buff[0] = (capacity >> 24);
+	buff[1] = (capacity >> 16) & 0xff;
+	buff[2] = (capacity >> 8) & 0xff;
+	buff[3] = capacity & 0xff;
 
-	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, dma_dir);
-	
-	if (use_sg == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.\n");
-		return 0;
-	}
+	/* Block size in bytes (512) */
+	buff[4] = (TW_BLOCK_SIZE >> 24);
+	buff[5] = (TW_BLOCK_SIZE >> 16) & 0xff;
+	buff[6] = (TW_BLOCK_SIZE >> 8) & 0xff;
+	buff[7] = TW_BLOCK_SIZE & 0xff;
 
-	cmd->SCp.phase = 2;
-	cmd->SCp.have_data_in = use_sg;
-	
-	return use_sg;
-} /* End tw_map_scsi_sg_data() */
+	return 0;
+} /* End tw_scsiop_read_capacity_complete() */
 
-static u32 tw_map_scsi_single_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
+/* This function handles scsi read or write commands */
+static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id) 
 {
-	dma_addr_t mapping;
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-
-	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_single_data()\n");
+	TW_Command *command_packet;
+	unsigned long command_que_value;
+	u32 lba = 0x0, num_sectors = 0x0, buffaddr = 0x0;
+	int i, use_sg;
+	struct scsi_cmnd *srb;
+	struct scatterlist *sglist;
 
-	if (cmd->request_bufflen == 0)
-		return 0;
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write()\n");
 
-	mapping = pci_map_page(pdev, virt_to_page(cmd->request_buffer), offset_in_page(cmd->request_buffer), cmd->request_bufflen, dma_dir);
+	if (tw_dev->srb[request_id]->request_buffer == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_write(): Request buffer NULL.\n");
+		return 1;
+	}
+	sglist = (struct scatterlist *)tw_dev->srb[request_id]->request_buffer;
+	srb = tw_dev->srb[request_id];
 
-	if (mapping == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_single_data(): pci_map_page() failed.\n");
-		return 0;
+	/* Initialize command packet */
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	if (command_packet == NULL) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): Bad command packet virtual address.\n");
+		return 1;
 	}
 
-	cmd->SCp.phase = 1;
-	cmd->SCp.have_data_in = mapping;
+	if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == READ_10) {
+		command_packet->opcode__sgloffset = TW_OPSGL_IN(3, TW_OP_READ);
+	} else {
+		command_packet->opcode__sgloffset = TW_OPSGL_IN(3, TW_OP_WRITE);
+	}
 
-	return mapping;
-} /* End tw_map_scsi_single_data() */
+	command_packet->size = 3;
+	command_packet->request_id = request_id;
+	command_packet->unit__hostid = TW_UNITHOST_IN(0, srb->device->id);
+	command_packet->status = 0;
+	command_packet->flags = 0;
 
-/* This function will mask the command interrupt */
-void tw_mask_command_interrupt(TW_Device_Extension *tw_dev)
-{
-	u32 control_reg_addr, control_reg_value;
-	
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_CONTROL_MASK_COMMAND_INTERRUPT;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_mask_command_interrupt() */
+	if (srb->cmnd[0] == WRITE_10) {
+		if ((srb->cmnd[1] & 0x8) || (srb->cmnd[1] & 0x10))
+			command_packet->flags = 1;
+	}
 
-/* This function will poll the status register for a flag */
-int tw_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds)
-{
-	u32 status_reg_addr, status_reg_value;
-	struct timeval before, timeout;
+	if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == WRITE_6) {
+		lba = ((u32)srb->cmnd[1] << 16) | ((u32)srb->cmnd[2] << 8) | (u32)srb->cmnd[3];
+		num_sectors = (u32)srb->cmnd[4];
+	} else {
+		lba = ((u32)srb->cmnd[2] << 24) | ((u32)srb->cmnd[3] << 16) | ((u32)srb->cmnd[4] << 8) | (u32)srb->cmnd[5];
+		num_sectors = (u32)srb->cmnd[8] | ((u32)srb->cmnd[7] << 8);
+	}
+  
+	/* Update sector statistic */
+	tw_dev->sector_count = num_sectors;
+	if (tw_dev->sector_count > tw_dev->max_sector_count)
+		tw_dev->max_sector_count = tw_dev->sector_count;
+  
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): lba = 0x%x num_sectors = 0x%x\n", lba, num_sectors);
+	command_packet->byte8.io.lba = lba;
+	command_packet->byte6.block_count = num_sectors;
 
-	status_reg_addr = tw_dev->registers.status_reg_addr;
-	do_gettimeofday(&before);
-	status_reg_value = inl(status_reg_addr);
+	/* Do this if there are no sg list entries */
+	if (tw_dev->srb[request_id]->use_sg == 0) {    
+		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): SG = 0\n");
+		buffaddr = tw_map_scsi_single_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
+		if (buffaddr == 0)
+			return 1;
 
-	if (tw_check_bits(status_reg_value)) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_poll_status(): Unexpected bits.\n");
-		tw_decode_bits(tw_dev, status_reg_value, 0);
+		command_packet->byte8.io.sgl[0].address = buffaddr;
+		command_packet->byte8.io.sgl[0].length = tw_dev->srb[request_id]->request_bufflen;
+		command_packet->size+=2;
 	}
-		
-	while ((status_reg_value & flag) != flag) {
-		status_reg_value = inl(status_reg_addr);
-
-		if (tw_check_bits(status_reg_value)) {
-			dprintk(KERN_WARNING "3w-xxxx: tw_poll_status(): Unexpected bits.\n");
-			tw_decode_bits(tw_dev, status_reg_value, 0);
-		}
 
-		do_gettimeofday(&timeout);
-		if (before.tv_sec + seconds < timeout.tv_sec) { 
-			dprintk(KERN_WARNING "3w-xxxx: tw_poll_status(): Flag 0x%x not found.\n", flag);
+	/* Do this if we have multiple sg list entries */
+	if (tw_dev->srb[request_id]->use_sg > 0) {
+		use_sg = tw_map_scsi_sg_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
+		if (use_sg == 0)
 			return 1;
+
+		for (i=0;i<use_sg; i++) {
+			command_packet->byte8.io.sgl[i].address = sg_dma_address(&sglist[i]);
+			command_packet->byte8.io.sgl[i].length = sg_dma_len(&sglist[i]);
+			command_packet->size+=2;
 		}
-		mdelay(5);
 	}
-	return 0;
-} /* End tw_poll_status() */
 
-/* This function will poll the status register for disappearance of a flag */
-int tw_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int seconds)
-{
-	u32 status_reg_addr, status_reg_value;
-	struct timeval before, timeout;
-
-	status_reg_addr = tw_dev->registers.status_reg_addr;
-	do_gettimeofday(&before);
-	status_reg_value = inl(status_reg_addr);
+	/* Update SG statistics */
+	tw_dev->sgl_entries = tw_dev->srb[request_id]->use_sg;
+	if (tw_dev->sgl_entries > tw_dev->max_sgl_entries)
+		tw_dev->max_sgl_entries = tw_dev->sgl_entries;
 
-	if (tw_check_bits(status_reg_value)) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_poll_status_gone(): Unexpected bits.\n");
-		tw_decode_bits(tw_dev, status_reg_value, 0);
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_scsiop_read_write(): Bad command packet physical address.\n");
+		return 1;
 	}
+      
+	/* Now try to post the command to the board */
+	tw_post_command_packet(tw_dev, request_id);
 
-	while ((status_reg_value & flag) != 0) {
-		status_reg_value = inl(status_reg_addr);
+	return 0;
+} /* End tw_scsiop_read_write() */
 
-		if (tw_check_bits(status_reg_value)) {
-			dprintk(KERN_WARNING "3w-xxxx: tw_poll_status_gone(): Unexpected bits.\n");
-			tw_decode_bits(tw_dev, status_reg_value, 0);
-		}
-
-		do_gettimeofday(&timeout);
-		if (before.tv_sec + seconds < timeout.tv_sec) {
-			dprintk(KERN_WARNING "3w-xxxx: tw_poll_status_gone(): Flag 0x%x never disappeared.\n", flag);
-			return 1;
-		}
-		mdelay(5);
-	}
-	return 0;
-} /* End tw_poll_status_gone() */
-
-/* This function will attempt to post a command packet to the board */
-int tw_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
+/* This function will handle the request sense scsi command */
+static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 {
-	u32 status_reg_addr, status_reg_value;
-	unsigned long command_que_value;
-	u32 command_que_addr;
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_post_command_packet()\n");
-	command_que_addr = tw_dev->registers.command_que_addr;
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	status_reg_addr = tw_dev->registers.status_reg_addr;
-	status_reg_value = inl(status_reg_addr);
+	/* For now we just zero the request buffer */
+	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	tw_dev->state[request_id] = TW_S_COMPLETED;
+	tw_state_request_finish(tw_dev, request_id);
 
-	if (tw_check_bits(status_reg_value)) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_post_command_packet(): Unexpected bits.\n");
-		tw_decode_bits(tw_dev, status_reg_value, 1);
-	}
+	/* If we got a request_sense, we probably want a reset, return error */
+	tw_dev->srb[request_id]->result = (DID_ERROR << 16);
+	tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 
-	if ((status_reg_value & TW_STATUS_COMMAND_QUEUE_FULL) == 0) {
-		/* We successfully posted the command packet */
-		outl(command_que_value, command_que_addr);
-		tw_dev->state[request_id] = TW_S_POSTED;
-		tw_dev->posted_request_count++;
-		if (tw_dev->posted_request_count > tw_dev->max_posted_request_count) {
-			tw_dev->max_posted_request_count = tw_dev->posted_request_count;
-		}
-	} else {
-		/* Couldn't post the command packet, so we do it in the isr */
-		if (tw_dev->state[request_id] != TW_S_PENDING) {
-			tw_dev->state[request_id] = TW_S_PENDING;
-			tw_dev->pending_request_count++;
-			if (tw_dev->pending_request_count > tw_dev->max_pending_request_count) {
-				tw_dev->max_pending_request_count = tw_dev->pending_request_count;
-			}
-			tw_dev->pending_queue[tw_dev->pending_tail] = request_id;
-			if (tw_dev->pending_tail == TW_Q_LENGTH-1) {
-				tw_dev->pending_tail = TW_Q_START;
-			} else {
-				tw_dev->pending_tail = tw_dev->pending_tail + 1;
-			}
-		} 
-		tw_unmask_command_interrupt(tw_dev);
-		return 1;
-	}
 	return 0;
-} /* End tw_post_command_packet() */
+} /* End tw_scsiop_request_sense() */
 
-/* This function will reset a device extension */
-int tw_reset_device_extension(TW_Device_Extension *tw_dev) 
+/* This function will handle synchronize cache scsi command */
+static int tw_scsiop_synchronize_cache(TW_Device_Extension *tw_dev, int request_id)
 {
-	int imax = 0;
-	int i = 0;
-	Scsi_Cmnd *srb;
+	TW_Command *command_packet;
+	unsigned long command_que_value;
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_reset_device_extension()\n");
-	imax = TW_Q_LENGTH;
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_synchronize_cache()\n");
 
-	if (tw_reset_sequence(tw_dev)) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset sequence failed.\n", tw_dev->host->host_no);
+	/* Send firmware flush command for this unit */
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	if (command_packet == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_synchronize_cache(): Bad command packet virtual address.\n");
 		return 1;
 	}
 
-	/* Abort all requests that are in progress */
-	for (i=0;i<imax;i++) {
-		if ((tw_dev->state[i] != TW_S_FINISHED) && 
-		    (tw_dev->state[i] != TW_S_INITIAL) &&
-		    (tw_dev->state[i] != TW_S_COMPLETED)) {
-			srb = tw_dev->srb[i];
-			if (srb != NULL) {
-				srb->result = (DID_RESET << 16);
-				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
-				tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[i]);
-			}
-		}
+	/* Setup the command packet */
+	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(0, TW_OP_FLUSH_CACHE);
+	command_packet->size = 2;
+	command_packet->request_id = request_id;
+	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.parameter_count = 1;
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_synchronize_cache(): Bad command packet physical address.\n");
+		return 1;
 	}
 
-	/* Reset queues and counts */
-	for (i=0;i<imax;i++) {
-		tw_dev->free_queue[i] = i;
-		tw_dev->state[i] = TW_S_INITIAL;
-	}
-	tw_dev->free_head = TW_Q_START;
-	tw_dev->free_tail = TW_Q_START;
-	tw_dev->posted_request_count = 0;
-	tw_dev->pending_request_count = 0;
-	tw_dev->pending_head = TW_Q_START;
-	tw_dev->pending_tail = TW_Q_START;
-	tw_dev->reset_print = 0;
-	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+	/* Now try to post the command packet */
+	tw_post_command_packet(tw_dev, request_id);
 
 	return 0;
-} /* End tw_reset_device_extension() */
+} /* End tw_scsiop_synchronize_cache() */
 
-/* This function will reset a controller */
-int tw_reset_sequence(TW_Device_Extension *tw_dev) 
+/* This function will handle test unit ready scsi command */
+static int tw_scsiop_test_unit_ready(TW_Device_Extension *tw_dev, int request_id)
 {
-	int error = 0;
-	int tries = 0;
-
-	/* Disable interrupts */
-	tw_disable_interrupts(tw_dev);
-
-	/* Reset the board */
-	while (tries < TW_MAX_RESET_TRIES) {
-		tw_soft_reset(tw_dev);
-
-		error = tw_aen_drain_queue(tw_dev);
-		if (error) {
-			printk(KERN_WARNING "3w-xxxx: scsi%d: AEN drain failed, retrying.\n", tw_dev->host->host_no);
-			tries++;
-			continue;
-		}
+	TW_Param *param;
+	TW_Command *command_packet;
+	unsigned long command_que_value;
+	unsigned long param_value;
 
-		/* Check for controller errors */
-		if (tw_check_errors(tw_dev)) {
-			printk(KERN_WARNING "3w-xxxx: scsi%d: Controller errors found, retrying.\n", tw_dev->host->host_no);
-			tries++;
-			continue;
-		}
+	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_test_unit_ready()\n");
 
-		/* Now the controller is in a good state */
-		break;
+	/* Initialize command packet */
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	if (command_packet == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad command packet virtual address.\n");
+		return 1;
 	}
+	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size = 4;
+	command_packet->request_id = request_id;
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.parameter_count = 1;
 
-	if (tries >= TW_MAX_RESET_TRIES) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Controller errors, card not responding, check all cabling.\n", tw_dev->host->host_no);
+	/* Now setup the param */
+	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad alignment virtual address.\n");
 		return 1;
 	}
-
-	error = tw_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS);
-	if (error) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Connection initialization failed.\n", tw_dev->host->host_no);
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	memset(param, 0, sizeof(TW_Sector));
+	param->table_id = 3;	 /* unit summary table */
+	param->parameter_id = 3; /* unitsstatus parameter */
+	param->parameter_size_bytes = TW_MAX_UNITS;
+	param_value = tw_dev->alignment_physical_address[request_id];
+	if (param_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad alignment physical address.\n");
 		return 1;
 	}
 
-	/* Re-enable interrupts */
-	tw_enable_and_clear_interrupts(tw_dev);
-
-	return 0;
-} /* End tw_reset_sequence() */
-
-/* This funciton returns unit geometry in cylinders/heads/sectors */
-int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-		sector_t capacity, int geom[]) 
-{
-	int heads, sectors, cylinders;
-	TW_Device_Extension *tw_dev;
-	
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_biosparam()\n");
-	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
-
-	heads = 64;
-	sectors = 32;
-	cylinders = (unsigned long)capacity / (heads * sectors);
-
-	if (capacity >= 0x200000) {
-		heads = 255;
-		sectors = 63;
-		cylinders = (unsigned long)capacity / (heads * sectors);
+	command_packet->byte8.param.sgl[0].address = param_value;
+	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad command packet physical address.\n");
+		return 1;
 	}
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_biosparam(): heads = %d, sectors = %d, cylinders = %d\n", heads, sectors, cylinders);
-	geom[0] = heads;			 
-	geom[1] = sectors;
-	geom[2] = cylinders;
+	/* Now try to post the command packet */
+	tw_post_command_packet(tw_dev, request_id);
 
 	return 0;
-} /* End tw_scsi_biosparam() */
-
-/* This function will find and initialize any cards */
-int tw_scsi_detect(Scsi_Host_Template *tw_host)
-{
-	int ret;
-	
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_detect()\n");
-
-	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", tw_driver_version);
-
-	ret = tw_findcards(tw_host);
-
-	return ret;
-} /* End tw_scsi_detect() */
+} /* End tw_scsiop_test_unit_ready() */
 
-/* This is the new scsi eh abort function */
-int tw_scsi_eh_abort(Scsi_Cmnd *SCpnt) 
+/* This function is called by the isr to complete a testunitready command */
+static int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int request_id)
 {
-	TW_Device_Extension *tw_dev=NULL;
-	int i = 0;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_eh_abort()\n");
+	unsigned char *is_unit_present;
+	TW_Param *param;
 
-	if (!SCpnt) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_abort(): Invalid Scsi_Cmnd.\n");
-		return (FAILED);
-	}
+	dprintk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready_complete()\n");
 
-	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
-	if (tw_dev == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_abort(): Invalid device extension.\n");
-		return (FAILED);
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	if (param == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready_complete(): Bad alignment virtual address.\n");
+		return 1;
 	}
+	is_unit_present = &(param->data[0]);
 
-	spin_lock(&tw_dev->tw_lock);
-	tw_dev->num_aborts++;
-
-	/* If the command hasn't been posted yet, we can do the abort */
-	for (i=0;i<TW_Q_LENGTH;i++) {
-		if (tw_dev->srb[i] == SCpnt) {
-			if (tw_dev->state[i] == TW_S_STARTED) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Unit #%d: Command (%p) timed out.\n", tw_dev->host->host_no, tw_dev->srb[i]==0 ? 0 : tw_dev->srb[i]->device->id, SCpnt);
-				tw_dev->state[i] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, i);
-				spin_unlock(&tw_dev->tw_lock);
-				return (SUCCESS);
-			}
-			if (tw_dev->state[i] == TW_S_PENDING) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Unit #%d: Command (%p) timed out.\n", tw_dev->host->host_no, tw_dev->srb[i]==0 ? 0 : tw_dev->srb[i]->device->id, SCpnt);
-				if (tw_dev->pending_head == TW_Q_LENGTH-1) {
-					tw_dev->pending_head = TW_Q_START;
-				} else {
-					tw_dev->pending_head = tw_dev->pending_head + 1;
-				}
-				tw_dev->pending_request_count--;
-				tw_dev->state[i] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, i);
-				spin_unlock(&tw_dev->tw_lock);
-				return (SUCCESS);
-			}
-			if (tw_dev->state[i] == TW_S_POSTED) {
-				/* If the command has already been posted, we have to reset the card */
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Unit #%d: Command (%p) timed out, resetting card.\n", tw_dev->host->host_no, tw_dev->srb[i]==0 ? 0 : tw_dev->srb[i]->device->id, SCpnt);
-				/* We have to let AEN requests through before the reset */
-				spin_unlock(&tw_dev->tw_lock);
-				spin_unlock_irq(tw_dev->host->host_lock);
-				mdelay(TW_AEN_WAIT_TIME);
-				spin_lock_irq(tw_dev->host->host_lock);
-				spin_lock(&tw_dev->tw_lock);
-
-				if (tw_reset_device_extension(tw_dev)) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_scsi_eh_abort(): Reset failed for card %d.\n", tw_dev->host->host_no);
-					spin_unlock(&tw_dev->tw_lock);
-					return (FAILED);
-				}
-			}
-		}
+	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
+		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
+	} else {
+		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
+		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
+		return TW_ISR_DONT_RESULT;
 	}
 
-	spin_unlock(&tw_dev->tw_lock);
-	return (SUCCESS);
-} /* End tw_scsi_eh_abort() */
+	return 0;
+} /* End tw_scsiop_test_unit_ready_complete() */
 
-/* This is the new scsi eh reset function */
-int tw_scsi_eh_reset(Scsi_Cmnd *SCpnt) 
+/* This is the main scsi queue function to handle scsi opcodes */
+static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) 
 {
-	TW_Device_Extension *tw_dev=NULL;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_eh_reset()\n");
-
-	if (!SCpnt) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_reset(): Invalid Scsi_Cmnd.\n");
-		return (FAILED);
-	}
-
-	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
-	if (tw_dev == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_reset(): Invalid device extension.\n");
-		return (FAILED);
-	}
+	unsigned char *command = SCpnt->cmnd;
+	int request_id = 0;
+	int retval = 1;
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
-	/* We have to let AEN requests through before the reset */
-	spin_unlock_irq(tw_dev->host->host_lock);
-	mdelay(TW_AEN_WAIT_TIME);
-	spin_lock_irq(tw_dev->host->host_lock);
+	/* Save done function into Scsi_Cmnd struct */
+	SCpnt->scsi_done = done;
+		 
+	/* Queue the command and get a request id */
+	tw_state_request_start(tw_dev, &request_id);
 
-	spin_lock(&tw_dev->tw_lock);
-	tw_dev->num_resets++;
+	/* Save the scsi command for use by the ISR */
+	tw_dev->srb[request_id] = SCpnt;
 
-	/* Now reset the card and some of the device extension data */
-	if (tw_reset_device_extension(tw_dev)) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
-		spin_unlock(&tw_dev->tw_lock);
-		return (FAILED);
-	}
-	printk(KERN_WARNING "3w-xxxx: scsi%d: Reset succeeded.\n", tw_dev->host->host_no);
-	spin_unlock(&tw_dev->tw_lock);
-
-	return (SUCCESS);
-} /* End tw_scsi_eh_reset() */
-
-/* This function handles input and output from /proc/scsi/3w-xxxx/x */
-int tw_scsi_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
-		      off_t offset, int length, int inout) 
-{
-	TW_Device_Extension *tw_dev = NULL;
-	TW_Info info;
-	int i;
-	int j;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_proc_info()\n");
-
-	/* Find the correct device extension */
-	for (i=0;i<tw_device_extension_count;i++) 
-		if (tw_device_extension_list[i]->host->host_no == shost->host_no) 
-			tw_dev = tw_device_extension_list[i];
-	if (tw_dev == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_proc_info(): Couldn't locate device extension.\n");
-		return (-EINVAL);
-	}
-
-	info.buffer = buffer;
-	info.length = length;
-	info.offset = offset;
-	info.position = 0;
-	
-	if (inout) {
-		/* Write */
-		if (strncmp(buffer, "debug", 5) == 0) {
-			printk(KERN_INFO "3w-xxxx: Posted commands:\n");
-			for (j=0;j<TW_Q_LENGTH;j++) {
-				if (tw_dev->state[j] == TW_S_POSTED) {
-					TW_Command *command = (TW_Command *)tw_dev->command_packet_virtual_address[j];
-					printk(KERN_INFO "3w-xxxx: Request_id: %d\n", j);
-					printk(KERN_INFO "Opcode: 0x%x\n", command->byte0.opcode);
-					printk(KERN_INFO "Block_count: 0x%x\n", command->byte6.block_count);
-					printk(KERN_INFO "LBA: 0x%x\n", command->byte8.io.lba);
-					printk(KERN_INFO "Physical command packet addr: 0x%lx\n", tw_dev->command_packet_physical_address[j]);
-					printk(KERN_INFO "Scsi_Cmnd: %p\n", tw_dev->srb[j]);
-				}
-			}
-			printk(KERN_INFO "3w-xxxx: Free_head: %3d\n", tw_dev->free_head);
-			printk(KERN_INFO "3w-xxxx: Free_tail: %3d\n", tw_dev->free_tail);
-		} 
-		return length;
-	} else {
-		/* Read */
-		if (start) {
-			*start = buffer;
-		}
-		tw_copy_info(&info, "scsi%d: 3ware Storage Controller\n", shost->host_no);
-		tw_copy_info(&info, "Driver version: %s\n", tw_driver_version);
-		tw_copy_info(&info, "Current commands posted:       %3d\n", tw_dev->posted_request_count);
-		tw_copy_info(&info, "Max commands posted:           %3d\n", tw_dev->max_posted_request_count);
-		tw_copy_info(&info, "Current pending commands:      %3d\n", tw_dev->pending_request_count);
-		tw_copy_info(&info, "Max pending commands:          %3d\n", tw_dev->max_pending_request_count);
-		tw_copy_info(&info, "Last sgl length:               %3d\n", tw_dev->sgl_entries);
-		tw_copy_info(&info, "Max sgl length:                %3d\n", tw_dev->max_sgl_entries);
-		tw_copy_info(&info, "Last sector count:             %3d\n", tw_dev->sector_count);
-		tw_copy_info(&info, "Max sector count:              %3d\n", tw_dev->max_sector_count);
-		tw_copy_info(&info, "Resets:                        %3d\n", tw_dev->num_resets);
-		tw_copy_info(&info, "Aborts:                        %3d\n", tw_dev->num_aborts);
-		tw_copy_info(&info, "AEN's:                         %3d\n", tw_dev->aen_count);
-	}
-	if (info.position > info.offset) {
-		return (info.position - info.offset);
-	} else { 
-		return 0;
-	}
-} /* End tw_scsi_proc_info() */
-
-/* This is the main scsi queue function to handle scsi opcodes */
-int tw_scsi_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *)) 
-{
-	unsigned char *command = SCpnt->cmnd;
-	int request_id = 0;
-	int error = 0;
-	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
-
-	if (tw_dev == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsi_queue(): Invalid device extension.\n");
-		SCpnt->result = (DID_ERROR << 16);
-		done(SCpnt);
-		return 0;
-	}
-
-	spin_lock(&tw_dev->tw_lock);
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue()\n");
-
-	/* Skip scsi command if it isn't for us */
-	if ((SCpnt->device->channel != 0) || (SCpnt->device->lun != 0)) {
-		SCpnt->result = (DID_BAD_TARGET << 16);
-		done(SCpnt);
-		spin_unlock(&tw_dev->tw_lock);
-		return 0;
-	}
-	
-	/* Save done function into Scsi_Cmnd struct */
-	SCpnt->scsi_done = done;
-		 
-	/* Queue the command and get a request id */
-	tw_state_request_start(tw_dev, &request_id);
-
-	/* Save the scsi command for use by the ISR */
-	tw_dev->srb[request_id] = SCpnt;
-
-	/* Initialize phase to zero */
-	SCpnt->SCp.phase = 0;
+	/* Initialize phase to zero */
+	SCpnt->SCp.phase = TW_PHASE_INITIAL;
 
 	switch (*command) {
 		case READ_10:

