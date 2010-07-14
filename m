From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] aic7xxx: Remove OS utility wrappers
Date: Wed, 14 Jul 2010 13:12:57 +0300
Message-ID: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jiri Kosina <jkosina@suse.cz>, =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?utf-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch removes malloc(), free(), and printf() wrappers from the aic=
7xxx
SCSI driver. I didn't use pr_debug for printf because of some 'clever' =
uses of
printf don't compile with the pr_debug. I didn't fix the overeager uses=
 of
GFP_ATOMIC either because I wanted to keep this patch as simple as poss=
ible.

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Uwe Kleine-K=C3=B6nig" <u.kleine-koenig@pengutronix.de>
Cc: "Andr=C3=A9 Goddard Rosa" <andre.goddard@gmail.com>
Cc: <linux-scsi@vger.kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/scsi/aic7xxx/aic7770.c         |   10 +-
 drivers/scsi/aic7xxx/aic7770_osm.c     |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c    |  624 ++++++++++++++++--------=
--------
 drivers/scsi/aic7xxx/aic79xx_osm.c     |  108 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.h     |    7 -
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    8 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c     |   56 ++--
 drivers/scsi/aic7xxx/aic79xx_proc.c    |   13 +-
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c   |   10 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c    |  430 +++++++++++-----------
 drivers/scsi/aic7xxx/aic7xxx_osm.c     |   76 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.h     |    7 -
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    8 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |   74 ++--
 drivers/scsi/aic7xxx/aic7xxx_proc.c    |   15 +-
 15 files changed, 711 insertions(+), 737 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/aic7=
770.c
index 6d86a9b..ef79dc4 100644
--- a/drivers/scsi/aic7xxx/aic7770.c
+++ b/drivers/scsi/aic7xxx/aic7770.c
@@ -170,7 +170,7 @@ aic7770_config(struct ahc_softc *ahc, struct aic777=
0_identity *entry, u_int io)
 	case 15:
 		break;
 	default:
-		printf("aic7770_config: invalid irq setting %d\n", intdef);
+		printk("aic7770_config: invalid irq setting %d\n", intdef);
 		return (ENXIO);
 	}
=20
@@ -293,7 +293,7 @@ aha2840_load_seeprom(struct ahc_softc *ahc)
 	sc =3D ahc->seep_config;
=20
 	if (bootverbose)
-		printf("%s: Reading SEEPROM...", ahc_name(ahc));
+		printk("%s: Reading SEEPROM...", ahc_name(ahc));
 	have_seeprom =3D ahc_read_seeprom(&sd, (uint16_t *)sc,
 					/*start_addr*/0, sizeof(*sc)/2);
=20
@@ -301,16 +301,16 @@ aha2840_load_seeprom(struct ahc_softc *ahc)
=20
 		if (ahc_verify_cksum(sc) =3D=3D 0) {
 			if(bootverbose)
-				printf ("checksum error\n");
+				printk ("checksum error\n");
 			have_seeprom =3D 0;
 		} else if (bootverbose) {
-			printf("done.\n");
+			printk("done.\n");
 		}
 	}
=20
 	if (!have_seeprom) {
 		if (bootverbose)
-			printf("%s: No SEEPROM available\n", ahc_name(ahc));
+			printk("%s: No SEEPROM available\n", ahc_name(ahc));
 		ahc->flags |=3D AHC_USEDEFAULTS;
 	} else {
 		/*
diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/=
aic7770_osm.c
index f220e5e..0cb8ef6 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -85,7 +85,7 @@ aic7770_probe(struct device *dev)
 	int	error;
=20
 	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
-	name =3D malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (name =3D=3D NULL)
 		return (ENOMEM);
 	strcpy(name, buf);
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx=
/aic79xx_core.c
index 78971db..3233bf5 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -289,7 +289,7 @@ ahd_set_modes(struct ahd_softc *ahd, ahd_mode src, =
ahd_mode dst)
 	 || ahd->dst_mode =3D=3D AHD_MODE_UNKNOWN)
 		panic("Setting mode prior to saving it.\n");
 	if ((ahd_debug & AHD_SHOW_MODEPTR) !=3D 0)
-		printf("%s: Setting mode 0x%x\n", ahd_name(ahd),
+		printk("%s: Setting mode 0x%x\n", ahd_name(ahd),
 		       ahd_build_mode_state(ahd, src, dst));
 #endif
 	ahd_outb(ahd, MODE_PTR, ahd_build_mode_state(ahd, src, dst));
@@ -307,7 +307,7 @@ ahd_update_modes(struct ahd_softc *ahd)
 	mode_ptr =3D ahd_inb(ahd, MODE_PTR);
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MODEPTR) !=3D 0)
-		printf("Reading mode 0x%x\n", mode_ptr);
+		printk("Reading mode 0x%x\n", mode_ptr);
 #endif
 	ahd_extract_mode_state(ahd, mode_ptr, &src, &dst);
 	ahd_known_modes(ahd, src, dst);
@@ -877,7 +877,7 @@ ahd_queue_scb(struct ahd_softc *ahd, struct scb *sc=
b)
 		uint64_t host_dataptr;
=20
 		host_dataptr =3D ahd_le64toh(scb->hscb->dataptr);
-		printf("%s: Queueing SCB %d:0x%x bus addr 0x%x - 0x%x%x/0x%x\n",
+		printk("%s: Queueing SCB %d:0x%x bus addr 0x%x - 0x%x%x/0x%x\n",
 		       ahd_name(ahd),
 		       SCB_GET_TAG(scb), scb->hscb->scsiid,
 		       ahd_le32toh(scb->hscb->hscb_busaddr),
@@ -1174,7 +1174,7 @@ ahd_clear_fifo(struct ahd_softc *ahd, u_int fifo)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_FIFOS) !=3D 0)
-		printf("%s: Clearing FIFO %d\n", ahd_name(ahd), fifo);
+		printk("%s: Clearing FIFO %d\n", ahd_name(ahd), fifo);
 #endif
 	saved_modes =3D ahd_save_modes(ahd);
 	ahd_set_modes(ahd, fifo, fifo);
@@ -1215,7 +1215,7 @@ ahd_flush_qoutfifo(struct ahd_softc *ahd)
 		scbid =3D ahd_inw(ahd, GSFIFO);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: Warning - GSFIFO SCB %d invalid\n",
+			printk("%s: Warning - GSFIFO SCB %d invalid\n",
 			       ahd_name(ahd), scbid);
 			continue;
 		}
@@ -1339,7 +1339,7 @@ rescan_fifos:
 		next_scbid =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: Warning - DMA-up and complete "
+			printk("%s: Warning - DMA-up and complete "
 			       "SCB %d invalid\n", ahd_name(ahd), scbid);
 			continue;
 		}
@@ -1360,7 +1360,7 @@ rescan_fifos:
 		next_scbid =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: Warning - Complete Qfrz SCB %d invalid\n",
+			printk("%s: Warning - Complete Qfrz SCB %d invalid\n",
 			       ahd_name(ahd), scbid);
 			continue;
 		}
@@ -1377,7 +1377,7 @@ rescan_fifos:
 		next_scbid =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: Warning - Complete SCB %d invalid\n",
+			printk("%s: Warning - Complete SCB %d invalid\n",
 			       ahd_name(ahd), scbid);
 			continue;
 		}
@@ -1682,7 +1682,7 @@ ahd_run_qoutfifo(struct ahd_softc *ahd)
 		scb_index =3D ahd_le16toh(completion->tag);
 		scb =3D ahd_lookup_scb(ahd, scb_index);
 		if (scb =3D=3D NULL) {
-			printf("%s: WARNING no command for scb %d "
+			printk("%s: WARNING no command for scb %d "
 			       "(cmdcmplt)\nQOUTPOS =3D %d\n",
 			       ahd_name(ahd), scb_index,
 			       ahd->qoutfifonext);
@@ -1714,7 +1714,7 @@ ahd_handle_hwerrint(struct ahd_softc *ahd)
 	error =3D ahd_inb(ahd, ERROR);
 	for (i =3D 0; i < num_errors; i++) {
 		if ((error & ahd_hard_errors[i].errno) !=3D 0)
-			printf("%s: hwerrint, %s\n",
+			printk("%s: hwerrint, %s\n",
 			       ahd_name(ahd), ahd_hard_errors[i].errmesg);
 	}
=20
@@ -1747,7 +1747,7 @@ ahd_dump_sglist(struct scb *scb)
=20
 				addr =3D ahd_le64toh(sg_list[i].addr);
 				len =3D ahd_le32toh(sg_list[i].len);
-				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
+				printk("sg[%d] - Addr 0x%x%x : Length %d%s\n",
 				       i,
 				       (uint32_t)((addr >> 32) & 0xFFFFFFFF),
 				       (uint32_t)(addr & 0xFFFFFFFF),
@@ -1763,7 +1763,7 @@ ahd_dump_sglist(struct scb *scb)
 				uint32_t len;
=20
 				len =3D ahd_le32toh(sg_list[i].len);
-				printf("sg[%d] - Addr 0x%x%x : Length %d%s\n",
+				printk("sg[%d] - Addr 0x%x%x : Length %d%s\n",
 				       i,
 				       (len & AHD_SG_HIGH_ADDR_MASK) >> 24,
 				       ahd_le32toh(sg_list[i].addr),
@@ -1802,7 +1802,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 	ahd_update_modes(ahd);
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-		printf("%s: Handle Seqint Called for code %d\n",
+		printk("%s: Handle Seqint Called for code %d\n",
 		       ahd_name(ahd), seqintcode);
 #endif
 	switch (seqintcode) {
@@ -1836,18 +1836,18 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int =
intstat)
 			 */
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0)
-				printf("%s: Assuming LQIPHASE_NLQ with "
+				printk("%s: Assuming LQIPHASE_NLQ with "
 				       "P0 assertion\n", ahd_name(ahd));
 #endif
 		}
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0)
-			printf("%s: Entering NONPACK\n", ahd_name(ahd));
+			printk("%s: Entering NONPACK\n", ahd_name(ahd));
 #endif
 		break;
 	}
 	case INVALID_SEQINT:
-		printf("%s: Invalid Sequencer interrupt occurred, "
+		printk("%s: Invalid Sequencer interrupt occurred, "
 		       "resetting channel.\n",
 		       ahd_name(ahd));
 #ifdef AHD_DEBUG
@@ -1866,8 +1866,8 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		if (scb !=3D NULL)
 			ahd_print_path(ahd, scb);
 		else
-			printf("%s: ", ahd_name(ahd));
-		printf("SCB %d Packetized Status Overrun", scbid);
+			printk("%s: ", ahd_name(ahd));
+		printk("SCB %d Packetized Status Overrun", scbid);
 		ahd_dump_card_state(ahd);
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 		break;
@@ -1881,7 +1881,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
 			ahd_dump_card_state(ahd);
-			printf("CFG4ISTAT: Free SCB %d referenced", scbid);
+			printk("CFG4ISTAT: Free SCB %d referenced", scbid);
 			panic("For safety");
 		}
 		ahd_outq(ahd, HADDR, scb->sense_busaddr);
@@ -1896,7 +1896,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		u_int bus_phase;
=20
 		bus_phase =3D ahd_inb(ahd, SCSISIGI) & PHASE_MASK;
