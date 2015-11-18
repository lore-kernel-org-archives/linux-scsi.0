From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 67/71] ncr5380: Cleanup comments
Date: Wed, 18 Nov 2015 19:36:02 +1100
Message-ID: <20151118083520.181154454@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-cleanup-comments
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The CVS revision log is not nearly as useful as the history/history.git
repo, so remove it. Roman's commentary at the top of his driver repeats
the same information elsewhere in the file so remove it. Also remove
some other redundant or obsolete comments.

Both the driver and the datasheets confusingly refer to a DMA access
for a SCSI WRITE command as a "DMA write". Similarly a SCSI READ command
is called a "DMA read". This is the opposite of the usual convention.
Thankfully, the chip documentation and driver code also use "DMA send" and
"DMA receive", so adopt this terminology.

This removes some unimportant discrepancies between the two core driver
forks so that 'diff' can be used to reveal the important ones, to
facilitate reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |  154 ++++++++++---------------------------------
 drivers/scsi/atari_NCR5380.c |   97 +++------------------------
 2 files changed, 48 insertions(+), 203 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:36.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:37.000000000 +1100
@@ -25,45 +25,8 @@
  */
 
 /*
- * Revision 1.10 1998/9/2	Alan Cox
- *				(alan@lxorguk.ukuu.org.uk)
- * Fixed up the timer lockups reported so far. Things still suck. Looking 
- * forward to 2.3 and per device request queues. Then it'll be possible to
- * SMP thread this beast and improve life no end.
- 
- * Revision 1.9  1997/7/27	Ronald van Cuijlenborg
- *				(ronald.van.cuijlenborg@tip.nl or nutty@dds.nl)
- * (hopefully) fixed and enhanced USLEEP
- * added support for DTC3181E card (for Mustek scanner)
- *
-
- * Revision 1.8			Ingmar Baumgart
- *				(ingmar@gonzo.schwaben.de)
- * added support for NCR53C400a card
- *
-
- * Revision 1.7  1996/3/2       Ray Van Tassle (rayvt@comm.mot.com)
- * added proc_info
- * added support needed for DTC 3180/3280
- * fixed a couple of bugs
- *
-
- * Revision 1.5  1994/01/19  09:14:57  drew
- * Fixed udelay() hack that was being used on DATAOUT phases
- * instead of a proper wait for the final handshake.
- *
- * Revision 1.4  1994/01/19  06:44:25  drew
- * *** empty log message ***
- *
- * Revision 1.3  1994/01/19  05:24:40  drew
- * Added support for TCR LAST_BYTE_SENT bit.
- *
- * Revision 1.2  1994/01/15  06:14:11  drew
- * REAL DMA support, bug fixes.
- *
- * Revision 1.1  1994/01/15  06:00:54  drew
- * Initial revision
- *
+ * With contributions from Ray Van Tassle, Ingmar Baumgart,
+ * Ronald van Cuijlenborg, Alan Cox and others.
  */
 
 /*
@@ -98,12 +61,6 @@
  * transfer - some PC's will use the I/O bus, 68K's must use 
  * memory mapped) and drops this file in their 'C' wrapper.
  *
- * (Note from hch:  unfortunately it was not enough for the different
- * m68k folks and instead of improving this driver they copied it
- * and hacked it up for their needs.  As a consequence they lost
- * most updates to this driver.  Maybe someone will fix all these
- * drivers to use a common core one day..)
- *
  * As far as command queueing, two queues are maintained for 
  * each 5380 in the system - commands that haven't been issued yet,
  * and commands that are currently executing.  This means that an 
@@ -180,9 +137,6 @@
  *      rely on phase mismatch and EOP interrupts to determine end 
  *      of phase.
  *
- * Defaults for these will be provided although the user may want to adjust 
- * these to allocate CPU resources to the SCSI driver or "real" code.
- * 
  * These macros MUST be defined :
  * 
  * NCR5380_read(register)  - read from the specified register
@@ -219,7 +173,7 @@
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
-/*
+/**
  *	initialize_SCp		-	init the scsi pointer field
  *	@cmd: command block to set up
  *
@@ -379,8 +333,6 @@ mrs[] = {
  *	@instance:	adapter state to dump
  *
  *	Print the SCSI bus signals for debugging purposes
- *
- *	Locks: caller holds hostdata lock (not essential)
  */
 
 static void NCR5380_print(struct Scsi_Host *instance)
@@ -413,13 +365,11 @@ static void NCR5380_print(struct Scsi_Ho
 }
 
 
