From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware driver update for linux-2.6.12-rc1-bk2
Date: Mon, 21 Mar 2005 19:38:24 -0800
Message-ID: <b1bc6a00050321193832afec6f@mail.gmail.com>
Reply-To: adam radford <aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.193]:37 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262306AbVCVDi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 22:38:29 -0500
Received: by wproxy.gmail.com with SMTP id 68so1213418wra
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2005 19:38:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

This patch updates the driver for the 3ware 5/6/7/8000 series to do
the following:

- Increase max ioctl buffer size to 512 sectors.
- Make tw_scsi_queue() return 0 for 'Unknown scsi opcode'.
- Fix tw_remove() to free irq handler/unregister_chrdev() before shutting down
  the card.
- Change to new 'change_queue_depth' api (from James).
- Fix 'handled=1' ISR usage, remove bogus IRQ check (from Jeff).

A smiliar patch for the 9000 series driver will follow shortly,
including a PAE fix,
and a few other things (that is why I want it to be a separate patch).

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

diff -Naur linux-2.6.12-rc1-bk1/drivers/scsi/3w-xxxx.c
linux-2.6.12-rc1-bk2/drivers/scsi/3w-xxxx.c
--- linux-2.6.12-rc1-bk1/drivers/scsi/3w-xxxx.c	2005-03-18
22:35:03.000000000 -0800
+++ linux-2.6.12-rc1-bk2/drivers/scsi/3w-xxxx.c	2005-03-21
19:19:36.000000000 -0800
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2004 3ware Inc.
+   Copyright (C) 1999-2005 3ware Inc.
 
    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -185,6 +185,12 @@
                  Fix data_buffer_length usage in tw_chrdev_ioctl().
                  Update contact information.
    1.26.02.000 - Convert driver to pci_driver format.
+   1.26.02.001 - Increase max ioctl buffer size to 512 sectors.
+                 Make tw_scsi_queue() return 0 for 'Unknown scsi opcode'.
+                 Fix tw_remove() to free irq handler/unregister_chrdev()
+                 before shutting down card.
+                 Change to new 'change_queue_depth' api.
+                 Fix 'handled=1' ISR usage, remove bogus IRQ check.
 */
 
 #include <linux/module.h>
@@ -207,7 +213,7 @@
 #include "3w-xxxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.000"
+#define TW_DRIVER_VERSION "1.26.02.001"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -509,33 +515,13 @@
 } /* End tw_show_stats() */
 
 /* This function will set a devices queue depth */
-static ssize_t tw_store_queue_depth(struct device *dev, const char
*buf, size_t count)
+static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
-	int queue_depth;
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	queue_depth = simple_strtoul(buf, NULL, 0);
 	if (queue_depth > TW_Q_LENGTH-2)
-		return -EINVAL;
+		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
-
-	return count;
-} /* End tw_store_queue_depth() */
-
-/* Create sysfs 'queue_depth' entry */
-static struct device_attribute tw_queue_depth_attr = {
-	.attr = {
-		.name =		"queue_depth",
-		.mode =		S_IRUSR | S_IWUSR,
-	},
-	.store = tw_store_queue_depth
-};
-
-/* Device attributes initializer */
-static struct device_attribute *tw_dev_attrs[] = {
-	&tw_queue_depth_attr,
-	NULL,
-};
+	return queue_depth;
+} /* End tw_change_queue_depth() */
 
 /* Create sysfs 'stats' entry */
 static struct class_device_attribute tw_host_stats_attr = {
@@ -910,7 +896,7 @@
 		goto out;
 
 	/* Check size */
-	if (data_buffer_length > TW_MAX_SECTORS * 512) {
+	if (data_buffer_length > TW_MAX_IOCTL_SECTORS * 512) {
 		retval = -EINVAL;
 		goto out;
 	}
@@ -995,7 +981,7 @@
 			timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
 			/* Now wait for the command to complete */
-			timeout = wait_event_interruptible_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
+			timeout = wait_event_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
 
 			/* See if we reset while waiting for the ioctl to complete */
 			if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
@@ -1004,16 +990,11 @@
 				goto out2;
 			}
 
-			/* Check if we timed out, got a signal, or didn't get
-			   an interrupt */
-			if ((timeout <= 0) && (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE)) {
+			/* We timed out, and didn't get an interrupt */
+			if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 				/* Now we need to reset the board */
-				if (timeout == -ERESTARTSYS) {
-					retval = timeout;
-				} else {
-					printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x)
timed out, resetting card.\n", tw_dev->host->host_no, cmd);
-					retval = -EIO;
-				}
+				printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x)
timed out, resetting card.\n", tw_dev->host->host_no, cmd);
+				retval = -EIO;
 				spin_lock_irqsave(tw_dev->host->host_lock, flags);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				tw_state_request_finish(tw_dev, request_id);
