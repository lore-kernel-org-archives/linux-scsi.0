From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Mon, 26 Feb 2007 10:26:17 -0800
Message-ID: <20070226182617.GC9968@andrew-vasquezs-computer.local>
References: <20070226133153.GC4095@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6301 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378AbXBZS0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Feb 2007 13:26:24 -0500
Content-Disposition: inline
In-Reply-To: <20070226133153.GC4095@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <linux-driver@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, 26 Feb 2007, Andre Noll wrote:

> On linux-2.6.20.1, we're seeing hard lockups with 2 raid systems
> connected to a qla2xxx card and used as a single volume via lvm.
> The system seems to lock up only if data gets written to both raid
> systems at the same time.
> 
> On a standard kernel nothing makes it to the log, the system just
> freezes. So we tried a lockdep kernel which reports two BUGs during
> boot, see below.
> 
> Could this be related to our problem?

Before we proceed further, could you retrieve the latest firmware
release for 24xx type HBAs:

> [   64.151096] QLogic Fibre Channel HBA Driver
> [   64.151405] ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 32 (level, low) -> IRQ 32
> [   64.151821] qla2xxx 0000:05:08.0: Found an ISP2422, irq 32, iobase 0xffffc20000006000
> [   64.152231] qla2xxx 0000:05:08.0: Configuring PCI space...
> [   64.152498] qla2xxx 0000:05:08.0: Configure NVRAM parameters...
> [   64.159088] qla2xxx 0000:05:08.0: Verifying loaded RISC code...
> [   74.169623] qla2xxx 0000:05:08.0: Firmware image unavailable.
> [   74.169737] qla2xxx 0000:05:08.0: Firmware images can be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.
> [   74.169902] qla2xxx 0000:05:08.0: Attempting to load (potentially outdated) firmware from flash.
> [   74.760935] qla2xxx 0000:05:08.0: Allocated (64 KB) for EFT...
> [   74.761186] qla2xxx 0000:05:08.0: Allocated (1413 KB) for firmware dump...
> [   74.776988] scsi0 : qla2xxx
> [   74.961451] qla2xxx 0000:05:08.0: 
> [   74.961452]  QLogic Fibre Channel HBA Driver: 8.01.07-k4
> [   74.961453]   QLogic HP AE369-60001 - QLA2340
> [   74.961454]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.0 hdma+, host#=0, fw=4.00.70 [IP] 

You are loading some stale firmware that's left over on the card --
I'm not even sure what 4.00.70 is, as the latest release firmware is
4.00.27.  You can retrieve the image here:

	ftp://ftp.qlogic.com/outgoing/linux/firmware/ql2400_fw.bin

Let's start there... before we move on to this:

> [   75.778656] BUG: at kernel/lockdep.c:1860 trace_hardirqs_on()
> [   75.778771] 
> [   75.778772] Call Trace:
> [   75.778967]  <IRQ>  [<ffffffff8024b877>] trace_hardirqs_on+0xd7/0x180
> [   75.779154]  [<ffffffff8052bc1b>] _spin_unlock_irq+0x2b/0x40
> [   75.779271]  [<ffffffff804605d7>] qla2x00_process_completed_request+0x137/0x1d0
> [   75.779424]  [<ffffffff804606f2>] qla2x00_status_entry+0x82/0xa40
> [   75.779541]  [<ffffffff8024b17f>] __lock_acquire+0xcdf/0xd90
> [   75.779657]  [<ffffffff8052bcb2>] _spin_unlock_irqrestore+0x42/0x60
> [   75.779775]  [<ffffffff8046228e>] qla24xx_intr_handler+0x4e/0x2b0
> [   75.779892]  [<ffffffff804613e1>] qla24xx_process_response_queue+0xc1/0x1c0
> [   75.780012]  [<ffffffff80462414>] qla24xx_intr_handler+0x1d4/0x2b0
> [   75.780131]  [<ffffffff8025e950>] handle_IRQ_event+0x20/0x60

Hmm....

Regards,
Andrew Vasquez
