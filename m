From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH 3/3] 3ware 5/6/7/8000 driver v1.26.02.000
Date: Thu, 9 Sep 2004 14:23:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <I3SM4U02.EOF@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:48837 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S266304AbUIIVY0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 17:24:26 -0400
Received: from mailhost02.amcc.com ([192.195.69.49]) by
          hadar.amcc.com (Netscape Messaging Server 4.15) with SMTP id
          I3SM4U02.EOF for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004
          14:24:30 -0700
Received: (from ving-pc [10.66.6.122])
 by mailhost02.amcc.com (SMSSMTP 4.0.0.59) with SMTP id M2004090914252020791
 for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2004 14:25:20 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

diff -Naur linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c
--- linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c	2004-08-14 03:56:22.000000000 -0700
+++ linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c	2004-09-08 17:41:45.000000000 -0700
@@ -2633,35 +2026,34 @@
 		case WRITE_10:
 		case WRITE_6:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught READ/WRITE.\n");
-			error = tw_scsiop_read_write(tw_dev, request_id);
+			retval = tw_scsiop_read_write(tw_dev, request_id);
 			break;
 		case TEST_UNIT_READY:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught TEST_UNIT_READY.\n");
-			error = tw_scsiop_test_unit_ready(tw_dev, request_id);
+			retval = tw_scsiop_test_unit_ready(tw_dev, request_id);
 			break;
 		case INQUIRY:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught INQUIRY.\n");
-			error = tw_scsiop_inquiry(tw_dev, request_id);
+			retval = tw_scsiop_inquiry(tw_dev, request_id);
 			break;
 		case READ_CAPACITY:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught READ_CAPACITY.\n");
-			error = tw_scsiop_read_capacity(tw_dev, request_id);
+			retval = tw_scsiop_read_capacity(tw_dev, request_id);
 			break;
 	        case REQUEST_SENSE:
 		        dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught REQUEST_SENSE.\n");
-		        error = tw_scsiop_request_sense(tw_dev, request_id);
+		        retval = tw_scsiop_request_sense(tw_dev, request_id);
 		        break;
 		case MODE_SENSE:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught MODE_SENSE.\n");
-			error = tw_scsiop_mode_sense(tw_dev, request_id);
+			retval = tw_scsiop_mode_sense(tw_dev, request_id);
 			break;
 		case SYNCHRONIZE_CACHE:
 			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught SYNCHRONIZE_CACHE.\n");
-			error = tw_scsiop_synchronize_cache(tw_dev, request_id);
+			retval = tw_scsiop_synchronize_cache(tw_dev, request_id);
 			break;
 		case TW_IOCTL:
-			dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_queue(): caught TW_SCSI_IOCTL.\n");
-			error = tw_ioctl(tw_dev, request_id);
+			printk(KERN_WARNING "3w-xxxx: SCSI_IOCTL_SEND_COMMAND deprecated, please update your 3ware tools.\n");
 			break;
 		default:
 			printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
@@ -2669,837 +2061,440 @@
 			tw_state_request_finish(tw_dev, request_id);
 			SCpnt->result = (DID_BAD_TARGET << 16);
 			done(SCpnt);
+			goto out;
 	}
-	if (error) {
+	if (retval) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
 	}
-	spin_unlock(&tw_dev->tw_lock);
-
-	return 0;
+out:
+	return retval;
 } /* End tw_scsi_queue() */
 
-/* This function will release the resources on an rmmod call */
-int tw_scsi_release(struct Scsi_Host *tw_host) 
-{
-	TW_Device_Extension *tw_dev;
-	tw_dev = (TW_Device_Extension *)tw_host->hostdata;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_release()\n");
-
-	/* Fake like we just shut down, so notify the card that
-	 * we "shut down cleanly".
-	 */
-	tw_halt(0, 0, 0);  // parameters aren't actually used
-
-	/* Free up the IO region */
-	release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
-
-	/* Free up the IRQ */
-	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
-
-	/* Unregister character device */
-	if (twe_major >= 0) {
-		unregister_chrdev(twe_major, "twe");
-		twe_major = -1;
-	}
-
-	/* Free up device extension resources */
-	tw_free_device_extension(tw_dev);
-
-	/* Tell kernel scsi-layer we are gone */
-	scsi_unregister(tw_host);
-
-	return 0;
-} /* End tw_scsi_release() */
-
-/* This function handles scsi inquiry commands */
-int tw_scsiop_inquiry(TW_Device_Extension *tw_dev, int request_id)
+/* This function is the interrupt service routine */
+static irqreturn_t tw_interrupt(int irq, void *dev_instance,
+		     struct pt_regs *regs) 
 {
-	TW_Param *param;
+	int request_id;
+	u32 status_reg_value;
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
+	TW_Response_Queue response_que;
+	int error = 0, retval = 0;
 	TW_Command *command_packet;
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	unsigned long param_value;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry()\n");
-
-	/* Initialize command packet */
-	command_que_addr = tw_dev->registers.command_que_addr;
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad command packet virtual address.\n");
-		return 1;
-	}
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
-
-	/* Now setup the param */
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = 3;	 /* unit summary table */
-	param->parameter_id = 3; /* unitsstatus parameter */
-	param->parameter_size_bytes = TW_MAX_UNITS;
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad alignment physical address.\n");
-		return 1;
-	}
+	int handled = 0;
 
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry(): Bad command packet physical address.\n");
-		return 1;
-	}
+	/* Get the host lock for io completions */
+	spin_lock(tw_dev->host->host_lock);
 
-	/* Now try to post the command packet */
-	tw_post_command_packet(tw_dev, request_id);
+	/* See if the interrupt matches this instance */
+	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
 
-	return 0;
-} /* End tw_scsiop_inquiry() */
+		handled = 1;
 
