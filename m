From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 1/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:03:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596126.7080502@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:39625 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267705AbUI1NDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:03:43 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD3fW01941
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:03:41 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD3fm30524
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:03:41 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2231-2232)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/aic7xxx/aic79xx.h#95 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.h ====
--- /tmp/tmp.26033.0	2004-09-27 12:39:23.752814600 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.h	2003-07-08 16:44:13.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#95 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#96 $
  *
  * $FreeBSD$
  */
@@ -375,7 +375,8 @@
	AHD_RESET_POLL_ACTIVE = 0x200000,
	AHD_UPDATE_PEND_CMDS  = 0x400000,
	AHD_RUNNING_QOUTFIFO  = 0x800000,
-	AHD_HAD_FIRST_SEL     = 0x1000000
+	AHD_HAD_FIRST_SEL     = 0x1000000,
+	AHD_SHUTDOWN_RECOVERY = 0x2000000 /* Terminate recovery thread. */
} ahd_flag;

/************************* Hardware  SCB Definition ***************************/
@@ -591,12 +592,16 @@
	SCB_PKT_SENSE		= 0x02000,
	SCB_CMDPHASE_ABORT	= 0x04000,
	SCB_ON_COL_LIST		= 0x08000,
-	SCB_SILENT		= 0x10000 /*
+	SCB_SILENT		= 0x10000,/*
					   * Be quiet about transmission type
					   * errors.  They are expected and we
					   * don't want to upset the user.  This
					   * flag is typically used during DV.
					   */
+	SCB_TIMEDOUT		= 0x20000/*
+					  * SCB has timed out and is on the
+					  * timedout list.
+					  */
} scb_flag;

struct scb {
@@ -613,6 +618,7 @@
	} links2;
#define pending_links links2.le
#define collision_links links2.le
+	LIST_ENTRY(scb)		  timedout_links;
	struct scb		 *col_scb;
	ahd_io_ctx_t		  io_ctx;
	struct ahd_softc	 *ahd_softc;
@@ -1069,6 +1075,11 @@
	LIST_HEAD(, scb)	  pending_scbs;

	/*
+	 * SCBs whose timeout routine has been called.
+	 */
+	LIST_HEAD(, scb)	  timedout_scbs;
+
+	/*
	 * Current register window mode information.
	 */
	ahd_mode		  dst_mode;
@@ -1433,6 +1444,8 @@
					       struct scb *scb);
void			ahd_calc_residual(struct ahd_softc *ahd,
					  struct scb *scb);
+void			ahd_timeout(struct scb *scb);
+void			ahd_recover_commands(struct ahd_softc *ahd);
/*************************** Utility Functions ********************************/
struct ahd_phase_table_entry*
			ahd_lookup_phase_entry(int phase);
==== //depot/aic7xxx/aic7xxx/aic79xx.c#202 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.26033.1	2004-09-27 12:39:26.571386112 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-07-24 13:03:29.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#202 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#203 $
  *
  * $FreeBSD$
  */
@@ -224,6 +224,9 @@
static void		ahd_download_instr(struct ahd_softc *ahd,
					   u_int instrptr, uint8_t *dconsts);
static int		ahd_probe_stack_size(struct ahd_softc *ahd);
+static void		ahd_other_scb_timeout(struct ahd_softc *ahd,
+					      struct scb *scb,
+					      struct scb *other_scb);
static int		ahd_scb_active_in_fifo(struct ahd_softc *ahd,
					       struct scb *scb);
