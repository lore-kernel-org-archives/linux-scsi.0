From: Tim Schmielau <tim@physik3.uni-rostock.de>
Subject: [patch] fix compares of jiffies
Date: Sun, 22 Sep 2002 13:45:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209221145.g8MBjq523300@gans.physik3.uni-rostock.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: mike@i-connect.net
Cc: linux-eata@i-connect.net, linux-scsi@vger.kernel.org, tim@physik3.uni-rostock.de

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



EATA-DMA SCSI DRIVER
P:	Michael Neuffer
M:	mike@i-Connect.Net
L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
S:	Maintained


--- linux-2.4.20-pre6/drivers/scsi/eata_generic.h	Wed Aug 15 10:22:16 2001
+++ linux-2.4.20-pre6-jfix/drivers/scsi/eata_generic.h	Wed Sep 11 12:48:52 2002
@@ -97,7 +97,7 @@
 #define DELAY(x) { ulong flags, i;                \
                    save_flags(flags); sti();      \
                    i = jiffies + (x * HZ);        \
-                   while (jiffies < i);           \
+                   while (time_before(jiffies, i));           \
                    restore_flags(flags); }
 
 /***********************************************

