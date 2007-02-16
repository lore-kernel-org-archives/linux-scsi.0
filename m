From: akpm@linux-foundation.org
Subject: [patch 26/30] drivers/scsi/aic7xxx: Convert to generic boolean-values
Date: Fri, 16 Feb 2007 01:46:44 -0800
Message-ID: <200702160946.l1G9kiN2026700@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423518AbXBPJrD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:47:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ricknu-0@student.ltu.se

From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert:
FALSE -> false
TRUE  -> true

var == FALSE -> !var
var != FALSE -> var
var == TRUE  -> var

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic7770.c              |    4 
 drivers/scsi/aic7xxx/aic7770_osm.c          |    2 
 drivers/scsi/aic7xxx/aic79xx.h              |    7 
 drivers/scsi/aic7xxx/aic79xx_core.c         |  218 ++++++++----------
 drivers/scsi/aic7xxx/aic79xx_inline.h       |    2 
 drivers/scsi/aic7xxx/aic79xx_osm.c          |   60 ++--
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c      |    2 
 drivers/scsi/aic7xxx/aic79xx_pci.c          |    6 
 drivers/scsi/aic7xxx/aic79xx_proc.c         |    4 
 drivers/scsi/aic7xxx/aic7xxx.h              |    7 
 drivers/scsi/aic7xxx/aic7xxx_core.c         |  179 +++++++-------
 drivers/scsi/aic7xxx/aic7xxx_inline.h       |    2 
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |   56 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c      |    2 
 drivers/scsi/aic7xxx/aic7xxx_pci.c          |   30 +-
 drivers/scsi/aic7xxx/aic7xxx_proc.c         |    4 
 drivers/scsi/aic7xxx/aicasm/aicasm.c        |    2 
 drivers/scsi/aic7xxx/aicasm/aicasm.h        |    8 
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y   |   24 -
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l   |    4 
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c |    4 
 21 files changed, 301 insertions(+), 326 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7770.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7770.c
--- a/drivers/scsi/aic7xxx/aic7770.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7770.c
@@ -147,7 +147,7 @@ aic7770_config(struct ahc_softc *ahc, st
 	 * a misstep to hang the machine in an interrupt
 	 * storm.
 	 */
-	ahc_intr_enable(ahc, FALSE);
+	ahc_intr_enable(ahc, false);
 
 	ahc->description = entry->name;
 	error = ahc_softc_init(ahc);
@@ -158,7 +158,7 @@ aic7770_config(struct ahc_softc *ahc, st
 	ahc->bus_suspend = aic7770_suspend;
 	ahc->bus_resume = aic7770_resume;
 
-	error = ahc_reset(ahc, /*reinit*/FALSE);
+	error = ahc_reset(ahc, /*reinit*/false);
 	if (error != 0)
 		return (error);
 
diff -puN drivers/scsi/aic7xxx/aic7770_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7770_osm.c
--- a/drivers/scsi/aic7xxx/aic7770_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -116,7 +116,7 @@ aic7770_remove(struct device *dev)
 			scsi_remove_host(ahc->platform_data->host);
 
 	ahc_lock(ahc, &s);
-	ahc_intr_enable(ahc, FALSE);
+	ahc_intr_enable(ahc, false);
 	ahc_unlock(ahc, &s);
 
 	ahc_free(ahc);
diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx.h
@@ -53,13 +53,6 @@ struct ahd_platform_data;
 struct scb_platform_data;
 
 /****************************** Useful Macros *********************************/
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define ALL_CHANNELS '\0'
 #define ALL_TARGETS_MASK 0xFFFF
 #define INITIATOR_WILDCARD	(~0)
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1088,7 +1088,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 		if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
 			ahd_dump_card_state(ahd);
 #endif
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 		break;
 	case STATUS_OVERRUN:
 	{
@@ -1103,7 +1103,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 			printf("%s: ", ahd_name(ahd));
 		printf("SCB %d Packetized Status Overrun", scbid);
 		ahd_dump_card_state(ahd);
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 		break;
 	}
 	case CFG4ISTAT_INTR:
@@ -1141,7 +1141,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 		case P_MESGOUT:
 		case P_STATUS:
 		case P_MESGIN:
-			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 			printf("%s: Issued Bus Reset.\n", ahd_name(ahd));
 			break;
 		case P_COMMAND:
@@ -1170,7 +1170,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 				printf("Invalid phase with no valid SCB.  "
 				       "Resetting bus.\n");
 				ahd_reset_channel(ahd, 'A',
-						  /*Initiate Reset*/TRUE);
+						  /*Initiate Reset*/true);
 				break;
 			}
 			ahd_compile_devinfo(&devinfo, SCB_GET_OUR_ID(scb),
@@ -1185,10 +1185,10 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 							&tstate);
 			tinfo = &targ_info->curr;
 			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHD_TRANS_ACTIVE, /*paused*/TRUE);
+				      AHD_TRANS_ACTIVE, /*paused*/true);
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
 					 /*offset*/0, /*ppr_options*/0,
-					 AHD_TRANS_ACTIVE, /*paused*/TRUE);
+					 AHD_TRANS_ACTIVE, /*paused*/true);
 			/* Hand-craft TUR command */
 			ahd_outb(ahd, SCB_CDB_STORE, 0);
 			ahd_outb(ahd, SCB_CDB_STORE+1, 0);
@@ -1680,7 +1680,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 		/*
 		 * A change in I/O mode is equivalent to a bus reset.
 		 */
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 		ahd_pause(ahd);
 		ahd_setup_iocell_workaround(ahd);
 		ahd_unpause(ahd);
@@ -1688,11 +1688,11 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 
 		printf("%s: SCSI offset overrun detected.  Resetting bus.\n",
 		       ahd_name(ahd));
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 	} else if ((status & SCSIRSTI) != 0) {
 
 		printf("%s: Someone reset channel A\n", ahd_name(ahd));
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/FALSE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/false);
 	} else if ((status & SCSIPERR) != 0) {
 
 		/* Make sure the sequencer is in a safe location. */
@@ -1955,7 +1955,7 @@ ahd_handle_transmission_error(struct ahd
 	/*
 	 * Try to find the SCB associated with this error.
 	 */
-	silent = FALSE;
+	silent = false;
 	if (lqistat1 == 0
 	 || (lqistat1 & LQICRCI_NLQ) != 0) {
 	 	if ((lqistat1 & (LQICRCI_NLQ|LQIOVERI_NLQ)) != 0)
@@ -1963,11 +1963,11 @@ ahd_handle_transmission_error(struct ahd
 		scbid = ahd_get_scbptr(ahd);
 		scb = ahd_lookup_scb(ahd, scbid);
 		if (scb != NULL && SCB_IS_SILENT(scb))
-			silent = TRUE;
+			silent = true;
 	}
 
 	cur_col = 0;
-	if (silent == FALSE) {
+	if (!silent) {
 		printf("%s: Transmission error detected\n", ahd_name(ahd));
 		ahd_lqistat1_print(lqistat1, &cur_col, 50);
 		ahd_lastphase_print(lastphase, &cur_col, 50);
@@ -1978,12 +1978,12 @@ ahd_handle_transmission_error(struct ahd
 	}
 
 	if ((lqistat1 & (LQIOVERI_LQ|LQIOVERI_NLQ)) != 0) {
-		if (silent == FALSE) {
+		if (!silent) {
 			printf("%s: Gross protocol error during incoming "
 			       "packet.  lqistat1 == 0x%x.  Resetting bus.\n",
 			       ahd_name(ahd), lqistat1);
 		}
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 		return;
 	} else if ((lqistat1 & LQICRCI_LQ) != 0) {
 		/*
@@ -2055,22 +2055,22 @@ ahd_handle_transmission_error(struct ahd
 		 * listed above for the read streaming with P0 asserted.
 		 * Busfree detection is enabled.
 		 */
-		if (silent == FALSE)
+		if (!silent)
 			printf("LQICRC_NLQ\n");
 		if (scb == NULL) {
 			printf("%s: No SCB valid for LQICRC_NLQ.  "
 			       "Resetting bus\n", ahd_name(ahd));
-			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 			return;
 		}
 	} else if ((lqistat1 & LQIBADLQI) != 0) {
 		printf("Need to handle BADLQI!\n");
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 		return;
 	} else if ((perrdiag & (PARITYERR|PREVPHASE)) == PARITYERR) {
 		if ((curphase & ~P_DATAIN_DT) != 0) {
 			/* Ack the byte.  So we can continue. */
-			if (silent == FALSE)
+			if (!silent)
 				printf("Acking %s to clear perror\n",
 				    ahd_lookup_phase_entry(curphase)->phasemsg);
 			ahd_inb(ahd, SCSIDAT);
@@ -2129,7 +2129,7 @@ ahd_handle_lqiphase_error(struct ahd_sof
 	} else {
 		printf("Reseting Channel for LQI Phase error\n");
 		ahd_dump_card_state(ahd);
-		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/true);
 	}
 }
 
@@ -2213,7 +2213,7 @@ ahd_handle_pkt_busfree(struct ahd_softc 
 		}
 		ahd_set_scbptr(ahd, saved_scbptr);
 		if (scb->crc_retry_count < AHD_MAX_LQ_CRC_ERRORS) {
-			if (SCB_IS_SILENT(scb) == FALSE) {
+			if (!SCB_IS_SILENT(scb)) {
 				ahd_print_path(ahd, scb);
 				printf("Probable outgoing LQ CRC error.  "
 				       "Retrying command\n");
@@ -2308,8 +2308,8 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 		u_int tag;
 
 		tag = SCB_LIST_NULL;
-		if (ahd_sent_msg(ahd, AHDMSG_1B, MSG_ABORT_TAG, TRUE)
-		 || ahd_sent_msg(ahd, AHDMSG_1B, MSG_ABORT, TRUE)) {
+		if (ahd_sent_msg(ahd, AHDMSG_1B, MSG_ABORT_TAG, true)
+		 || ahd_sent_msg(ahd, AHDMSG_1B, MSG_ABORT, true)) {
 			int found;
 			int sent_msg;
 
@@ -2351,7 +2351,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			printf("found == 0x%x\n", found);
 			printerror = 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_1B,
-					MSG_BUS_DEV_RESET, TRUE)) {
+					MSG_BUS_DEV_RESET, true)) {
 #ifdef __FreeBSD__
 			/*
 			 * Don't mark the user's request for this BDR
@@ -2369,7 +2369,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 					    CAM_BDR_SENT, "Bus Device Reset",
 					    /*verbose_level*/0);
 			printerror = 0;
-		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, FALSE)
+		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, false)
 			&& ppr_busfree == 0) {
 			struct ahd_initiator_tinfo *tinfo;
 			struct ahd_tmode_tstate *tstate;
@@ -2395,12 +2395,12 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 				ahd_set_width(ahd, &devinfo,
 					      MSG_EXT_WDTR_BUS_8_BIT,
 					      AHD_TRANS_CUR,
-					      /*paused*/TRUE);
+					      /*paused*/true);
 				ahd_set_syncrate(ahd, &devinfo,
 						/*period*/0, /*offset*/0,
 						/*ppr_options*/0,
 						AHD_TRANS_CUR,
-						/*paused*/TRUE);
+						/*paused*/true);
 				/*
 				 * The expect PPR busfree handler below
 				 * will effect the retry and necessary
@@ -2419,7 +2419,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 				ahd_qinfifo_requeue_tail(ahd, scb);
 				printerror = 0;
 			}
-		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, FALSE)
+		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, false)
 			&& ppr_busfree == 0) {
 			/*
 			 * Negotiation Rejected.  Go-narrow and
@@ -2432,7 +2432,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			ahd_set_width(ahd, &devinfo,
 				      MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_CUR|AHD_TRANS_GOAL,
-				      /*paused*/TRUE);
+				      /*paused*/true);
 			/*
 			 * Remove any SCBs in the waiting for selection
 			 * queue that may also be for this target so that
@@ -2441,7 +2441,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			ahd_freeze_devq(ahd, scb);
 			ahd_qinfifo_requeue_tail(ahd, scb);
 			printerror = 0;
-		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, FALSE)
+		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, false)
 			&& ppr_busfree == 0) {
 			/*
 			 * Negotiation Rejected.  Go-async and
@@ -2455,7 +2455,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 					/*period*/0, /*offset*/0,
 					/*ppr_options*/0,
 					AHD_TRANS_CUR|AHD_TRANS_GOAL,
-					/*paused*/TRUE);
+					/*paused*/true);
 			/*
 			 * Remove any SCBs in the waiting for selection
 			 * queue that may also be for this target so that
@@ -2466,7 +2466,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			printerror = 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_IDE_BUSFREE) != 0
 			&& ahd_sent_msg(ahd, AHDMSG_1B,
-					 MSG_INITIATOR_DET_ERR, TRUE)) {
+					 MSG_INITIATOR_DET_ERR, true)) {
 
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
@@ -2475,7 +2475,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			printerror = 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_QASREJ_BUSFREE)
 			&& ahd_sent_msg(ahd, AHDMSG_1B,
-					MSG_MESSAGE_REJECT, TRUE)) {
+					MSG_MESSAGE_REJECT, true)) {
 
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
@@ -2614,7 +2614,7 @@ proto_violation_reset:
 		 * The only safe thing to do is to blow
 		 * it away with a bus reset.
 		 */
