From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym2 & lasi700 small updates
Date: Sat, 14 Aug 2004 22:45:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040814214556.GC12936@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32953 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266218AbUHNVp5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 17:45:57 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1Bw6Lc-0004W9-SE
	for linux-scsi@vger.kernel.org; Sat, 14 Aug 2004 22:45:56 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Two small patches from the PA-RISC tree:

 - Claim the lasi700 interrupt with a more useful name (Thibaut Varene)
 - sym2 always defines SYM_OPT_NVRAM_PRE_READ; delete dead code (Matthew Wilcox)

diff -urpNX dontdiff linus-2.6/drivers/scsi/lasi700.c parisc-2.6/drivers/scsi/lasi700.c
--- linus-2.6/drivers/scsi/lasi700.c	Sat Aug 14 11:16:39 2004
+++ parisc-2.6/drivers/scsi/lasi700.c	Sat Aug 14 11:05:39 2004
@@ -110,7 +110,7 @@ lasi700_probe(struct parisc_device *dev)
 
 	host->irq = dev->irq;
 	if (request_irq(dev->irq, NCR_700_intr, SA_SHIRQ,
-				dev->dev.bus_id, host)) {
+				"lasi700", host)) {
 		printk(KERN_ERR "%s: irq problem, detaching\n",
 		       dev->dev.bus_id);
 		goto out_put_host;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Sat Aug 14 11:16:40 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Sat Aug 14 11:05:40 2004
@@ -89,7 +89,6 @@
 
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
-#define SYM_OPT_NVRAM_PRE_READ
 #define SYM_OPT_SNIFF_INQUIRY
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Sat Aug 14 11:16:40 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Sat Aug 14 11:05:40 2004
@@ -5738,15 +5738,8 @@ if (resid)
 /*
  *  Soft-attach the controller.
  */
-#ifdef SYM_OPT_NVRAM_PRE_READ
 int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram)
-#else
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw)
-#endif
 {
-#ifndef SYM_OPT_NVRAM_PRE_READ
-	struct sym_nvram nvram_buf, *nvram = &nvram_buf;
-#endif
 	int i;
 
 	/*
@@ -5771,13 +5764,6 @@ int sym_hcb_attach(hcb_p np, struct sym_
 	 *  if the chip is currently active.
 	 */
 	sym_chip_reset (np);
-
-	/*
-	 *  Try to read the user set-up.
-	 */
-#ifndef SYM_OPT_NVRAM_PRE_READ
-	(void) sym_read_nvram(np, nvram);
-#endif
 
 	/*
 	 *  Prepare controller and devices settings, according 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Sat Aug 14 11:16:40 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Sat Aug 14 11:05:40 2004
@@ -1139,12 +1139,7 @@ int sym_abort_scsiio(hcb_p np, cam_ccb_p
 int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out);
 int sym_reset_scsi_target(hcb_p np, int target);
 void sym_hcb_free(hcb_p np);
-
-#ifdef SYM_OPT_NVRAM_PRE_READ
 int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram);
-#else
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw);
-#endif
 
 /*
  *  Optionnaly, the driver may handle IO timeouts.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
