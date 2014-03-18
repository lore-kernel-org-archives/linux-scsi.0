From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 08/12] scsi/NCR5380: adopt dprintk()
Date: Tue, 18 Mar 2014 11:42:20 +1100
Message-ID: <20140318004214.992467108@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-debug-macros-substitute-X_PRINTK
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

All NCR5380 drivers already include the NCR5380.h header. Better to
adopt those macros rather than have three variations on them.

Moreover, the macros in NCR5380.h are preferable because the atari_NCR5380
and sun3_NCR5380 versions are inflexible. For example, they can't accomodate
dprintk(NDEBUG_MAIN | NDEBUG_QUEUES, ...)

Replace the *_PRINTK macros from atari_NCR5380.h and sun3_NCR5380.h with
the equivalent macros from NCR5380.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |  130 +++++++++++++++++++++----------------------
 drivers/scsi/atari_scsi.c    |   16 ++---
 drivers/scsi/sun3_NCR5380.c  |  122 ++++++++++++++++++++--------------------
 3 files changed, 134 insertions(+), 134 deletions(-)

Index: linux-m68k/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -370,7 +370,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, i
 		return 0;
 	if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
 	    TagAlloc[cmd->device->id][cmd->device->lun].queue_size) {
-		TAG_PRINTK("scsi%d: target %d lun %d: no free tags\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
 			   H_NO(cmd), cmd->device->id, cmd->device->lun);
 		return 1;
 	}
@@ -394,7 +394,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd,
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
 		hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
