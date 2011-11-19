From: Joe Perches <joe@perches.com>
Subject: [PATCH] 3ware: Reduce object size by centralizing printks
Date: Fri, 18 Nov 2011 22:22:35 -0800
Message-ID: <1321683755.18250.6.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35306 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905Ab1KSGWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2011 01:22:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

Reduced object size of 15-20% is good.

Convert TW_PRINTK macros to functions.
Convert printks to pr_<level>.
Align arguments.

$ size drivers/scsi/3w-*.o*
   text	   data	    bss	    dec	    hex	filename
  30993	   2172	   5320	  38485	   9655	drivers/scsi/3w-9xxx.o.new
  35424	   2172	   6024	  43620	   aa64	drivers/scsi/3w-9xxx.o.old
  21437	    696	   4352	  26485	   6775	drivers/scsi/3w-sas.o.new
  24974	    696	   4928	  30598	   7786	drivers/scsi/3w-sas.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/3w-9xxx.c |  232 +++++++++++++++++++++++++++++------------------
 drivers/scsi/3w-9xxx.h |    9 +--
 drivers/scsi/3w-sas.c  |  192 +++++++++++++++++++++++++---------------
 drivers/scsi/3w-sas.h  |    6 --
 4 files changed, 265 insertions(+), 174 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3868ab2..3663626 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -81,6 +81,8 @@
    2.26.02.014 - Force 60 second timeout default.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
@@ -153,6 +155,17 @@ static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id);
 
 /* Functions */
 
+static void twa_msg(const struct Scsi_Host *host, int err1, int err2,
+		    const char *desc)
+{
+	if (host)
+		pr_warn("scsi%d: ERROR: (0x%02X:0x%04X): %s\n",
+			host->host_no, err1, err2, desc);
+	else
+		pr_warn("ERROR: (0x%02X:0x%04X): %s\n",
+			err1, err2, desc);
+}
+
 /* Show some statistics about the card */
 static ssize_t twa_show_stats(struct device *dev,
 			      struct device_attribute *attr, char *buf)
@@ -311,7 +324,8 @@ static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 	sglist[0].address = tw_dev->generic_buffer_phys[request_id];
 
 	if (sglist[0].address & TW_ALIGNMENT_9000_SGL) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Found unaligned address during AEN drain");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1,
+			"Found unaligned address during AEN drain");
 		goto out;
 	}
 
@@ -321,13 +335,15 @@ static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 	do {
 		/* Send command to the board */
 		if (twa_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2, "Error posting request sense");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x2,
+				"Error posting request sense");
 			goto out;
 		}
 
 		/* Now poll for completion */
 		if (twa_poll_response(tw_dev, request_id, 30)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x3, "No valid response while draining AEN queue");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x3,
+				"No valid response while draining AEN queue");
 			tw_dev->posted_request_count--;
 			goto out;
 		}
@@ -413,12 +429,12 @@ static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	event->parameter_len = strlen(header->err_specific_desc);
 	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + (error_str[0] == '\0' ? 0 : (1 + strlen(error_str))));
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
-		printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
-		       host,
-		       twa_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
-		       TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen,
-		       error_str[0] == '\0' ? twa_string_lookup(twa_aen_table, aen) : error_str,
-		       header->err_specific_desc);
+		pr_warn("%s AEN: %s (0x%02X:0x%04X): %s:%s\n",
+			host,
+			twa_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
+			TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen,
+			error_str[0] == '\0' ? twa_string_lookup(twa_aen_table, aen) : error_str,
+			header->err_specific_desc);
 	else
 		tw_dev->aen_count--;
 
@@ -453,7 +469,8 @@ static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 
 	/* Now post the command packet */
 	if (twa_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x4, "Post failed while reading AEN queue");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x4,
+			"Post failed while reading AEN queue");
 		goto out;
 	}
 	retval = 0;
@@ -529,12 +546,14 @@ static int twa_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 
 	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
 	if (!cpu_addr) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x5, "Memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x5,
+			"Memory allocation failed");
 		goto out;
 	}
 
 	if ((unsigned long)cpu_addr % (TW_ALIGNMENT_9000)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x6, "Failed to allocate correctly aligned memory");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x6,
+			"Failed to allocate correctly aligned memory");
 		pci_free_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, cpu_addr, dma_handle);
 		goto out;
 	}
@@ -587,7 +606,8 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
 			       TW_CURRENT_DRIVER_BUILD, &fw_on_ctlr_srl,
 			       &fw_on_ctlr_arch_id, &fw_on_ctlr_branch,
 			       &fw_on_ctlr_build, &init_connect_result)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x7, "Initconnection failed while checking SRL");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x7,
+			"Initconnection failed while checking SRL");
 		goto out;
 	}
 
@@ -604,14 +624,17 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
 				       &fw_on_ctlr_srl, &fw_on_ctlr_arch_id,
 				       &fw_on_ctlr_branch, &fw_on_ctlr_build,
 				       &init_connect_result)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0xa, "Initconnection (base mode) failed while checking SRL");
+			twa_msg(tw_dev->host, TW_DRIVER, 0xa,
+				"Initconnection (base mode) failed while checking SRL");
 			goto out;
 		}
 		if (!(init_connect_result & TW_CTLR_FW_COMPATIBLE)) {
 			if (TW_CURRENT_DRIVER_SRL > fw_on_ctlr_srl) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x32, "Firmware and driver incompatibility: please upgrade firmware");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x32,
