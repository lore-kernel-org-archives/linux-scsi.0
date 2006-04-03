From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic79xx bus reset update
Date: Mon, 03 Apr 2006 08:19:34 +0200
Message-ID: <4430BE76.5010209@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010703040408080802020300"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:26274 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751558AbWDCGTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 02:19:47 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 2555F1D79B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2006 08:19:35 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010703040408080802020300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

as James B. noted bus reset has to be protected by a lock to prevent
access to the sequencer during reset.

However, the main reason of _not_ holding the lock there was this very
curious 'poll till bus reset is gone' feature in ahd_reset_channel(),
which would deadlock if the procedure was called with ahd_lock held.

So I've reworked this 'feature' to just use a flag to signify 'the bus
has just been reset by us, ignore any incoming external resets'. This
should be equivalent in functionality but won't deadlock as the flag is
tested in the main SCSI interrupt routine.
I still wonder whether we need this functionality at all. The original
code will only trigger on very specialized cases (bus reset followed by
continuous external resets), and this smells like it would trigger
various other effects, too.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------010703040408080802020300
Content-Type: text/plain;
 name="aic79xx-update-bus-reset-handling"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-update-bus-reset-handling"

From: Hannes Reinecke <hare@suse.de>
Subject: Update aic79xx bus reset handling

As James B. correctly noted, ahd_reset_channel() in
ahd_linux_bus_reset() should be protected by ahd_lock().
However, the main reason for not doing so was a deadlock
with the interesting polling mechanism to detect the end
a bus reset.
This patch replaces the polling mechanism with a saner
signalling via flags; it also gives us the benefit of detecting
any multiple calls to ahd_reset_channel().

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 1d11f7e..933e510 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -372,7 +372,7 @@ typedef enum {
 	AHD_CURRENT_SENSING   = 0x40000,
 	AHD_SCB_CONFIG_USED   = 0x80000,/* No SEEPROM but SCB had info. */
 	AHD_HP_BOARD	      = 0x100000,
-	AHD_RESET_POLL_ACTIVE = 0x200000,
+	AHD_BUS_RESET_ACTIVE  = 0x200000,
 	AHD_UPDATE_PEND_CMDS  = 0x400000,
 	AHD_RUNNING_QOUTFIFO  = 0x800000,
 	AHD_HAD_FIRST_SEL     = 0x1000000
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 326a622..880a10d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -207,7 +207,6 @@ static void		ahd_add_scb_to_free_list(st
 static u_int		ahd_rem_wscb(struct ahd_softc *ahd, u_int scbid,
 				     u_int prev, u_int next, u_int tid);
 static void		ahd_reset_current_bus(struct ahd_softc *ahd);
-static ahd_callback_t	ahd_reset_poll;
 static ahd_callback_t	ahd_stat_timer;
 #ifdef AHD_DUMP_SEQ
 static void		ahd_dumpseq(struct ahd_softc *ahd);
@@ -1534,6 +1533,18 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 	lqistat1 = ahd_inb(ahd, LQISTAT1);
 	lqostat0 = ahd_inb(ahd, LQOSTAT0);
 	busfreetime = ahd_inb(ahd, SSTAT2) & BUSFREETIME;
+
+	/*
+	 * Ignore external resets after a bus reset.
+	 */
+	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE))
+		return;
+
+	/*
+	 * Clear bus reset flag
+	 */
+	ahd->flags &= ~AHD_BUS_RESET_ACTIVE;
+
 	if ((status0 & (SELDI|SELDO)) != 0) {
 		u_int simode0;
 
@@ -7847,6 +7858,17 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	int	found;
 	u_int	fifo;
 	u_int	next_fifo;
+	uint8_t scsiseq;
+
+	/*
+	 * Check if the last bus reset is cleared
+	 */
+	if (ahd->flags & AHD_BUS_RESET_ACTIVE) {
+		printf("%s: bus reset still active\n",
+		       ahd_name(ahd));
+		return 0;
+	}
+	ahd->flags |= AHD_BUS_RESET_ACTIVE;
 
 	ahd->pending_device = NULL;
 
@@ -7860,6 +7882,12 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	/* Make sure the sequencer is in a safe location. */
 	ahd_clear_critical_section(ahd);
 
+	/*
+	 * Run our command complete fifos to ensure that we perform
+	 * completion processing on any commands that 'completed'
+	 * before the reset occurred.
+	 */
+	ahd_run_qoutfifo(ahd);
 #ifdef AHD_TARGET_MODE
 	if ((ahd->flags & AHD_TARGETROLE) != 0) {
 		ahd_run_tqinfifo(ahd, /*paused*/TRUE);
@@ -7924,30 +7952,14 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	ahd_clear_fifo(ahd, 1);
 
 	/*
-	 * Revert to async/narrow transfers until we renegotiate.
+	 * Reenable selections
 	 */
-	max_scsiid = (ahd->features & AHD_WIDE) ? 15 : 7;
-	for (target = 0; target <= max_scsiid; target++) {
-
-		if (ahd->enabled_targets[target] == NULL)
-			continue;
-		for (initiator = 0; initiator <= max_scsiid; initiator++) {
-			struct ahd_devinfo devinfo;
-
-			ahd_compile_devinfo(&devinfo, target, initiator,
-					    CAM_LUN_WILDCARD,
-					    'A', ROLE_UNKNOWN);
-			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHD_TRANS_CUR, /*paused*/TRUE);
-			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
-					 /*offset*/0, /*ppr_options*/0,
-					 AHD_TRANS_CUR, /*paused*/TRUE);
-		}
-	}
+	ahd_outb(ahd, SIMODE1, ahd_inb(ahd, SIMODE1) | ENSCSIRST);
+	scsiseq = ahd_inb(ahd, SCSISEQ_TEMPLATE);
+	ahd_outb(ahd, SCSISEQ1, scsiseq & (ENSELI|ENRSELI|ENAUTOATNP));
 
