From: scameron@beardog.cce.hp.com
Subject: Re: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
Date: Mon, 31 Jan 2011 08:42:35 -0600
Message-ID: <20110131144235.GM27398@beardog.cce.hp.com>
References: <1296340702.14831.219.camel@haakon2.linux-iscsi.org> <4D44DA55.7060505@garzik.org> <1296422299.14831.302.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:45603 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1AaOmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2011 09:42:37 -0500
Content-Disposition: inline
In-Reply-To: <1296422299.14831.302.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com

On Sun, Jan 30, 2011 at 01:18:19PM -0800, Nicholas A. Bellinger wrote:
> On Sat, 2011-01-29 at 22:26 -0500, Jeff Garzik wrote:
> > On 01/29/2011 05:38 PM, Nicholas A. Bellinger wrote:
> > > Hi Stephen and Co,
> > >
> > > Attached is a quick patch to enable modern SCSI host_lock' less
> > > operation for the HPSA SCSI LLD driver on>= .37 kernels.  After an
> > > initial LLD conversion and review, I would like to verify with you that
> > > the following calls are currently protected by HPDA LLD internal locks
> > > that disable interrupts from the newly renamed hpsa_scsi_queue_command()
> > > dispatcher below..
> > >
> > > *) For cmd_alloc(), struct ctlr_info *h->lock + spin_lock_irqsave() is
> > > obtained and released.
> > >
> > > *) For enqueue_cmd_and_start_io(), struct ctlr_info *h->lock +
> > > spin_lock_irqsave() is obtained for addQ() + start_io() and released.
> > >
> > > So the one new piece wrt to host_lock less mode that is *not* protected
> > > in hpsa_scsi_queue_command() is the call to hpsa_scatter_gather().  This
> > > should be OK to get called without h->lock held w/ spin_lock_irqsave(),
> > > yes..?
> > >
> > > So far this patch has been compile tested only.  Please have a look and
> > > comment.
> > >
> > > Thanks!
> > >
> > > --nab
> > >
> > > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > > index 12deffc..e205f33 100644
> > > --- a/drivers/scsi/hpsa.c
> > > +++ b/drivers/scsi/hpsa.c
> > > @@ -1906,9 +1906,11 @@ sglist_finished:
> > >          return 0;
> > >   }
> > >
> > > -
> > > -static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> > > -       void (*done)(struct scsi_cmnd *))
> > > +/*
> > > + * Running in struct Scsi_Host->host_lock less mode using LLD internal
> > > + * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
> > > + */
> > 
> > The way I read this comment, it initially misled me into thinking that 
> > this queuecommand was somehow wrapped entirely within this protection 
> > you described.
> > 
> > Only after an in-depth review did I figure out that cmd_alloc() and 
> > enqueue_cmd_and_start_io() did all the locking necessary.
> > 
> > Therefore, here are some observations and recommendations:
> > 
> > * the code changes are correct.  Reviewed-by: Jeff Garzik 
> > <jgarzik@redhat.com>
> > 
> > * delete the comment.  lack of "_lck" alone tells you its lockless.
> > 
> > * I question whether the following hpsa.c logic
> > 	lock_irqsave
> > 	cmd_alloc()
> > 	unlock_irqrestore
> > 
> > 	init cmd
> > 
> > 	lock_irqsave
> > 	enqueue
> > 	unlock_irqrestore
> >    isn't more expensive than simply
> > 	lock_irqsave
> > 	cmd_alloc()
> > 	init cmd
> > 	enqueue
> > 	unlock_irqrestore
> > 
> > It seems like the common case would cycle the spinlock and interrupts 
> > twice for an uncontended lock, which the initialization portion of the 
> > cmd, which may indeed occur in parallel, is so cheap you'll spend more 
> > time on the double-lock than anywhere else.
> > 
> 
> Hi Jeff,
> 
> I was wondering about the overhead of double h->lock cycle for parallel
> struct scsi_cmnd -> struct CommandList initialization vs. single h->
> lock cycle..  Thanks for your input here!
> 

