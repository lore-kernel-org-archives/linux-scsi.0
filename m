From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: More FC Transport Issues
Date: Fri, 23 Dec 2005 11:47:54 -0800
Message-ID: <20051223194754.GF1112@andrew-vasquezs-powerbook-g4-15.local>
References: <43AB36BC.8000003@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:54896 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1161029AbVLWTsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 14:48:00 -0500
Content-Disposition: inline
In-Reply-To: <43AB36BC.8000003@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@SGI.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@SGI.com>

On Thu, 22 Dec 2005, Michael Reed wrote:

> I installed 2.6.15-rc6-git3 on my ia64 test system and the system hung during
> startup.  There were "recursion depth exceeded" messages.
> 
> The fabric was coming online at the time of hba startup and the targets
> hadn't yet been discovered by the switch.  Consequently, the hbas saw
> loop up but no targets, then the switch generates a state change notification
> and the driver for the hbas discovers the targets in parallel.
> 
> So, there appears to be another recursion issue with the new fc transport.
> 
> I then try rebooting the system again.  Discovery happens as expected
> at the time the driver initializes each card.  Then the system takes an
> OOPS.
> 
<snip>
> QLogic Fibre Channel HBA Driver
> ACPI: PCI Interrupt 0002:01:04.0[A]: no GSI
> qla2300 0002:01:04.0: Found an ISP2312, irq 74, iobase 0xc00000080fd00000
> qla2300 0002:01:04.0: Configuring PCI space...
> PCI: slot 0002:01:04.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
> qla2300 0002:01:04.0: Configure NVRAM parameters...
> qla2300 0002:01:04.0: Verifying loaded RISC code...
> qla2300 0002:01:04.0: LIP reset occured (f7f7).
> qla2300 0002:01:04.0: Waiting for LIP to complete...
> qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
> qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
> BUG: soft lockup detected on CPU#0!
> Modules linked in:
> 
> Pid: 1, CPU 0, comm:              swapper
> psr : 00001210081a6018 ifs : 8000000000000286 ip  : [<a0000001006c77c1>]    Not tainted
> ip is at _spin_unlock_irqrestore+0x41/0xa0
> unat: 0000000000000000 pfs : 0000000000000691 rsc : 0000000000000003
> rnat: 0000000000000286 bsps: 0000000000000003 pr  : 00000001502a9a55
> ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
> csd : 0000000000000000 ssd : 0000000000000000
> b0  : a0000001005537f0 b6  : e0000030023e5490 b7  : a000000100553260
> f6  : 1003e00000000000003e8 f7  : 0ffe4c000000000000000
> f8  : 1003e0000000000002710 f9  : 1003e000000000000000a
> f10 : 10000bffffffff4000000 f11 : 1003e0000000000000003
> r1  : a000000100cc2100 r2  : 0000000000000001 r3  : a000000100ac2850
> r8  : 0000000000004000 r9  : 0000000000004000 r10 : e000003003104232
> r11 : 0000000000000000 r12 : e00000b07bb279f0 r13 : e00000b07bb20000
> r14 : e000003014d48000 r15 : 0000000000000011 r16 : e000003014d49370
> r17 : 0000000000000000 r18 : e000003014d49378 r19 : 0000000000000000
> r20 : 0000000000000020 r21 : 0000000000000000 r22 : e000003003104231
> r23 : ffffffffffff4230 r24 : 0000000000000078 r25 : 0000000000000000
> r26 : 0000000000000012 r27 : c00000080fe30000 r28 : c00000080fa00200
> r29 : e000003014d49370 r30 : 0000000000000088 r31 : a0000001007648d8
> 
> Call Trace:
>  [<a000000100013260>] show_stack+0x40/0xa0
>                                 sp=e00000b07bb27640 bsp=e00000b07bb21660
>  [<a000000100013a90>] show_regs+0x7d0/0x800
>                                 sp=e00000b07bb27810 bsp=e00000b07bb21610
>  [<a0000001000fa020>] softlockup_tick+0x140/0x180
>                                 sp=e00000b07bb27810 bsp=e00000b07bb215d8

I believe I had posted a patch earlier which attempted to address
this:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=113399970127421&w=2

at least we could get rid of this soft-lockup noise.

--
av
