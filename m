From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
        requeues
Date: Fri, 20 Oct 2017 18:26:30 +0200
Message-ID: <20171020162630.GA14277@lst.de>
References: <20171003104845.10417-1-hch@lst.de> <20171003104845.10417-10-hch@lst.de> <20171019155933.GE26185@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171019155933.GE26185@bblock-ThinkPad-W530>
Sender: linux-block-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 19, 2017 at 05:59:33PM +0200, Benjamin Block wrote:
> > +#define ptr64(val) ((void __user *)(uintptr_t)(val))
> 
> Better to reflect the special property, that it is a user pointer, in
> the name of the macro. Maybe something like user_ptr(64). The same
> comment for the same macro in bsg.c.

Not sure it's worth it especially now that Martin has merged the patch.
But given how many interface we have all over the kernel that use a u64
to store a user pointer in ioctls and similar it might make sense to
lift a helper like this to a generic header.  In that case we'll need
a more descriptive name for sure.

> > +static int bsg_transport_check_proto(struct sg_io_v4 *hdr)
> > +{
> > +	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
> > +	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_TRANSPORT)
> > +		return -EINVAL;
> > +	if (!capable(CAP_SYS_RAWIO))
> > +		return -EPERM;
> 
> Any particular reason why this is not symmetric with bsg_scsi? IOW
> permission checking done in bsg_transport_fill_hdr(), like it is done in
> bsg_scsi_fill_hdr()?
> 
> We might save some time copying memory with this (we also only talk
> about ~20 bytes here), but on the other hand the interface would be more
> clean otherwise IMO (if we already do restructure the interface) -
> similar callbacks have similar responsibilities.

I could move the capable check around, no sure why I had done it that
way, it's been a while.  Probably because blk_verify_command needs the
CDB while a simple capable() check does not.

> If I understand this right, the this reflects the old code, if only
> written down a little different.
> 
> But I wonder why we do that? Wouldn't that be interesting to know for
> uspace, if more was received than it allocated space for? Isn't that the
> typical residual over run case (similar to LUN scanning in SCSI common
> code), and din_resid is signed after all? Well I guess it could be an
> ABI break, I don't know.
> 
> Ah well, at least the documentation for 'struct sg_io_v4' makes no such
> restrictions (that it can not be below 0).
> 
> Just a thought I had while reading it.

Maybe it would, but I really didn't want to change behavior.  If we
were to redo transport passthrough I would do it totally different today.

> > +	job->reply = kzalloc(SCSI_SENSE_BUFFERSIZE, gfp);
> 
> One suggestion here. Maybe we could get rid of this implicit knowledge
> about SCSI_SENSE_BUFFERSIZE being the max size for a bsg-reply?
> Especially if we use this patch and get rid of other similarities (like
> using scsi_request).
> 
> Maybe we can just define a extra macro in bsg-lib.c, or in one of the
> headers, and define its size to be SCSI_SENSE_BUFFERSIZE (for now) and
> then use that in all cases.
> 
> I tried something similar some time ego if you remember, but I couldn't
> follow up because other stuff got more important in the meantime. One
> could also static check the transport reply-types against that.
> 
> This way, should need to change that value for a sepcific transport, we
> only need to change one knob, and not 10 (I guess SCSI_SENSE_BUFFERSIZE
> could not be changed for such cases ;) ).

There shouldn't be any dependencies on SCSI_SENSE_BUFFERSIZE left,
so yes, this could be cleaned up.  Great opportunity for a follow on
patch.

> > -	/* if the LLD has been removed then the bsg_unregister_queue will
> > -	 * eventually be called and the class_dev was freed, so we can no
> > -	 * longer use this request_queue. Return no such address.
> > -	 */
> 
> Why remove the comment? Has that changed?

Nothing, but then again it's standard behavior so the comment doesn't
really add any value.

> > +	rq->timeout = msecs_to_jiffies(hdr->timeout);
> > +	if (!rq->timeout)
> > +		rq->timeout = rq->q->sg_timeout;
> 
> No need to use the rq pointer, you already have a variable q with the
> same content.

True.

> > -		ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
> > -				      GFP_KERNEL);
> > -		if (ret)
> > -			goto out;
> > +		ret = blk_rq_map_user(q, rq, NULL, ptr64(hdr->din_xferp),
> > +				hdr->din_xfer_len, GFP_KERNEL);
> > +	} else {
> > +		ret = blk_rq_map_user(q, rq, NULL, NULL, 0, GFP_KERNEL);
> 
> Why do we behave differently in this case now? To prevent special
> handling elsewhere? Otherwise it seems a bit pointless/error-prone
> mapping zero length to nothing.

Yes, this could be removed again.  I'll send a follow up.
