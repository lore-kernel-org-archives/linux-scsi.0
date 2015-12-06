From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 64/72] atari_NCR5380: Eliminate HOSTNO macro
Date: Sun, 06 Dec 2015 12:32:30 +1100
Message-ID: <20151206013142.815482783@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-remove-HOSTNO-dprintk
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Keep the two core driver forks in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   71 +++++++++++++++--------------
 drivers/scsi/atari_NCR5380.c |  102 +++++++++++++++++++------------------------
 2 files changed, 84 insertions(+), 89 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:31:09.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:31:11.000000000 +1100
@@ -175,8 +175,6 @@
  * possible) function may be used.
  */
 
-#define	HOSTNO		instance->host_no
-
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
@@ -1019,10 +1017,8 @@ static void NCR5380_main(struct work_str
 		    && !hostdata->dma_len
 #endif
 		    ) {
-			dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
-				    HOSTNO);
+			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfer\n");
 			NCR5380_information_transfer(instance);
-			dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
 			done = 0;
 		}
 	} while (!done);
@@ -1059,7 +1055,7 @@ static void NCR5380_dma_complete(struct
 			    (BASR_PHASE_MATCH|BASR_ACK)) {
 				saved_data = NCR5380_read(INPUT_DATA_REG);
 				overrun = 1;
-				dprintk(NDEBUG_DMA, "scsi%d: read overrun handled\n", HOSTNO);
+				dsprintk(NDEBUG_DMA, instance, "read overrun handled\n");
 			}
 		}
 	}