static void		ahd_run_data_fifo(struct ahd_softc *ahd,
@@ -5266,6 +5269,7 @@
{
	int i;

+	ahd_terminate_recovery_thread(ahd);
	switch (ahd->init_level) {
	default:
	case 5:
@@ -7810,7 +7814,7 @@
	 */
	ahd_clear_msg_state(ahd);
	ahd_outb(ahd, SIMODE1,
-		 ahd_inb(ahd, SIMODE1) & ~(ENBUSFREE|ENSCSIRST|ENBUSFREE));
+		 ahd_inb(ahd, SIMODE1) & ~(ENBUSFREE|ENSCSIRST));

	if (initiate_reset)
		ahd_reset_current_bus(ahd);
@@ -9072,6 +9076,270 @@
	ahd_restore_modes(ahd, saved_modes);
}

+
+/*************************** Timeout Handling *********************************/
+void
+ahd_timeout(struct scb *scb)
+{
+	struct ahd_softc *ahd;
+	u_long s;
+
+	ahd = scb->ahd_softc;
+	ahd_lock(ahd, &s);
+	if ((scb->flags & SCB_ACTIVE) != 0) {
+		if ((scb->flags & SCB_TIMEDOUT) != 0) {
+			LIST_INSERT_HEAD(&ahd->timedout_scbs, scb,
+					 timedout_links);
+			scb->flags |= SCB_TIMEDOUT;
+		}
+		ahd_wakeup_recovery_thread(ahd);
+	}
+	ahd_unlock(ahd, &s);
+}
+
+/*
+ * ahd_recover_commands determines if any of the commands that have currently
+ * timedout are the root cause for this timeout.  Innocent commands are given
+ * a new timeout while we wait for the command executing on the bus to timeout.
+ * This routine is invoked from a thread context so we are allowed to sleep.
+ * Our lock is not held on entry.
+ */
+void
+ahd_recover_commands(struct ahd_softc *ahd)
+{
+	struct	scb *scb;
+	struct	scb *active_scb;
+	long	s;
+	int	found;
+	int	was_paused;
+	u_int	active_scbptr;
+	u_int	last_phase;
+
+	ahd_lock(ahd, &s);
+
+	/*
+	 * Pause the controller and manually flush any
+	 * commands that have just completed but that our
+	 * interrupt handler has yet to see.
+	 */
+	was_paused = ahd_is_paused(ahd);
+	ahd_pause_and_flushwork(ahd);
+
+	if (LIST_EMPTY(&ahd->timedout_scbs) != 0) {
+		/*
+		 * The timedout commands have already
+		 * completed.  This typically means
+		 * that either the timeout value was on
+		 * the hairy edge of what the device
+		 * requires or - more likely - interrupts
+		 * are not happening.
+		 */
+		printf("%s: Timedout SCBs already complete. "
+		       "Interrupts may not be functioning.\n", ahd_name(ahd));
+		ahd_unpause(ahd);
+		ahd_unlock(ahd, &s);
+		return;
+	}
+
+	printf("%s: Recovery Initiated - Card was %spaused\n", ahd_name(ahd),
+	       was_paused ? "" : "not ");
+	ahd_dump_card_state(ahd);
+
+	/*
+	 * Determine identity of SCB acting on the bus.
+	 * This test only catches non-packetized transactions.
+	 * Due to the fleeting nature of packetized operations,
+	 * we can't easily determine that a packetized operation
+	 * is on the bus.
+	 */
+	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
+	last_phase = ahd_inb(ahd, LASTPHASE);
+	active_scbptr = ahd_get_scbptr(ahd);
+	active_scb = NULL;
+	if (last_phase != P_BUSFREE
+	 || (ahd_inb(ahd, SEQ_FLAGS) & NOT_IDENTIFIED) == 0)
+		active_scb = ahd_lookup_scb(ahd, active_scbptr);
+
+	while ((scb = LIST_FIRST(&ahd->timedout_scbs)) != NULL) {
+		int	target;
+		int	lun;
+		char	channel;
+
+		target = SCB_GET_TARGET(ahd, scb);
+		channel = SCB_GET_CHANNEL(ahd, scb);
+		lun = SCB_GET_LUN(scb);
+
+		ahd_print_path(ahd, scb);
+		printf("SCB 0x%x - timed out\n", scb->hscb->tag);
+
+		if (scb->flags & (SCB_DEVICE_RESET|SCB_ABORT)) {
+			/*
+			 * Been down this road before.
+			 * Do a full bus reset.
+			 */
+			ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
+			found = ahd_reset_channel(ahd, channel,
+						  /*Initiate Reset*/TRUE);
+			printf("%s: Issued Channel %c Bus Reset. "
+			       "%d SCBs aborted\n", ahd_name(ahd), channel,
+			       found);
+			continue;
+		}
+
+		/*
+		 * Remove the command from the timedout list in
+		 * preparation for requeing it.
+		 */
+		LIST_REMOVE(scb, timedout_links);
+		scb->flags &= ~SCB_TIMEDOUT;
+
+		if (active_scb != NULL) {
+
+			if (active_scb != scb) {
+				/*
+				 * If the active SCB is not us, assume that
+				 * the active SCB has a longer timeout than
+				 * the timedout SCB, and wait for the active
+				 * SCB to timeout.
+				 */
+				ahd_other_scb_timeout(ahd, scb, active_scb);
+				continue;
+			}
+
+			/*
+			 * We're active on the bus, so assert ATN
+			 * and hope that the target responds.
+			 */
+			ahd_set_recoveryscb(ahd, active_scb);
+                	active_scb->flags |= SCB_RECOVERY_SCB|SCB_DEVICE_RESET;
+			ahd_outb(ahd, MSG_OUT, HOST_MSG);
+			ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
+			ahd_print_path(ahd, active_scb);
+			printf("BDR message in message buffer\n");
+			ahd_scb_timer_reset(scb, 2 * 1000000);
+			break;
+		} else if (ahd_search_qinfifo(ahd, target, channel, lun,
+					      scb->hscb->tag, ROLE_INITIATOR,
+					      /*status*/0, SEARCH_COUNT) > 0) {
+
+			/*
+			 * We haven't even gone out on the bus
+			 * yet, so the timeout must be due to
+			 * some other command.  Reset the timer
+			 * and go on.
+			 */
+			ahd_other_scb_timeout(ahd, scb, scb);
+		} else {
+			/*
+			 * This SCB is for a disconnected transaction
+			 * and we haven't found a better candidate on
+			 * the bus to explain this timeout.
+			 */
+			ahd_set_recoveryscb(ahd, scb);
+
+			/*
+			 * Actually re-queue this SCB in an attempt
+			 * to select the device before it reconnects.
+			 * In either case (selection or reselection),
+			 * we will now issue a target reset to the
+			 * timed-out device.
+			 *
+			 * Set the MK_MESSAGE control bit indicating
+			 * that we desire to send a message.  We
+			 * also set the disconnected flag since
+			 * in the paging case there is no guarantee
+			 * that our SCB control byte matches the
+			 * version on the card.  We don't want the
+			 * sequencer to abort the command thinking
+			 * an unsolicited reselection occurred.
+			 */
+			scb->flags |= SCB_DEVICE_RESET;
+			scb->hscb->cdb_len = 0;
+			scb->hscb->task_attribute = 0;
+			scb->hscb->task_management = SIU_TASKMGMT_ABORT_TASK;
+
+			ahd_set_scbptr(ahd, SCB_GET_TAG(scb));
+			if ((scb->flags & SCB_PACKETIZED) != 0) {
+				/*
+				 * Mark the SCB has having an outstanding
+				 * task management function.  Should the command
+				 * complete normally before the task management
+				 * function can be sent, the host will be
+				 * notified to abort our requeued SCB.
+				 */
+				ahd_outb(ahd, SCB_TASK_MANAGEMENT,
+					 scb->hscb->task_management);
+			} else {
+				/*
+				 * If non-packetized, set the MK_MESSAGE control
+				 * bit indicating that we desire to send a
+				 * message.  We also set the disconnected flag
+				 * since there is no guarantee that our SCB
+				 * control byte matches the version on the
+				 * card.  We don't want the sequencer to abort
+				 * the command thinking an unsolicited
+				 * reselection occurred.
+				 */
+				scb->hscb->control |= MK_MESSAGE|DISCONNECTED;
+
+				/*
+				 * The sequencer will never re-reference the
+				 * in-core SCB.  To make sure we are notified
+				 * during reslection, set the MK_MESSAGE flag in
+				 * the card's copy of the SCB.
+				 */
+				ahd_outb(ahd, SCB_CONTROL,
+					 ahd_inb(ahd, SCB_CONTROL)|MK_MESSAGE);
+			}
+
+			/*
+			 * Clear out any entries in the QINFIFO first
+			 * so we are the next SCB for this target
+			 * to run.
+			 */
+			ahd_search_qinfifo(ahd, target, channel, lun,
+					   SCB_LIST_NULL, ROLE_INITIATOR,
+					   CAM_REQUEUE_REQ, SEARCH_COMPLETE);
+			ahd_qinfifo_requeue_tail(ahd, scb);
+			ahd_set_scbptr(ahd, active_scbptr);
+			ahd_print_path(ahd, scb);
+			printf("Queuing a BDR SCB\n");
+			ahd_scb_timer_reset(scb, 2 * 1000000);
+			break;
+		}
+	}
+	
+	/*
+	 * Any remaining SCBs were not the "culprit", so give
+	 * them a new lease on life.
+	 */
+	while ((scb = LIST_FIRST(&ahd->timedout_scbs)) != NULL) {
+
+		LIST_REMOVE(scb, timedout_links);
+		scb->flags &= ~SCB_TIMEDOUT;
+		ahd_scb_timer_reset(scb, ahd_get_timeout(scb));
+	}
+
+	ahd_unpause(ahd);
+	ahd_unlock(ahd, &s);
+}
+
+static void
+ahd_other_scb_timeout(struct ahd_softc *ahd, struct scb *scb,
+		      struct scb *other_scb)
+{
+	u_int	newtimeout;
+
+	ahd_print_path(ahd, scb);
+	printf("Other SCB Timeout%s",
+ 	       (scb->flags & SCB_OTHERTCL_TIMEOUT) != 0
+	       ? " again\n" : "\n");
+	scb->flags |= SCB_OTHERTCL_TIMEOUT;
+	newtimeout = MAX(ahd_get_timeout(other_scb),
+			 ahd_get_timeout(scb));
+	ahd_scb_timer_reset(scb, newtimeout);
+}
+
/**************************** Flexport Logic **********************************/
/*
  * Read count 16bit words from 16bit word address start_addr from the
==== //depot/aic7xxx/aic7xxx/aic7xxx.h#79 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.h ====
--- /tmp/tmp.26033.2	2004-09-27 12:39:26.864341576 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.h	2003-07-08 16:43:44.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.h#79 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.h#80 $
  *
  * $FreeBSD$
  */
@@ -366,7 +366,8 @@
	AHC_SCB_CONFIG_USED   = 0x4000000, /* No SEEPROM but SCB2 had info. */
	AHC_NO_BIOS_INIT      = 0x8000000, /* No BIOS left over settings. */
	AHC_DISABLE_PCI_PERR  = 0x10000000,
-	AHC_HAS_TERM_LOGIC    = 0x20000000
+	AHC_HAS_TERM_LOGIC    = 0x20000000,
+	AHC_SHUTDOWN_RECOVERY = 0x40000000 /* Terminate recovery thread. */
} ahc_flag;

