From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 5/6] scsi: misc: Merge consecutive seq_puts calls
Date: Wed,  3 Dec 2014 00:10:53 +0100
Message-ID: <1417561854-17188-6-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
 <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:45849 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529AbaLBXMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 18:12:10 -0500
Received: by mail-la0-f45.google.com with SMTP id gq15so11481679lab.4
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2014 15:12:08 -0800 (PST)
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>

Consecutive seq_puts calls with literal strings may be replaced by a
single call, saving a little .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/advansys.c      | 43 +++++++++++++++----------------------------
 drivers/scsi/atp870u.c       |  5 ++---
 drivers/scsi/dc395x.c        |  4 ++--
 drivers/scsi/pcmcia/nsp_cs.c |  4 ++--
 4 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d31fc6d..c4d0910 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2903,11 +2903,9 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 	 * the BIOS code segment base address.
 	 */
 	if (boardp->bios_signature != 0x55AA) {
-		seq_puts(m, "Disabled or Pre-3.1\n");
-		seq_puts(m,
-			 "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n");
-		seq_puts(m,
-			 "can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
+		seq_puts(m, "Disabled or Pre-3.1\n"
+			"BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n"
+			"can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
 	} else {
 		major = (boardp->bios_version >> 12) & 0xF;
 		minor = (boardp->bios_version >> 8) & 0xF;
@@ -2923,9 +2921,8 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 		 */
 		if (major < 3 || (major <= 3 && minor < 1) ||
 		    (major <= 3 && minor <= 1 && letter < ('I' - 'A'))) {
-			seq_puts(m,
-				 "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n");
-			seq_puts(m, "ftp://ftp.connectcom.net/pub\n");
+			seq_puts(m, "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n"
+				"ftp://ftp.connectcom.net/pub\n");
 		}
 	}
 }
@@ -3071,27 +3068,23 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	seq_puts(m, " Target ID:           ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %d", i);
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Disconnects:         ");
+	seq_puts(m, "\n Disconnects:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->disc_enable & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Command Queuing:     ");
+	seq_puts(m, "\n Command Queuing:     ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->use_cmd_qng & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Start Motor:         ");
+	seq_puts(m, "\n Start Motor:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->start_motor & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Synchronous Transfer:");
+	seq_puts(m, "\n Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
@@ -3410,10 +3403,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (v->use_tagged_qng & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
 
 	/* Current number of commands waiting for a device. */
-	seq_puts(m, " Command Queue Pending:");
+	seq_puts(m, "\n Command Queue Pending:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3421,10 +3413,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 		seq_printf(m, " %X:%u", i, v->cur_dvc_qng[i]);
 	}
-	seq_puts(m, "\n");
 
 	/* Current limit on number of commands that can be sent to a device. */
-	seq_puts(m, " Command Queue Limit:");
+	seq_puts(m, "\n Command Queue Limit:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3432,10 +3423,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		}
 		seq_printf(m, " %X:%u", i, v->max_dvc_qng[i]);
 	}
-	seq_puts(m, "\n");
 
 	/* Indicate whether the device has returned queue full status. */
-	seq_puts(m, " Command Queue Full:");
+	seq_puts(m, "\n Command Queue Full:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3447,9 +3437,8 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		else
 			seq_printf(m, " %X:N", i);
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Synchronous Transfer:");
+	seq_puts(m, "\n Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3555,9 +3544,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (tagqng_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Queue Limit:");
+	seq_puts(m, "\n Queue Limit:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3569,9 +3557,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Command Pending:");
+	seq_puts(m, "\n Command Pending:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0b02467..0836433 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3101,9 +3101,8 @@ static const char *atp870u_info(struct Scsi_Host *notused)
 
 static int atp870u_show_info(struct seq_file *m, struct Scsi_Host *HBAptr)
 {
-	seq_puts(m, "ACARD AEC-671X Driver Version: 2.6+ac\n");
-	seq_puts(m, "\n");
-	seq_puts(m, "Adapter Configuration:\n");
+	seq_puts(m, "ACARD AEC-671X Driver Version: 2.6+ac\n\n"
+		"Adapter Configuration:\n");
 	seq_printf(m, "               Base IO: %#.4lx\n", HBAptr->io_port);
 	seq_printf(m, "                   IRQ: %d\n", HBAptr->irq);
 	return 0;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 3a55ea2..48c79f9 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4623,8 +4623,8 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 	unsigned long flags;
 	int dev;
 
-	seq_puts(m, DC395X_BANNER " PCI SCSI Host Adapter\n");
-	seq_puts(m, " Driver Version " DC395X_VERSION "\n");
+	seq_puts(m, DC395X_BANNER " PCI SCSI Host Adapter\n"
+		" Driver Version " DC395X_VERSION "\n");
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index bf883a6..acf558a 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1375,8 +1375,8 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 	hostno = host->host_no;
 	data = (nsp_hw_data *)host->hostdata;
 
-	seq_puts(m, "NinjaSCSI status\n\n");
-	seq_puts(m, "Driver version:        $Revision: 1.23 $\n");
+	seq_puts(m, "NinjaSCSI status\n\n"
+		"Driver version:        $Revision: 1.23 $\n");
 	seq_printf(m, "SCSI host No.:         %d\n",          hostno);
 	seq_printf(m, "IRQ:                   %d\n",          host->irq);
 	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
-- 
2.0.4