+					"Firmware and driver incompatibility: please upgrade firmware");
 			} else {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x33, "Firmware and driver incompatibility: please upgrade driver");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x33,
+					"Firmware and driver incompatibility: please upgrade driver");
 			}
 			goto out;
 		}
@@ -724,9 +747,8 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		/* We timed out, and didn't get an interrupt */
 		if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 			/* Now we need to reset the board */
-			printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card.\n",
-			       tw_dev->host->host_no, TW_DRIVER, 0x37,
-			       cmd);
+			pr_warn("scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card\n",
+				tw_dev->host->host_no, TW_DRIVER, 0x37, cmd);
 			retval = TW_IOCTL_ERROR_OS_EIO;
 			twa_reset_device_extension(tw_dev);
 			goto out3;
@@ -906,12 +928,13 @@ static int twa_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value)
 
 	/* Check for various error conditions and handle them appropriately */
 	if (status_reg_value & TW_STATUS_PCI_PARITY_ERROR) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xc, "PCI Parity Error: clearing");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xc,
+			"PCI Parity Error: clearing");
 		writel(TW_CONTROL_CLEAR_PARITY_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}
 
 	if (status_reg_value & TW_STATUS_PCI_ABORT) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xd, "PCI Abort: clearing");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xd, "PCI Abort: clearing");
 		writel(TW_CONTROL_CLEAR_PCI_ABORT, TW_CONTROL_REG_ADDR(tw_dev));
 		pci_write_config_word(tw_dev->tw_pci_dev, PCI_STATUS, TW_PCI_CLEAR_PCI_ABORT);
 	}
@@ -920,13 +943,15 @@ static int twa_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value)
 		if (((tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9650SE) &&
 		     (tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9690SA)) ||
 		    (!test_bit(TW_IN_RESET, &tw_dev->flags)))
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Controller Queue Error: clearing");
+			twa_msg(tw_dev->host, TW_DRIVER, 0xe,
+				"Controller Queue Error: clearing");
 		writel(TW_CONTROL_CLEAR_QUEUE_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}
 
 	if (status_reg_value & TW_STATUS_MICROCONTROLLER_ERROR) {
 		if (tw_dev->reset_print == 0) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10, "Microcontroller Error: clearing");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x10,
+				"Microcontroller Error: clearing");
 			tw_dev->reset_print = 1;
 		}
 		goto out;
@@ -998,22 +1023,22 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 	error = le16_to_cpu(full_command_packet->header.status_block.error);
 	if ((error != TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error != TW_ERROR_UNIT_OFFLINE)) {
 		if (print_host)
-			printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
-			       tw_dev->host->host_no,
-			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
-			       full_command_packet->header.status_block.error,
-			       error_str[0] == '\0' ?
-			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
-			       full_command_packet->header.err_specific_desc);
+			pr_warn("scsi%d: ERROR: (0x%02X:0x%04X): %s:%s\n",
+				tw_dev->host->host_no,
+				TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+				full_command_packet->header.status_block.error,
+				error_str[0] == '\0' ?
+				twa_string_lookup(twa_error_table,
+						  full_command_packet->header.status_block.error) : error_str,
+				full_command_packet->header.err_specific_desc);
 		else
-			printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s:%s.\n",
-			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
-			       full_command_packet->header.status_block.error,
-			       error_str[0] == '\0' ?
-			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
-			       full_command_packet->header.err_specific_desc);
+			pr_warn("ERROR: (0x%02X:0x%04X): %s:%s\n",
+				TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+				full_command_packet->header.status_block.error,
+				error_str[0] == '\0' ?
+				twa_string_lookup(twa_error_table,
+						  full_command_packet->header.status_block.error) : error_str,
+				full_command_packet->header.err_specific_desc);
 	}
 
 	if (copy_sense) {
@@ -1086,7 +1111,8 @@ static void *twa_get_param(TW_Device_Extension *tw_dev, int request_id, int tabl
 
 	/* Poll for completion */
 	if (twa_poll_response(tw_dev, request_id, 30))
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x13, "No valid response during get param")
+		twa_msg(tw_dev->host, TW_DRIVER, 0x13,
+			"No valid response during get param");
 	else
 		retval = (void *)&(param->data[0]);
 
@@ -1150,7 +1176,8 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 
 	/* Poll for completion */
 	if (twa_poll_response(tw_dev, request_id, 30)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x15, "No valid response during init connection");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x15,
+			"No valid response during init connection");
 	} else {
 		if (set_features & TW_EXTENDED_INIT_CONNECT) {
 			*fw_on_ctlr_srl = le16_to_cpu(tw_initconnect->fw_srl);
@@ -1175,20 +1202,23 @@ static int twa_initialize_device_extension(TW_Device_Extension *tw_dev)
 
 	/* Initialize command packet buffers */
 	if (twa_allocate_memory(tw_dev, sizeof(TW_Command_Full), 0)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x16, "Command packet memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x16,
+			"Command packet memory allocation failed");
 		goto out;
 	}
 
 	/* Initialize generic buffer */
 	if (twa_allocate_memory(tw_dev, TW_SECTOR_SIZE, 1)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x17, "Generic memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x17,
+			"Generic memory allocation failed");
 		goto out;
 	}
 
 	/* Allocate event info space */
 	tw_dev->event_queue[0] = kcalloc(TW_Q_LENGTH, sizeof(TW_Event), GFP_KERNEL);
 	if (!tw_dev->event_queue[0]) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x18, "Event info memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x18,