-/* This function is called by the isr to complete an inquiry command */
-int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_id)
-{
-	unsigned char *is_unit_present;
-	unsigned char *request_buffer;
-	TW_Param *param;
+		/* Read the registers */
+		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry_complete()\n");
+		/* Check if this is our interrupt, otherwise bail */
+		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+			goto tw_interrupt_bail;
 
-	/* Fill request buffer */
-	if (tw_dev->srb[request_id]->request_buffer == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Request buffer NULL.\n");
-		return 1;
-	}
-	request_buffer = tw_dev->srb[request_id]->request_buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
-	request_buffer[0] = TYPE_DISK; /* Peripheral device type */
-	request_buffer[1] = 0;	       /* Device type modifier */
-	request_buffer[2] = 0;	       /* No ansi/iso compliance */
-	request_buffer[4] = 31;	       /* Additional length */
-	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
-	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
-	memcpy(&request_buffer[32], tw_driver_version, 3);
+		/* Check controller for errors */
+		if (tw_check_bits(status_reg_value)) {
+			dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
+			if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
+				TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+				goto tw_interrupt_bail;
+			}
+		}
 
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	if (param == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	is_unit_present = &(param->data[0]);
+		/* Handle host interrupt */
+		if (status_reg_value & TW_STATUS_HOST_INTERRUPT) {
+			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received host interrupt.\n");
+			TW_CLEAR_HOST_INTERRUPT(tw_dev);
+		}
 
-	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = TRUE;
-	} else {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = FALSE;
-		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
-		return TW_ISR_DONT_RESULT;
-	}
+		/* Handle attention interrupt */
+		if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
+			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention interrupt.\n");
+			TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
+			tw_state_request_start(tw_dev, &request_id);
+			error = tw_aen_read_queue(tw_dev, request_id);
+			if (error) {
+				printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen queue.\n", tw_dev->host->host_no);
+				tw_dev->state[request_id] = TW_S_COMPLETED;
+				tw_state_request_finish(tw_dev, request_id);
+			}
+		}
 
-	return 0;
-} /* End tw_scsiop_inquiry_complete() */
+		/* Handle command interrupt */
+		if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
+			/* Drain as many pending commands as we can */
+			while (tw_dev->pending_request_count > 0) {
+				request_id = tw_dev->pending_queue[tw_dev->pending_head];
+				if (tw_dev->state[request_id] != TW_S_PENDING) {
+					printk(KERN_WARNING "3w-xxxx: scsi%d: Found request id that wasn't pending.\n", tw_dev->host->host_no);
+					break;
+				}
+				if (tw_post_command_packet(tw_dev, request_id)==0) {
+					if (tw_dev->pending_head == TW_Q_LENGTH-1) {
+						tw_dev->pending_head = TW_Q_START;
+					} else {
+						tw_dev->pending_head = tw_dev->pending_head + 1;
+					}
+					tw_dev->pending_request_count--;
+				} else {
+					/* If we get here, we will continue re-posting on the next command interrupt */
+					break;
+				}
+			}
+			/* If there are no more pending requests, we mask command interrupt */
+			if (tw_dev->pending_request_count == 0) 
+				TW_MASK_COMMAND_INTERRUPT(tw_dev);
+		}
 
-/* This function handles scsi mode_sense commands */
-int tw_scsiop_mode_sense(TW_Device_Extension *tw_dev, int request_id)
-{
-	TW_Param *param;
-	TW_Command *command_packet;
-	unsigned long command_que_value;
-	unsigned long param_value;
+		/* Handle response interrupt */
+		if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
+			/* Drain the response queue from the board */
+			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
+				/* Read response queue register */
+				response_que.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+				request_id = TW_RESID_OUT(response_que.response_id);
+				command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+				error = 0;
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense()\n");
+				/* Check for bad response */
+				if (command_packet->status != 0) {
+					/* If internal command, don't error, don't fill sense */
+					if (tw_dev->srb[request_id] == 0) {
+						tw_decode_sense(tw_dev, request_id, 0);
+					} else {
+						error = tw_decode_sense(tw_dev, request_id, 1);
+					}
+				}
 
-	/* Only page control = 0, page code = 0x8 (cache page) supported */
-	if (tw_dev->srb[request_id]->cmnd[2] != 0x8) {
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-		return 0;
-	}
+				/* Check for correct state */
+				if (tw_dev->state[request_id] != TW_S_POSTED) {
+					if (tw_dev->srb[request_id] != 0) {
+						printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id that wasn't posted.\n", tw_dev->host->host_no);
+						error = 1;
+					}
+				}
 
-	/* Now read firmware cache setting for this unit */
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad command packet virtual address.\n");
-		return 1;
-	}
+				dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue request id: %d.\n", request_id);
 