-		printf("%s: ILLEGAL_PHASE 0x%x\n",
+		printk("%s: ILLEGAL_PHASE 0x%x\n",
 		       ahd_name(ahd), bus_phase);
=20
 		switch (bus_phase) {
@@ -1908,7 +1908,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		case P_STATUS:
 		case P_MESGIN:
 			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
-			printf("%s: Issued Bus Reset.\n", ahd_name(ahd));
+			printk("%s: Issued Bus Reset.\n", ahd_name(ahd));
 			break;
 		case P_COMMAND:
 		{
@@ -1933,7 +1933,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 			scbid =3D ahd_get_scbptr(ahd);
 			scb =3D ahd_lookup_scb(ahd, scbid);
 			if (scb =3D=3D NULL) {
-				printf("Invalid phase with no valid SCB.  "
+				printk("Invalid phase with no valid SCB.  "
 				       "Resetting bus.\n");
 				ahd_reset_channel(ahd, 'A',
 						  /*Initiate Reset*/TRUE);
@@ -1997,7 +1997,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0) {
 				ahd_print_path(ahd, scb);
-				printf("Unexpected command phase from "
+				printk("Unexpected command phase from "
 				       "packetized target\n");
 			}
 #endif
@@ -2013,7 +2013,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 	=09
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0) {
-			printf("%s: CFG4OVERRUN mode =3D %x\n", ahd_name(ahd),
+			printk("%s: CFG4OVERRUN mode =3D %x\n", ahd_name(ahd),
 			       ahd_inb(ahd, MODE_PTR));
 		}
 #endif
@@ -2049,7 +2049,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 	{
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0) {
-			printf("%s: PDATA_REINIT - DFCNTRL =3D 0x%x "
+			printk("%s: PDATA_REINIT - DFCNTRL =3D 0x%x "
 			       "SG_CACHE_SHADOW =3D 0x%x\n",
 			       ahd_name(ahd), ahd_inb(ahd, DFCNTRL),
 			       ahd_inb(ahd, SG_CACHE_SHADOW));
@@ -2082,7 +2082,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 			bus_phase =3D ahd_inb(ahd, SCSISIGI) & PHASE_MASK;
 			if (bus_phase !=3D P_MESGIN
 			 && bus_phase !=3D P_MESGOUT) {
-				printf("ahd_intr: HOST_MSG_LOOP bad "
+				printk("ahd_intr: HOST_MSG_LOOP bad "
 				       "phase 0x%x\n", bus_phase);
 				/*
 				 * Probably transitioned to bus free before
@@ -2131,29 +2131,29 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int =
intstat)
 		AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
 		ahd_outb(ahd, SCSISEQ0, ahd_inb(ahd, SCSISEQ0) & ~ENSELO);
=20
-		printf("%s:%c:%d: no active SCB for reconnecting "
+		printk("%s:%c:%d: no active SCB for reconnecting "
 		       "target - issuing BUS DEVICE RESET\n",
 		       ahd_name(ahd), 'A', ahd_inb(ahd, SELID) >> 4);
-		printf("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
+		printk("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
 		       "REG0 =3D=3D 0x%x ACCUM =3D 0x%x\n",
 		       ahd_inb(ahd, SAVED_SCSIID), ahd_inb(ahd, SAVED_LUN),
 		       ahd_inw(ahd, REG0), ahd_inb(ahd, ACCUM));
-		printf("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
+		printk("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
 		       "SINDEX =3D=3D 0x%x\n",
 		       ahd_inb(ahd, SEQ_FLAGS), ahd_get_scbptr(ahd),
 		       ahd_find_busy_tcl(ahd,
 					 BUILD_TCL(ahd_inb(ahd, SAVED_SCSIID),
 						   ahd_inb(ahd, SAVED_LUN))),
 		       ahd_inw(ahd, SINDEX));
-		printf("SELID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0x=
%x, "
+		printk("SELID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0x=
%x, "
 		       "SCB_CONTROL =3D=3D 0x%x\n",
 		       ahd_inb(ahd, SELID), ahd_inb_scbram(ahd, SCB_SCSIID),
 		       ahd_inb_scbram(ahd, SCB_LUN),
 		       ahd_inb_scbram(ahd, SCB_CONTROL));
-		printf("SCSIBUS[0] =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
+		printk("SCSIBUS[0] =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
 		       ahd_inb(ahd, SCSIBUS), ahd_inb(ahd, SCSISIGI));
-		printf("SXFRCTL0 =3D=3D 0x%x\n", ahd_inb(ahd, SXFRCTL0));
-		printf("SEQCTL0 =3D=3D 0x%x\n", ahd_inb(ahd, SEQCTL0));
+		printk("SXFRCTL0 =3D=3D 0x%x\n", ahd_inb(ahd, SXFRCTL0));
+		printk("SEQCTL0 =3D=3D 0x%x\n", ahd_inb(ahd, SEQCTL0));
 		ahd_dump_card_state(ahd);
 		ahd->msgout_buf[0] =3D MSG_BUS_DEV_RESET;
 		ahd->msgout_len =3D 1;
@@ -2181,7 +2181,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		u_int lastphase;
=20
 		lastphase =3D ahd_inb(ahd, LASTPHASE);
-		printf("%s:%c:%d: unknown scsi bus phase %x, "
+		printk("%s:%c:%d: unknown scsi bus phase %x, "
 		       "lastphase =3D 0x%x.  Attempting to continue\n",
 		       ahd_name(ahd), 'A',
 		       SCSIID_TARGET(ahd, ahd_inb(ahd, SAVED_SCSIID)),
@@ -2193,7 +2193,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		u_int lastphase;
=20
 		lastphase =3D ahd_inb(ahd, LASTPHASE);
-		printf("%s:%c:%d: Missed busfree. "
+		printk("%s:%c:%d: Missed busfree. "
 		       "Lastphase =3D 0x%x, Curphase =3D 0x%x\n",
 		       ahd_name(ahd), 'A',
 		       SCSIID_TARGET(ahd, ahd_inb(ahd, SAVED_SCSIID)),
@@ -2223,11 +2223,11 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int =
intstat)
 		lastphase =3D ahd_inb(ahd, LASTPHASE);
 		if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0) {
 			ahd_print_path(ahd, scb);
-			printf("data overrun detected %s.  Tag =3D=3D 0x%x.\n",
+			printk("data overrun detected %s.  Tag =3D=3D 0x%x.\n",
 			       ahd_lookup_phase_entry(lastphase)->phasemsg,
 			       SCB_GET_TAG(scb));
 			ahd_print_path(ahd, scb);
-			printf("%s seen Data Phase.  Length =3D %ld.  "
+			printk("%s seen Data Phase.  Length =3D %ld.  "
 			       "NumSGs =3D %d.\n",
 			       ahd_inb(ahd, SEQ_FLAGS) & DPHASE
 			       ? "Have" : "Haven't",
@@ -2252,7 +2252,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		u_int scbid;
=20
 		ahd_fetch_devinfo(ahd, &devinfo);
-		printf("%s:%c:%d:%d: Attempt to issue message failed\n",
+		printk("%s:%c:%d:%d: Attempt to issue message failed\n",
 		       ahd_name(ahd), devinfo.channel, devinfo.target,
 		       devinfo.lun);
 		scbid =3D ahd_get_scbptr(ahd);
@@ -2285,7 +2285,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 			cam_status error;
=20
 			ahd_print_path(ahd, scb);
-			printf("Task Management Func 0x%x Complete\n",
+			printk("Task Management Func 0x%x Complete\n",
 			       scb->hscb->task_management);
 			lun =3D CAM_LUN_WILDCARD;
 			tag =3D SCB_LIST_NULL;
@@ -2341,7 +2341,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 			 * the QINFIFO if it is still there.
                          */
 			ahd_print_path(ahd, scb);
-			printf("SCB completes before TMF\n");
+			printk("SCB completes before TMF\n");
 			/*
 			 * Handle losing the race.  Wait until any
 			 * current selection completes.  We will then
@@ -2366,7 +2366,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 	case TRACEPOINT1:
 	case TRACEPOINT2:
 	case TRACEPOINT3:
-		printf("%s: Tracepoint %d\n", ahd_name(ahd),
+		printk("%s: Tracepoint %d\n", ahd_name(ahd),
 		       seqintcode - TRACEPOINT0);
 		break;
 	case NO_SEQINT:
@@ -2375,7 +2375,7 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int in=
tstat)
 		ahd_handle_hwerrint(ahd);
 		break;
 	default:
-		printf("%s: Unexpected SEQINTCODE %d\n", ahd_name(ahd),
+		printk("%s: Unexpected SEQINTCODE %d\n", ahd_name(ahd),
 		       seqintcode);
 		break;
 	}
@@ -2440,7 +2440,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 		u_int now_lvd;
=20
 		now_lvd =3D ahd_inb(ahd, SBLKCTL) & ENAB40;
-		printf("%s: Transceiver State Has Changed to %s mode\n",
+		printk("%s: Transceiver State Has Changed to %s mode\n",
 		       ahd_name(ahd), now_lvd ? "LVD" : "SE");
 		ahd_outb(ahd, CLRSINT0, CLRIOERR);
 		/*
@@ -2452,12 +2452,12 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int=
 intstat)
 		ahd_unpause(ahd);
 	} else if ((status0 & OVERRUN) !=3D 0) {
=20
-		printf("%s: SCSI offset overrun detected.  Resetting bus.\n",
+		printk("%s: SCSI offset overrun detected.  Resetting bus.\n",
 		       ahd_name(ahd));
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 	} else if ((status & SCSIRSTI) !=3D 0) {
=20
-		printf("%s: Someone reset channel A\n", ahd_name(ahd));
+		printk("%s: Someone reset channel A\n", ahd_name(ahd));
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/FALSE);
 	} else if ((status & SCSIPERR) !=3D 0) {
=20
@@ -2467,7 +2467,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 		ahd_handle_transmission_error(ahd);
 	} else if (lqostat0 !=3D 0) {
=20
-		printf("%s: lqostat0 =3D=3D 0x%x!\n", ahd_name(ahd), lqostat0);
+		printk("%s: lqostat0 =3D=3D 0x%x!\n", ahd_name(ahd), lqostat0);
 		ahd_outb(ahd, CLRLQOINT0, lqostat0);
 		if ((ahd->bugs & AHD_CLRLQO_AUTOCLR_BUG) !=3D 0)
 			ahd_outb(ahd, CLRLQOINT1, 0);
@@ -2497,7 +2497,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 		scbid =3D ahd_inw(ahd, WAITING_TID_HEAD);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: ahd_intr - referenced scb not "
+			printk("%s: ahd_intr - referenced scb not "
 			       "valid during SELTO scb(0x%x)\n",
 			       ahd_name(ahd), scbid);
 			ahd_dump_card_state(ahd);
@@ -2506,7 +2506,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_SELTO) !=3D 0) {
 				ahd_print_path(ahd, scb);
-				printf("Saw Selection Timeout for SCB 0x%x\n",
+				printk("Saw Selection Timeout for SCB 0x%x\n",
 				       scbid);
 			}
 #endif
@@ -2534,7 +2534,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 		ahd_iocell_first_selection(ahd);
 		ahd_unpause(ahd);
 	} else if (status3 !=3D 0) {
-		printf("%s: SCSI Cell parity error SSTAT3 =3D=3D 0x%x\n",
+		printk("%s: SCSI Cell parity error SSTAT3 =3D=3D 0x%x\n",
 		       ahd_name(ahd), status3);
 		ahd_outb(ahd, CLRSINT3, status3);
 	} else if ((lqistat1 & (LQIPHASE_LQ|LQIPHASE_NLQ)) !=3D 0) {
@@ -2587,7 +2587,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 			scbid =3D ahd_get_scbptr(ahd);
 			scb =3D ahd_lookup_scb(ahd, scbid);
 			if (scb =3D=3D NULL) {
-				printf("%s: Invalid SCB %d in DFF%d "
+				printk("%s: Invalid SCB %d in DFF%d "
 				       "during unexpected busfree\n",
 				       ahd_name(ahd), scbid, mode);
 				packetized =3D 0;
@@ -2620,7 +2620,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
=20
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-			printf("Saw Busfree.  Busfreetime =3D 0x%x.\n",
+			printk("Saw Busfree.  Busfreetime =3D 0x%x.\n",
 			       busfreetime);
 #endif
 		/*
@@ -2661,7 +2661,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int i=
ntstat)
 			ahd_unpause(ahd);
 		}
 	} else {
-		printf("%s: Missing case in ahd_handle_scsiint. status =3D %x\n",
+		printk("%s: Missing case in ahd_handle_scsiint. status =3D %x\n",
 		       ahd_name(ahd), status);
 		ahd_dump_card_state(ahd);
 		ahd_clear_intstat(ahd);
@@ -2697,7 +2697,7 @@ ahd_handle_transmission_error(struct ahd_softc *a=
hd)
 		 || (lqistate =3D=3D 0x29)) {
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0) {
-				printf("%s: NLQCRC found via LQISTATE\n",
+				printk("%s: NLQCRC found via LQISTATE\n",
 				       ahd_name(ahd));
 			}
 #endif
@@ -2729,18 +2729,18 @@ ahd_handle_transmission_error(struct ahd_softc =
*ahd)
=20
 	cur_col =3D 0;
 	if (silent =3D=3D FALSE) {
-		printf("%s: Transmission error detected\n", ahd_name(ahd));
+		printk("%s: Transmission error detected\n", ahd_name(ahd));
 		ahd_lqistat1_print(lqistat1, &cur_col, 50);
 		ahd_lastphase_print(lastphase, &cur_col, 50);
 		ahd_scsisigi_print(curphase, &cur_col, 50);
 		ahd_perrdiag_print(perrdiag, &cur_col, 50);
-		printf("\n");
+		printk("\n");
 		ahd_dump_card_state(ahd);
 	}
=20
 	if ((lqistat1 & (LQIOVERI_LQ|LQIOVERI_NLQ)) !=3D 0) {
 		if (silent =3D=3D FALSE) {
-			printf("%s: Gross protocol error during incoming "
+			printk("%s: Gross protocol error during incoming "
 			       "packet.  lqistat1 =3D=3D 0x%x.  Resetting bus.\n",
 			       ahd_name(ahd), lqistat1);
 		}
@@ -2769,7 +2769,7 @@ ahd_handle_transmission_error(struct ahd_softc *a=
hd)
 		 * (SPI4R09 10.7.3.3.3)
 		 */
 		ahd_outb(ahd, LQCTL2, LQIRETRY);
-		printf("LQIRetry for LQICRCI_LQ to release ACK\n");
+		printk("LQIRetry for LQICRCI_LQ to release ACK\n");
 	} else if ((lqistat1 & LQICRCI_NLQ) !=3D 0) {
 		/*
 		 * We detected a CRC error in a NON-LQ packet.
@@ -2817,22 +2817,22 @@ ahd_handle_transmission_error(struct ahd_softc =
*ahd)
 		 * Busfree detection is enabled.
 		 */
 		if (silent =3D=3D FALSE)
-			printf("LQICRC_NLQ\n");
+			printk("LQICRC_NLQ\n");
 		if (scb =3D=3D NULL) {
-			printf("%s: No SCB valid for LQICRC_NLQ.  "
+			printk("%s: No SCB valid for LQICRC_NLQ.  "
 			       "Resetting bus\n", ahd_name(ahd));
 			ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 			return;
 		}
 	} else if ((lqistat1 & LQIBADLQI) !=3D 0) {
-		printf("Need to handle BADLQI!\n");
+		printk("Need to handle BADLQI!\n");
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 		return;
 	} else if ((perrdiag & (PARITYERR|PREVPHASE)) =3D=3D PARITYERR) {
 		if ((curphase & ~P_DATAIN_DT) !=3D 0) {
 			/* Ack the byte.  So we can continue. */
 			if (silent =3D=3D FALSE)
-				printf("Acking %s to clear perror\n",
+				printk("Acking %s to clear perror\n",
 				    ahd_lookup_phase_entry(curphase)->phasemsg);
 			ahd_inb(ahd, SCSIDAT);
 		}
@@ -2877,10 +2877,10 @@ ahd_handle_lqiphase_error(struct ahd_softc *ahd=
, u_int lqistat1)
 	if ((ahd_inb(ahd, SCSISIGO) & ATNO) !=3D 0
 	 && (ahd_inb(ahd, MDFFSTAT) & DLZERO) !=3D 0) {
 		if ((lqistat1 & LQIPHASE_LQ) !=3D 0) {
-			printf("LQIRETRY for LQIPHASE_LQ\n");
+			printk("LQIRETRY for LQIPHASE_LQ\n");
 			ahd_outb(ahd, LQCTL2, LQIRETRY);
 		} else if ((lqistat1 & LQIPHASE_NLQ) !=3D 0) {
-			printf("LQIRETRY for LQIPHASE_NLQ\n");
+			printk("LQIRETRY for LQIPHASE_NLQ\n");
 			ahd_outb(ahd, LQCTL2, LQIRETRY);
 		} else
 			panic("ahd_handle_lqiphase_error: No phase errors\n");
@@ -2888,7 +2888,7 @@ ahd_handle_lqiphase_error(struct ahd_softc *ahd, =
u_int lqistat1)
 		ahd_outb(ahd, CLRINT, CLRSCSIINT);
 		ahd_unpause(ahd);
 	} else {
-		printf("Reseting Channel for LQI Phase error\n");
+		printk("Reseting Channel for LQI Phase error\n");
 		ahd_dump_card_state(ahd);
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 	}
@@ -2976,7 +2976,7 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_i=
nt busfreetime)
 		if (scb->crc_retry_count < AHD_MAX_LQ_CRC_ERRORS) {
 			if (SCB_IS_SILENT(scb) =3D=3D FALSE) {
 				ahd_print_path(ahd, scb);
-				printf("Probable outgoing LQ CRC error.  "
+				printk("Probable outgoing LQ CRC error.  "
 				       "Retrying command\n");
 			}
 			scb->crc_retry_count++;
@@ -2998,7 +2998,7 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_i=
nt busfreetime)
 		ahd_outb(ahd, CLRSINT1, CLRSCSIPERR|CLRBUSFREE);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MASKED_ERRORS) !=3D 0)
-			printf("%s: Parity on last REQ detected "
+			printk("%s: Parity on last REQ detected "
 			       "during busfree phase.\n",
 			       ahd_name(ahd));
 #endif
@@ -3012,7 +3012,7 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_i=
nt busfreetime)
 		scbid =3D ahd_get_scbptr(ahd);
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		ahd_print_path(ahd, scb);
-		printf("Unexpected PKT busfree condition\n");
+		printk("Unexpected PKT busfree condition\n");
 		ahd_dump_card_state(ahd);
 		ahd_abort_scbs(ahd, SCB_GET_TARGET(ahd, scb), 'A',
 			       SCB_GET_LUN(scb), SCB_GET_TAG(scb),
@@ -3021,7 +3021,7 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_i=
nt busfreetime)
 		/* Return restarting the sequencer. */
 		return (1);
 	}
-	printf("%s: Unexpected PKT busfree condition\n", ahd_name(ahd));
+	printk("%s: Unexpected PKT busfree condition\n", ahd_name(ahd));
 	ahd_dump_card_state(ahd);
 	/* Restart the sequencer. */
 	return (1);
@@ -3076,14 +3076,14 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd=
)
=20
 			if (scb =3D=3D NULL) {
 				ahd_print_devinfo(ahd, &devinfo);
-				printf("Abort for unidentified "
+				printk("Abort for unidentified "
 				       "connection completed.\n");
 				/* restart the sequencer. */
 				return (1);
 			}
 			sent_msg =3D ahd->msgout_buf[ahd->msgout_index - 1];
 			ahd_print_path(ahd, scb);
-			printf("SCB %d - Abort%s Completed.\n",
+			printk("SCB %d - Abort%s Completed.\n",
 			       SCB_GET_TAG(scb),
 			       sent_msg =3D=3D MSG_ABORT_TAG ? "" : " Tag");
=20
@@ -3109,7 +3109,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			found =3D ahd_abort_scbs(ahd, target, 'A', saved_lun,
 					       tag, ROLE_INITIATOR,
 					       CAM_REQ_ABORTED);
-			printf("found =3D=3D 0x%x\n", found);
+			printk("found =3D=3D 0x%x\n", found);
 			printerror =3D 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_1B,
 					MSG_BUS_DEV_RESET, TRUE)) {
@@ -3147,7 +3147,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			 */
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("PPR negotiation rejected busfree.\n");
+				printk("PPR negotiation rejected busfree.\n");
 #endif
 			tinfo =3D ahd_fetch_transinfo(ahd, devinfo.channel,
 						    devinfo.our_scsiid,
@@ -3191,7 +3191,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			 */
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("WDTR negotiation rejected busfree.\n");
+				printk("WDTR negotiation rejected busfree.\n");
 #endif
 			ahd_set_width(ahd, &devinfo,
 				      MSG_EXT_WDTR_BUS_8_BIT,
@@ -3216,7 +3216,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			 */
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("SDTR negotiation rejected busfree.\n");
+				printk("SDTR negotiation rejected busfree.\n");
 #endif
 			ahd_set_syncrate(ahd, &devinfo,
 					/*period*/0, /*offset*/0,
@@ -3240,7 +3240,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
=20
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("Expected IDE Busfree\n");
+				printk("Expected IDE Busfree\n");
 #endif
 			printerror =3D 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_QASREJ_BUSFREE)
@@ -3249,7 +3249,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
=20
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("Expected QAS Reject Busfree\n");
+				printk("Expected QAS Reject Busfree\n");
 #endif
 			printerror =3D 0;
 		}
@@ -3275,7 +3275,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 		} else {
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf("PPR Negotiation Busfree.\n");
+				printk("PPR Negotiation Busfree.\n");
 #endif
 			ahd_done(ahd, scb);
 		}
@@ -3302,9 +3302,9 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 			 * We had not fully identified this connection,
 			 * so we cannot abort anything.
 			 */
-			printf("%s: ", ahd_name(ahd));
+			printk("%s: ", ahd_name(ahd));
 		}
-		printf("Unexpected busfree %s, %d SCBs aborted, "
+		printk("Unexpected busfree %s, %d SCBs aborted, "
 		       "PRGMCNT =3D=3D 0x%x\n",
 		       ahd_lookup_phase_entry(lastphase)->phasemsg,
 		       aborted,
@@ -3342,7 +3342,7 @@ ahd_handle_proto_violation(struct ahd_softc *ahd)
 		 * to match.
 		 */
 		ahd_print_devinfo(ahd, &devinfo);
-		printf("Target did not send an IDENTIFY message. "
+		printk("Target did not send an IDENTIFY message. "
 		       "LASTPHASE =3D 0x%x.\n", lastphase);
 		scb =3D NULL;
 	} else if (scb =3D=3D NULL) {
@@ -3351,13 +3351,13 @@ ahd_handle_proto_violation(struct ahd_softc *ah=
d)
 		 * transaction.  Print an error and reset the bus.
 		 */
 		ahd_print_devinfo(ahd, &devinfo);
-		printf("No SCB found during protocol violation\n");
+		printk("No SCB found during protocol violation\n");
 		goto proto_violation_reset;
 	} else {
 		ahd_set_transaction_status(scb, CAM_SEQUENCE_FAIL);
 		if ((seq_flags & NO_CDB_SENT) !=3D 0) {
 			ahd_print_path(ahd, scb);
-			printf("No or incomplete CDB sent to device.\n");
+			printk("No or incomplete CDB sent to device.\n");
 		} else if ((ahd_inb_scbram(ahd, SCB_CONTROL)
 			  & STATUS_RCVD) =3D=3D 0) {
 			/*
@@ -3368,10 +3368,10 @@ ahd_handle_proto_violation(struct ahd_softc *ah=
d)
 			 * message.
 			 */
 			ahd_print_path(ahd, scb);
-			printf("Completed command without status.\n");
+			printk("Completed command without status.\n");
 		} else {
 			ahd_print_path(ahd, scb);
-			printf("Unknown protocol violation.\n");
+			printk("Unknown protocol violation.\n");
 			ahd_dump_card_state(ahd);
 		}
 	}
@@ -3385,7 +3385,7 @@ proto_violation_reset:
 		 * it away with a bus reset.
 		 */
 		found =3D ahd_reset_channel(ahd, 'A', TRUE);
-		printf("%s: Issued Channel %c Bus Reset. "
+		printk("%s: Issued Channel %c Bus Reset. "
 		       "%d SCBs aborted\n", ahd_name(ahd), 'A', found);
 	} else {
 		/*
@@ -3407,7 +3407,7 @@ proto_violation_reset:
 			ahd_print_path(ahd, scb);
 			scb->flags |=3D SCB_ABORT;
 		}
-		printf("Protocol violation %s.  Attempting to abort.\n",
+		printk("Protocol violation %s.  Attempting to abort.\n",
 		       ahd_lookup_phase_entry(curphase)->phasemsg);
 	}
 }
@@ -3425,7 +3425,7 @@ ahd_force_renegotiation(struct ahd_softc *ahd, st=
ruct ahd_devinfo *devinfo)
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
 		ahd_print_devinfo(ahd, devinfo);
-		printf("Forcing renegotiation\n");
+		printk("Forcing renegotiation\n");
 	}
 #endif
 	targ_info =3D ahd_fetch_transinfo(ahd,
@@ -3486,7 +3486,7 @@ ahd_clear_critical_section(struct ahd_softc *ahd)
 			break;
=20
 		if (steps > AHD_MAX_STEPS) {
-			printf("%s: Infinite loop in critical section\n"
+			printk("%s: Infinite loop in critical section\n"
 			       "%s: First Instruction 0x%x now 0x%x\n",
 			       ahd_name(ahd), ahd_name(ahd), first_instr,
 			       seqaddr);
@@ -3497,7 +3497,7 @@ ahd_clear_critical_section(struct ahd_softc *ahd)
 		steps++;
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-			printf("%s: Single stepping at 0x%x\n", ahd_name(ahd),
+			printk("%s: Single stepping at 0x%x\n", ahd_name(ahd),
 			       seqaddr);
 #endif
 		if (stepping =3D=3D FALSE) {
@@ -3601,16 +3601,16 @@ ahd_print_scb(struct scb *scb)
 	int i;
=20
 	hscb =3D scb->hscb;
-	printf("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
+	printk("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
 	       (void *)scb,
 	       hscb->control,
 	       hscb->scsiid,
 	       hscb->lun,
 	       hscb->cdb_len);
-	printf("Shared Data: ");
+	printk("Shared Data: ");
 	for (i =3D 0; i < sizeof(hscb->shared_data.idata.cdb); i++)
-		printf("%#02x", hscb->shared_data.idata.cdb[i]);
-	printf("        dataptr:%#x%x datacnt:%#x sgptr:%#x tag:%#x\n",
+		printk("%#02x", hscb->shared_data.idata.cdb[i]);
+	printk("        dataptr:%#x%x datacnt:%#x sgptr:%#x tag:%#x\n",
 	       (uint32_t)((ahd_le64toh(hscb->dataptr) >> 32) & 0xFFFFFFFF),
 	       (uint32_t)(ahd_le64toh(hscb->dataptr) & 0xFFFFFFFF),
 	       ahd_le32toh(hscb->datacnt),
@@ -3637,7 +3637,7 @@ ahd_alloc_tstate(struct ahd_softc *ahd, u_int scs=
i_id, char channel)
 	 && ahd->enabled_targets[scsi_id] !=3D master_tstate)
 		panic("%s: ahd_alloc_tstate - Target already allocated",
 		      ahd_name(ahd));
-	tstate =3D malloc(sizeof(*tstate), M_DEVBUF, M_NOWAIT);
+	tstate =3D kmalloc(sizeof(*tstate), GFP_ATOMIC);
 	if (tstate =3D=3D NULL)
 		return (NULL);
=20
@@ -3682,7 +3682,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi=
_id, char channel, int force)
=20
 	tstate =3D ahd->enabled_targets[scsi_id];
 	if (tstate !=3D NULL)
-		free(tstate, M_DEVBUF);
+		kfree(tstate);
 	ahd->enabled_targets[scsi_id] =3D NULL;
 }
 #endif
@@ -3942,37 +3942,37 @@ ahd_set_syncrate(struct ahd_softc *ahd, struct =
ahd_devinfo *devinfo,
 			if (offset !=3D 0) {
 				int options;
=20
-				printf("%s: target %d synchronous with "
+				printk("%s: target %d synchronous with "
 				       "period =3D 0x%x, offset =3D 0x%x",
 				       ahd_name(ahd), devinfo->target,
 				       period, offset);
 				options =3D 0;
 				if ((ppr_options & MSG_EXT_PPR_RD_STRM) !=3D 0) {
-					printf("(RDSTRM");
+					printk("(RDSTRM");
 					options++;
 				}
 				if ((ppr_options & MSG_EXT_PPR_DT_REQ) !=3D 0) {
-					printf("%s", options ? "|DT" : "(DT");
+					printk("%s", options ? "|DT" : "(DT");
 					options++;
 				}
 				if ((ppr_options & MSG_EXT_PPR_IU_REQ) !=3D 0) {
-					printf("%s", options ? "|IU" : "(IU");
+					printk("%s", options ? "|IU" : "(IU");
 					options++;
 				}
 				if ((ppr_options & MSG_EXT_PPR_RTI) !=3D 0) {
-					printf("%s", options ? "|RTI" : "(RTI");
+					printk("%s", options ? "|RTI" : "(RTI");
 					options++;
 				}
 				if ((ppr_options & MSG_EXT_PPR_QAS_REQ) !=3D 0) {
-					printf("%s", options ? "|QAS" : "(QAS");
+					printk("%s", options ? "|QAS" : "(QAS");
 					options++;
 				}
 				if (options !=3D 0)
-					printf(")\n");
+					printk(")\n");
 				else
-					printf("\n");
+					printk("\n");
 			} else {
-				printf("%s: target %d using "
+				printk("%s: target %d using "
 				       "asynchronous transfers%s\n",
 				       ahd_name(ahd), devinfo->target,
 				       (ppr_options & MSG_EXT_PPR_QAS_REQ) !=3D 0
@@ -4000,7 +4000,7 @@ ahd_set_syncrate(struct ahd_softc *ahd, struct ah=
d_devinfo *devinfo,
 #ifdef AHD_DEBUG
 				if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
 					ahd_print_devinfo(ahd, devinfo);
-					printf("Expecting IU Change busfree\n");
+					printk("Expecting IU Change busfree\n");
 				}
 #endif
 				ahd->msg_flags |=3D MSG_FLAG_EXPECT_PPR_BUSFREE
@@ -4009,7 +4009,7 @@ ahd_set_syncrate(struct ahd_softc *ahd, struct ah=
d_devinfo *devinfo,
 			if ((old_ppr & MSG_EXT_PPR_IU_REQ) !=3D 0) {
 #ifdef AHD_DEBUG
 				if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-					printf("PPR with IU_REQ outstanding\n");
+					printk("PPR with IU_REQ outstanding\n");
 #endif
 				ahd->msg_flags |=3D MSG_FLAG_EXPECT_PPR_BUSFREE;
 			}
@@ -4061,7 +4061,7 @@ ahd_set_width(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo,
 		ahd_send_async(ahd, devinfo->channel, devinfo->target,
 			       CAM_LUN_WILDCARD, AC_TRANSFER_NEG);
 		if (bootverbose) {
-			printf("%s: target %d using %dbit transfers\n",
+			printk("%s: target %d using %dbit transfers\n",
 			       ahd_name(ahd), devinfo->target,
 			       8 * (0x01 << width));
 		}
@@ -4337,7 +4337,7 @@ ahd_fetch_devinfo(struct ahd_softc *ahd, struct a=
hd_devinfo *devinfo)
 void
 ahd_print_devinfo(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
 {
-	printf("%s:%c:%d:%d: ", ahd_name(ahd), 'A',
+	printk("%s:%c:%d:%d: ", ahd_name(ahd), 'A',
 	       devinfo->target, devinfo->lun);
 }
=20
@@ -4419,11 +4419,11 @@ ahd_setup_initiator_msgout(struct ahd_softc *ah=
d, struct ahd_devinfo *devinfo,
 		ahd->msg_type =3D MSG_TYPE_INITIATOR_MSGOUT;
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-			printf("Setting up for Parity Error delivery\n");
+			printk("Setting up for Parity Error delivery\n");
 #endif
 		return;
 	} else if (scb =3D=3D NULL) {
-		printf("%s: WARNING. No pending message for "
+		printk("%s: WARNING. No pending message for "
 		       "I_T msgin.  Issuing NO-OP\n", ahd_name(ahd));
 		ahd->msgout_buf[ahd->msgout_index++] =3D MSG_NOOP;
 		ahd->msgout_len++;
@@ -4454,7 +4454,7 @@ ahd_setup_initiator_msgout(struct ahd_softc *ahd,=
 struct ahd_devinfo *devinfo,
 		ahd->msgout_buf[ahd->msgout_index++] =3D MSG_BUS_DEV_RESET;
 		ahd->msgout_len++;
 		ahd_print_path(ahd, scb);
-		printf("Bus Device Reset Message Sent\n");
+		printk("Bus Device Reset Message Sent\n");
 		/*
 		 * Clear our selection hardware in advance of
 		 * the busfree.  We may have an entry in the waiting
@@ -4472,7 +4472,7 @@ ahd_setup_initiator_msgout(struct ahd_softc *ahd,=
 struct ahd_devinfo *devinfo,
 		}
 		ahd->msgout_len++;
 		ahd_print_path(ahd, scb);
-		printf("Abort%s Message Sent\n",
+		printk("Abort%s Message Sent\n",
 		       (scb->hscb->control & TAG_ENB) !=3D 0 ? " Tag" : "");
 		/*
 		 * Clear our selection hardware in advance of
@@ -4493,9 +4493,9 @@ ahd_setup_initiator_msgout(struct ahd_softc *ahd,=
 struct ahd_devinfo *devinfo,
 		 */
 		ahd_outb(ahd, SCSISEQ0, 0);
 	} else {
-		printf("ahd_intr: AWAITING_MSG for an SCB that "
+		printk("ahd_intr: AWAITING_MSG for an SCB that "
 		       "does not have a waiting message\n");
-		printf("SCSIID =3D %x, target_mask =3D %x\n", scb->hscb->scsiid,
+		printk("SCSIID =3D %x, target_mask =3D %x\n", scb->hscb->scsiid,
 		       devinfo->target_mask);
 		panic("SCB =3D %d, SCB Control =3D %x:%x, MSG_OUT =3D %x "
 		      "SCB flags =3D %x", SCB_GET_TAG(scb), scb->hscb->control,
@@ -4577,7 +4577,7 @@ ahd_build_transfer_msg(struct ahd_softc *ahd, str=
uct ahd_devinfo *devinfo)
=20
 		if (bootverbose) {
 			ahd_print_devinfo(ahd, devinfo);
-			printf("Ensuring async\n");
+			printk("Ensuring async\n");
 		}
 	}
 	/* Target initiated PPR is not allowed in the SCSI spec */
@@ -4624,7 +4624,7 @@ ahd_construct_sdtr(struct ahd_softc *ahd, struct =
ahd_devinfo *devinfo,
 			ahd->msgout_buf + ahd->msgout_index, period, offset);
 	ahd->msgout_len +=3D 5;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
+		printk("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
 		       ahd_name(ahd), devinfo->channel, devinfo->target,
 		       devinfo->lun, period, offset);
 	}
@@ -4642,7 +4642,7 @@ ahd_construct_wdtr(struct ahd_softc *ahd, struct =
ahd_devinfo *devinfo,
 			ahd->msgout_buf + ahd->msgout_index, bus_width);
 	ahd->msgout_len +=3D 4;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending WDTR %x\n",
+		printk("(%s:%c:%d:%d): Sending WDTR %x\n",
 		       ahd_name(ahd), devinfo->channel, devinfo->target,
 		       devinfo->lun, bus_width);
 	}
@@ -4671,7 +4671,7 @@ ahd_construct_ppr(struct ahd_softc *ahd, struct a=
hd_devinfo *devinfo,
 			bus_width, ppr_options);
 	ahd->msgout_len +=3D 8;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
+		printk("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
 		       "offset %x, ppr_options %x\n", ahd_name(ahd),
 		       devinfo->channel, devinfo->target, devinfo->lun,
 		       bus_width, period, offset, ppr_options);
@@ -4721,7 +4721,7 @@ ahd_handle_message_phase(struct ahd_softc *ahd)
 	bus_phase =3D ahd_inb(ahd, LASTPHASE);
=20
 	if ((ahd_inb(ahd, LQISTAT2) & LQIPHASE_OUTPKT) !=3D 0) {
-		printf("LQIRETRY for LQIPHASE_OUTPKT\n");
+		printk("LQIRETRY for LQIPHASE_OUTPKT\n");
 		ahd_outb(ahd, LQCTL2, LQIRETRY);
 	}
 reswitch:
@@ -4738,14 +4738,14 @@ reswitch:
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
 			ahd_print_devinfo(ahd, &devinfo);
-			printf("INITIATOR_MSG_OUT");
+			printk("INITIATOR_MSG_OUT");
 		}
 #endif
 		phasemis =3D bus_phase !=3D P_MESGOUT;
 		if (phasemis) {
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
-				printf(" PHASEMIS %s\n",
+				printk(" PHASEMIS %s\n",
 				       ahd_lookup_phase_entry(bus_phase)
 							     ->phasemsg);
 			}
@@ -4772,7 +4772,7 @@ reswitch:
 			ahd_outb(ahd, CLRSINT1, CLRREQINIT);
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-				printf(" byte 0x%x\n", ahd->send_msg_perror);
+				printk(" byte 0x%x\n", ahd->send_msg_perror);
 #endif
 			/*
 			 * If we are notifying the target of a CRC error
@@ -4813,7 +4813,7 @@ reswitch:
 		ahd_outb(ahd, CLRSINT1, CLRREQINIT);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-			printf(" byte 0x%x\n",
+			printk(" byte 0x%x\n",
 			       ahd->msgout_buf[ahd->msgout_index]);
 #endif
 		ahd_outb(ahd, RETURN_2, ahd->msgout_buf[ahd->msgout_index++]);
@@ -4828,14 +4828,14 @@ reswitch:
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
 			ahd_print_devinfo(ahd, &devinfo);
-			printf("INITIATOR_MSG_IN");
+			printk("INITIATOR_MSG_IN");
 		}
 #endif
 		phasemis =3D bus_phase !=3D P_MESGIN;
 		if (phasemis) {
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
-				printf(" PHASEMIS %s\n",
+				printk(" PHASEMIS %s\n",
 				       ahd_lookup_phase_entry(bus_phase)
 							     ->phasemsg);
 			}
@@ -4856,7 +4856,7 @@ reswitch:
 		ahd->msgin_buf[ahd->msgin_index] =3D ahd_inb(ahd, SCSIBUS);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-			printf(" byte 0x%x\n",
+			printk(" byte 0x%x\n",
 			       ahd->msgin_buf[ahd->msgin_index]);
 #endif
=20
@@ -4878,7 +4878,7 @@ reswitch:
 #ifdef AHD_DEBUG
 				if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0) {
 					ahd_print_devinfo(ahd, &devinfo);
-					printf("Asserting ATN for response\n");
+					printk("Asserting ATN for response\n");
 				}
 #endif
 				ahd_assert_atn(ahd);
@@ -5026,7 +5026,7 @@ reswitch:
=20
 	if (end_session) {
 		if ((ahd->msg_flags & MSG_FLAG_PACKETIZED) !=3D 0) {
-			printf("%s: Returning to Idle Loop\n",
+			printk("%s: Returning to Idle Loop\n",
 			       ahd_name(ahd));
 			ahd_clear_msg_state(ahd);
=20
@@ -5178,7 +5178,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 			ahd_validate_offset(ahd, tinfo, period, &offset,
 					    tinfo->curr.width, devinfo->role);
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received "
+				printk("(%s:%c:%d:%d): Received "
 				       "SDTR period %x, offset %x\n\t"
 				       "Filtered to period %x, offset %x\n",
 				       ahd_name(ahd), devinfo->channel,
@@ -5208,7 +5208,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 				 */
 				if (bootverbose
 				 && devinfo->role =3D=3D ROLE_INITIATOR) {
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated SDTR\n",
 					       ahd_name(ahd), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -5250,7 +5250,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 			ahd_validate_width(ahd, tinfo, &bus_width,
 					   devinfo->role);
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received WDTR "
+				printk("(%s:%c:%d:%d): Received WDTR "
 				       "%x filtered to %x\n",
 				       ahd_name(ahd), devinfo->channel,
 				       devinfo->target, devinfo->lun,
@@ -5266,7 +5266,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 				 */
 				if (saved_width > bus_width) {
 					reject =3D TRUE;
-					printf("(%s:%c:%d:%d): requested %dBit "
+					printk("(%s:%c:%d:%d): requested %dBit "
 					       "transfers.  Rejecting...\n",
 					       ahd_name(ahd), devinfo->channel,
 					       devinfo->target, devinfo->lun,
@@ -5279,7 +5279,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 				 */
 				if (bootverbose
 				 && devinfo->role =3D=3D ROLE_INITIATOR) {
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated WDTR\n",
 					       ahd_name(ahd), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -5391,12 +5391,12 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd=
_devinfo *devinfo)
 				}
 			} else {
 				if (devinfo->role !=3D ROLE_TARGET)
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated PPR\n",
 					       ahd_name(ahd), devinfo->channel,
 					       devinfo->target, devinfo->lun);
 				else
-					printf("(%s:%c:%d:%d): Initiator "
+					printk("(%s:%c:%d:%d): Initiator "
 					       "Initiated PPR\n",
 					       ahd_name(ahd), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -5408,7 +5408,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 				response =3D TRUE;
 			}
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received PPR width %x, "
+				printk("(%s:%c:%d:%d): Received PPR width %x, "
 				       "period %x, offset %x,options %x\n"
 				       "\tFiltered to width %x, period %x, "
 				       "offset %x, options %x\n",
@@ -5484,7 +5484,7 @@ ahd_parse_msg(struct ahd_softc *ahd, struct ahd_d=
evinfo *devinfo)
 	case MSG_QAS_REQUEST:
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) !=3D 0)
-			printf("%s: QAS request.  SCSISIGI =3D=3D 0x%x\n",
+			printk("%s: QAS request.  SCSISIGI =3D=3D 0x%x\n",
 			       ahd_name(ahd), ahd_inb(ahd, SCSISIGI));
 #endif
 		ahd->msg_flags |=3D MSG_FLAG_EXPECT_QASREJ_BUSFREE;
@@ -5549,7 +5549,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, stru=
ct ahd_devinfo *devinfo)
 			 * off these options.
 			 */
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): PPR Rejected. "
+				printk("(%s:%c:%d:%d): PPR Rejected. "
 				       "Trying simple U160 PPR\n",
 				       ahd_name(ahd), devinfo->channel,
 				       devinfo->target, devinfo->lun);
@@ -5564,7 +5564,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, stru=
ct ahd_devinfo *devinfo)
 			 * Attempt to negotiate SPI-2 style.
 			 */
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): PPR Rejected. "
+				printk("(%s:%c:%d:%d): PPR Rejected. "
 				       "Trying WDTR/SDTR\n",
 				       ahd_name(ahd), devinfo->channel,
 				       devinfo->target, devinfo->lun);
@@ -5581,7 +5581,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, stru=
ct ahd_devinfo *devinfo)
 	} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, /*full*/FALSE)=
) {
=20
 		/* note 8bit xfers */
-		printf("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
+		printk("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
 		       "8bit transfers\n", ahd_name(ahd),
 		       devinfo->channel, devinfo->target, devinfo->lun);
 		ahd_set_width(ahd, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
@@ -5609,7 +5609,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, stru=
ct ahd_devinfo *devinfo)
 				 /*offset*/0, /*ppr_options*/0,
 				 AHD_TRANS_ACTIVE|AHD_TRANS_GOAL,
 				 /*paused*/TRUE);
-		printf("(%s:%c:%d:%d): refuses synchronous negotiation. "
+		printk("(%s:%c:%d:%d): refuses synchronous negotiation. "
 		       "Using asynchronous transfers\n",
 		       ahd_name(ahd), devinfo->channel,
 		       devinfo->target, devinfo->lun);
@@ -5620,13 +5620,13 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, st=
ruct ahd_devinfo *devinfo)
 		tag_type =3D (scb->hscb->control & MSG_SIMPLE_TASK);
=20
 		if (tag_type =3D=3D MSG_SIMPLE_TASK) {
-			printf("(%s:%c:%d:%d): refuses tagged commands.  "
+			printk("(%s:%c:%d:%d): refuses tagged commands.  "
 			       "Performing non-tagged I/O\n", ahd_name(ahd),
 			       devinfo->channel, devinfo->target, devinfo->lun);
 			ahd_set_tags(ahd, scb->io_ctx, devinfo, AHD_QUEUE_NONE);
 			mask =3D ~0x23;
 		} else {
-			printf("(%s:%c:%d:%d): refuses %s tagged commands.  "
+			printk("(%s:%c:%d:%d): refuses %s tagged commands.  "
 			       "Performing simple queue tagged I/O only\n",
 			       ahd_name(ahd), devinfo->channel, devinfo->target,
 			       devinfo->lun, tag_type =3D=3D MSG_ORDERED_TASK
@@ -5677,7 +5677,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, stru=
ct ahd_devinfo *devinfo)
 		/*
 		 * Otherwise, we ignore it.
 		 */
-		printf("%s:%c:%d: Message reject for %x -- ignored\n",
+		printk("%s:%c:%d: Message reject for %x -- ignored\n",
 		       ahd_name(ahd), devinfo->channel, devinfo->target,
 		       last_msg);
 	}
@@ -5864,7 +5864,7 @@ ahd_reinitialize_dataptrs(struct ahd_softc *ahd)
 		ahd_delay(100);
 	if (wait =3D=3D 0) {
 		ahd_print_path(ahd, scb);
-		printf("ahd_reinitialize_dataptrs: Forcing FIFO free.\n");
+		printk("ahd_reinitialize_dataptrs: Forcing FIFO free.\n");
 		ahd_outb(ahd, DFFSXFRCTL, RSTCHN|CLRSHCNT);
 	}
 	saved_modes =3D ahd_save_modes(ahd);
@@ -5978,7 +5978,7 @@ ahd_handle_devreset(struct ahd_softc *ahd, struct=
 ahd_devinfo *devinfo,
 			       CAM_LUN_WILDCARD, AC_SENT_BDR);
=20
 	if (message !=3D NULL && bootverbose)
-		printf("%s: %s on %c:%d. %d SCBs aborted\n", ahd_name(ahd),
+		printk("%s: %s on %c:%d. %d SCBs aborted\n", ahd_name(ahd),
 		       message, devinfo->channel, devinfo->target, found);
 }
=20
@@ -6074,23 +6074,22 @@ ahd_alloc(void *platform_arg, char *name)
 	struct  ahd_softc *ahd;
=20
 #ifndef	__FreeBSD__
-	ahd =3D malloc(sizeof(*ahd), M_DEVBUF, M_NOWAIT);
+	ahd =3D kmalloc(sizeof(*ahd), GFP_ATOMIC);
 	if (!ahd) {
-		printf("aic7xxx: cannot malloc softc!\n");
-		free(name, M_DEVBUF);
+		printk("aic7xxx: cannot malloc softc!\n");
+		kfree(name);
 		return NULL;
 	}
 #else
 	ahd =3D device_get_softc((device_t)platform_arg);
 #endif
 	memset(ahd, 0, sizeof(*ahd));
-	ahd->seep_config =3D malloc(sizeof(*ahd->seep_config),
-				  M_DEVBUF, M_NOWAIT);
+	ahd->seep_config =3D kmalloc(sizeof(*ahd->seep_config), GFP_ATOMIC);
 	if (ahd->seep_config =3D=3D NULL) {
 #ifndef	__FreeBSD__
-		free(ahd, M_DEVBUF);
+		kfree(ahd);
 #endif
-		free(name, M_DEVBUF);
+		kfree(name);
 		return (NULL);
 	}
 	LIST_INIT(&ahd->pending_scbs);
@@ -6120,7 +6119,7 @@ ahd_alloc(void *platform_arg, char *name)
 	}
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MEMORY) !=3D 0) {
-		printf("%s: scb size =3D 0x%x, hscb size =3D 0x%x\n",
+		printk("%s: scb size =3D 0x%x, hscb size =3D 0x%x\n",
 		       ahd_name(ahd), (u_int)sizeof(struct scb),
 		       (u_int)sizeof(struct hardware_scb));
 	}
@@ -6147,7 +6146,7 @@ void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
 	if (ahd->name !=3D NULL)
-		free(ahd->name, M_DEVBUF);
+		kfree(ahd->name);
 	ahd->name =3D name;
 }
=20
@@ -6201,27 +6200,27 @@ ahd_free(struct ahd_softc *ahd)
 				lstate =3D tstate->enabled_luns[j];
 				if (lstate !=3D NULL) {
 					xpt_free_path(lstate->path);
-					free(lstate, M_DEVBUF);
+					kfree(lstate);
 				}
 			}
 #endif
-			free(tstate, M_DEVBUF);
+			kfree(tstate);
 		}
 	}
 #ifdef AHD_TARGET_MODE
 	if (ahd->black_hole !=3D NULL) {
 		xpt_free_path(ahd->black_hole->path);
-		free(ahd->black_hole, M_DEVBUF);
+		kfree(ahd->black_hole);
 	}
 #endif
 	if (ahd->name !=3D NULL)
-		free(ahd->name, M_DEVBUF);
+		kfree(ahd->name);
 	if (ahd->seep_config !=3D NULL)
-		free(ahd->seep_config, M_DEVBUF);
+		kfree(ahd->seep_config);
 	if (ahd->saved_stack !=3D NULL)
-		free(ahd->saved_stack, M_DEVBUF);
+		kfree(ahd->saved_stack);
 #ifndef __FreeBSD__
-	free(ahd, M_DEVBUF);
+	kfree(ahd);
 #endif
 	return;
 }
@@ -6300,7 +6299,7 @@ ahd_reset(struct ahd_softc *ahd, int reinit)
 	} while (--wait && !(ahd_inb(ahd, HCNTRL) & CHIPRSTACK));
=20
 	if (wait =3D=3D 0) {
-		printf("%s: WARNING - Failed chip reset!  "
+		printk("%s: WARNING - Failed chip reset!  "
 		       "Trying to initialize anyway.\n", ahd_name(ahd));
 	}
 	ahd_outb(ahd, HCNTRL, ahd->pause);
@@ -6422,7 +6421,7 @@ ahd_init_scbdata(struct ahd_softc *ahd)
 	/* Determine the number of hardware SCBs and initialize them */
 	scb_data->maxhscbs =3D ahd_probe_scbs(ahd);
 	if (scb_data->maxhscbs =3D=3D 0) {
-		printf("%s: No SCB space found\n", ahd_name(ahd));
+		printk("%s: No SCB space found\n", ahd_name(ahd));
 		return (ENXIO);
 	}
=20
@@ -6465,7 +6464,7 @@ ahd_init_scbdata(struct ahd_softc *ahd)
 	}
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MEMORY) !=3D 0)
-		printf("%s: ahd_sglist_allocsize =3D 0x%x\n", ahd_name(ahd),
+		printk("%s: ahd_sglist_allocsize =3D 0x%x\n", ahd_name(ahd),
 		       ahd_sglist_allocsize(ahd));
 #endif
=20
@@ -6489,7 +6488,7 @@ ahd_init_scbdata(struct ahd_softc *ahd)
 	ahd_alloc_scbs(ahd);
=20
 	if (scb_data->numscbs =3D=3D 0) {
-		printf("%s: ahd_init_scbdata - "
+		printk("%s: ahd_init_scbdata - "
 		       "Unable to allocate initial scbs\n",
 		       ahd_name(ahd));
 		goto error_exit;
@@ -6564,7 +6563,7 @@ ahd_fini_scbdata(struct ahd_softc *ahd)
 					  sns_map->dmamap);
 			ahd_dmamem_free(ahd, scb_data->sense_dmat,
 					sns_map->vaddr, sns_map->dmamap);
-			free(sns_map, M_DEVBUF);
+			kfree(sns_map);
 		}
 		ahd_dma_tag_destroy(ahd, scb_data->sense_dmat);
 		/* FALLTHROUGH */
@@ -6579,7 +6578,7 @@ ahd_fini_scbdata(struct ahd_softc *ahd)
 					  sg_map->dmamap);
 			ahd_dmamem_free(ahd, scb_data->sg_dmat,
 					sg_map->vaddr, sg_map->dmamap);
