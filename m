From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 3/3] Fix 3ware irq handling: update irq handler indentation
Date: Wed, 02 Mar 2005 02:22:34 -0500
Message-ID: <422569BA.9000509@pobox.com>
References: <20050224015859.55191.qmail@web40910.mail.yahoo.com> <421D3D33.9060707@pobox.com> <20050226193255.GA6256@ime.usp.br> <4220D9DE.10904@pobox.com> <42234279.6030004@rtr.ca> <422568CF.3060307@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010804080102030608090208"
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5854 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262210AbVCBHWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 02:22:49 -0500
In-Reply-To: <422568CF.3060307@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linuxraid@amcc.com
Cc: Mark Lord <liml@rtr.ca>

This is a multi-part message in MIME format.
--------------010804080102030608090208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Reduce irq handler indentation level.

The previous patch replaced an always-true test with "if (1)",
a function change.

This patch simply eliminates the "if (1)", and reduces the indentation
level of the entire [rather large] interrupt handler code.

No code changes other than eliminating the "if (1)" test.

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


--------------010804080102030608090208
Content-Type: text/plain;
 name="patch.3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.3"

diff -Nru a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:58 -05:00
+++ b/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:58 -05:00
@@ -1173,138 +1173,136 @@
 	/* Get the per adapter lock */
 	spin_lock(tw_dev->host->host_lock);
 
-	if (1) {
+	/* Read the registers */
+	status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
 
-		/* Read the registers */
-		status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
-
-		/* Check if this is our interrupt, otherwise bail */
-		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+	/* Check if this is our interrupt, otherwise bail */
+	if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+		goto twa_interrupt_bail;
+
+	handled = 1;
+
+	/* Check controller for errors */
+	if (twa_check_bits(status_reg_value)) {
+		if (twa_decode_bits(tw_dev, status_reg_value)) {
+			TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 			goto twa_interrupt_bail;
-
-		handled = 1;
-
-		/* Check controller for errors */
-		if (twa_check_bits(status_reg_value)) {
-			if (twa_decode_bits(tw_dev, status_reg_value)) {
-				TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-				goto twa_interrupt_bail;
-			}
 		}
+	}
 
-		/* Handle host interrupt */
-		if (status_reg_value & TW_STATUS_HOST_INTERRUPT)
-			TW_CLEAR_HOST_INTERRUPT(tw_dev);
-
-		/* Handle attention interrupt */
-		if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
-			TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
-			if (!(test_and_set_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags))) {
-				twa_get_request_id(tw_dev, &request_id);
-
-				error = twa_aen_read_queue(tw_dev, request_id);
-				if (error) {
-					tw_dev->state[request_id] = TW_S_COMPLETED;
-					twa_free_request_id(tw_dev, request_id);
-					clear_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags);
-				}
+	/* Handle host interrupt */
+	if (status_reg_value & TW_STATUS_HOST_INTERRUPT)
+		TW_CLEAR_HOST_INTERRUPT(tw_dev);
+
+	/* Handle attention interrupt */
+	if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
+		TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
+		if (!(test_and_set_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags))) {
+			twa_get_request_id(tw_dev, &request_id);
+
+			error = twa_aen_read_queue(tw_dev, request_id);
+			if (error) {
+				tw_dev->state[request_id] = TW_S_COMPLETED;
+				twa_free_request_id(tw_dev, request_id);
+				clear_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags);
 			}
 		}
+	}
 
-		/* Handle command interrupt */
-		if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
-			TW_MASK_COMMAND_INTERRUPT(tw_dev);
-			/* Drain as many pending commands as we can */
-			while (tw_dev->pending_request_count > 0) {
-				request_id = tw_dev->pending_queue[tw_dev->pending_head];
-				if (tw_dev->state[request_id] != TW_S_PENDING) {
-					TW_PRINTK(tw_dev->host, TW_DRIVER, 0x19, "Found request id that wasn't pending");
-					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-					goto twa_interrupt_bail;
-				}
-				if (twa_post_command_packet(tw_dev, request_id, 1)==0) {
-					tw_dev->pending_head = (tw_dev->pending_head + 1) % TW_Q_LENGTH;
-					tw_dev->pending_request_count--;
-				} else {
-					/* If we get here, we will continue re-posting on the next command interrupt */
-					break;
-				}
+	/* Handle command interrupt */
+	if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
+		TW_MASK_COMMAND_INTERRUPT(tw_dev);
+		/* Drain as many pending commands as we can */
+		while (tw_dev->pending_request_count > 0) {
+			request_id = tw_dev->pending_queue[tw_dev->pending_head];
+			if (tw_dev->state[request_id] != TW_S_PENDING) {
+				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x19, "Found request id that wasn't pending");
+				TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+				goto twa_interrupt_bail;
+			}
+			if (twa_post_command_packet(tw_dev, request_id, 1)==0) {
+				tw_dev->pending_head = (tw_dev->pending_head + 1) % TW_Q_LENGTH;
+				tw_dev->pending_request_count--;
+			} else {
+				/* If we get here, we will continue re-posting on the next command interrupt */
+				break;
 			}
 		}