I'll defer to Jeff's expertise on this, though some measurements 
might be nice.  Might be hard to measure though, as I suspect if
you were able to make this part of the code infinitely fast, you'd
still have a hard time telling the difference, as commands spend 
such a small proportion of their lifetimes in there... though if
it eliminates or mitigates some sort of bad, weird interlocking
behavior between this code and the interrupt handler or something
like that, (not that I'm aware of any such bad behavior) I suppose
it might make a noticeable difference.
 
> Attached is a v2 to address your comments.
> 
> --nab
> 
> ------------------------------------------------------------------------
> 
> [PATCH] hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
> 
> This patch first converts HPSA to run in struct Scsi_Host->host_lock'
> less operation by removing DEF_SCSI_QCMD() and '_lck' suffix from the
> hpsa_scsi_queue_command() I/O dispatcher.
> 
> Secondly in hpsa_scsi_queue_command() the struct ctlr_info *h->lock is
> now held a single lock obtain/release cycle while struct CommandList
> initialization is performed, and enqueued into HW.  This enqueuing
> is done using a new h->lock unlocked __enqueue_cmd_and_start_io(),
> wrapper and conversion of the the original enqueue_cmd_and_start_io()
> to use this new code.
> 
> Reviewed-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/hpsa.c |   34 +++++++++++++++++++---------------
>  1 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 12deffc..fff7cd4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -329,16 +329,25 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
>                 c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
>  }
> 
> -static void enqueue_cmd_and_start_io(struct ctlr_info *h,
> +/*
> + * Must be called with struct ctlr_info *h->lock held w/ interrupts disabled
> + */
> +static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
>         struct CommandList *c)
>  {
> -       unsigned long flags;
> -
>         set_performant_mode(h, c);
> -       spin_lock_irqsave(&h->lock, flags);
>         addQ(&h->reqQ, c);
>         h->Qdepth++;
>         start_io(h);
> +}
> +
> +static void enqueue_cmd_and_start_io(struct ctlr_info *h,
> +       struct CommandList *c)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&h->lock, flags);
> +       __enqueue_cmd_and_start_io(h, c);
>         spin_unlock_irqrestore(&h->lock, flags);
>  }

Should that be "static inline"?  Or maybe the compiler's smart enough
to decide whether to inline that on its own these days?

> 
> @@ -1906,9 +1915,7 @@ sglist_finished:
>         return 0;
>  }
> 
> -
> -static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> -       void (*done)(struct scsi_cmnd *))
> +static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
>  {
>         struct ctlr_info *h;
>         struct hpsa_scsi_dev_t *dev;
> @@ -1921,7 +1928,7 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>         dev = cmd->device->hostdata;
>         if (!dev) {
>                 cmd->result = DID_NO_CONNECT << 16;
> -               done(cmd);
> +               cmd->scsi_done(cmd);
>                 return 0;
>         }
>         memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
> @@ -1929,16 +1936,13 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>         /* Need a lock as this is being allocated from the pool */
>         spin_lock_irqsave(&h->lock, flags);
>         c = cmd_alloc(h);
> -       spin_unlock_irqrestore(&h->lock, flags);
>         if (c == NULL) {                        /* trouble... */
>                 dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
> +               spin_unlock_irqrestore(&h->lock, flags);
>                 return SCSI_MLQUEUE_HOST_BUSY;
>         }
> 
>         /* Fill in the command list header */
> -
> -       cmd->scsi_done = done;    /* save this for use by completion code */
> -
>         /* save c in case we have to abort it  */
>         cmd->host_scribble = (unsigned char *) c;
> 
> @@ -1994,15 +1998,15 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> 
>         if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
>                 cmd_free(h, c);
> +               spin_unlock_irqrestore(&h->lock, flags);
>                 return SCSI_MLQUEUE_HOST_BUSY;
>         }
> -       enqueue_cmd_and_start_io(h, c);
> +       __enqueue_cmd_and_start_io(h, c);
> +       spin_unlock_irqrestore(&h->lock, flags);
>         /* the cmd'll come back via intr handler in complete_scsi_command()  */
>         return 0;
>  }
> 
> -static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
> -
>  static void hpsa_scan_start(struct Scsi_Host *sh)
>  {
>         struct ctlr_info *h = shost_to_hba(sh);
> -- 
> 1.7.3.5
> 
> 
> 
> 
