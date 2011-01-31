From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less
	operation
Date: Mon, 31 Jan 2011 12:26:00 -0800
Message-ID: <1296505560.14831.389.camel@haakon2.linux-iscsi.org>
References: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
	 <4D44DA55.7060505@garzik.org>
	 <1296422299.14831.302.camel@haakon2.linux-iscsi.org>
	 <20110131144235.GM27398@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37502 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1AaU0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2011 15:26:06 -0500
In-Reply-To: <20110131144235.GM27398@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-01-31 at 08:42 -0600, scameron@beardog.cce.hp.com wrote:
> On Sun, Jan 30, 2011 at 01:18:19PM -0800, Nicholas A. Bellinger wrote:
> > On Sat, 2011-01-29 at 22:26 -0500, Jeff Garzik wrote:
> > > On 01/29/2011 05:38 PM, Nicholas A. Bellinger wrote:

<SNIP>

> > > > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > > > index 12deffc..e205f33 100644
> > > > --- a/drivers/scsi/hpsa.c
> > > > +++ b/drivers/scsi/hpsa.c
> > > > @@ -1906,9 +1906,11 @@ sglist_finished:
> > > >          return 0;
> > > >   }
> > > >
> > > > -
> > > > -static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> > > > -       void (*done)(struct scsi_cmnd *))
> > > > +/*
> > > > + * Running in struct Scsi_Host->host_lock less mode using LLD internal
> > > > + * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
> > > > + */
> > > 
> > > The way I read this comment, it initially misled me into thinking that 
> > > this queuecommand was somehow wrapped entirely within this protection 
> > > you described.
> > > 
> > > Only after an in-depth review did I figure out that cmd_alloc() and 
> > > enqueue_cmd_and_start_io() did all the locking necessary.
> > > 
> > > Therefore, here are some observations and recommendations:
> > > 
> > > * the code changes are correct.  Reviewed-by: Jeff Garzik 
> > > <jgarzik@redhat.com>
> > > 
> > > * delete the comment.  lack of "_lck" alone tells you its lockless.
> > > 
> > > * I question whether the following hpsa.c logic
> > > 	lock_irqsave
> > > 	cmd_alloc()
> > > 	unlock_irqrestore
> > > 
> > > 	init cmd
> > > 
> > > 	lock_irqsave
> > > 	enqueue
> > > 	unlock_irqrestore
> > >    isn't more expensive than simply
> > > 	lock_irqsave
> > > 	cmd_alloc()
> > > 	init cmd
> > > 	enqueue
> > > 	unlock_irqrestore
> > > 
> > > It seems like the common case would cycle the spinlock and interrupts 
> > > twice for an uncontended lock, which the initialization portion of the 
> > > cmd, which may indeed occur in parallel, is so cheap you'll spend more 
> > > time on the double-lock than anywhere else.
> > > 
> > 
> > Hi Jeff,
> > 
> > I was wondering about the overhead of double h->lock cycle for parallel
> > struct scsi_cmnd -> struct CommandList initialization vs. single h->
> > lock cycle..  Thanks for your input here!
> > 
> 
> I'll defer to Jeff's expertise on this, though some measurements 
> might be nice.  Might be hard to measure though, as I suspect if
> you were able to make this part of the code infinitely fast, you'd
> still have a hard time telling the difference, as commands spend 
> such a small proportion of their lifetimes in there...

Unfortuately I do not have HPSA hardware to test this one in-house, but
this patch is actually intended for John + kernel.org mirrors, whom have
been moving from CCISS raw struct block_device -> HPSA LLD struct
scsi_device recently.

He has been observing some unusually high spin_lock contention on one
particular machine using HPSA LUNs w/ 38-rc2 code, and while it's pretty
certain that the HPSA LLD is not the root culprit, I figured that
getting this code properly converted to run w/o host_lock could not hurt
at this point.

> though if
> it eliminates or mitigates some sort of bad, weird interlocking
> behavior between this code and the interrupt handler or something
> like that, (not that I'm aware of any such bad behavior) I suppose
> it might make a noticeable difference.
>  

Understood, and thanks for the clarification here.  Running with
DEF_SCSI_QCMD() host_lock'ed code w/ the original double h->lock cycle
would have likely prevented any bad behaviour here, so holding h->lock
from before cmd_alloc() until after __enque_cmd_and_start_io() for a
single lock cycle per struct scsi_cmnd would seem to be provide similar
protection.


> > Attached is a v2 to address your comments.
> > 
> > --nab
> > 
> > ------------------------------------------------------------------------
> > 
> > [PATCH] hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
> > 
> > This patch first converts HPSA to run in struct Scsi_Host->host_lock'
> > less operation by removing DEF_SCSI_QCMD() and '_lck' suffix from the
> > hpsa_scsi_queue_command() I/O dispatcher.
> > 
> > Secondly in hpsa_scsi_queue_command() the struct ctlr_info *h->lock is
> > now held a single lock obtain/release cycle while struct CommandList
> > initialization is performed, and enqueued into HW.  This enqueuing
> > is done using a new h->lock unlocked __enqueue_cmd_and_start_io(),
> > wrapper and conversion of the the original enqueue_cmd_and_start_io()
> > to use this new code.
> > 
> > Reviewed-by: Jeff Garzik <jgarzik@redhat.com>
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/hpsa.c |   34 +++++++++++++++++++---------------
> >  1 files changed, 19 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 12deffc..fff7cd4 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -329,16 +329,25 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
> >                 c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
> >  }
> > 
> > -static void enqueue_cmd_and_start_io(struct ctlr_info *h,
> > +/*
> > + * Must be called with struct ctlr_info *h->lock held w/ interrupts disabled
> > + */
> > +static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
> >         struct CommandList *c)
> >  {
> > -       unsigned long flags;
> > -
> >         set_performant_mode(h, c);
> > -       spin_lock_irqsave(&h->lock, flags);
> >         addQ(&h->reqQ, c);
> >         h->Qdepth++;
> >         start_io(h);
> > +}
> > +
> > +static void enqueue_cmd_and_start_io(struct ctlr_info *h,
> > +       struct CommandList *c)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&h->lock, flags);
> > +       __enqueue_cmd_and_start_io(h, c);
> >         spin_unlock_irqrestore(&h->lock, flags);
> >  }
> 
> Should that be "static inline"?  Or maybe the compiler's smart enough
> to decide whether to inline that on its own these days?
> 

Inlining both of these makes sense to me.  I will add this change and
send out an updated [PATCH] with your Reviewed-by shortly.

Thanks for your comments!

--nab

