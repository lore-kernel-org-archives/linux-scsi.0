From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 08 Dec 2003 10:39:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070905143.2263.63.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:32673 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265501AbTLHRjN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 12:39:13 -0500
In-Reply-To: <3FD43229.7070708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > P.S. I presume already you are aware of the gcc -Wall warning:
> > 
> > $ cd sg3_utils-1.06/
> > $ make
> > gcc -g -O2 -Wall -W -D_REENTRANT -D_LARGEFILE64_SOURCE
> > -D_FILE_OFFSET_BITS=64
> > -c -o sg_dd.o sg_dd.c
> > sg_dd.c: In function `siginfo_handler':
> > sg_dd.c:138: warning: unused parameter `sig'
> > ...
> 
> Yes, but adding the '-W' flagging has several beneficial
> effects (to counterbalance this annoying warning which
> C++ but not C addresses).

Sorry I had forgotten that gcc -W warns of more than -Wall.

I have seen translations to C language express the idea of discarding a
result on purpose via such source code as { result = result; }
assign-no-change and { (void) result; } cast-to-void.

I vote assign-no-change, because ...

gcc -Wall -W here now seems happy with either.  Possibly I remember
msvc++ max warnings accepting assign-no-change and disliking
cast-to-void.  I see javac here accepts assign-to-self, rejects
cast-to-void as an error.  I see `man lint` here now chokes.  `man -k
lint` suggests `splint`.  `splint sg_dd.c` yields about 283 warnings,
but accepts assign-no-change quietly while complaining of cast-to-void
via "Statement has no ...  visible effect --- no values are modified
...".

Assign-no-change has not yet bitten me with gcc, your mileage may vary.

I see `make sg_dd.lst` here doesn't yet know gcc -a well enough to try
things like the linux-fsdevel suggestion `gcc -O -g -Wa=
,-ahls file.c` that you might see hinted by lk 2.6 `make
drivers/usb/core/usb.lst`.

Pat LaVarre

diff -Nurp sg3_utils-1.06/sg_dd.c sg3_utils/sg_dd.c
--- sg3_utils-1.06/sg_dd.c	2003-11-12 04:02:10.000000000 -0700
+++ sg3_utils/sg_dd.c	2003-12-08 10:14:15.315282120 -0700
@@ -137,6 +137,7 @@ static void interrupt_handler(int sig)
 
 static void siginfo_handler(int sig)
 {
+    sig = sig;
     fprintf(stderr, "Progress report, continuing ...\n");
     print_stats("  ");
 }
diff -Nurp sg3_utils-1.06/sg_read.c sg3_utils/sg_read.c
--- sg3_utils-1.06/sg_read.c	2003-11-11 21:32:01.000000000 -0700
+++ sg3_utils/sg_read.c	2003-12-08 10:14:35.178262488 -0700
@@ -123,6 +123,7 @@ static void interrupt_handler(int sig)
 
 static void siginfo_handler(int sig)
 {
+    sig = sig;
     fprintf(stderr, "Progress report, continuing ...\n");
     print_stats(0);
 }


