From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] in2000 warning
Date: Thu, 11 Sep 2003 08:35:47 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0309110828160.1879-100000@vervain.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Passing the address of a `long' as the `flags' parameter of check_setup_args()
causes a warning. But apparently this parameter isn't used at all, so remove
it.

--- linux-2.6.0-test5/drivers/scsi/in2000.c.orig	Tue Jul 29 18:19:10 2003
+++ linux-2.6.0-test5/drivers/scsi/in2000.c	Tue Sep  9 14:58:28 2003
@@ -1844,7 +1844,7 @@
 /* check_setup_args() returns index if key found, 0 if not
  */
 
-static int __init check_setup_args(char *key, int *flags, int *val, char *buf)
+static int __init check_setup_args(char *key, int *val, char *buf)
 {
 	int x;
 	char *cp;
@@ -1929,7 +1929,7 @@
 
 	detect_count = 0;
 	for (bios = 0; bios_tab[bios]; bios++) {
-		if (check_setup_args("ioport", &flags, &val, buf)) {
+		if (check_setup_args("ioport", &val, buf)) {
 			base = val;
 			switches = ~inb(base + IO_SWITCHES) & 0xff;
 			printk("Forcing IN2000 detection at IOport 0x%x ", base);
@@ -2048,30 +2048,30 @@
 #endif
 #endif
 
-		if (check_setup_args("nosync", &flags, &val, buf))
+		if (check_setup_args("nosync", &val, buf))
 			hostdata->sync_off = val;
 
-		if (check_setup_args("period", &flags, &val, buf))
+		if (check_setup_args("period", &val, buf))
 			hostdata->default_sx_per = sx_table[round_period((unsigned int) val)].period_ns;
 
-		if (check_setup_args("disconnect", &flags, &val, buf)) {
+		if (check_setup_args("disconnect", &val, buf)) {
 			if ((val >= DIS_NEVER) && (val <= DIS_ALWAYS))
 				hostdata->disconnect = val;
 			else
 				hostdata->disconnect = DIS_ADAPTIVE;
 		}
 
-		if (check_setup_args("noreset", &flags, &val, buf))
+		if (check_setup_args("noreset", &val, buf))
 			hostdata->args ^= A_NO_SCSI_RESET;
 
-		if (check_setup_args("level2", &flags, &val, buf))
+		if (check_setup_args("level2", &val, buf))
 			hostdata->level2 = val;
 
-		if (check_setup_args("debug", &flags, &val, buf))
+		if (check_setup_args("debug", &val, buf))
 			hostdata->args = (val & DB_MASK);
 
 #ifdef PROC_INTERFACE
-		if (check_setup_args("proc", &flags, &val, buf))
+		if (check_setup_args("proc", &val, buf))
 			hostdata->proc = val;
 #endif
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