+			"Event info memory allocation failed");
 		goto out;
 	}
 
@@ -1274,7 +1304,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 		while (tw_dev->pending_request_count > 0) {
 			request_id = tw_dev->pending_queue[tw_dev->pending_head];
 			if (tw_dev->state[request_id] != TW_S_PENDING) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x19, "Found request id that wasn't pending");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x19,
+					"Found request id that wasn't pending");
 				TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 				goto twa_interrupt_bail;
 			}
@@ -1313,7 +1344,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 			/* Check for correct state */
 			if (tw_dev->state[request_id] != TW_S_POSTED) {
 				if (tw_dev->srb[request_id] != NULL) {
-					TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Received a request id that wasn't posted");
+					twa_msg(tw_dev->host, TW_DRIVER, 0x1a,
+						"Received a request id that wasn't posted");
 					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 					goto twa_interrupt_bail;
 				}
@@ -1323,7 +1355,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 			if (tw_dev->srb[request_id] == NULL) {
 				if (request_id != tw_dev->chrdev_request_id) {
 					if (twa_aen_complete(tw_dev, request_id))
-						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Error completing AEN during attention interrupt");
+						twa_msg(tw_dev->host, TW_DRIVER, 0x1b,
+							"Error completing AEN during attention interrupt");
 				} else {
 					tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
 					wake_up(&tw_dev->ioctl_wqueue);
@@ -1424,7 +1457,8 @@ static int twa_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
 	if (!use_sg)
 		return 0;
 	else if (use_sg < 0) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to map scatter gather list");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1c,
+			"Failed to map scatter gather list");
 		return 0;
 	}
 
@@ -1445,7 +1479,8 @@ static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int se
 		response_queue.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
 		response_request_id = TW_RESID_OUT(response_queue.response_id);
 		if (request_id != response_request_id) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "Found unexpected request id while polling for response");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x1e,
+				"Found unexpected request id while polling for response");
 			goto out;
 		}
 		if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved) == TW_OP_EXECUTE_SCSI) {
@@ -1656,7 +1691,8 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 			TW_SOFT_RESET(tw_dev);
 			/* Clear pchip/response queue on 9550SX */
 			if (twa_empty_response_queue_large(tw_dev)) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x36, "Response queue (large) empty failed during reset sequence");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x36,
+					"Response queue (large) empty failed during reset sequence");
 				do_soft_reset = 1;
 				tries++;
 				continue;
@@ -1665,7 +1701,8 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 		/* Make sure controller is in a good state */
 		if (twa_poll_status(tw_dev, TW_STATUS_MICROCONTROLLER_READY | (do_soft_reset == 1 ? TW_STATUS_ATTENTION_INTERRUPT : 0), 60)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Microcontroller not ready during reset sequence");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x1f,
+				"Microcontroller not ready during reset sequence");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1673,7 +1710,8 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 		/* Empty response queue */
 		if (twa_empty_response_queue(tw_dev)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x20, "Response queue empty failed during reset sequence");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x20,
+				"Response queue empty failed during reset sequence");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1683,7 +1721,8 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 		/* Check for compatibility/flash */
 		if (twa_check_srl(tw_dev, &flashed)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x21, "Compatibility check failed during reset sequence");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x21,
+				"Compatibility check failed during reset sequence");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1696,7 +1735,8 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 		/* Drain the AEN queue */
 		if (twa_aen_drain_queue(tw_dev, soft_reset)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x22, "AEN drain failed during reset sequence");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x22,
+				"AEN drain failed during reset sequence");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1746,15 +1786,16 @@ static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt)
 	tw_dev->num_resets++;
 
 	sdev_printk(KERN_WARNING, SCpnt->device,
-		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
-		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
+		    "WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card\n",
+		    TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
 
 	/* Make sure we are not issuing an ioctl or resetting from ioctl */
 	mutex_lock(&tw_dev->ioctl_lock);
 
 	/* Now reset the card and some of the device extension data */
 	if (twa_reset_device_extension(tw_dev)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2b, "Controller reset failed during scsi host reset");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x2b,
+			"Controller reset failed during scsi host reset");
 		goto out;
 	}
 
@@ -1883,7 +1924,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 					command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(sg));
 					command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
 					if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
-						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligned sgl address during execute scsi");
+						twa_msg(tw_dev->host, TW_DRIVER, 0x2e,
+							"Found unaligned sgl address during execute scsi");
 						goto out;
 					}
 				}
@@ -1896,7 +1938,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 			command_packet->sg_list[i].address = TW_CPU_TO_SGL(sglistarg[i].address);
 			command_packet->sg_list[i].length = cpu_to_le32(sglistarg[i].length);
 			if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2f, "Found unaligned sgl address during internal post");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x2f,
+					"Found unaligned sgl address during internal post");
 				goto out;
 			}
 		}
