From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 4/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:04:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596164.3050708@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12234 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267702AbUI1NEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:04:45 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4iW02331
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:44 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4hm30773
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:43 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2241-2281)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/aic7xxx/aic79xx.seq#99 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq ====
--- /tmp/tmp.26212.0	2004-09-27 12:47:56.473869152 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq	2003-08-26 16:16:49.000000000 -0400
@@ -40,7 +40,7 @@
  * $FreeBSD$
  */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#99 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#101 $"
PATCH_ARG_LIST = "struct ahd_softc *ahd"
PREFIX = "ahd_"

@@ -490,6 +490,9 @@
SET_SRC_MODE	M_SCSI;
SET_DST_MODE	M_SCSI;
select_in:
+	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
+		or	SBLKCTL, DIAGLEDEN|DIAGLEDON;
+	}
	if ((ahd->bugs & AHD_BUSFREEREV_BUG) != 0) {
		/*
		 * Test to ensure that the bus has not
@@ -527,6 +530,9 @@
SET_SRC_MODE	M_SCSI;
SET_DST_MODE	M_SCSI;
select_out:
+	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
+		or	SBLKCTL, DIAGLEDEN|DIAGLEDON;
+	}
BEGIN_CRITICAL;
	/* Clear out all SCBs that have been successfully sent. */
	if ((ahd->bugs & AHD_SENT_SCB_UPDATE_BUG) != 0) {
@@ -1658,7 +1664,7 @@
		 * savepointer in the current FIFO.  We do this so that
		 * a pending CTXTDONE or SAVEPTR is visible in the active
		 * FIFO.  This status is the only way we can detect if we
-		 * have lost the race (e.g. host paused us) and our attepts
+		 * have lost the race (e.g. host paused us) and our attempts
		 * to disable the channel occurred after all REQs were
		 * already seen and acked (REQINIT never comes true).
		 */
==== //depot/aic7xxx/aic7xxx/aic79xx.c#203 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.26212.1	2004-09-27 12:47:58.273595552 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-08-11 19:38:14.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#203 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#206 $
  *
  * $FreeBSD$
  */
@@ -1065,7 +1065,7 @@
			ahd_outb(ahd, SAVED_LUN, 0);
			ahd_outb(ahd, SEQ_FLAGS, 0);
			ahd_assert_atn(ahd);
-			scb->flags &= ~(SCB_PACKETIZED);
+			scb->flags &= ~SCB_PACKETIZED;
			scb->flags |= SCB_ABORT|SCB_CMDPHASE_ABORT;
			ahd_freeze_devq(ahd, scb);
			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
@@ -9082,19 +9082,16 @@
ahd_timeout(struct scb *scb)
{
	struct ahd_softc *ahd;
-	u_long s;

	ahd = scb->ahd_softc;
-	ahd_lock(ahd, &s);
	if ((scb->flags & SCB_ACTIVE) != 0) {
-		if ((scb->flags & SCB_TIMEDOUT) != 0) {
+		if ((scb->flags & SCB_TIMEDOUT) == 0) {
			LIST_INSERT_HEAD(&ahd->timedout_scbs, scb,
					 timedout_links);
			scb->flags |= SCB_TIMEDOUT;
		}
		ahd_wakeup_recovery_thread(ahd);
	}
-	ahd_unlock(ahd, &s);
}

/*
@@ -9310,14 +9307,14 @@
	}
	
	/*
-	 * Any remaining SCBs were not the "culprit", so give
-	 * them a new lease on life.
+	 * Any remaining SCBs were not the "culprit", so remove
+	 * them from the timeout list.  The timer for these commands
+	 * will be reset once the recovery SCB completes.
	 */
	while ((scb = LIST_FIRST(&ahd->timedout_scbs)) != NULL) {

		LIST_REMOVE(scb, timedout_links);
		scb->flags &= ~SCB_TIMEDOUT;
-		ahd_scb_timer_reset(scb, ahd_get_timeout(scb));
	}

	ahd_unpause(ahd);
@@ -9446,7 +9443,7 @@
{
	int cnt;

-	cnt = 20;
+	cnt = 5000;
	while ((ahd_inb(ahd, SEESTAT) & (SEEARBACK|SEEBUSY)) != 0 && --cnt)
		ahd_delay(5);

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#172 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.26212.2	2004-09-27 12:47:58.963490672 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-08-20 17:41:40.000000000 -0400
@@ -1,7 +1,7 @@
/*
  * Adaptec AIC79xx device driver for Linux.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#172 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#175 $
  *
  * --------------------------------------------------------------------------
  * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -890,8 +890,33 @@
			ahd_unlock(ahd, &s);
			break;
		}
+
+		/*
+		 * Don't bother the recovery handler if the
+		 * list has been cleared by a previous run
+		 * of the handler.  This can happen when
+		 * several SCBs timeout before our handler
+		 * can run causing our semaphore to be up'ed
+		 * repeatedly.  The extra calls need to be
+		 * avoided so that the recovery handler doesn't
+		 * confuse this case with timeouts occuring
+		 * due to interrupts failing to function.
+		 */
+		if (LIST_EMPTY(&ahd->timedout_scbs) != 0) {
+			ahd_unlock(ahd, &s);
+			continue;
+		}
+
		ahd_unlock(ahd, &s);
		ahd_recover_commands(ahd);
+
+		/*
+		 * Process any pent up completions.
+		 */
+		ahd_lock(ahd, &s);
+		ahd_schedule_runq(ahd);
+		ahd_linux_run_complete_queue(ahd);
+		ahd_unlock(ahd, &s);
	}
	up(&ahd->platform_data->recovery_ending_sem);
	return(0);
@@ -973,7 +998,7 @@
		LIST_FOREACH(list_scb, &ahd->pending_scbs, pending_links) {

			scsi_delete_timer(list_scb->io_ctx);
-			scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
+			list_scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
		}
	}
}
@@ -982,15 +1007,27 @@
ahd_platform_timeout(struct scsi_cmnd *cmd)
{

-	if (AHD_DV_CMD(cmd) == 0) {
+	if (AHD_DV_CMD(cmd) != 0) {

		ahd_linux_dv_timeout(cmd);
	} else {
+		struct	ahd_softc *ahd;
		struct	scb *scb;
+		u_long	s;

		scb = (struct scb *)cmd->host_scribble;
-		scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
-		ahd_timeout(scb);
+		ahd = scb->ahd_softc;
+		ahd_lock(ahd, &s);
+
+		/*
+		 * Skip timeouts that fire just after
+		 * they have been cancelled.
+		 */
+		if ((scb->platform_data->flags & AHD_TIMEOUT_ACTIVE) != 0) {
+			scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
+			ahd_timeout(scb);
+		}
+		ahd_unlock(ahd, &s);
	}
}

@@ -1197,6 +1234,7 @@
		printf("%s: aic79xx_linux_queue -"
		       "CDB length of %d exceeds max!\n",
		       ahd_name(ahd), cmd->cmd_len);
+		return (0);
	}

	/*
@@ -3080,6 +3118,7 @@
		spin_unlock_irqrestore(&io_request_lock, s);
#endif
		down_interruptible(&ahd->platform_data->dv_cmd_sem);
+
		/*
		 * Wait for the SIMQ to be released so that DV is the
		 * only reason the queue is frozen.
@@ -4285,6 +4324,7 @@
		TAILQ_REMOVE(&dev->busyq, acmd, acmd_links.tqe);
		scb->io_ctx = cmd;
		scb->platform_data->dev = dev;
+		scb->platform_data->flags = 0;
		hscb = scb->hscb;
		cmd->host_scribble = (char *)scb;

@@ -4643,7 +4683,11 @@
		ahd_dump_card_state(ahd);
		panic("Stopping for safety");
	}
+
	LIST_REMOVE(scb, pending_links);
+	if ((scb->flags & SCB_TIMEDOUT) != 0)
+		LIST_REMOVE(scb, timedout_links);
+
	cmd = scb->io_ctx;
	dev = scb->platform_data->dev;
	dev->active--;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#138 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26212.3	2004-09-27 12:47:59.226450696 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-08-20 18:13:29.000000000 -0400
@@ -36,7 +36,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#138 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#140 $
  *
  */
#ifndef _AIC79XX_LINUX_H_
@@ -266,7 +266,7 @@
#define AHD_SCSI_HAS_HOST_LOCK 0
#endif

-#define AIC79XX_DRIVER_VERSION "1.3.11"
+#define AIC79XX_DRIVER_VERSION "2.0.0"

/**************************** Front End Queues ********************************/
/*
==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#77 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.26212.4	2004-09-27 12:47:59.315437168 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2003-08-08 18:00:03.000000000 -0400
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#77 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#78 $
  *
  * $FreeBSD$
  */
@@ -701,6 +701,7 @@
	 * Now set the termination based on what we found.
	 */
	sxfrctl1 = ahd_inb(ahd, SXFRCTL1) & ~STPWEN;
+	ahd->flags &= ~AHD_TERM_ENB_A;
	if ((termctl & FLX_TERMCTL_ENPRILOW) != 0) {
		ahd->flags |= AHD_TERM_ENB_A;
		sxfrctl1 |= STPWEN;
==== //depot/aic7xxx/aic7xxx/aic7xxx_93cx6.c#17 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_93cx6.c ====
--- /tmp/tmp.26212.5	2004-09-27 12:47:59.346432456 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_93cx6.c	2003-08-11 17:01:38.000000000 -0400
@@ -28,7 +28,7 @@
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_93cx6.c#17 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_93cx6.c#18 $
  *
  * $FreeBSD$
  */
@@ -81,14 +81,22 @@
  * Right now, we only have to read the SEEPROM.  But we make it easier to
  * add other 93Cx6 functions.
  */
-static struct seeprom_cmd {
+struct seeprom_cmd {
   	uint8_t len;
- 	uint8_t bits[9];
-} seeprom_read = {3, {1, 1, 0}};
+ 	uint8_t bits[11];
+};

+/* Short opcodes for the c46 */
static struct seeprom_cmd seeprom_ewen = {9, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
static struct seeprom_cmd seeprom_ewds = {9, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
+
+/* Long opcodes for the C56/C66 */
+static struct seeprom_cmd seeprom_long_ewen = {11, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
+static struct seeprom_cmd seeprom_long_ewds = {11, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
+
+/* Common opcodes */
static struct seeprom_cmd seeprom_write = {3, {1, 0, 1}};
+static struct seeprom_cmd seeprom_read  = {3, {1, 1, 0}};

/*
  * Wait for the SEERDY to go high; about 800 ns.
@@ -222,12 +230,25 @@
ahc_write_seeprom(struct seeprom_descriptor *sd, uint16_t *buf,
		  u_int start_addr, u_int count)
{
+	struct seeprom_cmd *ewen, *ewds;
	uint16_t v;
	uint8_t temp;
	int i, k;

	/* Place the chip into write-enable mode */
-	send_seeprom_cmd(sd, &seeprom_ewen);
+	if (sd->sd_chip == C46) {
+		ewen = &seeprom_ewen;
+		ewds = &seeprom_ewds;
+	} else if (sd->sd_chip == C56_66) {
+		ewen = &seeprom_long_ewen;
+		ewds = &seeprom_long_ewds;
+	} else {
+		printf("ahc_write_seeprom: unsupported seeprom type %d\n",
+		       sd->sd_chip);
+		return (0);
+	}
+
+	send_seeprom_cmd(sd, ewen);
	reset_seeprom(sd);

	/* Write all requested data out to the seeprom. */
@@ -277,7 +298,7 @@
	}

	/* Put the chip back into write-protect mode */
-	send_seeprom_cmd(sd, &seeprom_ewds);
+	send_seeprom_cmd(sd, ewds);
	reset_seeprom(sd);

	return (1);
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#135 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.26212.6	2004-09-27 12:48:00.150310248 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-08-07 17:50:20.000000000 -0400
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#135 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#136 $
  *
  * $FreeBSD$
  */
@@ -6844,19 +6844,16 @@
ahc_timeout(struct scb *scb)
{
	struct ahc_softc *ahc;
-	u_long s;

	ahc = scb->ahc_softc;
-	ahc_lock(ahc, &s);
	if ((scb->flags & SCB_ACTIVE) != 0) {
-		if ((scb->flags & SCB_TIMEDOUT) != 0) {
+		if ((scb->flags & SCB_TIMEDOUT) == 0) {
			LIST_INSERT_HEAD(&ahc->timedout_scbs, scb,
					 timedout_links);
			scb->flags |= SCB_TIMEDOUT;
		}
		ahc_wakeup_recovery_thread(ahc);
	}
-	ahc_unlock(ahc, &s);
}

/*
@@ -7131,14 +7128,14 @@
	}
	
	/*
-	 * Any remaining SCBs were not the "culprit", so give
-	 * them a new lease on life.
+	 * Any remaining SCBs were not the "culprit", so remove
+	 * them from the timeout list.  The timer for these commands
+	 * will be reset once the recovery SCB completes.
	 */
	while ((scb = LIST_FIRST(&ahc->timedout_scbs)) != NULL) {

		LIST_REMOVE(scb, timedout_links);
		scb->flags &= ~SCB_TIMEDOUT;
-		ahc_scb_timer_reset(scb, ahc_get_timeout(scb));
	}

	if (restart_needed)
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#236 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26212.7	2004-09-27 12:48:00.756218136 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-08-19 17:37:57.000000000 -0400
@@ -1,7 +1,7 @@
/*
  * Adaptec AIC7xxx device driver for Linux.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#236 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#238 $
  *
  * Copyright (c) 1994 John Aycock
  *   The University of Calgary Department of Computer Science.
@@ -878,8 +878,32 @@
			ahc_unlock(ahc, &s);
			break;
		}
+
+		/*
+		 * Don't bother the recovery handler if the
+		 * list has been cleared by a previous run
+		 * of the handler.  This can happen when
+		 * several SCBs timeout before our handler
+		 * can run causing our semaphore to be up'ed
+		 * repeatedly.  The extra calls need to be
+		 * avoided so that the recovery handler doesn't
+		 * confuse this case with timeouts occuring
+		 * due to interrupts failing to function.
+		 */
+		if (LIST_EMPTY(&ahc->timedout_scbs) != 0) {
+			ahc_unlock(ahc, &s);
+			continue;
+		}
		ahc_unlock(ahc, &s);
		ahc_recover_commands(ahc);
+
+		/*
+		 * Process any pent up completions.
+		 */
+		ahc_lock(ahc, &s);
+		ahc_schedule_runq(ahc);
+		ahc_linux_run_complete_queue(ahc);
+		ahc_unlock(ahc, &s);
	}
	up(&ahc->platform_data->recovery_ending_sem);
	return(0);
@@ -961,7 +985,7 @@
		LIST_FOREACH(list_scb, &ahc->pending_scbs, pending_links) {

			scsi_delete_timer(list_scb->io_ctx);
-			scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
+			list_scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
		}
	}
}
@@ -970,15 +994,27 @@
ahc_platform_timeout(struct scsi_cmnd *cmd)
{

-	if (AHC_DV_CMD(cmd) == 0) {
+	if (AHC_DV_CMD(cmd) != 0) {

		ahc_linux_dv_timeout(cmd);
	} else {
		struct	scb *scb;
+		struct	ahc_softc *ahc;
+		u_long	s;

		scb = (struct scb *)cmd->host_scribble;
-		scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
-		ahc_timeout(scb);
+		ahc = scb->ahc_softc;
+		ahc_lock(ahc, &s);
+
+		/*
+		 * Skip timeouts that fire just after
+		 * they have been cancelled.
+		 */
+		if ((scb->platform_data->flags & AHC_TIMEOUT_ACTIVE) != 0) {
+			scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
+			ahc_timeout(scb);
+		}
+		ahc_unlock(ahc, &s);
	}
}

@@ -1185,6 +1221,7 @@
		printf("%s: aic7xxx_linux_queue -"
		       "CDB length of %d exceeds max!\n",
		       ahc_name(ahc), cmd->cmd_len);
+		return (0);
	}

	/*
@@ -4318,6 +4355,8 @@
	struct	   ahc_linux_device *dev;

	LIST_REMOVE(scb, pending_links);
+	if ((scb->flags & SCB_TIMEDOUT) != 0)
+		LIST_REMOVE(scb, timedout_links);
	if ((scb->flags & SCB_UNTAGGEDQ) != 0) {
		struct scb_tailq *untagged_q;
		int target_offset;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#152 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26212.8	2004-09-27 12:48:00.869200960 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-08-12 14:22:12.000000000 -0400
@@ -53,7 +53,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#152 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#153 $
  *
  */
#ifndef _AIC7XXX_LINUX_H_
@@ -278,7 +278,7 @@
#define AHC_SCSI_HAS_HOST_LOCK 0
#endif

-#define AIC7XXX_DRIVER_VERSION "6.2.36"
+#define AIC7XXX_DRIVER_VERSION "6.2.37"

/**************************** Front End Queues ********************************/
/*
==== //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#69 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c ====
--- /tmp/tmp.26212.9	2004-09-27 12:48:01.102165544 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c	2003-08-08 19:11:01.000000000 -0400
@@ -39,7 +39,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#69 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#70 $
  *
  * $FreeBSD$
  */
@@ -1388,6 +1388,10 @@
			sd.sd_chip = C56_66;
		}
		ahc_release_seeprom(&sd);
+
+		/* Remember the SEEPROM type for later */
+		if (sd.sd_chip == C56_66)
+			ahc->flags |= AHC_LARGE_SEEPROM;
	}

	if (!have_seeprom) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#29 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_proc.c ====
--- /tmp/tmp.26212.10	2004-09-27 12:48:01.246143656 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_proc.c	2003-08-08 19:08:46.000000000 -0400
@@ -37,7 +37,7 @@
  * String handling code courtesy of Gerard Roudier's <groudier@club-internet.fr>
  * sym driver.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#29 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_proc.c#30 $
  */
#include "aic7xxx_osm.h"
#include "aic7xxx_inline.h"
@@ -204,7 +204,8 @@
		ahc_pause(ahc);

	if (length != sizeof(struct seeprom_config)) {
-		printf("ahc_proc_write_seeprom: incorrect buffer size\n");
+		printf("ahc_proc_write_seeprom: incorrect buffer size %d\n",
+		       length);
		goto done;
	}