-	/* Setup the command packet */
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
-
-	/* Setup the param */
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad alignment virtual address.\n");
-		return 1;
-	}
-
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + tw_dev->srb[request_id]->device->id;
-	param->parameter_id = 7; /* unit flags */
-	param->parameter_size_bytes = 1;
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad alignment physical address.\n");
-		return 1;
-	}
-
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense(): Bad command packet physical address.\n");
-		return 1;
-	}
-
-	/* Now try to post the command packet */
-	tw_post_command_packet(tw_dev, request_id);
-	
-	return 0;
-} /* End tw_scsiop_mode_sense() */
-
-/* This function is called by the isr to complete a mode sense command */
-int tw_scsiop_mode_sense_complete(TW_Device_Extension *tw_dev, int request_id)
-{
-	TW_Param *param;
-	unsigned char *flags;
-	unsigned char *request_buffer;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense_complete()\n");
-
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	if (param == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_mode_sense_complete(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	flags = (char *)&(param->data[0]);
-	request_buffer = tw_dev->srb[request_id]->buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
-
-	request_buffer[0] = 0xf;        /* mode data length */
-	request_buffer[1] = 0;          /* default medium type */
-	request_buffer[2] = 0x10;       /* dpo/fua support on */
-	request_buffer[3] = 0;          /* no block descriptors */
-	request_buffer[4] = 0x8;        /* caching page */
-	request_buffer[5] = 0xa;        /* page length */
-	if (*flags & 0x1)
-		request_buffer[6] = 0x4;        /* WCE on */
-	else
-		request_buffer[6] = 0x0;        /* WCE off */
-
-	return 0;
-} /* End tw_scsiop_mode_sense_complete() */
-
-/* This function handles scsi read_capacity commands */
-int tw_scsiop_read_capacity(TW_Device_Extension *tw_dev, int request_id) 
-{
-	TW_Param *param;
-	TW_Command *command_packet;
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	unsigned long param_value;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity()\n");
-
-	/* Initialize command packet */
-	command_que_addr = tw_dev->registers.command_que_addr;
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-
-	if (command_packet == NULL) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad command packet virtual address.\n");
-		return 1;
-	}
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = tw_dev->srb[request_id]->device->id;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.block_count = 1;
-
-	/* Now setup the param */
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + 
-	tw_dev->srb[request_id]->device->id;
-	param->parameter_id = 4;	/* unitcapacity parameter */
-	param->parameter_size_bytes = 4;
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad alignment physical address.\n");
-		return 1;
-	}
-  
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity(): Bad command packet physical address.\n");
-		return 1;
-	}
-
-	/* Now try to post the command to the board */
-	tw_post_command_packet(tw_dev, request_id);
-  
-	return 0;
-} /* End tw_scsiop_read_capacity() */
-
-/* This function is called by the isr to complete a readcapacity command */
-int tw_scsiop_read_capacity_complete(TW_Device_Extension *tw_dev, int request_id)
-{
-	unsigned char *param_data;
-	u32 capacity;
-	char *buff;
-	TW_Param *param;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete()\n");
-
-	buff = tw_dev->srb[request_id]->request_buffer;
-	if (buff == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Request buffer NULL.\n");
-		return 1;
-	}
-	memset(buff, 0, tw_dev->srb[request_id]->request_bufflen);
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	if (param == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	param_data = &(param->data[0]);
-
-	capacity = (param_data[3] << 24) | (param_data[2] << 16) | 
-		   (param_data[1] << 8) | param_data[0];
-
-	/* Subtract one sector to fix get last sector ioctl */
-	capacity -= 1;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete(): Capacity = 0x%x.\n", capacity);
-
-	/* Number of LBA's */
-	buff[0] = (capacity >> 24);
-	buff[1] = (capacity >> 16) & 0xff;
-	buff[2] = (capacity >> 8) & 0xff;
-	buff[3] = capacity & 0xff;
-
-	/* Block size in bytes (512) */
-	buff[4] = (TW_BLOCK_SIZE >> 24);
-	buff[5] = (TW_BLOCK_SIZE >> 16) & 0xff;
-	buff[6] = (TW_BLOCK_SIZE >> 8) & 0xff;
-	buff[7] = TW_BLOCK_SIZE & 0xff;
-
-	return 0;
-} /* End tw_scsiop_read_capacity_complete() */
-
-/* This function handles scsi read or write commands */
-int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id) 
-{
-	TW_Command *command_packet;
-	unsigned long command_que_value;
-	u32 command_que_addr = 0x0;
-	u32 lba = 0x0, num_sectors = 0x0, buffaddr = 0x0;
-	int i, use_sg;
-	Scsi_Cmnd *srb;
-	struct scatterlist *sglist;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write()\n");
-
-	if (tw_dev->srb[request_id]->request_buffer == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_write(): Request buffer NULL.\n");
-		return 1;
-	}
-	sglist = (struct scatterlist *)tw_dev->srb[request_id]->request_buffer;
-	srb = tw_dev->srb[request_id];
-
-	/* Initialize command packet */
-	command_que_addr = tw_dev->registers.command_que_addr;
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): Bad command packet virtual address.\n");
-		return 1;
-	}
-
-	if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == READ_10) {
-		command_packet->byte0.opcode = TW_OP_READ;
-	} else {
-		command_packet->byte0.opcode = TW_OP_WRITE;
-	}
-
-	command_packet->byte0.sgl_offset = 3;
-	command_packet->size = 3;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = srb->device->id;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-
-	if (srb->cmnd[0] == WRITE_10) {
-		if ((srb->cmnd[1] & 0x8) || (srb->cmnd[1] & 0x10))
-			command_packet->flags = 1;
-	}
-
-	if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == WRITE_6) {
-		lba = ((u32)srb->cmnd[1] << 16) | ((u32)srb->cmnd[2] << 8) | (u32)srb->cmnd[3];
-		num_sectors = (u32)srb->cmnd[4];
-	} else {
-		lba = ((u32)srb->cmnd[2] << 24) | ((u32)srb->cmnd[3] << 16) | ((u32)srb->cmnd[4] << 8) | (u32)srb->cmnd[5];
-		num_sectors = (u32)srb->cmnd[8] | ((u32)srb->cmnd[7] << 8);
-	}
-  
-	/* Update sector statistic */
-	tw_dev->sector_count = num_sectors;
-	if (tw_dev->sector_count > tw_dev->max_sector_count)
-		tw_dev->max_sector_count = tw_dev->sector_count;
-  
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): lba = 0x%x num_sectors = 0x%x\n", lba, num_sectors);
-	command_packet->byte8.io.lba = lba;
-	command_packet->byte6.block_count = num_sectors;
-
-	/* Do this if there are no sg list entries */
-	if (tw_dev->srb[request_id]->use_sg == 0) {    
-		dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write(): SG = 0\n");
-		buffaddr = tw_map_scsi_single_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-		if (buffaddr == 0)
-			return 1;
-
-		command_packet->byte8.io.sgl[0].address = buffaddr;
-		command_packet->byte8.io.sgl[0].length = tw_dev->srb[request_id]->request_bufflen;
-		command_packet->size+=2;
-	}
-
-	/* Do this if we have multiple sg list entries */
-	if (tw_dev->srb[request_id]->use_sg > 0) {
-		use_sg = tw_map_scsi_sg_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-		if (use_sg == 0)
-			return 1;
-
-		for (i=0;i<use_sg; i++) {
-			command_packet->byte8.io.sgl[i].address = sg_dma_address(&sglist[i]);
-			command_packet->byte8.io.sgl[i].length = sg_dma_len(&sglist[i]);
-			command_packet->size+=2;
-		}
-	}
-
-	/* Update SG statistics */
-	tw_dev->sgl_entries = tw_dev->srb[request_id]->use_sg;
-	if (tw_dev->sgl_entries > tw_dev->max_sgl_entries)
-		tw_dev->max_sgl_entries = tw_dev->sgl_entries;
-
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_scsiop_read_write(): Bad command packet physical address.\n");
-		return 1;
-	}
-      
-	/* Now try to post the command to the board */
-	tw_post_command_packet(tw_dev, request_id);
-
-	return 0;
-} /* End tw_scsiop_read_write() */
-
-/* This function will handle the request sense scsi command */
-int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
-{
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
-
-	/* For now we just zero the request buffer */
-	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
-	tw_dev->state[request_id] = TW_S_COMPLETED;
-	tw_state_request_finish(tw_dev, request_id);
-
-	/* If we got a request_sense, we probably want a reset, return error */
-	tw_dev->srb[request_id]->result = (DID_ERROR << 16);
-	tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-
-	return 0;
-} /* End tw_scsiop_request_sense() */
+				/* Check for internal command completion */
+				if (tw_dev->srb[request_id] == 0) {
+					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Found internally posted command.\n");
+					/* Check for chrdev ioctl completion */
+					if (request_id != tw_dev->chrdev_request_id) {
+						retval = tw_aen_complete(tw_dev, request_id);
+						if (retval) {
+							printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing aen.\n", tw_dev->host->host_no);
+						}
+					} else {
+						tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+						wake_up(&tw_dev->ioctl_wqueue);
+					}
+				} else {
+				switch (tw_dev->srb[request_id]->cmnd[0]) {
+					case READ_10:
+					case READ_6:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_10/READ_6\n");
+						break;
+					case WRITE_10:
+					case WRITE_6:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught WRITE_10/WRITE_6\n");
+						break;
+					case TEST_UNIT_READY:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught TEST_UNIT_READY\n");
+						error = tw_scsiop_test_unit_ready_complete(tw_dev, request_id);
+						break;
+					case INQUIRY:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught INQUIRY\n");
+						error = tw_scsiop_inquiry_complete(tw_dev, request_id);
+						break;
+					case READ_CAPACITY:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_CAPACITY\n");
+						error = tw_scsiop_read_capacity_complete(tw_dev, request_id);
+						break;
+					case MODE_SENSE:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught MODE_SENSE\n");
+						error = tw_scsiop_mode_sense_complete(tw_dev, request_id);
+						break;
+					case SYNCHRONIZE_CACHE:
+						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught SYNCHRONIZE_CACHE\n");
+						break;
+					default:
+						printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
+						error = 1;
+					}
 
-/* This function will handle synchronize cache scsi command */
-int tw_scsiop_synchronize_cache(TW_Device_Extension *tw_dev, int request_id)
-{
-	TW_Command *command_packet;
-	unsigned long command_que_value;
+					/* If no error command was a success */
+					if (error == 0) {
+						tw_dev->srb[request_id]->result = (DID_OK << 16);
+					}
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_synchronize_cache()\n");
+					/* If error, command failed */
+					if (error == 1) {
+						/* Ask for a host reset */
+						tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					}
 
-	/* Send firmware flush command for this unit */
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_synchronize_cache(): Bad command packet virtual address.\n");
-		return 1;
-	}
+					/* Now complete the io */
+					if ((error != TW_ISR_DONT_COMPLETE)) {
+						tw_dev->state[request_id] = TW_S_COMPLETED;
+						tw_state_request_finish(tw_dev, request_id);
+						tw_dev->posted_request_count--;
+						tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 
-	/* Setup the command packet */
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_FLUSH_CACHE;
-	command_packet->byte0.sgl_offset = 0;
-	command_packet->size = 2;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = tw_dev->srb[request_id]->device->id;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_synchronize_cache(): Bad command packet physical address.\n");
-		return 1;
+						tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
+					}
+				}
+				
+				/* Check for valid status after each drain */
+				status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+				if (tw_check_bits(status_reg_value)) {
+					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
+					if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
+						TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+						goto tw_interrupt_bail;
+					}
+				}
+			}
+		}
 	}
