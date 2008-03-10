From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL
	pointer dereference
Date: Mon, 10 Mar 2008 16:12:57 -0500
Message-ID: <1205183577.2941.38.camel@localhost.localdomain>
References: <867igc3w8r.fsf@deprecated.bitebene.org>
	 <47D551B8.9080807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35863 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbYCJVNE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 17:13:04 -0400
In-Reply-To: <47D551B8.9080807@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon, 2008-03-10 at 17:20 +0200, Boaz Harrosh wrote:
> On Sun, Mar 09 2008 at 14:41 +0200, Sven Schnelle <svens@stackframe.org> wrote:
> > Hi,
> > 
> > i'm facing the following kernel oops with the latest git:
> > 
> > --------------------------------------8<--------------------------------------
> > Stopping MD arrays...failed (no MD subsystem loaded).
> > Mounting root filesystem read-only...done.
> > Will now restart.
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > IP: [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
> > PGD 7e51e067 PUD 7e6a1067 PMD 0 
> > Oops: 0002 [1] PREEMPT SMP 
> > CPU 3 
> > Modules linked in: nvidia(P) lm85 hwmon_vid hwmon [last unloaded: nvidia]
> > Pid: 0, comm: swapper Tainted: P         2.6.25-rc4-smp-00134-g84c6f60 #11 
> > RIP: 0010:[<ffffffff8051a97e>]  [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
> > RSP: 0018:ffff81007fbefed8  EFLAGS: 00010086
> > RAX: 0000000000000000 RBX: ffff81007e0dda68 RCX: 0000000000000002
> > RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffc20000330000
> > RBP: ffff81007fbeff08 R08: 0000000000000000 R09: ffff81007f01de70
> > R10: 0000000000000000 R11: 0000000000000050 R12: ffff810000b10480
> > R13: ffff810000b104ff R14: ffff81007e214200 R15: 0000000000000009
> > FS:  0000000000000000(0000) GS:ffff81007f802c80(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 000000007e643000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process swapper (pid: 0, threadinfo ffff81007fbe6000, task ffff81007fbe4000)
> > Stack:  0000000000000046 ffff81007e8a93c0 0000000000000000 0000000000000000
> >  0000000000000018 0000000000000003 ffff81007fbeff18 ffffffff8051ab9f
> >  ffff81007fbeff48 ffffffff80258cc2 ffffffff8092e300 ffff81007e8a93c0
> > Call Trace:
> >  <IRQ>  [<ffffffff8051ab9f>] gdth_interrupt+0x10/0x12
> >  [<ffffffff80258cc2>] handle_IRQ_event+0x27/0x57
> >  [<ffffffff8025a055>] handle_fasteoi_irq+0x9c/0xdc
> >  [<ffffffff8020def0>] do_IRQ+0x88/0xfc
> >  [<ffffffff80209ffe>] ? default_idle+0x0/0x5f
> >  [<ffffffff8020b851>] ret_from_intr+0x0/0xa
> >  <EOI>  [<ffffffff8020a037>] ? default_idle+0x39/0x5f
> >  [<ffffffff8020a032>] ? default_idle+0x34/0x5f
> >  [<ffffffff80209ffe>] ? default_idle+0x0/0x5f
> >  [<ffffffff8020a11c>] ? cpu_idle+0xbf/0xf5
> >  [<ffffffff806cd973>] ? start_secondary+0x3e0/0x3ef
> > 
> > 
> > Code: 00 04 eb 15 3c 17 75 11 41 0f b6 c5 48 c1 e0 05 41 80 a4 04 92 02 00 00 fb 41 c7 86 18 01 00 00 00 00 00 00 49 8b 86 c0 00 00 00 <c6> 00 00 e9 92 01 00 00 66 89 43 24 41 8b 84 24 68 02 00 00 89 
> > RIP  [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
> >  RSP <ffff81007fbefed8>
> > CR2: 0000000000000000
> > ---[ end trace e81e561a458e8791 ]---
> > Kernel panic - not syncing: Aiee, killing interrupt handler!
> > Rebooting in 5 seconds..
> > --------------------------------------8<--------------------------------------
> > 
> > From 2dc63f9f8e61fd1c89f8b4d9b2d174be1c3bfbe2 Mon Sep 17 00:00:00 2001
> > From: root <root@apollo.bitebene.org>
> > Date: Sun, 9 Mar 2008 13:25:07 +0100
> > Subject: 
> > 
> > This fixes a NULL pointer dereference during execution of Internal commands,
> > where gdth only allocates scp, but not scp->sense_buffer. The rest of
> > the code assumes that sense_buffer is allocated, which leads to a kernel
> > oops e.g. on reboot (during cache flush).
> > 
> > So we have two choices here:
> > 
> > a) Allocate the sense_buffer
> > b) surrounding all accesses to sense_buffer with some if (!internal_command)
> > 
> > I'm using solution a, as this keeps code simpler.
> > 
> > Signed-off-by: Sven Schnelle <svens@stackframe.org>
> > ---
> >  drivers/scsi/gdth.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> > index 27ebd33..0b2080d 100644
> > --- a/drivers/scsi/gdth.c
> > +++ b/drivers/scsi/gdth.c
> > @@ -493,6 +493,12 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
> >      if (!scp)
> >          return -ENOMEM;
> >  
> > +    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> > +    if (!scp->sense_buffer) {
> > +	kfree(scp);
> > +	return -ENOMEM;
> > +    }
> > +
> >      scp->device = sdev;
> >      memset(&cmndinfo, 0, sizeof(cmndinfo));
> >  
> > @@ -513,6 +519,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
> >      rval = cmndinfo.status;
> >      if (info)
> >          *info = cmndinfo.info;
> > +    kfree(scp->sense_buffer);
> >      kfree(scp);
> >      return rval;
> >  }
> James and linux-scsi CCed.

Looks fine .. could someone send the patch in an applyable form (i.e.
not quoted).

> James it looks reasonable. It's a fallout from the sense_buffer separation patches.
> Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> I will submit solution b) above as part of my sense handling patchset.

Um, that looks like it will be a bit nasty, so the simpler fix is
probably the better one (even if the sense buffer simply gets ignored).

The best long term fix for GDTH is probably to make it behave more like
a standard raid driver, so it includes a translation layer from scsi
commands to gdth commands and then the __gdth_execute() can be
reformulated as gdth command injection and we don't have to muck about
with upper layer objects like SCSI commands.

James