@@ -1959,13 +2002,14 @@ static void __twa_shutdown(TW_Device_Extension *tw_dev)
 	/* Free up the IRQ */
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
-	printk(KERN_WARNING "3w-9xxx: Shutting down host %d.\n", tw_dev->host->host_no);
+	pr_warn("Shutting down host %d\n", tw_dev->host->host_no);
 
 	/* Tell the card we are shutting down */
 	if (twa_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x31, "Connection shutdown failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x31,
+			"Connection shutdown failed");
 	} else {
-		printk(KERN_WARNING "3w-9xxx: Shutdown complete.\n");
+		pr_warn("Shutdown complete\n");
 	}
 
 	/* Clear all interrupts just before exit */
@@ -2038,7 +2082,7 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
+		twa_msg(host, TW_DRIVER, 0x34, "Failed to enable pci device");
 		goto out_disable_device;
 	}
 
@@ -2049,14 +2093,16 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
 		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
+			twa_msg(host, TW_DRIVER, 0x23,
+				"Failed to set dma mask");
 			retval = -ENODEV;
 			goto out_disable_device;
 		}
 
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
-		TW_PRINTK(host, TW_DRIVER, 0x24, "Failed to allocate memory for device extension");
+		twa_msg(host, TW_DRIVER, 0x24,
+			"Failed to allocate memory for device extension");
 		retval = -ENOMEM;
 		goto out_disable_device;
 	}
@@ -2067,14 +2113,16 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	tw_dev->tw_pci_dev = pdev;
 
 	if (twa_initialize_device_extension(tw_dev)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to initialize device extension");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x25,
+			"Failed to initialize device extension");
 		goto out_free_device_extension;
 	}
 
 	/* Request IO regions */
 	retval = pci_request_regions(pdev, "3w-9xxx");
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x26, "Failed to get mem region");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x26,
+			"Failed to get mem region");
 		goto out_free_device_extension;
 	}
 
@@ -2089,7 +2137,7 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	/* Save base address */
 	tw_dev->base_addr = ioremap(mem_addr, mem_len);
 	if (!tw_dev->base_addr) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
 		goto out_release_mem_region;
 	}
 
@@ -2116,22 +2164,22 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	/* Register the card with the kernel SCSI layer */
 	retval = scsi_add_host(host, &pdev->dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x27, "scsi add host failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x27, "scsi add host failed");
 		goto out_iounmap;
 	}
 
 	pci_set_drvdata(pdev, host);
 
-	printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage Controller at 0x%lx, IRQ: %d.\n",
-	       host->host_no, mem_addr, pdev->irq);
-	printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s, Ports: %d.\n",
-	       host->host_no,
-	       (char *)twa_get_param(tw_dev, 0, TW_VERSION_TABLE,
-				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
-	       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
-				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-	       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
-				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
+	pr_warn("scsi%d: Found a 3ware 9000 Storage Controller at 0x%lx, IRQ: %d\n",
+		host->host_no, mem_addr, pdev->irq);
+	pr_warn("scsi%d: Firmware %s, BIOS %s, Ports: %d.\n",
+		host->host_no,
+		(char *)twa_get_param(tw_dev, 0, TW_VERSION_TABLE,
+				      TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
+		(char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				      TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
+		le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
+						  TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
 
 	/* Try to enable MSI */
 	if (use_msi && (pdev->device != PCI_DEVICE_ID_3WARE_9000) &&
@@ -2141,7 +2189,7 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twa_interrupt, IRQF_SHARED, "3w-9xxx", tw_dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x30, "Error requesting IRQ");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x30, "Error requesting IRQ");
 		goto out_remove_host;
 	}
 
@@ -2156,7 +2204,8 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	if (twa_major == -1) {
 		if ((twa_major = register_chrdev (0, "twa", &twa_fops)) < 0)
-			TW_PRINTK(host, TW_DRIVER, 0x29, "Failed to register character device");
+			twa_msg(host, TW_DRIVER, 0x29,
+				"Failed to register character device");
 	}
 	return 0;
 
@@ -2219,7 +2268,7 @@ static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	printk(KERN_WARNING "3w-9xxx: Suspending host %d.\n", tw_dev->host->host_no);
+	pr_warn("Suspending host %d\n", tw_dev->host->host_no);
 
 	TW_DISABLE_INTERRUPTS(tw_dev);
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
@@ -2229,9 +2278,10 @@ static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	/* Tell the card we are shutting down */
 	if (twa_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x38, "Connection shutdown failed during suspend");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x38,
+			"Connection shutdown failed during suspend");
 	} else {
-		printk(KERN_WARNING "3w-9xxx: Suspend complete.\n");
+		pr_warn("Suspend complete\n");
 	}
 	TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 
@@ -2249,14 +2299,15 @@ static int twa_resume(struct pci_dev *pdev)
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
+	pr_warn("Resuming host %d\n", tw_dev->host->host_no);
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x39, "Enable device failed during resume");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x39,
+			"Enable device failed during resume");
 		return retval;
 	}
 
@@ -2267,7 +2318,8 @@ static int twa_resume(struct pci_dev *pdev)
 	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
 		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-			TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
+			twa_msg(host, TW_DRIVER, 0x40,
+				"Failed to set dma mask during resume");
 			retval = -ENODEV;
 			goto out_disable_device;
 		}
