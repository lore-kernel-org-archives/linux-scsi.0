From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 06/12] scsi/NCR5380: fix dprintk macro usage and definition
Date: Tue, 18 Mar 2014 11:42:18 +1100
Message-ID: <20140318004214.402473367@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-debug-macros-dprintk-params
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There are three implementations of the core NCR5380 driver and three sets
of debugging macro definitions. And all three implementations use the
NCR5380.h header as well.

Two of the definitions of the dprintk macro accept a variable argument list
whereas the third does not. Standardize on the variable argument list.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |  126 ++++++++++++++++++++++++-------------------------
 drivers/scsi/NCR5380.h |    6 +-
 2 files changed, 66 insertions(+), 66 deletions(-)

Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
@@ -1003,7 +1003,7 @@ static int NCR5380_queue_command_lck(Scs
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
-	dprintk(NDEBUG_QUEUES, ("scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail"));
+	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
@@ -1038,7 +1038,7 @@ static void NCR5380_main(struct work_str
 		/* Lock held here */
 		done = 1;
 		if (!hostdata->connected && !hostdata->selecting) {
-			dprintk(NDEBUG_MAIN, ("scsi%d : not connected\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : not connected\n", instance->host_no);
 			/*
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
@@ -1046,7 +1046,7 @@ static void NCR5380_main(struct work_str
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun));
+					dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
 					if (prev) {
@@ -1064,7 +1064,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun));
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -1093,7 +1093,7 @@ static void NCR5380_main(struct work_str
 						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 						hostdata->issue_queue = tmp;
 						done = 0;
-						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no));
+						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no);
 					}
 					/* lock held here still */
 				}	/* if target/lun is not busy */
@@ -1123,9 +1123,9 @@ static void NCR5380_main(struct work_str
 #endif
 		    && (!hostdata->time_expires || time_before_eq(hostdata->time_expires, jiffies))
 		    ) {
-			dprintk(NDEBUG_MAIN, ("scsi%d : main() : performing information transfer\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : main() : performing information transfer\n", instance->host_no);
 			NCR5380_information_transfer(instance);
-			dprintk(NDEBUG_MAIN, ("scsi%d : main() : done set false\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : main() : done set false\n", instance->host_no);
 			done = 0;
 		} else
 			break;
@@ -1157,8 +1157,8 @@ static irqreturn_t NCR5380_intr(int dumm
 	unsigned char basr;
 	unsigned long flags;
 
-	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n",
-		instance->irq));
+	dprintk(NDEBUG_INTR, "scsi : NCR5380 irq %d triggered\n",
+		instance->irq);
 
 	do {
 		done = 1;
@@ -1171,14 +1171,14 @@ static irqreturn_t NCR5380_intr(int dumm
 			NCR5380_dprint(NDEBUG_INTR, instance);
 			if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 				done = 0;
-				dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : SEL interrupt\n", instance->host_no);
 				NCR5380_reselect(instance);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else if (basr & BASR_PARITY_ERROR) {
-				dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : PARITY interrupt\n", instance->host_no);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-				dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : RESET interrupt\n", instance->host_no);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else {
 #if defined(REAL_DMA)
@@ -1208,7 +1208,7 @@ static irqreturn_t NCR5380_intr(int dumm
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 				}
 #else
-				dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
+				dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 #endif
 			}
@@ -1302,7 +1302,7 @@ static int NCR5380_select(struct Scsi_Ho
 	hostdata->restart_select = 0;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
 
 	/* 
 	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the 
@@ -1331,7 +1331,7 @@ static int NCR5380_select(struct Scsi_Ho
 		goto failed;
 	}
 
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : arbitration complete\n", instance->host_no));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : arbitration complete\n", instance->host_no);
 
 	/* 
 	 * The arbitration delay is 2.2us, but this is a minimum and there is 
@@ -1345,7 +1345,7 @@ static int NCR5380_select(struct Scsi_Ho
 	/* Check for lost arbitration */
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		dprintk(NDEBUG_ARBITRATION, ("scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no));
+		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
 		goto failed;
 	}
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_SEL);
@@ -1358,7 +1358,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dprintk(NDEBUG_ARBITRATION, ("scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no));
+		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
 		goto failed;
 	}
 	/* 
@@ -1368,7 +1368,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(2);
 
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : won arbitration\n", instance->host_no));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
 	/* 
 	 * Now that we have won arbitration, start Selection process, asserting 
@@ -1420,7 +1420,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd)));
+	dprintk(NDEBUG_SELECTION, "scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd));
 
 	/* 
 	 * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1485,7 +1485,7 @@ part2:
 		collect_stats(hostdata, cmd);
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		dprintk(NDEBUG_SELECTION, ("scsi%d : target did not respond within 250ms\n", instance->host_no));
+		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n", instance->host_no);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
@@ -1518,7 +1518,7 @@ part2:
 		goto failed;
 	}
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id));
+	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
@@ -1528,7 +1528,7 @@ part2:
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	dprintk(NDEBUG_SELECTION, ("scsi%d : nexus established.\n", instance->host_no));
+	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
@@ -1581,9 +1581,9 @@ static int NCR5380_transfer_pio(struct S
 	NCR5380_setup(instance);
 
 	if (!(p & SR_IO))
-		dprintk(NDEBUG_PIO, ("scsi%d : pio write %d bytes\n", instance->host_no, c));
+		dprintk(NDEBUG_PIO, "scsi%d : pio write %d bytes\n", instance->host_no, c);
 	else
-		dprintk(NDEBUG_PIO, ("scsi%d : pio read %d bytes\n", instance->host_no, c));
+		dprintk(NDEBUG_PIO, "scsi%d : pio read %d bytes\n", instance->host_no, c);
 
 	/* 
 	 * The NCR5380 chip will only drive the SCSI bus when the 
@@ -1618,11 +1618,11 @@ static int NCR5380_transfer_pio(struct S
 			break;
 		}
 
-		dprintk(NDEBUG_HANDSHAKE, ("scsi%d : REQ detected\n", instance->host_no));
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d : REQ detected\n", instance->host_no);
 
 		/* Check for phase mismatch */
 		if ((tmp & PHASE_MASK) != p) {
-			dprintk(NDEBUG_HANDSHAKE, ("scsi%d : phase mismatch\n", instance->host_no));
+			dprintk(NDEBUG_HANDSHAKE, "scsi%d : phase mismatch\n", instance->host_no);
 			NCR5380_dprint_phase(NDEBUG_HANDSHAKE, instance);
 			break;
 		}
@@ -1658,7 +1658,7 @@ static int NCR5380_transfer_pio(struct S
 
 		/* FIXME - if this fails bus reset ?? */
 		NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 5*HZ);
-		dprintk(NDEBUG_HANDSHAKE, ("scsi%d : req false, handshake complete\n", instance->host_no));
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d : req false, handshake complete\n", instance->host_no);
 
 /*
  * We have several special cases to consider during REQ/ACK handshaking : 
@@ -1679,7 +1679,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	dprintk(NDEBUG_PIO, ("scsi%d : residual %d\n", instance->host_no, c));
+	dprintk(NDEBUG_PIO, "scsi%d : residual %d\n", instance->host_no, c);
 
 	*count = c;
 	*data = d;
@@ -1826,7 +1826,7 @@ static int NCR5380_transfer_dma(struct S
 		c -= 2;
 	}
 #endif
-	dprintk(NDEBUG_DMA, ("scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d));
+	dprintk(NDEBUG_DMA, "scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d);
 	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
 #endif
 
@@ -1855,7 +1855,7 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
 #endif				/* def REAL_DMA */
 
-	dprintk(NDEBUG_DMA, ("scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG)));
+	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
 	/* 
 	 *	On the PAS16 at least I/O recovery delays are not needed here.
@@ -1932,7 +1932,7 @@ static int NCR5380_transfer_dma(struct S
 		}
 	}
 
-	dprintk(NDEBUG_DMA, ("scsi%d : polled DMA transfer complete, basr 0x%X, sr 0x%X\n", instance->host_no, tmp, NCR5380_read(STATUS_REG)));
+	dprintk(NDEBUG_DMA, "scsi%d : polled DMA transfer complete, basr 0x%X, sr 0x%X\n", instance->host_no, tmp, NCR5380_read(STATUS_REG));
 
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1946,7 +1946,7 @@ static int NCR5380_transfer_dma(struct S
 #ifdef READ_OVERRUNS
 	if (*phase == p && (p & SR_IO) && residue == 0) {
 		if (overrun) {
-			dprintk(NDEBUG_DMA, ("Got an input overrun, using saved byte\n"));
+			dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 			**data = saved_data;
 			*data += 1;
 			*count -= 1;
@@ -1955,13 +1955,13 @@ static int NCR5380_transfer_dma(struct S
 			printk("No overrun??\n");
 			cnt = toPIO = 2;
 		}
-		dprintk(NDEBUG_DMA, ("Doing %d-byte PIO to 0x%X\n", cnt, *data));
+		dprintk(NDEBUG_DMA, "Doing %d-byte PIO to 0x%X\n", cnt, *data);
 		NCR5380_transfer_pio(instance, phase, &cnt, data);
 		*count -= toPIO - cnt;
 	}
 #endif
 
-	dprintk(NDEBUG_DMA, ("Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count)));
+	dprintk(NDEBUG_DMA, "Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count));
 	return 0;
 
 #elif defined(REAL_DMA)
@@ -2011,7 +2011,7 @@ static int NCR5380_transfer_dma(struct S
 		foo = NCR5380_pwrite(instance, d, c);
 #else
 		int timeout;
-		dprintk(NDEBUG_C400_PWRITE, ("About to pwrite %d bytes\n", c));
+		dprintk(NDEBUG_C400_PWRITE, "About to pwrite %d bytes\n", c);
 		if (!(foo = NCR5380_pwrite(instance, d, c))) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for 
@@ -2022,19 +2022,19 @@ static int NCR5380_transfer_dma(struct S
 				while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) && (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH));
 
 				if (!timeout)
-					dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : timed out on last byte\n", instance->host_no));
+					dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : timed out on last byte\n", instance->host_no);
 
 				if (hostdata->flags & FLAG_CHECK_LAST_BYTE_SENT) {
 					hostdata->flags &= ~FLAG_CHECK_LAST_BYTE_SENT;
 					if (NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT) {
 						hostdata->flags |= FLAG_HAS_LAST_BYTE_SENT;
-						dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : last byte sent works\n", instance->host_no));
+						dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : last byte sent works\n", instance->host_no);
 					}
 				}
 			} else {
-				dprintk(NDEBUG_C400_PWRITE, ("Waiting for LASTBYTE\n"));
+				dprintk(NDEBUG_C400_PWRITE, "Waiting for LASTBYTE\n");
 				while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT));
-				dprintk(NDEBUG_C400_PWRITE, ("Got LASTBYTE\n"));
+				dprintk(NDEBUG_C400_PWRITE, "Got LASTBYTE\n");
 			}
 		}
 #endif
@@ -2043,9 +2043,9 @@ static int NCR5380_transfer_dma(struct S
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	if ((!(p & SR_IO)) && (hostdata->flags & FLAG_NCR53C400)) {
-		dprintk(NDEBUG_C400_PWRITE, ("53C400w: Checking for IRQ\n"));
+		dprintk(NDEBUG_C400_PWRITE, "53C400w: Checking for IRQ\n");
 		if (NCR5380_read(BUS_AND_STATUS_REG) & BASR_IRQ) {
-			dprintk(NDEBUG_C400_PWRITE, ("53C400w:    got it, reading reset interrupt reg\n"));
+			dprintk(NDEBUG_C400_PWRITE, "53C400w:    got it, reading reset interrupt reg\n");
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else {
 			printk("53C400w:    IRQ NOT THERE!\n");
@@ -2137,7 +2137,7 @@ static void NCR5380_information_transfer
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
 					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-					dprintk(NDEBUG_INFORMATION, ("scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual));
+					dprintk(NDEBUG_INFORMATION, "scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual);
 				}
 				/*
 				 * The preferred transfer method is going to be 
@@ -2217,7 +2217,7 @@ static void NCR5380_information_transfer
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
@@ -2233,7 +2233,7 @@ static void NCR5380_information_transfer
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2245,7 +2245,7 @@ static void NCR5380_information_transfer
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 
 					/* 
@@ -2279,13 +2279,13 @@ static void NCR5380_information_transfer
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
+						dprintk(NDEBUG_AUTOSENSE, "scsi%d : performing request sense\n", instance->host_no);
 
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no));
+						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
 					} else
 #endif				/* def AUTOSENSE */
 					{
@@ -2325,7 +2325,7 @@ static void NCR5380_information_transfer
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun));
+						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun);
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2371,14 +2371,14 @@ static void NCR5380_information_transfer
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_EXTENDED, ("scsi%d : receiving extended message\n", instance->host_no));
+					dprintk(NDEBUG_EXTENDED, "scsi%d : receiving extended message\n", instance->host_no);
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
 
-					dprintk(NDEBUG_EXTENDED, ("scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]));
+					dprintk(NDEBUG_EXTENDED, "scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]);
 
 					if (!len && extended_msg[1] <= (sizeof(extended_msg) - 1)) {
 						/* Accept third byte by clearing ACK */
@@ -2388,7 +2388,7 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						dprintk(NDEBUG_EXTENDED, ("scsi%d : message received, residual %d\n", instance->host_no, len));
+						dprintk(NDEBUG_EXTENDED, "scsi%d : message received, residual %d\n", instance->host_no, len);
 
 						switch (extended_msg[2]) {
 						case EXTENDED_SDTR:
@@ -2454,7 +2454,7 @@ static void NCR5380_information_transfer
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
 					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
+					dprintk(NDEBUG_USLEEP, "scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
 					return;
 				}
 				break;
@@ -2474,7 +2474,7 @@ static void NCR5380_information_transfer
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
 				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
+				dprintk(NDEBUG_USLEEP, "scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
 				return;
 			}
 		}
@@ -2515,7 +2515,7 @@ static void NCR5380_reselect(struct Scsi
 	hostdata->restart_select = 1;
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
-	dprintk(NDEBUG_SELECTION, ("scsi%d : reselect\n", instance->host_no));
+	dprintk(NDEBUG_SELECTION, "scsi%d : reselect\n", instance->host_no);
 
 	/* 
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2595,7 +2595,7 @@ static void NCR5380_reselect(struct Scsi
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag));
+		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
 	}
 }
 
@@ -2680,8 +2680,8 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
 	NCR5380_setup(instance);
 
-	dprintk(NDEBUG_ABORT, ("scsi%d : abort called\n", instance->host_no));
-	dprintk(NDEBUG_ABORT, ("        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG)));
+	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
+	dprintk(NDEBUG_ABORT, "        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG));
 
 #if 0
 /*
@@ -2691,7 +2691,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  */
 
 	if (hostdata->connected == cmd) {
-		dprintk(NDEBUG_ABORT, ("scsi%d : aborting connected command\n", instance->host_no));
+		dprintk(NDEBUG_ABORT, "scsi%d : aborting connected command\n", instance->host_no);
 		hostdata->aborted = 1;
 /*
  * We should perform BSY checking, and make sure we haven't slipped
@@ -2719,14 +2719,14 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  *          from the issue queue.
  */
  
-	dprintk(NDEBUG_ABORT, ("scsi%d : abort going into loop.\n", instance->host_no));
+	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
 	for (prev = (Scsi_Cmnd **) & (hostdata->issue_queue), tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (Scsi_Cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
 			tmp->result = DID_ABORT << 16;
-			dprintk(NDEBUG_ABORT, ("scsi%d : abort removed command from issue queue.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
 			tmp->scsi_done(tmp);
 			return SUCCESS;
 		}
@@ -2748,7 +2748,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  */
 
 	if (hostdata->connected) {
-		dprintk(NDEBUG_ABORT, ("scsi%d : abort failed, command connected.\n", instance->host_no));
+		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
 		return FAILED;
 	}
 /*
@@ -2778,11 +2778,11 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
 	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp; tmp = (Scsi_Cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
-			dprintk(NDEBUG_ABORT, ("scsi%d : aborting disconnected command.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
 			if (NCR5380_select(instance, cmd, (int) cmd->tag))
 				return FAILED;
-			dprintk(NDEBUG_ABORT, ("scsi%d : nexus reestablished.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
 
 			do_abort(instance);
 
Index: linux-m68k/drivers/scsi/NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.h	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.h	2014-03-18 00:18:34.000000000 +1100
@@ -288,9 +288,9 @@ struct NCR5380_hostdata {
 
 #ifdef __KERNEL__
 
-#define dprintk(a,b)			do {} while(0)
-#define NCR5380_dprint(a,b)		do {} while(0)
-#define NCR5380_dprint_phase(a,b)	do {} while(0)
+#define dprintk(flg, fmt, args...)     do {} while (0)
+#define NCR5380_dprint(flg, arg)       do {} while (0)
+#define NCR5380_dprint_phase(flg, arg) do {} while (0)
 
 #if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
