From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Date: Thu, 31 Jan 2008 20:41:13 +0100
Message-ID: <20080131194113.GA3925@uranus.ravnborg.org>
References: <20080130223219.GT29368@does.not.exist> <20080131074436.GA31966@uranus.ravnborg.org> <1201795051.3131.13.camel@localhost.localdomain> <20080131081120.27505dc0@laptopd505.fenrus.org> <20080131162141.GC19700@cs181133002.pp.htv.fi> <20080131090749.72781689@laptopd505.fenrus.org> <20080131171436.GG19700@cs181133002.pp.htv.fi> <20080131094801.63a048f0@laptopd505.fenrus.org> <20080131183425.GA2893@uranus.ravnborg.org> <20080131104811.4c2d558f@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:44959 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbYAaTlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:41:14 -0500
Content-Disposition: inline
In-Reply-To: <20080131104811.4c2d558f@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Thu, Jan 31, 2008 at 10:48:11AM -0800, Arjan van de Ven wrote:
> On Thu, 31 Jan 2008 19:34:25 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Thu, Jan 31, 2008 at 09:48:01AM -0800, Arjan van de Ven wrote:
> > > On Thu, 31 Jan 2008 19:14:36 +0200
> > > Adrian Bunk <bunk@kernel.org> wrote:
> > > > > cpuhotplug is required for suspend/resume.
> > > > 
> > > > Not on UP computers.
> > > > 
> > > 
> > > great! someone who still has one of those and uses a kernel without
> > > it. Can you look at your system.map and see how many kilobytes
> > > you've gained? Eg how many kilobytes are in these sections exactly?
> > I have one. A Atmel AT91 board equipped with an 9263.
> > So lets take a look at the defconfig build for the evaluation board.
> > 
> > 
> > o-arm/vmlinux.o:     file format elf32-littlearm
> > 
> >   0 .text         001cdefc  00000000  00000000  00000400  2**10
> >   2 .init.text    000165e8  00000000  00000000  001ce6c0  2**5
> >  26 .init.data    000032ec  00000000  00000000  002578cc  2**2
> > 
> > ---
> > 
> >   4 .devinit.text 00001558  00000000  00000000  001e5270  2**2
> >   9 .exit.text    00000bc8  00000000  00000000  001e8d2c  2**2
> >  10 .cpuinit.text 00000924  00000000  00000000  001e98f4  2**2
> >  11 .meminit.text 000004cc  00000000  00000000  001ea218  2**2
> >  12 .devexit.text 00000160  00000000  00000000  001ea6e4  2**2
> >  38 .cpuinit.data 00000040  00000000  00000000  0025afc0  2**2
> >  39 .meminit.data 0000000c  00000000  00000000  0025b000  2**2
> > 
> > 
> > __devinit alone gives a net win of 5464 bytes.
> > That is only ~3% of total .text size but this is non-swapable
> > memory where everything is worth it.
> 
> now how much of this is lost again because you have to round the stuff to pagesize?

Lets take a look in the ARM vmlinux.lds.S file:
       .text.head : {
                _stext = .;
                _sinittext = .;
                *(.text.head)
        }

        .init : {                       /* Init code and data           */
                        INIT_TEXT
                _einittext = .;
                __proc_info_begin = .;
                        *(.proc.info.init)
                __proc_info_end = .;
                __arch_info_begin = .;
                        *(.arch.info.init)
                __arch_info_end = .;
                __tagtable_begin = .;
                        *(.taglist.init)
                __tagtable_end = .;
                . = ALIGN(16);
                __setup_start = .;
                        *(.init.setup)
                __setup_end = .;
                __early_begin = .;
                        *(.early_param.init)
                __early_end = .;
                __initcall_start = .;
                        INITCALLS
                __initcall_end = .;
                __con_initcall_start = .;
                        *(.con_initcall.init)
                __con_initcall_end = .;
                __security_initcall_start = .;
                        *(.security_initcall.init)
                __security_initcall_end = .;
#ifdef CONFIG_BLK_DEV_INITRD
                . = ALIGN(32);
                __initramfs_start = .;
                        usr/built-in.o(.init.ramfs)
                __initramfs_end = .;
#endif
                . = ALIGN(4096);
                __per_cpu_start = .;
                        *(.data.percpu)
                        *(.data.percpu.shared_aligned)
                __per_cpu_end = .;
#ifndef CONFIG_XIP_KERNEL
                __init_begin = _stext;
                INIT_DATA
                . = ALIGN(4096);
                __init_end = .;

Everything between _stext and __init_end are freed.
And we have two PAGESIZE alignmnets here - one for the percpu stuff
and the other to align the full area that can be freed.
So there is no special alignment for the __devinit stuff.

And there is no percpu data on ARM so that area is empty.
So it is one or two pages extra that are freed up.

	Sam

 