@@ -2281,7 +2333,8 @@ static int twa_resume(struct pci_dev *pdev)
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twa_interrupt, IRQF_SHARED, "3w-9xxx", tw_dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x42, "Error requesting IRQ during resume");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x42,
+			"Error requesting IRQ during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
 	}
@@ -2293,7 +2346,7 @@ static int twa_resume(struct pci_dev *pdev)
 	/* Re-enable interrupts on the card */
 	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
 
-	printk(KERN_WARNING "3w-9xxx: Resume complete.\n");
+	pr_warn("Resume complete\n");
 	return 0;
 
 out_disable_device:
@@ -2334,7 +2387,8 @@ static struct pci_driver twa_driver = {
 /* This function is called on driver initialization */
 static int __init twa_init(void)
 {
-	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
+	pr_warn("3ware 9000 Storage Controller device driver for Linux v%s\n",
+		TW_DRIVER_VERSION);
 
 	return pci_register_driver(&twa_driver);
 } /* End twa_init() */
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 040f721..44849b7 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -466,12 +466,9 @@ static twa_message_type twa_error_table[] = {
 			TW_CONTROL_MASK_RESPONSE_INTERRUPT | \
 			TW_CONTROL_CLEAR_ERROR_STATUS | \
 			TW_CONTROL_DISABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
-#define TW_PRINTK(h,a,b,c) { \
-if (h) \
-printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s.\n",h->host_no,a,b,c); \
-else \
-printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
-}
+void TW9_PRINTK(const struct Scsi_Host *host, int err1, int err2,
+		const char *desc);
+
 #define TW_MAX_LUNS(srl) (srl < TW_FW_SRL_LUNS_SUPPORTED ? 1 : 16)
 #define TW_COMMAND_SIZE (sizeof(dma_addr_t) > 4 ? 5 : 4)
 #define TW_APACHE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 72 : 109)
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 13e39e1..fc16928 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -53,6 +53,8 @@
    3.26.02.000 - Initial driver release.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
@@ -97,6 +99,17 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 
 /* Functions */
 
+static void twa_msg(const struct Scsi_Host *host, int err1, int err2,
+		    const char *desc)
+{
+	if (host)
+		pr_warn("scsi%d: ERROR: (0x%02X:0x%04X): %s\n",
+			host->host_no, err1, err2, desc);
+	else
+		pr_warn("ERROR: (0x%02X:0x%04X): %s\n",
+			err1, err2, desc);
+}
+
 /* This function returns AENs through sysfs */
 static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
@@ -271,11 +284,11 @@ static void twl_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	event->parameter_len = strlen(header->err_specific_desc);
 	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + 1 + strlen(error_str));
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
-		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
-		       host,
-		       twl_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
-		       TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen, error_str,
-		       header->err_specific_desc);
+		pr_warn("%s AEN: %s (0x%02X:0x%04X): %s:%s\n",
+			host,
+			twl_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
+			TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen, error_str,
+			header->err_specific_desc);
 	else
 		tw_dev->aen_count--;
 
@@ -313,7 +326,8 @@ static int twl_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
 	if (!use_sg)
 		return 0;
 	else if (use_sg < 0) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Failed to map scatter gather list");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1,
+			"Failed to map scatter gather list");
 		return 0;
 	}
 
@@ -432,7 +446,8 @@ static int twl_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 
 	/* Now post the command packet */
 	if (twl_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2, "Post failed while reading AEN queue");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x2,
+			"Post failed while reading AEN queue");
 		goto out;
 	}
 	retval = 0;
@@ -625,13 +640,15 @@ static int twl_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 	do {
 		/* Send command to the board */
 		if (twl_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x3, "Error posting request sense");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x3,
+				"Error posting request sense");
 			goto out;
 		}
 
 		/* Now poll for completion */
 		if (twl_poll_response(tw_dev, request_id, 30)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x4, "No valid response while draining AEN queue");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x4,
+				"No valid response while draining AEN queue");
 			tw_dev->posted_request_count--;
 			goto out;
 		}
@@ -685,7 +702,8 @@ static int twl_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 
 	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
 	if (!cpu_addr) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x5, "Memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x5,
+			"Memory allocation failed");
 		goto out;
 	}
 
@@ -829,9 +847,8 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		/* We timed out, and didn't get an interrupt */
 		if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 			/* Now we need to reset the board */
-			printk(KERN_WARNING "3w-sas: scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card.\n",
-			       tw_dev->host->host_no, TW_DRIVER, 0x6,
-			       cmd);
+			pr_warn("scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card\n",
+				tw_dev->host->host_no, TW_DRIVER, 0x6, cmd);
 			retval = -EIO;
 			twl_reset_device_extension(tw_dev, 1);
 			goto out3;