-			free(sg_map, M_DEVBUF);
+			kfree(sg_map);
 		}
 		ahd_dma_tag_destroy(ahd, scb_data->sg_dmat);
 		/* FALLTHROUGH */
@@ -6594,7 +6593,7 @@ ahd_fini_scbdata(struct ahd_softc *ahd)
 					  hscb_map->dmamap);
 			ahd_dmamem_free(ahd, scb_data->hscb_dmat,
 					hscb_map->vaddr, hscb_map->dmamap);
-			free(hscb_map, M_DEVBUF);
+			kfree(hscb_map);
 		}
 		ahd_dma_tag_destroy(ahd, scb_data->hscb_dmat);
 		/* FALLTHROUGH */
@@ -6624,7 +6623,7 @@ ahd_setup_iocell_workaround(struct ahd_softc *ahd=
)
 	ahd_outb(ahd, SIMODE0, ahd_inb(ahd, SIMODE0) | (ENSELDO|ENSELDI));
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-		printf("%s: Setting up iocell workaround\n", ahd_name(ahd));
+		printk("%s: Setting up iocell workaround\n", ahd_name(ahd));
 #endif
 	ahd_restore_modes(ahd, saved_modes);
 	ahd->flags &=3D ~AHD_HAD_FIRST_SEL;
@@ -6644,14 +6643,14 @@ ahd_iocell_first_selection(struct ahd_softc *ah=
d)
 	ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-		printf("%s: iocell first selection\n", ahd_name(ahd));
+		printk("%s: iocell first selection\n", ahd_name(ahd));
 #endif
 	if ((sblkctl & ENAB40) !=3D 0) {
 		ahd_outb(ahd, DSPDATACTL,
 			 ahd_inb(ahd, DSPDATACTL) & ~BYPASSENAB);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-			printf("%s: BYPASS now disabled\n", ahd_name(ahd));
+			printk("%s: BYPASS now disabled\n", ahd_name(ahd));
 #endif
 	}
 	ahd_outb(ahd, SIMODE0, ahd_inb(ahd, SIMODE0) & ~(ENSELDO|ENSELDI));
@@ -6833,7 +6832,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		hscb =3D &((struct hardware_scb *)hscb_map->vaddr)[offset];
 		hscb_busaddr =3D hscb_map->physaddr + (offset * sizeof(*hscb));
 	} else {
-		hscb_map =3D malloc(sizeof(*hscb_map), M_DEVBUF, M_NOWAIT);
+		hscb_map =3D kmalloc(sizeof(*hscb_map), GFP_ATOMIC);
=20
 		if (hscb_map =3D=3D NULL)
 			return;
@@ -6842,7 +6841,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		if (ahd_dmamem_alloc(ahd, scb_data->hscb_dmat,
 				     (void **)&hscb_map->vaddr,
 				     BUS_DMA_NOWAIT, &hscb_map->dmamap) !=3D 0) {
-			free(hscb_map, M_DEVBUF);
+			kfree(hscb_map);
 			return;
 		}
=20
@@ -6866,7 +6865,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		segs =3D sg_map->vaddr + offset;
 		sg_busaddr =3D sg_map->physaddr + offset;
 	} else {
-		sg_map =3D malloc(sizeof(*sg_map), M_DEVBUF, M_NOWAIT);
+		sg_map =3D kmalloc(sizeof(*sg_map), GFP_ATOMIC);
=20
 		if (sg_map =3D=3D NULL)
 			return;
@@ -6875,7 +6874,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		if (ahd_dmamem_alloc(ahd, scb_data->sg_dmat,
 				     (void **)&sg_map->vaddr,
 				     BUS_DMA_NOWAIT, &sg_map->dmamap) !=3D 0) {
-			free(sg_map, M_DEVBUF);
+			kfree(sg_map);
 			return;
 		}
=20
@@ -6891,7 +6890,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		    ahd_sglist_allocsize(ahd) / ahd_sglist_size(ahd);
 #ifdef AHD_DEBUG
 		if (ahd_debug & AHD_SHOW_MEMORY)
-			printf("Mapped SG data\n");
+			printk("Mapped SG data\n");
 #endif
 	}
=20
@@ -6903,7 +6902,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		sense_data =3D sense_map->vaddr + offset;
 		sense_busaddr =3D sense_map->physaddr + offset;
 	} else {
-		sense_map =3D malloc(sizeof(*sense_map), M_DEVBUF, M_NOWAIT);
+		sense_map =3D kmalloc(sizeof(*sense_map), GFP_ATOMIC);
=20
 		if (sense_map =3D=3D NULL)
 			return;
@@ -6912,7 +6911,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		if (ahd_dmamem_alloc(ahd, scb_data->sense_dmat,
 				     (void **)&sense_map->vaddr,
 				     BUS_DMA_NOWAIT, &sense_map->dmamap) !=3D 0) {
-			free(sense_map, M_DEVBUF);
+			kfree(sense_map);
 			return;
 		}
=20
@@ -6927,7 +6926,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		scb_data->sense_left =3D PAGE_SIZE / AHD_SENSE_BUFSIZE;
 #ifdef AHD_DEBUG
 		if (ahd_debug & AHD_SHOW_MEMORY)
-			printf("Mapped sense data\n");
+			printk("Mapped sense data\n");
 #endif
 	}
=20
@@ -6941,15 +6940,13 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		int error;
 #endif
=20
-		next_scb =3D (struct scb *)malloc(sizeof(*next_scb),
-						M_DEVBUF, M_NOWAIT);
+		next_scb =3D kmalloc(sizeof(*next_scb), GFP_ATOMIC);
 		if (next_scb =3D=3D NULL)
 			break;
=20
-		pdata =3D (struct scb_platform_data *)malloc(sizeof(*pdata),
-							   M_DEVBUF, M_NOWAIT);
+		pdata =3D kmalloc(sizeof(*pdata), GFP_ATOMIC);
 		if (pdata =3D=3D NULL) {
-			free(next_scb, M_DEVBUF);
+			kfree(next_scb);
 			break;
 		}
 		next_scb->platform_data =3D pdata;
@@ -6979,8 +6976,8 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 		error =3D ahd_dmamap_create(ahd, ahd->buffer_dmat, /*flags*/0,
 					  &next_scb->dmamap);
 		if (error !=3D 0) {
-			free(next_scb, M_DEVBUF);
-			free(pdata, M_DEVBUF);
+			kfree(next_scb);
+			kfree(pdata);
 			break;
 		}
 #endif
@@ -7077,8 +7074,7 @@ ahd_init(struct ahd_softc *ahd)
 	AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
=20
 	ahd->stack_size =3D ahd_probe_stack_size(ahd);
-	ahd->saved_stack =3D malloc(ahd->stack_size * sizeof(uint16_t),
-				  M_DEVBUF, M_NOWAIT);
+	ahd->saved_stack =3D kmalloc(ahd->stack_size * sizeof(uint16_t), GFP_=
ATOMIC);
 	if (ahd->saved_stack =3D=3D NULL)
 		return (ENOMEM);
=20
@@ -7224,20 +7220,20 @@ ahd_init(struct ahd_softc *ahd)
 	error =3D ahd_write_flexport(ahd, FLXADDR_ROMSTAT_CURSENSECTL,
 				   CURSENSE_ENB);
 	if (error !=3D 0) {
-		printf("%s: current sensing timeout 1\n", ahd_name(ahd));
+		printk("%s: current sensing timeout 1\n", ahd_name(ahd));
 		goto init_done;
 	}
 	for (i =3D 20, fstat =3D FLX_FSTAT_BUSY;
 	     (fstat & FLX_FSTAT_BUSY) !=3D 0 && i; i--) {
 		error =3D ahd_read_flexport(ahd, FLXADDR_FLEXSTAT, &fstat);
 		if (error !=3D 0) {
-			printf("%s: current sensing timeout 2\n",
+			printk("%s: current sensing timeout 2\n",
 			       ahd_name(ahd));
 			goto init_done;
 		}
 	}
 	if (i =3D=3D 0) {
-		printf("%s: Timedout during current-sensing test\n",
+		printk("%s: Timedout during current-sensing test\n",
 		       ahd_name(ahd));
 		goto init_done;
 	}
@@ -7245,7 +7241,7 @@ ahd_init(struct ahd_softc *ahd)
 	/* Latch Current Sensing status. */
 	error =3D ahd_read_flexport(ahd, FLXADDR_CURRENT_STAT, &current_sensi=
ng);
 	if (error !=3D 0) {
-		printf("%s: current sensing timeout 3\n", ahd_name(ahd));
+		printk("%s: current sensing timeout 3\n", ahd_name(ahd));
 		goto init_done;
 	}
=20
@@ -7254,7 +7250,7 @@ ahd_init(struct ahd_softc *ahd)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_TERMCTL) !=3D 0) {
-		printf("%s: current_sensing =3D=3D 0x%x\n",
+		printk("%s: current_sensing =3D=3D 0x%x\n",
 		       ahd_name(ahd), current_sensing);
 	}
 #endif
@@ -7271,13 +7267,13 @@ ahd_init(struct ahd_softc *ahd)
 		case FLX_CSTAT_OKAY:
 			if (warn_user =3D=3D 0 && bootverbose =3D=3D 0)
 				break;
-			printf("%s: %s Channel %s\n", ahd_name(ahd),
+			printk("%s: %s Channel %s\n", ahd_name(ahd),
 			       channel_strings[i], termstat_strings[term_stat]);
 			break;
 		}
 	}
 	if (warn_user) {
-		printf("%s: WARNING. Termination is not configured correctly.\n"
+		printk("%s: WARNING. Termination is not configured correctly.\n"
 		       "%s: WARNING. SCSI bus operations may FAIL.\n",
 		       ahd_name(ahd), ahd_name(ahd));
 	}
@@ -7393,7 +7389,7 @@ ahd_chip_init(struct ahd_softc *ahd)
 		}
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-			printf("%s: WRTBIASCTL now 0x%x\n", ahd_name(ahd),
+			printk("%s: WRTBIASCTL now 0x%x\n", ahd_name(ahd),
 			       WRTBIASCTL_HP_DEFAULT);
 #endif
 	}
@@ -7622,9 +7618,9 @@ ahd_chip_init(struct ahd_softc *ahd)
 		ahd_outb(ahd, NEGCONOPTS, negodat3);
 		negodat3 =3D ahd_inb(ahd, NEGCONOPTS);
 		if (!(negodat3 & ENSLOWCRC))
-			printf("aic79xx: failed to set the SLOWCRC bit\n");
+			printk("aic79xx: failed to set the SLOWCRC bit\n");
 		else
-			printf("aic79xx: SLOWCRC bit set\n");
+			printk("aic79xx: SLOWCRC bit set\n");
 	}
 }
=20
@@ -7646,7 +7642,7 @@ ahd_default_config(struct ahd_softc *ahd)
 	 * data for any target mode initiator.
 	 */
 	if (ahd_alloc_tstate(ahd, ahd->our_id, 'A') =3D=3D NULL) {
-		printf("%s: unable to allocate ahd_tmode_tstate.  "
+		printk("%s: unable to allocate ahd_tmode_tstate.  "
 		       "Failing attach\n", ahd_name(ahd));
 		return (ENOMEM);
 	}
@@ -7725,7 +7721,7 @@ ahd_parse_cfgdata(struct ahd_softc *ahd, struct s=
eeprom_config *sc)
 	 * data for any target mode initiator.
 	 */
 	if (ahd_alloc_tstate(ahd, ahd->our_id, 'A') =3D=3D NULL) {
-		printf("%s: unable to allocate ahd_tmode_tstate.  "
+		printk("%s: unable to allocate ahd_tmode_tstate.  "
 		       "Failing attach\n", ahd_name(ahd));
 		return (ENOMEM);
 	}
@@ -7795,7 +7791,7 @@ ahd_parse_cfgdata(struct ahd_softc *ahd, struct s=
eeprom_config *sc)
 			user_tinfo->width =3D MSG_EXT_WDTR_BUS_8_BIT;
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MISC) !=3D 0)
-			printf("(%d): %x:%x:%x:%x\n", targ, user_tinfo->width,
+			printk("(%d): %x:%x:%x:%x\n", targ, user_tinfo->width,
 			       user_tinfo->period, user_tinfo->offset,
 			       user_tinfo->ppr_options);
 #endif
@@ -7951,7 +7947,7 @@ ahd_pause_and_flushwork(struct ahd_softc *ahd)
 	       || (ahd_inb(ahd, SSTAT0) & (SELDO|SELINGO)) !=3D 0));