+tw_interrupt_bail:
+	spin_unlock(tw_dev->host->host_lock);
+	return IRQ_RETVAL(handled);
+} /* End tw_interrupt() */
 
-	/* Now try to post the command packet */
-	tw_post_command_packet(tw_dev, request_id);
-
-	return 0;
-} /* End tw_scsiop_synchronize_cache() */
-
-/* This function will handle test unit ready scsi command */
-int tw_scsiop_test_unit_ready(TW_Device_Extension *tw_dev, int request_id)
+/* This function tells the controller to shut down */
+static void __tw_shutdown(TW_Device_Extension *tw_dev)
 {
-	TW_Param *param;
-	TW_Command *command_packet;
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	unsigned long param_value;
+	/* Disable interrupts */
+	TW_DISABLE_INTERRUPTS(tw_dev);
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_test_unit_ready()\n");
+	printk(KERN_WARNING "3w-xxxx: Shutting down host %d.\n", tw_dev->host->host_no);
 
-	/* Initialize command packet */
-	command_que_addr = tw_dev->registers.command_que_addr;
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	if (command_packet == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad command packet virtual address.\n");
-		return 1;
+	/* Tell the card we are shutting down */
+	if (tw_initconnection(tw_dev, 1)) {
+		printk(KERN_WARNING "3w-xxxx: Connection shutdown failed.\n");
+	} else {
+		printk(KERN_WARNING "3w-xxxx: Shutdown complete.\n");
 	}
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
 
-	/* Now setup the param */
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad alignment virtual address.\n");
-		return 1;
-	}
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = 3;	 /* unit summary table */
-	param->parameter_id = 3; /* unitsstatus parameter */
-	param->parameter_size_bytes = TW_MAX_UNITS;
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad alignment physical address.\n");
-		return 1;
-	}
+	/* Clear all interrupts just before exit */
+	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+} /* End __tw_shutdown() */
 
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready(): Bad command packet physical address.\n");
-		return 1;
-	}
+/* Wrapper for __tw_shutdown */
+static void tw_shutdown(struct device *dev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(to_pci_dev(dev));
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	/* Now try to post the command packet */
-	tw_post_command_packet(tw_dev, request_id);
+	__tw_shutdown(tw_dev);
+} /* End tw_shutdown() */
 
-	return 0;
-} /* End tw_scsiop_test_unit_ready() */
+static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "3ware Storage Controller",
+	.queuecommand		= tw_scsi_queue,
+	.eh_host_reset_handler	= tw_scsi_eh_reset,
+	.bios_param		= tw_scsi_biosparam,
+	.can_queue		= TW_Q_LENGTH-2,
+	.this_id		= -1,
+	.sg_tablesize		= TW_MAX_SGL_LENGTH,
+	.max_sectors		= TW_MAX_SECTORS,
+	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= tw_host_attrs,
+	.sdev_attrs		= tw_dev_attrs,
+	.emulated		= 1
+};
 