-		found = ahd_reset_channel(ahd, 'A', TRUE);
+		found = ahd_reset_channel(ahd, 'A', true);
 		printf("%s: Issued Channel %c Bus Reset. "
 		       "%d SCBs aborted\n", ahd_name(ahd), 'A', found);
 	} else {
@@ -2686,7 +2686,7 @@ ahd_clear_critical_section(struct ahd_so
 	if (ahd->num_critical_sections == 0)
 		return;
 
-	stepping = FALSE;
+	stepping = false;
 	steps = 0;
 	first_instr = 0;
 	simode0 = 0;
@@ -2730,7 +2730,7 @@ ahd_clear_critical_section(struct ahd_so
 			printf("%s: Single stepping at 0x%x\n", ahd_name(ahd),
 			       seqaddr);
 #endif
-		if (stepping == FALSE) {
+		if (!stepping) {
 
 			first_instr = seqaddr;
   			ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
@@ -2756,7 +2756,7 @@ ahd_clear_critical_section(struct ahd_so
 			 */
 			ahd_outb(ahd, SIMODE1, simode1 & ENBUSFREE);
 			ahd_outb(ahd, SEQCTL0, ahd_inb(ahd, SEQCTL0) | STEP);
-			stepping = TRUE;
+			stepping = true;
 		}
 		ahd_outb(ahd, CLRSINT1, CLRBUSFREE);
 		ahd_outb(ahd, CLRINT, CLRSCSIINT);
@@ -2906,8 +2906,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u
 	 * Don't clean up our "master" tstate.
 	 * It has our default user settings.
 	 */
-	if (scsi_id == ahd->our_id
-	 && force == FALSE)
+	if (scsi_id == ahd->our_id && !force)
 		return;
 
 	tstate = ahd->enabled_targets[scsi_id];
@@ -3947,7 +3946,7 @@ ahd_handle_message_phase(struct ahd_soft
 	int	end_session;
 
 	ahd_fetch_devinfo(ahd, &devinfo);
-	end_session = FALSE;
+	end_session = false;
 	bus_phase = ahd_inb(ahd, LASTPHASE);
 
 	if ((ahd_inb(ahd, LQISTAT2) & LQIPHASE_OUTPKT) != 0) {
@@ -3993,7 +3992,7 @@ reswitch:
 				ahd->msgin_index = 0;
 				goto reswitch;
 			}
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -4078,7 +4077,7 @@ reswitch:
 				ahd->msg_type = MSG_TYPE_INITIATOR_MSGOUT;
 				goto reswitch;
 			}
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -4117,7 +4116,7 @@ reswitch:
 			ahd->msgin_index++;
 
 		if (message_done == MSGLOOP_TERMINATED) {
-			end_session = TRUE;
+			end_session = true;
 		} else {
 			/* Ack the byte */
 			ahd_outb(ahd, CLRSINT1, CLRREQINIT);
@@ -4146,9 +4145,9 @@ reswitch:
 		 */
 		if ((ahd_inb(ahd, SCSISIGI) & ATNI) != 0
 		 && ahd->msgout_index > 0)
-			msgout_request = TRUE;
+			msgout_request = true;
 		else
-			msgout_request = FALSE;
+			msgout_request = false;
 
 		if (msgout_request) {
 
@@ -4172,7 +4171,7 @@ reswitch:
 		if (msgdone) {
 			ahd_outb(ahd, SXFRCTL0,
 				 ahd_inb(ahd, SXFRCTL0) & ~SPIOEN);
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -4241,7 +4240,7 @@ reswitch:
 		}
 
 		if (lastbyte)
-			end_session = TRUE;
+			end_session = true;
 		else {
 			/* Ask for the next byte. */
 			ahd_outb(ahd, SXFRCTL0,
@@ -4285,7 +4284,7 @@ ahd_sent_msg(struct ahd_softc *ahd, ahd_
 	int found;
 	u_int index;
 
-	found = FALSE;
+	found = false;
 	index = 0;
 
 	while (index < ahd->msgout_len) {
@@ -4298,9 +4297,9 @@ ahd_sent_msg(struct ahd_softc *ahd, ahd_
 
 				if (full) {
 					if (ahd->msgout_index > end_index)
-						found = TRUE;
+						found = true;
 				} else if (ahd->msgout_index > index)
-					found = TRUE;
+					found = true;
 			}
 			index = end_index;
 		} else if (ahd->msgout_buf[index] >= MSG_SIMPLE_TASK
@@ -4315,7 +4314,7 @@ ahd_sent_msg(struct ahd_softc *ahd, ahd_
 			 && (ahd->msgout_buf[index] == msgval
 			  || ((ahd->msgout_buf[index] & MSG_IDENTIFYFLAG) != 0
 			   && msgval == MSG_IDENTIFYFLAG)))
-				found = TRUE;
+				found = true;
 			index++;
 		}
 
@@ -4338,8 +4337,8 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 	int	response;
 
 	done = MSGLOOP_IN_PROG;
-	response = FALSE;
-	reject = FALSE;
+	response = false;
+	reject = false;
 	tinfo = ahd_fetch_transinfo(ahd, devinfo->channel, devinfo->our_scsiid,
 				    devinfo->target, &tstate);
 
@@ -4386,7 +4385,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			u_int	 saved_offset;
 			
 			if (ahd->msgin_buf[1] != MSG_EXT_SDTR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -4419,18 +4418,18 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			ahd_set_syncrate(ahd, devinfo, period,
 					 offset, ppr_options,
 					 AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-					 /*paused*/TRUE);
+					 /*paused*/true);
 
 			/*
 			 * See if we initiated Sync Negotiation
 			 * and didn't have to fall down to async
 			 * transfers.
 			 */
-			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, TRUE)) {
+			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, true)) {
 				/* We started it */
 				if (saved_offset != offset) {
 					/* Went too low - force async */
-					reject = TRUE;
+					reject = true;
 				}
 			} else {
 				/*
@@ -4448,7 +4447,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				ahd_construct_sdtr(ahd, devinfo,
 						   period, offset);
 				ahd->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
@@ -4459,9 +4458,9 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			u_int saved_width;
 			u_int sending_reply;
 
-			sending_reply = FALSE;
+			sending_reply = false;
 			if (ahd->msgin_buf[1] != MSG_EXT_WDTR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -4487,7 +4486,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				       saved_width, bus_width);
 			}
 
-			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, TRUE)) {
+			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, true)) {
 				/*
 				 * Don't send a WDTR back to the
 				 * target, since we asked first.
@@ -4495,7 +4494,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				 * request, reject it.
 				 */
 				if (saved_width > bus_width) {
-					reject = TRUE;
+					reject = true;
 					printf("(%s:%c:%d:%d): requested %dBit "
 					       "transfers.  Rejecting...\n",
 					       ahd_name(ahd), devinfo->channel,
@@ -4518,8 +4517,8 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				ahd->msgout_len = 0;
 				ahd_construct_wdtr(ahd, devinfo, bus_width);
 				ahd->msgout_index = 0;
-				response = TRUE;
-				sending_reply = TRUE;
+				response = true;
+				sending_reply = true;
 			}
 			/*
 			 * After a wide message, we are async, but
@@ -4534,8 +4533,8 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 					       tinfo, AHD_NEG_ALWAYS);
 			ahd_set_width(ahd, devinfo, bus_width,
 				      AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-				      /*paused*/TRUE);
-			if (sending_reply == FALSE && reject == FALSE) {
+				      /*paused*/true);
+			if (!sending_reply && !reject) {
 
 				/*
 				 * We will always have an SDTR to send.
@@ -4544,7 +4543,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				ahd->msgout_len = 0;
 				ahd_build_transfer_msg(ahd, devinfo);
 				ahd->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
@@ -4560,7 +4559,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			u_int	saved_ppr_options;
 
 			if (ahd->msgin_buf[1] != MSG_EXT_PPR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -4604,7 +4603,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			ahd_validate_offset(ahd, tinfo, period, &offset,
 					    bus_width, devinfo->role);
 
-			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, TRUE)) {
+			if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, true)) {
 				/*
 				 * If we are unable to do any of the
 				 * requested options (we went too low),
@@ -4613,7 +4612,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				if (saved_width > bus_width
 				 || saved_offset != offset
 				 || saved_ppr_options != ppr_options) {
-					reject = TRUE;
+					reject = true;
 					period = 0;
 					offset = 0;
 					bus_width = 0;
@@ -4635,7 +4634,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 				ahd_construct_ppr(ahd, devinfo, period, offset,
 						  bus_width, ppr_options);
 				ahd->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			if (bootverbose) {
 				printf("(%s:%c:%d:%d): Received PPR width %x, "
@@ -4650,18 +4649,18 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 			}
 			ahd_set_width(ahd, devinfo, bus_width,
 				      AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-				      /*paused*/TRUE);
+				      /*paused*/true);
 			ahd_set_syncrate(ahd, devinfo, period,
 					 offset, ppr_options,
 					 AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-					 /*paused*/TRUE);
+					 /*paused*/true);
 
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
 		}
 		default:
 			/* Unknown extended message.  Reject it. */
-			reject = TRUE;
+			reject = true;
 			break;
 		}
 		break;
@@ -4683,7 +4682,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 
 		/* Target mode messages */
 		if (devinfo->role != ROLE_TARGET) {
-			reject = TRUE;
+			reject = true;
 			break;
 		}
 		tag = SCB_LIST_NULL;
@@ -4721,7 +4720,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 		/* FALLTHROUGH */
 	case MSG_TERM_IO_PROC:
 	default:
-		reject = TRUE;
+		reject = true;
 		break;
 	}
 
@@ -4733,7 +4732,7 @@ ahd_parse_msg(struct ahd_softc *ahd, str
 		ahd->msgout_len = 1;
 		ahd->msgout_buf[0] = MSG_MESSAGE_REJECT;
 		done = MSGLOOP_MSGCOMPLETE;
-		response = TRUE;
+		response = true;
 	}
 
 	if (done != MSGLOOP_IN_PROG && !response)
@@ -4770,8 +4769,8 @@ ahd_handle_msg_reject(struct ahd_softc *
 	/* Might be necessary */
 	last_msg = ahd_inb(ahd, LAST_MSG);
 
-	if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, /*full*/FALSE)) {
-		if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, /*full*/TRUE)
+	if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, /*full*/false)) {
+		if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_PPR, /*full*/true)
 		 && tinfo->goal.period <= AHD_SYNCRATE_PACED) {
 			/*
 			 * Target may not like our SPI-4 PPR Options.
@@ -4808,7 +4807,7 @@ ahd_handle_msg_reject(struct ahd_softc *
 		ahd_build_transfer_msg(ahd, devinfo);
 		ahd->msgout_index = 0;
 		response = 1;
-	} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, /*full*/FALSE)) {
+	} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, /*full*/false)) {
 
 		/* note 8bit xfers */
 		printf("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
@@ -4816,7 +4815,7 @@ ahd_handle_msg_reject(struct ahd_softc *
 		       devinfo->channel, devinfo->target, devinfo->lun);
 		ahd_set_width(ahd, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
 			      AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-			      /*paused*/TRUE);
+			      /*paused*/true);
 		/*
 		 * No need to clear the sync rate.  If the target
 		 * did not accept the command, our syncrate is
@@ -4833,12 +4832,12 @@ ahd_handle_msg_reject(struct ahd_softc *
 			ahd->msgout_index = 0;
 			response = 1;
 		}
-	} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, /*full*/FALSE)) {
+	} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, /*full*/false)) {
 		/* note asynch xfers and clear flag */
 		ahd_set_syncrate(ahd, devinfo, /*period*/0,
 				 /*offset*/0, /*ppr_options*/0,
 				 AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
-				 /*paused*/TRUE);
+				 /*paused*/true);
 		printf("(%s:%c:%d:%d): refuses synchronous negotiation. "
 		       "Using asynchronous transfers\n",
 		       ahd_name(ahd), devinfo->channel,
@@ -4872,7 +4871,7 @@ ahd_handle_msg_reject(struct ahd_softc *
 		ahd_outb(ahd, SCB_CONTROL,
 			 ahd_inb_scbram(ahd, SCB_CONTROL) & mask);
 	 	scb->hscb->control &= mask;
-		ahd_set_transaction_tag(scb, /*enabled*/FALSE,
+		ahd_set_transaction_tag(scb, /*enabled*/false,
 					/*type*/MSG_SIMPLE_TASK);
 		ahd_outb(ahd, MSG_OUT, MSG_IDENTIFYFLAG);
 		ahd_assert_atn(ahd);
@@ -4889,7 +4888,7 @@ ahd_handle_msg_reject(struct ahd_softc *
 				   SCB_GET_LUN(scb), /*tag*/SCB_LIST_NULL,
 				   ROLE_INITIATOR, CAM_REQUEUE_REQ,
 				   SEARCH_COMPLETE);
-	} else if (ahd_sent_msg(ahd, AHDMSG_1B, MSG_IDENTIFYFLAG, TRUE)) {
+	} else if (ahd_sent_msg(ahd, AHDMSG_1B, MSG_IDENTIFYFLAG, true)) {
 		/*
 		 * Most likely the device believes that we had
 		 * previously negotiated packetized.
@@ -5198,10 +5197,10 @@ ahd_handle_devreset(struct ahd_softc *ah
 	 * Go back to async/narrow transfers and renegotiate.
 	 */
 	ahd_set_width(ahd, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-		      AHD_TRANS_CUR, /*paused*/TRUE);
+		      AHD_TRANS_CUR, /*paused*/true);
 	ahd_set_syncrate(ahd, devinfo, /*period*/0, /*offset*/0,
 			 /*ppr_options*/0, AHD_TRANS_CUR,
-			 /*paused*/TRUE);
+			 /*paused*/true);
 	
 	if (status != CAM_SEL_TIMEOUT)
 		ahd_send_async(ahd, devinfo->channel, devinfo->target,
@@ -5470,7 +5469,7 @@ ahd_shutdown(void *arg)
 	ahd_timer_stop(&ahd->stat_timer);
 
 	/* This will reset most registers to 0, but not all */
-	ahd_reset(ahd, /*reinit*/FALSE);
+	ahd_reset(ahd, /*reinit*/false);
 }
 
 /*
@@ -6823,7 +6822,7 @@ ahd_chip_init(struct ahd_softc *ahd)
 	ahd_update_coalescing_values(ahd, ahd->int_coalescing_timer,
 				     ahd->int_coalescing_maxcmds,
 				     ahd->int_coalescing_mincmds);
-	ahd_enable_coalescing(ahd, FALSE);
+	ahd_enable_coalescing(ahd, false);
 
 	ahd_loadseq(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
@@ -6912,10 +6911,10 @@ ahd_default_config(struct ahd_softc *ahd
 				    'A', ROLE_INITIATOR);
 		tstate->tagenable &= ~target_mask;
 		ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-			      AHD_TRANS_CUR|AHD_TRANS_GOAL, /*paused*/TRUE);
