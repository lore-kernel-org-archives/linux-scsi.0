From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm 2008-12-30-16-05] Warning at MPT driver initialization.
Date: Mon, 12 Jan 2009 14:19:14 -0800
Message-ID: <20090112141914.7517cc2c.akpm@linux-foundation.org>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
	<200901011051.ICE39590.JOFQLHFtSFMVOO@I-love.SAKURA.ne.jp>
	<20081231182613.a37eab90.akpm@linux-foundation.org>
	<7e0fb38c0901050845u3140d2c5iac7ab6c269fc5ec7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZALWTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 17:19:50 -0500
In-Reply-To: <7e0fb38c0901050845u3140d2c5iac7ab6c269fc5ec7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Paris <eparis@parisplace.org>
Cc: penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Mon, 5 Jan 2009 11:45:07 -0500
"Eric Paris" <eparis@parisplace.org> wrote:

> >> Fusion MPT base driver 3.04.07
> >> Copyright (c) 1999-2008 LSI Corporation
> >> Fusion MPT SPI Host driver 3.04.07
> >> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> >> PCI: setting IRQ 11 as level-triggered
> >> mptspi 0000:00:10.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> >> mptbase: ioc0: Initiating bringup
> >> ioc0: LSI53C1030 B0: Capabilities={Initiator}
> >> ODEBUG: object is on stack, but not annotated
> >> ------------[ cut here ]------------
> >> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x1f3/0x276()
> >> Hardware name: VMware Virtual Platform
> >> Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi ext3 jbd mbcache
> >> Pid: 540, comm: insmod Not tainted 2.6.28-mm1 #2
> >> Call Trace:
> >>  [<c042c51c>] warn_slowpath+0x74/0x8a
> >>  [<c0469600>] ? start_critical_timing+0x96/0xb7
> >>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
> >>  [<c0446fad>] ? trace_hardirqs_off_caller+0x18/0xaf
> >>  [<c044704f>] ? trace_hardirqs_off+0xb/0xd
> >>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
> >>  [<c042cb84>] ? release_console_sem+0x1a5/0x1ad
> >>  [<c05013e6>] __debug_object_init+0x1f3/0x276
> >>  [<c0501494>] debug_object_init+0x13/0x17
> >>  [<c0433c56>] init_timer+0x10/0x1a
> >>  [<e08e5b54>] mpt_config+0x1c1/0x2b7 [mptbase]
> >>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
> >>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
> >>  [<e08e6fa2>] mpt_do_ioc_recovery+0x950/0x1212 [mptbase]
> >>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
> >>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
> >>  [<c060c3af>] ? _spin_unlock_irq+0x22/0x26
> >>  [<c04f2d8b>] ? string+0x2b/0x76
> >>  [<c04f310e>] ? vsnprintf+0x338/0x7b3
> >>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
> >>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
> >>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
> >>  [<c044897d>] ? debug_check_no_locks_freed+0xeb/0x105
> >>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
> >>  [<c04488bc>] ? debug_check_no_locks_freed+0x2a/0x105
> >>  [<c0446b8c>] ? lock_release_holdtime+0x43/0x48
> >>  [<c043f742>] ? up_read+0x16/0x29
> >>  [<c05076f8>] ? pci_get_slot+0x66/0x72
> >>  [<e08e89ca>] mpt_attach+0x881/0x9b1 [mptbase]
> >>  [<e091c8e5>] mptspi_probe+0x11/0x354 [mptspi]
> >
> > Well it's the debugobjects stuff complaining about
> > init_timer(&pCfg->timer) in mpt_config().
> >
> > I spent a minute trying to work out what the heck
> > debug_object_is_on_stack() is trying to tell me, but it seems that code
> > was designed to only be used by Thomas, so let's cc him and ask.
> >
> > Thomas, could we have some nice code comments please, so that random
> > kernel developers don't need to go and reverse engineer the
> > debugobjects design before they can work out what they did wrong?

^^ this?

> Noticing that every caller of mpt_config has its CONFIGPARMS struct
> declared on the stack and thus the &pCfg->timer is always on the stack
> I changed init_timer() to init_timer_on_stack() and it seems to have
> shut up.....
> 
> Admittedly I don't know either the debugobject code or the mpt code,
> but when the timer is on the stack and we have an "init when the timer
> is on the stack" it seemed like an easy enough fix.

yeah, I don't have a clue why that warning came out either, and I don't
know what it's trying to tell us.  This is a bad situation!

Thomas, please help?

> [tmp.patch  application/octet-stream (561B)]

Bah.
