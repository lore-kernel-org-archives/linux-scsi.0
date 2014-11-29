From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 6/7] scsi: misc: Merge consecutive seq_puts calls
Date: Sat, 29 Nov 2014 01:34:17 +0100
Message-ID: <1417221258-4937-7-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Consecutive seq_puts calls with literal strings may be replaced by a
single call, saving a little .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/advansys.c      | 40 ++++++++++++++--------------------------
 drivers/scsi/atp870u.c       |  5 ++---
 drivers/scsi/dc395x.c        |  4 ++--
 drivers/scsi/pcmcia/nsp_cs.c |  4 ++--
 4 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 720faea..76e7610 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2903,10 +2903,9 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 	 * the BIOS code segment base address.
 	 */
 	if (boardp->bios_signature != 0x55AA) {
-		seq_puts(m, "Disabled or Pre-3.1\n");
-		seq_puts(m,
-			 "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n");
 		seq_puts(m,
+			 "Disabled or Pre-3.1\n"
+			 "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n"
 			 "can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
 	} else {
 		major = (boardp->bios_version >> 12) & 0xF;
@@ -2923,9 +2922,8 @@ static void asc_prt_adv_bios(struct seq_file *m, struct Scsi_Host *shost)
 		 */
 		if (major < 3 || (major <= 3 && minor < 1) ||
 		    (major <= 3 && minor <= 1 && letter < ('I' - 'A'))) {
-			seq_puts(m,
-				 "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n");
-			seq_puts(m, "ftp://ftp.connectcom.net/pub\n");
+			seq_puts(m, "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n"
+				    "ftp://ftp.connectcom.net/pub\n");
 		}
 	}
 }
@@ -3071,27 +3069,23 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
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
@@ -3410,10 +3404,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
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
@@ -3421,10 +3414,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
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
@@ -3432,10 +3424,9 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
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
@@ -3447,9 +3438,8 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		else
 			seq_printf(m, " %X:N", i);
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Synchronous Transfer:");
+	seq_puts(m, "\n Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3556,9 +3546,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (tagqng_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Queue Limit:");
+	seq_puts(m, "\n Queue Limit:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3570,9 +3559,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	seq_puts(m, "\n");
 
-	seq_puts(m, " Command Pending:");
+	seq_puts(m, "\n Command Pending:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0b02467..603239e 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3101,9 +3101,8 @@ static const char *atp870u_info(struct Scsi_Host *notused)
 
 static int atp870u_show_info(struct seq_file *m, struct Scsi_Host *HBAptr)
 {
-	seq_puts(m, "ACARD AEC-671X Driver Version: 2.6+ac\n");
-	seq_puts(m, "\n");
-	seq_puts(m, "Adapter Configuration:\n");
+	seq_puts(m, "ACARD AEC-671X Driver Version: 2.6+ac\n\n"
+		    "Adapter Configuration:\n");
 	seq_printf(m, "               Base IO: %#.4lx\n", HBAptr->io_port);
 	seq_printf(m, "                   IRQ: %d\n", HBAptr->irq);
 	return 0;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 613a773..baff2d9 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4623,8 +4623,8 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 	unsigned long flags;
 	int dev;
 
-	seq_puts(m, DC395X_BANNER " PCI SCSI Host Adapter\n");
-	seq_puts(m, " Driver Version " DC395X_VERSION "\n");
+	seq_puts(m, DC395X_BANNER " PCI SCSI Host Adapter\n"
+		    " Driver Version " DC395X_VERSION "\n");
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index bf883a6..b0c8643 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1375,8 +1375,8 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 	hostno = host->host_no;
 	data = (nsp_hw_data *)host->hostdata;
 
-	seq_puts(m, "NinjaSCSI status\n\n");
-	seq_puts(m, "Driver version:        $Revision: 1.23 $\n");
+	seq_puts(m, "NinjaSCSI status\n\n"
+		    "Driver version:        $Revision: 1.23 $\n");
 	seq_printf(m, "SCSI host No.:         %d\n",          hostno);
 	seq_printf(m, "IRQ:                   %d\n",          host->irq);
 	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
-- 
2.0.4