+			      AHD_TRANS_CUR|AHD_TRANS_GOAL, /*paused*/true);
 		ahd_set_syncrate(ahd, &devinfo, /*period*/0, /*offset*/0,
 				 /*ppr_options*/0, AHD_TRANS_CUR|AHD_TRANS_GOAL,
-				 /*paused*/TRUE);
+				 /*paused*/true);
 	}
 	return (0);
 }
@@ -7025,10 +7024,10 @@ ahd_parse_cfgdata(struct ahd_softc *ahd,
 				    targ, CAM_LUN_WILDCARD,
 				    'A', ROLE_INITIATOR);
 		ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-			      AHD_TRANS_CUR|AHD_TRANS_GOAL, /*paused*/TRUE);
+			      AHD_TRANS_CUR|AHD_TRANS_GOAL, /*paused*/true);
 		ahd_set_syncrate(ahd, &devinfo, /*period*/0, /*offset*/0,
 				 /*ppr_options*/0, AHD_TRANS_CUR|AHD_TRANS_GOAL,
-				 /*paused*/TRUE);
+				 /*paused*/true);
 	}
 
 	ahd->flags &= ~AHD_SPCHK_ENB_A;
@@ -7196,8 +7195,8 @@ int
 ahd_resume(struct ahd_softc *ahd)
 {
 
-	ahd_reset(ahd, /*reinit*/TRUE);
-	ahd_intr_enable(ahd, TRUE); 
+	ahd_reset(ahd, /*reinit*/true);
+	ahd_intr_enable(ahd, true);
 	ahd_restart(ahd);
 	return (0);
 }
@@ -7917,8 +7916,8 @@ ahd_reset_current_bus(struct ahd_softc *
 		 * SCSI bus resets that we initiate, so
 		 * we must reset the chip.
 		 */
-		ahd_reset(ahd, /*reinit*/TRUE);
-		ahd_intr_enable(ahd, /*enable*/TRUE);
+		ahd_reset(ahd, /*reinit*/true);
+		ahd_intr_enable(ahd, /*enable*/true);
 		AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
 	}
 
@@ -7967,7 +7966,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	ahd_run_qoutfifo(ahd);
 #ifdef AHD_TARGET_MODE
 	if ((ahd->flags & AHD_TARGETROLE) != 0) {
-		ahd_run_tqinfifo(ahd, /*paused*/TRUE);
+		ahd_run_tqinfifo(ahd, /*paused*/true);
 	}
 #endif
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
@@ -8080,10 +8079,10 @@ ahd_reset_channel(struct ahd_softc *ahd,
 					    CAM_LUN_WILDCARD,
 					    'A', ROLE_UNKNOWN);
 			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHD_TRANS_CUR, /*paused*/TRUE);
+				      AHD_TRANS_CUR, /*paused*/true);
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
 					 /*offset*/0, /*ppr_options*/0,
-					 AHD_TRANS_CUR, /*paused*/TRUE);
+					 AHD_TRANS_CUR, /*paused*/true);
 		}
 	}
 
