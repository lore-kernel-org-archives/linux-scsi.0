From: Tim Schmielau <tim@physik3.uni-rostock.de>
Subject: [patch] fix compares of jiffies
Date: Sun, 22 Sep 2002 13:45:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209221145.g8MBjp023269@gans.physik3.uni-rostock.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: lw_linux@hotmail.com
Cc: linux-scsi@vger.kernel.org, tim@physik3.uni-rostock.de

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



/* 
 *  sym53c416.c
 *  Low-level SCSI driver for sym53c416 chip.
 *  Copyright (C) 1998 Lieven Willems (lw_linux@hotmail.com)


--- linux-2.4.20-pre6/drivers/scsi/sym53c416.c	Sun Sep 30 21:26:07 2001
+++ linux-2.4.20-pre6-jfix/drivers/scsi/sym53c416.c	Wed Sep 11 12:53:08 2002
@@ -277,7 +277,7 @@
 		{
 			i = jiffies + timeout;
 			restore_flags(flags);
-			while(jiffies < i && (inb(base + PIO_INT_REG) & EMPTY) && timeout)
+			while(time_before(jiffies, i) && (inb(base + PIO_INT_REG) & EMPTY) && timeout)
 				if(inb(base + PIO_INT_REG) & SCI)
 					timeout = 0;
 			save_flags(flags);
@@ -323,7 +323,7 @@
 		{
 			i = jiffies + timeout;
 			restore_flags(flags);
-			while(jiffies < i && (inb(base + PIO_INT_REG) & FULL) && timeout)
+			while(time_before(jiffies, i) && (inb(base + PIO_INT_REG) & FULL) && timeout)
 				;
 			save_flags(flags);
 			cli();
@@ -559,9 +559,9 @@
 	outb(0x00, base + DEST_BUS_ID);
 	/* Wait for interrupt to occur */
 	i = jiffies + 20;
-	while(i > jiffies && !(inb(base + STATUS_REG) & SCI))
+	while(time_before(jiffies, i) && !(inb(base + STATUS_REG) & SCI))
 		barrier();
-	if(i <= jiffies) /* timed out */
+	if(time_after_eq(jiffies, i)) /* timed out */
 		return 0;
 	/* Get occurred irq */
 	irq = probe_irq_off(irqs);