-		TAG_PRINTK("scsi%d: target %d lun %d now allocated by untagged "
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
 			   "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun);
 	} else {
 		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
@@ -402,7 +402,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd,
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated++;
-		TAG_PRINTK("scsi%d: using tag %d for target %d lun %d "
+		dprintk(NDEBUG_TAGS, "scsi%d: using tag %d for target %d lun %d "
 			   "(now %d tags in use)\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id,
 			   cmd->device->lun, ta->nr_allocated);
@@ -420,7 +420,7 @@ static void cmd_free_tag(Scsi_Cmnd *cmd)
 
 	if (cmd->tag == TAG_NONE) {
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-		TAG_PRINTK("scsi%d: target %d lun %d untagged cmd finished\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d untagged cmd finished\n",
 			   H_NO(cmd), cmd->device->id, cmd->device->lun);
 	} else if (cmd->tag >= MAX_TAGS) {
 		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
@@ -429,7 +429,7 @@ static void cmd_free_tag(Scsi_Cmnd *cmd)
 		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
-		TAG_PRINTK("scsi%d: freed tag %d for target %d lun %d\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun);
 	}
 }
@@ -478,7 +478,7 @@ static void merge_contiguous_buffers(Scs
 	for (endaddr = virt_to_phys(cmd->SCp.ptr + cmd->SCp.this_residual - 1) + 1;
 	     cmd->SCp.buffers_residual &&
 	     virt_to_phys(sg_virt(&cmd->SCp.buffer[1])) == endaddr;) {
-		MER_PRINTK("VTOP(%p) == %08lx -> merging\n",
+		dprintk(NDEBUG_MERGING, "VTOP(%p) == %08lx -> merging\n",
 			   page_address(sg_page(&cmd->SCp.buffer[1])), endaddr);
 #if (NDEBUG & NDEBUG_MERGING)
 		++cnt;
@@ -490,7 +490,7 @@ static void merge_contiguous_buffers(Scs
 	}
 #if (NDEBUG & NDEBUG_MERGING)
 	if (oldlen != cmd->SCp.this_residual)
-		MER_PRINTK("merged %d buffers from %p, new length %08x\n",
+		dprintk(NDEBUG_MERGING, "merged %d buffers from %p, new length %08x\n",
 			   cnt, cmd->SCp.ptr, cmd->SCp.this_residual);
 #endif
 }
@@ -676,7 +676,7 @@ static inline void NCR5380_all_init(void
 {
 	static int done = 0;
 	if (!done) {
-		INI_PRINTK("scsi : NCR5380_all_init()\n");
+		dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
 		done = 1;
 	}
 }
@@ -984,7 +984,7 @@ static int NCR5380_queue_command_lck(Scs
 	}
 	local_irq_restore(flags);
 
-	QU_PRINTK("scsi%d: command added to %s of queue\n", H_NO(cmd),
+	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* If queue_command() is called from an interrupt (real one or bottom
@@ -1054,7 +1054,7 @@ static void NCR5380_main(struct work_str
 		done = 1;
 
 		if (!hostdata->connected) {
-			MAIN_PRINTK("scsi%d: not connected\n", HOSTNO);
+			dprintk(NDEBUG_MAIN, "scsi%d: not connected\n", HOSTNO);
 			/*
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
@@ -1107,7 +1107,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying.
 					 */
-					MAIN_PRINTK("scsi%d: main(): command for target %d "
+					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
 						    "lun %d removed from issue_queue\n",
 						    HOSTNO, tmp->device->id, tmp->device->lun);
 					/*
@@ -1140,7 +1140,7 @@ static void NCR5380_main(struct work_str
 #endif
 						falcon_dont_release--;
 						local_irq_restore(flags);
-						MAIN_PRINTK("scsi%d: main(): select() failed, "
+						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
 						if (hostdata->connected)
 							break;
@@ -1155,10 +1155,10 @@ static void NCR5380_main(struct work_str
 #endif
 		    ) {
 			local_irq_restore(flags);
-			MAIN_PRINTK("scsi%d: main: performing information transfer\n",
+			dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 				    HOSTNO);
 			NCR5380_information_transfer(instance);
-			MAIN_PRINTK("scsi%d: main: done set false\n", HOSTNO);
+			dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
 			done = 0;
 		}
 	} while (!done);
@@ -1204,12 +1204,12 @@ static void NCR5380_dma_complete(struct
 			    (BASR_PHASE_MATCH|BASR_ACK)) {
 				saved_data = NCR5380_read(INPUT_DATA_REG);
 				overrun = 1;
-				DMA_PRINTK("scsi%d: read overrun handled\n", HOSTNO);
+				dprintk(NDEBUG_DMA, "scsi%d: read overrun handled\n", HOSTNO);
 			}
 		}
 	}
 
-	DMA_PRINTK("scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
+	dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
 		   HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
 		   NCR5380_read(STATUS_REG));
 
@@ -1229,13 +1229,13 @@ static void NCR5380_dma_complete(struct
 		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) == p && (p & SR_IO)) {
 			cnt = toPIO = atari_read_overruns;
 			if (overrun) {
-				DMA_PRINTK("Got an input overrun, using saved byte\n");
+				dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 				*(*data)++ = saved_data;
 				(*count)--;
 				cnt--;
 				toPIO--;
 			}
-			DMA_PRINTK("Doing %d-byte PIO to 0x%08lx\n", cnt, (long)*data);
+			dprintk(NDEBUG_DMA, "Doing %d-byte PIO to 0x%08lx\n", cnt, (long)*data);
 			NCR5380_transfer_pio(instance, &p, &cnt, data);
 			*count -= toPIO - cnt;
 		}
@@ -1261,25 +1261,25 @@ static irqreturn_t NCR5380_intr(int irq,
 	int done = 1, handled = 0;
 	unsigned char basr;
 
-	INT_PRINTK("scsi%d: NCR5380 irq triggered\n", HOSTNO);
+	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
 
 	/* Look for pending interrupts */
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
-	INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
+	dprintk(NDEBUG_INTR, "scsi%d: BASR=%02x\n", HOSTNO, basr);
 	/* dispatch to appropriate routine if found and done=0 */
 	if (basr & BASR_IRQ) {
 		NCR5380_dprint(NDEBUG_INTR, instance);
 		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 			done = 0;
 			ENABLE_IRQ();
-			INT_PRINTK("scsi%d: SEL interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 			NCR5380_reselect(instance);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else if (basr & BASR_PARITY_ERROR) {
-			INT_PRINTK("scsi%d: PARITY interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-			INT_PRINTK("scsi%d: RESET interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else {
 			/*
@@ -1298,7 +1298,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			    ((basr & BASR_END_DMA_TRANSFER) ||
 			     !(basr & BASR_PHASE_MATCH))) {
 
-				INT_PRINTK("scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
+				dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 				NCR5380_dma_complete( instance );
 				done = 0;
 				ENABLE_IRQ();
@@ -1323,7 +1323,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	}
 
 	if (!done) {
-		INT_PRINTK("scsi%d: in int routine, calling main\n", HOSTNO);
+		dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
 		/* Put a call to NCR5380_main() on the queue... */
 		queue_main();
 	}
@@ -1397,7 +1397,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	hostdata->restart_select = 0;
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
 		   instance->this_id);
 
 	/*
@@ -1442,7 +1442,7 @@ static int NCR5380_select(struct Scsi_Ho
 		;
 #endif
 
-	ARB_PRINTK("scsi%d: arbitration complete\n", HOSTNO);
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
 
 	if (hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1463,7 +1463,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
 	    hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		ARB_PRINTK("scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
+		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 			   HOSTNO);
 		return -1;
 	}
@@ -1478,7 +1478,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		ARB_PRINTK("scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
+		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
 			   HOSTNO);
 		return -1;
 	}
@@ -1501,7 +1501,7 @@ static int NCR5380_select(struct Scsi_Ho
 		return -1;
 	}
 
-	ARB_PRINTK("scsi%d: won arbitration\n", HOSTNO);
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
 	/*
 	 * Now that we have won arbitration, start Selection process, asserting
@@ -1561,7 +1561,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	SEL_PRINTK("scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
+	dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
 
 	/*
 	 * The SCSI specification calls for a 250 ms timeout for the actual
@@ -1630,7 +1630,7 @@ static int NCR5380_select(struct Scsi_Ho
 #endif
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		SEL_PRINTK("scsi%d: target did not respond within 250ms\n", HOSTNO);
+		dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
@@ -1656,7 +1656,7 @@ static int NCR5380_select(struct Scsi_Ho
 	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
 		;
 
-	SEL_PRINTK("scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
+	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 		   HOSTNO, cmd->device->id);
 	tmp[0] = IDENTIFY(1, cmd->device->lun);
 
@@ -1676,7 +1676,7 @@ static int NCR5380_select(struct Scsi_Ho
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	SEL_PRINTK("scsi%d: nexus established.\n", HOSTNO);
+	dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
@@ -1737,11 +1737,11 @@ static int NCR5380_transfer_pio(struct S
 		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
 			;
 
-		HSH_PRINTK("scsi%d: REQ detected\n", HOSTNO);
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
 
 		/* Check for phase mismatch */
 		if ((tmp & PHASE_MASK) != p) {
-			PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
+			dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
@@ -1782,7 +1782,7 @@ static int NCR5380_transfer_pio(struct S
 		while (NCR5380_read(STATUS_REG) & SR_REQ)
 			;
 
-		HSH_PRINTK("scsi%d: req false, handshake complete\n", HOSTNO);
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
 		/*
 		 * We have several special cases to consider during REQ/ACK handshaking :
@@ -1803,7 +1803,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	PIO_PRINTK("scsi%d: residual %d\n", HOSTNO, c);
+	dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
 
 	*count = c;
 	*data = d;
@@ -1917,7 +1917,7 @@ static int NCR5380_transfer_dma(struct S
 	if (atari_read_overruns && (p & SR_IO))
 		c -= atari_read_overruns;
 
-	DMA_PRINTK("scsi%d: initializing DMA for %s, %d bytes %s %p\n",
+	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
 		   HOSTNO, (p & SR_IO) ? "reading" : "writing",
 		   c, (p & SR_IO) ? "to" : "from", d);
 
@@ -2039,7 +2039,7 @@ static void NCR5380_information_transfer
 					 * they are at contiguous physical addresses.
 					 */
 					merge_contiguous_buffers(cmd);
-					INF_PRINTK("scsi%d: %d bytes and %d buffers left\n",
+					dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers left\n",
 						   HOSTNO, cmd->SCp.this_residual,
 						   cmd->SCp.buffers_residual);
 				}
@@ -2123,7 +2123,7 @@ static void NCR5380_information_transfer
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-					LNK_PRINTK("scsi%d: target %d lun %d linked command "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
 						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 					/* Enable reselect interrupts */
@@ -2148,7 +2148,7 @@ static void NCR5380_information_transfer
 					 * and don't free it! */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					LNK_PRINTK("scsi%d: target %d lun %d linked request "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 						   "done, calling scsi_done().\n",
 						   HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2165,7 +2165,7 @@ static void NCR5380_information_transfer
 					/* ++guenther: possible race with Falcon locking */
 					falcon_dont_release++;
 					hostdata->connected = NULL;
-					QU_PRINTK("scsi%d: command for target %d, lun %d "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2179,7 +2179,7 @@ static void NCR5380_information_transfer
 						/* ++Andreas: the mid level code knows about
 						   QUEUE_FULL now. */
 						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-						TAG_PRINTK("scsi%d: target %d lun %d returned "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 							   "QUEUE_FULL after %d commands\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun,
 							   ta->nr_allocated);
@@ -2224,14 +2224,14 @@ static void NCR5380_information_transfer
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						ASEN_PRINTK("scsi%d: performing request sense\n", HOSTNO);
+						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n", HOSTNO);
 
 						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
 						local_irq_restore(flags);
-						QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
+						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
 					} else
 #endif /* def AUTOSENSE */
@@ -2277,7 +2277,7 @@ static void NCR5380_information_transfer
 						cmd->device->tagged_supported = 0;
 						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 						cmd->tag = TAG_NONE;
-						TAG_PRINTK("scsi%d: target %d lun %d rejected "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 							   "QUEUE_TAG message; tagged queuing "
 							   "disabled\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2294,7 +2294,7 @@ static void NCR5380_information_transfer
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
 					local_irq_restore(flags);
-					QU_PRINTK("scsi%d: command for target %d lun %d was "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 						  "moved from connected to the "
 						  "disconnected_queue\n", HOSTNO,
 						  cmd->device->id, cmd->device->lun);
@@ -2344,13 +2344,13 @@ static void NCR5380_information_transfer
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-					EXT_PRINTK("scsi%d: receiving extended message\n", HOSTNO);
+					dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
-					EXT_PRINTK("scsi%d: length=%d, code=0x%02x\n", HOSTNO,
+					dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 						   (int)extended_msg[1], (int)extended_msg[2]);
 
 					if (!len && extended_msg[1] <=
@@ -2362,7 +2362,7 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						EXT_PRINTK("scsi%d: message received, residual %d\n",
+						dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
 							   HOSTNO, len);
 
 						switch (extended_msg[2]) {
@@ -2493,7 +2493,7 @@ static void NCR5380_reselect(struct Scsi
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
-	RSL_PRINTK("scsi%d: reselect\n", HOSTNO);
+	dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
 
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2544,7 +2544,7 @@ static void NCR5380_reselect(struct Scsi
 		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 		    msg[1] == SIMPLE_QUEUE_TAG)
 			tag = msg[2];
-		TAG_PRINTK("scsi%d: target mask %02x, lun %d sent tag %d at "
+		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at "
 			   "reselection\n", HOSTNO, target_mask, lun, tag);
 	}
 #endif
@@ -2598,7 +2598,7 @@ static void NCR5380_reselect(struct Scsi
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	hostdata->connected = tmp;
-	RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
 		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 	falcon_dont_release--;
 }
@@ -2640,7 +2640,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 		printk(KERN_ERR "scsi%d: !!BINGO!! Falcon has no lock in NCR5380_abort\n",
 		       HOSTNO);
 
-	ABRT_PRINTK("scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
+	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
 		    NCR5380_read(STATUS_REG));
 
@@ -2653,7 +2653,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 
 	if (hostdata->connected == cmd) {
 
-		ABRT_PRINTK("scsi%d: aborting connected command\n", HOSTNO);
+		dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO);
 		/*
 		 * We should perform BSY checking, and make sure we haven't slipped
 		 * into BUS FREE.
@@ -2705,7 +2705,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
 			local_irq_restore(flags);
-			ABRT_PRINTK("scsi%d: abort removed command from issue queue.\n",
+			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 				    HOSTNO);
 			/* Tagged queuing note: no tag to free here, hasn't been assigned
 			 * yet... */
@@ -2728,7 +2728,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 
 	if (hostdata->connected) {
 		local_irq_restore(flags);
-		ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
+		dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
 		return SCSI_ABORT_SNOOZE;
 	}
 
@@ -2761,12 +2761,12 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	     tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
 			local_irq_restore(flags);
-			ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
+			dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
 
 			if (NCR5380_select(instance, cmd, (int)cmd->tag))
 				return SCSI_ABORT_BUSY;
 
-			ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
+			dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
 
 			do_abort(instance);
 
@@ -2890,7 +2890,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 	 */
 
 	if ((cmd = connected)) {
-		ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 		cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
 		cmd->scsi_done(cmd);
 	}
@@ -2902,7 +2902,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 		cmd->scsi_done(cmd);
 	}
 	if (i > 0)
-		ABRT_PRINTK("scsi: reset aborted %d disconnected command(s)\n", i);
+		dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)\n", i);
 
 	/* The Falcon lock should be released after a reset...
 	 */
@@ -2942,11 +2942,11 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 	 */
 
 	if (hostdata->issue_queue)
-		ABRT_PRINTK("scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
 	if (hostdata->connected)
-		ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 	if (hostdata->disconnected_queue)
-		ABRT_PRINTK("scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
 
 	local_irq_save(flags);
 	hostdata->issue_queue = NULL;
Index: linux-m68k/drivers/scsi/atari_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_scsi.c	2014-03-17 23:49:24.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_scsi.c	2014-03-18 00:18:36.000000000 +1100
@@ -313,7 +313,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 	dma_stat = tt_scsi_dma.dma_ctrl;
 
-	INT_PRINTK("scsi%d: NCR5380 interrupt, DMA status = %02x\n",
+	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 interrupt, DMA status = %02x\n",
 		   atari_scsi_host->host_no, dma_stat & 0xff);
 
 	/* Look if it was the DMA that has interrupted: First possibility
@@ -339,7 +339,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 	if ((dma_stat & 0x02) && !(dma_stat & 0x40)) {
 		atari_dma_residual = HOSTDATA_DMALEN - (SCSI_DMA_READ_P(dma_addr) - atari_dma_startaddr);
 
-		DMA_PRINTK("SCSI DMA: There are %ld residual bytes.\n",
+		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
 
 		if ((signed int)atari_dma_residual < 0)
@@ -370,7 +370,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 			 * other command.  These shouldn't disconnect anyway.
 			 */
 			if (atari_dma_residual & 0x1ff) {
-				DMA_PRINTK("SCSI DMA: DMA bug corrected, "
+				dprintk(NDEBUG_DMA, "SCSI DMA: DMA bug corrected, "
 					   "difference %ld bytes\n",
 					   512 - (atari_dma_residual & 0x1ff));
 				atari_dma_residual = (atari_dma_residual + 511) & ~0x1ff;
@@ -437,7 +437,7 @@ static irqreturn_t scsi_falcon_intr(int
 			       "ST-DMA fifo\n", transferred & 15);
 
 		atari_dma_residual = HOSTDATA_DMALEN - transferred;
-		DMA_PRINTK("SCSI DMA: There are %ld residual bytes.\n",
+		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
 	} else
 		atari_dma_residual = 0;
@@ -473,11 +473,11 @@ static void atari_scsi_fetch_restbytes(v
 		/* there are 'nr' bytes left for the last long address
 		   before the DMA pointer */
 		phys_dst ^= nr;
-		DMA_PRINTK("SCSI DMA: there are %d rest bytes for phys addr 0x%08lx",
+		dprintk(NDEBUG_DMA, "SCSI DMA: there are %d rest bytes for phys addr 0x%08lx",
 			   nr, phys_dst);
 		/* The content of the DMA pointer is a physical address!  */
 		dst = phys_to_virt(phys_dst);
-		DMA_PRINTK(" = virt addr %p\n", dst);
+		dprintk(NDEBUG_DMA, " = virt addr %p\n", dst);
 		for (src = (char *)&tt_scsi_dma.dma_restdata; nr != 0; --nr)
 			*dst++ = *src++;
 	}
@@ -877,7 +877,7 @@ static unsigned long atari_scsi_dma_setu
 {
 	unsigned long addr = virt_to_phys(data);
 
-	DMA_PRINTK("scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, "
+	dprintk(NDEBUG_DMA, "scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, "
 		   "dir = %d\n", instance->host_no, data, addr, count, dir);
 
 	if (!IS_A_TT() && !STRAM_ADDR(addr)) {
@@ -1057,7 +1057,7 @@ static unsigned long atari_dma_xfer_len(
 		possible_len = limit;
 
 	if (possible_len != wanted_len)
-		DMA_PRINTK("Sorry, must cut DMA transfer size to %ld bytes "
+		dprintk(NDEBUG_DMA, "Sorry, must cut DMA transfer size to %ld bytes "
 			   "instead of %ld\n", possible_len, wanted_len);
 
 	return possible_len;
Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -364,7 +364,7 @@ static int is_lun_busy(struct scsi_cmnd
 	return( 0 );
     if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
 	TagAlloc[cmd->device->id][cmd->device->lun].queue_size ) {
-	TAG_PRINTK( "scsi%d: target %d lun %d: no free tags\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d: no free tags\n",
 		    H_NO(cmd), cmd->device->id, cmd->device->lun );
 	return( 1 );
     }
@@ -388,7 +388,7 @@ static void cmd_get_tag(struct scsi_cmnd
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 	cmd->tag = TAG_NONE;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
-	TAG_PRINTK( "scsi%d: target %d lun %d now allocated by untagged "
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d now allocated by untagged "
 		    "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun );
     }
     else {
@@ -397,7 +397,7 @@ static void cmd_get_tag(struct scsi_cmnd
 	cmd->tag = find_first_zero_bit( &ta->allocated, MAX_TAGS );
 	set_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated++;
-	TAG_PRINTK( "scsi%d: using tag %d for target %d lun %d "
+	dprintk(NDEBUG_TAGS,  "scsi%d: using tag %d for target %d lun %d "
 		    "(now %d tags in use)\n",
 		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun,
 		    ta->nr_allocated );
@@ -415,7 +415,7 @@ static void cmd_free_tag(struct scsi_cmn
 
     if (cmd->tag == TAG_NONE) {
 	hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-	TAG_PRINTK( "scsi%d: target %d lun %d untagged cmd finished\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d untagged cmd finished\n",
 		    H_NO(cmd), cmd->device->id, cmd->device->lun );
     }
     else if (cmd->tag >= MAX_TAGS) {
@@ -426,7 +426,7 @@ static void cmd_free_tag(struct scsi_cmn
 	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
 	clear_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated--;
-	TAG_PRINTK( "scsi%d: freed tag %d for target %d lun %d\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: freed tag %d for target %d lun %d\n",
 		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun );
     }
 }
@@ -618,7 +618,7 @@ static inline void NCR5380_all_init (voi
 {
     static int done = 0;
     if (!done) {
-	INI_PRINTK("scsi : NCR5380_all_init()\n");
+	dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
 	done = 1;
     }
 }
@@ -928,7 +928,7 @@ static int NCR5380_queue_command_lck(str
 
     local_irq_restore(flags);
 
-    QU_PRINTK("scsi%d: command added to %s of queue\n", H_NO(cmd),
+    dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 	      (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
     /* If queue_command() is called from an interrupt (real one or bottom
@@ -998,7 +998,7 @@ static void NCR5380_main (struct work_st
 	done = 1;
 	
 	if (!hostdata->connected) {
-	    MAIN_PRINTK( "scsi%d: not connected\n", HOSTNO );
+	    dprintk(NDEBUG_MAIN,  "scsi%d: not connected\n", HOSTNO );
 	    /*
 	     * Search through the issue_queue for a command destined
 	     * for a target that's not busy.
@@ -1047,7 +1047,7 @@ static void NCR5380_main (struct work_st
 		     * On failure, we must add the command back to the
 		     *   issue queue so we can keep trying.	
 		     */
-		    MAIN_PRINTK("scsi%d: main(): command for target %d "
+		    dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
 				"lun %d removed from issue_queue\n",
 				HOSTNO, tmp->device->id, tmp->device->lun);
 		    /* 
@@ -1076,7 +1076,7 @@ static void NCR5380_main (struct work_st
 			cmd_free_tag( tmp );
 #endif
 			local_irq_restore(flags);
-			MAIN_PRINTK("scsi%d: main(): select() failed, "
+			dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 				    "returned to issue_queue\n", HOSTNO);
 			if (hostdata->connected)
 			    break;
@@ -1090,10 +1090,10 @@ static void NCR5380_main (struct work_st
 #endif
 	    ) {
 	    local_irq_restore(flags);
-	    MAIN_PRINTK("scsi%d: main: performing information transfer\n",
+	    dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 			HOSTNO);
 	    NCR5380_information_transfer(instance);
-	    MAIN_PRINTK("scsi%d: main: done set false\n", HOSTNO);
+	    dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
 	    done = 0;
 	}
     } while (!done);
@@ -1130,7 +1130,7 @@ static void NCR5380_dma_complete( struct
 	return;
     }
 
-    DMA_PRINTK("scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
+    dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
 	       HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
 	       NCR5380_read(STATUS_REG));
 
@@ -1189,27 +1189,27 @@ static irqreturn_t NCR5380_intr (int irq
     int done = 1, handled = 0;
     unsigned char basr;
 
-    INT_PRINTK("scsi%d: NCR5380 irq triggered\n", HOSTNO);
+    dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
 
     /* Look for pending interrupts */
     basr = NCR5380_read(BUS_AND_STATUS_REG);
-    INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
+    dprintk(NDEBUG_INTR, "scsi%d: BASR=%02x\n", HOSTNO, basr);
     /* dispatch to appropriate routine if found and done=0 */
     if (basr & BASR_IRQ) {
 	NCR5380_dprint(NDEBUG_INTR, instance);
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 	    done = 0;
 //	    ENABLE_IRQ();
-	    INT_PRINTK("scsi%d: SEL interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 	    NCR5380_reselect(instance);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else if (basr & BASR_PARITY_ERROR) {
-	    INT_PRINTK("scsi%d: PARITY interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-	    INT_PRINTK("scsi%d: RESET interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
 	    (void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else {
@@ -1229,7 +1229,7 @@ static irqreturn_t NCR5380_intr (int irq
 		((basr & BASR_END_DMA_TRANSFER) || 
 		 !(basr & BASR_PHASE_MATCH))) {
 		    
-		INT_PRINTK("scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
+		dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 		NCR5380_dma_complete( instance );
 		done = 0;
 //		ENABLE_IRQ();
@@ -1238,7 +1238,7 @@ static irqreturn_t NCR5380_intr (int irq
 	    {
 /* MS: Ignore unknown phase mismatch interrupts (caused by EOP interrupt) */
 		if (basr & BASR_PHASE_MATCH)
-		   INT_PRINTK("scsi%d: unknown interrupt, "
+		   dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
 			   "BASR 0x%x, MR 0x%x, SR 0x%x\n",
 			   HOSTNO, basr, NCR5380_read(MODE_REG),
 			   NCR5380_read(STATUS_REG));
@@ -1262,7 +1262,7 @@ static irqreturn_t NCR5380_intr (int irq
     }
     
     if (!done) {
-	INT_PRINTK("scsi%d: in int routine, calling main\n", HOSTNO);
+	dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
 	/* Put a call to NCR5380_main() on the queue... */
 	queue_main();
     }
@@ -1339,7 +1339,7 @@ static int NCR5380_select(struct Scsi_Ho
 
     hostdata->restart_select = 0;
     NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-    ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
 	       instance->this_id);
 
     /* 
@@ -1385,7 +1385,7 @@ static int NCR5380_select(struct Scsi_Ho
 	 && !hostdata->connected);
 #endif
 
-    ARB_PRINTK("scsi%d: arbitration complete\n", HOSTNO);
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
 
     if (hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE); 
@@ -1406,7 +1406,7 @@ static int NCR5380_select(struct Scsi_Ho
 	(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
 	hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE); 
-	ARB_PRINTK("scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 		   HOSTNO);
 	return -1;
     }
@@ -1421,7 +1421,7 @@ static int NCR5380_select(struct Scsi_Ho
 	hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	ARB_PRINTK("scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
 		   HOSTNO);
 	return -1;
     }
@@ -1444,7 +1444,7 @@ static int NCR5380_select(struct Scsi_Ho
 	return -1;
     }
 
-    ARB_PRINTK("scsi%d: won arbitration\n", HOSTNO);
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
     /* 
      * Now that we have won arbitration, start Selection process, asserting 
@@ -1504,7 +1504,7 @@ static int NCR5380_select(struct Scsi_Ho
 
     udelay(1);
 
-    SEL_PRINTK("scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
+    dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
 
     /* 
      * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1572,7 +1572,7 @@ static int NCR5380_select(struct Scsi_Ho
 #endif
 	cmd->scsi_done(cmd);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	SEL_PRINTK("scsi%d: target did not respond within 250ms\n", HOSTNO);
+	dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 	return 0;
     } 
@@ -1597,7 +1597,7 @@ static int NCR5380_select(struct Scsi_Ho
     /* Wait for start of REQ/ACK handshake */
     while (!(NCR5380_read(STATUS_REG) & SR_REQ));
 
-    SEL_PRINTK("scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
+    dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 	       HOSTNO, cmd->device->id);
     tmp[0] = IDENTIFY(1, cmd->device->lun);
 
@@ -1617,7 +1617,7 @@ static int NCR5380_select(struct Scsi_Ho
     data = tmp;
     phase = PHASE_MSGOUT;
     NCR5380_transfer_pio(instance, &phase, &len, &data);
-    SEL_PRINTK("scsi%d: nexus established.\n", HOSTNO);
+    dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
     /* XXX need to handle errors here */
     hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
@@ -1680,11 +1680,11 @@ static int NCR5380_transfer_pio( struct
 	 */
 	while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ));
 
-	HSH_PRINTK("scsi%d: REQ detected\n", HOSTNO);
+	dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
 
 	/* Check for phase mismatch */	
 	if ((tmp & PHASE_MASK) != p) {
-	    PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
+	    dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
 	    NCR5380_dprint_phase(NDEBUG_PIO, instance);
 	    break;
 	}
@@ -1725,7 +1725,7 @@ static int NCR5380_transfer_pio( struct
 
 	while (NCR5380_read(STATUS_REG) & SR_REQ);
 
-	HSH_PRINTK("scsi%d: req false, handshake complete\n", HOSTNO);
+	dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
 /*
  * We have several special cases to consider during REQ/ACK handshaking : 
@@ -1746,7 +1746,7 @@ static int NCR5380_transfer_pio( struct
 	} 
     } while (--c);
 
-    PIO_PRINTK("scsi%d: residual %d\n", HOSTNO, c);
+    dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
 
     *count = c;
     *data = d;
@@ -1854,7 +1854,7 @@ static int NCR5380_transfer_dma( struct
     }
     hostdata->dma_len = c;
 
-    DMA_PRINTK("scsi%d: initializing DMA for %s, %d bytes %s %p\n",
+    dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
 	       HOSTNO, (p & SR_IO) ? "reading" : "writing",
 	       c, (p & SR_IO) ? "to" : "from", *data);
 
@@ -1996,7 +1996,7 @@ static void NCR5380_information_transfer
 		    --cmd->SCp.buffers_residual;
 		    cmd->SCp.this_residual = cmd->SCp.buffer->length;
 		    cmd->SCp.ptr = SGADDR(cmd->SCp.buffer);
-		    INF_PRINTK("scsi%d: %d bytes and %d buffers left\n",
+		    dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers left\n",
 			       HOSTNO, cmd->SCp.this_residual,
 			       cmd->SCp.buffers_residual);
 		}
@@ -2088,7 +2088,7 @@ static void NCR5380_information_transfer
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    
-		    LNK_PRINTK("scsi%d: target %d lun %d linked command "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
 			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 		    /* Enable reselect interrupts */
@@ -2113,7 +2113,7 @@ static void NCR5380_information_transfer
 		     * and don't free it! */
 		    cmd->next_link->tag = cmd->tag;
 		    cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
-		    LNK_PRINTK("scsi%d: target %d lun %d linked request "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 			       "done, calling scsi_done().\n",
 			       HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2128,7 +2128,7 @@ static void NCR5380_information_transfer
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    hostdata->connected = NULL;
-		    QU_PRINTK("scsi%d: command for target %d, lun %d "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
 			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
@@ -2142,7 +2142,7 @@ static void NCR5380_information_transfer
 			/* ++Andreas: the mid level code knows about
 			   QUEUE_FULL now. */
 			TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-			TAG_PRINTK("scsi%d: target %d lun %d returned "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 				   "QUEUE_FULL after %d commands\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun,
 				   ta->nr_allocated);
@@ -2186,7 +2186,7 @@ static void NCR5380_information_transfer
 		    if ((cmd->cmnd[0] != REQUEST_SENSE) && 
 			(status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
-			ASEN_PRINTK("scsi%d: performing request sense\n",
+			dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n",
 				    HOSTNO);
 			/* this is initialized from initialize_SCp 
 			cmd->SCp.buffer = NULL;
@@ -2198,7 +2198,7 @@ static void NCR5380_information_transfer
 			SET_NEXT(cmd, hostdata->issue_queue);
 		        hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 		        local_irq_restore(flags);
-			QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
+			dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 				  "issue queue\n", H_NO(cmd));
 		   } else
 #endif /* def AUTOSENSE */
@@ -2238,7 +2238,7 @@ static void NCR5380_information_transfer
 			cmd->device->tagged_supported = 0;
 			hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 			cmd->tag = TAG_NONE;
-			TAG_PRINTK("scsi%d: target %d lun %d rejected "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 				   "QUEUE_TAG message; tagged queuing "
 				   "disabled\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2255,7 +2255,7 @@ static void NCR5380_information_transfer
 		    hostdata->connected = NULL;
 		    hostdata->disconnected_queue = cmd;
 		    local_irq_restore(flags);
-		    QU_PRINTK("scsi%d: command for target %d lun %d was "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 			      "moved from connected to the "
 			      "disconnected_queue\n", HOSTNO, 
 			      cmd->device->id, cmd->device->lun);
@@ -2308,13 +2308,13 @@ static void NCR5380_information_transfer
 		    /* Accept first byte by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-		    EXT_PRINTK("scsi%d: receiving extended message\n", HOSTNO);
+		    dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 		    len = 2;
 		    data = extended_msg + 1;
 		    phase = PHASE_MSGIN;
 		    NCR5380_transfer_pio(instance, &phase, &len, &data);
-		    EXT_PRINTK("scsi%d: length=%d, code=0x%02x\n", HOSTNO,
+		    dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 			       (int)extended_msg[1], (int)extended_msg[2]);
 
 		    if (!len && extended_msg[1] <= 
@@ -2326,7 +2326,7 @@ static void NCR5380_information_transfer
 			phase = PHASE_MSGIN;
 
 			NCR5380_transfer_pio(instance, &phase, &len, &data);
-			EXT_PRINTK("scsi%d: message received, residual %d\n",
+			dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
 				   HOSTNO, len);
 
 			switch (extended_msg[2]) {
@@ -2458,7 +2458,7 @@ static void NCR5380_reselect (struct Scs
 
     target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
-    RSL_PRINTK("scsi%d: reselect\n", HOSTNO);
+    dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
 
     /* 
      * At this point, we have detected that our SCSI ID is on the bus,
@@ -2580,13 +2580,13 @@ static void NCR5380_reselect (struct Scs
 	if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 	    msg[1] == SIMPLE_QUEUE_TAG)
 	    tag = msg[2];
-	TAG_PRINTK("scsi%d: target mask %02x, lun %d sent tag %d at "
+	dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at "
 		   "reselection\n", HOSTNO, target_mask, lun, tag);
     }
 #endif
     
     hostdata->connected = tmp;
-    RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+    dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
 	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
@@ -2622,7 +2622,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     local_irq_save(flags);
     
-    ABRT_PRINTK("scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
+    dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		NCR5380_read(BUS_AND_STATUS_REG),
 		NCR5380_read(STATUS_REG));
 
@@ -2635,7 +2635,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     if (hostdata->connected == cmd) {
 
-	ABRT_PRINTK("scsi%d: aborting connected command\n", HOSTNO);
+	dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO);
 /*
  * We should perform BSY checking, and make sure we haven't slipped
  * into BUS FREE.
@@ -2686,7 +2686,7 @@ static int NCR5380_abort(struct scsi_cmn
 	    SET_NEXT(tmp, NULL);
 	    tmp->result = DID_ABORT << 16;
 	    local_irq_restore(flags);
-	    ABRT_PRINTK("scsi%d: abort removed command from issue queue.\n",
+	    dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 			HOSTNO);
 	    /* Tagged queuing note: no tag to free here, hasn't been assigned
 	     * yet... */
@@ -2707,7 +2707,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     if (hostdata->connected) {
 	local_irq_restore(flags);
-	ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
+	dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
         return SCSI_ABORT_SNOOZE;
     }
 
@@ -2740,12 +2740,12 @@ static int NCR5380_abort(struct scsi_cmn
 	 tmp = NEXT(tmp)) 
         if (cmd == tmp) {
             local_irq_restore(flags);
-	    ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
+	    dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
   
             if (NCR5380_select (instance, cmd, (int) cmd->tag)) 
 		return SCSI_ABORT_BUSY;
 
-	    ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
+	    dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
 
 	    do_abort (instance);
 
@@ -2857,7 +2857,7 @@ static int NCR5380_bus_reset(struct scsi
      */
 
     if ((cmd = connected)) {
-	ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 	cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
 	cmd->scsi_done( cmd );
     }
@@ -2869,7 +2869,7 @@ static int NCR5380_bus_reset(struct scsi
 	cmd->scsi_done( cmd );
     }
     if (i > 0)
-	ABRT_PRINTK("scsi: reset aborted %d disconnected command(s)\n", i);
+	dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)\n", i);
 
 
     /* since all commands have been explicitly terminated, we need to tell
@@ -2903,11 +2903,11 @@ static int NCR5380_bus_reset(struct scsi
      */
 
     if (hostdata->issue_queue)
-	ABRT_PRINTK("scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
     if (hostdata->connected) 
-	ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
     if (hostdata->disconnected_queue)
-	ABRT_PRINTK("scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
 
     local_irq_save(flags);
     hostdata->issue_queue = NULL;
