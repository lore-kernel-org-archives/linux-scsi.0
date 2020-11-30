Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20364C64E7D
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 00:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75FB20757
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 00:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgK3AVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 19:21:45 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47392 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgK3AVp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 19:21:45 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 927AC2AA81;
        Sun, 29 Nov 2020 19:21:01 -0500 (EST)
Date:   Mon, 30 Nov 2020 11:21:01 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
In-Reply-To: <X8H8M2AM0hfMX7aj@lx-t490>
Message-ID: <alpine.LNX.2.23.453.2011301118520.6@nippy.intranet>
References: <20201126132952.2287996-1-bigeasy@linutronix.de> <20201126132952.2287996-13-bigeasy@linutronix.de> <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet> <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet> <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
 <X8H8M2AM0hfMX7aj@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 28 Nov 2020, Ahmed S. Darwish wrote:

> On Sat, Nov 28, 2020 at 08:48:00AM +1100, Finn Thain wrote:
> >
> > On Sat, 28 Nov 2020, Finn Thain wrote:
> >
> > >
> > > diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> > > index d654a6cc4162..739def70cffb 100644
> > > --- a/drivers/scsi/NCR5380.c
> > > +++ b/drivers/scsi/NCR5380.c
> > > @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
> > >  		cpu_relax();
> > >  	} while (n--);
> > >
> > > -	if (irqs_disabled() || in_interrupt())
> > > +	/* We can't sleep when local irqs are disabled and callers ensure
> > > +	 * that local irqs are disabled whenever we can't sleep.
> > > +	 */
> > > +	if (irqs_disabled())
> > >  		return -ETIMEDOUT;
> > >
> > >  	/* Repeatedly sleep for 1 ms until deadline */
> > >
> >
> > Michael, Andreas, would you please confirm that this is workable on Atari?
> > The driver could sleep when IPL == 2 because arch_irqs_disabled_flags()
> > would return false (on Atari). I'm wondering whether that would deadlock.
> 
> Please re-check the commit log:
> 
>   "Linus clearly requested that code which changes behaviour depending
>    on context should either be separated, or the context be explicitly
>    conveyed in an argument passed by the caller."
> 

Yes, I knew about the discussion around the issues with preempt_count() 
and CONFIG_PREEMPT. And I don't have any problem with removing 
in_interrupt(), as you can see from my patch.

> So, sorry, drivers shouldn't do context-dependent dances anymore.
> 

I don't know what is meant by 'context-dependent'. I suspect that it's 
left ill-defined because there are many cases where global state is 
needed, such as those mentioned in the thread you cited, like the 
memalloc_no*() calls. See also, in_compat_syscall().

> For more context (no pun intended), please check the thread mentioned in
> the cover letter, and also below message:
> 
>   https://lkml.kernel.org/r/CAKMK7uHAk9-Vy2cof0ws=DrcD52GHiCDiyHbjLd19CgpBU2rKQ@mail.gmail.com
> 

Are you also planning to remove spin_lock_irqsave/restore() and replace 
these with spin_lock_irq/unlock_irq()? And if not, why do you object to 
irqs_disabled()?

Please also compare your patch and mine with regard to stack usage, 
readability and code size. Also consider that adding a new argument to all 
those functions creates new opportunities for mistakes in new callers.

> Kind regards,
> 
> --
> Ahmed S. Darwish
> Linutronix GmbH
> 