+	}
 
-		/* Handle response interrupt */
-		if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
+	/* Handle response interrupt */
+	if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
 
-			/* Drain the response queue from the board */
-			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-				/* Complete the response */
-				response_que.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
-				request_id = TW_RESID_OUT(response_que.response_id);
-				full_command_packet = tw_dev->command_packet_virt[request_id];
-				error = 0;
-				command_packet = &full_command_packet->command.oldcommand;
-				/* Check for command packet errors */
-				if (full_command_packet->command.newcommand.status != 0) {
-					if (tw_dev->srb[request_id] != 0) {
-						error = twa_fill_sense(tw_dev, request_id, 1, 1);
-					} else {
-						/* Skip ioctl error prints */
-						if (request_id != tw_dev->chrdev_request_id) {
-							error = twa_fill_sense(tw_dev, request_id, 0, 1);
-						}
+		/* Drain the response queue from the board */
+		while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
+			/* Complete the response */
+			response_que.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+			request_id = TW_RESID_OUT(response_que.response_id);
+			full_command_packet = tw_dev->command_packet_virt[request_id];
+			error = 0;
+			command_packet = &full_command_packet->command.oldcommand;
+			/* Check for command packet errors */
+			if (full_command_packet->command.newcommand.status != 0) {
+				if (tw_dev->srb[request_id] != 0) {
+					error = twa_fill_sense(tw_dev, request_id, 1, 1);
+				} else {
+					/* Skip ioctl error prints */
+					if (request_id != tw_dev->chrdev_request_id) {
+						error = twa_fill_sense(tw_dev, request_id, 0, 1);
 					}
 				}
+			}
 
-				/* Check for correct state */
-				if (tw_dev->state[request_id] != TW_S_POSTED) {
-					if (tw_dev->srb[request_id] != 0) {
-						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Received a request id that wasn't posted");
-					        TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-						goto twa_interrupt_bail;
-					}
+			/* Check for correct state */
+			if (tw_dev->state[request_id] != TW_S_POSTED) {
+				if (tw_dev->srb[request_id] != 0) {
+					TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Received a request id that wasn't posted");
+				        TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+					goto twa_interrupt_bail;
 				}
+			}
 
-				/* Check for internal command completion */
-				if (tw_dev->srb[request_id] == 0) {
-					if (request_id != tw_dev->chrdev_request_id) {
-						if (twa_aen_complete(tw_dev, request_id))
-							TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Error completing AEN during attention interrupt");
-					} else {
-						tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-						wake_up(&tw_dev->ioctl_wqueue);
-					}
+			/* Check for internal command completion */
+			if (tw_dev->srb[request_id] == 0) {
+				if (request_id != tw_dev->chrdev_request_id) {
+					if (twa_aen_complete(tw_dev, request_id))
+						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Error completing AEN during attention interrupt");
 				} else {
-					twa_scsiop_execute_scsi_complete(tw_dev, request_id);
-					/* If no error command was a success */
-					if (error == 0) {
-						tw_dev->srb[request_id]->result = (DID_OK << 16);
-					}
-
-					/* If error, command failed */
-					if (error == 1) {
-						/* Ask for a host reset */
-						tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-					}
-
-					/* Now complete the io */
-					tw_dev->state[request_id] = TW_S_COMPLETED;
-					twa_free_request_id(tw_dev, request_id);
-					tw_dev->posted_request_count--;
-					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-					twa_unmap_scsi_data(tw_dev, request_id);
+					tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+					wake_up(&tw_dev->ioctl_wqueue);
 				}
+			} else {
+				twa_scsiop_execute_scsi_complete(tw_dev, request_id);
+				/* If no error command was a success */
+				if (error == 0) {
+					tw_dev->srb[request_id]->result = (DID_OK << 16);
+				}
+
+				/* If error, command failed */
+				if (error == 1) {
+					/* Ask for a host reset */
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+				}
+
+				/* Now complete the io */
+				tw_dev->state[request_id] = TW_S_COMPLETED;
+				twa_free_request_id(tw_dev, request_id);
+				tw_dev->posted_request_count--;
+				tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+				twa_unmap_scsi_data(tw_dev, request_id);
+			}
 
-				/* Check for valid status after each drain */
-				status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
-				if (twa_check_bits(status_reg_value)) {
-					if (twa_decode_bits(tw_dev, status_reg_value)) {
-						TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-						goto twa_interrupt_bail;
-					}
+			/* Check for valid status after each drain */
+			status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
+			if (twa_check_bits(status_reg_value)) {
+				if (twa_decode_bits(tw_dev, status_reg_value)) {
+					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+					goto twa_interrupt_bail;
 				}
 			}
 		}
 	}
+
 twa_interrupt_bail:
 	spin_unlock(tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
diff -Nru a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:58 -05:00
+++ b/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:58 -05:00
@@ -2088,182 +2088,180 @@
 	/* Get the host lock for io completions */
 	spin_lock(tw_dev->host->host_lock);
 
-	if (1) {
+	/* Read the registers */
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
-		/* Read the registers */
-		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
-
-		/* Check if this is our interrupt, otherwise bail */
-		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+	/* Check if this is our interrupt, otherwise bail */
+	if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
+		goto tw_interrupt_bail;
+
+	handled = 1;
+
+	/* Check controller for errors */
+	if (tw_check_bits(status_reg_value)) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
+		if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
+			TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 			goto tw_interrupt_bail;
-
-		handled = 1;
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
-		}
+	/* Handle host interrupt */
+	if (status_reg_value & TW_STATUS_HOST_INTERRUPT) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received host interrupt.\n");
+		TW_CLEAR_HOST_INTERRUPT(tw_dev);
+	}
 
-		/* Handle attention interrupt */
-		if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
-			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention interrupt.\n");
-			TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
-			tw_state_request_start(tw_dev, &request_id);
-			error = tw_aen_read_queue(tw_dev, request_id);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen queue.\n", tw_dev->host->host_no);
-				tw_dev->state[request_id] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, request_id);
-			}
+	/* Handle attention interrupt */
+	if (status_reg_value & TW_STATUS_ATTENTION_INTERRUPT) {
+		dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Received attention interrupt.\n");
+		TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
+		tw_state_request_start(tw_dev, &request_id);
+		error = tw_aen_read_queue(tw_dev, request_id);
+		if (error) {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: Error reading aen queue.\n", tw_dev->host->host_no);
+			tw_dev->state[request_id] = TW_S_COMPLETED;
+			tw_state_request_finish(tw_dev, request_id);
 		}
+	}
 
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
+	/* Handle command interrupt */
+	if (status_reg_value & TW_STATUS_COMMAND_INTERRUPT) {
+		/* Drain as many pending commands as we can */
+		while (tw_dev->pending_request_count > 0) {
+			request_id = tw_dev->pending_queue[tw_dev->pending_head];
+			if (tw_dev->state[request_id] != TW_S_PENDING) {
+				printk(KERN_WARNING "3w-xxxx: scsi%d: Found request id that wasn't pending.\n", tw_dev->host->host_no);
+				break;
+			}
+			if (tw_post_command_packet(tw_dev, request_id)==0) {
+				if (tw_dev->pending_head == TW_Q_LENGTH-1) {
+					tw_dev->pending_head = TW_Q_START;
 				} else {
-					/* If we get here, we will continue re-posting on the next command interrupt */
-					break;
+					tw_dev->pending_head = tw_dev->pending_head + 1;
 				}
+				tw_dev->pending_request_count--;
+			} else {
+				/* If we get here, we will continue re-posting on the next command interrupt */
+				break;
 			}
-			/* If there are no more pending requests, we mask command interrupt */
-			if (tw_dev->pending_request_count == 0) 
-				TW_MASK_COMMAND_INTERRUPT(tw_dev);
 		}
+		/* If there are no more pending requests, we mask command interrupt */
+		if (tw_dev->pending_request_count == 0) 
+			TW_MASK_COMMAND_INTERRUPT(tw_dev);
+	}
 
-		/* Handle response interrupt */
-		if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
-			/* Drain the response queue from the board */
-			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-				/* Read response queue register */
-				response_que.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
-				request_id = TW_RESID_OUT(response_que.response_id);
-				command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
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
+	/* Handle response interrupt */
+	if (status_reg_value & TW_STATUS_RESPONSE_INTERRUPT) {
+		/* Drain the response queue from the board */
+		while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
+			/* Read response queue register */
+			response_que.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+			request_id = TW_RESID_OUT(response_que.response_id);
+			command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+			error = 0;
+
+			/* Check for bad response */
+			if (command_packet->status != 0) {
+				/* If internal command, don't error, don't fill sense */
+				if (tw_dev->srb[request_id] == NULL) {
+					tw_decode_sense(tw_dev, request_id, 0);
+				} else {
+					error = tw_decode_sense(tw_dev, request_id, 1);
 				}
+			}
 
-				/* Check for correct state */
-				if (tw_dev->state[request_id] != TW_S_POSTED) {
-					if (tw_dev->srb[request_id] != NULL) {
-						printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id that wasn't posted.\n", tw_dev->host->host_no);
-						error = 1;
-					}
+			/* Check for correct state */
+			if (tw_dev->state[request_id] != TW_S_POSTED) {
+				if (tw_dev->srb[request_id] != NULL) {
+					printk(KERN_WARNING "3w-xxxx: scsi%d: Received a request id that wasn't posted.\n", tw_dev->host->host_no);
+					error = 1;
 				}
+			}
 
-				dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue request id: %d.\n", request_id);
+			dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): Response queue request id: %d.\n", request_id);
 
-				/* Check for internal command completion */
-				if (tw_dev->srb[request_id] == NULL) {
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
+			/* Check for internal command completion */
+			if (tw_dev->srb[request_id] == NULL) {
+				dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Found internally posted command.\n");
+				/* Check for chrdev ioctl completion */
+				if (request_id != tw_dev->chrdev_request_id) {
+					retval = tw_aen_complete(tw_dev, request_id);
+					if (retval) {
+						printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing aen.\n", tw_dev->host->host_no);
 					}
 				} else {
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
-					default:
-						printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
-						error = 1;
-					}
+					tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+					wake_up(&tw_dev->ioctl_wqueue);
+				}
+			} else {
+			switch (tw_dev->srb[request_id]->cmnd[0]) {
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
+					dprintk(KERN_NOTICE "3w-xxxx: tw_interrupt(): caught SYNCHRONIZE_CACHE\n");
+					break;
+				default:
+					printk(KERN_WARNING "3w-xxxx: case slip in tw_interrupt()\n");
+					error = 1;
+				}
 
-					/* If no error command was a success */
-					if (error == 0) {
-						tw_dev->srb[request_id]->result = (DID_OK << 16);
-					}
+				/* If no error command was a success */
+				if (error == 0) {
+					tw_dev->srb[request_id]->result = (DID_OK << 16);
+				}
 
-					/* If error, command failed */
-					if (error == 1) {
-						/* Ask for a host reset */
-						tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-					}
+				/* If error, command failed */
+				if (error == 1) {
+					/* Ask for a host reset */
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+				}
 
-					/* Now complete the io */
-					if ((error != TW_ISR_DONT_COMPLETE)) {
-						tw_dev->state[request_id] = TW_S_COMPLETED;
-						tw_state_request_finish(tw_dev, request_id);
-						tw_dev->posted_request_count--;
-						tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+				/* Now complete the io */
+				if ((error != TW_ISR_DONT_COMPLETE)) {
+					tw_dev->state[request_id] = TW_S_COMPLETED;
+					tw_state_request_finish(tw_dev, request_id);
+					tw_dev->posted_request_count--;
+					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 
-						tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-					}
+					tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
 				}
-				
-				/* Check for valid status after each drain */
-				status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
-				if (tw_check_bits(status_reg_value)) {
-					dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
-					if (tw_decode_bits(tw_dev, status_reg_value, 1)) {
-						TW_CLEAR_ALL_INTERRUPTS(tw_dev);
-						goto tw_interrupt_bail;
-					}
+			}
+			
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

--------------010804080102030608090208--