@@ -1164,8 +1160,8 @@ static irqreturn_t NCR5380_intr(int irq,
 		unsigned char mr = NCR5380_read(MODE_REG);
 		unsigned char sr = NCR5380_read(STATUS_REG);
 
-		dprintk(NDEBUG_INTR, "scsi%d: IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
-		        HOSTNO, irq, basr, sr, mr);
+		dsprintk(NDEBUG_INTR, instance, "IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
+		         irq, basr, sr, mr);
 
 #if defined(REAL_DMA)
 		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
@@ -1174,7 +1170,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			 * for End of DMA errata need to happen in DMA Mode.
 			 */
 
-			dprintk(NDEBUG_INTR, "scsi%d: interrupt in DMA mode\n", HOSTNO);
+			dsprintk(NDEBUG_INTR, instance, "interrupt in DMA mode\n");
 
 			if (hostdata->connected) {
 				NCR5380_dma_complete(instance);
@@ -1191,8 +1187,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			NCR5380_write(SELECT_ENABLE_REG, 0);
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-			dprintk(NDEBUG_INTR, "scsi%d: interrupt with SEL and IO\n",
-			        HOSTNO);
+			dsprintk(NDEBUG_INTR, instance, "interrupt with SEL and IO\n");
 
 			if (!hostdata->connected) {
 				NCR5380_reselect(instance);
@@ -1204,7 +1199,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			/* Probably Bus Reset */
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-			dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt\n", HOSTNO);
+			dsprintk(NDEBUG_INTR, instance, "unknown interrupt\n");
 #ifdef SUN3_SCSI_VME
 			dregs->csr |= CSR_DMA_ENABLE;
 #endif
@@ -1261,8 +1256,8 @@ static struct scsi_cmnd *NCR5380_select(
 	int err;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
-		   instance->this_id);
+	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
+	         instance->this_id);
 
 	/*
 	 * Arbitration and selection phases are slow and involve dropping the
@@ -1316,8 +1311,7 @@ static struct scsi_cmnd *NCR5380_select(
 	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
-			   HOSTNO);
+		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
 		spin_lock_irq(&hostdata->lock);
 		goto out;
 	}
@@ -1351,7 +1345,7 @@ static struct scsi_cmnd *NCR5380_select(
 		goto out;
 	}
 
-	dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
+	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
 
 	/*
 	 * Now that we have won arbitration, start Selection process, asserting
@@ -1407,7 +1401,7 @@ static struct scsi_cmnd *NCR5380_select(
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
+	dsprintk(NDEBUG_SELECTION, instance, "selecting target %d\n", scmd_id(cmd));
 
 	/*
 	 * The SCSI specification calls for a 250 ms timeout for the actual
@@ -1481,8 +1475,8 @@ static struct scsi_cmnd *NCR5380_select(
 		goto out;
 	}
 
-	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
-		   HOSTNO, cmd->device->id);
+	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
+	         scmd_id(cmd));
 	tmp[0] = IDENTIFY(1, cmd->device->lun);
 
 #ifdef SUPPORT_TAGS
@@ -1501,7 +1495,7 @@ static struct scsi_cmnd *NCR5380_select(
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
+	dsprintk(NDEBUG_SELECTION, instance, "nexus established.\n");
 	/* XXX need to handle errors here */
 
 	hostdata->connected = cmd;
@@ -1573,11 +1567,11 @@ static int NCR5380_transfer_pio(struct S
 		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
 			break;
 
-		dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
+		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
 
 		/* Check for phase mismatch */
 		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) != p) {
-			dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
+			dsprintk(NDEBUG_PIO, instance, "phase mismatch\n");
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
@@ -1619,7 +1613,7 @@ static int NCR5380_transfer_pio(struct S
 		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
 			break;
 
-		dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
+		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
 
 		/*
 		 * We have several special cases to consider during REQ/ACK handshaking :
@@ -1640,7 +1634,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
+	dsprintk(NDEBUG_PIO, instance, "residual %d\n", c);
 
 	*count = c;
 	*data = d;
@@ -1786,9 +1780,8 @@ static int NCR5380_transfer_dma(struct S
 	}
 	hostdata->dma_len = c;
 
-	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
-		instance->host_no, (p & SR_IO) ? "reading" : "writing",
-		c, (p & SR_IO) ? "to" : "from", *data);
+	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
+	         (p & SR_IO) ? "receive" : "send", c, *data);
 
 	/* netbsd turns off ints here, why not be safe and do it too */
 
@@ -1824,9 +1817,8 @@ static int NCR5380_transfer_dma(struct S
 	if (hostdata->read_overruns && (p & SR_IO))
 		c -= hostdata->read_overruns;
 
-	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
-		   HOSTNO, (p & SR_IO) ? "reading" : "writing",
-		   c, (p & SR_IO) ? "to" : "from", d);
+	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
+	         (p & SR_IO) ? "receive" : "send", c, d);
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
@@ -1973,9 +1965,9 @@ static void NCR5380_information_transfer
 					 * they are at contiguous physical addresses.
 					 */
 					merge_contiguous_buffers(cmd);
-					dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers left\n",
-						   HOSTNO, cmd->SCp.this_residual,
-						   cmd->SCp.buffers_residual);
+					dsprintk(NDEBUG_INFORMATION, instance, "%d bytes and %d buffers left\n",
+					         cmd->SCp.this_residual,
+					         cmd->SCp.buffers_residual);
 				}
 
 				/*
@@ -2063,11 +2055,12 @@ static void NCR5380_information_transfer
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
-						struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][cmd->device->lun];
-						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
-							   "QUEUE_FULL after %d commands\n",
-							   HOSTNO, cmd->device->id, cmd->device->lun,
-							   ta->nr_allocated);
+						u8 lun = cmd->device->lun;
+						struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][lun];
+
+						dsprintk(NDEBUG_TAGS, instance,
+						         "QUEUE_FULL %p target %d lun %d nr_allocated %d\n",
+						         cmd, scmd_id(cmd), lun, ta->nr_allocated);
 						if (ta->queue_size > ta->nr_allocated)
 							ta->queue_size = ta->nr_allocated;
 					}
@@ -2121,10 +2114,8 @@ static void NCR5380_information_transfer
 						cmd->device->tagged_supported = 0;
 						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 						cmd->tag = TAG_NONE;
-						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu rejected "
-							   "QUEUE_TAG message; tagged queuing "
-							   "disabled\n",
-							   HOSTNO, cmd->device->id, cmd->device->lun);
+						dsprintk(NDEBUG_TAGS, instance, "target %d lun %llu rejected QUEUE_TAG message; tagged queuing disabled\n",
+						         scmd_id(cmd), cmd->device->lun);
 						break;
 					}
 					break;
@@ -2183,14 +2174,15 @@ static void NCR5380_information_transfer
 
 					spin_unlock_irq(&hostdata->lock);
 
-					dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
+					dsprintk(NDEBUG_EXTENDED, instance, "receiving extended message\n");
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
-					dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
-						   (int)extended_msg[1], (int)extended_msg[2]);
+					dsprintk(NDEBUG_EXTENDED, instance, "length %d, code 0x%02x\n",
+					         (int)extended_msg[1],
+					         (int)extended_msg[2]);
 
 					if (!len && extended_msg[1] > 0 &&
 					    extended_msg[1] <= sizeof(extended_msg) - 2) {
@@ -2201,8 +2193,8 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
-							   HOSTNO, len);
+						dsprintk(NDEBUG_EXTENDED, instance, "message received, residual %d\n",
+						         len);
 
 						switch (extended_msg[2]) {
 						case EXTENDED_SDTR:
@@ -2330,7 +2322,7 @@ static void NCR5380_reselect(struct Scsi
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
-	dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
+	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
 
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2400,8 +2392,8 @@ static void NCR5380_reselect(struct Scsi
 		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 		    msg[1] == SIMPLE_QUEUE_TAG)
 			tag = msg[2];
-		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at "
-			   "reselection\n", HOSTNO, target_mask, lun, tag);
+		dsprintk(NDEBUG_TAGS, instance, "reselect: target mask %02x, lun %d sent tag %d\n",
+		         target_mask, lun, tag);
 	}
 #endif
 
@@ -2486,14 +2478,14 @@ static void NCR5380_reselect(struct Scsi
 		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 		    msg[1] == SIMPLE_QUEUE_TAG)
 			tag = msg[2];
-		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at reselection\n"
-			HOSTNO, target_mask, lun, tag);
+		dsprintk(NDEBUG_TAGS, instance, "reselect: target mask %02x, lun %d sent tag %d\n"
+		         target_mask, lun, tag);
 	}
 #endif
 
 	hostdata->connected = tmp;
-	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %llu, tag = %d\n",
-		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
+	dsprintk(NDEBUG_RESELECTION, instance, "nexus established, target %d, lun %llu, tag %d\n",
+	         scmd_id(tmp), tmp->device->lun, tmp->tag);
 }
 
 
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:31:09.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:31:11.000000000 +1100
@@ -921,9 +921,8 @@ static void NCR5380_main(struct work_str
 		    && !hostdata->dmalen
 #endif
 		    ) {
-			dprintk(NDEBUG_MAIN, "scsi%d : main() : performing information transfer\n", instance->host_no);
+			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfer\n");
 			NCR5380_information_transfer(instance);
-			dprintk(NDEBUG_MAIN, "scsi%d : main() : done set false\n", instance->host_no);
 			done = 0;
 		}
 	} while (!done);
@@ -981,8 +980,8 @@ static irqreturn_t NCR5380_intr(int irq,
 		unsigned char mr = NCR5380_read(MODE_REG);
 		unsigned char sr = NCR5380_read(STATUS_REG);
 
-		dprintk(NDEBUG_INTR, "scsi%d: IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
-		        instance->host_no, irq, basr, sr, mr);
+		dsprintk(NDEBUG_INTR, instance, "IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
+		         irq, basr, sr, mr);
 
 #if defined(REAL_DMA)
 		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
@@ -991,7 +990,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			 * for End of DMA errata need to happen in DMA Mode.
 			 */
 