@@ -8287,7 +8286,7 @@ ahd_handle_scsi_status(struct ahd_softc 
 		scb->sg_count = 0;
 		sg = ahd_sg_setup(ahd, scb, sg, ahd_get_sense_bufaddr(ahd, scb),
 				  ahd_get_sense_bufsize(ahd, scb),
-				  /*last*/TRUE);
+				  /*last*/true);
 		sc->opcode = REQUEST_SENSE;
 		sc->byte2 = 0;
 		if (tinfo->protocol_version <= SCSI_REV_2
@@ -8483,7 +8482,7 @@ ahd_queue_lstate_event(struct ahd_softc 
 		 */
 		lstate->event_r_idx = 0;
 		lstate->event_w_idx = 0;
-		xpt_release_devq(lstate->path, pending, /*runqueue*/FALSE);
+		xpt_release_devq(lstate->path, pending, /*runqueue*/false);
 	}
 
 	if (pending == AHD_TMODE_EVENT_BUFFER_SIZE) {
@@ -8494,7 +8493,7 @@ ahd_queue_lstate_event(struct ahd_softc 
 		lstate->event_r_idx++;
 		if (lstate->event_r_idx == AHD_TMODE_EVENT_BUFFER_SIZE)
 			lstate->event_r_idx = 0;
-		xpt_release_devq(lstate->path, /*count*/1, /*runqueue*/FALSE);
+		xpt_release_devq(lstate->path, /*count*/1, /*runqueue*/false);
 	}
 
 	event = &lstate->event_buffer[lstate->event_w_idx];
@@ -8691,18 +8690,17 @@ ahd_loadseq(struct ahd_softc *ahd)
 		 */
 		for (; cur_cs < num_critical_sections; cur_cs++) {
 			if (critical_sections[cur_cs].end <= i) {
-				if (begin_set[cs_count] == TRUE
-				 && end_set[cs_count] == FALSE) {
+				if (begin_set[cs_count] && !end_set[cs_count]) {
 					cs_table[cs_count].end = downloaded;
-				 	end_set[cs_count] = TRUE;
+					end_set[cs_count] = true;
 					cs_count++;
 				}
 				continue;
 			}
 			if (critical_sections[cur_cs].begin <= i
-			 && begin_set[cs_count] == FALSE) {
+			 && !begin_set[cs_count]) {
 				cs_table[cs_count].begin = downloaded;
-				begin_set[cs_count] = TRUE;
+				begin_set[cs_count] = true;
 			}
 			break;
 		}
@@ -9550,7 +9548,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd,
 	char	   channel;
 
 	status = ahd_find_tmode_devs(ahd, sim, ccb, &tstate, &lstate,
-				     /*notfound_failure*/FALSE);
+				     /*notfound_failure*/false);
 
 	if (status != CAM_REQ_CMP) {
 		ccb->ccb_h.status = status;
@@ -9799,7 +9797,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd,
 
 			if (empty) {
 				ahd_free_tstate(ahd, target, channel,
-						/*force*/FALSE);
+						/*force*/false);
 				if (ahd->features & AHD_MULTI_TID) {
 					u_int targid_mask;
 
@@ -9817,7 +9815,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd,
 			 * We can't allow selections without
 			 * our black hole device.
 			 */
-			empty = TRUE;
+			empty = true;
 		}
 		if (ahd->enabled_luns == 0) {
 			/* Disallow select-in */
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -923,7 +923,7 @@ ahd_intr(struct ahd_softc *ahd)
 		ahd->cmdcmplt_total++;
 #ifdef AHD_TARGET_MODE
 		if ((ahd->flags & AHD_TARGETROLE) != 0)
-			ahd_run_tqinfifo(ahd, /*paused*/FALSE);
+			ahd_run_tqinfifo(ahd, /*paused*/false);
 #endif
 	}
 
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -509,9 +509,9 @@ ahd_linux_target_alloc(struct scsi_targe
 			    CAM_LUN_WILDCARD, channel,
 			    ROLE_INITIATOR);
 	ahd_set_syncrate(ahd, &devinfo, 0, 0, 0,
-			 AHD_TRANS_GOAL, /*paused*/FALSE);
+			 AHD_TRANS_GOAL, /*paused*/false);
 	ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-		      AHD_TRANS_GOAL, /*paused*/FALSE);
+		      AHD_TRANS_GOAL, /*paused*/false);
 	ahd_unlock(ahd, &flags);
 
 	return 0;
@@ -650,8 +650,8 @@ ahd_linux_dev_reset(struct scsi_cmnd *cm
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	reset_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
+	paused = false;
+	wait = false;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd,
@@ -749,7 +749,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 	ahd_lock(ahd, &flags);
 
 	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
-				  /*initiate reset*/TRUE);
+				  /*initiate reset*/true);
 	ahd_unlock(ahd, &flags);
 
 	if (bootverbose)
@@ -929,7 +929,7 @@ ahd_parse_brace_option(char *opt_name, c
 	opt_arg++;
 	instance = -1;
 	targ = -1;
-	done = FALSE;
+	done = false;
 	/*
 	 * Restore separator that may be in
 	 * the middle of our option argument.
@@ -949,7 +949,7 @@ ahd_parse_brace_option(char *opt_name, c
 				} else {
 					printf("Malformed Option %s\n",
 					       opt_name);
-					done = TRUE;
+					done = true;
 				}
 			}
 			opt_arg++;
@@ -964,7 +964,7 @@ ahd_parse_brace_option(char *opt_name, c
 		case ',':
 		case '.':
 			if (instance == -1)
-				done = TRUE;
+				done = true;
 			else if (targ >= 0)
 				targ++;
 			else if (instance >= 0)
@@ -972,7 +972,7 @@ ahd_parse_brace_option(char *opt_name, c
 			opt_arg++;
 			break;
 		case '\0':
-			done = TRUE;
+			done = true;
 			break;
 		default:
 			tok_end = end;
@@ -1112,7 +1112,7 @@ ahd_linux_register_host(struct ahd_softc
 	}
 	host->unique_id = ahd->unit;
 	ahd_linux_initialize_scsi_bus(ahd);
-	ahd_intr_enable(ahd, TRUE);
+	ahd_intr_enable(ahd, true);
 
 	host->transportt = ahd_linux_transport_template;
 
@@ -1146,7 +1146,7 @@ ahd_linux_initialize_scsi_bus(struct ahd
 		ahd->flags &= ~AHD_RESET_BUS_A;
 
 	if ((ahd->flags & AHD_RESET_BUS_A) != 0)
-		ahd_reset_channel(ahd, 'A', /*initiate_reset*/TRUE);
+		ahd_reset_channel(ahd, 'A', /*initiate_reset*/true);
 	else
 		numtarg = (ahd->features & AHD_WIDE) ? 16 : 8;
 
@@ -1528,7 +1528,7 @@ ahd_linux_run_command(struct ahd_softc *
 		scb->platform_data->xfer_len = cmd->request_bufflen;
 		scb->platform_data->buf_busaddr = addr;
 		sg = ahd_sg_setup(ahd, scb, sg, addr,
-				  cmd->request_bufflen, /*last*/TRUE);
+				  cmd->request_bufflen, /*last*/true);
 	}
 
 	LIST_INSERT_HEAD(&ahd->pending_scbs, scb, pending_links);
@@ -2050,8 +2050,8 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 	unsigned long flags;
 
 	pending_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
+	paused = false;
+	wait = false;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd,
@@ -2112,7 +2112,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 	 */
 	was_paused = ahd_is_paused(ahd);
 	ahd_pause_and_flushwork(ahd);
-	paused = TRUE;
+	paused = true;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
 		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
@@ -2123,7 +2123,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 	       ahd_name(ahd), was_paused ? "" : "not ");
 	ahd_dump_card_state(ahd);
 
-	disconnected = TRUE;
+	disconnected = true;
 	if (ahd_search_qinfifo(ahd, cmd->device->id, 
 			       cmd->device->channel + 'A',
 			       cmd->device->lun, 
@@ -2147,7 +2147,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 
 		bus_scb = ahd_lookup_scb(ahd, active_scbptr);
 		if (bus_scb == pending_scb)
-			disconnected = FALSE;
+			disconnected = false;
 	}
 
 	/*
@@ -2168,7 +2168,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
 		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
-		wait = TRUE;
+		wait = true;
 	} else if (disconnected) {
 
 		/*
@@ -2226,7 +2226,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cm
 		ahd_set_scbptr(ahd, saved_scbptr);
 		ahd_print_path(ahd, pending_scb);
 		printf("Device is disconnected, re-queuing SCB\n");
-		wait = TRUE;
+		wait = true;
 	} else {
 		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
@@ -2280,7 +2280,7 @@ static void ahd_linux_set_width(struct s
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_lock(ahd, &flags);
-	ahd_set_width(ahd, &devinfo, width, AHD_TRANS_GOAL, FALSE);
+	ahd_set_width(ahd, &devinfo, width, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2330,7 +2330,7 @@ static void ahd_linux_set_period(struct 
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2365,7 +2365,7 @@ static void ahd_linux_set_offset(struct 
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset, ppr_options,
-			 AHD_TRANS_GOAL, FALSE);
+			 AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2407,7 +2407,7 @@ static void ahd_linux_set_dt(struct scsi
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2446,7 +2446,7 @@ static void ahd_linux_set_qas(struct scs
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2486,7 +2486,7 @@ static void ahd_linux_set_iu(struct scsi
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2522,7 +2522,7 @@ static void ahd_linux_set_rd_strm(struct
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2558,7 +2558,7 @@ static void ahd_linux_set_wr_flow(struct
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2602,7 +2602,7 @@ static void ahd_linux_set_rti(struct scs
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2652,7 +2652,7 @@ static void ahd_linux_set_pcomp_en(struc
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
@@ -2682,7 +2682,7 @@ static void ahd_linux_set_hold_mcs(struc
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
-			 ppr_options, AHD_TRANS_GOAL, FALSE);
+			 ppr_options, AHD_TRANS_GOAL, false);
 	ahd_unlock(ahd, &flags);
 }
 
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -100,7 +100,7 @@ ahd_linux_pci_dev_remove(struct pci_dev 
 			scsi_remove_host(ahd->platform_data->host);
 
 	ahd_lock(ahd, &s);
-	ahd_intr_enable(ahd, FALSE);
+	ahd_intr_enable(ahd, false);
 	ahd_unlock(ahd, &s);
 	ahd_free(ahd);
 }
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -360,7 +360,7 @@ ahd_pci_config(struct ahd_softc *ahd, st
 
 	ahd->bus_intr = ahd_pci_intr;
 
-	error = ahd_reset(ahd, /*reinit*/FALSE);
+	error = ahd_reset(ahd, /*reinit*/false);
 	if (error != 0)
 		return (ENXIO);
 
@@ -514,7 +514,7 @@ ahd_check_extport(struct ahd_softc *ahd)
 
 		error = ahd_read_seeprom(ahd, (uint16_t *)&vpd,
 					 start_addr, sizeof(vpd)/2,
-					 /*bytestream*/TRUE);
+					 /*bytestream*/true);
 		if (error == 0)
 			error = ahd_parse_vpddata(ahd, &vpd);
 		if (bootverbose) 
@@ -530,7 +530,7 @@ ahd_check_extport(struct ahd_softc *ahd)
 
 		error = ahd_read_seeprom(ahd, (uint16_t *)sc,
 					 start_addr, sizeof(*sc)/2,
-					 /*bytestream*/FALSE);
+					 /*bytestream*/false);
 
 		if (error != 0) {
 			printf("Unable to read SEEPROM\n");
diff -puN drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic79xx_proc.c
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -304,7 +304,7 @@ ahd_proc_write_seeprom(struct ahd_softc 
 				  sizeof(struct seeprom_config)/2);
 		ahd_read_seeprom(ahd, (uint16_t *)ahd->seep_config,
 				 start_addr, sizeof(struct seeprom_config)/2,
-				 /*ByteStream*/FALSE);
+				 /*ByteStream*/false);
 		ahd_release_seeprom(ahd);
 		written = length;
 	}
@@ -331,7 +331,7 @@ ahd_linux_proc_info(struct Scsi_Host *sh
 	int	retval;
 
 	 /* Has data been written to the file? */ 
-	if (inout == TRUE) {
+	if (inout) {
 		retval = ahd_proc_write_seeprom(ahd, buffer, length);
 		goto done;
 	}
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx.h
--- a/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx.h
@@ -54,13 +54,6 @@ struct scb_platform_data;
 struct seeprom_descriptor;
 
 /****************************** Useful Macros *********************************/
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define ALL_CHANNELS '\0'
 #define ALL_TARGETS_MASK 0xFFFF
 #define INITIATOR_WILDCARD	(~0)
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -789,7 +789,7 @@ ahc_handle_seqint(struct ahc_softc *ahc,
 						ahc_set_transaction_status(scb,
 						    CAM_UNCOR_PARITY);
 					ahc_reset_channel(ahc, devinfo.channel, 
-							  /*init reset*/TRUE);
+							  /*init reset*/true);
 				}
 			} else {
 				ahc_inb(ahc, SCSIDATL);
@@ -1025,7 +1025,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 			ahc_name(ahc), intr_channel);
 		if (intr_channel != cur_channel)
 		 	ahc_outb(ahc, SBLKCTL, ahc_inb(ahc, SBLKCTL) ^ SELBUSB);