-/* This function is called by the isr to complete a testunitready command */
-int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int request_id)
+/* This function will probe and initialize a card */
+static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 {
-	unsigned char *is_unit_present;
-	TW_Param *param;
+	struct Scsi_Host *host = NULL;
+	TW_Device_Extension *tw_dev;
+	int retval = -ENODEV;
 
-	dprintk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready_complete()\n");
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		printk(KERN_WARNING "3w-xxxx: Failed to enable pci device.");
+		goto out_disable_device;
+	}
 
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	if (param == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_test_unit_ready_complete(): Bad alignment virtual address.\n");
-		return 1;
+	pci_set_master(pdev);
+
+	retval = pci_set_dma_mask(pdev, TW_DMA_MASK);
+	if (retval) {
+		printk(KERN_WARNING "3w-xxxx: Failed to set dma mask.");
+		goto out_disable_device;
 	}
-	is_unit_present = &(param->data[0]);
 
-	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = TRUE;
-	} else {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = FALSE;
-		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
-		return TW_ISR_DONT_RESULT;
+	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
+	if (!host) {
+		printk(KERN_WARNING "3w-xxxx: Failed to allocate memory for device extension.");
+		retval = -ENOMEM;
+		goto out_disable_device;
 	}
+	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	return 0;
-} /* End tw_scsiop_test_unit_ready_complete() */
+	memset(tw_dev, 0, sizeof(TW_Device_Extension));
 
-/* Set a value in the features table */
-int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size,
-                  unsigned char *val)
-{
-	TW_Param *param;
-	TW_Command  *command_packet;
-	TW_Response_Queue response_queue;
-	int request_id = 0;
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	u32 response_que_addr;
-	unsigned long param_value;
+	/* Save values to device extension */
+	tw_dev->host = host;
+	tw_dev->tw_pci_dev = pdev;
 
-  	/* Initialize SetParam command packet */
-	if (tw_dev->command_packet_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad command packet virtual address.\n");
-		return 1;
+	if (tw_initialize_device_extension(tw_dev)) {
+		printk(KERN_WARNING "3w-xxxx: Failed to initialize device extension.");
+		goto out_free_device_extension;
 	}
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	memset(command_packet, 0, sizeof(TW_Sector));
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-
-	command_packet->byte0.opcode = TW_OP_SET_PARAM;
-	command_packet->byte0.sgl_offset  = 2;
-	param->table_id = 0x404;  /* Features table */
-	param->parameter_id = parm;
-	param->parameter_size_bytes = param_size;
-	memcpy(param->data, val, param_size);
 
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Bad alignment physical address.\n");
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
-		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+	/* Request IO regions */
+	retval = pci_request_regions(pdev, "3w-xxxx");
+	if (retval) {
+		printk(KERN_WARNING "3w-xxxx: Failed to get mem region.");
+		goto out_free_device_extension;
 	}
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
 
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte6.parameter_count = 1;
-
-  	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad command packet physical address.\n");
-	return 1;
+	/* Save base address */
+	tw_dev->base_addr = pci_resource_start(pdev, 0);
+	if (!tw_dev->base_addr) {
+		printk(KERN_WARNING "3w-xxxx: Failed to get io address.");
+		goto out_release_mem_region;
 	}
-	command_que_addr = tw_dev->registers.command_que_addr;
-	response_que_addr = tw_dev->registers.response_que_addr;
 
-	/* Send command packet to the board */
-	outl(command_que_value, command_que_addr);
-
-	/* Poll for completion */
-	if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
-		response_queue.value = inl(response_que_addr);
-		request_id = (unsigned char)response_queue.u.response_id;
-		if (request_id != 0) {
-			/* unexpected request id */
-			printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Unexpected request id.\n");
-			return 1;
-		}
-		if (command_packet->status != 0) {
-			/* bad response */
-			tw_decode_sense(tw_dev, request_id, 0);
-			return 1;
-		}
-	}
+	/* Disable interrupts on the card */
+	TW_DISABLE_INTERRUPTS(tw_dev);
 
-	return 0;
-} /* End tw_setfeature() */
+	/* Initialize the card */
+	if (tw_reset_sequence(tw_dev))
+		goto out_release_mem_region;
 
-/* This function will setup the interrupt handler */
-int tw_setup_irq(TW_Device_Extension *tw_dev)
-{
-	char *device = TW_DEVICE_NAME;
-	int error;
+	/* Set host specific parameters */
+	host->max_id = TW_MAX_UNITS;
+	host->max_cmd_len = TW_MAX_CDB_LEN;
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_setup_irq()\n");
-	error = request_irq(tw_dev->tw_pci_dev->irq, tw_interrupt, SA_SHIRQ, device, tw_dev);
+	/* Luns and channels aren't supported by adapter */
+	host->max_lun = 0;
+	host->max_channel = 0;
 
-	if (error < 0) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Error requesting IRQ: %d.\n", tw_dev->host->host_no, tw_dev->tw_pci_dev->irq);
-		return 1;
+	/* Register the card with the kernel SCSI layer */
+	retval = scsi_add_host(host, &pdev->dev);
+	if (retval) {
+		printk(KERN_WARNING "3w-xxxx: scsi add host failed");
+		goto out_release_mem_region;
 	}
-	return 0;
-} /* End tw_setup_irq() */
 
