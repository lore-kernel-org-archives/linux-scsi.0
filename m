From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 7/7 fix single_lun code for per-scsi_device queue_lock
Date: Wed, 26 Mar 2003 13:47:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030326134717.B5307@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com> <20030324180404.F15047@beaverton.ibm.com> <3E80C8DD.4060803@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E80C8DD.4060803@splentec.com>; from luben@splentec.com on Tue, Mar 25, 2003 at 04:23:41PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2003 at 04:23:41PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > Fix single_lun code for per-scsi_device queue_lock
> > 
> > diff -purN -X /home/patman/dontdiff lksplit-25/drivers/scsi/scsi.h sl_lksplit-25/drivers/scsi/scsi.h
> > --- lksplit-25/drivers/scsi/scsi.h	Mon Mar 24 12:15:10 2003
> > +++ sl_lksplit-25/drivers/scsi/scsi.h	Mon Mar 24 12:15:26 2003
> > @@ -531,6 +531,15 @@ extern struct list_head scsi_dev_info_li
> >  extern int scsi_dev_info_list_add_str(char *);
> >  
> >  /*
> > + * scsi_target: representation of a scsi target, for now, this is only
> > + * used for single_lun devices.
> > + */
> > +struct scsi_target {
> > +	unsigned int starget_busy;
> > +	unsigned int starget_refcnt;
> > +};
> 
> Yes ok, but let's do it right.
> First, I abhore all this letter playing to devise
> names like: starget_busy and starget_refcnt.

> starget_busy could be an atomic_t which is equal
> to the sum of all LU's pending_q_counts, i.e.
> it better, else we're losing commands, and also
> with a different name (more descriptive).
> Something like active_cmds, or active_cmd_count,
> but NOT ``..._cnt''!
> 
> Also, moving all the necessary variables into scsi_target, like
> say single_lun to be renamed single_lu.
> 
> Also having a list of devices:
> 
> 	struct list_head lu_list;
> 
> etc, etc.

> > +	struct scsi_target      *sdev_target;   /* used only for single_lun */
> 
> 
> Should probably be used for all devices.  Let's do it right.

I would like to have a scsi_target that always shows up, I don't have time
now to code it. So for now the klugey single_lun code.

> > +	spin_lock_irqsave(current_sdev->request_queue->queue_lock, flags2);
> > +	spin_lock_irqsave(current_sdev->host->host_lock, flags);
> 
> No, you do NOT need flags and flags2.  Look at other kernel code
> to see how this is done.  scsi_put_command() gives
> an example of doing double locks and irq state -- it's a nice one.

OK

> you MUST absolutely mention this somewhere with boldface red
> letters comment that the queue lock is always obtained FIRST
> and the host lock SECOND (and, trivially, released in opposite
> order).

OK will add comments, though undecided on whether to have both a
target lock and host_lock, or just go with host_lock (per comments sent
reply to James).

> > +	__blk_run_queue(current_sdev->request_queue);
> > +	spin_unlock_irqrestore(current_sdev->request_queue->queue_lock, flags2);
> 
> Now if you make device_busy an atomic_t type, then you DO not
> need these double locking acrobatics.

We should defer such changes until we clean up IO completion, per other
email comments.

> > +	if (sdev->single_lun) {
> > +		spin_lock_irqsave(sdev->host->host_lock, flags);
> > +		sdev->sdev_target->starget_refcnt--;
> > +		if (sdev->sdev_target->starget_refcnt == 0)
> > +			kfree(sdev->sdev_target);
> 
> 
> Have you seen ``atomic_dec_and_test()''?

OK

-- Patrick Mansfield