@@ -2060,7 +2041,7 @@
 			tw_state_request_finish(tw_dev, request_id);
 			SCpnt->result = (DID_BAD_TARGET << 16);
 			done(SCpnt);
-			goto out;
+			retval = 0;
 	}
 	if (retval) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
@@ -2069,7 +2050,6 @@
 		done(SCpnt);
 		retval = 0;
 	}
-out:
 	return retval;
 } /* End tw_scsi_queue() */
 
@@ -2088,183 +2068,180 @@
 	/* Get the host lock for io completions */
 	spin_lock(tw_dev->host->host_lock);
 
-	/* See if the interrupt matches this instance */
-	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
+	/* Read the registers */
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
-		handled = 1;
+	/* Check if this is our interrupt, otherwise bail */
+	if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+		goto tw_interrupt_bail;
 
-		/* Read the registers */
-		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+	handled = 1;
 
-		/* Check if this is our interrupt, otherwise bail */
-		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+	/* Check controller for errors */
+	if (tw_check_bits(status_reg_value)) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
+		if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
+			TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 			goto tw_interrupt_bail;
-
-		/* Check controller for errors */
-		if (tw_check_bits(status_reg_value)) {
-			dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
-			if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
-				TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-				goto tw_interrupt_bail;
-			}
 		}
+	}
 
-		/* Handle host interrupt */
-		if (status_reg_value & TW_STATUS_HOST_INTERRUPT) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received host interrupt.\n");
-			TW_CLEAR_HOST_INTERRUPT(tw_dev);
+	/* Handle host interrupt */
+	if (status_reg_value & TW_STATUS_HOST_INTERRUPT) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received host interrupt.\n");
+		TW_CLEAR_HOST_INTERRUPT(tw_dev);
+	}
+
+	/* Handle attention interrupt */
+	if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention
interrupt.\n");
+		TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
+		tw_state_request_start(tw_dev, &request_id);
+		error = tw_aen_read_queue(tw_dev, request_id);
+		if (error) {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen queue.\n",
tw_dev->host->host_no);
+			tw_dev->state[request_id] = TW_S_COMPLETED;
+			tw_state_request_finish(tw_dev, request_id);
 		}
+	}
 
-		/* Handle attention interrupt */
-		if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention
interrupt.\n");
-			TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
-			tw_state_request_start(tw_dev, &request_id);
-			error = tw_aen_read_queue(tw_dev, request_id);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen
queue.\n", tw_dev->host->host_no);
-				tw_dev->state[request_id] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, request_id);
+	/* Handle command interrupt */
+	if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
+		/* Drain as many pending commands as we can */
+		while (tw_dev->pending_request_count > 0) {
+			request_id = tw_dev->pending_queue[tw_dev->pending_head];
+			if (tw_dev->state[request_id] != TW_S_PENDING) {
+				printk(KERN_WARNING "3w-xxxx: scsi%d: Found request id that
wasn't pending.\n", tw_dev->host->host_no);
+				break;
+			}
+			if (tw_post_command_packet(tw_dev, request_id)==0) {
+				if (tw_dev->pending_head == TW_Q_LENGTH-1) {
+					tw_dev->pending_head = TW_Q_START;
+				} else {
+					tw_dev->pending_head = tw_dev->pending_head + 1;
+				}
+				tw_dev->pending_request_count--;
+			} else {
+				/* If we get here, we will continue re-posting on the next
command interrupt */
+				break;
 			}
 		}
+		/* If there are no more pending requests, we mask command interrupt */
+		if (tw_dev->pending_request_count == 0) 
+			TW_MASK_COMMAND_INTERRUPT(tw_dev);
+	}
+
+	/* Handle response interrupt */
+	if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
+		/* Drain the response queue from the board */
+		while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
+			/* Read response queue register */
+			response_que.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+			request_id = TW_RESID_OUT(response_que.response_id);
+			command_packet = (TW_Command
*)tw_dev->command_packet_virtual_address[request_id];
+			error = 0;
 