-/* This function will tell the controller we're shutting down by sending
-   initconnection with a 1 */
-int tw_shutdown_device(TW_Device_Extension *tw_dev)
-{
-	int error;
+	pci_set_drvdata(pdev, host);
 
-	/* Disable interrupts */
-	tw_disable_interrupts(tw_dev);
+	printk(KERN_WARNING "3w-xxxx: scsi%d: Found a 3ware Storage Controller at 0x%x, IRQ: %d.\n", host->host_no, tw_dev->base_addr, pdev->irq);
 
-	/* poke the board */
-	error = tw_initconnection(tw_dev, 1);
-	if (error) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Connection shutdown failed.\n", tw_dev->host->host_no);
-	} else {
-		printk(KERN_NOTICE "3w-xxxx: Shutdown complete.\n");
+	/* Now setup the interrupt handler */
+	retval = request_irq(pdev->irq, tw_interrupt, SA_SHIRQ, "3w-xxxx", tw_dev);
+	if (retval) {
+		printk(KERN_WARNING "3w-xxxx: Error requesting IRQ.");
+		goto out_remove_host;
 	}
 
-	/* Re-enable interrupts */
-	tw_enable_and_clear_interrupts(tw_dev);
+	tw_device_extension_list[tw_device_extension_count] = tw_dev;
+	tw_device_extension_count++;
 
-	return 0;
-} /* End tw_shutdown_device() */
-
-/* This function will configure individual target parameters */
-int tw_slave_configure(Scsi_Device *SDptr)
-{
-	int max_cmds;
+	/* Re-enable interrupts on the card */
+	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
 
-	dprintk(KERN_WARNING "3w-xxxx: tw_slave_configure()\n");
+	/* Finally, scan the host */
+	scsi_scan_host(host);
 
-	if (cmds_per_lun) {
-		max_cmds = cmds_per_lun;
-		if (max_cmds > TW_MAX_CMDS_PER_LUN)
-			max_cmds = TW_MAX_CMDS_PER_LUN;
-	} else {
-		max_cmds = TW_MAX_CMDS_PER_LUN;
+	if (twe_major == -1) {
+		if ((twe_major = register_chrdev (0, "twe", &tw_fops)) < 0)
+			printk(KERN_WARNING "3w-xxxx: Failed to register character device.");
 	}
-	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, max_cmds);
-
 	return 0;
-} /* End tw_slave_configure() */
 
-/* This function will soft reset the controller */
-void tw_soft_reset(TW_Device_Extension *tw_dev) 
-{
-	u32 control_reg_addr, control_reg_value;
+out_remove_host:
+	scsi_remove_host(host);
+out_release_mem_region:
+	pci_release_regions(pdev);
+out_free_device_extension:
+	tw_free_device_extension(tw_dev);
+	scsi_host_put(host);
+out_disable_device:
+	pci_disable_device(pdev);
 
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = (	TW_CONTROL_ISSUE_SOFT_RESET |
-				TW_CONTROL_CLEAR_HOST_INTERRUPT |
-				TW_CONTROL_CLEAR_ATTENTION_INTERRUPT |
-				TW_CONTROL_MASK_COMMAND_INTERRUPT |
-				TW_CONTROL_MASK_RESPONSE_INTERRUPT |
-				TW_CONTROL_CLEAR_ERROR_STATUS | 
-				TW_CONTROL_DISABLE_INTERRUPTS);
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_soft_reset() */
+	return retval;
+} /* End tw_probe() */
 
-/* This function will free a request_id */
-int tw_state_request_finish(TW_Device_Extension *tw_dev, int request_id)
+/* This function is called to remove a device */
+static void tw_remove(struct pci_dev *pdev)
 {
-	dprintk(KERN_NOTICE "3w-xxxx: tw_state_request_finish()\n");
-  
-	tw_dev->free_queue[tw_dev->free_tail] = request_id;
-	tw_dev->state[request_id] = TW_S_FINISHED;
-	if (tw_dev->free_tail == tw_dev->free_wrap)
-		tw_dev->free_tail = TW_Q_START;
-	else
-		tw_dev->free_tail++;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_state_request_finish(): Freeing request_id %d\n", request_id);
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	return 0;
-} /* End tw_state_request_finish() */
+	scsi_remove_host(tw_dev->host);
 
-/* This function will assign an available request_id */
-int tw_state_request_start(TW_Device_Extension *tw_dev, int *request_id)
-{
-	int id = 0;
+	__tw_shutdown(tw_dev);
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_state_request_start()\n");
-	
-	/* Obtain next free request_id */
-	id = tw_dev->free_queue[tw_dev->free_head];
-	if (tw_dev->free_head == tw_dev->free_wrap)
-		tw_dev->free_head = TW_Q_START;
-	else
-		tw_dev->free_head++;
+	/* Free up the IRQ */
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
-	*request_id = id;
-	tw_dev->state[id] = TW_S_STARTED;
+	/* Free up the mem region */
+	pci_release_regions(pdev);
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_state_request_start(): id = %d.\n", id);
-	return 0;
-} /* End tw_state_request_start() */
+	/* Free up device extension resources */
+	tw_free_device_extension(tw_dev);
 
-static void tw_unmap_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
-{
-	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	/* Unregister character device */
+	if (twe_major >= 0) {
+		unregister_chrdev(twe_major, "twe");
+		twe_major = -1;
+	}
 
-	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
+	scsi_host_put(tw_dev->host);
+	pci_disable_device(pdev);
+	tw_device_extension_count--;
+} /* End tw_remove() */
+
+/* PCI Devices supported by this driver */
+static struct pci_device_id tw_pci_tbl[] __devinitdata = {
+	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, tw_pci_tbl);
 
-	switch(cmd->SCp.phase) {
-		case 1:
-			pci_unmap_page(pdev, cmd->SCp.have_data_in, cmd->request_bufflen, dma_dir);
-			break;
-		case 2:
-			pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, dma_dir);
-			break;
+/* pci_driver initializer */
+static struct pci_driver tw_driver = {
+	.name		= "3w-xxxx",
+	.id_table	= tw_pci_tbl,
+	.probe		= tw_probe,
+	.remove		= tw_remove,
+	.driver		= {
+		.shutdown = tw_shutdown
 	}
-} /* End tw_unmap_scsi_data() */
+};
 
-/* This function will unmask the command interrupt on the controller */
-void tw_unmask_command_interrupt(TW_Device_Extension *tw_dev)
+/* This function is called on driver initialization */
+static int __init tw_init(void)
 {
-	u32 control_reg_addr, control_reg_value;
+	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", tw_driver_version);
 
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_CONTROL_UNMASK_COMMAND_INTERRUPT;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_unmask_command_interrupt() */
-
-static Scsi_Host_Template driver_template = {
-	.proc_name		= "3w-xxxx",
-	.proc_info		= tw_scsi_proc_info,
-	.name			= "3ware Storage Controller",
-	.detect			= tw_scsi_detect,
-	.release		= tw_scsi_release,
-	.queuecommand		= tw_scsi_queue,
-	.eh_abort_handler	= tw_scsi_eh_abort,
-	.eh_host_reset_handler	= tw_scsi_eh_reset,
-	.bios_param		= tw_scsi_biosparam,
-	.slave_configure	= tw_slave_configure,
-	.can_queue		= TW_Q_LENGTH-2,
-	.this_id		= -1,
-	.sg_tablesize		= TW_MAX_SGL_LENGTH,
-	.max_sectors		= TW_MAX_SECTORS,
-	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
-	.use_clustering		= ENABLE_CLUSTERING,
-	.emulated		= 1
-};
-#include "scsi_module.c"
+	return pci_module_init(&tw_driver);
+} /* End tw_init() */
+
+/* This function is called on driver exit */
+static void __exit tw_exit(void)
+{
+	pci_unregister_driver(&tw_driver);
+} /* End tw_exit() */
+
+module_init(tw_init);
+module_exit(tw_exit);
 
