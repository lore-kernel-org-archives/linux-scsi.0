From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NCR53c406a.c warning
Date: Thu, 11 Sep 2003 08:37:36 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0309110836030.1879-100000@vervain.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


NCR53c406a: Apparently wait_intr() is unused, so remove it.

--- linux-2.6.0-test5/drivers/scsi/NCR53c406a.c.orig	Sun Aug 24 09:49:34 2003
+++ linux-2.6.0-test5/drivers/scsi/NCR53c406a.c	Tue Sep  9 15:01:48 2003
@@ -170,7 +170,6 @@
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
 static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
-static void wait_intr(void);
 static void chip_init(void);
 static void calc_port_addr(void);
 #ifndef IRQ_LEV
@@ -663,26 +662,6 @@
 {
 	DEB(printk("NCR53c406a_info called\n"));
 	return (info_msg);
-}
-
-static void wait_intr(void)
-{
-	unsigned long i = jiffies + WATCHDOG;
-
-	while (time_after(i, jiffies) && !(inb(STAT_REG) & 0xe0)) {	/* wait for a pseudo-interrupt */
-		cpu_relax();
-		barrier();
-	}
-
-	if (time_before_eq(i, jiffies)) {	/* Timed out */
-		rtrc(0);
-		current_SC->result = DID_TIME_OUT << 16;
-		current_SC->SCp.phase = idle;
-		current_SC->scsi_done(current_SC);
-		return;
-	}
-
-	NCR53c406a_intr(0, NULL, NULL);
 }
 
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------------------- Sint-Stevens-Woluwestraat 55
Voice +32-2-2908453 Fax +32-2-7262686 ---------------- B-1130 Brussels, Belgium