-		/* Handle command interrupt */
-		if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
-			/* Drain as many pending commands as we can */
-			while (tw_dev->pending_request_count > 0) {
-				request_id = tw_dev->pending_queue[tw_dev->pending_head];
-				if (tw_dev->state[request_id] != TW_S_PENDING) {
-					printk(KERN_WARNING "3w-xxxx: scsi%d: Found request id that
wasn't pending.\n", tw_dev->host->host_no);
-					break;
-				}
-				if (tw_post_command_packet(tw_dev, request_id)==0) {
-					if (tw_dev->pending_head == TW_Q_LENGTH-1) {
-						tw_dev->pending_head = TW_Q_START;
-					} else {
-						tw_dev->pending_head = tw_dev->pending_head + 1;
-					}
-					tw_dev->pending_request_count--;
+			/* Check for bad response */
+			if (command_packet->status != 0) {
+				/* If internal command, don't error, don't fill sense */
+				if (tw_dev->srb[request_id] == NULL) {
+					tw_decode_sense(tw_dev, request_id, 0);
 				} else {
-					/* If we get here, we will continue re-posting on the next
command interrupt */
-					break;
+					error = tw_decode_sense(tw_dev, request_id, 1);
 				}
 			}
-			/* If there are no more pending requests, we mask command interrupt */
-			if (tw_dev->pending_request_count == 0) 
-				TW_MASK_COMMAND_INTERRUPT(tw_dev);
-		}
-
-		/* Handle response interrupt */
-		if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
-			/* Drain the response queue from the board */
-			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-				/* Read response queue register */
-				response_que.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
-				request_id = TW_RESID_OUT(response_que.response_id);
-				command_packet = (TW_Command
*)tw_dev->command_packet_virtual_address[request_id];
-				error = 0;
-
-				/* Check for bad response */
-				if (command_packet->status != 0) {
-					/* If internal command, don't error, don't fill sense */
-					if (tw_dev->srb[request_id] == NULL) {
-						tw_decode_sense(tw_dev, request_id, 0);
-					} else {
-						error = tw_decode_sense(tw_dev, request_id, 1);
-					}
-				}
 
-				/* Check for correct state */
-				if (tw_dev->state[request_id] != TW_S_POSTED) {
-					if (tw_dev->srb[request_id] != NULL) {
-						printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id
that wasn't posted.\n", tw_dev->host->host_no);
-						error = 1;
-					}
+			/* Check for correct state */
+			if (tw_dev->state[request_id] != TW_S_POSTED) {
+				if (tw_dev->srb[request_id] != NULL) {
+					printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id that
wasn't posted.\n", tw_dev->host->host_no);
+					error = 1;
 				}
+			}
 
-				dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue
request id: %d.\n", request_id);
+			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue
request id: %d.\n", request_id);
 
-				/* Check for internal command completion */
-				if (tw_dev->srb[request_id] == NULL) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Found internally
posted command.\n");
-					/* Check for chrdev ioctl completion */
-					if (request_id != tw_dev->chrdev_request_id) {
-						retval = tw_aen_complete(tw_dev, request_id);
-						if (retval) {
-							printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing
aen.\n", tw_dev->host->host_no);
-						}
-					} else {
-						tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-						wake_up(&tw_dev->ioctl_wqueue);
+			/* Check for internal command completion */
+			if (tw_dev->srb[request_id] == NULL) {
+				dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Found internally
posted command.\n");
+				/* Check for chrdev ioctl completion */
+				if (request_id != tw_dev->chrdev_request_id) {
+					retval = tw_aen_complete(tw_dev, request_id);
+					if (retval) {
+						printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing aen.\n",
tw_dev->host->host_no);
 					}
 				} else {
+					tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+					wake_up(&tw_dev->ioctl_wqueue);
+				}
+			} else {
 				switch (tw_dev->srb[request_id]->cmnd[0]) {
-					case READ_10:
-					case READ_6:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_10/READ_6\n");
-						break;
-					case WRITE_10:
-					case WRITE_6:
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught
WRITE_10/WRITE_6\n");
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
-						dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught
SYNCHRONIZE_CACHE\n");
-						break;
-					default:
-						printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
-						error = 1;
-					}
-
-					/* If no error command was a success */
-					if (error == 0) {
-						tw_dev->srb[request_id]->result = (DID_OK << 16);
-					}
+				case READ_10:
+				case READ_6:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_10/READ_6\n");
+					break;
+				case WRITE_10:
+				case WRITE_6:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught WRITE_10/WRITE_6\n");
+					break;
+				case TEST_UNIT_READY:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught TEST_UNIT_READY\n");
+					error = tw_scsiop_test_unit_ready_complete(tw_dev, request_id);
+					break;
+				case INQUIRY:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught INQUIRY\n");
+					error = tw_scsiop_inquiry_complete(tw_dev, request_id);
+					break;
+				case READ_CAPACITY:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught READ_CAPACITY\n");
+					error = tw_scsiop_read_capacity_complete(tw_dev, request_id);
+					break;
+				case MODE_SENSE:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught MODE_SENSE\n");
+					error = tw_scsiop_mode_sense_complete(tw_dev, request_id);
+					break;
+				case SYNCHRONIZE_CACHE:
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught
SYNCHRONIZE_CACHE\n");
+					break;
+				default:
+					printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
+					error = 1;
+				}
 
-					/* If error, command failed */
-					if (error == 1) {
-						/* Ask for a host reset */
-						tw_dev->srb[request_id]->result = (DID_OK << 16) |
(CHECK_CONDITION << 1);
-					}
+				/* If no error command was a success */
+				if (error == 0) {
+					tw_dev->srb[request_id]->result = (DID_OK << 16);
+				}
 
-					/* Now complete the io */
-					if ((error != TW_ISR_DONT_COMPLETE)) {
-						tw_dev->state[request_id] = TW_S_COMPLETED;
-						tw_state_request_finish(tw_dev, request_id);
-						tw_dev->posted_request_count--;
-						tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+				/* If error, command failed */
+				if (error == 1) {
+					/* Ask for a host reset */
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+				}
 
-						tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-					}
+				/* Now complete the io */
+				if ((error != TW_ISR_DONT_COMPLETE)) {
+					tw_dev->state[request_id] = TW_S_COMPLETED;
+					tw_state_request_finish(tw_dev, request_id);
+					tw_dev->posted_request_count--;
+					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+					
+					tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
 				}
+			}
 				
-				/* Check for valid status after each drain */
-				status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
-				if (tw_check_bits(status_reg_value)) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
-					if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
-						TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-						goto tw_interrupt_bail;
-					}
+			/* Check for valid status after each drain */
+			status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+			if (tw_check_bits(status_reg_value)) {
+				dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
+				if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
+					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+					goto tw_interrupt_bail;
 				}
 			}
 		}
 	}
