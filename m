From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Tue, 13 Jan 2004 00:00:02 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401122345060.9046-100000@poirot.grange>
References: <0f0c01c3d8ef$d7cb3cb0$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43145 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262015AbUALXHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 18:07:12 -0500
In-Reply-To: <0f0c01c3d8ef$d7cb3cb0$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 12 Jan 2004, Kai Ruhnau wrote:

> I try to do, what I can:
>
> kernel 2.4.22 aha152x compiled in:
>   aha152x: ABORT timed out - removed from issue queue
> kernel 2.4.22 aha152x as module:
>   No such device
> kernel 2.4.10 aha152x compiled in:
>   timeout and NULL-pointer dereference
> kernel 2.4.10 aha152x as module:
>   kernel Oops (NULL pointer dereference) during linuxrc

Please try the patch below - just to see where it fails. It looks like
you've got another driver claiming the 0x340 region - can you check your
/proc/ioports? If not - I don't understand why SuSE-7.3 detected the chip,
and vanilla kernels don't - among all SuSE-7.3 patches nothing touches
aha152x.*. The patch might not apply cleanly to your kernel-version, but
you should be able to add the required lines manually.

Also, can you install SuSE 2.4.10 sources, compile a kernel from them and
see if that works? It would be useful to get a kernel, that works, that we
can compile ourselves, that we can compare with those kernels, that fail,
and that we can put some debugging output in.

> drivers/scsi/ of SuSE's 2.4.10:
>   please have a look at
>     http://tragetaschen.dyndns.org/kernel/drivers_scsi.tar.bz2

...couldn't get to this site.

>   original, full sources at
>     ftp://ftp.suse.com/pub/suse/i386/7.3/suse/d2/kernel-source.rpm
>   the drivers/scsi/ diff from vanilla-2.4.10 to SuSE-2.4.10 is at
>
>     http://tragetaschen.dyndns.org/kernel/vanilla2suse.bz2
>   (Sorry, but I only have 16k upload)

I downloaded SuSE-patches from one of their ftp-sites - only some generic
scsi error-handling / reset patches. Nothing aha152x-specific.

Regards
Guennadi
---
Guennadi Liakhovetski

--- aha152x.c~	Sun Jan 11 23:40:37 2004
+++ aha152x.c	Mon Jan 12 23:42:18 2004
@@ -849,8 +849,10 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
+	if (check_region(io_port, IO_RANGE)) {
+		printk(KERN_WARNING"Port 0x%x[%d] busy\n", io_port, IO_RANGE);
 		return 0;
+	}

 	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
@@ -867,8 +869,10 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
+	if (check_region(io_port, IO_RANGE)) {
+		printk(KERN_WARNING"Port 0x%x[%d] busy\n", io_port, IO_RANGE);
 		return 0;
+	}

 	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
@@ -895,8 +899,10 @@

 	if(aha152x_porttest(setup->io_port)) {
           setup->tc1550=0;
+	  printk("%s(): aha152x found at %x\n", __FUNCTION__, setup->io_port);
         } else if(tc1550_porttest(setup->io_port)) {
           setup->tc1550=1;
+	  printk("%s(): tc1550 found at %x\n", __FUNCTION__, setup->io_port);
         } else
           return 0;

@@ -1308,6 +1314,7 @@
 				continue;

 			if (aha152x_porttest(ports[i])) {
+				printk("%s(): aha152x found at %x\n", __FUNCTION__, ports[i]);
 				ok++;
 				setup[setup_count].io_port = ports[i];
 				setup[setup_count].tc1550  = 0;
@@ -1327,6 +1334,7 @@
 #endif
 				setup_count++;
 			} else if (tc1550_porttest(ports[i])) {
+				printk("%s(): tc1550 found at %x\n", __FUNCTION__, ports[i]);
 				ok++;
 				setup[setup_count].io_port = ports[i];
 				setup[setup_count].tc1550  = 1;


