From: Tim Schmielau <tim@physik3.uni-rostock.de>
Subject: [patch] fix compares of jiffies
Date: Sun, 22 Sep 2002 13:45:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209221145.g8MBjp723243@gans.physik3.uni-rostock.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tim@physik3.uni-rostock.de

Dear Linux kernel code maintainer,

on rechecking the current stable kernel code, I found some places where jiffies
were compared in a way that seems to break when they wrap. For these,
I made up patches to use the macros "time_before()" or "time_after()"
that are supposed to handle wraparound correctly.

For a small part of the patches, I believe you to be the relevant kernel code
maintainer. Appended to this email you will find some lines explaining
why I decided to mail or cc: you on this (an extract of the copyright notice
or the MAINTAINERS file), followed by the patch itself. If I mailed you
in error, please drop me a short note.

I kindly ask you to approve the correctness of the patch, and pass it on to
the relevant people for inclusion into the mainline kernel.

Thanks,
Tim Schmielau (tim@physik3.uni-rostock.de)



--- linux-2.4.20-pre6/drivers/scsi/scsi_obsolete.c	Sat Aug  3 02:39:44 2002
+++ linux-2.4.20-pre6-jfix/drivers/scsi/scsi_obsolete.c	Wed Sep 11 12:47:46 2002
@@ -967,7 +967,7 @@
 				   that the delay in internal_cmnd will guarantee at least a
 				   MIN_RESET_DELAY bus settle time.
 				 */
-				if (host->last_reset - jiffies > 20UL * HZ)
+				if (time_before(jiffies, host->last_reset - 20UL * HZ))
 					host->last_reset = jiffies;
 			} else {
 				host->host_busy++;