-#ifdef AHD_TARGET_MODE
 	max_scsiid = (ahd->features & AHD_WIDE) ? 15 : 7;
-
+#ifdef AHD_TARGET_MODE
 	/*
 	 * Send an immediate notify ccb to all target more peripheral
 	 * drivers affected by this action.
@@ -7975,51 +7987,31 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	/* Notify the XPT that a bus reset occurred */
 	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
 		       CAM_LUN_WILDCARD, AC_BUS_RESET, NULL);
-	ahd_restart(ahd);
+
 	/*
-	 * Freeze the SIMQ until our poller can determine that
-	 * the bus reset has really gone away.  We set the initial
-	 * timer to 0 to have the check performed as soon as possible
-	 * from the timer context.
-	 */
-	if ((ahd->flags & AHD_RESET_POLL_ACTIVE) == 0) {
-		ahd->flags |= AHD_RESET_POLL_ACTIVE;
-		ahd_freeze_simq(ahd);
-		ahd_timer_reset(&ahd->reset_timer, 0, ahd_reset_poll, ahd);
-	}
-	return (found);
-}
+	 * Revert to async/narrow transfers until we renegotiate.
+	 */
+	for (target = 0; target <= max_scsiid; target++) {
 
+		if (ahd->enabled_targets[target] == NULL)
+			continue;
+		for (initiator = 0; initiator <= max_scsiid; initiator++) {
+			struct ahd_devinfo devinfo;
 
-#define AHD_RESET_POLL_US 1000
-static void
-ahd_reset_poll(void *arg)
-{
-	struct	ahd_softc *ahd = arg;
-	u_int	scsiseq1;
-	u_long	s;
-	
-	ahd_lock(ahd, &s);
-	ahd_pause(ahd);
-	ahd_update_modes(ahd);
-	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
-	if ((ahd_inb(ahd, SSTAT1) & SCSIRSTI) != 0) {
-		ahd_timer_reset(&ahd->reset_timer, AHD_RESET_POLL_US,
-				ahd_reset_poll, ahd);
-		ahd_unpause(ahd);
-		ahd_unlock(ahd, &s);
-		return;
+			ahd_compile_devinfo(&devinfo, target, initiator,
+					    CAM_LUN_WILDCARD,
+					    'A', ROLE_UNKNOWN);
+			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
+				      AHD_TRANS_CUR, /*paused*/TRUE);
+			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
+					 /*offset*/0, /*ppr_options*/0,
+					 AHD_TRANS_CUR, /*paused*/TRUE);
+		}
 	}
 
-	/* Reset is now low.  Complete chip reinitialization. */
-	ahd_outb(ahd, SIMODE1, ahd_inb(ahd, SIMODE1) | ENSCSIRST);
-	scsiseq1 = ahd_inb(ahd, SCSISEQ_TEMPLATE);
-	ahd_outb(ahd, SCSISEQ1, scsiseq1 & (ENSELI|ENRSELI|ENAUTOATNP));
-	ahd_unpause(ahd);
-	ahd->flags &= ~AHD_RESET_POLL_ACTIVE;
-	ahd_unlock(ahd, &s);
-	ahd_release_simq(ahd);
+	ahd_restart(ahd);
+
+	return (found);
 }
 
 /**************************** Statistics Processing ***************************/
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index bcced0a..66e4a47 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -782,6 +782,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 {
 	struct ahd_softc *ahd;
 	int    found;
+	unsigned long flags;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 #ifdef AHD_DEBUG
@@ -789,8 +790,11 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		printf("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
+	ahd_lock(ahd, &flags);
+
 	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
+	ahd_unlock(ahd, &flags);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "

--------------010703040408080802020300--