+
 tw_interrupt_bail:
 	spin_unlock(tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
@@ -2304,6 +2281,7 @@
 	.queuecommand		= tw_scsi_queue,
 	.eh_host_reset_handler	= tw_scsi_eh_reset,
 	.bios_param		= tw_scsi_biosparam,
+	.change_queue_depth	= tw_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.this_id		= -1,
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
@@ -2311,7 +2289,6 @@
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= tw_host_attrs,
-	.sdev_attrs		= tw_dev_attrs,
 	.emulated		= 1
 };
 
@@ -2438,23 +2415,24 @@
 
 	scsi_remove_host(tw_dev->host);
 
-	__tw_shutdown(tw_dev);
+	/* Unregister character device */
+	if (twe_major >= 0) {
+		unregister_chrdev(twe_major, "twe");
+		twe_major = -1;
+	}
 
 	/* Free up the IRQ */
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
+	/* Shutdown the card */
+	__tw_shutdown(tw_dev);
+
 	/* Free up the mem region */
 	pci_release_regions(pdev);
 
 	/* Free up device extension resources */
 	tw_free_device_extension(tw_dev);
 
-	/* Unregister character device */
-	if (twe_major >= 0) {
-		unregister_chrdev(twe_major, "twe");
-		twe_major = -1;
-	}
-
 	scsi_host_put(tw_dev->host);
 	pci_disable_device(pdev);
 	tw_device_extension_count--;
diff -Naur linux-2.6.12-rc1-bk1/drivers/scsi/3w-xxxx.h
linux-2.6.12-rc1-bk2/drivers/scsi/3w-xxxx.h
--- linux-2.6.12-rc1-bk1/drivers/scsi/3w-xxxx.h	2005-03-21
19:16:18.000000000 -0800
+++ linux-2.6.12-rc1-bk2/drivers/scsi/3w-xxxx.h	2005-03-21
19:19:38.000000000 -0800
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2004 3ware Inc.
+   Copyright (C) 1999-2005 3ware Inc.
 
    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -227,6 +227,7 @@
 #define TW_IN_RESET                           2
 #define TW_IN_CHRDEV_IOCTL                    3
 #define TW_MAX_SECTORS                        256
+#define TW_MAX_IOCTL_SECTORS		      512
 #define TW_AEN_WAIT_TIME                      1000
 #define TW_IOCTL_WAIT_TIME                    (1 * HZ) /* 1 second */
 #define TW_ISR_DONT_COMPLETE                  2