-			dprintk(NDEBUG_INTR, "scsi%d: interrupt in DMA mode\n", intance->host_no);
+			dsprintk(NDEBUG_INTR, instance, "interrupt in DMA mode\n");
 
 			int transferred;
 
@@ -1018,8 +1017,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			NCR5380_write(SELECT_ENABLE_REG, 0);
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-			dprintk(NDEBUG_INTR, "scsi%d: interrupt with SEL and IO\n",
-			        instance->host_no);
+			dsprintk(NDEBUG_INTR, instance, "interrupt with SEL and IO\n");
 
 			if (!hostdata->connected) {
 				NCR5380_reselect(instance);
@@ -1031,7 +1029,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			/* Probably Bus Reset */
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-			dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt\n", instance->host_no);
+			dsprintk(NDEBUG_INTR, instance, "unknown interrupt\n");
 		}
 		handled = 1;
 	} else {
@@ -1086,7 +1084,8 @@ static struct scsi_cmnd *NCR5380_select(
 	int err;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
+	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
+	         instance->this_id);
 
 	/*
 	 * Arbitration and selection phases are slow and involve dropping the
@@ -1138,7 +1137,7 @@ static struct scsi_cmnd *NCR5380_select(
 	/* Check for lost arbitration */
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
+		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
 		spin_lock_irq(&hostdata->lock);
 		goto out;
 	}
@@ -1172,7 +1171,7 @@ static struct scsi_cmnd *NCR5380_select(
 		goto out;
 	}
 
-	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
+	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
 
 	/* 
 	 * Now that we have won arbitration, start Selection process, asserting 
@@ -1226,7 +1225,7 @@ static struct scsi_cmnd *NCR5380_select(
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, "scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd));
+	dsprintk(NDEBUG_SELECTION, instance, "selecting target %d\n", scmd_id(cmd));
 
 	/* 
 	 * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1300,7 +1299,8 @@ static struct scsi_cmnd *NCR5380_select(
 		goto out;
 	}
 
-	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
+	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
+	         scmd_id(cmd));
 	tmp[0] = IDENTIFY(((instance->irq == NO_IRQ) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
@@ -1310,7 +1310,7 @@ static struct scsi_cmnd *NCR5380_select(
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
+	dsprintk(NDEBUG_SELECTION, instance, "nexus established.\n");
 	/* XXX need to handle errors here */
 
 	hostdata->connected = cmd;