-		ahc_reset_channel(ahc, intr_channel, /*Initiate Reset*/FALSE);
+		ahc_reset_channel(ahc, intr_channel, /*Initiate Reset*/false);
 	} else if ((status & SCSIPERR) != 0) {
 		/*
 		 * Determine the bus phase and queue an appropriate message.
@@ -1073,10 +1073,10 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 				break;
 		}
 		mesg_out = ahc_phase_table[i].mesg_out;
-		silent = FALSE;
+		silent = false;
 		if (scb != NULL) {
 			if (SCB_IS_SILENT(scb))
-				silent = TRUE;
+				silent = true;
 			else
 				ahc_print_path(ahc, scb);
 			scb->flags |= SCB_TRANSMISSION_ERROR;
@@ -1084,7 +1084,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 			printf("%s:%c:%d: ", ahc_name(ahc), intr_channel,
 			       SCSIID_TARGET(ahc, ahc_inb(ahc, SAVED_SCSIID)));
 		scsirate = ahc_inb(ahc, SCSIRATE);
-		if (silent == FALSE) {
+		if (!silent) {
 			printf("parity error detected %s. "
 			       "SEQADDR(0x%x) SCSIRATE(0x%x)\n",
 			       ahc_phase_table[i].phasemsg,
@@ -1125,7 +1125,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 		 */
 		if (mesg_out != MSG_NOOP) {
 			if (ahc->msg_type != MSG_TYPE_NONE)
-				ahc->send_msg_perror = TRUE;
+				ahc->send_msg_perror = true;
 			else
 				ahc_outb(ahc, MSG_OUT, mesg_out);
 		}
@@ -1247,8 +1247,8 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 			u_int tag;
 
 			tag = SCB_LIST_NULL;
-			if (ahc_sent_msg(ahc, AHCMSG_1B, MSG_ABORT_TAG, TRUE)
-			 || ahc_sent_msg(ahc, AHCMSG_1B, MSG_ABORT, TRUE)) {
+			if (ahc_sent_msg(ahc, AHCMSG_1B, MSG_ABORT_TAG, true)
+			 || ahc_sent_msg(ahc, AHCMSG_1B, MSG_ABORT, true)) {
 				if (ahc->msgout_buf[ahc->msgout_index - 1]
 				 == MSG_ABORT_TAG)
 					tag = scb->hscb->tag;
@@ -1262,7 +1262,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 					       CAM_REQ_ABORTED);
 				printerror = 0;
 			} else if (ahc_sent_msg(ahc, AHCMSG_1B,
-						MSG_BUS_DEV_RESET, TRUE)) {
+						MSG_BUS_DEV_RESET, true)) {
 #ifdef __FreeBSD__
 				/*
 				 * Don't mark the user's request for this BDR
@@ -1290,7 +1290,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 						    /*verbose_level*/0);
 				printerror = 0;
 			} else if (ahc_sent_msg(ahc, AHCMSG_EXT,
-						MSG_EXT_PPR, FALSE)) {
+						MSG_EXT_PPR, false)) {
 				struct ahc_initiator_tinfo *tinfo;
 				struct ahc_tmode_tstate *tstate;
 
@@ -1309,7 +1309,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 				ahc_qinfifo_requeue_tail(ahc, scb);
 				printerror = 0;
 			} else if (ahc_sent_msg(ahc, AHCMSG_EXT,
-						MSG_EXT_WDTR, FALSE)) {
+						MSG_EXT_WDTR, false)) {
 				/*
 				 * Negotiation Rejected.  Go-narrow and
 				 * retry command.
@@ -1317,11 +1317,11 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 				ahc_set_width(ahc, &devinfo,
 					      MSG_EXT_WDTR_BUS_8_BIT,
 					      AHC_TRANS_CUR|AHC_TRANS_GOAL,
-					      /*paused*/TRUE);
+					      /*paused*/true);
 				ahc_qinfifo_requeue_tail(ahc, scb);
 				printerror = 0;
 			} else if (ahc_sent_msg(ahc, AHCMSG_EXT,
-						MSG_EXT_SDTR, FALSE)) {
+						MSG_EXT_SDTR, false)) {
 				/*
 				 * Negotiation Rejected.  Go-async and
 				 * retry command.
@@ -1331,7 +1331,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc
 						/*period*/0, /*offset*/0,
 						/*ppr_options*/0,
 						AHC_TRANS_CUR|AHC_TRANS_GOAL,
-						/*paused*/TRUE);
+						/*paused*/true);
 				ahc_qinfifo_requeue_tail(ahc, scb);
 				printerror = 0;
 			}
@@ -1417,7 +1417,7 @@ ahc_clear_critical_section(struct ahc_so
 	if (ahc->num_critical_sections == 0)
 		return;
 
-	stepping = FALSE;
+	stepping = false;
 	steps = 0;
 	simode0 = 0;
 	simode1 = 0;
@@ -1454,7 +1454,7 @@ ahc_clear_critical_section(struct ahc_so
 		}
 
 		steps++;
-		if (stepping == FALSE) {
+		if (!stepping) {
 
 			/*
 			 * Disable all interrupt sources so that the
@@ -1479,7 +1479,7 @@ ahc_clear_critical_section(struct ahc_so
 				ahc_outb(ahc, SIMODE1, 0);
 			ahc_outb(ahc, CLRINT, CLRSCSIINT);
 			ahc_outb(ahc, SEQCTL, ahc->seqctl | STEP);
-			stepping = TRUE;
+			stepping = true;
 		}
 		if ((ahc->features & AHC_DT) != 0) {
 			ahc_outb(ahc, CLRSINT1, CLRBUSFREE);
@@ -1615,7 +1615,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u
 	 */
 	if (((channel == 'B' && scsi_id == ahc->our_id_b)
 	  || (channel == 'A' && scsi_id == ahc->our_id))
-	 && force == FALSE)
+	 && !force)
 		return;
 
 	if (channel == 'B')
@@ -2601,7 +2601,7 @@ proto_violation_reset:
 		 * The only safe thing to do is to blow
 		 * it away with a bus reset.
 		 */
-		found = ahc_reset_channel(ahc, 'A', TRUE);
+		found = ahc_reset_channel(ahc, 'A', true);
 		printf("%s: Issued Channel %c Bus Reset. "
 		       "%d SCBs aborted\n", ahc_name(ahc), 'A', found);
 	} else {
@@ -2640,7 +2640,7 @@ ahc_handle_message_phase(struct ahc_soft
 	int	end_session;
 
 	ahc_fetch_devinfo(ahc, &devinfo);
-	end_session = FALSE;
+	end_session = false;
 	bus_phase = ahc_inb(ahc, SCSISIGI) & PHASE_MASK;
 
 reswitch:
@@ -2677,12 +2677,12 @@ reswitch:
 				 * the sequencer.
 				 */
 				ahc_outb(ahc, CLRSINT1, CLRATNO);
-				ahc->send_msg_perror = FALSE;
+				ahc->send_msg_perror = false;
 				ahc->msg_type = MSG_TYPE_INITIATOR_MSGIN;
 				ahc->msgin_index = 0;
 				goto reswitch;
 			}
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -2749,13 +2749,13 @@ reswitch:
 #endif
 			ahc->msgin_index = 0;
 			if (bus_phase == P_MESGOUT
-			 && (ahc->send_msg_perror == TRUE
+			 && (ahc->send_msg_perror
 			  || (ahc->msgout_len != 0
 			   && ahc->msgout_index == 0))) {
 				ahc->msg_type = MSG_TYPE_INITIATOR_MSGOUT;
 				goto reswitch;
 			}
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -2794,7 +2794,7 @@ reswitch:
 			ahc->msgin_index++;
 
 		if (message_done == MSGLOOP_TERMINATED) {
-			end_session = TRUE;
+			end_session = true;
 		} else {
 			/* Ack the byte */
 			ahc_outb(ahc, CLRSINT1, CLRREQINIT);
@@ -2818,9 +2818,9 @@ reswitch:
 		 */
 		if ((ahc_inb(ahc, SCSISIGI) & ATNI) != 0
 		 && ahc->msgout_index > 0)
-			msgout_request = TRUE;
+			msgout_request = true;
 		else
-			msgout_request = FALSE;
+			msgout_request = false;
 
 		if (msgout_request) {
 
@@ -2844,7 +2844,7 @@ reswitch:
 		if (msgdone) {
 			ahc_outb(ahc, SXFRCTL0,
 				 ahc_inb(ahc, SXFRCTL0) & ~SPIOEN);
-			end_session = TRUE;
+			end_session = true;
 			break;
 		}
 
@@ -2908,7 +2908,7 @@ reswitch:
 		}
 
 		if (lastbyte)
-			end_session = TRUE;
+			end_session = true;
 		else {
 			/* Ask for the next byte. */
 			ahc_outb(ahc, SXFRCTL0,
@@ -2940,7 +2940,7 @@ ahc_sent_msg(struct ahc_softc *ahc, ahc_
 	int found;
 	u_int index;
 
-	found = FALSE;
+	found = false;
 	index = 0;
 
 	while (index < ahc->msgout_len) {
@@ -2953,9 +2953,9 @@ ahc_sent_msg(struct ahc_softc *ahc, ahc_
 
 				if (full) {
 					if (ahc->msgout_index > end_index)
-						found = TRUE;
+						found = true;
 				} else if (ahc->msgout_index > index)
-					found = TRUE;
+					found = true;
 			}
 			index = end_index;
 		} else if (ahc->msgout_buf[index] >= MSG_SIMPLE_TASK
@@ -2968,7 +2968,7 @@ ahc_sent_msg(struct ahc_softc *ahc, ahc_
 			if (type == AHCMSG_1B
 			 && ahc->msgout_buf[index] == msgval
 			 && ahc->msgout_index > index)
-				found = TRUE;
+				found = true;
 			index++;
 		}
 
@@ -2992,8 +2992,8 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 	u_int	targ_scsirate;
 
 	done = MSGLOOP_IN_PROG;
-	response = FALSE;
-	reject = FALSE;
+	response = false;
+	reject = false;
 	tinfo = ahc_fetch_transinfo(ahc, devinfo->channel, devinfo->our_scsiid,
 				    devinfo->target, &tstate);
 	targ_scsirate = tinfo->scsirate;
@@ -3042,7 +3042,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 			u_int	 saved_offset;
 			
 			if (ahc->msgin_buf[1] != MSG_EXT_SDTR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -3078,18 +3078,18 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 					 syncrate, period,
 					 offset, ppr_options,
 					 AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-					 /*paused*/TRUE);
+					 /*paused*/true);
 
 			/*
 			 * See if we initiated Sync Negotiation
 			 * and didn't have to fall down to async
 			 * transfers.
 			 */
-			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_SDTR, TRUE)) {
+			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_SDTR, true)) {
 				/* We started it */
 				if (saved_offset != offset) {
 					/* Went too low - force async */
-					reject = TRUE;
+					reject = true;
 				}
 			} else {
 				/*
@@ -3107,7 +3107,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				ahc_construct_sdtr(ahc, devinfo,
 						   period, offset);
 				ahc->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
@@ -3118,9 +3118,9 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 			u_int saved_width;
 			u_int sending_reply;
 
-			sending_reply = FALSE;
+			sending_reply = false;
 			if (ahc->msgin_buf[1] != MSG_EXT_WDTR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -3146,7 +3146,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				       saved_width, bus_width);
 			}
 
-			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_WDTR, TRUE)) {
+			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_WDTR, true)) {
 				/*
 				 * Don't send a WDTR back to the
 				 * target, since we asked first.
@@ -3154,7 +3154,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				 * request, reject it.
 				 */
 				if (saved_width > bus_width) {
-					reject = TRUE;
+					reject = true;
 					printf("(%s:%c:%d:%d): requested %dBit "
 					       "transfers.  Rejecting...\n",
 					       ahc_name(ahc), devinfo->channel,
@@ -3177,8 +3177,8 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				ahc->msgout_len = 0;
 				ahc_construct_wdtr(ahc, devinfo, bus_width);
 				ahc->msgout_index = 0;
-				response = TRUE;
-				sending_reply = TRUE;
+				response = true;
+				sending_reply = true;
 			}
 			/*
 			 * After a wide message, we are async, but
@@ -3193,8 +3193,8 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 					       tinfo, AHC_NEG_ALWAYS);
 			ahc_set_width(ahc, devinfo, bus_width,
 				      AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-				      /*paused*/TRUE);
-			if (sending_reply == FALSE && reject == FALSE) {
+				      /*paused*/true);
+			if (!sending_reply && !reject) {
 
 				/*
 				 * We will always have an SDTR to send.
@@ -3203,7 +3203,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				ahc->msgout_len = 0;
 				ahc_build_transfer_msg(ahc, devinfo);
 				ahc->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
@@ -3220,7 +3220,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 			u_int	saved_ppr_options;
 
 			if (ahc->msgin_buf[1] != MSG_EXT_PPR_LEN) {
-				reject = TRUE;
+				reject = true;
 				break;
 			}
 
@@ -3268,7 +3268,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 					    &offset, bus_width,
 					    devinfo->role);
 
-			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_PPR, TRUE)) {
+			if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_PPR, true)) {
 				/*
 				 * If we are unable to do any of the
 				 * requested options (we went too low),
@@ -3277,7 +3277,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				if (saved_width > bus_width
 				 || saved_offset != offset
 				 || saved_ppr_options != ppr_options) {
-					reject = TRUE;
+					reject = true;
 					period = 0;
 					offset = 0;
 					bus_width = 0;
@@ -3300,7 +3300,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 				ahc_construct_ppr(ahc, devinfo, period, offset,
 						  bus_width, ppr_options);
 				ahc->msgout_index = 0;
-				response = TRUE;
+				response = true;
 			}
 			if (bootverbose) {
 				printf("(%s:%c:%d:%d): Received PPR width %x, "
@@ -3315,18 +3315,18 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 			}
 			ahc_set_width(ahc, devinfo, bus_width,
 				      AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-				      /*paused*/TRUE);
+				      /*paused*/true);
 			ahc_set_syncrate(ahc, devinfo,
 					 syncrate, period,
 					 offset, ppr_options,
 					 AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-					 /*paused*/TRUE);
+					 /*paused*/true);
 			done = MSGLOOP_MSGCOMPLETE;
 			break;
 		}
 		default:
 			/* Unknown extended message.  Reject it. */
-			reject = TRUE;
+			reject = true;
 			break;
 		}
 		break;
@@ -3348,7 +3348,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 
 		/* Target mode messages */
 		if (devinfo->role != ROLE_TARGET) {
-			reject = TRUE;
+			reject = true;
 			break;
 		}
 		tag = SCB_LIST_NULL;
@@ -3378,7 +3378,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 #endif
 	case MSG_TERM_IO_PROC:
 	default:
-		reject = TRUE;
+		reject = true;
 		break;
 	}
 
