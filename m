From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Thu, 17 Jan 2013 10:11:31 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301171005560.1339-100000@iolanthe.rowland.org>
References: <20130117051325.GA31469@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130117051325.GA31469@aaronlu.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 Jan 2013, Aaron Lu wrote:

> > > @@ -515,6 +516,27 @@ void elv_bio_merged(struct request_queue *q, struct request *rq,
> > >  		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
> > >  }
> > >  
> > > +#ifdef CONFIG_PM_RUNTIME
> > > +static void blk_pm_requeue_request(struct request *rq)
> > > +{
> > > +	if (!(rq->cmd_flags & REQ_PM))
> > > +		rq->q->nr_pending--;
> > > +}
> > 
> > You don't check q->dev here.  That's okay, but it means that
> > q->nr_pending will be meaningless or wrong if any I/O takes place
> > before blk_pm_runtime_init is called.
> 
> Right, so I had better check q->dev here too.
> 
> > 
> > Therefore the kerneldoc for blk_pm_runtime_init should mention that it
> > must not be called after any requests have been submitted.  Also
> 
> So with the q->dev check added above, I believe this is not needed.

No, it is still needed.  With the q->dev check added, q->nr_pending 
will always be 0 before blk_pm_runtime_init is called.  But if I/O is 
taking place then the number of pending requests really isn't 0.

Either you have to make sure the q->nr_pending is always correct, even 
when runtime PM isn't being used, or else the caller has to make sure 
that no I/O takes place before blk_pm_runtime_init is called.

> ------------
> > mention that blk_pm_runtime_init enables runtime PM for q->dev, so the
> > caller shouldn't do it.
> 
> I may misunderstandd this in last email.
> 
> We didn't enable runtime PM for the device in blk_pm_runtime_init, just
> some auto suspend related settings.

Sorry, yes, you are right.  In fact, the caller has to make sure that 
runtime PM is enabled before calling blk_pm_runtime_init; otherwise the 
autosuspend timer might not work right.

Alan Stern
