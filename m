From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Wed, 26 Mar 2003 11:11:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030326111146.A3548@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <3E80BDC3.7000503@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E80BDC3.7000503@splentec.com>; from luben@splentec.com on Tue, Mar 25, 2003 at 03:36:19PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2003 at 03:36:19PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > Consolidate scsi single_lun code.
> > 

> >  /*
> > + * Called for single_lun devices. The target associated with current_sdev can
> > + * only handle one active command at a time. Scan through all of the luns
> > + * on the same target as current_sdev, return 1 if any are active.
> > + */
> 
> Here is parth of your comment:
> 	A single_lun (single_lu:1) marked target can handle a single
> 	active LU at a time.

OK I'll change "one active command" to "one active LU". Plus it does not
actually check current_sdev->device_busy, I'll clarify that comment.

> > +static int scsi_single_lun_check(struct scsi_device *current_sdev)
> 
> Here is the name:
> 
> static int scsi_single_lun_active(struct scsi_device *dev);
> 
> The reason is that this makes sense:
> 
> 	if (scsi_single_lun_active(dev)) {
> 		/* then there is an active lu */
> 	} else {
> 		/* No, there's no active devices or
> 		the target is NOT a single lun. */
> 	}
> 
> or the negation:
> 
> 	if (!scsi_single_lun_active(dev)) {
> 		/* no active lun devices or target is not a single
> 		LU, -- either way we can continue here: */
> 		...

OK - change the name to scsi_single_lun_active.

I was trying to keep the main path code fast, so we do not call out to any
functions if not the single_lun case. We can change
scsi_queue_next_request to be consistent with this approach: have one
function to handle leftover IO, one for single_lun cases, and one for
starved. And only call these functions when necessary.

> > + */
> > +static void scsi_single_lun_run(struct scsi_device *current_sdev,
> > +				 struct request_queue *q)
> 
> Now here I've got a problem.  This just pulls out the old logic
> into a separate fn.

That is the main intention of this particular patch - move the code out
of the way. Then the later patches add a per scsi_device queue_lock, and
then fix the single_lun code to work with the new locking.

> I'd rather you did this: in the request fn put the single_lun device
> into the starved devices list, just as you'd do for other devices.

> If you want you to discern between devices, you can add single_lun
> devices to the front and fully capable devices into the tail of the
> starved devices list -- this would make the starved devices list
> into a priority queue.

But the last single_lun LU that ran should have priority over any other
LU's on that same target (well it should really get some slice of IO time,
rather than allowing IO til it is no longer busy), and separately, the
first starved device should have priority over all other starved devices,
I can't do that (simply) with one list. 

single_lun devices are likely slow (CDROM), and we really don't want to
give them priority over other starved devices.

> static inline void scsi_run_starved_devs(struct Scsi_Host *shost)
> {
> 	unsigned long flags;
> 	LIST_HEAD(starved);
> 	
> 	spin_lock_irqsave(&shost->starved_devs_lock, flags);
> 	list_splice_init(&shost->starved_devs, &starved);
> 	spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
> 	
> 	while (!list_empty(&starved)) {
> 		struct scsi_device *dev;
> 
> 		if (shost->host_blocked || shost->host_self_blocked ||
> 		    (shost->can_queue > 0 &&
> 		     shost->host_busy >= shost->can_queue))
> 			break;
> 	
> 		dev=list_entry(starved.next,struct scsi_device,starved_entry);
> 		list_del_init(dev->starved_entry);
> 		spin_lock_irqsave(dev->request_queue->queue_lock, flags);
> 		__blk_run_queue(dev->request_queue);
> 		spin_unlock_irqrestore(dev->request_queue->queue_lock, flags);
> 	}
> 	
> 	if (!list_empty(&starved)) {
> 		spin_lock_irqsave(&shost->starved_devs_lock, flags);
> 		list_splice_init(&starved, &shost->starved_devs);
> 		spin_unlock_irqrestore(&shost->starved_devs_lock, flags);
> 	}
> }

I did not take the list_splice an approach mainly because I wanted to
allow multiple CPU's to run the starved queues (host_blocked cases, not
can_queue). I don't have any data to back this up, and it probably does
not matter. 

For the can_queue limit being hit, with continuous IO across multiple LU's
on a host, there we will (likely) send only one more IO (run one starved
queue) and stop - the last few lines of the above code would always be
executed.

Also the same lock has to be used to protect the scsi_host->starved_list
and scsi_device->starved_entry. In the above code the first
list_splice_init above touches the shost->starved_devs->next->prev,
corresponding to a scsi_device->starved_entry->prev, while holding
starved_devs_lock but the following list_del_init is done holding the
queue_lock.

> Now since __blk_run_queue(q) call the scsi_request_fn() it MAY
> add the device back to the starved list, but that's no problem
> as it is already emtpy.  If the host blocks in due time, then
> the left over devices are added to the front and we get
> prioritization by time (submittal).

Yes, that happens whether we splice out a list or not.

> And this is how scsi_queue_next_request() might look like:
> (i.e. a more general form)
> 

> 	scsi_run_starved_devs(shost);
> 
> 	spin_lock_irqsave(q->queue_lock, flags);
> 	if (cmd != NULL) {
> 
> 		/*
> 		 * For some reason, we are not done with this request.
> 		 * This happens for I/O errors in the middle of the request,
> 		 * in which case we need to request the blocks that come after
> 		 * the bad sector.
> 		 */
> 		cmd->request->special = cmd;
> 		if (blk_rq_tagged(cmd->request))
> 			blk_queue_end_tag(q, cmd->request);
> 
> 		/*
> 		 * set REQ_SPECIAL - we have a command
> 		 * clear REQ_DONTPREP - we assume the sg table has been
> 		 *	nuked so we need to set it up again.
> 		 */
> 		cmd->request->flags |= REQ_SPECIAL;
> 		cmd->request->flags &= ~REQ_DONTPREP;
> 		__elv_add_request(q, cmd->request, 0, 0);
> 	}
> 
> 	__blk_run_queue(q);
> 
> 	spin_unlock_irqrestore(q->queue_lock, flags);

I did not move starved or single_lun handling before the incomplete IO
retry, as the retry should have higher priority.

-- Patrick Mansfield
