From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 27 Feb 2007 10:51:34 -0800
Message-ID: <20070227185134.GJ20397@andrew-vasquezs-computer.local>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29304 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXB0Svl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 13:51:41 -0500
Content-Disposition: inline
In-Reply-To: <20070227101100.GA22572@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Tue, 27 Feb 2007, Andre Noll wrote:

> On 10:26, Andrew Vasquez wrote:
> > You are loading some stale firmware that's left over on the card --
> > I'm not even sure what 4.00.70 is, as the latest release firmware is
> > 4.00.27.
> 
> That's the firmware which came with the card. Anyway, I just upgraded
> the firmware, but the bug remains. The backtrace differs a bit though
> as now the tg3 network driver seems to be involved as well.
> 
> Thanks for your help
> Andre
...
> [   68.532665] BUG: at kernel/lockdep.c:1860 trace_hardirqs_on()
> [   68.532784] 
> [   68.532785] Call Trace:
> [   68.532979]  <IRQ>  [<ffffffff8024b877>] trace_hardirqs_on+0xd7/0x180
> [   68.533168]  [<ffffffff80511f5b>] _spin_unlock_irq+0x2b/0x40
> [   68.533295]  [<ffffffff88032747>] :qla2xxx:qla2x00_process_completed_request+0x137/0x1d0
> [   68.533457]  [<ffffffff88032862>] :qla2xxx:qla2x00_status_entry+0x82/0xa40
> [   68.533577]  [<ffffffff8024b17f>] __lock_acquire+0xcdf/0xd90
> [   68.533693]  [<ffffffff80511ff2>] _spin_unlock_irqrestore+0x42/0x60
> [   68.533816]  [<ffffffff880343fe>] :qla2xxx:qla24xx_intr_handler+0x4e/0x2b0
> [   68.533942]  [<ffffffff88033551>] :qla2xxx:qla24xx_process_response_queue+0xc1/0x1c0
> [   68.534102]  [<ffffffff88034584>] :qla2xxx:qla24xx_intr_handler+0x1d4/0x2b0

Ok, since 2.6.20, there been a patch added to qla2xxx which drops the
spin_unlock_irq() call while attempting to ramp-up the queue-depth:

	commit befede3dabd204e9c546cbfbe391b29286c57da2
	Author: Seokmann Ju <seokmann.ju@qlogic.com>
	Date:   Tue Jan 9 11:37:52 2007 -0800

	    [SCSI] qla2xxx: correct locking while call starget_for_each_device()

	    Removed spin_unlock_irq()/spin_lock_irq() pairs surrounding
	    starget_for_each_device() calls.
	    As Matthew W. pointed out, starget_for_each_device() can be called under
	    a spinlock being held.
	    The change has been tested and verified on qla2xxx.ko module.
	    Thanks Matthew W. and Hisashi H. for help.

	    Signed-off-by: Andrew Vasquez <Andrew.vasquez@qlogic.com>
	    Signed-off-by: Seokmann Ju <Seokmann.ju@qlogic.com>
	    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

	http://marc.theaimsgroup.com/?l=linux-scsi&m=116837234904583&w=2

Could you try the latest 2.6.21-rc which contains the correction?

Regards,
Andrew Vasquez
