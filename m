From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/17] sym53c8xx: Remove io_ws, mmio_ws and ram_ws elements
Date: Fri,  5 Oct 2007 15:55:07 -0400
Message-ID: <11916141153517-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52936 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761140AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

These struct elements record info that is never needed

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +----
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    7 ++-----
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    3 ---
 4 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 357903f..6865d30 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1432,17 +1432,14 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	np->mmio_ba = (u32)dev->mmio_base;
 	np->s.ioaddr	= dev->s.ioaddr;
 	np->s.ramaddr	= dev->s.ramaddr;
-	np->s.io_ws = (np->features & FE_IO256) ? 256 : 128;
 
 	/*
 	 *  Map on-chip RAM if present and supported.
 	 */
 	if (!(np->features & FE_RAM))
 		dev->ram_base = 0;
-	if (dev->ram_base) {
+	if (dev->ram_base)
 		np->ram_ba = (u32)dev->ram_base;
-		np->ram_ws = (np->features & FE_RAM8K) ? 8192 : 4096;
-	}
 
 	if (sym_hcb_attach(instance, fw, dev->nvram))
 		goto attach_failed;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index b961f70..ab2de1c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -184,7 +184,6 @@ struct sym_shcb {
 
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
 	void __iomem *	ramaddr;	/* RAM  kernel io address	*/
-	u_short		io_ws;		/* IO window size		*/
 
 	struct timer_list timer;	/* Timer handler link header	*/
 	u_long		lasttime;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 5443394..39f84bb 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1910,7 +1910,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 		if (sym_verbose >= 2)
 			printf("%s: Downloading SCSI SCRIPTS.\n", sym_name(np));
 		memcpy_toio(np->s.ramaddr, np->scripta0, np->scripta_sz);
-		if (np->ram_ws == 8192) {
+		if (np->features & FE_RAM8K) {
 			memcpy_toio(np->s.ramaddr + 4096, np->scriptb0, np->scriptb_sz);
 			phys = scr_to_cpu(np->scr_ram_seg);
 			OUTL(np, nc_mmws, phys);
@@ -5595,16 +5595,13 @@ int sym_hcb_attach(struct Scsi_Host *shost, struct sym_fw *fw, struct sym_nvram
 	np->scriptz_ba	= vtobus(np->scriptz0);
 
 	if (np->ram_ba) {
-		np->scripta_ba	= np->ram_ba;
+		np->scripta_ba = np->ram_ba;
 		if (np->features & FE_RAM8K) {
-			np->ram_ws = 8192;
 			np->scriptb_ba = np->scripta_ba + 4096;
 #if 0	/* May get useful for 64 BIT PCI addressing */
 			np->scr_ram_seg = cpu_to_scr(np->scripta_ba >> 32);
 #endif
 		}
-		else
-			np->ram_ws = 4096;
 	}
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index b8908e1..f76b27f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -883,10 +883,7 @@ struct sym_hcb {
 	 *  Physical bus addresses of the chip.
 	 */
 	u32		mmio_ba;	/* MMIO 32 bit BUS address	*/
-	int		mmio_ws;	/* MMIO Window size		*/
-
 	u32		ram_ba;		/* RAM 32 bit BUS address	*/
-	int		ram_ws;		/* RAM window size		*/
 
 	/*
 	 *  SCRIPTS virtual and physical bus addresses.
-- 
1.4.4.2

