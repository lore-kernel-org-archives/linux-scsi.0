From: Willem Riede <wrlk@riede.org>
Subject: SCSI error handler dying prematurely
Date: Tue, 31 Dec 2002 12:04:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021231170436.GG1378@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gBVH4af06083
	for <linux-scsi@vger.kernel.org>; Tue, 31 Dec 2002 12:04:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The error handler thread of ide-scsi has started dying on me, if
and only if ide-scsi is started during the boot sequence from
rc.sysinit. I'm using the scripts from Red Hat 8.0, which, if you
boot the kernel with 'hdx=ide-scsi' will modprobe ide-cd and 
ide-scsi. I've generated some output:

Dec 31 11:42:59 fallguy kernel: scsi logging level set to 0x00000005
Dec 31 11:42:59 fallguy kernel: end_request: I/O error, dev hda, sector 0
Dec 31 11:42:59 fallguy kernel: end_request: I/O error, dev hda, sector 0
Dec 31 11:42:59 fallguy kernel: hda: ATAPI 32X CD-ROM drive, 5644kB Cache, (U)DMA
Dec 31 11:42:59 fallguy kernel: Uniform CD-ROM driver Revision: 3.12
Dec 31 11:42:59 fallguy kernel: Wake up parent 
Dec 31 11:42:59 fallguy kernel: Error handler scsi_eh_2 sleeping
Dec 31 11:42:59 fallguy kernel: scsi2 : SCSI host adapter emulation for IDE ATAPI devices
Dec 31 11:42:59 fallguy kernel:   Vendor: OnStream  Model: ADR Series        Rev: 5.05
Dec 31 11:42:59 fallguy kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Dec 31 11:42:59 fallguy kernel:   Vendor: OnStream  Model: DI-30             Rev: 1.09
Dec 31 11:43:00 fallguy kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Dec 31 11:43:00 fallguy kernel:   Vendor: CONNER    Model: CTT8000-A         Rev: 2.08
Dec 31 11:43:00 fallguy kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Dec 31 11:43:00 fallguy kernel: Signals pending for scsi_eh_2: 00000001 00000000
Dec 31 11:43:00 fallguy kernel: Error handler scsi_eh_2 exiting

In rc.sysinit I put an echo to /proc/scsi/scsi to set the logging level,
just before the modprobe ide-cd. There is no cd in the cdrom drive, 
hence the errors on hda (the disks on this system are all scsi).

The CD-ROM driver loads normally, then we get output from ide-scsi.
It starts the error handler, which wakes its parent, then goes to
sleep. The main thread detects the other ide devices (all tape drives).

Then, out of the blue, but virtually immediately, and reproducably,
the ide-scsi error handler receives a signal and exits. I've inserted 
the print statement to show the signals in scsi_error.c so I need to 
explain what you're looking at.

I'm printing current->pending.signal.sig[0] and 
current->pending.signal.sig[1] with %08lx.

It appears that the LSB of sig[0] is set. Does that make it SIGHUP?

And again, if I load ide-scsi later, or rmmod and modprobe it after
this happened on boot, the error handler stays up.

How do I figure out where this stray signal is coming from?

Thanks, Willem Riede.
