From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test.
Date: Thu, 29 Mar 2007 10:17:18 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9C85@otce2k301.adaptec.com>
References: <20070329031156.GA9582@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56878 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbXC2ORV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 10:17:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070329031156.GA9582@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com, Judith Lebzelter <judith@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, AACRAID <aacraid@adaptec.com>, fastboot@lists.osdl.org

I have been working on a patch to the driver to do just this, reset the
adapter during init if necessary. We want to limit the adapter's reset
as it takes time (an additional 45 seconds or longer) for the Firmware
to cycle... I will bump the priority of the testing for this patch.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com] 
> Sent: Wednesday, March 28, 2007 11:12 PM
> To: Judith Lebzelter
> Cc: linux-scsi@vger.kernel.org; AACRAID; fastboot@lists.osdl.org
> Subject: Re: [Fastboot] Panics for AACRAID driver during 
> 'insmod' for kexec test.
> 
> 
> On Wed, Mar 28, 2007 at 02:54:32PM -0700, Judith Lebzelter wrote:
> > Hello, 
> > 
> > I have been running a series of kexec tests using LKDTT on the 
> > aacraid driver on this card (ASR-4805SAS (Marauder-E)) on x86_64
> > using the latest top of scsi-misc git-tree(as of yesterday), and 
> > I have found that it is not coming up consistantly when booted 
> > through kexec.
> > 
> > I have included 4 different types of failures I found here because 
> > I assume they might be related, and thought maybe there could 
> > be an issue with the card's state on reboot (through kexec).
> > 
> > The most common problem is this oops/panic, which has happened 
> > with various types of crash points (6 times out of 40):
> > 
> > Loading aacraid.Adaptec aacraid driver (1.1-5[2437]-mh4)^M
> > ko module^M
> > ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNKC] -> GSI 3 
> (level, low) -> IRQ 3^M
> > general protection fault: 0000 [1] ^M
> > CPU 0 ^M
> > Modules linked in: aacraid^M
> > Pid: 0, comm: swapper Not tainted 2.6.21-rc3-kdump #1^M
> > RIP: 0010:[<ffffffff88008a99>]  [<ffffffff88008a99>] 
> :aacraid:aac_intr_normal+0x17a/0x1b1^M
> > RSP: 0000:ffffffff81523ed8  EFLAGS: 00010006^M
> > RAX: ffff810004102000 RBX: ffff8100014f01e0 RCX: 0000000000000086^M
> > RDX: ffff810004041540 RSI: ffff8100014f01e0 RDI: cccccccccccccccc^M
> > RBP: ffff810004702cd8 R08: 00000000a6037e6c R09: 00000016001562d7^M
> > R10: 0000000000000023 R11: 0000000000000000 R12: 0000000000000011^M
> > R13: ffff810004702cd8 R14: ffff810004001400 R15: 0000000000000000^M
> > FS:  0000000000000000(0000) GS:ffffffff814d5000(0000) 
> knlGS:0000000000000000^M
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b^M
> > CR2: 00000000006ba5a0 CR3: 000000000474d000 CR4: 00000000000006e0^M
> > Process swapper (pid: 0, threadinfo ffffffff814e4000, task 
> ffffffff81470360)^M
> > Stack:  0000000000000011 ffff810004702cd8 0000000000000100 
> 0000000000000003^M
> >  0000000000000001 ffffffff88009470 0000000000000000 
> ffff810004041540^M
> >  ffffffff814d5080 ffffffff810428f4 0000000000000000 
> ffffffff814d5080^M
> > Call Trace:^M
> >  <IRQ>  [<ffffffff88009470>] 
> :aacraid:aac_rx_intr_message+0x2c/0x60^M
> >  [<ffffffff810428f4>] note_interrupt+0xd3/0x1db^M
> >  [<ffffffff8104319b>] handle_level_irq+0x7e/0xab^M
> >  [<ffffffff8100b0b1>] do_IRQ+0xd7/0x132^M
> >  [<ffffffff810085a1>] mwait_idle+0x0/0x43^M
> >  [<ffffffff81009651>] ret_from_intr+0x0/0xa^M
> >  <EOI>  [<ffffffff810085e0>] mwait_idle+0x3f/0x43^M
> >  [<ffffffff81008540>] cpu_idle+0x3d/0x5c^M
> >  [<ffffffff814e78d2>] start_kernel+0x28f/0x29b^M
> >  [<ffffffff814e7140>] _sinittext+0x140/0x144^M
> > ^M
> > ^M
> > Code: ff 53 38 eb 20 9c 58 fa 83 7b 30 00 75 07 c7 43 30 01 00 00 ^M
> > RIP  [<ffffffff88008a99>] :aacraid:aac_intr_normal+0x17a/0x1b1^M
> > Kernel panic - not syncing: Aiee, killing interrupt handler!^M
> >  
> > 
> 
> I don't much about the aacraid code but looking little bit, 
> it looks like
> the typical case where driver in second kernel receives the pending
> interrupt from the device and in the interrupt handler it 
> accesses some
> data structures which are not even initialized yet. This 
> interrupt must
> have been pending from crashed kernel's context.
> 
> Either we should reset the device before doing request_irq(), so that
> interrupts are cleared or do some kind of ABORT, FLUSH messages or
> whatever the card firmware supports to clear the pending 
> interrupts and 
> flush exisiting commands before doing request_irq().
> 
> Thanks
> Vivek
> 