@@ -1357,11 +1357,6 @@ static int NCR5380_transfer_pio(struct S
 	int c = *count;
 	unsigned char *d = *data;
 
-	if (!(p & SR_IO))
-		dprintk(NDEBUG_PIO, "scsi%d : pio write %d bytes\n", instance->host_no, c);
-	else
-		dprintk(NDEBUG_PIO, "scsi%d : pio read %d bytes\n", instance->host_no, c);
-
 	/* 
 	 * The NCR5380 chip will only drive the SCSI bus when the 
 	 * phase specified in the appropriate bits of the TARGET COMMAND
@@ -1379,12 +1374,12 @@ static int NCR5380_transfer_pio(struct S
 		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
 			break;
 
-		dprintk(NDEBUG_HANDSHAKE, "scsi%d : REQ detected\n", instance->host_no);
+		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
 
 		/* Check for phase mismatch */
 		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) != p) {
-			dprintk(NDEBUG_HANDSHAKE, "scsi%d : phase mismatch\n", instance->host_no);
-			NCR5380_dprint_phase(NDEBUG_HANDSHAKE, instance);
+			dsprintk(NDEBUG_PIO, instance, "phase mismatch\n");
+			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
 		/* Do actual transfer from SCSI bus to / from memory */
@@ -1421,7 +1416,7 @@ static int NCR5380_transfer_pio(struct S
 		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
 			break;
 
-		dprintk(NDEBUG_HANDSHAKE, "scsi%d : req false, handshake complete\n", instance->host_no);
+		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
 
 /*
  * We have several special cases to consider during REQ/ACK handshaking : 
@@ -1442,7 +1437,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	dprintk(NDEBUG_PIO, "scsi%d : residual %d\n", instance->host_no, c);
+	dsprintk(NDEBUG_PIO, instance, "residual %d\n", c);
 
 	*count = c;
 	*data = d;
@@ -1592,8 +1587,10 @@ static int NCR5380_transfer_dma(struct S
 		if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS))
 			c -= 2;
 	}
-	dprintk(NDEBUG_DMA, "scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d);
 	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
+
+	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
+	         (p & SR_IO) ? "receive" : "send", c, *data);
 #endif
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
@@ -1695,7 +1692,8 @@ static int NCR5380_transfer_dma(struct S
 		}
 	}
 
-	dprintk(NDEBUG_DMA, "scsi%d : polled DMA transfer complete, basr 0x%X, sr 0x%X\n", instance->host_no, tmp, NCR5380_read(STATUS_REG));
+	dsprintk(NDEBUG_DMA, "polled DMA transfer complete, basr 0x%02x, sr 0x%02x\n",
+	         tmp, NCR5380_read(STATUS_REG));
 
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1865,7 +1863,9 @@ static void NCR5380_information_transfer
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
 					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-					dprintk(NDEBUG_INFORMATION, "scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual);
+					dsprintk(NDEBUG_INFORMATION, instance, "%d bytes and %d buffers left\n",
+					         cmd->SCp.this_residual,
+					         cmd->SCp.buffers_residual);
 				}
 				/*
 				 * The preferred transfer method is going to be 
@@ -2020,14 +2020,15 @@ static void NCR5380_information_transfer
 
 					spin_unlock_irq(&hostdata->lock);
 
-					dprintk(NDEBUG_EXTENDED, "scsi%d : receiving extended message\n", instance->host_no);
+					dsprintk(NDEBUG_EXTENDED, instance, "receiving extended message\n");
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
-
-					dprintk(NDEBUG_EXTENDED, "scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]);
+					dsprintk(NDEBUG_EXTENDED, instance, "length %d, code 0x%02x\n",
+					         (int)extended_msg[1],
+					         (int)extended_msg[2]);
 
 					if (!len && extended_msg[1] > 0 &&
 					    extended_msg[1] <= sizeof(extended_msg) - 2) {
@@ -2038,7 +2039,8 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						dprintk(NDEBUG_EXTENDED, "scsi%d : message received, residual %d\n", instance->host_no, len);
+						dsprintk(NDEBUG_EXTENDED, instance, "message received, residual %d\n",
+						         len);
 
 						switch (extended_msg[2]) {
 						case EXTENDED_SDTR:
@@ -2155,7 +2157,8 @@ static void NCR5380_reselect(struct Scsi
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
-	dprintk(NDEBUG_RESELECTION, "scsi%d : reselect\n", instance->host_no);
+
+	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
 
 	/* 
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2244,8 +2247,8 @@ static void NCR5380_reselect(struct Scsi
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	hostdata->connected = tmp;
-	dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n",
-	        instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
+	dsprintk(NDEBUG_RESELECTION, instance, "nexus established, target %d, lun %llu, tag %d\n",
+	         scmd_id(tmp), tmp->device->lun, tmp->tag);
 }
 
 /*