/************************* Hardware  SCB Definition ***************************/
@@ -560,12 +561,16 @@
					  * to report the error.
					  */
	SCB_TARGET_SCB		= 0x2000,
-	SCB_SILENT		= 0x4000 /*
+	SCB_SILENT		= 0x4000,/*
					  * Be quiet about transmission type
					  * errors.  They are expected and we
					  * don't want to upset the user.  This
					  * flag is typically used during DV.
					  */
+	SCB_TIMEDOUT		= 0x8000 /*
+					  * SCB has timed out and is on the
+					  * timedout list.
+					  */
} scb_flag;

struct scb {
@@ -575,6 +580,7 @@
		TAILQ_ENTRY(scb)  tqe;
	} links;
	LIST_ENTRY(scb)		  pending_links;
+	LIST_ENTRY(scb)		  timedout_links;
	ahc_io_ctx_t		  io_ctx;
	struct ahc_softc	 *ahc_softc;
	scb_flag		  flags;
@@ -929,6 +935,11 @@
	LIST_HEAD(, scb)	  pending_scbs;

	/*
+	 * SCBs whose timeout routine has been called.
+	 */
+	LIST_HEAD(, scb)	  timedout_scbs;
+
+	/*
	 * Counting lock for deferring the release of additional
	 * untagged transactions from the untagged_queues.  When
	 * the lock is decremented to 0, all queues in the
@@ -1248,6 +1259,8 @@
void			ahc_restart(struct ahc_softc *ahc);
void			ahc_calc_residual(struct ahc_softc *ahc,
					  struct scb *scb);
+void			ahc_timeout(struct scb *scb);
+void			ahc_recover_commands(struct ahc_softc *ahc);
/*************************** Utility Functions ********************************/
struct ahc_phase_table_entry*
			ahc_lookup_phase_entry(int phase);
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#134 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.26033.3	2004-09-27 12:39:28.555084544 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-07-09 17:27:48.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#134 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#135 $
  *
  * $FreeBSD$
  */
