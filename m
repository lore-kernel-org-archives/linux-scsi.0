From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
Date: Wed, 4 Mar 2009 03:01:56 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>  <1236097526.3263.17.camel@localhost.localdomain>
  <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain> <1236119195.24019.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1236119195.24019.24.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Mar 2009, James Bottomley wrote:

> On Tue, 2009-03-03 at 23:07 +0100, Thomas Gleixner wrote:
> > On Tue, 3 Mar 2009, Thomas Gleixner wrote:
> > > My bad. I was playing with that to get rid of the aic7xxx wreckage on
> > > one of my test boxen and forgot to remove it.
> > 
> > While the one below is definitey not my fault. It's on Linus latest:
> > 
> >  commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66
> > 
> > While compiling a kernel I triggerred the BUG below. Not so nice as it
> > took a whole filesystem with it. fsck took more than 20 min to recover
> > the leftovers :(
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> > 
> > ------------[ cut here ]------------
> > kernel BUG at /home/tglx/work/kernel/git/linux-2.6/drivers/scsi/scsi_lib.c:1141!
> 
> This is BUG_ON(count > sdb->table.nents);
> 
> It looks like the sg list got split and grew in size ... I suspect this
> might be libata related, so cc'ing the ide list.  I suspect either the
> block layer initially parametrised this wrongly (tomo bug) or a sg list
> got split then requeued (something in libata?).

FYI, after I've lost a full day of work including the results of four
"iozone -a -g 4G" runs I tried to reproduce the problem on that
machine - the leftovers of the filesystem are pretty useless anyway.

It took about 2hrs to trigger the bug again. Same back trace.

Anything I can do what might help to decode the problem ?

Thanks,

	tglx
