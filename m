From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 2/6] scsi/advansys: Replace seq_printf with seq_puts
Date: Wed,  3 Dec 2014 00:10:50 +0100
Message-ID: <1417561854-17188-3-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
 <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-scsi@vger.kernel.org

Using seq_printf to print a simple string is a lot more expensive than
it needs to be, since seq_puts exists. Replace seq_printf with
seq_puts when possible.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/advansys.c | 155 +++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 6719a33..d31fc6d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2880,7 +2880,7 @@ static void asc_prt_board_devices(struct seq_file *m, struct Scsi_Host *shost)
 		chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
 	}
 
-	seq_printf(m, "Target IDs Detected:");
+	seq_puts(m, "Target IDs Detected:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if (boardp->init_tidmask & ADV_TID_TO_TIDMASK(i))
 			seq_printf(m, " %X,", i);
@@ -2896,18 +2896,18 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 	struct asc_board *boardp = shost_priv(shost);
 	ushort major, minor, letter;
 
-	seq_printf(m, "\nROM BIOS Version: ");
+	seq_puts(m, "\nROM BIOS Version: ");
 
 	/*
 	 * If the BIOS saved a valid signature, then fill in
 	 * the BIOS code segment base address.
 	 */
 	if (boardp->bios_signature != 0x55AA) {
-		seq_printf(m, "Disabled or Pre-3.1\n");
-		seq_printf(m,
-			  "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n");
-		seq_printf(m,
-			  "can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
+		seq_puts(m, "Disabled or Pre-3.1\n");
+		seq_puts(m,
+			 "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n");
+		seq_puts(m,
+			 "can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
 	} else {
 		major = (boardp->bios_version >> 12) & 0xF;
 		minor = (boardp->bios_version >> 8) & 0xF;
@@ -2923,10 +2923,9 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 		 */
 		if (major < 3 || (major <= 3 && minor < 1) ||
 		    (major <= 3 && minor <= 1 && letter < ('I' - 'A'))) {
-			seq_printf(m,
-				   "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n");
-			seq_printf(m,
-				   "ftp://ftp.connectcom.net/pub\n");
+			seq_puts(m,
+				 "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n");
+			seq_puts(m, "ftp://ftp.connectcom.net/pub\n");
 		}
 	}
 }
@@ -3056,11 +3055,10 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	    == ASC_TRUE)
 		seq_printf(m, " Serial Number: %s\n", serialstr);
 	else if (ep->adapter_info[5] == 0xBB)
-		seq_printf(m,
-			   " Default Settings Used for EEPROM-less Adapter.\n");
+		seq_puts(m,
+			 " Default Settings Used for EEPROM-less Adapter.\n");
 	else
-		seq_printf(m,
-			   " Serial Number Signature Not Present.\n");
+		seq_puts(m, " Serial Number Signature Not Present.\n");
 
 	seq_printf(m,
 		   " Host SCSI ID: %u, Host Queue Size: %u, Device Queue Size: %u\n",
@@ -3070,34 +3068,34 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	seq_printf(m,
 		   " cntl 0x%x, no_scam 0x%x\n", ep->cntl, ep->no_scam);
 
-	seq_printf(m, " Target ID:           ");
+	seq_puts(m, " Target ID:           ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %d", i);
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Disconnects:         ");
+	seq_puts(m, " Disconnects:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->disc_enable & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Command Queuing:     ");
+	seq_puts(m, " Command Queuing:     ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->use_cmd_qng & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Start Motor:         ");
+	seq_puts(m, " Start Motor:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->start_motor & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Synchronous Transfer:");
+	seq_puts(m, " Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 #ifdef CONFIG_ISA
 	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
@@ -3151,7 +3149,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	if (asc_get_eeprom_string(wordp, serialstr) == ASC_TRUE)
 		seq_printf(m, " Serial Number: %s\n", serialstr);
 	else
-		seq_printf(m, " Serial Number Signature Not Present.\n");
+		seq_puts(m, " Serial Number Signature Not Present.\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550)
 		seq_printf(m,
@@ -3209,10 +3207,10 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 			   ep_38C1600->termination_lvd, termstr,
 			   ep_38C1600->bios_ctrl);
 
-	seq_printf(m, " Target ID:           ");
+	seq_puts(m, " Target ID:           ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %X", i);
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->disc_enable;
@@ -3221,11 +3219,11 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	} else {
 		word = ep_38C1600->disc_enable;
 	}
-	seq_printf(m, " Disconnects:         ");
+	seq_puts(m, " Disconnects:         ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->tagqng_able;
@@ -3234,11 +3232,11 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	} else {
 		word = ep_38C1600->tagqng_able;
 	}
-	seq_printf(m, " Command Queuing:     ");
+	seq_puts(m, " Command Queuing:     ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->start_motor;
@@ -3247,28 +3245,28 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	} else {
 		word = ep_38C1600->start_motor;
 	}
-	seq_printf(m, " Start Motor:         ");
+	seq_puts(m, " Start Motor:         ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		seq_printf(m, " Synchronous Transfer:");
+		seq_puts(m, " Synchronous Transfer:");
 		for (i = 0; i <= ADV_MAX_TID; i++)
 			seq_printf(m, " %c",
 				   (ep_3550->sdtr_able & ADV_TID_TO_TIDMASK(i)) ?
 				   'Y' : 'N');
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		seq_printf(m, " Ultra Transfer:      ");
+		seq_puts(m, " Ultra Transfer:      ");
 		for (i = 0; i <= ADV_MAX_TID; i++)
 			seq_printf(m, " %c",
 				   (ep_3550->ultra_able & ADV_TID_TO_TIDMASK(i))
 				   ? 'Y' : 'N');
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
@@ -3278,16 +3276,15 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	} else {
 		word = ep_38C1600->wdtr_able;
 	}
-	seq_printf(m, " Wide Transfer:       ");
+	seq_puts(m, " Wide Transfer:       ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800 ||
 	    adv_dvc_varp->chip_type == ADV_CHIP_ASC38C1600) {
-		seq_printf(m,
-			   " Synchronous Transfer Speed (Mhz):\n  ");
+		seq_puts(m, " Synchronous Transfer Speed (Mhz):\n  ");
 		for (i = 0; i <= ADV_MAX_TID; i++) {
 			char *speed_str;
 
@@ -3325,10 +3322,10 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 			}
 			seq_printf(m, "%X:%s ", i, speed_str);
 			if (i == 7)
-				seq_printf(m, "\n  ");
+				seq_puts(m, "\n  ");
 			sdtr_speed >>= 4;
 		}
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 }
 
@@ -3403,7 +3400,7 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 	seq_printf(m,
 		   " Total Command Pending: %d\n", v->cur_total_qng);
 
-	seq_printf(m, " Command Queuing:");
+	seq_puts(m, " Command Queuing:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3413,10 +3410,10 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (v->use_tagged_qng & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	/* Current number of commands waiting for a device. */
-	seq_printf(m, " Command Queue Pending:");
+	seq_puts(m, " Command Queue Pending:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3424,10 +3421,10 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 		seq_printf(m, " %X:%u", i, v->cur_dvc_qng[i]);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	/* Current limit on number of commands that can be sent to a device. */
-	seq_printf(m, " Command Queue Limit:");
+	seq_puts(m, " Command Queue Limit:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3435,10 +3432,10 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 		seq_printf(m, " %X:%u", i, v->max_dvc_qng[i]);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	/* Indicate whether the device has returned queue full status. */
-	seq_printf(m, " Command Queue Full:");
+	seq_puts(m, " Command Queue Full:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3450,9 +3447,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		else
 			seq_printf(m, " %X:N", i);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Synchronous Transfer:");
+	seq_puts(m, " Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3462,7 +3459,7 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (v->sdtr_done & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		uchar syn_period_ix;
@@ -3476,7 +3473,7 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		seq_printf(m, "  %X:", i);
 
 		if ((boardp->sdtr_data[i] & ASC_SYN_MAX_OFFSET) == 0) {
-			seq_printf(m, " Asynchronous");
+			seq_puts(m, " Asynchronous");
 		} else {
 			syn_period_ix =
 			    (boardp->sdtr_data[i] >> 4) & (v->max_sdtr_index -
@@ -3494,16 +3491,15 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 
 		if ((v->sdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			seq_printf(m, "*\n");
+			seq_puts(m, "*\n");
 			renegotiate = 1;
 		} else {
-			seq_printf(m, "\n");
+			seq_puts(m, "\n");
 		}
 	}
 
 	if (renegotiate) {
-		seq_printf(m,
-			   " * = Re-negotiation pending before next command.\n");
+		seq_puts(m, " * = Re-negotiation pending before next command.\n");
 	}
 }
 
@@ -3548,7 +3544,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		   c->mcode_date, c->mcode_version);
 
 	AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
-	seq_printf(m, " Queuing Enabled:");
+	seq_puts(m, " Queuing Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3559,9 +3555,9 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (tagqng_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Queue Limit:");
+	seq_puts(m, " Queue Limit:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3573,9 +3569,9 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
-	seq_printf(m, " Command Pending:");
+	seq_puts(m, " Command Pending:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3587,10 +3583,10 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
-	seq_printf(m, " Wide Enabled:");
+	seq_puts(m, " Wide Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3601,10 +3597,10 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (wdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, wdtr_done);
-	seq_printf(m, " Transfer Bit Width:");
+	seq_puts(m, " Transfer Bit Width:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3620,14 +3616,14 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		if ((wdtr_able & ADV_TID_TO_TIDMASK(i)) &&
 		    (wdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			seq_printf(m, "*");
+			seq_puts(m, "*");
 			renegotiate = 1;
 		}
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
-	seq_printf(m, " Synchronous Enabled:");
+	seq_puts(m, " Synchronous Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3638,7 +3634,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (sdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, sdtr_done);
 	for (i = 0; i <= ADV_MAX_TID; i++) {
@@ -3657,14 +3653,14 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		seq_printf(m, "  %X:", i);
 
 		if ((lramword & 0x1F) == 0) {	/* Check for REQ/ACK Offset 0. */
-			seq_printf(m, " Asynchronous");
+			seq_puts(m, " Asynchronous");
 		} else {
-			seq_printf(m, " Transfer Period Factor: ");
+			seq_puts(m, " Transfer Period Factor: ");
 
 			if ((lramword & 0x1F00) == 0x1100) {	/* 80 Mhz */
-				seq_printf(m, "9 (80.0 Mhz),");
+				seq_puts(m, "9 (80.0 Mhz),");
 			} else if ((lramword & 0x1F00) == 0x1000) {	/* 40 Mhz */
-				seq_printf(m, "10 (40.0 Mhz),");
+				seq_puts(m, "10 (40.0 Mhz),");
 			} else {	/* 20 Mhz or below. */
 
 				period = (((lramword >> 8) * 25) + 50) / 4;
@@ -3684,16 +3680,15 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 
 		if ((sdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			seq_printf(m, "*\n");
+			seq_puts(m, "*\n");
 			renegotiate = 1;
 		} else {
-			seq_printf(m, "\n");
+			seq_puts(m, "\n");
 		}
 	}
 
 	if (renegotiate) {
-		seq_printf(m,
-			   " * = Re-negotiation pending before next command.\n");
+		seq_puts(m, " * = Re-negotiation pending before next command.\n");
 	}
 }
 
-- 
2.0.4