diff -Naur linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.h linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.h
--- linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.h	2004-08-14 03:54:51.000000000 -0700
+++ linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.h	2004-09-08 17:41:47.000000000 -0700
@@ -180,7 +180,6 @@
 #define TW_OP_AEN_LISTEN      0x1c
 #define TW_OP_FLUSH_CACHE     0x0e
 #define TW_CMD_PACKET         0x1d
-#define TW_ATA_PASSTHRU       0x1e
 #define TW_CMD_PACKET_WITH_DATA 0x1f
 
 /* Asynchronous Event Notification (AEN) Codes */
@@ -197,6 +196,11 @@
 #define TW_AEN_SMART_FAIL        0x000F
 #define TW_AEN_SBUF_FAIL         0x0024
 
+/* Phase defines */
+#define TW_PHASE_INITIAL 0
+#define TW_PHASE_SINGLE 1
+#define TW_PHASE_SGLIST 2
+
 /* Misc defines */
 #define TW_ALIGNMENT_6000		      64 /* 64 bytes */
 #define TW_ALIGNMENT_7000                     4  /* 4 bytes */
@@ -207,7 +211,6 @@
 #define TW_POLL_MAX_RETRIES        	      20000
 #define TW_MAX_SGL_LENGTH		      62
 #define TW_ATA_PASS_SGL_MAX                   60
-#define TW_MAX_PASSTHRU_BYTES                 4096
 #define TW_Q_LENGTH			      256
 #define TW_Q_START			      0
 #define TW_MAX_SLOT			      32
@@ -221,7 +224,7 @@
 #define TW_IOCTL                              0x80
 #define TW_UNIT_ONLINE                        1
 #define TW_IN_INTR                            1
-#define TW_IN_IOCTL                           2
+#define TW_IN_RESET                           2
 #define TW_IN_CHRDEV_IOCTL                    3
 #define TW_MAX_SECTORS                        256
 #define TW_AEN_WAIT_TIME                      1000
@@ -231,8 +234,41 @@
 #define TW_IOCTL_TIMEOUT                      25 /* 25 seconds */
 #define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
 #define TW_IOCTL_CHRDEV_FREE                  -1
+#define TW_DMA_MASK			      DMA_32BIT_MASK
+#define TW_MAX_CDB_LEN			      16
+
+/* Bitmask macros to eliminate bitfields */
+
+/* opcode: 5, sgloffset: 3 */
+#define TW_OPSGL_IN(x,y) ((x << 5) | (y & 0x1f))
+#define TW_SGL_OUT(x) ((x >> 5) & 0x7)
+
+/* reserved_1: 4, response_id: 8, reserved_2: 20 */
+#define TW_RESID_OUT(x) ((x >> 4) & 0xff)
+
+/* unit: 4, host_id: 4 */
+#define TW_UNITHOST_IN(x,y) ((x << 4) | ( y & 0xf))
+#define TW_UNIT_OUT(x) (x & 0xf)
 
 /* Macros */
