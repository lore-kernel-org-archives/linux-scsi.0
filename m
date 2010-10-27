From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: sym53c8xx_2 data corruption
Date: Wed, 27 Oct 2010 18:19:32 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1010271803010.18202@artax.karlin.mff.cuni.cz>
References: <20101027012932.3CB6E4FB4@hiauly1.hia.nrc.ca>  <1288155041.19649.354.camel@mulgrave.site>  <alpine.DEB.1.10.1010271059230.31946@artax.karlin.mff.cuni.cz> <1288190807.4692.30.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1288190807.4692.30.camel@mulgrave.site>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org



On Wed, 27 Oct 2010, James Bottomley wrote:

> On Wed, 2010-10-27 at 11:04 +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > I sent this about twice to linux-scsi and got no reseponse, neither from 
> > conference nor from Matthew. So I'm sending it here, James, you are the 
> > maintainer of SCSI, could you please look at the patch and incorporate it 
> > to the kernel in this cycle?
> > 
> > The problem is that if the disk returns QUEUE FULL, the requests are 
> > aborted with DID_SOFT_ERROR (rather than DID_REQUEUE), which results in 
> > too few retries and premature errors. The errors happen mostly on writes, 
> > resulting in data corruption.
> > 
> > Mikulas
> > 
> > ---
> > 
> > sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue.
> > 
> > When the controller encounters an error (including QUEUE FULL or BUSY status),
> > it aborts all not yet submitted requests in the function
> > sym_dequeue_from_squeue.
> > 
> > This function aborts them with DID_SOFT_ERROR.
> > 
> > If the disk has a full tag queue, the request that caused the overflow is
> > aborted with QUEUE FULL status (and the scsi midlayer properly retries it
> > until it is accepted by the disk), but other requests are aborted with
> > DID_SOFT_ERROR --- for them, the midlayer does just a few retries and then
> > signals the error up to sd.
> > 
> > The result is that disk returning QUEUE FULL causes request failures.
> > 
> > The error was reproduced on 53c895 with COMPAQ BD03685A24 disk (rebranded
> > ST336607LC) with command queue 48 or 64 tags. The disk has 64 tags, but
> > under some access patterns it return QUEUE FULL when there are less than
> > 64 pending tags. The SCSI specification allows returning QUEUE FULL
> > anytime and it is up to the host to retry.
> 
> So the description isn't really complete.  the function is
> dequeue_from_squeue which is used to requeue all unissued scbs when the
> sequencer is restarted.  This doesn't just affect QUEUE_FULL, it affects
> everything.  As long as the pushback is done before the status is
> returned (which it looks like it is), I think the patch after fixing
> looks fine.
>
> The problem isn't the actual command which returns queue full ... it's
> that the sequencer accepts and queues a pile of commands and then
> returns all of them on the first queue full ... that means that deeply
> queued commands in the sequencer issue queue can get returned >5 times
> on multiple QUEUE_FULL conditions which would cause a failure.

Sure, that's how I understood it from the code and debug prints. You can 
add this to the description.

That QUEUE_FULL command is actually retired fine, the following commands 
are problematic.

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c
> > ===================================================================
> > --- linux-2.6.36-rc5-fast.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:25:59.000000000 +0200
> > +++ linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:26:27.000000000 +0200
> > @@ -3000,7 +3000,11 @@ sym_dequeue_from_squeue(struct sym_hcb *
> >  		if ((target == -1 || cp->target == target) &&
> >  		    (lun    == -1 || cp->lun    == lun)    &&
> >  		    (task   == -1 || cp->tag    == task)) {
> > +#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
> >  			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
> > +#else
> > +			sym_set_cam_status(cp->cmd, DID_REQUEUE);
> > +#endif
> 
> So the ifdef is definitely wrong.  SYM_OPT_HANDLE_DEVICE_QUEUEING is a
> leftover from when the driver did explicit internal queueing. Just make
> this do DID_REQUEUE and I *think* everything will be OK.

When I tried to enable SYM_OPT_HANDLE_DEVICE_QUEUEING, it didn't work, it 
crashed on something --- it is leftover from some other operating system 
that didn't handle requeuing in the midlayer.

When looking at the other parts of code that handles this driver-internal 
requeueing, it expects DID_SOFT_ERROR there. But it doesn't matter, that 
code is useless for Linux and broken anyway.

> There's a danger in that DID_REQUEUE will requeue forever, so this
> working depends on the original failing command being returned with the
> correct code (which I think it is, but more eyes looking at this would
> be helpful).

Requeuing forever is dangerous anyway, a device returning QUEUE_FULL 
constantly could deadlock the system. Question: is it better to risk a 
deadlock with a broken device or to risk a false timeout under high load? 
--- I don't know --- maybe there are valid cases where the device is 
returning QUEUE_FULL for long time (some raid reconfiguration?) ... do you 
know about them?

Anyway, if sym_dequeue_from_squeue was called from some other error that 
causes limited retry or command abort, I think it is still valid to use 
DID_REQUEUE for the following commands --- it can't deadlock with 
DID_REQUEUE, because on that error, the first command is aborted or has 
its retry count decremented --- so the first command must be eventually 
completed, and the second command (which was being retried with 
DID_REQUEUE) becomes the first --- and once it's first, it cannot loop 
forever. So with induction you can prove that every command completes in 
finite time.

Mikulas

> James
> 
> 
