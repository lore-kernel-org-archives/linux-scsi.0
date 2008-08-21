From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 21 Aug 2008 15:48:35 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
References: <48AD02B2.7020004@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
 <20080821084333.c471b439.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20625 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYHUPth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 11:49:37 -0400
In-Reply-To: <20080821084333.c471b439.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>



> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Thursday, August 21, 2008 10:44 AM
> To: Miller, Mike (OS Dev)
> Cc: lkml; scsi; akpm
> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>
> On Thu, 21 Aug 2008 14:26:06 +0000 Miller, Mike (OS Dev) wrote:
>
> >
> >
> > > -----Original Message-----
> > > From: rdunlap [mailto:randy.dunlap@oracle.com]
> > > Sent: Thursday, August 21, 2008 12:53 AM
> > > To: lkml; scsi; Miller, Mike (OS Dev)
> > > Subject: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> > >
> > > on x86_64, 4 proc, 8 GB RAM:
> > >
> > > calling  cciss_init+0x0/0x2e [cciss] HP CISS Driver (v 3.6.20)
> > > ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54 cciss
> > > 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high)
> > > -> IRQ 54
> > > cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
> > > BUG: unable to handle kernel NULL pointer dereference at
> > > 0000000000000248
> > > IP: [<ffffffffa001bb68>] do_cciss_intr+0x627/0xa6c [cciss] PGD
> > > 17e422067 PUD 17e423067 PMD 0
> > > Oops: 0002 [1] SMP
> > > CPU 2
> > > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > > Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > > RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > > do_cciss_intr+0x627/0xa6c [cciss]
> > > RSP: 0018:ffff88027f66fee8  EFLAGS: 00010007
> > > RAX: 0000000000000000 RBX: ffff88007f840270 RCX: 000000000000000c
> > > RDX: 0000000000000000 RSI: ffff88027e5c0000 RDI: ffff88027e5c0000
> > > RBP: ffff88027f66ff18 R08: 0000000000000000 R09: ffff88017fa95e88
> > > R10: 0000000000000000 R11: ffff88027f66ff48 R12: ffff88027e5c0000
> > > R13: 0000000000000000 R14: 00000000000001f7 R15: 0000000000000086
> > > FS:  0000000000680850(0000) GS:ffff88017fc02c80(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > CR2: 0000000000000248 CR3: 000000017e425000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > 0000000000000400 Process swapper (pid: 0, threadinfo
> > > ffff88017fa94000, task ffff88027f63d340)
> > > Stack:  ffff88027f66fee0 ffff88017e9b4800 0000000000000000
> > > 0000000000000000
> > >  00000000000001f7 0000000000000000 ffff88027f66ff48
> ffffffff8026757e
> > > ffffffff80719000 00000000000001f7 ffff88017e9b4800
> ffffffff80719050
> > > Call Trace:
> > >  <IRQ>  [<ffffffff8026757e>] handle_IRQ_event+0x27/0x57
> > > [<ffffffff80268d08>] handle_edge_irq+0xed/0x12e
> [<ffffffff8020eaab>]
> > > do_IRQ+0xf6/0x167  [<ffffffff8020c471>]
> ret_from_intr+0x0/0xa  <EOI>
> > > [<ffffffff802122b1>] ?
> > > default_idle+0x2b/0x40  [<ffffffff802124bf>] ?
> > > c1e_idle+0xd4/0xdb  [<ffffffff8055677d>] ?
> > > atomic_notifier_call_chain+0xf/0x11
> > >  [<ffffffff8020ac6c>] ? cpu_idle+0x71/0x8f [<ffffffff8054e752>] ?
> > > start_secondary+0x157/0x15c
> > >
> > >
> > > Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00
> 01 00 75 08
> > > 49 89 84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b
> > > 93 48 02 00 00 <48> 89 90 48 02 00 00 48 8b 93 48 02 00 00 48
> > > 89 82 40 02 00 00 RIP  [<ffffffffa001bb68>]
> > > do_cciss_intr+0x627/0xa6c [cciss]  RSP <ffff88027f66fee8>
> > > CR2: 0000000000000248
> > > ---[ end trace 902dc79a9e72d3ed ]---
> > >
> >
> > Randy,
> > Sorry I haven't replied sooner. I saw your earlier mail,
> just been busy breaking stuff internally. Did this happen
> during driver init or runtime?
>
> Hi Mike,
>
> It's very much during driver init.
>
> Full boot log and .config are attached.
>
> Andrew:  I'll rerun the test ASAP.  Machine is busy atm.

Randy,
We know of a race condition in cciss_init_one. It's fixed in 2.6.26 I believe. Here's the patch:

http://groups.google.com/group/linux.kernel/browse_thread/thread/7b39f2b77622ab03/4f5f45c008655ca1?hl=en&lnk=gst&q=cciss#4f5f45c008655ca1

-- mikem


>
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland,
> Oregon USA http://linuxplumbersconf.org/
>