+#define TW_CONTROL_REG_ADDR(x) (x->base_addr)
+#define TW_STATUS_REG_ADDR(x) (x->base_addr + 0x4)
+#define TW_COMMAND_QUEUE_REG_ADDR(x) (x->base_addr + 0x8)
+#define TW_RESPONSE_QUEUE_REG_ADDR(x) (x->base_addr + 0xC)
+#define TW_CLEAR_ALL_INTERRUPTS(x) (outl(TW_STATUS_VALID_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_CLEAR_ATTENTION_INTERRUPT(x) (outl(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_CLEAR_HOST_INTERRUPT(x) (outl(TW_CONTROL_CLEAR_HOST_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_DISABLE_INTERRUPTS(x) (outl(TW_CONTROL_DISABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
+#define TW_ENABLE_AND_CLEAR_INTERRUPTS(x) (outl(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT | TW_CONTROL_UNMASK_RESPONSE_INTERRUPT | TW_CONTROL_ENABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
+#define TW_MASK_COMMAND_INTERRUPT(x) (outl(TW_CONTROL_MASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_UNMASK_COMMAND_INTERRUPT(x) (outl(TW_CONTROL_UNMASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_SOFT_RESET(x) (outl(TW_CONTROL_ISSUE_SOFT_RESET | \
+			TW_CONTROL_CLEAR_HOST_INTERRUPT | \
+			TW_CONTROL_CLEAR_ATTENTION_INTERRUPT | \
+			TW_CONTROL_MASK_COMMAND_INTERRUPT | \
+			TW_CONTROL_MASK_RESPONSE_INTERRUPT | \
+			TW_CONTROL_CLEAR_ERROR_STATUS | \
+			TW_CONTROL_DISABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
 #define TW_STATUS_ERRORS(x) \
 	(((x & TW_STATUS_PCI_ABORT) || \
 	(x & TW_STATUS_PCI_PARITY_ERROR) || \
@@ -258,17 +294,10 @@
 
 /* Command Packet */
 typedef struct TW_Command {
-	/* First DWORD */
-	struct {
-		unsigned char opcode:5;
-		unsigned char sgl_offset:3;
-	} byte0;
+	unsigned char opcode__sgloffset;
 	unsigned char size;
 	unsigned char request_id;
-	struct {
-		unsigned char unit:4;
-		unsigned char host_id:4;
-	} byte3;
+	unsigned char unit__hostid;
 	/* Second DWORD */
 	unsigned char status;
 	unsigned char flags;
@@ -328,29 +357,10 @@
 
 /* Response queue */
 typedef union TAG_TW_Response_Queue {
-	struct {
-		u32 undefined_1: 4;
-		u32 response_id: 8;
-		u32 undefined_2: 20;
-	} u;
+	u32 response_id;
 	u32 value;
 } TW_Response_Queue;
 
-typedef struct TAG_TW_Registers {
-	u32 base_addr;
-	u32 control_reg_addr;
-	u32 status_reg_addr;
-	u32 command_que_addr;
-	u32 response_que_addr;
-} TW_Registers;
-
-typedef struct TAG_TW_Info {
-	char *buffer;
-	int length;
-	int offset;
-	int position;
-} TW_Info;
-
 typedef int TW_Cmd_State;
 
 #define TW_S_INITIAL   0x1  /* Initial state */
@@ -364,16 +374,10 @@
 /* Command header for ATA pass-thru */
 typedef struct TAG_TW_Passthru
 {
-	struct {
-		unsigned char opcode:5;
-		unsigned char sgloff:3;
-	} byte0;
+	unsigned char opcode__sgloffset;
 	unsigned char size;
 	unsigned char request_id;
-	struct {
-		unsigned char aport:4;
-		unsigned char host_id:4;
-	} byte3;
+	unsigned char aport__hostid;
 	unsigned char status;
 	unsigned char flags;
 	unsigned short param;
@@ -389,7 +393,7 @@
 } TW_Passthru;
 
 typedef struct TAG_TW_Device_Extension {
-	TW_Registers		registers;
+	u32			base_addr;
 	unsigned long		*alignment_virtual_address[TW_Q_LENGTH];
 	unsigned long		alignment_physical_address[TW_Q_LENGTH];
 	int			is_unit_present[TW_MAX_UNITS];
@@ -397,11 +401,10 @@
 	unsigned long		*command_packet_virtual_address[TW_Q_LENGTH];
 	unsigned long		command_packet_physical_address[TW_Q_LENGTH];
 	struct pci_dev		*tw_pci_dev;
-	Scsi_Cmnd		*srb[TW_Q_LENGTH];
+	struct scsi_cmnd	*srb[TW_Q_LENGTH];
 	unsigned char		free_queue[TW_Q_LENGTH];
 	unsigned char		free_head;
 	unsigned char		free_tail;
-	unsigned char           free_wrap;
 	unsigned char		pending_queue[TW_Q_LENGTH];
 	unsigned char		pending_head;
 	unsigned char		pending_tail;
@@ -413,83 +416,21 @@
 	u32			max_pending_request_count;
 	u32			max_sgl_entries;
 	u32			sgl_entries;
-	u32			num_aborts;
 	u32			num_resets;
 	u32			sector_count;
 	u32			max_sector_count;
 	u32			aen_count;
 	struct Scsi_Host	*host;
-	spinlock_t		tw_lock;
 	struct semaphore	ioctl_sem;
-	int		        ioctl_size[TW_Q_LENGTH];
 	unsigned short		aen_queue[TW_Q_LENGTH];
 	unsigned char		aen_head;
 	unsigned char		aen_tail;
 	volatile long		flags; /* long req'd for set_bit --RR */
-	unsigned long		*ioctl_data[TW_Q_LENGTH];
 	int			reset_print;
-	char                    online;
 	volatile int		chrdev_request_id;
 	wait_queue_head_t	ioctl_wqueue;
 } TW_Device_Extension;
 
 #pragma pack()
 
-/* Function prototypes */
-int tw_aen_complete(TW_Device_Extension *tw_dev, int request_id);
-int tw_aen_drain_queue(TW_Device_Extension *tw_dev);
-int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id);
-int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which);
-int tw_check_bits(u32 status_reg_value);
-int tw_check_errors(TW_Device_Extension *tw_dev);
-void tw_clear_all_interrupts(TW_Device_Extension *tw_dev);
-void tw_clear_attention_interrupt(TW_Device_Extension *tw_dev);
-void tw_clear_host_interrupt(TW_Device_Extension *tw_dev);
-int tw_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value, int print_host);
-int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill_sense);
-void tw_disable_interrupts(TW_Device_Extension *tw_dev);
-void tw_empty_response_que(TW_Device_Extension *tw_dev);
-void tw_enable_interrupts(TW_Device_Extension *tw_dev);
-void tw_enable_and_clear_interrupts(TW_Device_Extension *tw_dev);
-int tw_findcards(Scsi_Host_Template *tw_host);
-void tw_free_device_extension(TW_Device_Extension *tw_dev);
-int tw_initconnection(TW_Device_Extension *tw_dev, int message_credits);
-int tw_initialize_device_extension(TW_Device_Extension *tw_dev);
-int tw_initialize_units(TW_Device_Extension *tw_dev);
-int tw_ioctl(TW_Device_Extension *tw_dev, int request_id);
-int tw_ioctl_complete(TW_Device_Extension *tw_dev, int request_id);
-void tw_mask_command_interrupt(TW_Device_Extension *tw_dev);
-int tw_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds);
-int tw_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int seconds);
-int tw_post_command_packet(TW_Device_Extension *tw_dev, int request_id);
-int tw_reset_device_extension(TW_Device_Extension *tw_dev);
-int tw_reset_sequence(TW_Device_Extension *tw_dev);
-int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-		sector_t capacity, int geom[]);
-int tw_scsi_detect(Scsi_Host_Template *tw_host);
-int tw_scsi_eh_abort(Scsi_Cmnd *SCpnt);
-int tw_scsi_eh_reset(Scsi_Cmnd *SCpnt);
-int tw_scsi_queue(Scsi_Cmnd *cmd, void (*done) (Scsi_Cmnd *));
-int tw_scsi_release(struct Scsi_Host *tw_host);
-int tw_scsiop_inquiry(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_mode_sense(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_mode_sense_complete(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_read_capacity(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_read_capacity_complete(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_synchronize_cache(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_test_unit_ready(TW_Device_Extension *tw_dev, int request_id);
-int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int request_id);
-int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size, 
-		  unsigned char *val);
-int tw_setup_irq(TW_Device_Extension *tw_dev);
-int tw_shutdown_device(TW_Device_Extension *tw_dev);
-int tw_slave_configure(Scsi_Device *SDptr);
-void tw_soft_reset(TW_Device_Extension *tw_dev);
-int tw_state_request_finish(TW_Device_Extension *tw_dev,int request_id);
-int tw_state_request_start(TW_Device_Extension *tw_dev, int *request_id);
-void tw_unmask_command_interrupt(TW_Device_Extension *tw_dev);
-
 #endif /* _3W_XXXX_H */