@@ -3969,6 +3969,7 @@
{
	int i;

+	ahc_terminate_recovery_thread(ahc);
	switch (ahc->init_level) {
	default:
	case 5:
@@ -4046,6 +4047,9 @@

	ahc = (struct ahc_softc *)arg;

+	/* Kill off our recovery thread. */
+	ahc_terminate_recovery_thread(ahc);
+
	/* This will reset most registers to 0, but not all */
	ahc_reset(ahc, /*reinit*/FALSE);
	ahc_outb(ahc, SCSISEQ, 0);
@@ -4760,6 +4764,7 @@
ahc_init(struct ahc_softc *ahc)
{
	int	 max_targ;
+	int	 error;
	u_int	 i;
	u_int	 scsi_conf;
	u_int	 ultraenb;
@@ -4915,6 +4920,13 @@
		}
	}

+	/*
+	 * Fire up a recovery thread for this controller.
+	 */
+	error = ahc_spawn_recovery_thread(ahc);
+	if (error != 0)
+		return (error);
+
	if (ahc->scb_data->maxhscbs < AHC_SCB_MAX_ALLOC) {
		ahc->flags |= AHC_PAGESCBS;
	} else {
@@ -6827,6 +6839,315 @@
		ahc_unpause(ahc);
}

+/*************************** Timeout Handling *********************************/
+void
+ahc_timeout(struct scb *scb)
+{
+	struct ahc_softc *ahc;
+	u_long s;
+
+	ahc = scb->ahc_softc;
+	ahc_lock(ahc, &s);
+	if ((scb->flags & SCB_ACTIVE) != 0) {
+		if ((scb->flags & SCB_TIMEDOUT) != 0) {
+			LIST_INSERT_HEAD(&ahc->timedout_scbs, scb,
+					 timedout_links);
+			scb->flags |= SCB_TIMEDOUT;
+		}
+		ahc_wakeup_recovery_thread(ahc);
+	}
+	ahc_unlock(ahc, &s);
+}
+
+/*
+ * ahc_recover_commands determines if any of the commands that have currently
+ * timedout are the root cause for this timeout.  Innocent commands are given
+ * a new timeout while we wait for the command executing on the bus to timeout.
+ * This routine is invoked from a thread context so we are allowed to sleep.
+ * Our lock is not held on entry.
+ */
+void
+ahc_recover_commands(struct ahc_softc *ahc)
+{
+	struct	scb *scb;
+	long	s;
+	int	found;
+	int	restart_needed;
+	u_int	last_phase;
+
+	ahc_lock(ahc, &s);
+
+	/*
+	 * Pause the controller and manually flush any
+	 * commands that have just completed but that our
+	 * interrupt handler has yet to see.
+	 */
+	ahc_pause_and_flushwork(ahc);
+
+	if (LIST_EMPTY(&ahc->timedout_scbs) != 0) {
+		/*
+		 * The timedout commands have already
+		 * completed.  This typically means
+		 * that either the timeout value was on
+		 * the hairy edge of what the device
+		 * requires or - more likely - interrupts
+		 * are not happening.
+		 */
+		printf("%s: Timedout SCBs already complete. "
+		       "Interrupts may not be functioning.\n", ahc_name(ahc));
+		ahc_unpause(ahc);
+		ahc_unlock(ahc, &s);
+		return;
+	}
+
+	restart_needed = 0;
+	printf("%s: Recovery Initiated\n", ahc_name(ahc));
+	ahc_dump_card_state(ahc);
+
+	last_phase = ahc_inb(ahc, LASTPHASE);
+	while ((scb = LIST_FIRST(&ahc->timedout_scbs)) != NULL) {
+		u_int	active_scb_index;
+		u_int	saved_scbptr;
+		int	target;
+		int	lun;
+		int	i;
+		char	channel;
+
+		target = SCB_GET_TARGET(ahc, scb);
+		channel = SCB_GET_CHANNEL(ahc, scb);
+		lun = SCB_GET_LUN(scb);
+
+		ahc_print_path(ahc, scb);
+		printf("SCB 0x%x - timed out\n", scb->hscb->tag);
+		if (scb->sg_count > 0) {
+			for (i = 0; i < scb->sg_count; i++) {
+				printf("sg[%d] - Addr 0x%x : Length %d\n",
+				       i,
+				       scb->sg_list[i].addr,
+				       scb->sg_list[i].len & AHC_SG_LEN_MASK);
+			}
+		}
+		if (scb->flags & (SCB_DEVICE_RESET|SCB_ABORT)) {
+			/*
+			 * Been down this road before.
+			 * Do a full bus reset.
+			 */
+bus_reset:
+			ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
+			found = ahc_reset_channel(ahc, channel,
+						  /*Initiate Reset*/TRUE);
+			printf("%s: Issued Channel %c Bus Reset. "
+			       "%d SCBs aborted\n", ahc_name(ahc), channel,
+			       found);
+			continue;
+		}
+
+		/*
+		 * Remove the command from the timedout list in
+		 * preparation for requeing it.
+		 */
+		LIST_REMOVE(scb, timedout_links);
+		scb->flags &= ~SCB_TIMEDOUT;
+
+		/*
+		 * If we are a target, transition to bus free and report
+		 * the timeout.
+		 *
+		 * The target/initiator that is holding up the bus may not
+		 * be the same as the one that triggered this timeout
+		 * (different commands have different timeout lengths).
+		 * If the bus is idle and we are actiing as the initiator
+		 * for this request, queue a BDR message to the timed out
+		 * target.  Otherwise, if the timed out transaction is
+		 * active:
+		 *   Initiator transaction:
+		 *	Stuff the message buffer with a BDR message and assert
+		 *	ATN in the hopes that the target will let go of the bus
+		 *	and go to the mesgout phase.  If this fails, we'll
+		 *	get another timeout 2 seconds later which will attempt
+		 *	a bus reset.
+		 *
+		 *   Target transaction:
+		 *	Transition to BUS FREE and report the error.
+		 *	It's good to be the target!
+		 */
+		saved_scbptr = ahc_inb(ahc, SCBPTR);
+		active_scb_index = ahc_inb(ahc, SCB_TAG);
+
+		if ((ahc_inb(ahc, SEQ_FLAGS) & NOT_IDENTIFIED) == 0
+		  && (active_scb_index < ahc->scb_data->numscbs)) {
+			struct scb *active_scb;
+
+			/*
+			 * If the active SCB is not us, assume that
+			 * the active SCB has a longer timeout than
+			 * the timedout SCB, and wait for the active
+			 * SCB to timeout.
+			 */
+			active_scb = ahc_lookup_scb(ahc, active_scb_index);
+			if (active_scb != scb) {
+				u_int	newtimeout;
+
+				ahc_print_path(ahc, scb);
+				printf("Other SCB Timeout%s",
+			 	       (scb->flags & SCB_OTHERTCL_TIMEOUT) != 0
+				       ? " again\n" : "\n");
+				scb->flags |= SCB_OTHERTCL_TIMEOUT;
+				newtimeout =
+				    MAX(ahc_get_timeout(active_scb),
+					ahc_get_timeout(scb));
+				ahc_scb_timer_reset(scb, newtimeout);
+				continue;
+			}
+
+			/* It's us */
+			if ((scb->flags & SCB_TARGET_SCB) != 0) {
+
+				/*
+				 * Send back any queued up transactions
+				 * and properly record the error condition.
+				 */
+				ahc_abort_scbs(ahc, SCB_GET_TARGET(ahc, scb),
+					       SCB_GET_CHANNEL(ahc, scb),
+					       SCB_GET_LUN(scb),
+					       scb->hscb->tag,
+					       ROLE_TARGET,
+					       CAM_CMD_TIMEOUT);
+
+				/* Will clear us from the bus */
+				restart_needed = 1;
+				break;
+			}
+
+			ahc_set_recoveryscb(ahc, active_scb);
+			ahc_outb(ahc, MSG_OUT, HOST_MSG);
+			ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
+			ahc_print_path(ahc, active_scb);
+			printf("BDR message in message buffer\n");
+			active_scb->flags |= SCB_DEVICE_RESET;
+			ahc_scb_timer_reset(scb, 2 * 1000000);
+		} else {
+			int	 disconnected;
+
+			if (last_phase != P_BUSFREE
+			 && (ahc_inb(ahc, SSTAT0) & TARGET) != 0) {
+				/* Hung target selection.  Goto busfree */
+				printf("%s: Hung target selection\n",
+				       ahc_name(ahc));
+				restart_needed = 1;
+				break;
+			}
+
+			/* XXX Shouldn't panic.  Just punt instead? */
+			if ((scb->flags & SCB_TARGET_SCB) != 0)
+				panic("Timed-out target SCB but bus idle");
+
+			if (ahc_search_qinfifo(ahc, target, channel, lun,
+					       scb->hscb->tag, ROLE_INITIATOR,
+					       /*status*/0, SEARCH_COUNT) > 0) {
+				disconnected = FALSE;
+			} else {
+				disconnected = TRUE;
+			}
+
+			if (disconnected) {
+
+				ahc_set_recoveryscb(ahc, scb);
+				/*
+				 * Actually re-queue this SCB in an attempt
+				 * to select the device before it reconnects.
+				 * In either case (selection or reselection),
+				 * we will now issue a target reset to the
+				 * timed-out device.
+				 *
+				 * Set the MK_MESSAGE control bit indicating
+				 * that we desire to send a message.  We
+				 * also set the disconnected flag since
+				 * in the paging case there is no guarantee
+				 * that our SCB control byte matches the
+				 * version on the card.  We don't want the
+				 * sequencer to abort the command thinking
+				 * an unsolicited reselection occurred.
+				 */
+				scb->hscb->control |= MK_MESSAGE|DISCONNECTED;
+				scb->flags |= SCB_DEVICE_RESET;
+
+				/*
+				 * Remove any cached copy of this SCB in the
+				 * disconnected list in preparation for the
+				 * queuing of our abort SCB.  We use the
+				 * same element in the SCB, SCB_NEXT, for
+				 * both the qinfifo and the disconnected list.
+				 */
+				ahc_search_disc_list(ahc, target, channel,
+						     lun, scb->hscb->tag,
+						     /*stop_on_first*/TRUE,
+						     /*remove*/TRUE,
+						     /*save_state*/FALSE);
+
+				/*
+				 * In the non-paging case, the sequencer will
+				 * never re-reference the in-core SCB.
+				 * To make sure we are notified during
+				 * reslection, set the MK_MESSAGE flag in
+				 * the card's copy of the SCB.
+				 */
+				if ((ahc->flags & AHC_PAGESCBS) == 0) {
+					ahc_outb(ahc, SCBPTR, scb->hscb->tag);
+					ahc_outb(ahc, SCB_CONTROL,
+						 ahc_inb(ahc, SCB_CONTROL)
+						| MK_MESSAGE);
+				}
+
+				/*
+				 * Clear out any entries in the QINFIFO first
+				 * so we are the next SCB for this target
+				 * to run.
+				 */
+				ahc_search_qinfifo(ahc,
+						   SCB_GET_TARGET(ahc, scb),
+						   channel, SCB_GET_LUN(scb),
+						   SCB_LIST_NULL,
+						   ROLE_INITIATOR,
+						   CAM_REQUEUE_REQ,
+						   SEARCH_COMPLETE);
+				ahc_print_path(ahc, scb);
+				printf("Queuing a BDR SCB\n");
+				ahc_qinfifo_requeue_tail(ahc, scb);
+				ahc_outb(ahc, SCBPTR, saved_scbptr);
+				ahc_scb_timer_reset(scb, 2 * 1000000);
+			} else {
+				/* Go "immediatly" to the bus reset */
+				/* This shouldn't happen */
+				ahc_set_recoveryscb(ahc, scb);
+				ahc_print_path(ahc, scb);
+				printf("SCB %d: Immediate reset.  "
+					"Flags = 0x%x\n", scb->hscb->tag,
+					scb->flags);
+				goto bus_reset;
+			}
+		}
+		break;
+	}
+	
+	/*
+	 * Any remaining SCBs were not the "culprit", so give
+	 * them a new lease on life.
+	 */
+	while ((scb = LIST_FIRST(&ahc->timedout_scbs)) != NULL) {
+
+		LIST_REMOVE(scb, timedout_links);
+		scb->flags &= ~SCB_TIMEDOUT;
+		ahc_scb_timer_reset(scb, ahc_get_timeout(scb));
+	}
+
+	if (restart_needed)
+		ahc_restart(ahc);
+	else
+		ahc_unpause(ahc);
+	ahc_unlock(ahc, &s);
+}
+
/************************* Target Mode ****************************************/
#ifdef AHC_TARGET_MODE
cam_status


