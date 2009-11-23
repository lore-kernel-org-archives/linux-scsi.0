From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 19/27] scsi proc_fops: convert advansys
Date: Mon, 23 Nov 2009 04:43:13 +0300
Message-ID: <20091123014313.GS31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65042 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZKWBob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:44:31 -0500
Received: by ewy19 with SMTP id 19so1403526ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:44:36 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

As side effect, should fix output corruption when two processes read
from same proc file, see struct asc_board::prtbuf.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/advansys.c |  825 ++++++++++--------------------------------------
 1 file changed, 182 insertions(+), 643 deletions(-)

--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -36,6 +36,7 @@
 #include <linux/isa.h>
 #include <linux/eisa.h>
 #include <linux/pci.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/firmware.h>
@@ -2179,22 +2180,6 @@ do { \
 
 #define ASC_INFO_SIZE           128	/* advansys_info() line size */
 
-#ifdef CONFIG_PROC_FS
-/* /proc/scsi/advansys/[0...] related definitions */
-#define ASC_PRTBUF_SIZE         2048
-#define ASC_PRTLINE_SIZE        160
-
-#define ASC_PRT_NEXT() \
-    if (cp) { \
-        totlen += len; \
-        leftlen -= len; \
-        if (leftlen == 0) { \
-            return totlen; \
-        } \
-        cp += len; \
-    }
-#endif /* CONFIG_PROC_FS */
-
 /* Asc Library return codes */
 #define ASC_TRUE        1
 #define ASC_FALSE       0
@@ -2384,8 +2369,6 @@ struct asc_board {
 		ADVEEP_38C1600_CONFIG adv_38C1600_eep;	/* 38C1600 EEPROM config. */
 	} eep_config;
 	ulong last_reset;	/* Saved last reset time */
-	/* /proc/scsi/advansys/[0...] */
-	char *prtbuf;		/* /proc print buffer */
 #ifdef ADVANSYS_STATS
 	struct asc_stats asc_stats;	/* Board statistics */
 #endif				/* ADVANSYS_STATS */
@@ -2877,63 +2860,19 @@ static const char *advansys_info(struct Scsi_Host *shost)
 
 #ifdef CONFIG_PROC_FS
 /*
- * asc_prt_line()
- *
- * If 'cp' is NULL print to the console, otherwise print to a buffer.
- *
- * Return 0 if printing to the console, otherwise return the number of
- * bytes written to the buffer.
- *
- * Note: If any single line is greater than ASC_PRTLINE_SIZE bytes the stack
- * will be corrupted. 's[]' is defined to be ASC_PRTLINE_SIZE bytes.
- */
-static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
-{
-	va_list args;
-	int ret;
-	char s[ASC_PRTLINE_SIZE];
-
-	va_start(args, fmt);
-	ret = vsprintf(s, fmt, args);
-	BUG_ON(ret >= ASC_PRTLINE_SIZE);
-	if (buf == NULL) {
-		(void)printk(s);
-		ret = 0;
-	} else {
-		ret = min(buflen, ret);
-		memcpy(buf, s, ret);
-	}
-	va_end(args);
-	return ret;
-}
-
-/*
  * asc_prt_board_devices()
  *
  * Print driver information for devices attached to the board.
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_board_devices(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	int leftlen;
-	int totlen;
-	int len;
 	int chip_scsi_id;
 	int i;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nDevice Information for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		chip_scsi_id = boardp->dvc_cfg.asc_dvc_cfg.chip_scsi_id;
@@ -2941,59 +2880,43 @@ static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
 		chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
 	}
 
-	len = asc_prt_line(cp, leftlen, "Target IDs Detected:");
-	ASC_PRT_NEXT();
+	seq_printf(m, "Target IDs Detected:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if (boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) {
-			len = asc_prt_line(cp, leftlen, " %X,", i);
-			ASC_PRT_NEXT();
+			seq_printf(m, " %X,", i);
 		}
 	}
-	len = asc_prt_line(cp, leftlen, " (%X=Host Adapter)\n", chip_scsi_id);
-	ASC_PRT_NEXT();
-
-	return totlen;
+	seq_printf(m, " (%X=Host Adapter)\n", chip_scsi_id);
 }
 
 /*
  * Display Wide Board BIOS Information.
  */
-static int asc_prt_adv_bios(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_adv_bios(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	int leftlen;
-	int totlen;
-	int len;
 	ushort major, minor, letter;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen, "\nROM BIOS Version: ");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\nROM BIOS Version: ");
 
 	/*
 	 * If the BIOS saved a valid signature, then fill in
 	 * the BIOS code segment base address.
 	 */
 	if (boardp->bios_signature != 0x55AA) {
-		len = asc_prt_line(cp, leftlen, "Disabled or Pre-3.1\n");
-		ASC_PRT_NEXT();
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m, "Disabled or Pre-3.1\n");
+		seq_printf(m,
 				   "BIOS either disabled or Pre-3.1. If it is pre-3.1, then a newer version\n");
-		ASC_PRT_NEXT();
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   "can be found at the ConnectCom FTP site: ftp://ftp.connectcom.net/pub\n");
-		ASC_PRT_NEXT();
 	} else {
 		major = (boardp->bios_version >> 12) & 0xF;
 		minor = (boardp->bios_version >> 8) & 0xF;
 		letter = (boardp->bios_version & 0xFF);
 
-		len = asc_prt_line(cp, leftlen, "%d.%d%c\n",
+		seq_printf(m, "%d.%d%c\n",
 				   major, minor,
 				   letter >= 26 ? '?' : letter + 'A');
-		ASC_PRT_NEXT();
 
 		/*
 		 * Current available ROM BIOS release is 3.1I for UW
@@ -3002,16 +2925,12 @@ static int asc_prt_adv_bios(struct Scsi_Host *shost, char *cp, int cplen)
 		 */
 		if (major < 3 || (major <= 3 && minor < 1) ||
 		    (major <= 3 && minor <= 1 && letter < ('I' - 'A'))) {
-			len = asc_prt_line(cp, leftlen,
+			seq_printf(m,
 					   "Newer version of ROM BIOS is available at the ConnectCom FTP site:\n");
-			ASC_PRT_NEXT();
-			len = asc_prt_line(cp, leftlen,
+			seq_printf(m,
 					   "ftp://ftp.connectcom.net/pub\n");
-			ASC_PRT_NEXT();
 		}
 	}
-
-	return totlen;
 }
 
 /*
@@ -3116,20 +3035,11 @@ static int asc_get_eeprom_string(ushort *serialnum, uchar *cp)
  * asc_prt_asc_board_eeprom()
  *
  * Print board EEPROM configuration.
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_asc_board_eeprom(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
-	int leftlen;
-	int totlen;
-	int len;
 	ASCEEP_CONFIG *ep;
 	int i;
 #ifdef CONFIG_ISA
@@ -3140,129 +3050,91 @@ static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 	ep = &boardp->eep_config.asc_eep;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nEEPROM Settings for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
 	if (asc_get_eeprom_string((ushort *)&ep->adapter_info[0], serialstr)
 	    == ASC_TRUE) {
-		len =
-		    asc_prt_line(cp, leftlen, " Serial Number: %s\n",
-				 serialstr);
-		ASC_PRT_NEXT();
+		seq_printf(m, " Serial Number: %s\n", serialstr);
 	} else {
 		if (ep->adapter_info[5] == 0xBB) {
-			len = asc_prt_line(cp, leftlen,
+			seq_printf(m,
 					   " Default Settings Used for EEPROM-less Adapter.\n");
-			ASC_PRT_NEXT();
 		} else {
-			len = asc_prt_line(cp, leftlen,
+			seq_printf(m,
 					   " Serial Number Signature Not Present.\n");
-			ASC_PRT_NEXT();
 		}
 	}
 
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   " Host SCSI ID: %u, Host Queue Size: %u, Device Queue Size: %u\n",
 			   ASC_EEP_GET_CHIP_ID(ep), ep->max_total_qng,
 			   ep->max_tag_qng);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   " cntl 0x%x, no_scam 0x%x\n", ep->cntl, ep->no_scam);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen, " Target ID:           ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Target ID:           ");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %d", i);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %d", i);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Disconnects:         ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Disconnects:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (ep->
 				    disc_enable & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Command Queuing:     ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queuing:     ");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (ep->
 				    use_cmd_qng & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Start Motor:         ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Start Motor:         ");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (ep->
 				    start_motor & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Synchronous Transfer:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (ep->
 				    init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 #ifdef CONFIG_ISA
 	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Host ISA DMA speed:   %d MB/S\n",
 				   isa_dma_speed[ASC_EEP_GET_DMA_SPD(ep)]);
-		ASC_PRT_NEXT();
 	}
 #endif /* CONFIG_ISA */
-
-	return totlen;
 }
 
 /*
  * asc_prt_adv_board_eeprom()
  *
  * Print board EEPROM configuration.
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_adv_board_eeprom(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
 	ADV_DVC_VAR *adv_dvc_varp;
-	int leftlen;
-	int totlen;
-	int len;
 	int i;
 	char *termstr;
 	uchar serialstr[13];
@@ -3282,13 +3154,9 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 		ep_38C1600 = &boardp->eep_config.adv_38C1600_eep;
 	}
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nEEPROM Settings for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		wordp = &ep_3550->serial_number_word1;
@@ -3299,36 +3167,29 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	}
 
 	if (asc_get_eeprom_string(wordp, serialstr) == ASC_TRUE) {
-		len =
-		    asc_prt_line(cp, leftlen, " Serial Number: %s\n",
-				 serialstr);
-		ASC_PRT_NEXT();
+		seq_printf(m, " Serial Number: %s\n", serialstr);
 	} else {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Serial Number Signature Not Present.\n");
-		ASC_PRT_NEXT();
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Host SCSI ID: %u, Host Queue Size: %u, Device Queue Size: %u\n",
 				   ep_3550->adapter_scsi_id,
 				   ep_3550->max_host_qng, ep_3550->max_dvc_qng);
-		ASC_PRT_NEXT();
 	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Host SCSI ID: %u, Host Queue Size: %u, Device Queue Size: %u\n",
 				   ep_38C0800->adapter_scsi_id,
 				   ep_38C0800->max_host_qng,
 				   ep_38C0800->max_dvc_qng);
-		ASC_PRT_NEXT();
 	} else {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Host SCSI ID: %u, Host Queue Size: %u, Device Queue Size: %u\n",
 				   ep_38C1600->adapter_scsi_id,
 				   ep_38C1600->max_host_qng,
 				   ep_38C1600->max_dvc_qng);
-		ASC_PRT_NEXT();
 	}
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->termination;
@@ -3354,33 +3215,27 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " termination: %u (%s), bios_ctrl: 0x%x\n",
 				   ep_3550->termination, termstr,
 				   ep_3550->bios_ctrl);
-		ASC_PRT_NEXT();
 	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " termination: %u (%s), bios_ctrl: 0x%x\n",
 				   ep_38C0800->termination_lvd, termstr,
 				   ep_38C0800->bios_ctrl);
-		ASC_PRT_NEXT();
 	} else {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " termination: %u (%s), bios_ctrl: 0x%x\n",
 				   ep_38C1600->termination_lvd, termstr,
 				   ep_38C1600->bios_ctrl);
-		ASC_PRT_NEXT();
 	}
 
-	len = asc_prt_line(cp, leftlen, " Target ID:           ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Target ID:           ");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %X", i);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %X", i);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->disc_enable;
@@ -3389,15 +3244,12 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	} else {
 		word = ep_38C1600->disc_enable;
 	}
-	len = asc_prt_line(cp, leftlen, " Disconnects:         ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Disconnects:         ");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->tagqng_able;
@@ -3406,15 +3258,12 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	} else {
 		word = ep_38C1600->tagqng_able;
 	}
-	len = asc_prt_line(cp, leftlen, " Command Queuing:     ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queuing:     ");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->start_motor;
@@ -3423,42 +3272,33 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	} else {
 		word = ep_38C1600->start_motor;
 	}
-	len = asc_prt_line(cp, leftlen, " Start Motor:         ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Start Motor:         ");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		len = asc_prt_line(cp, leftlen, " Synchronous Transfer:");
-		ASC_PRT_NEXT();
+		seq_printf(m, " Synchronous Transfer:");
 		for (i = 0; i <= ADV_MAX_TID; i++) {
-			len = asc_prt_line(cp, leftlen, " %c",
+			seq_printf(m, " %c",
 					   (ep_3550->
 					    sdtr_able & ADV_TID_TO_TIDMASK(i)) ?
 					   'Y' : 'N');
-			ASC_PRT_NEXT();
 		}
-		len = asc_prt_line(cp, leftlen, "\n");
-		ASC_PRT_NEXT();
+		seq_printf(m, "\n");
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		len = asc_prt_line(cp, leftlen, " Ultra Transfer:      ");
-		ASC_PRT_NEXT();
+		seq_printf(m, " Ultra Transfer:      ");
 		for (i = 0; i <= ADV_MAX_TID; i++) {
-			len = asc_prt_line(cp, leftlen, " %c",
+			seq_printf(m, " %c",
 					   (ep_3550->
 					    ultra_able & ADV_TID_TO_TIDMASK(i))
 					   ? 'Y' : 'N');
-			ASC_PRT_NEXT();
 		}
-		len = asc_prt_line(cp, leftlen, "\n");
-		ASC_PRT_NEXT();
+		seq_printf(m, "\n");
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
@@ -3468,21 +3308,17 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	} else {
 		word = ep_38C1600->wdtr_able;
 	}
-	len = asc_prt_line(cp, leftlen, " Wide Transfer:       ");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Wide Transfer:       ");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
-		len = asc_prt_line(cp, leftlen, " %c",
+		seq_printf(m, " %c",
 				   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800 ||
 	    adv_dvc_varp->chip_type == ADV_CHIP_ASC38C1600) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " Synchronous Transfer Speed (Mhz):\n  ");
-		ASC_PRT_NEXT();
 		for (i = 0; i <= ADV_MAX_TID; i++) {
 			char *speed_str;
 
@@ -3518,99 +3354,65 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 				speed_str = "Unk";
 				break;
 			}
-			len = asc_prt_line(cp, leftlen, "%X:%s ", i, speed_str);
-			ASC_PRT_NEXT();
+			seq_printf(m, "%X:%s ", i, speed_str);
 			if (i == 7) {
-				len = asc_prt_line(cp, leftlen, "\n  ");
-				ASC_PRT_NEXT();
+				seq_printf(m, "\n  ");
 			}
 			sdtr_speed >>= 4;
 		}
-		len = asc_prt_line(cp, leftlen, "\n");
-		ASC_PRT_NEXT();
+		seq_printf(m, "\n");
 	}
-
-	return totlen;
 }
 
 /*
  * asc_prt_driver_conf()
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_driver_conf(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	int leftlen;
-	int totlen;
-	int len;
 	int chip_scsi_id;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nLinux Driver Configuration and Information for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " host_busy %u, last_reset %u, max_id %u, max_lun %u, max_channel %u\n",
+	seq_printf(m,
+			   " host_busy %u, last_reset %lu, max_id %u, max_lun %u, max_channel %u\n",
 			   shost->host_busy, shost->last_reset, shost->max_id,
 			   shost->max_lun, shost->max_channel);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   " unique_id %d, can_queue %d, this_id %d, sg_tablesize %u, cmd_per_lun %u\n",
 			   shost->unique_id, shost->can_queue, shost->this_id,
 			   shost->sg_tablesize, shost->cmd_per_lun);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   " unchecked_isa_dma %d, use_clustering %d\n",
 			   shost->unchecked_isa_dma, shost->use_clustering);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " flags 0x%x, last_reset 0x%x, jiffies 0x%x, asc_n_io_port 0x%x\n",
+	seq_printf(m,
+			   " flags 0x%x, last_reset 0x%lx, jiffies 0x%lx, asc_n_io_port 0x%x\n",
 			   boardp->flags, boardp->last_reset, jiffies,
 			   boardp->asc_n_io_port);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen, " io_port 0x%x\n", shost->io_port);
-	ASC_PRT_NEXT();
+	seq_printf(m, " io_port 0x%lx\n", shost->io_port);
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		chip_scsi_id = boardp->dvc_cfg.asc_dvc_cfg.chip_scsi_id;
 	} else {
 		chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
 	}
-
-	return totlen;
 }
 
 /*
  * asc_prt_asc_board_info()
  *
  * Print dynamic board configuration information.
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_asc_board_info(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
 	int chip_scsi_id;
-	int leftlen;
-	int totlen;
-	int len;
 	ASC_DVC_VAR *v;
 	ASC_DVC_CFG *c;
 	int i;
@@ -3620,105 +3422,84 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 	c = &boardp->dvc_cfg.asc_dvc_cfg;
 	chip_scsi_id = c->chip_scsi_id;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nAsc Library Configuration and Statistics for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen, " chip_version %u, mcode_date 0x%x, "
+	seq_printf(m, " chip_version %u, mcode_date 0x%x, "
 			   "mcode_version 0x%x, err_code %u\n",
 			   c->chip_version, c->mcode_date, c->mcode_version,
 			   v->err_code);
-	ASC_PRT_NEXT();
 
 	/* Current number of commands waiting for the host. */
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   " Total Command Pending: %d\n", v->cur_total_qng);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen, " Command Queuing:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queuing:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
-		len = asc_prt_line(cp, leftlen, " %X:%c",
+		seq_printf(m, " %X:%c",
 				   i,
 				   (v->
 				    use_tagged_qng & ADV_TID_TO_TIDMASK(i)) ?
 				   'Y' : 'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	/* Current number of commands waiting for a device. */
-	len = asc_prt_line(cp, leftlen, " Command Queue Pending:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queue Pending:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
-		len = asc_prt_line(cp, leftlen, " %X:%u", i, v->cur_dvc_qng[i]);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %X:%u", i, v->cur_dvc_qng[i]);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	/* Current limit on number of commands that can be sent to a device. */
-	len = asc_prt_line(cp, leftlen, " Command Queue Limit:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queue Limit:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
-		len = asc_prt_line(cp, leftlen, " %X:%u", i, v->max_dvc_qng[i]);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %X:%u", i, v->max_dvc_qng[i]);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	/* Indicate whether the device has returned queue full status. */
-	len = asc_prt_line(cp, leftlen, " Command Queue Full:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Queue Full:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
 		if (boardp->queue_full & ADV_TID_TO_TIDMASK(i)) {
-			len = asc_prt_line(cp, leftlen, " %X:Y-%d",
+			seq_printf(m, " %X:Y-%d",
 					   i, boardp->queue_full_cnt[i]);
 		} else {
-			len = asc_prt_line(cp, leftlen, " %X:N", i);
+			seq_printf(m, " %X:N", i);
 		}
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Synchronous Transfer:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Synchronous Transfer:");
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
-		len = asc_prt_line(cp, leftlen, " %X:%c",
+		seq_printf(m, " %X:%c",
 				   i,
 				   (v->
 				    sdtr_done & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		uchar syn_period_ix;
@@ -3729,18 +3510,16 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 			continue;
 		}
 
-		len = asc_prt_line(cp, leftlen, "  %X:", i);
-		ASC_PRT_NEXT();
+		seq_printf(m, "  %X:", i);
 
 		if ((boardp->sdtr_data[i] & ASC_SYN_MAX_OFFSET) == 0) {
-			len = asc_prt_line(cp, leftlen, " Asynchronous");
-			ASC_PRT_NEXT();
+			seq_printf(m, " Asynchronous");
 		} else {
 			syn_period_ix =
 			    (boardp->sdtr_data[i] >> 4) & (v->max_sdtr_index -
 							   1);
 
-			len = asc_prt_line(cp, leftlen,
+			seq_printf(m,
 					   " Transfer Period Factor: %d (%d.%d Mhz),",
 					   v->sdtr_period_tbl[syn_period_ix],
 					   250 /
@@ -3749,49 +3528,34 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 						      v->
 						      sdtr_period_tbl
 						      [syn_period_ix]));
-			ASC_PRT_NEXT();
 
-			len = asc_prt_line(cp, leftlen, " REQ/ACK Offset: %d",
+			seq_printf(m, " REQ/ACK Offset: %d",
 					   boardp->
 					   sdtr_data[i] & ASC_SYN_MAX_OFFSET);
-			ASC_PRT_NEXT();
 		}
 
 		if ((v->sdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			len = asc_prt_line(cp, leftlen, "*\n");
+			seq_printf(m, "*\n");
 			renegotiate = 1;
 		} else {
-			len = asc_prt_line(cp, leftlen, "\n");
+			seq_printf(m, "\n");
 		}
-		ASC_PRT_NEXT();
 	}
 
 	if (renegotiate) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " * = Re-negotiation pending before next command.\n");
-		ASC_PRT_NEXT();
 	}
-
-	return totlen;
 }
 
 /*
  * asc_prt_adv_board_info()
  *
  * Print dynamic board configuration information.
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_adv_board_info(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	int leftlen;
-	int totlen;
-	int len;
 	int i;
 	ADV_DVC_VAR *v;
 	ADV_DVC_CFG *c;
@@ -3810,47 +3574,37 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 	iop_base = v->iop_base;
 	chip_scsi_id = v->chip_scsi_id;
 
-	leftlen = cplen;
-	totlen = len = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nAdv Library Configuration and Statistics for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " iop_base 0x%lx, cable_detect: %X, err_code %u\n",
+	seq_printf(m,
+			   " iop_base %p, cable_detect: %X, err_code %u\n",
 			   v->iop_base,
 			   AdvReadWordRegister(iop_base,
 					       IOPW_SCSI_CFG1) & CABLE_DETECT,
 			   v->err_code);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen, " chip_version %u, mcode_date 0x%x, "
+	seq_printf(m, " chip_version %u, mcode_date 0x%x, "
 			   "mcode_version 0x%x\n", c->chip_version,
 			   c->mcode_date, c->mcode_version);
-	ASC_PRT_NEXT();
 
 	AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
-	len = asc_prt_line(cp, leftlen, " Queuing Enabled:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Queuing Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
 
-		len = asc_prt_line(cp, leftlen, " %X:%c",
+		seq_printf(m, " %X:%c",
 				   i,
 				   (tagqng_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Queue Limit:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Queue Limit:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3860,14 +3614,11 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 		AdvReadByteLram(iop_base, ASC_MC_NUMBER_OF_MAX_CMD + i,
 				lrambyte);
 
-		len = asc_prt_line(cp, leftlen, " %X:%d", i, lrambyte);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
-	len = asc_prt_line(cp, leftlen, " Command Pending:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Command Pending:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3877,33 +3628,27 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 		AdvReadByteLram(iop_base, ASC_MC_NUMBER_OF_QUEUED_CMD + i,
 				lrambyte);
 
-		len = asc_prt_line(cp, leftlen, " %X:%d", i, lrambyte);
-		ASC_PRT_NEXT();
+		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
-	len = asc_prt_line(cp, leftlen, " Wide Enabled:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Wide Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
 
-		len = asc_prt_line(cp, leftlen, " %X:%c",
+		seq_printf(m, " %X:%c",
 				   i,
 				   (wdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, wdtr_done);
-	len = asc_prt_line(cp, leftlen, " Transfer Bit Width:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Transfer Bit Width:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
@@ -3914,37 +3659,31 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 				ASC_MC_DEVICE_HSHK_CFG_TABLE + (2 * i),
 				lramword);
 
-		len = asc_prt_line(cp, leftlen, " %X:%d",
+		seq_printf(m, " %X:%d",
 				   i, (lramword & 0x8000) ? 16 : 8);
-		ASC_PRT_NEXT();
 
 		if ((wdtr_able & ADV_TID_TO_TIDMASK(i)) &&
 		    (wdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			len = asc_prt_line(cp, leftlen, "*");
-			ASC_PRT_NEXT();
+			seq_printf(m, "*");
 			renegotiate = 1;
 		}
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
-	len = asc_prt_line(cp, leftlen, " Synchronous Enabled:");
-	ASC_PRT_NEXT();
+	seq_printf(m, " Synchronous Enabled:");
 	for (i = 0; i <= ADV_MAX_TID; i++) {
 		if ((chip_scsi_id == i) ||
 		    ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
 			continue;
 		}
 
-		len = asc_prt_line(cp, leftlen, " %X:%c",
+		seq_printf(m, " %X:%c",
 				   i,
 				   (sdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' :
 				   'N');
-		ASC_PRT_NEXT();
 	}
-	len = asc_prt_line(cp, leftlen, "\n");
-	ASC_PRT_NEXT();
+	seq_printf(m, "\n");
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, sdtr_done);
 	for (i = 0; i <= ADV_MAX_TID; i++) {
@@ -3960,359 +3699,177 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 			continue;
 		}
 
-		len = asc_prt_line(cp, leftlen, "  %X:", i);
-		ASC_PRT_NEXT();
+		seq_printf(m, "  %X:", i);
 
 		if ((lramword & 0x1F) == 0) {	/* Check for REQ/ACK Offset 0. */
-			len = asc_prt_line(cp, leftlen, " Asynchronous");
-			ASC_PRT_NEXT();
+			seq_printf(m, " Asynchronous");
 		} else {
-			len =
-			    asc_prt_line(cp, leftlen,
-					 " Transfer Period Factor: ");
-			ASC_PRT_NEXT();
+			seq_printf(m, " Transfer Period Factor: ");
 
 			if ((lramword & 0x1F00) == 0x1100) {	/* 80 Mhz */
-				len =
-				    asc_prt_line(cp, leftlen, "9 (80.0 Mhz),");
-				ASC_PRT_NEXT();
+				seq_printf(m, "9 (80.0 Mhz),");
 			} else if ((lramword & 0x1F00) == 0x1000) {	/* 40 Mhz */
-				len =
-				    asc_prt_line(cp, leftlen, "10 (40.0 Mhz),");
-				ASC_PRT_NEXT();
+				seq_printf(m, "10 (40.0 Mhz),");
 			} else {	/* 20 Mhz or below. */
 
 				period = (((lramword >> 8) * 25) + 50) / 4;
 
 				if (period == 0) {	/* Should never happen. */
-					len =
-					    asc_prt_line(cp, leftlen,
-							 "%d (? Mhz), ");
-					ASC_PRT_NEXT();
+					seq_printf(m, "%d (? Mhz), ", period);
 				} else {
-					len = asc_prt_line(cp, leftlen,
+					seq_printf(m,
 							   "%d (%d.%d Mhz),",
 							   period, 250 / period,
 							   ASC_TENTHS(250,
 								      period));
-					ASC_PRT_NEXT();
 				}
 			}
 
-			len = asc_prt_line(cp, leftlen, " REQ/ACK Offset: %d",
+			seq_printf(m, " REQ/ACK Offset: %d",
 					   lramword & 0x1F);
-			ASC_PRT_NEXT();
 		}
 
 		if ((sdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			len = asc_prt_line(cp, leftlen, "*\n");
+			seq_printf(m, "*\n");
 			renegotiate = 1;
 		} else {
-			len = asc_prt_line(cp, leftlen, "\n");
+			seq_printf(m, "\n");
 		}
-		ASC_PRT_NEXT();
 	}
 
 	if (renegotiate) {
-		len = asc_prt_line(cp, leftlen,
+		seq_printf(m,
 				   " * = Re-negotiation pending before next command.\n");
-		ASC_PRT_NEXT();
 	}
-
-	return totlen;
-}
-
-/*
- * asc_proc_copy()
- *
- * Copy proc information to a read buffer taking into account the current
- * read offset in the file and the remaining space in the read buffer.
- */
-static int
-asc_proc_copy(off_t advoffset, off_t offset, char *curbuf, int leftlen,
-	      char *cp, int cplen)
-{
-	int cnt = 0;
-
-	ASC_DBG(2, "offset %d, advoffset %d, cplen %d\n",
-		 (unsigned)offset, (unsigned)advoffset, cplen);
-	if (offset <= advoffset) {
-		/* Read offset below current offset, copy everything. */
-		cnt = min(cplen, leftlen);
-		ASC_DBG(2, "curbuf 0x%lx, cp 0x%lx, cnt %d\n",
-			 (ulong)curbuf, (ulong)cp, cnt);
-		memcpy(curbuf, cp, cnt);
-	} else if (offset < advoffset + cplen) {
-		/* Read offset within current range, partial copy. */
-		cnt = (advoffset + cplen) - offset;
-		cp = (cp + cplen) - cnt;
-		cnt = min(cnt, leftlen);
-		ASC_DBG(2, "curbuf 0x%lx, cp 0x%lx, cnt %d\n",
-			 (ulong)curbuf, (ulong)cp, cnt);
-		memcpy(curbuf, cp, cnt);
-	}
-	return cnt;
 }
 
 #ifdef ADVANSYS_STATS
 /*
  * asc_prt_board_stats()
- *
- * Note: no single line should be greater than ASC_PRTLINE_SIZE,
- * cf. asc_prt_line().
- *
- * Return the number of characters copied into 'cp'. No more than
- * 'cplen' characters will be copied to 'cp'.
  */
-static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
+static void asc_prt_board_stats(struct Scsi_Host *shost, struct seq_file *m)
 {
 	struct asc_board *boardp = shost_priv(shost);
 	struct asc_stats *s = &boardp->asc_stats;
 
-	int leftlen = cplen;
-	int len, totlen = 0;
-
-	len = asc_prt_line(cp, leftlen,
+	seq_printf(m,
 			   "\nLinux Driver Statistics for AdvanSys SCSI Host %d:\n",
 			   shost->host_no);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " queuecommand %lu, reset %lu, biosparam %lu, interrupt %lu\n",
+	seq_printf(m,
+			   " queuecommand %u, reset %u, biosparam %u, interrupt %u\n",
 			   s->queuecommand, s->reset, s->biosparam,
 			   s->interrupt);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " callback %lu, done %lu, build_error %lu, build_noreq %lu, build_nosg %lu\n",
+	seq_printf(m,
+			   " callback %u, done %u, build_error %u, build_noreq %u, build_nosg %u\n",
 			   s->callback, s->done, s->build_error,
 			   s->adv_build_noreq, s->adv_build_nosg);
-	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " exe_noerror %lu, exe_busy %lu, exe_error %lu, exe_unknown %lu\n",
+	seq_printf(m,
+			   " exe_noerror %u, exe_busy %u, exe_error %u, exe_unknown %u\n",
 			   s->exe_noerror, s->exe_busy, s->exe_error,
 			   s->exe_unknown);
-	ASC_PRT_NEXT();
 
 	/*
 	 * Display data transfer statistics.
 	 */
 	if (s->xfer_cnt > 0) {
-		len = asc_prt_line(cp, leftlen, " xfer_cnt %lu, xfer_elem %lu, ",
+		seq_printf(m, " xfer_cnt %u, xfer_elem %u, ",
 				   s->xfer_cnt, s->xfer_elem);
-		ASC_PRT_NEXT();
 
-		len = asc_prt_line(cp, leftlen, "xfer_bytes %lu.%01lu kb\n",
+		seq_printf(m, "xfer_bytes %u.%01u kb\n",
 				   s->xfer_sect / 2, ASC_TENTHS(s->xfer_sect, 2));
-		ASC_PRT_NEXT();
 
 		/* Scatter gather transfer statistics */
-		len = asc_prt_line(cp, leftlen, " avg_num_elem %lu.%01lu, ",
+		seq_printf(m, " avg_num_elem %u.%01u, ",
 				   s->xfer_elem / s->xfer_cnt,
 				   ASC_TENTHS(s->xfer_elem, s->xfer_cnt));
-		ASC_PRT_NEXT();
 
-		len = asc_prt_line(cp, leftlen, "avg_elem_size %lu.%01lu kb, ",
+		seq_printf(m, "avg_elem_size %u.%01u kb, ",
 				   (s->xfer_sect / 2) / s->xfer_elem,
 				   ASC_TENTHS((s->xfer_sect / 2), s->xfer_elem));
-		ASC_PRT_NEXT();
 
-		len = asc_prt_line(cp, leftlen, "avg_xfer_size %lu.%01lu kb\n",
+		seq_printf(m, "avg_xfer_size %u.%01u kb\n",
 				   (s->xfer_sect / 2) / s->xfer_cnt,
 				   ASC_TENTHS((s->xfer_sect / 2), s->xfer_cnt));
-		ASC_PRT_NEXT();
 	}
-
-	return totlen;
 }
 #endif /* ADVANSYS_STATS */
 
 /*
- * advansys_proc_info() - /proc/scsi/advansys/{0,1,2,3,...}
- *
- * *buffer: I/O buffer
- * **start: if inout == FALSE pointer into buffer where user read should start
- * offset: current offset into a /proc/scsi/advansys/[0...] file
- * length: length of buffer
- * hostno: Scsi_Host host_no
- * inout: TRUE - user is writing; FALSE - user is reading
- *
- * Return the number of bytes read from or written to a
- * /proc/scsi/advansys/[0...] file.
- *
- * Note: This function uses the per board buffer 'prtbuf' which is
- * allocated when the board is initialized in advansys_detect(). The
- * buffer is ASC_PRTBUF_SIZE bytes. The function asc_proc_copy() is
- * used to write to the buffer. The way asc_proc_copy() is written
- * if 'prtbuf' is too small it will not be overwritten. Instead the
- * user just won't get all the available statistics.
+ * /proc/scsi/advansys/{0,1,2,3,...}
  */
-static int
-advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
-		   off_t offset, int length, int inout)
+static int advansys_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shost = m->private;
 	struct asc_board *boardp = shost_priv(shost);
-	char *cp;
-	int cplen;
-	int cnt;
-	int totcnt;
-	int leftlen;
-	char *curbuf;
-	off_t advoffset;
-
-	ASC_DBG(1, "begin\n");
-
-	/*
-	 * User write not supported.
-	 */
-	if (inout == TRUE)
-		return -ENOSYS;
-
-	/*
-	 * User read of /proc/scsi/advansys/[0...] file.
-	 */
-
-	/* Copy read data starting at the beginning of the buffer. */
-	*start = buffer;
-	curbuf = buffer;
-	advoffset = 0;
-	totcnt = 0;
-	leftlen = length;
 
 	/*
 	 * Get board configuration information.
 	 *
 	 * advansys_info() returns the board string from its own static buffer.
 	 */
-	cp = (char *)advansys_info(shost);
-	strcat(cp, "\n");
-	cplen = strlen(cp);
-	/* Copy board information. */
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	seq_printf(m, "%s\n", advansys_info(shost));
 
 	/*
 	 * Display Wide Board BIOS Information.
 	 */
 	if (!ASC_NARROW_BOARD(boardp)) {
-		cp = boardp->prtbuf;
-		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
-		BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
-				  cplen);
-		totcnt += cnt;
-		leftlen -= cnt;
-		if (leftlen == 0) {
-			ASC_DBG(1, "totcnt %d\n", totcnt);
-			return totcnt;
-		}
-		advoffset += cplen;
-		curbuf += cnt;
+		asc_prt_adv_bios(shost, m);
 	}
 
 	/*
 	 * Display driver information for each device attached to the board.
 	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	asc_prt_board_devices(shost, m);
 
 	/*
 	 * Display EEPROM configuration for the board.
 	 */
-	cp = boardp->prtbuf;
 	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
+		asc_prt_asc_board_eeprom(shost, m);
 	} else {
-		cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
-	}
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
+		asc_prt_adv_board_eeprom(shost, m);
 	}
-	advoffset += cplen;
-	curbuf += cnt;
 
 	/*
 	 * Display driver configuration and information for the board.
 	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	asc_prt_driver_conf(shost, m);
 
 #ifdef ADVANSYS_STATS
 	/*
 	 * Display driver statistics for the board.
 	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	asc_prt_board_stats(shost, m);
 #endif /* ADVANSYS_STATS */
 
 	/*
 	 * Display Asc Library dynamic configuration information
 	 * for the board.
 	 */
-	cp = boardp->prtbuf;
 	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_info(shost, cp, ASC_PRTBUF_SIZE);
+		asc_prt_asc_board_info(shost, m);
 	} else {
-		cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
+		asc_prt_adv_board_info(shost, m);
 	}
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG(1, "totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
 
-	ASC_DBG(1, "totcnt %d\n", totcnt);
+	return 0;
+}
 
-	return totcnt;
+static int advansys_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, advansys_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations advansys_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= advansys_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 static void asc_scsi_done(struct scsi_cmnd *scp)
@@ -11720,7 +11277,7 @@ AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 static struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
-	.proc_info = advansys_proc_info,
+	.proc_fops = &advansys_proc_fops,
 #endif
 	.name = DRV_NAME,
 	.info = advansys_info,
@@ -11916,20 +11473,6 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 #endif /* CONFIG_PCI */
 	}
 
-#ifdef CONFIG_PROC_FS
-	/*
-	 * Allocate buffer for printing information from
-	 * /proc/scsi/advansys/[0...].
-	 */
-	boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_KERNEL);
-	if (!boardp->prtbuf) {
-		shost_printk(KERN_ERR, shost, "kmalloc(%d) returned NULL\n",
-				ASC_PRTBUF_SIZE);
-		ret = -ENOMEM;
-		goto err_unmap;
-	}
-#endif /* CONFIG_PROC_FS */
-
 	if (ASC_NARROW_BOARD(boardp)) {
 		/*
 		 * Set the board bus type and PCI IRQ before
@@ -12343,8 +11886,6 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		free_dma(shost->dma_channel);
 #endif
  err_free_proc:
-	kfree(boardp->prtbuf);
- err_unmap:
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
@@ -12377,7 +11918,6 @@ static int advansys_release(struct Scsi_Host *shost)
 		iounmap(board->ioremap_addr);
 		advansys_wide_free_mem(board);
 	}
-	kfree(board->prtbuf);
 	scsi_host_put(shost);
 	ASC_DBG(1, "end\n");
 	return 0;
-- 
1.6.5.2

