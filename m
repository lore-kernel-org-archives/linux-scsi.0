From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 17:25:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204172505.A28812@beaverton.ibm.com>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de> <20030204091955.A24785@beaverton.ibm.com> <1044383605.2014.23.camel@mulgrave> <20030204202935.A325@lst.de> <1044399797.3484.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044399797.3484.15.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Feb 04, 2003 at 05:03:15PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Feb 04, 2003 at 05:03:15PM -0600, James Bottomley wrote:
> On Tue, 2003-02-04 at 13:29, Christoph Hellwig wrote:
> > --- 1.64/drivers/scsi/scsi_lib.c	Tue Jan 28 23:09:29 2003
> > +++ edited/drivers/scsi/scsi_lib.c	Tue Feb  4 20:19:00 2003
> > @@ -35,7 +35,6 @@
> >  }; 	
> >  #undef SP
> >  
> > -struct scsi_core_data *scsi_core;
> >  
> >  /*
> >   * Function:    scsi_insert_special_cmd()
> > @@ -814,9 +813,10 @@
> >  		SCpnt = (Scsi_Cmnd *) req->special;
> >  		SRpnt = (Scsi_Request *) req->special;
> >  		
> > -		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
> > -			SCpnt = scsi_getset_command(SRpnt->sr_device,
> > -						    GFP_ATOMIC);
> > +		if (SRpnt->sr_magic == SCSI_REQ_MAGIC) {
> > +			if (SDpnt->device_busy >= SDpnt->queue_depth)
> > +				return BLKPREP_DEFER;
> > +			SCpnt = scsi_get_command(SRpnt->sr_device, GFP_ATOMIC);
> 
> Actually, I don't necessarily think we want to do this.
> 
> I think we should throttle in the request_fn not in the prep_fn.  The
> reason is the way the block queue works:  If we have a prepped request
> ready to roll, it will go straight through the request fn (without
> sending it back through prep again).  Thus, we can have a fully prepared
> command ready for immediate issue as soon as the device returns one of
> its slots and therefore we keep the pipeline packed as tightly as
> possible given the maximum number of outstanding commands constraint. 
> It also means that we have all the memory allocations completed by the
> time we try to issue the command, rather than trying the memory
> allocations as part of the prep function for the next issue.
> 
> James

But if we have a lot of prepped commands around we will be allocating
memory that is not (currently) needed, we could end up using an equal
number of scsi_cmnd's as we have blk requests. I would rather we not
allocate or hold onto scsi_cmnd in such cases. (And generally in all
cases, but that goes beyond.)

I doubt (especially with new scsi_get_command) that the scsi_prep_fn takes
much time compared to the IO completion path and the scsi_request_fn code,

We are arguing time versus space tradeoffs, and we don't know how much
space we are using, or how much time scsi_prep_fn takes (with
scsi_get_command). Current performance was good even with the crappy
scsi_allocate_device() allocation, scsi_get_command should be faster, so I
would rather save space.

In any case so, the device_busy check should be in scsi_request_fn whether
we have a command or not, so pre-prepped commands (i.e. that don't call
scsi_prep_fn) will not be sent if we have reached to sdev->queue_depth.

We are still missing single_lun checking.

I would like to see the patch in a tree before 2.5.60 (probably already
too late), and then we can take care of these other issues. I think some
systems/disks will barf if they are flooded with QUEUE FULLs.

-- Patrick Mansfield