-/* 
+/**
  *	NCR5380_print_phase	-	show SCSI phase
  *	@instance: adapter to dump
  *
  * 	Print the current SCSI phase for debugging purposes
- *
- *	Locks: none
  */
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
@@ -463,8 +413,6 @@ static irqreturn_t __init probe_intr(int
  *
  *	Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
  *	and then looking to see what interrupt actually turned up.
- *
- *	Locks: none, irqs must be enabled on entry
  */
 
 static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
@@ -514,8 +462,6 @@ static int __init __maybe_unused NCR5380
  *	@instance: relevant scsi host instance
  *
  *	For use as the host template info() handler.
- *
- *	Locks: none
  */
 
 static const char *NCR5380_info(struct Scsi_Host *instance)
@@ -566,20 +512,6 @@ static void prepare_info(struct Scsi_Hos
 }
 
 #ifdef PSEUDO_DMA
-/******************************************/
-/*
- * /proc/scsi/[dtc pas16 t128 generic]/[0-ASC_NUM_BOARD_SUPPORTED]
- *
- * *buffer: I/O buffer
- * **start: if inout == FALSE pointer into buffer where user read should start
- * offset: current offset
- * length: length of buffer
- * hostno: Scsi_Host host_no
- * inout: TRUE - user is writing; FALSE - user is reading
- *
- * Return the number of bytes read from or written
- */
-
 static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
 	char *buffer, int length)
 {
@@ -613,8 +545,6 @@ static int __maybe_unused NCR5380_show_i
  *      set correctly.  I don't care about the irq and other fields. 
  *
  *	Returns 0 for success
- *
- *	Locks: interrupts must be enabled when we are called 
  */
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
@@ -877,9 +807,6 @@ static void requeue_cmd(struct Scsi_Host
  *      be done on the NCR5380 host adapters in a system.  Both 
  *      NCR5380_queue_command() and NCR5380_intr() will try to start it 
  *      in case it is not running.
- * 
- *	Locks: called as its own thread with no locks held. Takes the
- *	host lock and called routines may take the isa dma lock.
  */
 
 static void NCR5380_main(struct work_struct *work)
@@ -1077,8 +1004,6 @@ static irqreturn_t NCR5380_intr(int irq,
  *
  *      If failed (no target) : cmd->scsi_done() will be called, and the 
  *              cmd->result host byte set to DID_BAD_TARGET.
- *
- *	Locks: caller holds hostdata lock in IRQ mode
  */
  
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
@@ -1578,8 +1503,6 @@ timeout:
  *      is in same phase.
  *
  *      Also, *phase, *count, *data are modified in place.
- *
- *	Locks: io_request lock held by caller
  */
 
 
@@ -1656,39 +1579,38 @@ static int NCR5380_transfer_dma(struct S
 	} while ((tmp & BASR_PHASE_MATCH) && !(tmp & (BASR_BUSY_ERROR | BASR_END_DMA_TRANSFER)));
 
 /*
-   At this point, either we've completed DMA, or we have a phase mismatch,
-   or we've unexpectedly lost BUSY (which is a real error).
-
-   For write DMAs, we want to wait until the last byte has been
-   transferred out over the bus before we turn off DMA mode.  Alas, there
-   seems to be no terribly good way of doing this on a 5380 under all
-   conditions.  For non-scatter-gather operations, we can wait until REQ
-   and ACK both go false, or until a phase mismatch occurs.  Gather-writes
-   are nastier, since the device will be expecting more data than we
-   are prepared to send it, and REQ will remain asserted.  On a 53C8[01] we
-   could test LAST BIT SENT to assure transfer (I imagine this is precisely
-   why this signal was added to the newer chips) but on the older 538[01]
-   this signal does not exist.  The workaround for this lack is a watchdog;
-   we bail out of the wait-loop after a modest amount of wait-time if
-   the usual exit conditions are not met.  Not a terribly clean or
-   correct solution :-%
-
-   Reads are equally tricky due to a nasty characteristic of the NCR5380.
-   If the chip is in DMA mode for an READ, it will respond to a target's
-   REQ by latching the SCSI data into the INPUT DATA register and asserting
-   ACK, even if it has _already_ been notified by the DMA controller that
-   the current DMA transfer has completed!  If the NCR5380 is then taken
-   out of DMA mode, this already-acknowledged byte is lost.
-
-   This is not a problem for "one DMA transfer per command" reads, because
-   the situation will never arise... either all of the data is DMA'ed
-   properly, or the target switches to MESSAGE IN phase to signal a
-   disconnection (either operation bringing the DMA to a clean halt).
-   However, in order to handle scatter-reads, we must work around the
-   problem.  The chosen fix is to DMA N-2 bytes, then check for the
-   condition before taking the NCR5380 out of DMA mode.  One or two extra
-   bytes are transferred via PIO as necessary to fill out the original
-   request.
+ * At this point, either we've completed DMA, or we have a phase mismatch,
+ * or we've unexpectedly lost BUSY (which is a real error).
+ *
+ * For DMA sends, we want to wait until the last byte has been
+ * transferred out over the bus before we turn off DMA mode.  Alas, there
+ * seems to be no terribly good way of doing this on a 5380 under all
+ * conditions.  For non-scatter-gather operations, we can wait until REQ
+ * and ACK both go false, or until a phase mismatch occurs.  Gather-sends
+ * are nastier, since the device will be expecting more data than we
+ * are prepared to send it, and REQ will remain asserted.  On a 53C8[01] we
+ * could test Last Byte Sent to assure transfer (I imagine this is precisely
+ * why this signal was added to the newer chips) but on the older 538[01]
+ * this signal does not exist.  The workaround for this lack is a watchdog;
+ * we bail out of the wait-loop after a modest amount of wait-time if
+ * the usual exit conditions are not met.  Not a terribly clean or
+ * correct solution :-%
+ *
+ * DMA receive is equally tricky due to a nasty characteristic of the NCR5380.
+ * If the chip is in DMA receive mode, it will respond to a target's
+ * REQ by latching the SCSI data into the INPUT DATA register and asserting
+ * ACK, even if it has _already_ been notified by the DMA controller that
+ * the current DMA transfer has completed!  If the NCR5380 is then taken
+ * out of DMA mode, this already-acknowledged byte is lost. This is
+ * not a problem for "one DMA transfer per READ command", because
+ * the situation will never arise... either all of the data is DMA'ed
+ * properly, or the target switches to MESSAGE IN phase to signal a
+ * disconnection (either operation bringing the DMA to a clean halt).
+ * However, in order to handle scatter-receive, we must work around the
+ * problem.  The chosen fix is to DMA N-2 bytes, then check for the
+ * condition before taking the NCR5380 out of DMA mode.  One or two extra
+ * bytes are transferred via PIO as necessary to fill out the original
+ * request.
  */
 
 	if (p & SR_IO) {
@@ -1824,8 +1746,6 @@ static int NCR5380_transfer_dma(struct S
  *
  * XXX Note : we need to watch for bus free or a reset condition here 
  *      to recover from an unexpected bus free condition.
- *
- * Locks: io_request_lock held by caller in IRQ mode
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance) {
@@ -2153,8 +2073,6 @@ static void NCR5380_information_transfer
  *      nexus has been reestablished,
  *      
  * Inputs : instance - this instance of the NCR5380.
- *
- * Locks: io_request_lock held by caller if IRQ driven
  */
 
 static void NCR5380_reselect(struct Scsi_Host *instance) {
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:36.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:37.000000000 +1100
@@ -24,47 +24,7 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * ++roman: To port the 5380 driver to the Atari, I had to do some changes in
- * this file, too:
- *
- *  - Some of the debug statements were incorrect (undefined variables and the
- *    like). I fixed that.
- *
- *  - In information_transfer(), I think a #ifdef was wrong. Looking at the
- *    possible DMA transfer size should also happen for REAL_DMA. I added this
- *    in the #if statement.
- *
- *  - When using real DMA, information_transfer() should return in a DATAOUT
- *    phase after starting the DMA. It has nothing more to do.
- *
- *  - The interrupt service routine should run main after end of DMA, too (not
- *    only after RESELECTION interrupts). Additionally, it should _not_ test
- *    for more interrupts after running main, since a DMA process may have
- *    been started and interrupts are turned on now. The new int could happen
- *    inside the execution of NCR5380_intr(), leading to recursive
- *    calls.
- *
- *  - I've added a function merge_contiguous_buffers() that tries to
- *    merge scatter-gather buffers that are located at contiguous
- *    physical addresses and can be processed with the same DMA setup.
- *    Since most scatter-gather operations work on a page (4K) of
- *    4 buffers (1K), in more than 90% of all cases three interrupts and
- *    DMA setup actions are saved.
- *
- * - I've deleted all the stuff for AUTOPROBE_IRQ, REAL_DMA_POLL, PSEUDO_DMA
- *    and USLEEP, because these were messing up readability and will never be
- *    needed for Atari SCSI.
- *
- * - I've revised the NCR5380_main() calling scheme (relax the 'main_running'
- *   stuff), and 'main' is executed in a bottom half if awoken by an
- *   interrupt.
- *
- * - The code was quite cluttered up by "#if (NDEBUG & NDEBUG_*) printk..."
- *   constructs. In my eyes, this made the source rather unreadable, so I
- *   finally replaced that by the *_PRINTK() macros.
- *
- */
+/* Ported to Atari by Roman Hodek and others. */
 
 /* Adapted for the sun3 by Sam Creasey. */
 
@@ -344,17 +304,15 @@ static void free_all_tags(struct NCR5380
 
 #endif /* SUPPORT_TAGS */
 
-
-/*
- * Function: void merge_contiguous_buffers( struct scsi_cmnd *cmd )
+/**
+ * merge_contiguous_buffers - coalesce scatter-gather list entries
+ * @cmd: command requesting IO
  *
- * Purpose: Try to merge several scatter-gather requests into one DMA
- *    transfer. This is possible if the scatter buffers lie on
- *    physical contiguous addresses.
- *
- * Parameters: struct scsi_cmnd *cmd
- *    The command to work on. The first scatter buffer's data are
- *    assumed to be already transferred into ptr/this_residual.
+ * Try to merge several scatter-gather buffers into one DMA transfer.
+ * This is possible if the scatter buffers lie on physically
+ * contiguous addresses. The first scatter-gather buffer's data are
+ * assumed to be already transferred into cmd->SCp.this_residual.
+ * Every buffer merged avoids an interrupt and a DMA setup operation.
  */
 
 static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
@@ -406,9 +364,7 @@ static inline void initialize_SCp(struct
 		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
-		/* ++roman: Try to merge some scatter-buffers if they are at
-		 * contiguous physical addresses.
-		 */
+
 		merge_contiguous_buffers(cmd);
 	} else {
 		cmd->SCp.buffer = NULL;
@@ -567,8 +523,6 @@ static struct {
  * @instance: adapter to dump
  *
  * Print the current SCSI phase for debugging purposes
- *
- * Locks: none
  */
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
@@ -594,8 +548,6 @@ static void NCR5380_print_phase(struct S
  * @instance: relevant scsi host instance
  *
  * For use as the host template info() handler.
- *
- * Locks: none
  */
 
 static const char *NCR5380_info(struct Scsi_Host *instance)
@@ -830,20 +782,6 @@ static int NCR5380_queue_command(struct
 	cmd->result = 0;
 
 	/*
-	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
-	 * commands are added to the head of the queue since any command will
-	 * clear the contingent allegiance condition that exists and the
-	 * sense data is only guaranteed to be valid while the condition exists.
-	 */
-
-	/* ++guenther: now that the issue queue is being set up, we can lock ST-DMA.
-	 * Otherwise a running NCR5380_main may steal the lock.
-	 * Lock before actually inserting due to fairness reasons explained in
-	 * atari_scsi.c. If we insert first, then it's impossible for this driver
-	 * to release the lock.
-	 * Stop timer for this command while waiting for the lock, or timeouts
-	 * may happen (and they really do), and it's no good if the command doesn't
-	 * appear in any of the queues.
 	 * ++roman: Just disabling the NCR interrupt isn't sufficient here,
 	 * because also a timer int can trigger an abort or reset, which would
 	 * alter queues and touch the lock.
@@ -959,8 +897,6 @@ static void requeue_cmd(struct Scsi_Host
  * be done on the NCR5380 host adapters in a system.  Both
  * NCR5380_queue_command() and NCR5380_intr() will try to start it
  * in case it is not running.
- *
- * Locks: called as its own thread with no locks held.
  */
 
 static void NCR5380_main(struct work_struct *work)
@@ -1042,7 +978,6 @@ static void NCR5380_main(struct work_str
  *	mismatch occurs (which would finish the DMA transfer).
  *
  * Inputs : instance - this instance of the NCR5380.
- *
  */
 
 static void NCR5380_dma_complete(struct Scsi_Host *instance)
@@ -1779,7 +1714,6 @@ timeout:
  *	is in same phase.
  *
  *	Also, *phase, *count, *data are modified in place.
- *
  */
 
 
@@ -1981,9 +1915,6 @@ static void NCR5380_information_transfer
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
 					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-					/* ++roman: Try to merge some scatter-buffers if
-					 * they are at contiguous physical addresses.
-					 */
 					merge_contiguous_buffers(cmd);
 					dsprintk(NDEBUG_INFORMATION, instance, "%d bytes and %d buffers left\n",
 					         cmd->SCp.this_residual,
@@ -2020,7 +1951,8 @@ static void NCR5380_information_transfer
 						/*
 						 * If the watchdog timer fires, all future
 						 * accesses to this device will use the
-						 * polled-IO. */
+						 * polled-IO.
+						 */
 						scmd_printk(KERN_INFO, cmd,
 							"switching to slow handshake\n");
 						cmd->device->borken = 1;
@@ -2112,10 +2044,6 @@ static void NCR5380_information_transfer
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
-					/* ++roman: For Falcon SCSI, release the lock on the
-					 * ST-DMA here if no other commands are waiting on the
-					 * disconnected queue.
-					 */
 					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
@@ -2312,7 +2240,6 @@ static void NCR5380_information_transfer
  *	nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
- *
  */
 
 
