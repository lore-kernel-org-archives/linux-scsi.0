From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: cciss: WARNING/BUG in do_cciss_intr (it's back)
Date: Fri, 6 Feb 2009 08:44:28 +0100
Message-ID: <20090206074427.GR30821@kernel.dk>
References: <4989D435.7010003@oracle.com> <0F5B06BAB751E047AB5C87D1F77A778859F9EAD9D5@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:13912 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZBFHqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 02:46:31 -0500
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778859F9EAD9D5@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, ISS StorageDev <iss_storagedev@hp.com>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, Feb 05 2009, Miller, Mike (OS Dev) wrote:
>  
> 
> > -----Original Message-----
> > From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> > Sent: Wednesday, February 04, 2009 11:45 AM
> > To: Miller, Mike (OS Dev); ISS StorageDev; scsi; Linux Kernel 
> > Mailing List
> > Subject: cciss: WARNING/BUG in do_cciss_intr (it's back)
> > 
> > Hi Mike,
> > 
> > Was there any debugging code added to try to help with this problem?
> > or is that the WARNING before the BUG?
> > 
> 
> Randy,
> I think this is a different bug than the one you reported previously.
> Please open a new bugzilla.

I think it's the same one. The first warning that now triggers is:

WARNING: at drivers/block/cciss.c:225 

which is

        if (WARN_ON(hlist_unhashed(&c->list)))

removeQ(), this is where we would have crashed before due to trying to
remove a command from a list it didn't belong to. And then we crash
right after in the interrupt handler. So I'm pretty sure this is 100%
the same bug.

Randy, is this still using kexec? Perhaps cciss needs a better
kick-in-the-pants reset on driver load to clear EVERYTHING, there's
clearly something very bad happening there.


> 
> Thanks,
> -- mikem
> 
> > 
> > Booting 2.6.29-rc3-git6 oopsed with:
> > 
> > calling  cciss_init+0x0/0x2e [cciss] @ 733 HP CISS Driver (v 3.6.20)
> > ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54 cciss 
> > 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) 
> > -> IRQ 54 cciss 0000:42:08.0: irq 56 for MSI/MSI-X IRQ 
> > 56/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
> > cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 56 using DAC 
> > ------------[ cut here ]------------
> > WARNING: at drivers/block/cciss.c:225 
> > do_cciss_intr+0x58f/0x99a [cciss]() Hardware name: ProLiant 
> > BL685c G1 Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > Pid: 0, comm: swapper Not tainted 2.6.29-rc3-git6 #1 Call Trace:
> >  <IRQ>  [<ffffffff8023a741>] warn_slowpath+0xd3/0xf2  
> > [<ffffffff80243a44>] ? __mod_timer+0xc1/0xd3  
> > [<ffffffff8041469f>] ? smi_timeout+0xd9/0xe5  
> > [<ffffffff8024f86a>] ? ktime_get_ts+0x49/0x4e  
> > [<ffffffff804145c6>] ? smi_timeout+0x0/0xe5  
> > [<ffffffffa0024c4b>] do_cciss_intr+0x58f/0x99a [cciss]  
> > [<ffffffff8026ed21>] handle_IRQ_event+0x27/0x57  
> > [<ffffffff8027057d>] handle_edge_irq+0xde/0x11f  
> > [<ffffffff8020e302>] do_IRQ+0xdc/0x152  [<ffffffff8020ca13>] 
> > ret_from_intr+0x0/0xa  <EOI> <4>---[ end trace a8b437cd48391e28 ]---
> > BUG: unable to handle kernel NULL pointer dereference at 
> > 00000000000000f4
> > IP: [<ffffffffa0024c93>] do_cciss_intr+0x5d7/0x99a [cciss] PGD 0
> > Oops: 0002 [#1] SMP
> > last sysfs file: /sys/block/ram15/dev
> > CPU 2
> > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc3-git6 #1
> > RIP: 0010:[<ffffffffa0024c93>]  [<ffffffffa0024c93>] 
> > do_cciss_intr+0x5d7/0x99a [cciss]
> > RSP: 0018:ffff88027f12fef0  EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff88007f840270 RCX: 0000000000013888
> > RDX: 0000000000008080 RSI: 0000000000000046 RDI: 0000000000000009
> > RBP: ffff88027f12ff20 R08: 000000447f12fa70 R09: ffff88017e540700
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007f8404b0
> > R13: ffff88027e1a0000 R14: 0000000000000000 R15: 0000000000000086
> > FS:  0000000000680850(0000) GS:ffff88017f121380(0000) 
> > knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00000000000000f4 CR3: 0000000000201000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> > 0000000000000400 Process swapper (pid: 0, threadinfo 
> > ffff88017f164000, task ffff88017fa5d4c0)
> > Stack:
> >  0000000000000001 ffff88027f126280 0000000000000000 0000000000000000
> >  0000000000000038 0000000000000000 ffff88027f12ff50 
> > ffffffff8026ed21  ffffffff8076e000 0000000000000038 
> > ffff88027f126280 ffffffff8076e054 Call Trace:
> >  <IRQ> <0> [<ffffffff8026ed21>] handle_IRQ_event+0x27/0x57  
> > [<ffffffff8027057d>] handle_edge_irq+0xde/0x11f  
> > [<ffffffff8020e302>] do_IRQ+0xdc/0x152  [<ffffffff8020ca13>] 
> > ret_from_intr+0x0/0xa  <EOI> <0>Code: 50 08 48 c7 83 40 02 00 
> > 00 00 00 00 00 49 c7 44 24 08 00 00 00 00 8b 83 34 02 00 00 
> > 85 c0 0f 85 49 03 00 00 4c 8b b3 50 02 00 00 <41> c7 86 f4 00 
> > 00 00 00 00 00 00 4c 8b 83 28 02 00 00 66 41 8b RIP  
> > [<ffffffffa0024c93>] do_cciss_intr+0x5d7/0x99a [cciss]  RSP 
> > <ffff88027f12fef0>
> > CR2: 00000000000000f4
> > ---[ end trace a8b437cd48391e29 ]---
> > Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > 
> > 
> > This is on an HP ProLiant BL685c G1, 4-proc system with
> > 8 GB of RAM.  (same as previous reports)
> > 
> > 
> > Rebooting worked successfully.
> > 
> > Thanks,
> > --
> > ~Randy
> > 
-- 
Jens Axboe