=20
 	if (maxloops =3D=3D 0) {
-		printf("Infinite interrupt loop, INTSTAT =3D %x",
+		printk("Infinite interrupt loop, INTSTAT =3D %x",
 		      ahd_inb(ahd, INTSTAT));
 	}
 	ahd->qfreeze_cnt++;
@@ -8241,7 +8237,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 	prev_scb =3D NULL;
=20
 	if (action =3D=3D SEARCH_PRINT) {
-		printf("qinstart =3D %d qinfifonext =3D %d\nQINFIFO:",
+		printk("qinstart =3D %d qinfifonext =3D %d\nQINFIFO:",
 		       qinstart, ahd->qinfifonext);
 	}
=20
@@ -8256,7 +8252,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 	while (qinpos !=3D qintail) {
 		scb =3D ahd_lookup_scb(ahd, ahd->qinfifo[qinpos]);
 		if (scb =3D=3D NULL) {
-			printf("qinpos =3D %d, SCB index =3D %d\n",
+			printk("qinpos =3D %d, SCB index =3D %d\n",
 				qinpos, ahd->qinfifo[qinpos]);
 			panic("Loop 1\n");
 		}
@@ -8269,13 +8265,13 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int t=
arget, char channel,
 			switch (action) {
 			case SEARCH_COMPLETE:
 				if ((scb->flags & SCB_ACTIVE) =3D=3D 0)
-					printf("Inactive SCB in qinfifo\n");
+					printk("Inactive SCB in qinfifo\n");
 				ahd_done_with_status(ahd, scb, status);
 				/* FALLTHROUGH */
 			case SEARCH_REMOVE:
 				break;
 			case SEARCH_PRINT:
-				printf(" 0x%x", ahd->qinfifo[qinpos]);
+				printk(" 0x%x", ahd->qinfifo[qinpos]);
 				/* FALLTHROUGH */
 			case SEARCH_COUNT:
 				ahd_qinfifo_requeue(ahd, prev_scb, scb);
@@ -8292,7 +8288,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 	ahd_set_hnscb_qoff(ahd, ahd->qinfifonext);
=20
 	if (action =3D=3D SEARCH_PRINT)
-		printf("\nWAITING_TID_QUEUES:\n");
+		printk("\nWAITING_TID_QUEUES:\n");
=20
 	/*
 	 * Search waiting for selection lists.  We traverse the
@@ -8320,7 +8316,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 			panic("TID LIST LOOP");
=20
 		if (scbid >=3D ahd->scb_data.numscbs) {
-			printf("%s: Waiting TID List inconsistency. "
+			printk("%s: Waiting TID List inconsistency. "
 			       "SCB index =3D=3D 0x%x, yet numscbs =3D=3D 0x%x.",
 			       ahd_name(ahd), scbid, ahd->scb_data.numscbs);
 			ahd_dump_card_state(ahd);
@@ -8328,7 +8324,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 		}
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: SCB =3D 0x%x Not Active!\n",
+			printk("%s: SCB =3D 0x%x Not Active!\n",
 			       ahd_name(ahd), scbid);
 			panic("Waiting TID List traversal\n");
 		}
@@ -8344,7 +8340,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 		 * We found a list of scbs that needs to be searched.
 		 */
 		if (action =3D=3D SEARCH_PRINT)
-			printf("       %d ( ", SCB_GET_TARGET(ahd, scb));
+			printk("       %d ( ", SCB_GET_TARGET(ahd, scb));
 		tid_head =3D scbid;
 		found +=3D ahd_search_scb_list(ahd, target, channel,
 					     lun, tag, role, status,
@@ -8365,14 +8361,14 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int t=
arget, char channel,
 			switch (action) {
 			case SEARCH_COMPLETE:
 				if ((mk_msg_scb->flags & SCB_ACTIVE) =3D=3D 0)
-					printf("Inactive SCB pending MK_MSG\n");
+					printk("Inactive SCB pending MK_MSG\n");
 				ahd_done_with_status(ahd, mk_msg_scb, status);
 				/* FALLTHROUGH */
 			case SEARCH_REMOVE:
 			{
 				u_int tail_offset;
=20
-				printf("Removing MK_MSG scb\n");
+				printk("Removing MK_MSG scb\n");
=20
 				/*
 				 * Reset our tail to the tail of the
@@ -8390,7 +8386,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 				break;
 			}
 			case SEARCH_PRINT:
-				printf(" 0x%x", SCB_GET_TAG(scb));
+				printk(" 0x%x", SCB_GET_TAG(scb));
 				/* FALLTHROUGH */
 			case SEARCH_COUNT:
 				break;
@@ -8407,7 +8403,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 			 * queue with a pending MK_MESSAGE scb, we
 			 * must queue the MK_MESSAGE scb.
 			 */
-			printf("Queueing mk_msg_scb\n");
+			printk("Queueing mk_msg_scb\n");
 			tid_head =3D ahd_inw(ahd, MK_MESSAGE_SCB);
 			seq_flags2 &=3D ~PENDING_MK_MESSAGE;
 			ahd_outb(ahd, SEQ_FLAGS2, seq_flags2);
@@ -8418,7 +8414,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int tar=
get, char channel,
 		if (!SCBID_IS_NULL(tid_head))
 			tid_prev =3D tid_head;
 		if (action =3D=3D SEARCH_PRINT)
-			printf(")\n");
+			printk(")\n");
 	}
=20
 	/* Restore saved state. */
@@ -8446,7 +8442,7 @@ ahd_search_scb_list(struct ahd_softc *ahd, int ta=
rget, char channel,
 	*list_tail =3D SCB_LIST_NULL;
 	for (scbid =3D next; !SCBID_IS_NULL(scbid); scbid =3D next) {
 		if (scbid >=3D ahd->scb_data.numscbs) {
-			printf("%s:SCB List inconsistency. "
+			printk("%s:SCB List inconsistency. "
 			       "SCB =3D=3D 0x%x, yet numscbs =3D=3D 0x%x.",
 			       ahd_name(ahd), scbid, ahd->scb_data.numscbs);
 			ahd_dump_card_state(ahd);
@@ -8454,7 +8450,7 @@ ahd_search_scb_list(struct ahd_softc *ahd, int ta=
rget, char channel,
 		}
 		scb =3D ahd_lookup_scb(ahd, scbid);
 		if (scb =3D=3D NULL) {
-			printf("%s: SCB =3D %d Not Active!\n",
+			printk("%s: SCB =3D %d Not Active!\n",
 			       ahd_name(ahd), scbid);
 			panic("Waiting List traversal\n");
 		}
@@ -8470,7 +8466,7 @@ ahd_search_scb_list(struct ahd_softc *ahd, int ta=
rget, char channel,
 		switch (action) {
 		case SEARCH_COMPLETE:
 			if ((scb->flags & SCB_ACTIVE) =3D=3D 0)
-				printf("Inactive SCB in Waiting List\n");
+				printk("Inactive SCB in Waiting List\n");
 			ahd_done_with_status(ahd, scb, status);
 			/* FALLTHROUGH */
 		case SEARCH_REMOVE:
@@ -8480,7 +8476,7 @@ ahd_search_scb_list(struct ahd_softc *ahd, int ta=
rget, char channel,
 				*list_head =3D next;
 			break;
 		case SEARCH_PRINT:
-			printf("0x%x ", scbid);
+			printk("0x%x ", scbid);
 		case SEARCH_COUNT:
 			prev =3D scbid;
 			break;
@@ -8668,7 +8664,7 @@ ahd_abort_scbs(struct ahd_softc *ahd, int target,=
 char channel,
 			if (ahd_get_transaction_status(scbp) !=3D CAM_REQ_CMP)
 				ahd_freeze_scb(scbp);
 			if ((scbp->flags & SCB_ACTIVE) =3D=3D 0)
-				printf("Inactive SCB on pending list\n");
+				printk("Inactive SCB on pending list\n");
 			ahd_done(ahd, scbp);
 			found++;
 		}
@@ -8725,7 +8721,7 @@ ahd_reset_channel(struct ahd_softc *ahd, char cha=
nnel, int initiate_reset)
 	 * Check if the last bus reset is cleared
 	 */
 	if (ahd->flags & AHD_BUS_RESET_ACTIVE) {
-		printf("%s: bus reset still active\n",
+		printk("%s: bus reset still active\n",
 		       ahd_name(ahd));
 		return 0;
 	}
@@ -8900,7 +8896,7 @@ ahd_stat_timer(void *arg)
 		ahd_enable_coalescing(ahd, enint_coal);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_INT_COALESCING) !=3D 0)
-			printf("%s: Interrupt coalescing "
+			printk("%s: Interrupt coalescing "
 			       "now %sabled. Cmds %d\n",
 			       ahd_name(ahd),
 			       (enint_coal & ENINT_COALESCE) ? "en" : "dis",
@@ -8975,9 +8971,9 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, str=
uct scb *scb)
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_SENSE) !=3D 0) {
 			ahd_print_path(ahd, scb);
-			printf("SCB 0x%x Received PKT Status of 0x%x\n",
+			printk("SCB 0x%x Received PKT Status of 0x%x\n",
 			       SCB_GET_TAG(scb), siu->status);
-			printf("\tflags =3D 0x%x, sense len =3D 0x%x, "
+			printk("\tflags =3D 0x%x, sense len =3D 0x%x, "
 			       "pktfail =3D 0x%x\n",
 			       siu->flags, scsi_4btoul(siu->sense_length),
 			       scsi_4btoul(siu->pkt_failures_length));
@@ -8986,27 +8982,27 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, s=
truct scb *scb)
 		if ((siu->flags & SIU_RSPVALID) !=3D 0) {
 			ahd_print_path(ahd, scb);
 			if (scsi_4btoul(siu->pkt_failures_length) < 4) {
-				printf("Unable to parse pkt_failures\n");
+				printk("Unable to parse pkt_failures\n");
 			} else {
=20
 				switch (SIU_PKTFAIL_CODE(siu)) {
 				case SIU_PFC_NONE:
-					printf("No packet failure found\n");
+					printk("No packet failure found\n");
 					break;
 				case SIU_PFC_CIU_FIELDS_INVALID:
-					printf("Invalid Command IU Field\n");
+					printk("Invalid Command IU Field\n");
 					break;
 				case SIU_PFC_TMF_NOT_SUPPORTED:
-					printf("TMF not supportd\n");
+					printk("TMF not supportd\n");
 					break;
 				case SIU_PFC_TMF_FAILED:
-					printf("TMF failed\n");
+					printk("TMF failed\n");
 					break;
 				case SIU_PFC_INVALID_TYPE_CODE:
-					printf("Invalid L_Q Type code\n");
+					printk("Invalid L_Q Type code\n");
 					break;
 				case SIU_PFC_ILLEGAL_REQUEST:
-					printf("Illegal request\n");
+					printk("Illegal request\n");
 				default:
 					break;
 				}
@@ -9019,7 +9015,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, str=
uct scb *scb)
 			scb->flags |=3D SCB_PKT_SENSE;
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_SENSE) !=3D 0)
-				printf("Sense data available\n");
+				printk("Sense data available\n");
 #endif
 		}
 		ahd_done(ahd, scb);
@@ -9037,7 +9033,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, str=
uct scb *scb)
 #ifdef AHD_DEBUG
 		if (ahd_debug & AHD_SHOW_SENSE) {
 			ahd_print_path(ahd, scb);
-			printf("SCB %d: requests Check Status\n",
+			printk("SCB %d: requests Check Status\n",
 			       SCB_GET_TAG(scb));
 		}
 #endif
@@ -9065,7 +9061,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, str=
uct scb *scb)
 #ifdef AHD_DEBUG
 		if (ahd_debug & AHD_SHOW_SENSE) {
 			ahd_print_path(ahd, scb);
-			printf("Sending Sense\n");
+			printk("Sending Sense\n");
 		}
 #endif
 		scb->sg_count =3D 0;
@@ -9117,7 +9113,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, str=
uct scb *scb)
 		break;
 	}
 	case SCSI_STATUS_OK:
-		printf("%s: Interrupted for staus of 0???\n",
+		printk("%s: Interrupted for staus of 0???\n",
 		       ahd_name(ahd));
 		/* FALLTHROUGH */
 	default:
@@ -9192,7 +9188,7 @@ ahd_calc_residual(struct ahd_softc *ahd, struct s=
cb *scb)
 		return;
 	} else if ((resid_sgptr & SG_OVERRUN_RESID) !=3D 0) {
 		ahd_print_path(ahd, scb);
-		printf("data overrun detected Tag =3D=3D 0x%x.\n",
+		printk("data overrun detected Tag =3D=3D 0x%x.\n",
 		       SCB_GET_TAG(scb));
 		ahd_freeze_devq(ahd, scb);
 		ahd_set_transaction_status(scb, CAM_DATA_RUN_ERR);
@@ -9232,7 +9228,7 @@ ahd_calc_residual(struct ahd_softc *ahd, struct s=
cb *scb)
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MISC) !=3D 0) {
 		ahd_print_path(ahd, scb);
-		printf("Handled %sResidual of %d bytes\n",
+		printk("Handled %sResidual of %d bytes\n",
 		       (scb->flags & SCB_SENSE) ? "Sense " : "", resid);
 	}
 #endif
@@ -9272,7 +9268,7 @@ ahd_queue_lstate_event(struct ahd_softc *ahd, str=
uct ahd_tmode_lstate *lstate,
=20
 	if (pending =3D=3D AHD_TMODE_EVENT_BUFFER_SIZE) {
 		xpt_print_path(lstate->path);
-		printf("immediate event %x:%x lost\n",
+		printk("immediate event %x:%x lost\n",
 		       lstate->event_buffer[lstate->event_r_idx].event_type,
 		       lstate->event_buffer[lstate->event_r_idx].event_arg);
 		lstate->event_r_idx++;
@@ -9344,7 +9340,7 @@ ahd_dumpseq(struct ahd_softc* ahd)
 		uint8_t ins_bytes[4];
=20
 		ahd_insb(ahd, SEQRAM, ins_bytes, 4);
-		printf("0x%08x\n", ins_bytes[0] << 24
+		printk("0x%08x\n", ins_bytes[0] << 24
 				 | ins_bytes[1] << 16
 				 | ins_bytes[2] << 8
 				 | ins_bytes[3]);
@@ -9372,7 +9368,7 @@ ahd_loadseq(struct ahd_softc *ahd)
 	uint8_t	download_consts[DOWNLOAD_CONST_COUNT];
=20
 	if (bootverbose)
-		printf("%s: Downloading Sequencer Program...",
+		printk("%s: Downloading Sequencer Program...",
 		       ahd_name(ahd));
=20
 #if DOWNLOAD_CONST_COUNT !=3D 8
@@ -9498,7 +9494,7 @@ ahd_loadseq(struct ahd_softc *ahd)
 	if (cs_count !=3D 0) {
=20
 		cs_count *=3D sizeof(struct cs);
-		ahd->critical_sections =3D malloc(cs_count, M_DEVBUF, M_NOWAIT);
+		ahd->critical_sections =3D kmalloc(cs_count, GFP_ATOMIC);
 		if (ahd->critical_sections =3D=3D NULL)
 			panic("ahd_loadseq: Could not malloc");
 		memcpy(ahd->critical_sections, cs_table, cs_count);
@@ -9506,8 +9502,8 @@ ahd_loadseq(struct ahd_softc *ahd)
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
=20
 	if (bootverbose) {
-		printf(" %d instructions downloaded\n", downloaded);
-		printf("%s: Features 0x%x, Bugs 0x%x, Flags 0x%x\n",
+		printk(" %d instructions downloaded\n", downloaded);
+		printk("%s: Features 0x%x, Bugs 0x%x, Flags 0x%x\n",
 		       ahd_name(ahd), ahd->features, ahd->bugs, ahd->flags);
 	}
 }
@@ -9690,12 +9686,12 @@ ahd_print_register(const ahd_reg_parse_entry_t =
*table, u_int num_entries,
 	u_int	printed_mask;
=20
 	if (cur_column !=3D NULL && *cur_column >=3D wrap_point) {
-		printf("\n");
+		printk("\n");
 		*cur_column =3D 0;
 	}
-	printed =3D printf("%s[0x%x]", name, value);
+	printed =3D printk("%s[0x%x]", name, value);
 	if (table =3D=3D NULL) {
-		printed +=3D printf(" ");
+		printed +=3D printk(" ");
 		*cur_column +=3D printed;
 		return (printed);
 	}
@@ -9710,7 +9706,7 @@ ahd_print_register(const ahd_reg_parse_entry_t *t=
able, u_int num_entries,
 			  =3D=3D table[entry].mask))
 				continue;
=20
-			printed +=3D printf("%s%s",
+			printed +=3D printk("%s%s",
 					  printed_mask =3D=3D 0 ? ":(" : "|",
 					  table[entry].name);
 			printed_mask |=3D table[entry].mask;
@@ -9721,9 +9717,9 @@ ahd_print_register(const ahd_reg_parse_entry_t *t=
able, u_int num_entries,
 			break;
 	}
 	if (printed_mask !=3D 0)
-		printed +=3D printf(") ");
+		printed +=3D printk(") ");
 	else
-		printed +=3D printf(" ");
+		printed +=3D printk(" ");
 	if (cur_column !=3D NULL)
 		*cur_column +=3D printed;
 	return (printed);
@@ -9749,17 +9745,17 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	}
 	saved_modes =3D ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n=
"
+	printk(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n=
"
 	       "%s: Dumping Card State at program address 0x%x Mode 0x%x\n",
 	       ahd_name(ahd),=20
 	       ahd_inw(ahd, CURADDR),
 	       ahd_build_mode_state(ahd, ahd->saved_src_mode,
 				    ahd->saved_dst_mode));
 	if (paused)
-		printf("Card was paused\n");
+		printk("Card was paused\n");
=20
 	if (ahd_check_cmdcmpltqueues(ahd))
-		printf("Completions are pending\n");
+		printk("Completions are pending\n");
=20
 	/*
 	 * Mode independent registers.
@@ -9801,8 +9797,8 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	ahd_lqostat0_print(ahd_inb(ahd, LQOSTAT0), &cur_col, 50);
 	ahd_lqostat1_print(ahd_inb(ahd, LQOSTAT1), &cur_col, 50);
 	ahd_lqostat2_print(ahd_inb(ahd, LQOSTAT2), &cur_col, 50);
-	printf("\n");
-	printf("\nSCB Count =3D %d CMDS_PENDING =3D %d LASTSCB 0x%x "
+	printk("\n");
+	printk("\nSCB Count =3D %d CMDS_PENDING =3D %d LASTSCB 0x%x "
 	       "CURRSCB 0x%x NEXTSCB 0x%x\n",
 	       ahd->scb_data.numscbs, ahd_inw(ahd, CMDS_PENDING),
 	       ahd_inw(ahd, LASTSCB), ahd_inw(ahd, CURRSCB),
@@ -9813,12 +9809,12 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 			   CAM_LUN_WILDCARD, SCB_LIST_NULL,
 			   ROLE_UNKNOWN, /*status*/0, SEARCH_PRINT);
 	saved_scb_index =3D ahd_get_scbptr(ahd);
-	printf("Pending list:");
+	printk("Pending list:");
 	i =3D 0;
 	LIST_FOREACH(scb, &ahd->pending_scbs, pending_links) {
 		if (i++ > AHD_SCB_MAX)
 			break;
-		cur_col =3D printf("\n%3d FIFO_USE[0x%x] ", SCB_GET_TAG(scb),
+		cur_col =3D printk("\n%3d FIFO_USE[0x%x] ", SCB_GET_TAG(scb),
 				 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT));
 		ahd_set_scbptr(ahd, SCB_GET_TAG(scb));
 		ahd_scb_control_print(ahd_inb_scbram(ahd, SCB_CONTROL),
@@ -9826,16 +9822,16 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		ahd_scb_scsiid_print(ahd_inb_scbram(ahd, SCB_SCSIID),
 				     &cur_col, 60);
 	}
-	printf("\nTotal %d\n", i);
+	printk("\nTotal %d\n", i);
=20
-	printf("Kernel Free SCB list: ");
+	printk("Kernel Free SCB list: ");
 	i =3D 0;
 	TAILQ_FOREACH(scb, &ahd->scb_data.free_scbs, links.tqe) {
 		struct scb *list_scb;
=20
 		list_scb =3D scb;
 		do {
-			printf("%d ", SCB_GET_TAG(list_scb));
+			printk("%d ", SCB_GET_TAG(list_scb));
 			list_scb =3D LIST_NEXT(list_scb, collision_links);
 		} while (list_scb && i++ < AHD_SCB_MAX);
 	}
@@ -9843,49 +9839,49 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	LIST_FOREACH(scb, &ahd->scb_data.any_dev_free_scb_list, links.le) {
 		if (i++ > AHD_SCB_MAX)
 			break;
-		printf("%d ", SCB_GET_TAG(scb));
+		printk("%d ", SCB_GET_TAG(scb));
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Sequencer Complete DMA-inprog list: ");
+	printk("Sequencer Complete DMA-inprog list: ");
 	scb_index =3D ahd_inw(ahd, COMPLETE_SCB_DMAINPROG_HEAD);
 	i =3D 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printf("%d ", scb_index);
+		printk("%d ", scb_index);
 		scb_index =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Sequencer Complete list: ");
+	printk("Sequencer Complete list: ");
 	scb_index =3D ahd_inw(ahd, COMPLETE_SCB_HEAD);
 	i =3D 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printf("%d ", scb_index);
+		printk("%d ", scb_index);
 		scb_index =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printf("\n");
+	printk("\n");
=20
 =09
-	printf("Sequencer DMA-Up and Complete list: ");
+	printk("Sequencer DMA-Up and Complete list: ");
 	scb_index =3D ahd_inw(ahd, COMPLETE_DMA_SCB_HEAD);
 	i =3D 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printf("%d ", scb_index);
+		printk("%d ", scb_index);
 		scb_index =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printf("\n");
-	printf("Sequencer On QFreeze and Complete list: ");
+	printk("\n");
+	printk("Sequencer On QFreeze and Complete list: ");
 	scb_index =3D ahd_inw(ahd, COMPLETE_ON_QFREEZE_HEAD);
 	i =3D 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printf("%d ", scb_index);
+		printk("%d ", scb_index);
 		scb_index =3D ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printf("\n");
+	printk("\n");
 	ahd_set_scbptr(ahd, saved_scb_index);
 	dffstat =3D ahd_inb(ahd, DFFSTAT);
 	for (i =3D 0; i < 2; i++) {
@@ -9896,7 +9892,7 @@ ahd_dump_card_state(struct ahd_softc *ahd)
=20
 		ahd_set_modes(ahd, AHD_MODE_DFF0 + i, AHD_MODE_DFF0 + i);
 		fifo_scbptr =3D ahd_get_scbptr(ahd);
-		printf("\n\n%s: FIFO%d %s, LONGJMP =3D=3D 0x%x, SCB 0x%x\n",
+		printk("\n\n%s: FIFO%d %s, LONGJMP =3D=3D 0x%x, SCB 0x%x\n",
 		       ahd_name(ahd), i,
 		       (dffstat & (FIFO0FREE << i)) ? "Free" : "Active",
 		       ahd_inw(ahd, LONGJMP_ADDR), fifo_scbptr);
@@ -9912,20 +9908,20 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		ahd_soffcnt_print(ahd_inb(ahd, SOFFCNT), &cur_col, 50);
 		ahd_mdffstat_print(ahd_inb(ahd, MDFFSTAT), &cur_col, 50);
 		if (cur_col > 50) {
-			printf("\n");
+			printk("\n");
 			cur_col =3D 0;
 		}
-		cur_col +=3D printf("SHADDR =3D 0x%x%x, SHCNT =3D 0x%x ",
+		cur_col +=3D printk("SHADDR =3D 0x%x%x, SHCNT =3D 0x%x ",
 				  ahd_inl(ahd, SHADDR+4),
 				  ahd_inl(ahd, SHADDR),
 				  (ahd_inb(ahd, SHCNT)
 				| (ahd_inb(ahd, SHCNT + 1) << 8)
 				| (ahd_inb(ahd, SHCNT + 2) << 16)));
 		if (cur_col > 50) {
-			printf("\n");
+			printk("\n");
 			cur_col =3D 0;
 		}
-		cur_col +=3D printf("HADDR =3D 0x%x%x, HCNT =3D 0x%x ",
+		cur_col +=3D printk("HADDR =3D 0x%x%x, HCNT =3D 0x%x ",
 				  ahd_inl(ahd, HADDR+4),
 				  ahd_inl(ahd, HADDR),
 				  (ahd_inb(ahd, HCNT)
@@ -9940,52 +9936,52 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		}
 #endif
 	}
-	printf("\nLQIN: ");
+	printk("\nLQIN: ");
 	for (i =3D 0; i < 20; i++)
-		printf("0x%x ", ahd_inb(ahd, LQIN + i));
-	printf("\n");
+		printk("0x%x ", ahd_inb(ahd, LQIN + i));
+	printk("\n");
 	ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
-	printf("%s: LQISTATE =3D 0x%x, LQOSTATE =3D 0x%x, OPTIONMODE =3D 0x%x=
\n",
+	printk("%s: LQISTATE =3D 0x%x, LQOSTATE =3D 0x%x, OPTIONMODE =3D 0x%x=
\n",
 	       ahd_name(ahd), ahd_inb(ahd, LQISTATE), ahd_inb(ahd, LQOSTATE),
 	       ahd_inb(ahd, OPTIONMODE));
-	printf("%s: OS_SPACE_CNT =3D 0x%x MAXCMDCNT =3D 0x%x\n",
+	printk("%s: OS_SPACE_CNT =3D 0x%x MAXCMDCNT =3D 0x%x\n",
 	       ahd_name(ahd), ahd_inb(ahd, OS_SPACE_CNT),
 	       ahd_inb(ahd, MAXCMDCNT));
-	printf("%s: SAVED_SCSIID =3D 0x%x SAVED_LUN =3D 0x%x\n",
+	printk("%s: SAVED_SCSIID =3D 0x%x SAVED_LUN =3D 0x%x\n",
 	       ahd_name(ahd), ahd_inb(ahd, SAVED_SCSIID),
 	       ahd_inb(ahd, SAVED_LUN));
 	ahd_simode0_print(ahd_inb(ahd, SIMODE0), &cur_col, 50);
-	printf("\n");
+	printk("\n");
 	ahd_set_modes(ahd, AHD_MODE_CCHAN, AHD_MODE_CCHAN);
 	cur_col =3D 0;
 	ahd_ccscbctl_print(ahd_inb(ahd, CCSCBCTL), &cur_col, 50);
-	printf("\n");
+	printk("\n");
 	ahd_set_modes(ahd, ahd->saved_src_mode, ahd->saved_dst_mode);
-	printf("%s: REG0 =3D=3D 0x%x, SINDEX =3D 0x%x, DINDEX =3D 0x%x\n",
+	printk("%s: REG0 =3D=3D 0x%x, SINDEX =3D 0x%x, DINDEX =3D 0x%x\n",
 	       ahd_name(ahd), ahd_inw(ahd, REG0), ahd_inw(ahd, SINDEX),
 	       ahd_inw(ahd, DINDEX));
-	printf("%s: SCBPTR =3D=3D 0x%x, SCB_NEXT =3D=3D 0x%x, SCB_NEXT2 =3D=3D=
 0x%x\n",
+	printk("%s: SCBPTR =3D=3D 0x%x, SCB_NEXT =3D=3D 0x%x, SCB_NEXT2 =3D=3D=
 0x%x\n",
 	       ahd_name(ahd), ahd_get_scbptr(ahd),
 	       ahd_inw_scbram(ahd, SCB_NEXT),
 	       ahd_inw_scbram(ahd, SCB_NEXT2));
-	printf("CDB %x %x %x %x %x %x\n",
+	printk("CDB %x %x %x %x %x %x\n",
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+1),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+2),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+3),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+4),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+5));
-	printf("STACK:");
+	printk("STACK:");
 	for (i =3D 0; i < ahd->stack_size; i++) {
 		ahd->saved_stack[i] =3D
 		    ahd_inb(ahd, STACK)|(ahd_inb(ahd, STACK) << 8);
-		printf(" 0x%x", ahd->saved_stack[i]);
+		printk(" 0x%x", ahd->saved_stack[i]);
 	}
 	for (i =3D ahd->stack_size-1; i >=3D 0; i--) {
 		ahd_outb(ahd, STACK, ahd->saved_stack[i] & 0xFF);
 		ahd_outb(ahd, STACK, (ahd->saved_stack[i] >> 8) & 0xFF);
 	}
-	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n=
");
+	printk("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n=
");
 	ahd_restore_modes(ahd, saved_modes);
 	if (paused =3D=3D 0)
 		ahd_unpause(ahd);
@@ -10004,8 +10000,8 @@ ahd_dump_scbs(struct ahd_softc *ahd)
 	saved_scb_index =3D ahd_get_scbptr(ahd);
 	for (i =3D 0; i < AHD_SCB_MAX; i++) {
 		ahd_set_scbptr(ahd, i);
-		printf("%3d", i);
-		printf("(CTRL 0x%x ID 0x%x N 0x%x N2 0x%x SG 0x%x, RSG 0x%x)\n",
+		printk("%3d", i);
+		printk("(CTRL 0x%x ID 0x%x N 0x%x N2 0x%x SG 0x%x, RSG 0x%x)\n",
 		       ahd_inb_scbram(ahd, SCB_CONTROL),
 		       ahd_inb_scbram(ahd, SCB_SCSIID),
 		       ahd_inw_scbram(ahd, SCB_NEXT),
@@ -10013,7 +10009,7 @@ ahd_dump_scbs(struct ahd_softc *ahd)
 		       ahd_inl_scbram(ahd, SCB_SGPTR),
 		       ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR));
 	}
-	printf("\n");
+	printk("\n");
 	ahd_set_scbptr(ahd, saved_scb_index);
 	ahd_restore_modes(ahd, saved_modes);
 }
@@ -10383,7 +10379,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 	 && ccb->ccb_h.target_id !=3D CAM_TARGET_WILDCARD) {
 		u_long	s;
=20
-		printf("Configuring Target Mode\n");
+		printk("Configuring Target Mode\n");
 		ahd_lock(ahd, &s);
 		if (LIST_FIRST(&ahd->pending_scbs) !=3D NULL) {
 			ccb->ccb_h.status =3D CAM_BUSY;
@@ -10412,7 +10408,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 		/* Are we already enabled?? */
 		if (lstate !=3D NULL) {
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Lun already enabled\n");
+			printk("Lun already enabled\n");
 			ccb->ccb_h.status =3D CAM_LUN_ALRDY_ENA;
 			return;
 		}
@@ -10424,7 +10420,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 			 * specific commands.
 			 */
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
-			printf("Non-zero Group Codes\n");
+			printk("Non-zero Group Codes\n");
 			return;
 		}
=20
@@ -10436,15 +10432,15 @@ ahd_handle_en_lun(struct ahd_softc *ahd, stru=
ct cam_sim *sim, union ccb *ccb)
 			tstate =3D ahd_alloc_tstate(ahd, target, channel);
 			if (tstate =3D=3D NULL) {
 				xpt_print_path(ccb->ccb_h.path);
-				printf("Couldn't allocate tstate\n");
+				printk("Couldn't allocate tstate\n");
 				ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 				return;
 			}
 		}
-		lstate =3D malloc(sizeof(*lstate), M_DEVBUF, M_NOWAIT);
+		lstate =3D kmalloc(sizeof(*lstate), GFP_ATOMIC);
 		if (lstate =3D=3D NULL) {
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Couldn't allocate lstate\n");
+			printk("Couldn't allocate lstate\n");
 			ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 			return;
 		}
@@ -10454,9 +10450,9 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 					 xpt_path_target_id(ccb->ccb_h.path),
 					 xpt_path_lun_id(ccb->ccb_h.path));
 		if (status !=3D CAM_REQ_CMP) {
-			free(lstate, M_DEVBUF);
+			kfree(lstate);
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Couldn't allocate path\n");
+			printk("Couldn't allocate path\n");
 			ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 			return;
 		}
@@ -10524,7 +10520,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 		ahd_unlock(ahd, &s);
 		ccb->ccb_h.status =3D CAM_REQ_CMP;
 		xpt_print_path(ccb->ccb_h.path);
-		printf("Lun now enabled for target mode\n");
+		printk("Lun now enabled for target mode\n");
 	} else {
 		struct scb *scb;
 		int i, empty;
@@ -10543,7 +10539,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 			ccbh =3D &scb->io_ctx->ccb_h;
 			if (ccbh->func_code =3D=3D XPT_CONT_TARGET_IO
 			 && !xpt_path_comp(ccbh->path, ccb->ccb_h.path)){
-				printf("CTIO pending\n");
+				printk("CTIO pending\n");
 				ccb->ccb_h.status =3D CAM_REQ_INVALID;
 				ahd_unlock(ahd, &s);
 				return;
@@ -10551,12 +10547,12 @@ ahd_handle_en_lun(struct ahd_softc *ahd, stru=
ct cam_sim *sim, union ccb *ccb)
 		}
=20
 		if (SLIST_FIRST(&lstate->accept_tios) !=3D NULL) {
-			printf("ATIOs pending\n");
+			printk("ATIOs pending\n");
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
 		}
=20
 		if (SLIST_FIRST(&lstate->immed_notifies) !=3D NULL) {
-			printf("INOTs pending\n");
+			printk("INOTs pending\n");
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
 		}
=20
@@ -10566,9 +10562,9 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 		}
=20
 		xpt_print_path(ccb->ccb_h.path);
-		printf("Target mode disabled\n");
+		printk("Target mode disabled\n");
 		xpt_free_path(lstate->path);
-		free(lstate, M_DEVBUF);
+		kfree(lstate);
=20
 		ahd_pause(ahd);
 		/* Can we clean up the target too? */
@@ -10615,7 +10611,7 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct=
 cam_sim *sim, union ccb *ccb)
 			ahd_outb(ahd, SCSISEQ1, scsiseq1);
=20
 			if ((ahd->features & AHD_MULTIROLE) =3D=3D 0) {
-				printf("Configuring Initiator Mode\n");
+				printk("Configuring Initiator Mode\n");
 				ahd->flags &=3D ~AHD_TARGETROLE;
 				ahd->flags |=3D AHD_INITIATORROLE;
 				ahd_pause(ahd);
@@ -10749,7 +10745,7 @@ ahd_handle_target_cmd(struct ahd_softc *ahd, st=
ruct target_cmd *cmd)
 		ahd->flags &=3D ~AHD_TQINFIFO_BLOCKED;
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_TQIN) !=3D 0)
-		printf("Incoming command from %d for %d:%d%s\n",
+		printk("Incoming command from %d for %d:%d%s\n",
 		       initiator, target, lun,
 		       lstate =3D=3D ahd->black_hole ? "(Black Holed)" : "");
 #endif
@@ -10796,7 +10792,7 @@ ahd_handle_target_cmd(struct ahd_softc *ahd, st=
ruct target_cmd *cmd)
 	default:
 		/* Only copy the opcode. */
 		atio->cdb_len =3D 1;
-		printf("Reserved or VU command code type encountered\n");
+		printk("Reserved or VU command code type encountered\n");
 		break;
 	}
 =09
@@ -10813,7 +10809,7 @@ ahd_handle_target_cmd(struct ahd_softc *ahd, st=
ruct target_cmd *cmd)
 		 */
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_TQIN) !=3D 0)
-			printf("Received Immediate Command %d:%d:%d - %p\n",
+			printk("Received Immediate Command %d:%d:%d - %p\n",
 			       initiator, target, lun, ahd->pending_device);
 #endif
 		ahd->pending_device =3D lstate;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/=
aic79xx_osm.c
index 4c41332..f022338 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -674,7 +674,7 @@ ahd_linux_slave_alloc(struct scsi_device *sdev)
 	struct ahd_linux_device *dev;
=20
 	if (bootverbose)
-		printf("%s: Slave Alloc %d\n", ahd_name(ahd), sdev->id);
+		printk("%s: Slave Alloc %d\n", ahd_name(ahd), sdev->id);
=20
 	dev =3D scsi_transport_device_data(sdev);
 	memset(dev, 0, sizeof(*dev));
@@ -798,10 +798,10 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	scmd_printk(KERN_INFO, cmd,
 		    "Attempting to queue a TARGET RESET message:");
=20
-	printf("CDB:");
+	printk("CDB:");
 	for (cdb_byte =3D 0; cdb_byte < cmd->cmd_len; cdb_byte++)
-		printf(" 0x%x", cmd->cmnd[cdb_byte]);
-	printf("\n");
+		printk(" 0x%x", cmd->cmnd[cdb_byte]);
+	printk("\n");
=20
 	/*
 	 * Determine if we currently own this command.
@@ -857,16 +857,16 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	ahd->platform_data->eh_done =3D &done;
 	ahd_unlock(ahd, &flags);
=20
-	printf("%s: Device reset code sleeping\n", ahd_name(ahd));
+	printk("%s: Device reset code sleeping\n", ahd_name(ahd));
 	if (!wait_for_completion_timeout(&done, 5 * HZ)) {
 		ahd_lock(ahd, &flags);
 		ahd->platform_data->eh_done =3D NULL;
 		ahd_unlock(ahd, &flags);
-		printf("%s: Device reset timer expired (active %d)\n",
+		printk("%s: Device reset timer expired (active %d)\n",
 		       ahd_name(ahd), dev->active);
 		retval =3D FAILED;
 	}
-	printf("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
+	printk("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
=20
 	return (retval);
 }
@@ -884,7 +884,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cmd)
 	ahd =3D *(struct ahd_softc **)cmd->device->host->hostdata;
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_RECOVERY) !=3D 0)
-		printf("%s: Bus reset called for cmd %p\n",
+		printk("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
 	ahd_lock(ahd, &flags);
@@ -894,7 +894,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cmd)
 	ahd_unlock(ahd, &flags);
=20
 	if (bootverbose)
-		printf("%s: SCSI bus reset delivered. "
+		printk("%s: SCSI bus reset delivered. "
 		       "%d SCBs aborted.\n", ahd_name(ahd), found);
=20
 	return (SUCCESS);
@@ -935,7 +935,7 @@ ahd_dma_tag_create(struct ahd_softc *ahd, bus_dma_t=
ag_t parent,
 {
 	bus_dma_tag_t dmat;
=20
-	dmat =3D malloc(sizeof(*dmat), M_DEVBUF, M_NOWAIT);
+	dmat =3D kmalloc(sizeof(*dmat), GFP_ATOMIC);
 	if (dmat =3D=3D NULL)
 		return (ENOMEM);
=20
@@ -956,7 +956,7 @@ ahd_dma_tag_create(struct ahd_softc *ahd, bus_dma_t=
ag_t parent,
 void
 ahd_dma_tag_destroy(struct ahd_softc *ahd, bus_dma_tag_t dmat)
 {
-	free(dmat, M_DEVBUF);
+	kfree(dmat);
 }
=20
 int
@@ -1019,7 +1019,7 @@ ahd_linux_setup_iocell_info(u_long index, int ins=
tance, int targ, int32_t value)
 		iocell_info =3D (uint8_t*)&aic79xx_iocell_info[instance];
 		iocell_info[index] =3D value & 0xFFFF;
 		if (bootverbose)
-			printf("iocell[%d:%ld] =3D %d\n", instance, index, value);
+			printk("iocell[%d:%ld] =3D %d\n", instance, index, value);
 	}
 }
=20
@@ -1029,7 +1029,7 @@ ahd_linux_setup_tag_info_global(char *p)
 	int tags, i, j;
=20
 	tags =3D simple_strtoul(p + 1, NULL, 0) & 0xff;
-	printf("Setting Global Tags=3D %d\n", tags);
+	printk("Setting Global Tags=3D %d\n", tags);
=20
 	for (i =3D 0; i < ARRAY_SIZE(aic79xx_tag_info); i++) {
 		for (j =3D 0; j < AHD_NUM_TARGETS; j++) {
@@ -1047,7 +1047,7 @@ ahd_linux_setup_tag_info(u_long arg, int instance=
, int targ, int32_t value)
 	 && (targ < AHD_NUM_TARGETS)) {
 		aic79xx_tag_info[instance].tag_commands[targ] =3D value & 0x1FF;
 		if (bootverbose)
-			printf("tag_info[%d:%d] =3D %d\n", instance, targ, value);
+			printk("tag_info[%d:%d] =3D %d\n", instance, targ, value);
 	}
 }
=20
@@ -1088,7 +1088,7 @@ ahd_parse_brace_option(char *opt_name, char *opt_=
arg, char *end, int depth,
 					if (targ =3D=3D -1)
 						targ =3D 0;
 				} else {
-					printf("Malformed Option %s\n",
+					printk("Malformed Option %s\n",
 					       opt_name);
 					done =3D TRUE;
 				}
@@ -1246,7 +1246,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, st=
ruct scsi_host_template *templa
 	ahd_set_unit(ahd, ahd_linux_unit++);
 	ahd_unlock(ahd, &s);
 	sprintf(buf, "scsi%d", host->host_no);
-	new_name =3D malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	new_name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (new_name !=3D NULL) {
 		strcpy(new_name, buf);
 		ahd_set_name(ahd, new_name);
@@ -1322,7 +1322,7 @@ int
 ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
 {
 	ahd->platform_data =3D
-	    malloc(sizeof(struct ahd_platform_data), M_DEVBUF, M_NOWAIT);
+	    kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
 	if (ahd->platform_data =3D=3D NULL)
 		return (ENOMEM);
 	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
@@ -1364,7 +1364,7 @@ ahd_platform_free(struct ahd_softc *ahd)
 		if (ahd->platform_data->host)
 			scsi_host_put(ahd->platform_data->host);
=20
-		free(ahd->platform_data, M_DEVBUF);
+		kfree(ahd->platform_data);
 	}
 }
=20
@@ -1502,7 +1502,7 @@ ahd_linux_user_tagdepth(struct ahd_softc *ahd, st=
ruct ahd_devinfo *devinfo)
 		if (ahd->unit >=3D ARRAY_SIZE(aic79xx_tag_info)) {
=20
 			if (warned_user =3D=3D 0) {
-				printf(KERN_WARNING
+				printk(KERN_WARNING
 "aic79xx: WARNING: Insufficient tag_info instances\n"
 "aic79xx: for installed controllers.  Using defaults\n"
 "aic79xx: Please update the aic79xx_tag_info array in\n"
@@ -1544,7 +1544,7 @@ ahd_linux_device_queue_depth(struct scsi_device *=
sdev)
 		ahd_send_async(ahd, devinfo.channel, devinfo.target,
 			       devinfo.lun, AC_TRANSFER_NEG);
 		ahd_print_devinfo(ahd, &devinfo);
-		printf("Tagged Queuing enabled.  Depth %d\n", tags);
+		printk("Tagged Queuing enabled.  Depth %d\n", tags);
 	} else {
 		ahd_platform_set_tags(ahd, sdev, &devinfo, AHD_QUEUE_NONE);
 		ahd_send_async(ahd, devinfo.channel, devinfo.target,
@@ -1794,7 +1794,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	struct	  ahd_linux_device *dev;
=20
 	if ((scb->flags & SCB_ACTIVE) =3D=3D 0) {
-		printf("SCB %d done'd twice\n", SCB_GET_TAG(scb));
+		printk("SCB %d done'd twice\n", SCB_GET_TAG(scb));
 		ahd_dump_card_state(ahd);
 		panic("Stopping for safety");
 	}
@@ -1825,7 +1825,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MISC) !=3D 0) {
 				ahd_print_path(ahd, scb);
-				printf("Set CAM_UNCOR_PARITY\n");
+				printk("Set CAM_UNCOR_PARITY\n");
 			}
 #endif
 			ahd_set_transaction_status(scb, CAM_UNCOR_PARITY);
@@ -1843,12 +1843,12 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb=
)
 			u_int i;
=20
 			ahd_print_path(ahd, scb);
-			printf("CDB:");
+			printk("CDB:");
 			for (i =3D 0; i < scb->io_ctx->cmd_len; i++)
-				printf(" 0x%x", scb->io_ctx->cmnd[i]);
-			printf("\n");
+				printk(" 0x%x", scb->io_ctx->cmnd[i]);
+			printk("\n");
 			ahd_print_path(ahd, scb);
-			printf("Saw underflow (%ld of %ld bytes). "
+			printk("Saw underflow (%ld of %ld bytes). "
 			       "Treated as error\n",
 				ahd_get_residual(scb),
 				ahd_get_transfer_length(scb));
@@ -1881,7 +1881,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 		dev->commands_since_idle_or_otag =3D 0;
=20
 	if ((scb->flags & SCB_RECOVERY_SCB) !=3D 0) {
-		printf("Recovery SCB completes\n");
+		printk("Recovery SCB completes\n");
 		if (ahd_get_transaction_status(scb) =3D=3D CAM_BDR_SENT
 		 || ahd_get_transaction_status(scb) =3D=3D CAM_REQ_ABORTED)
 			ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
@@ -1963,14 +1963,14 @@ ahd_linux_handle_scsi_status(struct ahd_softc *=
ahd,
 			if (ahd_debug & AHD_SHOW_SENSE) {
 				int i;
=20
-				printf("Copied %d bytes of sense data at %d:",
+				printk("Copied %d bytes of sense data at %d:",
 				       sense_size, sense_offset);
 				for (i =3D 0; i < sense_size; i++) {
 					if ((i & 0xF) =3D=3D 0)
-						printf("\n");
-					printf("0x%x ", cmd->sense_buffer[i]);
+						printk("\n");
+					printk("0x%x ", cmd->sense_buffer[i]);
 				}
-				printf("\n");
+				printk("\n");
 			}
 #endif
 		}
@@ -1995,7 +1995,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ah=
d,
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_QFULL) !=3D 0) {
 				ahd_print_path(ahd, scb);
-				printf("Dropping tag count to %d\n",
+				printk("Dropping tag count to %d\n",
 				       dev->active);
 			}
 #endif
@@ -2014,7 +2014,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ah=
d,
 				 =3D=3D AHD_LOCK_TAGS_COUNT) {
 					dev->maxtags =3D dev->active;
 					ahd_print_path(ahd, scb);
-					printf("Locking max tag count at %d\n",
+					printk("Locking max tag count at %d\n",
 					       dev->active);
 				}
 			} else {
@@ -2138,7 +2138,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ah=
d, struct scsi_cmnd *cmd)
 	}
=20
 	if (do_fallback) {
-		printf("%s: device overrun (status %x) on %d:%d:%d\n",
+		printk("%s: device overrun (status %x) on %d:%d:%d\n",
 		       ahd_name(ahd), status, cmd->device->channel,
 		       cmd->device->id, cmd->device->lun);
 	}
@@ -2187,10 +2187,10 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd=
)
 	scmd_printk(KERN_INFO, cmd,
 		    "Attempting to queue an ABORT message:");
=20
-	printf("CDB:");
+	printk("CDB:");
 	for (cdb_byte =3D 0; cdb_byte < cmd->cmd_len; cdb_byte++)
-		printf(" 0x%x", cmd->cmnd[cdb_byte]);
-	printf("\n");
+		printk(" 0x%x", cmd->cmnd[cdb_byte]);
+	printk("\n");
=20
 	ahd_lock(ahd, &flags);
=20
@@ -2249,7 +2249,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 		goto no_cmd;
 	}
=20
-	printf("%s: At time of recovery, card was %spaused\n",
+	printk("%s: At time of recovery, card was %spaused\n",
 	       ahd_name(ahd), was_paused ? "" : "not ");
 	ahd_dump_card_state(ahd);
=20
@@ -2260,7 +2260,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 			       pending_scb->hscb->tag,
 			       ROLE_INITIATOR, CAM_REQ_ABORTED,
 			       SEARCH_COMPLETE) > 0) {
-		printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
+		printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 		       ahd_name(ahd), cmd->device->channel,=20
 		       cmd->device->id, cmd->device->lun);
 		retval =3D SUCCESS;
@@ -2355,7 +2355,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 		ahd_qinfifo_requeue_tail(ahd, pending_scb);
 		ahd_set_scbptr(ahd, saved_scbptr);
 		ahd_print_path(ahd, pending_scb);
-		printf("Device is disconnected, re-queuing SCB\n");
+		printk("Device is disconnected, re-queuing SCB\n");
 		wait =3D TRUE;
 	} else {
 		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
@@ -2380,21 +2380,21 @@ done:
 		ahd->platform_data->eh_done =3D &done;
 		ahd_unlock(ahd, &flags);
=20
-		printf("%s: Recovery code sleeping\n", ahd_name(ahd));
+		printk("%s: Recovery code sleeping\n", ahd_name(ahd));
 		if (!wait_for_completion_timeout(&done, 5 * HZ)) {
 			ahd_lock(ahd, &flags);
 			ahd->platform_data->eh_done =3D NULL;
 			ahd_unlock(ahd, &flags);
-			printf("%s: Timer Expired (active %d)\n",
+			printk("%s: Timer Expired (active %d)\n",
 			       ahd_name(ahd), dev->active);
 			retval =3D FAILED;
 		}
-		printf("Recovery code awake\n");
+		printk("Recovery code awake\n");
 	} else
 		ahd_unlock(ahd, &flags);
=20
 	if (retval !=3D SUCCESS)
-		printf("%s: Command abort returning 0x%x\n",
+		printk("%s: Command abort returning 0x%x\n",
 		       ahd_name(ahd), retval);
=20
 	return retval;
@@ -2431,7 +2431,7 @@ static void ahd_linux_set_period(struct scsi_targ=
et *starget, int period)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: set period to %d\n", ahd_name(ahd), period);
+		printk("%s: set period to %d\n", ahd_name(ahd), period);
 #endif
 	if (offset =3D=3D 0)
 		offset =3D MAX_OFFSET;
@@ -2484,7 +2484,7 @@ static void ahd_linux_set_offset(struct scsi_targ=
et *starget, int offset)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: set offset to %d\n", ahd_name(ahd), offset);
+		printk("%s: set offset to %d\n", ahd_name(ahd), offset);
 #endif
=20
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
@@ -2520,7 +2520,7 @@ static void ahd_linux_set_dt(struct scsi_target *=
starget, int dt)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s DT\n", ahd_name(ahd),=20
+		printk("%s: %s DT\n", ahd_name(ahd),=20
 		       dt ? "enabling" : "disabling");
 #endif
 	if (dt && spi_max_width(starget)) {
@@ -2562,7 +2562,7 @@ static void ahd_linux_set_qas(struct scsi_target =
*starget, int qas)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s QAS\n", ahd_name(ahd),=20
+		printk("%s: %s QAS\n", ahd_name(ahd),=20
 		       qas ? "enabling" : "disabling");
 #endif
=20
@@ -2601,7 +2601,7 @@ static void ahd_linux_set_iu(struct scsi_target *=
starget, int iu)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s IU\n", ahd_name(ahd),
+		printk("%s: %s IU\n", ahd_name(ahd),
 		       iu ? "enabling" : "disabling");
 #endif
=20
@@ -2641,7 +2641,7 @@ static void ahd_linux_set_rd_strm(struct scsi_tar=
get *starget, int rdstrm)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s Read Streaming\n", ahd_name(ahd),=20
+		printk("%s: %s Read Streaming\n", ahd_name(ahd),=20
 		       rdstrm  ? "enabling" : "disabling");
 #endif
=20
@@ -2677,7 +2677,7 @@ static void ahd_linux_set_wr_flow(struct scsi_tar=
get *starget, int wrflow)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s Write Flow Control\n", ahd_name(ahd),
+		printk("%s: %s Write Flow Control\n", ahd_name(ahd),
 		       wrflow ? "enabling" : "disabling");
 #endif
=20
@@ -2714,14 +2714,14 @@ static void ahd_linux_set_rti(struct scsi_targe=
t *starget, int rti)
 	if ((ahd->features & AHD_RTI) =3D=3D 0) {
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-			printf("%s: RTI not available\n", ahd_name(ahd));
+			printk("%s: RTI not available\n", ahd_name(ahd));
 #endif
 		return;
 	}
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s RTI\n", ahd_name(ahd),
+		printk("%s: %s RTI\n", ahd_name(ahd),
 		       rti ? "enabling" : "disabling");
 #endif
=20
@@ -2757,7 +2757,7 @@ static void ahd_linux_set_pcomp_en(struct scsi_ta=
rget *starget, int pcomp)
=20
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_DV) !=3D 0)
-		printf("%s: %s Precompensation\n", ahd_name(ahd),=20
+		printk("%s: %s Precompensation\n", ahd_name(ahd),=20
 		       pcomp ? "Enable" : "Disable");
 #endif
=20
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/=
aic79xx_osm.h
index 55c1fe0..28e4349 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -363,13 +363,6 @@ struct ahd_platform_data {
 	resource_size_t		 mem_busaddr;	/* Mem Base Addr */
 };
=20
-/************************** OS Utility Wrappers **********************=
*********/
-#define printf printk
-#define M_NOWAIT GFP_ATOMIC
-#define M_WAITOK 0
-#define malloc(size, type, flags) kmalloc(size, flags)
-#define free(ptr, type) kfree(ptr)
-
 void ahd_delay(long);
=20
 /***************************** Low Level I/O *************************=
*********/
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic79xx_osm_pci.c
index 8f68612..3c85873 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -178,7 +178,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
 		ahd_get_pci_bus(pci),
 		ahd_get_pci_slot(pci),
 		ahd_get_pci_function(pci));
-	name =3D malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (name =3D=3D NULL)
 		return (-ENOMEM);
 	strcpy(name, buf);
@@ -333,7 +333,7 @@ ahd_pci_map_registers(struct ahd_softc *ahd)
=20
 		if (ahd_pci_test_register_access(ahd) !=3D 0) {
=20
-			printf("aic79xx: PCI Device %d:%d:%d "
+			printk("aic79xx: PCI Device %d:%d:%d "
 			       "failed memory mapped test.  Using PIO.\n",
 			       ahd_get_pci_bus(ahd->dev_softc),
 			       ahd_get_pci_slot(ahd->dev_softc),
@@ -346,7 +346,7 @@ ahd_pci_map_registers(struct ahd_softc *ahd)
 		} else
 			command |=3D PCIM_CMD_MEMEN;
 	} else if (bootverbose) {
-		printf("aic79xx: PCI%d:%d:%d MEM region 0x%llx "
+		printk("aic79xx: PCI%d:%d:%d MEM region 0x%llx "
 		       "unavailable. Cannot memory map device.\n",
 		       ahd_get_pci_bus(ahd->dev_softc),
 		       ahd_get_pci_slot(ahd->dev_softc),
@@ -365,7 +365,7 @@ ahd_pci_map_registers(struct ahd_softc *ahd)
 			ahd->bshs[1].ioport =3D (u_long)base2;
 			command |=3D PCIM_CMD_PORTEN;
 		} else {
-			printf("aic79xx: PCI%d:%d:%d IO regions 0x%llx and "
+			printk("aic79xx: PCI%d:%d:%d IO regions 0x%llx and "
 			       "0x%llx unavailable. Cannot map device.\n",
 			       ahd_get_pci_bus(ahd->dev_softc),
 			       ahd_get_pci_slot(ahd->dev_softc),
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/=
aic79xx_pci.c
index 90a04a3..14b5f8d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -338,7 +338,7 @@ ahd_pci_config(struct ahd_softc *ahd, const struct =
ahd_pci_identity *entry)
 	 */
 	if ((ahd->flags & (AHD_39BIT_ADDRESSING|AHD_64BIT_ADDRESSING)) !=3D 0=
) {
 		if (bootverbose)
-			printf("%s: Enabling 39Bit Addressing\n",
+			printk("%s: Enabling 39Bit Addressing\n",
 			       ahd_name(ahd));
 		devconfig =3D ahd_pci_read_config(ahd->dev_softc,
 						DEVCONFIG, /*bytes*/4);
@@ -528,7 +528,7 @@ ahd_check_extport(struct ahd_softc *ahd)
 		 * Fetch VPD for this function and parse it.
 		 */
 		if (bootverbose)=20
-			printf("%s: Reading VPD from SEEPROM...",
+			printk("%s: Reading VPD from SEEPROM...",
 			       ahd_name(ahd));
=20
 		/* Address is always in units of 16bit words */
@@ -541,12 +541,12 @@ ahd_check_extport(struct ahd_softc *ahd)
 		if (error =3D=3D 0)
 			error =3D ahd_parse_vpddata(ahd, &vpd);
 		if (bootverbose)=20
-			printf("%s: VPD parsing %s\n",
+			printk("%s: VPD parsing %s\n",
 			       ahd_name(ahd),
 			       error =3D=3D 0 ? "successful" : "failed");
=20
 		if (bootverbose)=20
-			printf("%s: Reading SEEPROM...", ahd_name(ahd));
+			printk("%s: Reading SEEPROM...", ahd_name(ahd));
=20
 		/* Address is always in units of 16bit words */
 		start_addr =3D (sizeof(*sc) / 2) * (ahd->channel - 'A');
@@ -556,16 +556,16 @@ ahd_check_extport(struct ahd_softc *ahd)
 					 /*bytestream*/FALSE);
=20
 		if (error !=3D 0) {
-			printf("Unable to read SEEPROM\n");
+			printk("Unable to read SEEPROM\n");
 			have_seeprom =3D 0;
 		} else {
 			have_seeprom =3D ahd_verify_cksum(sc);
=20
 			if (bootverbose) {
 				if (have_seeprom =3D=3D 0)
-					printf ("checksum error\n");
+					printk ("checksum error\n");
 				else
-					printf ("done.\n");
+					printk ("done.\n");
 			}
 		}
 		ahd_release_seeprom(ahd);
@@ -615,21 +615,21 @@ ahd_check_extport(struct ahd_softc *ahd)
 		uint16_t *sc_data;
 		int	  i;
=20
-		printf("%s: Seeprom Contents:", ahd_name(ahd));
+		printk("%s: Seeprom Contents:", ahd_name(ahd));
 		sc_data =3D (uint16_t *)sc;
 		for (i =3D 0; i < (sizeof(*sc)); i +=3D 2)
-			printf("\n\t0x%.4x", sc_data[i]);
-		printf("\n");
+			printk("\n\t0x%.4x", sc_data[i]);
+		printk("\n");
 	}
 #endif
=20
 	if (!have_seeprom) {
 		if (bootverbose)
-			printf("%s: No SEEPROM available.\n", ahd_name(ahd));
+			printk("%s: No SEEPROM available.\n", ahd_name(ahd));
 		ahd->flags |=3D AHD_USEDEFAULTS;
 		error =3D ahd_default_config(ahd);
 		adapter_control =3D CFAUTOTERM|CFSEAUTOTERM;
-		free(ahd->seep_config, M_DEVBUF);
+		kfree(ahd->seep_config);
 		ahd->seep_config =3D NULL;
 	} else {
 		error =3D ahd_parse_cfgdata(ahd, sc);
@@ -656,7 +656,7 @@ ahd_configure_termination(struct ahd_softc *ahd, u_=
int adapter_control)
 	if ((ahd->flags & AHD_STPWLEVEL_A) !=3D 0)
 		devconfig |=3D STPWLEVEL;
 	if (bootverbose)
-		printf("%s: STPWLEVEL is %s\n",
+		printk("%s: STPWLEVEL is %s\n",
 		       ahd_name(ahd), (devconfig & STPWLEVEL) ? "on" : "off");
 	ahd_pci_write_config(ahd->dev_softc, DEVCONFIG, devconfig, /*bytes*/4=
);
 =20
@@ -671,7 +671,7 @@ ahd_configure_termination(struct ahd_softc *ahd, u_=
int adapter_control)
 	error =3D ahd_read_flexport(ahd, FLXADDR_TERMCTL, &termctl);
 	if ((adapter_control & CFAUTOTERM) =3D=3D 0) {
 		if (bootverbose)
-			printf("%s: Manual Primary Termination\n",
+			printk("%s: Manual Primary Termination\n",
 			       ahd_name(ahd));
 		termctl &=3D ~(FLX_TERMCTL_ENPRILOW|FLX_TERMCTL_ENPRIHIGH);
 		if ((adapter_control & CFSTERM) !=3D 0)
@@ -679,14 +679,14 @@ ahd_configure_termination(struct ahd_softc *ahd, =
u_int adapter_control)
 		if ((adapter_control & CFWSTERM) !=3D 0)
 			termctl |=3D FLX_TERMCTL_ENPRIHIGH;
 	} else if (error !=3D 0) {
-		printf("%s: Primary Auto-Term Sensing failed! "
+		printk("%s: Primary Auto-Term Sensing failed! "
 		       "Using Defaults.\n", ahd_name(ahd));
 		termctl =3D FLX_TERMCTL_ENPRILOW|FLX_TERMCTL_ENPRIHIGH;
 	}
=20
 	if ((adapter_control & CFSEAUTOTERM) =3D=3D 0) {
 		if (bootverbose)
-			printf("%s: Manual Secondary Termination\n",
+			printk("%s: Manual Secondary Termination\n",
 			       ahd_name(ahd));
 		termctl &=3D ~(FLX_TERMCTL_ENSECLOW|FLX_TERMCTL_ENSECHIGH);
 		if ((adapter_control & CFSELOWTERM) !=3D 0)
@@ -694,7 +694,7 @@ ahd_configure_termination(struct ahd_softc *ahd, u_=
int adapter_control)
 		if ((adapter_control & CFSEHIGHTERM) !=3D 0)
 			termctl |=3D FLX_TERMCTL_ENSECHIGH;
 	} else if (error !=3D 0) {
-		printf("%s: Secondary Auto-Term Sensing failed! "
+		printk("%s: Secondary Auto-Term Sensing failed! "
 		       "Using Defaults.\n", ahd_name(ahd));
 		termctl |=3D FLX_TERMCTL_ENSECLOW|FLX_TERMCTL_ENSECHIGH;
 	}
@@ -714,22 +714,22 @@ ahd_configure_termination(struct ahd_softc *ahd, =
u_int adapter_control)
=20
 	error =3D ahd_write_flexport(ahd, FLXADDR_TERMCTL, termctl);
 	if (error !=3D 0) {
-		printf("%s: Unable to set termination settings!\n",
+		printk("%s: Unable to set termination settings!\n",
 		       ahd_name(ahd));
 	} else if (bootverbose) {
-		printf("%s: Primary High byte termination %sabled\n",
+		printk("%s: Primary High byte termination %sabled\n",
 		       ahd_name(ahd),
 		       (termctl & FLX_TERMCTL_ENPRIHIGH) ? "En" : "Dis");
=20
-		printf("%s: Primary Low byte termination %sabled\n",
+		printk("%s: Primary Low byte termination %sabled\n",
 		       ahd_name(ahd),
 		       (termctl & FLX_TERMCTL_ENPRILOW) ? "En" : "Dis");
=20
-		printf("%s: Secondary High byte termination %sabled\n",
+		printk("%s: Secondary High byte termination %sabled\n",
 		       ahd_name(ahd),
 		       (termctl & FLX_TERMCTL_ENSECHIGH) ? "En" : "Dis");
=20
-		printf("%s: Secondary Low byte termination %sabled\n",
+		printk("%s: Secondary Low byte termination %sabled\n",
 		       ahd_name(ahd),
 		       (termctl & FLX_TERMCTL_ENSECLOW) ? "En" : "Dis");
 	}
@@ -805,7 +805,7 @@ ahd_pci_intr(struct ahd_softc *ahd)
 	if ((intstat & PCIINT) =3D=3D 0)
 		return;
=20
-	printf("%s: PCI error Interrupt\n", ahd_name(ahd));
+	printk("%s: PCI error Interrupt\n", ahd_name(ahd));
 	saved_modes =3D ahd_save_modes(ahd);
 	ahd_dump_card_state(ahd);
 	ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
@@ -832,7 +832,7 @@ ahd_pci_intr(struct ahd_softc *ahd)
 				s =3D pci_status_strings[bit];
 				if (i =3D=3D 7/*TARG*/ && bit =3D=3D 3)
 					s =3D "%s: Signaled Target Abort\n";
-				printf(s, ahd_name(ahd), pci_status_source[i]);
+				printk(s, ahd_name(ahd), pci_status_source[i]);
 			}
 		}=09
 	}
@@ -862,7 +862,7 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int int=
stat)
 	 */
 	pcix_status =3D ahd_pci_read_config(ahd->dev_softc, PCIXR_STATUS,
 					  /*bytes*/2);
-	printf("%s: PCI Split Interrupt - PCI-X status =3D 0x%x\n",
+	printk("%s: PCI Split Interrupt - PCI-X status =3D 0x%x\n",
 	       ahd_name(ahd), pcix_status);
 	saved_modes =3D ahd_save_modes(ahd);
 	for (i =3D 0; i < 4; i++) {
@@ -891,7 +891,7 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int int=
stat)
 				static const char *s;
=20
 				s =3D split_status_strings[bit];
-				printf(s, ahd_name(ahd),
+				printk(s, ahd_name(ahd),
 				       split_status_source[i]);
 			}
=20
@@ -902,7 +902,7 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int int=
stat)
 				static const char *s;
=20
 				s =3D split_status_strings[bit];
-				printf(s, ahd_name(ahd), "SG");
+				printk(s, ahd_name(ahd), "SG");
 			}
 		}
 	}
@@ -950,7 +950,7 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 	pci =3D ahd->dev_softc;
 	rev =3D ahd_pci_read_config(pci, PCIR_REVID, /*bytes*/1);
 	if (rev < ID_AIC7902_PCI_REV_A4) {
-		printf("%s: Unable to attach to unsupported chip revision %d\n",
+		printk("%s: Unable to attach to unsupported chip revision %d\n",
 		       ahd_name(ahd), rev);
 		ahd_pci_write_config(pci, PCIR_COMMAND, 0, /*bytes*/2);
 		return (ENXIO);
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx=
/aic79xx_proc.c
index 014bed7..59c85d5 100644
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -272,33 +272,32 @@ ahd_proc_write_seeprom(struct ahd_softc *ahd, cha=
r *buffer, int length)
 	saved_modes =3D ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
 	if (length !=3D sizeof(struct seeprom_config)) {
-		printf("ahd_proc_write_seeprom: incorrect buffer size\n");
+		printk("ahd_proc_write_seeprom: incorrect buffer size\n");
 		goto done;
 	}
=20
 	have_seeprom =3D ahd_verify_cksum((struct seeprom_config*)buffer);
 	if (have_seeprom =3D=3D 0) {
-		printf("ahd_proc_write_seeprom: cksum verification failed\n");
+		printk("ahd_proc_write_seeprom: cksum verification failed\n");
 		goto done;
 	}
=20
 	have_seeprom =3D ahd_acquire_seeprom(ahd);
 	if (!have_seeprom) {
-		printf("ahd_proc_write_seeprom: No Serial EEPROM\n");
+		printk("ahd_proc_write_seeprom: No Serial EEPROM\n");
 		goto done;
 	} else {
 		u_int start_addr;
=20
 		if (ahd->seep_config =3D=3D NULL) {
-			ahd->seep_config =3D malloc(sizeof(*ahd->seep_config),
-						  M_DEVBUF, M_NOWAIT);
+			ahd->seep_config =3D kmalloc(sizeof(*ahd->seep_config), GFP_ATOMIC)=
;
 			if (ahd->seep_config =3D=3D NULL) {
-				printf("aic79xx: Unable to allocate serial "
+				printk("aic79xx: Unable to allocate serial "
 				       "eeprom buffer.  Write failing\n");
 				goto done;
 			}
 		}
-		printf("aic79xx: Writing Serial EEPROM\n");
+		printk("aic79xx: Writing Serial EEPROM\n");
 		start_addr =3D 32 * (ahd->channel - 'A');
 		ahd_write_seeprom(ahd, (u_int16_t *)buffer, start_addr,
 				  sizeof(struct seeprom_config)/2);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_93cx6.c b/drivers/scsi/aic7xx=
x/aic7xxx_93cx6.c
index dd11999..9e85a7e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
@@ -207,14 +207,14 @@ ahc_read_seeprom(struct seeprom_descriptor *sd, u=
int16_t *buf,
 		reset_seeprom(sd);
 	}
 #ifdef AHC_DUMP_EEPROM
-	printf("\nSerial EEPROM:\n\t");
+	printk("\nSerial EEPROM:\n\t");
 	for (k =3D 0; k < count; k =3D k + 1) {
 		if (((k % 8) =3D=3D 0) && (k !=3D 0)) {
-			printf ("\n\t");
+			printk(KERN_CONT "\n\t");
 		}
-		printf (" 0x%x", buf[k]);
+		printk(KERN_CONT " 0x%x", buf[k]);
 	}
-	printf ("\n");
+	printk(KERN_CONT "\n");
 #endif
 	return (1);
 }
@@ -240,7 +240,7 @@ ahc_write_seeprom(struct seeprom_descriptor *sd, ui=
nt16_t *buf,
 		ewen =3D &seeprom_long_ewen;
 		ewds =3D &seeprom_long_ewds;
 	} else {
-		printf("ahc_write_seeprom: unsupported seeprom type %d\n",
+		printk("ahc_write_seeprom: unsupported seeprom type %d\n",
 		       sd->sd_chip);
 		return (0);
 	}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx=
/aic7xxx_core.c
index 45aa728..3f5a542 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -910,7 +910,7 @@ ahc_run_qoutfifo(struct ahc_softc *ahc)
=20
 		scb =3D ahc_lookup_scb(ahc, scb_index);
 		if (scb =3D=3D NULL) {
-			printf("%s: WARNING no command for scb %d "
+			printk("%s: WARNING no command for scb %d "
 			       "(cmdcmplt)\nQOUTPOS =3D %d\n",
 			       ahc_name(ahc), scb_index,
 			       (ahc->qoutfifonext - 1) & 0xFF);
@@ -964,7 +964,7 @@ ahc_handle_brkadrint(struct ahc_softc *ahc)
 	error =3D ahc_inb(ahc, ERROR);
 	for (i =3D 0; error !=3D 1 && i < num_errors; i++)
 		error >>=3D 1;
-	printf("%s: brkadrint, %s at seqaddr =3D 0x%x\n",
+	printk("%s: brkadrint, %s at seqaddr =3D 0x%x\n",
 	       ahc_name(ahc), ahc_hard_errors[i].errmesg,
 	       ahc_inb(ahc, SEQADDR0) |
 	       (ahc_inb(ahc, SEQADDR1) << 8));
@@ -1021,7 +1021,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 		scb =3D ahc_lookup_scb(ahc, scb_index);
 		if (scb =3D=3D NULL) {
 			ahc_print_devinfo(ahc, &devinfo);
-			printf("ahc_intr - referenced scb "
+			printk("ahc_intr - referenced scb "
 			       "not valid during seqint 0x%x scb(%d)\n",
 			       intstat, scb_index);
 			ahc_dump_card_state(ahc);
@@ -1049,7 +1049,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 		ahc_set_scsi_status(scb, hscb->shared_data.status.scsi_status);
 		switch (hscb->shared_data.status.scsi_status) {
 		case SCSI_STATUS_OK:
-			printf("%s: Interrupted for staus of 0???\n",
+			printk("%s: Interrupted for staus of 0???\n",
 			       ahc_name(ahc));
 			break;
 		case SCSI_STATUS_CMD_TERMINATED:
@@ -1063,7 +1063,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				ahc_print_path(ahc, scb);
-				printf("SCB %d: requests Check Status\n",
+				printk("SCB %d: requests Check Status\n",
 				       scb->hscb->tag);
 			}
 #endif
@@ -1086,7 +1086,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				ahc_print_path(ahc, scb);
-				printf("Sending Sense\n");
+				printk("Sending Sense\n");
 			}
 #endif
 			sg->addr =3D ahc_get_sense_bufaddr(ahc, scb);
@@ -1162,29 +1162,29 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int =
intstat)
 		ahc_outb(ahc, SCSISEQ,
 			 ahc_inb(ahc, SCSISEQ) & (ENSELI|ENRSELI|ENAUTOATNP));
=20
-		printf("%s:%c:%d: no active SCB for reconnecting "
+		printk("%s:%c:%d: no active SCB for reconnecting "
 		       "target - issuing BUS DEVICE RESET\n",
 		       ahc_name(ahc), devinfo.channel, devinfo.target);
-		printf("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
+		printk("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
 		       "ARG_1 =3D=3D 0x%x ACCUM =3D 0x%x\n",
 		       ahc_inb(ahc, SAVED_SCSIID), ahc_inb(ahc, SAVED_LUN),
 		       ahc_inb(ahc, ARG_1), ahc_inb(ahc, ACCUM));
-		printf("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
+		printk("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
 		       "SINDEX =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SEQ_FLAGS), ahc_inb(ahc, SCBPTR),
 		       ahc_index_busy_tcl(ahc,
 			    BUILD_TCL(ahc_inb(ahc, SAVED_SCSIID),
 				      ahc_inb(ahc, SAVED_LUN))),
 		       ahc_inb(ahc, SINDEX));
-		printf("SCSIID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0=
x%x, "
+		printk("SCSIID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0=
x%x, "
 		       "SCB_TAG =3D=3D 0x%x, SCB_CONTROL =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SCSIID), ahc_inb(ahc, SCB_SCSIID),
 		       ahc_inb(ahc, SCB_LUN), ahc_inb(ahc, SCB_TAG),
 		       ahc_inb(ahc, SCB_CONTROL));
-		printf("SCSIBUSL =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
+		printk("SCSIBUSL =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SCSIBUSL), ahc_inb(ahc, SCSISIGI));
-		printf("SXFRCTL0 =3D=3D 0x%x\n", ahc_inb(ahc, SXFRCTL0));
-		printf("SEQCTL =3D=3D 0x%x\n", ahc_inb(ahc, SEQCTL));
+		printk("SXFRCTL0 =3D=3D 0x%x\n", ahc_inb(ahc, SXFRCTL0));
+		printk("SEQCTL =3D=3D 0x%x\n", ahc_inb(ahc, SEQCTL));
 		ahc_dump_card_state(ahc);
 		ahc->msgout_buf[0] =3D MSG_BUS_DEV_RESET;
 		ahc->msgout_len =3D 1;
@@ -1197,7 +1197,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 	case SEND_REJECT:=20
 	{
 		u_int rejbyte =3D ahc_inb(ahc, ACCUM);
-		printf("%s:%c:%d: Warning - unknown message received from "
+		printk("%s:%c:%d: Warning - unknown message received from "
 		       "target (0x%x).  Rejecting\n",=20
 		       ahc_name(ahc), devinfo.channel, devinfo.target, rejbyte);
 		break;=20
@@ -1218,7 +1218,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 		u_int lastphase;
=20
 		lastphase =3D ahc_inb(ahc, LASTPHASE);
-		printf("%s:%c:%d: unknown scsi bus phase %x, "
+		printk("%s:%c:%d: unknown scsi bus phase %x, "
 		       "lastphase =3D 0x%x.  Attempting to continue\n",
 		       ahc_name(ahc), devinfo.channel, devinfo.target,
 		       lastphase, ahc_inb(ahc, SCSISIGI));
@@ -1229,7 +1229,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 		u_int lastphase;
=20
 		lastphase =3D ahc_inb(ahc, LASTPHASE);
-		printf("%s:%c:%d: Missed busfree. "
+		printk("%s:%c:%d: Missed busfree. "
 		       "Lastphase =3D 0x%x, Curphase =3D 0x%x\n",
 		       ahc_name(ahc), devinfo.channel, devinfo.target,
 		       lastphase, ahc_inb(ahc, SCSISIGI));
@@ -1257,7 +1257,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 			bus_phase =3D ahc_inb(ahc, SCSISIGI) & PHASE_MASK;
 			if (bus_phase !=3D P_MESGIN
 			 && bus_phase !=3D P_MESGOUT) {
-				printf("ahc_intr: HOST_MSG_LOOP bad "
+				printk("ahc_intr: HOST_MSG_LOOP bad "
 				       "phase 0x%x\n",
 				      bus_phase);
 				/*
@@ -1359,7 +1359,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 					u_int	scb_index;
=20
 					ahc_print_devinfo(ahc, &devinfo);
-					printf("Unable to clear parity error.  "
+					printk("Unable to clear parity error.  "
 					       "Resetting bus.\n");
 					scb_index =3D ahc_inb(ahc, SCB_TAG);
 					scb =3D ahc_lookup_scb(ahc, scb_index);
@@ -1395,18 +1395,18 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int =
intstat)
 				break;
 		}
 		ahc_print_path(ahc, scb);
-		printf("data overrun detected %s."
+		printk("data overrun detected %s."
 		       "  Tag =3D=3D 0x%x.\n",
 		       ahc_phase_table[i].phasemsg,
   		       scb->hscb->tag);
 		ahc_print_path(ahc, scb);
-		printf("%s seen Data Phase.  Length =3D %ld.  NumSGs =3D %d.\n",
+		printk("%s seen Data Phase.  Length =3D %ld.  NumSGs =3D %d.\n",
 		       ahc_inb(ahc, SEQ_FLAGS) & DPHASE ? "Have" : "Haven't",
 		       ahc_get_transfer_length(scb), scb->sg_count);
 		if (scb->sg_count > 0) {
 			for (i =3D 0; i < scb->sg_count; i++) {
=20
-				printf("sg[%d] - Addr 0x%x%x : Length %d\n",
+				printk("sg[%d] - Addr 0x%x%x : Length %d\n",
 				       i,
 				       (ahc_le32toh(scb->sg_list[i].len) >> 24
 				        & SG_HIGH_ADDR_BITS),
@@ -1453,7 +1453,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 	{
 		u_int scbindex;
=20
-		printf("%s:%c:%d:%d: Attempt to issue message failed\n",
+		printk("%s:%c:%d:%d: Attempt to issue message failed\n",
 		       ahc_name(ahc), devinfo.channel, devinfo.target,
 		       devinfo.lun);
 		scbindex =3D ahc_inb(ahc, SCB_TAG);
@@ -1473,7 +1473,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 	}
 	case NO_FREE_SCB:
 	{
-		printf("%s: No free or disconnected SCBs\n", ahc_name(ahc));
+		printk("%s: No free or disconnected SCBs\n", ahc_name(ahc));
 		ahc_dump_card_state(ahc);
 		panic("for safety");
 		break;
@@ -1483,7 +1483,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int in=
tstat)
 		u_int scbptr;
=20
 		scbptr =3D ahc_inb(ahc, SCBPTR);
-		printf("Bogus TAG after DMA.  SCBPTR %d, tag %d, our tag %d\n",
+		printk("Bogus TAG after DMA.  SCBPTR %d, tag %d, our tag %d\n",
 		       scbptr, ahc_inb(ahc, ARG_1),
 		       ahc->scb_data->hscbs[scbptr].tag);
 		ahc_dump_card_state(ahc);
@@ -1492,12 +1492,12 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int =
intstat)
 	}
 	case OUT_OF_RANGE:
 	{
-		printf("%s: BTT calculation out of range\n", ahc_name(ahc));
-		printf("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
+		printk("%s: BTT calculation out of range\n", ahc_name(ahc));
+		printk("SAVED_SCSIID =3D=3D 0x%x, SAVED_LUN =3D=3D 0x%x, "
 		       "ARG_1 =3D=3D 0x%x ACCUM =3D 0x%x\n",
 		       ahc_inb(ahc, SAVED_SCSIID), ahc_inb(ahc, SAVED_LUN),
 		       ahc_inb(ahc, ARG_1), ahc_inb(ahc, ACCUM));
-		printf("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
+		printk("SEQ_FLAGS =3D=3D 0x%x, SCBPTR =3D=3D 0x%x, BTT =3D=3D 0x%x, =
"
 		       "SINDEX =3D=3D 0x%x\n, A =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SEQ_FLAGS), ahc_inb(ahc, SCBPTR),
 		       ahc_index_busy_tcl(ahc,
@@ -1505,19 +1505,19 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int =
intstat)
 				      ahc_inb(ahc, SAVED_LUN))),
 		       ahc_inb(ahc, SINDEX),
 		       ahc_inb(ahc, ACCUM));
-		printf("SCSIID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0=
x%x, "
+		printk("SCSIID =3D=3D 0x%x, SCB_SCSIID =3D=3D 0x%x, SCB_LUN =3D=3D 0=
x%x, "
 		       "SCB_TAG =3D=3D 0x%x, SCB_CONTROL =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SCSIID), ahc_inb(ahc, SCB_SCSIID),
 		       ahc_inb(ahc, SCB_LUN), ahc_inb(ahc, SCB_TAG),
 		       ahc_inb(ahc, SCB_CONTROL));
-		printf("SCSIBUSL =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
+		printk("SCSIBUSL =3D=3D 0x%x, SCSISIGI =3D=3D 0x%x\n",
 		       ahc_inb(ahc, SCSIBUSL), ahc_inb(ahc, SCSISIGI));
 		ahc_dump_card_state(ahc);
 		panic("for safety");
 		break;
 	}
 	default:
-		printf("ahc_intr: seqint, "
+		printk("ahc_intr: seqint, "
 		       "intstat =3D=3D 0x%x, scsisigi =3D 0x%x\n",
 		       intstat, ahc_inb(ahc, SCSISIGI));
 		break;
@@ -1562,7 +1562,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 			intr_channel =3D (cur_channel =3D=3D 'A') ? 'B' : 'A';
 		}
 		if (status =3D=3D 0) {
-			printf("%s: Spurious SCSI interrupt\n", ahc_name(ahc));
+			printk("%s: Spurious SCSI interrupt\n", ahc_name(ahc));
 			ahc_outb(ahc, CLRINT, CLRSCSIINT);
 			ahc_unpause(ahc);
 			return;
@@ -1583,7 +1583,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 		int now_lvd;
=20
 		now_lvd =3D ahc_inb(ahc, SBLKCTL) & ENAB40;
-		printf("%s: Transceiver State Has Changed to %s mode\n",
+		printk("%s: Transceiver State Has Changed to %s mode\n",
 		       ahc_name(ahc), now_lvd ? "LVD" : "SE");
 		ahc_outb(ahc, CLRSINT0, CLRIOERR);
 		/*
@@ -1599,7 +1599,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 		ahc_reset_channel(ahc, intr_channel,
 				 /*Initiate Reset*/now_lvd =3D=3D 0);
 	} else if ((status & SCSIRSTI) !=3D 0) {
-		printf("%s: Someone reset channel %c\n",
+		printk("%s: Someone reset channel %c\n",
 			ahc_name(ahc), intr_channel);
 		if (intr_channel !=3D cur_channel)
 		 	ahc_outb(ahc, SBLKCTL, ahc_inb(ahc, SBLKCTL) ^ SELBUSB);
@@ -1659,26 +1659,26 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int=
 intstat)
 				ahc_print_path(ahc, scb);
 			scb->flags |=3D SCB_TRANSMISSION_ERROR;
 		} else
-			printf("%s:%c:%d: ", ahc_name(ahc), intr_channel,
+			printk("%s:%c:%d: ", ahc_name(ahc), intr_channel,
 			       SCSIID_TARGET(ahc, ahc_inb(ahc, SAVED_SCSIID)));
 		scsirate =3D ahc_inb(ahc, SCSIRATE);
 		if (silent =3D=3D FALSE) {
-			printf("parity error detected %s. "
+			printk("parity error detected %s. "
 			       "SEQADDR(0x%x) SCSIRATE(0x%x)\n",
 			       ahc_phase_table[i].phasemsg,
 			       ahc_inw(ahc, SEQADDR0),
 			       scsirate);
 			if ((ahc->features & AHC_DT) !=3D 0) {
 				if ((sstat2 & CRCVALERR) !=3D 0)
-					printf("\tCRC Value Mismatch\n");
+					printk("\tCRC Value Mismatch\n");
 				if ((sstat2 & CRCENDERR) !=3D 0)
-					printf("\tNo terminal CRC packet "
+					printk("\tNo terminal CRC packet "
 					       "recevied\n");
 				if ((sstat2 & CRCREQERR) !=3D 0)
-					printf("\tIllegal CRC packet "
+					printk("\tIllegal CRC packet "
 					       "request\n");
 				if ((sstat2 & DUAL_EDGE_ERR) !=3D 0)
-					printf("\tUnexpected %sDT Data Phase\n",
+					printk("\tUnexpected %sDT Data Phase\n",
 					       (scsirate & SINGLE_EDGE)
 					     ? "" : "non-");
 			}
@@ -1746,7 +1746,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
=20
 		scb =3D ahc_lookup_scb(ahc, scb_index);
 		if (scb =3D=3D NULL) {
-			printf("%s: ahc_intr - referenced scb not "
+			printk("%s: ahc_intr - referenced scb not "
 			       "valid during SELTO scb(%d, %d)\n",
 			       ahc_name(ahc), scbptr, scb_index);
 			ahc_dump_card_state(ahc);
@@ -1755,7 +1755,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_SELTO) !=3D 0) {
 				ahc_print_path(ahc, scb);
-				printf("Saw Selection Timeout for SCB 0x%x\n",
+				printk("Saw Selection Timeout for SCB 0x%x\n",
 				       scb_index);
 			}
 #endif
@@ -1831,7 +1831,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 				 =3D=3D MSG_ABORT_TAG)
 					tag =3D scb->hscb->tag;
 				ahc_print_path(ahc, scb);
-				printf("SCB %d - Abort%s Completed.\n",
+				printk("SCB %d - Abort%s Completed.\n",
 				       scb->hscb->tag, tag =3D=3D SCB_LIST_NULL ?
 				       "" : " Tag");
 				ahc_abort_scbs(ahc, target, channel,
@@ -1934,7 +1934,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 				 * We had not fully identified this connection,
 				 * so we cannot abort anything.
 				 */
-				printf("%s: ", ahc_name(ahc));
+				printk("%s: ", ahc_name(ahc));
 			}
 			for (i =3D 0; i < num_phases; i++) {
 				if (lastphase =3D=3D ahc_phase_table[i].phase)
@@ -1949,7 +1949,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 				 */
 				ahc_force_renegotiation(ahc, &devinfo);
 			}
-			printf("Unexpected busfree %s\n"
+			printk("Unexpected busfree %s\n"
 			       "SEQADDR =3D=3D 0x%x\n",
 			       ahc_phase_table[i].phasemsg,
 			       ahc_inb(ahc, SEQADDR0)
@@ -1958,7 +1958,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int i=
ntstat)
 		ahc_outb(ahc, CLRINT, CLRSCSIINT);
 		ahc_restart(ahc);
 	} else {
-		printf("%s: Missing case in ahc_handle_scsiint. status =3D %x\n",
+		printk("%s: Missing case in ahc_handle_scsiint. status =3D %x\n",
 		       ahc_name(ahc), status);
 		ahc_outb(ahc, CLRINT, CLRSCSIINT);
 	}
@@ -2025,7 +2025,7 @@ ahc_clear_critical_section(struct ahc_softc *ahc)
 			break;
=20
 		if (steps > AHC_MAX_STEPS) {
-			printf("%s: Infinite loop in critical section\n",
+			printk("%s: Infinite loop in critical section\n",
 			       ahc_name(ahc));
 			ahc_dump_card_state(ahc);
 			panic("critical section loop");
@@ -2104,23 +2104,23 @@ ahc_print_scb(struct scb *scb)
=20
 	struct hardware_scb *hscb =3D scb->hscb;
=20
-	printf("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
+	printk("scb:%p control:0x%x scsiid:0x%x lun:%d cdb_len:%d\n",
 	       (void *)scb,
 	       hscb->control,
 	       hscb->scsiid,
 	       hscb->lun,
 	       hscb->cdb_len);
-	printf("Shared Data: ");
+	printk("Shared Data: ");
 	for (i =3D 0; i < sizeof(hscb->shared_data.cdb); i++)
-		printf("%#02x", hscb->shared_data.cdb[i]);
-	printf("        dataptr:%#x datacnt:%#x sgptr:%#x tag:%#x\n",
+		printk("%#02x", hscb->shared_data.cdb[i]);
+	printk("        dataptr:%#x datacnt:%#x sgptr:%#x tag:%#x\n",
 		ahc_le32toh(hscb->dataptr),
 		ahc_le32toh(hscb->datacnt),
 		ahc_le32toh(hscb->sgptr),
 		hscb->tag);
 	if (scb->sg_count > 0) {
 		for (i =3D 0; i < scb->sg_count; i++) {
-			printf("sg[%d] - Addr 0x%x%x : Length %d\n",
+			printk("sg[%d] - Addr 0x%x%x : Length %d\n",
 			       i,
 			       (ahc_le32toh(scb->sg_list[i].len) >> 24
 			        & SG_HIGH_ADDR_BITS),
@@ -2152,8 +2152,7 @@ ahc_alloc_tstate(struct ahc_softc *ahc, u_int scs=
i_id, char channel)
 	 && ahc->enabled_targets[scsi_id] !=3D master_tstate)
 		panic("%s: ahc_alloc_tstate - Target already allocated",
 		      ahc_name(ahc));
-	tstate =3D (struct ahc_tmode_tstate*)malloc(sizeof(*tstate),
-						   M_DEVBUF, M_NOWAIT);
+	tstate =3D kmalloc(sizeof(*tstate), GFP_ATOMIC);
 	if (tstate =3D=3D NULL)
 		return (NULL);
=20
@@ -2202,7 +2201,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi=
_id, char channel, int force)
 		scsi_id +=3D 8;
 	tstate =3D ahc->enabled_targets[scsi_id];
 	if (tstate !=3D NULL)
-		free(tstate, M_DEVBUF);
+		kfree(tstate);
 	ahc->enabled_targets[scsi_id] =3D NULL;
 }
 #endif
@@ -2589,13 +2588,13 @@ ahc_set_syncrate(struct ahc_softc *ahc, struct =
ahc_devinfo *devinfo,
 			       CAM_LUN_WILDCARD, AC_TRANSFER_NEG);
 		if (bootverbose) {
 			if (offset !=3D 0) {
-				printf("%s: target %d synchronous at %sMHz%s, "
+				printk("%s: target %d synchronous at %sMHz%s, "
 				       "offset =3D 0x%x\n", ahc_name(ahc),
 				       devinfo->target, syncrate->rate,
 				       (ppr_options & MSG_EXT_PPR_DT_REQ)
 				       ? " DT" : "", offset);
 			} else {
-				printf("%s: target %d using "
+				printk("%s: target %d using "
 				       "asynchronous transfers\n",
 				       ahc_name(ahc), devinfo->target);
 			}
@@ -2658,7 +2657,7 @@ ahc_set_width(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo,
 		ahc_send_async(ahc, devinfo->channel, devinfo->target,
 			       CAM_LUN_WILDCARD, AC_TRANSFER_NEG);
 		if (bootverbose) {
-			printf("%s: target %d using %dbit transfers\n",
+			printk("%s: target %d using %dbit transfers\n",
 			       ahc_name(ahc), devinfo->target,
 			       8 * (0x01 << width));
 		}
@@ -2835,7 +2834,7 @@ ahc_compile_devinfo(struct ahc_devinfo *devinfo, =
u_int our_id, u_int target,
 void
 ahc_print_devinfo(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
 {
-	printf("%s:%c:%d:%d: ", ahc_name(ahc), devinfo->channel,
+	printk("%s:%c:%d:%d: ", ahc_name(ahc), devinfo->channel,
 	       devinfo->target, devinfo->lun);
 }
=20
@@ -2907,7 +2906,7 @@ ahc_setup_initiator_msgout(struct ahc_softc *ahc,=
 struct ahc_devinfo *devinfo,
 		ahc->msgout_buf[ahc->msgout_index++] =3D MSG_BUS_DEV_RESET;
 		ahc->msgout_len++;
 		ahc_print_path(ahc, scb);
-		printf("Bus Device Reset Message Sent\n");
+		printk("Bus Device Reset Message Sent\n");
 		/*
 		 * Clear our selection hardware in advance of
 		 * the busfree.  We may have an entry in the waiting
@@ -2923,7 +2922,7 @@ ahc_setup_initiator_msgout(struct ahc_softc *ahc,=
 struct ahc_devinfo *devinfo,
 			ahc->msgout_buf[ahc->msgout_index++] =3D MSG_ABORT;
 		ahc->msgout_len++;
 		ahc_print_path(ahc, scb);
-		printf("Abort%s Message Sent\n",
+		printk("Abort%s Message Sent\n",
 		       (scb->hscb->control & TAG_ENB) !=3D 0 ? " Tag" : "");
 		/*
 		 * Clear our selection hardware in advance of
@@ -2936,9 +2935,9 @@ ahc_setup_initiator_msgout(struct ahc_softc *ahc,=
 struct ahc_devinfo *devinfo,
 	} else if ((scb->flags & (SCB_AUTO_NEGOTIATE|SCB_NEGOTIATE)) !=3D 0) =
{
 		ahc_build_transfer_msg(ahc, devinfo);
 	} else {
-		printf("ahc_intr: AWAITING_MSG for an SCB that "
+		printk("ahc_intr: AWAITING_MSG for an SCB that "
 		       "does not have a waiting message\n");
-		printf("SCSIID =3D %x, target_mask =3D %x\n", scb->hscb->scsiid,
+		printk("SCSIID =3D %x, target_mask =3D %x\n", scb->hscb->scsiid,
 		       devinfo->target_mask);
 		panic("SCB =3D %d, SCB Control =3D %x, MSG_OUT =3D %x "
 		      "SCB flags =3D %x", scb->hscb->tag, scb->hscb->control,
@@ -3019,7 +3018,7 @@ ahc_build_transfer_msg(struct ahc_softc *ahc, str=
uct ahc_devinfo *devinfo)
=20
 		if (bootverbose) {
 			ahc_print_devinfo(ahc, devinfo);
-			printf("Ensuring async\n");
+			printk("Ensuring async\n");
 		}
 	}
=20
@@ -3067,7 +3066,7 @@ ahc_construct_sdtr(struct ahc_softc *ahc, struct =
ahc_devinfo *devinfo,
 			ahc->msgout_buf + ahc->msgout_index, period, offset);
 	ahc->msgout_len +=3D 5;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
+		printk("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
 		       ahc_name(ahc), devinfo->channel, devinfo->target,
 		       devinfo->lun, period, offset);
 	}
@@ -3085,7 +3084,7 @@ ahc_construct_wdtr(struct ahc_softc *ahc, struct =
ahc_devinfo *devinfo,
 			ahc->msgout_buf + ahc->msgout_index, bus_width);
 	ahc->msgout_len +=3D 4;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending WDTR %x\n",
+		printk("(%s:%c:%d:%d): Sending WDTR %x\n",
 		       ahc_name(ahc), devinfo->channel, devinfo->target,
 		       devinfo->lun, bus_width);
 	}
@@ -3107,7 +3106,7 @@ ahc_construct_ppr(struct ahc_softc *ahc, struct a=
hc_devinfo *devinfo,
 			bus_width, ppr_options);
 	ahc->msgout_len +=3D 8;
 	if (bootverbose) {
-		printf("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
+		printk("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
 		       "offset %x, ppr_options %x\n", ahc_name(ahc),
 		       devinfo->channel, devinfo->target, devinfo->lun,
 		       bus_width, period, offset, ppr_options);
@@ -3160,7 +3159,7 @@ ahc_handle_proto_violation(struct ahc_softc *ahc)
 		 * to match.
 		 */
 		ahc_print_devinfo(ahc, &devinfo);
-		printf("Target did not send an IDENTIFY message. "
+		printk("Target did not send an IDENTIFY message. "
 		       "LASTPHASE =3D 0x%x.\n", lastphase);
 		scb =3D NULL;
 	} else if (scb =3D=3D NULL) {
@@ -3169,13 +3168,13 @@ ahc_handle_proto_violation(struct ahc_softc *ah=
c)
 		 * transaction.  Print an error and reset the bus.
 		 */
 		ahc_print_devinfo(ahc, &devinfo);
-		printf("No SCB found during protocol violation\n");
+		printk("No SCB found during protocol violation\n");
 		goto proto_violation_reset;
 	} else {
 		ahc_set_transaction_status(scb, CAM_SEQUENCE_FAIL);
 		if ((seq_flags & NO_CDB_SENT) !=3D 0) {
 			ahc_print_path(ahc, scb);
-			printf("No or incomplete CDB sent to device.\n");
+			printk("No or incomplete CDB sent to device.\n");
 		} else if ((ahc_inb(ahc, SCB_CONTROL) & STATUS_RCVD) =3D=3D 0) {
 			/*
 			 * The target never bothered to provide status to
@@ -3185,10 +3184,10 @@ ahc_handle_proto_violation(struct ahc_softc *ah=
c)
 			 * message.
 			 */
 			ahc_print_path(ahc, scb);
-			printf("Completed command without status.\n");
+			printk("Completed command without status.\n");
 		} else {
 			ahc_print_path(ahc, scb);
-			printf("Unknown protocol violation.\n");
+			printk("Unknown protocol violation.\n");
 			ahc_dump_card_state(ahc);
 		}
 	}
@@ -3202,7 +3201,7 @@ proto_violation_reset:
 		 * it away with a bus reset.
 		 */
 		found =3D ahc_reset_channel(ahc, 'A', TRUE);
-		printf("%s: Issued Channel %c Bus Reset. "
+		printk("%s: Issued Channel %c Bus Reset. "
 		       "%d SCBs aborted\n", ahc_name(ahc), 'A', found);
 	} else {
 		/*
@@ -3224,7 +3223,7 @@ proto_violation_reset:
 			ahc_print_path(ahc, scb);
 			scb->flags |=3D SCB_ABORT;
 		}
-		printf("Protocol violation %s.  Attempting to abort.\n",
+		printk("Protocol violation %s.  Attempting to abort.\n",
 		       ahc_lookup_phase_entry(curphase)->phasemsg);
 	}
 }
@@ -3257,14 +3256,14 @@ reswitch:
 #ifdef AHC_DEBUG
 		if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0) {
 			ahc_print_devinfo(ahc, &devinfo);
-			printf("INITIATOR_MSG_OUT");
+			printk("INITIATOR_MSG_OUT");
 		}
 #endif
 		phasemis =3D bus_phase !=3D P_MESGOUT;
 		if (phasemis) {
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0) {
-				printf(" PHASEMIS %s\n",
+				printk(" PHASEMIS %s\n",
 				       ahc_lookup_phase_entry(bus_phase)
 							     ->phasemsg);
 			}
@@ -3291,7 +3290,7 @@ reswitch:
 			ahc_outb(ahc, CLRSINT1, CLRREQINIT);
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0)
-				printf(" byte 0x%x\n", ahc->send_msg_perror);
+				printk(" byte 0x%x\n", ahc->send_msg_perror);
 #endif
 			ahc_outb(ahc, SCSIDATL, MSG_PARITY_ERROR);
 			break;
@@ -3321,7 +3320,7 @@ reswitch:
 		ahc_outb(ahc, CLRSINT1, CLRREQINIT);
 #ifdef AHC_DEBUG
 		if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0)
-			printf(" byte 0x%x\n",
+			printk(" byte 0x%x\n",
 			       ahc->msgout_buf[ahc->msgout_index]);
 #endif
 		ahc_outb(ahc, SCSIDATL, ahc->msgout_buf[ahc->msgout_index++]);
@@ -3335,14 +3334,14 @@ reswitch:
 #ifdef AHC_DEBUG
 		if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0) {
 			ahc_print_devinfo(ahc, &devinfo);
-			printf("INITIATOR_MSG_IN");
+			printk("INITIATOR_MSG_IN");
 		}
 #endif
 		phasemis =3D bus_phase !=3D P_MESGIN;
 		if (phasemis) {
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0) {
-				printf(" PHASEMIS %s\n",
+				printk(" PHASEMIS %s\n",
 				       ahc_lookup_phase_entry(bus_phase)
 							     ->phasemsg);
 			}
@@ -3363,7 +3362,7 @@ reswitch:
 		ahc->msgin_buf[ahc->msgin_index] =3D ahc_inb(ahc, SCSIBUSL);
 #ifdef AHC_DEBUG
 		if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0)
-			printf(" byte 0x%x\n",
+			printk(" byte 0x%x\n",
 			       ahc->msgin_buf[ahc->msgin_index]);
 #endif
=20
@@ -3385,7 +3384,7 @@ reswitch:
 #ifdef AHC_DEBUG
 				if ((ahc_debug & AHC_SHOW_MESSAGES) !=3D 0) {
 					ahc_print_devinfo(ahc, &devinfo);
-					printf("Asserting ATN for response\n");
+					printk("Asserting ATN for response\n");
 				}
 #endif
 				ahc_assert_atn(ahc);
@@ -3666,7 +3665,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 					    targ_scsirate & WIDEXFER,
 					    devinfo->role);
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received "
+				printk("(%s:%c:%d:%d): Received "
 				       "SDTR period %x, offset %x\n\t"
 				       "Filtered to period %x, offset %x\n",
 				       ahc_name(ahc), devinfo->channel,
@@ -3697,7 +3696,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 				 */
 				if (bootverbose
 				 && devinfo->role =3D=3D ROLE_INITIATOR) {
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated SDTR\n",
 					       ahc_name(ahc), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -3739,7 +3738,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 			ahc_validate_width(ahc, tinfo, &bus_width,
 					   devinfo->role);
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received WDTR "
+				printk("(%s:%c:%d:%d): Received WDTR "
 				       "%x filtered to %x\n",
 				       ahc_name(ahc), devinfo->channel,
 				       devinfo->target, devinfo->lun,
@@ -3755,7 +3754,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 				 */
 				if (saved_width > bus_width) {
 					reject =3D TRUE;
-					printf("(%s:%c:%d:%d): requested %dBit "
+					printk("(%s:%c:%d:%d): requested %dBit "
 					       "transfers.  Rejecting...\n",
 					       ahc_name(ahc), devinfo->channel,
 					       devinfo->target, devinfo->lun,
@@ -3768,7 +3767,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 				 */
 				if (bootverbose
 				 && devinfo->role =3D=3D ROLE_INITIATOR) {
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated WDTR\n",
 					       ahc_name(ahc), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -3886,12 +3885,12 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc=
_devinfo *devinfo)
 				}
 			} else {
 				if (devinfo->role !=3D ROLE_TARGET)
-					printf("(%s:%c:%d:%d): Target "
+					printk("(%s:%c:%d:%d): Target "
 					       "Initiated PPR\n",
 					       ahc_name(ahc), devinfo->channel,
 					       devinfo->target, devinfo->lun);
 				else
-					printf("(%s:%c:%d:%d): Initiator "
+					printk("(%s:%c:%d:%d): Initiator "
 					       "Initiated PPR\n",
 					       ahc_name(ahc), devinfo->channel,
 					       devinfo->target, devinfo->lun);
@@ -3903,7 +3902,7 @@ ahc_parse_msg(struct ahc_softc *ahc, struct ahc_d=
evinfo *devinfo)
 				response =3D TRUE;
 			}
 			if (bootverbose) {
-				printf("(%s:%c:%d:%d): Received PPR width %x, "
+				printk("(%s:%c:%d:%d): Received PPR width %x, "
 				       "period %x, offset %x,options %x\n"
 				       "\tFiltered to width %x, period %x, "
 				       "offset %x, options %x\n",
@@ -4033,7 +4032,7 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, stru=
ct ahc_devinfo *devinfo)
 		 * Attempt to negotiate SPI-2 style.
 		 */
 		if (bootverbose) {
-			printf("(%s:%c:%d:%d): PPR Rejected. "
+			printk("(%s:%c:%d:%d): PPR Rejected. "
 			       "Trying WDTR/SDTR\n",
 			       ahc_name(ahc), devinfo->channel,
 			       devinfo->target, devinfo->lun);
@@ -4049,7 +4048,7 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, stru=
ct ahc_devinfo *devinfo)
 	} else if (ahc_sent_msg(ahc, AHCMSG_EXT, MSG_EXT_WDTR, /*full*/FALSE)=
) {
=20
 		/* note 8bit xfers */
-		printf("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
+		printk("(%s:%c:%d:%d): refuses WIDE negotiation.  Using "
 		       "8bit transfers\n", ahc_name(ahc),
 		       devinfo->channel, devinfo->target, devinfo->lun);
 		ahc_set_width(ahc, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
@@ -4077,7 +4076,7 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, stru=
ct ahc_devinfo *devinfo)
 				 /*offset*/0, /*ppr_options*/0,
 				 AHC_TRANS_ACTIVE|AHC_TRANS_GOAL,
 				 /*paused*/TRUE);
-		printf("(%s:%c:%d:%d): refuses synchronous negotiation. "
+		printk("(%s:%c:%d:%d): refuses synchronous negotiation. "
 		       "Using asynchronous transfers\n",
 		       ahc_name(ahc), devinfo->channel,
 		       devinfo->target, devinfo->lun);
@@ -4088,13 +4087,13 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, st=
ruct ahc_devinfo *devinfo)
 		tag_type =3D (scb->hscb->control & MSG_SIMPLE_TASK);
=20
 		if (tag_type =3D=3D MSG_SIMPLE_TASK) {
-			printf("(%s:%c:%d:%d): refuses tagged commands.  "
+			printk("(%s:%c:%d:%d): refuses tagged commands.  "
 			       "Performing non-tagged I/O\n", ahc_name(ahc),
 			       devinfo->channel, devinfo->target, devinfo->lun);
 			ahc_set_tags(ahc, scb->io_ctx, devinfo, AHC_QUEUE_NONE);
 			mask =3D ~0x23;
 		} else {
-			printf("(%s:%c:%d:%d): refuses %s tagged commands.  "
+			printk("(%s:%c:%d:%d): refuses %s tagged commands.  "
 			       "Performing simple queue tagged I/O only\n",
 			       ahc_name(ahc), devinfo->channel, devinfo->target,
 			       devinfo->lun, tag_type =3D=3D MSG_ORDERED_TASK
@@ -4144,7 +4143,7 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, stru=
ct ahc_devinfo *devinfo)
 		/*
 		 * Otherwise, we ignore it.
 		 */
-		printf("%s:%c:%d: Message reject for %x -- ignored\n",
+		printk("%s:%c:%d: Message reject for %x -- ignored\n",
 		       ahc_name(ahc), devinfo->channel, devinfo->target,
 		       last_msg);
 	}
@@ -4369,7 +4368,7 @@ ahc_handle_devreset(struct ahc_softc *ahc, struct=
 ahc_devinfo *devinfo,
=20
 	if (message !=3D NULL
 	 && (verbose_level <=3D bootverbose))
-		printf("%s: %s on %c:%d. %d SCBs aborted\n", ahc_name(ahc),
+		printk("%s: %s on %c:%d. %d SCBs aborted\n", ahc_name(ahc),
 		       message, devinfo->channel, devinfo->target, found);
 }
=20
@@ -4408,23 +4407,22 @@ ahc_alloc(void *platform_arg, char *name)
 	int	i;
=20
 #ifndef	__FreeBSD__
-	ahc =3D malloc(sizeof(*ahc), M_DEVBUF, M_NOWAIT);
+	ahc =3D kmalloc(sizeof(*ahc), GFP_ATOMIC);
 	if (!ahc) {
-		printf("aic7xxx: cannot malloc softc!\n");
-		free(name, M_DEVBUF);
+		printk("aic7xxx: cannot malloc softc!\n");
+		kfree(name);
 		return NULL;
 	}
 #else
 	ahc =3D device_get_softc((device_t)platform_arg);
 #endif
 	memset(ahc, 0, sizeof(*ahc));
-	ahc->seep_config =3D malloc(sizeof(*ahc->seep_config),
-				  M_DEVBUF, M_NOWAIT);
+	ahc->seep_config =3D kmalloc(sizeof(*ahc->seep_config), GFP_ATOMIC);
 	if (ahc->seep_config =3D=3D NULL) {
 #ifndef	__FreeBSD__
-		free(ahc, M_DEVBUF);
+		kfree(ahc);
 #endif
-		free(name, M_DEVBUF);
+		kfree(name);
 		return (NULL);
 	}
 	LIST_INIT(&ahc->pending_scbs);
@@ -4466,8 +4464,7 @@ ahc_softc_init(struct ahc_softc *ahc)
 	ahc->pause =3D ahc->unpause | PAUSE;=20
 	/* XXX The shared scb data stuff should be deprecated */
 	if (ahc->scb_data =3D=3D NULL) {
-		ahc->scb_data =3D malloc(sizeof(*ahc->scb_data),
-				       M_DEVBUF, M_NOWAIT);
+		ahc->scb_data =3D kmalloc(sizeof(*ahc->scb_data), GFP_ATOMIC);
 		if (ahc->scb_data =3D=3D NULL)
 			return (ENOMEM);
 		memset(ahc->scb_data, 0, sizeof(*ahc->scb_data));
@@ -4486,7 +4483,7 @@ void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
 	if (ahc->name !=3D NULL)
-		free(ahc->name, M_DEVBUF);
+		kfree(ahc->name);
 	ahc->name =3D name;
 }
=20
@@ -4540,25 +4537,25 @@ ahc_free(struct ahc_softc *ahc)
 				lstate =3D tstate->enabled_luns[j];
 				if (lstate !=3D NULL) {
 					xpt_free_path(lstate->path);
-					free(lstate, M_DEVBUF);
+					kfree(lstate);
 				}
 			}
 #endif
-			free(tstate, M_DEVBUF);
+			kfree(tstate);
 		}
 	}
 #ifdef AHC_TARGET_MODE
 	if (ahc->black_hole !=3D NULL) {
 		xpt_free_path(ahc->black_hole->path);
-		free(ahc->black_hole, M_DEVBUF);
+		kfree(ahc->black_hole);
 	}
 #endif
 	if (ahc->name !=3D NULL)
-		free(ahc->name, M_DEVBUF);
+		kfree(ahc->name);
 	if (ahc->seep_config !=3D NULL)
-		free(ahc->seep_config, M_DEVBUF);
+		kfree(ahc->seep_config);
 #ifndef __FreeBSD__
-	free(ahc, M_DEVBUF);
+	kfree(ahc);
 #endif
 	return;
 }
@@ -4633,7 +4630,7 @@ ahc_reset(struct ahc_softc *ahc, int reinit)
 	} while (--wait && !(ahc_inb(ahc, HCNTRL) & CHIPRSTACK));
=20
 	if (wait =3D=3D 0) {
-		printf("%s: WARNING - Failed chip reset!  "
+		printk("%s: WARNING - Failed chip reset!  "
 		       "Trying to initialize anyway.\n", ahc_name(ahc));
 	}
 	ahc_outb(ahc, HCNTRL, ahc->pause);
@@ -4656,7 +4653,7 @@ ahc_reset(struct ahc_softc *ahc, int reinit)
 		ahc->features |=3D AHC_TWIN;
 		break;
 	default:
-		printf(" Unsupported adapter type.  Ignoring\n");
+		printk(" Unsupported adapter type.  Ignoring\n");
 		return(-1);
 	}
=20
@@ -4783,9 +4780,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
 	SLIST_INIT(&scb_data->sg_maps);
=20
 	/* Allocate SCB resources */
-	scb_data->scbarray =3D
-	    (struct scb *)malloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
-				 M_DEVBUF, M_NOWAIT);
+	scb_data->scbarray =3D (struct scb *)kmalloc(sizeof(struct scb) * AHC=
_SCB_MAX_ALLOC, GFP_ATOMIC);
 	if (scb_data->scbarray =3D=3D NULL)
 		return (ENOMEM);
 	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC)=
;
@@ -4794,7 +4789,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
=20
 	scb_data->maxhscbs =3D ahc_probe_scbs(ahc);
 	if (ahc->scb_data->maxhscbs =3D=3D 0) {
-		printf("%s: No SCB space found\n", ahc_name(ahc));
+		printk("%s: No SCB space found\n", ahc_name(ahc));
 		return (ENXIO);
 	}
=20
@@ -4892,7 +4887,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
 	ahc_alloc_scbs(ahc);
=20
 	if (scb_data->numscbs =3D=3D 0) {
-		printf("%s: ahc_init_scbdata - "
+		printk("%s: ahc_init_scbdata - "
 		       "Unable to allocate initial scbs\n",
 		       ahc_name(ahc));
 		goto error_exit;
@@ -4935,7 +4930,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 			ahc_dmamem_free(ahc, scb_data->sg_dmat,
 					sg_map->sg_vaddr,
 					sg_map->sg_dmamap);
-			free(sg_map, M_DEVBUF);
+			kfree(sg_map);
 		}
 		ahc_dma_tag_destroy(ahc, scb_data->sg_dmat);
 	}
@@ -4964,7 +4959,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 		break;
 	}
 	if (scb_data->scbarray !=3D NULL)
-		free(scb_data->scbarray, M_DEVBUF);
+		kfree(scb_data->scbarray);
 }
=20
 static void
@@ -4985,7 +4980,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
=20
 	next_scb =3D &scb_data->scbarray[scb_data->numscbs];
=20
-	sg_map =3D malloc(sizeof(*sg_map), M_DEVBUF, M_NOWAIT);
+	sg_map =3D kmalloc(sizeof(*sg_map), GFP_ATOMIC);
=20
 	if (sg_map =3D=3D NULL)
 		return;
@@ -4994,7 +4989,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 	if (ahc_dmamem_alloc(ahc, scb_data->sg_dmat,
 			     (void **)&sg_map->sg_vaddr,
 			     BUS_DMA_NOWAIT, &sg_map->sg_dmamap) !=3D 0) {
-		free(sg_map, M_DEVBUF);
+		kfree(sg_map);
 		return;
 	}
=20
@@ -5014,8 +5009,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 #ifndef __linux__
 		int error;
 #endif
-		pdata =3D (struct scb_platform_data *)malloc(sizeof(*pdata),
-							   M_DEVBUF, M_NOWAIT);
+		pdata =3D kmalloc(sizeof(*pdata), GFP_ATOMIC);
 		if (pdata =3D=3D NULL)
 			break;
 		next_scb->platform_data =3D pdata;
@@ -5244,7 +5238,7 @@ ahc_chip_init(struct ahc_softc *ahc)
 	 * in "fast" mode.
 	 */
 	if (bootverbose)
-		printf("%s: Downloading Sequencer Program...",
+		printk("%s: Downloading Sequencer Program...",
 		       ahc_name(ahc));
=20
 	error =3D ahc_loadseq(ahc);
@@ -5290,22 +5284,22 @@ ahc_init(struct ahc_softc *ahc)
 #endif
=20
 #ifdef AHC_PRINT_SRAM
-	printf("Scratch Ram:");
+	printk("Scratch Ram:");
 	for (i =3D 0x20; i < 0x5f; i++) {
 		if (((i % 8) =3D=3D 0) && (i !=3D 0)) {
-			printf ("\n              ");
+			printk ("\n              ");
 		}
-		printf (" 0x%x", ahc_inb(ahc, i));
+		printk (" 0x%x", ahc_inb(ahc, i));
 	}
 	if ((ahc->features & AHC_MORE_SRAM) !=3D 0) {
 		for (i =3D 0x70; i < 0x7f; i++) {
 			if (((i % 8) =3D=3D 0) && (i !=3D 0)) {
-				printf ("\n              ");
+				printk ("\n              ");
 			}
-			printf (" 0x%x", ahc_inb(ahc, i));
+			printk (" 0x%x", ahc_inb(ahc, i));
 		}
 	}
-	printf ("\n");
+	printk ("\n");
 	/*
 	 * Reading uninitialized scratch ram may
 	 * generate parity errors.
@@ -5419,14 +5413,14 @@ ahc_init(struct ahc_softc *ahc)
 	 * data for any target mode initiator.
 	 */
 	if (ahc_alloc_tstate(ahc, ahc->our_id, 'A') =3D=3D NULL) {
-		printf("%s: unable to allocate ahc_tmode_tstate.  "
+		printk("%s: unable to allocate ahc_tmode_tstate.  "
 		       "Failing attach\n", ahc_name(ahc));
 		return (ENOMEM);
 	}
=20
 	if ((ahc->features & AHC_TWIN) !=3D 0) {
 		if (ahc_alloc_tstate(ahc, ahc->our_id_b, 'B') =3D=3D NULL) {
-			printf("%s: unable to allocate ahc_tmode_tstate.  "
+			printk("%s: unable to allocate ahc_tmode_tstate.  "
 			       "Failing attach\n", ahc_name(ahc));
 			return (ENOMEM);
 		}
@@ -5440,7 +5434,7 @@ ahc_init(struct ahc_softc *ahc)
=20
 #ifdef AHC_DEBUG
 	if (ahc_debug & AHC_SHOW_MISC) {
-		printf("%s: hardware scb %u bytes; kernel scb %u bytes; "
+		printk("%s: hardware scb %u bytes; kernel scb %u bytes; "
 		       "ahc_dma %u bytes\n",
 			ahc_name(ahc),
 			(u_int)sizeof(struct hardware_scb),
@@ -5470,7 +5464,7 @@ ahc_init(struct ahc_softc *ahc)
=20
 	/* Grab the disconnection disable table and invert it for our needs *=
/
 	if ((ahc->flags & AHC_USEDEFAULTS) !=3D 0) {
-		printf("%s: Host Adapter Bios disabled.  Using default SCSI "
+		printk("%s: Host Adapter Bios disabled.  Using default SCSI "
 			"device parameters\n", ahc_name(ahc));
 		ahc->flags |=3D AHC_EXTENDED_TRANS_A|AHC_EXTENDED_TRANS_B|
 			      AHC_TERM_ENB_A|AHC_TERM_ENB_B;
@@ -5651,7 +5645,7 @@ ahc_pause_and_flushwork(struct ahc_softc *ahc)
 	      && ((intstat & INT_PEND) !=3D 0
 	       || (ahc_inb(ahc, SSTAT0) & (SELDO|SELINGO)) !=3D 0));
 	if (maxloops =3D=3D 0) {
-		printf("Infinite interrupt loop, INTSTAT =3D %x",
+		printk("Infinite interrupt loop, INTSTAT =3D %x",
 		       ahc_inb(ahc, INTSTAT));
 	}
 	ahc_platform_flushwork(ahc);
@@ -5910,7 +5904,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 	while (qinpos !=3D qintail) {
 		scb =3D ahc_lookup_scb(ahc, ahc->qinfifo[qinpos]);
 		if (scb =3D=3D NULL) {
-			printf("qinpos =3D %d, SCB index =3D %d\n",
+			printk("qinpos =3D %d, SCB index =3D %d\n",
 				qinpos, ahc->qinfifo[qinpos]);
 			panic("Loop 1\n");
 		}
@@ -5933,7 +5927,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 				if (cstat !=3D CAM_REQ_CMP)
 					ahc_freeze_scb(scb);
 				if ((scb->flags & SCB_ACTIVE) =3D=3D 0)
-					printf("Inactive SCB in qinfifo\n");
+					printk("Inactive SCB in qinfifo\n");
 				ahc_done(ahc, scb);
=20
 				/* FALLTHROUGH */
@@ -5976,7 +5970,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 		scb =3D ahc_lookup_scb(ahc, ahc->qinfifo[qinstart]);
=20
 		if (scb =3D=3D NULL) {
-			printf("found =3D %d, qinstart =3D %d, qinfifionext =3D %d\n",
+			printk("found =3D %d, qinstart =3D %d, qinfifionext =3D %d\n",
 				found, qinstart, ahc->qinfifonext);
 			panic("First/Second Qinfifo fixup\n");
 		}
@@ -6014,7 +6008,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 		ahc_outb(ahc, SCBPTR, next);
 		scb_index =3D ahc_inb(ahc, SCB_TAG);
 		if (scb_index >=3D ahc->scb_data->numscbs) {
-			printf("Waiting List inconsistency. "
+			printk("Waiting List inconsistency. "
 			       "SCB index =3D=3D %d, yet numscbs =3D=3D %d.",
 			       scb_index, ahc->scb_data->numscbs);
 			ahc_dump_card_state(ahc);
@@ -6022,7 +6016,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 		}
 		scb =3D ahc_lookup_scb(ahc, scb_index);
 		if (scb =3D=3D NULL) {
-			printf("scb_index =3D %d, next =3D %d\n",
+			printk("scb_index =3D %d, next =3D %d\n",
 				scb_index, next);
 			panic("Waiting List traversal\n");
 		}
@@ -6046,7 +6040,7 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int tar=
get, char channel,
 				if (cstat !=3D CAM_REQ_CMP)
 					ahc_freeze_scb(scb);
 				if ((scb->flags & SCB_ACTIVE) =3D=3D 0)
-					printf("Inactive SCB in Waiting List\n");
+					printk("Inactive SCB in Waiting List\n");
 				ahc_done(ahc, scb);
 				/* FALLTHROUGH */
 			}
@@ -6153,7 +6147,7 @@ ahc_search_untagged_queues(struct ahc_softc *ahc,=
 ahc_io_ctx_t ctx,
 				if (cstat !=3D CAM_REQ_CMP)
 					ahc_freeze_scb(scb);
 				if ((scb->flags & SCB_ACTIVE) =3D=3D 0)
-					printf("Inactive SCB in untaggedQ\n");
+					printk("Inactive SCB in untaggedQ\n");
 				ahc_done(ahc, scb);
 				break;
 			}
@@ -6200,7 +6194,7 @@ ahc_search_disc_list(struct ahc_softc *ahc, int t=
arget, char channel,
 		ahc_outb(ahc, SCBPTR, next);
 		scb_index =3D ahc_inb(ahc, SCB_TAG);
 		if (scb_index >=3D ahc->scb_data->numscbs) {
-			printf("Disconnected List inconsistency. "
+			printk("Disconnected List inconsistency. "
 			       "SCB index =3D=3D %d, yet numscbs =3D=3D %d.",
 			       scb_index, ahc->scb_data->numscbs);
 			ahc_dump_card_state(ahc);
@@ -6456,7 +6450,7 @@ ahc_abort_scbs(struct ahc_softc *ahc, int target,=
 char channel,
 			if (ahc_get_transaction_status(scbp) !=3D CAM_REQ_CMP)
 				ahc_freeze_scb(scbp);
 			if ((scbp->flags & SCB_ACTIVE) =3D=3D 0)
-				printf("Inactive SCB on pending list\n");
+				printk("Inactive SCB on pending list\n");
 			ahc_done(ahc, scbp);
 			found++;
 		}
@@ -6734,7 +6728,7 @@ ahc_calc_residual(struct ahc_softc *ahc, struct s=
cb *scb)
 #ifdef AHC_DEBUG
 	if ((ahc_debug & AHC_SHOW_MISC) !=3D 0) {
 		ahc_print_path(ahc, scb);
-		printf("Handled %sResidual of %d bytes\n",
+		printk("Handled %sResidual of %d bytes\n",
 		       (scb->flags & SCB_SENSE) ? "Sense " : "", resid);
 	}
 #endif
@@ -6774,7 +6768,7 @@ ahc_queue_lstate_event(struct ahc_softc *ahc, str=
uct ahc_tmode_lstate *lstate,
=20
 	if (pending =3D=3D AHC_TMODE_EVENT_BUFFER_SIZE) {
 		xpt_print_path(lstate->path);
-		printf("immediate event %x:%x lost\n",
+		printk("immediate event %x:%x lost\n",
 		       lstate->event_buffer[lstate->event_r_idx].event_type,
 		       lstate->event_buffer[lstate->event_r_idx].event_arg);
 		lstate->event_r_idx++;
@@ -6844,7 +6838,7 @@ ahc_dumpseq(struct ahc_softc* ahc)
 		uint8_t ins_bytes[4];
=20
 		ahc_insb(ahc, SEQRAM, ins_bytes, 4);
-		printf("0x%08x\n", ins_bytes[0] << 24
+		printk("0x%08x\n", ins_bytes[0] << 24
 				 | ins_bytes[1] << 16
 				 | ins_bytes[2] << 8
 				 | ins_bytes[3]);
@@ -6912,7 +6906,7 @@ ahc_loadseq(struct ahc_softc *ahc)
 			 * storage capacity for this chip.  Fail
 			 * the load.
 			 */
-			printf("\n%s: Program too large for instruction memory "
+			printk("\n%s: Program too large for instruction memory "
 			       "size of %d!\n", ahc_name(ahc),
 			       ahc->instruction_ram_size);
 			return (ENOMEM);
@@ -6947,7 +6941,7 @@ ahc_loadseq(struct ahc_softc *ahc)
 	if (cs_count !=3D 0) {
=20
 		cs_count *=3D sizeof(struct cs);
-		ahc->critical_sections =3D malloc(cs_count, M_DEVBUF, M_NOWAIT);
+		ahc->critical_sections =3D kmalloc(cs_count, GFP_ATOMIC);
 		if (ahc->critical_sections =3D=3D NULL)
 			panic("ahc_loadseq: Could not malloc");
 		memcpy(ahc->critical_sections, cs_table, cs_count);
@@ -6955,8 +6949,8 @@ ahc_loadseq(struct ahc_softc *ahc)
 	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
=20
 	if (bootverbose) {
-		printf(" %d instructions downloaded\n", downloaded);
-		printf("%s: Features 0x%x, Bugs 0x%x, Flags 0x%x\n",
+		printk(" %d instructions downloaded\n", downloaded);
+		printk("%s: Features 0x%x, Bugs 0x%x, Flags 0x%x\n",
 		       ahc_name(ahc), ahc->features, ahc->bugs, ahc->flags);
 	}
 	return (0);
@@ -7132,12 +7126,12 @@ ahc_print_register(const ahc_reg_parse_entry_t =
*table, u_int num_entries,
 	u_int	printed_mask;
=20
 	if (cur_column !=3D NULL && *cur_column >=3D wrap_point) {
-		printf("\n");
+		printk("\n");
 		*cur_column =3D 0;
 	}
-	printed =3D printf("%s[0x%x]", name, value);
+	printed  =3D printk("%s[0x%x]", name, value);
 	if (table =3D=3D NULL) {
-		printed +=3D printf(" ");
+		printed +=3D printk(" ");
 		*cur_column +=3D printed;
 		return (printed);
 	}
@@ -7152,7 +7146,7 @@ ahc_print_register(const ahc_reg_parse_entry_t *t=
able, u_int num_entries,
 			  =3D=3D table[entry].mask))
 				continue;
=20
-			printed +=3D printf("%s%s",
+			printed +=3D printk("%s%s",
 					  printed_mask =3D=3D 0 ? ":(" : "|",
 					  table[entry].name);
 			printed_mask |=3D table[entry].mask;
@@ -7163,9 +7157,9 @@ ahc_print_register(const ahc_reg_parse_entry_t *t=
able, u_int num_entries,
 			break;
 	}
 	if (printed_mask !=3D 0)
-		printed +=3D printf(") ");
+		printed +=3D printk(") ");
 	else
-		printed +=3D printf(" ");
+		printed +=3D printk(" ");
 	if (cur_column !=3D NULL)
 		*cur_column +=3D printed;
 	return (printed);
@@ -7197,16 +7191,16 @@ ahc_dump_card_state(struct ahc_softc *ahc)
=20
 	saved_scbptr =3D ahc_inb(ahc, SCBPTR);
 	last_phase =3D ahc_inb(ahc, LASTPHASE);
-	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n=
"
+	printk(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n=
"
 	       "%s: Dumping Card State %s, at SEQADDR 0x%x\n",
 	       ahc_name(ahc), ahc_lookup_phase_entry(last_phase)->phasemsg,
 	       ahc_inb(ahc, SEQADDR0) | (ahc_inb(ahc, SEQADDR1) << 8));
 	if (paused)
-		printf("Card was paused\n");
-	printf("ACCUM =3D 0x%x, SINDEX =3D 0x%x, DINDEX =3D 0x%x, ARG_2 =3D 0=
x%x\n",
+		printk("Card was paused\n");
+	printk("ACCUM =3D 0x%x, SINDEX =3D 0x%x, DINDEX =3D 0x%x, ARG_2 =3D 0=
x%x\n",
 	       ahc_inb(ahc, ACCUM), ahc_inb(ahc, SINDEX), ahc_inb(ahc, DINDEX=
),
 	       ahc_inb(ahc, ARG_2));
-	printf("HCNT =3D 0x%x SCBPTR =3D 0x%x\n", ahc_inb(ahc, HCNT),
+	printk("HCNT =3D 0x%x SCBPTR =3D 0x%x\n", ahc_inb(ahc, HCNT),
 	       ahc_inb(ahc, SCBPTR));
 	cur_col =3D 0;
 	if ((ahc->features & AHC_DT) !=3D 0)
@@ -7230,15 +7224,15 @@ ahc_dump_card_state(struct ahc_softc *ahc)
 	ahc_dfcntrl_print(ahc_inb(ahc, DFCNTRL), &cur_col, 50);
 	ahc_dfstatus_print(ahc_inb(ahc, DFSTATUS), &cur_col, 50);
 	if (cur_col !=3D 0)
-		printf("\n");
-	printf("STACK:");
+		printk("\n");
+	printk("STACK:");
 	for (i =3D 0; i < STACK_SIZE; i++)
-	       printf(" 0x%x", ahc_inb(ahc, STACK)|(ahc_inb(ahc, STACK) << 8)=
);
-	printf("\nSCB count =3D %d\n", ahc->scb_data->numscbs);
-	printf("Kernel NEXTQSCB =3D %d\n", ahc->next_queued_scb->hscb->tag);
-	printf("Card NEXTQSCB =3D %d\n", ahc_inb(ahc, NEXT_QUEUED_SCB));
+		printk(" 0x%x", ahc_inb(ahc, STACK)|(ahc_inb(ahc, STACK) << 8));
+	printk("\nSCB count =3D %d\n", ahc->scb_data->numscbs);
+	printk("Kernel NEXTQSCB =3D %d\n", ahc->next_queued_scb->hscb->tag);
+	printk("Card NEXTQSCB =3D %d\n", ahc_inb(ahc, NEXT_QUEUED_SCB));
 	/* QINFIFO */
-	printf("QINFIFO entries: ");
+	printk("QINFIFO entries: ");
 	if ((ahc->features & AHC_QUEUE_REGS) !=3D 0) {
 		qinpos =3D ahc_inb(ahc, SNSCB_QOFF);
 		ahc_outb(ahc, SNSCB_QOFF, qinpos);
@@ -7246,109 +7240,109 @@ ahc_dump_card_state(struct ahc_softc *ahc)
 		qinpos =3D ahc_inb(ahc, QINPOS);
 	qintail =3D ahc->qinfifonext;
 	while (qinpos !=3D qintail) {
-		printf("%d ", ahc->qinfifo[qinpos]);
+		printk("%d ", ahc->qinfifo[qinpos]);
 		qinpos++;
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Waiting Queue entries: ");
+	printk("Waiting Queue entries: ");
 	scb_index =3D ahc_inb(ahc, WAITING_SCBH);
 	i =3D 0;
 	while (scb_index !=3D SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printf("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
+		printk("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
 		scb_index =3D ahc_inb(ahc, SCB_NEXT);
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Disconnected Queue entries: ");
+	printk("Disconnected Queue entries: ");
 	scb_index =3D ahc_inb(ahc, DISCONNECTED_SCBH);
 	i =3D 0;
 	while (scb_index !=3D SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printf("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
+		printk("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
 		scb_index =3D ahc_inb(ahc, SCB_NEXT);
 	}
-	printf("\n");
+	printk("\n");
 	=09
 	ahc_sync_qoutfifo(ahc, BUS_DMASYNC_POSTREAD);
-	printf("QOUTFIFO entries: ");
+	printk("QOUTFIFO entries: ");
 	qoutpos =3D ahc->qoutfifonext;
 	i =3D 0;
 	while (ahc->qoutfifo[qoutpos] !=3D SCB_LIST_NULL && i++ < 256) {
-		printf("%d ", ahc->qoutfifo[qoutpos]);
+		printk("%d ", ahc->qoutfifo[qoutpos]);
 		qoutpos++;
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Sequencer Free SCB List: ");
+	printk("Sequencer Free SCB List: ");
 	scb_index =3D ahc_inb(ahc, FREE_SCBH);
 	i =3D 0;
 	while (scb_index !=3D SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printf("%d ", scb_index);
+		printk("%d ", scb_index);
 		scb_index =3D ahc_inb(ahc, SCB_NEXT);
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Sequencer SCB Info: ");
+	printk("Sequencer SCB Info: ");
 	for (i =3D 0; i < ahc->scb_data->maxhscbs; i++) {
 		ahc_outb(ahc, SCBPTR, i);
-		cur_col =3D printf("\n%3d ", i);
+		cur_col  =3D printk("\n%3d ", i);
=20
 		ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL), &cur_col, 60);
 		ahc_scb_scsiid_print(ahc_inb(ahc, SCB_SCSIID), &cur_col, 60);
 		ahc_scb_lun_print(ahc_inb(ahc, SCB_LUN), &cur_col, 60);
 		ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &cur_col, 60);
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Pending list: ");
+	printk("Pending list: ");
 	i =3D 0;
 	LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
 		if (i++ > 256)
 			break;
-		cur_col =3D printf("\n%3d ", scb->hscb->tag);
+		cur_col  =3D printk("\n%3d ", scb->hscb->tag);
 		ahc_scb_control_print(scb->hscb->control, &cur_col, 60);
 		ahc_scb_scsiid_print(scb->hscb->scsiid, &cur_col, 60);
 		ahc_scb_lun_print(scb->hscb->lun, &cur_col, 60);
 		if ((ahc->flags & AHC_PAGESCBS) =3D=3D 0) {
 			ahc_outb(ahc, SCBPTR, scb->hscb->tag);
-			printf("(");
+			printk("(");
 			ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL),
 					      &cur_col, 60);
 			ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &cur_col, 60);
-			printf(")");
+			printk(")");
 		}
 	}
-	printf("\n");
+	printk("\n");
=20
-	printf("Kernel Free SCB list: ");
+	printk("Kernel Free SCB list: ");
 	i =3D 0;
 	SLIST_FOREACH(scb, &ahc->scb_data->free_scbs, links.sle) {
 		if (i++ > 256)
 			break;
-		printf("%d ", scb->hscb->tag);
+		printk("%d ", scb->hscb->tag);
 	}
-	printf("\n");
+	printk("\n");
=20
 	maxtarget =3D (ahc->features & (AHC_WIDE|AHC_TWIN)) ? 15 : 7;
 	for (target =3D 0; target <=3D maxtarget; target++) {
 		untagged_q =3D &ahc->untagged_queues[target];
 		if (TAILQ_FIRST(untagged_q) =3D=3D NULL)
 			continue;
-		printf("Untagged Q(%d): ", target);
+		printk("Untagged Q(%d): ", target);
 		i =3D 0;
 		TAILQ_FOREACH(scb, untagged_q, links.tqe) {
 			if (i++ > 256)
 				break;
-			printf("%d ", scb->hscb->tag);
+			printk("%d ", scb->hscb->tag);
 		}
-		printf("\n");
+		printk("\n");
 	}
=20
 	ahc_platform_dump_card_state(ahc);
-	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n=
");
+	printk("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n=
");
 	ahc_outb(ahc, SCBPTR, saved_scbptr);
 	if (paused =3D=3D 0)
 		ahc_unpause(ahc);
@@ -7489,7 +7483,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 		u_long	 s;
 		ahc_flag saved_flags;
=20
-		printf("Configuring Target Mode\n");
+		printk("Configuring Target Mode\n");
 		ahc_lock(ahc, &s);
 		if (LIST_FIRST(&ahc->pending_scbs) !=3D NULL) {
 			ccb->ccb_h.status =3D CAM_BUSY;
@@ -7535,7 +7529,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 		/* Are we already enabled?? */
 		if (lstate !=3D NULL) {
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Lun already enabled\n");
+			printk("Lun already enabled\n");
 			ccb->ccb_h.status =3D CAM_LUN_ALRDY_ENA;
 			return;
 		}
@@ -7547,7 +7541,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 			 * specific commands.
 			 */
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
-			printf("Non-zero Group Codes\n");
+			printk("Non-zero Group Codes\n");
 			return;
 		}
=20
@@ -7559,15 +7553,15 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct=
 cam_sim *sim, union ccb *ccb)
 			tstate =3D ahc_alloc_tstate(ahc, target, channel);
 			if (tstate =3D=3D NULL) {
 				xpt_print_path(ccb->ccb_h.path);
-				printf("Couldn't allocate tstate\n");
+				printk("Couldn't allocate tstate\n");
 				ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 				return;
 			}
 		}
-		lstate =3D malloc(sizeof(*lstate), M_DEVBUF, M_NOWAIT);
+		lstate =3D kmalloc(sizeof(*lstate), GFP_ATOMIC);
 		if (lstate =3D=3D NULL) {
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Couldn't allocate lstate\n");
+			printk("Couldn't allocate lstate\n");
 			ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 			return;
 		}
@@ -7577,9 +7571,9 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 					 xpt_path_target_id(ccb->ccb_h.path),
 					 xpt_path_lun_id(ccb->ccb_h.path));
 		if (status !=3D CAM_REQ_CMP) {
-			free(lstate, M_DEVBUF);
+			kfree(lstate);
 			xpt_print_path(ccb->ccb_h.path);
-			printf("Couldn't allocate path\n");
+			printk("Couldn't allocate path\n");
 			ccb->ccb_h.status =3D CAM_RESRC_UNAVAIL;
 			return;
 		}
@@ -7654,7 +7648,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 		ahc_unlock(ahc, &s);
 		ccb->ccb_h.status =3D CAM_REQ_CMP;
 		xpt_print_path(ccb->ccb_h.path);
-		printf("Lun now enabled for target mode\n");
+		printk("Lun now enabled for target mode\n");
 	} else {
 		struct scb *scb;
 		int i, empty;
@@ -7673,7 +7667,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 			ccbh =3D &scb->io_ctx->ccb_h;
 			if (ccbh->func_code =3D=3D XPT_CONT_TARGET_IO
 			 && !xpt_path_comp(ccbh->path, ccb->ccb_h.path)){
-				printf("CTIO pending\n");
+				printk("CTIO pending\n");
 				ccb->ccb_h.status =3D CAM_REQ_INVALID;
 				ahc_unlock(ahc, &s);
 				return;
@@ -7681,12 +7675,12 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct=
 cam_sim *sim, union ccb *ccb)
 		}
=20
 		if (SLIST_FIRST(&lstate->accept_tios) !=3D NULL) {
-			printf("ATIOs pending\n");
+			printk("ATIOs pending\n");
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
 		}
=20
 		if (SLIST_FIRST(&lstate->immed_notifies) !=3D NULL) {
-			printf("INOTs pending\n");
+			printk("INOTs pending\n");
 			ccb->ccb_h.status =3D CAM_REQ_INVALID;
 		}
=20
@@ -7696,9 +7690,9 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 		}
=20
 		xpt_print_path(ccb->ccb_h.path);
-		printf("Target mode disabled\n");
+		printk("Target mode disabled\n");
 		xpt_free_path(lstate->path);
-		free(lstate, M_DEVBUF);
+		kfree(lstate);
=20
 		ahc_pause(ahc);
 		/* Can we clean up the target too? */
@@ -7750,7 +7744,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct c=
am_sim *sim, union ccb *ccb)
 			ahc_outb(ahc, SCSISEQ, scsiseq);
=20
 			if ((ahc->features & AHC_MULTIROLE) =3D=3D 0) {
-				printf("Configuring Initiator Mode\n");
+				printk("Configuring Initiator Mode\n");
 				ahc->flags &=3D ~AHC_TARGETROLE;
 				ahc->flags |=3D AHC_INITIATORROLE;
 				/*
@@ -7897,12 +7891,12 @@ ahc_handle_target_cmd(struct ahc_softc *ahc, st=
ruct target_cmd *cmd)
 		 * Wait for more ATIOs from the peripheral driver for this lun.
 		 */
 		if (bootverbose)
-			printf("%s: ATIOs exhausted\n", ahc_name(ahc));
+			printk("%s: ATIOs exhausted\n", ahc_name(ahc));
 		return (1);
 	} else
 		ahc->flags &=3D ~AHC_TQINFIFO_BLOCKED;
 #if 0
-	printf("Incoming command from %d for %d:%d%s\n",
+	printk("Incoming command from %d for %d:%d%s\n",
 	       initiator, target, lun,
 	       lstate =3D=3D ahc->black_hole ? "(Black Holed)" : "");
 #endif
@@ -7949,7 +7943,7 @@ ahc_handle_target_cmd(struct ahc_softc *ahc, stru=
ct target_cmd *cmd)
 	default:
 		/* Only copy the opcode. */
 		atio->cdb_len =3D 1;
-		printf("Reserved or VU command code type encountered\n");
+		printk("Reserved or VU command code type encountered\n");
 		break;
 	}
 =09
@@ -7965,7 +7959,7 @@ ahc_handle_target_cmd(struct ahc_softc *ahc, stru=
ct target_cmd *cmd)
 		 * to this accept tio.
 		 */
 #if 0
-		printf("Received Immediate Command %d:%d:%d - %p\n",
+		printk("Received Immediate Command %d:%d:%d - %p\n",
 		       initiator, target, lun, ahc->pending_device);
 #endif
 		ahc->pending_device =3D lstate;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/=
aic7xxx_osm.c
index 5e42dac..aeea7a6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -653,7 +653,7 @@ ahc_linux_slave_alloc(struct scsi_device *sdev)
 	struct ahc_linux_device *dev;
=20
 	if (bootverbose)
-		printf("%s: Slave Alloc %d\n", ahc_name(ahc), sdev->id);
+		printk("%s: Slave Alloc %d\n", ahc_name(ahc), sdev->id);
=20
 	dev =3D scsi_transport_device_data(sdev);
 	memset(dev, 0, sizeof(*dev));
@@ -755,7 +755,7 @@ ahc_linux_abort(struct scsi_cmnd *cmd)
=20
 	error =3D ahc_linux_queue_recovery_cmd(cmd, SCB_ABORT);
 	if (error !=3D 0)
-		printf("aic7xxx_abort returns 0x%x\n", error);
+		printk("aic7xxx_abort returns 0x%x\n", error);
 	return (error);
 }
=20
@@ -769,7 +769,7 @@ ahc_linux_dev_reset(struct scsi_cmnd *cmd)
=20
 	error =3D ahc_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
 	if (error !=3D 0)
-		printf("aic7xxx_dev_reset returns 0x%x\n", error);
+		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
 }
=20
@@ -791,7 +791,7 @@ ahc_linux_bus_reset(struct scsi_cmnd *cmd)
 	ahc_unlock(ahc, &flags);
=20
 	if (bootverbose)
-		printf("%s: SCSI bus reset delivered. "
+		printk("%s: SCSI bus reset delivered. "
 		       "%d SCBs aborted.\n", ahc_name(ahc), found);
=20
 	return SUCCESS;
@@ -840,7 +840,7 @@ ahc_dma_tag_create(struct ahc_softc *ahc, bus_dma_t=
ag_t parent,
 {
 	bus_dma_tag_t dmat;
=20
-	dmat =3D malloc(sizeof(*dmat), M_DEVBUF, M_NOWAIT);
+	dmat =3D kmalloc(sizeof(*dmat), GFP_ATOMIC);
 	if (dmat =3D=3D NULL)
 		return (ENOMEM);
=20
@@ -861,7 +861,7 @@ ahc_dma_tag_create(struct ahc_softc *ahc, bus_dma_t=
ag_t parent,
 void
 ahc_dma_tag_destroy(struct ahc_softc *ahc, bus_dma_tag_t dmat)
 {
-	free(dmat, M_DEVBUF);
+	kfree(dmat);
 }
=20
 int
@@ -918,7 +918,7 @@ ahc_linux_setup_tag_info_global(char *p)
 	int tags, i, j;
=20
 	tags =3D simple_strtoul(p + 1, NULL, 0) & 0xff;
-	printf("Setting Global Tags=3D %d\n", tags);
+	printk("Setting Global Tags=3D %d\n", tags);
=20
 	for (i =3D 0; i < ARRAY_SIZE(aic7xxx_tag_info); i++) {
 		for (j =3D 0; j < AHC_NUM_TARGETS; j++) {
@@ -936,7 +936,7 @@ ahc_linux_setup_tag_info(u_long arg, int instance, =
int targ, int32_t value)
 	 && (targ < AHC_NUM_TARGETS)) {
 		aic7xxx_tag_info[instance].tag_commands[targ] =3D value & 0xff;
 		if (bootverbose)
-			printf("tag_info[%d:%d] =3D %d\n", instance, targ, value);
+			printk("tag_info[%d:%d] =3D %d\n", instance, targ, value);
 	}
 }
=20
@@ -977,7 +977,7 @@ ahc_parse_brace_option(char *opt_name, char *opt_ar=
g, char *end, int depth,
 					if (targ =3D=3D -1)
 						targ =3D 0;
 				} else {
-					printf("Malformed Option %s\n",
+					printk("Malformed Option %s\n",
 					       opt_name);
 					done =3D TRUE;
 				}
@@ -1120,7 +1120,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, st=
ruct scsi_host_template *templa
 	ahc_set_unit(ahc, ahc_linux_unit++);
 	ahc_unlock(ahc, &s);
 	sprintf(buf, "scsi%d", host->host_no);
-	new_name =3D malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	new_name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (new_name !=3D NULL) {
 		strcpy(new_name, buf);
 		ahc_set_name(ahc, new_name);
@@ -1220,7 +1220,7 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *p=
latform_arg)
 {
=20
 	ahc->platform_data =3D
-	    malloc(sizeof(struct ahc_platform_data), M_DEVBUF, M_NOWAIT);
+	    kmalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
 	if (ahc->platform_data =3D=3D NULL)
 		return (ENOMEM);
 	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
@@ -1264,7 +1264,7 @@ ahc_platform_free(struct ahc_softc *ahc)
 		if (ahc->platform_data->host)
 			scsi_host_put(ahc->platform_data->host);
=20
-		free(ahc->platform_data, M_DEVBUF);
+		kfree(ahc->platform_data);
 	}
 }
=20
@@ -1378,7 +1378,7 @@ ahc_linux_user_tagdepth(struct ahc_softc *ahc, st=
ruct ahc_devinfo *devinfo)
 		if (ahc->unit >=3D ARRAY_SIZE(aic7xxx_tag_info)) {
 			if (warned_user =3D=3D 0) {
=20
-				printf(KERN_WARNING
+				printk(KERN_WARNING
 "aic7xxx: WARNING: Insufficient tag_info instances\n"
 "aic7xxx: for installed controllers. Using defaults\n"
 "aic7xxx: Please update the aic7xxx_tag_info array in\n"
@@ -1421,7 +1421,7 @@ ahc_linux_device_queue_depth(struct scsi_device *=
sdev)
 		ahc_send_async(ahc, devinfo.channel, devinfo.target,
 			       devinfo.lun, AC_TRANSFER_NEG);
 		ahc_print_devinfo(ahc, &devinfo);
-		printf("Tagged Queuing enabled.  Depth %d\n", tags);
+		printk("Tagged Queuing enabled.  Depth %d\n", tags);
 	} else {
 		ahc_platform_set_tags(ahc, sdev, &devinfo, AHC_QUEUE_NONE);
 		ahc_send_async(ahc, devinfo.channel, devinfo.target,
@@ -1735,7 +1735,7 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 		 * not have been dispatched to the controller, so
 		 * only check the SCB_ACTIVE flag for tagged transactions.
 		 */
-		printf("SCB %d done'd twice\n", scb->hscb->tag);
+		printk("SCB %d done'd twice\n", scb->hscb->tag);
 		ahc_dump_card_state(ahc);
 		panic("Stopping for safety");
 	}
@@ -1765,7 +1765,7 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MISC) !=3D 0) {
 				ahc_print_path(ahc, scb);
-				printf("Set CAM_UNCOR_PARITY\n");
+				printk("Set CAM_UNCOR_PARITY\n");
 			}
 #endif
 			ahc_set_transaction_status(scb, CAM_UNCOR_PARITY);
@@ -1783,12 +1783,12 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb=
)
 			u_int i;
=20
 			ahc_print_path(ahc, scb);
-			printf("CDB:");
+			printk("CDB:");
 			for (i =3D 0; i < scb->io_ctx->cmd_len; i++)
-				printf(" 0x%x", scb->io_ctx->cmnd[i]);
-			printf("\n");
+				printk(" 0x%x", scb->io_ctx->cmnd[i]);
+			printk("\n");
 			ahc_print_path(ahc, scb);
-			printf("Saw underflow (%ld of %ld bytes). "
+			printk("Saw underflow (%ld of %ld bytes). "
 			       "Treated as error\n",
 				ahc_get_residual(scb),
 				ahc_get_transfer_length(scb));
@@ -1821,7 +1821,7 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 		dev->commands_since_idle_or_otag =3D 0;
=20
 	if ((scb->flags & SCB_RECOVERY_SCB) !=3D 0) {
-		printf("Recovery SCB completes\n");
+		printk("Recovery SCB completes\n");
 		if (ahc_get_transaction_status(scb) =3D=3D CAM_BDR_SENT
 		 || ahc_get_transaction_status(scb) =3D=3D CAM_REQ_ABORTED)
 			ahc_set_transaction_status(scb, CAM_CMD_TIMEOUT);
@@ -1886,14 +1886,14 @@ ahc_linux_handle_scsi_status(struct ahc_softc *=
ahc,
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				int i;
=20
-				printf("Copied %d bytes of sense data:",
+				printk("Copied %d bytes of sense data:",
 				       sense_size);
 				for (i =3D 0; i < sense_size; i++) {
 					if ((i & 0xF) =3D=3D 0)
-						printf("\n");
-					printf("0x%x ", cmd->sense_buffer[i]);
+						printk("\n");
+					printk("0x%x ", cmd->sense_buffer[i]);
 				}
-				printf("\n");
+				printk("\n");
 			}
 #endif
 		}
@@ -1918,7 +1918,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ah=
c,
 			dev->openings =3D 0;
 /*
 			ahc_print_path(ahc, scb);
-			printf("Dropping tag count to %d\n", dev->active);
+			printk("Dropping tag count to %d\n", dev->active);
  */
 			if (dev->active =3D=3D dev->tags_on_last_queuefull) {
=20
@@ -1935,7 +1935,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ah=
c,
 				 =3D=3D AHC_LOCK_TAGS_COUNT) {
 					dev->maxtags =3D dev->active;
 					ahc_print_path(ahc, scb);
-					printf("Locking max tag count at %d\n",
+					printk("Locking max tag count at %d\n",
 					       dev->active);
 				}
 			} else {
@@ -2100,10 +2100,10 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *=
cmd, scb_flag flag)
 	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
 	       flag =3D=3D SCB_ABORT ? "n ABORT" : " TARGET RESET");
=20
-	printf("CDB:");
+	printk("CDB:");
 	for (cdb_byte =3D 0; cdb_byte < cmd->cmd_len; cdb_byte++)
-		printf(" 0x%x", cmd->cmnd[cdb_byte]);
-	printf("\n");
+		printk(" 0x%x", cmd->cmnd[cdb_byte]);
+	printk("\n");
=20
 	ahc_lock(ahc, &flags);
=20
@@ -2121,7 +2121,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cm=
d, scb_flag flag)
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		printf("%s:%d:%d:%d: Is not an active device\n",
+		printk("%s:%d:%d:%d: Is not an active device\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
 		       cmd->device->lun);
 		retval =3D SUCCESS;
@@ -2133,7 +2133,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cm=
d, scb_flag flag)
 				       cmd->device->channel + 'A',
 				       cmd->device->lun,
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) !=3D 0) {
-		printf("%s:%d:%d:%d: Command found on untagged queue\n",
+		printk("%s:%d:%d:%d: Command found on untagged queue\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
 		       cmd->device->lun);
 		retval =3D SUCCESS;
@@ -2187,7 +2187,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cm=
d, scb_flag flag)
 		goto no_cmd;
 	}
=20
-	printf("%s: At time of recovery, card was %spaused\n",
+	printk("%s: At time of recovery, card was %spaused\n",
 	       ahc_name(ahc), was_paused ? "" : "not ");
 	ahc_dump_card_state(ahc);
=20
@@ -2199,7 +2199,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cm=
d, scb_flag flag)
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
-			printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
+			printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 			       ahc_name(ahc), cmd->device->channel,
 					cmd->device->id, cmd->device->lun);
 			retval =3D SUCCESS;
@@ -2313,7 +2313,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cm=
d, scb_flag flag)
 		ahc_qinfifo_requeue_tail(ahc, pending_scb);
 		ahc_outb(ahc, SCBPTR, saved_scbptr);
 		ahc_print_path(ahc, pending_scb);
-		printf("Device is disconnected, re-queuing SCB\n");
+		printk("Device is disconnected, re-queuing SCB\n");
 		wait =3D TRUE;
 	} else {
 		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
@@ -2338,16 +2338,16 @@ done:
 		ahc->platform_data->eh_done =3D &done;
 		ahc_unlock(ahc, &flags);
=20
-		printf("Recovery code sleeping\n");
+		printk("Recovery code sleeping\n");
 		if (!wait_for_completion_timeout(&done, 5 * HZ)) {
 			ahc_lock(ahc, &flags);
 			ahc->platform_data->eh_done =3D NULL;
 			ahc_unlock(ahc, &flags);
=20
-			printf("Timer Expired\n");
+			printk("Timer Expired\n");
 			retval =3D FAILED;
 		}
-		printf("Recovery code awake\n");
+		printk("Recovery code awake\n");
 	} else
 		ahc_unlock(ahc, &flags);
 	return (retval);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/=
aic7xxx_osm.h
index 56f07e5..bca0fb8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -368,13 +368,6 @@ struct ahc_platform_data {
 	resource_size_t 	 mem_busaddr;	/* Mem Base Addr */
 };
=20
-/************************** OS Utility Wrappers **********************=
*********/
-#define printf printk
-#define M_NOWAIT GFP_ATOMIC
-#define M_WAITOK 0
-#define malloc(size, type, flags) kmalloc(size, flags)
-#define free(ptr, type) kfree(ptr)
-
 void ahc_delay(long);
=20
=20
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic7xxx_osm_pci.c
index 78fc70c..ee05e84 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -225,7 +225,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
 		ahc_get_pci_bus(pci),
 		ahc_get_pci_slot(pci),
 		ahc_get_pci_function(pci));
-	name =3D malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (name =3D=3D NULL)
 		return (-ENOMEM);
 	strcpy(name, buf);
@@ -412,7 +412,7 @@ ahc_pci_map_registers(struct ahc_softc *ahc)
 		 */
 		if (ahc_pci_test_register_access(ahc) !=3D 0) {
=20
-			printf("aic7xxx: PCI Device %d:%d:%d "
+			printk("aic7xxx: PCI Device %d:%d:%d "
 			       "failed memory mapped test.  Using PIO.\n",
 			       ahc_get_pci_bus(ahc->dev_softc),
 			       ahc_get_pci_slot(ahc->dev_softc),
@@ -425,7 +425,7 @@ ahc_pci_map_registers(struct ahc_softc *ahc)
 		} else
 			command |=3D PCIM_CMD_MEMEN;
 	} else {
-		printf("aic7xxx: PCI%d:%d:%d MEM region 0x%llx "
+		printk("aic7xxx: PCI%d:%d:%d MEM region 0x%llx "
 		       "unavailable. Cannot memory map device.\n",
 		       ahc_get_pci_bus(ahc->dev_softc),
 		       ahc_get_pci_slot(ahc->dev_softc),
@@ -444,7 +444,7 @@ ahc_pci_map_registers(struct ahc_softc *ahc)
 			ahc->bsh.ioport =3D (u_long)base;
 			command |=3D PCIM_CMD_PORTEN;
 		} else {
-			printf("aic7xxx: PCI%d:%d:%d IO region 0x%llx[0..255] "
+			printk("aic7xxx: PCI%d:%d:%d IO region 0x%llx[0..255] "
 			       "unavailable. Cannot map device.\n",
 			       ahc_get_pci_bus(ahc->dev_softc),
 			       ahc_get_pci_slot(ahc->dev_softc),
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/=
aic7xxx_pci.c
index 27014b9..2b11a42 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -752,7 +752,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct =
ahc_pci_identity *entry)
 	if ((ahc->flags & AHC_39BIT_ADDRESSING) !=3D 0) {
=20
 		if (bootverbose)
-			printf("%s: Enabling 39Bit Addressing\n",
+			printk("%s: Enabling 39Bit Addressing\n",
 			       ahc_name(ahc));
 		devconfig |=3D DACEN;
 	}
@@ -896,7 +896,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct =
ahc_pci_identity *entry)
 		/* See if someone else set us up already */
 		if ((ahc->flags & AHC_NO_BIOS_INIT) =3D=3D 0
 		 && scsiseq !=3D 0) {
-			printf("%s: Using left over BIOS settings\n",
+			printk("%s: Using left over BIOS settings\n",
 				ahc_name(ahc));
 			ahc->flags &=3D ~AHC_USEDEFAULTS;
 			ahc->flags |=3D AHC_BIOS_ENABLED;
@@ -1155,7 +1155,7 @@ done:
 	ahc_outb(ahc, CLRINT, CLRPARERR);
 	ahc_outb(ahc, CLRINT, CLRBRKADRINT);
 	if (bootverbose && enable) {
-		printf("%s: External SRAM, %s access%s, %dbytes/SCB\n",
+		printk("%s: External SRAM, %s access%s, %dbytes/SCB\n",
 		       ahc_name(ahc), fast ? "fast" : "slow",=20
 		       pcheck ? ", parity checking enabled" : "",
 		       large ? 64 : 32);
@@ -1292,7 +1292,7 @@ check_extport(struct ahc_softc *ahc, u_int *sxfrc=
tl1)
 	if (have_seeprom) {
=20
 		if (bootverbose)=20
-			printf("%s: Reading SEEPROM...", ahc_name(ahc));
+			printk("%s: Reading SEEPROM...", ahc_name(ahc));
=20
 		for (;;) {
 			u_int start_addr;
@@ -1309,9 +1309,9 @@ check_extport(struct ahc_softc *ahc, u_int *sxfrc=
tl1)
 			if (have_seeprom !=3D 0 || sd.sd_chip =3D=3D C56_66) {
 				if (bootverbose) {
 					if (have_seeprom =3D=3D 0)
-						printf ("checksum error\n");
+						printk ("checksum error\n");
 					else
-						printf ("done.\n");
+						printk ("done.\n");
 				}
 				break;
 			}
@@ -1362,9 +1362,9 @@ check_extport(struct ahc_softc *ahc, u_int *sxfrc=
tl1)
=20
 	if (!have_seeprom) {
 		if (bootverbose)
-			printf("%s: No SEEPROM available.\n", ahc_name(ahc));
+			printk("%s: No SEEPROM available.\n", ahc_name(ahc));
 		ahc->flags |=3D AHC_USEDEFAULTS;
-		free(ahc->seep_config, M_DEVBUF);
+		kfree(ahc->seep_config);
 		ahc->seep_config =3D NULL;
 		sc =3D NULL;
 	} else {
@@ -1399,7 +1399,7 @@ check_extport(struct ahc_softc *ahc, u_int *sxfrc=
tl1)
 		if ((sc->adapter_control & CFSTERM) !=3D 0)
 			*sxfrctl1 |=3D STPWEN;
 		if (bootverbose)
-			printf("%s: Low byte termination %sabled\n",
+			printk("%s: Low byte termination %sabled\n",
 			       ahc_name(ahc),
 			       (*sxfrctl1 & STPWEN) ? "en" : "dis");
 	}
@@ -1569,7 +1569,7 @@ configure_termination(struct ahc_softc *ahc,
 					    &eeprom_present);
 			if ((adapter_control & CFSEAUTOTERM) =3D=3D 0) {
 				if (bootverbose)
-					printf("%s: Manual SE Termination\n",
+					printk("%s: Manual SE Termination\n",
 					       ahc_name(ahc));
 				enableSEC_low =3D (adapter_control & CFSELOWTERM);
 				enableSEC_high =3D
@@ -1577,7 +1577,7 @@ configure_termination(struct ahc_softc *ahc,
 			}
 			if ((adapter_control & CFAUTOTERM) =3D=3D 0) {
 				if (bootverbose)
-					printf("%s: Manual LVD Termination\n",
+					printk("%s: Manual LVD Termination\n",
 					       ahc_name(ahc));
 				enablePRI_low =3D (adapter_control & CFSTERM);
 				enablePRI_high =3D (adapter_control & CFWSTERM);
@@ -1604,19 +1604,19 @@ configure_termination(struct ahc_softc *ahc,
=20
 		if (bootverbose
 		 && (ahc->features & AHC_ULTRA2) =3D=3D 0) {
-			printf("%s: internal 50 cable %s present",
+			printk("%s: internal 50 cable %s present",
 			       ahc_name(ahc),
 			       internal50_present ? "is":"not");
=20
 			if ((ahc->features & AHC_WIDE) !=3D 0)
-				printf(", internal 68 cable %s present",
+				printk(", internal 68 cable %s present",
 				       internal68_present ? "is":"not");
-			printf("\n%s: external cable %s present\n",
+			printk("\n%s: external cable %s present\n",
 			       ahc_name(ahc),
 			       externalcable_present ? "is":"not");
 		}
 		if (bootverbose)
-			printf("%s: BIOS eeprom %s present\n",
+			printk("%s: BIOS eeprom %s present\n",
 			       ahc_name(ahc), eeprom_present ? "is" : "not");
=20
 		if ((ahc->flags & AHC_INT50_SPEEDFLEX) !=3D 0) {
@@ -1642,7 +1642,7 @@ configure_termination(struct ahc_softc *ahc,
 		 && (internal50_present !=3D 0)
 		 && (internal68_present !=3D 0)
 		 && (externalcable_present !=3D 0)) {
-			printf("%s: Illegal cable configuration!!. "
+			printk("%s: Illegal cable configuration!!. "
 			       "Only two connectors on the "
 			       "adapter may be used at a "
 			       "time!\n", ahc_name(ahc));
@@ -1664,10 +1664,10 @@ configure_termination(struct ahc_softc *ahc,
 			brddat |=3D BRDDAT6;
 			if (bootverbose) {
 				if ((ahc->flags & AHC_INT50_SPEEDFLEX) !=3D 0)
-					printf("%s: 68 pin termination "
+					printk("%s: 68 pin termination "
 					       "Enabled\n", ahc_name(ahc));
 				else
-					printf("%s: %sHigh byte termination "
+					printk("%s: %sHigh byte termination "
 					       "Enabled\n", ahc_name(ahc),
 					       enableSEC_high ? "Secondary "
 							      : "");
@@ -1683,10 +1683,10 @@ configure_termination(struct ahc_softc *ahc,
 				*sxfrctl1 |=3D STPWEN;
 			if (bootverbose) {
 				if ((ahc->flags & AHC_INT50_SPEEDFLEX) !=3D 0)
-					printf("%s: 50 pin termination "
+					printk("%s: 50 pin termination "
 					       "Enabled\n", ahc_name(ahc));
 				else
-					printf("%s: %sLow byte termination "
+					printk("%s: %sLow byte termination "
 					       "Enabled\n", ahc_name(ahc),
 					       enableSEC_low ? "Secondary "
 							     : "");
@@ -1696,7 +1696,7 @@ configure_termination(struct ahc_softc *ahc,
 		if (enablePRI_low !=3D 0) {
 			*sxfrctl1 |=3D STPWEN;
 			if (bootverbose)
-				printf("%s: Primary Low Byte termination "
+				printk("%s: Primary Low Byte termination "
 				       "Enabled\n", ahc_name(ahc));
 		}
=20
@@ -1709,7 +1709,7 @@ configure_termination(struct ahc_softc *ahc,
 		if (enablePRI_high !=3D 0) {
 			brddat |=3D BRDDAT4;
 			if (bootverbose)
-				printf("%s: Primary High Byte "
+				printk("%s: Primary High Byte "
 				       "termination Enabled\n",
 				       ahc_name(ahc));
 		}
@@ -1721,7 +1721,7 @@ configure_termination(struct ahc_softc *ahc,
 			*sxfrctl1 |=3D STPWEN;
=20
 			if (bootverbose)
-				printf("%s: %sLow byte termination Enabled\n",
+				printk("%s: %sLow byte termination Enabled\n",
 				       ahc_name(ahc),
 				       (ahc->features & AHC_ULTRA2) ? "Primary "
 								    : "");
@@ -1731,7 +1731,7 @@ configure_termination(struct ahc_softc *ahc,
 		 && (ahc->features & AHC_WIDE) !=3D 0) {
 			brddat |=3D BRDDAT6;
 			if (bootverbose)
-				printf("%s: %sHigh byte termination Enabled\n",
+				printk("%s: %sHigh byte termination Enabled\n",
 				       ahc_name(ahc),
 				       (ahc->features & AHC_ULTRA2)
 				     ? "Secondary " : "");
@@ -1937,29 +1937,29 @@ ahc_pci_intr(struct ahc_softc *ahc)
 	status1 =3D ahc_pci_read_config(ahc->dev_softc,
 				      PCIR_STATUS + 1, /*bytes*/1);
=20
-	printf("%s: PCI error Interrupt at seqaddr =3D 0x%x\n",
+	printk("%s: PCI error Interrupt at seqaddr =3D 0x%x\n",
 	      ahc_name(ahc),
 	      ahc_inb(ahc, SEQADDR0) | (ahc_inb(ahc, SEQADDR1) << 8));
=20
 	if (status1 & DPE) {
 		ahc->pci_target_perr_count++;
-		printf("%s: Data Parity Error Detected during address "
+		printk("%s: Data Parity Error Detected during address "
 		       "or write data phase\n", ahc_name(ahc));
 	}
 	if (status1 & SSE) {
-		printf("%s: Signal System Error Detected\n", ahc_name(ahc));
+		printk("%s: Signal System Error Detected\n", ahc_name(ahc));
 	}
 	if (status1 & RMA) {
-		printf("%s: Received a Master Abort\n", ahc_name(ahc));
+		printk("%s: Received a Master Abort\n", ahc_name(ahc));
 	}
 	if (status1 & RTA) {
-		printf("%s: Received a Target Abort\n", ahc_name(ahc));
+		printk("%s: Received a Target Abort\n", ahc_name(ahc));
 	}
 	if (status1 & STA) {
-		printf("%s: Signaled a Target Abort\n", ahc_name(ahc));
+		printk("%s: Signaled a Target Abort\n", ahc_name(ahc));
 	}
 	if (status1 & DPR) {
-		printf("%s: Data Parity Error has been reported via PERR#\n",
+		printk("%s: Data Parity Error has been reported via PERR#\n",
 		       ahc_name(ahc));
 	}
=20
@@ -1968,14 +1968,14 @@ ahc_pci_intr(struct ahc_softc *ahc)
 			     status1, /*bytes*/1);
=20
 	if ((status1 & (DPE|SSE|RMA|RTA|STA|DPR)) =3D=3D 0) {
-		printf("%s: Latched PCIERR interrupt with "
+		printk("%s: Latched PCIERR interrupt with "
 		       "no status bits set\n", ahc_name(ahc));=20
 	} else {
 		ahc_outb(ahc, CLRINT, CLRPARERR);
 	}
=20
 	if (ahc->pci_target_perr_count > AHC_PCI_TARGET_PERR_THRESH) {
-		printf(
+		printk(
 "%s: WARNING WARNING WARNING WARNING\n"
 "%s: Too many PCI parity errors observed as a target.\n"
 "%s: Some device on this bus is generating bad parity.\n"
@@ -2386,7 +2386,7 @@ ahc_aha29160C_setup(struct ahc_softc *ahc)
 static int
 ahc_raid_setup(struct ahc_softc *ahc)
 {
-	printf("RAID functionality unsupported\n");
+	printk("RAID functionality unsupported\n");
 	return (ENXIO);
 }
=20
@@ -2404,7 +2404,7 @@ ahc_aha394XX_setup(struct ahc_softc *ahc)
 		ahc->channel =3D 'B';
 		break;
 	default:
-		printf("adapter at unexpected slot %d\n"
+		printk("adapter at unexpected slot %d\n"
 		       "unable to map to a channel\n",
 		       ahc_get_pci_slot(pci));
 		ahc->channel =3D 'A';
@@ -2429,7 +2429,7 @@ ahc_aha398XX_setup(struct ahc_softc *ahc)
 		ahc->channel =3D 'C';
 		break;
 	default:
-		printf("adapter at unexpected slot %d\n"
+		printk("adapter at unexpected slot %d\n"
 		       "unable to map to a channel\n",
 		       ahc_get_pci_slot(pci));
 		ahc->channel =3D 'A';
@@ -2459,7 +2459,7 @@ ahc_aha494XX_setup(struct ahc_softc *ahc)
 		ahc->channel =3D 'D';
 		break;
 	default:
-		printf("adapter at unexpected slot %d\n"
+		printk("adapter at unexpected slot %d\n"
 		       "unable to map to a channel\n",
 		       ahc_get_pci_slot(pci));
 		ahc->channel =3D 'A';
diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx=
/aic7xxx_proc.c
index e92991a..f2525f8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -248,13 +248,13 @@ ahc_proc_write_seeprom(struct ahc_softc *ahc, cha=
r *buffer, int length)
 		ahc_pause(ahc);
=20
 	if (length !=3D sizeof(struct seeprom_config)) {
-		printf("ahc_proc_write_seeprom: incorrect buffer size\n");
+		printk("ahc_proc_write_seeprom: incorrect buffer size\n");
 		goto done;
 	}
=20
 	have_seeprom =3D ahc_verify_cksum((struct seeprom_config*)buffer);
 	if (have_seeprom =3D=3D 0) {
-		printf("ahc_proc_write_seeprom: cksum verification failed\n");
+		printk("ahc_proc_write_seeprom: cksum verification failed\n");
 		goto done;
 	}
=20
@@ -290,26 +290,25 @@ ahc_proc_write_seeprom(struct ahc_softc *ahc, cha=
r *buffer, int length)
 		sd.sd_DI =3D DI_2840;
 		have_seeprom =3D TRUE;
 	} else {
-		printf("ahc_proc_write_seeprom: unsupported adapter type\n");
+		printk("ahc_proc_write_seeprom: unsupported adapter type\n");
 		goto done;
 	}
=20
 	if (!have_seeprom) {
-		printf("ahc_proc_write_seeprom: No Serial EEPROM\n");
+		printk("ahc_proc_write_seeprom: No Serial EEPROM\n");
 		goto done;
 	} else {
 		u_int start_addr;
=20
 		if (ahc->seep_config =3D=3D NULL) {
-			ahc->seep_config =3D malloc(sizeof(*ahc->seep_config),
-						  M_DEVBUF, M_NOWAIT);
+			ahc->seep_config =3D kmalloc(sizeof(*ahc->seep_config), GFP_ATOMIC)=
;
 			if (ahc->seep_config =3D=3D NULL) {
-				printf("aic7xxx: Unable to allocate serial "
+				printk("aic7xxx: Unable to allocate serial "
 				       "eeprom buffer.  Write failing\n");
 				goto done;
 			}
 		}
-		printf("aic7xxx: Writing Serial EEPROM\n");
+		printk("aic7xxx: Writing Serial EEPROM\n");
 		start_addr =3D 32 * (ahc->channel - 'A');
 		ahc_write_seeprom(&sd, (u_int16_t *)buffer, start_addr,
 				  sizeof(struct seeprom_config)/2);
--=20
1.6.3.3
