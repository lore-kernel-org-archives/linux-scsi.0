From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] block: fix barrier error transmission
Date: Thu, 3 Apr 2008 10:06:27 +0200
Message-ID: <20080403080626.GO12774@kernel.dk>
References: <1207159348.3082.45.camel@localhost.localdomain> <20080402190827.GJ12774@kernel.dk> <1207177912.3082.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23847 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbYDCIGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Apr 2008 04:06:32 -0400
Content-Disposition: inline
In-Reply-To: <1207177912.3082.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mtosatti@redhat.com

On Wed, Apr 02 2008, James Bottomley wrote:
> On Wed, 2008-04-02 at 21:08 +0200, Jens Axboe wrote:
> > > diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> > > index 55c5f1f..3a3947c 100644
> > > --- a/block/blk-barrier.c
> > > +++ b/block/blk-barrier.c
> > > @@ -114,18 +114,24 @@ void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
> > >  
> > >  static void pre_flush_end_io(struct request *rq, int error)
> > >  {
> > > +	error = rq->errors ? -EIO : error;
> > > +
> > >  	elv_completed_request(rq->q, rq);
> > >  	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_PREFLUSH, error);
> > >  }
> > 
> > It's a bit of a hack, SCSI really should pass the error value back
> > instead of fiddling around with possibly perhaps finding it in ->errors.
> > And please don't use these ?: constructs, in this case it doesn't even
> > make a lot of sense and a
> > 
> >         if (rq->errors)
> >                 error = -EIO;
> > 
> > would have been much cleaner ;-)
> > 
> > So my question is why does the model not allow you to return the error
> > properly?
> 
> I thought it was the sg_io that would be the problem, but apparently on
> further research, it simply discards the error as does scsi_execute_req.
> 
> I suppose that's a strong enough reason to try returning an error ...
> I'm just a bit leery this close to a release.
> 
> I think this will work ... it just really needs quite a bit of
> testing ...

This looks much better, but I'm with you on the danger of applying
something like this so close to a release...

Now, this isn't a regression, but it also impacts barrier reliability
and as such it's a big nasty to leave this open for another release.


> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1b199e1..67f412b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -839,7 +839,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	int this_count = scsi_bufflen(cmd);
>  	struct request_queue *q = cmd->device->request_queue;
>  	struct request *req = cmd->request;
> -	int clear_errors = 1;
> +	int error = 0;
>  	struct scsi_sense_hdr sshdr;
>  	int sense_valid = 0;
>  	int sense_deferred = 0;
> @@ -853,7 +853,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
>  		req->errors = result;
>  		if (result) {
> -			clear_errors = 0;
>  			if (sense_valid && req->sense) {
>  				/*
>  				 * SG_IO wants current and deferred errors
> @@ -865,6 +864,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  				memcpy(req->sense, cmd->sense_buffer,  len);
>  				req->sense_len = len;
>  			}
> +			if (!sense_deferred)
> +				error = -EIO;
>  		}
>  		if (scsi_bidi_cmnd(cmd)) {
>  			/* will also release_buffers */
> @@ -885,14 +886,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  				      "%d bytes done.\n",
>  				      req->nr_sectors, good_bytes));
>  
> -	if (clear_errors)
> -		req->errors = 0;
> -
>  	/* A number of bytes were successfully read.  If there
>  	 * are leftovers and there is some kind of error
>  	 * (result != 0), retry the rest.
>  	 */
> -	if (scsi_end_request(cmd, 0, good_bytes, result == 0) == NULL)
> +	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
>  
>  	/* good_bytes = 0, or (inclusive) there were leftovers and
> 
> 

-- 
Jens Axboe