@@ -912,14 +929,14 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
 	error = le16_to_cpu(header->status_block.error);
 	if ((error != TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error != TW_ERROR_UNIT_OFFLINE) && (error != TW_ERROR_INVALID_FIELD_IN_CDB)) {
 		if (print_host)
-			printk(KERN_WARNING "3w-sas: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
-			       tw_dev->host->host_no,
-			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
-			       header->status_block.error,
-			       error_str, 
-			       header->err_specific_desc);
+			pr_warn("scsi%d: ERROR: (0x%02X:0x%04X): %s:%s\n",
+				tw_dev->host->host_no,
+				TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+				header->status_block.error,
+				error_str,
+				header->err_specific_desc);
 		else
-			printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s:%s.\n",
+			pr_warn("ERROR: (0x%02X:0x%04X): %s:%s\n",
 			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
 			       header->status_block.error,
 			       error_str,
@@ -993,7 +1010,8 @@ static void *twl_get_param(TW_Device_Extension *tw_dev, int request_id, int tabl
 
 	/* Poll for completion */
 	if (twl_poll_response(tw_dev, request_id, 30))
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x7, "No valid response during get param")
+		twa_msg(tw_dev->host, TW_DRIVER, 0x7,
+			"No valid response during get param");
 	else
 		retval = (void *)&(param->data[0]);
 
@@ -1049,7 +1067,8 @@ static int twl_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 
 	/* Poll for completion */
 	if (twl_poll_response(tw_dev, request_id, 30)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x8, "No valid response during init connection");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x8,
+			"No valid response during init connection");
 	} else {
 		if (set_features & TW_EXTENDED_INIT_CONNECT) {
 			*fw_on_ctlr_srl = le16_to_cpu(tw_initconnect->fw_srl);
@@ -1074,26 +1093,30 @@ static int twl_initialize_device_extension(TW_Device_Extension *tw_dev)
 
 	/* Initialize command packet buffers */
 	if (twl_allocate_memory(tw_dev, sizeof(TW_Command_Full), 0)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x9, "Command packet memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x9,
+			"Command packet memory allocation failed");
 		goto out;
 	}
 
 	/* Initialize generic buffer */
 	if (twl_allocate_memory(tw_dev, TW_SECTOR_SIZE, 1)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xa, "Generic memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xa,
+			"Generic memory allocation failed");
 		goto out;
 	}
 
 	/* Allocate sense buffers */
 	if (twl_allocate_memory(tw_dev, sizeof(TW_Command_Apache_Header), 2)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xb, "Sense buffer allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xb,
+			"Sense buffer allocation failed");
 		goto out;
 	}
 
 	/* Allocate event info space */
 	tw_dev->event_queue[0] = kcalloc(TW_Q_LENGTH, sizeof(TW_Event), GFP_KERNEL);
 	if (!tw_dev->event_queue[0]) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xc, "Event info memory allocation failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xc,
+			"Event info memory allocation failed");
 		goto out;
 	}
 
@@ -1136,7 +1159,8 @@ static int twl_handle_attention_interrupt(TW_Device_Extension *tw_dev)
 
 	/* Check for controller errors */
 	if (doorbell & TWL_DOORBELL_CONTROLLER_ERROR) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xd, "Microcontroller Error: clearing");
+		twa_msg(tw_dev->host, TW_DRIVER, 0xd,
+			"Microcontroller Error: clearing");
 		goto out;
 	}
 
@@ -1237,7 +1261,8 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 		/* Check for correct state */
 		if (tw_dev->state[request_id] != TW_S_POSTED) {
 			if (tw_dev->srb[request_id] != NULL) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Received a request id that wasn't posted");
+				twa_msg(tw_dev->host, TW_DRIVER, 0xe,
+					"Received a request id that wasn't posted");
 				TWL_MASK_INTERRUPTS(tw_dev);
 				goto twl_interrupt_bail;
 			}
@@ -1247,7 +1272,8 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 		if (tw_dev->srb[request_id] == NULL) {
 			if (request_id != tw_dev->chrdev_request_id) {
 				if (twl_aen_complete(tw_dev, request_id))
-					TW_PRINTK(tw_dev->host, TW_DRIVER, 0xf, "Error completing AEN during attention interrupt");
+					twa_msg(tw_dev->host, TW_DRIVER, 0xf,
+						"Error completing AEN during attention interrupt");
 			} else {
 				tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
 				wake_up(&tw_dev->ioctl_wqueue);
@@ -1321,12 +1347,14 @@ static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 			/* Make sure controller is in a good state */
 			if (twl_poll_register(tw_dev, TWL_SCRPD3_REG_ADDR(tw_dev), TWL_CONTROLLER_READY, 0x0, 30)) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10, "Controller never went non-ready during reset sequence");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x10,
+					"Controller never went non-ready during reset sequence");
 				tries++;
 				continue;
 			}
 			if (twl_poll_register(tw_dev, TWL_SCRPD3_REG_ADDR(tw_dev), TWL_CONTROLLER_READY, TWL_CONTROLLER_READY, 60)) {
-				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x11, "Controller not ready during reset sequence");
+				twa_msg(tw_dev->host, TW_DRIVER, 0x11,
+					"Controller not ready during reset sequence");
 				tries++;
 				continue;
 			}
@@ -1339,7 +1367,8 @@ static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 				       TW_CURRENT_DRIVER_BUILD, &fw_on_ctlr_srl,
 				       &fw_on_ctlr_arch_id, &fw_on_ctlr_branch,
 				       &fw_on_ctlr_build, &init_connect_result)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x12, "Initconnection failed while checking SRL");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x12,
