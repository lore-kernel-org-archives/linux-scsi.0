From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] aic79xx: Sanitize inb / outb handling
Date: Thu, 22 Dec 2005 15:22:13 +0100
Message-ID: <43AAB695.6030808@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070206000300080406080901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:36485 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030187AbVLVOWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 09:22:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070206000300080406080901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patches coalesces inb/outb calls to the approriate word or long form=
=2E
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070206000300080406080901
Content-Type: text/plain;
 name="0004-aic79xx-Sanitize-inb-outb-handling.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0004-aic79xx-Sanitize-inb-outb-handling.txt"

[PATCH 4/6] aic79xx: Sanitize inb / outb handling

This patches coalesces inb/outb calls to the approriate word or long form.
---

 drivers/scsi/aic7xxx/aic79xx_core.c |   80 +++++++++--------------------------
 1 files changed, 21 insertions(+), 59 deletions(-)

a41a0c3e581feb48d7bacf39cfc047dd6e95f18d
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -387,8 +387,7 @@ ahd_flush_qoutfifo(struct ahd_softc *ahd
 		u_int fifo_mode;
 		u_int i;
 		
-		scbid = (ahd_inb(ahd, GSFIFO+1) << 8)
-		      | ahd_inb(ahd, GSFIFO);
+		scbid = ahd_inw(ahd, GSFIFO);
 		scb = ahd_lookup_scb(ahd, scbid);
 		if (scb == NULL) {
 			printf("%s: Warning - GSFIFO SCB %d invalid\n",
@@ -748,7 +747,7 @@ ahd_run_data_fifo(struct ahd_softc *ahd,
 			 * Advertise the segment to the hardware.
 			 */
 			dfcntrl = ahd_inb(ahd, DFCNTRL)|PRELOADEN|HDMAEN;
-			if ((ahd->features & AHD_NEW_DFCNTRL_OPTS)!=0) {
+			if ((ahd->features & AHD_NEW_DFCNTRL_OPTS) != 0) {
 				/*
 				 * Use SCSIENWRDIS so that SCSIEN
 				 * is never modified by this
@@ -1060,7 +1059,7 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 			ahd_outb(ahd, SAVED_LUN, 0);
 			ahd_outb(ahd, SEQ_FLAGS, 0);
 			ahd_assert_atn(ahd);
-			scb->flags &= ~(SCB_PACKETIZED);
+			scb->flags &= ~SCB_PACKETIZED;
 			scb->flags |= SCB_ABORT|SCB_CMDPHASE_ABORT;
 			ahd_freeze_devq(ahd, scb);
 			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
@@ -2310,8 +2309,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 		       "PRGMCNT == 0x%x\n",
 		       ahd_lookup_phase_entry(lastphase)->phasemsg,
 		       aborted,
-		       ahd_inb(ahd, PRGMCNT)
-			| (ahd_inb(ahd, PRGMCNT+1) << 8));
+		       ahd_inw(ahd, PRGMCNT));
 		ahd_dump_card_state(ahd);
 	}
 	/* Always restart the sequencer. */
@@ -2474,8 +2472,7 @@ ahd_clear_critical_section(struct ahd_so
 		u_int	i;
 
 		ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-		seqaddr = ahd_inb(ahd, CURADDR)
-			| (ahd_inb(ahd, CURADDR+1) << 8);
+		seqaddr = ahd_inw(ahd, CURADDR);
 
 		cs = ahd->critical_sections;
 		for (i = 0; i < ahd->num_critical_sections; i++, cs++) {
@@ -4909,10 +4906,7 @@ ahd_reinitialize_dataptrs(struct ahd_sof
 	 * Determine initial values for data_addr and data_cnt
 	 * for resuming the data phase.
 	 */
-	sgptr = (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 3) << 24)
-	      | (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 2) << 16)
-	      | (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 1) << 8)
-	      |	ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR);
+	sgptr = ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR);
 	sgptr &= SG_PTR_MASK;
 
 	resid = (ahd_inb_scbram(ahd, SCB_RESIDUAL_DATACNT + 2) << 16)
@@ -4930,10 +4924,7 @@ ahd_reinitialize_dataptrs(struct ahd_sof
 		dataptr = ahd_le64toh(sg->addr)
 			+ (ahd_le32toh(sg->len) & AHD_SG_LEN_MASK)
 			- resid;
-		ahd_outb(ahd, HADDR + 7, dataptr >> 56);
-		ahd_outb(ahd, HADDR + 6, dataptr >> 48);
-		ahd_outb(ahd, HADDR + 5, dataptr >> 40);
-		ahd_outb(ahd, HADDR + 4, dataptr >> 32);
+		ahd_outl(ahd, HADDR + 4, dataptr >> 32);
 	} else {
 		struct	 ahd_dma_seg *sg;
 
@@ -4948,10 +4939,7 @@ ahd_reinitialize_dataptrs(struct ahd_sof
 		ahd_outb(ahd, HADDR + 4,
 			 (ahd_le32toh(sg->len) & ~AHD_SG_LEN_MASK) >> 24);
 	}
-	ahd_outb(ahd, HADDR + 3, dataptr >> 24);
-	ahd_outb(ahd, HADDR + 2, dataptr >> 16);
-	ahd_outb(ahd, HADDR + 1, dataptr >> 8);
-	ahd_outb(ahd, HADDR, dataptr);
+	ahd_outl(ahd, HADDR, dataptr);
 	ahd_outb(ahd, HCNT + 2, resid >> 16);
 	ahd_outb(ahd, HCNT + 1, resid >> 8);
 	ahd_outb(ahd, HCNT, resid);
@@ -6567,14 +6555,8 @@ ahd_chip_init(struct ahd_softc *ahd)
 	 * Tell the sequencer where it can find our arrays in memory.
 	 */
 	busaddr = ahd->shared_data_map.physaddr;
-	ahd_outb(ahd, SHARED_DATA_ADDR, busaddr & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 3, (busaddr >> 24) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR, busaddr & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, SHARED_DATA_ADDR, busaddr);
+	ahd_outl(ahd, QOUTFIFO_NEXT_ADDR, busaddr);
 
 	/*
 	 * Setup the allowed SCSI Sequences based on operational mode.
@@ -6623,10 +6605,7 @@ ahd_chip_init(struct ahd_softc *ahd)
 	 * Tell the sequencer which SCB will be the next one it receives.
 	 */
 	busaddr = ahd_le32toh(ahd->next_queued_hscb->hscb_busaddr);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);
 
 	/*
 	 * Default to coalescing disabled.
@@ -7159,10 +7138,7 @@ ahd_qinfifo_requeue(struct ahd_softc *ah
 		uint32_t busaddr;
 
 		busaddr = ahd_le32toh(scb->hscb->hscb_busaddr);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+		ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);
 	} else {
 		prev_scb->hscb->next_hscb_busaddr = scb->hscb->hscb_busaddr;
 		ahd_sync_scb(ahd, prev_scb, 
@@ -7269,10 +7245,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd
 	 */
 	ahd->qinfifonext = qinstart;
 	busaddr = ahd_le32toh(ahd->next_queued_hscb->hscb_busaddr);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);
 
 	while (qinpos != qintail) {
 		scb = ahd_lookup_scb(ahd, ahd->qinfifo[qinpos]);
@@ -7743,7 +7716,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	 */
 	ahd_clear_msg_state(ahd);
 	ahd_outb(ahd, SIMODE1,
-		 ahd_inb(ahd, SIMODE1) & ~(ENBUSFREE|ENSCSIRST|ENBUSFREE));
+		 ahd_inb(ahd, SIMODE1) & ~(ENBUSFREE|ENSCSIRST));
 
 	if (initiate_reset)
 		ahd_reset_current_bus(ahd);
@@ -8321,8 +8294,7 @@ ahd_dumpseq(struct ahd_softc* ahd)
 	max_prog = 2048;
 
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE|LOADRAM);
-	ahd_outb(ahd, PRGMCNT, 0);
-	ahd_outb(ahd, PRGMCNT+1, 0);
+	ahd_outw(ahd, PRGMCNT, 0);
 	for (i = 0; i < max_prog; i++) {
 		uint8_t ins_bytes[4];
 
@@ -8437,8 +8409,7 @@ ahd_loadseq(struct ahd_softc *ahd)
 	downloaded = 0;
 	skip_addr = 0;
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE|LOADRAM);
-	ahd_outb(ahd, PRGMCNT, 0);
-	ahd_outb(ahd, PRGMCNT+1, 0);
+	ahd_outw(ahd, PRGMCNT, 0);
 
 	for (i = 0; i < sizeof(seqprog)/4; i++) {
 		if (ahd_check_patch(ahd, &cur_patch, i, &skip_addr) == 0) {
@@ -8731,7 +8702,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n"
 	       "%s: Dumping Card State at program address 0x%x Mode 0x%x\n",
 	       ahd_name(ahd), 
-	       ahd_inb(ahd, CURADDR) | (ahd_inb(ahd, CURADDR+1) << 8),
+	       ahd_inw(ahd, CURADDR),
 	       ahd_build_mode_state(ahd, ahd->saved_src_mode,
 				    ahd->saved_dst_mode));
 	if (paused)
@@ -9427,13 +9398,9 @@ ahd_handle_en_lun(struct ahd_softc *ahd,
 			if ((ahd->features & AHD_MULTI_TID) != 0) {
 				u_int targid_mask;
 
-				targid_mask = ahd_inb(ahd, TARGID)
-					    | (ahd_inb(ahd, TARGID + 1) << 8);
-
+				targid_mask = ahd_inw(ahd, TARGID);
 				targid_mask |= target_mask;
-				ahd_outb(ahd, TARGID, targid_mask);
-				ahd_outb(ahd, TARGID+1, (targid_mask >> 8));
-				
+				ahd_outw(ahd, TARGID, targid_mask);
 				ahd_update_scsiid(ahd, targid_mask);
 			} else {
 				u_int our_id;
@@ -9547,14 +9514,9 @@ ahd_handle_en_lun(struct ahd_softc *ahd,
 				if (ahd->features & AHD_MULTI_TID) {
 					u_int targid_mask;
 
-					targid_mask = ahd_inb(ahd, TARGID)
-						    | (ahd_inb(ahd, TARGID + 1)
-						       << 8);
-
+					targid_mask = ahd_inw(ahd, TARGID);
 					targid_mask &= ~target_mask;
-					ahd_outb(ahd, TARGID, targid_mask);
-					ahd_outb(ahd, TARGID+1,
-					 	 (targid_mask >> 8));
+					ahd_outw(ahd, TARGID, targid_mask);
 					ahd_update_scsiid(ahd, targid_mask);
 				}
 			}

--------------070206000300080406080901--