@@ -3390,7 +3390,7 @@ ahc_parse_msg(struct ahc_softc *ahc, str
 		ahc->msgout_len = 1;
 		ahc->msgout_buf[0] = MSG_MESSAGE_REJECT;
 		done = MSGLOOP_MSGCOMPLETE;
-		response = TRUE;
+		response = true;
 	}
 
 	if (done != MSGLOOP_IN_PROG && !response)
@@ -3427,7 +3427,7 @@ ahc_handle_msg_reject(struct ahc_softc *
 	/* Might be necessary */
 	last_msg = ahc_inb(ahc, LAST_MSG);
 
-	if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_PPR, /*full*/FALSE)) {
+	if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_PPR, /*full*/false)) {
 		/*
 		 * Target does not support the PPR message.
 		 * Attempt to negotiate SPI-2 style.
@@ -3446,7 +3446,7 @@ ahc_handle_msg_reject(struct ahc_softc *
 		ahc_build_transfer_msg(ahc, devinfo);
 		ahc->msgout_index = 0;
 		response = 1;
-	} else if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_WDTR, /*full*/FALSE)) {
+	} else if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_WDTR, /*full*/false)) {
 
 		/* note 8bit xfers */
 		printf("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
@@ -3454,7 +3454,7 @@ ahc_handle_msg_reject(struct ahc_softc *
 		       devinfo->channel, devinfo->target, devinfo->lun);
 		ahc_set_width(ahc, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
 			      AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-			      /*paused*/TRUE);
+			      /*paused*/true);
 		/*
 		 * No need to clear the sync rate.  If the target
 		 * did not accept the command, our syncrate is
@@ -3471,12 +3471,12 @@ ahc_handle_msg_reject(struct ahc_softc *
 			ahc->msgout_index = 0;
 			response = 1;
 		}
-	} else if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_SDTR, /*full*/FALSE)) {
+	} else if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_SDTR, /*full*/false)) {
 		/* note asynch xfers and clear flag */
 		ahc_set_syncrate(ahc, devinfo, /*syncrate*/NULL, /*period*/0,
 				 /*offset*/0, /*ppr_options*/0,
 				 AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
-				 /*paused*/TRUE);
+				 /*paused*/true);
 		printf("(%s:%c:%d:%d): refuses synchronous negotiation. "
 		       "Using asynchronous transfers\n",
 		       ahc_name(ahc), devinfo->channel,
@@ -3510,7 +3510,7 @@ ahc_handle_msg_reject(struct ahc_softc *
 		ahc_outb(ahc, SCB_CONTROL,
 			 ahc_inb(ahc, SCB_CONTROL) & mask);
 	 	scb->hscb->control &= mask;
-		ahc_set_transaction_tag(scb, /*enabled*/FALSE,
+		ahc_set_transaction_tag(scb, /*enabled*/false,
 					/*type*/MSG_SIMPLE_TASK);
 		ahc_outb(ahc, MSG_OUT, MSG_IDENTIFYFLAG);
 		ahc_assert_atn(ahc);
@@ -3758,10 +3758,10 @@ ahc_handle_devreset(struct ahc_softc *ah
 	 * Go back to async/narrow transfers and renegotiate.
 	 */
 	ahc_set_width(ahc, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-		      AHC_TRANS_CUR, /*paused*/TRUE);
+		      AHC_TRANS_CUR, /*paused*/true);
 	ahc_set_syncrate(ahc, devinfo, /*syncrate*/NULL,
 			 /*period*/0, /*offset*/0, /*ppr_options*/0,
-			 AHC_TRANS_CUR, /*paused*/TRUE);
+			 AHC_TRANS_CUR, /*paused*/true);
 	
 	if (status != CAM_SEL_TIMEOUT)
 		ahc_send_async(ahc, devinfo->channel, devinfo->target,
@@ -3972,7 +3972,7 @@ ahc_shutdown(void *arg)
 	ahc = (struct ahc_softc *)arg;
 
 	/* This will reset most registers to 0, but not all */
-	ahc_reset(ahc, /*reinit*/FALSE);
+	ahc_reset(ahc, /*reinit*/false);
 	ahc_outb(ahc, SCSISEQ, 0);
 	ahc_outb(ahc, SXFRCTL0, 0);
 	ahc_outb(ahc, DSPCISTATUS, 0);
@@ -5027,7 +5027,7 @@ ahc_pause_and_flushwork(struct ahc_softc
 
 	maxloops = 1000;
 	ahc->flags |= AHC_ALL_INTERRUPTS;
-	paused = FALSE;
+	paused = false;
 	do {
 		if (paused) {
 			ahc_unpause(ahc);
@@ -5039,7 +5039,7 @@ ahc_pause_and_flushwork(struct ahc_softc
 		}
 		ahc_intr(ahc);
 		ahc_pause(ahc);
-		paused = TRUE;
+		paused = true;
 		ahc_outb(ahc, SCSISEQ, ahc_inb(ahc, SCSISEQ) & ~ENSELO);
 		intstat = ahc_inb(ahc, INTSTAT);
 		if ((intstat & INT_PEND) == 0) {
@@ -5088,8 +5088,8 @@ int
 ahc_resume(struct ahc_softc *ahc)
 {
 
-	ahc_reset(ahc, /*reinit*/TRUE);
-	ahc_intr_enable(ahc, TRUE); 
+	ahc_reset(ahc, /*reinit*/true);
+	ahc_intr_enable(ahc, true);
 	ahc_restart(ahc);
 	return (0);
 }
@@ -5813,8 +5813,8 @@ ahc_abort_scbs(struct ahc_softc *ahc, in
 		 * is no reason for this search to restore it too.
 		 */
 		ahc_search_disc_list(ahc, target, channel, lun, tag,
-				     /*stop_on_first*/FALSE, /*remove*/TRUE,
-				     /*save_state*/FALSE);
+				     /*stop_on_first*/false, /*remove*/true,
+				     /*save_state*/false);
 	}
 
 	/*
@@ -5927,7 +5927,7 @@ ahc_reset_channel(struct ahc_softc *ahc,
 	 *	 to compact the tqinfifo appropriately.
 	 */
 	if ((ahc->flags & AHC_TARGETROLE) != 0) {
-		ahc_run_tqinfifo(ahc, /*paused*/TRUE);
+		ahc_run_tqinfifo(ahc, /*paused*/true);
 	}
 #endif
 
@@ -5962,7 +5962,7 @@ ahc_reset_channel(struct ahc_softc *ahc,
 		ahc_clear_intstat(ahc);
 		ahc_outb(ahc, SCSISEQ, scsiseq & (ENSELI|ENRSELI|ENAUTOATNP));
 		ahc_outb(ahc, SBLKCTL, sblkctl);
-		restart_needed = FALSE;
+		restart_needed = false;
 	} else {
 		/* Case 2: A command from this bus is active or we're idle */
 		simode1 = ahc_inb(ahc, SIMODE1) & ~(ENBUSFREE|ENSCSIRST);
@@ -5980,7 +5980,7 @@ ahc_reset_channel(struct ahc_softc *ahc,
 			ahc_reset_current_bus(ahc);
 		ahc_clear_intstat(ahc);
 		ahc_outb(ahc, SCSISEQ, scsiseq & (ENSELI|ENRSELI|ENAUTOATNP));
-		restart_needed = TRUE;
+		restart_needed = true;
 	}
 
 	/*
@@ -6036,11 +6036,11 @@ ahc_reset_channel(struct ahc_softc *ahc,
 					    CAM_LUN_WILDCARD,
 					    channel, ROLE_UNKNOWN);
 			ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-				      AHC_TRANS_CUR, /*paused*/TRUE);
+				      AHC_TRANS_CUR, /*paused*/true);
 			ahc_set_syncrate(ahc, &devinfo, /*syncrate*/NULL,
 					 /*period*/0, /*offset*/0,
 					 /*ppr_options*/0, AHC_TRANS_CUR,
-					 /*paused*/TRUE);
+					 /*paused*/true);
 		}
 	}
 
@@ -6168,7 +6168,7 @@ ahc_queue_lstate_event(struct ahc_softc 
 		 */
 		lstate->event_r_idx = 0;
 		lstate->event_w_idx = 0;
-		xpt_release_devq(lstate->path, pending, /*runqueue*/FALSE);
+		xpt_release_devq(lstate->path, pending, /*runqueue*/false);
 	}
 
 	if (pending == AHC_TMODE_EVENT_BUFFER_SIZE) {
@@ -6179,7 +6179,7 @@ ahc_queue_lstate_event(struct ahc_softc 
 		lstate->event_r_idx++;
 		if (lstate->event_r_idx == AHC_TMODE_EVENT_BUFFER_SIZE)
 			lstate->event_r_idx = 0;
-		xpt_release_devq(lstate->path, /*count*/1, /*runqueue*/FALSE);
+		xpt_release_devq(lstate->path, /*count*/1, /*runqueue*/false);
 	}
 
 	event = &lstate->event_buffer[lstate->event_w_idx];
@@ -6323,18 +6323,17 @@ ahc_loadseq(struct ahc_softc *ahc)
 		 */
 		for (; cur_cs < num_critical_sections; cur_cs++) {
 			if (critical_sections[cur_cs].end <= i) {
-				if (begin_set[cs_count] == TRUE
-				 && end_set[cs_count] == FALSE) {
+				if (begin_set[cs_count] && !end_set[cs_count]) {
 					cs_table[cs_count].end = downloaded;
-				 	end_set[cs_count] = TRUE;
+					end_set[cs_count] = true;
 					cs_count++;
 				}
 				continue;
 			}
 			if (critical_sections[cur_cs].begin <= i
-			 && begin_set[cs_count] == FALSE) {
+			 && !begin_set[cs_count]) {
 				cs_table[cs_count].begin = downloaded;
-				begin_set[cs_count] = TRUE;
+				begin_set[cs_count] = true;
 			}
 			break;
 		}
@@ -6812,7 +6811,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc,
 	char	   channel;
 
 	status = ahc_find_tmode_devs(ahc, sim, ccb, &tstate, &lstate,
-				     /*notfound_failure*/FALSE);
+				     /*notfound_failure*/false);
 
 	if (status != CAM_REQ_CMP) {
 		ccb->ccb_h.status = status;
@@ -7112,7 +7111,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc,
 
 			if (empty) {
 				ahc_free_tstate(ahc, target, channel,
-						/*force*/FALSE);
+						/*force*/false);
 				if (ahc->features & AHC_MULTI_TID) {
 					u_int targid_mask;
 
@@ -7135,7 +7134,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc,
 			 * We can't allow selections without
 			 * our black hole device.
 			 */
-			empty = TRUE;
+			empty = true;
 		}
 		if (ahc->enabled_luns == 0) {
 			/* Disallow select-in */
@@ -7218,7 +7217,7 @@ ahc_run_tqinfifo(struct ahc_softc *ahc, 
 	 * of whether it is paused or not.
 	 */
 	if ((ahc->features & AHC_AUTOPAUSE) != 0)
-		paused = TRUE;
+		paused = true;
 
 	ahc_sync_tqinfifo(ahc, BUS_DMASYNC_POSTREAD);
 	while ((cmd = &ahc->targetcmds[ahc->tqinfifonext])->cmd_valid != 0) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_inline.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_inline.h
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -622,7 +622,7 @@ ahc_intr(struct ahc_softc *ahc)
 		ahc_run_qoutfifo(ahc);
 #ifdef AHC_TARGET_MODE
 		if ((ahc->flags & AHC_TARGETROLE) != 0)
-			ahc_run_tqinfifo(ahc, /*paused*/FALSE);
+			ahc_run_tqinfifo(ahc, /*paused*/false);
 #endif
 	}
 
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -570,9 +570,9 @@ ahc_linux_target_alloc(struct scsi_targe
 			    CAM_LUN_WILDCARD, channel,
 			    ROLE_INITIATOR);
 	ahc_set_syncrate(ahc, &devinfo, NULL, 0, 0, 0,
-			 AHC_TRANS_GOAL, /*paused*/FALSE);
+			 AHC_TRANS_GOAL, /*paused*/false);
 	ahc_set_width(ahc, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-		      AHC_TRANS_GOAL, /*paused*/FALSE);
+		      AHC_TRANS_GOAL, /*paused*/false);
 	ahc_unlock(ahc, &flags);
 
 	return 0;
@@ -729,7 +729,7 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 
 	ahc_lock(ahc, &flags);
 	found = ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
-				  /*initiate reset*/TRUE);
+				  /*initiate reset*/true);
 	ahc_unlock(ahc, &flags);
 
 	if (bootverbose)
@@ -901,7 +901,7 @@ ahc_parse_brace_option(char *opt_name, c
 	opt_arg++;
 	instance = -1;
 	targ = -1;
-	done = FALSE;
+	done = false;
 	/*
 	 * Restore separator that may be in
 	 * the middle of our option argument.
@@ -921,7 +921,7 @@ ahc_parse_brace_option(char *opt_name, c
 				} else {
 					printf("Malformed Option %s\n",
 					       opt_name);
-					done = TRUE;
+					done = true;
 				}
 			}
 			opt_arg++;
@@ -936,7 +936,7 @@ ahc_parse_brace_option(char *opt_name, c
 		case ',':
 		case '.':
 			if (instance == -1)
-				done = TRUE;
+				done = true;
 			else if (targ >= 0)
 				targ++;
 			else if (instance >= 0)
@@ -944,7 +944,7 @@ ahc_parse_brace_option(char *opt_name, c
 			opt_arg++;
 			break;
 		case '\0':
-			done = TRUE;
+			done = true;
 			break;
 		default:
 			tok_end = end;
@@ -1069,7 +1069,7 @@ ahc_linux_register_host(struct ahc_softc
 	}
 	host->unique_id = ahc->unit;
 	ahc_linux_initialize_scsi_bus(ahc);
-	ahc_intr_enable(ahc, TRUE);
+	ahc_intr_enable(ahc, true);
 
 	host->transportt = ahc_linux_transport_template;
 
@@ -1106,14 +1106,14 @@ ahc_linux_initialize_scsi_bus(struct ahc
 		ahc->flags &= ~(AHC_RESET_BUS_A|AHC_RESET_BUS_B);
 
 	if ((ahc->flags & AHC_RESET_BUS_A) != 0)
-		ahc_reset_channel(ahc, 'A', /*initiate_reset*/TRUE);
+		ahc_reset_channel(ahc, 'A', /*initiate_reset*/true);
 	else
 		numtarg = (ahc->features & AHC_WIDE) ? 16 : 8;
 
 	if ((ahc->features & AHC_TWIN) != 0) {
 
 		if ((ahc->flags & AHC_RESET_BUS_B) != 0) {
-			ahc_reset_channel(ahc, 'B', /*initiate_reset*/TRUE);
+			ahc_reset_channel(ahc, 'B', /*initiate_reset*/true);
 		} else {
 			if (numtarg == 0)
 				i = 8;
@@ -2057,8 +2057,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	unsigned long flags;
 
 	pending_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
+	paused = false;
+	wait = false;
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
@@ -2144,7 +2144,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	 */
 	was_paused = ahc_is_paused(ahc);
 	ahc_pause_and_flushwork(ahc);
-	paused = TRUE;
+	paused = true;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
 		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
@@ -2155,7 +2155,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	       ahc_name(ahc), was_paused ? "" : "not ");
 	ahc_dump_card_state(ahc);
 
-	disconnected = TRUE;
+	disconnected = true;
 	if (flag == SCB_ABORT) {
 		if (ahc_search_qinfifo(ahc, cmd->device->id,
 				       cmd->device->channel + 'A',
@@ -2174,7 +2174,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 				      cmd->device->lun, pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
-		disconnected = FALSE;
+		disconnected = false;
 	}
 
 	if (disconnected && (ahc_inb(ahc, SEQ_FLAGS) & NOT_IDENTIFIED) == 0) {
@@ -2182,11 +2182,11 @@ ahc_linux_queue_recovery_cmd(struct scsi
 
 		bus_scb = ahc_lookup_scb(ahc, ahc_inb(ahc, SCB_TAG));
 		if (bus_scb == pending_scb)
-			disconnected = FALSE;
+			disconnected = false;
 		else if (flag != SCB_ABORT
 		      && ahc_inb(ahc, SAVED_SCSIID) == pending_scb->hscb->scsiid
 		      && ahc_inb(ahc, SAVED_LUN) == SCB_GET_LUN(pending_scb))
-			disconnected = FALSE;
+			disconnected = false;
 	}
 
 	/*
@@ -2215,7 +2215,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		ahc_outb(ahc, MSG_OUT, HOST_MSG);
 		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
 		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
-		wait = TRUE;
+		wait = true;
 	} else if (disconnected) {
 
 		/*
@@ -2247,9 +2247,9 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		ahc_search_disc_list(ahc, cmd->device->id,
 				     cmd->device->channel + 'A',
 				     cmd->device->lun, pending_scb->hscb->tag,
-				     /*stop_on_first*/TRUE,
-				     /*remove*/TRUE,
-				     /*save_state*/FALSE);
+				     /*stop_on_first*/true,
+				     /*remove*/true,
+				     /*save_state*/false);
 
 		/*
 		 * In the non-paging case, the sequencer will
@@ -2278,7 +2278,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		ahc_outb(ahc, SCBPTR, saved_scbptr);
 		ahc_print_path(ahc, pending_scb);
 		printf("Device is disconnected, re-queuing SCB\n");
-		wait = TRUE;
+		wait = true;
 	} else {
 		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
@@ -2332,7 +2332,7 @@ static void ahc_linux_set_width(struct s
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahc_lock(ahc, &flags);
-	ahc_set_width(ahc, &devinfo, width, AHC_TRANS_GOAL, FALSE);
+	ahc_set_width(ahc, &devinfo, width, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 
@@ -2371,7 +2371,7 @@ static void ahc_linux_set_period(struct 
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
+			 ppr_options, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 
@@ -2399,7 +2399,7 @@ static void ahc_linux_set_offset(struct 
 	}
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
+			 ppr_options, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 
@@ -2432,7 +2432,7 @@ static void ahc_linux_set_dt(struct scsi
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
+			 ppr_options, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 
@@ -2465,7 +2465,7 @@ static void ahc_linux_set_qas(struct scs
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
+			 ppr_options, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 
@@ -2493,7 +2493,7 @@ static void ahc_linux_set_iu(struct scsi
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
-			 ppr_options, AHC_TRANS_GOAL, FALSE);
+			 ppr_options, AHC_TRANS_GOAL, false);
 	ahc_unlock(ahc, &flags);
 }
 #endif
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -147,7 +147,7 @@ ahc_linux_pci_dev_remove(struct pci_dev 
 			scsi_remove_host(ahc->platform_data->host);
 
 	ahc_lock(ahc, &s);
-	ahc_intr_enable(ahc, FALSE);
+	ahc_intr_enable(ahc, false);
 	ahc_unlock(ahc, &s);
 	ahc_free(ahc);
 }
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -742,7 +742,7 @@ ahc_pci_config(struct ahc_softc *ahc, st
 	 * a misstep to hang the machine in an interrupt
 	 * storm.
 	 */
-	ahc_intr_enable(ahc, FALSE);
+	ahc_intr_enable(ahc, false);
 
 	devconfig = ahc_pci_read_config(ahc->dev_softc, DEVCONFIG, /*bytes*/4);
 
@@ -809,7 +809,7 @@ ahc_pci_config(struct ahc_softc *ahc, st
 		scsiseq = 0;
 	}
 
-	error = ahc_reset(ahc, /*reinit*/FALSE);
+	error = ahc_reset(ahc, /*reinit*/false);
 	if (error != 0)
 		return (ENXIO);
 
@@ -1085,10 +1085,10 @@ ahc_probe_ext_scbram(struct ahc_softc *a
 	int fast;
 	int large;
 
-	enable = FALSE;
-	pcheck = FALSE;
-	fast = FALSE;
-	large = FALSE;
+	enable = false;
+	pcheck = false;
+	fast = false;
+	large = false;
 	num_scbs = 0;
 	
 	if (ahc_ext_scbram_present(ahc) == 0)
@@ -1097,13 +1097,13 @@ ahc_probe_ext_scbram(struct ahc_softc *a
 	/*
 	 * Probe for the best parameters to use.
 	 */
-	ahc_scbram_config(ahc, /*enable*/TRUE, pcheck, fast, large);
+	ahc_scbram_config(ahc, /*enable*/true, pcheck, fast, large);
 	num_scbs = ahc_probe_scbs(ahc);
 	if (num_scbs == 0) {
 		/* The SRAM wasn't really present. */
 		goto done;
 	}
-	enable = TRUE;
+	enable = true;
 
 	/*
 	 * Clear any outstanding parity error
@@ -1115,33 +1115,33 @@ ahc_probe_ext_scbram(struct ahc_softc *a
 	ahc_outb(ahc, CLRINT, CLRBRKADRINT);
 
 	/* Now see if we can do parity */
-	ahc_scbram_config(ahc, enable, /*pcheck*/TRUE, fast, large);
+	ahc_scbram_config(ahc, enable, /*pcheck*/true, fast, large);
 	num_scbs = ahc_probe_scbs(ahc);
 	if ((ahc_inb(ahc, INTSTAT) & BRKADRINT) == 0
 	 || (ahc_inb(ahc, ERROR) & MPARERR) == 0)
-		pcheck = TRUE;
+		pcheck = true;
 
 	/* Clear any resulting parity error */
 	ahc_outb(ahc, CLRINT, CLRPARERR);
 	ahc_outb(ahc, CLRINT, CLRBRKADRINT);
 
 	/* Now see if we can do fast timing */
-	ahc_scbram_config(ahc, enable, pcheck, /*fast*/TRUE, large);
+	ahc_scbram_config(ahc, enable, pcheck, /*fast*/true, large);
 	test_num_scbs = ahc_probe_scbs(ahc);
 	if (test_num_scbs == num_scbs
 	 && ((ahc_inb(ahc, INTSTAT) & BRKADRINT) == 0
 	  || (ahc_inb(ahc, ERROR) & MPARERR) == 0))
-		fast = TRUE;
+		fast = true;
 
 	/*
 	 * See if we can use large SCBs and still maintain
 	 * the same overall count of SCBs.
 	 */
 	if ((ahc->features & AHC_LARGE_SCBS) != 0) {
-		ahc_scbram_config(ahc, enable, pcheck, fast, /*large*/TRUE);
+		ahc_scbram_config(ahc, enable, pcheck, fast, /*large*/true);
 		test_num_scbs = ahc_probe_scbs(ahc);
 		if (test_num_scbs >= num_scbs) {
-			large = TRUE;
+			large = true;
 			num_scbs = test_num_scbs;
 	 		if (num_scbs >= 64) {
 				/*
@@ -1395,7 +1395,7 @@ check_extport(struct ahc_softc *ahc, u_i
 	 */
 	if ((ahc->features & AHC_SPIOCAP) != 0) {
 		if ((ahc_inb(ahc, SPIOCAP) & SSPIOCPS) == 0)
-			have_autoterm = FALSE;
+			have_autoterm = false;
 	}
 
 	if (have_autoterm) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_proc.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aic7xxx_proc.c
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -288,7 +288,7 @@ ahc_proc_write_seeprom(struct ahc_softc 
 		sd.sd_CK = CK_2840;
 		sd.sd_DO = DO_2840;
 		sd.sd_DI = DI_2840;
-		have_seeprom = TRUE;
+		have_seeprom = true;
 	} else {
 		printf("ahc_proc_write_seeprom: unsupported adapter type\n");
 		goto done;
@@ -344,7 +344,7 @@ ahc_linux_proc_info(struct Scsi_Host *sh
 	int	retval;
 
 	 /* Has data been written to the file? */ 
-	if (inout == TRUE) {
+	if (inout) {
 		retval = ahc_proc_write_seeprom(ahc, buffer, length);
 		goto done;
 	}
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aicasm/aicasm.c
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -555,7 +555,7 @@ output_listing(char *ifilename)
 		if (func_values == NULL)
 			stop("Could not malloc", EX_OSERR);
 		
-		func_values[0] = 0; /* FALSE func */
+		func_values[0] = 0; /* false func */
 		func_count--;
 
 		/*
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aicasm/aicasm.h
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.h~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm.h
@@ -48,14 +48,6 @@
 #include <sys/queue.h>
 #endif
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 typedef struct path_entry {
 	char	*directory;
 	int	quoted_includes_only;
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_gram.y~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -980,14 +980,14 @@ critical_section_start:
 	{
 		critical_section_t *cs;
 
-		if (in_critical_section != FALSE) {
+		if (in_critical_section) {
 			stop("Critical Section within Critical Section",
 			     EX_DATAERR);
 			/* NOTREACHED */
 		}
 		cs = cs_alloc();
 		cs->begin_addr = instruction_ptr;
-		in_critical_section = TRUE;
+		in_critical_section = true;
 	}
 ;
 
@@ -996,13 +996,13 @@ critical_section_end:
 	{
 		critical_section_t *cs;
 
-		if (in_critical_section == FALSE) {
+		if (!in_critical_section) {
 			stop("Unballanced 'end_cs'", EX_DATAERR);
 			/* NOTREACHED */
 		}
 		cs = TAILQ_LAST(&cs_tailq, cs_tailq);
 		cs->end_addr = instruction_ptr;
-		in_critical_section = FALSE;
+		in_critical_section = false;
 	}
 ;
 
@@ -1290,7 +1290,7 @@ code:
 		expression_t immed;
 
 		make_expression(&immed, 0xff);
-		format_1_instr(AIC_OP_AND, &none, &immed, &allzeros, TRUE);
+		format_1_instr(AIC_OP_AND, &none, &immed, &allzeros, true);
 	}
 ;
 
@@ -1436,7 +1436,7 @@ process_field(int field_type, symbol_t *
 	symlist_add(&(sym->info.finfo->symrefs), cur_symbol,
 		    SYMLIST_INSERT_HEAD);
 	cur_symbol->info.rinfo->valid_bitmask |= sym->info.finfo->mask;
-	cur_symbol->info.rinfo->typecheck_masks = TRUE;
+	cur_symbol->info.rinfo->typecheck_masks = true;
 	symlist_add(&(cur_symbol->info.rinfo->fields), sym, SYMLIST_SORT);
 }
 
@@ -1835,16 +1835,16 @@ type_check(symbol_t *symbol, expression_
 	symbol_node_t *node;
 	int and_op;
 
-	and_op = FALSE;
+	and_op = false;
 	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || AIC_OP_JZ)
-		and_op = TRUE;
+		and_op = true;
 
 	/*
 	 * Make sure that we aren't attempting to write something
 	 * that hasn't been defined.  If this is an and operation,
 	 * this is a mask, so "undefined" bits are okay.
 	 */
-	if (and_op == FALSE
+	if (!and_op
 	 && (expression->value & ~symbol->info.rinfo->valid_bitmask) != 0) {
 		snprintf(errbuf, sizeof(errbuf),
 			 "Invalid bit(s) 0x%x in immediate written to %s",
@@ -1858,7 +1858,7 @@ type_check(symbol_t *symbol, expression_
 	 * Now make sure that all of the symbols referenced by the
 	 * expression are defined for this register.
 	 */
-	if (symbol->info.rinfo->typecheck_masks != FALSE) {
+	if (symbol->info.rinfo->typecheck_masks) {
 		for(node = expression->referenced_syms.slh_first;
 		    node != NULL;
 		    node = node->links.sle_next) {
@@ -1954,7 +1954,7 @@ is_download_const(expression_t *immed)
 {
 	if ((immed->referenced_syms.slh_first != NULL)
 	 && (immed->referenced_syms.slh_first->symbol->type == DOWNLOAD_CONST))
-		return (TRUE);
+		return (true);
 
-	return (FALSE);
+	return (false);
 }
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_scan.l~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -159,7 +159,7 @@ PATCH_ARG_LIST		{ return T_PATCH_ARG_LIS
 	/* Register/SCB/SRAM definition keywords */
 export			{ return T_EXPORT; }
 register		{ return T_REGISTER; }
-const			{ yylval.value = FALSE; return T_CONST; }
+const			{ yylval.value = false; return T_CONST; }
 download		{ return T_DOWNLOAD; }
 address			{ return T_ADDRESS; }
 access_mode		{ return T_ACCESS_MODE; }
@@ -476,7 +476,7 @@ include_file(char *file_name, include_ty
                      include_dir = include_dir->links.sle_next) {
 			char fullname[PATH_MAX];
 
-			if ((include_dir->quoted_includes_only == TRUE)
+			if (include_dir->quoted_includes_only
 			 && (type != QUOTED_INCLUDE))
 				continue;
 
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c~drivers-scsi-aic7xxx-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -230,7 +230,7 @@ symlist_add(symlist_t *symlist, symbol_t
 		symbol_node_t *curnode;
 		int field;
 
-		field = FALSE;
+		field = false;
 		switch(symbol->type) {
 		case REGISTER:
 		case SCBLOC:
@@ -240,7 +240,7 @@ symlist_add(symlist_t *symlist, symbol_t
 		case MASK:
 		case ENUM:
 		case ENUM_ENTRY:
-			field = TRUE;
+			field = true;
 			break;
 		default:
 			stop("symlist_add: Invalid symbol type for sorting",
_