+				"Initconnection failed while checking SRL");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1359,7 +1388,8 @@ static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 		/* Now check status */
 		status = readl(TWL_STATUS_REG_ADDR(tw_dev));
 		if (status) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x13, "Bad controller status after loading sense buffers");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x13,
+				"Bad controller status after loading sense buffers");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1367,7 +1397,8 @@ static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 
 		/* Drain the AEN queue */
 		if (twl_aen_drain_queue(tw_dev, soft_reset)) {
-			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x14, "AEN drain failed during reset sequence");
+			twa_msg(tw_dev->host, TW_DRIVER, 0x14,
+				"AEN drain failed during reset sequence");
 			do_soft_reset = 1;
 			tries++;
 			continue;
@@ -1482,15 +1513,16 @@ static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
 	tw_dev->num_resets++;
 
 	sdev_printk(KERN_WARNING, SCpnt->device,
-		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
-		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
+		    "WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card\n",
+		    TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
 
 	/* Make sure we are not issuing an ioctl or resetting from ioctl */
 	mutex_lock(&tw_dev->ioctl_lock);
 
 	/* Now reset the card and some of the device extension data */
 	if (twl_reset_device_extension(tw_dev, 0)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x15, "Controller reset failed during scsi host reset");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x15,
+			"Controller reset failed during scsi host reset");
 		goto out;
 	}
 
@@ -1547,13 +1579,14 @@ static void __twl_shutdown(TW_Device_Extension *tw_dev)
 	/* Free up the IRQ */
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
-	printk(KERN_WARNING "3w-sas: Shutting down host %d.\n", tw_dev->host->host_no);
+	pr_warn("Shutting down host %d\n", tw_dev->host->host_no);
 
 	/* Tell the card we are shutting down */
 	if (twl_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x16, "Connection shutdown failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x16,
+			"Connection shutdown failed");
 	} else {
-		printk(KERN_WARNING "3w-sas: Shutdown complete.\n");
+		pr_warn("Shutdown complete\n");
 	}
 
 	/* Clear doorbell interrupt just before exit */
@@ -1613,7 +1646,7 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		TW_PRINTK(host, TW_DRIVER, 0x17, "Failed to enable pci device");
+		twa_msg(host, TW_DRIVER, 0x17, "Failed to enable pci device");
 		goto out_disable_device;
 	}
 
@@ -1624,14 +1657,16 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
 		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-			TW_PRINTK(host, TW_DRIVER, 0x18, "Failed to set dma mask");
+			twa_msg(host, TW_DRIVER, 0x18,
+				"Failed to set dma mask");
 			retval = -ENODEV;
 			goto out_disable_device;
 		}
 
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
-		TW_PRINTK(host, TW_DRIVER, 0x19, "Failed to allocate memory for device extension");
+		twa_msg(host, TW_DRIVER, 0x19,
+			"Failed to allocate memory for device extension");
 		retval = -ENOMEM;
 		goto out_disable_device;
 	}
@@ -1642,21 +1677,23 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 	tw_dev->tw_pci_dev = pdev;
 
 	if (twl_initialize_device_extension(tw_dev)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize device extension");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1a,
+			"Failed to initialize device extension");
 		goto out_free_device_extension;
 	}
 
 	/* Request IO regions */
 	retval = pci_request_regions(pdev, "3w-sas");
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Failed to get mem region");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1b,
+			"Failed to get mem region");
 		goto out_free_device_extension;
 	}
 
 	/* Save base address, use region 1 */
 	tw_dev->base_addr = pci_iomap(pdev, 1, 0);
 	if (!tw_dev->base_addr) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
 		goto out_release_mem_region;
 	}
 
@@ -1665,7 +1702,8 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Initialize the card */
 	if (twl_reset_sequence(tw_dev, 0)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed during probe");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1d,
+			"Controller reset failed during probe");
 		goto out_iounmap;
 	}
 
@@ -1678,30 +1716,30 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 	/* Register the card with the kernel SCSI layer */
 	retval = scsi_add_host(host, &pdev->dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "scsi add host failed");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1e, "scsi add host failed");
 		goto out_iounmap;
 	}
 
 	pci_set_drvdata(pdev, host);
 
-	printk(KERN_WARNING "3w-sas: scsi%d: Found an LSI 3ware %s Controller at 0x%llx, IRQ: %d.\n",
-	       host->host_no,
-	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
-				     TW_PARAM_MODEL, TW_PARAM_MODEL_LENGTH),
-	       (u64)pci_resource_start(pdev, 1), pdev->irq);
+	pr_warn("scsi%d: Found an LSI 3ware %s Controller at 0x%llx, IRQ: %d\n",
+		host->host_no,
+		(char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				      TW_PARAM_MODEL, TW_PARAM_MODEL_LENGTH),
+		(u64)pci_resource_start(pdev, 1), pdev->irq);
 
 	ptr_phycount = twl_get_param(tw_dev, 2, TW_PARAM_PHY_SUMMARY_TABLE,
 				     TW_PARAM_PHYCOUNT, TW_PARAM_PHYCOUNT_LENGTH);
 	if (ptr_phycount)
 		phycount = le32_to_cpu(*(int *)ptr_phycount);
 
-	printk(KERN_WARNING "3w-sas: scsi%d: Firmware %s, BIOS %s, Phys: %d.\n",
-	       host->host_no,
-	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
-				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
-	       (char *)twl_get_param(tw_dev, 2, TW_VERSION_TABLE,
-				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-	       phycount);
+	pr_warn("scsi%d: Firmware %s, BIOS %s, Phys: %d\n",
+		host->host_no,
+		(char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				      TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
+		(char *)twl_get_param(tw_dev, 2, TW_VERSION_TABLE,
+				      TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
+		phycount);
 
 	/* Try to enable MSI */
 	if (use_msi && !pci_enable_msi(pdev))
@@ -1710,7 +1748,7 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas", tw_dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
 		goto out_remove_host;
 	}
 
@@ -1725,13 +1763,16 @@ static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Add sysfs binary files */
 	if (sysfs_create_bin_file(&host->shost_dev.kobj, &twl_sysfs_aen_read_attr))
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x20, "Failed to create sysfs binary file: 3ware_aen_read");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x20,
+			"Failed to create sysfs binary file: 3ware_aen_read");
 	if (sysfs_create_bin_file(&host->shost_dev.kobj, &twl_sysfs_compat_info_attr))
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x21, "Failed to create sysfs binary file: 3ware_compat_info");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x21,
+			"Failed to create sysfs binary file: 3ware_compat_info");
 
 	if (twl_major == -1) {
 		if ((twl_major = register_chrdev (0, "twl", &twl_fops)) < 0)
-			TW_PRINTK(host, TW_DRIVER, 0x22, "Failed to register character device");
+			twa_msg(host, TW_DRIVER, 0x22,
+				"Failed to register character device");
 	}
 	tw_dev->online = 1;
 	return 0;
@@ -1807,7 +1848,7 @@ static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	printk(KERN_WARNING "3w-sas: Suspending host %d.\n", tw_dev->host->host_no);
+	pr_warn("Suspending host %d\n", tw_dev->host->host_no);
 	/* Disable interrupts */
 	TWL_MASK_INTERRUPTS(tw_dev);
 
@@ -1815,9 +1856,10 @@ static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	/* Tell the card we are shutting down */
 	if (twl_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL)) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x23, "Connection shutdown failed during suspend");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x23,
+			"Connection shutdown failed during suspend");
 	} else {
-		printk(KERN_WARNING "3w-sas: Suspend complete.\n");
+		pr_warn("Suspend complete\n");
 	}
 
 	/* Clear doorbell interrupt */
@@ -1837,14 +1879,15 @@ static int twl_resume(struct pci_dev *pdev)
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
+	pr_warn("Resuming host %d\n", tw_dev->host->host_no);
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x24, "Enable device failed during resume");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x24,
+			"Enable device failed during resume");
 		return retval;
 	}
 
@@ -1855,7 +1898,8 @@ static int twl_resume(struct pci_dev *pdev)
 	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
 		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-			TW_PRINTK(host, TW_DRIVER, 0x25, "Failed to set dma mask during resume");
+			twa_msg(host, TW_DRIVER, 0x25,
+				"Failed to set dma mask during resume");
 			retval = -ENODEV;
 			goto out_disable_device;
 		}
@@ -1869,7 +1913,8 @@ static int twl_resume(struct pci_dev *pdev)
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas", tw_dev);
 	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x26, "Error requesting IRQ during resume");
+		twa_msg(tw_dev->host, TW_DRIVER, 0x26,
+			"Error requesting IRQ during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
 	}
@@ -1881,7 +1926,7 @@ static int twl_resume(struct pci_dev *pdev)
 	/* Re-enable interrupts on the card */
 	TWL_UNMASK_INTERRUPTS(tw_dev);
 
-	printk(KERN_WARNING "3w-sas: Resume complete.\n");
+	pr_warn("Resume complete\n");
 	return 0;
 
 out_disable_device:
@@ -1915,7 +1960,8 @@ static struct pci_driver twl_driver = {
 /* This function is called on driver initialization */
 static int __init twl_init(void)
 {
-	printk(KERN_INFO "LSI 3ware SAS/SATA-RAID Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
+	pr_info("LSI 3ware SAS/SATA-RAID Controller device driver for Linux v%s\n",
+		TW_DRIVER_VERSION);
 
 	return pci_register_driver(&twl_driver);
 } /* End twl_init() */
diff --git a/drivers/scsi/3w-sas.h b/drivers/scsi/3w-sas.h
index d474892..d1a32fa 100644
--- a/drivers/scsi/3w-sas.h
+++ b/drivers/scsi/3w-sas.h
@@ -195,12 +195,6 @@ static char *twl_aen_severity_table[] =
 #define TWL_SOFT_RESET(x) (writel(TWL_ISSUE_SOFT_RESET, TWL_HIBDB_REG_ADDR(tw_dev)))
 
 /* Macros */
-#define TW_PRINTK(h,a,b,c) { \
-if (h) \
-printk(KERN_WARNING "3w-sas: scsi%d: ERROR: (0x%02X:0x%04X): %s.\n",h->host_no,a,b,c); \
-else \
-printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
-}
 #define TW_MAX_LUNS 16
 #define TW_COMMAND_SIZE (sizeof(dma_addr_t) > 4 ? 6 : 4)
 #define TW_LIBERATOR_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 46 : 92)


